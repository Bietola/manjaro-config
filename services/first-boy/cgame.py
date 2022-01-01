import time
import threading
from telegram.ext import CommandHandler, ConversationHandler, MessageHandler
from telegram.ext.filters import Filters
from codetiming import Timer

import proc_utils as putl
from utils import eprint

class CGame:
    def __init__(self, name):
        self.name = name
        self.proc = None
        self.stdin_mutex = threading.Lock()
        self.stdin_next_msg = None
        self.stdin_buffer = []


g_cur_game = None
PLAY_GAME = range(1)


def start_cgame(upd, ctx):
    def send_msg(msg):
        if msg is None or len(msg) == 0:
            eprint('ERR: NILMSG: Null/empty msg sent from `cgame.start_cgame`')
            return

        ctx.bot.send_message(
            chat_id=upd.effective_chat.id,
            text=msg
        )

    # TODO/CC: Make a special function that uses a dedicated thread to empty the buffer as a telegram message. The hook `send_msg` to this function and use it to just fill the buffer
    # def send_msg_buffered(msg, wait_secs=3, max_buf_len=20):
    #     if msg is None or len(msg) == 0:
    #         eprint('ERR: NILMSG: Null/empty msg sent from `cgame.start_cgame`')
    #         return

    #     buffer = send_msg_buffered.buffer
    #     timer = send_msg_buffered.timer

    #     now = time.perf_counter()
    #     elapsed = now - timer
    #     print('DB: ', elapsed)
    #     if len(buffer) >= max_buf_len or elapsed >= wait_secs:
    #         print('DB: ', 'in')
    #         send_msg('\n'.join(buffer))
    #         timer = time.perf_counter()
    #         send_msg_buffered.buffer = []

    #     else:
    #         buffer.append(msg)

    # send_msg_buffered.buffer = []
    # send_msg_buffered.timer = time.perf_counter()

    if len(ctx.args) == 0:
        send_msg("Available games:\nRPS\nLupus in Tabula [WIP]\n")
        return ConversationHandler.END

    # Start cgame
    cgame = ctx.args[0]

    global g_cur_game
    g_cur_game = CGame(cgame)

    # TODO: Check if game is valid

    g_cur_game.proc = putl.start(
        f'( cd ./cgames/{g_cur_game.name}/; stdbuf -o0 ./a.out; )'
    )

    # TODO/CC: Confused stdin with stdout
    def periodically_dump_buffer_to_stdin(
        min_buffer_len=1,
        wait_secs=3
    ):
        while True:
            time.sleep(wait_secs)

            global g_cur_game
            g_cur_game.stdin_mutex.acquire()
            buffer = g_cur_game.stdin_buffer

            if len(buffer) >= min_buffer_len:
                g_cur_game.stdin_buffer = []
                g_cur_game.stdin_mutex.release()
                return '\n'.join(buffer)
            else:
                g_cur_game.stdin_mutex.release()

    def pipe_usr_msg_to_stdin_buffer():
        # TODO/WIP
        next_msg = None
        while True:
            time.sleep(1)

            global g_cur_game
            g_cur_game.stdin_mutex.acquire()
            next_msg = g_cur_game.stdin_next_msg

            if next_msg is not None:
                g_cur_game.stdin_next_msg = None
                g_cur_game.stdin_mutex.release()
                g_cur_game.stdin_buffer.append(next_msg)
            else:
                g_cur_game.stdin_mutex.release()

    threading.Thread(
        target=pipe_usr_msg_to_stdin_buffer
    ).start()

    # TODO: Use messages instead of stdin
    threading.Thread(
        target=lambda: putl.interact(
            g_cur_game.proc,
            stdout=send_msg,
            stdin=lambda: periodically_dump_buffer_to_stdin(
                wait_secs=3,
            ),
            interrupt_sig='INTERRUPT',
            log_interrupt=send_msg
        )
    ).start()

    return PLAY_GAME


def send_to_cur_game_stdin(upd, ctx):
    global g_cur_game
    g_cur_game.stdin_mutex.acquire()
    # NB. Using `.lower()` for ergonomic purposes
    g_cur_game.stdin_next_msg = upd.message.text.lower()
    g_cur_game.stdin_mutex.release()


def interrupt_cgame():
    # Send `'INTERRUPT'` string to thread hosting cgame
    pass


handler = ConversationHandler(
    entry_points=[CommandHandler('cgame', start_cgame)],
    states={
        PLAY_GAME: [MessageHandler(Filters.text, send_to_cur_game_stdin)]
        # HANDLE_WIN: [MessageHandler(Filters.photo, photo)]
        # LOCATION: [
        #     MessageHandler(Filters.location, location),
        #     CommandHandler('skip', skip_location),
        # ],
        # BIO: [MessageHandler(Filters.text & ~Filters.command, bio)],
    },
    fallbacks=[CommandHandler('cancel', interrupt_cgame)],
    per_user=False
)


# Test
# threading.Thread(
#     target=lambda: play_cgame('rps')
# ).start()

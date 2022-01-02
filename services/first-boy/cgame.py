import time
import threading
from telegram.ext import CommandHandler, ConversationHandler, MessageHandler
from telegram.ext.filters import Filters
from codetiming import Timer

import proc_utils as putl
from utils import eprint

class CGame:
    def __init__(self, name, letter_limit=None):
        self.name = name
        self.proc = None
        self.letter_limit = letter_limit
        self.stdin_mutex = threading.Lock()
        self.stdin_next_msg = None
        self.stdout_mutex = threading.Lock()
        self.stdout_buffer = []


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

    if len(ctx.args) == 0:
        send_msg("Available games:\n- rps\n- lit\n")
        return ConversationHandler.END

    # Start cgame
    cgame = ctx.args[0]

    global g_cur_game
    g_cur_game = CGame(
        name=cgame,
        letter_limit=1 if cgame == 'lit' else None
    )

    # TODO: Check if game is valid

    g_cur_game.proc = putl.start(
        f'( cd ./cgames/{g_cur_game.name}/; stdbuf -o0 ./a.out; )'
    )

    # TODO/CC: Confused stdin with stdout
    def periodically_dump_buffer_to_stdout(
        min_buffer_len=1,
        wait_secs=1
    ):
        while True:
            time.sleep(wait_secs)

            global g_cur_game
            g_cur_game.stdout_mutex.acquire()
            buffer = g_cur_game.stdout_buffer

            if len(buffer) >= min_buffer_len:
                g_cur_game.stdout_buffer = []
                g_cur_game.stdout_mutex.release()
                send_msg('\n'.join(buffer))
            else:
                g_cur_game.stdout_mutex.release()

    def pipe_cgame_next_msg_to_stdin():
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
                return next_msg
            else:
                g_cur_game.stdin_mutex.release()

    def pipe_stdout_to_cur_buffer(txt):
        global g_cur_game
        g_cur_game.stdout_mutex.acquire()
        g_cur_game.stdout_buffer.append(txt)
        g_cur_game.stdout_mutex.release()

    threading.Thread(
        target=lambda: periodically_dump_buffer_to_stdout(
            wait_secs=1,
            min_buffer_len=1
        )
    ).start()

    # TODO: Use messages instead of stdin
    threading.Thread(
        target=lambda: putl.interact(
            g_cur_game.proc,
            stdout=pipe_stdout_to_cur_buffer,
            stdin=pipe_cgame_next_msg_to_stdin,
            interrupt_sig='INTERRUPT',
            log_interrupt=send_msg
        )
    ).start()

    return PLAY_GAME


def send_to_cur_game_stdin(upd, ctx):
    global g_cur_game
    letter_lim = g_cur_game.letter_limit
    g_cur_game.stdin_mutex.acquire()
    # NB. Using `.lower()` for ergonomic purposes
    full_msg = upd.message.text.lower()
    g_cur_game.stdin_next_msg = full_msg[:letter_lim] if letter_lim else full_msg
    g_cur_game.stdin_mutex.release()


def interrupt_cgame():
    # Send `'INTERRUPT'` string to thread hosting cgame
    pass


handler = ConversationHandler(
    entry_points=[CommandHandler('cg', start_cgame)],
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

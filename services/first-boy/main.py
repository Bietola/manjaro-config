import fire
import telegram
from telegram.ext import Updater
from telegram.ext import CommandHandler
from functools import *
from pathlib import Path
import random
import os
import threading
import time
import inspect
import emoji
import json

import utils
from utils import eprint, shell, SRC_PATH
import proc_utils as putl

import timon
import minecraft
import register
import bi
import nation_game
from register import RegChats

####################
# Global Variables #
####################

# None for now

##################################
# Helper Functions ans Constants #
##################################

def cur_time():
    return time.strftime("%H:%M:%S", time.localtime())

########
# Main #
########

def first_bot(max_spam_lv=1):
    # Basic logging functions
    def log(txt, silent=False, notify=True, spam_lv=1):
        print(f'main_thread: {txt}')

        if spam_lv <= max_spam_lv and not silent:
            regchats = RegChats.get()

            for chat_id in RegChats.get():
                updater.bot.send_message(
                    chat_id = chat_id,
                    text = txt,
                    disable_notification = not notify
                )

    ################################
    # Get access to bot with token #
    ################################

    utils.wait_until_connected(delay=20, trace=True)
    updater = Updater(token='1516509922:AAHd36t-69qu1FolhavdCo6_qb_UJnFPix4', use_context=True)
    dispatcher = updater.dispatcher


    #############
    # Bot Intro #
    #############

    # log('FirstBoy is awake')

    ############
    # Handlers #
    ############

    dispatcher.add_handler(
        CommandHandler(
            'test',
            lambda upd, ctx: ctx.bot.send_animation(
                chat_id = upd.effective_chat.id,
                animation = './gifs/fly.gif'
            )
        )
    )

    dispatcher.add_handler(
        CommandHandler(
            'register',
            register.handler
        )
    )

    dispatcher.add_handler(
        CommandHandler(
            'regcommit',
            register.commit
        )
    )

    dispatcher.add_handler(
        CommandHandler(
            'insult',
            lambda upd, ctx: ctx.bot.send_message(
                chat_id = upd.effective_chat.id,
                text = "no u"
            )
        )
    )

    log(f'Timon handler active (time: {cur_time()})', spam_lv=2)
    dispatcher.add_handler(
        CommandHandler(
            'timon',
            lambda upd, ctx: ctx.bot.send_message(
                chat_id = upd.effective_chat.id,
                text = timon.get_tier(' '.join(ctx.args or 'N/A'))
            )
        )
    )

    timon_card_images = list(
        (SRC_PATH / Path('images/cards')).glob('*')
    )
    dispatcher.add_handler(
        CommandHandler(
            'draw',
            lambda upd, ctx: ctx.bot.send_photo(
                chat_id = upd.effective_chat.id,
                photo = open(
                    random.choice(timon_card_images),
                    'rb'
                )
            )
        )
    )

    # log(f'Minecraft handler active (time: {cur_time()})', spam_lv=2)
    # dispatcher.add_handler(
    #     CommandHandler(
    #         'minecraft',
    #         minecraft.minecraft_handler
    #     )
    # )

    log(f'🅱 handler active (time: {cur_time()})', spam_lv=2)
    dispatcher.add_handler(CommandHandler('bi', bi.handler))

    # TODO: Also add query handler
    log(f'Nation game handler active (time: {cur_time()})', spam_lv=2)
    dispatcher.add_handler(nation_game.round_handler)

    # def pipe_test(upd, ctx):
    #     print('writing to pipe: ', ctx.args[0])
    #     shell(f'echo \'{ctx.args[0]}\' > ./cgames/rps/pipes/inp')
    # log(f'TEST handle active (time: {cur_time()})', spam_lv=2)
    # dispatcher.add_handler(
    #     CommandHandler(
    #         'pipe',
    #         pipe_test
    #     )
    # )

    ###################
    # Start Things Up #
    ###################

    # # Start Periodic Checks
    # threading.Thread(
    #     target = minecraft.server_inactivity_checker(updater.bot)
    # ).start()

    # # Get output of RPS
    # def handle_cgames():
    #     # Start rps
    #     os.system(
    #         'cd ./cgames/rps/; stdbuf -i0 -o0 -e0 ./rps <pipes/inp >pipes/out;'
    #     )
    # threading.Thread(
    #     target = handle_cgames
    # ).start()

    # threading.Thread(
    #     target = lambda:
    #         os.system('cat < ./cgames/rps/pipes/out')
    # ).start()

    # Get output of RPS
    # def launch_cgames():
    #     # Start rps
    #     os.system(
    #         'cd ./cgames/rps/; stdbuf -o0 ./rps <pipes/inp;'
    #     )
    # threading.Thread(
    #     target = launch_cgames
    # ).start()

    # def recv_cgames_stdout():
    #     # os.system('cat < ./cgames/rps/pipes/out')
    #     with open('./cgames/rps/pipes/out') as fifo:
    #         for line in fifo.readlines():
    #             print(line)
    # threading.Thread(
    #     target = recv_cgames_stdout
    # ).start()

    # Start bot
    updater.start_polling()

###############
# Entry Point #
###############

if __name__ == '__main__':
    fire.Fire(first_bot)

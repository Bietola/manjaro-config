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

import utils
from utils import eprint, SRC_PATH

import dice
import register
from register import RegChats

##################################
# Helper Functions ans Constants #
##################################

def cur_time():
    return time.strftime("%H:%M:%S", time.localtime())

########
# Main #
########

def bot_process(max_spam_lv=1):
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
    updater = Updater(token='1810983014:AAHeg7VLhnM3y99zMxzPSigB_4gqUKRRAqo', use_context=True)
    dispatcher = updater.dispatcher


    #############
    # Bot Intro #
    #############

    # TODO/UC: log('DiceBoy is awake')

    ############
    # Handlers #
    ############

    dispatcher.add_handler(
        CommandHandler(
            'shrek',
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

    dispatcher.add_handler(
        CommandHandler(
            'hello',
            lambda upd, ctx: ctx.bot.send_message(
                chat_id = upd.effective_chat.id,
                text = "Hello from DiceBoy"
            )
        )
    )

    log(f'Dice handler active (time: {cur_time()})', spam_lv=2)
    dispatcher.add_handler(
        CommandHandler(
            'roll',
            lambda upd, ctx: ctx.bot.send_message(
                chat_id = upd.effective_chat.id,
                text = "\n".join(
                    map(
                        lambda tpl: f'roll {tpl[0] + 1}: {tpl[1]}',
                        enumerate(dice.rr_roll(
                            int(ctx.args[0]),
                            int(ctx.args[1])
                        ))
                    )
                )
            )
        )
    )

    ###################
    # Start Things Up #
    ###################

    # Start bot
    updater.start_polling()

###############
# Entry Point #
###############

if __name__ == '__main__':
    fire.Fire(bot_process)

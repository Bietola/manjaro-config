from pathlib import Path
import json
import random

import emoji_utils as emjutl

#############
# Constants #
#############

HELP_MSG = 'Ciao 🅱i🅱🅱i, istruzioni per l\'uso:\n/bi: spamma emoji randomica bibbificata\n/bi full (oppure f): scopri nome pieno di ultima emoji bibbificata\n/bi nation (oppure n): spamma emoji bandiera con nome nazione bibbificato\n'

###########
# Globals #
###########

g_emojis = []
g_last_emoji = {'emoji': '🅱', 'name': 'B'}

######################################################
# Init function (to be called before bot activation) #
######################################################

def init():
    # Load emojis
    global g_emojis
    g_emojis = json.loads(Path('./assets/emojis.json').open().read())['emojis']
    print('Loaded giant emoji json')

###################
# Other functions #
###################

def handler(upd, ctx):
    def bify_then_send(emoji, name_mod=lambda x: x):
        ctx.bot.send_message(
            chat_id = upd.effective_chat.id,
            text = emoji['emoji']
        )
        ctx.bot.send_message(
            chat_id = upd.effective_chat.id,
            text = '🅱' + name_mod(emoji['name']).split()[0][1:]
        )
        global g_last_emoji
        g_last_emoji = emoji

    if len(ctx.args) == 1:
        if ctx.args[0] in ['help', 'h']:
            ctx.bot.send_message(
                chat_id = upd.effective_chat.id,
                text = HELP_MSG
            )
            return
        elif ctx.args[0] in ['full', 'f']:
            ctx.bot.send_message(
                chat_id = upd.effective_chat.id,
                text = ' '.join(list(map(lambda w: '🅱'  + w[1:], g_last_emoji['name'].split()))) + ' ' + g_last_emoji['emoji']
            )
            return
        elif ctx.args[0] in ['nation', 'n']:
            rand_emoji = random.choice(list(filter(lambda e: 'flag' in e['name'], g_emojis)))
            bify_then_send(rand_emoji, name_mod=lambda n: ' '.join(n.split()[1:]))
            return

    bify_then_send(random.choice(g_emojis))

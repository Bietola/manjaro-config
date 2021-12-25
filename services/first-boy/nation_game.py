# Game states

# TODO: Query game stats and group wins
#
# e.g. /ng group
#
def handle_ranking(upd, ctx):
    if len(ctx.args) >= 1 and ctx.args[0] == query:
        pass

# 1 round of the game (record win)
#
# EXAMPLE:
# /ng start
# > Ok
# > :flag_italy:
# France
# > No, 9 guesses left for Chicco
# Italy
# > Davide wins! 10 wood, 2 bronze victories in all
#
def handle_game_round(upd, ctx):
    def send_txt(txt):
        ctx.bot.send_message(
            chat_id=upd.effective_chat.id,
            text=txt
        )

    send_txt('Let the game commence')
    send_txt()

round_handler = ConversationHandler(
    entry_points=[CommandHandler('ng', handle_game_round)],
    states={
        SHOW_FLAG: 
        RECV_ANS: [MessageHandler(Filters.regex('^(Boy|Girl|Other)$'), gender)],
        HANDLE_WIN: [MessageHandler(Filters.photo, photo), CommandHandler('skip', skip_photo)],
        LOCATION: [
            MessageHandler(Filters.location, location),
            CommandHandler('skip', skip_location),
        ],
        BIO: [MessageHandler(Filters.text & ~Filters.command, bio)],
    },
    fallbacks=[CommandHandler('cancel', cancel)],
)

import proc_utils as putl

g_current_cgame = ''
g_curr_proc = None

# Start and handle interaction with CGame executable
def play_cgame(game):
    global g_current_cgame
    g_current_cgame = game

    # TODO: Check if game is valid

    g_curr_proc = putl.start(
        f'( cd ./cgames/{game}/; stdbuf -o0 ./a.out; )'
    )

    # TODO/CC
    # threading.Thread(
    #     target=putl.interact(
    #         g_curr_proc,
    #         stdout=print,
    #         stdin=lambda: ()
    #         interrupt_sig='INTERRUPT'
    #     )
    # ).start()


def send_to_curr_cgame_stdin():
    # TODO/CC
    pass


handler = ConversationHandler(
    entry_points=[CommandHandler(
        'cgame',
        lambda upd, ctx:
            play_cgame(ctx.args[0]) if len(ctx.args) == 1
            else ConversationHandler.END
    )],
    states={
        PLAY_GAME: [MessageHandler(Filters.text, send_to_curr_cgame_stdin)],
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

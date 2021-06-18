import re
import random
from functools import *
from datetime import datetime

dexpr_re = re.compile(r'\b(\d*)d(\d*)\b')

def load_dice_names():
    if not load_dice_names.DONE:
        print('Loading dice names...')
        load_dice_names.DONE = True
        global DICE_NAMES
        with open('./assets/dice.txt') as f:
            DICE_NAMES = ['The One']
            for i, line in enumerate(f):
                print(f'\t{i + 1}: {line[:-1]}')
                DICE_NAMES.append(line)
load_dice_names.DONE = False
load_dice_names()

class RollResult:
    def __init__(self, dice_id, dice_results):
        self.dice_id = dice_id
        self.dice_results = dice_results

    def __repr__(self):
        res = []

        res.append(f'Rolling {DICE_NAMES[self.dice_id]}')

        res += list(map(
            lambda tpl: f'Roll {tpl[0] + 1}: {tpl[1]}',
            enumerate(self.dice_results)
        ))

        if len(self.dice_results) > 1:
            res.append(f'Total: {sum(self.dice_results)}')

        return '\n'.join(res)

def roll(id, num, val):
    res = []
    for i in range(0, num):
        res.append(random.randint(1, val))

    return RollResult(id, res)

# Reset Rand Roll
def rr_roll(id, num, val):
    random.seed(datetime.now())
    return roll(id, num, val)

def roll_dice_exp(dexp):
    if m := re.compile(r'(?:(\d+)\.)?(\d+)(?:d(\d+))?').match(dexp):

        if not (die_id := m.group(1)):
            die_id = roll_dice_exp.CURR_DIE_ID
        else:
            roll_dice_exp.CURR_DIE_ID = die_id

        if num_after_d := m.group(3):
            dice_amm = m.group(2)
            die_sides = num_after_d
        else:
            dice_amm = 1
            die_sides = m.group(2)

        return rr_roll(int(die_id), int(dice_amm), int(die_sides))

    else:
        assert False, "Can't roll invalid dice expression"

roll_dice_exp.CURR_DIE_ID = 0

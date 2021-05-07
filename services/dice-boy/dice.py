import re
import random
from datetime import datetime

dexpr_re = re.compile(r'(\d*?)d(\d*?)')
def roll_from_dexpr(dexp):
    if m := dexpr_re.match(dexp):
        print(f'DB: {m.group(0)}')

        dice_num = int(m.group(1))
        dice_val = int(m.group(2))

        res = []
        for i in range(0, dice_num):
            res.append(random.randint(1, dice_val))

        return res

    else:
        return []

def roll(num, val):
    res = []
    for i in range(0, num):
        res.append(random.randint(1, val))

    return res

# Reset Rand Roll
def rr_roll(num, val):
    random.seed(datetime.now())
    return roll(num, val)

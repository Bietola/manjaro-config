import re
import random
from datetime import datetime

dexpr_re = re.compile(r'\b(\d*)d(\d*)\b')

def parse_dexpr(dexp):
    if m := dexpr_re.match(dexp):
        print(f'DB: {m[0]}')

        return (int(m.group(1)), int(m.group(2)))

    else:
        return (0, 0)

def roll(num, val):
    res = []
    for i in range(0, num):
        res.append(random.randint(1, val))

    return res

# Reset Rand Roll
def rr_roll(num, val):
    random.seed(datetime.now())
    return roll(num, val)

#!/usr/bin/env python3
import random

random.seed(1337)


def rb(size):
    return random.randbytes(size)


for x in range(20):
    (group, mask, key, input) = (random.choice([0, 1]), rb(16), rb(16), rb(16))
    output = bytes([m ^ i for m, i in zip(key, input)])
    print(",".join([str(group), mask.hex(), key.hex(), input.hex(), output.hex()]))

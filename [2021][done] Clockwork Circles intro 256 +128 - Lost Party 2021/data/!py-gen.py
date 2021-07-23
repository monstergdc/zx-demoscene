#! /usr/bin/env python
# -*- coding: utf-8 -*-

# ZX helper stuff
# (c)2020, 2021 MoNsTeR/GDC, Noniewicz.com, Jakub Noniewicz
# cre: 20200829
# upd: 20210630
# upd: 20210723

# TODO:
# - ?

from array import array
import random, math, string, os, sys

random.seed()
c = math.pi/180
#s2 = math.sqrt(2)/2

def save(data, fn):
    try:
        text_file = open(fn, "w")
        text_file.write(data)
        text_file.close()
        return 0
    except:
        print('file save error: fn=[%s]' % fn)
        return -1

def gen_sin(size, amp):
    dim = 200
    bdata_sin = [0] * size
    bdata_cos = [0] * size
    data = ""
    y0 = 24/2 # center for ZX attr
    x0 = 32/2

    data += "sin%d\r\n" % size
    for x in range(size):
        y = y0 + amp * math.sin(x/size*360*c)
        bdata_sin[x] = int(y)
        data += "\tdb %d ; %d\r\n" % (int(y), x)

    data += "\r\n"

    data += "cos%d\r\n" % size
    for x in range(size):
        y = x0 + amp * math.cos(x/size*360*c)
        bdata_cos[x] = int(y)
        data += "\tdb %d ; %d\r\n" % (int(y), x)

    data += "\r\n"

    data += "t22\r\n"
    for x in range(dim):
        y = x*x
        #data[x] = y
        data += "\tdw %d ; %d\r\n" % (int(y), x)

    if False:
        save(data, 'sincos-data%d-%d.asm' % (size, amp))

    nfile = open('sin%d-%d.bin' % (size, amp), 'wb')
    nfile.write((''.join(chr(i) for i in bdata_sin)).encode('charmap'))

    if False:
        nfile = open('cos%d-%d.bin' % (size, amp), 'wb')
        nfile.write((''.join(chr(i) for i in bdata_cos)).encode('charmap'))

# ---

if False:
    gen_sin(size = 32, amp = 6)
    gen_sin(size = 32, amp = 7)
    gen_sin(size = 32, amp = 8)
    gen_sin(size = 32, amp = 10)
    gen_sin(size = 32, amp = 12)

gen_sin(size = 48, amp = 5.8) # this one for Clockwork Circles
#gen_sin(size = 48, amp = 6)
#gen_sin(size = 48, amp = 7)
#gen_sin(size = 48, amp = 8)
#gen_sin(size = 48, amp = 10)
#gen_sin(size = 48, amp = 12)

if False:
    gen_sin(size = 64, amp = 6)
    gen_sin(size = 64, amp = 7)
    gen_sin(size = 64, amp = 8)
    gen_sin(size = 64, amp = 10)
    gen_sin(size = 64, amp = 12)

if False:
    gen_sin(size = 128, amp = 6)
    gen_sin(size = 128, amp = 8)
    gen_sin(size = 128, amp = 10)
    gen_sin(size = 128, amp = 12)

if False:
    gen_sin(size = 256, amp = 6)
    gen_sin(size = 256, amp = 8)
    gen_sin(size = 256, amp = 10)
    gen_sin(size = 256, amp = 12)

# EOF

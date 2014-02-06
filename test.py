#!/usr/bin/env python

"Come basic tests for the interface."

import numpy as np
import ricecomp

print "Testing rcomp/rdecomp with int8"
input = np.random.randint(-127,127,(20,5)).astype(np.int8)
buf = ricecomp.rcomp(input, 32)
output = ricecomp.rdecomp(buf, np.int8, input.size, 32).reshape(input.shape)
if (input!=output).any():
   print "DATA NOT EQUAL!!"

print "Testing rcomp/rdecomp with int16"
input = np.random.randint(-5000,5000,(20,5)).astype(np.int16)
buf = ricecomp.rcomp(input, 32)
output = ricecomp.rdecomp(buf, np.int16, input.size, 32).reshape(input.shape)
if (input!=output).any():
   print "DATA NOT EQUAL!!"

print "Testing rcomp/rdecomp with int32"
input = np.random.randint(-500000,500000,(20,5)).astype(np.int32)
buf = ricecomp.rcomp(input, 32)
output = ricecomp.rdecomp(buf, np.int32, input.size, 32).reshape(input.shape)
if (input!=output).any():
   print "DATA NOT EQUAL!!"

print "Testing rcomp/rdecomp with uint8"
input = np.random.randint(0,255,(20,5)).astype(np.uint8)
buf = ricecomp.rcomp(input, 32)
output = ricecomp.rdecomp(buf, np.uint8, input.size, 32).reshape(input.shape)
if (input!=output).any():
   print "DATA NOT EQUAL!!"

print "Testing rcomp/rdecomp with uint16"
input = np.random.randint(0,5000,(20,5)).astype(np.uint16)
buf = ricecomp.rcomp(input, 32)
output = ricecomp.rdecomp(buf, np.uint16, input.size, 32).reshape(input.shape)
if (input!=output).any():
   print "DATA NOT EQUAL!!"

print "Testing rcomp/rdecomp with uint32"
input = np.random.randint(0,500000,(20,5)).astype(np.uint32)
buf = ricecomp.rcomp(input, 32)
output = ricecomp.rdecomp(buf, np.uint32, input.size, 32).reshape(input.shape)
if (input!=output).any():
   print "DATA NOT EQUAL!!"

print "Testing different block sizes"
input = np.random.randint(-500000,500000,(20,5)).astype(np.int32)
print "   nblock == 16"
buf = ricecomp.rcomp(input, 16)
output = ricecomp.rdecomp(buf, np.int32, input.size, 16).reshape(input.shape)
if (input!=output).any():
   print "DATA NOT EQUAL!!"
print "   nblock == 64"
buf = ricecomp.rcomp(input, 64)
output = ricecomp.rdecomp(buf, np.int32, input.size, 64).reshape(input.shape)
if (input!=output).any():
   print "DATA NOT EQUAL!!"
print "   nblock == 128"
buf = ricecomp.rcomp(input, 128)
output = ricecomp.rdecomp(buf, np.int32, input.size, 128).reshape(input.shape)
if (input!=output).any():
   print "DATA NOT EQUAL!!"
print "negative test for nblock: 16 != 32"
buf = ricecomp.rcomp(input, 16)
try:
   output = ricecomp.rdecomp(buf, np.int32, input.size, 32).reshape(input.shape)
   if (input==output).all():
      print "DATA EQUAL!!"
except:
   pass # we actually expect a problem here when the decompress bsize is larger
print "negative test for nblock: 32 != 16"
buf = ricecomp.rcomp(input, 32)
output = ricecomp.rdecomp(buf, np.int32, input.size, 16).reshape(input.shape)
if (input==output).all():
   print "DATA EQUAL!!"

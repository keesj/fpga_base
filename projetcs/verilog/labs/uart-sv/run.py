#!/usr/bin/env python3
import time
import serial

ser = serial.Serial( port='/dev/ttyUSB1', baudrate=115200)

ser.isOpen()
ser.write(b"a" * 64)
ser.send_break()
time.sleep(.1)
print("Connect to target")
for i in range(1):
    ser.write(b"a" * 128)
    time.sleep(0.1)
    while ser.inWaiting() > 0:
        print(ser.read(1).decode('latin1'),end='')

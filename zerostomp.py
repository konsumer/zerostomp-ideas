#!/usr/bin/env python

import time
import random
import os
from evdev import list_devices, InputDevice
from select import select
import Adafruit_Nokia_LCD as LCD
import Adafruit_GPIO.SPI as SPI
import RPi.GPIO as GPIO
import ImageDraw
import ImageFont
from PIL import Image

def displayControls():
  """
  Display the current patch name, control-names, and values (as lines)
  """
  disp.clear()
  draw.rectangle((0, 0, LCD.LCDWIDTH, LCD.LCDHEIGHT), outline=255,fill=255)
  draw.text((0, 0), name.center(20), font=font)
  i = 0
  for p in params:
    offset = 10 + (i * 9)
    draw.text((0, offset), params[p][0], font=font)
    draw.line((0, offset + 6, LCD.LCDWIDTH*(params[p][1]/20.0), offset + 6), fill=0)
    i = i + 1
  disp.image(imageText)
  disp.display()

def setup():
  global devices, params, name, disp, imageText, draw, font
  devices = [InputDevice(i) for i in list_devices()]
  devices = {dev.fd: dev for dev in devices if dev.name.startswith('rotary@')}
  labels = ['Param 1', 'Param 2', 'Param 3', 'Param 4']
  params = {f: [labels[i], 0] for i,f in enumerate(devices)}

  ASSET_DIR=os.path.join(os.path.dirname(__file__), 'assets')
  disp = LCD.PCD8544(23, 24, spi=SPI.SpiDev(0, 0, max_speed_hz=4000000))
  #font = ImageFont.truetype('%s/VCR_OSD_MONO_1.001.ttf' % ASSET_DIR, 6)
  font = ImageFont.truetype('%s/ProFontWindows.ttf' % ASSET_DIR, 6)
  imageText = Image.new('1',(LCD.LCDWIDTH, LCD.LCDHEIGHT))
  imageWait = Image.open('%s/please_wait.ppm' % ASSET_DIR).convert('1')
  draw = ImageDraw.Draw(imageText)
  name='EFFECT NAME'
  # turn on LCD backlight
  GPIO.setmode(GPIO.BCM)
  GPIO.setup(22, GPIO.OUT)
  GPIO.output(22, GPIO.LOW)

  disp.begin(contrast=60)
  disp.clear()
  disp.image(imageWait)
  disp.display()
  time.sleep(1)


def loop():
  displayControls()
  # update params from knobs
  r, w, x = select(devices, [], [])
  for fd in r:
    for event in devices[fd].read():
      if event.type == 2:
        params[fd][1] = params[fd][1] + event.value

def shutdown():
  disp.clear()
  disp.display()
  GPIO.output(22, GPIO.HIGH)

setup()
print('Press Ctrl-C to quit.')
try:
  while True:
    loop()
finally:
  shutdown()

#!/usr/bin/env python3

# pip3 install python-osc
from pythonosc import dispatcher
from pythonosc import osc_server

def demo_handler(address, *args):
  print(address, args)

def lcd_handler(address, *args):
  print('LCD (line %d): %s' % (args[0], ' '.join(args[1:])))

def connect_handler(address, *args):
  print('connect', address, args)

if __name__ == "__main__":
  dispatcher = dispatcher.Dispatcher()
  dispatcher.map("/connect", connect_handler)
  dispatcher.map("/lcd", lcd_handler)

  server = osc_server.ThreadingOSCUDPServer(("127.0.0.1", 5005), dispatcher)
  print("Serving on %s:%d" % server.server_address)
  server.serve_forever()


# TODO: load pd
# TODO: listen/send commands via UDP
# TODO: make pygame UI for LCD, buttons & rotary-encoders
# zerostomp

This is a cheap & easily-programmable effects pedal / synth that's easy to build.

It includes a text-mode emulator (in qemu) so you can easily build images, and runs on docker for easy management & development.

# WORK IN PROGRESS

## TODO

* provide release that is image of SDCard for quick install
* write detailed usage instructions and videos
* implement [these](https://guitarextended.wordpress.com/audio-effects-for-guitar-with-pure-data/) and other basic effect patches
* add support for expression pedal
* do something smart with rotary push-state
* put patch/gpio controller in pd directly with [rpi-gpio](http://nyu-waverlylabs.org/rpi-gpio/)?
* replace pd with [mod-host](https://github.com/moddevices/mod-host) & ladspa for better performance?
* get purr-data running so it has all the nice fresh extensions
* Use `/boot/startup.sh` method (used in dev) to fast-boot into pd.
* Redesign [pdpi](https://github.com/konsumer/pdpi) to use all this stuff

## hardware

The pedal is meant to operate plugged-in (no battery power) and uses a pi-zero to do all the work. It uses 4 rotary-encoders for input, a single 3PDT footswitch for true-bypass, and 2 buttons to select the current patch. It has a Nokia 5110 to display status and show the values of different parameters. The USB power plug is hooked up to the piZero data-port, so it can get power & also run in USB host mode if it's connected to a computer.

### parts

* [nice enclosures & buttons](https://www.mammothelectronics.com/)
* [audio hat](https://www.amazon.com/gp/product/B075V1VNDD/ref=ppx_yo_dt_b_asin_title_o02_s00?ie=UTF8&psc=1)
* [panel-mount USB for power & input](https://www.adafruit.com/product/4217)
* 4x [rotary encoders with pullup resistors](https://www.amazon.com/gp/product/B06XQTHDRR/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)
* [pizero](https://www.adafruit.com/product/2885)
* [stacking header](https://www.amazon.com/gp/product/B071XCHZNB/ref=ppx_yo_dt_b_asin_title_o00_s00?ie=UTF8&psc=1)
* 2x [input buttons](https://www.amazon.com/gp/product/B076V2QYSJ/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)
* 2x [audio jacks](https://www.amazon.com/gp/product/B00CO6Q1II/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&psc=1)
* [3PDT bypass footswitch](https://www.mammothelectronics.com/collections/footswitches/products/3pdt-ls-pro-footswitch)

## software

* stores patches on sdcard in `zerostomp/patches`
* each effect is a patch made in puredata.
* uses [this](https://github.com/modmypi/Rotary-Encoder/blob/master/rotary_encoder.py) to read encoders
* run ssh server for file sharing & control
* run pi in [USB host mode](https://gist.github.com/gbaman/975e2db164b3ca2b51ae11e45e8fd40a) so it acts like a network device

When a pd patch loads, it receives any stored params to `init-value` message, and sends it's name to `patch-name` message. It also sends each of it's params to `patch-param`, along with their range. When a knob is turned, it sends it's value to `patch-value`.

### optimization

* [trimmed down distro](https://gist.github.com/hhromic/78e3d849ec239b6a4789ae8842701838)
* [fast boot linux](http://himeshp.blogspot.com/2018/08/fast-boot-with-raspberry-pi.html) (under 2s)
* [optimize sound](https://wiki.linuxaudio.org/wiki/raspberrypi)

## NOTES

### emulator

**TODO:** This can be made much simpler with `arm32v7/debian:stretch-slim` docker to build stuff in pi-space

* Run emulator with `make emu`
* Press `Ctrl-A` then `X` to exit emulator
* `sudo poweroff` will cleanly shutdown
* don't edit files in `patches/` on the host when the emulator is running or they may get corrupt. Eventually I will setup network-mount or something to help with this.

Here is the image-build procedure:

```
sudo make setup
```

You can run the image in an emulator, but it will probly be missing stuff like sound:

```
make emu
```

### puredata

You can run `emulator/MAIN.py` to emulate zerostomp, on the host system to test out stuff, if you have `pd` in your path.

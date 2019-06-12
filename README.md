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
* get purr-data running so it has all the nice fresh extensions
* Use `/boot/startup.sh` method (used in dev) to fast-boot into pd.
* Update [pdpi](https://github.com/konsumer/pdpi) to use all this stuff, so this repo can be much simpler.

## software

* stores patches on sdcard in `zerostomp/patches`
* each effect is a patch made in puredata.
* uses [this](https://github.com/modmypi/Rotary-Encoder/blob/master/rotary_encoder.py) to read encoders

### optimization

* [fast boot linux](http://himeshp.blogspot.com/2018/08/fast-boot-with-raspberry-pi.html) (under 2s)
* [optimize sound, in general](https://wiki.linuxaudio.org/wiki/raspberrypi)
* [optimize usb sound](https://computers.tutsplus.com/articles/using-a-usb-audio-device-with-a-raspberry-pi--mac-55876)


When a patch loads, it receives any stored params to `init-value` message, and sends it's name to `patch-name` message. It also sends each of it's params to `patch-param`, along with their range. When a knob is turned, it sends it's value to `patch-value`.

## hardware

The pedal is meant to operate plugged-in (no battery power) and uses a pi-zero to do all the work. It uses 4 rotary-encoders for input, a single 3PDT footswitch for true-bypass, and 2 buttons to select the current patch. It has a Nokia 5110 to display status and show the values of different parameters.

### parts

* [nice enclosures & buttons](https://www.mammothelectronics.com/)
* [audio usb](https://www.adafruit.com/product/1475)
* [USB Host adapter for plugging in audio](https://www.adafruit.com/product/1099)
* [panel-mount USB for power input](https://www.adafruit.com/product/4217)
* 4x [rotary encoders](https://www.adafruit.com/product/377)
* [pizero](https://www.adafruit.com/product/2885)


## NOTES

### emulator

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
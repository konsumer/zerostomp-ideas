import pd from 'node-libpd'
import raspi from 'raspi'
import { DigitalInput, PULL_UP } from 'raspi-gpio'

// location of patch files
const patchesPath = `${__dirname}/patches`

// [clock, data, push] for 3 rotary-encoders
const rotaryPins = [
  [17, 18, 19],
  [20, 21, 22],
  [23, 24, 25]
]

raspi.init(() => {
  // handle 3 rotary encoders
  const knobs = rotaryPins.map(r => r.map(pin => new DigitalInput(({ pin, pullResistor: PULL_UP }))))
})

pd.init({
  numInputChannels: 2,
  numOutputChannels: 2,
  sampleRate: 48000,
  ticks: 1
})

const patch = pd.openPatch('receive-msg.pd', patchesPath)

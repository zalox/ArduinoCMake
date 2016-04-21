# ArduinoCMake
A simple CMake build project for Arduino

## Prerequisites

Compiling Arduino firmware requires the following dependencies:
- avr-gcc
- avr-libc

further, flashing the firmware requires:

- avr-binutils
- avrdude

at last, for the serial communication you will need

- picocom

## Usage

See the `examples/CMakeLists.txt` for basic usage.

An optional but recommended option is to set `ARDUINO_ROOT` to the Arduino SDK root directory.
If this variable is not set, standard install locations will be searched.

Consult the file **hardware/arduino/avr/boards.txt** in your Arduino root folder for setting the following
variables in your CMakeLists.txt:

| Compile | Notes |
| ---- | ----- |
| `FIRMWARE_TARGET` | The executable name |
| `ARDUINO_PROTOCOL` | Bootloader protocol for uploading of firmware.  Set `ARDUINO_PROTOCOL` to the `upload.protocol` value in **boards.txt** for your board |
| `ARDUINO_VARIANT` | Name which corresponds to your board variant type. Set `ARDUINO_VARIANT` to the `build.variant` value in **boards.txt** for your board.  |
| `ARDUINO_MCU` | MCU part definition. Set `ARDUINO_MCU` to the `build.mcu` value in **boards.txt** for your board. |
| `ARDUINO_FCPU` | Clock frequency. Set `ARDUINO_FCPU` to the `build.f_cpu` value in **boards.txt** for your board. |
| `ARDUINO_UPLOAD_SPEED` | Upload serial baud rate speed to flash your Arduino. Set `ARDUINO_UPLOAD_SPEED` to the `upload.speed` value in **boards.txt** for your board. |
| `ARDUINO_PORT` | Upload serial port. This may begin with `/dev/tty.usbmodem` on a Mac or `/dev/ttyUSB` on Linux, for example. |

| Serial | Notes |
| ---- | ----- |
| `ARDUINO_SERIAL_SPEED` | Serial communications baudrate speed for your Arduino. `ARDUINO_PORT` must also be set. |


## Install	
bash```
git submodule add https://github.com/zalox/ArduinoCMake.git
```

## Usage
bash```
make flash
```

[`picocom`](https://github.com/npat-efault/picocom)
bash```
make serial
```
    

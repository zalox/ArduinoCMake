# ArduinoCMake
A simple CMake build project for Arduino

## Getting Started

See the [CMakeLists.txt](CMakeLists.txt) file for an example blink program.
It is optional but recommended to set `ARDUINO_ROOT` to the installed root Arduino SDK folder location. If this variable is not set, standard install locations will be searched (see [Arduino.cmake](
scripts/Arduino.cmake))

Required variables to set in your CMakeLists.txt file are

| Required | Notes |
| ---- | ----- |
| `FIRMWARE_TARGET` | Your target executable name |
| `ARDUINO_PROTOCOL` | Bootloader protocol to upload your firmware. Consult the file **hardware/arduino/avr/boards.txt** in your Arduino root folder. Set `ARDUINO_PROTOCOL` to the `upload.protocol` value for your board |
| `ARDUINO_BOARD` | Name which corresponds to your board variant type. Consult the file **hardware/arduino/avr/boards.txt** in your Arduino root folder. Set `ARDUINO_BOARD` to the `build.variant` value for your board.  |
| `ARDUINO_MCU` | MCU part definition. Consult the file **hardware/arduino/avr/boards.txt** in your Arduino root folder. Set `ARDUINO_MCU` to the `build.mcu` value for your board. |
| `ARDUINO_FCPU` | Clock frequency. Consult the file **hardware/arduino/avr/boards.txt** in your Arduino root folder. Set `ARDUINO_FCPU` to the `build.f_cpu` value for your board. |
| `ARDUINO_UPLOAD_SPEED` | Upload serial baud rate speed to flash your Arduino. The value '115200' is a good choice. |
| `ARDUINO_PORT` | Upload serial port. This may begin with `/dev/tty.usbmodem` on a Mac or `/dev/ttyUSB` on Linux, for example.

You must also set your target executable to depend on the list of Arduino sources like so:

	add_executable(${FIRMWARE_TARGET}
		${SOURCES}
		${ARDUINO_SOURCE_FILES})

where `SOURCES` is a list of your custom source files for your project.

## Compile the example and upload to your arduino

	git clone https://github.com/ChisholmKyle/ArduinoCMake.git
	cd ArduinoCMake && mkdir build && cd build
	cmake ..
	make
	make flash


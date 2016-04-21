cmake_minimum_required (VERSION 2.6)
project (ArduinoCMakeExample)

set(FIRMWARE_TARGET firmware) # matches add_executable

### Settings
# set(ARDUINO_ROOT "/Applications/Arduino.app/Contents/Java")
set(ARDUINO_PORT "/dev/ttyUSB0") #default USB0
set(ARDUINO_SERIAL_SPEED "115200") # serial picocom communications

# uncomment the correct device
# To create your own .cmake file look in the message printed from this function:
# message(${ARDUINO_ROOT}/hardware/arduino/avr/boards.txt) # prints path
include("${CMAKE_SOURCE_DIR}/ArduinoCMake/cmake/ArduinoUno.cmake")
# include("${CMAKE_SOURCE_DIR}/ArduinoCMake/cmake/ArduinoMega2560.cmake")
include("${CMAKE_SOURCE_DIR}/ArduinoCMake/cmake/Arduino.cmake") # finds main library

# target
add_executable(${FIRMWARE_TARGET}
	# your source files
	${ARDUINO_SOURCE_FILES})

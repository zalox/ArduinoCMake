cmake_minimum_required (VERSION 2.6)
project (ArduinoCMakeExample)

# specify target name
set(FIRMWARE_TARGET firmware)

# preferably set SDK root folder (see Arduino.cmake for search paths)
# set(ARDUINO_ROOT "/Applications/Arduino.app/Contents/Java")

# arduino settings - consult ${ARDUINO_ROOT}/hardware/arduino/avr/boards.txt
set(ARDUINO_PROTOCOL "wiring")
set(ARDUINO_BOARD "mega")
set(ARDUINO_MCU "atmega2560")
set(ARDUINO_FCPU "16000000L")
# upload settings
set(ARDUINO_UPLOAD_SPEED "115200")
set(ARDUINO_PORT "/dev/tty.usbmodemXXXXXX")

# arduino cmake script
include("${CMAKE_SOURCE_DIR}/scripts/Arduino.cmake")

# Include files
include_directories("${CMAKE_SOURCE_DIR}/include")

# sources
file(GLOB SOURCES "${PROJECT_SOURCE_DIR}/src/*.cpp")

# target
add_executable(${FIRMWARE_TARGET}
	${SOURCES}
	${ARDUINO_SOURCE_FILES})

cmake_minimum_required (VERSION 2.6)
project (ArduinoCMakeExample)

# specify target name
set(FIRMWARE_TARGET firmware)

# preferably set SDK root folder (see Arduino.cmake for search paths)
# 	set(ARDUINO_ROOT "/Applications/Arduino.app/Contents/Java")

# arduino settings - consult ${ARDUINO_ROOT}/hardware/arduino/avr/boards.txt
# alternatively, place these setting in a separate file and use command such as:
# 	include("${CMAKE_SOURCE_DIR}/cmake/ArduinoMega2560.cmake")
set(ARDUINO_PROTOCOL "wiring")
set(ARDUINO_VARIANT "mega")
set(ARDUINO_MCU "atmega2560")
set(ARDUINO_FCPU "16000000L")
set(ARDUINO_UPLOAD_SPEED "115200")

# upload port
set(ARDUINO_PORT "/dev/tty.usbmodemXXXXXX")

# serial picocom communications
set(ARDUINO_SERIAL_SPEED "115200")

# arduino cmake script
include("${CMAKE_SOURCE_DIR}/cmake/Arduino.cmake")

# optional Wire library to include
# include("${CMAKE_SOURCE_DIR}/cmake/ArduinoLibraryWire.cmake")

# Include files
include_directories("${CMAKE_SOURCE_DIR}/include")

# sources
file(GLOB SOURCES "${PROJECT_SOURCE_DIR}/src/*.cpp")

# target
add_executable(${FIRMWARE_TARGET}
	${SOURCES}
	${ARDUINO_SOURCE_FILES})

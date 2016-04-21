# This file is based on the work of:
# https://github.com/tmpsantos/Arduino-CMake-Template
# http://mjo.tc/atelier/2009/02/arduino-cli.html
# http://johanneshoff.com/arduino-command-line.html
# http://www.arduino.cc/playground/Code/CmakeBuild
# http://www.tmpsantos.com.br/en/2010/12/arduino-uno-ubuntu-cmake/
# http://forum.arduino.cc/index.php?topic=244741.0

# set compilers
find_program(AVR_GCC avr-gcc)
find_program(AVR_G++ avr-g++)

if (NOT AVR_GCC)
    message(FATAL_ERROR "Please install avr-gcc")
endif ()
if (NOT AVR_G++)
    message(FATAL_ERROR "Please install avr-g++")
endif ()

set(CMAKE_ASM_COMPILER avr-gcc)
set(CMAKE_C_COMPILER avr-gcc)
set(CMAKE_CXX_COMPILER avr-g++)

# enable assembler language
enable_language(ASM)

# for cross-compilation
set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")
set(CMAKE_CXX_LINK_FLAGS "")

# C only fine tunning
set(TUNING_FLAGS "-funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums")

# Compilation flags
set(CMAKE_ASM_FLAGS "-mmcu=${ARDUINO_MCU} -DF_CPU=${ARDUINO_FCPU}")
set(CMAKE_CXX_FLAGS "${CMAKE_ASM_FLAGS} -Os")
set(CMAKE_C_FLAGS "${CMAKE_CXX_FLAGS} ${TUNING_FLAGS} -Wall -std=gnu99")

# Find arduino root path
if(ARDUINO_ROOT)
    # check if path specified is good
    find_path(ARDUINO_ROOT_VERIFIED
        NAMES lib/version.txt
        PATHS ${ARDUINO_ROOT})
    if(NOT ARDUINO_ROOT_VERIFIED)
        unset(ARDUINO_ROOT)
    endif()
endif()
if(NOT ARDUINO_ROOT)
    # if root is not set, search
    file(GLOB ARDUINO_ROOT_SEARCH_PATHS
        /usr/arduino*
        /usr/local/arduino*
        /usr/share/arduino*
        /usr/local/share/arduino*
        /opt/arduino*
        /opt/local/arduino*
        /Applications/Arduino.app/Contents/Java
        /Applications/Arduino.app/Contents/Resources/Java
    )
    find_path(ARDUINO_ROOT
        NAMES lib/version.txt
        PATHS ${ARDUINO_ROOT_SEARCH_PATHS})
endif()
if(NOT ARDUINO_ROOT)
    # Arduino SDK not found
    message(FATAL_ERROR "Could not find Arduino SDK root folder. Set the variable ARDUINO_ROOT in your CMakeList.txt file before including Arduino.cmake")
endif()

# Arduino directories
set(ARDUINO_CORE_DIR "${ARDUINO_ROOT}/hardware/arduino/avr/cores/arduino")
set(ARDUINO_PINS_DIR "${ARDUINO_ROOT}/hardware/arduino/avr/variants/${ARDUINO_VARIANT}")
set(AVRDUDE_CONFIG "${ARDUINO_ROOT}/hardware/tools/avr/etc/avrdude.conf")

include_directories(${ARDUINO_CORE_DIR})
include_directories(${ARDUINO_PINS_DIR})

# core source
file(GLOB ARDUINO_SOURCE_FILES
	${ARDUINO_CORE_DIR}/*.S
	${ARDUINO_CORE_DIR}/*.c
	${ARDUINO_CORE_DIR}/*.cpp)
# remove main
list(REMOVE_ITEM ARDUINO_SOURCE_FILES "${ARDUINO_CORE_DIR}/main.cpp")

set(PORT $ENV{ARDUINO_PORT})
if (NOT PORT)
    set(PORT ${ARDUINO_PORT})
endif()

find_program(AVROBJCOPY "avr-objcopy")
find_program(AVRDUDE "avrdude")
find_program(PICOCOM "picocom")

if(AVROBJCOPY AND AVRDUDE)
    # make sure target is set
    if(NOT FIRMWARE_TARGET)
        message(FATAL_ERROR "Set the variable FIRMWARE_TARGET in your CMakeList.txt file before including Arduino.cmake")
    endif()

    add_custom_target(hex)
    add_dependencies(hex ${FIRMWARE_TARGET})
    add_custom_command(TARGET hex POST_BUILD
        COMMAND ${AVROBJCOPY} -O ihex -R .eeprom ${CMAKE_CURRENT_BINARY_DIR}/${FIRMWARE_TARGET} ${FIRMWARE_TARGET}.hex
    )

    add_custom_target(flash)
    add_dependencies(flash hex)
    if(ARDUINO_PROTOCOL STREQUAL "usbasp")
        add_custom_command(TARGET flash POST_BUILD
            COMMAND ${AVRDUDE} -C${AVRDUDE_CONFIG} -v -p${ARDUINO_MCU} -c usbasp -Uflash:w:firmware.hex:i
        )
    else()
        add_custom_command(TARGET flash POST_BUILD
            COMMAND ${AVRDUDE} -C${AVRDUDE_CONFIG} -v -p${ARDUINO_MCU} -c${ARDUINO_PROTOCOL} -P${PORT} -b${ARDUINO_UPLOAD_SPEED} -D -Uflash:w:${FIRMWARE_TARGET}.hex:i
        )
    endif()

endif()

if(PICOCOM)
    add_custom_target(serial)
    add_custom_command(TARGET serial POST_BUILD
        COMMAND ${PICOCOM} ${PORT} -b ${ARDUINO_SERIAL_SPEED} -l
    )
endif()

add_custom_target(reset)
add_custom_command(TARGET reset POST_BUILD
    COMMAND echo 0 > ${PORT}
)

uname_S := $(shell sh -c 'uname -s 2>/dev/null || echo not')

ifeq ($(uname_S),Linux)
    PREFERENCES_FILE := ~/.arduino/preferences.txt
    HARDWARE_DIR := /usr/share/arduino/hardware
    AVRDUDE_CONF := /usr/share/arduino/hardware/tools/avrdude.conf
    AVR_INCLUDE := /usr/lib/avr/include
endif
ifeq ($(uname_S),Darwin)
    PREFERENCES_FILE := ~/Library/Arduino/preferences.txt
    HARDWARE_DIR := /Applications/Arduino.app/Contents/Resources/Java/hardware
    # workaround for bug in OS X where modifying PATH doesn't work
    # see https://discussions.apple.com/message/10129603?messageID=10129603
    SHELL := /bin/bash
    PATH := $(HARDWARE_DIR)/tools/avr/bin:$(PATH)
    AVRDUDE_CONF := $(HARDWARE_DIR)/tools/avr/etc/avrdude.conf
    AVR_INCLUDE := $(HARDWARE_DIR)/tools/avr/avr/include
endif
BOARDS_FILE := $(HARDWARE_DIR)/arduino/boards.txt

ifneq ($(shell test -f $(PREFERENCES_FILE) && echo y),y)
    $(error No arduino preferences.txt found. Try running the Arduino IDE)
endif
ifneq ($(shell test -f $(BOARDS_FILE) && echo y),y)
    $(error No boards.txt found. You need to install the Arduino IDE)
endif

BOARD := $(shell sh -c 'grep board= $(PREFERENCES_FILE) | cut -d = -f 2')
ifeq ($(BOARD),)
    $(error No board set in preferences file)
endif

MCU := $(shell sh -c 'grep ^$(BOARD).build.mcu $(BOARDS_FILE) | cut -d = -f 2')
ifeq ($(MCU),)
    $(error No MCU found in boards.txt)
endif

F_CPU := $(shell sh -c 'grep ^$(BOARD).build.f_cpu $(BOARDS_FILE) | cut -d = -f 2')
ifeq ($(F_CPU),)
    $(error No F_CPU found in boards.txt)
endif

UPLOAD_SPEED := $(shell sh -c 'grep ^$(BOARD).upload.speed $(BOARDS_FILE) | cut -d = -f 2')
ifeq ($(UPLOAD_SPEED),)
    $(error No UPLOAD_SPEED found in boards.txt)
endif

UPLOAD_PROTOCOL := $(shell sh -c 'grep ^$(BOARD).upload.protocol $(BOARDS_FILE) | cut -d = -f 2')
ifeq ($(UPLOAD_PROTOCOL),)
    $(error No UPLOAD_PROTOCOL found in boards.txt)
endif

PORT := $(shell sh -c 'grep port= $(PREFERENCES_FILE) | cut -d = -f 2')
ifeq ($(PORT),)
    $(error No PORT set in preferences file)
endif

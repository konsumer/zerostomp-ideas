TARGET = zerostomp
UNAME = $(shell uname)
SOLIB_PREFIX = lib
SOLIB_EXT = so
PLATFORM = linux
CXXFLAGS = -D__UNIX_JACK__ -D__LINUX_ALSA__
AUDIO_API = -ljack -lasound -pthread
LIBPD_DIR = /root/libpd
LIBPD = $(LIBPD_DIR)/libs/libpd.$(SOLIB_EXT)
SRC_FILES = src/PdObject.cpp src/main.cpp src/RtAudio.cpp
CXXFLAGS += -I$(LIBPD_DIR)/pure-data/src -I$(LIBPD_DIR)/libpd_wrapper \
            -I$(LIBPD_DIR)/libpd_wrapper/util -I$(LIBPD_DIR)/cpp \
            -I./src -std=c++11 -DLIBPD_USE_STD_MUTEX -O3
TMP := $(shell tempfile -d)

.PHONY: clean clobber

$(TARGET): ${SRC_FILES:.cpp=.o} $(LIBPD)
	g++ -o $(TARGET) $^ $(LIBPD) $(AUDIO_API)
	if [ $(PLATFORM) == "mac" ]; then mkdir -p ./libs && cp $(LIBPD) ./libs; fi

$(LIBPD):
	cd $(LIBPD_DIR) && make UTIL=true EXTRA=true

$(TARGET).tgz: $(TARGET)
	mkdir -p $(TMP)/bin $(TMP)/lib
	cp $(LIBPD) $(TMP)/lib
	cp $(TARGET) $(TMP)/bin
	tar -czf $(TARGET).tgz -C $(TMP)

release: $(TARGET).tgz

clean:
	rm -f src/*.o

clobber: clean
	rm -f $(TARGET)
	if [ $(PLATFORM) == "mac" ]; then rm -rf ./libs; fi
	cd $(LIBPD_DIR) && make clobber

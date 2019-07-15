# this uses qemu + make to manage your zerostomp image

APP_NAME = 'zerostomp'
CWD = $(shell pwd)

.PHONY: image

# eventually, I will be able to use built-in scripts in ryankurte/docker-rpi-emu
# but need to wait for ryankurte/docker-rpi-emu#18

image: images/$(APP_NAME).img
	@echo "Building image in the context of pi"
	@docker run -it --rm --privileged=true \
		-v ${CWD}/images:/usr/rpi/images \
		-v ${CWD}/builder:/usr/rpi/builder \
		-v ${CWD}/assets:/usr/rpi/assets \
		-v ${CWD}/patches:/usr/rpi/patches \
		-v ${CWD}/zerostomp.py:/usr/rpi/zerostomp.py \
		-v /dev:/dev \
		-w /usr/rpi \
		ryankurte/docker-rpi-emu \
		/bin/bash \
		-c './builder/setup.sh images/$(APP_NAME).img'

# download a zip of current raspbian-lite
images/raspbian_lite.zip:
	@echo "Getting zip of latest raspbian_lite."
	@mkdir -p images
	@curl -L https://downloads.raspberrypi.org/raspbian_lite_latest -o images/raspbian_lite.zip

# unzip image to images/$(IMAGE)
images/$(APP_NAME).img: images/raspbian_lite.zip
	@echo "Extracting disk image for raspbian_lite."
	@unzip -p images/raspbian_lite.zip '*.img' > images/$(APP_NAME).img




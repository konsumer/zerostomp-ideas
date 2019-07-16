# this uses qemu + make to manage your pi image

APP_NAME = zerostomp

.PHONY: image bash loopback

# build an image
image: loopback
	@echo "Building your $(APP_NAME) image"
	@docker run -it --rm \
		-v $(PWD):/usr/rpi \
		-v $(PWD):/usr/rpi/images/diskmount/usr/rpi \
		ryankurte/docker-rpi-emu \
		chroot /usr/rpi/images/diskmount/ bash /usr/rpi/builder/configpi.sh
	@sudo umount "$(LOOP)p1"
	@sudo umount "$(LOOP)p2"

# run bash in context of pi image
bash: loopback
	@echo "Chrooting to pi image-root"
	@docker run -it --rm \
		-v $(PWD):/usr/rpi \
		-v $(PWD):/usr/rpi/images/diskmount/usr/rpi \
		ryankurte/docker-rpi-emu \
		chroot /usr/rpi/images/diskmount/ bash
	@sudo umount "$(LOOP)p1"
	@sudo umount "$(LOOP)p2"

# mount image as loopback on host
loopback: images/$(APP_NAME).img
	@echo "Creating a loopback filesystem"
	$(eval LOOP = $(shell sudo losetup --show -fP "images/${APP_NAME}.img"))
	@mkdir -p images/diskmount
	@sudo mount "$(LOOP)p2" images/diskmount/
	@sudo mount "$(LOOP)p1" images/diskmount/boot/

# build a purr-data deb
pd:
	@echo "Building purr-data inside $(APP_NAME) image"
	@docker run -it --rm \
		-v $(PWD):/usr/rpi \
		arm32v7/debian \
		bash /usr/rpi/builder/build_purr.sh

# download a zip of current raspbian-lite
images/raspbian_lite.zip:
	@echo "Getting zip of latest raspbian_lite."
	@mkdir -p images
	@curl -L https://downloads.raspberrypi.org/raspbian_lite_latest -o images/raspbian_lite.zip

# unzip image to images/$(IMAGE)
images/$(APP_NAME).img: images/raspbian_lite.zip
	@echo "Extracting disk image for raspbian_lite."
	@unzip -p images/raspbian_lite.zip '*.img' > images/$(APP_NAME).img



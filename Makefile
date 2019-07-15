# this uses qemu + make to manage your pi image

APP_NAME = zerostomp
CWD = $(shell pwd)

# build an image
image: loopback
	@echo "Building your $(APP_NAME) image"
	touch "${CWD}/images/diskmount/boot/ssh"
	cp builder/config.txt "${CWD}/images/diskmount/boot/"
	cp builder/cmdline.txt "${CWD}/images/diskmount/boot/"
	cp -R patches "${CWD}/images/diskmount/boot/"
	cp -R assets "${CWD}/images/diskmount/boot/"
	cp zerostomp.py "${CWD}/images/diskmount/boot/"
	cp builder/rc.local "${CWD}/images/diskmount/etc/rc.local"
	@docker run -it --rm \
		-v ${CWD}/images:/usr/rpi/images \
		-v ${CWD}/builder:/usr/rpi/builder \
		ryankurte/docker-rpi-emu \
		chroot /usr/rpi/images/diskmount/ bash /usr/rpi/builder/configpi.sh
	@sudo umount images/diskmount/boot/
	@sudo umount images/diskmount/

# run bash in context of pi image
bash: loopback
	@echo "Chrooting to pi image-root"
	@docker run -it --rm \
		-v ${CWD}/images:/usr/rpi/images \
		ryankurte/docker-rpi-emu \
		chroot /usr/rpi/images/diskmount/ bash
	@sudo umount images/diskmount/boot/
	@sudo umount images/diskmount/

# mount image as loopback on host
loopback: images/$(APP_NAME).img
	@echo "Creating a loopback filesystem"
	$(eval LOOP = $(shell sudo losetup --show -fP "images/${APP_NAME}.img"))
	@mkdir -p images/diskmount
	@sudo mount "$(LOOP)p2" images/diskmount/
	@sudo mount "$(LOOP)p1" images/diskmount/boot/

# download a zip of current raspbian-lite
images/raspbian_lite.zip:
	@echo "Getting zip of latest raspbian_lite."
	@mkdir -p images
	@curl -L https://downloads.raspberrypi.org/raspbian_lite_latest -o images/raspbian_lite.zip

# unzip image to images/$(IMAGE)
images/$(APP_NAME).img: images/raspbian_lite.zip
	@echo "Extracting disk image for raspbian_lite."
	@unzip -p images/raspbian_lite.zip '*.img' > images/$(APP_NAME).img



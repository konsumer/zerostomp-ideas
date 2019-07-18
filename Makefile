# this uses qemu + make to manage your pi image

APP_NAME = zerostomp

.PHONY: image bash

# build an image
image: images/$(APP_NAME).img
	@echo "Building your $(APP_NAME) image"
	@docker run -it --rm --privileged \
		-v $(PWD):/usr/rpi \
		arm32v7/debian \
		bash /usr/rpi/builder/chroot.sh "/usr/rpi/images/$(APP_NAME).img" /usr/rpi/images/diskmount bash /usr/rpi/builder/configpi.sh

# run bash in context of pi image
bash: images/$(APP_NAME).img
	@echo "Chrooting to pi image-root"
	@docker run -it --rm --privileged \
		-v $(PWD):/usr/rpi \
		arm32v7/debian \
		bash /usr/rpi/builder/chroot.sh "/usr/rpi/images/$(APP_NAME).img" /usr/rpi/images/diskmount bash

# build a purr-data deb
# This is saved in releases of this project, on github
images/purr-data/pd-l2ork-2.9.0-20190624-rev.e2b3cc4a-armv7l.deb:
	@echo "Building purr-data deb"
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



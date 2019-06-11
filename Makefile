# this uses qemu + make to manage your zerostomp image

CWD=$(shell pwd)
IMAGE=zerostomp.img

# Launch the docker image into an emulated session
emu: images/$(IMAGE) images/kernel-qemu-4.4.34-jessie
	@echo "Launching interactive emulated session"
	@qemu-system-arm -nographic\
		-append 'root=/dev/sda2 rw console=ttyAMA0'\
		-kernel images/kernel-qemu-4.4.34-jessie\
		-cpu arm1176 -m 256 -M versatilepb\
		-drive file=images/$(IMAGE),format=raw\
		-drive file=fat:rw:$(CWD)/src

images/kernel-qemu-4.4.34-jessie:
	wget https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/kernel-qemu-4.4.34-jessie -O images/kernel-qemu-4.4.34-jessie

# download a zip of current raspbian-lite
images/raspbian_lite.zip:
	@echo "Getting zip of latest raspbian_lite."
	@mkdir images
	@wget https://downloads.raspberrypi.org/raspbian_lite_latest -O images/raspbian_lite.zip

# unzip image to images/$(IMAGE)
images/$(IMAGE): images/raspbian_lite.zip
	@echo "Extracting disk image for raspbian_lite."
	@unzip images/raspbian_lite.zip
	@mv *.img images/$(IMAGE)

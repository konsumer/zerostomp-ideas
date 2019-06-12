# this uses qemu + make to manage your zerostomp image

APP_NAME='zerostomp'
CWD=$(shell pwd)
KERNEL=kernel-qemu-4.14.79-stretch
DOCKER_REPO=konsumer
VERSION=0.0.1

# Launch the docker image into an emulated session
emu: images/$(APP_NAME).img images/$(KERNEL) images/versatile-pb.dtb
	@echo "Launching interactive emulated session"
	@qemu-system-arm -nographic\
		-append 'root=/dev/sda2 rw panic=1'\
		-dtb images/versatile-pb.dtb\
		-kernel images/$(KERNEL)\
		-cpu arm1176 -m 256 -M versatilepb\
		-drive file=images/$(APP_NAME).img,format=raw\
		-drive file=fat:rw:$(CWD)/emu\
		-drive file=fat:rw:$(CWD)/app\
		-drive file=fat:rw:$(CWD)/patches\
		-no-reboot

images/versatile-pb.dtb:
	wget https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/versatile-pb.dtb -O images/versatile-pb.dtb

images/$(KERNEL):
	wget https://github.com/dhruvvyas90/qemu-rpi-kernel/raw/master/$(KERNEL) -O images/$(KERNEL)

# download a zip of current raspbian-lite
images/raspbian_lite.zip:
	@echo "Getting zip of latest raspbian_lite."
	@mkdir images
	@wget https://downloads.raspberrypi.org/raspbian_lite_latest -O images/raspbian_lite.zip

# unzip image to images/$(IMAGE)
images/$(APP_NAME).img: images/raspbian_lite.zip
	@echo "Extracting disk image for raspbian_lite."
	@unzip -p images/raspbian_lite.zip '*.img' > images/$(APP_NAME).img

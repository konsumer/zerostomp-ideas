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
		-drive file=images/$(IMAGE),format=raw\
		-drive file=fat:rw:$(CWD)/emu\
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
	@unzip images/raspbian_lite.zip
	@mv *.img images/$(APP_NAME).img

# build a docker image
build:
	@docker build -t $(APP_NAME) .

# Build the container without caching
build-nc:
	@docker build --no-cache -t $(APP_NAME) .

# run a docker image
run:
	@docker run -i -t --rm -v / --device /dev/snd $(APP_NAME)

# Stop and remove a running container
stop:
	@docker stop $(APP_NAME); docker rm $(APP_NAME)

# Make a release by building and publishing
release: build-nc publish-latest publish-version

# Generate container tags for the `{version}` ans `latest` tags
tag: tag-latest tag-version

# Generate container `{version}` tag
tag-latest:
	@echo 'create tag latest'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):latest

# Generate container `latest` tag
tag-version:
	@echo 'create tag $(VERSION)'
	docker tag $(APP_NAME) $(DOCKER_REPO)/$(APP_NAME):$(VERSION)

# Publish the `latest` taged container
publish-latest: tag-latest
	@echo 'publish latest to $(DOCKER_REPO)'
	@docker push $(DOCKER_REPO)/$(APP_NAME):latest

# Publish the `{version}` taged container
publish-version: tag-version
	@echo 'publish $(VERSION) to $(DOCKER_REPO)'
	docker push $(DOCKER_REPO)/$(APP_NAME):$(VERSION)
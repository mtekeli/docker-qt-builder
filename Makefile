IMG := mustafatekeli/qtbuilder
TAG_RPI := 1-rpi
TAG_UBUNTU := 1-amd64

.PHONY: build-rpi, build-cross-rpi

build-rpi:
	@ docker build -t=${IMG}:${TAG_RPI} armv7
	@ docker push ${IMG}:${TAG_RPI}

build-cross-rpi:
	@ docker build \
		--build-arg RPI_HOST=pi@192.168.1.11 \
		-t=${IMG}:${TAG_RPI} amd64
	@ docker push ${IMG}:${TAG_UBUNTU}

IMG := mustafatekeli/qtbuilder
TAG_RPI := 1-rpi

.PHONY: build-rpi

build-rpi:
	@ docker build -t=${IMG}:${TAG_RPI} armv7
	@ docker push ${IMG}:${TAG_RPI}

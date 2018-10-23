IMG := mustafatekeli/qtbuilder
TAG_RPI := qt5.11.2-rpi
TAG_UBUNTU := qt5.11.2-amd64

.PHONY: build-rpi, build-cross-rpi

build-rpi:
	@ docker build -t=${IMG}:${TAG_RPI} armv7
	@ docker push ${IMG}:${TAG_RPI}

build-cross-rpi:
	@ rm -rf amd64/.ssh
	@ mkdir amd64/.ssh
	@ cp ${SSH_KEY_FILE} ./amd64/.ssh/id_rsa
	@ docker build -t=${IMG}:${TAG_UBUNTU} amd64 \
		--build-arg RPI_HOST=${RPI_HOST}
	@ docker push ${IMG}:${TAG_UBUNTU}
	@ rm -rf amd64/.ssh

QT_VERSION_MAJOR := 5.12
QT_VERSION_MINOR := 4
IMG := mustafatekeli/qtbuilder
TAG_RPI := rpi-base-${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}-1
TAG_UBUNTU := amd64-rpi-cross-compile-base-${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}-1

.PHONY: build-rpi, build-cross-rpi, clean, push-cross-rpi

clean:
	@ rm -rf amd64/.ssh

build-rpi:
	@ docker build -t=${IMG}:${TAG_RPI} armv7
	@ docker push ${IMG}:${TAG_RPI} \
		--build-arg QT_VERSION_MAJOR=${QT_VERSION_MAJOR} \
		--build-arg QT_VERSION_MINOR=${QT_VERSION_MINOR}

build-cross-rpi: clean
	@ mkdir amd64/.ssh
	@ cp ${SSH_KEY_FILE} ./amd64/.ssh/id_rsa
	@ docker build -t=${IMG}:${TAG_UBUNTU} amd64 \
		--build-arg QT_VERSION_MAJOR=${QT_VERSION_MAJOR} \
		--build-arg QT_VERSION_MINOR=${QT_VERSION_MINOR} \
		--build-arg RPI_HOST=${RPI_HOST}
	@ make clean

push-cross-rpi:
	@ docker push ${IMG}:${TAG_UBUNTU}

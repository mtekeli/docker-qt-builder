QT_VERSION_MAJOR := 5.15
QT_VERSION_MINOR := 1
IMG := mustafatekeli/qtbuilder
TAG_RPI := rpi-base-${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}-1
TAG_UBUNTU := amd64-rpi-cross-compile-base-${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}-1

.PHONY: build-rpi, build-cross-rpi, run-cross-rpi, clean, push-rpi, push-cross-rpi

clean:
	@ rm -rf amd64/.ssh

build-rpi:
	@ docker build -t=${IMG}:${TAG_RPI} armv7 \
		--build-arg QT_VERSION_MAJOR=${QT_VERSION_MAJOR} \
		--build-arg QT_VERSION_MINOR=${QT_VERSION_MINOR}	
build-cross-rpi: clean
	@ docker build -t=${IMG}:${TAG_UBUNTU} amd64 \
		--build-arg QT_VERSION_MAJOR=${QT_VERSION_MAJOR} \
		--build-arg QT_VERSION_MINOR=${QT_VERSION_MINOR}
	@ make clean

run-cross-rpi:
	@ docker run -it --workdir=//root/raspi ${IMG}:${TAG_UBUNTU}

push-rpi:
        @ docker push ${IMG}:${TAG_RPI}

push-cross-rpi:
	@ docker push ${IMG}:${TAG_UBUNTU}

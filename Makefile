IMG := mustafatekeli/qtbuilder
TAG_RPI := rpi-base-5.12.3-1
TAG_UBUNTU := amd64-rpi-cross-compile-base-5.12.3-1

.PHONY: build-rpi, build-cross-rpi, clean, push-cross-rpi

clean:
	@ rm -rf amd64/.ssh

#clean-docker-images:
	#@ docker rm ${docker ps -q -f 'status=exited'}
 	#@ docker rmi ${docker images -q -f 'dangling=true'}

build-rpi:
	@ docker build -t=${IMG}:${TAG_RPI} armv7
	@ docker push ${IMG}:${TAG_RPI}

build-cross-rpi: clean
	@ mkdir amd64/.ssh
	@ cp ${SSH_KEY_FILE} ./amd64/.ssh/id_rsa
	@ docker build -t=${IMG}:${TAG_UBUNTU} amd64 \
		--build-arg RPI_HOST=${RPI_HOST}
	@ make clean

push-cross-rpi:
	@ docker push ${IMG}:${TAG_UBUNTU}

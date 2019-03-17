IMG := mustafatekeli/qtbuilder
TAG_RPI := qt5.12.2-rpi
TAG_UBUNTU := qt5.12.2-amd64-rpi-cross-compile

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

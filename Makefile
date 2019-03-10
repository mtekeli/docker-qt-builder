IMG := mustafatekeli/qtbuilder
TAG_RPI := qt5.12.1-rpi
TAG_UBUNTU := qt5.12.1-amd64

.PHONY: build-rpi, build-cross-rpi, clean, clean-docker-images

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
	@ docker push ${IMG}:${TAG_UBUNTU}

ARG RPI_HOST
ARG RPI_VER
ARG RPI_DIR=/root/raspi
ARG DEV_BINS=${RPI_DIR}/qt5pi
ARG HOST_BINS=${RPI_DIR}/qt5
ARG TOOLS_DIR=${RPI_DIR}/tools
ARG TOOL_DIR=${RPI_DIR}/tool
ARG SYS_ROOT=${RPI_DIR}/sysroot

FROM ubuntu:18.04 as intermediate
LABEL maintainer="Mustafa Tekeli <mustafatekeli.mt@gmail.com>"

RUN apt-get update && \
	apt-get install -y \
	build-essential \
	curl \
	git \
	python \
	rsync \
	wget \ 
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ARG RPI_HOST
ARG RPI_VER
ARG RPI_DIR
ARG DEV_BINS
ARG HOST_BINS
ARG SYS_ROOT
ARG TOOLS_DIR
ARG TOOL_DIR
ARG TOOLS_URL=https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/armv8l-linux-gnueabihf/gcc-linaro-6.5.0-2018.12-x86_64_armv8l-linux-gnueabihf.tar.xz

RUN echo ${RPI_VER}

# copy over the ssh profile to connect to rpi
RUN rm -rf /root/.ssh/id_rsa
COPY .ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa
COPY qmake.conf ${RPI_DIR}/qmake.conf
RUN cat ${RPI_DIR}/qmake.conf

# make sure your domain is accepted
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan ${RPI_HOST} >> /root/.ssh/known_hosts

# uncomment deb-src to have access to dev packages
RUN ssh pi@${RPI_HOST} 'sudo sed -i '/deb-src/s/^#//g' /etc/apt/sources.list'

# install required libraries
RUN ssh pi@${RPI_HOST} 'sudo apt-get update'
RUN ssh pi@${RPI_HOST} 'sudo apt-get build-dep qt4-x11 -y'
RUN ssh pi@${RPI_HOST} 'sudo apt-get build-dep libqt5gui5 -y'
RUN ssh pi@${RPI_HOST} 'sudo apt-get install libudev-dev libinput-dev libts-dev libxcb-xinerama0-dev libxcb-xinerama0 -y'

# prepare our target directory
RUN ssh pi@${RPI_HOST} 'sudo mkdir -p /usr/local/qt5pi'
RUN ssh pi@${RPI_HOST} 'sudo chown pi:pi /usr/local/qt5pi'

# create a sysroot
RUN	mkdir -p ${SYS_ROOT}/usr ${SYS_ROOT}/opt
RUN rsync -avz --rsync-path="sudo rsync" pi@${RPI_HOST}:/lib ${SYS_ROOT}
RUN rsync -avz --rsync-path="sudo rsync" pi@${RPI_HOST}:/usr/lib ${SYS_ROOT}/usr
RUN rsync -avz --rsync-path="sudo rsync" pi@${RPI_HOST}:/usr/include ${SYS_ROOT}/usr
RUN rsync -avz --rsync-path="sudo rsync" pi@${RPI_HOST}:/opt/vc ${SYS_ROOT}/opt

# adjust symlinks to be relative
RUN cd ${RPI_DIR} \
	&& wget https://raw.githubusercontent.com/Kukkimonsuta/rpi-buildqt/master/scripts/utils/sysroot-relativelinks.py \
	&& chmod +x sysroot-relativelinks.py \
	&& python ./sysroot-relativelinks.py ${SYS_ROOT}

# prepare cross-compile toolchain
RUN cd ${RPI_DIR} \
	&& git clone https://github.com/raspberrypi/tools -b master --depth=1 \
	&& ls -l

ENV QT_VERSION_MAJOR     5.12
ENV QT_VERSION           5.12.1
ENV QT_DIST              /usr/local/Qt-${QT_VERSION}
ENV QT_BASE_SRC          http://download.qt.io/official_releases/qt/${QT_VERSION_MAJOR}/${QT_VERSION}/submodules/qtbase-everywhere-src-${QT_VERSION}.tar.xz
ENV QT_BASE_DIR          ${RPI_DIR}/qtbase-everywhere-src-${QT_VERSION}

RUN cd ${RPI_DIR} \
	&& curl -sSL $QT_BASE_SRC | tar xJ

# rpi3 qmake.conf fix
RUN cat ${RPI_DIR}/qmake.conf
RUN cat ${RPI_DIR}/qtbase-everywhere-src-${QT_VERSION}/mkspecs/devices/linux-rasp-pi3-g++/qmake.conf
RUN rm ${RPI_DIR}/qtbase-everywhere-src-${QT_VERSION}/mkspecs/devices/linux-rasp-pi3-g++/qmake.conf
RUN cp ${RPI_DIR}/qmake.conf ${RPI_DIR}/qtbase-everywhere-src-${QT_VERSION}/mkspecs/devices/linux-rasp-pi3-g++/
RUN cat ${RPI_DIR}/qtbase-everywhere-src-${QT_VERSION}/mkspecs/devices/linux-rasp-pi3-g++/qmake.conf

RUN cd ${QT_BASE_DIR} \
	&& pwd \
	&& ls -lah \
	&& ./configure -release -opengl es2 -device linux-rasp-pi3-g++ -device-option CROSS_COMPILE=${TOOLS_DIR}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf- -sysroot ${SYS_ROOT} -opensource -confirm-license -make libs -prefix /usr/local/qt5pi -extprefix ${DEV_BINS} -hostprefix ${HOST_BINS} -no-use-gold-linker -no-gbm -v
	#&& ./configure -release -opengl es2 -device linux-rasp-pi3-g++ -device-option CROSS_COMPILE=${TOOLS_DIR}/gcc-linaro-6.5.0-2018.12-x86_64_armv8l-linux-gnueabihf/bin/armv8l-linux-gnueabihf- -sysroot ${SYS_ROOT} -opensource -confirm-license -make libs -prefix /usr/local/qt5pi -extprefix ${DEV_BINS} -hostprefix ${HOST_BINS} -no-use-gold-linker -no-gbm

RUN cd ${QT_BASE_DIR} \
	&& make -j4

RUN cd ${QT_BASE_DIR} \
	&& make install

# deploy Qt to the device
RUN cd ${RPI_DIR} \
	&& rsync -avz qt5pi pi@${RPI_HOST}:/usr/local


FROM ubuntu:18.04

ARG RPI_DIR
ARG DEV_BINS
ARG HOST_BINS
ARG TOOLS_DIR
ARG TOOL_DIR

RUN mkdir -p ${RPI_DIR}
RUN mkdir -p ${TOOL_DIR}

# copy the repository form the previous image
COPY --from=intermediate ${DEV_BINS} ${DEV_BINS}
COPY --from=intermediate ${HOST_BINS} ${HOST_BINS}
COPY --from=intermediate ${TOOLS_DIR}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64 ${TOOL_DIR}

RUN cd ${RPI_DIR} \
	&& ls -lah \
	&& ls -lah ${DEV_BINS} \
	&& ls -lah ${HOST_BINS} \
	&& ls -lah ${TOOL_DIR}

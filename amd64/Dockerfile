ARG RPI_HOST
ARG RPI_DIR=/root/raspi
ARG DEV_BINS=${RPI_DIR}/qt5pi
ARG HOST_BINS=${RPI_DIR}/qt5
ARG TOOLS_DIR=${RPI_DIR}/tools
ARG TOOL_DIR=${RPI_DIR}/tool
ARG SYS_ROOT=${RPI_DIR}/sysroot

FROM ubuntu:16.04 as intermediate
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
ARG RPI_DIR
ARG DEV_BINS
ARG HOST_BINS
ARG SYS_ROOT
ARG TOOLS_DIR
ARG TOOL_DIR

# copy over the ssh profile to connect to rpi
RUN rm -rf /root/.ssh/id_rsa
COPY .ssh/id_rsa /root/.ssh/id_rsa
RUN chmod 400 /root/.ssh/id_rsa

# make sure your domain is accepted
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan ${RPI_HOST} >> /root/.ssh/known_hosts

# create a sysroot
RUN mkdir -p ${RPI_DIR} \
	&& cd ${RPI_DIR} \
	&& rm -rf ${SYS_ROOT}/usr \
	&& rm -rf ${SYS_ROOT}/opt \
	&& mkdir ${SYS_ROOT} ${SYS_ROOT}/usr ${SYS_ROOT}/opt \
	&& ls -lah \
	&& rsync -avz pi@${RPI_HOST}:/lib ${SYS_ROOT} \
	&& rsync -avz pi@${RPI_HOST}:/usr/include ${SYS_ROOT}/usr \
	&& rsync -avz pi@${RPI_HOST}:/usr/lib ${SYS_ROOT}/usr \
	&& rsync -avz pi@${RPI_HOST}:/opt/vc ${SYS_ROOT}/opt

# adjust symlinks to be relative
RUN cd ${RPI_DIR} \
	&& wget https://raw.githubusercontent.com/riscv/riscv-poky/priv-1.10/scripts/sysroot-relativelinks.py \
	&& chmod +x sysroot-relativelinks.py \
	&& python ./sysroot-relativelinks.py ${SYS_ROOT}

# prepare cross-compile toolchain
RUN cd ${RPI_DIR} \
	&& ls -lah \
	&& git clone https://github.com/raspberrypi/tools -b master --depth=1

RUN mkdir -p ${TOOL_DIR} \
	&& cp -r ${TOOLS_DIR}/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64 ${TOOL_DIR}

ENV QT_VERSION_MAJOR     5.11
ENV QT_VERSION           5.11.3
ENV QT_DIST              /usr/local/Qt-${QT_VERSION}
ENV QT_BASE_SRC          http://download.qt.io/official_releases/qt/${QT_VERSION_MAJOR}/${QT_VERSION}/submodules/qtbase-everywhere-src-${QT_VERSION}.tar.xz
ENV QT_BASE_DIR          ${RPI_DIR}/qtbase-everywhere-src-${QT_VERSION}

RUN cd ${RPI_DIR} \
	&& curl -sSL $QT_BASE_SRC | tar xJ

RUN cd ${QT_BASE_DIR} \
	&& bash ./configure --help

RUN cd ${QT_BASE_DIR} \
	&& pwd \
	&& ls -lah \
	&& ./configure -release -opengl es2 -device linux-rasp-pi-g++ -device-option CROSS_COMPILE=${TOOL_DIR}/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf- -sysroot ${SYS_ROOT} -opensource -confirm-license -make libs -prefix /usr/local/qt5pi -extprefix ${DEV_BINS} -hostprefix ${HOST_BINS} -v -no-use-gold-linker -no-gbm

RUN cd ${QT_BASE_DIR} \
	&& make

RUN cd ${QT_BASE_DIR} \
	&& make install

# deploy Qt to the device
RUN cd ${RPI_DIR} \
	&& rsync -avz qt5pi pi@${RPI_HOST}:/usr/local


FROM ubuntu:16.04

ARG RPI_DIR
ARG DEV_BINS
ARG HOST_BINS
ARG TOOL_DIR

RUN mkdir -p ${RPI_DIR}

# copy the repository form the previous image
COPY --from=intermediate ${DEV_BINS} ${DEV_BINS}
COPY --from=intermediate ${HOST_BINS} ${HOST_BINS}
COPY --from=intermediate ${TOOL_DIR} ${TOOL_DIR}

RUN cd ${RPI_DIR} \
	&& ls -lah \
	&& ls -lah ${DEV_BINS} \
	&& ls -lah ${HOST_BINS} \
	&& ls -lah ${TOOL_DIR}

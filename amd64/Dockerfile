FROM ubuntu:16.04 as intermediate
MAINTAINER Mustafa Tekeli <mustafatekeli.mt@gmail.com>

RUN apt-get update && \
	apt-get install -y \
    	build-essential \
        curl \
        git \
        libc-dev \
        python \
        rsync \
    	wget \ 
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG RPI_HOST
RUN echo "$RPI_HOST"

# add credentials on build
ARG SSH_PRIVATE_KEY
RUN echo "$SSH_PRIVATE_KEY"

ENV RPI_DIR 			/root/raspi
ENV QT_VERSION_MAJOR	5.11
ENV QT_VERSION 			5.11.2
ENV QT_DIST 			/usr/local/Qt-"$QT_VERSION"
ENV QT_BASE_SRC 		http://download.qt.io/official_releases/qt/"$QT_VERSION_MAJOR"/"$QT_VERSION"/submodules/qtbase-everywhere-src-"$QT_VERSION".tar.xz
ENV QT_BASE_DIR			"$RPI_DIR"/qtbase-everywhere-src-"$QT_VERSION"
ENV SYS_ROOT			"$RPI_DIR"/sysroot
ENV TOOLS_DIR			"$RPI_DIR"/tools
ENV DEV_BINS			"$RPI_DIR"/qt5pi
ENV HOST_BINS			"$RPI_DIR"/qt5

COPY .ssh/id_rsa /root/.ssh/id_rsa
RUN cat /root/.ssh/id_rsa

# make sure your domain is accepted
RUN touch /root/.ssh/known_hosts
RUN ssh-keyscan 192.168.1.7 >> /root/.ssh/known_hosts

# create a sysroot
RUN mkdir -p "$RPI_DIR" \
	&& cd "$RPI_DIR" \
	&& mkdir "$SYS_ROOT" "$SYS_ROOT"/usr "$SYS_ROOT"/opt \
	&& ls -lah \
	&& rsync -avz "$RPI_HOST":/lib "$SYS_ROOT" \
	&& rsync -avz "$RPI_HOST":/usr/include "$SYS_ROOT"/usr \
	&& rsync -avz "$RPI_HOST":/usr/lib "$SYS_ROOT"/usr \
	&& rsync -avz "$RPI_HOST":/opt/vc "$SYS_ROOT"/opt

# adjust symlinks to be relative
RUN cd "$RPI_DIR" \
	&& wget https://raw.githubusercontent.com/riscv/riscv-poky/priv-1.10/scripts/sysroot-relativelinks.py \
	&& chmod +x sysroot-relativelinks.py \
	&& python ./sysroot-relativelinks.py "$SYS_ROOT"

# prepare cross-compile toolchain
RUN cd "$RPI_DIR" \
	&& ls -lah \
	&& git clone https://github.com/raspberrypi/tools \
	&& ls -lah "$TOOLS_DIR"/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf-*

RUN cd "$RPI_DIR" \
	&& curl -sSL $QT_BASE_SRC | tar xJ

RUN cd "$QT_BASE_DIR" \
	&& pwd \
	&& ls -lah \
	&& bash ./configure --help

RUN cd "$QT_BASE_DIR" \
	&& pwd \
	&& ls -lah \
	&& ./configure -release -opengl es2 -device linux-rasp-pi-g++ -device-option CROSS_COMPILE="$TOOLS_DIR"/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin/arm-linux-gnueabihf- -sysroot "$SYS_ROOT" -opensource -confirm-license -make libs -prefix /usr/local/qt5pi -extprefix "$DEV_BINS" -hostprefix "$HOST_BINS" -v -no-use-gold-linker -no-gbm

RUN cd "$QT_BASE_DIR" \
	&& make

RUN cd "$QT_BASE_DIR" \
	&& make install

# deploy Qt to the device
RUN cd "$RPI_DIR" \
	&& rsync -avz qt5pi "$RPI_HOST":/usr/local


FROM ubuntu:18.10

RUN mkdir -p /root/raspi \
	&& cd /root/raspi \
	&& ls -lah \
	&& echo ${RPI_HOST1} \
	&& echo "$DEV_BINS" \
	&& echo "$HOST_BINS"

# copy the repository form the previous image
COPY --from=intermediate /root/raspi/qt5pi /root/raspi/qt5pi
COPY --from=intermediate /root/raspi/qt5 /root/raspi/qt5

RUN cd /root/raspi \
	&& ls -lah \
	&& ls -lah ./qt5pi \
	&& ls -lah ./qt5



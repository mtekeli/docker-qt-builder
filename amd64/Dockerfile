FROM ubuntu:18.04
MAINTAINER Mustafa Tekeli <mustafatekeli.mt@gmail.com>

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
RUN echo "$RPI_HOST"

# prepare cross-compile toolchain
RUN mkdir ~/raspi \
	&& cd ~/raspi \
	&& git clone https://github.com/raspberrypi/tools

# create a sysroot
RUN mkdir sysroot sysroot/usr sysroot/opt \
	&& rsync -avz "$RPI_HOST":/lib sysroot \
	&& rsync -avz "$RPI_HOST":/usr/include sysroot/usr \
	&& rsync -avz "$RPI_HOST":/usr/lib sysroot/usr \
	&& rsync -avz "$RPI_HOST":/opt/vc sysroot/opt

# adjust symlinks to be relative
RUN wget https://raw.githubusercontent.com/riscv/riscv-poky/priv-1.10/scripts/sysroot-relativelinks.py \
	&& chmod +x sysroot-relativelinks.py \
	&& ./sysroot-relativelinks.py sysroot

ENV QT_VERSION_MAJOR 5.11
ENV QT_VERSION 5.11.2

ENV QT_DIST /usr/local/Qt-"$QT_VERSION"
ENV QT_BASE_SRC http://download.qt.io/official_releases/qt/"$QT_VERSION_MAJOR"/"$QT_VERSION"/submodules/qtbase-everywhere-src-"$QT_VERSION".tar.xz
ENV QT_BASE_DIR /qtbase-everywhere-src-"$QT_VERSION"

RUN curl -sSL $QT_BASE_SRC | tar xJ \
    && cd $QT_BASE_DIR \
    && bash ./configure --help \
    && bash ./configure -release -opengl es2 -device linux-rasp-pi3-g++ -device-option CROSS_COMPILE=~/raspi/tools/ \
    arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin/arm-linux-gnueabihf- -sysroot ~/raspi/sysroot -opensource -confirm-license -make libs -prefix \
    /usr/local/qt5pi -extprefix ~/raspi/qt5pi -hostprefix ~/raspi/qt5 -v -no-use-gold-linker -no-gbm \
    && make \
    && make install

# deploy Qt to the device
RUN rsync -avz qt5pi "$RPI_HOST":/usr/local

#ENV PATH $QT_DIST/bin:$PATH

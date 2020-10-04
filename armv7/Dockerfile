ARG QT_VERSION_MAJOR
ARG QT_VERSION_MINOR
ARG QT_VERSION=${QT_VERSION_MAJOR}.${QT_VERSION_MINOR}

FROM resin/rpi-raspbian:stretch
LABEL maintainer="Mustafa Tekeli mustafatekeli.mt@gmail.com"

ARG QT_VERSION_MAJOR
ARG QT_VERSION_MINOR
ARG QT_VERSION

RUN apt-get update && \
	apt-get install -y \
    	build-essential \
        curl \
    	wget \ 
    	libgl1-mesa-dev \
		libglu1-mesa-dev \
		libegl1-mesa \
		libegl1-mesa-dev \
        libpng-dev \ 
    	libfontconfig1-dev \
    	libdbus-1-dev \
    	libfreetype6-dev \
    	libudev-dev \
    	libicu-dev \
    	libsqlite3-dev \
    	libxslt1-dev \
    	libssl-dev \
    	libasound2-dev \
    	libavcodec-dev \
    	libavformat-dev \
    	libswscale-dev \
    	libgstreamer0.10-dev \
    	libgstreamer-plugins-base0.10-dev \
    	gstreamer-tools \
    	gstreamer0.10-plugins-good \
    	#gstreamer0.10-plugins-bad \
    	libraspberrypi-dev \
    	libpulse-dev \
    	libx11-dev \
    	libglib2.0-dev \
        libtiff-dev \
        libjpeg62-turbo-dev \
        libjpeg-dev \
    	libcups2-dev \
        libcupsimage2-dev \
    	freetds-dev \
    	libsqlite0-dev \
    	libpq-dev \
    	libiodbc2-dev \
    	#libmysqlclient-dev \
    	firebird-dev \
    	libgst-dev \
    	libxext-dev \
    	libxcb1 \
    	libxcb1-dev \
    	libx11-xcb1 \
    	libx11-xcb-dev \
    	libxcb-keysyms1 \
    	libxcb-keysyms1-dev \
    	libxcb-image0 \
    	libxcb-image0-dev \
    	libxcb-shm0 \
    	libxcb-shm0-dev \
    	libxcb-icccm4 \
    	libxcb-icccm4-dev \
    	libxcb-sync1 \
    	libxcb-sync-dev \
    	libxcb-render-util0 \
    	libxcb-render-util0-dev \
    	libxcb-xfixes0-dev \
    	libxrender-dev \
    	libxcb-shape0-dev \
    	libxcb-randr0-dev \
    	libxcb-glx0-dev \
    	libxi-dev \
    	libdrm-dev \
    	libssl-dev \
    	libxcb-xinerama0 \
    	libxcb-xinerama0-dev \   
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV QT_DIST /usr/local/Qt-"$QT_VERSION"
ENV QT_BASE_SRC http://download.qt.io/official_releases/qt/"$QT_VERSION_MAJOR"/"$QT_VERSION"/submodules/qtbase-everywhere-src-"$QT_VERSION".tar.xz
ENV QT_BASE_DIR /qtbase-everywhere-src-"$QT_VERSION"

RUN curl -sSL $QT_BASE_SRC | tar xJ \
    && cd $QT_BASE_DIR \
    && bash ./configure --help \
    && bash ./configure -v -no-pch -opensource -confirm-license \
       -no-harfbuzz -openssl-linked -qt-pcre -no-dbus -nomake tools \
       -no-xkbcommon-evdev -no-xinput2 -no-xcb-xlib -no-glib -qt-xcb -no-compile-examples -nomake examples \
       -no-gif -qt-doubleconversion -no-gtk \
    && make \
    && make install

ENV PATH $QT_DIST/bin:$PATH




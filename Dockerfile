FROM nvcr.io/nvidia/l4t-base:r32.4.4

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y \
    cmake \
    libprotobuf-dev \
    protobuf-compiler \
    wget \
    unzip \
    autoconf \
    automake \
    libtool \
    build-essential \
    pkg-config \
    python-setuptools \
    python-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libgtk2.0-dev \
    qt5-default \
    libcanberra-gtk-module \
    libcanberra-gtk3-module \
    python-opencv \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Install gstreamer packages, might be too much though
RUN apt-get update -qq && apt-get install -y \
    libgstreamer1.0-0 \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    gstreamer1.0-plugins-ugly \
    gstreamer1.0-libav \
    gstreamer1.0-doc \
    gstreamer1.0-tools \
    libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade setuptools pip
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# Build OpenCV 4.5.2 with Gstreamer
RUN cd ~/ && \
    wget -O opencv.zip https://github.com/opencv/opencv/archive/4.5.2.zip && \
    wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/4.5.2.zip && \
    unzip opencv.zip && \
    unzip opencv_contrib.zip && \
    mv opencv-4.5.2 opencv && \
    mv opencv_contrib-4.5.2 opencv_contrib && \
    cd opencv && \
    mkdir build && \
    cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=/usr/local \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D INSTALL_C_EXAMPLES=OFF \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D WITH_CUDA=ON \
        -D WITH_CUDNN=ON \
        -D OPENCV_DNN_CUDA=ON \
        -D ENABLE_FAST_MATH=1 \
        -D CUDA_FAST_MATH=1 \
        -D CUDA_ARCH_BIN=5.3 \
        -D WITH_CUBLAS=1 \
        -D WITH_GSTREAMER=ON \
        -D WITH_GSTREAMER_0_10=OFF \
        -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib/modules \
        -D HAVE_opencv_python3=ON \
        -D PYTHON_EXECUTABLE=/usr/bin/python3 \
        -D BUILD_EXAMPLES=ON ..

RUN cd ~/opencv/build/ && \
    make -j $(($(nproc) + 1)) && \
    make install

RUN cd ~/opencv/build/ && \
    ldconfig

WORKDIR /home/nano

#!/usr/bin/env bash
set -e
. ../../setCompilePath.sh
export MEDIAINFO_ROOT="$(pwd)"
export BUILD_PATH="$(pwd)/build"
export CFLAGS="${CFLAGS} -I$(pwd)/build/include -static"
export LDFLAGS="${LDFLAGS} -L$(pwd)/build/lib"
export CPPFLAGS="${CPPFLAGS} -I$(pwd)/build/include"

##compile zlib
if [ ! -d zlib-1.2.11 ]
then
  wget https://zlib.net/zlib-1.2.11.tar.gz
  tar xf zlib-1.2.11.tar.gz
fi
cd zlib-1.2.11
./configure --prefix=$BUILD_PATH --static
make clean
make
make install
cd $MEDIAINFO_ROOT

##compile zenlib
if [ ! -d ZenLib ]
then
  git clone https://github.com/MediaArea/ZenLib.git
fi
cd ZenLib/Project/GNU/Library
./autogen.sh
./configure --enable-static=yes --enable-shared=no --host=mipsel-linux --target=mipsel-linux --prefix=$BUILD_PATH
make clean
make
make install
cd $MEDIAINFO_ROOT

##Compile mediainfo
if [ ! -d MediaInfoLib ]
then
  git clone https://github.com/MediaArea/MediaInfoLib.git
fi
cd MediaInfoLib/Project/GNU/Library
./autogen.sh
./configure --enable-static=yes --enable-shared=no --host=mipsel-linux --target=mipsel-linux --prefix=$BUILD_PATH
make clean
make
make install
cd $MEDIAINFO_ROOT

#####compile mediainfo

if [ ! -d MediaInfo ]
then
  git clone https://github.com/MediaArea/MediaInfo.git
fi
cd MediaInfo/Project/GNU/CLI
./autogen.sh
./configure --enable-static --enable-staticlibs --host=mipsel-linux --target=mipsel-linux --prefix=$BUILD_PATH
make clean
make
make install

cd $MEDIAINFO_ROOT
cp build/bin/mediainfo ${INSTALLDIR}/bin/

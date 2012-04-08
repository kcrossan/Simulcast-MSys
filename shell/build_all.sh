#!/bin/sh

PREFIX="$SYSTEMDRIVE/msys/mingw"
CUR_DIR=$PWD

function change_title()
{
	echo -ne "\033]0;MINGW32: $@\007"
}

#download patches
if ! ls *.patch; then
	change_title 'Downloading patches'
	wget -nd -r -np -A patch http://dev.simulcastlectures.com/env-files/bash-scripts/patches
fi

#get and extract GTK
if [[ ! -f "$PREFIX/bin/gtk-demo.exe" ]]; then
	change_title 'Downloading/Extracting GTK+'
	wget -c http://ftp.gnome.org/pub/GNOME/binaries/win32/gtk+/2.24/gtk+-bundle_2.24.8-20111122_win32.zip
	unzip -o gtk+-bundle_2.24.8-20111122_win32.zip -d $PREFIX
fi

#get x264
if ! grep -q 'Name: x264' /mingw/lib/pkgconfig/x264.pc; then
	change_title 'Building x264'
	if [[ ! -d 'x264' ]]; then
		git clone git://git.videolan.org/x264.git;
		cd x264;
	else
		cd x264;
		git pull;
	fi
	./configure --enable-shared --enable-win32thread --prefix=${PREFIX} && make && make install 
	if (($?)); then
		echo "Failed to build x264";
		exit 1;
	fi
	cd $CUR_DIR
fi

#standard flags
export CFLAGS="-O2 -mms-bitfields"
export CXXFLAGS="${CFLAGS}"
export C_INCLUDE_PATH="$SYSTEMDRIVE/msys/include;$SYSTEMDRIVE/msys/mingw/include"
export CPLUS_INCLUDE_PATH="${C_INCLUDE_PATH}"
CONF_FLAGS="--prefix=${PREFIX} --enable-shared --disable-static lt_cv_deplibs_check_method=pass_all"
MAKE_FLAGS="-j$NUMBER_OF_PROCESSORS LDFLAGS=-no-undefined"

#get pixman, required for cairo
# if ! grep -q 'Version: 0.24.0' /mingw/lib/pkgconfig/pixman-1.pc; then
	# change_title 'Building pixman'
	# if [[ ! -d 'pixman-0.24.0' ]]; then
		# wget -c http://cairographics.org/releases/pixman-0.24.0.tar.gz
		# tar -xvf pixman-0.24.0.tar.gz
	# fi
	# cd pixman-0.24.0
	# ./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	# if (($?)); then
		# echo "Failed to build pixman";
		# exit 1;
	# fi
	# cd $CUR_DIR
# fi

#update the cairo library
# if ! grep -q 'Version: 1.10.2' /mingw/lib/pkgconfig/cairo.pc; then
	# change_title 'Building Cairo'
	# if [[ ! -d 'cairo' ]]; then
		# git clone git://anongit.freedesktop.org/cairo
	# fi
	# cd cairo
	# git checkout f46ba56d5b8c54be5f0379aca204c0ce05d0f58a
	# ./autogen.sh $CONF_FLAGS && make $MAKE_FLAGS && make uninstall && make install
	# if (($?)); then
		# echo "Failed to build Cairo";
		# exit 1;
	# fi
	# cd $CUR_DIR
# fi
if ! grep -q 'Version: 1.12.0' /mingw/lib/pkgconfig/cairo.pc; then
	change_title 'Building Cairo'
	if [[ ! -d 'cairo-1.12.0' ]]; then
		wget -c http://cairographics.org/releases/cairo-1.12.0.tar.gz
		tar -xvf cairo-1.12.0.tar.gz
		sed -i 's/typedef SSIZE_T ssize_t;//' cairo-1.12.0/util/cairo-missing/cairo-missing.h
		sed -i 's/_write/__write/' cairo-1.12.0/test/any2ppm.c
	fi
	cd cairo-1.12.0
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make uninstall && make install
	if (($?)); then
		echo "Failed to build Cairo";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get the json-glib library
if ! grep -q 'Version: 0.14.2' /mingw/lib/pkgconfig/json-glib-1.0.pc; then
	change_title 'Building json-glib'
	if [[ ! -d 'json-glib-0.14.2' ]]; then
		wget -c http://ftp.acc.umu.se/pub/GNOME/sources/json-glib/0.14/json-glib-0.14.2.tar.xz
		tar -xvf json-glib-0.14.2.tar.xz
	fi
	cd json-glib-0.14.2
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build json-glib";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get libxml2
if ! grep -q 'Version: 2.7.8' /mingw/lib/pkgconfig/libxml-2.0.pc; then
	change_title 'Building libxml2'
	if [[ ! -d 'libxml2-2.7.8' ]]; then
		wget -c ftp://xmlsoft.org/libxml2/libxml2-sources-2.7.8.tar.gz
		tar -xvf libxml2-sources-2.7.8.tar.gz
	fi
	cd libxml2-2.7.8
	mv testThreadsWin32.c testThreads.c
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build libxml2";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get gettext
if ! /mingw/bin/msgfmt.exe --version | grep -q ' 0.18.1'; then
	OLD_PATH=$PATH
	export PATH=/bin:/mingw/bin
	change_title 'Building gettext'
	if [[ ! -d 'gettext-0.18.1.1' ]]; then
		wget -c http://ftp.gnu.org/gnu/gettext/gettext-0.18.1.1.tar.gz
		tar -xvf gettext-0.18.1.1.tar.gz
	fi
	cd gettext-0.18.1.1
	./configure $CONF_FLAGS --enable-threads=win32 && make $MAKE_FLAGS && make install
	if (($?)); then
		echo "Failed to build gettext";
		exit 1;
	fi
	export PATH=$OLD_PATH
	cd $CUR_DIR
fi

#get libxlst
#source get disabled because of compilation error
# if [[ ! -d 'libxslt-1.1.26' ]]; then
	# wget -c ftp://xmlsoft.org/libxslt/libxslt-1.1.26.tar.gz
	# tar -xvf libxslt-1.1.26.tar.gz
# fi
# cd libxslt-1.1.26
# ./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
# if (($?)); then
	# echo "Failed to build libxslt";
	# exit 1;
# fi
# cd $CUR_DIR
if [[ ! -f '/mingw/bin/libxslt.dll' ]]; then
	change_title 'Downloading/Extracting libxslt'
	if [[ ! -d 'libxslt-1.1.26.win32' ]]; then
		wget -c ftp://ftp.zlatkovic.com/libxml/libxslt-1.1.26.win32.zip
		unzip libxslt-1.1.26.win32.zip
	fi
	cd libxslt-1.1.26.win32
	cp -R bin include lib $PREFIX
	ln -s $PREFIX/bin/libxml2-2.dll $PREFIX/bin/libxml2.dll
	cd $CUR_DIR
fi

#get gtk-doc
if ! grep -q 'Version: 1.15' /mingw/share/pkgconfig/gtk-doc.pc; then
	change_title 'Building gtk-doc'
	if [[ ! -d 'gtk-doc-1.15' ]]; then
		wget -c http://ftp.gnome.org/pub/GNOME/sources/gtk-doc/1.15/gtk-doc-1.15.tar.bz2
		tar -xvf gtk-doc-1.15.tar.bz2
	fi
	cd gtk-doc-1.15
	patch -fR -p0 < ../gtk-doc-config.patch
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build gtk-doc";
		exit 1;
	fi
	cd $CUR_DIR
fi

#update OpenGL headers
if [[ ! -f "$PREFIX/include/GL/mesa_wgl.h" ]]; then
	change_title 'Updating OpenGL headers'
	rm $PREFIX/include/GL/gl.h $PREFIX/include/GL/glext.h
	wget -O $PREFIX/include/GL/gl.h -c http://cgit.freedesktop.org/mesa/mesa/plain/include/GL/gl.h
	wget -O $PREFIX/include/GL/glext.h -c http://www.opengl.org/registry/api/glext.h
	wget -O $PREFIX/include/GL/mesa_wgl.h -c http://cgit.freedesktop.org/mesa/mesa/plain/include/GL/mesa_wgl.h
fi

#get GLEW
if ! grep -q 'Version: 1.7.0' /mingw/lib/pkgconfig/glew.pc; then
	change_title 'Building GLEW'
	if [[ ! -d 'glew-1.7.0' ]]; then
		wget -cNt 3 http://sourceforge.net/projects/glew/files/glew/1.7.0/glew-1.7.0.tgz/download
		tar -xvf glew-1.7.0.tgz
	fi
	cd glew-1.7.0
	make && make install GLEW_DEST=$PREFIX 
	if (($?)); then
		echo "Failed to build GLEW";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get ORC
if ! grep -q 'Version: 0.4.16' /mingw/lib/pkgconfig/orc-0.4.pc; then
	change_title 'Building ORC'
	if [[ ! -d 'orc-0.4.16' ]]; then
		wget -c http://code.entropywave.com/download/orc/orc-0.4.16.tar.gz
		tar -xvf orc-0.4.16.tar.gz;
	fi
	cd orc-0.4.16
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build ORC";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get Schroedinger
if ! grep -q 'Version: 1.0.11' /mingw/lib/pkgconfig/schroedinger-1.0.pc; then
	change_title 'Building Schroedinger'
	if [[ ! -d 'schroedinger-1.0.11' ]]; then
		wget -c http://diracvideo.org/download/schroedinger/schroedinger-1.0.11.tar.gz
		tar -xvf schroedinger-1.0.11.tar.gz
		sed -i 's/ testsuite//' schroedinger-1.0.11/Makefile*
	fi
	cd schroedinger-1.0.11
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build Schroedinger";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get FAAC
if ! /mingw/bin/faac.exe | grep -q 'FAAC 1.28'; then
	change_title 'Building FAAC'
	if [[ ! -d 'faac-1.28' ]]; then
		wget -c http://downloads.sourceforge.net/faac/faac-1.28.tar.bz2
		tar -xvf faac-1.28.tar.bz2;
	fi
	cd faac-1.28
	./configure $CONF_FLAGS --with-mp4v2=no && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build FAAC";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get FAAD
#currently disabled - build error
# if [[ ! -d 'faad2-2.7' ]]; then
	# wget http://downloads.sourceforge.net/faac/faad2-2.7.tar.bz2;
	# tar -xvf faad2-2.7.tar.bz2;
# fi
# cd faad2-2.7
# ./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
# if (($?)); then
	# echo "Failed to build FAAD2";
	# exit 1;
# fi
# cd $CUR_DIR

#get mjpegtools
if ! grep -q 'Version: 2.0.0' /mingw/lib/pkgconfig/mjpegtools.pc; then
	change_title 'Downloading/Extracting mjpegtools'
	if [[ ! -f mjpegtools-2.0.0-mingw-bin.tar.bz2 ]]; then
		wget -cNt 3 http://sourceforge.net/projects/mjpeg/files/mjpegtools/2.0.0/mjpegtools-2.0.0-mingw-bin.tar.bz2/download
	fi
	tar -xvf mjpegtools-2.0.0-mingw-bin.tar.bz2 -C $PREFIX
fi

#get SDL
if ! grep -q 'Version: 1.2.15' /mingw/lib/pkgconfig/sdl.pc; then
	change_title 'Building SDL'
	if [[ ! -d 'SDL-1.2.15' ]]; then
		wget -c http://www.libsdl.org/release/SDL-1.2.15.tar.gz
		tar -xvf SDL-1.2.15.tar.gz;
	fi
	cd SDL-1.2.15
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build SDL";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get XviD
if [[ ! -f '/mingw/bin/libxvidcore.dll' ]]; then
	change_title 'Building XviD'
	if [[ ! -d 'xvidcore' ]]; then
		wget -c http://downloads.xvid.org/downloads/xvidcore-1.3.2.tar.bz2
		tar -xvf xvidcore-1.3.2.tar.bz2
	fi
	cd xvidcore/build/generic
	sed -i 's/-mno-cygwin//' configure #remove obsolete -mno-cygwin flags
	./configure $CONF_FLAGS && make && make install 
	if (($?)); then
		echo "Failed to build XviD";
		exit 1;
	fi
	mv $PREFIX/lib/xvidcore.dll $PREFIX/bin/libxvidcore.dll
	mv $PREFIX/lib/xvidcore.a $PREFIX/lib/libxvidcore.a
	cd $CUR_DIR
fi

#get LAME
if ! /mingw/bin/lame.exe 2>&1 | grep -q 'version 3.99.5'; then
	change_title 'Building LAME'
	if [[ ! -d 'lame-3.99.5' ]]; then
		wget -cNt 3 http://sourceforge.net/projects/lame/files/lame/3.99/lame-3.99.5.tar.gz/download
		tar -xvf lame-3.99.5.tar.gz;
	fi
	cd lame-3.99.5
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build LAME";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get openssl
if ! grep -q 'Version: 1.0.1' /mingw/lib/pkgconfig/openssl.pc; then
change_title 'Building OpenSSL'
	if [[ ! -d 'openssl-1.0.1' ]]; then
		wget -c http://www.openssl.org/source/openssl-1.0.1.tar.gz
		tar -xvf openssl-1.0.1.tar.gz
	fi
	cd openssl-1.0.1
	./config --prefix=${PREFIX} && make && make install 
	if (($?)); then
		echo "Failed to build openssl";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get Vala
if ! grep -q 'Version: 0.16.0' /mingw/lib/pkgconfig/libvala-0.16.pc; then
	change_title 'Building Vala'
	if [[ ! -d 'vala-0.16.0' ]]; then
		wget -c http://ftp.gnome.org/pub/GNOME/sources/vala/0.16/vala-0.16.0.tar.xz
		tar -xvf vala-0.16.0.tar.xz
	fi
	cd vala-0.16.0
	./configure $CONF_FLAGS --disable-vapigen && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build Vala";
		exit 1;
	fi
	cd $CUR_DIR
fi

# #get Graphviz
# #disabled for now, issues with regex in libgvc
# change_title 'Building Graphviz'
# if [[ ! -d 'graphviz-2.26.3' ]]; then
	# wget -c http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.26.3.tar.gz
	# tar -xvf graphviz-2.26.3.tar.gz
# fi
# cd graphviz-2.26.3
# ./autogen.sh $CONF_FLAGS CFLAGS="$CFLAGS -DWIN32" && make $MAKE_FLAGS && make install 
# if (($?)); then
	# echo "Failed to build Graphviz";
	# exit 1;
# fi
# cd $CUR_DIR

# #get Valadoc
# change_title 'Building Valadoc'
# if [[ ! -d 'valadoc' ]]; then
	# git clone git://git.gnome.org/valadoc
# fi
# cd valadoc
# ./autogen.sh $CONF_FLAGS && make $MAKE_FLAGS && make install 
# if (($?)); then
	# echo "Failed to build Valadoc";
	# exit 1;
# fi
# cd $CUR_DIR

#get libgee
if ! grep -q 'Version: 0.6.4' /mingw/lib/pkgconfig/gee-1.0.pc; then
	change_title 'Building libgee'
	if [[ ! -d 'libgee-0.6.4' ]]; then
		wget -c http://ftp.acc.umu.se/pub/GNOME/sources/libgee/0.6/libgee-0.6.4.tar.xz
		tar -xvf libgee-0.6.4.tar.xz
	fi
	cd libgee-0.6.4
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build libgee";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get ATK
if ! grep -q 'Version: 2.2.0' /mingw/lib/pkgconfig/atk.pc; then
	change_title 'Building ATK'
	if [[ ! -d 'atk-2.2.0' ]]; then
		wget -c http://ftp.gnome.org/pub/gnome/sources/atk/2.2/atk-2.2.0.tar.xz
		tar -xvf atk-2.2.0.tar.xz
	fi
	cd atk-2.2.0
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install
	if (($?)); then
		echo "Failed to build ATK";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get cogl
if ! grep -q 'Version: 1.8.2' /mingw/lib/pkgconfig/cogl-1.0.pc; then
	change_title 'Building Cogl'
	if [[ ! -d 'cogl-1.8.2' ]]; then
		wget -c http://source.clutter-project.org/sources/cogl/1.8/cogl-1.8.2.tar.xz
		tar -xvf cogl-1.8.2.tar.xz
	fi
	cd cogl-1.8.2
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install
	if (($?)); then
		echo "Failed to build Cogl";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get clutter
if ! grep -q 'Version: 1.8.4' /mingw/lib/pkgconfig/clutter-1.0.pc; then
	change_title 'Building Clutter'
	if [[ ! -d 'clutter-1.8.4' ]]; then
		wget -c http://source.clutter-project.org/sources/clutter/1.8/clutter-1.8.4.tar.xz
		tar -xvf clutter-1.8.4.tar.xz
		wget -O clutter.patch "http://bugzilla-attachments.gnome.org/attachment.cgi?id=207534&action=diff&collapsed=&context=patch&format=raw&headers=1"
	fi
	cd clutter-1.8.4
	patch -f -p1 < ../clutter.patch
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install
	if (($?)); then
		echo "Failed to build Clutter";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get intltool
#source = bad!
# if [[ ! -d 'intltool-0.41.1' ]]; then
	# wget -c http://launchpad.net/intltool/trunk/0.41.1/+download/intltool-0.41.1.tar.gz
	# tar -xvf intltool-0.41.1.tar.gz
# fi
# cd intltool-0.41.1
# ./configure $CONF_FLAGS && make $MAKE_FLAGS && make install
# cd $CUR_DIR
if ! /mingw/bin/intltool-extract --version | grep -q '0.40.4'; then
	change_title 'Downloading/Extracting intltool'
	wget -c http://ftp.acc.umu.se/pub/GNOME/binaries/win32/intltool/0.40/intltool_0.40.4-1_win32.zip
	unzip -o intltool_0.40.4-1_win32.zip -d $PREFIX
	#patch bang to point to correct perl
	sed -i -e "s|#!/opt/perl/bin/perl|#!`which perl`|" $PREFIX/bin/intltool-*
fi

#get mx
if ! grep -q 'Version: 1.1.10' /mingw/lib/pkgconfig/mx-1.0.pc; then
	change_title 'Building mx'
	if [[ ! -d 'mx-1.1.10' ]]; then
		wget -c http://git.clutter-project.org/mx/snapshot/mx-1.1.10.tar.gz
		tar -xvf mx-1.1.10.tar.gz
	fi
	cd mx-1.1.10
	./autogen.sh #this will fail during configure
	patch -f -p1 < ../mx.patch
	./configure $CONF_FLAGS --with-winsys=none && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build mx";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get libjpeg
if [[ ! -f '/mingw/bin/libjpeg-8.dll' ]]; then
	change_title 'Building libjpeg'
	if [[ ! -d 'jpegsrc.v8c' ]]; then
		wget -c http://www.ijg.org/files/jpegsrc.v8c.tar.gz
		tar -xvf jpegsrc.v8c.tar.gz
	fi
	cd jpeg-8c
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build libjpeg";
		exit 1;
	fi
	cd $CUR_DIR
	# apply libjpeg header fix - should not define INT32 since it conflicts with MINGW
	sed -e 's|typedef long INT32;||' -i $PREFIX/include/jmorecfg.h
fi

#get libopenjpeg
#Linker flags need to be adjusted to deal with Poppler's export symbol indecisiveness
#Makefiles need to be hacked in order to remove build errors
#Poppler detects without @s, but links with them
if ! grep -q 'Version: 1.4.0' /lib/pkgconfig/libopenjpeg.pc; then
	change_title 'Building libopenjpeg'
	if [[ ! -d 'openjpeg_v1_4_sources_r697' ]]; then
		wget -c http://openjpeg.googlecode.com/files/openjpeg_v1_4_sources_r697.tgz
		tar -xvf openjpeg_v1_4_sources_r697.tgz
	fi
	cd openjpeg_v1_4_sources_r697
	sed -e 's| ${wl}--enable-auto-image-base | ${wl}--enable-auto-image-base,--add-stdcall-alias |' -i configure
	./configure $CONF_FLAGS && ( make $MAKE_FLAGS || ( echo "all: " > mj2/Makefile && echo "install: " >> mj2/Makefile && echo "uninstall: " >> mj2/Makefile && echo "all: " > codec/Makefile && echo "install: " >> codec/Makefile && echo "uninstall: " >> codec/Makefile &&  make $MAKE_FLAGS ) )
	make install 
	if (($?)); then
		echo "Failed to build libopenjpeg";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get Poppler
if ! grep -q 'Version: 0.18.4' /mingw/lib/pkgconfig/poppler.pc; then
	change_title 'Building Poppler'
	if [[ ! -d 'poppler-0.18.4' ]]; then
		wget -c http://poppler.freedesktop.org/poppler-0.18.4.tar.gz
		tar -xvf poppler-0.18.4.tar.gz
	fi
	cd poppler-0.18.4
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build Poppler";
		exit 1;
	fi
	cd $CUR_DIR
fi

# #get Poppler-data
# change_title 'Building Poppler-data'
# if [[ ! -d 'poppler-data-0.4.4' ]]; then
	# wget -c http://poppler.freedesktop.org/poppler-data-0.4.4.tar.gz
	# tar -xvf poppler-data-0.4.4.tar.gz
# fi
# cd poppler-data-0.4.4
# make install prefix=$PREFIX
# if (($?)); then
	# echo "Failed to build Poppler-data";
	# exit 1;
# fi
# cd $CUR_DIR

#get libFLAC
if ! grep -q 'Version: 1.2.1' /mingw/lib/pkgconfig/flac.pc; then
	change_title 'Building libFLAC'
	if [[ ! -d 'flac-1.2.1' ]]; then
		wget -c http://sourceforge.net/projects/flac/files/flac-src/flac-1.2.1-src/flac-1.2.1.tar.gz/download
		tar -xvf flac-1.2.1.tar.gz
	fi
	cd flac-1.2.1
	patch -p1 -N < ../libflac.patch
	./configure $CONF_FLAGS && make -j$NUMBER_OF_PROCESSORS LDFLAGS="-no-undefined -lwsock32" && make install 
	if (($?)); then
		echo "Failed to build libFLAC";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get libmad
if [[ ! -f '/mingw/bin/libmad-0.dll' ]]; then
	change_title 'Building libmad'
	if [[ ! -d 'libmad-0.15.1b' ]]; then
		wget -c ftp://ftp.mars.org/pub/mpeg/libmad-0.15.1b.tar.gz
		tar -xvf libmad-0.15.1b.tar.gz
	fi
	cd libmad-0.15.1b
	patch -p1 -N < ../libmad.patch
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build libmad";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get libogg
if ! grep -q 'Version: 1.3.0' /mingw/lib/pkgconfig/ogg.pc; then
	change_title 'Building libogg'
	if [[ ! -d 'libogg-1.3.0' ]]; then
		wget -c http://downloads.xiph.org/releases/ogg/libogg-1.3.0.tar.xz
		tar -xvf libogg-1.3.0.tar.xz
	fi
	cd libogg-1.3.0
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build libogg";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get libvorbis
if ! grep -q 'Version: 1.3.3' /mingw/lib/pkgconfig/vorbis.pc; then
	change_title 'Building libvorbis'
	if [[ ! -d 'libvorbis-1.3.3' ]]; then
		wget -c http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.3.tar.xz
		tar -xvf libvorbis-1.3.3.tar.xz
	fi
	cd libvorbis-1.3.3
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build libvorbis";
		exit 1;
	fi
	cd $CUR_DIR
fi

#get libharu
if [[ ! -f '/mingw/bin/libhpdf-2-2-1.dll' ]]; then
	change_title 'Building libharu'
	if [[ ! -d 'libharu-2.2.1' ]]; then
		wget -c http://libharu.org/files/libharu-2.2.1.tar.bz2
		tar -xvf libharu-2.2.1.tar.bz2
	fi
	cd libharu-2.2.1
	./configure $CONF_FLAGS --with-zlib="$PREFIX" --without-png && make $MAKE_FLAGS && make install 
	if (($?)); then
		echo "Failed to build libharu";
		exit 1;
	fi
	cd $CUR_DIR
fi

# #get libapr
# if ! grep -q 'Version: 1.4.6' /mingw/lib/pkgconfig/apr-1.pc; then
	# change_title 'Building libapr'
	# if [[ ! -d 'apr-1.4.6' ]]; then
		# wget -c http://apache.mirrors.redwire.net/apr/apr-1.4.6.tar.bz2
		# tar -xvf apr-1.4.6.tar.bz2
	# fi
	# cd apr-1.4.6
	# ./configure $CONF_FLAGS && make $MAKE_FLAGS && make install 
	# if (($?)); then
		# echo "Failed to build libapr";
		# exit 1;
	# fi
	# cd $CUR_DIR
# fi

# #get libapr-util
# if ! grep -q 'Version: 1.4.1' /mingw/lib/pkgconfig/apr-util-1.pc; then
	# change_title 'Building libapr-util'
	# if [[ ! -d 'apr-util-1.4.1' ]]; then
		# wget -c http://apache.mirrors.redwire.net/apr/apr-util-1.4.1.tar.bz2
		# tar -xvf apr-util-1.4.1.tar.bz2
	# fi
	# cd apr-util-1.4.1
	# ./configure --with-apr=$PREFIX $CONF_FLAGS && make $MAKE_FLAGS && make install 
	# if (($?)); then
		# echo "Failed to build libapr-util";
		# exit 1;
	# fi
	# cd $CUR_DIR
# fi

# #get subversion
# if ! grep -q 'Version: 1.7.4' /mingw/lib/pkgconfig/svn.pc; then
	# change_title 'Building subversion'
	# if [[ ! -d 'subversion-1.7.4' ]]; then
		# wget -c http://www.trieuvan.com/apache/subversion/subversion-1.7.4.tar.bz2
		# tar -xvf subversion-1.7.4.tar.bz2
		# wget -c http://sqlite.org/sqlite-amalgamation-3070603.zip
		# unzip sqlite-amalgamation-3070603.zip
	# fi
	# cd subversion-1.7.4
	# sed -i 's/#include <crtdbg.h>//' subversion/libsvn_subr/cmdline.c
	# ./configure --with-sqlite=../sqlite-amalgamation-3070603/sqlite3.c $CONF_FLAGS && make $MAKE_FLAGS && make install 
	# if (($?)); then
		# echo "Failed to build subversion";
		# exit 1;
	# fi
	# cd $CUR_DIR
# fi

#get subversion
if ! /mingw/bin/svn --version | grep -q '1.7.4'; then
	change_title 'Getting subversion'
	if [[ ! -d 'svn-win32-1.7.4' ]]; then
		wget -c http://sourceforge.net/projects/win32svn/files/1.7.4/svn-win32-1.7.4.zip
		unzip svn-win32-1.7.4.zip
	fi
	cd svn-win32-1.7.4/bin && cp *.exe *.dll $PREFIX/bin
	if (($?)); then
		echo "Failed to get Subversion";
		exit 1;
	fi
	cd $CUR_DIR
fi


#get gstreamer
if ! gst-inspect-0.10 | grep -q "ffmpeg"; then
	change_title 'Building GStreamer'
	rm $PREFIX/include/MMReg.h $PREFIX/include/MSAcm.h
	wget -O $PREFIX/include/MMReg.h -c http://dev.simulcastlectures.com/env-files/include/MMReg.h
	wget -O $PREFIX/include/MSAcm.h -c http://dev.simulcastlectures.com/env-files/include/MSAcm.h
	if [[ ! -d 'gstreamer' ]]; then
		mkdir gstreamer
	fi
	cd gstreamer
	if [[ ! -f 'gstreamer_build.sh' ]]; then
		wget -c http://dev.simulcastlectures.com/env-files/bash-scripts/gstreamer_build.sh
	fi
	source gstreamer_build.sh
	if (($?)); then
		echo "Failed to build GStreamer";
		exit 1;
	fi
	cd $CUR_DIR/..
fi

if ! grep -q 'Version: 1.3.8' /mingw/lib/pkgconfig/clutter-gst-1.0.pc; then
	change_title 'Building clutter-gst'
	if [[ ! -d 'clutter-gst-1.3.8' ]]; then
		wget -c http://source.clutter-project.org/sources/clutter-gst/1.3/clutter-gst-1.3.8.tar.bz2
		tar -xvf clutter-gst-1.3.8.tar.bz2
	fi
	cd clutter-gst-1.3.8
	./configure $CONF_FLAGS && make $MAKE_FLAGS && make install
	if (($?)); then
		echo "Failed to build Clutter-Gst";
		exit 1;
	fi
	cd $CUR_DIR
fi

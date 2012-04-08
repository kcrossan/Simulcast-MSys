#!/bin/sh

#GStreamer build script
#Checks out source from Git (or updates it if already checked out);
#Applies some build patches;
#Builds each of the submodules

PREFIX="$SYSTEMDRIVE/msys/mingw"
CUR_DIR=$PWD
export CFLAGS="${CFLAGS} -O2 -mms-bitfields"
export CXXFLAGS="${CFLAGS}"
CONF_FLAGS="--prefix=${PREFIX} --enable-shared --disable-static --disable-nls lt_cv_deplibs_check_method=pass_all"
MAKE_FLAGS="-j2"

MODULES='gstreamer RELEASE-0.10.35
gst-plugins-base RELEASE-0.10.35
gst-plugins-good RELEASE-0.10.30
gst-plugins-bad RELEASE-0.10.22
gst-plugins-ugly RELEASE-0.10.18
gst-plugins-gl
gst-ffmpeg RELEASE-0.10.13
'
FOR_IFS='
'

function change_title()
{
	echo -ne "\033]0;MINGW32: $@\007"
}

if [[ $1 = "uninstall" || $1 = "clean" ]]; then
	IFS=$FOR_IFS
	for module in $MODULES; do
		unset IFS
		set -- $module
		module=$1
		echo "Uninstalling and cleaning $module"
		change_title "Uninstalling and cleaning $module"
		cd $module
		make clean
		make uninstall
		cd ..
	done
	echo
else
	#update or get source
	IFS=$FOR_IFS
	if [ $1 ]; then
		for module in $MODULES; do
			if [[ $module == *$1* ]]; then
				MODULES=$module
				break
			fi
		done
	fi
	for module in $MODULES; do
		unset IFS
		set -- $module
		module=$1
		tag=$2
		echo "Updating $module via Git"
		change_title "Updating $module via Git"
		if [[ ! -d $module ]] ; then
			git clone git://anongit.freedesktop.org/git/gstreamer/$module
		fi
		cd $module
		git reset --hard HEAD
		git pull
		if [ $tag ]; then
			git checkout $tag
		fi
		cd ..
		echo
	done
	
	#build hacks
	sed -i -e "s/CONFIGURE_DEF_OPT='--enable-maintainer-mode --enable-gtk-doc'/CONFIGURE_DEF_OPT='--enable-maintainer-mode --enable-gtk-doc --with-plugins --enable-dshowsrcwrapper --enable-dshowvideosink --enable-dshowdecwrapper --disable-gsettings --disable-apexsink'/" gst-plugins-bad/autogen.sh
	sed -i -e 's/if test \-x \$have_svn \&\& \[ \$have_svn \];/if test \-x "\$have_svn" \&\& [ "\$have_svn" ];/' -e "s/autogen_options \$@/CONFIGURE_DEF_OPT='--with-ffmpeg-extra-configure=--disable-asm'\n\nautogen_options \$@/" gst-ffmpeg/autogen.sh
	
	#build source
	IFS=$FOR_IFS
	for module in $MODULES; do
		unset IFS
		set -- $module
		module=$1
		cd $module
		echo "=================================================="
		echo "Building $module"
		echo "=================================================="
		change_title "Building $module"
		./autogen.sh -- --disable-gtk-doc --disable-debug $CONF_FLAGS
		if (($?)); then
			echo "Failed to configure $module"
			exit 1
		fi
		make clean && make $MAKE_FLAGS && make install
		if (($?)); then
			echo "Failed to make $module"
			exit 1
		fi
		cd ..
		echo
	done
fi

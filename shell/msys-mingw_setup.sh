#!/bin/sh

#MinGW install script, originally from http://www.cccp-project.net/nichorai/msys-mingw_setup.sh
#Referenced on http://www.cccp-project.net/wiki/index.php?title=Installing_MSYS-MinGW
#Modified to change the version of GCC to one that doesn't ICE when compiling libxml2
#Also added flex to the MinGW package list

prepend_mingw_url="http://sourceforge.net/projects/mingw/files/"

#needs to be downloaded first in order to properly untar packages
msys_BaseSystem_tar="
MSYS/Base/tar/tar-1.23-1/tar-1.23-1-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/tar/tar-1.23-1/tar-1.23-1-msys-1.0.13-ext.tar.lzma/download \
MSYS/Base/tar/tar-1.23-1/tar-1.23-1-msys-1.0.13-lang.tar.lzma/download \
MSYS/Base/tar/tar-1.23-1/tar-1.23-1-msys-1.0.13-lic.tar.lzma/download \
"
msys_BaseSystem_tar_old="
MSYS/Base/tar/tar-1.23-1/tar-1.23-1-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/libiconv/libiconv-1.14-1/libiconv-1.14-1-msys-1.0.17-dll-2.tar.lzma/download \
MSYS/Base/gettext/gettext-0.18.1.1-1/libintl-0.18.1.1-1-msys-1.0.17-dll-8.tar.lzma/download \
MSYS/Base/regex/regex-1.20090805-2/libregex-1.20090805-2-msys-1.0.13-dll-1.tar.lzma/download \
"

msys_BaseSystem=" \
MSYS/Base/bzip2/bzip2-1.0.6-1/bzip2-1.0.6-1-msys-1.0.17-doc.tar.lzma/download \
MSYS/Base/bzip2/bzip2-1.0.6-1/bzip2-1.0.6-1-msys-1.0.17-lic.tar.lzma/download \
MSYS/Base/bzip2/bzip2-1.0.6-1/libbz2-1.0.6-1-msys-1.0.17-dll-1.tar.lzma/download \
MSYS/Base/coreutils/coreutils-5.97-3/coreutils-5.97-3-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/coreutils/coreutils-5.97-3/coreutils-5.97-3-msys-1.0.13-ext.tar.lzma/download \
MSYS/Base/coreutils/coreutils-5.97-3/coreutils-5.97-3-msys-1.0.13-lang.tar.lzma/download \
MSYS/Base/coreutils/coreutils-5.97-3/coreutils-5.97-3-msys-1.0.13-lic.tar.lzma/download \
MSYS/Base/diffutils/diffutils-2.8.7.20071206cvs-3/diffutils-2.8.7.20071206cvs-3-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/diffutils/diffutils-2.8.7.20071206cvs-3/diffutils-2.8.7.20071206cvs-3-msys-1.0.13-lang.tar.lzma/download \
MSYS/Base/diffutils/diffutils-2.8.7.20071206cvs-3/diffutils-2.8.7.20071206cvs-3-msys-1.0.13-lic.tar.lzma/download \
MSYS/Base/gawk/gawk-3.1.7-2/gawk-3.1.7-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/gawk/gawk-3.1.7-2/gawk-3.1.7-2-msys-1.0.13-lang.tar.lzma/download \
MSYS/Base/gawk/gawk-3.1.7-2/gawk-3.1.7-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Base/gettext/gettext-0.18.1.1-1/gettext-0.18.1.1-1-msys-1.0.17-bin.tar.lzma/download \
MSYS/Base/gettext/gettext-0.18.1.1-1/gettext-0.18.1.1-1-msys-1.0.17-doc.tar.lzma/download \
MSYS/Base/gettext/gettext-0.18.1.1-1/gettext-0.18.1.1-1-msys-1.0.17-ext.tar.lzma/download \
MSYS/Base/gettext/gettext-0.18.1.1-1/gettext-0.18.1.1-1-msys-1.0.17-lic.tar.lzma/download \
MSYS/Base/gettext/gettext-0.18.1.1-1/libasprintf-0.18.1.1-1-msys-1.0.17-dll-0.tar.lzma/download \
MSYS/Base/gettext/gettext-0.18.1.1-1/libgettextpo-0.18.1.1-1-msys-1.0.17-dll-0.tar.lzma/download \
MSYS/Base/grep/grep-2.5.4-2/grep-2.5.4-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/grep/grep-2.5.4-2/grep-2.5.4-2-msys-1.0.13-lang.tar.lzma/download \
MSYS/Base/grep/grep-2.5.4-2/grep-2.5.4-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Base/gzip/gzip-1.3.12-2/gzip-1.3.12-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/gzip/gzip-1.3.12-2/gzip-1.3.12-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Base/less/less-436-2/less-436-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/less/less-436-2/less-436-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Base/libiconv/libiconv-1.14-1/libiconv-1.14-1-msys-1.0.17-bin.tar.lzma/download \
MSYS/Base/libiconv/libiconv-1.14-1/libiconv-1.14-1-msys-1.0.17-doc.tar.lzma/download \
MSYS/Base/libiconv/libiconv-1.14-1/libiconv-1.14-1-msys-1.0.17-lic.tar.lzma/download \
MSYS/Base/regex/regex-1.20090805-2/regex-1.20090805-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/regex/regex-1.20090805-2/regex-1.20090805-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Base/sed/sed-4.2.1-2/sed-4.2.1-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/sed/sed-4.2.1-2/sed-4.2.1-2-msys-1.0.13-lang.tar.lzma/download \
MSYS/Base/sed/sed-4.2.1-2/sed-4.2.1-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Base/termcap/termcap-0.20050421_1-2/termcap-0.20050421_1-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/termcap/termcap-0.20050421_1-2/termcap-0.20050421_1-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/termcap/termcap-0.20050421_1-2/termcap-0.20050421_1-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Base/xz/xz-5.0.3-1/xz-5.0.3-1-msys-1.0.17-doc.tar.lzma/download \
MSYS/Base/xz/xz-5.0.3-1/xz-5.0.3-1-msys-1.0.17-lic.tar.lzma/download \
"
msys_BaseSystem_old="
MSYS/Base/bzip2/bzip2-1.0.6-1/bzip2-1.0.6-1-msys-1.0.17-bin.tar.lzma/download \
MSYS/Base/coreutils/coreutils-5.97-3/coreutils-5.97-3-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/diffutils/diffutils-2.8.7.20071206cvs-3/diffutils-2.8.7.20071206cvs-3-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/gawk/gawk-3.1.7-2/gawk-3.1.7-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/grep/grep-2.5.4-2/grep-2.5.4-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/gzip/gzip-1.3.12-2/gzip-1.3.12-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/less/less-436-2/less-436-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/libiconv/libiconv-1.14-1/libcharset-1.14-1-msys-1.0.17-dll-1.tar.lzma/download \
MSYS/Base/sed/sed-4.2.1-2/sed-4.2.1-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/termcap/termcap-0.20050421_1-2/libtermcap-0.20050421_1-2-msys-1.0.13-dll-0.tar.lzma/download \
MSYS/Base/xz/xz-5.0.3-1/xz-5.0.3-1-msys-1.0.17-bin.tar.lzma/download \
MSYS/Base/xz/xz-5.0.3-1/liblzma-5.0.3-1-msys-1.0.17-dll-5.tar.lzma/download \
"

msys_BaseSystem_dependencies=" \
MSYS/Extension/expat/expat-2.0.1-1/libexpat-2.0.1-1-msys-1.0.13-dll-1.tar.lzma/download \
"

#separated because it is in use while running script
msys_BaseSystem_bash="
MSYS/Base/bash/bash-3.1.17-4/bash-3.1.17-4-msys-1.0.16-doc.tar.lzma/download \
MSYS/Base/bash/bash-3.1.17-4/bash-3.1.17-4-msys-1.0.16-lic.tar.lzma/download \
"
msys_BaseSystem_bash_old="
MSYS/Base/bash/bash-3.1.17-4/bash-3.1.17-4-msys-1.0.16-bin.tar.lzma/download \
"

msys_components=" \
MSYS/Extension/cvs/cvs-1.12.13-2/cvs-1.12.13-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/cvs/cvs-1.12.13-2/cvs-1.12.13-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/cvs/cvs-1.12.13-2/cvs-1.12.13-2-msys-1.0.13-lang.tar.lzma/download \
MSYS/Extension/cvs/cvs-1.12.13-2/cvs-1.12.13-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/cygutils/cygutils-1.3.4-4/cygutils-1.3.4-4-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/cygutils/cygutils-1.3.4-4/cygutils-1.3.4-4-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/cygutils/cygutils-1.3.4-4/cygutils-1.3.4-4-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/cygutils/cygutils-1.3.4-4/cygutils-dos2unix-1.3.4-4-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/file/file-5.04-1/file-5.04-1-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/file/file-5.04-1/file-5.04-1-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/file/file-5.04-1/file-5.04-1-msys-1.0.13-lic.tar.lzma/download \
MSYS/Base/file/file-5.04-1/libmagic-5.04-1-msys-1.0.13-dll-1.tar.lzma/download \
MSYS/Base/findutils/findutils-4.4.2-2/findutils-4.4.2-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/findutils/findutils-4.4.2-2/findutils-4.4.2-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/findutils/findutils-4.4.2-2/findutils-4.4.2-2-msys-1.0.13-lang.tar.lzma/download \
MSYS/Base/findutils/findutils-4.4.2-2/findutils-4.4.2-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Base/findutils/findutils-4.4.2-2/locate-4.4.2-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/groff/groff-1.20.1-2/groff-1.20.1-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/groff/groff-1.20.1-2/groff-1.20.1-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/groff/groff-1.20.1-2/groff-1.20.1-2-msys-1.0.13-ext.tar.lzma/download \
MSYS/Extension/groff/groff-1.20.1-2/groff-1.20.1-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/groff/groff-1.20.1-2/groff-1.20.1-2-msys-1.0.13-smp.tar.lzma/download \
MSYS/Extension/guile/guile-1.8.7-2/guile-1.8.7-2-msys-1.0.15-bin.tar.lzma/download \
MSYS/Extension/guile/guile-1.8.7-2/guile-1.8.7-2-msys-1.0.15-doc.tar.lzma/download \
MSYS/Extension/guile/guile-1.8.7-2/guile-1.8.7-2-msys-1.0.15-lic.tar.lzma/download \
MSYS/Extension/guile/guile-1.8.7-2/libguile-1.8.7-2-msys-1.0.15-dll-17.tar.lzma/download \
MSYS/Extension/guile/guile-1.8.7-2/libguile-1.8.7-2-msys-1.0.15-rtm.tar.lzma/download \
MSYS/Extension/inetutils/inetutils-1.7-1/inetutils-1.7-1-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/inetutils/inetutils-1.7-1/inetutils-1.7-1-msys-1.0.13-dev.tar.lzma/download \
MSYS/Extension/inetutils/inetutils-1.7-1/inetutils-1.7-1-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/inetutils/inetutils-1.7-1/inetutils-1.7-1-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/libarchive/libarchive-2.8.3-1/bsdcpio-2.8.3-1-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/libarchive/libarchive-2.8.3-1/bsdtar-2.8.3-1-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/libarchive/libarchive-2.8.3-1/libarchive-2.8.3-1-msys-1.0.13-dll-2.tar.lzma/download \
MSYS/Extension/libarchive/libarchive-2.8.3-1/libarchive-2.8.3-1-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/libarchive/libarchive-2.8.3-1/libarchive-2.8.3-1-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/lndir/lndir-1.0.1-2/lndir-1.0.1-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/lndir/lndir-1.0.1-2/lndir-1.0.1-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/lndir/lndir-1.0.1-2/lndir-1.0.1-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/m4/m4-1.4.14-1/m4-1.4.14-1-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/m4/m4-1.4.14-1/m4-1.4.14-1-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/m4/m4-1.4.14-1/m4-1.4.14-1-msys-1.0.13-lic.tar.lzma/download \
MSYS/Base/make/make-3.81-3/make-3.81-3-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/make/make-3.81-3/make-3.81-3-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/make/make-3.81-3/make-3.81-3-msys-1.0.13-lang.tar.lzma/download \
MSYS/Base/make/make-3.81-3/make-3.81-3-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/man/man-1.6f-2/man-1.6f-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/man/man-1.6f-2/man-1.6f-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/man/man-1.6f-2/man-1.6f-2-msys-1.0.13-lang.tar.lzma/download \
MSYS/Extension/man/man-1.6f-2/man-1.6f-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/mktemp/mktemp-1.6-2/mktemp-1.6-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/mktemp/mktemp-1.6-2/mktemp-1.6-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/mktemp/mktemp-1.6-2/mktemp-1.6-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/openssh/openssh-5.4p1-1/openssh-5.4p1-1-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/openssh/openssh-5.4p1-1/openssh-5.4p1-1-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/openssh/openssh-5.4p1-1/openssh-5.4p1-1-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/openssl/openssl-1.0.0-1/openssl-1.0.0-1-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/openssl/openssl-1.0.0-1/openssl-1.0.0-1-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/openssl/openssl-1.0.0-1/openssl-1.0.0-1-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/openssl/openssl-1.0.0-1/libopenssl-1.0.0-1-msys-1.0.13-dev.tar.lzma/download \
MSYS/Extension/openssl/openssl-1.0.0-1/libopenssl-1.0.0-1-msys-1.0.13-dll-100.tar.lzma/download \
MSYS/Extension/patch/patch-2.6.1-1/patch-2.6.1-1-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/patch/patch-2.6.1-1/patch-2.6.1-1-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/patch/patch-2.6.1-1/patch-2.6.1-1-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/perl/perl-5.8.8-1/perl-5.8.8-1-msys-1.0.17-bin.tar.lzma/download \
MSYS/Extension/perl/perl-5.8.8-1/perl-5.8.8-1-msys-1.0.17-doc.tar.lzma/download \
MSYS/Extension/perl/perl-5.8.8-1/perl-5.8.8-1-msys-1.0.17-html.tar.lzma/download \
MSYS/Extension/perl/perl-5.8.8-1/perl-5.8.8-1-msys-1.0.17-lic.tar.lzma/download \
MSYS/Extension/perl/perl-5.8.8-1/perl-5.8.8-1-msys-1.0.17-man.tar.lzma/download \
MSYS/Base/texinfo/texinfo-4.13a-2/texinfo-4.13a-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Base/texinfo/texinfo-4.13a-2/texinfo-4.13a-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Base/texinfo/texinfo-4.13a-2/texinfo-4.13a-2-msys-1.0.13-lang.tar.lzma/download \
MSYS/Base/texinfo/texinfo-4.13a-2/texinfo-4.13a-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/unzip/unzip-6.0-1/unzip-6.0-1-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/unzip/unzip-6.0-1/unzip-6.0-1-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/unzip/unzip-6.0-1/unzip-6.0-1-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/vim/vim-7.3-2/vim-7.3-2-msys-1.0.16-bin.tar.lzma/download \
MSYS/Extension/vim/vim-7.3-2/vim-7.3-2-msys-1.0.16-doc.tar.lzma/download \
MSYS/Extension/vim/vim-7.3-2/vim-7.3-2-msys-1.0.16-lang.tar.lzma/download \
MSYS/Extension/vim/vim-7.3-2/vim-7.3-2-msys-1.0.16-lic.tar.lzma/download \
MSYS/Extension/flex/flex-2.5.35-2/flex-2.5.35-2-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/flex/flex-2.5.35-2/flex-2.5.35-2-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/flex/flex-2.5.35-2/flex-2.5.35-2-msys-1.0.13-lang.tar.lzma/download \
MSYS/Extension/flex/flex-2.5.35-2/flex-2.5.35-2-msys-1.0.13-lic.tar.lzma/download \
"

msys_components_dependencies=" \
MSYS/Extension/bison/bison-2.4.2-1/bison-2.4.2-1-msys-1.0.13-rtm.tar.lzma/download \
MSYS/Extension/bison/bison-2.4.2-1/bison-2.4.2-1-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/bison/bison-2.4.2-1/bison-2.4.2-1-msys-1.0.13-bin.tar.lzma/download \
MSYS/Extension/bison/bison-2.4.2-1/bison-2.4.2-1-msys-1.0.13-doc.tar.lzma/download \
MSYS/Extension/bison/bison-2.4.2-1/bison-2.4.2-1-msys-1.0.13-lang.tar.lzma/download \
MSYS/Extension/crypt/crypt-1.1_1-3/libcrypt-1.1_1-3-msys-1.0.13-dll-0.tar.lzma/download \
MSYS/Extension/crypt/crypt-1.1_1-3/crypt-1.1_1-3-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/gdbm/gdbm-1.8.3-3/libgdbm-1.8.3-3-msys-1.0.13-dll-3.tar.lzma/download \
MSYS/Extension/gdbm/gdbm-1.8.3-3/gdbm-1.8.3-3-msys-1.0.13-lic.tar.lzma/download \
MSYS/msysdev/gmp/gmp-5.0.1-1/libgmp-5.0.1-1-msys-1.0.13-dll-10.tar.lzma/download \
MSYS/msysdev/gmp/gmp-5.0.1-1/gmp-5.0.1-1-msys-1.0.13-lic.tar.lzma/download \
MSYS/msysdev/libtool/libtool-2.4-1/libltdl-2.4-1-msys-1.0.15-dll-7.tar.lzma/download \
MSYS/msysdev/libtool/libtool-2.4-1/libtool-2.4-1-msys-1.0.15-lic.tar.lzma/download \
MSYS/Extension/minires/minires-1.02_1-2/libminires-1.02_1-2-msys-1.0.13-dll.tar.lzma/download \
MSYS/Extension/minires/minires-1.02_1-2/minires-1.02_1-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/popt/popt-1.15-2/libpopt-1.15-2-msys-1.0.13-dll-0.tar.lzma/download \
MSYS/Extension/popt/popt-1.15-2/popt-1.15-2-msys-1.0.13-lic.tar.lzma/download \
MSYS/Extension/zlib/zlib-1.2.5-1/zlib-1.2.5-1-msys-1.0.17-dll.tar.lzma/download \
MSYS/Extension/zlib/zlib-1.2.5-1/zlib-1.2.5-1-msys-1.0.17-lic.tar.lzma/download \
"

mingw32_components=" \
MinGW/Base/binutils/binutils-2.22/binutils-2.22-1-mingw32-bin.tar.lzma/download \
MinGW/Base/mingw-rt/mingwrt-3.20/mingwrt-3.20-mingw32-dev.tar.gz/download \
MinGW/Base/mingw-rt/mingwrt-3.20/mingwrt-3.20-mingw32-dll.tar.gz/download \
MinGW/Base/w32api/w32api-3.17/w32api-3.17-2-mingw32-dev.tar.lzma/download \
MinGW/Extension/make/make-3.82-mingw32/make-3.82-5-mingw32-bin.tar.lzma/download \
"

# also has libguile dependencies
msys_autogen=" \
MSYS/Extension/autogen/autogen-5.10.1-1/autogen-5.10.1-1-msys-1.0.15-bin.tar.lzma/download \
MSYS/Extension/autogen/autogen-5.10.1-1/autogen-5.10.1-1-msys-1.0.15-doc.tar.lzma/download \
MSYS/Extension/autogen/autogen-5.10.1-1/autogen-5.10.1-1-msys-1.0.15-lic.tar.lzma/download \
MSYS/Extension/autogen/autogen-5.10.1-1/libopts-5.10.1-1-msys-1.0.15-dll-25.tar.lzma/download \
MSYS/Extension/libxml2/libxml2-2.7.6-1/libxml2-2.7.6-1-msys-1.0.13-dll-2.tar.lzma/download \
"

mingw32_autotools=" \
MinGW/Extension/autoconf/wrapper/autoconf-10-1/autoconf-10-1-mingw32-bin.tar.lzma/download \
MinGW/Extension/autoconf/wrapper/autoconf-10-1/autoconf-10-1-mingw32-lic.tar.lzma/download \
MinGW/Extension/autoconf/autoconf2.1/autoconf2.1-2.13-4/autoconf2.1-2.13-4-mingw32-bin.tar.lzma/download \
MinGW/Extension/autoconf/autoconf2.1/autoconf2.1-2.13-4/autoconf2.1-2.13-4-mingw32-doc.tar.lzma/download \
MinGW/Extension/autoconf/autoconf2.1/autoconf2.1-2.13-4/autoconf2.1-2.13-4-mingw32-lic.tar.lzma/download \
MinGW/Extension/autoconf/autoconf2.5/autoconf2.5-2.68-1/autoconf2.5-2.68-1-mingw32-bin.tar.lzma/download \
MinGW/Extension/autoconf/autoconf2.5/autoconf2.5-2.68-1/autoconf2.5-2.68-1-mingw32-doc.tar.lzma/download \
MinGW/Extension/autoconf/autoconf2.5/autoconf2.5-2.68-1/autoconf2.5-2.68-1-mingw32-lic.tar.lzma/download \
MinGW/Extension/automake/wrapper/automake-4-1/automake-4-1-mingw32-bin.tar.lzma/download \
MinGW/Extension/automake/wrapper/automake-4-1/automake-4-1-mingw32-lic.tar.lzma/download \
MinGW/Extension/automake/automake1.11/automake1.11-1.11.1-1/automake1.11-1.11.1-1-mingw32-bin.tar.lzma/download \
MinGW/Extension/automake/automake1.11/automake1.11-1.11.1-1/automake1.11-1.11.1-1-mingw32-doc.tar.lzma/download \
MinGW/Extension/automake/automake1.11/automake1.11-1.11.1-1/automake1.11-1.11.1-1-mingw32-lic.tar.lzma/download \
MinGW/Extension/libtool/libtool-2.4-1/libtool-2.4-1-mingw32-bin.tar.lzma/download \
MinGW/Extension/libtool/libtool-2.4-1/libtool-2.4-1-mingw32-doc.tar.lzma/download \
MinGW/Extension/libtool/libtool-2.4-1/libtool-2.4-1-mingw32-lic.tar.lzma/download \
MinGW/Extension/libtool/libtool-2.4-1/libltdl-2.4-1-mingw32-dev.tar.lzma/download \
MinGW/Extension/libtool/libtool-2.4-1/libltdl-2.4-1-mingw32-dll-7.tar.lzma/download \
"

mingw32_stuff=" \
MinGW/Extension/gdb/GDB-7.3.1/gdb-7.3.1-1-mingw32-bin.tar.lzma/download \
MinGW/Base/libiconv/libiconv-1.14-2/libiconv-1.14-2-mingw32-bin.tar.lzma/download \
MinGW/Base/libiconv/libiconv-1.14-2/libiconv-1.14-2-mingw32-dev.tar.lzma/download \
MinGW/Base/libiconv/libiconv-1.14-2/libiconv-1.14-2-mingw32-dll-2.tar.lzma/download \
MinGW/Base/libiconv/libiconv-1.14-2/libiconv-1.14-2-mingw32-doc.tar.lzma/download \
MinGW/Base/libiconv/libiconv-1.14-2/libiconv-1.14-2-mingw32-lic.tar.lzma/download \
MinGW/Base/libiconv/libiconv-1.14-2/libcharset-1.14-2-mingw32-dll-1.tar.lzma/download \
"
# MinGW/Base/gettext/gettext-0.18.1.1-2/gettext-0.18.1.1-2-mingw32-bin.tar.lzma/download \
# MinGW/Base/gettext/gettext-0.18.1.1-2/gettext-0.18.1.1-2-mingw32-dev.tar.lzma/download \
# MinGW/Base/gettext/gettext-0.18.1.1-2/gettext-0.18.1.1-2-mingw32-doc.tar.lzma/download \
# MinGW/Base/gettext/gettext-0.18.1.1-2/gettext-0.18.1.1-2-mingw32-ext.tar.lzma/download \
# MinGW/Base/gettext/gettext-0.18.1.1-2/gettext-0.18.1.1-2-mingw32-lic.tar.lzma/download \
# MinGW/Base/gettext/gettext-0.18.1.1-2/libasprintf-0.18.1.1-2-mingw32-dll-0.tar.lzma/download \
# MinGW/Base/gettext/gettext-0.18.1.1-2/libgettextpo-0.18.1.1-2-mingw32-dll-0.tar.lzma/download \
# MinGW/Base/gettext/gettext-0.18.1.1-2/libintl-0.18.1.1-2-mingw32-dll-8.tar.lzma/download \
#GCC%20Version%204/Current%20Release_%20gcc-4.4.0/gcc-core-4.4.0-mingw32-dll.tar.gz/download \
#required by gettext ?

mingw32_mingwgcc=" \
GCC%20Version%204/gcc-4.5.0-1/gcc-core-4.5.0-1-mingw32-bin.tar.lzma/download \
GCC%20Version%204/gcc-4.5.0-1/gcc-c++-4.5.0-1-mingw32-bin.tar.lzma/download \
GCC%20Version%204/gcc-4.5.0-1/libgcc-4.5.0-1-mingw32-dll-1.tar.lzma/download \
GCC%20Version%204/gcc-4.5.0-1/libstdc++-4.5.0-1-mingw32-dll-6.tar.lzma/download \
GCC%20Version%204/gcc-4.5.0-1/libgomp-4.5.0-1-mingw32-dll-1.tar.lzma/download \
GCC%20Version%204/gcc-4.5.0-1/libssp-4.5.0-1-mingw32-dll-0.tar.lzma/download \
GCC%20Version%204/gcc-4.5.0-1/gcc-4.5.0-1-mingw32-doc.tar.lzma/download \
GCC%20Version%204/gcc-4.5.0-1/gcc-4.5.0-1-mingw32-lang.tar.lzma/download \
GCC%20Version%204/gcc-4.5.0-1/gcc-4.5.0-1-mingw32-lic.tar.lzma/download \
"

mingw32_mingwgcc_dependencies=" \
MinGW/mpc/mpc-0.8.1-1/libmpc-0.8.1-1-mingw32-dll-2.tar.lzma/download \
MinGW/mpc/mpc-0.8.1-1/mpc-0.8.1-1-mingw32-doc.tar.lzma/download \
MinGW/mpc/mpc-0.8.1-1/mpc-0.8.1-1-mingw32-lic.tar.lzma/download \
MinGW/mpfr/mpfr-2.4.1-1/libmpfr-2.4.1-1-mingw32-dll-1.tar.lzma/download \
MinGW/mpfr/mpfr-2.4.1-1/mpfr-2.4.1-1-mingw32-doc.tar.lzma/download \
MinGW/mpfr/mpfr-2.4.1-1/mpfr-2.4.1-1-mingw32-lic.tar.lzma/download \
MinGW/gmp/gmp-5.0.1-1/libgmp-5.0.1-1-mingw32-dll-10.tar.lzma/download \
MinGW/gmp/gmp-5.0.1-1/libgmpxx-5.0.1-1-mingw32-dll-4.tar.lzma/download \
MinGW/gmp/gmp-5.0.1-1/gmp-5.0.1-1-mingw32-doc.tar.lzma/download \
MinGW/gmp/gmp-5.0.1-1/gmp-5.0.1-1-mingw32-lic.tar.lzma/download \
MinGW/pthreads-w32/pthreads-w32-2.8.0-3/libpthread-2.8.0-3-mingw32-dll-2.tar.lzma/download \
MinGW/pthreads-w32/pthreads-w32-2.8.0-3/pthreads-w32-2.8.0-3-mingw32-doc.tar.lzma/download \
MinGW/pthreads-w32/pthreads-w32-2.8.0-3/pthreads-w32-2.8.0-3-mingw32-lic.tar.lzma/download \
"

#http://sourceforge.net/projects/mingw/files/MinGW/Base/GCC/Version3/Current%20Release_%20gcc-3.4.5-20060117-3/
#http://sourceforge.net/projects/tdm-gcc/files/
mingw32_tdmgcc=" \
http://sourceforge.net/projects/tdm-gcc/files/TDM-GCC%204.6%20series/4.6.1-tdm-1%20SJLJ/gcc-4.6.1-tdm-1-openmp.tar.lzma/download \
http://sourceforge.net/projects/tdm-gcc/files/TDM-GCC%204.6%20series/4.6.1-tdm-1%20SJLJ/gcc-4.6.1-tdm-1-core.tar.lzma/download \
http://sourceforge.net/projects/tdm-gcc/files/TDM-GCC%204.6%20series/4.6.1-tdm-1%20SJLJ/gcc-4.6.1-tdm-1-c++.tar.lzma/download \
"

mingw32_utils=" \
http://ftp.gnome.org/pub/gnome/binaries/win32/dependencies/pkg-config_0.26-1_win32.zip \
http://ftp.gnome.org/pub/gnome/binaries/win32/dependencies/pkg-config-dev_0.26-1_win32.zip \
"

win32_yasm="http://www.tortall.net/projects/yasm/releases/yasm-1.2.0-win32.exe"
win32_nasm="http://www.nasm.us/pub/nasm/releasebuilds/2.10/win32/nasm-2.10-win32.zip"
rar_cli="http://www.rarlab.com/rar/unrarw32.exe"

dx7_headers="http://www.mplayerhq.hu/MPlayer/contrib/win32/dx7headers.tgz"
mingwrt_largefile_patch="http://www.cccp-project.net/nichorai/patches/mingwrt-3.18-mingw32_file64.diff"

download_dir="${HOME}/msys_mingw_components"
msysoutput="/usr"
mingwoutput="/mingw"

download_files ()
{
  local output="$1"
  local files="${!2}"
  local base_url="$3"

  if [[ ! -d "${output}" ]]; then
    mkdir "${output}"
  fi

  for file in ${files}; do
    local filename="${file%\/download}"
	local filename=${filename##*/}
	if [[ ! -f "${output}/${filename}" ]]; then
      wget -cNt 3 -P "${output}" "${base_url}${file}"
      if [[ $? -ne 0 ]]; then
        echo "$filename did not download correctly, the script variables may be out of date."
	    exit 1
      fi
	fi
  done
}

extract_files ()
{
  local output="$1"
  local files="${!2}"

  if [[ ! -d "${output}" ]]; then
    mkdir "${output}"
  fi
  cd "${output}"

  for file in ${files}; do
    if [[ -f "${file}" ]]; then
      local fileext="${file##*.}"
      if [[ "${fileext}" == "lzma" ]]; then
        tar --lzma -xf "${file}"
      elif [[ "${fileext}" == "gz" || "${fileext}" == "tgz" ]]; then
        tar -xzf "${file}"
      elif [[ "${fileext}" == "bz2" ]]; then
        tar -xjf "${file}"
      elif [[ "${fileext}" == "zip" || "${fileext}" == "7z" ]]; then
        7za x -y "${file}" > /dev/null
      else
        echo "WARNING: File has unknown extension."
        echo "${file}"
      fi
    else
      echo "WARNING: File does not exist to extract."
      echo "${file}"
    fi
  done
  cd - > /dev/null
}

transform_links ()
{
  local input_var="$1"
  local input_val="${!1}"

  local totalvar=
  local newvar
  for file in ${input_val}; do
    newvar="${file%\/download}"  # for mingw/msys links
    totalvar+="${download_dir}/${newvar##*/} "
  done
  export "${input_var}"="${totalvar}" 
}

##Script begins##

if [[ ! -f "`which 7za`" ]]; then  # need something to initially extract .zip files
  echo "ERROR: You did not install a copy of 7za to MinGW."
  echo "Do this now."
  echo -e "\nhttp://www.7-zip.org/download.html"
  exit 1
fi

echo "Download MinGW/MSYS components now?"
read -n1 -p "[Y]es or [N]o: " keypress; echo
while [[ $keypress != "Y" && $keypress != "y" && $keypress != "N" && $keypress != "n" ]]; do
  echo "Download MinGW/MSYS components now?"
  read -n1 -p "[Y]es or [N]o: " keypress; echo
done

if [[ $keypress == "y" || $keypress == "Y" ]]; then
  if [[ -f "`which wget`" ]]; then
    echo "Downloading..."
    #downloads prepended with $prepend_mingw_url
    #mingw32_mingwgcc mingw32_mingwgcc_dependencies
    for group in msys_BaseSystem_tar msys_BaseSystem msys_BaseSystem_dependencies msys_BaseSystem_bash msys_components msys_components_dependencies msys_autogen mingw32_components mingw32_autotools mingw32_stuff; do
      download_files "${download_dir}" "${group}" "${prepend_mingw_url}"
      transform_links "${group}"
    done

    #downloads with full url
    for group in mingw32_tdmgcc mingw32_utils win32_yasm win32_nasm rar_cli dx7_headers mingwrt_largefile_patch; do
      download_files "${download_dir}" "${group}" ""
      transform_links "${group}"
    done
  else
    echo "ERROR: You did not install a copy of wget to MinGW."
    echo "Do this now."
    echo -e "\nhttp://users.ugent.be/~bpuype/wget/#download"
    exit 1
  fi
else
  for group in msys_BaseSystem_tar msys_BaseSystem msys_BaseSystem_dependencies msys_BaseSystem_bash msys_components msys_components_dependencies msys_autogen mingw32_components mingw32_autotools mingw32_stuff mingw32_tdmgcc mingw32_utils win32_yasm win32_nasm rar_cli dx7_headers mingwrt_largefile_patch mingw32_mingwgcc mingw32_mingwgcc_dependencies; do
    transform_links "${group}"
  done
fi

echo; read -s -n1 -p "Press any key to continue . . . " keypress; echo

#extract tar first, and replace old tar
echo "Installing GNU tar to MSYS..."
tempdir="/tmp/tar${RANDOM}"
extract_files "${tempdir}" msys_BaseSystem_tar
cp -rf "${tempdir}/"* "${msysoutput}"
rm -rf "${tempdir}"

#extract msys stuff
echo "Extracting MSYS components and updates..."
for group in msys_BaseSystem msys_BaseSystem_dependencies msys_BaseSystem_bash msys_components msys_components_dependencies msys_autogen; do
  extract_files "${msysoutput}" "${group}"
done

#extract mingw stuff
echo "Extracting MinGW components and updates..."
for group in mingw32_components mingw32_autotools mingw32_stuff mingw32_tdmgcc mingw32_utils; do
  extract_files "${mingwoutput}" "${group}"
done

#extract dx7 headers
echo "Extracting DirectX7 headers..."
extract_files "${mingwoutput}/include" dx7_headers

#install yasm
echo "Installing YASM to MinGW..."
cp -f "${win32_yasm}" "${mingwoutput}/bin/yasm.exe"

#install nasm
echo "Installing NASM to MinGW..."
tempdir="/tmp/nasm${RANDOM}"
extract_files "${tempdir}" win32_nasm
win32_nasm="${win32_nasm##*/}"
win32_nasm="${win32_nasm%-win32.zip }"
mkdir -p "${mingwoutput}/share/doc/nasm/${win32_nasm#nasm-}"
mv -f "${tempdir}/${win32_nasm}/LICENSE" "${mingwoutput}/share/doc/nasm/${win32_nasm#nasm-}"
cp -rf "${tempdir}/${win32_nasm}/"* "${mingwoutput}/bin"
rm -rf "${tempdir}"

#install unrar
echo "Installing unrar to MinGW..."
tempdir="/tmp/unrar${RANDOM}"
"${rar_cli}" -d"${tempdir}" -s
mkdir -p "${mingwoutput}/share/doc/unrar"
mv -f "${tempdir}/UnRAR.exe" "${mingwoutput}/bin"
mv -f "${tempdir}/license.txt" "${mingwoutput}/share/doc/unrar"
rm -rf "${tempdir}"

#normalize system from update
echo "Normalizing MSYS components..."
for file in awk bunzip2; do
  if [[ -f "/bin/${file}." && -f "/bin/${file}.exe" ]]; then
    rm -f "/bin/${file}.exe"  #delete exe copy
  fi
done
for file in d2u echo egrep fgrep ftp printf pwd u2d; do
  if [[ -f "/bin/${file}." && -f "/bin/${file}.exe" ]]; then
    rm -f "/bin/${file}."     #delete script copy
  fi
done
rm -rf "/share/file"
rm -rf "/uninstall"

#patch for largefile support in mingwrt
echo "Applying patch for largefile support to MinGW Runtimes..."
patch -sNp1 -d "${mingwoutput}" < "${mingwrt_largefile_patch}"

echo "Modifying msys.bat ..."
#modify msys.bat to use rxvt by default instead of cmd
sed -i 's/^\(if "x%MSYSCON%" == "xunknown" set MSYSCON=\)sh.exe$/\1rxvt.exe/' "${msysoutput}/msys.bat"

#modify msys.bat for msvc linking
msvc='SET VSENVPATH=unknown\
if defined VS100COMNTOOLS (\
CALL SET VSENVPATH=%%VS100COMNTOOLS%%\
) else if defined VS90COMNTOOLS (\
CALL SET VSENVPATH=%%VS90COMNTOOLS%%\
) else if defined VS80COMNTOOLS (\
CALL SET VSENVPATH=%%VS80COMNTOOLS%%\
) else if defined VS70COMNTOOLS (\
CALL SET VSENVPATH=%%VS70COMNTOOLS%%\
)\
if exist "%VSENVPATH%vsvars32.bat" (\
  CALL "%%VSENVPATH%%vsvars32.bat"\
)\
SET VSENVPATH='

sed -i -e '/^rem to represent.$/ {
  :again
  N
  /\nrem ember value of GOTO: is used to know recursion has happened.$/ !b again

  s/^\(rem to represent.\n\).*\(\nrem ember value of GOTO: is used to know recursion has happened.\)$/\1\n'"${msvc}"'\n\2/
  }' -e 's/-fg %FGCOLOR% -bg %BGCOLOR% -sr -fn Courier-12/-fg grey90 -bg black -sr -fn "Lucida Console-14"/' "${msysoutput}/msys.bat"

echo "Modifying /etc/profile ..."
#modify /etc/profile with pkg-config and other vars
sed -i 's/^\(export HOME LOGNAME MSYSTEM HISTFILE\)$/PKG_CONFIG_PATH=\"\/mingw\/lib\/pkgconfig\"\nCVS_RSH=ssh\nCC=gcc\n\1 PKG_CONFIG_PATH CVS_RSH CC/' "/etc/profile"

#modify /etc/fstab with path to /perl, copy drive letter from /mingw mount, else use HOMEDRIVE win32 var else default to c drive
echo "Modifying /etc/fstab ..."
perlpath="\/msys\/1.0\/lib\/perl5\/5.6"
mingwdrive=`sed -n '/^.*\/mingw$/ {p;q;}' "/etc/fstab"`
if [[ -n "${mingwdrive%%/*}" ]]; then
  HOMEDRIVE="${mingwdrive%%/*}"
fi
sed -i 's/^.*\/perl$/'"${HOMEDRIVE-C:}${perlpath}"'   \/perl/' "/etc/fstab"
echo -e "Confirm the paths in /etc/fstab below are correct:"
echo
cat /etc/fstab
echo -e "\n"

echo -e "\nDone!"

exit 0

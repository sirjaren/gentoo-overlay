# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils git-r3 multilib

DESCRIPTION="SANE backend driver for newer Epson scanners (DS, ET, PX, etc)"
HOMEPAGE="https://github.com/utsushi/utsushi"
EGIT_REPO_URI="https://github.com/utsushi/utsushi.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~x64"
IUSE="gtk imagemagick jpeg +network nls openmp tiff udev"

# These are needed by utsushi's 'bootstrap':
#   dev-libs/gnulib
#   sys-devel/autoconf-archive
#   sys-devel/autoconf-wrapper
#   sys-devel/automake-wrapper
#   sys-devel/gettext
#   sys-devel/libtool
#   sys-devel/patch
DEPEND="
	dev-libs/gnulib
	sys-devel/autoconf-archive
	sys-devel/autoconf-wrapper
	sys-devel/automake-wrapper
	sys-devel/gettext
	sys-devel/libtool
	sys-devel/patch
	media-gfx/sane-backends
	virtual/libusb:1
	gtk?          ( dev-cpp/gtkmm:2.4 )
	imagemagick?  ( media-gfx/imagemagick )
	jpeg?         ( virtual/jpeg:0 )
	tiff?         ( media-libs/tiff:0= )
	udev?         ( virtual/udev )
"

RDEPEND="
	${DEPEND}
	network?     ( media-gfx/epson-ds-plugins )
"

src_prepare() {
	# Copy over new 'ltmain.sh' file (patch)
	cp "${FILESDIR}"/ltmain.sh-2.4.diff "${S}"/sane/

	# Ensure sane configuration is created if SANE confdir is set
	epatch "${FILESDIR}"/${PF}-sane-makefile-fix.patch

	# utsushi requires using this bootstrap wrapper in lieu of autotools
	${S}/bootstrap || die

	# Create SANE configuration directory (used by sane/Makefile.am to create
	# utsushi backend config)
	dodir /etc/sane.d/dll.d
}

src_configure() {
	econf \
		--with-sane                                 \
		--with-sane-confdir="${EPREFIX}"/etc/sane.d \
		--without-included-boost                    \
		--with-boost=yes                            \
		$(use_with gtk gtkmm)                       \
		$(use_with imagemagick magick)              \
		$(use_with imagemagick magick-pp)           \
		$(use_with jpeg)                            \
		$(use_enable nls)                           \
		$(use_enable openmp)                        \
		$(use_with tiff)                            \
		$(use_enable udev udev_config)              \
		$(use_with udev udev_confdir "${EPREFIX}"/$(get_libdir)/udev)
}

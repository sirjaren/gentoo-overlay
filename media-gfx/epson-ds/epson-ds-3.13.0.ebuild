# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib

DESCRIPTION="SANE backend driver for Epson DS line of scanners"
HOMEPAGE="https://github.com/utsushi/utsushi"
SRC_URI="https://github.com/utsushi/imagescan/archive/${PV}.tar.gz -> epson-ds-${PV}.tar.gz"

RESTRICT="nomirror"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~x64"
IUSE="gtk imagemagick jpeg +network nls openmp system-boost tiff udev"

DEPEND="
	media-gfx/sane-backends
	virtual/libusb:1
	gtk?          ( dev-cpp/gtkmm:2.4 )
	imagemagick?  ( media-gfx/imagemagick )
	jpeg?         ( virtual/jpeg:0 )
	system-boost? ( dev-libs/boost )
	tiff?         ( media-libs/tiff:0= )
	udev?         ( virtual/udev )
"

RDEPEND="
	${DEPEND}
	network?     ( media-gfx/epson-ds-plugins )
"

# Extracted archive has a different name than the gentoo package
S="${WORKDIR}/imagescan-${PV}"

src_prepare() {
	# If using 'pkg-config' to determine SANE version, make sure 'git' is
	# stripped out.  This allows 'libtool' to not fail when using the
	# REVISION number inside the generated Makefiles
	epatch "${FILESDIR}"/${PF}-pkg-config-fix.patch
}

src_configure() {
	# 'utsushi' requires the 'boost' libraries
	if use system-boost; then
	  boost_conf="--without-included-boost"
	  boost_conf+=" --with-boost=yes"
	else
	  boost_conf="--with-included-boost"
	fi

	econf \
		--with-sane                                 \
		--with-sane-confdir="${EPREFIX}"/etc/sane.d \
		$boost_conf                                 \
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

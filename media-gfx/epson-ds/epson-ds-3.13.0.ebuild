# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib

DESCRIPTION="SANE backend driver for Epson DS line of scanners"
HOMEPAGE="https://github.com/utsushi/utsushi"
SRC_URI="https://github.com/utsushi/imagescan/archive/${PV}.tar.gz -> epson-ds-${PV}.tar.gz"

RESTRICT="nomirror"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="~x86 ~x64"
IUSE="gtk imagemagick jpeg +network nls openmp tiff udev"

DEPEND="
	media-gfx/sane-backends
	gtk?         ( dev-cpp/gtkmm:2.4 )
	imagemagick? ( media-gfx/imagemagick )
	jpeg?        ( virtual/jpeg:0 )
	tiff?        ( media-libs/tiff:0= )
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
	econf                                                 \
		--with-sane                                       \
		--with-sane-confdir="${EPREFIX}"/etc/sane.d       \
		$(use_with gtk gtkmm)                             \
		$(use_with imagemagick magick)                    \
		$(use_with imagemagick magick-pp)                 \
		$(use_with jpeg)                                  \
		$(use_enable nls)                                 \
		$(use_enable openmp)                              \
		$(use_with tiff)                                  \
		$(use_enable udev udev_config)                    \
		$(use_with udev udev_confdir "${EPREFIX}"/$(get_libdir)/udev)
}

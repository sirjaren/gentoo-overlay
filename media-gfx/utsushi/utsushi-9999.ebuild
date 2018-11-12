# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils git-r3 multilib toolchain-funcs

DESCRIPTION="SANE backend driver for newer Epson scanners (DS, ET, PX, etc)"
HOMEPAGE="https://gitlab.com/utsushi/utsushi"
EGIT_REPO_URI="https://gitlab.com/utsushi/utsushi.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~x64"
IUSE="gtk jpeg +network nls openmp tiff udev"

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
	sys-devel/gcc
	sys-devel/gettext
	sys-devel/libtool
	sys-devel/patch
	media-gfx/imagemagick
	media-gfx/sane-backends
	>=dev-libs/libusb-1.0.22
	>=dev-libs/boost-1.50.0
	gtk?          ( dev-cpp/gtkmm:2.4 )
	jpeg?         ( virtual/jpeg:0 )
	tiff?         ( media-libs/tiff:0= )
	udev?         ( virtual/udev )
"

RDEPEND="
	${DEPEND}
	network?     ( media-gfx/epson-ds-plugins )
"

PATCHES=(
	# AX_BOOST_BASE does not need to be patched
	"${FILESDIR}/${PF}-boost.patch"

	# Allow libusb >= 1.0.22 (removes deprecated 'libusb_set_debug()')
	"${FILESDIR}/${PF}-libusb.patch"

	# ImageMagick >= 7 removed various *_MAGICK_PP api's, which are possibly
	# not needed. See: https://gitlab.com/utsushi/utsushi/issues/43
	"${FILESDIR}/${PF}-magick-pp.patch"
)

src_prepare() {
	default

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
		--with-boost=yes                            \
		--with-magick                               \
		--with-magick-pp                            \
		$(use_with gtk gtkmm)                       \
		$(use_with jpeg)                            \
		$(use_enable nls)                           \
		$(use_enable openmp)                        \
		$(use_with tiff)                            \
		$(use_enable udev udev-config)              \
		$(use_with udev udev-confdir "${EPREFIX}"/$(get_libdir)/udev)
}

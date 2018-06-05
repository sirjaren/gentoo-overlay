# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils git-r3 multilib toolchain-funcs

DESCRIPTION="SANE backend driver for newer Epson scanners (DS, ET, PX, etc)"
HOMEPAGE="https://github.com/utsushi/utsushi"
EGIT_REPO_URI="https://github.com/utsushi/utsushi.git"

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
#
# NOTE:
#   Utsushi fails to build with GCC >= 8.0
#   Utsushi fails to build with libusb >= 1.0.22
#   ImageMagick is now a hard dependency. See:
#     https://github.com/utsushi/utsushi/issues/58
DEPEND="
	dev-libs/gnulib
	sys-devel/autoconf-archive
	sys-devel/autoconf-wrapper
	sys-devel/automake-wrapper
	sys-devel/gettext
	sys-devel/libtool
	sys-devel/patch
	media-gfx/imagemagick
	media-gfx/sane-backends
	<sys-devel/gcc-8
	<=dev-libs/libusb-1.0.21
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

	# ImageMagick >= 7 removed various *_MAGICK_PP api's, which are possibly
	# not needed. See: https://github.com/utsushi/utsushi/issues/43
	"${FILESDIR}/${PF}-magick-pp.patch"
)

pkg_setup() {
	# Ensure GCC <= 8 is used, as a user may have a lower version installed
	# but is currently set to use GCC >= 8
	if (( $(gcc-major-version) >= 8 )); then
		eerror
		eerror "'${PN}' does not currently compile with >=sys-devel/gcc-8.0.0"
		eerror "Use 'gcc-config' to set GCC to a lower version"
		eerror
		die
	fi
}

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

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils git-r3 toolchain-funcs

DESCRIPTION="Simple screen locker - patched to colorize lock screen"
HOMEPAGE="https://github.com/Arcaena/i3lock-color"
EGIT_REPO_URI="https://github.com/Arcaena/i3lock-color.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/pam
	dev-libs/libev
	>=x11-libs/libxkbcommon-0.5.0[X]
	x11-libs/libxcb[xkb]
	x11-libs/xcb-util
	x11-libs/cairo[xcb]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
DOCS=( CHANGELOG README.md )

pkg_setup() {
	tc-export CC
}

src_prepare() {
	sed -i -e 's:login:system-auth:' ${PN%-color}.pam || die
	epatch_user

	# Remove mangling of man pages from the Makefile for i3lock-color,
	# preferring to have Gentoo natively handle installing the 'man' pages
	epatch "${FILESDIR}"/${PF}-makefile-man-fix.patch
}

src_install() {
	default
	doman ${PN%-color}.1
}

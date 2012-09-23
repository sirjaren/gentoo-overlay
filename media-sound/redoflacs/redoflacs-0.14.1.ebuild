# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

inherit vcs-snapshot

DESCRIPTION="Command line (BASH) FLAC verifier, organizer, analyzer"
HOMEPAGE="https://github.com/sirjaren/redoflacs"
SRC_URI="https://github.com/sirjaren/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="mirror"

RDEPEND="
	sys-apps/coreutils
	sys-apps/findutils
	sys-apps/gawk
	sys-apps/grep
	app-shells/bash
	media-libs/flac"
DEPEND=""

src_install() {
	local install_dir="/usr/bin"
	insinto "${install_dir}"
	newins redoFlacs.sh redoflacs
	fperms a+x "${install_dir}"/redoflacs
}

pkg_postinst() {
	elog "This script makes use of optional programs if installed.  See below:"
	elog "   sys-libs/ncurses   ->  Support for full terminal width"
	elog "   sys-apps/less      ->  Support for piping help through 'less'"
	elog "   media-sound/sox    ->  Support for creating spectrograms"
	elog "   media-libs/libpng  ->  Needed by media-sound/sox"
}

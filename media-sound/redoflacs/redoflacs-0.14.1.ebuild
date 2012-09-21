# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

DESCRIPTION="Command line (BASH) FLAC verifier, organizer, analyzer"
HOMEPAGE="https://github.com/sirjaren/redoflacs"
SRC_URI="https://github.com/sirjaren/redoflacs/tarball/v${PV} -> $P.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+auto-width +pager +spectrogram"

RESTRICT="mirror"

RDEPEND="
	sys-apps/coreutils
	sys-apps/findutils
	sys-apps/gawk
	sys-apps/grep
	app-shells/bash
	media-libs/flac
	auto-width? ( sys-libs/ncurses )
	pager? ( sys-apps/less )
	spectrogram? ( media-sound/sox media-libs/libpng )"
DEPEND=""

src_unpack() {
	unpack "${A}"
	S=$(ls -d ${WORKDIR}/*redoflacs*)
	cd "${S}"
}

src_install() {
	local install_dir="/usr/bin"
	insinto "${install_dir}"
	newins redoFlacs.sh redoflacs
	fperms a+x "${install_dir}"/redoflacs
}

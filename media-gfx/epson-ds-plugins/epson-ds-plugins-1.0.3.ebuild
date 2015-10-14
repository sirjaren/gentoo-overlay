# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit rpm

S="${WORKDIR}"

DESCRIPTION="Non-free network plugin package for Epson DS line of scanners"
HOMEPAGE="http://download.ebz.epson.net/dsc/search/01/search/?OSC=LX"
SRC_URI="
	x86?   ( https://download3.ebz.epson.net/dsc/f/03/00/04/16/39/5be81863c43b44e13cef82437492e117bad7e1ed/imagescan-bundle-centos-6-${PV}.x86.rpm.tar.gz )
	amd64? ( https://download3.ebz.epson.net/dsc/f/03/00/04/16/39/8daed7ee9b07bd31d96861bb76e3fea1b47ce91e/imagescan-bundle-centos-6-${PV}.x64.rpm.tar.gz )
"

RESTRICT="nomirror"

LICENSE="AVASYS"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND="
	${DEPEND}
	media-gfx/epson-ds
"

# EPSON provided closed-source binary
QA_PRESTRIPPED="usr/libexec/utsushi/networkscan"

src_unpack() {
	# Create a 'core' and 'plugins' directory to unpack into
	mkdir -p "${WORKDIR}/"{core,plugins}

	# Unpack top-level package
	unpack "$A"

	# NOTE: EAPI 6 will support absolute pathnames to unpack() and rpm_unpack()
	# Unpack the core drivers to the created 'core' directory
	cd "${WORKDIR}/core"
	rpm_unpack ./../imagescan-bundle-centos-6-${PV}.x??.rpm/core/imagescan-*.rpm

	# Unpack 'networkscan' plugin to the created 'plugins' directory
	cd "${WORKDIR}/plugins"
	rpm_unpack ./../imagescan-bundle-centos-6-${PV}.x??.rpm/plugins/imagescan-plugin-networkscan*.rpm
}

src_install() {
	# NOTE:
	#  The udev rules are not installed as it's handled by the 'utsushi'
	#  source package
	#
	#  The 'utushi' config file for SANE (/etc/sane.d/dll.d/utsushi) is handled
	#  by the 'utsushi' source package
	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
	# Create a subdirectory to install the 'networkscan' docs
	dodoc ${WORKDIR}/plugins/usr/share/doc/imagescan-plugin-networkscan-*/{README,NEWS,AVASYSPL.en.txt}

	# Install the 'networkscan' config files
	# Renamed config to 'utsushi.conf' to be picked up by utsushi SANE backend
	insinto /etc/utsushi
	newins ${WORKDIR}/core/etc/imagescan/imagescan.conf utsushi.conf

	# Install the 'networkscan' binary
	exeinto /usr/libexec/utsushi
	doexe ${WORKDIR}/plugins/usr/libexec/utsushi/networkscan
}

pkg_postinst() {
	elog
	elog "Remember to insert your scanner information into:"
	elog "  /etc/utsushi/utsushi.conf"
	elog
	elog "See /usr/share/doc/${PF}/README.bz2 for examples"
	elog
}

# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

BUILD_NUMBER="193.5662.63"

HOMEPAGE="http://www.jetbrains.com/phpstorm/"
DESCRIPTION="PhpStorm - The Lightning-Smart PHP IDE"

inherit desktop eutils

SRC_URI="https://download.jetbrains.com/webide/PhpStorm-${PV}.tar.gz"
LICENSE=""

KEYWORDS="x86 amd64"
RESTRICT="strip mirror"

DEPEND=""
RDEPEND=">=virtual/jre-1.8"

SLOT="0"

S="${WORKDIR}/PhpStorm-${BUILD_NUMBER}"

src_install() {
	dodir /opt/${PN}

	insinto /opt/${PN}
	doins -r *

	rm -f ${D}/opt/${PN}/bin/fsnotifier-arm

	fperms a+x /opt/${PN}/bin/phpstorm.sh || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/fsnotifier || die "Chmod failed"
	fperms a+x /opt/${PN}/bin/fsnotifier64 || die "Chmod failed"

	for i in $(ls ${D}/opt/${PN}/jre64/bin/)
	do
		fperms a+x /opt/${PN}/jre64/bin/${i} || die "Chmod failed"
	done;

	dosym /opt/${PN}/bin/phpstorm.sh /usr/bin/${PN}

	doicon "bin/${PN}.svg"
	make_desktop_entry ${PN} "PHPStorm" "${PN}"
}


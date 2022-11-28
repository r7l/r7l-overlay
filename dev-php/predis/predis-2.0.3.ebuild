# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A flexible and feature-complete Redis client for PHP."
HOMEPAGE="https://github.com/predis/predis"
SRC_URI="https://github.com/predis/predis/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-lang/php
	dev-php/fedora-autoloader"

S="${WORKDIR}/predis-${PV}"

src_install() {
	insinto "/usr/share/php/predis"
	doins -r src/* "${FILESDIR}"/autoload.php
	dodoc README.md
}

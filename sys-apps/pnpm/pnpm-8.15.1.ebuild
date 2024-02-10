# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, disk space efficient package manager, alternative to npm and yarn"
HOMEPAGE="https://pnpm.io"

SRC_URI="
	amd64? ( https://github.com/pnpm/pnpm/releases/download/v${PV}/pnpm-linux-x64 -> ${P}-amd64 )
	arm64? ( https://github.com/pnpm/pnpm/releases/download/v${PV}/pnpm-linux-arm64 -> ${P}-arm64 )
"
KEYWORDS="~amd64 ~arm64"

LICENSE="MIT"
SLOT="0"

RESTRICT="strip"

S="${WORKDIR}"
QA_FLAGS_IGNORED="/usr/bin/${PN}-bin"

src_install() {
	newbin "${DISTDIR}/${P}" ${PN/-bin/}
}

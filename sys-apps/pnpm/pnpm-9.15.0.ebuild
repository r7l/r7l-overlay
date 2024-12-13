# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Fast, disk space efficient package manager, alternative to npm and yarn"
HOMEPAGE="https://github.com/pnpm/pnpm"

SRC_URI="
	amd64? ( https://github.com/pnpm/pnpm/releases/download/v${PV}/pnpm-linux-x64 -> ${P}-amd64 )
	arm64? ( https://github.com/pnpm/pnpm/releases/download/v${PV}/pnpm-linux-arm64 -> ${P}-arm64 )
"

S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="strip"

RDEPEND="net-libs/nodejs"

src_install() {
	newbin "${DISTDIR}/${P}-${ARCH}" ${PN}
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Gentoo flavored version of the Agnoster ZSH Theme."
HOMEPAGE="https://github.com/r7l/agnoster-gentoo-zsh-theme"

EGO_PN=github.com/r7l/agnoster-gentoo-zsh-theme
EGIT_COMMIT="a2b3700d80181f8431d80087df73481b527bc8c1"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

KEYWORDS="~amd64 ~arm64"

LICENSE="ZSH"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="app-shells/zsh
	app-shells/oh-my-zsh"

ZSH_DEST="/usr/share/zsh/site-contrib/${PN}"

S="${WORKDIR}/agnoster-gentoo-zsh-theme-${EGIT_COMMIT}"

src_install() {
	insinto "${ZSH_DEST}"
	doins -r agnoster-gentoo.zsh-theme
}

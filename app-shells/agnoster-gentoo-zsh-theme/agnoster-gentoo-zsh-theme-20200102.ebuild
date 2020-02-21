# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Gentoo flavored version of the Agnoster ZSH Theme."
HOMEPAGE="https://github.com/r7l/agnoster-gentoo-zsh-theme"

EGO_PN=github.com/r7l/agnoster-gentoo-zsh-theme
EGIT_COMMIT="a6af06df1ca0ce22ed1ad1f1439508b871e0e1b8"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

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

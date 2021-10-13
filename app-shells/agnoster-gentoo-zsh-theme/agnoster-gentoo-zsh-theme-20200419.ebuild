# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A Gentoo flavored version of the Agnoster ZSH Theme."
HOMEPAGE="https://github.com/r7l/agnoster-gentoo-zsh-theme"

EGO_PN=github.com/r7l/agnoster-gentoo-zsh-theme
EGIT_COMMIT="edc9f70a3c261f1b69761eeb4c50a109365bb9e1"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
RESTRICT="primaryuri"

KEYWORDS="~amd64 ~arm64"

LICENSE="ZSH"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="app-shells/zsh
	app-shells/oh-my-zsh"

ZSH_DEST="/usr/share/zsh/site-contrib/oh-my-zsh/custom/themes/"

S="${WORKDIR}/agnoster-gentoo-zsh-theme-${EGIT_COMMIT}"

src_install() {
	insinto "${ZSH_DEST}"
	doins agnoster-gentoo.zsh-theme
}

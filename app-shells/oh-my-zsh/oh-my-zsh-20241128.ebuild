# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A ready-to-use zsh configuration with plugins."
HOMEPAGE="https://ohmyz.sh"

EGIT_COMMIT="69a6359f7cf8978d464573fb7b023ee3cd00181a"
SRC_URI="https://github.com/ohmyzsh/ohmyzsh/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/ohmyzsh-${EGIT_COMMIT}"

LICENSE="ZSH"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror"

RDEPEND="app-shells/zsh"

ZSH_DEST="/usr/share/zsh/site-contrib/${PN}"
ZSH_EDEST="${EPREFIX}${ZSH_DEST}"
ZSH_TEMPLATE="templates/zshrc.zsh-template"

src_prepare() {
	local i
	for i in "${S}"/tools/*install* "${S}"/tools/*upgrade*
		do test -f "${i}" && : >"${i}"
	done
	sed -i -e 's!^ZSH=.*$!ZSH='"${ZSH_EDEST}"'!' \
		   -e 's!~/.oh-my-zsh!'"${ZSH_EDEST}"'!' "${S}/${ZSH_TEMPLATE}"
	sed -i -e 's!~/.oh-my-zsh!'"${ZSH_EDEST}"'!' \
		"${S}/plugins/dirpersist/dirpersist.plugin.zsh"
	sed -i -e '/zstyle.*cache/d' "${S}/lib/completion.zsh"
	default
}

src_install() {
	insinto "${ZSH_DEST}"
	doins -r *
}

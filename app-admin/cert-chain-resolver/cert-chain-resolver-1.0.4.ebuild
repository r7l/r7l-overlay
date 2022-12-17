# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/zakjan/cert-chain-resolver"

inherit golang-build golang-vcs-snapshot

DESCRIPTION="SSL certificate chain resolver"
HOMEPAGE="https://github.com/zakjan/cert-chain-resolver"
SRC_URI="https://${EGO_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_pretend() {
	(has network-sandbox ${FEATURES}) && die "You need to disable 'network-sandbox' for this Ebuild in FEATURES"
}

src_compile() {

	cd "${S}"

	export GOPATH="${G}"

	local MY_GO_ARGS=(
		-ldflags "-s -w -X=main.version=${PV}"
        )

	go generate || die
	go build "${MY_GO_ARGS[@]}"

}

src_install() {
	dobin cert-chain-resolver
}

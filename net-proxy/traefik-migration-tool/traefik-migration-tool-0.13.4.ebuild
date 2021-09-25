# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_/-}"
EGO_PN="github.com/traefik/${PN}"

inherit golang-vcs-snapshot systemd

DESCRIPTION="A migration tool from Traefik v1 to Traefik v2."
HOMEPAGE="https://traefik.io"
SRC_URI="https://${EGO_PN}/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache License 2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_pretend() {
	(has network-sandbox ${FEATURES}) && die "You need to disable 'network-sandbox' for this Ebuild in FEATURES"
}

src_compile() {
	export GOPATH="${G}"
	local PATH="${G}/bin:$PATH"
	local MY_LDFLAGS=(
		-X "${EGO_PN}/version.Version=${MY_PV}"
		-X "'${EGO_PN}/version.BuildDate=$(date -u '+%Y-%m-%d_%I:%M:%S%p')'"
	)
	local MY_GO_ARGS=(
		-v -work -x
		-ldflags "${MY_LDFLAGS[*]}"
	)

	go generate || die
	CGO_ENABLED=0 GOGC=off go build "${MY_GO_ARGS[@]}" .
}

src_install() {
	dobin traefik-migration-tool
}


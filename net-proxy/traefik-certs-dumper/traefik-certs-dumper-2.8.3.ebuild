# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGO_PN="github.com/ldez/traefik-certs-dumper"

inherit golang-build golang-vcs-snapshot

DESCRIPTION="Dump ACME data from Traefik to certificates"
HOMEPAGE="https://github.com/ldez/traefik-certs-dumper"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"

LICENSE="Apache-2.0"
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

	local MY_LDFLAGS=(
		-X "${EGO_PN}/cmd.version=${MY_PV}"
		-X "'${EGO_PN}/cmd.date=$(date -u '+%Y-%m-%d_%I:%M:%S%p')'"
	)

	local MY_GO_ARGS=(
		-v -work -x
		-ldflags "${MY_LDFLAGS[*]}"
	)

	go generate || die
	CGO_ENABLED=0 GOGC=off go build "${MY_GO_ARGS[@]}" .

}

src_install() {
	dobin traefik-certs-dumper
}

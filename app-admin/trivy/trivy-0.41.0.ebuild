# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EGO_PN="github.com/aquasecurity/trivy"

inherit go-module

DESCRIPTION="Scanner for vulnerabilities in container images, file systems, and Git repositories, as well as for configuration issues and hard-coded secrets"
HOMEPAGE="https://github.com/aquasecurity/trivy"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="~amd64"

LICENSE="Apache-2.0"
SLOT="0"
IUSE=""

DEPEND=">=dev-lang/go-1.19"
RDEPEND="${DEPEND}"

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
	go build "${MY_GO_ARGS[@]}" ./cmd/trivy

}

src_install() {
	dobin trivy
}

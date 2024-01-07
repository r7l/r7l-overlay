# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module

DESCRIPTION="An email and SMTP testing tool with API for developers."
HOMEPAGE="https://github.com/axllent/mailpit"
SRC_URI="https://github.com/axllent/mailpit/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND=">=net-libs/nodejs-18"
RDEPEND="acct-group/mailpit
	acct-user/mailpit"
DEPEND="${RDEPEND}"

S="${WORKDIR}/mailpit-${PV}"

pkg_pretend() {
	(has network-sandbox ${FEATURES}) && die "You need to disable 'network-sandbox' for this Ebuild in FEATURES"
}

src_prepare() {
	default
	cd "${S}"
	npm ci
}

src_compile() {

	cd "${S}"

	npm run package

	export GOPATH="${G}"
	local PATH="${G}/bin:$PATH"

	local MY_GO_ARGS=(
		-v -work -x
		-ldflags "-s -w -X github.com/axllent/mailpit/config.Version=${PV}"
	)

	go generate || die
	CGO_ENABLED=0 go build "${MY_GO_ARGS[@]}" -o ./mailpit

}

src_install() {
	insinto /usr/bin
	doins mailpit
	fperms 755 /usr/bin/mailpit
}

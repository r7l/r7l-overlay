# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CODENAME="cheddar"

inherit go-module systemd

DESCRIPTION="A modern HTTP reverse proxy and load balancer made to deploy microservices"
HOMEPAGE="https://traefik.io"
SRC_URI="https://github.com/traefik/traefik/releases/download/v${PV}/${PN}-v${PV}.src.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}"
WEBUI="${S}/webui"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="debug systemd"

DEPEND="acct-group/traefik
	acct-user/traefik"
RDEPEND="${DEPEND}"
BDEPEND=">=dev-lang/go-1.23
	=net-libs/nodejs-22*
	sys-apps/yarn"

RESTRICT="mirror"

pkg_pretend() {
	(has network-sandbox ${FEATURES}) && die "You need to disable 'network-sandbox' for this Ebuild in FEATURES"
}

src_unpack() {
	default
	pushd "${S}" >& /dev/null || die
	ego mod vendor
	popd >& /dev/null || die
}

src_compile() {

	local CURRENT_DATE="$(date -u "+%Y-%m-%d_%I:%M")"

	echo "Build Traefik WebUI"

	cd "${WEBUI}"
	mkdir -p "${WEBUI}/static"
	yarn install
	npm run build:nc

	echo "Build Traefik Binary"

	cd "${S}"

	CGO_ENABLED=0 GOGC=off go build -ldflags="-s -w \
		-X github.com/traefik/traefik/v3/pkg/version.Version=${PV} \
		-X github.com/traefik/traefik/v3/pkg/version.Codename=${CODENAME} \
		-X github.com/traefik/traefik/v3/pkg/version.BuildDate=${CURRENT_DATE} \
	" -installsuffix nocgo ./cmd/traefik

}

src_install() {

	dobin traefik
	einstalldocs

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"

	if use systemd ; then
		systemd_dounit "${FILESDIR}/${PN}.service"
	else
		newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	fi

	insinto /etc/traefik
	newins traefik.sample.toml traefik.toml.example

	diropts -o traefik -g traefik -m 0750
	keepdir /var/log/traefik

}

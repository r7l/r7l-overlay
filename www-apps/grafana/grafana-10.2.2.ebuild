# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV=${PV/_beta/-beta}
S=${WORKDIR}/${PN}-${MY_PV}

DESCRIPTION="The open-source platform for monitoring and observability"
HOMEPAGE="https://grafana.com"
SRC_URI="https://github.com/grafana/grafana/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

inherit go-module systemd

LICENSE="AGPL-3.0 Apache-2.0 BSD-2 BSD-3 BSD-4 BSL-1.0 ImageMagick ISC LGPL-3.0 MIT MPL-2.0 OpenSSL Zlib"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="systemd"

RDEPEND="acct-group/grafana
	acct-user/grafana
	!www-apps/grafana-bin"
DEPEND="${RDEPEND}
	=net-libs/nodejs-18*[icu]
	sys-apps/yarn"

QA_PRESTRIPPED="usr/bin/grafana-*"

pkg_pretend() {
	(has network-sandbox ${FEATURES}) && die "You need to disable 'network-sandbox' for this Ebuild in FEATURES"
}

src_compile() {
	NODE_OPTIONS="--max-old-space-size=5120" LDFLAGS="" make all || die
}

src_install() {
	keepdir /etc/grafana
	insinto /etc/grafana
	newins "${S}"/conf/defaults.ini grafana.ini

	# Frontend assets
	insinto /usr/share/${PN}
	doins -r public conf

	dobin bin/linux-amd64/grafana
	dobin bin/linux-amd64/grafana-cli
	dobin bin/linux-amd64/grafana-server

	newinitd "${FILESDIR}"/grafana.initd grafana

	if ! use systemd; then
		systemd_newunit "${FILESDIR}"/grafana.service grafana.service
	fi

	keepdir /var/{lib,log}/grafana
	keepdir /var/lib/grafana/{dashboards,plugins}
	fowners grafana:grafana /var/{lib,log}/grafana
	fowners grafana:grafana /var/lib/grafana/{dashboards,plugins}
	fperms 0750 /var/{lib,log}/grafana
	fperms 0750 /var/lib/grafana/{dashboards,plugins}
}

postinst() {
	elog "${PN} has built-in log rotation. Please see [log.file] section of"
	elog "/etc/grafana/grafana.ini for related settings."
	elog
	elog "You may add your own custom configuration for app-admin/logrotate if you"
	elog "wish to use external rotation of logs. In this case, you also need to make"
	elog "sure the built-in rotation is turned off."
}

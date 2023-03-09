# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="Simple web interface to manage Redis databases."
HOMEPAGE="https://github.com/erikdubbelboer/phpRedisAdmin"
SRC_URI="https://github.com/erikdubbelboer/phpRedisAdmin/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="CC-BY-SA-3.0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND="
	dev-db/redis
	dev-lang/php
	dev-php/predis
	virtual/httpd-php
"

need_httpd_cgi

S="${WORKDIR}"/phpRedisAdmin-${PV}

src_install() {

	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r .

	dosym /usr/share/php/predis ${MY_HTDOCSDIR}/vendor

	webapp_src_install

}

pkg_postinst() {
	elog "Please remember to set up a config.inc.php when installing for the first time."
	webapp_pkg_postinst
}

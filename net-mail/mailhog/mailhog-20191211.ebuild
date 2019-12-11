# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/mailhog/MailHog

EGIT_COMMIT="f5559ac00323e7f2ab5abcea3628e0c492bb3bf2"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

inherit user golang-vcs-snapshot golang-build

DESCRIPTION="MailHog is an email testing tool for developers"
HOMEPAGE="https://github.com/mailhog/MailHog"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src/${EGO_PN}"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 "/var/lib/${PN}" ${PN}
}

src_install() {
	newbin ${S}/MailHog mailhog
}

# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/mailhog/MailHog

EGIT_COMMIT="f5559ac00323e7f2ab5abcea3628e0c492bb3bf2"
SRC_URI="https://${EGO_PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"

inherit golang-vcs-snapshot golang-build

KEYWORDS="amd64 ~arm64"

DESCRIPTION="MailHog is an email testing tool for developers"
HOMEPAGE="https://github.com/mailhog/MailHog"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="acct-group/mailhog acct-user/mailhog"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/src/${EGO_PN}"

src_install() {
	newbin "${S}/MailHog" mailhog
}
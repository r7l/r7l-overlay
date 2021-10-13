# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
EGO_PN=github.com/mailhog/MailHog

inherit golang-vcs golang-build

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

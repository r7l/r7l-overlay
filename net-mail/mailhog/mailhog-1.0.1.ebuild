# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit golang-build golang-vcs-snapshot

EGO_PN="github.com/mailhog/MailHog"
SRC_URI="https://${EGO_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

KEYWORDS="amd64 ~arm64"

DESCRIPTION="MailHog is an email testing tool for developers"
HOMEPAGE="https://github.com/mailhog/MailHog"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="acct-group/mailhog
	acct-user/mailhog"
RDEPEND="${DEPEND}"

src_install() {
	newbin "${S}/MailHog" mailhog
}

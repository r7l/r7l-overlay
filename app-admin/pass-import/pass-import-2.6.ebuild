# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{3_4,3_5,3_6} )

inherit python-r1

DESCRIPTION="generic importer extension for password manager ZX2C4's pass"
HOMEPAGE="https://github.com/roddhjav/pass-import"
SRC_URI="https://github.com/roddhjav/pass-import/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=app-shells/bash-4.4
	dev-python/defusedxml[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=app-admin/pass-1.7.0
	dev-python/pyyaml"

RESTRICT="mirror"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md )

pkg_setup() {
	python_setup
}

src_prepare() {
	python_fix_shebang .
	eapply_user
}

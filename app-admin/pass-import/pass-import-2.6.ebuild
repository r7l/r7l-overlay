# Copyright 1999-2019 Gentoo Authors
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

COMMON_DEPEND="app-shells/bash
	dev-python/defusedxml[${PYTHON_USEDEP}]"
DEPEND=${COMMON_DEPEND}
RDEPEND="${COMMON_DEPEND}
	>=app-admin/pass-1.7.0
	>=dev-python/pyaml-19.4.1"

RESTRICT="mirror"

DOCS=( CHANGELOG.md CONTRIBUTING.md README.md )

pkg_setup() {
        python_setup
}

src_prepare() {
	python_fix_shebang .
	eapply_user
}

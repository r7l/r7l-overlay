# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )
DISTUTILS_USE_PEP517=poetry

inherit distutils-r1 pypi

DESCRIPTION="passpy -- ZX2C4's pass compatible library and cli"
HOMEPAGE="https://github.com/bfrascher/passpy"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

RDEPEND="
	dev-python/click
	dev-python/gitpython
	dev-python/python-gnupg
	dev-python/pyperclip
	"

src_prepare() {
	[ -d tests ] && rm -R tests
	if [ -f "${S}/NOTICE" ]; then
		rm "${S}/NOTICE"
	fi
	distutils-r1_src_prepare
}
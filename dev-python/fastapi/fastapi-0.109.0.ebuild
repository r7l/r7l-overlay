# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="High performance framework, easy to learn, fast to code, ready for production"
HOMEPAGE="https://github.com/tiangolo/fastapi"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND=">=dev-python/hatchling-1.13.0[${PYTHON_USEDEP}]"
RDEPEND="
	>=dev-python/pydantic-1.7.4[${PYTHON_USEDEP}]
	>=dev-python/starlette-0.27.0[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.5.0[${PYTHON_USEDEP}]
"

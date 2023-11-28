# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517=pdm-backend

inherit distutils-r1 pypi

DESCRIPTION="Server Sent Events for Starlette"
HOMEPAGE="https://github.com/sysid/sse-starlette"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/starlette[${PYTHON_USEDEP}]
"

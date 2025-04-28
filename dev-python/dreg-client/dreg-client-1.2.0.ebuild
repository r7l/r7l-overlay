# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )
PYPI_NO_NORMALIZE=1
PYPI_PN="${PN}"

inherit distutils-r1 pypi

DESCRIPTION="API client for Docker Registries"
HOMEPAGE="https://github.com/djmattyg007/dreg-client"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

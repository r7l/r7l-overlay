# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="API wrapper for the netcup DNS API"
HOMEPAGE="https://github.com/nbuchwitz/nc_dnsapi"
SRC_URI="https://github.com/nbuchwitz/nc_dnsapi/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/nc_dnsapi-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="dev-python/httplib2"

src_prepare() {
	default
	sed -i "s/version='0.1.5'/version='0.1.6'/g" setup.py
}

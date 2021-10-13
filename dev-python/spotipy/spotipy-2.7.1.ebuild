# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python{3_8,3_9,3_10})

inherit distutils-r1

DESCRIPTION="A thin Python-based library for the Spotify Web API"
HOMEPAGE="https://pypi.python.org/pypi/spotipy https://github.com/plamere/spotipy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	${PYTHON_DEPS}
	dev-python/requests[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

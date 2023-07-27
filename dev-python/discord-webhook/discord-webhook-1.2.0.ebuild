# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
DISTUTILS_USE_PEP517="poetry"

inherit distutils-r1

DESCRIPTION="Execute discord webhooks"
SRC_URI="https://github.com/lovvskillz/python-discord-webhook/releases/download/${PV}/${PN}-${PV}.tar.gz"
HOMEPAGE="https://github.com/lovvskillz/python-discord-webhook"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PHP_EXT_NAME="trader"
USE_PHP="php7-1 php7-2 php7-3"

inherit php-ext-pecl-r3

KEYWORDS="amd64 x86"

DESCRIPTION="PHP extension for ta-lib"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

DEPEND="sci-libs/ta-lib"
RDEPEND="${DEPEND}"


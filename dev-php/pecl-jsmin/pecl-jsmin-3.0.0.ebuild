# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PHP_EXT_NAME="jsmin"
PHP_EXT_INI="yes"
PHP_EXT_ZENDEXT="no"
DOCS="README.md"

USE_PHP="php7-4"

inherit php-ext-pecl-r3

KEYWORDS="~amd64 ~x86 ~arm ~arm64"

DESCRIPTION="PHP extension to compress JS files"
LICENSE="PHP-3"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

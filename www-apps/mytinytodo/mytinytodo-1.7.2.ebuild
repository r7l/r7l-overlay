# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit webapp

DESCRIPTION="Simple way to manage your todo list in AJAX style."
HOMEPAGE="https://www.mytinytodo.net"
SRC_URI="https://github.com/maxpozdeev/mytinytodo/releases/download/v${PV}/${PN}-v${PV}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~ppc64"
IUSE="+mysql sqlite"
REQUIRED_USE="|| ( mysql sqlite )"

DEPEND="app-arch/unzip"
RDEPEND=">=dev-lang/php-7
        mysql? ( virtual/mysql )
        sqlite? ( dev-db/sqlite )
        virtual/httpd-php"

S=${WORKDIR}/${PN}

src_prepare() {
        default
        mv "${S}/db/config.php" "${S}/db/config.php.default"
        if [ -f "${S}/content/themes/ie8.zip" ]; then
                rm "${S}/content/themes/ie8.zip"
        fi
}

src_install() {

        webapp_src_preinst

        insinto "${MY_HTDOCSDIR}"

        doins -r .

        keepdir "${MY_HTDOCSDIR}"/db

        webapp_serverowned -R "${MY_HTDOCSDIR}"/tmp

        webapp_src_install

}

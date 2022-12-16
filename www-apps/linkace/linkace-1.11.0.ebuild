# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit webapp

DESCRIPTION="LinkAce is a bookmark archive."
HOMEPAGE="https://github.com/Kovah/LinkAce"
SRC_URI="https://github.com/Kovah/LinkAce/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE="+mysql sqlite"
REQUIRED_USE="|| ( mysql sqlite )"

BDEPEND=">=net-libs/nodejs-16"
DEPEND="dev-php/composer"
RDEPEND=">=dev-lang/php-8.0[cli,fileinfo,pdo]
	mysql? ( virtual/mysql )
	sqlite? ( dev-db/sqlite )
	virtual/httpd-php"

S="${WORKDIR}/LinkAce-${PV}"

pkg_pretend() {
	(has network-sandbox ${FEATURES}) && die "You need to disable 'network-sandbox' for this Ebuild in FEATURES or package.env"
}

src_prepare() {

	default

	if [ -f "${S}/.dockerignore" ]; then
		rm "${S}/.dockerignore"
	fi

	if [ -f "${S}/docker-compose.yml" ]; then
		rm "${S}/docker-compose.yml"
	fi

	if [ -f "${S}/docker-compose.production.yml" ]; then
		rm "${S}/docker-compose.production.yml"
	fi

	if [ -f "${S}/docker-compose.production-simple.yml" ]; then
		rm "${S}/docker-compose.production-simple.yml"
	fi

	if [ -d "${S}/.github" ]; then
		rm -R "${S}/.github"
	fi

	cd "${S}"
	composer install --no-dev

	npm ci
	npm run prod

}

src_install() {

	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"

	doins -r .

	webapp_serverowned -R "${MY_HTDOCSDIR}"/storage
	webapp_serverowned -R "${MY_HTDOCSDIR}"/bootstrap/cache

	webapp_src_install

}

pkg_postinst() {
	elog "Don't forget to update the application by running 'php artisan migrate'."
	webapp_pkg_postinst
}

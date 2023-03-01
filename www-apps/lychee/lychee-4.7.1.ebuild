# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit webapp

DESCRIPTION="A great looking and easy-to-use photo-management-system."
HOMEPAGE="https://lycheeorg.github.io"
SRC_URI="https://github.com/lycheeorg/lychee/archive/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
IUSE="+mysql sqlite"
REQUIRED_USE="|| ( mysql sqlite )"

DEPEND="dev-php/composer"
RDEPEND="${DEPEND}
	>=dev-lang/php-8.1[cli,bcmath,exif,gd,curl,intl,phar,fileinfo,pdo]
	mysql? ( virtual/mysql )
	sqlite? ( dev-db/sqlite )
	virtual/httpd-php"

S="${WORKDIR}/Lychee-${PV}"

pkg_pretend() {
	(has network-sandbox ${FEATURES}) && die "You need to disable 'network-sandbox' in FEATURES or package.env"
}

src_prepare() {

	default

	if [ -f "${S}/makefile" ]; then
		rm "${S}/makefile"
	fi

	if [ -d "${S}/.github" ]; then
		rm -R "${S}/.github"
	fi

	if [ -f "${S}/.travis.yml" ]; then
		rm -R "${S}/.travis.yml"
	fi

	cd "${S}"
	composer install --no-dev

}

src_install() {

	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"

	doins -r .

	webapp_serverowned -R "${MY_HTDOCSDIR}"/storage/framework
	webapp_serverowned -R "${MY_HTDOCSDIR}"/storage/logs
	webapp_serverowned -R "${MY_HTDOCSDIR}"/bootstrap/cache
	webapp_serverowned -R "${MY_HTDOCSDIR}"/public/dist
	webapp_serverowned -R "${MY_HTDOCSDIR}"/public/img
	webapp_serverowned -R "${MY_HTDOCSDIR}"/public/sym
	webapp_serverowned -R "${MY_HTDOCSDIR}"/public/uploads

	keepdir "${MY_HTDOCSDIR}"/public/uploads

	webapp_src_install

}

pkg_postinst() {
	elog "Don't forget to update the application by running 'php artisan migrate'."
	webapp_pkg_postinst
}

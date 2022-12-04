# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

inherit webapp

DESCRIPTION="Lightweight CalDAV+CardDAV server"
HOMEPAGE="https://sabre.io/baikal/"
SRC_URI="https://github.com/sabre-io/Baikal/releases/download/${PV}/${P}.zip"

LICENSE="GPL-3"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="app-arch/unzip"
RDEPEND=""

PATCHES=( "${FILESDIR}/mysql-socket.patch" )

S=${WORKDIR}/${PN}

src_install() {

	webapp_src_preinst

	dodoc *.md || die "dodoc failed"

	einfo "Installing web files"
	insinto "${MY_HTDOCSDIR}"
	doins -r html/* html/.htaccess Core vendor || die "doins failed"

	einfo "Fixing symlinks"

	local link target

	find "${D}${MY_HTDOCSDIR}" -type l | while read link ; do
		target=$(readlink "${link}")
		target=${target/..\/Core/Core}
		rm "${link}" && ln -s "${target}" "${link}"
	done

	dodir "${MY_HTDOCSDIR}"/Specific
	keepdir "${MY_HTDOCSDIR}"/config
	dosym . "${MY_HTDOCSDIR}"/html

	webapp_serverowned -R "${MY_HTDOCSDIR}"/Specific
	webapp_serverowned -R "${MY_HTDOCSDIR}"/config

	webapp_src_install

}

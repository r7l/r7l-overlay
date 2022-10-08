# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit webapp

DESCRIPTION="Docker Registry User Interface."
HOMEPAGE="https://github.com/Joxit/docker-registry-ui"
SRC_URI="https://github.com/Joxit/docker-registry-ui/archive/refs/tags/${PV}.tar.gz"
RESTRICT="primaryuri"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~arm64"
IUSE=""
REQUIRED_USE=""

DEPEND=""
RDEPEND="virtual/httpd-basic"

src_install() {

	webapp_src_preinst

	insinto "${MY_HTDOCSDIR}"
	doins -r dist/* favicon.ico

	webapp_src_install

}

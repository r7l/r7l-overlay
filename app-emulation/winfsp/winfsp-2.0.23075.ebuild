# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PV="2.0"
DESCRIPTION="WinFsp · Windows File System Proxy - FUSE for Windows"
HOMEPAGE="https://github.com/winfsp/winfsp"
SRC_URI="https://github.com/winfsp/winfsp/releases/download/v${MY_PV}/${PN}-${PV}.msi"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-cdr/cdrtools"

S="${WORKDIR}"

src_unpack() {
	mkdir "${PN}"
	cp "${DISTDIR}/${A}" "${PN}"
}

src_prepare() {
	# File comes as zip but we need it to be .iso in order to mount it in QEMU"
	mkisofs -lJR -iso-level 4 -o "${PN}-${PV}.iso" "${PN}"
	rm -R "${PN}"
	eapply_user
}

src_install() {
	insinto /usr/share/drivers/windows
	doins "${PN}-${PV}.iso"
	dosym "${PN}-${PV}.iso" "/usr/share/drivers/windows/${PN}.iso"
}

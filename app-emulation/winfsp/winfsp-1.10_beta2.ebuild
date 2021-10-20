# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="1.10.21164"
MY_DNLD_PV="${PV//_beta/B}"

DESCRIPTION="WinFsp · Windows File System Proxy."
HOMEPAGE="https://github.com/billziss-gh/winfsp"
SRC_URI="https://github.com/billziss-gh/winfsp/releases/download/v${MY_DNLD_PV}/${PN}-${MY_PV}.msi"

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
	mkisofs -lJR -iso-level 4 -o "${PN}-${MY_PV}.iso" "${PN}"
	rm -R "${PN}"
	eapply_user
}

src_install() {
	insinto /usr/share/drivers/windows
	doins "${PN}-${MY_PV}.iso"
	dosym "${PN}-${MY_PV}.iso" "/usr/share/drivers/windows/${PN}.iso"
}

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=$(ver_rs 2 -)
MY_PN="virtio-win10-prewhql"

DESCRIPTION="VirtIO drivers for Windows virtual machines running on KVM based on upstream content. They may contain experimental drivers."
HOMEPAGE="https://docs.fedoraproject.org/en-US/quick-docs/creating-windows-virtual-machines-using-virtio-drivers/index.html"
SRC_URI="https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/upstream-virtio/${MY_PN}-${MY_PV}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="app-cdr/cdrtools"

S="${WORKDIR}"

src_unpack() {
	mkdir "${PN}"
	cd "${PN}"
	unpack ${A}
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

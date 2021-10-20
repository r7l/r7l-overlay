# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Ebuild also allows to download .iso file with given host software for Windows.

EAPI=7

MY_PN="LookingGlass"
MY_PV="${PV//1_beta/B}"

inherit cmake git-r3 tmpfiles

EGIT_COMMIT="25c88a1c6ca77c2db5f1fcef3458e3083b7bfaa7"
EGIT_REPO_URI="https://github.com/gnif/LookingGlass"

DESCRIPTION="A low latency KVM FrameRelay implementation for guests with VGA PCI Passthrough"
HOMEPAGE="https://looking-glass.io https://github.com/gnif/LookingGlass/"
SRC_URI="https://looking-glass.io/ci/host/source?id=715 -> ${PN}-${MY_PV}.tar.gz
	host? ( https://looking-glass.io/ci/host/download?id=715 -> ${PN}-${MY_PV}-host.zip )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug +host"

RDEPEND="dev-libs/libconfig:0=
	dev-libs/nettle:=[gmp]
	media-libs/freetype:2
	media-libs/fontconfig:1.0
	media-libs/libsdl2
	media-libs/sdl2-ttf
	virtual/glu"
DEPEND="${RDEPEND}
	app-emulation/spice-protocol
	dev-libs/wayland-protocols"
BDEPEND="virtual/pkgconfig
	host? ( app-arch/unzip )
	host? ( app-cdr/cdrtools )"

S="${WORKDIR}/${PN}"

CMAKE_USE_DIR="${S}"/client

src_unpack() {

	for FILE in ${A}; do
		if [[ "${FILE}" == *".tar.gz" ]]; then
			# unpack source files
			unpack "${FILE}"
			mv "${WORKDIR}/${PN}-${MY_PV}" "${WORKDIR}/${PN}"
		fi

		if [[ "${FILE}" == *".zip" ]]; then
	                # Extract the host exe file
	                mkdir "${PN}-host"
	                cd "${PN}-host"
	                # we need to use unzip manually here as we need to provide a password
	                unzip -P "${EGIT_COMMIT:0:8}" "${DISTDIR}/${FILE}"
                fi
	done

}

src_prepare() {
	default

	# Respect FLAGS
	sed -i -e '/CMAKE_C_FLAGS/s/-O2 -march=native //' \
		-e "/git/s/git describe --always --long --dirty --abbrev=10 --tags/echo ${MY_PV}/" \
		client/CMakeLists.txt || die "sed failed for FLAGS and COMMAND"

	if ! use debug ; then
		sed -i '/CMAKE_C_FLAGS/s/-g //' \
		client/CMakeLists.txt || die "sed failed for debug"
	fi

	if use host ; then
		# Host file comes as zip but we need it to be .iso in order to mount it in QEMU"
		mkisofs -lJR -iso-level 4 -o "${PN}-host-${MY_PV}.iso" "${WORKDIR}/${PN}-host"
		rm -R "${WORKDIR}/${PN}-host"
	fi

	cmake_src_prepare
}

src_install() {
	einstalldocs

	dobin "${BUILD_DIR}"/looking-glass-client
	newtmpfiles "${FILESDIR}"/${PN}-tmpfiles.d ${PN}.conf

	if use host ; then
		insinto /usr/share/drivers/windows
		doins "${PN}-host-${MY_PV}.iso"
		dosym "${PN}-host-${MY_PV}.iso" "/usr/share/drivers/windows/${PN}-host.iso"
	fi
}

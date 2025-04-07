# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Ebuild also allows to download Windows host software as mountable .iso file.

EAPI=8

MY_PN="LookingGlass"
MY_PV="${PV//1_beta/B}"
MY_PV="${MY_PV//_/-}"

inherit cmake linux-mod-r1 desktop tmpfiles xdg

DESCRIPTION="A low latency KVM FrameRelay implementation for guests with VGA PCI Passthrough"
HOMEPAGE="https://looking-glass.io"
SRC_URI="https://looking-glass.io/artifact/${MY_PV}/source -> ${PN}-${MY_PV}.tar.gz
	host? ( https://looking-glass.io/artifact/${MY_PV}/host -> ${PN}-${MY_PV}-host.zip )"

S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnome +host modules obs opengl pipewire pulseaudio wayland X"

RDEPEND="media-libs/fontconfig:1.0
	media-libs/libglvnd
	sys-libs/binutils-libs:=
	x11-libs/libxkbcommon
	obs? ( media-video/obs-studio )
	opengl? ( virtual/opengl )
	pipewire? ( media-video/pipewire:=
		media-libs/libsamplerate )
	pulseaudio? ( media-libs/libpulse
		media-libs/libsamplerate )
	X? ( x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXfixes
		x11-libs/libXScrnSaver
		x11-libs/libXinerama
		x11-libs/libXcursor
		x11-libs/libXpresent )
	wayland? ( dev-libs/wayland
		gnome? ( gui-libs/libdecor ) )"
DEPEND="${RDEPEND}
	app-emulation/spice-protocol
	dev-libs/wayland-protocols"
BDEPEND="virtual/pkgconfig
	host? (
		app-arch/unzip
		app-cdr/cdrtools
	)
	wayland? ( dev-util/wayland-scanner )"

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
	                unpack "${FILE}"
		fi
	done

}

src_prepare() {
	default

	if use host ; then
		# Host file comes as zip but we need it to be .iso in order to mount it in QEMU
		mkisofs -lJR -iso-level 4 -o "${PN}-host-${MY_PV}.iso" "${WORKDIR}/${PN}-host" \
			|| die "mkisofs failed"
		rm -R "${WORKDIR}/${PN}-host"
	fi

	# override warning
	sed -i '1 i\#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"' \
		host/platform/Linux/capture/pipewire/src/portal.c || die "sed failed"

	for project in client$(usex host ' host' '')$(usex obs ' obs' '') ; do
		CMAKE_USE_DIR="${S}/${project}"
		cmake_src_prepare "$@"
	done
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_EGL=ON
		-DENABLE_LIBDECOR="$(usex gnome)"
		-DENABLE_OPENGL="$(usex opengl)"
		-DENABLE_PIPEWIRE="$(usex pipewire)"
		-DENABLE_PULSEAUDIO="$(usex pulseaudio)"
		-DENABLE_WAYLAND="$(usex wayland)"
		-DENABLE_X11="$(usex X)"
	)

	for project in client$(usex host ' host' '')$(usex obs ' obs' '') ; do
		CMAKE_USE_DIR="${S}/${project}"
		BUILD_DIR="${CMAKE_USE_DIR}_build"
		cmake_src_configure "$@"
	done
	set_arch_to_kernel
}

src_compile() {
	for project in client$(usex host ' host' '')$(usex obs ' obs' '') ; do
		CMAKE_USE_DIR="${S}/${project}"
		BUILD_DIR="${CMAKE_USE_DIR}_build"
		cmake_src_compile "$@"
	done

	local modlist=( kvmfr=misc:module )
	local modargs=( KVER="${KV_FULL}" KDIR="${KV_OUT_DIR}" )
	use modules && linux-mod-r1_src_compile
}

src_install() {
	einstalldocs

	for project in client$(usex host ' host' '')$(usex obs ' obs' '') ; do
		CMAKE_USE_DIR="${S}/${project}"
		BUILD_DIR="${CMAKE_USE_DIR}_build"
		cmake_src_install "$@"
	done

	#dobin "${BUILD_DIR}"/looking-glass-client
	newtmpfiles "${FILESDIR}"/looking-glass.tmpfile looking-glass.conf
	newicon -s 128 "${S}"/resources/icon-128x128.png looking-glass-client.png

	domenu "${FILESDIR}"/looking-glass.desktop

	if use host ; then
		insinto /usr/share/drivers/windows
		doins "${PN}-host-${MY_PV}.iso"
		dosym "${PN}-host-${MY_PV}.iso" "/usr/share/drivers/windows/${PN}-host.iso"
	fi

	use modules && linux-mod-r1_src_install
}

pkg_postinst() {
	tmpfiles_process looking-glass.conf
	xdg_pkg_postinst
	use modules && linux-mod-r1_pkg_postinst
}

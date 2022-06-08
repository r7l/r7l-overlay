# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson systemd

DESCRIPTION="Makes power profiles handling available over D-Bus."
HOMEPAGE="https://gitlab.freedesktop.org/hadess/power-profiles-daemon"
SRC_URI="https://gitlab.freedesktop.org/hadess/${PN}/-/archive/${PV}/${PN}-${PV}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
IUSE="doc"

KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

BDEPEND=">=dev-libs/libgudev-234
	>=sys-auth/polkit-0.114
	sys-power/upower
	dev-util/umockdev
	dev-python/python-dbusmock
"
DEPEND="${BDEPEND}"

src_configure() {
    local emesonargs=(
        $(meson_use doc gtk_doc)
    )
    meson_src_configure
}

src_install() {
    meson_src_install
    systemd_enable_service multi-user.target ${PN}.service
}

pkg_postinst() {
    ewarn "Don't forget to enable \"${PN}\" service, by runnning:"
    ewarn "systemctl daemon-reload && systemctl enable --now ${PN}"
}

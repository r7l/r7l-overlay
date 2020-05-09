# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="SDK/C language API for Spotify"
HOMEPAGE="https://developer.spotify.com/technologies/libspotify/"
SRC_URI="https://github.com/mopidy/libspotify-deb/archive/v12.1.103-0mopidy1.tar.gz"

LICENSE="libspotify Boost-1.0 MIT BSD ZLIB CPOL"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	if [[ -n ${A} ]]; then
		unpack ${A}
	fi
	mv $S/libspotify-deb-12.1.103-0mopidy1/libspotify/amd64/* .
}

src_configure() {
	sed -i \
		-e "s|PKG_PREFIX|${EROOT}/usr|" \
		-e "s|/lib|/$(get_libdir)|" \
		lib/pkgconfig/libspotify.pc || die
}

src_compile() { :; }

src_install() {
	insinto /usr/$(get_libdir)
	doins lib/libspotify.so*

	insinto /usr/$(get_libdir)/pkgconfig
	doins lib/pkgconfig/libspotify.pc

	insinto /usr/include
	doins -r include/libspotify
}
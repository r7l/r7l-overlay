# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Universal Driver package and toolset for printing on Kyocera-based printers."
HOMEPAGE="https://kyoceradocumentsolutions.com"
SRC_URI="https://www.kyoceradocumentsolutions.co.uk/content/download-center/gb/drivers/all/Linux_Universal_Driver_zip.download.zip -> ${P}.zip"

LICENSE="GPL-2 kyocera-mita-ppds"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

BDEPEND="app-arch/unzip"
RDEPEND="
	net-print/cups
	net-print/cups-filters
	<dev-python/pypdf-4.0
	dev-python/reportlab
"

S="${WORKDIR}"

src_prepare() {

	default

	local DEB_PV=$(echo "${PV}" | cut -c -3)
	local MY_PV=$(echo "${PV}" | cut -c 5-)
	local DEB_FILE="kyodialog_${DEB_PV}-0_amd64.deb"

	# Extract the downloaded files
	tar -xzf "KyoceraLinuxPackages-${MY_PV}.tar.gz" "Debian/Global/kyodialog_amd64/${DEB_FILE}" --strip-components=3
	ar x "${DEB_FILE}"
	rm "${DEB_FILE}"

	tar -xzf data.tar.gz

	# Prepare ppd files
	mkdir "${S}/ppd"
	mv "usr/share/kyocera${DEB_PV}/ppd${DEB_PV}"/* "${S}/ppd"
	sed -i "s|/usr/lib/cups/filter|/usr/libexec/cups/filter|g" "${S}/ppd"/*.ppd

	# Prepare cups-filters
	mkdir "${S}/cups-filters"
	mv "usr/lib/cups/filter"/* "${S}/cups-filters"
	sed -i "s|PyPDF3|pypdf|g" "${S}/cups-filters/kyofilter_pre_H"

}

src_install() {

	insinto /usr/share/cups/model/kyocera
	doins ppd/*

	insinto /usr/libexec/cups/filter
	doins cups-filters/*

	chmod 755 "${D}"/usr/libexec/cups/filter/kyofilter*

}

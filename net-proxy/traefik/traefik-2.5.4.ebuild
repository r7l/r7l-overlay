# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_/-}"
CODENAME="cheddar"
EGO_PN="github.com/traefik/${PN}"

inherit golang-vcs-snapshot systemd

DESCRIPTION="A modern HTTP reverse proxy and load balancer made to deploy microservices"
HOMEPAGE="https://traefik.io"
SRC_URI="https://${EGO_PN}/releases/download/v${MY_PV}/${PN}-v${MY_PV}.src.tar.gz -> ${P}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="debug"

DEPEND="acct-group/traefik
        acct-user/traefik
        =dev-go/go-bindata-1.0.0"
RDEPEND="${DEPEND}"
BDEPEND=">net-libs/nodejs-13
        <net-libs/nodejs-15"

N="${WORKDIR}/${P}/src/${EGO_PN}/webui"
G="${WORKDIR}/${P}"
S="${G}/src/${EGO_PN}"

pkg_pretend() {
        (has network-sandbox ${FEATURES}) && die "You need to disable 'network-sandbox' for this Ebuild in FEATURES"
}

src_compile() {
        echo "Build Traefik WebUI"

        cd "${N}"
        mkdir -p "${N}/static"
        rm package-lock.json
        npm install
        npm run build:nc

        echo "Build Traefik Binary"

        cd "${S}"

        export GOPATH="${G}"
        local PATH="${G}/bin:$PATH"
        local MY_LDFLAGS=(
                "$(usex !debug '-s -w' '')"
                -X "${EGO_PN}/v2/pkg/version.Version=${MY_PV}"
                -X "${EGO_PN}/v2/pkg/version.Codename=${CODENAME}"
                -X "'${EGO_PN}/v2/pkg/version.BuildDate=$(date -u '+%Y-%m-%d_%I:%M:%S%p')'"
        )
        local MY_GO_ARGS=(
                -v -work -x
                -asmflags "all=-trimpath=${S}"
                -gcflags "all=-trimpath=${S}"
                -ldflags "${MY_LDFLAGS[*]}"
        )

        go generate || die
        CGO_ENABLED=0 GOGC=off go build "${MY_GO_ARGS[@]}" -a -installsuffix nocgo ./cmd/traefik
}

src_test() {
        ./script/make.sh test-unit || die
}

src_install() {
        dobin traefik
        use debug && dostrip -x /usr/bin/traefik
        einstalldocs

        newinitd "${FILESDIR}/${PN}.initd" "${PN}"
        newconfd "${FILESDIR}/${PN}.confd" "${PN}"
        systemd_dounit "${FILESDIR}/${PN}.service"

        insinto /etc/traefik
        newins traefik.sample.toml traefik.toml.example

        diropts -o traefik -g traefik -m 0750
        keepdir /var/log/traefik
}

pkg_postinst() {
        if [[ ! -e "${EROOT}/etc/traefik/traefik.toml" ]]; then
                elog "No traefik.toml found, copying the example over"
                cp "${EROOT}"/etc/traefik/traefik.toml{.example,} || die
        else
                elog "traefik.toml found, please check example file for possible changes"
        fi
}

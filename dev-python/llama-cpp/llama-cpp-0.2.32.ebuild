# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=scikit-build-core

inherit distutils-r1

DESCRIPTION="Python bindings for llama.cpp"
HOMEPAGE="https://github.com/abetlen/llama-cpp-python"
SRC_URI="https://github.com/abetlen/llama-cpp-python/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE="examples server"

DEPEND="
	~app-misc/llama-cpp-20240124
	dev-python/diskcache
	dev-python/numpy
	dev-python/typing-extensions
	server? (
		dev-python/uvicorn
		dev-python/fastapi
		>=dev-python/pydantic-2.0
		dev-python/pydantic-settings
		dev-python/sse-starlette
		dev-python/starlette-context
	)
"
RDEPEND="${DEPEND}"

S="${WORKDIR}/llama-cpp-python-${PV}"

src_prepare() {
	if ! use examples ; then
		rm -R examples
	fi

	# Remove the vendor as it has its own Ebuild
	rm -R vendor
	sed -i -e '/option.*/d' CMakeLists.txt || die

	# use Gentoo /usr/lib64
	sed -i 's/_base_path = pathlib.*/_base_path = pathlib.Path("\/usr\/lib64\")/g' llama_cpp/llama_cpp.py

	distutils-r1_src_prepare
}

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1

DESCRIPTION="Python bindings for llama.cpp"
HOMEPAGE="https://github.com/abetlen/llama-cpp-python"
SRC_URI="https://github.com/abetlen/llama-cpp-python/archive/refs/tags/v${PV}.tar.gz -> ${PN}-${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

DEPEND="
	~app-misc/llama-cpp-20230818
	dev-python/diskcache
	dev-python/numpy
	dev-python/typing-extensions
"
RDEPEND="${DEPEND}"
BDEPEND=""

S="${WORKDIR}/llama-cpp-python-${PV}"

src_prepare() {
	# prevent building of llama-cpp directly
	sed -i 's/^from skbuild.*/from setuptools import setup/g' setup.py
	# use Gentoo /usr/lib64
	sed -i 's/_base_path = pathlib.*/_base_path = pathlib.Path("\/usr\/lib64\")/g' llama_cpp/llama_cpp.py

	distutils-r1_src_prepare
}

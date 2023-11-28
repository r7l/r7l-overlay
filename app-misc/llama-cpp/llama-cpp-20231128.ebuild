# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_PN="llama.cpp"
MY_PV="b1573"

DESCRIPTION="Port of Facebook's LLaMA model in C/C++"
HOMEPAGE="https://github.com/ggerganov/llama.cpp"
SRC_URI="https://github.com/ggerganov/llama.cpp/archive/refs/tags/${MY_PV}.tar.gz -> ${MY_PN}-${MY_PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="blas cublas lto tests tools rocm"
CPU_FLAGS_X86=( avx avx2 f16c )

DEPEND="blas? ( sci-libs/openblas:= )
	cublas? ( dev-util/nvidia-cuda-toolkit )
	rocm? ( sci-libs/rocBLAS )"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_PN}-${MY_PV}"

src_configure() {
	if use rocm ; then
		CC=/usr/lib/llvm/${LLVM_MAX_SLOT}/bin/clang
		CXX=/usr/lib/llvm/${LLVM_MAX_SLOT}/bin/clang++
		export DEVICE_LIB_PATH=/usr/lib/amdgcn/bitcode
		export HIP_DEVICE_LIB_PATH=/usr/lib/amdgcn/bitcode
	fi
	local mycmakeargs=(
		-DLLAMA_BLAS="$(usex blas)"
		-DLLAMA_CUBLAS="$(usex cublas)"
		-DLLAMA_LTO="$(usex lto)"
		-DLLAMA_BUILD_TESTS="$(usex tests)"
		-DLLAMA_HIPBLAS="$(usex rocm)"
		-DLLAMA_BUILD_SERVER=OFF
		-DCMAKE_SKIP_BUILD_RPATH=ON
		-DBUILD_NUMBER="1"
	)
	if use cublas ; then
		addpredict /dev/nvidiactl
	fi
	cmake_src_configure
}

src_install() {
	doheader llama.h

	cd "${BUILD_DIR}" || die

	dolib.so libllama.so

	newbin bin/main llama-cpp

	if use tools ; then
		newbin bin/benchmark llama-cpp-benchmark
		newbin bin/perplexity llama-cpp-perplexity
		newbin bin/q8dot llama-cpp-q8dot
		newbin bin/quantize llama-cpp-quantize
		newbin bin/quantize-stats llama-cpp-quantize-stats
		newbin bin/vdot llama-cpp-vdot
	fi

}

pkg_postinst() {
	elog "The main binary has been installed as \"llama-cpp\""
}

# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NUPACK, a software suite for design and analysis of nucleic acid structures"
HOMEPAGE="http://nupack.org/"

REPO="https://github.com/zchen15/cryptic_overlay/raw/master/sci-biology/${PN}/files"
SRC_URI="${REPO}/${PV}.tar.gz -> nupack.tar.gz
		${REPO}/rebind.tar.gz
		${REPO}/cmake-modules.tar.gz
		${REPO}/backward-cpp.tar.gz
		${REPO}/find-tbb.tar.gz
		${REPO}/nupack-draw.tar.gz
		${REPO}/gecode.tar.gz
		${REPO}/visualization.tar.gz
		https://github.com/remymuller/boost.simd/archive/v4.17.6.0.tar.gz -> boost-simd.tar.gz
		https://github.com/nlohmann/json/archive/v3.7.3.tar.gz -> json.tar.gz
		https://github.com/sakra/cotire/archive/cotire-1.8.1.tar.gz -> cotire.tar.gz
		https://github.com/Eyescale/CMake/archive/2018.02.tar.gz -> cmake-common.tar.gz
		https://github.com/gabime/spdlog/archive/v1.5.0.tar.gz -> spdlog.tar.gz"
#https://github.com/Gecode/gecode/archive/release-6.2.0.tar.gz -> gecode.tar.gz
#SRC_URI="https://github.com/mfornace/${PN}/archive/4.0.a2.tar.gz -> nupack.tar.gz"
S="${WORKDIR}/nupack-4.0.a2"

PYTHON_COMPAT=( python3_{6,7,8} )
inherit distutils-r1

KEYWORDS="~amd64 ~x86"
SLOT=0
IUSE="cpu_flags_x86_sse2 tbb bokeh matplotlib jupyter"

RDEPEND="sci-libs/scipy
		dev-python/numpy
		dev-lang/python
		bokeh? ( dev-python/bokeh )
		matplotlib? ( dev-python/matplotlib )
		jupyter? ( dev-python/jupyter )"
BDEPEND="tbb? ( dev-cpp/tbb )
		sci-libs/armadillo
		dev-libs/boost
		dev-libs/spdlog"
DEPEND=""

pkg_pretend() {
	if ! use cpu_flags_x86_sse2 ; then
		eerror "This package requires a CPU supporting the SSE2 instruction set."
		die "SSE2 support missing"
	fi
}

src_unpack() {
	unpack nupack.tar.gz
	# unpack external modules
	for i in rebind spdlog cotire json gecode find-tbb backward-cpp cmake-modules nupack-draw visualization
	do
		echo unpacking $i
		unpack $i.tar.gz
		mv $i*/* ${S}/external/$i
	done

	echo unpacking boost.simd
	unpack boost-simd.tar.gz
	mv boost.simd*/* ${S}/external/boost-simd

	echo unpacking cmake common
	unpack cmake-common.tar.gz
	mv CMake*/* ${S}/external/cmake-common
}

src_configure() {
	mkdir ${S}/build
	cd ${S}/build
	cmake .. -DBUILD_TESTING=OFF -DREBIND_PYTHON=python -DCMAKE_CXX_COMPILER=clang++ -DCMAKE_C_COMPILER=clang -DNUPACK_SIMD_FLAGS="-msse;-msse2;-msse3;-msse4" -DCMAKE_CXX_FLAGS="-D_GLIBCXX_USE_CXX11_ABI=1 -fPIC -DJSON_USE_INT64_DOUBLE_CONVERSION=1" -DCMAKE_BUILD_TYPE=Release -DCMAKE_POSITION_INDEPENDENT_CODE=ON
}

src_compile() {
	cd ${S}/build
	cmake --build . --target python
}

src_install() {
	cd ${S}/build
	#distutils-r1_python_install
	echo python_get_sitedir
	esetup.py install
	python_optimize
}


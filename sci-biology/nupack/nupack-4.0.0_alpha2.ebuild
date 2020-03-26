# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NUPACK, a software suite for design and analysis of nucleic acid structures"
HOMEPAGE="http://nupack.org/"

REPO="https://github.com/zchen15/cryptic_overlay/raw/master/sci-biology/${PN}/files"
SRC_URI="${REPO}/${PV}.tar.gz -> nupack.tar.gz
		${REPO}/rebind.tar.gz
		${REPO}/find-tbb.tar.gz
		${REPO}/boost-simd.tar.gz
		${REPO}/spdlog.tar.gz
		${REPO}/json.tar.gz
		${REPO}/cmake-modules.tar.gz
		${REPO}/cmake-common.tar.gz
		${REPO}/backward-cpp.tar.gz
		${REPO}/cotire.tar.gz
		${REPO}/nupack-draw.tar.gz
		${REPO}/visualization.tar.gz
		${REPO}/gecode.tar.gz"
#SRC_URI="https://github.com/mfornace/${PN}/archive/4.0.a2.tar.gz -> nupack.tar.gz"
S="${WORKDIR}/nupack-4.0.a2"

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
	for i in rebind find-tbb boost-simd spdlog cotire json gecode backward-cpp cmake-modules cmake-common visualization nupack-draw
	do
		echo unpacking $i
		unpack $i.tar.gz
		mv ${WORKDIR}/$i/* ${S}/external/$i/
		rmdir ${WORKDIR}/$i
	done
}

src_configure() {
	mkdir ${S}/build
	cd ${S}/build
	cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF
}

src_compile() {
	cd ${S}/build
	emake
}

#src_install() {
#}

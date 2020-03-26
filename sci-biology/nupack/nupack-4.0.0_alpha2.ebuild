# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NUPACK, a software suite for design and analysis of nucleic acid structures"
HOMEPAGE="http://nupack.org/"
SRC_URI="https://github.com/zchen15/cryptic_overlay/sci-biology/nupack/files/${PV}.tar.gz"
#SRC_URI="https://github.com/mfornace/${PN}/archive/4.0.a2.tar.gz -> nupack.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT=0
IUSE="cpu_flags_x86_sse2 bokeh matplotlib jupyter"

RDEPEND="sci-libs/scipy
		sci-libs/numpy
		dev-lang/python
		bokeh? ( dev-python/bokeh )
		matplotlib? ( dev-python/matplotlib )
		jupyter? ( dev-python/jupyter )"
BDEPEND="dev-cpp/tbb
		sci-libs/armadillo
		dev-libs/boost"
DEPEND=""

pkg_pretend() {
	if ! use cpu_flags_x86_sse2 ; then
		eerror "This package requires a CPU supporting the SSE2 instruction set."
		die "SSE2 support missing"
	fi
}

src_unpack() {
	unpack nupack.tar.gz
	#unpack zlib.tar.gz
	#mv ${WORKDIR}/zlib-*/* ${S}/vendor/bioparser/vendor/zlib
}

src_configure() {
	mkdir ${S}/build
	cd ${S}/build
	cmake -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF ..
}

src_compile() {
	cd ${S}/build
	make
}


src_compile() {
	cmake -DCMAKE_BUILD_TYPE=Release
	emake \
			CC="$(tc-getCC)" \
			CPP="$(tc-getCXX)" \
			CXX="$(tc-getCXX)" \
			CFLAGS="" \
			CXXFLAGS="" \
			EXTRA_FLAGS="${LDFLAGS}" \
			RELEASE_FLAGS="${CXXFLAGS} -msse2" \
			WITH_TBB="$(usex tbb 1 0)"
}

src_install() {
	dobin ${PN}2 ${PN}2-*

	exeinto /usr/libexec/${PN}2
	doexe scripts/*

	newman MANUAL ${PN}2.1
	einstalldocs

	if use examples; then
		insinto /usr/share/${PN}2
		doins -r example
	fi
}

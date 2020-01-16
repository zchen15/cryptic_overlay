# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Popular short read aligner for Next-generation sequencing data"
HOMEPAGE="http://nupack.org/"
SRC_URI="mirror://github.com/mfornance/nupack/${PN}-bio/${PN}2/${PV}/${PN}2-${PV}-source.zip"

KEYWORDS="~amd64 ~x86"

IUSE="cpu_flags_x86_sse2 +tbb"

RDEPEND="tbb? ( dev-cpp/tbb )"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${PN}2-${PV}"

DOCS=( AUTHORS NEWS TUTORIAL )
HTML_DOCS=( doc/{manual.html,style.css} )
PATCHES=( "${FILESDIR}/${PN}-2.2.9-fix-c++14.patch" )

pkg_pretend() {
	if ! use cpu_flags_x86_sse2 ; then
		eerror "This package requires a CPU supporting the SSE2 instruction set."
		die "SSE2 support missing"
	fi
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

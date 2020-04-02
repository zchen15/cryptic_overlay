# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Multi-sequence alignment using SIMD accelerated partial order align graphs"
HOMEPAGE="https://github.com/rvaser/spoa"
SRC_URI="https://github.com/rvaser/spoa/archive/${PV}.tar.gz -> spoa.tar.gz
		https://github.com/rvaser/bioparser/archive/2.1.2.tar.gz -> bioparser.tar.gz
		https://github.com/madler/zlib/archive/v1.2.11.tar.gz -> zlib.tar.gz"
LICENSE="MIT"
SLOT="0"
IUSE="cpu_flags_x86_sse4_2 cpu_flags_x86_sse4_1"
KEYWORDS="amd64 x86"

DEPEND=""
BDEPEND=""
RDEPEND=""

pkg_pretend() {
	if ! use cpu_flags_x86_sse4_2 and ! use cpu_flags_x86_sse4_1 ; then
		eerror "This package requires a CPU supporting the SSE4 instruction set."
		die "SSE4 support missing"
	fi
}

src_unpack() {
	unpack spoa.tar.gz
	unpack bioparser.tar.gz
	mv ${WORKDIR}/bioparser-*/* ${S}/vendor/bioparser
	unpack zlib.tar.gz
	mv ${WORKDIR}/zlib-*/* ${S}/vendor/bioparser/vendor/zlib
}

src_configure() {
	mkdir ${S}/build
	cd ${S}/build
	cmake -DCMAKE_BUILD_TYPE=Release -Dspoa_build_executable=ON ..
}

src_compile() {
	cd ${S}/build
	emake
}

src_install() {
	dobin ${S}/build/bin/spoa
}

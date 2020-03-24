# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Multi-sequence alignment using SIMD accelerated partial order align graphs"
HOMEPAGE="https://github.com/rvaser/spoa"
SRC_URI="https://github.com/rvaser/spoa/archive/${PV}.tar.gz"
LICENSE="MIT"
SLOT="0"
IUSE="cpu_flags_x86_sse4_2 cpu_flags_x86_sse4_1"
KEYWORDS="~amd64 ~x86"

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
	echo getting the build directory
	echo ${WORKDIR}
	git clone --recursive https://github.com/rvaser/spoa spoa-${PV}
}

src_configure() {
	mkdir ${WORKDIR}/spoa-${PV}/build
	cd ${WORKDIR}/spoa-${PV}/build
	cmake -DCMAKE_BUILD_TYPE=Release -Dspoa_build_executable=ON ..
}

src_compile() {
	cd ${WORKDIR}/spoa-${PV}/build
	make
}

src_install() {
	dobin ${WORKDIR}/spoa-${PV}/build/bin/spoa
}

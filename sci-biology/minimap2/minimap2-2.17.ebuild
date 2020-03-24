# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A versatile pairwise aligner for genomic and spliced nucleotide sequences"
HOMEPAGE="https://lh3.github.io/minimap2"
SRC_URI="https://github.com/lh3/${PN}/archive/v${PV}.tar.gz"

LICENSE="MIT"
SLOT="0"
IUSE="cpu_flags_x86_sse4_2 cpu_flags_x86_sse4_1"
KEYWORDS="~amd64 ~x86"

DEPEND="sys-libs/zlib "
BDEPEND=""
RDEPEND=""

pkg_pretend() {
	if ! use cpu_flags_x86_sse4_2 and ! use cpu_flags_x86_sse4_1 ; then
		eerror "This package requires a CPU supporting the SSE4 instruction set."
		die "SSE4 support missing"
	fi
	echo source directory = ${S}

}

src_compile() {
	emake
}

src_install() {
	dobin minimap2
}

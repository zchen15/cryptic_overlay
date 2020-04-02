# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Guppy basecaller for nanopore sequencers"
HOMEPAGE="https://github.com/nanoporetech/ont-guppy"
SRC_URI="https://mirror.oxfordnanoportal.com/software/analysis/${PN}_${PV}_linux64.tar.gz"
S="${WORKDIR}/ont-guppy"

LICENSE=""
SLOT="0"
IUSE=""
KEYWORDS="amd64 x86"

DEPEND=""
BDEPEND=""
RDEPEND=""

src_compile() {
	echo Installing binaries
}

src_install() {
	insinto /opt/
	doins -r ${S}
}

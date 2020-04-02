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
RDEPEND="app-crypt/mit-krb5"

src_compile() {
	echo Installing binaries
}

src_install() {
	echo linking libraries
	ln -s /usr/lib64/libidn.so.12 ${S}/lib/libidn.so.11
	rm ${S}/lib/libz.so
	echo making binaries executable
	chmod +x ${S}/bin/*
	echo removing license files
	rm ${S}/bin/THIRD_PARTY_LICENSES
	rm ${S}/bin/*.pdf
	insinto /opt/
	doins -r ${S}
}

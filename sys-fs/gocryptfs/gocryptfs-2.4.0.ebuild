EAPI=7

DESCRIPTION="Encrypted overlay filesystem written in Go"
HOMEPAGE="https://github.com/rfjakob/gocryptfs/"
SRC_URI="https://github.com/rfjakob/${PN}/releases/download/v${PV}/${PN}_v${PV}_src-deps.tar.gz -> gocryptfs.tar.gz
		https://github.com/rfjakob/${PN}/releases/download/v${PV}/${PN}_v${PV}_linux-static_amd64.tar.gz -> gocryptfs-bin.tar.gz"
S1="${WORKDIR}/${PN}_v${PV}_src-deps"
S2="${WORKDIR}/${PN}_V${PV}_linux-static_amd64.tar.gz"
S="${WORKDIR}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="ssl"

RDEPEND="sys-fs/fuse
		ssl? ( dev-libs/openssl:0 )"
BDEPEND=""
DEPEND=""

src_unpack() {
	unpack gocryptfs-bin.tar.gz
	#unpack gocryptfs.tar.gz
	#mkdir ${HOME}/go
	#ln -s ${S1}/vendor ${HOME}/go/src
	#ln -s ${S1}/ ${HOME}/go/src/github.com/rfjakob/gocryptfs
}

src_compile() {
	echo installing binaries cause build here keeps failing
	#go env -w GOPATH=${HOME}/go
	#cd ${HOME}/go/src/github.com/rfjakob/gocryptfs
	#if [ use ssl ]; then
	#	./build.bash
	#else
	#	./build-without-openssl.bash
	#fi
}

src_install() {
	doman ${WORKDIR}/gocryptfs.1
	dobin ${WORKDIR}/gocryptfs
}

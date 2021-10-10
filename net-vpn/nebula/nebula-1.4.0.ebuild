# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV=${PV/_/}
MY_P=${PN}-${MY_PV}

DESCRIPTION="tinc is an easy to configure VPN implementation"
HOMEPAGE="https://github.com/slackhq/nebula"

SRC_URI="https://github.com/slackhq/nebula/releases/download/v${MY_P}/nebula-linux-amd64.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"

DEPEND=""
RDEPEND=""

src_prepare() {
	default
	eautoreconf

	# Fix the static (failing UNKNOWN) version in the autoconf
	# NOTE: When updating the ebuild, make sure to check that this
	# line number hasn't changed in the upstream sources.
	sed -i "6d" configure.ac
	sed -i "6iAC_INIT([tinc], ${PVR})" configure.ac
}

src_configure() {
	econf \
		--enable-jumbograms \
		--disable-silent-rules \
		--enable-legacy-protocol \
		--disable-tunemu  \
		--with-systemd="$(systemd_get_systemunitdir)" \
		$(use_enable lzo) \
		$(use_enable ncurses curses) \
		$(use_enable readline) \
		$(use_enable uml) \
		$(use_enable vde) \
		$(use_enable zlib) \
		$(use_enable upnp miniupnpc) \
		$(use_with ssl openssl)
		#--without-libgcrypt \
}

src_install() {
	emake DESTDIR="${D}" install
	dodir /etc/nebula
	dodoc AUTHORS NEWS README THANKS
}

pkg_postinst() {
	elog "This package requires the tun/tap kernel device."
}

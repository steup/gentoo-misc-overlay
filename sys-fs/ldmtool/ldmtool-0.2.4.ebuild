# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 systemd autotools

DESCRIPTION="ldmtool is a Windows Logical Disk Manager (LDM) helper tool. TI enables accessing software RAID disks in linux by mapping them to device mapper devices."
HOMEPAGE="https://github.com/mdbooth/libldm"
EGIT_REPO_URI="https://github.com/mdbooth/libldm.git"
EGIT_COMMIT="libldm-${PV}"
EGIT_MIN_CLONE_TYPE="single"

LICENSE="gpl3 lgpl3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+man"

CDEPEND="
	>=dev-libs/glib-2.26
	>=dev-libs/json-glib-0.14
	>=dev-util/gtk-doc-1.14
	sys-apps/util-linux
	>=sys-fs/lvm2-1.02
	>=sys-libs/zlib-1.2
	sys-libs/readline"
DEPEND="${CDEPEND}
	man? ( dev-libs/libxslt )"
RDEPEND="${CDEPEND}"

src_prepare() {
	eapply_user
	eautoreconf
}

src_configure() {
	econf --enable-static --disable-shared
}

src_install() {
	dobin src/ldmtool
	dodoc README
	if use man ; then
		doman docs/reference/ldmtool/ldmtool.1
	fi
	systemd_dounit "${FILESDIR}"/ldm.service
}

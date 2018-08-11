# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 cmake-utils

DESCRIPTION="C interface to read and write numpy .npy and .npz files"
HOMEPAGE="https://github.com/rogersce/cnpy"

EGIT_REPO_URI="https://github.com/rogersce/cnpy.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static"
PATCHES=${FILESDIR}/cmake.patch

DEPEND="sys-libs/zlib"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(-DENABLE_STATIC="$(usex static)")
	cmake-utils_src_configure
}

# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3 cmake-utils

DESCRIPTION=""
HOMEPAGE=""

EGIT_REPO_URI="https://github.com/IntelRealSense/librealsense.git"

LICENSE=""
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="media-libs/glfw"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/remove_ldconfig.patch"
	eapply_user
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_GRAPHICAL_EXAMPLES=OFF
		-DENABLE_ZERO_COPY=ON
		-DBUILD_WITH_STATIC_CRT=OFF
	)
	cmake-utils_src_configure
}

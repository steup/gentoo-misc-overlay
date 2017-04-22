# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Open Motion Planning Library (OMPL) is a library of various planning algorithms and interfaces for trajectory planning in 3D"
HOMEPAGE="http://ompl.kavrakilab.org/core/index.html"
SRC_URI="https://github.com/ompl/ompl/archive/${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="flann ode"

DEPEND=">=dev-libs/boost-1.54 
		flann? ( >=sci-libs/flann-1.8.3 )
		ode? ( dev-games/ode )"
RDEPEND="${DEPEND}"

src_configure() {
	mycmakeargs=(-DCMAKE_INSTALL_PREFIX:PATH=/usr -DOMPL_REGISTRATION=OFF)
	cmake_comment_add_subdirectory tests
	cmake_comment_add_subdirectory demos
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make
}

src_install() {
	cmake-utils_src_install
}

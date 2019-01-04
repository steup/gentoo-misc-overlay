# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )
inherit cmake-utils python-single-r1 git-r3

DESCRIPTION="libSavitar is a c++ implementation of 3mf loading with SIP python bindings"
HOMEPAGE="https://code.alephobjects.com/source/savitar/"
EGIT_REPO_URI="https://code.alephobjects.com/source/savitar.git"
KEYWORDS=""

LICENSE="AGPL-3+"
SLOT="0/2"
IUSE="python static-libs"
KEYWORDS=""

RDEPEND="${PYTHON_DEPS}
	dev-python/sip[${PYTHON_USEDEP}]
	>=dev-python/protobuf-python-3:*[${PYTHON_USEDEP}]
	dev-libs/pugixml"
DEPEND="${RDEPEND}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_PYTHON=$(usex python ON OFF)
		-DBUILD_STATIC=$(usex static-libs ON OFF)
		-DBUILD_PUGIXML=OFF
	)
	use python && mycmakeargs+=( -DPYTHON_SITE_PACKAGES_DIR="$(python_get_sitedir)" )
	cmake-utils_src_configure
}

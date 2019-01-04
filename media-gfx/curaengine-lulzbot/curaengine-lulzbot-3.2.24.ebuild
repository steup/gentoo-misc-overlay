# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit cmake-utils eutils git-r3


DESCRIPTION="A 3D model slicing engine for 3D printing"
HOMEPAGE="https://code.alephobjects.com/source/curaengine-lulzbot"
EGIT_REPO_URI="https://code.alephobjects.com/source/curaengine-lulzbot.git"
EGIT_MIN_CLONE_TYPE="single"
EGIT_COMMIT="v${PV}"
KEYWORDS="~amd64 ~x86"

LICENSE="AGPL-3"
SLOT="0"
IUSE="doc test"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/protobuf-3
	dev-libs/libarcus-lulzbot"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen )"


src_configure() {
	local mycmakeargs=( "-DBUILD_TESTS=$(usex test ON OFF)" )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make
	if use doc; then
		doxygen
		mv docs/html . || die
		find html -name '*.md5' -or -name '*.map' -delete || die
		DOCS+=( html )
	fi
}

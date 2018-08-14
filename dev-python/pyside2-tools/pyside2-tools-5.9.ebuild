# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils multilib python-r1 virtualx git-r3

DESCRIPTION="Support tools for Qt used from Python"
HOMEPAGE="http://wiki.qt.io/PySide"
EGIT_REPO_URI="https://code.qt.io/cgit/pyside/pyside-tools.git/"
EGIT_MIN_CLONE_TYPE=shallow
EGIT_BRANCH="${PV}"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

IUSE="test"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
"

# Minimal supported version of Qt.
QT_PV="5.9:5"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-qt/qtcore-${QT_PV}
	>=dev-python/pyside2-${QT_PV}
	>=dev-python/shiboken2-${QT_PV}
"
DEPEND="${RDEPEND}
"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS="$(usex test)"
	)

	configuration() {
		local mycmakeargs=(
			-DPYTHON_SUFFIX="-${EPYTHON}"
			"${mycmakeargs[@]}"
		)
		cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	local PYTHONDONTWRITEBYTECODE
	export PYTHONDONTWRITEBYTECODE

	VIRTUALX_COMMAND="cmake-utils_src_test" python_foreach_impl virtualmake
}

src_install() {
	python_foreach_impl cmake-utils_src_install
}

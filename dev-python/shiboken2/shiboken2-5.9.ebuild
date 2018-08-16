# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils multilib python-r1 git-r3

DESCRIPTION="A tool for creating Python bindings for C++ libraries"
HOMEPAGE="http://qt-project.org/wiki/PySide"
EGIT_REPO_URI="https://code.qt.io/cgit/pyside/shiboken.git"
EGIT_BRANCH="${PV}"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

IUSE="doc test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-qt/qtcore:5
	dev-qt/qtxml:5
	dev-qt/qtxmlpatterns:5
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS )

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	configuration() {
		local mycmakeargs=(
			-DBUILD_TESTS="$(usex test)"
			-DPYTHON_EXECUTABLE="${PYTHON}"
			-DPYTHON_SITE_PACKAGES="$(python_get_sitedir)"
			-DPYTHON_SUFFIX="-${EPYTHON}"
		)

		cmake-utils_src_configure
	}
	python_foreach_impl configuration
}

src_compile() {
	python_foreach_impl cmake-utils_src_compile
}

src_test() {
	python_foreach_impl cmake-utils_src_test
}

src_install() {
	installation() {
		cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation
}

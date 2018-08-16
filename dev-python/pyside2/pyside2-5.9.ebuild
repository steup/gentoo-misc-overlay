# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils multilib python-r1 virtualx git-r3

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="http://wiki.qt.io/PySide"
EGIT_REPO_URI="https://code.qt.io/cgit/pyside/pyside.git/"
EGIT_MIN_CLONE_TYPE=shallow
EGIT_BRANCH="${PV}"

LICENSE="LGPL-2.1"
SLOT="5"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

IUSE="concurrent debug declarative designer doc help multimedia network opengl printsupport script sql svg
	test testlib webchannel webengine webkit websockets widgets X x11extras xmlpatterns"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	declarative? ( X network )
	designer? ( widgets )
	help? ( X widgets )
	multimedia? ( X network )
	opengl? ( X widgets )
	printsupport? ( X widgets )
	sql? ( widgets )
	svg? ( X widgets )
	testlib? ( widgets )
	test? ( concurrent network printsupport sql testlib widgets X x11extras )
	webchannel? ( network )
	webengine? ( network widgets? ( printsupport webchannel ) )
	webkit? ( X network printsupport widgets )
	websockets? ( network )
	widgets? ( X )
	xmlpatterns? ( network )
"

# Minimal supported version of Qt.
QT_PV="5.9:5"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-qt/qtcore-${QT_PV}
	>=dev-qt/qtxml-${QT_PV}
	concurrent? ( >=dev-qt/qtconcurrent-${QT_PV} )
	declarative? ( >=dev-qt/qtdeclarative-${QT_PV} )
	designer? ( >=dev-qt/designer-${QT_PV} )
	X? ( >=dev-qt/qtgui-${QT_PV} )
	help? ( >=dev-qt/qthelp-${QT_PV} )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV}[widgets?] )
	network? ( >=dev-qt/qtnetwork-${QT_PV} )
	opengl? ( >=dev-qt/qtopengl-${QT_PV} )
	printsupport? ( >=dev-qt/qtprintsupport-${QT_PV} )
	script? ( >=dev-qt/script-${QT_PV} )
	sql? ( >=dev-qt/qtsql-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV} )
	testlib? ( >=dev-qt/qttest-${QT_PV} )
	webchannel? ( >=dev-qt/qtwebchannel-${QT_PV} )
	webengine? ( >=dev-qt/qtwebengine-${QT_PV}[widgets?] )
	webkit? ( >=dev-qt/qtwebkit-5.9:5[printsupport] )
	websockets? ( >=dev-qt/qtwebsockets-${QT_PV} )
	widgets? ( >=dev-qt/qtwidgets-${QT_PV} )
	x11extras? ( >=dev-qt/qtx11extras-${QT_PV} )
	xmlpatterns? ( >=dev-qt/qtxmlpatterns-${QT_PV} )
"
DEPEND="${RDEPEND}
	>=dev-python/shiboken2-${PV}:${SLOT}[${PYTHON_USEDEP}]
	doc? ( 
		media-gfx/graphviz
		dev-python/sphinx
	)
	test? (
		x11-base/xorg-server[xvfb]
	)
"

src_prepare() {
	# Fix generated pkgconfig file to require the shiboken
	# library suffixed with the correct python version.
	sed -i -e '/^Requires:/ s/shiboken2$/&@SHIBOKEN_PYTHON_SUFFIX@/' \
		libpyside/pyside2.pc.in || die

	if use prefix; then
		cp "${FILESDIR}"/rpath.cmake . || die
		sed -i -e '1iinclude(rpath.cmake)' CMakeLists.txt || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS="$(usex test)"
		-DUSE_XVFB="$(usex test)"
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

	python_foreach_impl virtx emake cmake-utils_src_test
}

src_install() {
	installation() {
		cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation
}

# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils multilib python-r1 virtualx git-r3

MY_P="${PN}-qt4.8+${PV}"

DESCRIPTION="Python bindings for the Qt framework"
HOMEPAGE="http://wiki.qt.io/PySide"
EGIT_REPO_URI="https://code.qt.io/cgit/pyside/pyside.git/"
EGIT_MIN_CLONE_TYPE=shallow
EGIT_BRANCH="${PV}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux"

IUSE="X declarative designer help multimedia opengl phonon script scripttools sql svg test webkit xmlpatterns"
REQUIRED_USE="
	${PYTHON_REQUIRED_USE}
	declarative? ( X )
	designer? ( X )
	help? ( X )
	multimedia? ( X )
	opengl? ( X )
	phonon? ( X )
	scripttools? ( X script )
	sql? ( X )
	svg? ( X )
	test? ( X )
	webkit? ( X )
"

# Minimal supported version of Qt.
QT_PV="5.9:5"

RDEPEND="
	${PYTHON_DEPS}
	>=dev-python/shiboken2-${PV}:${SLOT}[${PYTHON_USEDEP}]
	>=dev-qt/qtcore-${QT_PV}[ssl]
	X? (
		>=dev-qt/qtgui-${QT_PV}[accessibility]
		>=dev-qt/qttest-${QT_PV}
	)
	declarative? ( >=dev-qt/qtdeclarative-${QT_PV} )
	designer? ( >=dev-qt/designer-${QT_PV} )
	help? ( >=dev-qt/qthelp-${QT_PV} )
	multimedia? ( >=dev-qt/qtmultimedia-${QT_PV} )
	opengl? ( >=dev-qt/qtopengl-${QT_PV} )
	phonon? ( media-libs/phonon[qt4] )
	script? ( >=dev-qt/qtscript-${QT_PV} )
	sql? ( >=dev-qt/qtsql-${QT_PV} )
	svg? ( >=dev-qt/qtsvg-${QT_PV}[accessibility] )
	webkit? ( >=dev-qt/qtwebkit-${QT_PV} )
	xmlpatterns? ( >=dev-qt/qtxmlpatterns-${QT_PV} )
	test? (
		x11-base/xorg-server[xvfb]
	)
"
DEPEND="${RDEPEND}
	>=dev-qt/qtgui-${QT_PV}
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
		$(cmake-utils_use_build test TESTS)
		$(cmake-utils_use_enable test X XVFB)
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
	installation() {
		cmake-utils_src_install
		mv "${ED}"usr/$(get_libdir)/pkgconfig/${PN}{,-${EPYTHON}}.pc || die
	}
	python_foreach_impl installation
}

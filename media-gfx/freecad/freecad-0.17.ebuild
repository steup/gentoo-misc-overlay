# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit cmake-utils eutils fdo-mime fortran-2 python-single-r1

DESCRIPTION="QT based Computer Aided Design application"
HOMEPAGE="http://www.freecadweb.org/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/FreeCAD/FreeCAD.git"
else
	SRC_URI="https://github.com/FreeCAD/FreeCAD/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-2"
SLOT="0"

IUSE="fem plot start system_kdl"

#sci-libs/libmed from science overlay for smesh
COMMON_DEPEND="
	${PYTHON_DEPS}
	dev-cpp/eigen:3
	>=dev-libs/boost-1.48[python,${PYTHON_USEDEP}]
	dev-libs/xerces-c[icu]
	dev-python/pyside2[concurrent,network,opengl,printsupport,svg,widgets,X,${PYTHON_USEDEP}]
	dev-python/pyside2-tools[${PYTHON_USEDEP}]
	media-libs/coin
	media-libs/freetype
	sci-libs/opencascade
	sys-libs/zlib
	virtual/glu
	fem? ( 
		sci-libs/libmed
		sci-libs/vtk
	)
	plot? ( dev-python/matplotlib[${PYTHON_USEDEP}] )
	system_kdl? ( sci-libs/orocos_kdl )"
RDEPEND="${COMMON_DEPEND}
		 dev-python/numpy[${PYTHON_USEDEP}]"
DEPEND="${COMMON_DEPEND}"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.14.3702-install-paths.patch
)

# https://bugs.gentoo.org/show_bug.cgi?id=352435
# https://www.gentoo.org/foundation/en/minutes/2011/20110220_trustees.meeting_log.txt
RESTRICT="bindist"

# TODO:
#   DEPEND and RDEPEND:
#		salome-smesh - science overlay
#		zipio++ - not in portage yet

S="${WORKDIR}/FreeCAD-${PV}"

DOCS=( README.md ChangeLog.txt )

pkg_setup() {
	fortran-2_pkg_setup
	python-single-r1_pkg_setup

	[[ -z ${CASROOT} ]] && die "empty \$CASROOT, run eselect opencascade set or define otherwise"
}

src_configure() {
	export QT_SELECT=5

	#-DOCC_* defined with cMake/FindOpenCasCade.cmake
	#-DCOIN3D_* defined with cMake/FindCoin3D.cmake
	local mycmakeargs=(
		-DOCC_INCLUDE_DIR="${CASROOT}"/inc
		-DOCC_LIBRARY_DIR="${CASROOT}"/$(get_libdir)
		-DCMAKE_INSTALL_DATADIR=share/${P}
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}
		-DCMAKE_INSTALL_INCLUDEDIR=include/${P}
		-DFREECAD_USE_EXTERNAL_KDL="$(usex system_kdl)"
		-DFREECAD_USE_FREETYPE="$(usex freetype)"
		-DBUILD_WEB="$(usex start)"
		-DBUILD_START="$(usex start)"
		-DBUILD_PLOT="$(usex plot)"
		-DBUILD_QT5="ON"
	)

	# TODO to remove embedded dependencies:
	#
	#	-DFREECAD_USE_EXTERNAL_ZIPIOS="ON" -- this option needs zipios++ but it's not yet in portage so the embedded zipios++
	#                (under src/zipios++) will be used
	#	salomesmesh is in 3rdparty but upstream's find_package function is not complete yet to compile against external version
	#                (external salomesmesh is available in "science" overlay)

	cmake-utils_src_configure
	einfo "${P} will be built against opencascade version ${CASROOT}"
}

src_install() {
	cmake-utils_src_install

	make_desktop_entry FreeCAD "FreeCAD" "" "" "MimeType=application/x-extension-fcstd;"

	# install mimetype for FreeCAD files
	insinto /usr/share/mime/packages
	newins "${FILESDIR}"/${PN}.sharedmimeinfo "${PN}.xml"

	# install icons to correct place rather than /usr/share/freecad
	pushd "${ED%/}"/usr/share/${P} || die
	local size
	for size in 16 32 48 64; do
		newicon -s ${size} freecad-icon-${size}.png freecad.png
	done
	doicon -s scalable freecad.svg
	newicon -s 64 -c mimetypes freecad-doc.png application-x-extension-fcstd.png
	popd || die

	python_optimize "${ED%/}"/usr/{,share/${P}/}Mod/
}

pkg_postinst() {
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

pkg_postrm() {
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
	xdg_desktop_database_update
}

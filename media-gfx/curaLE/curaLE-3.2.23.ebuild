EAPI=6

PYTHON_COMPAT=( python3_{5,6} )
inherit cmake-utils fdo-mime gnome2-utils python-single-r1 git-r3

DESCRIPTION="A 3D model slicing application for 3D printing. This is Aleph Objects version including support for their Lulzbot series of 3D printers"
HOMEPAGE="https://code.alephobjects.com/project/profile/10/"
EGIT_REPO_URI="https://code.alephobjects.com/source/cura-lulzbot.git"
EGIT_COMMIT="v${PV}"
EGIT_MIN_CLONE_TYPE="single"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+usb zeroconf"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-python/uranium-${PV:0:3}[${PYTHON_USEDEP}]
	>=media-gfx/curaengine-${PV:0:3}
	>=media-gfx/fdm-materials-${PV:0:3}
	>=dev-libs/libsavitar-${PV:0:3}:=[python,${PYTHON_USEDEP}]
	>=dev-libs/libcharon-${PV:0:3}[${PYTHON_USEDEP}]
	usb? ( dev-python/pyserial[${PYTHON_USEDEP}] )
	zeroconf? ( dev-python/zeroconf[${PYTHON_USEDEP}] )"

DEPEND="${RDEPEND}
	sys-devel/gettext"

#S="${WORKDIR}/${PN}-${PV}"
#PATCHES=( "${FILESDIR}/${PN}-3.3.0-fix-install-paths.patch" )
DOCS=( README.md )

src_configure() {
	local mycmakeargs=(
		-DPYTHON_SITE_PACKAGES_DIR="$(python_get_sitedir)"
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	doicon icons/*.png
	python_optimize "${D}${get_libdir}"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	fdo-mime_mime_database_update
	gnome2_icon_cache_update
}


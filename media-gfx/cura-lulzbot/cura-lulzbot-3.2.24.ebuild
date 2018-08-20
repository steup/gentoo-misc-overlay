# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python3_{4,5,6} )
inherit cmake-utils git-r3 fdo-mime gnome2-utils python-single-r1

DESCRIPTION="A 3D model slicing application for 3D printing"
HOMEPAGE="https://code.alephobjects.com/source/cura-lulzbot/"
EGIT_REPO_URI="https://code.alephobjects.com/source/cura-lulzbot.git"
EGIT_COMMIT="v${PV}"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+usb"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	=dev-libs/libarcus-lulzbot-${PV}[python,${PYTHON_USEDEP}]
	=dev-libs/libsavitar-lulzbot-${PV}[python,${PYTHON_USEDEP}]
	=dev-python/uranium-lulzbot-${PV}[${PYTHON_USEDEP}]
	sci-libs/scipy[${PYTHON_USEDEP}]
	usb? ( dev-python/pyserial[${PYTHON_USEDEP}] )
	dev-python/zeroconf[${PYTHON_USEDEP}]
	=media-gfx/curaengine-lulzbot-${PV}"
DEPEND="${RDEPEND}
	sys-devel/gettext"

src_prepare() {
	einfo "Patching location of version.json"
	sed -e "s:\"cura-lulzbot\",\"version.json\":\"share\", \"cura\",\"version.json\":" \
		-i cura/CuraApplication.py || die
	
	eapply_user
    cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DPYTHON_SITE_PACKAGES_DIR="$(python_get_sitedir)" )
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {

	cmake-utils_src_install
	doicon icons/*.png
	python_optimize "${D}${get_libdir}"

	einfo "Generating version.json"
	cp -R "${EROOT}"usr/share/cura/version.json .
	${PYTHON} "${FILESDIR}"/generate_version.py "${WORKDIR}"/"${P}" .
	insinto "${EROOT}"usr/share/cura
	doins version.json
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

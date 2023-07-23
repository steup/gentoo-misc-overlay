# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="A Vulkan and OpenGL overlay for monitoring FPS, temperatures etc."
HOMEPAGE="https://github.com/flightlessmango/MangoHud"
SRC_URI="https://github.com/flightlessmango/MangoHud/archive/refs/tags/v0.6.9-1.tar.gz
		https://github.com/ocornut/imgui/archive/v1.81.tar.gz
		https://wrapdb.mesonbuild.com/v2/imgui_1.81-1/get_patch -> imgui_meson_patch.zip
		https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.2.158.tar.gz
		https://wrapdb.mesonbuild.com/v2/vulkan-headers_1.2.158-2/get_patch -> vulkan_headers_meson_patch.zip
		"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="	dev-util/glslang
			dev-util/vulkan-headers
			media-libs/libglvnd
			media-libs/mesa
			x11-libs/libX11
			sys-apps/dbus
			dev-python/mako
			dev-libs/spdlog
		"
RDEPEND="${DEPEND}"
BDEPEND="	>=dev-util/meson-0.54
			dev-util/ninja
		"

S="${WORKDIR}/MangoHud-0.6.9-1"

#PATCHES=( "${FILESDIR}/mangohud-0.6.8-imgui_local_subproject.patch" )

src_unpack() {
	unpack ${A}
	cp -r ${WORKDIR}/imgui-1.81 ${S}/subprojects/imgui
	cp -r ${WORKDIR}/Vulkan-Headers-1.2.158 ${S}/subprojects/vulkan-headers
	rm ${S}/subprojects/*.wrap
}

multilib_src_configure() {
	local emesonargs=(
		-Dwith_xnvctrl=disabled
		-Dwith_nvml=disabled
#		-Duse_system_vulkan=enabled
#		-Dvulkan_datadir=/usr/share
		-Duse_system_spdlog=enabled
	)
	meson_src_configure
}

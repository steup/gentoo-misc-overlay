# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="A Vulkan and OpenGL overlay for monitoring FPS, temperatures etc."
HOMEPAGE="https://github.com/flightlessmango/MangoHud"
SRC_URI="https://github.com/flightlessmango/MangoHud/archive/refs/tags/v${PV}.tar.gz
		https://github.com/ocornut/imgui/archive/v1.81.tar.gz
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

S="${WORKDIR}/MangoHud-${PV}"

#PATCHES=( "${FILESDIR}/mangohud-0.6.8-imgui_local_subproject.patch" )

src_unpack() {
	unpack ${A}
	unzip ${FILESDIR}/mangohud-0.6.8-imgui_meson.zip
	cp -r ${WORKDIR}/imgui-1.81 ${S}/subprojects/imgui
	rm ${S}/subprojects/*.wrap
}

multilib_src_configure() {
	local emesonargs=(
		-Dwith_xnvctrl=disabled
		-Dwith_nvml=disabled
		-Duse_system_vulkan=enabled
		-Dvulkan_datadir=/usr/share
		-Duse_system_spdlog=enabled
	)
	meson_src_configure
}

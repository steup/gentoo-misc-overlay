# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="A Vulkan post processingzlayer to enhance the visual graphics of games."
HOMEPAGE="https://github.com/DadSchoorse/vkBasalt"
SRC_URI="https://github.com/DadSchoorse/vkBasalt/archive/refs/tags/v0.3.2.6.tar.gz"

LICENSE="Zlib"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="	x11-libs/libX11
			dev-util/glslang
			dev-util/spirv-headers
			dev-util/vulkan-headers
"
RDEPEND="${DEPEND}"
BDEPEND=" dev-util/meson "

S="${WORKDIR}/vkBasalt-${PV}"

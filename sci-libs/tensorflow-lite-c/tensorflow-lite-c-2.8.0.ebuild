# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="TensorFlow Lite is a mobile library for deploying models on mobile, microcontrollers and other edge devices."
HOMEPAGE="https://www.tensorflow.org/lite/"
SRC_URI="https://github.com/tensorflow/tensorflow/archive/refs/tags/v${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

IUSE="opencl"

DEPEND=">=dev-cpp/abseil-cpp-20211102-r1:="
RDEPEND="${DEPEND}"
BDEPEND=""
S=${WORKDIR}/tensorflow-${PV}
CMAKE_USE_DIR=${S}/tensorflow/lite
BUILD_DIR=${WORKDIR}/tensorflow-lite-c_build

src_prepare() {
	cmake_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-DTFLITE_ENABLE_GPU=$(usex opencl ON OFF)
	)

	cmake_src_configure
}

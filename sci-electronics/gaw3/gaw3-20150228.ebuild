# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A waveform viewer for the gEDA suite. An alternative to gwave."
HOMEPAGE="http://www.rvq.fr/linux/gaw.php"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE="sound"
SRC_URI="http://download.tuxfamily.org/gaw/download/${P}.tar.gz"

DEPEND="sound? ( >=media-libs/alsa-lib-1.0.16 )
		>=x11-libs/gtk+-2.10:2"
RDEPEND="${DEPEND}"

src_configure() {
	econf $(use_enable sound gawsound )
}

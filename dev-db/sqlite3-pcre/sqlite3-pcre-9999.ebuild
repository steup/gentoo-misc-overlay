# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit git-r3

DESCRIPTION="Perl compatible regular expression extension (PCRE) module for sqlite3"
HOMEPAGE="https://github.com/ralight/sqlite3-pcre"
EGIT_REPO_URI="https://github.com/ralight/sqlite3-pcre.git"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/sqlite:3
        dev-libs/libpcre"
RDEPEND="${DEPEND}"

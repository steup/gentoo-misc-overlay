EAPI="6"

inherit git-r3 findlib

KEYWORDS="amd64 ~i386"
SLOT="0"
LICENSE="LGPL-2"

EGIT_REPO_URI="https://gitpub.recherche.enac.fr/ivy/ivy-ocaml.git"
EGIT_CLONE_TYPE="shallow"
EGIT_COMMIT=9cb0e7768b7e0281a38686088cedeaee4d74790a

RDEPEND="dev-lang/ocaml net-libs/ivy-bus[glib]"
DEPEND="${RDEPEND} sys-devel/gcc sys-devel/binutils"

MY_PV=1.3.2

PATCHES=( "${FILESDIR}/1.3.2-disable-tcl.patch" )

src_install() {
	findlib_src_preinst
	emake COMPAT_SYMLINK_CREATE=n install || die "Installation failed!"
}

EAPI="5"

inherit subversion versionator findlib

KEYWORDS="amd64 ~i386"
SLOT="0"
LICENSE="LGPL-2"

RDEPEND="dev-lang/ocaml net-libs/ivy-bus[glib]"
DEPEND="${RDEPEND} sys-devel/gcc sys-devel/binutils"

MY_PV=$(replace_version_separator 2 "-")

ESVN_REPO_URI="https://svn.tls.cena.fr/svn/ivy/ivy-ocaml/tags/${MY_PV}"
ESVN_OPTIONS="--trust-server-cert --non-interactive"

src_install() {
	findlib_src_preinst
	emake COMPAT_SYMLINK_CREATE=n install || die "Installation failed!"
}

EAPI="5"

inherit git-r3 versionator

KEYWORDS="amd64 ~i386"
LICENSE="LGPL-2"
SLOT="0"

MY_PV=3.15

EGIT_REPO_URI="https://gitpub.recherche.enac.fr/ivy/ivy-c.git"
EGIT_CLONE_TYPE="shallow"
EGIT_COMMIT=c238c8851fe2f58008a8a290eb66c3531b4fd0b7

RDEPEND="dev-libs/libpcre"
DEPEND="${RDEPEND} sys-devel/binutils sys-devel/gcc"

IUSE="+glib"

src_compile() {
 cd src && emake libivy.so.${PV} libgivy.so.${PV}|| die "Compilation failed!"
 if use glib ; then 
 	emake libglibivy.so.${PV} || die "Compilation failed!"
 fi
}

src_install() {
	cd src
	dolib libivy.so.${PV}
	dosym libivy.so.${PV} usr/lib64/libivy.so.3
	dosym libivy.so.${PV} usr/lib64/libivy.so
	dolib libgivy.so.${PV}
	dosym libgivy.so.${PV} usr/lib64/libgivy.so.3
	dosym libgivy.so.${PV} usr/lib64/libgivy.so
	if use glib ; then
		dolib libglibivy.so.${PV}
		dosym libglibivy.so.${PV} usr/lib64/libglibivy.so.3
		dosym libglibivy.so.${PV} usr/lib64/libglibivy.so
	fi
#	dolib libtclivy.so.3.12
#	dosym libtclivy.so.3.12 usr/lib/libtclivy.so.3
#	dosym libtclivy.so.3.12 usr/lib/libtclivy.so
#	dolib libxtivy.so.3.12
#	dosym libxtivy.so.3.12 usr/lib/libxtivy.so.3
#	dosym libxtivy.so.3.12 usr/lib/libxtivy.so
#	emake DESTDIR=$D PREFIX=/usr includes
	if use glib ; then
		emake PREFIX=/usr pkgconf
		insinto /usr/lib64/pkgconfig
		doins ivy-glib.pc
	fi
	insinto usr/include/Ivy
	doins ivy.h ivychannel.h ivyloop.h ivysocket.h timer.h version.h
	if use glib ; then
		doins ivyglibloop.h	
	fi
	cd ../doc
	doman ivy-c.1 ivy-c-functions.1
}

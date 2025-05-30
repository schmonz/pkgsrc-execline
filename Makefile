# $NetBSD: Makefile,v 1.26 2025/05/13 03:42:56 schmonz Exp $

DISTNAME=		${GITHUB_PROJECT}-${GITHUB_TAG}
PKGNAME=		execline-2.9.7.0
PKGREVISION=		2
#MANPAGES_VERSION=	2.9.6.1.1
CATEGORIES=		lang shells
MASTER_SITES=		${MASTER_SITE_GITHUB:=skarnet/}
MANPAGES_DIST=		execline-man-pages-${MANPAGES_VERSION}.tar.gz
#DISTFILES=		${DISTNAME}${EXTRACT_SUFX} ${MANPAGES_DIST}
#SITES.${MANPAGES_DIST}=	-https://git.sr.ht/~flexibeast/${PKGBASE}-man-pages/archive/v${MANPAGES_VERSION}.tar.gz
GITHUB_PROJECT=		execline
GITHUB_TAG=		359693d4323b6c912447dec1291bef7a83db8bec

MAINTAINER=		schmonz@NetBSD.org
HOMEPAGE=		https://skarnet.org/software/execline/
COMMENT=		The execline scripting language
LICENSE=		isc

TOOL_DEPENDS+=		coreutils-[0-9]*:../../sysutils/coreutils

WRKMANSRC=		${WRKDIR}/${PKGBASE}-man-pages-v${MANPAGES_VERSION}

USE_TOOLS+=		gmake
TOOLS_PLATFORM.install=	${PREFIX}/bin/ginstall
HAS_CONFIGURE=		yes
CONFIGURE_ARGS+=	--prefix=${PREFIX:Q}
CONFIGURE_ARGS+=	--enable-pkgconfig
CONFIGURE_ARGS+=	--enable-shared
CONFIGURE_ARGS+=	--disable-allstatic

#INSTALL_DIRS+=		. ${WRKMANSRC}
#INSTALL_ENV+=		PREFIX=${PREFIX:Q} MAN_DIR=${PREFIX:Q}/${PKGMANDIR:Q}

PLIST_SUBST+=		SHLIBLIFETIMEMAJOR=${SHLIBLIFETIMEMAJOR}
SHLIBLIFETIMEMAJORMINOR=${PKGVERSION_NOREV:C/\.[0-9]*$//}
SHLIBLIFETIMEMAJOR=	${SHLIBLIFETIMEMAJORMINOR:C/\.[0-9]*$//}

.include "../../mk/bsd.prefs.mk"

PLIST_VARS+=		Darwin
.if ${OPSYS} == "Darwin"
PLIST.Darwin=		yes
SHLIBLIFETIME=		${SHLIBLIFETIMEMAJOR:C/\.[0-9]*$//}
PLIST_SUBST+=		SHLIBLIFETIME=${SHLIBLIFETIME}
WTF_cmd=		${EXPR} 256 '*' ${SHLIBLIFETIME} + 9
WTF=			${WTF_cmd:sh}
PLIST_SUBST+=		WTF=${WTF}
.endif

.include "../../devel/skalibs/buildlink3.mk"
.include "../../mk/bsd.pkg.mk"

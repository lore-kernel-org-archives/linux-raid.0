From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] sha1.h: remove ansidecl.h header inclusion
Date: Tue, 14 Aug 2012 09:53:46 +1000
Message-ID: <20120814095346.68a2cdec@notabene.brown>
References: <20120813122043.25583.21352.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1Eje+wW5bcqjRccS6dQGVa."; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120813122043.25583.21352.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com, ed.ciechanowski@intel.com, Jacek.Danecki@intel.com
List-Id: linux-raid.ids

--Sig_/1Eje+wW5bcqjRccS6dQGVa.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Aug 2012 14:20:43 +0200 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> Inclusion of the 'ansidecl.h' header requires the 'binutils-devel'
> package to be installed but is not needed.
>=20
> Signed-off-by: Maciej Patelczyk <maciej.patelczyk@intel.com>
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  sha1.h |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>=20
> diff --git a/sha1.h b/sha1.h
> index 5473f91..a601d96 100644
> --- a/sha1.h
> +++ b/sha1.h
> @@ -26,8 +26,6 @@
>  # include <limits.h>
>  #endif
> =20
> -#include "ansidecl.h"
> -
>  /* The following contortions are an attempt to use the C preprocessor
>     to determine an unsigned integral type that is 32 bits wide.  An
>     alternative approach is to use autoconf's AC_CHECK_SIZEOF macro, but
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


applied, thanks.

NeilBrown


--Sig_/1Eje+wW5bcqjRccS6dQGVa.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCmTijnsnt1WYoG5AQK6tw//WKerePcoLMIkcI117r+auufWijt/tvJi
g9ItJtBOIU50m8rUDK7YvM24MWWh4sdDgmySvCtXQzUQ6xtu7xZYY6Axg3+0FaVo
3obhIpdijo2wc+0Gg8cQxbGxBX5AduNyeU+6fQm1VELfMJDM6T1qugrxf2ICmitU
VgAL6nPsF0WN7Toa75QcHHMtOovCy4lpxWPiyNY8yse861R11LWHqfC4HHDNWh8S
YdhOGP0Qr0uqKBFoEtULDq5K8gl3IJQtmjPmlC0n3eun6PwLqK3sY5HXBo8zJPNP
PkRQcczCVGR05l5AbEdH7ISDPF94j2YWboFHJVbTvQK15UpznHc8xJiahrrjmhC0
sCIsIhdcxyLTSdEKYElFse38RejpYVPEiRqjghGRme6pVAxKudWrCtgYalUCDLTY
/saD0mDicvYVdM3dOOmw6oGE3up27y5ivLddYmMbOqCskBhbfmZTzA4NkzDLECvg
dV4QiyWjg3zDGqQH6/v3/PSa9M3UnRAGcg9UrY8A9So3BqcszIuoglRwAsAH/Khe
/sa3A4QWvsZ0aFOvbgJBL6ZBKoOPdgGNPyByP6hqCEzXvaGGLK5BTkh9RtOOQ9qM
8DCZJEC2zY9CAjSW0k2xvOnVYNAbDUqGy49kCwruk5698Jjr4LDv9oqTzGCn2U5t
JqBjAuJbhSs=
=gzNV
-----END PGP SIGNATURE-----

--Sig_/1Eje+wW5bcqjRccS6dQGVa.--

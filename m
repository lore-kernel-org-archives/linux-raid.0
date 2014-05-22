From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: Do not reimplment offsetof
Date: Thu, 22 May 2014 14:29:48 +1000
Message-ID: <20140522142948.1f09e4f3@notabene.brown>
References: <1400690719-3020-1-git-send-email-crrodriguez@opensuse.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Mwpl2kRZO5ED/ZiGlawLXk5"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1400690719-3020-1-git-send-email-crrodriguez@opensuse.org>
Sender: linux-raid-owner@vger.kernel.org
To: Cristian =?UTF-8?B?Um9kcsOtZ3Vleg==?= <crrodriguez@opensuse.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Mwpl2kRZO5ED/ZiGlawLXk5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 21 May 2014 12:45:19 -0400 Cristian Rodr=C3=ADguez
<crrodriguez@opensuse.org> wrote:

> Proper implementations have offsetof in stddef.h
> ---
>  Grow.c      | 5 +----
>  super-ddf.c | 5 +----
>  super1.c    | 4 +---
>  3 files changed, 3 insertions(+), 11 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index a5a9421..468ab8a 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -24,6 +24,7 @@
>  #include	"mdadm.h"
>  #include	"dlink.h"
>  #include	<sys/mman.h>
> +#include	<stddef.h>
>  #include	<stdint.h>
>  #include	<signal.h>
>  #include	<sys/wait.h>
> @@ -34,10 +35,6 @@
>  #include	"md_u.h"
>  #include	"md_p.h"
> =20
> -#ifndef offsetof
> -#define offsetof(t,f) ((size_t)&(((t*)0)->f))
> -#endif
> -
>  int restore_backup(struct supertype *st,
>  		   struct mdinfo *content,
>  		   int working_disks,
> diff --git a/super-ddf.c b/super-ddf.c
> index 37ef665..b03e9b9 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -30,6 +30,7 @@
>  #include "mdmon.h"
>  #include "sha1.h"
>  #include <values.h>
> +#include <stddef.h>
> =20
>  /* a non-official T10 name for creation GUIDs */
>  static char T10[] =3D "Linux-MD";
> @@ -531,10 +532,6 @@ static int init_super_ddf_bvd(struct supertype *st,
>  			      char *name, char *homehost,
>  			      int *uuid, unsigned long long data_offset);
> =20
> -#ifndef offsetof
> -#define offsetof(t,f) ((size_t)&(((t*)0)->f))
> -#endif
> -
>  #if DEBUG
>  static void pr_state(struct ddf_super *ddf, const char *msg)
>  {
> diff --git a/super1.c b/super1.c
> index 1bc5216..7cf9b51 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -22,6 +22,7 @@
>   *    Email: <neilb@suse.de>
>   */
> =20
> +#include <stddef.h>
>  #include "mdadm.h"
>  /*
>   * The version-1 superblock :
> @@ -133,9 +134,6 @@ struct misc_dev_info {
>  					|MD_FEATURE_NEW_OFFSET		\
>  					)
> =20
> -#ifndef offsetof
> -#define offsetof(t,f) ((size_t)&(((t*)0)->f))
> -#endif
>  static unsigned int calc_sb_1_csum(struct mdp_superblock_1 * sb)
>  {
>  	unsigned int disk_csum, csum;



Applied, thanks.

NeilBrown

--Sig_/Mwpl2kRZO5ED/ZiGlawLXk5
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU319PDnsnt1WYoG5AQIlDw//TlF/34fYJ5XQ4HWDTUJ4d1B99lkWfdpQ
O8EHR/wFn1DerBUWsT5TxE9FrEc8psnR68ZINrOgRwZ1uw7gMfo+pce+4k+w52n5
DqOC5P930VG9gWdNDPqGW8bjVp0CMJ90bMG1u9Rt1XHUoqal7H97pMrSLakf3WZb
kBfk3lyWzoVJzCHxOgI4Yyq+9LAdToEewpJ2kaFfwvfpXG81sJ5i2oWX1XlhmT8a
7ehwiAlKuMVou8e0BOo9sNBHXOZvdF7ZqaWTtKawcomk67Q3+TayEtE6v0IlD8FZ
/X0NLl07endXWvd1WZ7Lishb17PGc4X/8UcwKp3ZKHbC4ZAbaHs7ZVI/PLuq2G6p
WX2jpzPJin1Z3uWAJSB/SFX8cdtPo64/B3PSrhL9hWR5qduLdVCV6mDQBJjITjLD
/AF6pGX2HpaGJ1mKyxba0NIbQfP4PzLcOEbXWIV/XsEhrPHgIJuonX91JpEUuKgt
kL32795lTYfoPSqB18pAdFS9KnVjxCm2d5e9P0Adxk2Zy9AMcrd8+TvPW9J4kNoZ
10rzOcH/se4rcYCmHUIu2QydPFa3r58AqBB3uaUAHLgAxhSiddrXyjWNN64i8eUA
eMJHqgN8vN/rYAtlsBWP114vKcFMzxwy/W6vZjh1RLMRpfeI/jucdLIv6iFsj847
IlRiq12UtrU=
=qs1q
-----END PGP SIGNATURE-----

--Sig_/Mwpl2kRZO5ED/ZiGlawLXk5--

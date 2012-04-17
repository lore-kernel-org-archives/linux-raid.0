From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] imsm: display maximum volumes per controller and array
Date: Tue, 17 Apr 2012 12:31:41 +1000
Message-ID: <20120417123141.5330ce20@notabene.brown>
References: <F9123E44003394499FDD2B17C60621D41861C0FB@IRSMSX101.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AJUKX6xO+rKHoEOVqL14SdH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9123E44003394499FDD2B17C60621D41861C0FB@IRSMSX101.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Labun, Marcin" <Marcin.Labun@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/AJUKX6xO+rKHoEOVqL14SdH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Apr 2012 14:25:41 +0000 "Labun, Marcin" <Marcin.Labun@intel.com>
wrote:

> Display maximum volumes per array and per controller
> in --detail-platform command.
>=20
> Signed-off-by: Marcin Labun <marcin.labun@intel.com>
> ---
>  super-intel.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index dad4c4d..1e6df30 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -1783,12 +1783,13 @@ static void print_imsm_capability(const struct im=
sm_orom *orom)
>  	       imsm_orom_has_chunk(orom, 1024*16) ? " 16M" : "",
>  	       imsm_orom_has_chunk(orom, 1024*32) ? " 32M" : "",
>  	       imsm_orom_has_chunk(orom, 1024*64) ? " 64M" : "");
> -	printf("      Max Disks : %d\n", orom->tds);
> -	printf("    Max Volumes : %d\n", orom->vpa);
>  	printf("    2TB volumes :%s supported\n",
>  	       (orom->attr & IMSM_OROM_ATTR_2TB)?"":" not");
>  	printf("      2TB disks :%s supported\n",
>  	       (orom->attr & IMSM_OROM_ATTR_2TB_DISK)?"":" not");
> +	printf("    Max Disks                 : %d\n", orom->tds);
> +	printf("    Max Volumes per array     : %d\n", orom->vpa);
> +	printf("    Max Volumes per controller: %d\n", orom->vphba);
>  	return;
>  }
> =20


Thanks.  However this messes up the formatting.

I've changed it to the following, and applied.

Thanks,
NeilBrown

diff --git a/super-intel.c b/super-intel.c
index ed7792d..088e6bc 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -1783,12 +1783,13 @@ static void print_imsm_capability(const struct imsm=
_orom *orom)
 	       imsm_orom_has_chunk(orom, 1024*16) ? " 16M" : "",
 	       imsm_orom_has_chunk(orom, 1024*32) ? " 32M" : "",
 	       imsm_orom_has_chunk(orom, 1024*64) ? " 64M" : "");
-	printf("      Max Disks : %d\n", orom->tds);
-	printf("    Max Volumes : %d\n", orom->vpa);
 	printf("    2TB volumes :%s supported\n",
 	       (orom->attr & IMSM_OROM_ATTR_2TB)?"":" not");
 	printf("      2TB disks :%s supported\n",
 	       (orom->attr & IMSM_OROM_ATTR_2TB_DISK)?"":" not");
+	printf("      Max Disks : %d\n", orom->tds);
+	printf("    Max Volumes : %d per array, %d per controller\n",
+	       orom->vpa, orom->vphba);
 	return;
 }
=20

--Sig_/AJUKX6xO+rKHoEOVqL14SdH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4zWDTnsnt1WYoG5AQI+sQ//fIbJmYZTNNYci3H2v3+K+h1HD4FyEwBN
lvMIlQ1dXGEaEA2HLzQnxSeL4k6AL0cA3OdoS14fclfAq70fDMyju25bhDQjthDE
pGYVaPcov1L/5rz+bPAD1gDY3knw4raPZnqrToV/9icQhLXgB4N65Cbb8mRZlCb7
rsuJELaZxvhPkoIQLsJDuA80ZUxgQuRge5lWNH58HgsWjlWiWvVLMBn5dUcHkWM9
ShRYeN5iIO1Ce4TyBBMgIxYvxLqb3zrwiNAAWSzW01PVr7f4Dm+lJrdVEMJMxgIP
UOo/7e4viyklnn5uWTOG+XVvyDD39Vp9hYMwPkEEyVClgX97U1XdECPHOe2/Kjcj
oeDqU49ri57Qe9+wWdWpw8+MfnBlvl1by7/U6yQVdfBmyLeWXJ6I8KfgSHK/D48A
CkVa/GSNDdoqG+mc7G4F1s9Pd7q2jJR2EqlTiK9fcbajk3IVIWQII79LrKcI3Qnj
Z5xI8DiLMmvWYJnR9YkoDTYVwZXQIyEJDKJyTBDmvU/Bd/8UysCP/bz4HxWjcALQ
tnmZ+316q6fDZ9x5hoJYmzbjuiQUU8KCKiC2S5ncy1YORkx9V3XgHhr4MpQjf26j
B9UYOc7sbi9cdF93tIxSx2Qg0XRdSoAuUpMtotM9CbLH2GkQP3KM27xHAElSfs7E
LVA6rWFPt+8=
=4hn+
-----END PGP SIGNATURE-----

--Sig_/AJUKX6xO+rKHoEOVqL14SdH--

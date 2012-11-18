From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Create.c: check if freesize is equal 0
Date: Mon, 19 Nov 2012 10:56:59 +1100
Message-ID: <20121119105659.206a4487@notabene.brown>
References: <20121116162436.11415.87524.stgit@gklab-128-085.igk.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ngSM1a6ZxeNAKpF53M=gYc7"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121116162436.11415.87524.stgit@gklab-128-085.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lukasz Dorau <lukasz.dorau@intel.com>
Cc: linux-raid@vger.kernel.org, maciej.patelczyk@intel.com
List-Id: linux-raid.ids

--Sig_/ngSM1a6ZxeNAKpF53M=gYc7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 Nov 2012 17:24:36 +0100 Lukasz Dorau <lukasz.dorau@intel.com>
wrote:

> "freesize" can be equal 0 after rounding to the chunk's size.
> Creating should be aborted in such case.
>=20
> Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
> ---
>  Create.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index afcf1a5..f5b7194 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -399,6 +399,11 @@ int Create(struct supertype *st, char *mddev,
>  		if (s->chunk && s->chunk !=3D UnSet) {
>  			/* round to chunk size */
>  			freesize =3D freesize & ~(s->chunk-1);
> +			if (!freesize) {
> +				pr_err("no free space left on %s\n", dname);
> +				fail =3D 1;
> +				continue;
> +			}
>  			if (do_default_chunk) {
>  				/* default chunk was just set */
>  				if (c->verbose > 0)


I think it would be best to have this test even if chunk is not set.
So I've applied the following.

Thanks,
NeilBrown

=46rom 3339b154fdc9dcc70b9be1c5ab203d3d011f5434 Mon Sep 17 00:00:00 2001
From: Lukasz Dorau <lukasz.dorau@intel.com>
Date: Fri, 16 Nov 2012 17:24:36 +0100
Subject: [PATCH] Create.c: check if freesize is equal 0

"freesize" can be equal 0, particularly after rounding to the chunk's size.
Creating should be aborted in such case.

Signed-off-by: Lukasz Dorau <lukasz.dorau@intel.com>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/Create.c b/Create.c
index 79fdec8..a4aab41 100644
--- a/Create.c
+++ b/Create.c
@@ -408,6 +408,11 @@ int Create(struct supertype *st, char *mddev,
 				do_default_chunk =3D 0;
 			}
 		}
+		if (!freesize) {
+			pr_err("no free space left on %s\n", dname);
+			fail =3D 1;
+			continue;
+		}
=20
 		if (s->size && freesize < s->size) {
 			pr_err("%s is smaller than given size."

--Sig_/ngSM1a6ZxeNAKpF53M=gYc7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUKl1yznsnt1WYoG5AQLYMRAAj4ihwHi9xGhEfNNLV/KI4FJTbptLrxqQ
oCbeJdgTjzTkxjXL+fVrWNziN5hc6rt+hN9nWrU7X5Zi1+CVI2FvVJsd7Ef+0jOd
cdFASH/wFmmC0VDMF0sszrrz4x0TnyKJhT7iejSIGyJJPrEOm7PO0/3ZAuwzeKVK
OHOXOOAaS3kK838u0HWyweXavBpsrdCd42cyftmsryGWio/990f6mFiML9MVRLu4
Qo050zX5skmcz+Axgz2jQ0t1INHvgvcuv5HVm0adO1zrpSrG0siBBbVXQUeJfA47
QdX6oQU6U0wylAO2z4y2df+bsHlg9RLsuUkGbZB9t9xXfex0bhmst5KBisWPa2qV
JkvJqwFU5zmYHgEddVU+6l6fYDNm3Ab7+6g7ALWsTbZzH8lxKLuRkEzaLE4Cmtrf
4P0aoSfDukBwYQA6FZMC51Bk3fpFMQtfat8YAXXeNOGVsSJUfaH6eCkqow+sxgQd
DkuXlTRoJzsMEava9QB/hOxFg+0cECW3vRJSvAuWNaAM03BFnfVlolMRqE+VUKQK
qaCCyKrcYgugpQyX9pxlsCUJN7dnr3hjI7DbIlHZrkypuMcu2CMnftafPr+4ebjM
g5nAbN0UmTFPdd0ENEWGI2fxpewrhwrD4nojLmL8zfM1cy+QKVoann4l00RnCkf/
OwDDJxfbK9g=
=PoN3
-----END PGP SIGNATURE-----

--Sig_/ngSM1a6ZxeNAKpF53M=gYc7--

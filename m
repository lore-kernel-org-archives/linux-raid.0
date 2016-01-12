From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Fix wrong description in manpage
Date: Wed, 13 Jan 2016 08:26:20 +1100
Message-ID: <87oacq8p6r.fsf@notabene.neil.brown.name>
References: <1452611304-14648-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1452611304-14648-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 13 2016, Guoqing Jiang wrote:

> The careless change was introduce by 'commit 7e6e839a2651
> (mdadm: change the num of cluster node)'. Which should be
> revert to avoid misunderstanding.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  mdadm.8.in | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/mdadm.8.in b/mdadm.8.in
> index 2844039..c2f2c95 100644
> --- a/mdadm.8.in
> +++ b/mdadm.8.in
> @@ -1162,9 +1162,7 @@ is given, a random UUID is chosen.
>  The
>  .B name
>  option will change the
> -.I name
> -of the array as stored in the superblock and bitmap. This option only
> -works for clustered environment.
> +.I name.
>=20=20
>  The
>  .B nodes

Thanks, that patch was messed up.
However your patch only fixes part of the mess that was made.
I've changed it to the following.

Thanks,
NeilBrown


From: Guoqing Jiang <gqjiang@suse.com>
Date: Tue, 12 Jan 2016 18:08:24 +0300
Subject: [PATCH] Fix wrong description in manpage

The careless change was introduce by 'commit 7e6e839a2651
(mdadm: change the num of cluster node)'. Which should be
revert to avoid misunderstanding.

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
Signed-off-by: NeilBrown <neilb@suse.com>

diff --git a/mdadm.8.in b/mdadm.8.in
index 2844039584ac..97ce8dc8219b 100644
=2D-- a/mdadm.8.in
+++ b/mdadm.8.in
@@ -1163,15 +1163,15 @@ The
 .B name
 option will change the
 .I name
=2Dof the array as stored in the superblock and bitmap. This option only
=2Dworks for clustered environment.
+of the array as stored in the superblock.  This is only supported for
+version-1 superblocks.
=20
 The
 .B nodes
 option will change the
 .I nodes
=2Dof the array as stored in the superblock.  This is only supported for
=2Dversion-1 superblocks.
+of the array as stored in the bitmap superblock. This option only
+works for a clustered environment.
=20
 The
 .B homehost

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWlW98AAoJEDnsnt1WYoG5zSMP+wX9DuA8VXC8UIbSShBw1TGw
16HFGg8Y3bqJdUSxZmINw2rDUk3H4Gp9NlqI+3sjkQlEzAMIRYcq3VLqc8q9C5W9
Memaz3HgC9yaf+nFrmmH5vOKz+WSYUMmn3VZAu6zXFJbPbwzVYOWpRXA8v69hyld
E7Pp33Cn7eQ9yNOyPtCTqjbcOJSC/crNHQjbSicx8xqIa/0urTlcQGpQKfytqcr0
85l82/qAViNpGYe2CrffLQTldAN7k400iVF64Uthg4laxW8VtBHTGG3M/Z81ff1Z
sZOr2oMmGfVPHxVmv3f1C31WIDkDV5asKDyig6ScmCvIWism3wSIJzwYOy3DkzuY
8SR29JN16/uWfwgZkvGlCJ4zW/OPRb+/ZhTcu1Q1foTWX6cucOUIckD+Dwxuc8qM
7L/Sb6cukMY9R4QMB0uwFwRDmwupGaKy+5q5QnBT+6Zj9eqgDEDoPGXCrMEhTKbz
O9ElwftBgB7SHEhTL69NdE7a+m8IQUlm6nXWrSBVUK4M4XNO41bXKmkW15naJJWh
n8KLYkmLcFqOILGsVUG5BLtCR3Oo4wkI3lKVbmX2JylJ3YMAArdhmUMyxeHdp6vp
QWpS80WJeUWzAoMJ7A4bTkbOY+BodTKRO76ZpWP27A1+rg33fwfjpYyOee3OmSZT
50GTB8DHOIg9KOZFmixt
=/tXt
-----END PGP SIGNATURE-----
--=-=-=--

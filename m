From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH]  md: raid5 run(): Fix max_degraded for raid level 4.
Date: Wed, 18 Mar 2009 13:53:24 +0100
Message-ID: <20090318125324.GL17185@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Is40wmw6z7H9MUbF"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Is40wmw6z7H9MUbF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

I found this one while trying to figure out why 3-disk raid6 arrays
aren't supported. It's an obvious and trivial bug fix but probably
not important enough for stable as it only affects raid4.

Regards
Andre

commit ea30abef4d1f3aad635eb24db082f3531b573540
Author: Andre Noll <maan@systemlinux.org>
Date:   Wed Mar 18 13:43:08 2009 +0100

    md: raid5 run(): Fix max_degraded for raid level 4.
   =20
    raid4 allows only one failed disk.
   =20
    Signed-off-by: Andre Noll <maan@systemlinux.org>

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a76ef52..ceb5924 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4484,7 +4484,7 @@ static int run(mddev_t *mddev)
 		 */
 		sector_t here_new, here_old;
 		int old_disks;
-		int max_degraded =3D (mddev->level =3D=3D 5 ? 1 : 2);
+		int max_degraded =3D (mddev->level =3D=3D 6 ? 2 : 1);
=20
 		if (mddev->new_level !=3D mddev->level ||
 		    mddev->new_layout !=3D mddev->layout ||
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--Is40wmw6z7H9MUbF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJwO7EWto1QDEAkw8RAvEkAJ0cm86VVKfH75Xa+GMdRmy6JSyLAgCgiJq8
FUoJUNCdixAmqreWsohVkMo=
=PL9S
-----END PGP SIGNATURE-----

--Is40wmw6z7H9MUbF--

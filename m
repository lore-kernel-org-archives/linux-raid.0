From: NeilBrown <neilb@suse.com>
Subject: [mdadm PATCH] Incremental: Use ->validate_geometry instead of ->avail_size
Date: Mon, 30 Oct 2017 15:43:41 +1100
Message-ID: <87k1zdb5z6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>, =?utf-8?Q?Bj=C3=B8rnar?= Ness <bjornar.ness@gmail.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Since mdadm 3.3 is has not been correct to call ->avail_size if
metadata hasn't been read from the device.  ->validate_geometry
should be used instead.

Unfortunately array_try_spare() didn't get the memo, and it can crash
when adding a spare with no metdata.

So change it to use ->validate_geometry().

Only one place remains that uses ->avail_size(), and that is safe.

Also fix a comment with a typo.

Reported-and-tested-by: Bj=C3=B8rnar Ness <bjornar.ness@gmail.com>
Fixes: 641da7459192 ("super1: separate to version of _avail_space1().")
Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 Incremental.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/Incremental.c b/Incremental.c
index 91301eb5e609..0beab163e642 100644
=2D-- a/Incremental.c
+++ b/Incremental.c
@@ -870,7 +870,7 @@ static int array_try_spare(char *devname, int *dfdp, st=
ruct dev_policy *pol,
 		struct supertype *st2;
 		struct domainlist *dl =3D NULL;
 		struct mdinfo *sra;
=2D		unsigned long long devsize;
+		unsigned long long devsize, freesize =3D 0;
 		struct spare_criteria sc =3D {0, 0};
=20
 		if (is_subarray(mp->metadata))
@@ -942,10 +942,13 @@ static int array_try_spare(char *devname, int *dfdp, =
struct dev_policy *pol,
 			close(mdfd);
 		}
 		if ((sra->component_size > 0 &&
=2D		     st2->ss->avail_size(st2, devsize,
=2D					 sra->devs ? sra->devs->data_offset :
=2D					 INVALID_SECTORS) <
=2D		     sra->component_size) ||
+		     st2->ss->validate_geometry(st2, sra->array.level, sra->array.layout,
+						sra->array.raid_disks, &sra->array.chunk_size,
+						sra->component_size,
+						sra->devs ? sra->devs->data_offset : INVALID_SECTORS,
+						devname, &freesize, sra->consistency_policy,
+						0) &&
+		     freesize < sra->component_size) ||
 		    (sra->component_size =3D=3D 0 && devsize < sc.min_size)) {
 			if (verbose > 1)
 				pr_err("not adding %s to %s as it is too small\n",
@@ -1265,7 +1268,7 @@ static int try_spare(char *devname, int *dfdp, struct=
 dev_policy *pol,
 	 * what arrays might be candidates.
 	 */
 	if (st) {
=2D		/* just try try 'array' or 'partition' based on this metadata */
+		/* just try to add 'array' or 'partition' based on this metadata */
 		if (st->ss->add_to_super)
 			return array_try_spare(devname, dfdp, pol, target, bare,
 					       st, verbose);
=2D-=20
2.14.0.rc0.dirty


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAln2rf8ACgkQOeye3VZi
gbmIKhAAiQglUy0CaGpsknohLZQISoIt7en3peBk4uuMDbCMJU9QtS5amH6jRu7n
52DNacBwFjRBMPJmhiDNcBeThgprl3uIS+jqAQzjw03qJ61pQ89V8kAk03LRBgw4
2E3IP1wQggEwIJ8DBsDr4+TmSxuSVFMtz/2OHLPmGt+zVtO+4Nsj17gETf8r9i0q
SpkBYkB9YWKBmkEYyNPn72E4Z8xJUk9dGHOE59417V5i6LOCqr2C7xK/XtmNCVQP
PoziJvAMqAowKxuWlkza8IGeG+vUUiTM9cAehBG5w9/gj4NPm9KOlx5eTkP0BigW
dyOdjyiChtkNEAv1TCmeR0tc0gIgtvmJ0lAoQGMWhJ7vc6e2QJlP52703cp/ItqX
Ms/Xn3k9iXWhVnoNGZKmrvEQwS8TrFMwf1mX3d2cTeBJKsQR3iR7eQSfhdtiW5mn
Y5HTOgt7UNxPaC5emZQwCpM27UReUgdHChyOdQlU4uLnriRU51rhwOR5IKPzc9Az
1GtpwqxpF4OuVIg85haqLkF+7k+A+kA22dr1lZFGTIwEQpCLEvhQ2im4dRhSfg11
UQ0SJl677i/2+LpfQTnnhqozQe1lb8ioB0N5J06hGMjgfvtCMU5Un7WFpSDLGbwV
oO9a87iBQ8Wk7jklQwQDSItDhHXZtxP/iXtZ5UL5ZRgIf/wZILg=
=dUn4
-----END PGP SIGNATURE-----
--=-=-=--

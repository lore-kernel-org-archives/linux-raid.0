From: NeilBrown <neilb@suse.com>
Subject: Fix bugs in [md PATCH 10/15] md/raid1: stop using bi_phys_segment
Date: Wed, 22 Mar 2017 12:41:33 +1100
Message-ID: <87r31qay0i.fsf@notabene.neil.brown.name>
References: <148954692173.18641.1294690639716682540.stgit@noble> <148954711389.18641.6044680366998154084.stgit@noble>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954711389.18641.6044680366998154084.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


Using r1_bio->sector in call_bio_endio is more
obviously-correct than bio->bi_iter.bi_sector,
though both should have the same value.

The inc_pending() call in handle_read_error() was missing.
One should always accompany a bio_inc_remaining.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/raid1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e566407b196f..bea7f149c43c 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -257,7 +257,7 @@ static void call_bio_endio(struct r1bio *r1_bio)
 	 * Wake up any possible resync thread that waits for the device
 	 * to go idle.
 	 */
=2D	allow_barrier(conf, bi_sector);
+	allow_barrier(conf, r1_bio->sector);
 }
=20
 static void raid_end_bio_io(struct r1bio *r1_bio)
@@ -2543,6 +2543,7 @@ static void handle_read_error(struct r1conf *conf, st=
ruct r1bio *r1_bio)
=20
 			r1_bio =3D alloc_r1bio(mddev, mbio, sectors_handled);
 			set_bit(R1BIO_ReadError, &r1_bio->state);
+			inc_pending(conf, r1_bio->sector);
=20
 			goto read_more;
 		} else {
=2D-=20
2.12.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljR1k0ACgkQOeye3VZi
gbkq9w/4+2P0F7+Y/horTFGqqsiUwk3ddCsdgYmWubKz2zALVnj1BX+WwTECwYLF
By3amkVGLkkT8Mlr6IN1Gexmh578kZmR0rHheUVBw5Z7l+vP10BZ63rJKwiQ2n2L
yC9OQ5QaOx64dVmUD5ktUd2kKrxB/HcPfyfn/yhOn0Bv/djlhqlSwAFDASXOhrZg
OvJY/QHfr2zkTQ6ANLSS8dECf2TCSi+JTCh8NTp4XXWpWeFwOQ5rCvCzbm9gbyH2
K9j6/2VZXVccmSsA06IIzix/YU3+7W/w/7szuyvYg+moALLlEcqnkz03w8fYChYd
CXatemsW0Owpnt4gbnVfZ9uIoStFtJTnJTmZsItOIJFnb5jwo3B37k4G7M42h6R+
GJNE9E3J+60czmi/+eXpM5kZCQOccvpoXUT1llUGdoDyHPZ4BLDBNUe8Bmc2MfTy
ilJXC+44VMENpsG6TxhCGdHYyHZNrWzMncIAB4vQeDMWU+vOxg2BfdKC6NkgQ/3K
+QrGoNEYLLO4tfAdxdU0THsjMbIwP2Cl+9EHjpLZVv3jS6H9S9BvGTP6R4PdAdxx
JaFt8eLRIs1thyWRguEm1eVu/plKSJo7ACcekMgS686tT+93dnkB0h7YsuyOGF0m
Gd3/HX7WIGX/uxvywX1REtNw6Qx5jqT/7g/by4m98pBJloDApw==
=v+X+
-----END PGP SIGNATURE-----
--=-=-=--

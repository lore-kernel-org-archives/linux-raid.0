From: NeilBrown <neilb@suse.com>
Subject: REALLY Fix bug in [md PATCH 02/15] md/raid5: simplfy delaying of writes while metadata is updated.
Date: Wed, 22 Mar 2017 13:29:32 +1100
Message-ID: <87inn2avsj.fsf@notabene.neil.brown.name>
References: <148954692173.18641.1294690639716682540.stgit@noble> <148954711228.18641.2048575896322496918.stgit@noble> <87tw6may1v.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87tw6may1v.fsf@notabene.neil.brown.name>
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

Sorry, I left an unused variable...
NeilBrown


 drivers/md/raid1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e566407b196f..2e2043cdcbf2 100644
=2D-- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -247,7 +247,6 @@ static void call_bio_endio(struct r1bio *r1_bio)
 {
 	struct bio *bio =3D r1_bio->master_bio;
 	struct r1conf *conf =3D r1_bio->mddev->private;
=2D	sector_t bi_sector =3D bio->bi_iter.bi_sector;
=20
 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
 		bio->bi_error =3D -EIO;
@@ -257,7 +256,7 @@ static void call_bio_endio(struct r1bio *r1_bio)
 	 * Wake up any possible resync thread that waits for the device
 	 * to go idle.
 	 */
=2D	allow_barrier(conf, bi_sector);
+	allow_barrier(conf, r1_bio->sector);
 }
=20
 static void raid_end_bio_io(struct r1bio *r1_bio)
@@ -2543,6 +2542,7 @@ static void handle_read_error(struct r1conf *conf, st=
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

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljR4YwACgkQOeye3VZi
gbmMUhAAm3oTG+rHHxpmeeEpqgz+KepHs4q8XZiFbsEi0PtwHY5WfOJfROt64Fz4
88BLINNz8CAScSP8yM7IErad1sbCB35JbQzqT9kQIxI2ESEC7yi0ElRLH4+3mb/u
a8ev9MVfCAok4q0S4wtcsqg7bGllk0LlAxOmncjuPb4pGYQZxylfMq/y9LrCdL0L
V8hSIf8SagqvVbD43/Ct72Q5obTS2NQ2L1UlCxXvlwVfakYayMpFoQngd1wRV4Uk
Lw1DJvO0wV76NzdBrmbVlJ+nlY0GViZ0RFLnh6rvPrlpF6KN58XCNvVFdV+vsLd0
EaLsjwAzppYrUYjLHdhDHP/7nSEx0lolqtafkHzoBvnxWzmrLPNCNY8krH6CPmlV
orMZQBhRanJP+rL6O1EyY1+S5G+xmZaL6viQz6JillR6NrAddXMxsdTdVi/2fMna
QzK9IF/x3K+wvURA2jnyd0z/l5XmWLgsdS5GwKfpBpRBzLw+oui1e1O/za8xwQil
tWqAdERLZID5Bg3XRKtlj1gbDKu4Iz9gewcFZClrSE8jgE28TtdEIQUhHHKoj1oa
VSV8sSt9KglUal5zFM8fuVcknmMo7XkA2iAr362OrEztpjNpMPGgljgsEvj5wxy3
d8ONwXIRi+YWUQ127vEDvVcDXEMR0vMSJL7craaxVCkO8X23ySk=
=ok5+
-----END PGP SIGNATURE-----
--=-=-=--

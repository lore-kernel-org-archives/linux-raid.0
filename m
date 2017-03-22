From: NeilBrown <neilb@suse.com>
Subject: Improvement for [md PATCH 15/15] MD: use per-cpu counter for writes_pending
Date: Wed, 22 Mar 2017 12:55:13 +1100
Message-ID: <87lgryaxdq.fsf@notabene.neil.brown.name>
References: <148954692173.18641.1294690639716682540.stgit@noble> <148954711465.18641.8222940807591984069.stgit@noble>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <148954711465.18641.8222940807591984069.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, hch@lst.de
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


__ref_is_percpu() is documented as an internal interface,
so best not to use it.
We don't really need it, as ->sync_checkers is always 0
when the writes_pending is in per-cpu mode.

So change to test ->sync_checkers, and update comments to match.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/md.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index adf2b5bdfd67..b76ac563115e 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2266,8 +2266,8 @@ static bool set_in_sync(struct mddev *mddev)
 		    percpu_ref_is_zero(&mddev->writes_pending)) {
 			mddev->in_sync =3D 1;
 			/*
=2D			 * Ensure in_sync is visible before switch back
=2D			 * to percpu
+			 * Ensure ->in_sync is visible before we clear
+			 * ->sync_checkers.
 			 */
 			smp_mb();
 			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
@@ -7920,7 +7920,7 @@ void md_write_start(struct mddev *mddev, struct bio *=
bi)
 	smp_mb(); /* Match smp_mb in set_in_sync() */
 	if (mddev->safemode =3D=3D 1)
 		mddev->safemode =3D 0;
=2D	if (mddev->in_sync || !__ref_is_percpu(&mddev->writes_pending, &notused=
)) {
+	if (mddev->in_sync || !mddev->sync_checkers) {
 		spin_lock(&mddev->lock);
 		if (mddev->in_sync) {
 			mddev->in_sync =3D 0;
=2D-=20
2.12.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljR2YEACgkQOeye3VZi
gbmALBAAwBSUdNGu57gj9exnWkY9wt8uh/7LWxgmk2mtj+gTH+xY+3Eux4A7jwuk
4546hd+ginVivKbKsPweiahzq4xMQYdxBK93UiTpfO91LB2CYf6XSL9l8VYjruIt
8sSoDpKXCvaexfOLvN5OsWydCWrQ8nEw2/S6+DovOcMFintlcTeHszz0XA90YV2g
FEs3IVbKtua4TetozApOtVr9iZ3220hQD4ub6KBpsKy4mf3HSu017c9LcHhcA1AY
JZ0U1CWevHTxejugwC5YQMXdIOSQ/pRJn8yMV1lWjTWcg8mP28wTgq3i6cYLQmFt
tcnv+ho0Ouxi7rX1RWFNqhFOfejW16ZBID5s6P0tAlHtkwUOtniocup6DhHhBCjp
uCxFpUMSk13+xf0Im5P6C9KEy6r8PddciKySwVgtkZZOS9/vl0cloregI3gK3jV6
RKcRAO8wsaPEOk/EpXvYa7WwqfiJePuoJKkCmE5gjLdNlfVni0l3JgYHWMMrUCJi
n5HZves25e19y3/g4sAgqtRqK2dww2isUqx3l7YsmO5iyUqObammuER64TfkPVZ9
6EuI5KMAwCKvzaHCgJPen+Rxi+CSgmNNGmyrm4BW9TD11IjYButhE1lx71ZS3QlG
vqFKrHGmPjHX7ma18ZCo84fxH9i7OZAConFJvUzDuVEb18lpGvw=
=Viop
-----END PGP SIGNATURE-----
--=-=-=--

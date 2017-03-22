From: NeilBrown <neilb@suse.com>
Subject: IMPROVEMENT for Improvement for [md PATCH 15/15] MD: use per-cpu counter for writes_pending
Date: Wed, 22 Mar 2017 13:34:20 +1100
Message-ID: <87d1daavkj.fsf@notabene.neil.brown.name>
References: <148954692173.18641.1294690639716682540.stgit@noble> <148954711465.18641.8222940807591984069.stgit@noble> <87lgryaxdq.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lgryaxdq.fsf@notabene.neil.brown.name>
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

Sorry, there was an undefined variable in that version.

This one is better.

NeilBrown


 drivers/md/md.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index adf2b5bdfd67..aeed8adeb5f1 100644
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
@@ -7901,7 +7901,6 @@ EXPORT_SYMBOL(md_done_sync);
  */
 void md_write_start(struct mddev *mddev, struct bio *bi)
 {
=2D	unsigned long __percpu *notused;
 	int did_change =3D 0;
 	if (bio_data_dir(bi) !=3D WRITE)
 		return;
@@ -7920,7 +7919,7 @@ void md_write_start(struct mddev *mddev, struct bio *=
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

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljR4qwACgkQOeye3VZi
gblzmQ/+NMvgVJYpyTXUBvRYgCCwRr+yOzkBW8FzCt7SXkHZBrKQWd/n38eU2g+W
EJmtlemdMPayWokIGB0ogGkGOyDni2qqeK7JG0lxgw6UU+4YyDYE0XZ7UToYmGL2
+oJVQBVuKFCI72DSE8EotlF8E3AmtDaDH8zjmIR00r4LiSK5K07UH5Q8f1QeG9Fp
pZBrqv/qtXBSKCjv08le0mFG2rH/BvD8EkBxq6f3Q7iLXgySSLCKt294zlGHeCSg
1UxlMeNbaZm+7/5VMCl9KLU79hIzjgySNHD6sz9pEM+oDlyiORzkXhbKAnax/kjm
pQffEOx4iVyNfeHn6Zh//wkAAf951tCSW++yq3hFZxDNdZAh1AZjxHpQvyP18tpe
Hq5zXLMmasRvTU7AHrHZHOsZlQdmJkRyDeEVJo77VbHT4rC2TrH8EzuIfO73ZQOT
PxYzVQKnxDxjsbcKHLsHbpBkqcDLO9fJyNbHHURneHVrCz1auc+ahqpsZ16D20Km
PcQbxINCmPlFyNzvvi1UqA7vCAeTMWmdT/zo7RASfedMFHRJWCah8i9SZE3N6IwR
W3qdM4ID4ooarmhx5wfv4t9SUZ3N3dKb0WwMOeHhLtxEJR2mnQT4EZHJ939/r/Zf
S8R/0w26JSAhtyq2XMbiNnh14TIAGCoo1bhbuFB4xhWpG8IfCJU=
=M9/B
-----END PGP SIGNATURE-----
--=-=-=--

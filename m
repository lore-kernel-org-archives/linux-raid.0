From: NeilBrown <neilb@suse.com>
Subject: [PATCH] md: use a separate bio_set for synchronous IO.
Date: Wed, 21 Jun 2017 09:12:21 +1000
Message-ID: <87wp861cfe.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


md devices allocate a bio_set and use it for two
distinct purposes.
mddev->bio_set is used to clone bios as part of sending
upper level requests down to lower level devices,
and it is also use for synchronous IO such as superblock
and bitmap updates, and for correcting read errors.

This multiple usage can lead to deadlocks.  It is likely
that cloned bios might be queued for write and to be
waiting for a metadata update before the write can be permitted.
If the cloning exhausted mddev->bio_set, the metadata update
may not be able to proceed.

This scenario has been seen during heavy testing, with lots of IO and
lots of memory pressure.

Address this by adding a new bio_set specifically for synchronous IO.
All synchronous IO goes directly to the underlying device and is not
queued at the md level, so request using entries from the new
mddev->sync_set will complete in a timely fashion.
Requests that use mddev->bio_set will sometimes need to wait
for synchronous IO, but will no longer risk deadlocking that iO.

Also: small simplification in mddev_put(): there is no need to
wait until the spinlock is released before calling bioset_free().

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--
 drivers/md/md.c | 27 ++++++++++++++++++++-------
 drivers/md/md.h |  3 +++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 87edc342ccb3..9d0eb50c458e 100644
=2D-- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -203,6 +203,14 @@ struct bio *bio_alloc_mddev(gfp_t gfp_mask, int nr_iov=
ecs,
 }
 EXPORT_SYMBOL_GPL(bio_alloc_mddev);
=20
+static struct bio *md_bio_alloc_sync(struct mddev *mddev)
+{
+	if (!mddev->sync_set)
+		return bio_alloc(GFP_NOIO, 1);
+
+	return bio_alloc_bioset(GFP_NOIO, 1, mddev->sync_set);
+}
+
 /*
  * We have a system wide 'event count' that is incremented
  * on any 'interesting' event, and readers of /proc/mdstat
@@ -462,8 +470,6 @@ static void mddev_delayed_delete(struct work_struct *ws=
);
=20
 static void mddev_put(struct mddev *mddev)
 {
=2D	struct bio_set *bs =3D NULL;
=2D
 	if (!atomic_dec_and_lock(&mddev->active, &all_mddevs_lock))
 		return;
 	if (!mddev->raid_disks && list_empty(&mddev->disks) &&
@@ -471,8 +477,12 @@ static void mddev_put(struct mddev *mddev)
 		/* Array is not configured at all, and not held active,
 		 * so destroy it */
 		list_del_init(&mddev->all_mddevs);
=2D		bs =3D mddev->bio_set;
+		if (mddev->bio_set)
+			bioset_free(mddev->bio_set);
+		if (mddev->sync_set)
+			bioset_free(mddev->sync_set);
 		mddev->bio_set =3D NULL;
+		mddev->sync_set =3D NULL;
 		if (mddev->gendisk) {
 			/* We did a probe so need to clean up.  Call
 			 * queue_work inside the spinlock so that
@@ -485,8 +495,6 @@ static void mddev_put(struct mddev *mddev)
 			kfree(mddev);
 	}
 	spin_unlock(&all_mddevs_lock);
=2D	if (bs)
=2D		bioset_free(bs);
 }
=20
 static void md_safemode_timeout(unsigned long data);
@@ -751,7 +759,7 @@ void md_super_write(struct mddev *mddev, struct md_rdev=
 *rdev,
 	if (test_bit(Faulty, &rdev->flags))
 		return;
=20
=2D	bio =3D bio_alloc_mddev(GFP_NOIO, 1, mddev);
+	bio =3D md_bio_alloc_sync(mddev);
=20
 	atomic_inc(&rdev->nr_pending);
=20
@@ -783,7 +791,7 @@ int md_super_wait(struct mddev *mddev)
 int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 		 struct page *page, int op, int op_flags, bool metadata_op)
 {
=2D	struct bio *bio =3D bio_alloc_mddev(GFP_NOIO, 1, rdev->mddev);
+	struct bio *bio =3D md_bio_alloc_sync(rdev->mddev);
 	int ret;
=20
 	bio->bi_bdev =3D (metadata_op && rdev->meta_bdev) ?
@@ -5432,6 +5440,11 @@ int md_run(struct mddev *mddev)
 		if (!mddev->bio_set)
 			return -ENOMEM;
 	}
+	if (mddev->sync_set =3D=3D NULL) {
+		mddev->sync_set =3D bioset_create(BIO_POOL_SIZE, 0);
+		if (!mddev->sync_set)
+			return -ENOMEM;
+	}
=20
 	spin_lock(&pers_lock);
 	pers =3D find_pers(mddev->level, mddev->clevel);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 0fa1de42c42b..a1c7aa89bb67 100644
=2D-- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -444,6 +444,9 @@ struct mddev {
 	struct attribute_group		*to_remove;
=20
 	struct bio_set			*bio_set;
+	struct bio_set			*sync_set; /* for sync operations like
+						   * metadata and bitmap writes
+						   */
=20
 	/* Generic flush handling.
 	 * The last to finish preflush schedules a worker to submit
=2D-=20
2.12.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllJq9cACgkQOeye3VZi
gbmh4A/+I5jdp2yIp86dSqNrxhpj9E3EysqIB7su0orG/7DUpmRfz4yQwVVe0rPh
vjBqcOtGFbmLcfySX4ZRQWV8FxgjpJLvaDJj+M0oIrY/hI0YxoAzn2zsCB8TN2UB
o/gxjqQyXHS3opiZvUHGueS1ZjuVXJ5oIrvguWK9YX44najBd2kw9Kaex1rQ14Xx
750PkKqifEZW/DRNMAWZMqbLPiQYxfQ1gQK7PNeJyLmiv+vHb/F3hcVdQyzByZOi
lj6bQ4lCjmnpApt0SWxwhx7cEzGYDRzB1/pRYUk+wjQPqXlgT1lHfiUM904nzt5l
VaDKaf9A+68DXpYxt3nwzOP3d1Zb81KdpK1SsU0HPoEiDcxnXTFfWvd3beNUUxVo
Y4HB6U0aKtQ9GLiD/Sa2EwtXzr9Lz5zcBzypm9rNVTlKeAd8MXB4b34eA+rTMPdB
Azc++qgMoeultCsgjHiRVx5YbJFB3IGdQDUhjPtNGmCdCk6DvbosgvWstCRuALOP
w4WfPyQtn6wHqvjX2WkrStpxq4C+ErrwDqtHtDWKF3qIuyvmMIzX8336gyh8A5UY
5U9NUKZvnYoq0f5+bn6S17uyY8qBD83NKTRteGlJUBXi+dFYBkbDSl1kwvgMm/F1
TBBJc8JbYTVcbs0MyFCBjH8D7g2hk3Pd/98twRtPmSKSnkbImf8=
=YyCR
-----END PGP SIGNATURE-----
--=-=-=--

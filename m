From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 6/5] md/raid5: remove over-loading of ->bi_phys_segments.
Date: Mon, 21 Nov 2016 13:32:06 +1100
Message-ID: <87oa19ef6h.fsf@notabene.neil.brown.name>
References: <147969099621.5434.12384452255155063186.stgit@noble>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147969099621.5434.12384452255155063186.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


When a read request, which bypassed the cache, fails, we need to retry
it through the cache.
This involves attaching it to a sequence of stripe_heads, and it may not
be possible to get all the stripe_heads we need at once.
We we do what we can, and record how far we got in ->bi_phys_segments so
we can pick up again later.

There is only every one bio which may have a non-zero offset stored in
=2D>bi_phys_segments, the one that is either active in the single thread
which calls retry_aligned_read(), or is in conf->retry_read_aligned
waiting for retry_aligned_read() to be called again.

So we only need to store one offset value.  This can be in a local
variable passed between remove_bio_from_retry() and
retry_aligned_read(), or in the r5conf structure next to the
=2D>retry_read_aligned pointer.

Storing it there allow the last usage of ->bi_phys_segments to be
removed from md/raid5.c.

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

This applies on top of the previous set of 5, and finishes the
task for eradicating usage of bi_phys_segments.

NeilBrown


 drivers/md/raid5.c | 46 ++++++++++++----------------------------------
 drivers/md/raid5.h |  1 +
 2 files changed, 13 insertions(+), 34 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 7169420bfde5..b7be5a097ead 100644
=2D-- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -144,28 +144,6 @@ static inline struct bio *r5_next_bio(struct bio *bio,=
 sector_t sector)
 		return NULL;
 }
=20
=2D/*
=2D * We maintain a biased count of active stripes in the bottom 16 bits of
=2D * bi_phys_segments, and a count of processed stripes in the upper 16 bi=
ts
=2D */
=2Dstatic inline int raid5_bi_processed_stripes(struct bio *bio)
=2D{
=2D	atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segments;
=2D	return (atomic_read(segments) >> 16) & 0xffff;
=2D}
=2D
=2Dstatic inline void raid5_set_bi_processed_stripes(struct bio *bio,
=2D	unsigned int cnt)
=2D{
=2D	atomic_t *segments =3D (atomic_t *)&bio->bi_phys_segments;
=2D	int old, new;
=2D
=2D	do {
=2D		old =3D atomic_read(segments);
=2D		new =3D (old & 0xffff) | (cnt << 16);
=2D	} while (atomic_cmpxchg(segments, old, new) !=3D old);
=2D}
=2D
 /* Find first data disk in a raid6 stripe */
 static inline int raid6_d0(struct stripe_head *sh)
 {
@@ -4679,12 +4657,14 @@ static void add_bio_to_retry(struct bio *bi,struct =
r5conf *conf)
 	md_wakeup_thread(conf->mddev->thread);
 }
=20
=2Dstatic struct bio *remove_bio_from_retry(struct r5conf *conf)
+static struct bio *remove_bio_from_retry(struct r5conf *conf,
+					 unsigned int *offset)
 {
 	struct bio *bi;
=20
 	bi =3D conf->retry_read_aligned;
 	if (bi) {
+		*offset =3D conf->retry_read_offset;
 		conf->retry_read_aligned =3D NULL;
 		return bi;
 	}
@@ -4692,11 +4672,7 @@ static struct bio *remove_bio_from_retry(struct r5co=
nf *conf)
 	if(bi) {
 		conf->retry_read_aligned_list =3D bi->bi_next;
 		bi->bi_next =3D NULL;
=2D		/*
=2D		 * this sets the active strip count to 1 and the processed
=2D		 * strip count to zero (upper 8 bits)
=2D		 */
=2D		raid5_set_bi_processed_stripes(bi, 0);
+		*offset =3D 0;
 	}
=20
 	return bi;
@@ -5620,7 +5596,8 @@ static inline sector_t raid5_sync_request(struct mdde=
v *mddev, sector_t sector_n
 	return STRIPE_SECTORS;
 }
=20
=2Dstatic int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
+static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio,
+			       unsigned int offset)
 {
 	/* We may not be able to submit a whole bio at once as there
 	 * may not be enough stripe_heads available.
@@ -5649,7 +5626,7 @@ static int  retry_aligned_read(struct r5conf *conf, s=
truct bio *raid_bio)
 		     sector +=3D STRIPE_SECTORS,
 		     scnt++) {
=20
=2D		if (scnt < raid5_bi_processed_stripes(raid_bio))
+		if (scnt < offset)
 			/* already done this stripe */
 			continue;
=20
@@ -5657,15 +5634,15 @@ static int  retry_aligned_read(struct r5conf *conf,=
 struct bio *raid_bio)
=20
 		if (!sh) {
 			/* failed to get a stripe - must wait */
=2D			raid5_set_bi_processed_stripes(raid_bio, scnt);
 			conf->retry_read_aligned =3D raid_bio;
+			conf->retry_read_offset =3D scnt;
 			return handled;
 		}
=20
 		if (!add_stripe_bio(sh, raid_bio, dd_idx, 0, 0)) {
 			raid5_release_stripe(sh);
=2D			raid5_set_bi_processed_stripes(raid_bio, scnt);
 			conf->retry_read_aligned =3D raid_bio;
+			conf->retry_read_offset =3D scnt;
 			return handled;
 		}
=20
@@ -5788,6 +5765,7 @@ static void raid5d(struct md_thread *thread)
 	while (1) {
 		struct bio *bio;
 		int batch_size, released;
+		unsigned int offset;
=20
 		released =3D release_stripe_list(conf, conf->temp_inactive_list);
 		if (released)
@@ -5805,10 +5783,10 @@ static void raid5d(struct md_thread *thread)
 		}
 		raid5_activate_delayed(conf);
=20
=2D		while ((bio =3D remove_bio_from_retry(conf))) {
+		while ((bio =3D remove_bio_from_retry(conf, &offset))) {
 			int ok;
 			spin_unlock_irq(&conf->device_lock);
=2D			ok =3D retry_aligned_read(conf, bio);
+			ok =3D retry_aligned_read(conf, bio, offset);
 			spin_lock_irq(&conf->device_lock);
 			if (!ok)
 				break;
diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
index 799f84b26838..ec2be7677bfb 100644
=2D-- a/drivers/md/raid5.h
+++ b/drivers/md/raid5.h
@@ -472,6 +472,7 @@ struct r5conf {
 	struct list_head	delayed_list; /* stripes that have plugged requests */
 	struct list_head	bitmap_list; /* stripes delaying awaiting bitmap update =
*/
 	struct bio		*retry_read_aligned; /* currently retrying aligned bios   */
+	unsigned int		retry_read_offset; /* sector offset into retry_read_aligned=
 */
 	struct bio		*retry_read_aligned_list; /* aligned bios retry list  */
 	atomic_t		preread_active_stripes; /* stripes with scheduled io */
 	atomic_t		active_aligned_reads;
=2D-=20
2.10.2


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYMlymAAoJEDnsnt1WYoG5JQ4P/jAbHR/D6m26qP22C8V6nMWJ
lur8RTkxsSx/KmlLjYoOT421nbXr7jdxW/+OzAnCYgKF/nLCl1iQRBNPJ5JNcrph
ZBMOMurXAFYHM/Tvw6nmGNdLhnCTw4Y8TOUDx7K1KJngg6rvBo1u45OLQV8OzX6k
56+azf2U5P95axxbZFuAueP4Q82k7bP1f90LT6aealmHE4pVccvucLGM6324epcN
RrGO6t4LyLsitq+P5J6tWbUpx4WSTDMTc3CWp5vBrG+wU8CAPDAVmhiBULeVuGZl
kn26l9Z8xKBxzKy0BpyJHHp3A3HjRLFXtGCspA95VLR04lZZt9ogNBDhm6R7tmRC
sP9yihG54v6uladdrbzDYIlbUUcKEJgY7jWXXdeI1cPZd1r0WU+z7xxR3Y3L41sZ
7BIE0f5h/dukSMlf1MrMBBjZL70a74P+l9WDd5f57KbI3nqFx/fyeB8CUMNXVAZI
lSUqGo2AslaqqXpe0HSadpyUNSbBmemHXM6hkAUPrCZwyexn9NsU2bPN2fJyFLPj
OFIiPvLxVFrdKLijI7tIIq80fZG/6YHIv9jFoRD68imiqU/QM2A8Qfemmp2dLzrg
w3KmGR54DbSjT5HjujujD1bqXg9c/22EEDVkqh+3wC4d1jwMYJrJW7griGh/glyp
xgxvNMULXbbCbfu4TQeh
=BjKA
-----END PGP SIGNATURE-----
--=-=-=--

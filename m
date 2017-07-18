From: Shaohua Li <shli@kernel.org>
Subject: [PATCH] md/raid1: fix writebehind bio clone
Date: Tue, 18 Jul 2017 10:21:56 -0700
Message-ID: <90e5fed8cd2b5dff7b393de121460671ebdd1260.1500398441.git.shli@fb.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Shaohua Li <shli@fb.com>, Ming Lei <tom.leiming@gmail.com>, "4.12+" <stable@vger.kernel.org>
List-Id: linux-raid.ids

From: Shaohua Li <shli@fb.com>

After bio is submitted, we should not clone it as its bi_iter might be
invalid by driver. This is the case of behind_master_bio. In certain
situration, we could dispatch behind_master_bio immediately for the
first disk and then clone it for other disks.

https://bugzilla.kernel.org/show_bug.cgi?id=196383

Reported-by: Markus <m4rkusxxl@web.de>
Cc: Ming Lei <tom.leiming@gmail.com>
Fix: 841c1316c7da(md: raid1: improve write behind)
Cc: stable@vger.kernel.org (4.12+)
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/raid1.c | 30 ++++++++++--------------------
 1 file changed, 10 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 8387eb1540cd..5622f521830b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -484,10 +484,6 @@ static void raid1_end_write_request(struct bio *bio)
 	}
 
 	if (behind) {
-		/* we release behind master bio when all write are done */
-		if (r1_bio->behind_master_bio == bio)
-			to_put = NULL;
-
 		if (test_bit(WriteMostly, &rdev->flags))
 			atomic_dec(&r1_bio->behind_remaining);
 
@@ -1080,7 +1076,7 @@ static void unfreeze_array(struct r1conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
-static struct bio *alloc_behind_master_bio(struct r1bio *r1_bio,
+static void alloc_behind_master_bio(struct r1bio *r1_bio,
 					   struct bio *bio)
 {
 	int size = bio->bi_iter.bi_size;
@@ -1090,7 +1086,7 @@ static struct bio *alloc_behind_master_bio(struct r1bio *r1_bio,
 
 	behind_bio = bio_alloc_mddev(GFP_NOIO, vcnt, r1_bio->mddev);
 	if (!behind_bio)
-		goto fail;
+		return;
 
 	/* discard op, we don't support writezero/writesame yet */
 	if (!bio_has_data(bio))
@@ -1115,14 +1111,13 @@ static struct bio *alloc_behind_master_bio(struct r1bio *r1_bio,
 	r1_bio->behind_master_bio = behind_bio;;
 	set_bit(R1BIO_BehindIO, &r1_bio->state);
 
-	return behind_bio;
+	return;
 
 free_pages:
 	pr_debug("%dB behind alloc failed, doing sync I/O\n",
 		 bio->bi_iter.bi_size);
 	bio_free_pages(behind_bio);
-fail:
-	return behind_bio;
+	bio_put(behind_bio);
 }
 
 struct raid1_plug_cb {
@@ -1475,7 +1470,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			    (atomic_read(&bitmap->behind_writes)
 			     < mddev->bitmap_info.max_write_behind) &&
 			    !waitqueue_active(&bitmap->behind_wait)) {
-				mbio = alloc_behind_master_bio(r1_bio, bio);
+				alloc_behind_master_bio(r1_bio, bio);
 			}
 
 			bitmap_startwrite(bitmap, r1_bio->sector,
@@ -1485,14 +1480,11 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			first_clone = 0;
 		}
 
-		if (!mbio) {
-			if (r1_bio->behind_master_bio)
-				mbio = bio_clone_fast(r1_bio->behind_master_bio,
-						      GFP_NOIO,
-						      mddev->bio_set);
-			else
-				mbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
-		}
+		if (r1_bio->behind_master_bio)
+			mbio = bio_clone_fast(r1_bio->behind_master_bio,
+					      GFP_NOIO, mddev->bio_set);
+		else
+			mbio = bio_clone_fast(bio, GFP_NOIO, mddev->bio_set);
 
 		if (r1_bio->behind_master_bio) {
 			if (test_bit(WriteMostly, &conf->mirrors[i].rdev->flags))
@@ -2346,8 +2338,6 @@ static int narrow_write_error(struct r1bio *r1_bio, int i)
 			wbio = bio_clone_fast(r1_bio->behind_master_bio,
 					      GFP_NOIO,
 					      mddev->bio_set);
-			/* We really need a _all clone */
-			wbio->bi_iter = (struct bvec_iter){ 0 };
 		} else {
 			wbio = bio_clone_fast(r1_bio->master_bio, GFP_NOIO,
 					      mddev->bio_set);
-- 
2.11.0

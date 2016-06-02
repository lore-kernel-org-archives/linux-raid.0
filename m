From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 05/18] md/raid10: add rcu protection to rdev access in
 raid10_sync_request.
Date: Thu, 02 Jun 2016 16:19:52 +1000
Message-ID: <20160602061952.2939.98809.stgit@noble>
References: <20160602061319.2939.72280.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160602061319.2939.72280.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mirrors[].rdev can become NULL at any point unless:
  - a counted reference is held
  - ->reconfig_mutex is held, or
  - rcu_read_lock() is held

Previously they could not become NULL during a resync/recovery/reshape either.
However when remove_and_add_spares() was added to hot_remove_disk(), that
changed.

So raid10_sync_request didn't previously need to protect rdev access,
but now it does.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/raid10.c |  120 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 72 insertions(+), 48 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e6f3a11f8f70..f6f21a253926 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2871,11 +2871,14 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				/* Completed a full sync so the replacements
 				 * are now fully recovered.
 				 */
-				for (i = 0; i < conf->geo.raid_disks; i++)
-					if (conf->mirrors[i].replacement)
-						conf->mirrors[i].replacement
-							->recovery_offset
-							= MaxSector;
+				rcu_read_lock();
+				for (i = 0; i < conf->geo.raid_disks; i++) {
+					struct md_rdev *rdev =
+						rcu_dereference(conf->mirrors[i].replacement);
+					if (rdev)
+						rdev->recovery_offset = MaxSector;
+				}
+				rcu_read_unlock();
 			}
 			conf->fullsync = 0;
 		}
@@ -2934,14 +2937,17 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			int must_sync;
 			int any_working;
 			struct raid10_info *mirror = &conf->mirrors[i];
+			struct md_rdev *mrdev, *mreplace;
 
-			if ((mirror->rdev == NULL ||
-			     test_bit(In_sync, &mirror->rdev->flags))
-			    &&
-			    (mirror->replacement == NULL ||
-			     test_bit(Faulty,
-				      &mirror->replacement->flags)))
+			rcu_read_lock();
+			mrdev = rcu_dereference(mirror->rdev);
+			mreplace = rcu_dereference(mirror->replacement);
+
+			if ((mrdev == NULL ||
+			     test_bit(In_sync, &mrdev->flags))) {
+				rcu_read_unlock();
 				continue;
+			}
 
 			still_degraded = 0;
 			/* want to reconstruct this device */
@@ -2951,6 +2957,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				/* last stripe is not complete - don't
 				 * try to recover this sector.
 				 */
+				rcu_read_unlock();
 				continue;
 			}
 			/* Unless we are doing a full sync, or a replacement
@@ -2962,14 +2969,19 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			if (sync_blocks < max_sync)
 				max_sync = sync_blocks;
 			if (!must_sync &&
-			    mirror->replacement == NULL &&
+			    mreplace == NULL &&
 			    !conf->fullsync) {
 				/* yep, skip the sync_blocks here, but don't assume
 				 * that there will never be anything to do here
 				 */
 				chunks_skipped = -1;
+				rcu_read_unlock();
 				continue;
 			}
+			atomic_inc(&mrdev->nr_pending);
+			if (mreplace)
+				atomic_inc(&mreplace->nr_pending);
+			rcu_read_unlock();
 
 			r10_bio = mempool_alloc(conf->r10buf_pool, GFP_NOIO);
 			r10_bio->state = 0;
@@ -2988,12 +3000,15 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			/* Need to check if the array will still be
 			 * degraded
 			 */
-			for (j = 0; j < conf->geo.raid_disks; j++)
-				if (conf->mirrors[j].rdev == NULL ||
-				    test_bit(Faulty, &conf->mirrors[j].rdev->flags)) {
+			rcu_read_lock();
+			for (j = 0; j < conf->geo.raid_disks; j++) {
+				struct md_rdev *rdev = rcu_dereference(
+					conf->mirrors[j].rdev);
+				if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
 					still_degraded = 1;
 					break;
 				}
+			}
 
 			must_sync = bitmap_start_sync(mddev->bitmap, sect,
 						      &sync_blocks, still_degraded);
@@ -3003,15 +3018,15 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				int k;
 				int d = r10_bio->devs[j].devnum;
 				sector_t from_addr, to_addr;
-				struct md_rdev *rdev;
+				struct md_rdev *rdev =
+					rcu_dereference(conf->mirrors[d].rdev);
 				sector_t sector, first_bad;
 				int bad_sectors;
-				if (!conf->mirrors[d].rdev ||
-				    !test_bit(In_sync, &conf->mirrors[d].rdev->flags))
+				if (!rdev ||
+				    !test_bit(In_sync, &rdev->flags))
 					continue;
 				/* This is where we read from */
 				any_working = 1;
-				rdev = conf->mirrors[d].rdev;
 				sector = r10_bio->devs[j].addr;
 
 				if (is_badblock(rdev, sector, max_sync,
@@ -3050,8 +3065,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				r10_bio->devs[1].devnum = i;
 				r10_bio->devs[1].addr = to_addr;
 
-				rdev = mirror->rdev;
-				if (!test_bit(In_sync, &rdev->flags)) {
+				if (!test_bit(In_sync, &mrdev->flags)) {
 					bio = r10_bio->devs[1].bio;
 					bio_reset(bio);
 					bio->bi_next = biolist;
@@ -3060,8 +3074,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 					bio->bi_end_io = end_sync_write;
 					bio->bi_rw = WRITE;
 					bio->bi_iter.bi_sector = to_addr
-						+ rdev->data_offset;
-					bio->bi_bdev = rdev->bdev;
+						+ mrdev->data_offset;
+					bio->bi_bdev = mrdev->bdev;
 					atomic_inc(&r10_bio->remaining);
 				} else
 					r10_bio->devs[1].bio->bi_end_io = NULL;
@@ -3070,8 +3084,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio = r10_bio->devs[1].repl_bio;
 				if (bio)
 					bio->bi_end_io = NULL;
-				rdev = mirror->replacement;
-				/* Note: if rdev != NULL, then bio
+				/* Note: if mreplace != NULL, then bio
 				 * cannot be NULL as r10buf_pool_alloc will
 				 * have allocated it.
 				 * So the second test here is pointless.
@@ -3079,8 +3092,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				 * this comment keeps human reviewers
 				 * happy.
 				 */
-				if (rdev == NULL || bio == NULL ||
-				    test_bit(Faulty, &rdev->flags))
+				if (mreplace == NULL || bio == NULL ||
+				    test_bit(Faulty, &mreplace->flags))
 					break;
 				bio_reset(bio);
 				bio->bi_next = biolist;
@@ -3089,11 +3102,12 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio->bi_end_io = end_sync_write;
 				bio->bi_rw = WRITE;
 				bio->bi_iter.bi_sector = to_addr +
-					rdev->data_offset;
-				bio->bi_bdev = rdev->bdev;
+					mreplace->data_offset;
+				bio->bi_bdev = mreplace->bdev;
 				atomic_inc(&r10_bio->remaining);
 				break;
 			}
+			rcu_read_unlock();
 			if (j == conf->copies) {
 				/* Cannot recover, so abort the recovery or
 				 * record a bad block */
@@ -3106,15 +3120,15 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 						if (r10_bio->devs[k].devnum == i)
 							break;
 					if (!test_bit(In_sync,
-						      &mirror->rdev->flags)
+						      &mrdev->flags)
 					    && !rdev_set_badblocks(
-						    mirror->rdev,
+						    mrdev,
 						    r10_bio->devs[k].addr,
 						    max_sync, 0))
 						any_working = 0;
-					if (mirror->replacement &&
+					if (mreplace &&
 					    !rdev_set_badblocks(
-						    mirror->replacement,
+						    mreplace,
 						    r10_bio->devs[k].addr,
 						    max_sync, 0))
 						any_working = 0;
@@ -3132,8 +3146,14 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				if (rb2)
 					atomic_dec(&rb2->remaining);
 				r10_bio = rb2;
+				rdev_dec_pending(mrdev, mddev);
+				if (mreplace)
+					rdev_dec_pending(mreplace, mddev);
 				break;
 			}
+			rdev_dec_pending(mrdev, mddev);
+			if (mreplace)
+				rdev_dec_pending(mreplace, mddev);
 		}
 		if (biolist == NULL) {
 			while (r10_bio) {
@@ -3178,6 +3198,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			int d = r10_bio->devs[i].devnum;
 			sector_t first_bad, sector;
 			int bad_sectors;
+			struct md_rdev *rdev;
 
 			if (r10_bio->devs[i].repl_bio)
 				r10_bio->devs[i].repl_bio->bi_end_io = NULL;
@@ -3185,12 +3206,14 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio = r10_bio->devs[i].bio;
 			bio_reset(bio);
 			bio->bi_error = -EIO;
-			if (conf->mirrors[d].rdev == NULL ||
-			    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
+			rcu_read_lock();
+			rdev = rcu_dereference(conf->mirrors[d].rdev);
+			if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
+				rcu_read_unlock();
 				continue;
+			}
 			sector = r10_bio->devs[i].addr;
-			if (is_badblock(conf->mirrors[d].rdev,
-					sector, max_sync,
+			if (is_badblock(rdev, sector, max_sync,
 					&first_bad, &bad_sectors)) {
 				if (first_bad > sector)
 					max_sync = first_bad - sector;
@@ -3198,25 +3221,28 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 					bad_sectors -= (sector - first_bad);
 					if (max_sync > bad_sectors)
 						max_sync = bad_sectors;
+					rcu_read_unlock();
 					continue;
 				}
 			}
-			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
+			atomic_inc(&rdev->nr_pending);
 			atomic_inc(&r10_bio->remaining);
 			bio->bi_next = biolist;
 			biolist = bio;
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_read;
 			bio->bi_rw = READ;
-			bio->bi_iter.bi_sector = sector +
-				conf->mirrors[d].rdev->data_offset;
-			bio->bi_bdev = conf->mirrors[d].rdev->bdev;
+			bio->bi_iter.bi_sector = sector + rdev->data_offset;
+			bio->bi_bdev = rdev->bdev;
 			count++;
 
-			if (conf->mirrors[d].replacement == NULL ||
-			    test_bit(Faulty,
-				     &conf->mirrors[d].replacement->flags))
+			rdev = rcu_dereference(conf->mirrors[d].replacement);
+			if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
+				rcu_read_unlock();
 				continue;
+			}
+			atomic_inc(&rdev->nr_pending);
+			rcu_read_unlock();
 
 			/* Need to set up for writing to the replacement */
 			bio = r10_bio->devs[i].repl_bio;
@@ -3224,15 +3250,13 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			bio->bi_error = -EIO;
 
 			sector = r10_bio->devs[i].addr;
-			atomic_inc(&conf->mirrors[d].replacement->nr_pending);
 			bio->bi_next = biolist;
 			biolist = bio;
 			bio->bi_private = r10_bio;
 			bio->bi_end_io = end_sync_write;
 			bio->bi_rw = WRITE;
-			bio->bi_iter.bi_sector = sector +
-				conf->mirrors[d].replacement->data_offset;
-			bio->bi_bdev = conf->mirrors[d].replacement->bdev;
+			bio->bi_iter.bi_sector = sector + rdev->data_offset;
+			bio->bi_bdev = rdev->bdev;
 			count++;
 		}
 



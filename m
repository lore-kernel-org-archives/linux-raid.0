From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 15/16] md/raid10: reformat some loops with less indenting.
Date: Wed, 11 May 2011 16:30:31 +1000
Message-ID: <20110511063031.21263.44877.stgit@notabene.brown>
References: <20110511062743.21263.72802.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110511062743.21263.72802.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When a loop ends with an 'if' with a large body, it is neater
to make the if 'continue' on the inverse condition, and then
the body is indented less.

Apply this pattern 3 times, and wrap some other long lines.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |  228 +++++++++++++++++++++++++++------------------------
 1 files changed, 120 insertions(+), 108 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index f44a3da..6e84668 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1736,7 +1736,8 @@ static int init_resync(conf_t *conf)
  *
  */
 
-static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, int go_faster)
+static sector_t sync_request(mddev_t *mddev, sector_t sector_nr,
+			     int *skipped, int go_faster)
 {
 	conf_t *conf = mddev->private;
 	r10bio_t *r10_bio;
@@ -1830,108 +1831,114 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 		int j, k;
 		r10_bio = NULL;
 
-		for (i=0 ; i<conf->raid_disks; i++)
-			if (conf->mirrors[i].rdev &&
-			    !test_bit(In_sync, &conf->mirrors[i].rdev->flags)) {
-				int still_degraded = 0;
-				/* want to reconstruct this device */
-				r10bio_t *rb2 = r10_bio;
-				sector_t sect = raid10_find_virt(conf, sector_nr, i);
-				int must_sync;
-				/* Unless we are doing a full sync, we only need
-				 * to recover the block if it is set in the bitmap
-				 */
-				must_sync = bitmap_start_sync(mddev->bitmap, sect,
-							      &sync_blocks, 1);
-				if (sync_blocks < max_sync)
-					max_sync = sync_blocks;
-				if (!must_sync &&
-				    !conf->fullsync) {
-					/* yep, skip the sync_blocks here, but don't assume
-					 * that there will never be anything to do here
-					 */
-					chunks_skipped = -1;
-					continue;
-				}
+		for (i=0 ; i<conf->raid_disks; i++) {
+			int still_degraded;
+			r10bio_t *rb2;
+			sector_t sect;
+			int must_sync;
 
-				r10_bio = mempool_alloc(conf->r10buf_pool, GFP_NOIO);
-				raise_barrier(conf, rb2 != NULL);
-				atomic_set(&r10_bio->remaining, 0);
+			if (conf->mirrors[i].rdev == NULL ||
+			    test_bit(In_sync, &conf->mirrors[i].rdev->flags)) 
+				continue;
 
-				r10_bio->master_bio = (struct bio*)rb2;
-				if (rb2)
-					atomic_inc(&rb2->remaining);
-				r10_bio->mddev = mddev;
-				set_bit(R10BIO_IsRecover, &r10_bio->state);
-				r10_bio->sector = sect;
+			still_degraded = 0;
+			/* want to reconstruct this device */
+			rb2 = r10_bio;
+			sect = raid10_find_virt(conf, sector_nr, i);
+			/* Unless we are doing a full sync, we only need
+			 * to recover the block if it is set in the bitmap
+			 */
+			must_sync = bitmap_start_sync(mddev->bitmap, sect,
+						      &sync_blocks, 1);
+			if (sync_blocks < max_sync)
+				max_sync = sync_blocks;
+			if (!must_sync &&
+			    !conf->fullsync) {
+				/* yep, skip the sync_blocks here, but don't assume
+				 * that there will never be anything to do here
+				 */
+				chunks_skipped = -1;
+				continue;
+			}
 
-				raid10_find_phys(conf, r10_bio);
+			r10_bio = mempool_alloc(conf->r10buf_pool, GFP_NOIO);
+			raise_barrier(conf, rb2 != NULL);
+			atomic_set(&r10_bio->remaining, 0);
 
-				/* Need to check if the array will still be
-				 * degraded
-				 */
-				for (j=0; j<conf->raid_disks; j++)
-					if (conf->mirrors[j].rdev == NULL ||
-					    test_bit(Faulty, &conf->mirrors[j].rdev->flags)) {
-						still_degraded = 1;
-						break;
-					}
-
-				must_sync = bitmap_start_sync(mddev->bitmap, sect,
-							      &sync_blocks, still_degraded);
-
-				for (j=0; j<conf->copies;j++) {
-					int d = r10_bio->devs[j].devnum;
-					if (conf->mirrors[d].rdev &&
-					    test_bit(In_sync, &conf->mirrors[d].rdev->flags)) {
-						/* This is where we read from */
-						bio = r10_bio->devs[0].bio;
-						bio->bi_next = biolist;
-						biolist = bio;
-						bio->bi_private = r10_bio;
-						bio->bi_end_io = end_sync_read;
-						bio->bi_rw = READ;
-						bio->bi_sector = r10_bio->devs[j].addr +
-							conf->mirrors[d].rdev->data_offset;
-						bio->bi_bdev = conf->mirrors[d].rdev->bdev;
-						atomic_inc(&conf->mirrors[d].rdev->nr_pending);
-						atomic_inc(&r10_bio->remaining);
-						/* and we write to 'i' */
-
-						for (k=0; k<conf->copies; k++)
-							if (r10_bio->devs[k].devnum == i)
-								break;
-						BUG_ON(k == conf->copies);
-						bio = r10_bio->devs[1].bio;
-						bio->bi_next = biolist;
-						biolist = bio;
-						bio->bi_private = r10_bio;
-						bio->bi_end_io = end_sync_write;
-						bio->bi_rw = WRITE;
-						bio->bi_sector = r10_bio->devs[k].addr +
-							conf->mirrors[i].rdev->data_offset;
-						bio->bi_bdev = conf->mirrors[i].rdev->bdev;
-
-						r10_bio->devs[0].devnum = d;
-						r10_bio->devs[1].devnum = i;
+			r10_bio->master_bio = (struct bio*)rb2;
+			if (rb2)
+				atomic_inc(&rb2->remaining);
+			r10_bio->mddev = mddev;
+			set_bit(R10BIO_IsRecover, &r10_bio->state);
+			r10_bio->sector = sect;
 
-						break;
-					}
-				}
-				if (j == conf->copies) {
-					/* Cannot recover, so abort the recovery */
-					put_buf(r10_bio);
-					if (rb2)
-						atomic_dec(&rb2->remaining);
-					r10_bio = rb2;
-					if (!test_and_set_bit(MD_RECOVERY_INTR,
-							      &mddev->recovery))
-						printk(KERN_INFO "md/raid10:%s: insufficient "
-						       "working devices for recovery.\n",
-						       mdname(mddev));
+			raid10_find_phys(conf, r10_bio);
+
+			/* Need to check if the array will still be
+			 * degraded
+			 */
+			for (j=0; j<conf->raid_disks; j++)
+				if (conf->mirrors[j].rdev == NULL ||
+				    test_bit(Faulty, &conf->mirrors[j].rdev->flags)) {
+					still_degraded = 1;
 					break;
 				}
+
+			must_sync = bitmap_start_sync(mddev->bitmap, sect,
+						      &sync_blocks, still_degraded);
+
+			for (j=0; j<conf->copies;j++) {
+				int d = r10_bio->devs[j].devnum;
+				if (!conf->mirrors[d].rdev ||
+				    !test_bit(In_sync, &conf->mirrors[d].rdev->flags))
+					continue;
+				/* This is where we read from */
+				bio = r10_bio->devs[0].bio;
+				bio->bi_next = biolist;
+				biolist = bio;
+				bio->bi_private = r10_bio;
+				bio->bi_end_io = end_sync_read;
+				bio->bi_rw = READ;
+				bio->bi_sector = r10_bio->devs[j].addr +
+					conf->mirrors[d].rdev->data_offset;
+				bio->bi_bdev = conf->mirrors[d].rdev->bdev;
+				atomic_inc(&conf->mirrors[d].rdev->nr_pending);
+				atomic_inc(&r10_bio->remaining);
+				/* and we write to 'i' */
+
+				for (k=0; k<conf->copies; k++)
+					if (r10_bio->devs[k].devnum == i)
+						break;
+				BUG_ON(k == conf->copies);
+				bio = r10_bio->devs[1].bio;
+				bio->bi_next = biolist;
+				biolist = bio;
+				bio->bi_private = r10_bio;
+				bio->bi_end_io = end_sync_write;
+				bio->bi_rw = WRITE;
+				bio->bi_sector = r10_bio->devs[k].addr +
+					conf->mirrors[i].rdev->data_offset;
+				bio->bi_bdev = conf->mirrors[i].rdev->bdev;
+
+				r10_bio->devs[0].devnum = d;
+				r10_bio->devs[1].devnum = i;
+
+				break;
+			}
+			if (j == conf->copies) {
+				/* Cannot recover, so abort the recovery */
+				put_buf(r10_bio);
+				if (rb2)
+					atomic_dec(&rb2->remaining);
+				r10_bio = rb2;
+				if (!test_and_set_bit(MD_RECOVERY_INTR,
+						      &mddev->recovery))
+					printk(KERN_INFO "md/raid10:%s: insufficient "
+					       "working devices for recovery.\n",
+					       mdname(mddev));
+				break;
 			}
+		}
 		if (biolist == NULL) {
 			while (r10_bio) {
 				r10bio_t *rb2 = r10_bio;
@@ -1949,7 +1956,8 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 
 		if (!bitmap_start_sync(mddev->bitmap, sector_nr,
 				       &sync_blocks, mddev->degraded) &&
-		    !conf->fullsync && !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
+		    !conf->fullsync && !test_bit(MD_RECOVERY_REQUESTED,
+						 &mddev->recovery)) {
 			/* We can skip this block */
 			*skipped = 1;
 			return sync_blocks + sectors_skipped;
@@ -1994,7 +2002,8 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 			for (i=0; i<conf->copies; i++) {
 				int d = r10_bio->devs[i].devnum;
 				if (r10_bio->devs[i].bio->bi_end_io)
-					rdev_dec_pending(conf->mirrors[d].rdev, mddev);
+					rdev_dec_pending(conf->mirrors[d].rdev,
+							 mddev);
 			}
 			put_buf(r10_bio);
 			biolist = NULL;
@@ -2024,19 +2033,22 @@ static sector_t sync_request(mddev_t *mddev, sector_t sector_nr, int *skipped, i
 		if (len == 0)
 			break;
 		for (bio= biolist ; bio ; bio=bio->bi_next) {
+			struct bio *bio2;
 			page = bio->bi_io_vec[bio->bi_vcnt].bv_page;
-			if (bio_add_page(bio, page, len, 0) == 0) {
-				/* stop here */
-				struct bio *bio2;
-				bio->bi_io_vec[bio->bi_vcnt].bv_page = page;
-				for (bio2 = biolist; bio2 && bio2 != bio; bio2 = bio2->bi_next) {
-					/* remove last page from this bio */
-					bio2->bi_vcnt--;
-					bio2->bi_size -= len;
-					bio2->bi_flags &= ~(1<< BIO_SEG_VALID);
-				}
-				goto bio_full;
+			if (bio_add_page(bio, page, len, 0))
+				continue;
+
+			/* stop here */
+			bio->bi_io_vec[bio->bi_vcnt].bv_page = page;
+			for (bio2 = biolist;
+			     bio2 && bio2 != bio;
+			     bio2 = bio2->bi_next) {
+				/* remove last page from this bio */
+				bio2->bi_vcnt--;
+				bio2->bi_size -= len;
+				bio2->bi_flags &= ~(1<< BIO_SEG_VALID);
 			}
+			goto bio_full;
 		}
 		nr_sectors += len>>9;
 		sector_nr += len>>9;



From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 07/17] md/raid10: handle recovery of replacement devices.
Date: Wed, 02 Nov 2011 16:25:44 +1100
Message-ID: <20111102052544.17566.75014.stgit@notabene.brown>
References: <20111102051851.17566.52748.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102051851.17566.52748.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If there is a replacement device, then recover to it,
reading from any drives - maybe the one being replaced, maybe not.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/raid10.c |   98 ++++++++++++++++++++++++++++++++++++---------------
 1 files changed, 70 insertions(+), 28 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index a2341ca..89de485 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1857,12 +1857,20 @@ static void recovery_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 	 * share the pages with the first bio
 	 * and submit the write request
 	 */
-	wbio = r10_bio->devs[1].bio;
 	d = r10_bio->devs[1].devnum;
-
-	atomic_inc(&conf->mirrors[d].rdev->nr_pending);
-	md_sync_acct(conf->mirrors[d].rdev->bdev, wbio->bi_size >> 9);
-	generic_make_request(wbio);
+	wbio = r10_bio->devs[1].bio;
+	if (wbio->bi_end_io) {
+		atomic_inc(&conf->mirrors[d].rdev->nr_pending);
+		md_sync_acct(conf->mirrors[d].rdev->bdev, wbio->bi_size >> 9);
+		generic_make_request(wbio);
+	}
+	wbio = r10_bio->devs[1].repl_bio;
+	if (wbio && wbio->bi_end_io) {
+		atomic_inc(&conf->mirrors[d].replacement->nr_pending);
+		md_sync_acct(conf->mirrors[d].replacement->bdev,
+			     wbio->bi_size >> 9);
+		generic_make_request(wbio);
+	}
 }
 
 
@@ -2592,23 +2600,30 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			sector_t sect;
 			int must_sync;
 			int any_working;
+			struct mirror_info *mirror = &conf->mirrors[i];
 
-			if (conf->mirrors[i].rdev == NULL ||
-			    test_bit(In_sync, &conf->mirrors[i].rdev->flags)) 
+			if ((mirror->rdev == NULL ||
+			     test_bit(In_sync, &mirror->rdev->flags))
+			    &&
+			    (mirror->replacement == NULL ||
+			     test_bit(Faulty,
+				      &mirror->replacement->flags)))
 				continue;
 
 			still_degraded = 0;
 			/* want to reconstruct this device */
 			rb2 = r10_bio;
 			sect = raid10_find_virt(conf, sector_nr, i);
-			/* Unless we are doing a full sync, we only need
-			 * to recover the block if it is set in the bitmap
+			/* Unless we are doing a full sync, or a replacement
+			 * we only need to recover the block if it is set in
+			 * the bitmap
 			 */
 			must_sync = bitmap_start_sync(mddev->bitmap, sect,
 						      &sync_blocks, 1);
 			if (sync_blocks < max_sync)
 				max_sync = sync_blocks;
 			if (!must_sync &&
+			    mirror->replacement == NULL &&
 			    !conf->fullsync) {
 				/* yep, skip the sync_blocks here, but don't assume
 				 * that there will never be anything to do here
@@ -2678,33 +2693,52 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 				bio->bi_end_io = end_sync_read;
 				bio->bi_rw = READ;
 				from_addr = r10_bio->devs[j].addr;
-				bio->bi_sector = from_addr +
-					conf->mirrors[d].rdev->data_offset;
-				bio->bi_bdev = conf->mirrors[d].rdev->bdev;
-				atomic_inc(&conf->mirrors[d].rdev->nr_pending);
-				atomic_inc(&r10_bio->remaining);
-				/* and we write to 'i' */
+				bio->bi_sector = from_addr + rdev->data_offset;
+				bio->bi_bdev = rdev->bdev;
+				atomic_inc(&rdev->nr_pending);
+				/* and we write to 'i' (if not in_sync) */
 
 				for (k=0; k<conf->copies; k++)
 					if (r10_bio->devs[k].devnum == i)
 						break;
 				BUG_ON(k == conf->copies);
-				bio = r10_bio->devs[1].bio;
-				bio->bi_next = biolist;
-				biolist = bio;
-				bio->bi_private = r10_bio;
-				bio->bi_end_io = end_sync_write;
-				bio->bi_rw = WRITE;
 				to_addr = r10_bio->devs[k].addr;
-				bio->bi_sector = to_addr +
-					conf->mirrors[i].rdev->data_offset;
-				bio->bi_bdev = conf->mirrors[i].rdev->bdev;
-
 				r10_bio->devs[0].devnum = d;
 				r10_bio->devs[0].addr = from_addr;
 				r10_bio->devs[1].devnum = i;
 				r10_bio->devs[1].addr = to_addr;
 
+				rdev = mirror->rdev;
+				if (!test_bit(In_sync, &rdev->flags)) {
+					bio = r10_bio->devs[1].bio;
+					bio->bi_next = biolist;
+					biolist = bio;
+					bio->bi_private = r10_bio;
+					bio->bi_end_io = end_sync_write;
+					bio->bi_rw = WRITE;
+					bio->bi_sector = to_addr
+						+ rdev->data_offset;
+					bio->bi_bdev = rdev->bdev;
+					atomic_inc(&r10_bio->remaining);
+				} else
+					r10_bio->devs[1].bio->bi_end_io = NULL;
+
+				/* and maybe write to replacement */
+				bio = r10_bio->devs[1].repl_bio;
+				if (bio)
+					bio->bi_end_io = NULL;
+				rdev = mirror->replacement;
+				if (rdev == NULL ||
+				    test_bit(Faulty, &rdev->flags))
+					break;
+				bio->bi_next = biolist;
+				biolist = bio;
+				bio->bi_private = r10_bio;
+				bio->bi_end_io = end_sync_write;
+				bio->bi_rw = WRITE;
+				bio->bi_sector = to_addr + rdev->data_offset;
+				bio->bi_bdev = rdev->bdev;
+				atomic_inc(&r10_bio->remaining);
 				break;
 			}
 			if (j == conf->copies) {
@@ -2722,8 +2756,16 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 					for (k = 0; k < conf->copies; k++)
 						if (r10_bio->devs[k].devnum == i)
 							break;
-					if (!rdev_set_badblocks(
-						    conf->mirrors[i].rdev,
+					if (!test_bit(In_sync,
+						      &mirror->rdev->flags)
+					    && !rdev_set_badblocks(
+						    mirror->rdev,
+						    r10_bio->devs[k].addr,
+						    max_sync, 0))
+						any_working = 0;
+					if (mirror->replacement &&
+					    !rdev_set_badblocks(
+						    mirror->replacement,
 						    r10_bio->devs[k].addr,
 						    max_sync, 0))
 						any_working = 0;
@@ -2734,7 +2776,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 						printk(KERN_INFO "md/raid10:%s: insufficient "
 						       "working devices for recovery.\n",
 						       mdname(mddev));
-					conf->mirrors[i].recovery_disabled
+					mirror->recovery_disabled
 						= mddev->recovery_disabled;
 				}
 				break;



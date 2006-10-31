From: NeilBrown <neilb@suse.de>
Subject: [PATCH] Check bio address after mapping through partitions.
Date: Tue, 31 Oct 2006 12:51:45 +1100
Message-ID: <1061031015145.24246@suse.de>
References: <20061031124940.24199.patches@notabene>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965521AbWJaBvx@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>, stable@kernel.org
List-Id: linux-raid.ids

This would be good for 2.6.19 and even 18.2, if it is seens acceptable.
raid0 at least (possibly other) can be made to Oops with a bad partition 
table and best fix seem to be to not let out-of-range request get down
to the device.

### Comments for Changeset

Partitions are not limited to live within a device.  So
we should range check after partition mapping.

Note that 'maxsector' was being used for two different things.  I have
split off the second usage into 'old_sector' so that maxsector can be
still be used for it's primary usage later in the function.

Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./block/ll_rw_blk.c |   24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff .prev/block/ll_rw_blk.c ./block/ll_rw_blk.c
--- .prev/block/ll_rw_blk.c	2006-10-31 11:43:33.000000000 +1100
+++ ./block/ll_rw_blk.c	2006-10-31 12:47:07.000000000 +1100
@@ -3007,6 +3007,7 @@ static inline void __generic_make_reques
 {
 	request_queue_t *q;
 	sector_t maxsector;
+	sector_t old_sector;
 	int ret, nr_sectors = bio_sectors(bio);
 	dev_t old_dev;
 
@@ -3035,7 +3036,7 @@ static inline void __generic_make_reques
 	 * NOTE: we don't repeat the blk_size check for each new device.
 	 * Stacking drivers are expected to know what they are doing.
 	 */
-	maxsector = -1;
+	old_sector = -1;
 	old_dev = 0;
 	do {
 		char b[BDEVNAME_SIZE];
@@ -3069,15 +3070,30 @@ end_io:
 		 */
 		blk_partition_remap(bio);
 
-		if (maxsector != -1)
+		if (old_sector != -1)
 			blk_add_trace_remap(q, bio, old_dev, bio->bi_sector, 
-					    maxsector);
+					    old_sector);
 
 		blk_add_trace_bio(q, bio, BLK_TA_QUEUE);
 
-		maxsector = bio->bi_sector;
+		old_sector = bio->bi_sector;
 		old_dev = bio->bi_bdev->bd_dev;
 
+		maxsector = bio->bi_bdev->bd_inode->i_size >> 9;
+		if (maxsector) {
+			sector_t sector = bio->bi_sector;
+
+			if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {
+				/*
+				 * This may well happen - partitions are not checked
+				 * to make sure they are within the size of the
+				 * whole device.
+				 */
+				handle_bad_sector(bio);
+				goto end_io;
+			}
+		}
+
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
 }

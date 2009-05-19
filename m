From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject: [PATCH 004/009]: md. chunk size check
Date: Tue, 19 May 2009 19:09:43 +0300
Message-ID: <1242749383.3293.85.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, neilb@suse.de
Cc: ofer <ofer@bitband.com>, yaron <yaronp@bitband.com>
List-Id: linux-raid.ids

	md fixes
1.move chunk size check from md responsibility to each run function in each raid.
2.replace chunk size power 2 code calculations by a regular division.

 md.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

Signed-off-by: raziebe@gmail.com
---
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 279007a..3ac8813 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -444,8 +444,12 @@ static sector_t calc_num_sectors(mdk_rdev_t *rdev, unsigned chunk_size)
 {
 	sector_t num_sectors = rdev->sb_start;
 
-	if (chunk_size)
-		num_sectors &= ~((sector_t)chunk_size/512 - 1);
+	if (chunk_size) {
+		sector_t chunk_sects = chunk_size>>9;
+		sector_t x = num_sectors;
+		sector_div(x, chunk_sects);
+		num_sectors = x*chunk_sects;
+	}
 	return num_sectors;
 }
 
@@ -3518,7 +3522,8 @@ min_sync_store(mddev_t *mddev, const char *buf, size_t len)
 
 	/* Must be a multiple of chunk_size */
 	if (mddev->chunk_size) {
-		if (min & (sector_t)((mddev->chunk_size>>9)-1))
+		sector_t temp = min;
+		if (sector_div(temp, (mddev->chunk_size>>9)))
 			return -EINVAL;
 	}
 	mddev->resync_min = min;
@@ -3555,7 +3560,8 @@ max_sync_store(mddev_t *mddev, const char *buf, size_t len)
 
 		/* Must be a multiple of chunk_size */
 		if (mddev->chunk_size) {
-			if (max & (sector_t)((mddev->chunk_size>>9)-1))
+			sector_t temp = max;
+			if (sector_div(temp, (mddev->chunk_size>>9)))
 				return -EINVAL;
 		}
 		mddev->resync_max = max;
@@ -3996,14 +4002,6 @@ static int do_md_run(mddev_t * mddev)
 				chunk_size, MAX_CHUNK_SIZE);
 			return -EINVAL;
 		}
-		/*
-		 * chunk-size has to be a power of 2
-		 */
-		if ( (1 << ffz(~chunk_size)) != chunk_size) {
-			printk(KERN_ERR "chunk_size of %d not valid\n", chunk_size);
-			return -EINVAL;
-		}
-
 		/* devices must have minimum size of one chunk */
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (test_bit(Faulty, &rdev->flags))



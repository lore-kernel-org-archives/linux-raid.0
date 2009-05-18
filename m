From: raz ben yehuda <raziebe@gmail.com>
Subject: Subject [ md PATCH 4/6] : md to support page size chunks in the
	case of raid 0
Date: Tue, 19 May 2009 02:06:29 +0300
Message-ID: <1242687989.21201.16.camel@raz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux raid <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
Cc: ofer@bitband.com
List-Id: linux-raid.ids

md to support page size chunks in the case of raid 0
Signed-off-by: raziebe@gmail.com
 md.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)
---
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 279007a..aab183e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -443,9 +443,13 @@ static inline sector_t calc_dev_sboffset(struct block_device *bdev)
 static sector_t calc_num_sectors(mdk_rdev_t *rdev, unsigned chunk_size)
 {
 	sector_t num_sectors = rdev->sb_start;
+	if (chunk_size) {
+		sector_t chunk_sects = chunk_size>>9;
+		sector_t x = num_sectors;
+		sector_div(x, chunk_sects);
+		num_sectors = x*chunk_sects;
+	}
 
-	if (chunk_size)
-		num_sectors &= ~((sector_t)chunk_size/512 - 1);
 	return num_sectors;
 }
 
@@ -3518,11 +3522,11 @@ min_sync_store(mddev_t *mddev, const char *buf, size_t len)
 
 	/* Must be a multiple of chunk_size */
 	if (mddev->chunk_size) {
-		if (min & (sector_t)((mddev->chunk_size>>9)-1))
+		unsigned long long temp = min;
+		if (sector_div(temp, (mddev->chunk_size>>9)))
 			return -EINVAL;
 	}
 	mddev->resync_min = min;
-
 	return len;
 }
 
@@ -3555,7 +3559,8 @@ max_sync_store(mddev_t *mddev, const char *buf, size_t len)
 
 		/* Must be a multiple of chunk_size */
 		if (mddev->chunk_size) {
-			if (max & (sector_t)((mddev->chunk_size>>9)-1))
+			unsigned long long temp = max;
+			if (sector_div(temp, (mddev->chunk_size>>9)))
 				return -EINVAL;
 		}
 		mddev->resync_max = max;
@@ -3996,14 +4001,23 @@ static int do_md_run(mddev_t * mddev)
 				chunk_size, MAX_CHUNK_SIZE);
 			return -EINVAL;
 		}
+
 		/*
 		 * chunk-size has to be a power of 2
 		 */
-		if ( (1 << ffz(~chunk_size)) != chunk_size) {
+		if ((1 << ffz(~chunk_size)) != chunk_size &&
+			 mddev->level != 0) {
 			printk(KERN_ERR "chunk_size of %d not valid\n", chunk_size);
 			return -EINVAL;
 		}
-
+		/*
+		* raid0 chunk size has to divide by a page
+		*/
+		if (mddev->level == 0 && (chunk_size % PAGE_SIZE)) {
+			printk(KERN_ERR "chunk_size of %d not valid\n",
+				chunk_size);
+			return -EINVAL;
+		}
 		/* devices must have minimum size of one chunk */
 		list_for_each_entry(rdev, &mddev->disks, same_set) {
 			if (test_bit(Faulty, &rdev->flags))



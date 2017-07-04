From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH v2] md/bitmap: don't read page from device with Bitmap_sync
Date: Tue,  4 Jul 2017 11:20:30 +0800
Message-ID: <20170704032030.27665-1-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org, neilb@suse.com
Cc: linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

The device owns Bitmap_sync flag needs recovery
to become in sync, and read page from this type
device could get stale status.

Also add comments for Bitmap_sync bit per the
suggestion from Shaohua and Neil.

Previous disscussion can be found here:
https://marc.info/?t=149760428900004&r=1&w=2

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/bitmap.c | 3 ++-
 drivers/md/md.h     | 4 +++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index f4eace5..40f3cd7 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -156,7 +156,8 @@ static int read_sb_page(struct mddev *mddev, loff_t offset,
 
 	rdev_for_each(rdev, mddev) {
 		if (! test_bit(In_sync, &rdev->flags)
-		    || test_bit(Faulty, &rdev->flags))
+		    || test_bit(Faulty, &rdev->flags)
+		    || test_bit(Bitmap_sync, &rdev->flags))
 			continue;
 
 		target = offset + index * (PAGE_SIZE/512);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 991f0fe..b50eb4a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -134,7 +134,9 @@ enum flag_bits {
 	Faulty,			/* device is known to have a fault */
 	In_sync,		/* device is in_sync with rest of array */
 	Bitmap_sync,		/* ..actually, not quite In_sync.  Need a
-				 * bitmap-based recovery to get fully in sync
+				 * bitmap-based recovery to get fully in sync.
+				 * The bit is only meaningful before device
+				 * has been passed to pers->hot_add_disk.
 				 */
 	WriteMostly,		/* Avoid reading if at all possible */
 	AutoDetected,		/* added by auto-detect */
-- 
2.10.0


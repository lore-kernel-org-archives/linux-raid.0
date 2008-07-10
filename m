From: Andre Noll <maan@systemlinux.org>
Subject: [PATCH 1/5] md: Make update_size() take the number of sectors.
Date: Thu, 10 Jul 2008 11:15:34 +0200
Message-ID: <1215681338-32365-2-git-send-email-maan@systemlinux.org>
References: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Andre Noll <maan@systemlinux.org>
List-Id: linux-raid.ids

Changing the internal representations of sizes of raid devices
from 1K blocks to sector counts (512B units) is desirable because
it allows to get rid of many divisions/multiplications and unnecessary
casts that are present in the current code.

This patch is a first step in this direction. It replaces the old
1K-based "size" argument of update_size() by "num_sectors" and
fixes up its two callers.

Signed-off-by: Andre Noll <maan@systemlinux.org>
---
 drivers/md/md.c |   36 ++++++++++++++++++------------------
 1 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 2580ac1..2ab13a3 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2785,7 +2785,7 @@ size_show(mddev_t *mddev, char *page)
 	return sprintf(page, "%llu\n", (unsigned long long)mddev->size);
 }
 
-static int update_size(mddev_t *mddev, unsigned long size);
+static int update_size(mddev_t *mddev, sector_t num_sectors);
 
 static ssize_t
 size_store(mddev_t *mddev, const char *buf, size_t len)
@@ -2802,7 +2802,7 @@ size_store(mddev_t *mddev, const char *buf, size_t len)
 		return -EINVAL;
 
 	if (mddev->pers) {
-		err = update_size(mddev, size);
+		err = update_size(mddev, size * 2);
 		md_update_sb(mddev, 1);
 	} else {
 		if (mddev->size == 0 ||
@@ -4476,24 +4476,24 @@ static int set_array_info(mddev_t * mddev, mdu_array_info_t *info)
 	return 0;
 }
 
-static int update_size(mddev_t *mddev, unsigned long size)
+static int update_size(mddev_t *mddev, sector_t num_sectors)
 {
 	mdk_rdev_t * rdev;
 	int rv;
 	struct list_head *tmp;
-	int fit = (size == 0);
+	int fit = (num_sectors == 0);
 
 	if (mddev->pers->resize == NULL)
 		return -EINVAL;
-	/* The "size" is the amount of each device that is used.
-	 * This can only make sense for arrays with redundancy.
-	 * linear and raid0 always use whatever space is available
-	 * We can only consider changing the size if no resync
-	 * or reconstruction is happening, and if the new size
-	 * is acceptable. It must fit before the sb_offset or,
-	 * if that is <data_offset, it must fit before the
-	 * size of each device.
-	 * If size is zero, we find the largest size that fits.
+	/* The "num_sectors" is the number of sectors of each device that
+	 * is used.  This can only make sense for arrays with redundancy.
+	 * linear and raid0 always use whatever space is available. We can only
+	 * consider changing this number if no resync or reconstruction is
+	 * happening, and if the new size is acceptable. It must fit before the
+	 * sb_offset or, if that is <data_offset, it must fit before the size
+	 * of each device.  If num_sectors is zero, we find the largest size
+	 * that fits.
+
 	 */
 	if (mddev->sync_thread)
 		return -EBUSY;
@@ -4501,12 +4501,12 @@ static int update_size(mddev_t *mddev, unsigned long size)
 		sector_t avail;
 		avail = rdev->size * 2;
 
-		if (fit && (size == 0 || size > avail/2))
-			size = avail/2;
-		if (avail < ((sector_t)size << 1))
+		if (fit && (num_sectors == 0 || num_sectors > avail))
+			num_sectors = avail;
+		if (avail < num_sectors)
 			return -ENOSPC;
 	}
-	rv = mddev->pers->resize(mddev, (sector_t)size *2);
+	rv = mddev->pers->resize(mddev, num_sectors);
 	if (!rv) {
 		struct block_device *bdev;
 
@@ -4588,7 +4588,7 @@ static int update_array_info(mddev_t *mddev, mdu_array_info_t *info)
 			return mddev->pers->reconfig(mddev, info->layout, -1);
 	}
 	if (info->size >= 0 && mddev->size != info->size)
-		rv = update_size(mddev, info->size);
+		rv = update_size(mddev, info->size * 2);
 
 	if (mddev->raid_disks    != info->raid_disks)
 		rv = update_raid_disks(mddev, info->raid_disks);
-- 
1.5.3.8


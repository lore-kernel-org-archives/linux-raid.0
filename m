From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH] md - 7 of 8 - Allow md arrays to be resized if devices are large enough.
Date: Fri, 28 May 2004 16:45:25 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <E1BTb7N-0002U4-GR@notabene.cse.unsw.edu.au>
References: <20040528163700.9426.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


It is possible to have raid1/4/5/6 arrays that do not 
use all the space on the drive.
This can be done explicitly, or can happen info you,
one by one, replace all the drives with larger devices.

This patch extends the "SET_ARRAY_INFO" ioctl (which previously
invalid on active arrays) allow some attributes of the array
to be changed and implements changing of the "size" attribute.

"size" is the amount of each device that is actually used.
If "size" is increased, the new space will immediately be
"resynced".

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

 ----------- Diffstat output ------------
 ./drivers/md/md.c           |  110 +++++++++++++++++++++++++++++++++++++-------
 ./drivers/md/raid1.c        |   21 ++++++++
 ./drivers/md/raid5.c        |   22 ++++++++
 ./drivers/md/raid6main.c    |   22 ++++++++
 ./include/linux/raid/md_k.h |    1 
 5 files changed, 160 insertions(+), 16 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2004-05-28 16:29:32.000000000 +1000
+++ ./drivers/md/md.c	2004-05-28 16:29:57.000000000 +1000
@@ -2411,6 +2411,76 @@ static int set_array_info(mddev_t * mdde
 	return 0;
 }
 
+/*
+ * update_array_info is used to change the configuration of an
+ * on-line array.
+ * The version, ctime,level,size,raid_disks,not_persistent, layout,chunk_size
+ * fields in the info are checked against the array.
+ * Any differences that cannot be handled will cause an error.
+ * Normally, only one change can be managed at a time.
+ */
+static int update_array_info(mddev_t *mddev, mdu_array_info_t *info)
+{
+	int rv = 0;
+
+	if (mddev->major_version != info->major_version ||
+	    mddev->minor_version != info->minor_version ||
+/*	    mddev->patch_version != info->patch_version || */
+	    mddev->ctime         != info->ctime         ||
+	    mddev->level         != info->level         ||
+	    mddev->raid_disks    != info->raid_disks    ||
+	    mddev->layout        != info->layout        ||
+	    !mddev->persistent	 != info->not_persistent||
+	    mddev->chunk_size    != info->chunk_size    )
+		return -EINVAL;
+	/* that leaves only size */
+	if (mddev->size != info->size) {
+		mdk_rdev_t * rdev;
+		struct list_head *tmp;
+		if (mddev->pers->resize == NULL)
+			return -EINVAL;
+		/* The "size" is the amount of each device that is used.
+		 * This can only make sense for arrays with redundancy.
+		 * linear and raid0 always use whatever space is available
+		 * We can only consider changing the size of no resync
+		 * or reconstruction is happening, and if the new size
+		 * is acceptable. It must fit before the sb_offset or,
+		 * if that is <data_offset, it must fit before the
+		 * size of each device.
+		 * If size is zero, we find the largest size that fits.
+		 */
+		if (mddev->sync_thread)
+			return -EBUSY;
+		ITERATE_RDEV(mddev,rdev,tmp) {
+			sector_t avail;
+			int fit = (info->size == 0);
+			if (rdev->sb_offset > rdev->data_offset)
+				avail = (rdev->sb_offset*2) - rdev->data_offset;
+			else
+				avail = get_capacity(rdev->bdev->bd_disk)
+					- rdev->data_offset;
+			if (fit && (info->size == 0 || info->size > avail/2))
+				info->size = avail/2;
+			if (avail < ((sector_t)info->size << 1))
+				return -ENOSPC;
+		}
+		rv = mddev->pers->resize(mddev, (sector_t)info->size *2);
+		if (!rv) {
+			struct block_device *bdev;
+
+			bdev = bdget_disk(mddev->gendisk, 0);
+			if (bdev) {
+				down(&bdev->bd_inode->i_sem);
+				i_size_write(bdev->bd_inode, mddev->array_size << 10);
+				up(&bdev->bd_inode->i_sem);
+				bdput(bdev);
+			}
+		}
+	}
+	md_update_sb(mddev);
+	return rv;
+}
+
 static int set_disk_faulty(mddev_t *mddev, dev_t dev)
 {
 	mdk_rdev_t *rdev;
@@ -2502,21 +2572,6 @@ static int md_ioctl(struct inode *inode,
 	switch (cmd)
 	{
 		case SET_ARRAY_INFO:
-
-			if (!list_empty(&mddev->disks)) {
-				printk(KERN_WARNING 
-					"md: array %s already has disks!\n",
-					mdname(mddev));
-				err = -EBUSY;
-				goto abort_unlock;
-			}
-			if (mddev->raid_disks) {
-				printk(KERN_WARNING 
-					"md: array %s already initialised!\n",
-					mdname(mddev));
-				err = -EBUSY;
-				goto abort_unlock;
-			}
 			{
 				mdu_array_info_t info;
 				if (!arg)
@@ -2525,10 +2580,33 @@ static int md_ioctl(struct inode *inode,
 					err = -EFAULT;
 					goto abort_unlock;
 				}
+				if (mddev->pers) {
+					err = update_array_info(mddev, &info);
+					if (err) {
+						printk(KERN_WARNING "md: couldn't update"
+						       " array info. %d\n", err);
+						goto abort_unlock;
+					}
+					goto done_unlock;
+				}
+				if (!list_empty(&mddev->disks)) {
+					printk(KERN_WARNING 
+					       "md: array %s already has disks!\n",
+					       mdname(mddev));
+					err = -EBUSY;
+					goto abort_unlock;
+				}
+				if (mddev->raid_disks) {
+					printk(KERN_WARNING 
+					       "md: array %s already initialised!\n",
+					       mdname(mddev));
+					err = -EBUSY;
+					goto abort_unlock;
+				}
 				err = set_array_info(mddev, &info);
 				if (err) {
 					printk(KERN_WARNING "md: couldn't set"
-						" array info. %d\n", err);
+					       " array info. %d\n", err);
 					goto abort_unlock;
 				}
 			}

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-05-28 16:28:18.000000000 +1000
+++ ./drivers/md/raid1.c	2004-05-28 16:29:57.000000000 +1000
@@ -1296,6 +1296,26 @@ static int stop(mddev_t *mddev)
 	return 0;
 }
 
+static int raid1_resize(mddev_t *mddev, sector_t sectors)
+{
+	/* no resync is happening, and there is enough space 
+	 * on all devices, so we can resize.
+	 * We need to make sure resync covers any new space.
+	 * If the array is shrinking we should possibly wait until
+	 * any io in the removed space completes, but it hardly seems
+	 * worth it.
+	 */
+	mddev->array_size = sectors>>1;
+	set_capacity(mddev->gendisk, mddev->array_size << 1);
+	mddev->changed = 1;
+	if (mddev->array_size > mddev->size && mddev->recovery_cp == MaxSector) {
+		mddev->recovery_cp = mddev->size << 1;
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	}
+	mddev->size = mddev->array_size;
+	return 0;
+}
+
 static mdk_personality_t raid1_personality =
 {
 	.name		= "raid1",
@@ -1309,6 +1329,7 @@ static mdk_personality_t raid1_personali
 	.hot_remove_disk= raid1_remove_disk,
 	.spare_active	= raid1_spare_active,
 	.sync_request	= sync_request,
+	.resize		= raid1_resize,
 };
 
 static int __init raid_init(void)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2004-05-28 16:28:13.000000000 +1000
+++ ./drivers/md/raid5.c	2004-05-28 16:29:57.000000000 +1000
@@ -1865,6 +1865,27 @@ static int raid5_add_disk(mddev_t *mddev
 	return found;
 }
 
+static int raid5_resize(mddev_t *mddev, sector_t sectors)
+{
+	/* no resync is happening, and there is enough space 
+	 * on all devices, so we can resize.
+	 * We need to make sure resync covers any new space.
+	 * If the array is shrinking we should possibly wait until
+	 * any io in the removed space completes, but it hardly seems
+	 * worth it.
+	 */
+	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
+	mddev->array_size = (sectors * (mddev->raid_disks-1))>>1;
+	set_capacity(mddev->gendisk, mddev->array_size << 1);
+	mddev->changed = 1;
+	if (sectors/2  > mddev->size && mddev->recovery_cp == MaxSector) {
+		mddev->recovery_cp = mddev->size << 1;
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	}
+	mddev->size = sectors /2;
+	return 0;
+}
+
 static mdk_personality_t raid5_personality=
 {
 	.name		= "raid5",
@@ -1878,6 +1899,7 @@ static mdk_personality_t raid5_personali
 	.hot_remove_disk= raid5_remove_disk,
 	.spare_active	= raid5_spare_active,
 	.sync_request	= sync_request,
+	.resize		= raid5_resize,
 };
 
 static int __init raid5_init (void)

diff ./drivers/md/raid6main.c~current~ ./drivers/md/raid6main.c
--- ./drivers/md/raid6main.c~current~	2004-05-28 16:28:13.000000000 +1000
+++ ./drivers/md/raid6main.c	2004-05-28 16:29:57.000000000 +1000
@@ -2034,6 +2034,27 @@ static int raid6_add_disk(mddev_t *mddev
 	return found;
 }
 
+static int raid6_resize(mddev_t *mddev, sector_t sectors)
+{
+	/* no resync is happening, and there is enough space 
+	 * on all devices, so we can resize.
+	 * We need to make sure resync covers any new space.
+	 * If the array is shrinking we should possibly wait until
+	 * any io in the removed space completes, but it hardly seems
+	 * worth it.
+	 */
+	sectors &= ~((sector_t)mddev->chunk_size/512 - 1);
+	mddev->array_size = (sectors * (mddev->raid_disks-2))>>1;
+	set_capacity(mddev->gendisk, mddev->array_size << 1);
+	mddev->changed = 1;
+	if (sectors/2  > mddev->size && mddev->recovery_cp == MaxSector) {
+		mddev->recovery_cp = mddev->size << 1;
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	}
+	mddev->size = sectors /2;
+	return 0;
+}
+
 static mdk_personality_t raid6_personality=
 {
 	.name		= "raid6",
@@ -2047,6 +2068,7 @@ static mdk_personality_t raid6_personali
 	.hot_remove_disk= raid6_remove_disk,
 	.spare_active	= raid6_spare_active,
 	.sync_request	= sync_request,
+	.resize		= raid6_resize,
 };
 
 static int __init raid6_init (void)

diff ./include/linux/raid/md_k.h~current~ ./include/linux/raid/md_k.h
--- ./include/linux/raid/md_k.h~current~	2004-05-28 16:28:13.000000000 +1000
+++ ./include/linux/raid/md_k.h	2004-05-28 16:29:57.000000000 +1000
@@ -279,6 +279,7 @@ struct mdk_personality_s
 	int (*hot_remove_disk) (mddev_t *mddev, int number);
 	int (*spare_active) (mddev_t *mddev);
 	int (*sync_request)(mddev_t *mddev, sector_t sector_nr, int go_faster);
+	int (*resize) (mddev_t *mddev, sector_t sectors);
 };
 
 

From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 010 of 20] Allow md array component size to be accessed and set via sysfs
Date: Mon, 12 Dec 2005 14:15:03 +1100
Message-ID: <1051212031503.5079@suse.de>
References: <20051212135705.4561.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./Documentation/md.txt |    9 +++
 ./drivers/md/md.c      |  131 +++++++++++++++++++++++++++++++++----------------
 2 files changed, 98 insertions(+), 42 deletions(-)

diff ./Documentation/md.txt~current~ ./Documentation/md.txt
--- ./Documentation/md.txt~current~	2005-12-12 11:31:25.000000000 +1100
+++ ./Documentation/md.txt	2005-12-12 11:31:46.000000000 +1100
@@ -174,6 +174,15 @@ All md devices contain:
      The size should be atleast PAGE_SIZE (4k) and should be a power
      of 2.  This can only be set while assembling an array
 
+  component_size
+     For arrays with data redundancy (i.e. not raid0, linear, faulty,
+     multipath), all components must be the same size - or at least
+     there must a size that they all provide space for.  This is a key
+     part or the geometry of the array.  It is measured in sectors
+     and can be read from here.  Writing to this value may resize
+     the array if the personality supports it (raid1, raid5, raid6),
+     and if the component drives are large enough.
+
 As component devices are added to an md array, they appear in the 'md'
 directory as new directories named
       dev-XXX

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-12-12 11:31:25.000000000 +1100
+++ ./drivers/md/md.c	2005-12-12 11:32:28.000000000 +1100
@@ -1820,6 +1820,44 @@ __ATTR(chunk_size, 0644, chunk_size_show
 
 
 static ssize_t
+size_show(mddev_t *mddev, char *page)
+{
+	return sprintf(page, "%llu\n", (unsigned long long)mddev->size);
+}
+
+static int update_size(mddev_t *mddev, unsigned long size);
+
+static ssize_t
+size_store(mddev_t *mddev, const char *buf, size_t len)
+{
+	/* If array is inactive, we can reduce the component size, but
+	 * not increase it (except from 0).
+	 * If array is active, we can try an on-line resize
+	 */
+	char *e;
+	int err = 0;
+	unsigned long long size = simple_strtoull(buf, &e, 10);
+	if (!*buf || *buf == '\n' ||
+	    (*e && *e != '\n'))
+		return -EINVAL;
+
+	if (mddev->pers) {
+		err = update_size(mddev, size);
+		md_update_sb(mddev);
+	} else {
+		if (mddev->size == 0 ||
+		    mddev->size > size)
+			mddev->size = size;
+		else
+			err = -ENOSPC;
+	}
+	return err ? err : len;
+}
+
+static struct md_sysfs_entry md_size =
+__ATTR(component_size, 0644, size_show, size_store);
+
+static ssize_t
 action_show(mddev_t *mddev, char *page)
 {
 	char *type = "idle";
@@ -1887,6 +1925,7 @@ static struct attribute *md_default_attr
 	&md_level.attr,
 	&md_raid_disks.attr,
 	&md_chunk_size.attr,
+	&md_size.attr,
 	NULL,
 };
 
@@ -3005,6 +3044,54 @@ static int set_array_info(mddev_t * mdde
 	return 0;
 }
 
+static int update_size(mddev_t *mddev, unsigned long size)
+{
+	mdk_rdev_t * rdev;
+	int rv;
+	struct list_head *tmp;
+
+	if (mddev->pers->resize == NULL)
+		return -EINVAL;
+	/* The "size" is the amount of each device that is used.
+	 * This can only make sense for arrays with redundancy.
+	 * linear and raid0 always use whatever space is available
+	 * We can only consider changing the size if no resync
+	 * or reconstruction is happening, and if the new size
+	 * is acceptable. It must fit before the sb_offset or,
+	 * if that is <data_offset, it must fit before the
+	 * size of each device.
+	 * If size is zero, we find the largest size that fits.
+	 */
+	if (mddev->sync_thread)
+		return -EBUSY;
+	ITERATE_RDEV(mddev,rdev,tmp) {
+		sector_t avail;
+		int fit = (size == 0);
+		if (rdev->sb_offset > rdev->data_offset)
+			avail = (rdev->sb_offset*2) - rdev->data_offset;
+		else
+			avail = get_capacity(rdev->bdev->bd_disk)
+				- rdev->data_offset;
+		if (fit && (size == 0 || size > avail/2))
+			size = avail/2;
+		if (avail < ((sector_t)size << 1))
+			return -ENOSPC;
+	}
+	rv = mddev->pers->resize(mddev, (sector_t)size *2);
+	if (!rv) {
+		struct block_device *bdev;
+
+		bdev = bdget_disk(mddev->gendisk, 0);
+		if (bdev) {
+			down(&bdev->bd_inode->i_sem);
+			i_size_write(bdev->bd_inode, mddev->array_size << 10);
+			up(&bdev->bd_inode->i_sem);
+			bdput(bdev);
+		}
+	}
+	return rv;
+}
+
 /*
  * update_array_info is used to change the configuration of an
  * on-line array.
@@ -3053,49 +3140,9 @@ static int update_array_info(mddev_t *md
 		else
 			return mddev->pers->reconfig(mddev, info->layout, -1);
 	}
-	if (mddev->size != info->size) {
-		mdk_rdev_t * rdev;
-		struct list_head *tmp;
-		if (mddev->pers->resize == NULL)
-			return -EINVAL;
-		/* The "size" is the amount of each device that is used.
-		 * This can only make sense for arrays with redundancy.
-		 * linear and raid0 always use whatever space is available
-		 * We can only consider changing the size if no resync
-		 * or reconstruction is happening, and if the new size
-		 * is acceptable. It must fit before the sb_offset or,
-		 * if that is <data_offset, it must fit before the
-		 * size of each device.
-		 * If size is zero, we find the largest size that fits.
-		 */
-		if (mddev->sync_thread)
-			return -EBUSY;
-		ITERATE_RDEV(mddev,rdev,tmp) {
-			sector_t avail;
-			int fit = (info->size == 0);
-			if (rdev->sb_offset > rdev->data_offset)
-				avail = (rdev->sb_offset*2) - rdev->data_offset;
-			else
-				avail = get_capacity(rdev->bdev->bd_disk)
-					- rdev->data_offset;
-			if (fit && (info->size == 0 || info->size > avail/2))
-				info->size = avail/2;
-			if (avail < ((sector_t)info->size << 1))
-				return -ENOSPC;
-		}
-		rv = mddev->pers->resize(mddev, (sector_t)info->size *2);
-		if (!rv) {
-			struct block_device *bdev;
+	if (mddev->size != info->size)
+		rv = update_size(mddev, info->size);
 
-			bdev = bdget_disk(mddev->gendisk, 0);
-			if (bdev) {
-				down(&bdev->bd_inode->i_sem);
-				i_size_write(bdev->bd_inode, mddev->array_size << 10);
-				up(&bdev->bd_inode->i_sem);
-				bdput(bdev);
-			}
-		}
-	}
 	if (mddev->raid_disks    != info->raid_disks) {
 		/* change the number of raid disks */
 		if (mddev->pers->reshape == NULL)

From: NeilBrown <neilb@suse.de>
Subject: [PATCH 018 of 29] md: Support changing rdev size on running arrays.
Date: Fri, 27 Jun 2008 16:51:16 +1000
Message-ID: <1080627065116.10596@suse.de>
References: <20080627164503.9671.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Chris Webb <chris@arachsys.com>
List-Id: linux-raid.ids


From: Chris Webb <chris@arachsys.com>

Allow /sys/block/mdX/md/rdY/size to change on running arrays, moving the
superblock if necessary for this metadata version. We prevent the available
space from shrinking to less than the used size, and allow it to be set to zero
to fill all the available space on the underlying device.

Signed-off-by: Chris Webb <chris@arachsys.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/md.c |  100 ++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 87 insertions(+), 13 deletions(-)

diff .prev/drivers/md/md.c ./drivers/md/md.c
--- .prev/drivers/md/md.c	2008-06-27 16:22:03.000000000 +1000
+++ ./drivers/md/md.c	2008-06-27 16:22:03.000000000 +1000
@@ -658,11 +658,14 @@ static unsigned int calc_sb_csum(mdp_sup
  */
 
 struct super_type  {
-	char 		*name;
-	struct module	*owner;
-	int		(*load_super)(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version);
-	int		(*validate_super)(mddev_t *mddev, mdk_rdev_t *rdev);
-	void		(*sync_super)(mddev_t *mddev, mdk_rdev_t *rdev);
+	char		    *name;
+	struct module	    *owner;
+	int		    (*load_super)(mdk_rdev_t *rdev, mdk_rdev_t *refdev,
+					  int minor_version);
+	int		    (*validate_super)(mddev_t *mddev, mdk_rdev_t *rdev);
+	void		    (*sync_super)(mddev_t *mddev, mdk_rdev_t *rdev);
+	unsigned long long  (*rdev_size_change)(mdk_rdev_t *rdev,
+						unsigned long long size);
 };
 
 /*
@@ -1004,6 +1007,27 @@ static void super_90_sync(mddev_t *mddev
 }
 
 /*
+ * rdev_size_change for 0.90.0
+ */
+static unsigned long long
+super_90_rdev_size_change(mdk_rdev_t *rdev, unsigned long long size)
+{
+	if (size && size < rdev->mddev->size)
+		return 0; /* component must fit device */
+	size *= 2; /* convert to sectors */
+	if (rdev->mddev->bitmap_offset)
+		return 0; /* can't move bitmap */
+	rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
+	if (!size || size > rdev->sb_offset*2)
+		size = rdev->sb_offset*2;
+	md_super_write(rdev->mddev, rdev, rdev->sb_offset << 1, rdev->sb_size,
+		       rdev->sb_page);
+	md_super_wait(rdev->mddev);
+	return size/2; /* kB for sysfs */
+}
+
+
+/*
  * version 1 superblock
  */
 
@@ -1328,21 +1352,59 @@ static void super_1_sync(mddev_t *mddev,
 	sb->sb_csum = calc_sb_1_csum(sb);
 }
 
+static unsigned long long
+super_1_rdev_size_change(mdk_rdev_t *rdev, unsigned long long size)
+{
+	struct mdp_superblock_1 *sb;
+	unsigned long long max_size;
+	if (size && size < rdev->mddev->size)
+		return 0; /* component must fit device */
+	size *= 2; /* convert to sectors */
+	if (rdev->sb_offset < rdev->data_offset/2) {
+		/* minor versions 1 and 2; superblock before data */
+		max_size = (rdev->bdev->bd_inode->i_size >> 9);
+		max_size -= rdev->data_offset;
+		if (!size || size > max_size)
+			size = max_size;
+	} else if (rdev->mddev->bitmap_offset) {
+		/* minor version 0 with bitmap we can't move */
+		return 0;
+	} else {
+		/* minor version 0; superblock after data */
+		sector_t sb_offset;
+		sb_offset = (rdev->bdev->bd_inode->i_size >> 9) - 8*2;
+		sb_offset &= ~(sector_t)(4*2 - 1);
+		max_size = rdev->size*2 + sb_offset - rdev->sb_offset*2;
+		if (!size || size > max_size)
+			size = max_size;
+		rdev->sb_offset = sb_offset/2;
+	}
+	sb = (struct mdp_superblock_1 *) page_address(rdev->sb_page);
+	sb->data_size = cpu_to_le64(size);
+	sb->super_offset = rdev->sb_offset*2;
+	sb->sb_csum = calc_sb_1_csum(sb);
+	md_super_write(rdev->mddev, rdev, rdev->sb_offset << 1, rdev->sb_size,
+		       rdev->sb_page);
+	md_super_wait(rdev->mddev);
+	return size/2; /* kB for sysfs */
+}
 
 static struct super_type super_types[] = {
 	[0] = {
 		.name	= "0.90.0",
 		.owner	= THIS_MODULE,
-		.load_super	= super_90_load,
-		.validate_super	= super_90_validate,
-		.sync_super	= super_90_sync,
+		.load_super	    = super_90_load,
+		.validate_super	    = super_90_validate,
+		.sync_super	    = super_90_sync,
+		.rdev_size_change   = super_90_rdev_size_change,
 	},
 	[1] = {
 		.name	= "md-1",
 		.owner	= THIS_MODULE,
-		.load_super	= super_1_load,
-		.validate_super	= super_1_validate,
-		.sync_super	= super_1_sync,
+		.load_super	    = super_1_load,
+		.validate_super	    = super_1_validate,
+		.sync_super	    = super_1_sync,
+		.rdev_size_change   = super_1_rdev_size_change,
 	},
 };
 
@@ -2060,8 +2122,20 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (my_mddev->pers && rdev->raid_disk >= 0)
-		return -EBUSY;
+	if (my_mddev->pers && rdev->raid_disk >= 0) {
+		if (rdev->mddev->persistent) {
+			size = super_types[rdev->mddev->major_version].
+				rdev_size_change(rdev, size);
+			if (!size)
+				return -EBUSY;
+		} else if (!size) {
+			size = (rdev->bdev->bd_inode->i_size >> 10);
+			size -= rdev->data_offset/2;
+		}
+		if (size < rdev->mddev->size)
+			return -EINVAL; /* component must fit device */
+	}
+
 	rdev->size = size;
 	if (size > oldsize && rdev->mddev->external) {
 		/* need to check that all other rdevs with the same ->bdev

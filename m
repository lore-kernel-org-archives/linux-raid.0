From: Chris Webb <chris@arachsys.com>
Subject: Re: Trouble increasing md component size
Date: Wed, 25 Jun 2008 00:19:47 +0100
Message-ID: <20080624231947.GG9948@arachsys.com>
References: <18528.10590.221031.75420@notabene.brown> <20080624114706.GD9948@arachsys.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="8nsIa27JVQLqB7/C"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080624114706.GD9948@arachsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--8nsIa27JVQLqB7/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Chris Webb <chris@arachsys.com> writes:

> Oops.

One final (hopefully!) correction: my patch didn't do the quite right thing
in the case of externally managed metadata, where there's no persistent
superblock to update.

Cheers,

Chris.

--8nsIa27JVQLqB7/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.24.4-md-rdev-size.5.patch"

From: Chris Webb <chris@arachsys.com>

Allow /sys/block/mdX/md/rdY/size to change on running arrays, moving the
superblock if necessary for this metadata version. We prevent the available
space from shrinking to less than the used size, and allow it to be set to zero
to fill all the available space on the underlying device.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 drivers/md/md.c |  100 ++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 87 insertions(+), 13 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -652,11 +652,14 @@
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
@@ -992,6 +995,27 @@
 	sb->this_disk = sb->disks[rdev->desc_nr];
 	sb->sb_csum = calc_sb_csum(sb);
 }
+
+/*
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
 
 /*
  * version 1 superblock
@@ -1310,21 +1334,59 @@
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
+	sb = (struct mdp_superblock_1 *) page_address(rdev->sb_page);
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
 
@@ -1946,8 +2008,20 @@
 	unsigned long long size = simple_strtoull(buf, &e, 10);
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers)
-		return -EBUSY;
+	if (rdev->mddev->pers) {
+		if (rdev->mddev->persistent) {
+			mdp_super_t *sb;
+			sb = (mdp_super_t *) page_address(rdev->sb_page);
+			size = super_types[sb->major_version].
+				rdev_size_change(rdev, size);
+			if (!size)
+				return -EBUSY;
+		} else if (!size) {
+			size = (rdev->bdev->bd_inode->i_size >> 10);
+			size -= rdev->data_offset/2;
+		} else if (size < rdev->mddev->size)
+			return 0; /* component must fit device */
+	}
 	rdev->size = size;
 	if (size < rdev->mddev->size || rdev->mddev->size == 0)
 		rdev->mddev->size = size;

--8nsIa27JVQLqB7/C--

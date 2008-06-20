From: Chris Webb <chris@arachsys.com>
Subject: Re: Trouble increasing md component size
Date: Fri, 20 Jun 2008 15:24:40 +0100
Message-ID: <20080620142440.GA2630@arachsys.com>
References: <20080619234914.GA24881@arachsys.com> <20080620111329.GA28046@arachsys.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="NzB8fVQJ5HfG6fxh"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080620111329.GA28046@arachsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Chris Webb <chris@arachsys.com> writes:

> I'd like to support metadata types 0.90 and 1.0 too, relocating the
> superblock. I think it'd be sufficient to write a new one at the end of
> the device then update rdev->sb_offset. I'll try this next week.

I've had a quick stab at this before I leave along with fixing a couple of
other oversights. (I just return EBUSY if there's a bitmap present in 0.90
and 1.0.) It appears to work correctly for 0.90 but generates a corrupt
superblock for 1.0, which I'll need to fix on Monday.

Cheers,

Chris.

--NzB8fVQJ5HfG6fxh
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.24.4-md-rdev-size.2.patch"

--- linux-2.6.24.4/drivers/md/md.c	2008-03-24 18:49:18.000000000 +0000
+++ linux-2.6.24.4-cdwmd/drivers/md/md.c	2008-06-20 15:02:01.000000000 +0100
@@ -652,11 +652,12 @@ static unsigned int calc_sb_csum(mdp_sup
  */
 
 struct super_type  {
-	char 		*name;
-	struct module	*owner;
-	int		(*load_super)(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version);
-	int		(*validate_super)(mddev_t *mddev, mdk_rdev_t *rdev);
-	void		(*sync_super)(mddev_t *mddev, mdk_rdev_t *rdev);
+	char		    *name;
+	struct module	    *owner;
+	int		    (*load_super)(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version);
+	int		    (*validate_super)(mddev_t *mddev, mdk_rdev_t *rdev);
+	void		    (*sync_super)(mddev_t *mddev, mdk_rdev_t *rdev);
+	unsigned long long  (*rdev_size_change)(mdk_rdev_t *rdev, unsigned long long size);
 };
 
 /*
@@ -994,6 +995,23 @@ static void super_90_sync(mddev_t *mddev
 }
 
 /*
+ * rdev_size_change for 0.90.0
+ */
+static unsigned long long
+super_90_rdev_size_change(mdk_rdev_t *rdev, unsigned long long size)
+{
+	if (rdev->mddev->bitmap_offset)
+		return 0; /* can't move bitmap */
+	rdev->sb_offset = calc_dev_sboffset(rdev->bdev);
+	if (!size || size > rdev->sb_offset)
+		size = rdev->sb_offset;
+	md_super_write(rdev->mddev, rdev, rdev->sb_offset << 1, rdev->sb_size,
+			rdev->sb_page);
+	return size;
+}
+
+
+/*
  * version 1 superblock
  */
 
@@ -1310,21 +1328,49 @@ static void super_1_sync(mddev_t *mddev,
 	sb->sb_csum = calc_sb_1_csum(sb);
 }
 
+static unsigned long long
+super_1_rdev_size_change(mdk_rdev_t *rdev, unsigned long long size)
+{
+	struct mdp_superblock_1 *sb;
+	sb = (struct mdp_superblock_1 *) page_address(rdev->sb_page);
+	if (rdev->sb_offset < rdev->data_offset/2) {
+		/* minor versions 1 and 2; superblock before data */
+		unsigned long long max_size;
+		max_size = (rdev->bdev->bd_inode->i_size >> 10) - rdev->data_offset/2;
+		if (!size || size > max_size)
+			size = max_size;
+	} else {
+		/* minor version 0; superblock after data */
+		if (rdev->mddev->bitmap_offset)
+			return 0; /* can't move bitmap */
+		rdev->sb_offset = (rdev->bdev->bd_inode->i_size >> 10) - 8;
+		rdev->sb_offset &= ~(sector_t)(4 - 1);
+		if (!size || size > rdev->sb_offset - rdev->data_offset/2)
+			size = rdev->sb_offset - rdev->data_offset/2;
+	}
+	sb->data_size = cpu_to_le64(size*2);
+	sb->sb_csum = calc_sb_1_csum(sb);
+	md_super_write(rdev->mddev, rdev, rdev->sb_offset << 1, rdev->sb_size,
+			rdev->sb_page);
+	return size;
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
 
@@ -1946,8 +1992,13 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 	unsigned long long size = simple_strtoull(buf, &e, 10);
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers)
-		return -EBUSY;
+	if (rdev->mddev->pers) {
+		mdp_super_t *sb;
+		sb = (mdp_super_t *) page_address(rdev->sb_page);
+		size = super_types[sb->major_version].rdev_size_change(rdev, size);
+		if (!size)
+			return -EBUSY;
+	}
 	rdev->size = size;
 	if (size < rdev->mddev->size || rdev->mddev->size == 0)
 		rdev->mddev->size = size;

--NzB8fVQJ5HfG6fxh--

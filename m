From: Chris Webb <chris@arachsys.com>
Subject: Re: Trouble increasing md component size
Date: Fri, 20 Jun 2008 12:13:29 +0100
Message-ID: <20080620111329.GA28046@arachsys.com>
References: <20080619234914.GA24881@arachsys.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="X1bOJ3K7DJ5YkBrT"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080619234914.GA24881@arachsys.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Here's an updated, cleaned up version of my patch. Since the action is
superblock version-specific, it now indirects through super_types[] as other
version-specific parts of md.c do. At present it allows the rdev->size to be
updated through sysfs for metadata types 1.1 and 1.2, making all the correct
checks on the supplied value. It also supports growing rdev->size as large
as possible for the block device using echo "0" >/sys/block/mdX/md/rdY/size.

If you try to extend the size of 1.0 and 0.90 devices so that the data area
would overlap the superblock, rdev_size_store just returns EBUSY, the same
behaviour as previously. I'd like to support metadata types 0.90 and 1.0
too, relocating the superblock. I think it'd be sufficient to write a new
one at the end of the device then update rdev->sb_offset. I'll try this next
week.

I'm a bit puzzled about what to do if there's an internal bitmap. I can
ignore the issue at present because I only handle 1.1 and 1.2 metadata,
where any bitmap is stored before the start of the data area.

For metadata at the end of the disk, the bitmap will either be just before
or just after the superblock, and so I'll presumably need to move it to the
new end of the device along with the superblock. However, it looks at first
glance like the bitmap offset is constant across the array, not a per-device
setting. This suggests the bitmap has to move when the array is grown, not
earlier when rdev->size changes.

Unfortunately, that doesn't square with rdev->size being changed for
individual disks first! I can't move the bitmap without changing rdev->size
on all disks, but I can't increase rdev->size to a valid value on any disk
without moving the bitmap at the same point. Either I'm missing something,
or changing rdev->size online, drive-by-drive won't be possible if there's
an internal bitmap on a 0.90 or 1.0 format array.

I'm unlikely to get a chance to work on this again before Monday, but
I'd be very grateful for any feedback or pointers. md.c is a fairly
involved piece of code!

Cheers,

Chris.

--X1bOJ3K7DJ5YkBrT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.24.4-md-rdev-size.2.patch"

--- linux-2.6.24.4/drivers/md/md.c	2008-03-24 18:49:18.000000000 +0000
+++ linux-2.6.24.4-cdwmd/drivers/md/md.c	2008-06-20 12:08:01.000000000 +0100
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
@@ -994,6 +995,19 @@ static void super_90_sync(mddev_t *mddev
 }
 
 /*
+ * rdev_size_change for 0.90.0
+ */
+static unsigned long long
+super_90_rdev_size_change(mdk_rdev_t *rdev, unsigned long long size)
+{
+	/* TODO: relocate sb to use full device */
+	if (!size || size > rdev->sb_offset - rdev->data_offset/2)
+		size = rdev->sb_offset - rdev->data_offset/2;
+	return size;
+}
+
+
+/*
  * version 1 superblock
  */
 
@@ -1310,21 +1324,52 @@ static void super_1_sync(mddev_t *mddev,
 	sb->sb_csum = calc_sb_1_csum(sb);
 }
 
+static unsigned long long
+super_1_rdev_size_change(mdk_rdev_t *rdev, unsigned long long size)
+{
+	struct mdp_superblock_1 *sb;
+	unsigned long long max_size;
+	sb = (struct mdp_superblock_1 *) page_address(rdev->sb_page);
+	if (rdev->sb_offset < rdev->data_offset/2) {
+		/* minor versions 1 and 2; superblock before data */
+		max_size = ((rdev->bdev->bd_inode->i_size >> 9) - rdev->data_offset)/2;
+		if (!size || size > max_size)
+			size = max_size;
+	} else {
+		/* minor version 0; superblock after data */
+		if (rdev->mddev->bitmap_offset < 0) {
+			/* don't overlap data with bitmap */
+			max_size = rdev->sb_offset*2 + rdev->mddev->bitmap_offset;
+			max_size = (max_size - rdev->data_offset)/2;
+		} else
+			max_size = rdev->sb_offset - rdev->data_offset/2;
+		/* TODO: relocate sb to use full device */
+		if (!size || size > max_size/2)
+			size = max_size/2;
+	}
+	sb->data_size = cpu_to_le64(size*2);
+	md_super_write(rdev->mddev, rdev, rdev->sb_offset << 1, rdev->sb_size,
+			rdev->sb_page);
+	return size;
+}
+
 
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
 
@@ -1946,8 +1991,13 @@ rdev_size_store(mdk_rdev_t *rdev, const 
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

--X1bOJ3K7DJ5YkBrT--

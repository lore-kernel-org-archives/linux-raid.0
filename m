From: Chris Webb <chris@arachsys.com>
Subject: Re: Trouble increasing md component size
Date: Mon, 23 Jun 2008 12:18:21 +0100
Message-ID: <20080623111821.GA9948@arachsys.com>
References: <18526.64462.687289.73717@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="vkogqOf2sHV7VnPd"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18526.64462.687289.73717@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Neil. Thanks for your advice on this patch.

Neil Brown <neilb@suse.de> writes:

> Thanks for doing this!!!

No problem at all; it's great to be able to help out with the md driver
which I use and rely upon so heavily!

>  - I would much prefer using "sector" numbers rather than "K" numbers
>    in any new code.  I'd eventually like to alway use sector numbers
>    internally, but that's a lower priority.  So if you could change
>    the rdev_size_change methods to convert to sectors and then use
>    that I'd appreciate it.

I've done this, and commented the conversion so that it'll be easy to remove
if you later decide to change rdev->size to work with sectors instead of kB.

To be honest, one of the things I found most confusing reading the md driver
for the first time was the use of kilobyte blocks for some sizes, and
sectors for others. Migrating to sectors throughout would be great for
readability, especially with most other kernel code using 512-byte sectors.
It looks like quite a big job, though, and changing the sysfs interface is
presumably out unless you rename the files?

>  - I think you really should call md_super_wait after md_super_write.
>    You really don't want the device to appear bigger until the
>    new metadata really is safe of disk.

Ah, thanks for pointing out this one. I wasn't aware that md_super_write
could return before the write had finished. Looking at the description of
md_super_wait, it looks like it might even have to retry, so the superblock
might never get written at all without it? I've added md_super_wait after
both md_super_write calls.

>  - I think you need some protection to make sure that size doesn't get
>    set below my_mddev->size while the array is active.  That would be
>    bad.

Definitely! I've put in the appropriate size guards for both metadata
formats. This morning I've also fixed the mysterious corruption of metadata
1.0  superblocks: turns out I forgot to update the sb->super_offset to match
rdev->sb_offset before writing out the superblock.

As far as I can tell from repeated testing on scratch arrays here, this
patch (attached) now behaves correctly and reliably for all supported
metadata formats.

> What I'd really like is for md to get a call-back when the device size
> changes, so that the metadata can be relocated immediately.  However
> that is a little way off, and I think this is a useful thing to have
> now.

If it's easy to register for such a call-back (?), I think it would be
sufficient for the call-back to run that new rdev_size_change superblock
function as

  super_types[sb->major_version].rdev_size_change(rdev, 0)

to update the rdev->size & superblock, and move the metadata if necessary.
For a shrink you probably want to resize before the block device changes
size rather than afterwards, although that's presumably not going to be
easy/possible to achieve for many block device changes.

Cheers,

Chris.

--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.24.4-md-rdev-size.3.patch"

Allow /sys/block/mdX/md/rdY/size to change on running arrays, moving the
superblock if necessary for this metadata version. We prevent the available
space from shrinking to less than the used size, and allow it to be set to
zero to fill all the available space on the underlying device.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 md.c |   94 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 81 insertions(+), 13 deletions(-)

--- linux-2.6.24.4.orig/drivers/md/md.c	2008-03-24 18:49:18.000000000 +0000
+++ linux-2.6.24.4/drivers/md/md.c	2008-06-23 10:29:34.000000000 +0100
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
@@ -994,6 +995,27 @@ static void super_90_sync(mddev_t *mddev
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
+			rdev->sb_page);
+	md_super_wait(rdev->mddev);
+	return size/2; /* kB for sysfs */
+}
+
+
+/*
  * version 1 superblock
  */
 
@@ -1310,21 +1332,62 @@ static void super_1_sync(mddev_t *mddev,
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
+		max_size = (rdev->bdev->bd_inode->i_size >> 9) - rdev->data_offset;
+		if (!size || size > max_size)
+			size = max_size;
+	} else {
+		/* minor version 0; superblock after data */
+		if (rdev->mddev->bitmap_offset)
+			return 0; /* can't move bitmap */
+		rdev->sb_offset = (rdev->bdev->bd_inode->i_size >> 10) - 8;
+		rdev->sb_offset &= ~(sector_t)(4 - 1);
+		max_size = rdev->sb_offset*2 - rdev->data_offset;
+		/* space reservation for bitmap */
+		if (max_size - 64*2 >= 200*1024*1024*2)
+			max_size -= 128*2;
+		else if (max_size - 4*2 >= 8*1024*1024*2)
+			max_size -= 64*2;
+		else if (max_size >= 64*2)
+			max_size -= 4*2;
+		if (!size || size > max_size)
+			size = max_size;
+	}
+	sb->data_size = cpu_to_le64(size);
+	sb->super_offset = rdev->sb_offset*2;
+	sb->sb_csum = calc_sb_1_csum(sb);
+	md_super_write(rdev->mddev, rdev, rdev->sb_offset << 1, rdev->sb_size,
+			rdev->sb_page);
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
 
@@ -1946,8 +2009,13 @@ rdev_size_store(mdk_rdev_t *rdev, const 
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

--vkogqOf2sHV7VnPd--

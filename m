From: Chris Webb <chris@arachsys.com>
Subject: Re: Trouble increasing md component size
Date: Tue, 24 Jun 2008 12:47:06 +0100
Message-ID: <20080624114706.GD9948@arachsys.com>
References: <18526.64462.687289.73717@notabene.brown> <20080623111821.GA9948@arachsys.com> <18528.10590.221031.75420@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="9Ek0hoCL9XbhcSqy"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18528.10590.221031.75420@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Neil Brown <neilb@suse.de> writes:

> I'm a bit bothered about the code for leaving space for a bitmap for a
> 1.0 array.  I'd rather avoid too much of this sort of 'policy' in the
> kernel.

You're right, it does seem a bit arbitrary. I'll take it out. Originally I
put it in there to avoid a discrepancy between the array you'd get if you
used mdadm to create (which hard-codes this policy), and one reshaped in the
kernel. That said, you get discrepancy anyway for v1.1 and v1.2 metadata,
where the bitmap reserved area is at the start of the array and can't grow.

Maybe the right thing to do is to copy the behaviour for v1.1 and v1.2
arrays, and keep the reserved area constant for v1.0 arrays too, rather than
attempting to scale it all? I've implemented this in the attached patch.
This also means that v1.0 arrays share the nice property of v0.9, v1.1 and
v1.2 arrays that, modulo chunk-size rounding, growing a device by some
amount always leads the same growth in the component_size (and hence it isn't
too awkward to calculate the resulting change in the available array size).

More generally, being a user-space consumer of md arrays which change size
isn't especially convenient at the moment. If, say, you use your md as an
lvm pv, and build it out of lower-level lvm volumes so you can change the
underlying device sizes, growing the top level isn't too painful. You can
use the 'maximum size' shortcut: increase the underlying devices, grow the
array to max size, then grow the top level structure to max size.

However, shrinking an md backed pv is quite a bit harder. You need to
calculate the array size for a given underlying device size in advance of
actually making the change, so you can shrink the top level pv before
resizing the array then the underlying devices. There's no defined route for
doing this calculation, either kernel or userspace. The only reasonable way
forward is to do everything relative to the existing sizes, comparing
against the values in sysfs and relying on the change to device sizes being
the same as the change to component sizes (allowing for chunk-size
rounding), then using a switch dispatching on RAID level and layout (for
raid10).

Even using mdadm create --size=X isn't especially easy because the size
you're specifying is the usable component size, whose connection to the
underlying device size is non-trivial: the metadata offset and size vary
depending on type, mdadm will automatically reserve space for a bitmap
according to a set of heuristics (which can't be overridden). You end up
having to know the details of mdadm's internal operation just to reliable
calculate the correct size to ask for to get the right component size.

I'd like to do something about this... but it's not yet clear to me what the
right thing would be to fit in tidily with the existing interface,
especially for the 'dry run' calculation.

> Also, you add 4 lines greater than 80 columns :-)

Oops. I've fixed these!

Best wishes,

Chris.

--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.24.4-md-rdev-size.4.patch"

From: Chris Webb <chris@arachsys.com>

Allow /sys/block/mdX/md/rdY/size to change on running arrays, moving the
superblock if necessary for this metadata version. We prevent the available
space from shrinking to less than the used size, and allow it to be set to
zero to fill all the available space on the underlying device.

Signed-off-by: Chris Webb <chris@arachsys.com>
---
 drivers/md/md.c |   94 +++++++++++++++++++++++++++++++++++++++-------
  1 file changed, 81 insertions(+), 13 deletions(-)

diff -uNpr linux-2.6.24.4.orig/drivers/md/md.c linux-2.6.24.4/drivers/md/md.c
--- linux-2.6.24.4.orig/drivers/md/md.c	2008-03-24 18:49:18.000000000 +0000
+++ linux-2.6.24.4/drivers/md/md.c	2008-06-24 11:35:47.000000000 +0100
@@ -652,11 +652,14 @@ static unsigned int calc_sb_csum(mdp_sup
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
@@ -994,6 +997,27 @@ static void super_90_sync(mddev_t *mddev
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
 
@@ -1310,21 +1334,59 @@ static void super_1_sync(mddev_t *mddev,
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
 
@@ -1946,8 +2008,14 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 	unsigned long long size = simple_strtoull(buf, &e, 10);
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers)
-		return -EBUSY;
+	if (rdev->mddev->pers) {
+		mdp_super_t *sb;
+		sb = (mdp_super_t *) page_address(rdev->sb_page);
+		size = super_types[sb->major_version].
+			rdev_size_change(rdev, size);
+		if (!size)
+			return -EBUSY;
+	}
 	rdev->size = size;
 	if (size < rdev->mddev->size || rdev->mddev->size == 0)
 		rdev->mddev->size = size;

--9Ek0hoCL9XbhcSqy--

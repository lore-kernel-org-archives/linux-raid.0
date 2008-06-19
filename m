From: Chris Webb <chris@arachsys.com>
Subject: Re: Trouble increasing md component size
Date: Thu, 19 Jun 2008 16:45:20 +0100
Message-ID: <20080619154520.GB3708@arachsys.com>
References: <20080618182622.GA29468@arachsys.com> <4859605D.90509@rabbit.us> <20080618200036.GB30682@arachsys.com> <18521.54665.166875.489547@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="xgyAXRrhYN0wYx8y"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18521.54665.166875.489547@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi. Thanks for the helpful pointers.

Neil Brown <neilb@suse.de> writes:

> I'd put this on my todo list if it wasn't so long already :-)
> (Well, I've put it there anyway, but no promises).

I'll have a stab at implementing this if you like: it's only fair as I'm the
one who wants the feature!

> It would require changing the 'size' as known by md of each device
> first.  i.e. /sys/block/mdX/md/dev-*/size.
> However this currently cannot be changed while the array is active.
> 
> I cannot immediately see a good reason why not.  It may be as simple
> as removing
> 
> 	if (my_mddev->pers)
> 		return -EBUSY;
> 
> from the start of rdev_size_store, but I wouldn't recommend
> experimenting with that on a production system....

Looking through the kernel md.c driver, I can't see anywhere that will
obviously break if rdev->size increases on a running array; it's used very
rarely. Given this, I've tried taking this check out in a scratch virtual
machine, and it works nicely: it's sufficient to echo the new size into the
sysfs file exactly as you indicate, then --grow --size=max works correctly.

I added some checks that the new value of rdev->size won't allow the data to
overlap the superblock, with rdev_size_store truncating the size value if
it is too large for the device, and filling the device if size = 0 is passed
in.

The only glitch is that the available dev size doesn't get updated in the
metadata, so next time the device is assembled, it fails to add the device
with an invalid argument error. Calling --assemble with --update=devicesize
fixes this of course.

I guess that ideally rdev_size_store should write out the changed rdev->size
to the metadata when it's called on a running array, in a similar manner to
size_store for component_size? If the superblock is version 1.x, I'm already
updating the data_size in the superblock ready to write out:

  if (sb->major_version == 1) {
          ((struct mdp_superblock_1 *) sb)->data_size = cpu_to_le64(rdev->size*2);
          /* TODO: write superblock out */
  }

However, I'm not sure what the correct call to get the superblock written
out at this point would be. I tried

  md_super_write(rdev->mddev, rdev, rdev->sb_offset << 1, rdev->sb_size,
                 rdev->sb_page);

after updating sb->data_size as above, but that doesn't seem to do the right
thing.

Cheers,

Chris.

--xgyAXRrhYN0wYx8y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="linux-2.6.24.4-md-rdev-size.patch"

--- linux-2.6.24.4/drivers/md/md.c	2008-03-24 18:49:18.000000000 +0000
+++ linux-2.6.24.4-mdplay/drivers/md/md.c	2008-06-19 16:39:29.000000000 +0100
@@ -1946,8 +1946,21 @@ rdev_size_store(mdk_rdev_t *rdev, const 
 	unsigned long long size = simple_strtoull(buf, &e, 10);
 	if (e==buf || (*e && *e != '\n'))
 		return -EINVAL;
-	if (rdev->mddev->pers)
-		return -EBUSY;
+	if (rdev->mddev->pers) {
+		mdp_super_t *sb;
+		if (rdev->sb_offset > rdev->data_offset/2) {
+			if (!size || size > rdev->sb_offset - rdev->data_offset/2)
+				size = rdev->sb_offset - rdev->data_offset/2;
+		} else if (!size || 2*size + rdev->data_offset > rdev->bdev->bd_inode->i_size >> 9)
+			size = ((rdev->bdev->bd_inode->i_size >> 9) - rdev->data_offset)/2;
+		sb = (mdp_super_t *) page_address(rdev->sb_page);
+		if (sb->major_version == 1) {
+			((struct mdp_superblock_1 *) sb)->data_size = cpu_to_le64(rdev->size*2);
+			md_super_write(rdev->mddev, rdev, rdev->sb_offset << 1, rdev->sb_size,
+					                 rdev->sb_page);
+			/* TODO: write superblock out */
+		}
+	}
 	rdev->size = size;
 	if (size < rdev->mddev->size || rdev->mddev->size == 0)
 		rdev->mddev->size = size;

--xgyAXRrhYN0wYx8y--

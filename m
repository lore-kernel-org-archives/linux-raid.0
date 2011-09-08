From: NeilBrown <neilb@suse.de>
Subject: Re: freshly grown array shrinks after first reboot - major data
 loss
Date: Thu, 8 Sep 2011 11:10:49 +1000
Message-ID: <20110908111049.08988921@notabene.brown>
References: <4E5FA4B5.6010407@macroscoop.nl>
	<4E5FAEF3.60501@macroscoop.nl>
	<4E5FB350.3040905@redhat.com>
	<4E5FC495.7070909@macroscoop.nl>
	<4E5FCC32.6020402@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E5FCC32.6020402@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 01 Sep 2011 14:17:22 -0400 Doug Ledford <dledford@redhat.com> wrote:

> On 09/01/2011 01:44 PM, Pim Zandbergen wrote:
> > On 09/01/2011 06:31 PM, Doug Ledford wrote:
> >> Why is your raid metadata using this old version? mdadm-3.2.2-6.fc15
> >> will not create this version of raid array by default. There is a
> >> reason we have updated to a new superblock.
> >
> > As you may have seen, the array was created in 2006, and has gone through
> > several similar grow procedures.
> 
> Even so, one of the original limitations of the 0.90 superblock was 
> maximum usable device size.  I'm not entirely sure that growing a 0.90 
> superblock past 2TB wasn't the source of your problem and that the bug 
> that needs fixed is that mdadm should have refused to grow a 0.90 
> superblock based array beyond the 2TB limit.  Neil would have to speak 
> to that.

I finally had time to look into this problem.
I'm ashamed to say there is a serious bug here that I should have found and
fixed some time ago, but didn't look problem.  However I don't understand why
you lost any data.

The 0.90 metadata uses an unsigned 32bit number to record the number of
kilobytes used per device.  This should allow devices up to 4TB.  I don't
know where the "2TB" came from.  Maybe I thought something was signed? or
maybe I just didn't think.

However in 2.6.29 a bug was introduced in the handling of the count.
It is best to keep everything in the same units and the preferred units for
devices seems to be 512byte sectors so we changed md to record the available
size on a device in sectors.  So for 0.90 metadata this is:

   rdev->sectors = sb->size * 2;

Do you see the bug?  It will multiple size (a u32) by 2 before casting it to
a sector_t, so we lose the high bit.   This should have been
   rdev->sectors = ((sector_t)sb->size)*2;
and will be after I submit a patch.

However this should not lead to any data corruption.  When you reassemble the
array after reboot it will be 2TB per device smaller than it should be
(which is exactly what we see: 18003551059968-4809411526656 == 2*10^40*(7-1))
so some data will be missing.  But when you increase the size again it will
check the parity of the "new" space but as that is all correct it will not
change anything.
So your data *should* have been back exactly as it was.  I am at a loss to
explain why it is not.

I will add a test to mdadm to discourage you from adding 4+TB devices to 0.90
metadata, or 2+TB devices for 3.0 and earlier kernels.

I might also add a test to discourage growing an array beyond 2TB on kernels
before 3.1.  That is more awkward as mdadm doesn't really know how big you
are growing it to.  You ask for 'max' and it just says 'max' to the kernel.
The kernel needs to do the testing - and currently it doesn't.

Anyway the following patch will be on its way to Linus in a day or two.
Thanks for your report, and my apologies for your loss.

NeilBrown

From 24e9c8d1a620159df73f9b4a545cae668b6285ef Mon Sep 17 00:00:00 2001
From: NeilBrown <neilb@suse.de>
Date: Thu, 8 Sep 2011 10:54:34 +1000
Subject: [PATCH] md: Fix handling for devices from 2TB to 4TB in 0.90 metadata.

0.90 metadata uses an unsigned 32bit number to count the number of
kilobytes used from each device.
This should allow up to 4TB per device.
However we multiply this by 2 (to get sectors) before casting to a
larger type, so sizes above 2TB get truncated.

Also we allow rdev->sectors to be larger than 4TB, so it is possible
for the array to be resized larger than the metadata can handle.
So make sure rdev->sectors never exceeds 4TB when 0.90 metadata is in
used.

Reported-by: Pim Zandbergen <P.Zandbergen@macroscoop.nl>
Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3742ce8..63f71cc 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1138,8 +1138,11 @@ static int super_90_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version
 			ret = 0;
 	}
 	rdev->sectors = rdev->sb_start;
+	/* Limit to 4TB as metadata cannot record more than that */
+	if (rdev->sectors >= (2ULL << 32))
+		rdev->sectors = (2ULL << 32) - 2;
 
-	if (rdev->sectors < sb->size * 2 && sb->level > 1)
+	if (rdev->sectors < ((sector_t)sb->size) * 2 && sb->level > 1)
 		/* "this cannot possibly happen" ... */
 		ret = -EINVAL;
 
@@ -1173,7 +1176,7 @@ static int super_90_validate(mddev_t *mddev, mdk_rdev_t *rdev)
 		mddev->clevel[0] = 0;
 		mddev->layout = sb->layout;
 		mddev->raid_disks = sb->raid_disks;
-		mddev->dev_sectors = sb->size * 2;
+		mddev->dev_sectors = ((sector_t)sb->size) * 2;
 		mddev->events = ev1;
 		mddev->bitmap_info.offset = 0;
 		mddev->bitmap_info.default_offset = MD_SB_BYTES >> 9;
@@ -1415,6 +1418,11 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, sector_t num_sectors)
 	rdev->sb_start = calc_dev_sboffset(rdev);
 	if (!num_sectors || num_sectors > rdev->sb_start)
 		num_sectors = rdev->sb_start;
+	/* Limit to 4TB as metadata cannot record more than that.
+	 * 4TB == 2^32 KB, or 2*2^32 sectors.
+	 */
+	if (num_sectors >= (2ULL << 32))
+		num_sectors = (2ULL << 32) - 2;
 	md_super_write(rdev->mddev, rdev, rdev->sb_start, rdev->sb_size,
 		       rdev->sb_page);
 	md_super_wait(rdev->mddev);

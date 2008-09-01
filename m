From: Neil Brown <neilb@suse.de>
Subject: Re: md (regression): reboot/shutdown hangs
Date: Mon, 1 Sep 2008 12:17:06 +1000
Message-ID: <18619.20642.697691.541752@notabene.brown>
References: <200808282005.09416.alistair@devzero.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1757746AbYIACRc@vger.kernel.org>
In-Reply-To: message from Alistair John Strachan on Thursday August 28
Sender: linux-kernel-owner@vger.kernel.org
To: Alistair John Strachan <alistair@devzero.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
List-Id: linux-raid.ids

On Thursday August 28, alistair@devzero.co.uk wrote:
> Hi Neil,
> 
> Commit 2b25000bf5157c28d8591f03f0575248a8cbd900 ("Restore force switch of md 
> array to readonly at reboot time.") causes a reboot/shutdown to hang 
> indefinitely on my box. Reverting this single commit makes the problem go 
> away. It was first released with 2.6.27-rc3, I believe, and so this is a 
> regression vs 2.6.26 (Rafael CCed).
> 
> I think the problem might be because my rootfs is on a RAID5 and my distro 
> fails to stop it completely before halt/reboot.
> 
> Please let me know if there's any more information you need from me.

Thanks for the report.

I'm having trouble figuring out why this ever worked.  I must be
missing something.

I can only reproduce a hang when calling reboot when a sync is needed.
I dirty a file and then 
   reboot -f -n

This will always have blocked except between the commit that you
mention and an earlier commit which broke something which that commit
was fixing.

This is because the reboot calls do_md_stop while holding the mddev
lock, and do_md_stop calls invalidate_partition.  If this finds any dirty
data to flush, the writeout will (most likely) need to mark the
superblock as dirty first, which cannot happen while the mddev lock is
held.  So we get a deadlock.

The call to invalidate_partition should not be needed in any case except a
reboot, and in that case you really don't want it (if you wanted to
sync, you would have done that first).
So I plan to remove it.  With it gone I cannot reproduce a hang.  If
you can, I would love to hear about it.

Thanks,
NeilBrown

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8cfadc5..4790c83 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3841,8 +3841,6 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 
 		del_timer_sync(&mddev->safemode_timer);
 
-		invalidate_partition(disk, 0);
-
 		switch(mode) {
 		case 1: /* readonly */
 			err  = -ENXIO;

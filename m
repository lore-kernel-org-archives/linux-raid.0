From: Neil Brown <neilb@suse.de>
Subject: Re: bug/race in md causing device to wedge in busy state
Date: Thu, 24 Dec 2009 10:12:56 +1100
Message-ID: <20091224101256.39d2d09a@notabene>
References: <4B2983AE.8020002@netezza.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B2983AE.8020002@netezza.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brett Russ <bruss@netezza.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Dec 2009 20:04:46 -0500
Brett Russ <bruss@netezza.com> wrote:

> I'm seeing cases where an attempted remove of a manually faulted disk 
> from an existing RAID unit can fail with mdadm reporting "Device or 
> resource busy".  I've reduced the problem down to the smallest set that 
> reliably reproduces the issue:

Thanks for the very detailed report.

Can you please see if the following patch fixes the problem.

When an array wants to resync but is waiting for other arrays
on the same devices to finish their resync, it does not abort the
resync attempt properly when an error is reported.
This should fix that.

Thanks,
NeilBrown



diff --git a/drivers/md/md.c b/drivers/md/md.c
index d2aff72..42fa446 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6504,6 +6504,8 @@ void md_do_sync(mddev_t *mddev)
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 			goto skip;
 		}
+		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
+			goto skip;
 		for_each_mddev(mddev2, tmp) {
 			if (mddev2 == mddev)
 				continue;


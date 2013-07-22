From: qindehua <qindehua@163.com>
Subject: Re: Problem with disk replacement
Date: Mon, 22 Jul 2013 18:23:57 +0800 (CST)
Message-ID: <3391fc7f.14685.14005e82e81.Coremail.qindehua@163.com>
References: <45ae92bb.4ffb.13ff2092e1d.Coremail.13691222965@163.com>
 <7945ee0b.7d5e.13ff2acdc3f.Coremail.13691222965@163.com>
 <20130722130415.44b85e93@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130722130415.44b85e93@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,
I have tested with this patch, and it fixes the problem.
I have also tried various combinations of failing and replacing disks,
with echo idle to /sys/block/md1/md/sync_action, they all work fine.

Regards,
Qin Dehua

At 2013-07-22 11:04:15,NeilBrown <neilb@suse.de> wrote:
>Hi Qin,
> thanks for the report.  I can easily reproduce the bug.
>
>I think this will fix it.  Could you please test and confirm that it fixes
>the problem for you too.
>
>Thanks,
>NeilBrown
>
>
>From: NeilBrown <neilb@suse.de>
>Date: Mon, 22 Jul 2013 12:57:21 +1000
>Subject: [PATCH] md/raid5: fix interaction of 'replace' and 'recovery'.
>
>If a device in a RAID4/5/6 is being replaced while another is being
>recovered, then the writes to the replacement device currently don't
>happen, resulting in corruption when the replacement completes and the
>new drive takes over.
>
>This is because the replacement writes are only triggered when
>'s.replacing' is set and not when the similar 's.sync' is set (which
>is the case during resync and recovery - it means all devices need to
>be read).
>
>So schedule those writes when s.replacing is set as well.
>
>In this case we cannot use "STRIPE_INSYNC" to record that the
>replacement has happened as that is needed for recording that any
>parity calculation is complete.  So introduce STRIPE_REPLACED to
>record if the replacement has happened.
>
>This bug was introduced in commit 9a3e1101b827a59ac9036a672f5fa8d5279d0fe2
>(md/raid5:  detect and handle replacements during recovery.)
>which introduced replacement for raid5.
>That was in 3.3-rc3, so any stable kernel since then would benefit
>from this fix.
>
>Cc: stable@vger.kernel.org (3.3+)
>Reported-by: qindehua <13691222965@163.com>
>Signed-off-by: NeilBrown <neilb@suse.de>
>
>diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>index 2bf094a..f0aa7abd 100644
>--- a/drivers/md/raid5.c
>+++ b/drivers/md/raid5.c
>@@ -3607,8 +3607,8 @@ static void handle_stripe(struct stripe_head *sh)
> 			handle_parity_checks5(conf, sh, &s, disks);
> 	}
> 
>-	if (s.replacing && s.locked == 0
>-	    && !test_bit(STRIPE_INSYNC, &sh->state)) {
>+	if ((s.replacing || s.syncing) && s.locked == 0
>+	    && !test_bit(STRIPE_REPLACED, &sh->state)) {
> 		/* Write out to replacement devices where possible */
> 		for (i = 0; i < conf->raid_disks; i++)
> 			if (test_bit(R5_UPTODATE, &sh->dev[i].flags) &&
>@@ -3617,7 +3617,9 @@ static void handle_stripe(struct stripe_head *sh)
> 				set_bit(R5_LOCKED, &sh->dev[i].flags);
> 				s.locked++;
> 			}
>-		set_bit(STRIPE_INSYNC, &sh->state);
>+		if (s.replacing)
>+			set_bit(STRIPE_INSYNC, &sh->state);
>+		set_bit(STRIPE_REPLACED, &sh->state);
> 	}
> 	if ((s.syncing || s.replacing) && s.locked == 0 &&
> 	    test_bit(STRIPE_INSYNC, &sh->state)) {
>diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
>index b0b663b..70c4932 100644
>--- a/drivers/md/raid5.h
>+++ b/drivers/md/raid5.h
>@@ -306,6 +306,7 @@ enum {
> 	STRIPE_SYNC_REQUESTED,
> 	STRIPE_SYNCING,
> 	STRIPE_INSYNC,
>+	STRIPE_REPLACED,
> 	STRIPE_PREREAD_ACTIVE,
> 	STRIPE_DELAYED,
> 	STRIPE_DEGRADED,

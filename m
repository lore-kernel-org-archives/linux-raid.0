From: NeilBrown <neilb@suse.de>
Subject: Re: rhel5 raid6 corruption
Date: Tue, 5 Apr 2011 15:00:22 +1000
Message-ID: <20110405150022.5a31bca1@notabene.brown>
References: <20110404135902.GA20052@grizzly.cita.utoronto.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110404135902.GA20052@grizzly.cita.utoronto.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Humble <robin.humble+raid@anu.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 4 Apr 2011 09:59:02 -0400 Robin Humble <robin.humble+raid@anu.edu.au>
wrote:

> Hi,
> 
> we are finding non-zero mismatch_cnt's and getting data corruption when
> using RHEL5/CentOS5 kernels with md raid6.
> actually, all kernels prior to 2.6.32 seem to have the bug.
> 
> the corruption only happens after we replace a failed disk, and the
> incorrect data is always on the replacement disk. i.e. the problem is
> with rebuild. mismatch_cnt is always a multiple of 8, so I suspect
> pages are going astray.
> 
> hardware and disk drivers are NOT the problem as I've reproduced it on
> 2 different machines with FC disks and SATA disks which have completely
> different drivers.
> 
> rebuilding the raid6 very very slowly (sync_speed_max=5000) mostly
> avoids the problem. the faster the rebuild goes or the more i/o to the
> raid whilst it's rebuilding, the more likely we are to see mismatches
> afterwards.
> 
> git bisecting through drivers/md/raid5.c between 2.6.31 (has mismatches)
> and .32 (no problems) says that one of these (unbisectable) commits
> fixed the issue:
>   a9b39a741a7e3b262b9f51fefb68e17b32756999  md/raid6: asynchronous handle_stripe_dirtying6
>   5599becca4bee7badf605e41fd5bcde76d51f2a4  md/raid6: asynchronous handle_stripe_fill6
>   d82dfee0ad8f240fef1b28e2258891c07da57367  md/raid6: asynchronous handle_parity_check6
>   6c0069c0ae9659e3a91b68eaed06a5c6c37f45c8  md/raid6: asynchronous handle_stripe6
> 
> any ideas?
> were any "write i/o whilst rebuilding from degraded" issues fixed by
> the above patches?

It looks like they were, but I didn't notice at the time.

If a write to a block in a stripe happens at exactly the same time as the
recovery of a different block in that stripe - and both operations are
combined into a single "fix up the stripe parity and write it all out"
operation, then the block that needs to be recovered is computed but not
written out.  oops.

The following patch should fix it.  Please test and report your results.
If they prove the fix I will submit it for the various -stable kernels.
It looks like this bug has "always" been present :-(

Thanks for the report .... and for all that testing!  A git-bisect where each
run can take 36 hours is a really test of commitment!!!

NeilBrown

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index b8a2c5d..f8cd6ef 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2436,10 +2436,16 @@ static void handle_stripe_dirtying6(raid5_conf_t *conf,
 				BUG();
 			case 1:
 				compute_block_1(sh, r6s->failed_num[0], 0);
+				set_bit(R5_LOCKED,
+					&sh->dev[r6s->failed_num[0]].flags);
 				break;
 			case 2:
 				compute_block_2(sh, r6s->failed_num[0],
 						r6s->failed_num[1]);
+				set_bit(R5_LOCKED,
+					&sh->dev[r6s->failed_num[0]].flags);
+				set_bit(R5_LOCKED,
+					&sh->dev[r6s->failed_num[1]].flags);
 				break;
 			default: /* This request should have been failed? */
 				BUG();

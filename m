From: Robin Humble <robin.humble+raid@anu.edu.au>
Subject: Re: rhel5 raid6 corruption
Date: Thu, 7 Apr 2011 03:45:05 -0400
Message-ID: <20110407074505.GA20218@grizzly.cita.utoronto.ca>
References: <20110404135902.GA20052@grizzly.cita.utoronto.ca>
 <20110405150022.5a31bca1@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110405150022.5a31bca1@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 05, 2011 at 03:00:22PM +1000, NeilBrown wrote:
>On Mon, 4 Apr 2011 09:59:02 -0400 Robin Humble <robin.humble+raid@anu.edu.au>
>> we are finding non-zero mismatch_cnt's and getting data corruption when
>> using RHEL5/CentOS5 kernels with md raid6.
>> actually, all kernels prior to 2.6.32 seem to have the bug.
>> 
>> the corruption only happens after we replace a failed disk, and the
>> incorrect data is always on the replacement disk. i.e. the problem is
>> with rebuild. mismatch_cnt is always a multiple of 8, so I suspect
>> pages are going astray.
...
>> git bisecting through drivers/md/raid5.c between 2.6.31 (has mismatches)
>> and .32 (no problems) says that one of these (unbisectable) commits
>> fixed the issue:
>>   a9b39a741a7e3b262b9f51fefb68e17b32756999  md/raid6: asynchronous handle_stripe_dirtying6
>>   5599becca4bee7badf605e41fd5bcde76d51f2a4  md/raid6: asynchronous handle_stripe_fill6
>>   d82dfee0ad8f240fef1b28e2258891c07da57367  md/raid6: asynchronous handle_parity_check6
>>   6c0069c0ae9659e3a91b68eaed06a5c6c37f45c8  md/raid6: asynchronous handle_stripe6
>> 
>> any ideas?
>> were any "write i/o whilst rebuilding from degraded" issues fixed by
>> the above patches?
>
>It looks like they were, but I didn't notice at the time.
>
>If a write to a block in a stripe happens at exactly the same time as the
>recovery of a different block in that stripe - and both operations are
>combined into a single "fix up the stripe parity and write it all out"
>operation, then the block that needs to be recovered is computed but not
>written out.  oops.
>
>The following patch should fix it.  Please test and report your results.
>If they prove the fix I will submit it for the various -stable kernels.
>It looks like this bug has "always" been present :-(

thanks for the very quick reply!

however, I don't think the patch has solved the problem :-/
I applied it to 2.6.31.14 and have got several mismatches since on both
FC and SATA machines.

BTW, these tests are actually fairly quick. often <10 kickout/rebuild
loops. so just a few hours.

in the above when you say "block in a stripe", does that mean the whole
128k on that disk (we have --chunk=128) might not have been written, or
one 512byte block (or a page)?
we don't see mismatch counts of 256 - usually 8 or 16, but I can see
why our current testing might hide such a count. <later> ok - now I
blank (dd zeros over) the replacement disk before putting it back into
the raid and am seeing perhaps slightly larger typical mismatch counts
of 16 and 32, but so far not 128k of mismatches.

another (potential) data point is that often position of the mismatches
on the md device doesn't really line up with where I think the data is
being written to. the mismatch is often near the start of the md device,
but sometimes 50% of the way in, and sometimes 95%.
the filesystem is <20% full, although the wildcard is that I really
have no idea how the (sparse) files doing the 4k direct i/o are
allocated across the filsystem, or where fs metadata and journals might
be updating blocks either.
seems odd though...

>Thanks for the report .... and for all that testing!  A git-bisect where each
>run can take 36 hours is a really test of commitment!!!

:-) no worries. thanks for md and for the help!
we've been trying to figure this out for months so a bit of testing
isn't a problem. we first eliminated a bunch of other things
(filesystem, drivers, firmware, ...) as possibilities. for a long time
we didn't really believe the problem could be with md as it's so well
tested around the world and has been very solid for us except for these
rebuilds.

cheers,
robin
--
Dr Robin Humble, HPC Systems Analyst, NCI National Facility


>NeilBrown
>
>diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>index b8a2c5d..f8cd6ef 100644
>--- a/drivers/md/raid5.c
>+++ b/drivers/md/raid5.c
>@@ -2436,10 +2436,16 @@ static void handle_stripe_dirtying6(raid5_conf_t *conf,
> 				BUG();
> 			case 1:
> 				compute_block_1(sh, r6s->failed_num[0], 0);
>+				set_bit(R5_LOCKED,
>+					&sh->dev[r6s->failed_num[0]].flags);
> 				break;
> 			case 2:
> 				compute_block_2(sh, r6s->failed_num[0],
> 						r6s->failed_num[1]);
>+				set_bit(R5_LOCKED,
>+					&sh->dev[r6s->failed_num[0]].flags);
>+				set_bit(R5_LOCKED,
>+					&sh->dev[r6s->failed_num[1]].flags);
> 				break;
> 			default: /* This request should have been failed? */
> 				BUG();

From: Robin Humble <robin.humble+raid@anu.edu.au>
Subject: Re: rhel5 raid6 corruption
Date: Sat, 9 Apr 2011 00:24:42 -0400
Message-ID: <20110409042437.GA29461@grizzly.cita.utoronto.ca>
References: <20110404135902.GA20052@grizzly.cita.utoronto.ca>
 <20110405150022.5a31bca1@notabene.brown>
 <20110407074505.GA20218@grizzly.cita.utoronto.ca>
 <20110408203345.5bb5d179@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110408203345.5bb5d179@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 08, 2011 at 08:33:45PM +1000, NeilBrown wrote:
>On Thu, 7 Apr 2011 03:45:05 -0400 Robin Humble <robin.humble+raid@anu.edu.au> wrote:
>> On Tue, Apr 05, 2011 at 03:00:22PM +1000, NeilBrown wrote:
>> >On Mon, 4 Apr 2011 09:59:02 -0400 Robin Humble <robin.humble+raid@anu.edu.au>
>> >> we are finding non-zero mismatch_cnt's and getting data corruption when
>> >> using RHEL5/CentOS5 kernels with md raid6.
>> >> actually, all kernels prior to 2.6.32 seem to have the bug.
>> >> 
>> >> the corruption only happens after we replace a failed disk, and the
>> >> incorrect data is always on the replacement disk. i.e. the problem is
>> >> with rebuild. mismatch_cnt is always a multiple of 8, so I suspect
>> >> pages are going astray.
>> ...
>> >> git bisecting through drivers/md/raid5.c between 2.6.31 (has mismatches)
>> >> and .32 (no problems) says that one of these (unbisectable) commits
>> >> fixed the issue:
>> >>   a9b39a741a7e3b262b9f51fefb68e17b32756999  md/raid6: asynchronous handle_stripe_dirtying6
>> >>   5599becca4bee7badf605e41fd5bcde76d51f2a4  md/raid6: asynchronous handle_stripe_fill6
>> >>   d82dfee0ad8f240fef1b28e2258891c07da57367  md/raid6: asynchronous handle_parity_check6
>> >>   6c0069c0ae9659e3a91b68eaed06a5c6c37f45c8  md/raid6: asynchronous handle_stripe6
>> >> 
>> >> any ideas?
>> >> were any "write i/o whilst rebuilding from degraded" issues fixed by
>> >> the above patches?
>> >
>> >It looks like they were, but I didn't notice at the time.
>> >
>> >If a write to a block in a stripe happens at exactly the same time as the
>> >recovery of a different block in that stripe - and both operations are
>> >combined into a single "fix up the stripe parity and write it all out"
>> >operation, then the block that needs to be recovered is computed but not
>> >written out.  oops.
>> >
>> >The following patch should fix it.  Please test and report your results.
>> >If they prove the fix I will submit it for the various -stable kernels.
>> >It looks like this bug has "always" been present :-(
>> 
>> thanks for the very quick reply!
>> 
>> however, I don't think the patch has solved the problem :-/
>> I applied it to 2.6.31.14 and have got several mismatches since on both
>> FC and SATA machines.
>
>That's disappointing - I was sure I had found it.  I'm tempted to ask "are
>you really sure you are running the modified kernel", but I'm sure you are.

yes - really running it :-)

so I added some pr_debug's in and around the patched switch statement
in handle_stripe_dirtying6. it seems cases 1 or 2 in the below aren't
executed in either of normal rebuild, or when I get mismatches. so that
explains why fixes there didn't change anything.

so I guess something in 
        if (s->locked == 0 && rcw == 0 &&
            !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
                if (must_compute > 0) {

is always failing?

 # cat /sys/kernel/debug/dynamic_debug/control | grep handle_stripe_dirtying6
drivers/md/raid5.c:2466 [raid456]handle_stripe_dirtying6 - "Writing stripe %llu block %d\012"
drivers/md/raid5.c:2460 [raid456]handle_stripe_dirtying6 - "Computing parity for stripe %llu\012"
drivers/md/raid5.c:2448 [raid456]handle_stripe_dirtying6 p "rjh - case2\012"
drivers/md/raid5.c:2441 [raid456]handle_stripe_dirtying6 p "rjh - case1, r6s->failed_num[0] = %d, flags %lu\012"
drivers/md/raid5.c:2433 [raid456]handle_stripe_dirtying6 - "rjh - must_compute %d, s->failed %d\012"
drivers/md/raid5.c:2430 [raid456]handle_stripe_dirtying6 - "rjh - s->locked %d rcw %d test_bit(STRIPE_BIT_DELAY, &sh->state) %d\012"
drivers/md/raid5.c:2421 [raid456]handle_stripe_dirtying6 - "Request delayed stripe %llu block %d for Reconstruct\012"
drivers/md/raid5.c:2414 [raid456]handle_stripe_dirtying6 - "Read_old stripe %llu block %d for Reconstruct\012"
drivers/md/raid5.c:2398 [raid456]handle_stripe_dirtying6 - "for sector %llu, rcw=%d, must_compute=%d\012"
drivers/md/raid5.c:2392 [raid456]handle_stripe_dirtying6 - "raid6: must_compute: disk %d flags=%#lx\012"

the output is verbose if I turn on some of these. but this is short
snippet that I guess looks ok to you?

raid456:for sector 6114040, rcw=0, must_compute=0
raid456:for sector 6113904, rcw=0, must_compute=0
raid456:for sector 11766712, rcw=0, must_compute=0
raid456:for sector 6113912, rcw=0, must_compute=1
raid456:for sector 6113912, rcw=0, must_compute=0
raid456:for sector 11766712, rcw=0, must_compute=0
raid456:for sector 11767200, rcw=0, must_compute=1
raid456:for sector 11761952, rcw=0, must_compute=0
raid456:for sector 11765560, rcw=0, must_compute=1
raid456:for sector 11763064, rcw=0, must_compute=1

please let me know if you'd like me to try/print something else.

cheers,
robin

>> >diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> >index b8a2c5d..f8cd6ef 100644
>> >--- a/drivers/md/raid5.c
>> >+++ b/drivers/md/raid5.c
>> >@@ -2436,10 +2436,16 @@ static void handle_stripe_dirtying6(raid5_conf_t *conf,
>> >                               BUG();
>> >                       case 1:
>> >                               compute_block_1(sh, r6s->failed_num[0], 0);
>> >+                              set_bit(R5_LOCKED,
>> >+                                      &sh->dev[r6s->failed_num[0]].flags);
>> >                               break;
>> >                       case 2:
>> >                               compute_block_2(sh, r6s->failed_num[0],
>> >                                               r6s->failed_num[1]);
>> >+                              set_bit(R5_LOCKED,
>> >+                                      &sh->dev[r6s->failed_num[0]].flags);
>> >+                              set_bit(R5_LOCKED,
>> >+                                      &sh->dev[r6s->failed_num[1]].flags);
>> >                               break;
>> >                       default: /* This request should have been failed? */
>> >                               BUG();

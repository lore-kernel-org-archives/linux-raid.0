From: Robin Humble <robin.humble+raid@anu.edu.au>
Subject: Re: rhel5 raid6 corruption
Date: Sat, 23 Apr 2011 20:45:45 -0400
Message-ID: <20110424004545.GA21488@grizzly.cita.utoronto.ca>
References: <20110404135902.GA20052@grizzly.cita.utoronto.ca>
 <20110405150022.5a31bca1@notabene.brown>
 <20110407074505.GA20218@grizzly.cita.utoronto.ca>
 <20110408203345.5bb5d179@notabene.brown>
 <20110409042437.GA29461@grizzly.cita.utoronto.ca>
 <20110418100057.3c0096d9@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110418100057.3c0096d9@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 18, 2011 at 10:00:57AM +1000, NeilBrown wrote:
>On Sat, 9 Apr 2011 00:24:42 -0400 Robin Humble <robin.humble+raid@anu.edu.au> wrote:
>> On Fri, Apr 08, 2011 at 08:33:45PM +1000, NeilBrown wrote:
>> >On Thu, 7 Apr 2011 03:45:05 -0400 Robin Humble <robin.humble+raid@anu.edu.au> wrote:
>> >> On Tue, Apr 05, 2011 at 03:00:22PM +1000, NeilBrown wrote:
>> >> >On Mon, 4 Apr 2011 09:59:02 -0400 Robin Humble <robin.humble+raid@anu.edu.au>
>> >> >> we are finding non-zero mismatch_cnt's and getting data corruption when
>> >> >> using RHEL5/CentOS5 kernels with md raid6.
>> >> >> actually, all kernels prior to 2.6.32 seem to have the bug.
>> >> >> 
>> >> >> the corruption only happens after we replace a failed disk, and the
>> >> >> incorrect data is always on the replacement disk. i.e. the problem is
...
>> so I guess something in 
>>         if (s->locked == 0 && rcw == 0 &&
>>             !test_bit(STRIPE_BIT_DELAY, &sh->state)) {
>>                 if (must_compute > 0) {
>> 
>> is always failing?
>
>Yes... I think that whenever must_compute is non-zero, s->locks is too.
>handle_stripe_fill6 has already done the compute_block calls, so there is
>never a chance for handle_stripe_dirtying6 to do them.
>
>I think this is that patch you want.
>
>diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>index f8cd6ef..83f83cd 100644
>--- a/drivers/md/raid5.c
>+++ b/drivers/md/raid5.c
>@@ -2466,8 +2466,6 @@ static void handle_stripe_dirtying6(raid5_conf_t *conf,
> 		if (s->locked == disks)
> 			if (!test_and_set_bit(STRIPE_FULL_WRITE, &sh->state))
> 				atomic_inc(&conf->pending_full_writes);
>-		/* after a RECONSTRUCT_WRITE, the stripe MUST be in-sync */
>-		set_bit(STRIPE_INSYNC, &sh->state);
> 
> 		if (test_and_clear_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {
> 			atomic_dec(&conf->preread_active_stripes);
>
>
>The comment isn't correct.  While the stripe in-memory must be in-sync, the
>stripe on disk might not be because if we computed a block rather than
>reading it from an in-sync disk, the in-memory stripe can be different from
>the on-disk stripe.

yes, I think that works. thanks! :)

sorry for the long delay - I was on the other side of the globe for a
while there, and also I wanted to test as much as possible...

I added the above patch to the 2.6.31 that had your prev patch in it.
then ran tests for 3 days on 2 machines (a total of >1000 rebuild
cycles) and it didn't find any mismatches. so looks like that's fixed
it. whoo!

I also backported your 2 fixes to RHEL 5.5's 2.6.18 kernel and added
the rest of our network and filesystem stack back into the mix, and so
far (albeit with less than a day of testing so far) it seems to work
there too.

>If this bug were still in mainline I would probably want a bigger patch which
>would leave this code but also set R5_LOCKED on all blocks that have been
>computed.  But as it is a stablisation patch, the above is simple and more
>clearly correct.

ok.

BTW, the case1 and case2 pr_debug's I added into the case statements of
your first patch (see the pr_debug list below) still don't seem to be
being hit, although I admit I didn't look for hits there very
comprehensively - they can scroll out of dmesg relatively quickly.

so I kinda suspect the mismatch problem is fixed by the above patch alone?

>Thanks for you patience - I look forward to your success/failure report.

AFAICT it's all good. thank you very much!
it's been a long road to this for us... we are very happy :)

cheers,
robin

>> 
>>  # cat /sys/kernel/debug/dynamic_debug/control | grep handle_stripe_dirtying6
>> drivers/md/raid5.c:2466 [raid456]handle_stripe_dirtying6 - "Writing stripe %llu block %d\012"
>> drivers/md/raid5.c:2460 [raid456]handle_stripe_dirtying6 - "Computing parity for stripe %llu\012"
>> drivers/md/raid5.c:2448 [raid456]handle_stripe_dirtying6 p "rjh - case2\012"
>> drivers/md/raid5.c:2441 [raid456]handle_stripe_dirtying6 p "rjh - case1, r6s->failed_num[0] = %d, flags %lu\012"
>> drivers/md/raid5.c:2433 [raid456]handle_stripe_dirtying6 - "rjh - must_compute %d, s->failed %d\012"
>> drivers/md/raid5.c:2430 [raid456]handle_stripe_dirtying6 - "rjh - s->locked %d rcw %d test_bit(STRIPE_BIT_DELAY, &sh->state) %d\012"
>> drivers/md/raid5.c:2421 [raid456]handle_stripe_dirtying6 - "Request delayed stripe %llu block %d for Reconstruct\012"
>> drivers/md/raid5.c:2414 [raid456]handle_stripe_dirtying6 - "Read_old stripe %llu block %d for Reconstruct\012"
>> drivers/md/raid5.c:2398 [raid456]handle_stripe_dirtying6 - "for sector %llu, rcw=%d, must_compute=%d\012"
>> drivers/md/raid5.c:2392 [raid456]handle_stripe_dirtying6 - "raid6: must_compute: disk %d flags=%#lx\012"
>> 
>> the output is verbose if I turn on some of these. but this is short
>> snippet that I guess looks ok to you?
>> 
>> raid456:for sector 6114040, rcw=0, must_compute=0
>> raid456:for sector 6113904, rcw=0, must_compute=0
>> raid456:for sector 11766712, rcw=0, must_compute=0
>> raid456:for sector 6113912, rcw=0, must_compute=1
>> raid456:for sector 6113912, rcw=0, must_compute=0
>> raid456:for sector 11766712, rcw=0, must_compute=0
>> raid456:for sector 11767200, rcw=0, must_compute=1
>> raid456:for sector 11761952, rcw=0, must_compute=0
>> raid456:for sector 11765560, rcw=0, must_compute=1
>> raid456:for sector 11763064, rcw=0, must_compute=1
>> 
>> please let me know if you'd like me to try/print something else.
>> 
>> cheers,
>> robin
>> 
>> >> >diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> >> >index b8a2c5d..f8cd6ef 100644
>> >> >--- a/drivers/md/raid5.c
>> >> >+++ b/drivers/md/raid5.c
>> >> >@@ -2436,10 +2436,16 @@ static void handle_stripe_dirtying6(raid5_conf_t *conf,
>> >> >                               BUG();
>> >> >                       case 1:
>> >> >                               compute_block_1(sh, r6s->failed_num[0], 0);
>> >> >+                              set_bit(R5_LOCKED,
>> >> >+                                      &sh->dev[r6s->failed_num[0]].flags);
>> >> >                               break;
>> >> >                       case 2:
>> >> >                               compute_block_2(sh, r6s->failed_num[0],
>> >> >                                               r6s->failed_num[1]);
>> >> >+                              set_bit(R5_LOCKED,
>> >> >+                                      &sh->dev[r6s->failed_num[0]].flags);
>> >> >+                              set_bit(R5_LOCKED,
>> >> >+                                      &sh->dev[r6s->failed_num[1]].flags);
>> >> >                               break;
>> >> >                       default: /* This request should have been failed? */
>> >> >                               BUG();
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

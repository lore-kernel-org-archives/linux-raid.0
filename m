From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: raid5: R5_WriteError is not cleared after rdev is marked as Faulty
Date: Mon, 6 Jan 2014 17:12:10 +0200
Message-ID: <CAGRgLy5wy54cCiXkuwTTqUugaKCukUgUNq7vzf75TV0=f2+2bA@mail.gmail.com>
References: <CAGRgLy6w=_nspVHu9YF9JHz3ADc5CkGL5N0bv6TGgopUpeaxGw@mail.gmail.com>
	<20140106131505.0ee4c490@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140106131505.0ee4c490@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks, Neil!
The test that was failing, passes now.

Thanks for the patch,
Alex.


On Mon, Jan 6, 2014 at 4:15 AM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 2 Jan 2014 17:58:33 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hi Neil,
>> I see the following issue: if more than one stripe-head experiences an
>> error in raid5_end_write_request, then when first stripe-head is
>> handled, it eventually fails the disk, but when the second stripe-head
>> is handled, disk is already marked as Faulty, so R5_WriteError is not
>> cleared from this second stripe-head, but it still remains in the
>> stripe cache.
>>
>> Below are more details on the flow. I added some prints to display the
>> flags values etc.
>>
>> # raid6 is rebuilding a disk
>>
>> # disk fails, as a result, raid5_end_write_request is called on two
>> stripe-heads:
>> [23369]md48066*[raid5_end_write_request:2002] sh[4560].flags=0x101A
>> dev[0].flags=0x20003 rdev[dm-6].flags=0x40
>> bio=ffff880028744fd8[4592(4560):8] WRITE ERROR
>> [13527.467363] [3842]md48066*[raid5_end_write_request:2002]
>> sh[4568].flags=0x101B dev[0].flags=0x20003 rdev[dm-6].flags=0x240
>> bio=ffff880028742bc0[4600(4568):8] WRITE ERROR
>>
>> As a result, appropriate r5dev's are marked with R5_WriteError on
>> these two stripe-heads.
>>
>> # raid5 calls analyse_stripe on behalf of stripe-head 4560 ((through
>> handle_active_stripes->handle_stripe->analyse_stripe)
>>
>> # analyse_stripe performs this code:
>>         if (rdev && test_bit(R5_WriteError, &dev->flags)) {
>>             /* This flag does not apply to '.replacement'
>>              * only to .rdev, so make sure to check that*/
>>             struct md_rdev *rdev2 = rcu_dereference(
>>                 conf->disks[i].rdev);
>>             if (rdev2 == rdev)
>>                 clear_bit(R5_Insync, &dev->flags);
>>             if (rdev2 && !test_bit(Faulty, &rdev2->flags)) {
>>                 s->handle_bad_blocks = 1;
>> it clears the R5_WriteError and sets handle_bad_blocks on the stripe-head
>>
>> # handle_stripe performs:
>>     if (s.handle_bad_blocks)
>>         for (i = disks; i--; ) {
>>             struct md_rdev *rdev;
>>             struct r5dev *dev = &sh->dev[i];
>>             if (test_and_clear_bit(R5_WriteError, &dev->flags)) {
>>                 /* We own a safe reference to the rdev */
>>                 rdev = conf->disks[i].rdev;
>>                 if (!rdev_set_badblocks(rdev, sh->sector,
>>                             STRIPE_SECTORS, 0))
>>                     md_error(conf->mddev, rdev);
>> this marks the rdev as Faulty and fails it (bad blocks are disabled)
>>
>> # raid5d calls analyse_stripe on stripe-head 4568. However, rdev is
>> already marked as Faulty, so it does:
>>         if (rdev && test_bit(Faulty, &rdev->flags))
>>             rdev = NULL;
>> and later this condition does not hold:
>> if (rdev && test_bit(R5_WriteError, &dev->flags)) {
>> so R5_WriteError is not cleared, but this stripe-head is still valid
>> in the stripe cache.
>>
>> Dumping the state of this stripe-head in the stripe-cache (through
>> custom sysfs entry):
>> sh[4568].state=0x1010 disks=5 pdidx=2 qdidx=3
>>   dev[0].flags=0x20001 rdev[???].flags=0x0 (sector=13688)
>>   dev[1].flags=0x11 rdev[dm-7].flags=0x2 (sector=13720)
>>   dev[2].flags=0x11 rdev[dm-8].flags=0x2 (sector=0) *P*
>>   dev[3].flags=0x11 rdev[dm-9].flags=0x2 (sector=0) *Q*
>>   dev[4].flags=0x11 rdev[dm-10].flags=0x2 (sector=13656)
>>
>> # Now user recovers the disk and re-adds the disk back into the array.
>> Rebuild starts, and eventually md_do_sync calls sync_request on this
>> stripe-head, which calls handle_stripe->analyse_stripe. Now
>> analyse_stripe sees the stale R5_WriteError flag and fails the disk,
>> which aborts the rebuild. Here is the stack trace, which detects the
>> stale R5_WriteError and fails the disk:
>> [<ffffffffa02d4543>] error+0x153/0x1d0 [raid456]
>> [<ffffffffa0445449>] md_error.part.39+0x19/0xa0 [md_mod]
>> [<ffffffffa0445503>] md_error+0x33/0x60 [md_mod]
>> [<ffffffffa02da07c>] handle_stripe+0x57c/0x2250 [raid456]
>> [<ffffffffa02dcacb>] sync_request+0x18b/0x390 [raid456]
>> [<ffffffffa044320c>] md_do_sync+0x76c/0xda0 [md_mod]
>> [<ffffffffa044084d>] md_thread+0x10d/0x140 [md_mod]
>>
>> Does this analysis make sense? I don't know how to fix issue though. I
>> am looking at kernel (3.8.13 - as usual), but looking at your
>> for-linus branch, it seems like the same would happen.
>>
>
> Looks like:
>
> commit 5d8c71f9e5fbdd95650be00294d238e27a363b5c
> Author: Adam Kwolek <adam.kwolek@intel.com>
> Date:   Fri Dec 9 14:26:11 2011 +1100
>
>     md: raid5 crash during degradation
>
>
> introduced this problem (in linux 3.3) with an over-simple fix for a problem.
>
> I think that we can not just reverted that patch as
>
> commit 14a75d3e07c784c004b4b44b34af996b8e4ac453
> Author: NeilBrown <neilb@suse.de>
> Date:   Fri Dec 23 10:17:52 2011 +1100
>
>     md/raid5: preferentially read from replacement device if possible.
>
>
> has effected a better fix.
> So the patch below should work.  Does that make sense to you?
>
> Thanks,
> NeilBrown
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index cc055da02e2a..9168173deaf3 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -3608,7 +3608,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
>                          */
>                         set_bit(R5_Insync, &dev->flags);
>
> -               if (rdev && test_bit(R5_WriteError, &dev->flags)) {
> +               if (test_bit(R5_WriteError, &dev->flags)) {
>                         /* This flag does not apply to '.replacement'
>                          * only to .rdev, so make sure to check that*/
>                         struct md_rdev *rdev2 = rcu_dereference(
> @@ -3621,7 +3621,7 @@ static void analyse_stripe(struct stripe_head *sh, struct stripe_head_state *s)
>                         } else
>                                 clear_bit(R5_WriteError, &dev->flags);
>                 }
> -               if (rdev && test_bit(R5_MadeGood, &dev->flags)) {
> +               if (test_bit(R5_MadeGood, &dev->flags)) {
>                         /* This flag does not apply to '.replacement'
>                          * only to .rdev, so make sure to check that*/
>                         struct md_rdev *rdev2 = rcu_dereference(

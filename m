From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: raid1 resync stuck
Date: Fri, 11 Sep 2015 13:44:37 -0400
Message-ID: <wrfjsi6k4zqy.fsf@redhat.com>
References: <wrfjmvwvz9ke.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjmvwvz9ke.fsf@redhat.com> (Jes Sorensen's message of "Wed, 09
	Sep 2015 15:17:37 -0400")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: majianpeng@gmail.com, linux-raid <linux-raid@vger.kernel.org>, nate.dailey@stratus.com
List-Id: linux-raid.ids

Jes Sorensen <Jes.Sorensen@redhat.com> writes:
> Neil,
>
> We're chasing a case where the raid1 code gets stuck during resync. Nate
> is able to reproduce it much more reliably than me - so attaching his
> reproducing script. Basically run it on an existing raid1 with internal
> bitmap on rotating disk.
>
> Nate was able to bisect it to 79ef3a8aa1cb1523cc231c9a90a278333c21f761,
> the original iobarrier rewrite patch, and it can be reproduced in
> current Linus' top of trunk a794b4f3292160bb3fd0f1f90ec8df454e3b17b3.
>
> In Nate's analysis it hangs in raise_barrier():
>
> static void raise_barrier(struct r1conf *conf, sector_t sector_nr)
> {
> 	spin_lock_irq(&conf->resync_lock);
>
> 	/* Wait until no block IO is waiting */
> 	wait_event_lock_irq(conf->wait_barrier, !conf->nr_waiting,
> 			    conf->resync_lock);
>
> 	/* block any new IO from starting */
> 	conf->barrier++;
> 	conf->next_resync = sector_nr;
>
> 	/* For these conditions we must wait:
> 	 * A: while the array is in frozen state
> 	 * B: while barrier >= RESYNC_DEPTH, meaning resync reach
> 	 *    the max count which allowed.
> 	 * C: next_resync + RESYNC_SECTORS > start_next_window, meaning
> 	 *    next resync will reach to the window which normal bios are
> 	 *    handling.
> 	 * D: while there are any active requests in the current window.
> 	 */
> 	wait_event_lock_irq(conf->wait_barrier,
> 			    !conf->array_frozen &&
> 			    conf->barrier < RESYNC_DEPTH &&
> 			    conf->current_window_requests == 0 &&
> 			    (conf->start_next_window >=
> 			     conf->next_resync + RESYNC_SECTORS),
> 			    conf->resync_lock);
>
> crash> r1conf 0xffff882028f3e600 | grep -e array_frozen -e barrier -e start_next_window -e next_resync
>   barrier = 0x1,                      (conf->barrier < RESYNC_DEPTH)
>   array_frozen = 0x0,                 (!conf->array_frozen)
>   next_resync = 0x3000,
>   start_next_window = 0x3000,
>
> ie. next_resync == start_next_window, which will never wake up since
> start_next_window is smaller than next_resync + RESYNC_SECTORS.
>
> Have you seen anything like this?

Looking further at this together with Nate. It looks like you had a
patch resolving something similar:

commit 669cc7ba77864e7b1ac39c9f2b2afb8730f341f4
Author: NeilBrown <neilb@suse.de>
Date:   Thu Sep 4 16:30:38 2014 +1000

    md/raid1: clean up request counts properly in close_sync()
    
    If there are outstanding writes when close_sync is called,
    the change to ->start_next_window might cause them to
    decrement the wrong counter when they complete.  Fix this
    by merging the two counters into the one that will be decremented.
    
    Having an incorrect value in a counter can cause raise_barrier()
    to hangs, so this is suitable for -stable.
    
    Fixes: 79ef3a8aa1cb1523cc231c9a90a278333c21f761
    cc: stable@vger.kernel.org (v3.13+)
    Signed-off-by: NeilBrown <neilb@suse.de>

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index ad0468c..a31c92b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1545,8 +1545,13 @@ static void close_sync(struct r1conf *conf)
        mempool_destroy(conf->r1buf_pool);
        conf->r1buf_pool = NULL;
 
+       spin_lock_irq(&conf->resync_lock);
        conf->next_resync = 0;
        conf->start_next_window = MaxSector;
+       conf->current_window_requests +=
+               conf->next_window_requests;
+       conf->next_window_requests = 0;
+       spin_unlock_irq(&conf->resync_lock);
 }
 
It looks to us like close_sync()'s conf->start_next_window = MaxSector
results in wait_barrier() triggering this when the outstanding IO
completes:

	if (bio && bio_data_dir(bio) == WRITE) {
		if (bio->bi_sector >=
		    conf->mddev->curr_resync_completed) {
			if (conf->start_next_window == MaxSector)
				conf->start_next_window =
					conf->next_resync +
					NEXT_NORMALIO_DISTANCE;

putting us into the situation where raise_barrier()'s condition never
completes:

	wait_event_lock_irq(conf->wait_barrier,
			    !conf->array_frozen &&
			    conf->barrier < RESYNC_DEPTH &&
			    conf->current_window_requests == 0 &&
			    (conf->start_next_window >=
			     conf->next_resync + RESYNC_SECTORS),
			    conf->resync_lock);

So the question is, is it wrong for close_sync() to be setting
conf->start_next_window = MaxSector in the first place, or should it
only be doing this once all outstanding I/O has completed?

Nate tested a case where removing the MaxSector assignment from
close_sync() but are there any side effects to doing that?

Cheers,
Jes

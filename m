From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 6 of 6] Fix handling of overlapping requests in raid5
Date: Tue, 8 Feb 2005 13:39:12 +1100
Message-ID: <16904.9808.259452.556708@cse.unsw.edu.au>
References: <20050207133555.17870.patches@notabene>
	<E1Cxyst-0004fu-PP@notabene.cse.unsw.edu.au>
	<20050207182456.1d50c83b.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Andrew Morton on Monday February 7
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday February 7, akpm@osdl.org wrote:
> NeilBrown <neilb@cse.unsw.edu.au> wrote:
> >
> > +	retry:
> >   		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
> >   		if (sh) {
> >  -
> >  -			while (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
> >  -				/* add failed due to overlap.  Flush everything
> >  +			if (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
> >  +				/* Add failed due to overlap.  Flush everything
> >   				 * and wait a while
> >  -				 * FIXME - overlapping requests should be handled better
> >   				 */
> >   				raid5_unplug_device(mddev->queue);
> >  -				set_current_state(TASK_UNINTERRUPTIBLE);
> >  -				schedule_timeout(1);
> >  +				release_stripe(sh);
> >  +				schedule();
> >  +				goto retry;
> 
> Worrisome.  If the calling process has SCHED_RR or SCHED_FIFO policy, this
> could cause a lockup, perhaps.

Is that just that I should have the "prepare_to_wait" after the retry:
label rather than before, or is there something more subtle.

> 
> Some sort of real synchronisation scheme would be nicer.  Or at the least,
> what was wrong with the schedule_timeout(1)?

schedule_timeout shouldn't be necessary as whenever the conflicting
bio gets dealt with, a wakeup will happen on the conf->wait_for_overlap wait_queue.

(schedule_timeout(1) by itself slowed things down too much. The
proactive waking was needed, and with it in place, the timeout becomes
irrelevant).

NeilBrown


--
md: prepare_to_wait needs to be in the loop which waits for overlapping requests to complete

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid5.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
--- ./drivers/md/raid5.c~current~	2005-02-07 13:34:23.000000000 +1100
+++ ./drivers/md/raid5.c	2005-02-08 13:34:38.000000000 +1100
@@ -1433,9 +1433,9 @@ static int make_request (request_queue_t
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
 
+	retry:
 		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 
-	retry:
 		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
 		if (sh) {
 			if (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {


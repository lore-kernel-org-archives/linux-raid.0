From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 6 of 6] Fix handling of overlapping requests in raid5
Date: Mon, 7 Feb 2005 19:07:01 -0800
Message-ID: <20050207190701.6782f33d.akpm@osdl.org>
References: <20050207133555.17870.patches@notabene>
	<E1Cxyst-0004fu-PP@notabene.cse.unsw.edu.au>
	<20050207182456.1d50c83b.akpm@osdl.org>
	<16904.9808.259452.556708@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <16904.9808.259452.556708@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
>
> On Monday February 7, akpm@osdl.org wrote:
> > NeilBrown <neilb@cse.unsw.edu.au> wrote:
> > >
> > > +	retry:
> > >   		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
> > >   		if (sh) {
> > >  -
> > >  -			while (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
> > >  -				/* add failed due to overlap.  Flush everything
> > >  +			if (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
> > >  +				/* Add failed due to overlap.  Flush everything
> > >   				 * and wait a while
> > >  -				 * FIXME - overlapping requests should be handled better
> > >   				 */
> > >   				raid5_unplug_device(mddev->queue);
> > >  -				set_current_state(TASK_UNINTERRUPTIBLE);
> > >  -				schedule_timeout(1);
> > >  +				release_stripe(sh);
> > >  +				schedule();
> > >  +				goto retry;
> > 
> > Worrisome.  If the calling process has SCHED_RR or SCHED_FIFO policy, this
> > could cause a lockup, perhaps.
> 
> Is that just that I should have the "prepare_to_wait" after the retry:
> label rather than before, or is there something more subtle.

umm, yes.  We always exit from schedule() in state TASK_RUNNING, so we need
to run prepare_to_wait() each time around.  See __wait_on_bit() for a
canonical example.

> ### Diffstat output
>  ./drivers/md/raid5.c |    2 +-
>  1 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff ./drivers/md/raid5.c~current~ ./drivers/md/raid5.c
> --- ./drivers/md/raid5.c~current~	2005-02-07 13:34:23.000000000 +1100
> +++ ./drivers/md/raid5.c	2005-02-08 13:34:38.000000000 +1100
> @@ -1433,9 +1433,9 @@ static int make_request (request_queue_t
>  			(unsigned long long)new_sector, 
>  			(unsigned long long)logical_sector);
>  
> +	retry:
>  		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
>  
> -	retry:
>  		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
>  		if (sh) {
>  			if (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {

You missed one.

--- 25/drivers/md/raid5.c~md-fix-handling-of-overlapping-requests-in-raid5-fix	2005-02-07 19:04:18.000000000 -0800
+++ 25-akpm/drivers/md/raid5.c	2005-02-07 19:04:48.000000000 -0800
@@ -1433,9 +1433,8 @@ static int make_request (request_queue_t
 			(unsigned long long)new_sector, 
 			(unsigned long long)logical_sector);
 
-		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
-
 	retry:
+		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
 		if (sh) {
 			if (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
diff -puN drivers/md/raid6main.c~md-fix-handling-of-overlapping-requests-in-raid5-fix drivers/md/raid6main.c
--- 25/drivers/md/raid6main.c~md-fix-handling-of-overlapping-requests-in-raid5-fix	2005-02-07 19:04:18.000000000 -0800
+++ 25-akpm/drivers/md/raid6main.c	2005-02-07 19:04:54.000000000 -0800
@@ -1593,9 +1593,8 @@ static int make_request (request_queue_t
 		       (unsigned long long)new_sector,
 		       (unsigned long long)logical_sector);
 
-		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
-
 	retry:
+		prepare_to_wait(&conf->wait_for_overlap, &w, TASK_UNINTERRUPTIBLE);
 		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
 		if (sh) {
 			if (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {

_

(That piece of the code looks pretty fugly in an 80-col xterm btw..)


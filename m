From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH md 6 of 6] Fix handling of overlapping requests in raid5
Date: Mon, 7 Feb 2005 18:24:56 -0800
Message-ID: <20050207182456.1d50c83b.akpm@osdl.org>
References: <20050207133555.17870.patches@notabene>
	<E1Cxyst-0004fu-PP@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
In-Reply-To: <E1Cxyst-0004fu-PP@notabene.cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@cse.unsw.edu.au> wrote:
>
> +	retry:
>   		sh = get_active_stripe(conf, new_sector, pd_idx, (bi->bi_rw&RWA_MASK));
>   		if (sh) {
>  -
>  -			while (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
>  -				/* add failed due to overlap.  Flush everything
>  +			if (!add_stripe_bio(sh, bi, dd_idx, (bi->bi_rw&RW_MASK))) {
>  +				/* Add failed due to overlap.  Flush everything
>   				 * and wait a while
>  -				 * FIXME - overlapping requests should be handled better
>   				 */
>   				raid5_unplug_device(mddev->queue);
>  -				set_current_state(TASK_UNINTERRUPTIBLE);
>  -				schedule_timeout(1);
>  +				release_stripe(sh);
>  +				schedule();
>  +				goto retry;

Worrisome.  If the calling process has SCHED_RR or SCHED_FIFO policy, this
could cause a lockup, perhaps.

Some sort of real synchronisation scheme would be nicer.  Or at the least,
what was wrong with the schedule_timeout(1)?

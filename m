From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Fri, 13 Feb 2015 09:32:50 +0100
Message-ID: <20150213083250.GN2896@worktop.programming.kicks-ass.net>
References: <54D3D24E.5060303@cybernetics.com>
 <20150206085133.2c1ab892@notabene.brown>
 <20150206113930.GK23123@twins.programming.kicks-ass.net>
 <20150209121357.29f19d36@notabene.brown>
 <20150209091000.GN5029@twins.programming.kicks-ass.net>
 <20150210135017.7659e49c@notabene.brown>
 <20150210092936.GW21418@twins.programming.kicks-ass.net>
 <20150213162600.059fffb2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150213162600.059fffb2@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Fri, Feb 13, 2015 at 04:26:00PM +1100, NeilBrown wrote:
> I choose ... Buzz Lightyear !!!

Great choice!

> From: NeilBrown <neilb@suse.de>
> Date: Fri, 13 Feb 2015 15:49:17 +1100
> Subject: [PATCH] sched: prevent recursion in io_schedule()
> 
> io_schedule() calls blk_flush_plug() which, depending on the
> contents of current->plug, can initiate arbitrary blk-io requests.
> 
> Note that this contrasts with blk_schedule_flush_plug() which requires
> all non-trivial work to be handed off to a separate thread.
> 
> This makes it possible for io_schedule() to recurse, and initiating
> block requests could possibly call mempool_alloc() which, in times of
> memory pressure, uses io_schedule().
> 
> Apart from any stack usage issues, io_schedule() will not behave
> correctly when called recursively as delayacct_blkio_start() does
> not allow for repeated calls.

Which seems to still be an issue with this patch.

> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 1f37fe7f77a4..90f3de8bc7ca 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4420,30 +4420,27 @@ EXPORT_SYMBOL_GPL(yield_to);
>   */
>  void __sched io_schedule(void)
>  {
> +	io_schedule_timeout(MAX_SCHEDULE_TIMEOUT);
>  }
>  EXPORT_SYMBOL(io_schedule);

Might as well move it to sched.h as an inline or so..

>  long __sched io_schedule_timeout(long timeout)
>  {
> +	struct rq *rq;
>  	long ret;
> +	int old_iowait = current->in_iowait;
> +
> +	current->in_iowait = 1;
> +	if (old_iowait)
> +		blk_schedule_flush_plug(current);
> +	else
> +		blk_flush_plug(current);
>  
>  	delayacct_blkio_start();
> +	rq = raw_rq();
>  	atomic_inc(&rq->nr_iowait);
>  	ret = schedule_timeout(timeout);
> +	current->in_iowait = old_iowait;
>  	atomic_dec(&rq->nr_iowait);
>  	delayacct_blkio_end();
>  	return ret;

Like said, that will still recursive call delayacct_blkio_*() and would
increase nr_iowait for a second time; while arguably its still the same
one io-wait instance.

So would a little something like:

long __sched io_schedule_timeout(long timeout)
{
	struct rq *rq;
	long ret;

	/*
	 * Recursive io_schedule() call; make sure to not recurse
	 * on the blk_flush_plug() stuff again.
	 */
	if (unlikely(current->in_iowait)) {
		/*
		 * Our parent io_schedule() call will already have done
		 * all the required io-wait accounting.
		 */
		blk_schedule_flush_plug(current);
		return schedule_timeout(timeout);
	}

	current->in_iowait = 1;
	delayacct_blkio_start();
	rq = raw_rq();
	atomic_inc(&rq->nr_iowait);
	blk_flush_plug(current);
	ret = schedule_timeout(timeout);
	atomic_dec(&rq->nr_iowait);
	delayacct_blkio_end();
	current->in_iowait = 0;

	return ret;
}

not make more sense? 

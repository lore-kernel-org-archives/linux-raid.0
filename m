From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Mon, 9 Feb 2015 10:10:00 +0100
Message-ID: <20150209091000.GN5029@twins.programming.kicks-ass.net>
References: <54D3D24E.5060303@cybernetics.com>
 <20150206085133.2c1ab892@notabene.brown>
 <20150206113930.GK23123@twins.programming.kicks-ass.net>
 <20150209121357.29f19d36@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150209121357.29f19d36@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Mon, Feb 09, 2015 at 12:13:57PM +1100, NeilBrown wrote:
> I had to re-read the code (And your analysis) a couple of times to be sure ...

Sorry :-)

> However, when io_schedule() explicitly calls blk_flush_plug(), then
> @from_schedule=false variant is used, and the unplug functions are allowed to
> allocate memory and block and maybe even call mempool_alloc() which might
> call io_schedule().
> 
> This shouldn't be a problem as blk_flush_plug() spliced out the plug list, so
> any recursive call will find an empty list and do nothing.

Unless, something along the way stuck something back on, right? So
should we stick an:

	WARN_ON(current->in_iowait);

somewhere near where things are added to this plug list? (and move the
blk_flush_plug() call inside of where that's actually true of course).

> Worst case is that a wait_event loop that calls io_schedule() (i.e.
> wait_on_bit_io()) might not block in the first call to io_schedule()
> if the unplugging needed to wait.  Every subsequent call will block as
> required as there is nothing else to add requests to the plug queue.

Again, assuming @cond will not actually stick something on this list.
Which if we add the above we'll get warned about.

> It isn't that scheduling is "rare" - it is that it can only occur once in a
> loop which doesn't expect it.

With the above WARN stuck in, agreed.

> So I propose the following, though I haven't tested it.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index e628cb11b560..b0f12ab3df23 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -4374,6 +4374,11 @@ void __sched io_schedule(void)
>  
>  	delayacct_blkio_start();
>  	atomic_inc(&rq->nr_iowait);
> +	/* Any sleeping in blk_flush_plug() should not
> +	 * trigger the "do not call blocking ops" warning
> +	 * as it can only happen once in a wait_event loop.
> +	 */

Might I suggest the 'regular' multi-line comment style, and a reference
to the above WARN that makes everything actually work?

	/*
	 * multi-line
	 *  comments have an empty
	 *    line at the start... As per CodingStyle ch. 8
	 */

> +	sched_annotate_sleep();
>  	blk_flush_plug(current);

Also, at this point, should we put it in blk_flush_plug()?


The only thing that really goes wrong then is if people 'forget' to put
a loop around io_schedule().

From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Fri, 6 Feb 2015 12:39:30 +0100
Message-ID: <20150206113930.GK23123@twins.programming.kicks-ass.net>
References: <54D3D24E.5060303@cybernetics.com>
 <20150206085133.2c1ab892@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150206085133.2c1ab892@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Fri, Feb 06, 2015 at 08:51:33AM +1100, NeilBrown wrote:
> That is exactly what is happening here.  However I don't think that is an
> "observed problem" but rather an "observed false-positive".
> 
> If nothing inside the outer loop blocks, then in particular
> generic_make_request will not be called, so nothing will be added to the
> queue that blk_schedule_flush_plug flushes.
> So the first time through the loop, a call the 'schedule()' may not actually
> block, but every subsequent time it will.
> So there is no actual problem here.
> 
> So I'd be included to add sched_annotate_sleep() in blk_flush_plug_list().
> 
> Peter: what do you think is the best way to silence this warning.

> > Call Trace:

> >  [<ffffffff8027ee62>] __might_sleep+0x82/0x90
> >  [<ffffffff803bee06>] generic_make_request_checks+0x36/0x2d0
> >  [<ffffffff803bf0b3>] generic_make_request+0x13/0x100
> >  [<ffffffff8054983b>] raid1_unplug+0x12b/0x170
> >  [<ffffffff803c1302>] blk_flush_plug_list+0xa2/0x230
> >  [<ffffffff80646383>] io_schedule+0x43/0x80
> >  [<ffffffff80646787>] bit_wait_io+0x27/0x50

Well, I don't know. I don't particularly like the whole blk_flush_plug()
thing scheduling while on its way to schedule. If you ever end up
calling io_schedule() from it there's 'fun'.

Also, how likely is it to actually schedule when doing all that? This
block layer stuff is somewhat impenetrable for me, too many callbacks.

You have some words on how its unlikely, but I can't even find _where_
it would schedule :/ All I see is a loop calling ->make_request_fn() and
god only knows where that ends up.

So there appear to be two blk_flush_plug() variants, one with an
@from_schedule = true, which seems to really try not to schedule, which
seems to suggest the 'false' one (the one above) is meant to schedule?

If scheduling is the rule rather than the exception, the above is
properly broken.

But again, I don't know.

If you're confident that scheduling is rare for _ALL_ (current and
future) block device implementations, not just the raid one, then you
can annotate blk_flush_plug_list() I suppose.

Otherwise I would suggest adding them one at a time in whatever blk
device thing likes to go schedule on us. Also, add a comment that
explains why its rare for the future us who need to look at it again.

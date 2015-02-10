From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: RAID1 might_sleep() warning on 3.19-rc7
Date: Tue, 10 Feb 2015 10:29:36 +0100
Message-ID: <20150210092936.GW21418@twins.programming.kicks-ass.net>
References: <54D3D24E.5060303@cybernetics.com>
 <20150206085133.2c1ab892@notabene.brown>
 <20150206113930.GK23123@twins.programming.kicks-ass.net>
 <20150209121357.29f19d36@notabene.brown>
 <20150209091000.GN5029@twins.programming.kicks-ass.net>
 <20150210135017.7659e49c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150210135017.7659e49c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Tony Battersby <tonyb@cybernetics.com>, linux-raid@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>, axboe@kernel.dk, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-raid.ids

On Tue, Feb 10, 2015 at 01:50:17PM +1100, NeilBrown wrote:
> On Mon, 9 Feb 2015 10:10:00 +0100 Peter Zijlstra <peterz@infradead.org> wrote:
> > > However, when io_schedule() explicitly calls blk_flush_plug(), then
> > > @from_schedule=false variant is used, and the unplug functions are allowed to
> > > allocate memory and block and maybe even call mempool_alloc() which might
> > > call io_schedule().
> > > 
> > > This shouldn't be a problem as blk_flush_plug() spliced out the plug list, so
> > > any recursive call will find an empty list and do nothing.
> > 
> > Unless, something along the way stuck something back on, right? So
> > should we stick an:
> > 
> > 	WARN_ON(current->in_iowait);
> > 
> > somewhere near where things are added to this plug list? (and move the
> > blk_flush_plug() call inside of where that's actually true of course).
> 
> No, I don't think so.
> 
> It is certainly possible that some request on plug->cb_list could add
> something to plug->list - which is processed after ->cb_list.
> 
> I think the best way to think about this is that the *problem* was that a
> wait_event loop could spin without making any progress.   So any time that
> clear forward progress is made it is safe sleep without necessitating the
> warning.  Hence sched_annotate_sleep() is reasonable.
> blk_flush_plug() with definitely have dispatched some requests if it
> might_sleep(), so the sleep is OK.

Well, yes, but you forget that this gets us back into recursion land.
io_schedule() calling io_schedule() calling io_schedule() and *boom*
stack overflow -> dead machine.

We must either guarantee io_schedule() will never call io_schedule() or
that io_schedule() itself will not add new work to the current plug such
that calling io_schedule() itself will not recurse on the blk stuff.

Pick either option, but pick one.

Without providing such a guarantee I'm not comfortable making this warn
go away.

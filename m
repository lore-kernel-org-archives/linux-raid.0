From: Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] md - 2 of 10 - Don't allow raid5 rebuild to swamp raid5
 stripe cache
Date: Thu, 15 Jan 2004 17:55:15 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040115175515.0f064aa7.akpm@osdl.org>
References: <E1AhIe9-0002U2-00@notabene>
	<20040115173317.3a356afc.akpm@osdl.org>
	<16391.16842.560527.897653@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16391.16842.560527.897653@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
>
> On Thursday January 15, akpm@osdl.org wrote:
> > NeilBrown <neilb@cse.unsw.edu.au> wrote:
> > >
> > > +	if (sh == NULL) {
> > > +		sh = get_active_stripe(conf, sector_nr, pd_idx, 0);
> > > +		/* make sure we don't swamp the stripe cache if someone else
> > > +		 * is trying to get access 
> > > +		 */
> > > +		yield();
> > > +	}
> > 
> > In 2.6, yield() has utterly awful behaviour when there are a lot of other
> > runnable tasks.
> > 
> > Have you tested this when the kernel is busy doing other stuff, like a
> > `make -j2' or a few busywait loops?  You might find that rebuild simply
> > stops.
> > 
> 
> No I haven't, and I'm not near my test box today, so it would be
> awkward. 

OK.  We had a yeild like that in ext3 for a while.  The CPU scheduler
changes killed it stone dead.  I ended up just making it a schedule(),
which is too weak and probably broke the transaction batching speedup :(

> No other patches are dependant on that one so you can just leave it
> out if you like.

OK.  It'll take a few days after Linus gets back from .au to get all this
stuff flushed out anyway.   I'll probably have >700 patches by then.

> I just want to wait until every other runnable process has had a
> turn.  Maybe cond_resched() would be better??  I try some things out.

There isn't an equivalent, really.  We could add one to the CPU scheduler.

With HZ=1000 you'll probably find that a brief schedule_timeout() is OK. 
blk_congestion_wait() probably does the wrong thing too.


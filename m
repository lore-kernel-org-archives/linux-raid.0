From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 1/3]raid5: adjust order of some operations in
 handle_stripe
Date: Wed, 28 May 2014 18:09:09 +0800
Message-ID: <20140528100909.GA17675@kernel.org>
References: <20140522112431.GA10509@kernel.org>
 <20140528125937.5555437e@notabene.brown>
 <20140528034507.GA1650@kernel.org>
 <20140528145435.3713a236@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140528145435.3713a236@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 28, 2014 at 02:54:35PM +1000, NeilBrown wrote:
> On Wed, 28 May 2014 11:45:07 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Wed, May 28, 2014 at 12:59:37PM +1000, NeilBrown wrote:
> > > On Thu, 22 May 2014 19:24:31 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > 
> > > > 
> > > > This is to revert ef5b7c69b7a1b8b8744a6168b6f. handle_stripe_clean_event()
> > > > handles finished stripes, which really should be the first thing to do. The
> > > > original changelog says checking reconstruct_state should be the first as
> > > > handle_stripe_clean_event can clear some dev->flags and impact checking
> > > > reconstruct_state code path. It's unclear to me why this happens, because I
> > > > thought written finish and reconstruct_state equals to *_result can't happen in
> > > > the same time.
> > > 
> > > "unclear to me" "I thought" are sufficient to justify a change, though they
> > > are certainly sufficient to ask a question.
> > > 
> > > Are you asking a question or submitting a change?
> > > 
> > > You may well be correct that if reconstruct_state is not
> > > reconstruct_state_idle, then handle_stripe_clean_event cannot possible be
> > > called.  In that case, maybe we should change the code flow to make that more
> > > obvious, but certainly the changelog comment should be clear about exactly
> > > why.
> > 
> > I'm sorry, it's more like a question. I really didn't understand why we have
> > ef5b7c69b7a1b8b8744a6168b6f, so I'm not 100% sure about. It would be great you
> > can help share a hint.
> 
> It's a while ago and I don't remember, but I suspect that I added that patch
> because handle_stripe_clean_event was about to change to clear R5_UPTODATE,
> and this code which was previously *after* handle_stripe_clean_event tested
> R5_UPTODATE (and could BUG if it wasn't set).
> 
> You may well be right that the two pieces of code cannot both run in the one
> invocation of handle_stripe().  I haven't analysed the code closely to be
> sure, but on casual reflection it seems likely.  However we always need to be
> careful of races in unusual situations.

Sure. The whole piece of code of handle_stripe is hard to understand.

> If that is correct, and if there are two (or more) different situations in
> which handle_stripe runs, maybe one after IO has completed and one after
> reconstruction has completed, and one when new devices have been added,
> then there might be value in clearly delineating these so we don't bother
> testing for cases that cannot happen.

Since run_io will increase stripe counter, if IO is running, the stripe can't
be handled again. So either IO is finished, handle_stripe handles the finished
IO (handle_stripe_clean_event) and then handle new requests in the stripe.
Doing handle_stripe_clean_event first is ok. So could another reconstruction be
scheduled before the IO? It sounds no. Either the stripe has towrite, so there
there is overlap, new bio to the stripe will wait. Or stripe has LOCKED set, so
reconstruction can't be rescheduled.

> 
> If it is not correct, then your proposed change might be dangerous.
> 
> 
> >  
> > > > 
> > > > I also moved checking reconstruct_state code path after handle_stripe_dirtying.
> > > > If that code sets reconstruct_state to reconstruct_state_idle, the order change
> > > > will make us miss one handle_stripe_dirtying. But the stripe will be eventually
> > > > handled again when written is finished.
> > > 
> > > You haven't said here why this patch is a good thing, only why it isn't
> > > obviously bad.  I really need some justification to make a change and you
> > > haven't provided any, at least not in this changelog comment.
> > 
> > ok, I'll add more about this.
> >  
> > > Maybe we need a completely different approach.
> > > Instead of repeatedly shuffling code inside handle_stripe(), how about we put
> > > all of handle_stripe inside a loop which runs as long as STRIPE_HANDLE is set
> > > and sh->count == 1.
> > > ie.
> > > 
> > > 	if (test_and_set_bit_lock(STRIPE_ACTIVE, &sh->state)) {
> > > 		/* already being handled, ensure it gets handled
> > > 		 * again when current action finishes */
> > > 		set_bit(STRIPE_HANDLE, &sh->state);
> > > 		return;
> > > 	}
> > > 
> > >         do {
> > > 	        clear_bit(STRIPE_HANDLE, &sh->state);
> > >                 __handle_stripe(sh);
> > >         } while (test_bit(STRIPE_HANDLE, &sh->state)
> > >                  && atomic_read(&sh->count) == 1);
> > > 	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
> > > 
> > > 
> > > where the rest of the current handle_stripe() goes in to __handle_stripe().
> > > 
> > > Would that address your performance concerns, or is there still too much
> > > overhead?
> > 
> > Let me try. One issue here is we still have massive cache miss when checking
> > stripe/dev state. I suppose this doesn't help but data should prove.
> 
> That would be great - thanks.
> If you can identify exactly where the cache misses are causing a problem, we
> might be able to optimise around that.

I tried. It's slightly better than without any change, but still not as good as
adjusting the order (which cuts the run times of handle_stripe). But I then hit
a quick hang with such change, so can't run long time test.

When checking perf annotate, some obvious cache miss comes from checking
dev->flags in analysis_stripe and checking conf->disks[]. But it's not an issue
one hotspot uses > 50% CPU. Other code in handle_stripe contributes overhead.

Thanks,
Shaohua

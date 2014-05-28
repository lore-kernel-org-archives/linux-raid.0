From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 1/3]raid5: adjust order of some operations in
 handle_stripe
Date: Wed, 28 May 2014 11:45:07 +0800
Message-ID: <20140528034507.GA1650@kernel.org>
References: <20140522112431.GA10509@kernel.org>
 <20140528125937.5555437e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140528125937.5555437e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 28, 2014 at 12:59:37PM +1000, NeilBrown wrote:
> On Thu, 22 May 2014 19:24:31 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > 
> > This is to revert ef5b7c69b7a1b8b8744a6168b6f. handle_stripe_clean_event()
> > handles finished stripes, which really should be the first thing to do. The
> > original changelog says checking reconstruct_state should be the first as
> > handle_stripe_clean_event can clear some dev->flags and impact checking
> > reconstruct_state code path. It's unclear to me why this happens, because I
> > thought written finish and reconstruct_state equals to *_result can't happen in
> > the same time.
> 
> "unclear to me" "I thought" are sufficient to justify a change, though they
> are certainly sufficient to ask a question.
> 
> Are you asking a question or submitting a change?
> 
> You may well be correct that if reconstruct_state is not
> reconstruct_state_idle, then handle_stripe_clean_event cannot possible be
> called.  In that case, maybe we should change the code flow to make that more
> obvious, but certainly the changelog comment should be clear about exactly
> why.

I'm sorry, it's more like a question. I really didn't understand why we have
ef5b7c69b7a1b8b8744a6168b6f, so I'm not 100% sure about. It would be great you
can help share a hint.
 
> > 
> > I also moved checking reconstruct_state code path after handle_stripe_dirtying.
> > If that code sets reconstruct_state to reconstruct_state_idle, the order change
> > will make us miss one handle_stripe_dirtying. But the stripe will be eventually
> > handled again when written is finished.
> 
> You haven't said here why this patch is a good thing, only why it isn't
> obviously bad.  I really need some justification to make a change and you
> haven't provided any, at least not in this changelog comment.

ok, I'll add more about this.
 
> Maybe we need a completely different approach.
> Instead of repeatedly shuffling code inside handle_stripe(), how about we put
> all of handle_stripe inside a loop which runs as long as STRIPE_HANDLE is set
> and sh->count == 1.
> ie.
> 
> 	if (test_and_set_bit_lock(STRIPE_ACTIVE, &sh->state)) {
> 		/* already being handled, ensure it gets handled
> 		 * again when current action finishes */
> 		set_bit(STRIPE_HANDLE, &sh->state);
> 		return;
> 	}
> 
>         do {
> 	        clear_bit(STRIPE_HANDLE, &sh->state);
>                 __handle_stripe(sh);
>         } while (test_bit(STRIPE_HANDLE, &sh->state)
>                  && atomic_read(&sh->count) == 1);
> 	clear_bit_unlock(STRIPE_ACTIVE, &sh->state);
> 
> 
> where the rest of the current handle_stripe() goes in to __handle_stripe().
> 
> Would that address your performance concerns, or is there still too much
> overhead?

Let me try. One issue here is we still have massive cache miss when checking
stripe/dev state. I suppose this doesn't help but data should prove.

Thanks,
Shaohua

From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 08/34] md/raid5: replace sh->lock with an 'active'
 flag.
Date: Fri, 22 Jul 2011 14:49:20 +1000
Message-ID: <20110722144920.2b933155@notabene.brown>
References: <20110721022537.6728.90204.stgit@notabene.brown>
	<20110721023225.6728.96772.stgit@notabene.brown>
	<87hb6fdjnr.fsf@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hb6fdjnr.fsf@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Namhyung Kim <namhyung@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Jul 2011 13:27:36 +0900 Namhyung Kim <namhyung@gmail.com> wrote:

> NeilBrown <neilb@suse.de> writes:
> 
> > sh->lock is now mainly used to ensure that two threads aren't running
> > in the locked part of handle_stripe[56] at the same time.
> >
> > That can more neatly be achieved with an 'active' flag which we set
> > while running handle_stripe.  If we find the flag is set, we simply
> > requeue the stripe for later by setting STRIPE_HANDLE.
> >
> > For safety we take ->device_lock while examining the state of the
> > stripe and creating a summary in 'stripe_head_state / r6_state'.
> > This possibly isn't needed but as shared fields like ->toread,
> > ->towrite are checked it is safer for now at least.
> >
> > We leave the label after the old 'unlock' called "unlock" because it
> > will disappear in a few patches, so renaming seems pointless.
> >
> > This leaves the stripe 'locked' for longer as we clear STRIPE_ACTIVE
> > later, but that is not a problem.
> >
> > Signed-off-by: NeilBrown <neilb@suse.de>
> 
> Reviewed-by: Namhyung Kim <namhyung@gmail.com>

Thanks.

> 
> But I have a question, please see below.

I like questions...

> > @@ -3037,6 +3028,7 @@ static void handle_stripe5(struct stripe_head *sh)
> >  
> >  	/* Now to look around and see what can be done */
> >  	rcu_read_lock();
> > +	spin_lock_irq(&conf->device_lock);
> 
> Do we still need rcu_read_lock()? AFAIK rcu_read_lock() only prevents
> task from preemption but spin_lock does same thing as well.
> 
> I know it's been already there under sh->lock before this patch, and
> it doesn't hurt anything, but I'm not sure it is really needed.

I see your point, but I think there are two reasons why it really is needed.

1/ I think rcu_read_lock does more than prevent preemption.  What it does
   exactly I don't know and I think it depends on which RCU scheme was chosen
   when configuring the kernel.  But what it conceptually does is stop
   a subsequent synchronize_rcu() from completing, and that it what I need.
   Disabling preemption might stop that as well, but I really don't know and
   so cannot trust it.

2/ It is useful documentation.  A reader seeing rcu_read_lock() knows that
   there must be some rcu-protected data here which needs to be handled with
   a little care and so they can be on the lookout for it.

So I think it is really needed.

Thanks,

NeilBrown


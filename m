From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 03/10 v3] raid5: add a per-stripe lock
Date: Tue, 3 Jul 2012 09:27:45 +0800
Message-ID: <20120703012745.GA1898@kernel.org>
References: <20120625072447.268095276@kernel.org>
 <20120625072613.620625574@kernel.org>
 <20120702105046.56cd47ec@notabene.brown>
 <20120702031626.GE29770@kernel.org>
 <20120702173953.7bee26cb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120702173953.7bee26cb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, axboe@kernel.dk, dan.j.williams@intel.com, shli@fusionio.com
List-Id: linux-raid.ids

On Mon, Jul 02, 2012 at 05:39:53PM +1000, NeilBrown wrote:
> On Mon, 2 Jul 2012 11:16:26 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> 
> > > Then I could see what is being added and what is being removed all in the one
> > > patch and I can be sure that they balance.
> > 
> > reworked the patch 3-5 to two patches as you suggested, and sent to you. please check.
> 
> Thanks.  That's looking really good.
> 
> However I think we can do better.  I've been looking more closely at the code
> and I think that the only things that we need stripe_lock to protect are
> ->toread and ->towrite, together with the following bios.  e.g.
> ->toread->bi_next etc.
> 
> ->read and ->written don't need stripe_lock protection, as they are only
> manipulated by the handle_stripe state machine which uses STRIPE_ACTIVE 
> and refcounts for exclusion.
> 
> So add_stripe_bio need to take the lock while adding a bio to the
> ->toread and  ->towrite lists, and ops_run_biodrain() and ops_run_biofill
> need to take the lock while the move the list from ->to{read,write} to
> ->{read,written}.  But we don't need it anywhere else.  e.g. analyse_stripe
> shouldn't need the lock at all.  Any change that could happen during the loop
> could equally happen after the lock was released so we don't lose by not
> having the lock.

Looks reasonable.

> There is another current user of the lock, but I think that should be
> discarded as a false optimisation.
> We currently try to optimise out extra calls to bitmap_startwrite and
> bitmap_endwrite when we see back-to-back writes to the one stripe.  However I
> suspect that is extremely unlikely and it just imposes and pointless need for
> synchronisation in raid5.
> 
> We just simply call bitmap_startwrite whenever ->towrite changes from NULL to
> non-NULL, and call bitmap_endwrite whenever we clear ->written, reguardless
> what value ->towrite now has.

Yep, the chance write to the same stripe should be very low.
I'll try in my stress test, if no failure, I'll post the patches.

Thanks,
Shaohua

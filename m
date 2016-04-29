From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V3 08/13] md: set MD_CHANGE_PENDING in a spinlocked region
Date: Fri, 29 Apr 2016 11:21:37 -0700
Message-ID: <20160429182137.GA103471@kernel.org>
References: <1461221895-20688-1-git-send-email-gqjiang@suse.com>
 <1461722186-11023-1-git-send-email-gqjiang@suse.com>
 <20160427152753.GB17061@kernel.org>
 <57217BAF.5060702@suse.com>
 <20160428035802.GA90901@kernel.org>
 <87eg9purw7.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87eg9purw7.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Guoqing Jiang <gqjiang@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 29, 2016 at 11:26:32AM +1000, NeilBrown wrote:
> On Thu, Apr 28 2016, Shaohua Li wrote:
> 
> > On Wed, Apr 27, 2016 at 10:55:43PM -0400, Guoqing Jiang wrote:
> >> 
> >> 
> >> On 04/27/2016 11:27 AM, Shaohua Li wrote:
> >> >On Tue, Apr 26, 2016 at 09:56:26PM -0400, Guoqing Jiang wrote:
> >> >>Some code waits for a metadata update by:
> >> >>
> >> >>1. flagging that it is needed (MD_CHANGE_DEVS or MD_CHANGE_CLEAN)
> >> >>2. setting MD_CHANGE_PENDING and waking the management thread
> >> >>3. waiting for MD_CHANGE_PENDING to be cleared
> >> >>
> >> >>If the first two are done without locking, the code in md_update_sb()
> >> >>which checks if it needs to repeat might test if an update is needed
> >> >>before step 1, then clear MD_CHANGE_PENDING after step 2, resulting
> >> >>in the wait returning early.
> >> >>
> >> >>So make sure all places that set MD_CHANGE_PENDING are protected by
> >> >>mddev->lock.
> >> >>
> >> >>Reviewed-by: NeilBrown <neilb@suse.com>
> >> >>Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> >> >>---
> >> >>V3 changes:
> >> >>1. use spin_lock_irqsave/spin_unlock_irqrestore in error funcs and
> >> >>    raid10's __make_request
> >> >shouldn't other places use spin_lock_irq/spin_unlock_irq? interrupt can occur
> >> >after you do spin_lock(), and if it's md_error, we deadlock.
> >> 
> >> It could possible in theory if func was interrupted by md_error after it
> >> called spin_lock,
> >> but seems lots of place in md.c also use spin_lock/unlock for mddev->lock,
> >> take
> >> md_do_sync and md_update_sb as example, both of them used
> >> spin_lock(&mddev->lock)
> >> and spin_unlock(&mddev->lock) before.
> >> 
> >> So I guess it will not cause trouble, otherwise, then we need to change all
> >> the usages of
> >> spin_lock/unlock(&mddev->lock), or introduce a new lock for this scenario. I
> >> am not sure
> >> which one is more acceptable.
> >
> > It doesn't cause trouble, because no interrupt/bh uses lock before. But now we
> > use it in softirq, that's the difference. Please enable lockdep, I think it
> > will complain. either we change all the locking to irq save or introducing a
> > new lock. either is ok.
> 
> Thanks for catching this!
> 
> As you say, the straight forward solution is change all the current
>   spin_lock(&mddev->lock);
> to
>   spin_lock_irq(&mddev->lock);
> 
> and similar for unlock.  Except where it can be called from interrupts
> we have to use spin_lock_irqsave().
> 
> There is another option that occurs to me.  Not sure if it is elegant or
> ugly, so I'm keen to see what you think.
> 
> In the places where were set MD_CHANGE_PENDING and one other bit -
> either MD_CHANGE_DEVS or MD_CHANGE_CLEAN - we could use set_mask_bits
> to set them both atomically.
> 
>   set_mask_bits(&mddev->flags, BIT(MD_CHANGE_PENDING) | BIT(MD_CHANGE_DEVS));
> 
> Then in md_update_sb, when deciding whether to loop back to "repeat:" we
> use a new "bit_clear_unless".
> 
> #define bit_clear_unless(ptr, _clear, _test)			\
> ({								\
> 	const typeof(*ptr) clear = (_clear), test = (_test);	\
> 	typeof(*ptr) old, new;					\
> 								\
> 	do {							\
> 		old = ACCESS_ONCE(*ptr);			\
> 		new = old & ~clear;				\
> 	} while (!(old & test) && cmpxchg(ptr, old, new) != old);\
> 								\
> 	!(old & test);							\
> })
> 
> The code in md_update_sb() would be
> 
>  if (mddev->in_sync != sync_req ||
>      !bit_clear_unless(&mddev->flags, BIT(MD_CHANGE_PENDING),
>                        BIT(MD_CHANGE_DEVS)|BIT(MD_CHANGE_CLEAN)))
>         goto repeat;
> 
> 
> So if either DEV or CLEAN we set, PENDING would not be cleared and the
> code would goto repeat.
> 
> What do you think?

Looks great, I like this idea. Thanks!

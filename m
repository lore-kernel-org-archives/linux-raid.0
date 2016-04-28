From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V3 08/13] md: set MD_CHANGE_PENDING in a spinlocked region
Date: Wed, 27 Apr 2016 20:58:02 -0700
Message-ID: <20160428035802.GA90901@kernel.org>
References: <1461221895-20688-1-git-send-email-gqjiang@suse.com>
 <1461722186-11023-1-git-send-email-gqjiang@suse.com>
 <20160427152753.GB17061@kernel.org>
 <57217BAF.5060702@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <57217BAF.5060702@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 27, 2016 at 10:55:43PM -0400, Guoqing Jiang wrote:
> 
> 
> On 04/27/2016 11:27 AM, Shaohua Li wrote:
> >On Tue, Apr 26, 2016 at 09:56:26PM -0400, Guoqing Jiang wrote:
> >>Some code waits for a metadata update by:
> >>
> >>1. flagging that it is needed (MD_CHANGE_DEVS or MD_CHANGE_CLEAN)
> >>2. setting MD_CHANGE_PENDING and waking the management thread
> >>3. waiting for MD_CHANGE_PENDING to be cleared
> >>
> >>If the first two are done without locking, the code in md_update_sb()
> >>which checks if it needs to repeat might test if an update is needed
> >>before step 1, then clear MD_CHANGE_PENDING after step 2, resulting
> >>in the wait returning early.
> >>
> >>So make sure all places that set MD_CHANGE_PENDING are protected by
> >>mddev->lock.
> >>
> >>Reviewed-by: NeilBrown <neilb@suse.com>
> >>Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> >>---
> >>V3 changes:
> >>1. use spin_lock_irqsave/spin_unlock_irqrestore in error funcs and
> >>    raid10's __make_request
> >shouldn't other places use spin_lock_irq/spin_unlock_irq? interrupt can occur
> >after you do spin_lock(), and if it's md_error, we deadlock.
> 
> It could possible in theory if func was interrupted by md_error after it
> called spin_lock,
> but seems lots of place in md.c also use spin_lock/unlock for mddev->lock,
> take
> md_do_sync and md_update_sb as example, both of them used
> spin_lock(&mddev->lock)
> and spin_unlock(&mddev->lock) before.
> 
> So I guess it will not cause trouble, otherwise, then we need to change all
> the usages of
> spin_lock/unlock(&mddev->lock), or introduce a new lock for this scenario. I
> am not sure
> which one is more acceptable.

It doesn't cause trouble, because no interrupt/bh uses lock before. But now we
use it in softirq, that's the difference. Please enable lockdep, I think it
will complain. either we change all the locking to irq save or introducing a
new lock. either is ok.

Thanks,
Shaohua

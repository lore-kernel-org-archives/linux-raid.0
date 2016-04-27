From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH V3 08/13] md: set MD_CHANGE_PENDING in a spinlocked region
Date: Wed, 27 Apr 2016 08:27:53 -0700
Message-ID: <20160427152753.GB17061@kernel.org>
References: <1461221895-20688-1-git-send-email-gqjiang@suse.com>
 <1461722186-11023-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1461722186-11023-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Apr 26, 2016 at 09:56:26PM -0400, Guoqing Jiang wrote:
> Some code waits for a metadata update by:
> 
> 1. flagging that it is needed (MD_CHANGE_DEVS or MD_CHANGE_CLEAN)
> 2. setting MD_CHANGE_PENDING and waking the management thread
> 3. waiting for MD_CHANGE_PENDING to be cleared
> 
> If the first two are done without locking, the code in md_update_sb()
> which checks if it needs to repeat might test if an update is needed
> before step 1, then clear MD_CHANGE_PENDING after step 2, resulting
> in the wait returning early.
> 
> So make sure all places that set MD_CHANGE_PENDING are protected by
> mddev->lock.
> 
> Reviewed-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
> V3 changes:
> 1. use spin_lock_irqsave/spin_unlock_irqrestore in error funcs and
>    raid10's __make_request

shouldn't other places use spin_lock_irq/spin_unlock_irq? interrupt can occur
after you do spin_lock(), and if it's md_error, we deadlock.

please resend the whole series.

Thanks,
Shaohua

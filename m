From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH/Resend] md: Push down data integrity code to personalities.
Date: Thu, 6 Aug 2009 13:31:59 +1000
Message-ID: <19066.20143.666654.818111@notabene.brown>
References: <20090701083802.GC9910@skl-net.de>
	<19026.50240.504728.428875@notabene.brown>
	<20090713085442.GJ9910@skl-net.de>
	<19058.31706.803177.77914@notabene.brown>
	<20090803164030.GI5174@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Monday August 3
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday August 3, maan@systemlinux.org wrote:
> On 15:06, Neil Brown wrote:
> > > Here is a revised patch that puts calls to the new functions into
> > > the ->hot_*_disk methods as you propose.
> > 
> > Thanks.  Much better.
> > Calling md_integrity_check from the ->error routines isn't a good idea
> > though.  They can be called in interrupt context, and
> > md_integrity_check can call kmalloc(..., GFP_KERNEL) which might try
> > to sleep.  That would be bad.
> > We don't need the call in ->error, having it in ->hot_remove_disk is
> > adequate, as that is called soon after any failure (it doesn't wait
> > for the sysadmin to "mdadm --remove ...".).
> > 
> > So I have made that change and updated the comment accordingly.
> 
> Thanks. Sorry if this is a FAQ, but how can one tell whether a given
> function may be called in interrupt context? Is there a better way
> than recursively checking all its callers?

I think you just have to 'know'. :-(
Some functions which mustn't be called from interrupts are
'documented' as such by calling "might_sleep()", but there is no
similar documentation for the reverse.

All ->bi_endio routines are called from interrupts.. or maybe
from softirqs or something similar.  I think the important point is
that they are called without a process context, so they cannot sleep
(i.e. no kmalloc unless you use GFP_ATOMIC, no mutex_lock, no
wait_event etc) and should use spin_lock_irqsave or spin_lock_bh
rather than a bare spin_lock.

NeilBrown

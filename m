From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PULL REQUEST] md bug fixes and minor improvements
Date: Fri, 1 Aug 2008 20:22:27 +0200
Message-ID: <20080801182227.GI20055@kernel.dk>
References: <18578.31924.259887.735206@notabene.brown> <alpine.LFD.1.10.0808011007240.3277@nehalem.linux-foundation.org> <20080801172231.GF20055@kernel.dk> <alpine.LFD.1.10.0808011115050.3277@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0808011115050.3277@nehalem.linux-foundation.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Neil Brown <neilb@suse.de>, Arthur Jones <ajones@riverbed.com>, Dan Williams <dan.j.williams@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
List-Id: linux-raid.ids

On Fri, Aug 01 2008, Linus Torvalds wrote:
> 
> 
> On Fri, 1 Aug 2008, Jens Axboe wrote:
> > +			spin_lock_irq(&bitmap->mddev->queue->queue_lock);
> >  			blk_plug_device(bitmap->mddev->queue);
> > +			spin_unlock_irq(&bitmap->mddev->queue->queue_lock);
> 
> Can we please not have a chain of three dereferences in a row like that? 
> That's an almost certain sign that we should either have a helper function 
> or just a variable, and do it as
> 
> 	queue = bitmap->mddev->queue;
> 
> 	spin_lock_irq(&queue->queue_lock);
> 	blk_plug_device(queue);
> 	spin_unlock_irq(&queue->queue_lock);
> 
> Hmm? Perhaps the helper function is cleaner, ie
> 
> 	static inline blk_plug_device_unlocked(struct request_queue * queue)
> 	{..
> 
> instead. That, of course, would have to use spin_lock_irqsave().

I rather like that. I've got a few simpler things to push, I'll queue it
up with that and send you a pull request later today.

-- 
Jens Axboe


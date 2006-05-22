From: Neil Brown <neilb@suse.de>
Subject: Re: spin_lock_irq() in handle_stripe()
Date: Tue, 23 May 2006 08:48:30 +1000
Message-ID: <17522.16318.925938.983064@cse.unsw.edu.au>
References: <m33bf2f93h.fsf@bzzz.home.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Alex Tomas on Monday May 22
Sender: linux-raid-owner@vger.kernel.org
To: Alex Tomas <alex@clusterfs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 22, alex@clusterfs.com wrote:
> 
> 
> Good day Neil, all
> 
> if I understand right, we disable irqs in handle_stripe()
> just because of using device_lock which can be grabbed
> from interrupt context (_end_io functions). can we replace
> it by a new separate spinlock and don't block interrupts
> in handle_stripe() + add_stripe_bio() ?

Yes, irqs are disabled in handle_stripe, but only for relatively short
periods of time.  Do you have reason to think this is a problem.?

device_lock does currently protect a number of data structures.
Not all of them are accessed in interrupt context, and so they could
be changed to be protected by a different lock, possibly sh->lock.
You would need to carefully work out exactly what it is protecting,
determine which of those aren't accessed from interrupts, and see
about moving them (one by one preferably) to a different lock.

NeilBrown

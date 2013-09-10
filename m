From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 3/3] raid5: relieve lock contention in get_active_stripe()
Date: Tue, 10 Sep 2013 14:59:12 +0800
Message-ID: <20130910065912.GA12038@kernel.org>
References: <20130904164132.177701e0@notabene.brown>
 <20130905054035.GA30216@kernel.org>
 <20130905162910.179ea808@notabene.brown>
 <20130905091822.GA8401@kernel.org>
 <20130909043318.GA27517@kernel.org>
 <20130910111318.1d19e8d3@notabene.brown>
 <20130910023555.GA17907@kernel.org>
 <20130910140629.702683da@notabene.brown>
 <20130910042438.GA16797@kernel.org>
 <20130910152032.48631492@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130910152032.48631492@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Tue, Sep 10, 2013 at 03:20:32PM +1000, NeilBrown wrote:
> On Tue, 10 Sep 2013 12:24:38 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Tue, Sep 10, 2013 at 02:06:29PM +1000, NeilBrown wrote:
> > > On Tue, 10 Sep 2013 10:35:55 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > 
> > > > On Tue, Sep 10, 2013 at 11:13:18AM +1000, NeilBrown wrote:
> > > > > On Mon, 9 Sep 2013 12:33:18 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > > > >  		} else {
> > > > > > +			spin_lock(&conf->device_lock);
> > > > > > +
> > > > > >  			if (atomic_read(&sh->count)) {
> > > > > >  				BUG_ON(!list_empty(&sh->lru)
> > > > > >  				    && !test_bit(STRIPE_EXPANDING, &sh->state)
> > > > > > @@ -611,13 +725,14 @@ get_active_stripe(struct r5conf *conf, s
> > > > > >  					sh->group = NULL;
> > > > > >  				}
> > > > > >  			}
> > > > > > +			spin_unlock(&conf->device_lock);
> > > > > 
> > > > > The device_lock is only really needed in the 'else' branch of the if
> > > > > statement.  So can we have it only there.  i.e. don't take the lock if
> > > > > sh->count is non-zero.
> > > > 
> > > > This is correct, I assume this isn't worthy optimizing before. Will fix soon.
> > > 
> > > It isn't really about optimising performance.  It is about making the code
> > > easier to understand.  If we keep the region covered by the lock as small as
> > > reasonably possible, it makes it more obvious to the reader which values are
> > > being protected.
> > > 
> > >  
> > > > > > -	spin_lock_irqsave(&conf->device_lock, flags);
> > > > > > +	lock_all_device_hash_locks_irqsave(conf, &flags);
> > > > > >  	clear_bit(In_sync, &rdev->flags);
> > > > > >  	mddev->degraded = calc_degraded(conf);
> > > > > > -	spin_unlock_irqrestore(&conf->device_lock, flags);
> > > > > > +	unlock_all_device_hash_locks_irqrestore(conf, &flags);
> > > > > >  	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> > > > > 
> > > > > Why do you think you need to take all the hash locks here and elsewhere when
> > > > > ->degraded is set?
> > > > > The lock is only need to ensure that the 'In_sync' flags are consistent with
> > > > > the 'degraded' count.
> > > > > ->degraded isn't used in get_active_stripe so I cannot see how it is relevant
> > > > > to the hash locks.
> > > > > 
> > > > > We need to lock everything in raid5_quiesce().  I don't think we need to
> > > > > anywhere else.
> > > > 
> > > > init_stripe() accesses some filelds, don't need to protect?
> > > 
> > > What fields?  Not ->degraded.
> > > 
> > > I think the fields that it accesses are effectively protected by the new
> > > seqlock.
> > > If you don't think so, please be explicit.
> > 
> > Like raid_disks, previous_raid_disks, chunk_sectors, prev_chunk_sectors,
> > algorithm and so on. They are used in raid5_compute_sector(), stripe_set_idx()
> > and init_stripe(). The former two are called by init_stripe().
> 
> Yes.  Those are only changed in raid5_start_reshape() and are protected by
> conf->gen_lock.

Ok, I thought I misread degraded as max_degraded, so added unnecessary code.
The last question, in raid5_start_reshape(), I thought we should use seqlock to
protect the '!mddev->sync_thread' case, no?

> If they change while init_stripe is running, the read_seqcount_retry() call in
> make_request() will notice the inconsistency, release the stripe, and try
> again.
> 
> I guess we probably need an extra check on gen_lock inside init_stripe().
> i.e. a
>   do {
>      seq = read_seqcount_begin(&conf->gen_lock);
> 
> just after the "remove_hash(sh)", and a
> 
>   } while (read_seqcount_retry(&conf->gen_lock, seq));
> 
> just before the "insert_hash(sh)".  That will ensure the stripe inserted into
> the hash is consistent.  The read_seqcount_retry() in make_request is still
> needed to ensure that the correct stripe_head is used.

Good point. If it's in hash list, the seqcount check could be skiped.

Thanks,
Shaohua

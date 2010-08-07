From: Neil Brown <neilb@suse.de>
Subject: Re: Raid10 device hangs during resync and heavy I/O.
Date: Sat, 7 Aug 2010 21:22:48 +1000
Message-ID: <20100807212248.1bda536b@notabene>
References: <20100716184618.GA25890@gmail.com>
	<20100722184933.GA22647@gmail.com>
	<20100723131925.4b2bd54e@notabene>
	<20100723154701.GA2090@gmail.com>
	<20100802122949.7bea3e7c@notabene>
	<20100802125805.1e902fe9@notabene>
	<20100802203754.GA10647@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100802203754.GA10647@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Bronder <jsbronder@gentoo.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2 Aug 2010 16:37:54 -0400
Justin Bronder <jsbronder@gentoo.org> wrote:

> On 02/08/10 12:58 +1000, Neil Brown wrote:
> > On Mon, 2 Aug 2010 12:29:49 +1000
> > Neil Brown <neilb@suse.de> wrote:
> > 
> > 
> > > Ahhhh.... I see the problem.  Because a 'generic_make_request' is already
> > > active, the once called by raid10::make_request just queues the request until
> > > the top level one completes.   This results in a deadlock.
> > > 
> > > I'll have to ponder a bit to figure out the best way to fix this.
> > > 
> > 
> > So, one good strong cup of tea later I think I have a good solution.
> > 
> > Would you be able to test with this patch and confirm that you cannot
> > reproduce the hang?
> 
> I've been running with this patch on 2.6.34.1 all day and have yet to cause
> the hang.  Given it took under 5 minutes earlier, feel free to add:
> 
> Tested-by:  Justin Bronder <jsbronder@gentoo.org>
> 
> I really appreciate you taking care of this.  Thanks.

And thank you for testing.  I've queued this up now and will send it to Linus
and -stable shortly.

NeilBrown


> 
> > Thanks.
> > 
> > NeilBrown
> > 
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 42e64e4..d1d6891 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -825,11 +825,29 @@ static int make_request(mddev_t *mddev, struct bio * bio)
> >  		 */
> >  		bp = bio_split(bio,
> >  			       chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
> > +
> > +		/* Each of these 'make_request' calls will call 'wait_barrier'.
> > +		 * If the first succeeds but the second blocks due to the resync
> > +		 * thread raising the barrier, we will deadlock because the
> > +		 * IO to the underlying device will be queued in generic_make_request
> > +		 * and will never complete, so will never reduce nr_pending.
> > +		 * So increment nr_waiting here so no new raise_barriers will
> > +		 * succeed, and so the second wait_barrier cannot block.
> > +		 */
> > +		spin_lock_irq(&conf->resync_lock);
> > +		conf->nr_waiting++;
> > +		spin_unlock_irq(&conf->resync_lock);
> > +
> >  		if (make_request(mddev, &bp->bio1))
> >  			generic_make_request(&bp->bio1);
> >  		if (make_request(mddev, &bp->bio2))
> >  			generic_make_request(&bp->bio2);
> >  
> > +		spin_lock_irq(&conf->resync_lock);
> > +		conf->nr_waiting--;
> > +		wake_up(&conf->wait_barrier);
> > +		spin_unlock_irq(&conf->resync_lock);
> > +
> >  		bio_pair_release(bp);
> >  		return 0;
> >  	bad_map:
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 


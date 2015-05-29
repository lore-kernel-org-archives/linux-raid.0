From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 1/4] raid5: wakeup raid5d when R5_ALLOC_MORE is set
Date: Thu, 28 May 2015 22:33:59 -0700
Message-ID: <20150529053340.GA2605536@devbig257.prn2.facebook.com>
References: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
 <20150529150256.6ca4211f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150529150256.6ca4211f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 29, 2015 at 03:02:56PM +1000, NeilBrown wrote:
> On Thu, 28 May 2015 17:33:45 -0700 Shaohua Li <shli@fb.com> wrote:
> 
> > The run time stripe allocation is done at raid5d. When we set the
> > R5_ALLOC_MORE flag, we should notify raid5d to handle it
> > 
> > Signed-off-by: Shaohua Li <shli@fb.com>
> > ---
> >  drivers/md/raid5.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 61e8e04..bfa2042 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -674,9 +674,11 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
> >  			if (!test_bit(R5_INACTIVE_BLOCKED, &conf->cache_state)) {
> >  				sh = get_free_stripe(conf, hash);
> >  				if (!sh && llist_empty(&conf->released_stripes) &&
> > -				    !test_bit(R5_DID_ALLOC, &conf->cache_state))
> > +				    !test_bit(R5_DID_ALLOC, &conf->cache_state)) {
> >  					set_bit(R5_ALLOC_MORE,
> >  						&conf->cache_state);
> > +					md_wakeup_thread(conf->mddev->thread);
> > +				}
> >  			}
> >  			if (noblock && sh == NULL)
> >  				break;
> 
> Thanks for reviewing my code !!!
> 
> I'm not exactly against this patch, but I wonder if it is really needed.
> R5_ALLOC_MORE is really just a hint - "You can allocate another stripe if you
> like".  If the array is at all busy, raid5d will be called fairly often and
> the allocation will happen.  If the array is idle, it doesn't matter if
> memory is allocated for a while.  Does it?

So this is related to the usage in my raid5 cache patch. Say I need
allocate 100 stripes and dispatch them together. If there are only 99
free stripes, I want to allocate a new one, but the 99 stripes will not
be handled and freed, we can't steal one from the 99 stripes. In this
case, I hope the automatically stripe allocation is reliable. Handling
the stripes together is to reduce disk cache flush. I can workaround the
issue in other way (by increasing min stripe number), but thought making
the allocation reliable is better.

Thanks,
Shaohua

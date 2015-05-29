From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 4/4] raid5: fix wakeup condition
Date: Thu, 28 May 2015 22:42:27 -0700
Message-ID: <20150529054208.GA2636793@devbig257.prn2.facebook.com>
References: <a92a0c36813c740c5de65a95b75ef161c1f2ede1.1432859513.git.shli@fb.com>
 <de048e4f0889e59ffb452f8b5f704bd888fcc1c1.1432859513.git.shli@fb.com>
 <20150529152316.0cd77069@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150529152316.0cd77069@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 29, 2015 at 03:23:16PM +1000, NeilBrown wrote:
> On Thu, 28 May 2015 17:33:48 -0700 Shaohua Li <shli@fb.com> wrote:
> 
> > Since we have several stripe hash list, the conf->active_stripes doesn't
> > determine if there is free stripe in a specific hash list, so delete the
> > check. After this, the R5_INACTIVE_BLOCKED check is inappropriate. There
> > is no point not to wakeup a task if there is free stripe.
> > 
> > Signed-off-by: Shaohua Li <shli@fb.com>
> > ---
> >  drivers/md/raid5.c | 6 +-----
> >  1 file changed, 1 insertion(+), 5 deletions(-)
> > 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 67626f3..4b5a03c 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -687,11 +687,7 @@ get_active_stripe(struct r5conf *conf, sector_t sector,
> >  					&conf->cache_state);
> >  				wait_event_lock_irq(
> >  					conf->wait_for_stripe,
> > -					!list_empty(conf->inactive_list + hash) &&
> > -					(atomic_read(&conf->active_stripes)
> > -					 < (conf->max_nr_stripes * 3 / 4)
> > -					 || !test_bit(R5_INACTIVE_BLOCKED,
> > -						      &conf->cache_state)),
> > +					!list_empty(conf->inactive_list + hash),
> >  					*(conf->hash_locks + hash));
> >  				clear_bit(R5_INACTIVE_BLOCKED,
> >  					  &conf->cache_state);
> 
> Have you actually tested this?  Because I do remember why I put that code in
> and it made a very real performance improvement.
> 
> The idea is that once we run out of free stripes, we wait until there a lots
> available.  That improves opportunities for batching.
> 
> So I would definitely needs some performance numbers with a patch like this.

I didn't realize this is related to performance. Your explaintation
makes a lot of sense, please ignore this.

Thanks,
Shaohua

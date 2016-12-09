From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/3] md: takeover should clear unrelated bits
Date: Thu, 8 Dec 2016 21:15:52 -0800
Message-ID: <20161209051552.hhvxpfyqns6nrahh@kernel.org>
References: <cover.1481240632.git.shli@fb.com>
 <8ba65915901de01043eb08cfadd07d65767776fb.1481240632.git.shli@fb.com>
 <87oa0l1zoo.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87oa0l1zoo.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Dec 09, 2016 at 03:41:59PM +1100, Neil Brown wrote:
> On Fri, Dec 09 2016, Shaohua Li wrote:
> 
> > When we change level from raid1 to raid5, the MD_FAILFAST_SUPPORTED bit
> > will be accidentally set, but raid5 doesn't support it. The same is true
> > for the MD_HAS_JOURNAL bit.
> >
> > Fix: 46533ff (md: Use REQ_FAILFAST_* on metadata writes where appropriate)
> > Cc: NeilBrown <neilb@suse.com>
> > Signed-off-by: Shaohua Li <shli@fb.com>
> > ---
> >  drivers/md/raid0.c | 5 +++++
> >  drivers/md/raid1.c | 5 ++++-
> >  drivers/md/raid5.c | 6 +++++-
> >  3 files changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> > index e628f18..a162fed 100644
> > --- a/drivers/md/raid0.c
> > +++ b/drivers/md/raid0.c
> > @@ -539,8 +539,11 @@ static void *raid0_takeover_raid45(struct mddev *mddev)
> >  	mddev->delta_disks = -1;
> >  	/* make sure it will be not marked as dirty */
> >  	mddev->recovery_cp = MaxSector;
> > +	clear_bit(MD_HAS_JOURNAL, &mddev->flags);
> > +	clear_bit(MD_JOURNAL_CLEAN, &mddev->flags);
> >  
> >  	create_strip_zones(mddev, &priv_conf);
> > +
> >  	return priv_conf;
> >  }
> 
> 
> This looks like a good fix, but it is a little fragile.
> If a new bit is added, we would need to go through all the takeover
> functions and check if it needs to be cleared, and we would forget.
> It might be better if each personality defined a VALID_MD_FLAGS or
> whatever, and the takeover function always did
>  set_mask_bits(&mddev->flags, 0, VALID_MD_FLAGS);

This is fragile indeed. My original idea is to clear the flags in level_store,
but it doesn't work well as different personablities have different valid
falgs. The suggestion looks good. Thanks for the review.

Thanks,
Shaohua

> 
> But that can come later.
> 
> Reviewed-by: NeilBrown <neilb@suse.com>
> 
> Thanks,
> NeilBrown
> 
> 
> >  
> > @@ -580,6 +583,7 @@ static void *raid0_takeover_raid10(struct mddev *mddev)
> >  	mddev->degraded = 0;
> >  	/* make sure it will be not marked as dirty */
> >  	mddev->recovery_cp = MaxSector;
> > +	clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
> >  
> >  	create_strip_zones(mddev, &priv_conf);
> >  	return priv_conf;
> > @@ -622,6 +626,7 @@ static void *raid0_takeover_raid1(struct mddev *mddev)
> >  	mddev->raid_disks = 1;
> >  	/* make sure it will be not marked as dirty */
> >  	mddev->recovery_cp = MaxSector;
> > +	clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
> >  
> >  	create_strip_zones(mddev, &priv_conf);
> >  	return priv_conf;
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index 94e0afc..efc2e74 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -3243,9 +3243,12 @@ static void *raid1_takeover(struct mddev *mddev)
> >  		mddev->new_layout = 0;
> >  		mddev->new_chunk_sectors = 0;
> >  		conf = setup_conf(mddev);
> > -		if (!IS_ERR(conf))
> > +		if (!IS_ERR(conf)) {
> >  			/* Array must appear to be quiesced */
> >  			conf->array_frozen = 1;
> > +			clear_bit(MD_HAS_JOURNAL, &mddev->flags);
> > +			clear_bit(MD_JOURNAL_CLEAN, &mddev->flags);
> > +		}
> >  		return conf;
> >  	}
> >  	return ERR_PTR(-EINVAL);
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 6bf3c26..3e6a2a0 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -7811,6 +7811,7 @@ static void *raid45_takeover_raid0(struct mddev *mddev, int level)
> >  static void *raid5_takeover_raid1(struct mddev *mddev)
> >  {
> >  	int chunksect;
> > +	void *ret;
> >  
> >  	if (mddev->raid_disks != 2 ||
> >  	    mddev->degraded > 1)
> > @@ -7832,7 +7833,10 @@ static void *raid5_takeover_raid1(struct mddev *mddev)
> >  	mddev->new_layout = ALGORITHM_LEFT_SYMMETRIC;
> >  	mddev->new_chunk_sectors = chunksect;
> >  
> > -	return setup_conf(mddev);
> > +	ret = setup_conf(mddev);
> > +	if (!IS_ERR_VALUE(ret))
> > +		clear_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
> > +	return ret;
> >  }
> >  
> >  static void *raid5_takeover_raid6(struct mddev *mddev)
> > -- 
> > 2.9.3
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



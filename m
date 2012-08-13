From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 6/7 v2] MD: raid5 trim support
Date: Mon, 13 Aug 2012 10:04:54 +0800
Message-ID: <20120813020454.GA447@kernel.org>
References: <20120810025113.050392766@kernel.org>
 <20120810025255.292192477@kernel.org>
 <20120813115051.64d5d44e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120813115051.64d5d44e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Shaohua Li <shli@fusionio.com>, linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

On Mon, Aug 13, 2012 at 11:50:51AM +1000, NeilBrown wrote:
> On Fri, 10 Aug 2012 10:51:19 +0800 Shaohua Li <shli@fusionio.com> wrote:
> 
> > @@ -4094,6 +4159,19 @@ static void make_request(struct mddev *m
> >  	bi->bi_next = NULL;
> >  	bi->bi_phys_segments = 1;	/* over-loaded to count active stripes */
> >  
> > +	/* block layer doesn't correctly do alignment even we set correct alignment */
> > +	if (unlikely(bi->bi_rw & REQ_DISCARD)) {
> > +		int stripe_sectors = conf->chunk_sectors *
> > +			(conf->raid_disks - conf->max_degraded);
> 
> This isn't right when an array is being reshaped.
> I suspect that during a reshape we should only attempt DISCARD on the part of
> the array which has already been reshaped.  On the other section we can
> either fail the discard (is that a good idea?) or write zeros.

I had a check in below for-loop for reshape, is it enough? If not, I'd like
just ignore discard request for reshape. We force discard_zero_data to be 0, so
should be ok.

I'll fix other two issues. Will repost the raid5 discard patches later.

Thanks,
Shaohua 

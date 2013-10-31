From: axboe <axboe@kernel.dk>
Subject: Re: [PATCH 3/3] md/raid5: For stripe with R5_ReadNoMerge, we replace
 REQ_FLUSH with REQ_NOMERGE.
Date: Thu, 31 Oct 2013 08:10:16 -0600
Message-ID: <20131031141016.GE10091@kernel.dk>
References: <2013103010414134402615@gmail.com>
 <20131031141056.1525429a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131031141056.1525429a@notabene.brown>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: majianpeng <majianpeng@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Oct 31 2013, NeilBrown wrote:
> On Wed, 30 Oct 2013 10:41:46 +0800 majianpeng <majianpeng@gmail.com> wrote:
> 
> > For R5_ReadNoMerge,it mean this bio can't merge with other bios or
> > request.It used REQ_FLUSH to achieve this. But REQ_NOMERGE can do the
> > same work.
> > 
> > Signed-off-by: Jianpeng Ma <majianpeng@gmail.com>
> > ---
> >  drivers/md/raid5.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index f8b9068..8e0aeaa 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -772,7 +772,7 @@ static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
> >  				bi->bi_sector = (sh->sector
> >  						 + rdev->data_offset);
> >  			if (test_bit(R5_ReadNoMerge, &sh->dev[i].flags))
> > -				bi->bi_rw |= REQ_FLUSH;
> > +				bi->bi_rw |= REQ_NOMERGE;
> >  
> >  			bi->bi_vcnt = 1;
> >  			bi->bi_io_vec[0].bv_len = STRIPE_SIZE;
> 
> Thanks.
> 
> I've queued this up pending Jens' acceptance of the other patches.

I've queued up the other two for 3.13.

-- 
Jens Axboe

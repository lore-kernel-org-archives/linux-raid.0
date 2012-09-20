From: Shaohua Li <shli@kernel.org>
Subject: Re: [patch 1/2]MD: raid5 trim support
Date: Thu, 20 Sep 2012 10:06:56 +0800
Message-ID: <20120920020656.GC6798@kernel.org>
References: <20120918082511.GA6298@kernel.org>
 <20120920111517.54d05380@notabene.brown>
 <20120920013642.GA6798@kernel.org>
 <20120920114740.7e2c2d1f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120920114740.7e2c2d1f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 20, 2012 at 11:47:40AM +1000, NeilBrown wrote:
> On Thu, 20 Sep 2012 09:36:42 +0800 Shaohua Li <shli@kernel.org> wrote:
> 
> > On Thu, Sep 20, 2012 at 11:15:17AM +1000, NeilBrown wrote:
> > > On Tue, 18 Sep 2012 16:25:11 +0800 Shaohua Li <shli@kernel.org> wrote:
> > > 
> > > > Discard for raid4/5/6 has limitation. If discard request size is small, we do
> > > > discard for one disk, but we need calculate parity and write parity disk.  To
> > > > correctly calculate parity, zero_after_discard must be guaranteed. Even it's
> > > > true, we need do discard for one disk but write another disks, which makes the
> > > > parity disks wear out fast. This doesn't make sense. So an efficient discard
> > > > for raid4/5/6 should discard all data disks and parity disks, which requires
> > > > the write pattern to be (A, A+chunk_size, A+chunk_size*2...). If A's size is
> > > > smaller than chunk_size, such pattern is almost impossible in practice. So in
> > > > this patch, I only handle the case that A's size equals to chunk_size. That is
> > > > discard request should be aligned to stripe size and its size is multiple of
> > > > stripe size.
> > > > 
> > > > Since we can only handle request with specific alignment and size (or part of
> > > > the request fitting stripes), we can't guarantee zero_after_discard even
> > > > zero_after_discard is true in low level drives.
> > > > 
> > > > The block layer doesn't send down correctly aligned requests even correct
> > > > discard alignment is set, so I must filter out.
> > > > 
> > > > For raid4/5/6 parity calculation, if data is 0, parity is 0. So if
> > > > zero_after_discard is true for all disks, data is consistent after discard.
> > > > Otherwise, data might be lost. Let's consider a scenario: discard a stripe,
> > > > write data to one disk and write parity disk. The stripe could be still
> > > > inconsistent till then depending on using data from other data disks or parity
> > > > disks to calculate new parity. If the disk is broken, we can't restore it. So
> > > > in this patch, we only enable discard support if all disks have
> > > > zero_after_discard.
> > > > 
> > > > If discard fails in one disk, we face the similar inconsistent issue above. The
> > > > patch will make discard follow the same path as normal write request. If
> > > > discard fails, a resync will be scheduled to make the data consistent. This
> > > > isn't good to have extra writes, but data consistency is important.
> > > > 
> > > > If a subsequent read/write request hits raid5 cache of a discarded stripe, the
> > > > discarded dev page should have zero filled, so the data is consistent. This
> > > > patch will always zero dev page for discarded request stripe. This isn't
> > > > optimal because discard request doesn't need such payload. Next patch will
> > > > avoid it.
> > > > 
> > > > Signed-off-by: Shaohua Li <shli@fusionio.com>
> > > > ---
> > > >  drivers/md/raid5.c |  176 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
> > > >  drivers/md/raid5.h |    1 
> > > >  2 files changed, 174 insertions(+), 3 deletions(-)
> > > > 
> > > > Index: linux/drivers/md/raid5.c
> > > > ===================================================================
> > > > --- linux.orig/drivers/md/raid5.c	2012-09-18 16:15:51.219353357 +0800
> > > > +++ linux/drivers/md/raid5.c	2012-09-18 16:15:55.471299904 +0800
> > > > @@ -547,6 +547,8 @@ static void ops_run_io(struct stripe_hea
> > > >  				rw = WRITE_FUA;
> > > >  			else
> > > >  				rw = WRITE;
> > > > +			if (test_and_clear_bit(R5_Discard, &sh->dev[i].flags))
> > > > +				rw |= REQ_DISCARD;
> > > >  		} else if (test_and_clear_bit(R5_Wantread, &sh->dev[i].flags))
> > > >  			rw = READ;
> > > >  		else if (test_and_clear_bit(R5_WantReplace,
> > > > @@ -1170,8 +1172,13 @@ ops_run_biodrain(struct stripe_head *sh,
> > > >  					set_bit(R5_WantFUA, &dev->flags);
> > > >  				if (wbi->bi_rw & REQ_SYNC)
> > > >  					set_bit(R5_SyncIO, &dev->flags);
> > > > -				tx = async_copy_data(1, wbi, dev->page,
> > > > -					dev->sector, tx);
> > > > +				if (wbi->bi_rw & REQ_DISCARD) {
> > > > +					memset(page_address(dev->page), 0,
> > > > +						STRIPE_SECTORS << 9);
> > > > +					set_bit(R5_Discard, &dev->flags);
> > > > +				} else
> > > > +					tx = async_copy_data(1, wbi, dev->page,
> > > > +						dev->sector, tx);
> > > >  				wbi = r5_next_bio(wbi, dev->sector);
> > > >  			}
> > > >  		}
> > > > @@ -1237,6 +1244,20 @@ ops_run_reconstruct5(struct stripe_head
> > > >  	pr_debug("%s: stripe %llu\n", __func__,
> > > >  		(unsigned long long)sh->sector);
> > > >  
> > > > +	for (i = 0; i < sh->disks; i++) {
> > > > +		if (pd_idx == i)
> > > > +			continue;
> > > > +		if (!test_bit(R5_Discard, &sh->dev[i].flags))
> > > > +			break;
> > > > +	}
> > > > +	if (i >= sh->disks) {
> > > > +		atomic_inc(&sh->count);
> > > > +		memset(page_address(sh->dev[pd_idx].page), 0,
> > > > +			STRIPE_SECTORS << 9);
> > > > +		set_bit(R5_Discard, &sh->dev[pd_idx].flags);
> > > > +		ops_complete_reconstruct(sh);
> > > > +		return;
> > > > +	}
> > > >  	/* check if prexor is active which means only process blocks
> > > >  	 * that are part of a read-modify-write (written)
> > > >  	 */
> > > > @@ -1281,10 +1302,28 @@ ops_run_reconstruct6(struct stripe_head
> > > >  {
> > > >  	struct async_submit_ctl submit;
> > > >  	struct page **blocks = percpu->scribble;
> > > > -	int count;
> > > > +	int count, i;
> > > >  
> > > >  	pr_debug("%s: stripe %llu\n", __func__, (unsigned long long)sh->sector);
> > > >  
> > > > +	for (i = 0; i < sh->disks; i++) {
> > > > +		if (sh->pd_idx == i || sh->qd_idx == i)
> > > > +			continue;
> > > > +		if (!test_bit(R5_Discard, &sh->dev[i].flags))
> > > > +			break;
> > > > +	}
> > > > +	if (i >= sh->disks) {
> > > > +		atomic_inc(&sh->count);
> > > > +		memset(page_address(sh->dev[sh->pd_idx].page), 0,
> > > > +			STRIPE_SECTORS << 9);
> > > > +		memset(page_address(sh->dev[sh->qd_idx].page), 0,
> > > > +			STRIPE_SECTORS << 9);
> > > > +		set_bit(R5_Discard, &sh->dev[sh->pd_idx].flags);
> > > > +		set_bit(R5_Discard, &sh->dev[sh->qd_idx].flags);
> > > > +		ops_complete_reconstruct(sh);
> > > > +		return;
> > > > +	}
> > > > +
> > > >  	count = set_syndrome_sources(blocks, sh);
> > > >  
> > > >  	atomic_inc(&sh->count);
> > > > @@ -4067,6 +4106,96 @@ static void release_stripe_plug(struct m
> > > >  		release_stripe(sh);
> > > >  }
> > > >  
> > > > +static void make_discard_request(struct mddev *mddev, struct bio *bi)
> > > > +{
> > > > +	struct r5conf *conf = mddev->private;
> > > > +	sector_t logical_sector, last_sector;
> > > > +	struct stripe_head *sh;
> > > > +	int remaining;
> > > > +	int stripe_sectors;
> > > > +
> > > > +	if (mddev->reshape_position != MaxSector)
> > > > +		/* Skip discard while reshape is happening */
> > > > +		return;
> > > > +
> > > > +	logical_sector = bi->bi_sector & ~((sector_t)STRIPE_SECTORS-1);
> > > > +	last_sector = bi->bi_sector + (bi->bi_size>>9);
> > > > +
> > > > +	bi->bi_next = NULL;
> > > > +	bi->bi_phys_segments = 1; /* over-loaded to count active stripes */
> > > > +
> > > > +	stripe_sectors = conf->chunk_sectors *
> > > > +		(conf->raid_disks - conf->max_degraded);
> > > > +	logical_sector = DIV_ROUND_UP_SECTOR_T(logical_sector,
> > > > +			stripe_sectors);
> > > > +	sector_div(last_sector, stripe_sectors);
> > > > +
> > > > +	logical_sector *= stripe_sectors;
> > > > +	last_sector *= stripe_sectors;
> > > > +
> > > > +	for (;logical_sector < last_sector;
> > > > +					logical_sector += STRIPE_SECTORS) {
> > > > +		DEFINE_WAIT(w);
> > > > +		sector_t new_sector;
> > > > +		int d;
> > > > +
> > > > +		new_sector = raid5_compute_sector(conf, logical_sector,
> > > > +						  0, &d, NULL);
> > > 
> > > This is pointless.  Look at the patch I posted again.  You don't need to call
> > > raid5_compute_sector().  It essentially just divides logical_sector by
> > > stripe_sectors.  It is cleaner not to do the multiple in the first place.
> > 
> > in my test, without it, wrong sectors are trimmed.
> 
> Which tells me that the code you tested was wrong.
> However the code you posted was wrong too.
> 
> Maybe if you post the code you tested and which looked more like mine, and
> explain which wrong sectors were trimmed....

Ah, I missed 'It is cleaner not to do the multiple in the first place.'.  Let
me check again.

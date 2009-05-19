From: raz ben yehuda <raziebe@gmail.com>
Subject: Re: Subject [ md PATCH 4/6] : md to support page size chunks in
	the case of raid 0
Date: Tue, 19 May 2009 13:17:07 +0300
Message-ID: <1242728227.3293.11.camel@raz>
References: <1242687989.21201.16.camel@raz>
	 <18962.444.630305.895248@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18962.444.630305.895248@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Tue, 2009-05-19 at 10:47 +1000, Neil Brown wrote:
> On Tuesday May 19, raziebe@gmail.com wrote:
> > md to support page size chunks in the case of raid 0
> > Signed-off-by: raziebe@gmail.com
> >  md.c |   28 +++++++++++++++++++++-------
> >  1 file changed, 21 insertions(+), 7 deletions(-)
> > ---
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 279007a..aab183e 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -443,9 +443,13 @@ static inline sector_t calc_dev_sboffset(struct block_device *bdev)
> >  static sector_t calc_num_sectors(mdk_rdev_t *rdev, unsigned chunk_size)
> >  {
> >  	sector_t num_sectors = rdev->sb_start;
> > +	if (chunk_size) {
> > +		sector_t chunk_sects = chunk_size>>9;
> > +		sector_t x = num_sectors;
> > +		sector_div(x, chunk_sects);
> > +		num_sectors = x*chunk_sects;
> > +	}
> >  
> > -	if (chunk_size)
> > -		num_sectors &= ~((sector_t)chunk_size/512 - 1);
> >  	return num_sectors;
> >  }
> 
> That's OK.... though you have removed the blank line separating the
> variable declarations from the code.  I like to keep that blank line
> there.
> And you have added a blank line before the "return", which I only
> mention because.....
> 
> >  
> > @@ -3518,11 +3522,11 @@ min_sync_store(mddev_t *mddev, const char *buf, size_t len)
> >  
> >  	/* Must be a multiple of chunk_size */
> >  	if (mddev->chunk_size) {
> > -		if (min & (sector_t)((mddev->chunk_size>>9)-1))
> > +		unsigned long long temp = min;
> > +		if (sector_div(temp, (mddev->chunk_size>>9)))
> >  			return -EINVAL;
> >  	}
> >  	mddev->resync_min = min;
> > -
> >  	return len;
> >  }
> 
> You have removed the blank line before the return here ??? consistency
> is a good thing.
> 
> And 'temp' should be 'sector_t'.  'sector_div' requires a 'sector_t'
> for the first argument.
> 
> 
> >  
> > @@ -3555,7 +3559,8 @@ max_sync_store(mddev_t *mddev, const char *buf, size_t len)
> >  
> >  		/* Must be a multiple of chunk_size */
> >  		if (mddev->chunk_size) {
> > -			if (max & (sector_t)((mddev->chunk_size>>9)-1))
> > +			unsigned long long temp = max;
> > +			if (sector_div(temp, (mddev->chunk_size>>9)))
> >  				return -EINVAL;
> 
> Again, temp must be sector_t.
> 
> >  		}
> >  		mddev->resync_max = max;
> > @@ -3996,14 +4001,23 @@ static int do_md_run(mddev_t * mddev)
> >  				chunk_size, MAX_CHUNK_SIZE);
> >  			return -EINVAL;
> >  		}
> > +
> >  		/*
> >  		 * chunk-size has to be a power of 2
> >  		 */
> > -		if ( (1 << ffz(~chunk_size)) != chunk_size) {
> > +		if ((1 << ffz(~chunk_size)) != chunk_size &&
> > +			 mddev->level != 0) {
> >  			printk(KERN_ERR "chunk_size of %d not valid\n", chunk_size);
> >  			return -EINVAL;
> >  		}
> 
> I wold really like to remove any knowledge about specific raid levels
> from the common (md.c) code and keep it all in the personality modules
> (is that a job for you Andre ??).
> So I definitely don't want to add a test for ->level here.
> 
> So I would like to see the tests for chunk_size removed do_md_run and
> included in each personalities ->run function.  This would be a series
> of patches that adds the checks in ->run where needed, then removes it
> from md.c.  Would you like to do that?
yes. As i understand , patch will not be accepted without it. 
> 
> > -
> > +		/*
> > +		* raid0 chunk size has to divide by a page
> > +		*/
> > +		if (mddev->level == 0 && (chunk_size % PAGE_SIZE)) {
> > +			printk(KERN_ERR "chunk_size of %d not valid\n",
> > +				chunk_size);
> > +			return -EINVAL;
> > +		}
> 
> Why should the chunk_size be a multiple of PAGE_SIZE?
> I suspect it should be a multiple of hardsect_size for each component
> device (which, thanks to blk_queue_stack_limits, we can check by just
> checking the hardsect_size of the mddev device after all the calls to
> blk_queue_stack_limits in create_strip_zones, or in raid0_run.
> And again, these checks need to move to raid0.c
i can. but it means we have to fix mdadm to get sectors and not
kilobytes. if you want, i can do it **after the reshape**. 
> 
> 
> Thanks,
> NeilBrown


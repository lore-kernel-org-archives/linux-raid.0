From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH --resend 1/2] md: disable WRITE SAME if it fails for
 linear/raid0
Date: Mon, 13 Feb 2017 16:04:19 -0800
Message-ID: <20170214000419.nvwxxdd3adlvd4zf@kernel.org>
References: <cover.1487015420.git.shli@fb.com>
 <c98a106b47626695f3b6976b616230da4b638df8.1487015420.git.shli@fb.com>
 <8737fh4pzr.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8737fh4pzr.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 14, 2017 at 10:42:32AM +1100, Neil Brown wrote:
> On Mon, Feb 13 2017, Shaohua Li wrote:
> 
> > This makes md do the same thing as dm for write same IO failure. Please
> > see 7eee4ae(dm: disable WRITE SAME if it fails) for details why we need
> > this.
> >
> > Also reported here: https://bugzilla.kernel.org/show_bug.cgi?id=118581
> >
> > Signed-off-by: Shaohua Li <shli@fb.com>
> > ---
> >  drivers/md/linear.c |  6 +++++-
> >  drivers/md/md.c     | 45 +++++++++++++++++++++++++++++++++++++++++++++
> >  drivers/md/md.h     |  2 ++
> >  drivers/md/raid0.c  |  6 +++++-
> >  4 files changed, 57 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/linear.c b/drivers/md/linear.c
> > index 26a73b2..bebc834 100644
> > --- a/drivers/md/linear.c
> > +++ b/drivers/md/linear.c
> > @@ -291,7 +291,11 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
> >  				trace_block_bio_remap(bdev_get_queue(split->bi_bdev),
> >  						      split, disk_devt(mddev->gendisk),
> >  						      bio_sector);
> > -			generic_make_request(split);
> > +			if (bio_op(split) == REQ_OP_WRITE_SAME)
> > +				generic_make_request(md_writesame_setup(mddev,
> > +								split));
> > +			else
> > +				generic_make_request(split);
> >  		}
> >  	} while (split != bio);
> >  	return;
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 13020e5..7354f0b 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -312,6 +312,51 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
> >  	return BLK_QC_T_NONE;
> >  }
> >  
> > +struct md_writesame_data {
> > +	struct bio *orig_bio;
> > +	struct mddev *mddev;
> > +	struct bio cloned_bio;
> > +};
> > +
> > +static void md_writesame_endio(struct bio *bio)
> > +{
> > +	struct md_writesame_data *data = bio->bi_private;
> > +
> > +	if (bio->bi_error == -EREMOTEIO &&
> > +	    !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
> > +		data->mddev->queue->limits.max_write_same_sectors = 0;
> 
> What would be *really* nice is if a block device could send a
> reconfigure message to its 'holder' (bd_holder).  This could include
> device size changes and, for this, changes to max_write_same_sectors.
> There are probably other changes that can usefully be propagated.
> 
> But for this patch, wouldn't it be easier, and maybe more efficient, to
> do
> 
>   if (bio_op(split) == REQ_OP_WRITE_SAME &&
>       !bdev_get_queue(bio->bi_bdev)->limits.max_write_same_sectors)
>            mddev->queue->limits.max_write_same_sectors = 0;
>   generic_make_request(split);
> 
> ???
> If there is some reason that can't work, then the patch as it stands
> look OK to me.

So we don't disable writesame in the first IO error and do it until a new
writesame comes? Good idea and much simpler! Let me check if it works.

Thanks,
Shaohua

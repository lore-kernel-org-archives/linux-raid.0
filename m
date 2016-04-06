From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [PATCH 11/27] bcache: io.c: use bio_set_vec_table
Date: Tue, 5 Apr 2016 16:35:07 -0800
Message-ID: <20160406003507.GD31161@kmo-pixel>
References: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
 <1459857443-20611-12-git-send-email-tom.leiming@gmail.com>
 <20160405124902.GA11986@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160405124902.GA11986@infradead.org>
Sender: linux-bcache-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, Boaz Harrosh <boaz@plexistor.com>, Shaohua Li <shli@kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Apr 05, 2016 at 05:49:02AM -0700, Christoph Hellwig wrote:
> On Tue, Apr 05, 2016 at 07:56:56PM +0800, Ming Lei wrote:
> > diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
> > index 86a0bb8..1c48462 100644
> > --- a/drivers/md/bcache/io.c
> > +++ b/drivers/md/bcache/io.c
> > @@ -26,8 +26,7 @@ struct bio *bch_bbio_alloc(struct cache_set *c)
> >  
> >  	bio_init(bio);
> >  	bio->bi_flags		|= BIO_POOL_NONE << BIO_POOL_OFFSET;
> > -	bio->bi_max_vecs	 = bucket_pages(c);
> > -	bio->bi_io_vec		 = bio->bi_inline_vecs;
> > +	bio_set_vec_table(bio, bio->bi_inline_vecs, bucket_pages(c));
> 
> All this bcache code needs to move away from bio_init on a bio
> embedded in a driver private structure toward properly using
> bio_alloc / bio_alloc_bioset.  That will also fix the crash
> with bcache over md that Shaohua reported, so I'd suggest to fast
> track this part of the series.

Why?

bio_init() is a publicly exported function, it's always been one and bcache is
ot the only driver to use it directly.

bios with > BIO_MAX_PAGES bvecs is a separate issue; I would argue that the bug
is in md's queue_limits; it uses blk_set_stacking_limits() which sets
max_segments = USHRT_MAX, which is wrong if it's going to clone the biovec.

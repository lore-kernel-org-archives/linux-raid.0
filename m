From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] block: call trace_block_split() from bio_split()
Date: Fri, 18 Nov 2016 04:55:33 -0800
Message-ID: <20161118125533.GA27741@infradead.org>
References: <87vavlfsar.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87vavlfsar.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 18, 2016 at 01:14:20PM +1100, NeilBrown wrote:
> 
> 
> Somewhere around
> Commit: 20d0189b1012 ("block: Introduce new bio_split()")
> and
> Commit: 4b1faf931650 ("block: Kill bio_pair_split()")
> 
> in 3.14 we lost the call to trace_block_split() from bio_split().
> 
> Commit: cda22646adaa ("block: add call to split trace point")
> 
> in 4.5 added it back for blk_queue_split(), but not for other users of
> bio_split(), and particularly not for md/raid.
> 
> This patch moves the trace_block_split() call from blk_queue_split()
> to bio_split().
> As blk_queue_split() calls bio_split() (via various helper functions)
> the same events that were traced before will still be traced.
> 
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  block/bio.c       | 1 +
>  block/blk-merge.c | 1 -
>  2 files changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index db85c5753a76..212ea95a7401 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1804,6 +1804,7 @@ struct bio *bio_split(struct bio *bio, int sectors,
>  		bio_integrity_trim(split, 0, sectors);
>  
>  	bio_advance(bio, split->bi_iter.bi_size);
> +	trace_block_split(bdev_get_queue(bio->bi_bdev), split, bio->bi_iter.bi_sector);

This line needs to be wrapped.

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

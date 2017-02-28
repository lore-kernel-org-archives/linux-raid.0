From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 09/13] md: raid1: use bio_segments_all()
Date: Tue, 28 Feb 2017 15:42:12 -0800
Message-ID: <20170228234212.3wjwxsegg4v57nxu@kernel.org>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
 <1488296503-4987-10-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488296503-4987-10-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Tue, Feb 28, 2017 at 11:41:39PM +0800, Ming Lei wrote:
> Use this helper, instead of direct access to .bi_vcnt.

what We really need to do for the behind IO is:
- allocate memory and copy bio data to the memory
- let behind bio do IO against the memory

The behind bio doesn't need to have the exactly same bio_vec setting. If we
just track the new memory, we don't need use the bio_segments_all and access
bio_vec too.

Thanks,
Shaohua
 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/md/raid1.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 316bd6dd6cc1..7396c99ff7b1 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1091,7 +1091,8 @@ static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
>  {
>  	int i;
>  	struct bio_vec *bvec;
> -	struct bio_vec *bvecs = kzalloc(bio->bi_vcnt * sizeof(struct bio_vec),
> +	unsigned vcnt = bio_segments_all(bio);
> +	struct bio_vec *bvecs = kzalloc(vcnt * sizeof(struct bio_vec),
>  					GFP_NOIO);
>  	if (unlikely(!bvecs))
>  		return;
> @@ -1107,12 +1108,12 @@ static void alloc_behind_pages(struct bio *bio, struct r1bio *r1_bio)
>  		kunmap(bvec->bv_page);
>  	}
>  	r1_bio->behind_bvecs = bvecs;
> -	r1_bio->behind_page_count = bio->bi_vcnt;
> +	r1_bio->behind_page_count = vcnt;
>  	set_bit(R1BIO_BehindIO, &r1_bio->state);
>  	return;
>  
>  do_sync_io:
> -	for (i = 0; i < bio->bi_vcnt; i++)
> +	for (i = 0; i < vcnt; i++)
>  		if (bvecs[i].bv_page)
>  			put_page(bvecs[i].bv_page);
>  	kfree(bvecs);
> -- 
> 2.7.4
> 

From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v3 08/14] block: introduce bio_copy_data_partial
Date: Thu, 23 Mar 2017 22:34:20 -0700
Message-ID: <20170324053420.6q4zzlmk3gg5o6tv@kernel.org>
References: <20170316161235.27110-1-tom.leiming@gmail.com>
 <20170316161235.27110-9-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170316161235.27110-9-tom.leiming@gmail.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

Jens,
can you look at this patch? If it's ok, I'd like to route it through md tree.

Thanks,
Shaohua

On Fri, Mar 17, 2017 at 12:12:29AM +0800, Ming Lei wrote:
> Turns out we can use bio_copy_data in raid1's write behind,
> and we can make alloc_behind_pages() more clean/efficient,
> but we need to partial version of bio_copy_data().
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  block/bio.c         | 60 +++++++++++++++++++++++++++++++++++++++++------------
>  include/linux/bio.h |  2 ++
>  2 files changed, 49 insertions(+), 13 deletions(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index e75878f8b14a..1ccff0dace89 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -1025,19 +1025,8 @@ int bio_alloc_pages(struct bio *bio, gfp_t gfp_mask)
>  }
>  EXPORT_SYMBOL(bio_alloc_pages);
>  
> -/**
> - * bio_copy_data - copy contents of data buffers from one chain of bios to
> - * another
> - * @src: source bio list
> - * @dst: destination bio list
> - *
> - * If @src and @dst are single bios, bi_next must be NULL - otherwise, treats
> - * @src and @dst as linked lists of bios.
> - *
> - * Stops when it reaches the end of either @src or @dst - that is, copies
> - * min(src->bi_size, dst->bi_size) bytes (or the equivalent for lists of bios).
> - */
> -void bio_copy_data(struct bio *dst, struct bio *src)
> +static void __bio_copy_data(struct bio *dst, struct bio *src,
> +			    int offset, int size)
>  {
>  	struct bvec_iter src_iter, dst_iter;
>  	struct bio_vec src_bv, dst_bv;
> @@ -1047,6 +1036,12 @@ void bio_copy_data(struct bio *dst, struct bio *src)
>  	src_iter = src->bi_iter;
>  	dst_iter = dst->bi_iter;
>  
> +	/* for supporting partial copy */
> +	if (offset || size != src->bi_iter.bi_size) {
> +		bio_advance_iter(src, &src_iter, offset);
> +		src_iter.bi_size = size;
> +	}
> +
>  	while (1) {
>  		if (!src_iter.bi_size) {
>  			src = src->bi_next;
> @@ -1083,8 +1078,47 @@ void bio_copy_data(struct bio *dst, struct bio *src)
>  		bio_advance_iter(dst, &dst_iter, bytes);
>  	}
>  }
> +
> +/**
> + * bio_copy_data - copy contents of data buffers from one chain of bios to
> + * another
> + * @src: source bio list
> + * @dst: destination bio list
> + *
> + * If @src and @dst are single bios, bi_next must be NULL - otherwise, treats
> + * @src and @dst as linked lists of bios.
> + *
> + * Stops when it reaches the end of either @src or @dst - that is, copies
> + * min(src->bi_size, dst->bi_size) bytes (or the equivalent for lists of bios).
> + */
> +void bio_copy_data(struct bio *dst, struct bio *src)
> +{
> +	__bio_copy_data(dst, src, 0, src->bi_iter.bi_size);
> +}
>  EXPORT_SYMBOL(bio_copy_data);
>  
> +/**
> + * bio_copy_data_partial - copy partial contents of data buffers from one
> + * chain of bios to another
> + * @dst: destination bio list
> + * @src: source bio list
> + * @offset: starting copy from the offset
> + * @size: how many bytes to copy
> + *
> + * If @src and @dst are single bios, bi_next must be NULL - otherwise, treats
> + * @src and @dst as linked lists of bios.
> + *
> + * Stops when it reaches the end of either @src or @dst - that is, copies
> + * min(src->bi_size, dst->bi_size) bytes (or the equivalent for lists of bios).
> + */
> +void bio_copy_data_partial(struct bio *dst, struct bio *src,
> +			   int offset, int size)
> +{
> +	__bio_copy_data(dst, src, offset, size);
> +
> +}
> +EXPORT_SYMBOL(bio_copy_data_partial);
> +
>  struct bio_map_data {
>  	int is_our_pages;
>  	struct iov_iter iter;
> diff --git a/include/linux/bio.h b/include/linux/bio.h
> index 8e521194f6fc..42b62a0288b0 100644
> --- a/include/linux/bio.h
> +++ b/include/linux/bio.h
> @@ -468,6 +468,8 @@ static inline void bio_flush_dcache_pages(struct bio *bi)
>  #endif
>  
>  extern void bio_copy_data(struct bio *dst, struct bio *src);
> +extern void bio_copy_data_partial(struct bio *dst, struct bio *src,
> +				  int offset, int size);
>  extern int bio_alloc_pages(struct bio *bio, gfp_t gfp);
>  extern void bio_free_pages(struct bio *bio);
>  
> -- 
> 2.9.3
> 

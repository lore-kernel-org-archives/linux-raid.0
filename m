From: Coly Li <i@coly.li>
Subject: Re: [PATCH v1 08/54] block: comment on bio_alloc_pages()
Date: Fri, 30 Dec 2016 18:40:16 +0800
Message-ID: <fe35d1e8-3d3f-9857-d236-cbc26016e0b2@coly.li>
References: <1482854250-13481-1-git-send-email-tom.leiming@gmail.com>
 <1482854250-13481-9-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <1482854250-13481-9-git-send-email-tom.leiming@gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>, Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, Mike Christie <mchristi@redhat.com>, Guoqing Jiang <gqjiang@suse.com>, Hannes Reinecke <hare@suse.com>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2016/12/27 下午11:55, Ming Lei wrote:
> This patch adds comment on usage of bio_alloc_pages(),
> also comments on one special case of bch_data_verify().
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  block/bio.c               | 4 +++-
>  drivers/md/bcache/debug.c | 6 ++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/block/bio.c b/block/bio.c
> index 2b375020fc49..d4a1e0b63ea0 100644
> --- a/block/bio.c
> +++ b/block/bio.c
> @@ -961,7 +961,9 @@ EXPORT_SYMBOL(bio_advance);
>   * @bio: bio to allocate pages for
>   * @gfp_mask: flags for allocation
>   *
> - * Allocates pages up to @bio->bi_vcnt.
> + * Allocates pages up to @bio->bi_vcnt, and this function should only
> + * be called on a new initialized bio, which means all pages aren't added
> + * to the bio via bio_add_page() yet.
>   *
>   * Returns 0 on success, -ENOMEM on failure. On failure, any allocated pages are
>   * freed.
> diff --git a/drivers/md/bcache/debug.c b/drivers/md/bcache/debug.c
> index 06f55056aaae..48d03e8b3385 100644
> --- a/drivers/md/bcache/debug.c
> +++ b/drivers/md/bcache/debug.c
> @@ -110,6 +110,12 @@ void bch_data_verify(struct cached_dev *dc, struct bio *bio)
>  	struct bio_vec bv, cbv;
>  	struct bvec_iter iter, citer = { 0 };
>  
> +	/*
> +	 * Once multipage bvec is supported, the bio_clone()
> +	 * has to make sure page count in this bio can be held
> +	 * in the new cloned bio because each single page need
> +	 * to assign to each bvec of the new bio.
> +	 */
>  	check = bio_clone(bio, GFP_NOIO);
>  	if (!check)
>  		return;
> 
Acked-by: Coly Li <colyli@suse.de>

-- 
Coly Li

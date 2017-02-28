From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 04/13] md: prepare for managing resync I/O pages in
 clean way
Date: Tue, 28 Feb 2017 15:30:11 -0800
Message-ID: <20170228233011.rdqtde22zwsimbz7@kernel.org>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
 <1488296503-4987-5-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488296503-4987-5-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Tue, Feb 28, 2017 at 11:41:34PM +0800, Ming Lei wrote:
> Now resync I/O use bio's bec table to manage pages,
> this way is very hacky, and may not work any more
> once multipage bvec is introduced.
> 
> So introduce helpers and new data structure for
> managing resync I/O pages more cleanly.
> 
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/md/md.h | 54 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 54 insertions(+)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 1d63239a1be4..b5a638d85cb4 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -720,4 +720,58 @@ static inline void mddev_check_writesame(struct mddev *mddev, struct bio *bio)
>  #define RESYNC_BLOCK_SIZE (64*1024)
>  #define RESYNC_PAGES ((RESYNC_BLOCK_SIZE + PAGE_SIZE-1) / PAGE_SIZE)
>  
> +/* for managing resync I/O pages */
> +struct resync_pages {
> +	unsigned	idx;	/* for get/put page from the pool */
> +	void		*raid_bio;
> +	struct page	*pages[RESYNC_PAGES];
> +};

I'd like this to be embedded into r1bio directly. Not sure if we really need a
structure.

> +
> +static inline int resync_alloc_pages(struct resync_pages *rp,
> +				     gfp_t gfp_flags)
> +{
> +	int i;
> +
> +	for (i = 0; i < RESYNC_PAGES; i++) {
> +		rp->pages[i] = alloc_page(gfp_flags);
> +		if (!rp->pages[i])
> +			goto out_free;
> +	}
> +
> +	return 0;
> +
> + out_free:
> +	while (--i >= 0)
> +		__free_page(rp->pages[i]);
> +	return -ENOMEM;
> +}
> +
> +static inline void resync_free_pages(struct resync_pages *rp)
> +{
> +	int i;
> +
> +	for (i = 0; i < RESYNC_PAGES; i++)
> +		__free_page(rp->pages[i]);

Since we will use get_page, shouldn't this be put_page?

> +}
> +
> +static inline void resync_get_all_pages(struct resync_pages *rp)
> +{
> +	int i;
> +
> +	for (i = 0; i < RESYNC_PAGES; i++)
> +		get_page(rp->pages[i]);
> +}
> +
> +static inline struct page *resync_fetch_page(struct resync_pages *rp)
> +{
> +	if (WARN_ON_ONCE(rp->idx >= RESYNC_PAGES))
> +		return NULL;
> +	return rp->pages[rp->idx++];

I'd like the caller explicitly specify the index instead of a global variable
to track it, which will make the code more understandable and less error prone.

> +}
> +
> +static inline bool resync_page_available(struct resync_pages *rp)
> +{
> +	return rp->idx < RESYNC_PAGES;
> +}

Then we don't need this obscure API.

Thanks,
Shaohua

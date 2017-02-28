From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 06/13] md: raid1: don't use bio's vec table to manage
 resync pages
Date: Tue, 28 Feb 2017 15:37:16 -0800
Message-ID: <20170228233716.v3izfseg3dpdyexc@kernel.org>
References: <1488296503-4987-1-git-send-email-tom.leiming@gmail.com>
 <1488296503-4987-7-git-send-email-tom.leiming@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1488296503-4987-7-git-send-email-tom.leiming@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Tue, Feb 28, 2017 at 11:41:36PM +0800, Ming Lei wrote:
> Now we allocate one page array for managing resync pages, instead
> of using bio's vec table to do that, and the old way is very hacky
> and won't work any more if multipage bvec is enabled.
> 
> The introduced cost is that we need to allocate (128 + 16) * raid_disks
> bytes per r1_bio, and it is fine because the inflight r1_bio for
> resync shouldn't be much, as pointed by Shaohua.
> 
> Also the bio_reset() in raid1_sync_request() is removed because
> all bios are freshly new now and not necessary to reset any more.
> 
> This patch can be thought as a cleanup too
> 
> Suggested-by: Shaohua Li <shli@kernel.org>
> Signed-off-by: Ming Lei <tom.leiming@gmail.com>
> ---
>  drivers/md/raid1.c | 83 ++++++++++++++++++++++++++++++++++--------------------
>  1 file changed, 53 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index c442b4657e2f..900144f39630 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -77,6 +77,16 @@ static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
>  #define raid1_log(md, fmt, args...)				\
>  	do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid1 " fmt, ##args); } while (0)
>  
> +static inline struct resync_pages *get_resync_pages(struct bio *bio)
> +{
> +	return bio->bi_private;
> +}
> +
> +static inline struct r1bio *get_resync_r1bio(struct bio *bio)
> +{
> +	return get_resync_pages(bio)->raid_bio;
> +}

This is a weird between bio, r1bio and the resync_pages. I'd like the pages are
embedded in r1bio. Maybe a pointer of r1bio to the pages. It's cleaner and more
straightforward.

I think the patch 6, 7 8 should be in a same patch. Otherwise bisect will be broken.

Thanks,
Shaohua

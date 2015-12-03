From: Shaohua Li <shli@fb.com>
Subject: Re: [PATCH 1/2] raid5-cache: use a bio_set
Date: Wed, 2 Dec 2015 21:01:05 -0800
Message-ID: <20151203050056.GC3111265@devbig084.prn1.facebook.com>
References: <1449072638-15409-1-git-send-email-hch@lst.de>
 <1449072638-15409-2-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449072638-15409-2-git-send-email-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: neilb@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Dec 02, 2015 at 05:10:37PM +0100, Christoph Hellwig wrote:
> This allows us to make guaranteed forward progress.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/md/raid5-cache.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 668e973..ef59564 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -34,6 +34,12 @@
>  #define RECLAIM_MAX_FREE_SPACE (10 * 1024 * 1024 * 2) /* sector */
>  #define RECLAIM_MAX_FREE_SPACE_SHIFT (2)
>  
> +/*
> + * We only need 2 bios per I/O unit to make progress, but ensure we
> + * have a few more available to not get too tight.
> + */
> +#define R5L_POOL_SIZE	1024

Looks reasonable, the recent arbitrary size bio makes things simpler. I
think we don't need to be that conservative. One metadata page can hold
at most
(PAGE_SIZE - sizeof(struct r5l_meta_block)) / sizeof(struct r5l_payload_data_parity)
pages.

Thanks,
Shaohua

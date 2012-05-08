From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC]md: using GFP_NOIO to allocate bio for flush request
Date: Tue, 8 May 2012 18:18:00 +0800
Message-ID: <20120508101800.GB9757@kernel.org>
References: <4F8BAED6.9090105@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F8BAED6.9090105@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids

On Mon, Apr 16, 2012 at 01:32:06PM +0800, Shaohua Li wrote:
> 
> flush request is issued in transaction commit code path usually, so
> looks using
> GFP_KERNEL to allocate memory for flush request bio falls into the classic
> deadlock issue. dm already gets it right.
ping!


> Signed-off-by: Shaohua Li <shli@fusionio.com>
> ---
>  drivers/md/md.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux/drivers/md/md.c
> ===================================================================
> --- linux.orig/drivers/md/md.c	2012-04-13 10:03:58.395497650 +0800
> +++ linux/drivers/md/md.c	2012-04-13 10:04:37.445497882 +0800
> @@ -450,7 +450,7 @@ static void submit_flushes(struct work_s
>  			atomic_inc(&rdev->nr_pending);
>  			atomic_inc(&rdev->nr_pending);
>  			rcu_read_unlock();
> -			bi = bio_alloc_mddev(GFP_KERNEL, 0, mddev);
> +			bi = bio_alloc_mddev(GFP_NOIO, 0, mddev);
>  			bi->bi_end_io = md_end_flush;
>  			bi->bi_private = rdev;
>  			bi->bi_bdev = rdev->bdev;

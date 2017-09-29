From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/2] md-cluster: fix wrong condition check in
 raid1_write_request
Date: Fri, 29 Sep 2017 10:54:26 -0700
Message-ID: <20170929175426.3azxndx7mxoiynh7@kernel.org>
References: <1506647804-469-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1506647804-469-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com
List-Id: linux-raid.ids

On Fri, Sep 29, 2017 at 09:16:43AM +0800, Guoqing Jiang wrote:
> The check used here is to avoid conflict between write and
> resync, however we used the wrong logic, it should be the
> inverse of the checking inside "if".
> 
> Fixes: 589a1c4 ("Suspend writes in RAID1 if within range")
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

applied, thanks!
> ---
>  drivers/md/raid1.c | 10 +++++-----
>  1 file changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f3f3e40..35264ad 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1325,12 +1325,12 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>  			sigset_t full, old;
>  			prepare_to_wait(&conf->wait_barrier,
>  					&w, TASK_INTERRUPTIBLE);
> -			if (bio_end_sector(bio) <= mddev->suspend_lo ||
> -			    bio->bi_iter.bi_sector >= mddev->suspend_hi ||
> -			    (mddev_is_clustered(mddev) &&
> +			if ((bio_end_sector(bio) <= mddev->suspend_lo ||
> +			     bio->bi_iter.bi_sector >= mddev->suspend_hi) &&
> +			    (!mddev_is_clustered(mddev) ||
>  			     !md_cluster_ops->area_resyncing(mddev, WRITE,
> -				     bio->bi_iter.bi_sector,
> -				     bio_end_sector(bio))))
> +							bio->bi_iter.bi_sector,
> +							bio_end_sector(bio))))
>  				break;
>  			sigfillset(&full);
>  			sigprocmask(SIG_BLOCK, &full, &old);
> -- 
> 2.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

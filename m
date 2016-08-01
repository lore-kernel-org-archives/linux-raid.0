From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/8] md-cluster: call md_kick_rdev_from_array once ack
 failed
Date: Mon, 1 Aug 2016 14:58:28 -0700
Message-ID: <20160801215828.GA18810@kernel.org>
References: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1469686612-16126-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 28, 2016 at 02:16:45AM -0400, Guoqing Jiang wrote:
> The new_disk_ack could return failure if WAITING_FOR_NEWDISK
> is not set, so we need to kick the dev from array in case
> failure happened.
> 
> Reviewed-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/md.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 2ed547f..743cd21 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6092,9 +6092,11 @@ static int add_new_disk(struct mddev *mddev, mdu_disk_info_t *info)
>  			export_rdev(rdev);
>  
>  		if (mddev_is_clustered(mddev)) {
> -			if (info->state & (1 << MD_DISK_CANDIDATE))
> -				md_cluster_ops->new_disk_ack(mddev, (err == 0));
> -			else {
> +			if (info->state & (1 << MD_DISK_CANDIDATE)) {

if err != 0, we already do export_rdev, do we need to do md_kick_rdev_from_array in that case?


> +				err = md_cluster_ops->new_disk_ack(mddev, (err == 0));
> +				if (err)
> +					md_kick_rdev_from_array(rdev);
> +			} else {
>  				if (err)
>  					md_cluster_ops->add_new_disk_cancel(mddev);
>  				else
> -- 
> 2.6.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md-cluster: fix potential lock issue in add_new_disk
Date: Wed, 17 May 2017 17:07:30 -0700
Message-ID: <20170518000730.q22ladboa2wrlolo@kernel.org>
References: <1494914485-16288-1-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1494914485-16288-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

On Tue, May 16, 2017 at 02:01:25PM +0800, Guoqing Jiang wrote:
> The add_new_disk returns with communication locked if
> __sendmsg returns failure, fix it with call unlock_comm
> before return.
> 
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> CC: Goldwyn Rodrigues <rgoldwyn@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

queued, thanks!

> ---
>  drivers/md/md-cluster.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 7299ce2..03082e1 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1311,8 +1311,10 @@ static int add_new_disk(struct mddev *mddev, struct md_rdev *rdev)
>  	cmsg.raid_slot = cpu_to_le32(rdev->desc_nr);
>  	lock_comm(cinfo, 1);
>  	ret = __sendmsg(cinfo, &cmsg);
> -	if (ret)
> +	if (ret) {
> +		unlock_comm(cinfo);
>  		return ret;
> +	}
>  	cinfo->no_new_dev_lockres->flags |= DLM_LKF_NOQUEUE;
>  	ret = dlm_lock_sync(cinfo->no_new_dev_lockres, DLM_LOCK_EX);
>  	cinfo->no_new_dev_lockres->flags &= ~DLM_LKF_NOQUEUE;
> -- 
> 2.6.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

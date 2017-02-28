From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 04/14] md-cluster: add mddev into struct md_cluster_info
Date: Tue, 28 Feb 2017 10:06:25 -0800
Message-ID: <20170228180625.rxdbizl7thpif566@kernel.org>
References: <1487906124-20107-1-git-send-email-gqjiang@suse.com>
 <1487906124-20107-5-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487906124-20107-5-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: linux-raid@vger.kernel.org, shli@fb.com, neilb@suse.de
List-Id: linux-raid.ids

On Fri, Feb 24, 2017 at 11:15:14AM +0800, Guoqing Jiang wrote:
> Store "struct mddev *mddev" in md_cluster_info,
> then we can get mddev inside lock_token in next
> patch.

Please merge this to the patch which requires the mddev. Don't think we need a
separate patch.
 
> Reviewed-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  drivers/md/md-cluster.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 620828e56dc8..1ec89273ff99 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -69,6 +69,7 @@ struct resync_info {
>  
>  
>  struct md_cluster_info {
> +	struct mddev *mddev; /* the md device which md_cluster_info belongs to */
>  	/* dlm lock space and resources for clustered raid. */
>  	dlm_lockspace_t *lockspace;
>  	int slot_number;
> @@ -833,6 +834,7 @@ static int join(struct mddev *mddev, int nodes)
>  	mutex_init(&cinfo->recv_mutex);
>  
>  	mddev->cluster_info = cinfo;
> +	cinfo->mddev = mddev;
>  
>  	memset(str, 0, 64);
>  	sprintf(str, "%pU", mddev->uuid);
> -- 
> 2.6.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 4/4] md-cluster: update document for raid10
Date: Sun, 29 Oct 2017 22:44:59 -0700
Message-ID: <20171030054459.nntk6i2ntrejgqmr@kernel.org>
References: <20171024071153.5275-1-gqjiang@suse.com>
 <20171024071153.5275-5-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171024071153.5275-5-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: shli@fb.com, linux-raid@vger.kernel.org, neilb@suse.com
List-Id: linux-raid.ids

On Tue, Oct 24, 2017 at 03:11:53PM +0800, Guoqing Jiang wrote:
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>  Documentation/md/md-cluster.txt | 3 ++-
>  drivers/md/Kconfig              | 5 +++--
>  drivers/md/md-cluster.c         | 2 +-
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/md/md-cluster.txt b/Documentation/md/md-cluster.txt
> index 82ee51604e9a..e1055f105cf5 100644
> --- a/Documentation/md/md-cluster.txt
> +++ b/Documentation/md/md-cluster.txt
> @@ -1,4 +1,5 @@
> -The cluster MD is a shared-device RAID for a cluster.
> +The cluster MD is a shared-device RAID for a cluster, it supports
> +two levels: raid1 and raid10 (limited support).
>  
>  
>  1. On-disk format
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 4a249ee86364..83b9362be09c 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -178,7 +178,7 @@ config MD_FAULTY
>  
>  
>  config MD_CLUSTER
> -	tristate "Cluster Support for MD (EXPERIMENTAL)"
> +	tristate "Cluster Support for MD"

Do we have confidence this is stable enough now?

>  	depends on BLK_DEV_MD
>  	depends on DLM
>  	default n
> @@ -188,7 +188,8 @@ config MD_CLUSTER
>  	nodes in the cluster can access the MD devices simultaneously.
>  
>  	This brings the redundancy (and uptime) of RAID levels across the
> -	nodes of the cluster.
> +	nodes of the cluster. Currently, it can work with raid1 and raid10
> +	(limited support).
>  
>  	If unsure, say N.
>  
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index d0fd1bd8575c..79bfbc840385 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1478,7 +1478,7 @@ static struct md_cluster_operations cluster_ops = {
>  
>  static int __init cluster_init(void)
>  {
> -	pr_warn("md-cluster: EXPERIMENTAL. Use with caution\n");
> +	pr_warn("md-cluster: support raid1 and raid10 (limited support)\n");
>  	pr_info("Registering Cluster MD functions\n");
>  	register_md_cluster_operations(&cluster_ops, THIS_MODULE);
>  	return 0;
> -- 
> 2.10.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

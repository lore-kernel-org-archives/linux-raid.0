From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH 1/5] md: add a 'md_numa_node' module parameter
Date: Mon, 10 Jul 2017 10:28:44 -0700
Message-ID: <20170710172844.hfln24mylpyaoxnw@kernel.org>
References: <1498893658-18409-1-git-send-email-liuzhengyuan@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1498893658-18409-1-git-send-email-liuzhengyuan@kylinos.cn>
Sender: linux-raid-owner@vger.kernel.org
To: Zhengyuan Liu <liuzhengyuan@kylinos.cn>
Cc: linux-raid@vger.kernel.org, neilb@suse.com, colyli@suse.de, liuyun01@kylinos.cn
List-Id: linux-raid.ids

On Sat, Jul 01, 2017 at 03:20:54PM +0800, Zhengyuan Liu wrote:
> This module parameter allows user to control which numa node
> the memory for mainly structures (e.g. mddev, md_rdev,
> request_queue, gendisk) is allocated from. The idea came from
> commit 115485e83f49 ("dm: add 'dm_numa_node' module parameter").
> If we don't set this parameter while loading module, it won't
> affect the md default behavior.
> 
> numa_node_id field is added so personality such as raid0 could
> inherit the node from mddev, for other personality which has its
> own handling thread we could add such a module parameter too.
> 
> This patch includes a bug fix about parameter range check suggested
> by Coly Li <colyli@suse.de>.
> 
> Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>

Can you give an example why this is useful?

If we have several raid arrays, we can't control numa node for them separately.
And in the patch 4/5, one array could have two different parameters to control
memory allocation. this is weird. I have no idea how users use this feature.

If we really want to support numa node, would it be better to deduce the numa
node from the combination of all underlayer disks?

Thanks,
Shaohua

> ---
>  drivers/md/md.c | 18 ++++++++++++++----
>  drivers/md/md.h |  2 ++
>  2 files changed, 16 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 092b48f..fae93db 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -184,6 +184,8 @@ static int start_readonly;
>   */
>  static bool create_on_open = true;
>  
> +static int md_numa_node = NUMA_NO_NODE;
> +
>  /* bio_clone_mddev
>   * like bio_clone, but with a local bio set
>   */
> @@ -588,7 +590,7 @@ static struct mddev *mddev_find(dev_t unit)
>  	}
>  	spin_unlock(&all_mddevs_lock);
>  
> -	new = kzalloc(sizeof(*new), GFP_KERNEL);
> +	new = kzalloc_node(sizeof(*new), GFP_KERNEL, md_numa_node);
>  	if (!new)
>  		return NULL;
>  
> @@ -598,6 +600,7 @@ static struct mddev *mddev_find(dev_t unit)
>  	else
>  		new->md_minor = MINOR(unit) >> MdpMinorShift;
>  
> +	new->numa_node_id = md_numa_node;
>  	mddev_init(new);
>  
>  	goto retry;
> @@ -3387,7 +3390,7 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
>  	struct md_rdev *rdev;
>  	sector_t size;
>  
> -	rdev = kzalloc(sizeof(*rdev), GFP_KERNEL);
> +	rdev = kzalloc_node(sizeof(*rdev), GFP_KERNEL, md_numa_node);
>  	if (!rdev)
>  		return ERR_PTR(-ENOMEM);
>  
> @@ -5256,7 +5259,7 @@ static int md_alloc(dev_t dev, char *name)
>  		mddev->hold_active = UNTIL_STOP;
>  
>  	error = -ENOMEM;
> -	mddev->queue = blk_alloc_queue(GFP_KERNEL);
> +	mddev->queue = blk_alloc_queue_node(GFP_KERNEL, md_numa_node);
>  	if (!mddev->queue)
>  		goto abort;
>  	mddev->queue->queuedata = mddev;
> @@ -5264,7 +5267,7 @@ static int md_alloc(dev_t dev, char *name)
>  	blk_queue_make_request(mddev->queue, md_make_request);
>  	blk_set_stacking_limits(&mddev->queue->limits);
>  
> -	disk = alloc_disk(1 << shift);
> +	disk = alloc_disk_node(1 << shift, md_numa_node);
>  	if (!disk) {
>  		blk_cleanup_queue(mddev->queue);
>  		mddev->queue = NULL;
> @@ -8969,6 +8972,11 @@ static int __init md_init(void)
>  	register_reboot_notifier(&md_notifier);
>  	raid_table_header = register_sysctl_table(raid_root_table);
>  
> +	if (md_numa_node < NUMA_NO_NODE)
> +		md_numa_node = NUMA_NO_NODE;
> +	else if (md_numa_node > (num_online_nodes() - 1))
> +		md_numa_node = num_online_nodes() - 1;
> +
>  	md_geninit();
>  	return 0;
>  
> @@ -9252,6 +9260,8 @@ module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
>  module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
>  module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
>  module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
> +module_param(md_numa_node, int, S_IRUGO);
> +MODULE_PARM_DESC(md_numa_node, "NUMA node for md device memory allocations");
>  
>  MODULE_LICENSE("GPL");
>  MODULE_DESCRIPTION("MD RAID framework");
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 991f0fe..5c91033 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -459,6 +459,8 @@ struct mddev {
>  	void (*sync_super)(struct mddev *mddev, struct md_rdev *rdev);
>  	struct md_cluster_info		*cluster_info;
>  	unsigned int			good_device_nr;	/* good device num within cluster raid */
> +
> +	int numa_node_id;
>  };
>  
>  enum recovery_flags {
> -- 
> 2.7.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

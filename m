From: Coly Li <colyli@suse.de>
Subject: Re: [PATCH] md: add a 'md_numa_node' module parameter
Date: Fri, 30 Jun 2017 19:13:24 +0800
Message-ID: <28f60a55-ce46-87cc-ca25-e319797bde52@suse.de>
References: <1498813021-2538-1-git-send-email-liuzhengyuan@kylinos.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1498813021-2538-1-git-send-email-liuzhengyuan@kylinos.cn>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Zhengyuan Liu <liuzhengyuan@kylinos.cn>, linux-raid@vger.kernel.org
Cc: shli@kernel.org, neilb@suse.com, liuyun01@kylinos.cn
List-Id: linux-raid.ids

On 2017/6/30 下午4:57, Zhengyuan Liu wrote:
> This module parameter allows user to control which numa node
> the memory for mainly structures (e.g. mddev, md_rdev,
> request_queue, gendisk) is allocated from. The idea came from
> commit 115485e83f49 ("dm: add 'dm_numa_node' module parameter").
> If we don't set this parameter while loading module, it won't
> affect the md default behavior.
> 
> numa_node_id field is added so personality such as raid0 could
> inherit the node from mddev, for other personality which has its
> own handling thread we could add such a module parameter too.I
> would send those patches soon.
> 
> Signed-off-by: Zhengyuan Liu <liuzhengyuan@kylinos.cn>

NACK.

md_numa_node can be any minus value other then -1. kzalloc_node() only
accepts minus node id as -1 (NUMA_NO_NODE), for other minus value sent
into kzalloc() may trigger a VM_BUG_ON(), see
include/linux/gfp.h:__alloc_pages_node(),
449 static inline struct page *
450 __alloc_pages_node(int nid, gfp_t gfp_mask, unsigned int order)
451 {
452         VM_BUG_ON(nid < 0 || nid >= MAX_NUMNODES);
453         VM_WARN_ON(!node_online(nid));
454
455         return __alloc_pages(gfp_mask, order, node_zonelist(nid,
gfp_mask));
456 }

That means you introduce a method to panic kernel by loading md kenrel
module.

So if you want to make it work correctly, you should formulate
md_numa_node in range of [-1, MAX_NUMNODES).

Coly

> ---
>  drivers/md/md.c | 13 +++++++++----
>  drivers/md/md.h |  2 ++
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 092b48f..aa44e92 100644
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
> @@ -9252,6 +9255,8 @@ module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
>  module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
>  module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
>  module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
> +module_param(md_numa_node, int, S_IRUGO | S_IWUSR);
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
> 


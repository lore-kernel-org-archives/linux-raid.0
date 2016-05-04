From: Guoqing Jiang <gqjiang@suse.com>
Subject: Re: [PATCH 2/3] md-cluster: gather resync infos and enable
 recv_thread after bitmap is ready
Date: Wed, 4 May 2016 01:52:26 -0400
Message-ID: <57298E1A.1010508@suse.com>
References: <1462328535-22566-1-git-send-email-gqjiang@suse.com>
 <1462328535-22566-2-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1462328535-22566-2-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: shli@kernel.org
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 05/03/2016 10:22 PM, Guoqing Jiang wrote:
> The in-memory bitmap is not ready when node joins cluster,
> so it doesn't make sense to make gather_all_resync_info()
> called so earlier, we need to call it after the node's
> bitmap is setup. Also, recv_thread could be wake up after
> node joins cluster, but it could cause problem if node
> receives RESYNCING message without persionality since
> mddev->pers->quiesce is called in process_suspend_info.
>
> This commit introduces a new cluster interface load_bitmaps
> to fix above problems, load_bitmaps is called in bitmap_load
> where bitmap and persionality are ready, and load_bitmaps
> does the following tasks:
>
> 1. call gather_all_resync_info to load all the node's
>     bitmap info.
> 2. set MD_CLUSTER_ALREADY_IN_CLUSTER bit to recv_thread
>     could be wake up, and wake up recv_thread if there is
>     pending recv event.
>
> Then ack_bast only wakes up recv_thread after IN_CLUSTER
> bit is ready otherwise MD_CLUSTER_PENDING_RESYNC_EVENT is
> set.
>
> Reviewed-by: NeilBrown <neilb@suse.com>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> ---
>   drivers/md/bitmap.c     |  3 +++
>   drivers/md/md-cluster.c | 27 ++++++++++++++++++++++-----
>   drivers/md/md-cluster.h |  1 +
>   3 files changed, 26 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> index ad5a858..d8129ec 100644
> --- a/drivers/md/bitmap.c
> +++ b/drivers/md/bitmap.c
> @@ -1848,6 +1848,9 @@ int bitmap_load(struct mddev *mddev)
>   	if (!bitmap)
>   		goto out;
>   
> +	if (mddev_is_clustered(mddev))
> +		md_cluster_ops->load_bitmaps(mddev, mddev->bitmap_info.nodes);
> +
>   	/* Clear out old bitmap info first:  Either there is none, or we
>   	 * are resuming after someone else has possibly changed things,
>   	 * so we should forget old cached info.
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index a55b5f4..bee4085 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -61,6 +61,10 @@ struct resync_info {
>    * the lock.
>    */
>   #define		MD_CLUSTER_SEND_LOCKED_ALREADY		5
> +/* We should receive message after node joined cluster and
> + * set up all the related infos such as bitmap and personality */
> +#define		MD_CLUSTER_ALREADY_IN_CLUSTER		6
> +#define		MD_CLUSTER_PENDING_RESYNC_EVENT		7
>   
>   
>   struct md_cluster_info {
> @@ -376,8 +380,11 @@ static void ack_bast(void *arg, int mode)
>   	struct dlm_lock_resource *res = arg;
>   	struct md_cluster_info *cinfo = res->mddev->cluster_info;
>   
> -	if (mode == DLM_LOCK_EX)
> +	if (mode == DLM_LOCK_EX &&
> +	    test_bit(MD_CLUSTER_ALREADY_IN_CLUSTER, &cinfo->state))
>   		md_wakeup_thread(cinfo->recv_thread);
> +	else
> +		set_bit(MD_CLUSTER_PENDING_RESYNC_EVENT, &cinfo->state);
>   }

Hmm, the above should be:

-       if (mode == DLM_LOCK_EX)
-               md_wakeup_thread(cinfo->recv_thread);
+       if (mode == DLM_LOCK_EX) {
+               if (test_bit(MD_CLUSTER_ALREADY_IN_CLUSTER, &cinfo->state))
+                       md_wakeup_thread(cinfo->recv_thread);
+               else
+                       set_bit(MD_CLUSTER_PENDING_RESYNC_EVENT, 
&cinfo->state);
+       }

I will update the patch.

Thanks,
Guoqing

>   
>   static void __remove_suspend_info(struct md_cluster_info *cinfo, int slot)
> @@ -846,10 +853,6 @@ static int join(struct mddev *mddev, int nodes)
>   	if (!cinfo->resync_lockres)
>   		goto err;
>   
> -	ret = gather_all_resync_info(mddev, nodes);
> -	if (ret)
> -		goto err;
> -
>   	return 0;
>   err:
>   	md_unregister_thread(&cinfo->recovery_thread);
> @@ -867,6 +870,19 @@ err:
>   	return ret;
>   }
>   
> +static void load_bitmaps(struct mddev *mddev, int total_slots)
> +{
> +	struct md_cluster_info *cinfo = mddev->cluster_info;
> +
> +	/* load all the node's bitmap info for resync */
> +	if (gather_all_resync_info(mddev, total_slots))
> +		pr_err("md-cluster: failed to gather all resyn infos\n");
> +	set_bit(MD_CLUSTER_ALREADY_IN_CLUSTER, &cinfo->state);
> +	/* wake up recv thread in case something need to be handled */
> +	if (test_and_clear_bit(MD_CLUSTER_PENDING_RESYNC_EVENT, &cinfo->state))
> +		md_wakeup_thread(cinfo->recv_thread);
> +}
> +
>   static void resync_bitmap(struct mddev *mddev)
>   {
>   	struct md_cluster_info *cinfo = mddev->cluster_info;
> @@ -1208,6 +1224,7 @@ static struct md_cluster_operations cluster_ops = {
>   	.add_new_disk_cancel = add_new_disk_cancel,
>   	.new_disk_ack = new_disk_ack,
>   	.remove_disk = remove_disk,
> +	.load_bitmaps = load_bitmaps,
>   	.gather_bitmaps = gather_bitmaps,
>   	.lock_all_bitmaps = lock_all_bitmaps,
>   	.unlock_all_bitmaps = unlock_all_bitmaps,
> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
> index 45ce6c9..e765499 100644
> --- a/drivers/md/md-cluster.h
> +++ b/drivers/md/md-cluster.h
> @@ -23,6 +23,7 @@ struct md_cluster_operations {
>   	void (*add_new_disk_cancel)(struct mddev *mddev);
>   	int (*new_disk_ack)(struct mddev *mddev, bool ack);
>   	int (*remove_disk)(struct mddev *mddev, struct md_rdev *rdev);
> +	void (*load_bitmaps)(struct mddev *mddev, int total_slots);
>   	int (*gather_bitmaps)(struct md_rdev *rdev);
>   	int (*lock_all_bitmaps)(struct mddev *mddev);
>   	void (*unlock_all_bitmaps)(struct mddev *mddev);


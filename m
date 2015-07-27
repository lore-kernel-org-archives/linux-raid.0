From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: Re: [PATCH 03/12] md-cluster: transfer the resync ownership to
 another node
Date: Mon, 27 Jul 2015 11:24:38 -0500
Message-ID: <55B65B46.4080203@suse.de>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
 <1436518453-12660-4-git-send-email-gqjiang@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518453-12660-4-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 07/10/2015 03:54 AM, Guoqing Jiang wrote:
> When node A stop an array while the array is doing resync, we need
> let another node B to take over the resync task.
>
> To achieve the goal, we need the A send an explicit BITMAP_NEEDS_SYNC
> message to the cluster. And the node B which received that message will
> invoke __recover_slot to do resync.
>
> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>

Reviewed-by: Goldwyn Rodrigues <rgoldwyn@suse.com>

> ---
>   drivers/md/md-cluster.c | 15 +++++++++++++++
>   drivers/md/md.c         |  6 +++---
>   2 files changed, 18 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 24caabe..47199ad 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -75,6 +75,7 @@ enum msg_type {
>   	NEWDISK,
>   	REMOVE,
>   	RE_ADD,
> +	BITMAP_NEEDS_SYNC,
>   };
>
>   struct cluster_msg {
> @@ -454,6 +455,11 @@ static void process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
>   			__func__, __LINE__, msg->slot);
>   		process_readd_disk(mddev, msg);
>   		break;
> +	case BITMAP_NEEDS_SYNC:
> +		pr_info("%s: %d Received BITMAP_NEEDS_SYNC from %d\n",
> +			__func__, __LINE__, msg->slot);
> +		__recover_slot(mddev, msg->slot);
> +		break;
>   	default:
>   		pr_warn("%s:%d Received unknown message from %d\n",
>   			__func__, __LINE__, msg->slot);
> @@ -814,8 +820,17 @@ static int resync_start(struct mddev *mddev, sector_t lo, sector_t hi)
>
>   static void resync_finish(struct mddev *mddev)
>   {
> +	struct md_cluster_info *cinfo = mddev->cluster_info;
> +	struct cluster_msg cmsg;
> +	int slot = cinfo->slot_number - 1;
> +
>   	pr_info("%s:%d\n", __func__, __LINE__);
>   	resync_send(mddev, RESYNCING, 0, 0);
> +	if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
> +		cmsg.type = cpu_to_le32(BITMAP_NEEDS_SYNC);
> +		cmsg.slot = cpu_to_le32(slot);
> +		sendmsg(cinfo, &cmsg);
> +	}
>   }
>
>   static int area_resyncing(struct mddev *mddev, int direction,
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index df92d30..7d05dff 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7931,9 +7931,6 @@ void md_do_sync(struct md_thread *thread)
>   	/* tell personality that we are finished */
>   	mddev->pers->sync_request(mddev, max_sectors, &skipped);
>
> -	if (mddev_is_clustered(mddev))
> -		md_cluster_ops->resync_finish(mddev);
> -
>   	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
>   	    mddev->curr_resync > 2) {
>   		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
> @@ -7967,6 +7964,9 @@ void md_do_sync(struct md_thread *thread)
>   		}
>   	}
>    skip:
> +	if (mddev_is_clustered(mddev))
> +		md_cluster_ops->resync_finish(mddev);
> +
>   	set_bit(MD_CHANGE_DEVS, &mddev->flags);
>
>   	spin_lock(&mddev->lock);
>

-- 
Goldwyn

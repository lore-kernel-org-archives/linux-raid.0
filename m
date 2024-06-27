Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2CA24B5B
	for <linux-raid@vger.kernel.org>; Thu, 27 Jun 2024 13:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719493266; cv=none; b=YyKSgLhW676lXjq5jOrHFEsYbDoduqfA1snNhhVj/TDRQ6e/1676YU+bc1LOooXwgQ+rcfQuGojce3i6Xj04b3TjMlyjbfmZvP50r5K1EKnrTHCG4gDcsQZYvLt31GiGAx5CkNlJ+lxs/vFXHdfbZ6H1aRp6QhaVG43kI7NTwuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719493266; c=relaxed/simple;
	bh=p8vO5x2RqnR/PQNOjrhX/ErCsY4G2b8vM69df61ejIQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mIhaAmNZJnQvG5pl+PMf6pZx5RjkP9GJ0actuU8Ga+y4L7PKKuLx+Zu8X47W6VFrWxV0MaLgOfrxrTnXTqGeSF5/v/OVp1G6mkht2Iq0KCOvAw+3zdTd+v6rJuBB6X1TO5cZ1ythFfTKwYVoS6yJGu0P8X9pJfwtQI5sAiNeOTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4W8zFn1N8Kz4f3kvP
	for <linux-raid@vger.kernel.org>; Thu, 27 Jun 2024 21:00:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 665D51A0199
	for <linux-raid@vger.kernel.org>; Thu, 27 Jun 2024 21:00:57 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP2 (Coremail) with SMTP id Syh0CgAnkYaIYn1mvlX6AQ--.24109S3;
	Thu, 27 Jun 2024 21:00:57 +0800 (CST)
Subject: Re: [PATCH 2/2] md-cluster: fix no recovery job when adding/re-adding
 a disk
To: Heming Zhao <heming.zhao@suse.com>, song@kernel.org,
 yukuai1@huaweicloud.com, xni@redhat.com
Cc: glass.su@suse.com, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240612021911.11043-1-heming.zhao@suse.com>
 <20240612021911.11043-2-heming.zhao@suse.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <532f0d59-b34c-63ff-a84e-cc590e7477ef@huaweicloud.com>
Date: Thu, 27 Jun 2024 21:00:56 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240612021911.11043-2-heming.zhao@suse.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgAnkYaIYn1mvlX6AQ--.24109S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr4kKrWrWryruFyxJF4rAFb_yoW3tw15pa
	yaqFy3Gr4UJr4fWrW3GryDuFyfCry8JrW7Kr47W3WI93ZYkr18GF15JF1kAFyDWas8WrnF
	qw1rGFs8uas3KrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZa9
	-UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/06/12 10:19, Heming Zhao Ð´µÀ:
> The commit db5e653d7c9f ("md: delay choosing sync action to
> md_start_sync()") delays the start of the sync action. In a
> clustered environment, this will cause another node to first
> activate the spare disk and skip recovery. As a result, no
> nodes will perform recovery when a disk is added or re-added.
> 
> Before db5e653d7c9f:
> 
> ```
>     node1                                node2
> ----------------------------------------------------------------
> md_check_recovery
>   + md_update_sb
>   |  sendmsg: METADATA_UPDATED
>   + md_choose_sync_action           process_metadata_update
>   |  remove_and_add_spares           //node1 has not finished adding
>   + call mddev->sync_work            //the spare disk:do nothing
> 
> md_start_sync
>   starts md_do_sync
> 
> md_do_sync
>   + grabbed resync_lockres:DLM_LOCK_EX
>   + do syncing job
> 
> md_check_recovery
>   sendmsg: METADATA_UPDATED
>                                   process_metadata_update
>                                     //activate spare disk
> 
>                                   ... ...
> 
>                                   md_do_sync
>                                    waiting to grab resync_lockres:EX
> ```
> 
> After db5e653d7c9f:
> 
> (note: if 'cmd:idle' sets MD_RECOVERY_INTR after md_check_recovery
> starts md_start_sync, setting the INTR action will exacerbate the
> delay in node1 calling the md_do_sync function.)
> 
> ```
>     node1                                node2
> ----------------------------------------------------------------
> md_check_recovery
>   + md_update_sb
>   |  sendmsg: METADATA_UPDATED
>   + calls mddev->sync_work         process_metadata_update
>                                     //node1 has not finished adding
>                                     //the spare disk:do nothing
> 
> md_start_sync
>   + md_choose_sync_action
>   |  remove_and_add_spares
>   + calls md_do_sync
> 
> md_check_recovery
>   md_update_sb
>    sendmsg: METADATA_UPDATED
>                                    process_metadata_update
>                                      //activate spare disk
> 
>    ... ...                         ... ...
> 
>                                    md_do_sync
>                                     + grabbed resync_lockres:EX
>                                     + raid1_sync_request skip sync under
> 				     conf->fullsync:0
> md_do_sync
>   1. waiting to grab resync_lockres:EX
>   2. when node1 could grab EX lock,
>      node1 will skip resync under recovery_offset:MaxSector

I have a question here, because md_do_sync() and the second
md_check_recovery() are completely irrelevant, so with or without
the commit db5e653d7c9f, the problem is always there?

Thanks,
Kuai


> ```
> 
> How to trigger:
> 
> ```(commands @node1)
>   # to easily watch the recovery status
> echo 2000 > /proc/sys/dev/raid/speed_limit_max
> ssh root@node2 "echo 2000 > /proc/sys/dev/raid/speed_limit_max"
> 
> mdadm -CR /dev/md0 -l1 -b clustered -n 2 /dev/sda /dev/sdb --assume-clean
> ssh root@node2 mdadm -A /dev/md0 /dev/sda /dev/sdb
> mdadm --manage /dev/md0 --fail /dev/sda --remove /dev/sda
> mdadm --manage /dev/md0 --add /dev/sdc
> 
> === "cat /proc/mdstat" on both node, there are no recovery action. ===
> ```
> 
> How to fix:
> 
> because md layer code logic is hard to restore for speeding up sync job
> on local node, we add new cluster msg to pending the another node to
> active disk.
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Reviewed-by: Su Yue <glass.su@suse.com>
> ---
>   drivers/md/md-cluster.c | 27 +++++++++++++++++++++++++++
>   drivers/md/md-cluster.h |  2 ++
>   drivers/md/md.c         | 17 ++++++++++++++---
>   3 files changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 27eaaf9fef94..ab1e3c490279 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -56,6 +56,7 @@ struct resync_info {
>   #define		MD_CLUSTER_ALREADY_IN_CLUSTER		6
>   #define		MD_CLUSTER_PENDING_RECV_EVENT		7
>   #define 	MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD		8
> +#define		MD_CLUSTER_WAITING_FOR_SYNC		9
>   
>   struct md_cluster_info {
>   	struct mddev *mddev; /* the md device which md_cluster_info belongs to */
> @@ -91,6 +92,7 @@ struct md_cluster_info {
>   	sector_t sync_hi;
>   };
>   
> +/* For compatibility, add the new msg_type at the end. */
>   enum msg_type {
>   	METADATA_UPDATED = 0,
>   	RESYNCING,
> @@ -100,6 +102,7 @@ enum msg_type {
>   	BITMAP_NEEDS_SYNC,
>   	CHANGE_CAPACITY,
>   	BITMAP_RESIZE,
> +	RESYNCING_START,
>   };
>   
>   struct cluster_msg {
> @@ -460,6 +463,7 @@ static void process_suspend_info(struct mddev *mddev,
>   		clear_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
>   		remove_suspend_info(mddev, slot);
>   		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +		clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
>   		md_wakeup_thread(mddev->thread);
>   		return;
>   	}
> @@ -530,6 +534,7 @@ static int process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
>   		res = -1;
>   	}
>   	clear_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
> +	set_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
>   	return res;
>   }
>   
> @@ -598,6 +603,9 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
>   	case CHANGE_CAPACITY:
>   		set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
>   		break;
> +	case RESYNCING_START:
> +		clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, &mddev->cluster_info->state);
> +		break;
>   	case RESYNCING:
>   		set_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
>   		process_suspend_info(mddev, le32_to_cpu(msg->slot),
> @@ -1353,6 +1361,23 @@ static void resync_info_get(struct mddev *mddev, sector_t *lo, sector_t *hi)
>   	spin_unlock_irq(&cinfo->suspend_lock);
>   }
>   
> +static int resync_status_get(struct mddev *mddev)
> +{
> +	struct md_cluster_info *cinfo = mddev->cluster_info;
> +
> +	return test_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
> +}
> +
> +static int resync_start_notify(struct mddev *mddev)
> +{
> +	struct md_cluster_info *cinfo = mddev->cluster_info;
> +	struct cluster_msg cmsg = {0};
> +
> +	cmsg.type = cpu_to_le32(RESYNCING_START);
> +
> +	return sendmsg(cinfo, &cmsg, 0);
> +}
> +
>   static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
>   {
>   	struct md_cluster_info *cinfo = mddev->cluster_info;
> @@ -1587,6 +1612,8 @@ static struct md_cluster_operations cluster_ops = {
>   	.resync_start = resync_start,
>   	.resync_finish = resync_finish,
>   	.resync_info_update = resync_info_update,
> +	.resync_start_notify = resync_start_notify,
> +	.resync_status_get = resync_status_get,
>   	.resync_info_get = resync_info_get,
>   	.metadata_update_start = metadata_update_start,
>   	.metadata_update_finish = metadata_update_finish,
> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
> index a78e3021775d..470bf18ffde5 100644
> --- a/drivers/md/md-cluster.h
> +++ b/drivers/md/md-cluster.h
> @@ -14,6 +14,8 @@ struct md_cluster_operations {
>   	int (*leave)(struct mddev *mddev);
>   	int (*slot_number)(struct mddev *mddev);
>   	int (*resync_info_update)(struct mddev *mddev, sector_t lo, sector_t hi);
> +	int (*resync_start_notify)(struct mddev *mddev);
> +	int (*resync_status_get)(struct mddev *mddev);
>   	void (*resync_info_get)(struct mddev *mddev, sector_t *lo, sector_t *hi);
>   	int (*metadata_update_start)(struct mddev *mddev);
>   	int (*metadata_update_finish)(struct mddev *mddev);
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index e575e74aabf5..97d7e96d1d5e 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8902,7 +8902,8 @@ void md_do_sync(struct md_thread *thread)
>   	 * This will mean we have to start checking from the beginning again.
>   	 *
>   	 */
> -
> +	if (mddev_is_clustered(mddev))
> +		md_cluster_ops->resync_start_notify(mddev);
>   	do {
>   		int mddev2_minor = -1;
>   		mddev->curr_resync = MD_RESYNC_DELAYED;
> @@ -9963,8 +9964,18 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
>   			 */
>   			if (rdev2->raid_disk == -1 && role != MD_DISK_ROLE_SPARE &&
>   			    !(le32_to_cpu(sb->feature_map) &
> -			      MD_FEATURE_RESHAPE_ACTIVE)) {
> -				rdev2->saved_raid_disk = role;
> +			      MD_FEATURE_RESHAPE_ACTIVE) &&
> +			    !md_cluster_ops->resync_status_get(mddev)) {
> +				/*
> +				 * -1 to make raid1_add_disk() set conf->fullsync
> +				 * to 1. This could avoid skipping sync when the
> +				 * remote node is down during resyncing.
> +				 */
> +				if ((le32_to_cpu(sb->feature_map)
> +				    & MD_FEATURE_RECOVERY_OFFSET))
> +					rdev2->saved_raid_disk = -1;
> +				else
> +					rdev2->saved_raid_disk = role;
>   				ret = remove_and_add_spares(mddev, rdev2);
>   				pr_info("Activated spare: %pg\n",
>   					rdev2->bdev);
> 


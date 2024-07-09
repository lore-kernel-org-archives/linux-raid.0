Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FA3F155389
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 11:11:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523510; cv=none; b=Z+NuQdePrIFXGopbuA81XfxryjpVr7ny6RuABe/FqSdmggT5P9iRWLPVaOPSup76XdaXObIvyM8zGoLJbYl54vS2MERaubaoHiZVInpHE1FyodFoykT9KZC+FtHyg2Sp4wepBUocrHZIjK3O/lJjMUkAvfKF1pDcGwiylFVZ5t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523510; c=relaxed/simple;
	bh=Kt2ZFPJ3e7wMQEAAmTSQ3xjuGaV3Tz5YJJSuay9rG3s=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UGDYs02oellqgQSZpums4Xc8UWH5zmm8i5Fr+usSLPvuCcSsvMUEWLXyGKCRH2piyhfxj0QXWKdlPSLR4s0Q9/hpbAe9YHTno6+Ga0gpI4qREwdkoPaErRgEjpSUtWs7rGJL/VD/IouZbMCEtTkHBhVdmYUGVyutijk5kpcMhzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WJJGD4ppmz4f3jdb
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 19:11:32 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 3A2871A0B08
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 19:11:44 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP2 (Coremail) with SMTP id Syh0CgCnD4XvGo1moJh0Bg--.48619S3;
	Tue, 09 Jul 2024 19:11:44 +0800 (CST)
Subject: Re: [PATCH v2 2/2] md-cluster: fix no recovery job when
 adding/re-adding a disk
To: Heming Zhao <heming.zhao@suse.com>, song@kernel.org,
 yukuai1@huaweicloud.com, xni@redhat.com
Cc: glass.su@suse.com, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240709104120.22243-1-heming.zhao@suse.com>
 <20240709104120.22243-2-heming.zhao@suse.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6b417c08-4c52-72f1-31ca-ea32338a5170@huaweicloud.com>
Date: Tue, 9 Jul 2024 19:11:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240709104120.22243-2-heming.zhao@suse.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCnD4XvGo1moJh0Bg--.48619S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr4kKrW8JFWDWF4kZry3XFb_yoW3uw1UpF
	WaqFy3Gr4UJrWfWrW7GrWDCFyfC348JrW7Kr47W3WI93ZYkr18GF15GF1kAFyDWasxWrnF
	qw1rKFs8uas3KrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI
	0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y
	0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxV
	W8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU1a9aP
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/07/09 18:41, Heming Zhao Ð´µÀ:
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

Acked-by: Yu Kuai <yukuai3@huawei.com>
> 
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> Reviewed-by: Su Yue <glass.su@suse.com>
> ---
> v1 -> v2: no change in this patch
> ---
>   drivers/md/md-cluster.c | 27 +++++++++++++++++++++++++++
>   drivers/md/md-cluster.h |  2 ++
>   drivers/md/md.c         | 17 ++++++++++++++---
>   3 files changed, 43 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index b5a802ae17bb..bf6a0dd8dac7 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -57,6 +57,7 @@ struct resync_info {
>   #define		MD_CLUSTER_ALREADY_IN_CLUSTER		6
>   #define		MD_CLUSTER_PENDING_RECV_EVENT		7
>   #define 	MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD		8
> +#define		MD_CLUSTER_WAITING_FOR_SYNC		9
>   
>   struct md_cluster_info {
>   	struct mddev *mddev; /* the md device which md_cluster_info belongs to */
> @@ -92,6 +93,7 @@ struct md_cluster_info {
>   	sector_t sync_hi;
>   };
>   
> +/* For compatibility, add the new msg_type at the end. */
>   enum msg_type {
>   	METADATA_UPDATED = 0,
>   	RESYNCING,
> @@ -101,6 +103,7 @@ enum msg_type {
>   	BITMAP_NEEDS_SYNC,
>   	CHANGE_CAPACITY,
>   	BITMAP_RESIZE,
> +	RESYNCING_START,
>   };
>   
>   struct cluster_msg {
> @@ -461,6 +464,7 @@ static void process_suspend_info(struct mddev *mddev,
>   		clear_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
>   		remove_suspend_info(mddev, slot);
>   		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +		clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
>   		md_wakeup_thread(mddev->thread);
>   		return;
>   	}
> @@ -531,6 +535,7 @@ static int process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
>   		res = -1;
>   	}
>   	clear_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
> +	set_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
>   	return res;
>   }
>   
> @@ -599,6 +604,9 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
>   	case CHANGE_CAPACITY:
>   		set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
>   		break;
> +	case RESYNCING_START:
> +		clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, &mddev->cluster_info->state);
> +		break;
>   	case RESYNCING:
>   		set_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
>   		process_suspend_info(mddev, le32_to_cpu(msg->slot),
> @@ -1345,6 +1353,23 @@ static void resync_info_get(struct mddev *mddev, sector_t *lo, sector_t *hi)
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
> @@ -1579,6 +1604,8 @@ static struct md_cluster_operations cluster_ops = {
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
> index aff9118ff697..e393df55fc8b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -8907,7 +8907,8 @@ void md_do_sync(struct md_thread *thread)
>   	 * This will mean we have to start checking from the beginning again.
>   	 *
>   	 */
> -
> +	if (mddev_is_clustered(mddev))
> +		md_cluster_ops->resync_start_notify(mddev);
>   	do {
>   		int mddev2_minor = -1;
>   		mddev->curr_resync = MD_RESYNC_DELAYED;
> @@ -9968,8 +9969,18 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
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


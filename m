Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F69374D1
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 02:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720493660; cv=none; b=JKobC97CgLniKj0OkAOStOTkJOuR/cAWjPQM2lqHrzvlpY+YfCY+MiemHfrW5fTcd6ZFpVsOQERDMQGMY49/QuoAvUoZPYyutqkBlzwzyOSSYY8aidjVa0SRSL847FlIspsM1WNVZ4PFHpT4R7j6BB45rOl5zGGjX15qMXtUd6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720493660; c=relaxed/simple;
	bh=46B/VWVaTMNN1/41qDywg9fLrwobQtTl1YwqxDrdExM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Hxv086I1a+ueFwC+nqDOrkKyedNHiri4mLjvwUYTXcD2m1h9k97eiw9nt5AGJ2pJvNVp6+Opn469XkNQpUP8Pjm9fu/w1ftAcAWfyb0yqZDnE7xiA6YMAQ7+MyGcOmZqSAxlaKFyRZRO1DVfsrMXytSk4Wb2Li7qo0GwSam9XmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WJ5D907v7z4f3kw5
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 10:54:01 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id C96991A0170
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 10:54:13 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP2 (Coremail) with SMTP id Syh0CgB34YZUpoxmJWVTBg--.40491S3;
	Tue, 09 Jul 2024 10:54:13 +0800 (CST)
Subject: Re: [PATCH 2/2] md-cluster: fix no recovery job when adding/re-adding
 a disk
To: Heming Zhao <heming.zhao@suse.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 song@kernel.org, xni@redhat.com
Cc: glass.su@suse.com, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240612021911.11043-1-heming.zhao@suse.com>
 <20240612021911.11043-2-heming.zhao@suse.com>
 <532f0d59-b34c-63ff-a84e-cc590e7477ef@huaweicloud.com>
 <be09f807-afc5-487f-a822-14d4e3f55cc9@suse.com>
 <f14a75fb-6f5f-490b-b968-51da56fec746@suse.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <c2b93bcf-56c2-341b-39bd-3c7f00db0b05@huaweicloud.com>
Date: Tue, 9 Jul 2024 10:54:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <f14a75fb-6f5f-490b-b968-51da56fec746@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgB34YZUpoxmJWVTBg--.40491S3
X-Coremail-Antispam: 1UD129KBjvAXoWfJryrJr15WFyrGw4DGr4DArb_yoW8Gr4rJo
	W8Kw13Zr1rXr1UGr1UJ34UJr13Xw1UJr1DJr1UJr17Gr18t3WUJ3yUJryUK3yUJr1rWr1U
	JryUXr18ZFWUZr18n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
	AaLaJ3UjIYCTnIWjp_UUUYF7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20EY4v20xva
	j40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2
	x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW8
	Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26r
	xl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj
	6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr
	0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CE
	bIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67
	AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIY
	rxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14
	v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbXdbU
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/07/09 8:34, Heming Zhao 写道:
> Hello Kuai,
> 
> ping...
> 

I don't have other suggestions for now, you can send a new vesion.

Thanks
Kuai

> On 6/29/24 19:16, Heming Zhao wrote:
>> On 6/27/24 21:00, Yu Kuai wrote:
>>> Hi,
>>>
>>> 在 2024/06/12 10:19, Heming Zhao 写道:
>>>> The commit db5e653d7c9f ("md: delay choosing sync action to
>>>> md_start_sync()") delays the start of the sync action. In a
>>>> clustered environment, this will cause another node to first
>>>> activate the spare disk and skip recovery. As a result, no
>>>> nodes will perform recovery when a disk is added or re-added.
>>>>
>>>> Before db5e653d7c9f:
>>>>
>>>> ```
>>>>     node1                                node2
>>>> ----------------------------------------------------------------
>>>> md_check_recovery
>>>>   + md_update_sb
>>>>   |  sendmsg: METADATA_UPDATED
>>>>   + md_choose_sync_action           process_metadata_update
>>>>   |  remove_and_add_spares           //node1 has not finished adding
>>>>   + call mddev->sync_work            //the spare disk:do nothing
>>>>
>>>> md_start_sync
>>>>   starts md_do_sync
>>>>
>>>> md_do_sync
>>>>   + grabbed resync_lockres:DLM_LOCK_EX
>>>>   + do syncing job
>>>>
>>>> md_check_recovery
>>>>   sendmsg: METADATA_UPDATED
>>>>                                   process_metadata_update
>>>>                                     //activate spare disk
>>>>
>>>>                                   ... ...
>>>>
>>>>                                   md_do_sync
>>>>                                    waiting to grab resync_lockres:EX
>>>> ```
>>>>
>>>> After db5e653d7c9f:
>>>>
>>>> (note: if 'cmd:idle' sets MD_RECOVERY_INTR after md_check_recovery
>>>> starts md_start_sync, setting the INTR action will exacerbate the
>>>> delay in node1 calling the md_do_sync function.)
>>>>
>>>> ```
>>>>     node1                                node2
>>>> ----------------------------------------------------------------
>>>> md_check_recovery
>>>>   + md_update_sb
>>>>   |  sendmsg: METADATA_UPDATED
>>>>   + calls mddev->sync_work         process_metadata_update
>>>>                                     //node1 has not finished adding
>>>>                                     //the spare disk:do nothing
>>>>
>>>> md_start_sync
>>>>   + md_choose_sync_action
>>>>   |  remove_and_add_spares
>>>>   + calls md_do_sync
>>>>
>>>> md_check_recovery
>>>>   md_update_sb
>>>>    sendmsg: METADATA_UPDATED
>>>>                                    process_metadata_update
>>>>                                      //activate spare disk
>>>>
>>>>    ... ...                         ... ...
>>>>
>>>>                                    md_do_sync
>>>>                                     + grabbed resync_lockres:EX
>>>>                                     + raid1_sync_request skip sync 
>>>> under
>>>>                      conf->fullsync:0
>>>> md_do_sync
>>>>   1. waiting to grab resync_lockres:EX
>>>>   2. when node1 could grab EX lock,
>>>>      node1 will skip resync under recovery_offset:MaxSector
>>>
>>> I have a question here, because md_do_sync() and the second
>>> md_check_recovery() are completely irrelevant, so with or without
>>> the commit db5e653d7c9f, the problem is always there?
>>>
>>> Thanks,
>>> Kuai
>>
>> I performed a bi-search job. The commit f52f5c71f3d4 ("md: fix
>> stopping sync thread") is the first sync failure commit. However,
>> f52f5c71f3d4 is not the root cause, it just exacerbates the sync
>> problem.
>>
>> In a clustered env, md_check_recovery() will send the msg
>> METADATA_UPDATED many times during the completion of metadata updates.
>> msg:METADATA_UPDATED notifies another node that the metadata is
>> updated. The current code design requires the local node to set
>> correct metadata values for another node. With db5e653d7c9f,
>> the another node will handle the metadata first and start the sync
>> job before the local node, which triggers the bug.
>>
>> -Heming
>>
>>>
>>>
>>>> ```
>>>>
>>>> How to trigger:
>>>>
>>>> ```(commands @node1)
>>>>   # to easily watch the recovery status
>>>> echo 2000 > /proc/sys/dev/raid/speed_limit_max
>>>> ssh root@node2 "echo 2000 > /proc/sys/dev/raid/speed_limit_max"
>>>>
>>>> mdadm -CR /dev/md0 -l1 -b clustered -n 2 /dev/sda /dev/sdb 
>>>> --assume-clean
>>>> ssh root@node2 mdadm -A /dev/md0 /dev/sda /dev/sdb
>>>> mdadm --manage /dev/md0 --fail /dev/sda --remove /dev/sda
>>>> mdadm --manage /dev/md0 --add /dev/sdc
>>>>
>>>> === "cat /proc/mdstat" on both node, there are no recovery action. ===
>>>> ```
>>>>
>>>> How to fix:
>>>>
>>>> because md layer code logic is hard to restore for speeding up sync job
>>>> on local node, we add new cluster msg to pending the another node to
>>>> active disk.
>>>>
>>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>>> Reviewed-by: Su Yue <glass.su@suse.com>
>>>> ---
>>>>   drivers/md/md-cluster.c | 27 +++++++++++++++++++++++++++
>>>>   drivers/md/md-cluster.h |  2 ++
>>>>   drivers/md/md.c         | 17 ++++++++++++++---
>>>>   3 files changed, 43 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>>>> index 27eaaf9fef94..ab1e3c490279 100644
>>>> --- a/drivers/md/md-cluster.c
>>>> +++ b/drivers/md/md-cluster.c
>>>> @@ -56,6 +56,7 @@ struct resync_info {
>>>>   #define        MD_CLUSTER_ALREADY_IN_CLUSTER        6
>>>>   #define        MD_CLUSTER_PENDING_RECV_EVENT        7
>>>>   #define     MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD        8
>>>> +#define        MD_CLUSTER_WAITING_FOR_SYNC        9
>>>>   struct md_cluster_info {
>>>>       struct mddev *mddev; /* the md device which md_cluster_info 
>>>> belongs to */
>>>> @@ -91,6 +92,7 @@ struct md_cluster_info {
>>>>       sector_t sync_hi;
>>>>   };
>>>> +/* For compatibility, add the new msg_type at the end. */
>>>>   enum msg_type {
>>>>       METADATA_UPDATED = 0,
>>>>       RESYNCING,
>>>> @@ -100,6 +102,7 @@ enum msg_type {
>>>>       BITMAP_NEEDS_SYNC,
>>>>       CHANGE_CAPACITY,
>>>>       BITMAP_RESIZE,
>>>> +    RESYNCING_START,
>>>>   };
>>>>   struct cluster_msg {
>>>> @@ -460,6 +463,7 @@ static void process_suspend_info(struct mddev 
>>>> *mddev,
>>>>           clear_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
>>>>           remove_suspend_info(mddev, slot);
>>>>           set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>>> +        clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
>>>>           md_wakeup_thread(mddev->thread);
>>>>           return;
>>>>       }
>>>> @@ -530,6 +534,7 @@ static int process_add_new_disk(struct mddev 
>>>> *mddev, struct cluster_msg *cmsg)
>>>>           res = -1;
>>>>       }
>>>>       clear_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
>>>> +    set_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
>>>>       return res;
>>>>   }
>>>> @@ -598,6 +603,9 @@ static int process_recvd_msg(struct mddev 
>>>> *mddev, struct cluster_msg *msg)
>>>>       case CHANGE_CAPACITY:
>>>>           set_capacity_and_notify(mddev->gendisk, 
>>>> mddev->array_sectors);
>>>>           break;
>>>> +    case RESYNCING_START:
>>>> +        clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, 
>>>> &mddev->cluster_info->state);
>>>> +        break;
>>>>       case RESYNCING:
>>>>           set_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
>>>>           process_suspend_info(mddev, le32_to_cpu(msg->slot),
>>>> @@ -1353,6 +1361,23 @@ static void resync_info_get(struct mddev 
>>>> *mddev, sector_t *lo, sector_t *hi)
>>>>       spin_unlock_irq(&cinfo->suspend_lock);
>>>>   }
>>>> +static int resync_status_get(struct mddev *mddev)
>>>> +{
>>>> +    struct md_cluster_info *cinfo = mddev->cluster_info;
>>>> +
>>>> +    return test_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
>>>> +}
>>>> +
>>>> +static int resync_start_notify(struct mddev *mddev)
>>>> +{
>>>> +    struct md_cluster_info *cinfo = mddev->cluster_info;
>>>> +    struct cluster_msg cmsg = {0};
>>>> +
>>>> +    cmsg.type = cpu_to_le32(RESYNCING_START);
>>>> +
>>>> +    return sendmsg(cinfo, &cmsg, 0);
>>>> +}
>>>> +
>>>>   static int resync_info_update(struct mddev *mddev, sector_t lo, 
>>>> sector_t hi)
>>>>   {
>>>>       struct md_cluster_info *cinfo = mddev->cluster_info;
>>>> @@ -1587,6 +1612,8 @@ static struct md_cluster_operations 
>>>> cluster_ops = {
>>>>       .resync_start = resync_start,
>>>>       .resync_finish = resync_finish,
>>>>       .resync_info_update = resync_info_update,
>>>> +    .resync_start_notify = resync_start_notify,
>>>> +    .resync_status_get = resync_status_get,
>>>>       .resync_info_get = resync_info_get,
>>>>       .metadata_update_start = metadata_update_start,
>>>>       .metadata_update_finish = metadata_update_finish,
>>>> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
>>>> index a78e3021775d..470bf18ffde5 100644
>>>> --- a/drivers/md/md-cluster.h
>>>> +++ b/drivers/md/md-cluster.h
>>>> @@ -14,6 +14,8 @@ struct md_cluster_operations {
>>>>       int (*leave)(struct mddev *mddev);
>>>>       int (*slot_number)(struct mddev *mddev);
>>>>       int (*resync_info_update)(struct mddev *mddev, sector_t lo, 
>>>> sector_t hi);
>>>> +    int (*resync_start_notify)(struct mddev *mddev);
>>>> +    int (*resync_status_get)(struct mddev *mddev);
>>>>       void (*resync_info_get)(struct mddev *mddev, sector_t *lo, 
>>>> sector_t *hi);
>>>>       int (*metadata_update_start)(struct mddev *mddev);
>>>>       int (*metadata_update_finish)(struct mddev *mddev);
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index e575e74aabf5..97d7e96d1d5e 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -8902,7 +8902,8 @@ void md_do_sync(struct md_thread *thread)
>>>>        * This will mean we have to start checking from the beginning 
>>>> again.
>>>>        *
>>>>        */
>>>> -
>>>> +    if (mddev_is_clustered(mddev))
>>>> +        md_cluster_ops->resync_start_notify(mddev);
>>>>       do {
>>>>           int mddev2_minor = -1;
>>>>           mddev->curr_resync = MD_RESYNC_DELAYED;
>>>> @@ -9963,8 +9964,18 @@ static void check_sb_changes(struct mddev 
>>>> *mddev, struct md_rdev *rdev)
>>>>                */
>>>>               if (rdev2->raid_disk == -1 && role != 
>>>> MD_DISK_ROLE_SPARE &&
>>>>                   !(le32_to_cpu(sb->feature_map) &
>>>> -                  MD_FEATURE_RESHAPE_ACTIVE)) {
>>>> -                rdev2->saved_raid_disk = role;
>>>> +                  MD_FEATURE_RESHAPE_ACTIVE) &&
>>>> +                !md_cluster_ops->resync_status_get(mddev)) {
>>>> +                /*
>>>> +                 * -1 to make raid1_add_disk() set conf->fullsync
>>>> +                 * to 1. This could avoid skipping sync when the
>>>> +                 * remote node is down during resyncing.
>>>> +                 */
>>>> +                if ((le32_to_cpu(sb->feature_map)
>>>> +                    & MD_FEATURE_RECOVERY_OFFSET))
>>>> +                    rdev2->saved_raid_disk = -1;
>>>> +                else
>>>> +                    rdev2->saved_raid_disk = role;
>>>>                   ret = remove_and_add_spares(mddev, rdev2);
>>>>                   pr_info("Activated spare: %pg\n",
>>>>                       rdev2->bdev);
>>>>
>>>
>>
> 
> 
> .
> 


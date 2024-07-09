Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DD7197
	for <linux-raid@vger.kernel.org>; Tue,  9 Jul 2024 00:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720485257; cv=none; b=P+2HQlflf3NO6+8uJWlgStnPeRIgNZx1aCo2YG/IB7oEddnS0ypEv6t8VHJ2JocSrX99naX1eHXdg8LcTTDLmMJ2VXCGEm+iFSIaCnjJHnjAtMT81VKti98DoIEUKakmnjT59OUTAdDkRl+Q7ztHab/6zfdQqRyA2I2XeIvpK8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720485257; c=relaxed/simple;
	bh=EUkSBYBBgKWY9tHDP2Kok/EUF9NAVtjkBOY15/2xZLg=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=mGRX3YgMxSGNRF1EGURwuOb7uC3+iYEqp3GvcapJw3DnOzLfN/e7XH73i4RWkFmlC4vU3wcCtUozLtja7E1rPsXRTizBXSMowVvq4Uq7Ivm2jUSuw+QnYgA2Hl3vXKEiO+RBKnF18TzssuHANboaZh+0CgXgXcc4X50UiWEMm9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=YO7+0DqH; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="YO7+0DqH"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-52e94eaf5efso5375447e87.2
        for <linux-raid@vger.kernel.org>; Mon, 08 Jul 2024 17:34:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1720485251; x=1721090051; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NhV9sqqfVAB1X1jyr7WQyhY8oza8KoMZ/jn1G30avjQ=;
        b=YO7+0DqHxHUGx1zyPBMrl5Ly++16RU3frRJHgBPeV3RuBBKJavIqizMnKTWsVx3PQm
         J0a8qA/+mKS264m5W1dmWTk6l0qORR+0NFq+S0jb2epT3BmeimsHNwPkzRIvQ+V0naw3
         eBIq8kzJFwdaH63ziCWofpLsuxjcwFyI//ljX+is3TeXw4gdGFXrjMMRIIBjE3yg3EK7
         57mVv16TGuscj5j5uKvQ4kSpSRiaKfPhEt6oikRwwh96FxjHl593MIWTeaAWCdI5JH/C
         iQPC6AfB/++9p2BSIUrUJHRwoEBKTaBVG5Mk2uhhdWIIm1DeoShLhDEVu0OgJPx2+khU
         YgYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720485251; x=1721090051;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NhV9sqqfVAB1X1jyr7WQyhY8oza8KoMZ/jn1G30avjQ=;
        b=gaszuHhlEWYj7fq7IYLH9Eve5WR0hypl0dCeQDNBsjVhujmS4jD6+jwrTpOGGNS3F+
         FQRa+zMNscBtFf3iJ8RyxUIy3shkdkTijMtx7VN+Sz5B6tOHiHYmccyh9n5sH1Mv/QOw
         IsuiNZp09ruS37sTirYffRDnziXmNbtLRC7cv3j9paxArOcP1rBjqMjETNJDxtEo2CnR
         LL0l3vwVRKcxPoIOlCJ7A88IQOI3VrjXqRNw8RZaVVv5qu/uUipbbtZrLMlSrXqXG5Jt
         zi+YsxpFM7J/dP4Qeb0URa8TtMioojggXvZAHaTvosK3li3i5axbaAJ60oxJVUc3EzWA
         nTOg==
X-Forwarded-Encrypted: i=1; AJvYcCXXe0p77ZEB84NiM9fMhITSBaEDCWw+S6eqSkGPh78imuwv09IbQG1o59JBqGql8Krir/YO1uYECFH1MV3Kott8m8tQBaoN+l8Hkg==
X-Gm-Message-State: AOJu0YzIpRZwMfxJDfSBDigJFG9dvQr9Kq4VeGJvxbMOZqYY+c5/U/jy
	LemNH1EdJ6M2+h1u3jOjv121g6mcDLblrTtcQTR3vV1s34JnohbqywVihRtANLo=
X-Google-Smtp-Source: AGHT+IHWSpXV5AhiwlhvrBiaL+PmYeb1SPdctiztDn7SC16cvkUPJ90H/6jTMUnO2fMnaVLhfpbacw==
X-Received: by 2002:a05:6512:791:b0:52c:dfa2:5ac1 with SMTP id 2adb3069b0e04-52eb9997b39mr322731e87.24.1720485251478;
        Mon, 08 Jul 2024 17:34:11 -0700 (PDT)
Received: from [10.202.0.23] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fbb6acfd05sm4365945ad.262.2024.07.08.17.34.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jul 2024 17:34:10 -0700 (PDT)
Message-ID: <f14a75fb-6f5f-490b-b968-51da56fec746@suse.com>
Date: Tue, 9 Jul 2024 08:34:07 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] md-cluster: fix no recovery job when adding/re-adding
 a disk
Content-Language: en-US
From: Heming Zhao <heming.zhao@suse.com>
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org, xni@redhat.com
Cc: glass.su@suse.com, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240612021911.11043-1-heming.zhao@suse.com>
 <20240612021911.11043-2-heming.zhao@suse.com>
 <532f0d59-b34c-63ff-a84e-cc590e7477ef@huaweicloud.com>
 <be09f807-afc5-487f-a822-14d4e3f55cc9@suse.com>
In-Reply-To: <be09f807-afc5-487f-a822-14d4e3f55cc9@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello Kuai,

ping...

On 6/29/24 19:16, Heming Zhao wrote:
> On 6/27/24 21:00, Yu Kuai wrote:
>> Hi,
>>
>> 在 2024/06/12 10:19, Heming Zhao 写道:
>>> The commit db5e653d7c9f ("md: delay choosing sync action to
>>> md_start_sync()") delays the start of the sync action. In a
>>> clustered environment, this will cause another node to first
>>> activate the spare disk and skip recovery. As a result, no
>>> nodes will perform recovery when a disk is added or re-added.
>>>
>>> Before db5e653d7c9f:
>>>
>>> ```
>>>     node1                                node2
>>> ----------------------------------------------------------------
>>> md_check_recovery
>>>   + md_update_sb
>>>   |  sendmsg: METADATA_UPDATED
>>>   + md_choose_sync_action           process_metadata_update
>>>   |  remove_and_add_spares           //node1 has not finished adding
>>>   + call mddev->sync_work            //the spare disk:do nothing
>>>
>>> md_start_sync
>>>   starts md_do_sync
>>>
>>> md_do_sync
>>>   + grabbed resync_lockres:DLM_LOCK_EX
>>>   + do syncing job
>>>
>>> md_check_recovery
>>>   sendmsg: METADATA_UPDATED
>>>                                   process_metadata_update
>>>                                     //activate spare disk
>>>
>>>                                   ... ...
>>>
>>>                                   md_do_sync
>>>                                    waiting to grab resync_lockres:EX
>>> ```
>>>
>>> After db5e653d7c9f:
>>>
>>> (note: if 'cmd:idle' sets MD_RECOVERY_INTR after md_check_recovery
>>> starts md_start_sync, setting the INTR action will exacerbate the
>>> delay in node1 calling the md_do_sync function.)
>>>
>>> ```
>>>     node1                                node2
>>> ----------------------------------------------------------------
>>> md_check_recovery
>>>   + md_update_sb
>>>   |  sendmsg: METADATA_UPDATED
>>>   + calls mddev->sync_work         process_metadata_update
>>>                                     //node1 has not finished adding
>>>                                     //the spare disk:do nothing
>>>
>>> md_start_sync
>>>   + md_choose_sync_action
>>>   |  remove_and_add_spares
>>>   + calls md_do_sync
>>>
>>> md_check_recovery
>>>   md_update_sb
>>>    sendmsg: METADATA_UPDATED
>>>                                    process_metadata_update
>>>                                      //activate spare disk
>>>
>>>    ... ...                         ... ...
>>>
>>>                                    md_do_sync
>>>                                     + grabbed resync_lockres:EX
>>>                                     + raid1_sync_request skip sync under
>>>                      conf->fullsync:0
>>> md_do_sync
>>>   1. waiting to grab resync_lockres:EX
>>>   2. when node1 could grab EX lock,
>>>      node1 will skip resync under recovery_offset:MaxSector
>>
>> I have a question here, because md_do_sync() and the second
>> md_check_recovery() are completely irrelevant, so with or without
>> the commit db5e653d7c9f, the problem is always there?
>>
>> Thanks,
>> Kuai
> 
> I performed a bi-search job. The commit f52f5c71f3d4 ("md: fix
> stopping sync thread") is the first sync failure commit. However,
> f52f5c71f3d4 is not the root cause, it just exacerbates the sync
> problem.
> 
> In a clustered env, md_check_recovery() will send the msg
> METADATA_UPDATED many times during the completion of metadata updates.
> msg:METADATA_UPDATED notifies another node that the metadata is
> updated. The current code design requires the local node to set
> correct metadata values for another node. With db5e653d7c9f,
> the another node will handle the metadata first and start the sync
> job before the local node, which triggers the bug.
> 
> -Heming
> 
>>
>>
>>> ```
>>>
>>> How to trigger:
>>>
>>> ```(commands @node1)
>>>   # to easily watch the recovery status
>>> echo 2000 > /proc/sys/dev/raid/speed_limit_max
>>> ssh root@node2 "echo 2000 > /proc/sys/dev/raid/speed_limit_max"
>>>
>>> mdadm -CR /dev/md0 -l1 -b clustered -n 2 /dev/sda /dev/sdb --assume-clean
>>> ssh root@node2 mdadm -A /dev/md0 /dev/sda /dev/sdb
>>> mdadm --manage /dev/md0 --fail /dev/sda --remove /dev/sda
>>> mdadm --manage /dev/md0 --add /dev/sdc
>>>
>>> === "cat /proc/mdstat" on both node, there are no recovery action. ===
>>> ```
>>>
>>> How to fix:
>>>
>>> because md layer code logic is hard to restore for speeding up sync job
>>> on local node, we add new cluster msg to pending the another node to
>>> active disk.
>>>
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> Reviewed-by: Su Yue <glass.su@suse.com>
>>> ---
>>>   drivers/md/md-cluster.c | 27 +++++++++++++++++++++++++++
>>>   drivers/md/md-cluster.h |  2 ++
>>>   drivers/md/md.c         | 17 ++++++++++++++---
>>>   3 files changed, 43 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>>> index 27eaaf9fef94..ab1e3c490279 100644
>>> --- a/drivers/md/md-cluster.c
>>> +++ b/drivers/md/md-cluster.c
>>> @@ -56,6 +56,7 @@ struct resync_info {
>>>   #define        MD_CLUSTER_ALREADY_IN_CLUSTER        6
>>>   #define        MD_CLUSTER_PENDING_RECV_EVENT        7
>>>   #define     MD_CLUSTER_HOLDING_MUTEX_FOR_RECVD        8
>>> +#define        MD_CLUSTER_WAITING_FOR_SYNC        9
>>>   struct md_cluster_info {
>>>       struct mddev *mddev; /* the md device which md_cluster_info belongs to */
>>> @@ -91,6 +92,7 @@ struct md_cluster_info {
>>>       sector_t sync_hi;
>>>   };
>>> +/* For compatibility, add the new msg_type at the end. */
>>>   enum msg_type {
>>>       METADATA_UPDATED = 0,
>>>       RESYNCING,
>>> @@ -100,6 +102,7 @@ enum msg_type {
>>>       BITMAP_NEEDS_SYNC,
>>>       CHANGE_CAPACITY,
>>>       BITMAP_RESIZE,
>>> +    RESYNCING_START,
>>>   };
>>>   struct cluster_msg {
>>> @@ -460,6 +463,7 @@ static void process_suspend_info(struct mddev *mddev,
>>>           clear_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
>>>           remove_suspend_info(mddev, slot);
>>>           set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>> +        clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
>>>           md_wakeup_thread(mddev->thread);
>>>           return;
>>>       }
>>> @@ -530,6 +534,7 @@ static int process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
>>>           res = -1;
>>>       }
>>>       clear_bit(MD_CLUSTER_WAITING_FOR_NEWDISK, &cinfo->state);
>>> +    set_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
>>>       return res;
>>>   }
>>> @@ -598,6 +603,9 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
>>>       case CHANGE_CAPACITY:
>>>           set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
>>>           break;
>>> +    case RESYNCING_START:
>>> +        clear_bit(MD_CLUSTER_WAITING_FOR_SYNC, &mddev->cluster_info->state);
>>> +        break;
>>>       case RESYNCING:
>>>           set_bit(MD_RESYNCING_REMOTE, &mddev->recovery);
>>>           process_suspend_info(mddev, le32_to_cpu(msg->slot),
>>> @@ -1353,6 +1361,23 @@ static void resync_info_get(struct mddev *mddev, sector_t *lo, sector_t *hi)
>>>       spin_unlock_irq(&cinfo->suspend_lock);
>>>   }
>>> +static int resync_status_get(struct mddev *mddev)
>>> +{
>>> +    struct md_cluster_info *cinfo = mddev->cluster_info;
>>> +
>>> +    return test_bit(MD_CLUSTER_WAITING_FOR_SYNC, &cinfo->state);
>>> +}
>>> +
>>> +static int resync_start_notify(struct mddev *mddev)
>>> +{
>>> +    struct md_cluster_info *cinfo = mddev->cluster_info;
>>> +    struct cluster_msg cmsg = {0};
>>> +
>>> +    cmsg.type = cpu_to_le32(RESYNCING_START);
>>> +
>>> +    return sendmsg(cinfo, &cmsg, 0);
>>> +}
>>> +
>>>   static int resync_info_update(struct mddev *mddev, sector_t lo, sector_t hi)
>>>   {
>>>       struct md_cluster_info *cinfo = mddev->cluster_info;
>>> @@ -1587,6 +1612,8 @@ static struct md_cluster_operations cluster_ops = {
>>>       .resync_start = resync_start,
>>>       .resync_finish = resync_finish,
>>>       .resync_info_update = resync_info_update,
>>> +    .resync_start_notify = resync_start_notify,
>>> +    .resync_status_get = resync_status_get,
>>>       .resync_info_get = resync_info_get,
>>>       .metadata_update_start = metadata_update_start,
>>>       .metadata_update_finish = metadata_update_finish,
>>> diff --git a/drivers/md/md-cluster.h b/drivers/md/md-cluster.h
>>> index a78e3021775d..470bf18ffde5 100644
>>> --- a/drivers/md/md-cluster.h
>>> +++ b/drivers/md/md-cluster.h
>>> @@ -14,6 +14,8 @@ struct md_cluster_operations {
>>>       int (*leave)(struct mddev *mddev);
>>>       int (*slot_number)(struct mddev *mddev);
>>>       int (*resync_info_update)(struct mddev *mddev, sector_t lo, sector_t hi);
>>> +    int (*resync_start_notify)(struct mddev *mddev);
>>> +    int (*resync_status_get)(struct mddev *mddev);
>>>       void (*resync_info_get)(struct mddev *mddev, sector_t *lo, sector_t *hi);
>>>       int (*metadata_update_start)(struct mddev *mddev);
>>>       int (*metadata_update_finish)(struct mddev *mddev);
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index e575e74aabf5..97d7e96d1d5e 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -8902,7 +8902,8 @@ void md_do_sync(struct md_thread *thread)
>>>        * This will mean we have to start checking from the beginning again.
>>>        *
>>>        */
>>> -
>>> +    if (mddev_is_clustered(mddev))
>>> +        md_cluster_ops->resync_start_notify(mddev);
>>>       do {
>>>           int mddev2_minor = -1;
>>>           mddev->curr_resync = MD_RESYNC_DELAYED;
>>> @@ -9963,8 +9964,18 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
>>>                */
>>>               if (rdev2->raid_disk == -1 && role != MD_DISK_ROLE_SPARE &&
>>>                   !(le32_to_cpu(sb->feature_map) &
>>> -                  MD_FEATURE_RESHAPE_ACTIVE)) {
>>> -                rdev2->saved_raid_disk = role;
>>> +                  MD_FEATURE_RESHAPE_ACTIVE) &&
>>> +                !md_cluster_ops->resync_status_get(mddev)) {
>>> +                /*
>>> +                 * -1 to make raid1_add_disk() set conf->fullsync
>>> +                 * to 1. This could avoid skipping sync when the
>>> +                 * remote node is down during resyncing.
>>> +                 */
>>> +                if ((le32_to_cpu(sb->feature_map)
>>> +                    & MD_FEATURE_RECOVERY_OFFSET))
>>> +                    rdev2->saved_raid_disk = -1;
>>> +                else
>>> +                    rdev2->saved_raid_disk = role;
>>>                   ret = remove_and_add_spares(mddev, rdev2);
>>>                   pr_info("Activated spare: %pg\n",
>>>                       rdev2->bdev);
>>>
>>
> 


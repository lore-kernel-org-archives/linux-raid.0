Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB17DC43334
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 03:29:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbiFFD3O (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 5 Jun 2022 23:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232586AbiFFD3N (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 5 Jun 2022 23:29:13 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFCA113DD8
        for <linux-raid@vger.kernel.org>; Sun,  5 Jun 2022 20:29:11 -0700 (PDT)
Subject: Re: [PATCH] md: only unlock mddev from action_store
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654486146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3CdaM2HbAKrvUdWE5fvammJ4ALbJYroKhY/3VJLbNgc=;
        b=Shw+zWFUBxDkGrTXvzj0yUe5lLeBEWHaN+KxyvSWZ6PF7qj2yY9Lwb0gNSdDUGdmgzzGvs
        TV+LqEZ6sPLzEJjzZ+0tnMNkidCDAY5MDy1TpjkPHU7lSQioZdGgPbdy/VCHfUvhT/6Fx3
        j+WUZtebSS/QCKrIeb4/GSnUvEheBxg=
To:     Logan Gunthorpe <logang@deltatee.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, buczek@molgen.mpg.de
References: <20220602134509.16662-1-guoqing.jiang@linux.dev>
 <a6a1183b-35ca-b321-cbd5-08e2a9e29ca3@deltatee.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <9b25a8d4-bedf-35bb-6928-3cd49a025460@linux.dev>
Date:   Mon, 6 Jun 2022 11:29:03 +0800
MIME-Version: 1.0
In-Reply-To: <a6a1183b-35ca-b321-cbd5-08e2a9e29ca3@deltatee.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 6/3/22 2:03 AM, Logan Gunthorpe wrote:
>
>
> On 2022-06-02 07:45, Guoqing Jiang wrote:
>> The 07reshape5intr test is broke because of below path.
>>
>>      md_reap_sync_thread
>>              -> mddev_unlock
>>              -> md_unregister_thread(&mddev->sync_thread)
>>
>> And md_check_recovery is triggered by,
>>
>> mddev_unlock -> md_wakeup_thread(mddev->thread)
>>
>> then mddev->reshape_position is set to MaxSector in raid5_finish_reshape
>> since MD_RECOVERY_INTR is cleared in md_check_recovery, which means
>> feature_map is not set with MD_FEATURE_RESHAPE_ACTIVE and superblock's
>> reshape_position can't be updated accordingly.
>>
>> Since the bug which commit 8b48ec23cc51a ("md: don't unregister sync_thread
>> with reconfig_mutex held") fixed is related with action_store path, other
>> callers which reap sync_thread didn't need to be changed, let's
>>
>> 1. only unlock mddev in md_reap_sync_thread if caller is action_store,
>>     so the parameter is renamed to reflect the change.
>> 2. save some contexts (MD_RECOVERY_INTR and reshape_position) since they
>>     could be changed by other processes, then restore them after get lock
>>     again.
>>
>> Fixes: 8b48ec23cc51a ("md: don't unregister sync_thread with reconfig_mutex held")
>> Reported-by: Logan Gunthorpe <logang@deltatee.com>
>> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
>> ---
>> I suppose the previous bug still can be fixed with the change, but it is
>> better to verify it. Donald, could you help to test the new code?
>>
>> Thanks,
>> Guoqing
>>
>>   drivers/md/md.c | 24 ++++++++++++++++++------
>>   drivers/md/md.h |  2 +-
>>   2 files changed, 19 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 5c8efef13881..3387260dd55b 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6197,7 +6197,7 @@ static void __md_stop_writes(struct mddev *mddev)
>>   		flush_workqueue(md_misc_wq);
>>   	if (mddev->sync_thread) {
>>   		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>> -		md_reap_sync_thread(mddev, true);
>> +		md_reap_sync_thread(mddev, false);
>>   	}
>>   
>>   	del_timer_sync(&mddev->safemode_timer);
>> @@ -9303,7 +9303,7 @@ void md_check_recovery(struct mddev *mddev)
>>   			 * ->spare_active and clear saved_raid_disk
>>   			 */
>>   			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>> -			md_reap_sync_thread(mddev, true);
>> +			md_reap_sync_thread(mddev, false);
>>   			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>>   			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>   			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
>> @@ -9338,7 +9338,7 @@ void md_check_recovery(struct mddev *mddev)
>>   			goto unlock;
>>   		}
>>   		if (mddev->sync_thread) {
>> -			md_reap_sync_thread(mddev, true);
>> +			md_reap_sync_thread(mddev, false);
>>   			goto unlock;
>>   		}
>>   		/* Set RUNNING before clearing NEEDED to avoid
>> @@ -9411,18 +9411,30 @@ void md_check_recovery(struct mddev *mddev)
>>   }
>>   EXPORT_SYMBOL(md_check_recovery);
>>   
>> -void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held)
>> +void md_reap_sync_thread(struct mddev *mddev, bool unlock_mddev)
>>   {
>>   	struct md_rdev *rdev;
>>   	sector_t old_dev_sectors = mddev->dev_sectors;
>> +	sector_t old_reshape_position;
>>   	bool is_reshaped = false;
>> +	bool is_interrupted = false;
>>   
>> -	if (reconfig_mutex_held)
>> +	if (unlock_mddev) {
>> +		old_reshape_position = mddev->reshape_position;
>> +		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>> +			is_interrupted = true;
>>   		mddev_unlock(mddev);
>> +	}
>>   	/* resync has finished, collect result */
>>   	md_unregister_thread(&mddev->sync_thread);
>> -	if (reconfig_mutex_held)
>> +	if (unlock_mddev) {
>>   		mddev_lock_nointr(mddev);
>> +		/* restore the previous flag and position */
>> +		mddev->reshape_position = old_reshape_position;
>> +		if (is_interrupted)
>> +			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>> +	}
> Maybe instead of the ugly boolean argument we could pull
> md_unregister_thread() into all the callers and explicitly unlock in the
> single call site that needs it?

After move "md_unregister_thread(&mddev->sync_thread)", then we need to
rename md_reap_sync_thread given it doesn't unregister sync_thread, any
suggestion about the new name? md_behind_reap_sync_thread?

Thanks,
Guoqing




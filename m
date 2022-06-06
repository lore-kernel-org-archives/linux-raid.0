Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90EFEC433EF
	for <linux-raid@archiver.kernel.org>; Mon,  6 Jun 2022 15:49:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbiFFPtg (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Jun 2022 11:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbiFFPte (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Jun 2022 11:49:34 -0400
Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6A0216292
        for <linux-raid@vger.kernel.org>; Mon,  6 Jun 2022 08:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
        MIME-Version:Date:Message-ID:content-disposition;
        bh=7alw3loWc5J5h3qJadzL5zRr6PaG9JKeftLHAkeal6M=; b=Aiorkyld4MQwyVjBXb5s6DHMQZ
        OPz8ONuX4jGsSijJuF6Ja2yOEGxettLQO64b/BKzOD4gW7l48mYXJAvVwa1BX0nI5Y+V0QBB9+Smb
        2YPmexwgv+qAAbxVHCodh5Uk36TziRMGPaJZBKJKYf8ayC96WpHWUu3o2aTgB1pxZJWRWVrGWaySb
        ATUajyFyUC8qdx+SFclgOzJhVkg+4rgXOqSJ7flkIJBY1uUgM6nQ5S/6+FvZ6Z8L0mRackEAJ5+N9
        Su45eTl0QhrRp6k1MKlGBPMTM9oz7zbW+Tx4Jv6r03iYEOvxTGa3r76wn4Uvq9rgRwR9rPGPOVHBr
        TxZ3q1LA==;
Received: from guinness.priv.deltatee.com ([172.16.1.162])
        by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <logang@deltatee.com>)
        id 1nyEy9-000Fa6-Nx; Mon, 06 Jun 2022 09:48:43 -0600
Message-ID: <2e8ae871-8349-2253-fcce-2722b03fe21d@deltatee.com>
Date:   Mon, 6 Jun 2022 09:48:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Content-Language: en-CA
To:     Guoqing Jiang <guoqing.jiang@linux.dev>, song@kernel.org
Cc:     linux-raid@vger.kernel.org, buczek@molgen.mpg.de
References: <20220602134509.16662-1-guoqing.jiang@linux.dev>
 <a6a1183b-35ca-b321-cbd5-08e2a9e29ca3@deltatee.com>
 <9b25a8d4-bedf-35bb-6928-3cd49a025460@linux.dev>
From:   Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <9b25a8d4-bedf-35bb-6928-3cd49a025460@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.162
X-SA-Exim-Rcpt-To: guoqing.jiang@linux.dev, song@kernel.org, linux-raid@vger.kernel.org, buczek@molgen.mpg.de
X-SA-Exim-Mail-From: logang@deltatee.com
Subject: Re: [PATCH] md: only unlock mddev from action_store
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 2022-06-05 21:29, Guoqing Jiang wrote:
> 
> 
> On 6/3/22 2:03 AM, Logan Gunthorpe wrote:
>>
>>
>> On 2022-06-02 07:45, Guoqing Jiang wrote:
>>> The 07reshape5intr test is broke because of below path.
>>>
>>>      md_reap_sync_thread
>>>              -> mddev_unlock
>>>              -> md_unregister_thread(&mddev->sync_thread)
>>>
>>> And md_check_recovery is triggered by,
>>>
>>> mddev_unlock -> md_wakeup_thread(mddev->thread)
>>>
>>> then mddev->reshape_position is set to MaxSector in raid5_finish_reshape
>>> since MD_RECOVERY_INTR is cleared in md_check_recovery, which means
>>> feature_map is not set with MD_FEATURE_RESHAPE_ACTIVE and superblock's
>>> reshape_position can't be updated accordingly.
>>>
>>> Since the bug which commit 8b48ec23cc51a ("md: don't unregister sync_thread
>>> with reconfig_mutex held") fixed is related with action_store path, other
>>> callers which reap sync_thread didn't need to be changed, let's
>>>
>>> 1. only unlock mddev in md_reap_sync_thread if caller is action_store,
>>>     so the parameter is renamed to reflect the change.
>>> 2. save some contexts (MD_RECOVERY_INTR and reshape_position) since they
>>>     could be changed by other processes, then restore them after get lock
>>>     again.
>>>
>>> Fixes: 8b48ec23cc51a ("md: don't unregister sync_thread with reconfig_mutex held")
>>> Reported-by: Logan Gunthorpe <logang@deltatee.com>
>>> Signed-off-by: Guoqing Jiang <guoqing.jiang@linux.dev>
>>> ---
>>> I suppose the previous bug still can be fixed with the change, but it is
>>> better to verify it. Donald, could you help to test the new code?
>>>
>>> Thanks,
>>> Guoqing
>>>
>>>   drivers/md/md.c | 24 ++++++++++++++++++------
>>>   drivers/md/md.h |  2 +-
>>>   2 files changed, 19 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 5c8efef13881..3387260dd55b 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -6197,7 +6197,7 @@ static void __md_stop_writes(struct mddev *mddev)
>>>   		flush_workqueue(md_misc_wq);
>>>   	if (mddev->sync_thread) {
>>>   		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>> -		md_reap_sync_thread(mddev, true);
>>> +		md_reap_sync_thread(mddev, false);
>>>   	}
>>>   
>>>   	del_timer_sync(&mddev->safemode_timer);
>>> @@ -9303,7 +9303,7 @@ void md_check_recovery(struct mddev *mddev)
>>>   			 * ->spare_active and clear saved_raid_disk
>>>   			 */
>>>   			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>> -			md_reap_sync_thread(mddev, true);
>>> +			md_reap_sync_thread(mddev, false);
>>>   			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>>>   			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>>>   			clear_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags);
>>> @@ -9338,7 +9338,7 @@ void md_check_recovery(struct mddev *mddev)
>>>   			goto unlock;
>>>   		}
>>>   		if (mddev->sync_thread) {
>>> -			md_reap_sync_thread(mddev, true);
>>> +			md_reap_sync_thread(mddev, false);
>>>   			goto unlock;
>>>   		}
>>>   		/* Set RUNNING before clearing NEEDED to avoid
>>> @@ -9411,18 +9411,30 @@ void md_check_recovery(struct mddev *mddev)
>>>   }
>>>   EXPORT_SYMBOL(md_check_recovery);
>>>   
>>> -void md_reap_sync_thread(struct mddev *mddev, bool reconfig_mutex_held)
>>> +void md_reap_sync_thread(struct mddev *mddev, bool unlock_mddev)
>>>   {
>>>   	struct md_rdev *rdev;
>>>   	sector_t old_dev_sectors = mddev->dev_sectors;
>>> +	sector_t old_reshape_position;
>>>   	bool is_reshaped = false;
>>> +	bool is_interrupted = false;
>>>   
>>> -	if (reconfig_mutex_held)
>>> +	if (unlock_mddev) {
>>> +		old_reshape_position = mddev->reshape_position;
>>> +		if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>>> +			is_interrupted = true;
>>>   		mddev_unlock(mddev);
>>> +	}
>>>   	/* resync has finished, collect result */
>>>   	md_unregister_thread(&mddev->sync_thread);
>>> -	if (reconfig_mutex_held)
>>> +	if (unlock_mddev) {
>>>   		mddev_lock_nointr(mddev);
>>> +		/* restore the previous flag and position */
>>> +		mddev->reshape_position = old_reshape_position;
>>> +		if (is_interrupted)
>>> +			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>> +	}
>> Maybe instead of the ugly boolean argument we could pull
>> md_unregister_thread() into all the callers and explicitly unlock in the
>> single call site that needs it?
> 
> After move "md_unregister_thread(&mddev->sync_thread)", then we need to
> rename md_reap_sync_thread given it doesn't unregister sync_thread, any
> suggestion about the new name? md_behind_reap_sync_thread?

I don't like the "behind"... Which would be a name suggesting when the
function should be called, not what the function does.

I'd maybe go with something like md_cleanup_sync_thread()

Logan

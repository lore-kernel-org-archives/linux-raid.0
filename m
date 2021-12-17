Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 598D7C433F5
	for <linux-raid@archiver.kernel.org>; Fri, 17 Dec 2021 02:16:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhLQCQM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 16 Dec 2021 21:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230224AbhLQCQM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 16 Dec 2021 21:16:12 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15288C061574
        for <linux-raid@vger.kernel.org>; Thu, 16 Dec 2021 18:16:12 -0800 (PST)
Subject: Re: [PATCH 2/3] md: Set MD_BROKEN for RAID1 and RAID10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639707370;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bKOTc40MpWmEHaVV12aRBQTPWFtiBPEuLUhJjtvwGIY=;
        b=naMTfFkgBVGg7LwHSGrZi43P8WusEn/kVwyKMOYH09hx4DyrYx3XAP0bh1dZbq5LOlAklm
        SA+rPYEmehufATp/nDEcjmusZjOysSN9iHRhvxP5P26ofLNHu5Cz7lKoS+ZLgtGrte6bTJ
        rZ7u8ubFyQZk+yCtMxSm8o+h1q1aoWI=
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, song@kernel.org
Cc:     linux-raid@vger.kernel.org
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
 <20211216145222.15370-3-mariusz.tkaczyk@linux.intel.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <2af6e504-7657-4b05-3ed4-45677fe09e27@linux.dev>
Date:   Fri, 17 Dec 2021 10:16:02 +0800
MIME-Version: 1.0
In-Reply-To: <20211216145222.15370-3-mariusz.tkaczyk@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 12/16/21 10:52 PM, Mariusz Tkaczyk wrote:
> There was no direct mechanism to determine raid failure outside
> personality. It was done by checking rdev->flags after executing
> md_error(). If "faulty" was not set then -EBUSY was returned to
> userspace. It causes that mdadm expects -EBUSY if the array
> becomes failed. There are some reasons to not consider this mechanism
> as correct:
> - drive can't be failed for different reasons.
> - there are path where -EBUSY is not reported and drive removal leads
> to failed array, without notification for userspace.
> - in the array failure case -EBUSY seems to be wrong status. Array is
> not busy, but removal process cannot proceed safe.
>
> -EBUSY expectation cannot be removed without breaking compatibility
> with userspace, but we can adopt the failed state verification method.
>
> In this patch MD_BROKEN flag support, used to mark non-redundant array
> as dead, is added to RAID1 and RAID10. Support for RAID456 is added in
> next commit.
>
> Now the array failure can be checked, so verify MD_BROKEN flag, however
> still return -EBUSY to userspace.
>
> As in previous commit, it causes that #mdadm --set-faulty is able to
> mark array as failed. Previously proposed workaround is valid if optional
> functionality 9a567843f79("md: allow last device to be forcibly

s/9a567843f79/9a567843f7ce/

> removed from RAID1/RAID10.") is disabled.
>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
>   drivers/md/md.c     | 17 ++++++++++-------
>   drivers/md/md.h     |  4 ++--
>   drivers/md/raid1.c  |  1 +
>   drivers/md/raid10.c |  1 +
>   4 files changed, 14 insertions(+), 9 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index f888ef197765..fda8473f96b8 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -2983,10 +2983,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
>   
>   	if (cmd_match(buf, "faulty") && rdev->mddev->pers) {
>   		md_error(rdev->mddev, rdev);
> -		if (test_bit(Faulty, &rdev->flags))
> -			err = 0;
> -		else
> +
> +		if (test_bit(MD_BROKEN, &rdev->mddev->flags))
>   			err = -EBUSY;
> +		else
> +			err = 0;
>   	} else if (cmd_match(buf, "remove")) {
>   		if (rdev->mddev->pers) {
>   			clear_bit(Blocked, &rdev->flags);
> @@ -7441,7 +7442,7 @@ static int set_disk_faulty(struct mddev *mddev, dev_t dev)
>   		err =  -ENODEV;
>   	else {
>   		md_error(mddev, rdev);
> -		if (!test_bit(Faulty, &rdev->flags))
> +		if (test_bit(MD_BROKEN, &mddev->flags))
>   			err = -EBUSY;
>   	}
>   	rcu_read_unlock();
> @@ -7987,12 +7988,14 @@ void md_error(struct mddev *mddev, struct md_rdev *rdev)
>   	if (!mddev->pers->sync_request)
>   		return;
>   
> -	if (mddev->degraded)
> +	if (mddev->degraded && !test_bit(MD_BROKEN, &mddev->flags))
>   		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   	sysfs_notify_dirent_safe(rdev->sysfs_state);
>   	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
> -	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> -	md_wakeup_thread(mddev->thread);
> +	if (!test_bit(MD_BROKEN, &mddev->flags)) {
> +		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
> +		md_wakeup_thread(mddev->thread);
> +	}
>   	if (mddev->event_work.func)
>   		queue_work(md_misc_wq, &mddev->event_work);
>   	md_new_event();
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index bc3f2094d0b6..d3a897868695 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -259,8 +259,8 @@ enum mddev_flags {
>   	MD_NOT_READY,		/* do_md_run() is active, so 'array_state'
>   				 * must not report that array is ready yet
>   				 */
> -	MD_BROKEN,              /* This is used in RAID-0/LINEAR only, to stop
> -				 * I/O in case an array member is gone/failed.
> +	MD_BROKEN,              /* This is used to stop I/O and mark device as

IIUC, 'device' actually means array, if so, could you change it to array 
to make it clear?

> +				 * dead in case an array becomes failed.
>   				 */
>   };
>   
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 7dc8026cf6ee..45dc75f90476 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1638,6 +1638,7 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   		 */
>   		conf->recovery_disabled = mddev->recovery_disabled;
>   		spin_unlock_irqrestore(&conf->device_lock, flags);
> +		set_bit(MD_BROKEN, &mddev->flags);
>   		return;
>   	}
>   	set_bit(Blocked, &rdev->flags);
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index dde98f65bd04..d7cefd212e6b 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1964,6 +1964,7 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>   		 * Don't fail the drive, just return an IO error.
>   		 */
>   		spin_unlock_irqrestore(&conf->device_lock, flags);
> +		set_bit(MD_BROKEN, &mddev->flags);
>   		return;
>   	}
>   	if (test_and_clear_bit(In_sync, &rdev->flags))

Thanks,
Guoqing

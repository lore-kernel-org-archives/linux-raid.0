Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7415B22A4F8;
	Sat, 30 Aug 2025 09:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756547505; cv=none; b=qcO9jlUNQbf1OTHAV5NefoD4X/UCW+W4fZgYfHu+xeHFW2d+6D17Hg/Tjl9QWQkN2hsSVshyuy3O+7aUawU81F9hnr9b1eCi4Nd5pd8aKSk5kszY5tKVWfl+u5g750mjjyiDIQxnBP0ZNtT0iPurNl9MpK63dOj1Heu6BqUq5aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756547505; c=relaxed/simple;
	bh=pB82EzBcmyB2LuXxIjdoAHAHn1WGfgtS4UVJVD+eLHs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cbnMcNRA17tPaClCAUfCSAZGNWUzEipz/tJl0MZzVH/Zt8rBUzRgXbununrluN3/Cl0+/dtZXB0DpI/+kdgAY8OORwi1+15L+xEmRZdbOQYAs6l031o8gCnyt11Uqln7PqdQERmLQToYyOmD9v3nWR6Q3OO5b4wf4BuYzTx1nxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af7fb.dynamic.kabel-deutschland.de [95.90.247.251])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id A31DA6004C2C9;
	Sat, 30 Aug 2025 11:51:13 +0200 (CEST)
Message-ID: <8d355b81-9a32-4bb6-9951-0905c05434a4@molgen.mpg.de>
Date: Sat, 30 Aug 2025 11:51:13 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: ensure consistent action state in md_do_sync
To: Li Nan <linan666@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250830090532.4071221-1-linan666@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250830090532.4071221-1-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Nan,


Thank you for your patch.

Am 30.08.25 um 11:05 schrieb linan666@huaweicloud.com:
> From: Li Nan <linan122@huawei.com>
> 
> The 'mddev->recovery' flags can change during md_do_sync(), leading to
> inconsistencies. For example, starting with MD_RECOVERY_RECOVER and
> ending with MD_RECOVERY_SYNC can cause incorrect offset updates.

Can you give a concrete example?

> To avoid this, use the 'action' determined at the beginning of the
> function instead of repeatedly checking 'mddev->recovery'.

Do you have a reproducer?

Add a Fixes: tag?

> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.c | 21 +++++++++------------
>   1 file changed, 9 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6828a569e819..67cda9b64c87 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9516,7 +9516,7 @@ void md_do_sync(struct md_thread *thread)
>   
>   		skipped = 0;
>   
> -		if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> +		if (action != ACTION_RESHAPE &&
>   		    ((mddev->curr_resync > mddev->curr_resync_completed &&
>   		      (mddev->curr_resync - mddev->curr_resync_completed)
>   		      > (max_sectors >> 4)) ||
> @@ -9529,8 +9529,7 @@ void md_do_sync(struct md_thread *thread)
>   			wait_event(mddev->recovery_wait,
>   				   atomic_read(&mddev->recovery_active) == 0);
>   			mddev->curr_resync_completed = j;
> -			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery) &&
> -			    j > mddev->resync_offset)
> +			if (action == ACTION_RESYNC && j > mddev->resync_offset)
>   				mddev->resync_offset = j;
>   			update_time = jiffies;
>   			set_bit(MD_SB_CHANGE_CLEAN, &mddev->sb_flags);
> @@ -9646,7 +9645,7 @@ void md_do_sync(struct md_thread *thread)
>   	blk_finish_plug(&plug);
>   	wait_event(mddev->recovery_wait, !atomic_read(&mddev->recovery_active));
>   
> -	if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> +	if (action != ACTION_RESHAPE &&
>   	    !test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>   	    mddev->curr_resync >= MD_RESYNC_ACTIVE) {
>   		mddev->curr_resync_completed = mddev->curr_resync;
> @@ -9654,9 +9653,8 @@ void md_do_sync(struct md_thread *thread)
>   	}
>   	mddev->pers->sync_request(mddev, max_sectors, max_sectors, &skipped);
>   
> -	if (!test_bit(MD_RECOVERY_CHECK, &mddev->recovery) &&
> -	    mddev->curr_resync > MD_RESYNC_ACTIVE) {
> -		if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
> +	if (action != ACTION_CHECK && mddev->curr_resync > MD_RESYNC_ACTIVE) {
> +		if (action == ACTION_RESYNC) {
>   			if (test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>   				if (mddev->curr_resync >= mddev->resync_offset) {
>   					pr_debug("md: checkpointing %s of %s.\n",
> @@ -9674,8 +9672,7 @@ void md_do_sync(struct md_thread *thread)
>   		} else {
>   			if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>   				mddev->curr_resync = MaxSector;
> -			if (!test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> -			    test_bit(MD_RECOVERY_RECOVER, &mddev->recovery)) {
> +			if (action == ACTION_RECOVER) {

What about `MD_RECOVERY_RESHAPE`?

>   				rcu_read_lock();
>   				rdev_for_each_rcu(rdev, mddev)
>   					if (mddev->delta_disks >= 0 &&
> @@ -9692,7 +9689,7 @@ void md_do_sync(struct md_thread *thread)
>   	set_mask_bits(&mddev->sb_flags, 0,
>   		      BIT(MD_SB_CHANGE_PENDING) | BIT(MD_SB_CHANGE_DEVS));
>   
> -	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
> +	if (action == ACTION_RESHAPE &&
>   			!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
>   			mddev->delta_disks > 0 &&
>   			mddev->pers->finish_reshape &&
> @@ -9709,10 +9706,10 @@ void md_do_sync(struct md_thread *thread)
>   	spin_lock(&mddev->lock);
>   	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>   		/* We completed so min/max setting can be forgotten if used. */
> -		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> +		if (action == ACTION_REPAIR)
>   			mddev->resync_min = 0;
>   		mddev->resync_max = MaxSector;
> -	} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> +	} else if (action == ACTION_REPAIR)
>   		mddev->resync_min = mddev->curr_resync_completed;
>   	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
>   	mddev->curr_resync = MD_RESYNC_NONE;

I have not fully grogged yet, what the consequence of a mismatch between 
`action`, set at the beginning, and changed flags in `&mddev->recovery` are.


Kind regards,

Paul

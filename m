Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC252326958;
	Tue,  6 Jan 2026 12:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767704400; cv=none; b=CDLpJCzqzScKHYSFHgK7Rw0pDO2mhVoT22EUXXEiENMH7VOE/Ge+VNVVD6DzwwzZSXLpftI8WYJVmbPib35cVfO7VKQQn8JepF98bJj0L6OJ9ukJrSr6lIQau30/KJKe7IUwn/3rrros6I1fiz8cy+i++SxEutIOC0fmN/XzA4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767704400; c=relaxed/simple;
	bh=9QeCIcvbrt9ax9C1NV2BjcxzatxfopaJUWQDHEbgYmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pLRedUJt/begsd4dML+NTWLedCJuMZPfJl58GSJ23QP9gkxpu/7sKXibB7pOqbV6Tw0Ucaaqvv3VlfBOWW0IkYSKW+hS678Tlicavm4K5+e/JKkwNL6Eo9iwdpqbNlOirJ6k1i6RrrLOtME7vKGTfPoXkWMLtncIUd1lHR2UteE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dlrpW18fPzKHN3q;
	Tue,  6 Jan 2026 20:59:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E691340562;
	Tue,  6 Jan 2026 20:59:54 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgBHqPhJB11pC_FbCw--.7647S3;
	Tue, 06 Jan 2026 20:59:54 +0800 (CST)
Message-ID: <3b5e935b-0a1b-bf23-8ceb-b45e0b5f1b4b@huaweicloud.com>
Date: Tue, 6 Jan 2026 20:59:53 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC PATCH 1/5] md: add helpers for requested sync action
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com, linan122@h-partners.com
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
 <20251231070952.1233903-2-zhengqixing@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251231070952.1233903-2-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHqPhJB11pC_FbCw--.7647S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XFyrtr47XrWxCw45Xw17GFg_yoW7tFy5pa
	yftFn8Cr4UAFyfXFW7ta4DAFWfZr1xtrZrtryxW3s5JFnxKrs5KF15WwnrAr95ta4kZF4j
	qa4DGFsxuF1a9w7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBSb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Gr0_Cr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E
	8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82
	IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC2
	0s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMI
	IF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF
	0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87
	Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxU7OJ5DUUUU
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/12/31 15:09, Zheng Qixing 写道:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> Add helpers for handling requested sync action.
> 
> In handle_requested_sync_action(), add mutual exclusivity checks between
> check/repair operations. This prevents the scenario where one operation
> is requested, but before MD_RECOVERY_RUNNING is set, another operation is
> requested, resulting in neither an EBUSY return nor proper execution of
> the second operation.
> 
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/md.c | 87 +++++++++++++++++++++++++++++++++++++------------
>   1 file changed, 66 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 5df2220b1bd1..ccaa2e6fe079 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -665,6 +665,59 @@ void mddev_put(struct mddev *mddev)
>   	spin_unlock(&all_mddevs_lock);
>   }
>   
> +static int __handle_requested_sync_action(struct mddev *mddev,
> +					  enum sync_action action)
> +{
> +	switch (action) {
> +	case ACTION_CHECK:
> +		set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> +		fallthrough;
> +	case ACTION_REPAIR:
> +		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
> +		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> +		return 0;
> +	default:
> +		return -EINVAL;
> +	} > +}
> +
> +static int handle_requested_sync_action(struct mddev *mddev,
> +					enum sync_action action)
> +{
> +	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> +		return -EBUSY;

This return change origin logic; split factor out and fix into two patches.

> +	return __handle_requested_sync_action(mddev, action);
> +}
> +

__handle_requested_sync_action does not need to be split.

> +static enum sync_action __get_recovery_sync_action(struct mddev *mddev)
> +{
> +	if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
> +		return ACTION_CHECK;
> +	if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> +		return ACTION_REPAIR;
> +	return ACTION_RESYNC;
> +}
> +
> +static enum sync_action get_recovery_sync_action(struct mddev *mddev)
> +{
> +	return __get_recovery_sync_action(mddev);
> +}
> +

__get_recovery_sync_action also does not need to be split.


> +static void init_recovery_position(struct mddev *mddev)
> +{
> +	mddev->resync_min = 0;
> +}
> +
> +static void set_requested_position(struct mddev *mddev, sector_t value)
> +{
> +	mddev->resync_min = value;
> +}
> +
> +static sector_t get_requested_position(struct mddev *mddev)
> +{
> +	return mddev->resync_min;
> +}
> +

There is no need to factor the operations of resync_min;
'rectify_min' that follows can re-use 'resync_min' directly.

>   static void md_safemode_timeout(struct timer_list *t);
>   static void md_start_sync(struct work_struct *ws);
>   
> @@ -781,7 +834,7 @@ int mddev_init(struct mddev *mddev)
>   	mddev->reshape_position = MaxSector;
>   	mddev->reshape_backwards = 0;
>   	mddev->last_sync_action = ACTION_IDLE;
> -	mddev->resync_min = 0;
> +	init_recovery_position(mddev);
>   	mddev->resync_max = MaxSector;
>   	mddev->level = LEVEL_NONE;
>   
> @@ -5101,17 +5154,9 @@ enum sync_action md_sync_action(struct mddev *mddev)
>   	if (test_bit(MD_RECOVERY_RECOVER, &recovery))
>   		return ACTION_RECOVER;
>   
> -	if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
> -		/*
> -		 * MD_RECOVERY_CHECK must be paired with
> -		 * MD_RECOVERY_REQUESTED.
> -		 */
> -		if (test_bit(MD_RECOVERY_CHECK, &recovery))
> -			return ACTION_CHECK;
> -		if (test_bit(MD_RECOVERY_REQUESTED, &recovery))
> -			return ACTION_REPAIR;
> -		return ACTION_RESYNC;
> -	}
> +	/* MD_RECOVERY_CHECK must be paired with MD_RECOVERY_REQUESTED. */
> +	if (test_bit(MD_RECOVERY_SYNC, &recovery))
> +		return get_recovery_sync_action(mddev);
>   
>   	/*
>   	 * MD_RECOVERY_NEEDED or MD_RECOVERY_RUNNING is set, however, no
> @@ -5300,11 +5345,10 @@ action_store(struct mddev *mddev, const char *page, size_t len)
>   			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
>   			break;
>   		case ACTION_CHECK:
> -			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
> -			fallthrough;
>   		case ACTION_REPAIR:
> -			set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
> -			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> +			ret = handle_requested_sync_action(mddev, action);
> +			if (ret)
> +				goto out;
>   			fallthrough;
>   		case ACTION_RESYNC:
>   		case ACTION_IDLE:
> @@ -6783,7 +6827,7 @@ static void md_clean(struct mddev *mddev)
>   	mddev->dev_sectors = 0;
>   	mddev->raid_disks = 0;
>   	mddev->resync_offset = 0;
> -	mddev->resync_min = 0;
> +	init_recovery_position(mddev);
>   	mddev->resync_max = MaxSector;
>   	mddev->reshape_position = MaxSector;
>   	/* we still need mddev->external in export_rdev, do not clear it yet */
> @@ -9370,7 +9414,7 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
>   	switch (action) {
>   	case ACTION_CHECK:
>   	case ACTION_REPAIR:
> -		return mddev->resync_min;
> +		return get_requested_position(mddev);
>   	case ACTION_RESYNC:
>   		if (!mddev->bitmap)
>   			return mddev->resync_offset;
> @@ -9795,10 +9839,11 @@ void md_do_sync(struct md_thread *thread)
>   	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery)) {
>   		/* We completed so min/max setting can be forgotten if used. */
>   		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> -			mddev->resync_min = 0;
> +			set_requested_position(mddev, 0);
>   		mddev->resync_max = MaxSector;
> -	} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
> -		mddev->resync_min = mddev->curr_resync_completed;
> +	} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
> +		set_requested_position(mddev, mddev->curr_resync_completed);
> +	}
>   	set_bit(MD_RECOVERY_DONE, &mddev->recovery);
>   	mddev->curr_resync = MD_RESYNC_NONE;
>   	spin_unlock(&mddev->lock);

-- 
Thanks,
Nan


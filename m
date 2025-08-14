Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC668F49
	for <linux-raid@vger.kernel.org>; Thu, 14 Aug 2025 02:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755137803; cv=none; b=BmLthoPmmpes2JMJ1BGsC28IRoclLP7ZASzF68ClF9fkbi27yLENvxWfOtMyVKaJR76yCUA03HtDD+Q1NbvXvjyjpJ2DUodGzuaNcX91yK9Z7jYVKLY9ObKv2eXhcpOLjbog2DsaelHRZxOgC+Z2QJgol6SufoxMRHsPzKt3Gyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755137803; c=relaxed/simple;
	bh=IuwWFhQPN6UazvePOMTdV0AKd1fwI/CURML2L2spWdU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fPAmGtAGOFdLH9CtO5h7XqQxqAR1Df6aCuOzZCvXZlnbb7T5+5YyHtbvhsxsZI9dPdd00amPW0k1mSnXHVX4RLsVfJDr5xB/5OjBtbqNqHfba3MS7sm+ugSxfjiIzkrzqkXZFiWP1LeH11+BtfzsKevA/zEYFTkFEs1esCaDPBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c2TPx4LfxzKHLvK
	for <linux-raid@vger.kernel.org>; Thu, 14 Aug 2025 10:16:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DD4D01A1920
	for <linux-raid@vger.kernel.org>; Thu, 14 Aug 2025 10:16:36 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgAXkxMBR51oPxRxDg--.7742S3;
	Thu, 14 Aug 2025 10:16:35 +0800 (CST)
Message-ID: <47e0d14a-f95a-3f5b-d4f6-d5a442c59f92@huaweicloud.com>
Date: Thu, 14 Aug 2025 10:16:33 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH V3 1/1] md: add legacy_async_del_gendisk mode
To: Xiao Ni <xni@redhat.com>, yukuai1@huaweicloud.com
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com, mpatocka@redhat.com,
 luca.boccassi@gmail.com
References: <20250812134549.36565-1-xni@redhat.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20250812134549.36565-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXkxMBR51oPxRxDg--.7742S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKF48Aw43Cr43JF4kWr15Arb_yoW7AryDp3
	y8tFn0krWUJFW2vrZrtw1DZF1rWwn7JrWkKFy3CryS9a4aqw1Uur1fu390gryqqrZ5Zr4Y
	va1jvF4fWr1xKrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9E14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbsYFJUUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/8/12 21:45, Xiao Ni 写道:
> commit 9e59d609763f ("md: call del_gendisk in control path") changes the
> async way to sync way of calling del_gendisk. But it breaks mdadm
> --assemble command. The assemble command runs like this:
> 1. create the array
> 2. stop the array
> 3. access the sysfs files after stopping
> 
> The sync way calls del_gendisk in step 2, so all sysfs files are removed.
> Now to avoid breaking mdadm assemble command, this patch adds the parameter
> legacy_async_del_gendisk that can be used to choose which way. The default
> is async way. In future, we plan to remove this parameter in kernel 7.0.
> Then users need to upgrade to mdadm 4.5 which removes step 2.
> 
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Closes: https://lore.kernel.org/linux-raid/CAMw=ZnQ=ET2St-+hnhsuq34rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com/T/#t
> Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
> v2: minor changes on format and log content
> v3: changes in commit message and log content
>   drivers/md/md.c | 56 ++++++++++++++++++++++++++++++++++++-------------
>   1 file changed, 42 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac85ec73a409..a42f2e38eb0b 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -339,6 +339,7 @@ static int start_readonly;
>    * so all the races disappear.
>    */
>   static bool create_on_open = true;
> +static bool legacy_async_del_gendisk = true;
>   
>   /*
>    * We have a system wide 'event count' that is incremented
> @@ -877,15 +878,18 @@ void mddev_unlock(struct mddev *mddev)
>   		export_rdev(rdev, mddev);
>   	}
>   
> -	/* Call del_gendisk after release reconfig_mutex to avoid
> -	 * deadlock (e.g. call del_gendisk under the lock and an
> -	 * access to sysfs files waits the lock)
> -	 * And MD_DELETED is only used for md raid which is set in
> -	 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
> -	 * doesn't need to check MD_DELETED when getting reconfig lock
> -	 */
> -	if (test_bit(MD_DELETED, &mddev->flags))
> -		del_gendisk(mddev->gendisk);
> +	if (!legacy_async_del_gendisk) {
> +		/*
> +		 * Call del_gendisk after release reconfig_mutex to avoid
> +		 * deadlock (e.g. call del_gendisk under the lock and an
> +		 * access to sysfs files waits the lock)
> +		 * And MD_DELETED is only used for md raid which is set in
> +		 * do_md_stop. dm raid only uses md_stop to stop. So dm raid
> +		 * doesn't need to check MD_DELETED when getting reconfig lock
> +		 */
> +		if (test_bit(MD_DELETED, &mddev->flags))
> +			del_gendisk(mddev->gendisk);
> +	}
>   }
>   EXPORT_SYMBOL_GPL(mddev_unlock);
>   
> @@ -5818,6 +5822,13 @@ static void md_kobj_release(struct kobject *ko)
>   {
>   	struct mddev *mddev = container_of(ko, struct mddev, kobj);
>   
> +	if (legacy_async_del_gendisk) {
> +		if (mddev->sysfs_state)
> +			sysfs_put(mddev->sysfs_state);
> +		if (mddev->sysfs_level)
> +			sysfs_put(mddev->sysfs_level);
> +		del_gendisk(mddev->gendisk);
> +	}
>   	put_disk(mddev->gendisk);
>   }
>   
> @@ -6021,6 +6032,9 @@ static int md_alloc_and_put(dev_t dev, char *name)
>   {
>   	struct mddev *mddev = md_alloc(dev, name);
>   
> +	if (legacy_async_del_gendisk)
> +		pr_warn("md: async del_gendisk mode will be removed in kernel 7.0, please upgrade to mdadm-4.5+\n");
> +
>   	if (IS_ERR(mddev))
>   		return PTR_ERR(mddev);
>   	mddev_put(mddev);
> @@ -6431,10 +6445,22 @@ static void md_clean(struct mddev *mddev)
>   	mddev->persistent = 0;
>   	mddev->level = LEVEL_NONE;
>   	mddev->clevel[0] = 0;
> -	/* if UNTIL_STOP is set, it's cleared here */
> -	mddev->hold_active = 0;
> -	/* Don't clear MD_CLOSING, or mddev can be opened again. */
> -	mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
> +
> +	/*
> +	 * For legacy_async_del_gendisk mode, it can stop the array in the
> +	 * middle of assembling it, then it still can access the array. So
> +	 * it needs to clear MD_CLOSING. If not legacy_async_del_gendisk,
> +	 * it can't open the array again after stopping it. So it doesn't
> +	 * clear MD_CLOSING.
> +	 */
> +	if (legacy_async_del_gendisk && mddev->hold_active) {
> +		clear_bit(MD_CLOSING, &mddev->flags);
> +	} else {
> +		/* if UNTIL_STOP is set, it's cleared here */
> +		mddev->hold_active = 0;
> +		/* Don't clear MD_CLOSING, or mddev can be opened again. */
> +		mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
> +	}
>   	mddev->sb_flags = 0;
>   	mddev->ro = MD_RDWR;
>   	mddev->metadata_type[0] = 0;
> @@ -6658,7 +6684,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
>   
>   		export_array(mddev);
>   		md_clean(mddev);
> -		set_bit(MD_DELETED, &mddev->flags);
> +		if (!legacy_async_del_gendisk)
> +			set_bit(MD_DELETED, &mddev->flags);
>   	}
>   	md_new_event();
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
> @@ -10392,6 +10419,7 @@ module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
>   module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
>   module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
>   module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
> +module_param(legacy_async_del_gendisk, bool, 0600);
>   
>   MODULE_LICENSE("GPL");
>   MODULE_DESCRIPTION("MD RAID framework");


LGTM, feel free to add

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan


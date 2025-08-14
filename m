Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9FA2566
	for <linux-raid@vger.kernel.org>; Thu, 14 Aug 2025 00:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755132851; cv=none; b=A93fszl6VS5B3GsDVqRosWg50unJLVJik0InwngYwvGay3dVyr+1IcwcYReILRBbSamL76qJTAqOZf5VH38allLZ/MOsC3RLR8ovhoEh4AwQ7V5HRe+K7JiJnJ865+qL6RcUoF0dONdLB/gpR6UeZ3JEYsAiMO4mFByf4oIrCeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755132851; c=relaxed/simple;
	bh=sZQG8CV23WGMxYRoy4JJcYYgb/gOd8EblA9LS7jPfKw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=kcOWQ/rKy+DSDkoPFnB6kTfzRsbP8FMqpMeJeHd8H9yyPa/9NQKXt95wdheiKzduQcNdVU284mk6mApK3mIIR7bByGSql+8hEwRSkqO1dK2Hrdf64dFuX1qB7fo8BnKsboD2CuDkdqRdoNJXOw/BivAuvENFrbiBdhCnIZCYawk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c2RZl4Bw5zKHMYg
	for <linux-raid@vger.kernel.org>; Thu, 14 Aug 2025 08:54:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id D6C541A018D
	for <linux-raid@vger.kernel.org>; Thu, 14 Aug 2025 08:54:06 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHjxCsM51okX1qDg--.31120S3;
	Thu, 14 Aug 2025 08:54:04 +0800 (CST)
Subject: Re: [PATCH v4 1/1] md: add legacy_async_del_gendisk mode
To: Xiao Ni <xni@redhat.com>, yukuai1@huaweicloud.com
Cc: linux-raid@vger.kernel.org, mpatocka@redhat.com, luca.boccassi@gmail.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250813032929.54978-1-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e193fc4b-994f-8261-a7de-8fd8008a9bae@huaweicloud.com>
Date: Thu, 14 Aug 2025 08:54:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250813032929.54978-1-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHjxCsM51okX1qDg--.31120S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JF4UGFWfZFW5Ar4kWr45ZFb_yoW7AF1Up3
	y8JFn0krWUJFZIqrZrtw1DZF1rWwn7JrZ7KFy3C3yIk3WYqw15ur1fW390gryqqFZ5Zr4Y
	va1YvFWfWr1xKrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUG0PhUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/


ÔÚ 2025/08/13 11:29, Xiao Ni Ð´µÀ:
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
> is async way. In future, we plan to change default to sync way in kernel
> 7.0. Then users need to upgrade to mdadm 4.5+ which removes step 2.
> 
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Closes: https://lore.kernel.org/linux-raid/CAMw=ZnQ=ET2St-+hnhsuq34rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com/T/#t
> Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
> v2: minor changes on format and log content
> v3: changes in commit message and log content
> v4: choose to change to sync way as default first in commit message
>   drivers/md/md.c | 56 ++++++++++++++++++++++++++++++++++++-------------
>   1 file changed, 42 insertions(+), 14 deletions(-)
> 

Aplied to md-6.17
Thanks

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac85ec73a409..772cffe02ff5 100644
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
> +		pr_warn("md: async del_gendisk mode will be removed in future, please upgrade to mdadm-4.5+\n");
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
> 


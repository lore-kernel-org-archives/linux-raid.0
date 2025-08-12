Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67731A9F99
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 07:40:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754984420; cv=none; b=Exl62CY5etp++n+2rD/9hCRiVQK5XLs7n1s5MJhGhOhAteD7zvt6FCuWIaBlYC6xa8bZvTDCPREOyf2SSCj4UZ3feQG2n+7ID1nwbRQxkyVup+0K7/cjybyrt6SkcuynP8bR79kB3JaqKF+xferaP6a6MYfl92Iu6Zs1ms1oYfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754984420; c=relaxed/simple;
	bh=RAAM/fX/GuRetT1sM3WurTuwOUPNVYmyIgGzmwWjz7E=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=uDYsMPIK3oUE79oOOAiPojlcIfVaFSEdtzMEioJSH5LwC7IYcTXzA3L2YdI1AWlcZEmy8/ts0VKE1zFPepi2Se9mT/Pwei/1WDxmoGKlcvmknoEs8YaabXEGcBflQ8RMd3lsBobtQIlPWY7pFDZolIFHpGPqCHKpaGobnW6yfcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c1NhG3tQwzKHMqL
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 15:40:14 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BFD461A0A89
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 15:40:13 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgCnIxTZ75poSjSnDQ--.48034S3;
	Tue, 12 Aug 2025 15:40:11 +0800 (CST)
Subject: Re: [PATCH 1/1] md: add legacy_async_del_gendisk mode
To: Xiao Ni <xni@redhat.com>, yukuai@kernel.org
Cc: linux-raid@vger.kernel.org, mpatocka@redhat.com, luca.boccassi@gmail.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250812072709.61059-1-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <608bc5b7-f9f3-af6d-e7ac-d4a27cb0f132@huaweicloud.com>
Date: Tue, 12 Aug 2025 15:40:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250812072709.61059-1-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnIxTZ75poSjSnDQ--.48034S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JF4UGFWfZFW5ArWxtF4UXFb_yoW7AFWDp3
	y8JFn0krWUJFW2vrZrtw1DZF1rXwn7XrZ7KF9xC34Ika4aqw15ur1fWrZ0gryqqFZ5Zr4Y
	va1UZFWfWr1xKrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwx
	hLUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/12 15:27, Xiao Ni Ð´µÀ:
> commit 9e59d609763f ("md: call del_gendisk in control path") changes the
> async way to sync way of calling del_gendisk. But it breaks mdadm
> --assemble command. The assemble command runs like this:
> 1. create the array
> 2. stop the array
> 3. access the sysfs files after stopping
> 
> The sync way calls del_gendisk in step2, so all sysfs files are removed.
> Now to avoid breaking mdadm assemble command, this patch adds a parameter
> that can be used to choose which way. The default is async way. In future,
> we can remove this parameter when users upgrade to mdadm 4.5 which removes
> step2.
> 
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Closes: https://lore.kernel.org/linux-raid/CAMw=ZnQ=ET2St-+hnhsuq34rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com/T/#t
> Suggested-by: Yu Kuai <yukuai@kernel.org>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 57 +++++++++++++++++++++++++++++++++++++------------
>   1 file changed, 43 insertions(+), 14 deletions(-)
> 

Other than some nits below, this patch LGTM

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac85ec73a409..e48ee59082a5 100644
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
> @@ -6021,6 +6032,10 @@ static int md_alloc_and_put(dev_t dev, char *name)
>   {
>   	struct mddev *mddev = md_alloc(dev, name);
>   
> +	if (legacy_async_del_gendisk) {
> +		pr_warn("md: async del_gendisk mode will be removed.");
> +		pr_warn("md: please upgrade to mdadm-4.5\n");
Perhaps mdadm-4.5+

And please use one line pr_warn, user may grep the whole line when they
notice such warning.
> +	}
>   	if (IS_ERR(mddev))
>   		return PTR_ERR(mddev);
>   	mddev_put(mddev);
> @@ -6431,10 +6446,22 @@ static void md_clean(struct mddev *mddev)
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
> +	if (legacy_async_del_gendisk && mddev->hold_active)
> +		clear_bit(MD_CLOSING, &mddev->flags);
> +	else {
> +		/* if UNTIL_STOP is set, it's cleared here */
> +		mddev->hold_active = 0;
> +		/* Don't clear MD_CLOSING, or mddev can be opened again. */
> +		mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
> +	}

It's prefered to use braces for above if as well.

Otherwise feel free to add:
Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
>   	mddev->sb_flags = 0;
>   	mddev->ro = MD_RDWR;
>   	mddev->metadata_type[0] = 0;
> @@ -6658,7 +6685,8 @@ static int do_md_stop(struct mddev *mddev, int mode)
>   
>   		export_array(mddev);
>   		md_clean(mddev);
> -		set_bit(MD_DELETED, &mddev->flags);
> +		if (!legacy_async_del_gendisk)
> +			set_bit(MD_DELETED, &mddev->flags);
>   	}
>   	md_new_event();
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
> @@ -10392,6 +10420,7 @@ module_param_call(start_ro, set_ro, get_ro, NULL, S_IRUSR|S_IWUSR);
>   module_param(start_dirty_degraded, int, S_IRUGO|S_IWUSR);
>   module_param_call(new_array, add_named_array, NULL, NULL, S_IWUSR);
>   module_param(create_on_open, bool, S_IRUSR|S_IWUSR);
> +module_param(legacy_async_del_gendisk, bool, 0600);
>   
>   MODULE_LICENSE("GPL");
>   MODULE_DESCRIPTION("MD RAID framework");
> 


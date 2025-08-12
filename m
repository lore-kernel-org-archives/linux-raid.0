Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC582EB5CE
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 09:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754992699; cv=none; b=XysaU4QYTEg0dI++kxFDDuYqg4B6PkUnsdvaIy0GjrXPg3qGDHsIoeG3wPWFV22cwWP2P1C1eB8nmkDIxREB8aTy2epROuCKt+796wRG0kjZfmXH1wIePzosjD7h8luriARMbonwkmEYqBybpLwXunMrn0JjsKtLRoE8br0TDuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754992699; c=relaxed/simple;
	bh=mjvES3UtPR/L9AYt+70fzuDBF6FCbXQ7jUxK1gMwluk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DDgWMULufpFSr9IeKO0GhXQpGYHNBbx+trHPVuLmLkHdHqz4aYqJDu4H0G7F3p9HhbVcT0fyOnIDkNUd6zAxAe0JbpYHwDqW0lhfDRyKI9SIeopSO0X7RJB4YST5b82v7GIl/d5xhoEVTkAKrGr1MOn9+SHOOvhR3zN5m1d8gTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [141.14.220.42] (g42.guest.molgen.mpg.de [141.14.220.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 17D4A61E647BB;
	Tue, 12 Aug 2025 11:57:49 +0200 (CEST)
Message-ID: <75175b99-57ce-4384-9b75-c91d4fe4ddad@molgen.mpg.de>
Date: Tue, 12 Aug 2025 11:57:48 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V2 1/1] md: add legacy_async_del_gendisk mode
To: Xiao Ni <xni@redhat.com>
Cc: yukuai1@huaweicloud.com, linux-raid@vger.kernel.org, yukuai3@huawei.com,
 mpatocka@redhat.com, luca.boccassi@gmail.com
References: <20250812074947.61740-1-xni@redhat.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250812074947.61740-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Xiao,


Thank you for your patch.

Am 12.08.25 um 09:49 schrieb Xiao Ni:
> commit 9e59d609763f ("md: call del_gendisk in control path") changes the
> async way to sync way of calling del_gendisk. But it breaks mdadm
> --assemble command. The assemble command runs like this:
> 1. create the array
> 2. stop the array
> 3. access the sysfs files after stopping
> 
> The sync way calls del_gendisk in step2, so all sysfs files are removed.
> Now to avoid breaking mdadm assemble command, this patch adds a parameter

… the parameter legacy_async_del_gendisk …

> that can be used to choose which way. The default is async way. In future,
> we can remove this parameter when users upgrade to mdadm 4.5 which removes
> step2.

step 2

Maybe say to first change the default, and then remove it.

> 
> Fixes: 9e59d609763f ("md: call del_gendisk in control path")
> Reported-by: Mikulas Patocka <mpatocka@redhat.com>
> Closes: https://lore.kernel.org/linux-raid/CAMw=ZnQ=ET2St-+hnhsuq34rRPnebqcXqP1QqaHW5Bh4aaaZ4g@mail.gmail.com/T/#t
> Suggested-and-reviewed-by: Yu Kuai <yukuai3@huawei.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
> v2: minor changes on format and log content
>   drivers/md/md.c | 56 ++++++++++++++++++++++++++++++++++++-------------
>   1 file changed, 42 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac85ec73a409..44827f841927 100644
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
> +		pr_warn("md: async del_gendisk mode will be removed please upgrade to mdadm-4.5+\n");

Maybe add a timeframe?

md: async del_gendisk mode will be removed in Linux 6.18. Please upgrade 
to mdadm 4.5+

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


Kind regards,

Paul

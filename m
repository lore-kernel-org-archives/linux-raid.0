Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0D81E7C1C
	for <linux-raid@vger.kernel.org>; Wed, 13 Aug 2025 05:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755062807; cv=none; b=RjaYJnOcW2KoF1S/NpQgL/ra3Rb8gofij2+8uQfxOAdEfdalJL8woZawGrnyE9LWiACq9GmyhAHuS24RKY9VVdWk2ywfZeklWolc7JESK/8J7RTKXkALawVjTHv4EK9GFUtRHh/jkHKCzNi6yFwctbosxFduvhir8RizPfKLY5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755062807; c=relaxed/simple;
	bh=CKbpkigJXLYsshb4SU+Hk340qP4l78j6EwxMUyqnNRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V8svFbzja0X9qEpsZVnFI7D39w4kE2UEskvgHF/3T4Qi3pCMSZEpTvaryjY6fRvoNdCV7ka44WMIeg3b1GnjE0zK1B84hnU7DLzhrO84x29tgXmX3pz/8nnqGeiC9IWW9pL437TApZcy3Xcm57W5JWC+ciq06RYieKclBGV/l5U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af7c8.dynamic.kabel-deutschland.de [95.90.247.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 57B5161E647BA;
	Wed, 13 Aug 2025 07:26:15 +0200 (CEST)
Message-ID: <d571e27d-d363-48e0-b642-a51f2405cabc@molgen.mpg.de>
Date: Wed, 13 Aug 2025 07:26:14 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/1] md: add legacy_async_del_gendisk mode
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, yukuai1@huaweicloud.com, yukuai3@huawei.com,
 mpatocka@redhat.com, luca.boccassi@gmail.com
References: <20250813032929.54978-1-xni@redhat.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250813032929.54978-1-xni@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Xiao,


Thank you for sending the new version of the patch.

Am 13.08.25 um 05:29 schrieb Xiao Ni:
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

Should this log message also be updated?

Problematic async del_gendisk mode will default to disable in Linux 7.0. 
Please upgrade to mdadm 4.5+.

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

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul

Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3A1B285C88;
	Mon, 15 Sep 2025 07:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757920833; cv=none; b=TSeZehquiqlzF72pUoq/4IWy5EM1hC5AWUPX48qHj6bx1VgEKZAmGpAzdbFkfFSx2ufA2krBJT/X1N+zgSW9jcSZa3t2bydYI32ivNGVXvjXOd6MjYGT1MFweiK2al2OHClkz5xY5gRY6ui/HOcSRQEO2OlS18xT8O2V+fCURuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757920833; c=relaxed/simple;
	bh=I7xDKviED18tRAwRWdO7pefy9g69KzrkDP4FAVDHnRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ByTxDn6LaZlhvjEgBFuGiU3hOh1mlg/yqto8DNaCTsvghFVU0W28VxCPxdl9rUP8tqFZ6up1ZH4DTm9vMBVKBWxvKa6JGLhD5zCCnl0VVSdhPbdHFxBWpgtPizOhn69NhvxyqrqGxkccPBf3tgxJ5a7F+9tIBKKLJWMnactQpnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.192] (ip5f5af7be.dynamic.kabel-deutschland.de [95.90.247.190])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 39B436028F362;
	Mon, 15 Sep 2025 09:19:40 +0200 (CEST)
Message-ID: <b1487963-a07e-4850-98f7-0eda07c31214@molgen.mpg.de>
Date: Mon, 15 Sep 2025 09:19:39 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] md/raid1,raid10: Fix: Operation continuing on 0
 devices.
To: Kenta Akagi <k@mgml.me>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
 Guoqing Jiang <jgq516@gmail.com>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250915034210.8533-1-k@mgml.me>
 <20250915034210.8533-10-k@mgml.me>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250915034210.8533-10-k@mgml.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Kenta,


Thank you for your patch, and well-written commit message and test. 
Reading just the summary, I didn’t know what it’s about. Should you 
resend, maybe:

 > md/raid1,raid10: Fix logging `Operation continuing on 0 devices.`

Am 15.09.25 um 05:42 schrieb Kenta Akagi:
> Since commit 9a567843f7ce ("md: allow last device to be forcibly
> removed from RAID1/RAID10."), RAID1/10 arrays can now lose all rdevs.
> 
> Before that commit, losing the array last rdev or reaching the end of
> the function without early return in raid{1,10}_error never occurred.
> However, both situations can occur in the current implementation.
> 
> As a result, when mddev->fail_last_dev is set, a spurious pr_crit
> message can be printed.
> 
> This patch prevents "Operation continuing" printed if the array
> is not operational.
> 
> root@fedora:~# mdadm --create --verbose /dev/md0 --level=1 \
> --raid-devices=2  /dev/loop0 /dev/loop1
> mdadm: Note: this array has metadata at the start and
>      may not be suitable as a boot device.  If you plan to
>      store '/boot' on this device please ensure that
>      your boot-loader understands md/v1.x metadata, or use
>      --metadata=0.90
> mdadm: size set to 1046528K
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: array /dev/md0 started.
> root@fedora:~# echo 1 > /sys/block/md0/md/fail_last_dev
> root@fedora:~# mdadm --fail /dev/md0 loop0
> mdadm: set loop0 faulty in /dev/md0
> root@fedora:~# mdadm --fail /dev/md0 loop1
> mdadm: set device faulty failed for loop1:  Device or resource busy
> root@fedora:~# dmesg | tail -n 4
> [ 1314.359674] md/raid1:md0: Disk failure on loop0, disabling device.
>                 md/raid1:md0: Operation continuing on 1 devices.
> [ 1315.506633] md/raid1:md0: Disk failure on loop1, disabling device.
>                 md/raid1:md0: Operation continuing on 0 devices.

Shouldn’t the first line of the critical log still be printed, but your 
patch would remove it?

> root@fedora:~#
> 
> Fixes: 9a567843f7ce ("md: allow last device to be forcibly removed from RAID1/RAID10.")
> Signed-off-by: Kenta Akagi <k@mgml.me>
> ---
>   drivers/md/raid1.c  | 9 +++++----
>   drivers/md/raid10.c | 9 +++++----
>   2 files changed, 10 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index febe2849a71a..b3c845855841 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1803,6 +1803,11 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   		update_lastdev(conf);
>   	}
>   	set_bit(Faulty, &rdev->flags);
> +	if ((conf->raid_disks - mddev->degraded) > 0)
> +		pr_crit("md/raid1:%s: Disk failure on %pg, disabling device.\n"
> +			"md/raid1:%s: Operation continuing on %d devices.\n",
> +			mdname(mddev), rdev->bdev,
> +			mdname(mddev), conf->raid_disks - mddev->degraded);
>   	spin_unlock_irqrestore(&conf->device_lock, flags);
>   	/*
>   	 * if recovery is running, make sure it aborts.
> @@ -1810,10 +1815,6 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>   	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>   	set_mask_bits(&mddev->sb_flags, 0,
>   		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
> -	pr_crit("md/raid1:%s: Disk failure on %pg, disabling device.\n"
> -		"md/raid1:%s: Operation continuing on %d devices.\n",
> -		mdname(mddev), rdev->bdev,
> -		mdname(mddev), conf->raid_disks - mddev->degraded);
>   }
>   
>   static void print_conf(struct r1conf *conf)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index be5fd77da3e1..4f3ef43ebd2a 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -2059,11 +2059,12 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>   	set_bit(Faulty, &rdev->flags);
>   	set_mask_bits(&mddev->sb_flags, 0,
>   		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
> +	if (enough(conf, -1))
> +		pr_crit("md/raid10:%s: Disk failure on %pg, disabling device.\n"
> +			"md/raid10:%s: Operation continuing on %d devices.\n",
> +			mdname(mddev), rdev->bdev,
> +			mdname(mddev), conf->geo.raid_disks - mddev->degraded);
>   	spin_unlock_irqrestore(&conf->device_lock, flags);
> -	pr_crit("md/raid10:%s: Disk failure on %pg, disabling device.\n"
> -		"md/raid10:%s: Operation continuing on %d devices.\n",
> -		mdname(mddev), rdev->bdev,
> -		mdname(mddev), conf->geo.raid_disks - mddev->degraded);
>   }
>   
>   static void print_conf(struct r10conf *conf)


Kind regards,

Paul

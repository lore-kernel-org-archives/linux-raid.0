Received: from mail-dy2-f43.google.com (mail-dy2-f43.google.com [74.125.229.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2993139FCB1
	for <linux-raid@vger.kernel.org>; Wed, 30 Sep 2026 22:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790805971; cv=none; b=Jv0gCZ1U5fLEkISSlTW6enQ1YhYTO7TRRJ8hPbBx1fQam9/DHNU3OqWrOzfi0kwSWe01Bf6vrutIktqAJe4RMavrqN9oVKTCFTjZcNFqtO9WZOab2O7U5AaCkrnSgpSyKrGPBnTrXuzGRVoeZ09t7we+y6fMwpNcjPP36uN6I/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790805971; c=relaxed/simple;
	bh=O9pgF5SXHBYX8VMisQz6nDuXGUM1T1Vc3DnQCSt8Swc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QkARL1NyhZ8Lgf4ObWhqE3tEa94OjcGzzokvtq/sO+nBCl87dW4Jui+9EUIIX4cKRChLYmVrlErl590OyHKsdSLEjxBSSO+oPPegJ4cWunDwJL+V8h+gE0P02PDiS4GxHfl1UaKC+rBl/9pX7ZUtAUnpTjummAoBpZEmheIKaAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B2vyFGVi; arc=none smtp.client-ip=74.125.229.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B2vyFGVi"
Received: by mail-dy2-f43.google.com with SMTP id 5a478bee46e88-34ad8819612so239672eec.1
        for <linux-raid@vger.kernel.org>; Wed, 30 Sep 2026 15:06:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790805969; x=1791410769; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HIc9txZykojEApq5zTCuA+rtntqKcyUhqeyri//1nbI=;
        b=B2vyFGViDUmq0jhg4r7sGfuNn/JY9Sb5ADvo2UuZMTWm2luLWhqVgFRfFgbaSQwUm1
         B3l7dpWswThXqD7R0WK3lIO0DAIEtmhNjc+OpEul1qjGl9w78iEWqY/pOxCVAouH8Vh6
         b1Iz6LmR/fXianAZdowO06RmVscojZQoe9h34/DbKV5tMnTdE3umjUX6MmroiE2qEuiY
         NXc9gm2OV4Wzunc0FWtp2G7+Bf31EagyCeXhjyarmHig2o5En2/syXMKdvh7bE+DS3tX
         qWVtFEPff+xdgNh4UzYasWfDrlEk04yk48QXtlXSzzNEskR3ROd2o/KRYL/HvkkfnZST
         fcSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790805969; x=1791410769;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HIc9txZykojEApq5zTCuA+rtntqKcyUhqeyri//1nbI=;
        b=uNmPYz6p3te8SyjouxH+vCAKJ2yZATOsy9rJKs4FNx4dfuh4+eg2HKQ1lnGqrBlxH7
         A88UrxZK3cueQzV2qLR4W8jB6qpdYTxgkvyWfz8kh+hAcoo8dPqbhpFnn/g+V6ISZurL
         kyxkLjEZ4V1IOz9VdqvxYsATNKwmfi8KepTCagUBL57EEWXNOCYLBtCCJ+bw8q/Rj599
         JtvQ+RjVr+vIHqU1EqUjyoAlUhjcDdnuguPh/pIEPhIJcGl26bAmCsP42ETCXaziDRb7
         5CsI/fyYkLhU35jwyKzc4Fvsbd+4Tfk5m3tLJ04BeT1L80JMmAidKufcKPRyYkhzP77Q
         EiFw==
X-Forwarded-Encrypted: i=1; AKwUvByg1nNDkcqrAz9MQUZNH80snVTvay0PMeALkdYcZcDIyWItPvp3TKt5pmU03HMdgZGn39V82Ggx1Jy+@vger.kernel.org
X-Gm-Message-State: AFuF++mkPXDVcIitF9d8COr2VsCuCw5MQBwfcC4L9y9/n/RRkuWUC2Lz
	L60wGL6DXCTE+j5ihUjwPiP48XOrKs/BYTUYeM1GCjdbjshl+wwcQXQ9
X-Gm-Gg: AYBFou3Q/zD3vjId4PgZrmDReOIXd93gcpz0XkN2lketLB2cYpbtDmp/miSAZXvcThV
	xmBdED3WxM/ohhNlDglmm8Dy6/96wf6VqGj8MXr7PVtLTuElA2I1W1GHBokVmulZ+zUPfYyXu4A
	11TpwDIq6L4iyg06youubKI3xu3M7Lx/XT2wQiOQBjK3TChF9pw6pkuxtULgu+UZlCXdMnOSuw6
	0CFxiUd5AKWPUe9BkH8XMraS8qMMClB/3V7lKv+6Gv7S297IyUwuYf+HWJLoIAoSOpVcKk8t87l
	glCraUlQqKog90lNDECG/HoTnfdF9urAgbHEGYpMBX5dzPdMFTj6HtQFeluaLhMJqJ7tHr1RuCH
	PxtGSQkrYyYt9mAXJM7+0IRmj7qUPOPt4y0SXWa8yjZIP9dJmsI4Ij+pWo0nfPX7wMbXmxZG/x2
	Ss+GhCySbgTKKszliffEAasj7eEeL+SVWii8o4pkYQVgA2dHqfeQHADw6uNmtZ3AocinZpXjeSY
	4EJnn5TdMyLgWIhm7ioe660Jj6VE0GdXJGtr2PC
X-Received: by 2002:a05:7300:fe46:b0:34b:dc68:c587 with SMTP id 5a478bee46e88-34cd9d59b2bmr4258579eec.0.1790805968817;
        Wed, 30 Sep 2026 15:06:08 -0700 (PDT)
Received: from [10.7.19.162] ([49.36.137.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-34db4926277sm1668597eec.25.2026.09.30.15.06.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 15:06:08 -0700 (PDT)
Message-ID: <d26b5aa7-0d8e-4d9e-a6a0-a4edb618259c@gmail.com>
Date: Thu, 1 Oct 2026 03:36:04 +0530
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] md: fix out-of-bound by adding checks at store
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 linux-raid@vger.kernel.org,
 syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
References: <20260923124634.5497-1-aadityakansal390@gmail.com>
Content-Language: en-US
From: Aaditya Kansal <aadityakansal390@gmail.com>
In-Reply-To: <20260923124634.5497-1-aadityakansal390@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/23/26 6:16 PM, Aaditya Kansal wrote:
> syzbot reported array-index-out-of-bounds in super_90_sync()
>      UBSAN: array-index-out-of-bounds in drivers/md/md.c:1697:17
>      index 124 is out of range for type 'mdp_disk_t [27]'
>      CPU: 1 UID: 0 PID: 10197 Comm: syz.3.1362 Tainted: G    L
>      syzkaller #0 PREEMPT(full)
>      Tainted: [L]=SOFTLOCKUP
>      Hardware name: Google Google Compute Engine/Google Compute Engine,
>      BIOS Google 08/05/2026
>      Call Trace:
>       <TASK>
>       __dump_stack lib/dump_stack.c:94 [inline]
>       dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>       ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>       __ubsan_handle_out_of_bounds+0xcc/0xf0 lib/ubsan.c:455
>       super_90_sync+0x1eed/0x1ff0 drivers/md/md.c:1697
>   ...
>
> super_90_sync() exists for older version 0.90, which supports up to 27
> maximum disks (MD_SB_DISKS). This function doesn't contain any bound checks
> for raid disks. The repro wrote higher value (124) in raid_disks sysfs
> attribute to trigger this bug.
>
> The repro is one configuration that triggers this bug, which is caused by
> the lack of proper checks at sysfs stores. Store is one path to reach
> OOB.
>
> Add helper function md_check_disks_fit_metadata() and call it at
> raid_disks_store() and metadata_store() to reject the write for
> mismatched configuration (raid_disks > MD_SB_DISKS for major == 0). This
> prevents invalid configuration via stores from reaching the super_90_sync
> function.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9e3014263a35700ab49b
> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
> ---
> v2:
> - moved the fix from super_90_sync() to a level above at store functions
> - add checks at stores themselves to prevent wrong configuration from
>    reaching the target function
> - add helper function to be called at all the sites where check is
>    required
>
>   drivers/md/md.c | 23 ++++++++++++++++++++++-
>   1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..f0f693f6bf7c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1354,6 +1354,13 @@ int md_check_no_bitmap(struct mddev *mddev)
>   }
>   EXPORT_SYMBOL(md_check_no_bitmap);
>
> +static int md_check_disks_fit_metadata(int major, int raid_disks)
> +{
> +	if (major == 0 && raid_disks > MD_SB_DISKS)
> +		return -EINVAL;
> +	return 0;
> +}
> +
>   /*
>    * load_super for 0.90.0
>    */
> @@ -4448,8 +4455,15 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
>   		mddev->delta_disks = n - olddisks;
>   		mddev->raid_disks = n;
>   		mddev->reshape_backwards = (mddev->delta_disks < 0);
> -	} else
> +	} else {
> +		err = md_check_disks_fit_metadata(mddev->major_version, n);
> +		if (err) {
> +			pr_warn("md: raid disks (%d) exceeds max disks (%d) for metadata version 0.90",
> +					n, MD_SB_DISKS);
> +			goto out_unlock;
> +		}
>   		mddev->raid_disks = n;
> +	}
>   out_unlock:
>   	memalloc_noio_restore(noio_flags);
>   	mddev_unlock_and_resume(mddev);
> @@ -5041,6 +5055,13 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
>   	err = -ENOENT;
>   	if (major >= ARRAY_SIZE(super_types) || super_types[major].name == NULL)
>   		goto out_unlock;
> +
> +	err = md_check_disks_fit_metadata(major, mddev->raid_disks);
> +	if (err) {
> +		pr_warn("md: metadata version 0.90 doesn't support raid disks count higher than %d",
> +				MD_SB_DISKS);
> +		goto out_unlock;
> +	}
>   	mddev->major_version = major;
>   	mddev->minor_version = minor;
>   	mddev->persistent = 1;
> --
> 2.55.0

Hi, ping for the patch.

-AK


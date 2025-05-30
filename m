Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF6110F1
	for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 06:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748587709; cv=none; b=XaTZjfKeFbYtT0lXYXBcgR8kpRvmNe3MW45SvK8i+SGiwWHs/9K0JQzheu+0BHxCq534hpWsnr4KqlxJyZ/XAqldq5MueGF25nZDbeos/Vj7g/oAnLgwyzmGovPS+IxY85Jn6+RYrW2kEnClOmMpVNDofPYm8YUfJBATiP8hv/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748587709; c=relaxed/simple;
	bh=WE0SNWO7piJoQq9jQYvRRhBUPlFwXjpjK6xk8RBwNyQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=aJqfomBduzwzt5nsEyemOHo0o3zApsnZaciVNCY0c2EGriH0xYQ9bjLXzqMJwoQfNlMXOqptBVa2Jm0JSmMBEgspUT7VKt7tFKrc90eLhkX32LdbuItrCt9yimuUkb/gP22+05jQKDaJ4iBsqU8ySBxqIOsEPsIyBtQql1g8YFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4b7v2f5f0fzKHMTn
	for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 14:48:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 316C51A01A3
	for <linux-raid@vger.kernel.org>; Fri, 30 May 2025 14:48:25 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAni1+4VDlo+IzRNw--.34742S3;
	Fri, 30 May 2025 14:48:25 +0800 (CST)
Subject: Re: [PATCH 1/2] md: Don't clear MD_CLOSING until mddev is freed
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: yukuai1@huaweicloud.com, ncroxon@redhat.com, song@kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250515090847.2356-1-xni@redhat.com>
 <20250515090847.2356-2-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <fed9d361-7005-d82c-d03b-6b6e5f12d4d5@huaweicloud.com>
Date: Fri, 30 May 2025 14:48:24 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250515090847.2356-2-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAni1+4VDlo+IzRNw--.34742S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZF13Jry7WF4UWF45Xr4fZrb_yoW8AFy8p3
	yxJF90yw4DJ345W3yjqF1DuFyFvas3trWvyry7A348J3WUCw1DKr4S9rZ8Gr1DWayrur4Y
	va1aqF4DZ3WxuF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUQo7NUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2025/05/15 17:08, Xiao Ni Ð´µÀ:
> UNTIL_STOP is used to avoid mddev is freed on the last close before adding
> disks to mddev. And it should be cleared when stopping an array which is
> mentioned in commit efeb53c0e572 ("md: Allow md devices to be created by
> name."). So reset ->hold_active to 0 in md_clean.
> 
> And MD_CLOSING should be kept until mddev is freed to avoid reopen.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/md.c | 15 ++++-----------
>   1 file changed, 4 insertions(+), 11 deletions(-)
> 

Patch 1 applied to md-6.16

BTW, please send a new version for patch 2, we might consider it for
the next merge window.

Thanks,
Kuai

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9daa78c5fe33..9b9950ed6ee9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6360,15 +6360,10 @@ static void md_clean(struct mddev *mddev)
>   	mddev->persistent = 0;
>   	mddev->level = LEVEL_NONE;
>   	mddev->clevel[0] = 0;
> -	/*
> -	 * Don't clear MD_CLOSING, or mddev can be opened again.
> -	 * 'hold_active != 0' means mddev is still in the creation
> -	 * process and will be used later.
> -	 */
> -	if (mddev->hold_active)
> -		mddev->flags = 0;
> -	else
> -		mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
> +	/* if UNTIL_STOP is set, it's cleared here */
> +	mddev->hold_active = 0;
> +	/* Don't clear MD_CLOSING, or mddev can be opened again. */
> +	mddev->flags &= BIT_ULL_MASK(MD_CLOSING);
>   	mddev->sb_flags = 0;
>   	mddev->ro = MD_RDWR;
>   	mddev->metadata_type[0] = 0;
> @@ -6595,8 +6590,6 @@ static int do_md_stop(struct mddev *mddev, int mode)
>   		export_array(mddev);
>   
>   		md_clean(mddev);
> -		if (mddev->hold_active == UNTIL_STOP)
> -			mddev->hold_active = 0;
>   	}
>   	md_new_event();
>   	sysfs_notify_dirent_safe(mddev->sysfs_state);
> 


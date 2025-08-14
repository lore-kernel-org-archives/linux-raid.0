Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE67C2628C;
	Thu, 14 Aug 2025 00:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755132785; cv=none; b=jtv+P5B7I//RE7FsdgL97+c9oMb3m70SanPOsCKsfFtHc+SV71QK9c4RyMepzK9mdIhMxqR4xKClodfV0yN0k7yaskSdAR73UTSle95TBf9fp3y1YZbErp9P7GNR8D4yGlHBWsn69BE/bT25zTuUAw5Xw7TlfbIBeWjmxd7Nu/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755132785; c=relaxed/simple;
	bh=5ZP0alk21AfgU/VuRCsoj7cUoXmeKRTbAj42s9Hxgy8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=ByJ7nE13y9ZwV2O8dA1VqRhv+Zwl3tnmK9T729iLRLKCIPUaGdaJAeIsENeVr9xLZaomNOjRfo/uHUdg4KsKtPHwrAPscKS8FmsQoZZrshxQoVFTyc6kij/3lCoJNQk1uHQUJyHvB8seO2syJyZMmIz3y7gGDQzVyfJmjHjU3qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c2RYS4gD0zYQv9d;
	Thu, 14 Aug 2025 08:53:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 41EF01A018D;
	Thu, 14 Aug 2025 08:52:59 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDnYhNpM51o7GZqDg--.8955S3;
	Thu, 14 Aug 2025 08:52:59 +0800 (CST)
Subject: Re: [PATCH v2 1/2] md: add helper rdev_needs_recovery()
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 linan122@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250812021738.3722569-1-zhengqixing@huaweicloud.com>
 <20250812021738.3722569-2-zhengqixing@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <258db10c-f80f-5975-d879-ec0d16f1db6e@huaweicloud.com>
Date: Thu, 14 Aug 2025 08:52:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250812021738.3722569-2-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnYhNpM51o7GZqDg--.8955S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZrW3XrWxZr1fXw4ftw1kXwb_yoW8Kr1rpa
	ySqFy3GryUZr17W3WDWr15GFyFgF4UKr4xCry7Ga4xJa98Kr15KaykCa45X34DAFZYvw4Y
	v3y5Xw4fCF12gw7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/08/12 10:17, Zheng Qixing Ð´µÀ:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> Add a helper for checking if an rdev needs recovery.
> 
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/md.c | 20 ++++++++++++--------
>   1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ac85ec73a409..4ea956a80343 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4835,6 +4835,16 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
>   static struct md_sysfs_entry md_metadata =
>   __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
>   
> +static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t sectors)
> +{
> +	if (!test_bit(Journal, &rdev->flags) &&
> +	    !test_bit(Faulty, &rdev->flags) &&
> +	    !test_bit(In_sync, &rdev->flags) &&
> +	    rdev->recovery_offset < sectors)
> +		return true;
> +	return false;
return directly:

return !test_bit(Journal, &rdev->flags) &&
	!test_bit(Faulty, &rdev->flags) &&
	!test_bit(In_sync, &rdev->flags) &&
	rdev->recovery_offset < sectors);

Otherwise, feel free to add
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

Kuai

> +}
> +
>   enum sync_action md_sync_action(struct mddev *mddev)
>   {
>   	unsigned long recovery = mddev->recovery;
> @@ -8969,10 +8979,7 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
>   		rcu_read_lock();
>   		rdev_for_each_rcu(rdev, mddev)
>   			if (rdev->raid_disk >= 0 &&
> -			    !test_bit(Journal, &rdev->flags) &&
> -			    !test_bit(Faulty, &rdev->flags) &&
> -			    !test_bit(In_sync, &rdev->flags) &&
> -			    rdev->recovery_offset < start)
> +			    rdev_needs_recovery(rdev, start))
>   				start = rdev->recovery_offset;
>   		rcu_read_unlock();
>   
> @@ -9333,10 +9340,7 @@ void md_do_sync(struct md_thread *thread)
>   				rdev_for_each_rcu(rdev, mddev)
>   					if (rdev->raid_disk >= 0 &&
>   					    mddev->delta_disks >= 0 &&
> -					    !test_bit(Journal, &rdev->flags) &&
> -					    !test_bit(Faulty, &rdev->flags) &&
> -					    !test_bit(In_sync, &rdev->flags) &&
> -					    rdev->recovery_offset < mddev->curr_resync)
> +					    rdev_needs_recovery(rdev, mddev->curr_resync))
>   						rdev->recovery_offset = mddev->curr_resync;
>   				rcu_read_unlock();
>   			}
> 


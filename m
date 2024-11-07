Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B390E1E1048
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 13:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730985603; cv=none; b=WjXD2xTNeN/bAGAeC2BWJnq5O/JdhdhUd7Oktdf2oUX+i8XU61AzqCiqzd+rNWW3LnbQfV2C07tRUaoBn4fVoCnBfBl7H+kfCWvp3hrMgocRBRwi9Vk5PoDbLcygwp1/OOvnJxw/kQcwJF4IV5GTz+Mcxks1xQOuDArgDAM3xIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730985603; c=relaxed/simple;
	bh=47ANHkvgmwlvYqgITlZEA7Lt2D7rRrThXFSmc7ojO00=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=RieTZ9aZF+5ehFVORf9NJuurpFm5JAoPWEwR3Y3chxBlrTCHBPe8lwYuSo5so98ZRLK40x/w9JxCH7EFXc0KILZeMNhpc3KLQ4CMYe1JDWLBATx6nrgX85YE/fBxafJjmxsen9LowVOnmbzrf1u58R9P1eTYz3pWTzWP4dqX39w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XkjNH1Lt5z4f3kq7
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 21:19:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1D70C1A06DA
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 21:19:56 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBHIoZ6vixnsA90BA--.9073S3;
	Thu, 07 Nov 2024 21:19:55 +0800 (CST)
Subject: Re: [PATCH 1/1] md/raid5: Wait sync io to finish before changing
 group cnt
To: Xiao Ni <xni@redhat.com>, song@kernel.org
Cc: yukuai1@huaweicloud.com, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241106095124.74577-1-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <888e7aeb-ca42-792c-5616-5cbaf0f0a952@huaweicloud.com>
Date: Thu, 7 Nov 2024 21:19:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241106095124.74577-1-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHIoZ6vixnsA90BA--.9073S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw1UWry7uryxuw43Gr1Dtrb_yoW8XF47pw
	4qkF45Zr4UXFWYkFyDZ34q9Fy8A3WUKrZIkryaqwn5Ka43Xw15Ww43Ga45Xr4jya4Syw4I
	yF15WF95Awn7KrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUehL0UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/11/06 17:51, Xiao Ni Ð´µÀ:
> One customer reports a bug: raid5 is hung when changing thread cnt
> while resync is running. The stripes are all in conf->handle_list
> and new threads can't handle them.
> 
> Commit b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removes
> pers->quiesce from mddev_suspend/resume. Before this patch, mddev_suspend
> needs to wait for all ios including sync io to finish. Now it's used
> to only wait normal io.
> 
> In this patch, it calls raid5_quiesce in raid5_store_group_thread_cnt
> directly to wait all sync requests to finish before changing the group
> cnt.
> 
> Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
>   drivers/md/raid5.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index dc2ea636d173..2fa1f270fb1d 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7177,6 +7177,8 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
>   	err = mddev_suspend_and_lock(mddev);
>   	if (err)
>   		return err;
> +	raid5_quiesce(mddev, true);
> +
>   	conf = mddev->private;
>   	if (!conf)
>   		err = -ENODEV;
> @@ -7198,6 +7200,8 @@ raid5_store_group_thread_cnt(struct mddev *mddev, const char *page, size_t len)
>   			kfree(old_groups);
>   		}
>   	}
> +
> +	raid5_quiesce(mddev, false);
>   	mddev_unlock_and_resume(mddev);
>   
>   	return err ?: len;
> 


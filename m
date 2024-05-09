Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2423CBA2B;
	Thu,  9 May 2024 01:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715218462; cv=none; b=J/thVAsqkAyLOWybFIj8vwIpCDea1H6Tf38OzQrm7xjVzIDN1eQKkxr3aErzj00IE2j7faT85KxzKa0t82pIYuOBgdVJROLWPnIjiLTaPpXqdWNMqZZpStOsTUWujj7GTlgy59xO2FgYsZm2JRlP8+KhntU1G6H7NQ8OskHL85A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715218462; c=relaxed/simple;
	bh=fqQkjF82diC2EzfU174t0iSDV9wYhGJFYbMGZP9Uw3s=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=rEMAqMkGDh//MadsF9omL9PNrmLSyptSOJebSH7IRe4EGCLwin1EDjZ2Hv/4rB+mcUhiXiHQfIRxLbaR5lHcKftAWFxm80PhMhzKvXAOWFxu6AdKft21GGJ3FgU0mMr0A30sTiaY0fs2QirqazI5S71butlrLU3QBJc5dlzPkE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VZZLC57Kkz4f3kkk;
	Thu,  9 May 2024 09:34:11 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 114101A016E;
	Thu,  9 May 2024 09:34:17 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAn+REXKDxmQR2YMA--.39420S3;
	Thu, 09 May 2024 09:34:16 +0800 (CST)
Subject: Re: [PATCH] md: do not delete safemode_timer in mddev_suspend
To: linan666@huaweicloud.com, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.co,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240508092053.1447930-1-linan666@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <33185f65-b657-b15b-ffa8-e35319fa0a5f@huaweicloud.com>
Date: Thu, 9 May 2024 09:34:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240508092053.1447930-1-linan666@huaweicloud.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAn+REXKDxmQR2YMA--.39420S3
X-Coremail-Antispam: 1UD129KBjvJXoW7KrWkGr1fur4kAry8Ar48tFb_yoW8CFWfp3
	ySqw4agw18Jr4Ika1DGa1kWFyrXwn5KrWUtFy3WrZxZa13Xr18WF4agws8XFyUur97J3Zx
	JF4F934rua48GFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_
	Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0J
	UdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/05/08 17:20, linan666@huaweicloud.com Ð´µÀ:
> From: Li Nan <linan122@huawei.com>
> 
> The deletion of safemode_timer in mddev_suspend() is redundant and
> potentially harmful now. If timer is about to be woken up but gets
> deleted, 'in_sync' will remain 0 until the next write, causing array
> to stay in the 'active' state instead of transitioning to 'clean'.
> 
> Commit 0d9f4f135eb6 ("MD: Add del_timer_sync to mddev_suspend (fix
> nasty panic))" introduced this deletion for dm, because if timer fired
> after dm is destroyed, the resource which the timer depends on might
> have been freed.
> 
> However, commit 0dd84b319352 ("md: call __md_stop_writes in md_stop")
> added __md_stop_writes() to md_stop(), which is called before freeing
> resource. Timer is deleted in __md_stop_writes(), and the origin issue
> is resolved. Therefore, delete safemode_timer can be removed safely now.
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index aff9118ff697..09c55d9a2c54 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -479,7 +479,6 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
>   	 */
>   	WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
>   
> -	del_timer_sync(&mddev->safemode_timer);

I don't understand why time is deleted here before, it's right based on
git log, commit 0d9f4f135eb6 add this to fix panic for dm-raid, and it's
not necessary now.

LGTM, feel free to add:

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

However, since this behaviour is introduced since 2012, does anybody
really care about array status is 'active' instead of 'clean' while
there is no IO after suspend?

Thanks,
Kuai

>   	/* restrict memory reclaim I/O during raid array is suspend */
>   	mddev->noio_flag = memalloc_noio_save();
>   
> 


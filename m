Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52AC032E13A;
	Tue,  6 Jan 2026 13:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767704871; cv=none; b=ucD9YSvnhLgmPcF8RGgOf9Rmf0zCctuzH51kSJ4q3DKA94xmGFJpRRyUAnN+0CtX7CJtrAyynpMzv5HfbOlNOMGoLGpR4hWN1x9QMgnx+8rs+6J6hBVURpBkjwYrDhahz/zeKfSscwCj1VUb91uZuVV/GJ9mvtWlt27oTvXptkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767704871; c=relaxed/simple;
	bh=r/Y5JBs5Nh/aoNjvsulX9TS0qnzR49t8wf9vENEXM2k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=am14QgSp5mvQNZ3SUrqreQuWc237J+aPvSkwqc7xxZwU4iRfSUaJIS9OuEuNSG1t8RcURgvLsurzgbb+9fNzIoHGSvtZLEa0J04bLZZanGOMWJVjx2CJ52fdIeeakaOqjeSuiAOvzJQyRAOGCpf4skcRHM3ajE3rKuZ8Nawpkmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dlrzZ0NfvzKHMvW;
	Tue,  6 Jan 2026 21:07:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CB39C40570;
	Tue,  6 Jan 2026 21:07:45 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPkgCV1phJhcCw--.12012S3;
	Tue, 06 Jan 2026 21:07:45 +0800 (CST)
Message-ID: <48421f04-6c37-8d76-2130-39ba38e6e437@huaweicloud.com>
Date: Tue, 6 Jan 2026 21:07:44 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC PATCH 2/5] md: clear stale sync flags when frozen before
 sync starts
To: Zheng Qixing <zhengqixing@huaweicloud.com>, song@kernel.org,
 yukuai@fnnas.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com, linan122@h-partners.com
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
 <20251231070952.1233903-3-zhengqixing@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20251231070952.1233903-3-zhengqixing@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPkgCV1phJhcCw--.12012S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw4Dur4kuFWfJr4xtryrWFg_yoWkZFXE9F
	4UA34xWrWUWF409F1qv3W3ZrWrJFs7Wr1fWFySqrWUZasrAr1xXr1Sy3WUWw1jvwsIyrn0
	k3ykJ3Wrtrs7KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbSAYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67
	AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2
	Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20x
	vY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I
	3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIx
	AIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAI
	cVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r4j6F4UMIIF0xvEx4A2js
	IEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UuBT5UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/12/31 15:09, Zheng Qixing 写道:
> From: Zheng Qixing <zhengqixing@huawei.com>
> 
> In md_check_recovery(), add clearing of all sync flags when sync is not
> running. This fixes the issue where a sync operation is requested, then
> 'frozen' is executed before MD_RECOVERY_RUNNING is set, leaving stale
> operation flags that cause subsequent operations to fail with EBUSY.
> 
> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>   drivers/md/md.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index ccaa2e6fe079..52e09a9a9288 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -10336,6 +10336,9 @@ void md_check_recovery(struct mddev *mddev)
>   			queue_work(md_misc_wq, &mddev->sync_work);
>   		} else {
>   			clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
> +			clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
> +			clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
> +			clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
>   			wake_up(&resync_wait);
>   		}
>   

Merge into one with the previous fix patch. Do not introduce an issue
and fix it later.

-- 
Thanks,
Nan


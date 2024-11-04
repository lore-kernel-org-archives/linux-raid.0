Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EE91C2301;
	Mon,  4 Nov 2024 11:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730718373; cv=none; b=oGs0vktp4PcvooaJs0yj+D6Bywc5IckaSwJPRV3ue5fLOL/HRQZajjLtu3C52uIn6LuXIZU9216A4JoVq8YyqJeFZ2/9jWIM00+BsWhIWQDnmVTbNooVxR1LcA3j6abrb/hJcLnNNwD5qRwKsRdMXpDJUaWjxOHLe5Rr5h7r0PU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730718373; c=relaxed/simple;
	bh=DQI9ribUuzYxsPXv9bLf/P2Hl2+pfQA1g2mUfCgOhL8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=JaVphZmJbGfEA9eZH3+2vtJYGIyA2zEA1RnSdWXvdrA8YoFoeVf2ynFsUcGx5xNRs3g4YByVmna3t6pE/euKpd0tvKdbdGsryIRVpQiqsxazFnmEFYs/1Js1ovspsEIL4k5S6JdkBCmFdwbxMUwCnPVsFZWQcO5x73ju8+SfLng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XhpY60JSJz4f3p10;
	Mon,  4 Nov 2024 19:05:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C2DC21A0196;
	Mon,  4 Nov 2024 19:06:04 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHYoaaqihnTOZLAw--.24045S3;
	Mon, 04 Nov 2024 19:06:04 +0800 (CST)
Subject: Re: [PATCH v3 3/5] md/raid0: Atomic write support
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241101144616.497602-1-john.g.garry@oracle.com>
 <20241101144616.497602-4-john.g.garry@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <77b69ea0-6a09-efdf-b251-cd4fa75d71c0@huaweicloud.com>
Date: Mon, 4 Nov 2024 19:06:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241101144616.497602-4-john.g.garry@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYoaaqihnTOZLAw--.24045S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtr1xJryfZryxurWxCF1kAFb_yoWkGwc_Ka
	1ru3ZIvrnF9F1Ivw10v3WxCrWY9w18Wan7ZFWfKrsxJF1rXFnY9Fyv93y5X3WjyrWYqryq
	yrs7W3WFyr1kXjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUb4AYFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW5JVW7JwA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v2
	6r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrV
	AFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCI
	c40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267
	AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU17KsU
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

ÔÚ 2024/11/01 22:46, John Garry Ð´µÀ:
> Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes. All other
> stacked device request queue limits should automatically be set properly.
> With regards to atomic write max bytes limit, this will be set at
> hw_max_sectors and this is limited by the stripe width, which we want.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/md/raid0.c | 1 +
>   1 file changed, 1 insertion(+)
> 
LGTM
Reviewed-by: Yu Kuai <yukuai3@huawei.com>

> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index baaf5f8b80ae..7049ec7fb8eb 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -384,6 +384,7 @@ static int raid0_set_limits(struct mddev *mddev)
>   	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
>   	lim.io_min = mddev->chunk_sectors << 9;
>   	lim.io_opt = lim.io_min * mddev->raid_disks;
> +	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err) {
>   		queue_limits_cancel_update(mddev->gendisk->queue);
> 


Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65716309EE4
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 07:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767683638; cv=none; b=VyY22XpsQEAvGpQ2rwaMjdX+DVXyEnOw47Gbyg/SifaU3z5ccTx0G2Spunb53JEh1/upOP+QRcmxznj0u7fkKQu04wNep6M1sQKH527rZim8zp+jxxZ61al4dOsc13t1mrVO8qc9NK5FdekkGVoAJ4StqxgfJzffJHvw0nozXXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767683638; c=relaxed/simple;
	bh=RMRzV+O99Yk2YusLQltIVwbuORam/aj0B3j7LRU+VbI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S4IaLV0Y8gxwDUrXT68q1fC1tp0CP0EONR4NN9zTB0BSm/aD2UbdweDynI/KcvmfkivM+cKOuBp8e4ZVLQIiYsZOp9sZiy3rwq8ofW8Mb4sjxdg7WNq4WHFnXbGC/ELZ5cH1UMM8oomaA2BKdN4kbBupDxwhkzzygxSCxm03ZT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dlj6m00v5zYQv3Y
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 15:12:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 238E34056B
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 15:13:48 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAXd_crtlxpMSo_Cw--.1809S3;
	Tue, 06 Jan 2026 15:13:48 +0800 (CST)
Message-ID: <16045c34-d1ff-3a67-57e5-2a1249e8be43@huaweicloud.com>
Date: Tue, 6 Jan 2026 15:13:47 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 10/11] md/raid0: align bio to io_opt
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: colyli@fnnas.com
References: <20260103154543.832844-1-yukuai@fnnas.com>
 <20260103154543.832844-11-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260103154543.832844-11-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXd_crtlxpMSo_Cw--.1809S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZFy7JFy8Zr1kWF4rKFyUKFg_yoWkWrg_Kr
	1xury7Xr1j9ry2vw1agr1avryYvryrWws7Ca4UK3y3Ary7Xr1FgFn7KF1YqFsFqayDtFn5
	Arn7u3WxCF1vgjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbx8YFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07U_-B
	_UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/3 23:45, Yu Kuai 写道:
> The impact is not so significant for raid0 compared to raid5, however
> it's still more appropriate to issue IOs evenly to underlying disks.
> 
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/raid0.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index f3814a69cd13..0ae44e3bfff2 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -29,8 +29,7 @@ module_param(default_layout, int, 0644);
>   	 (1L << MD_HAS_PPL) |		\
>   	 (1L << MD_HAS_MULTIPLE_PPLS) |	\
>   	 (1L << MD_FAILLAST_DEV) |	\
> -	 (1L << MD_SERIALIZE_POLICY) |	\
> -	 (1L << MD_BIO_ALIGN))
> +	 (1L << MD_SERIALIZE_POLICY))
>   
>   /*
>    * inform the user of the raid configuration
> @@ -398,6 +397,8 @@ static int raid0_set_limits(struct mddev *mddev)
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err)
>   		return err;
> +
> +	md_config_align_limits(mddev, &lim);
>   	return queue_limits_set(mddev->gendisk->queue, &lim);
>   }
>   

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan


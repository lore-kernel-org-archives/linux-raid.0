Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA6321D5BC
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 06:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767682234; cv=none; b=P1G9w+Myn4Om6bycRcgzrZl3XSwvsyEwCkAakwXAnWWvGV3CsfKNQ29usOnXYy75WoeioBWrQew19iAEgXu8Zt9HxLULf4VHj6FonEC1T0XaXK4tKP9f438EaASgz3dy7M5TdJbZHcVoSypB0QbkafwlTdJz3gGy08gnIwW79T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767682234; c=relaxed/simple;
	bh=Ew7YARAYGRLtDIasnl28+nrRAajLdDWob+RdYgzadBk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y9sG3ZryTTfhW7Dw853u3HHBsgRsq0zN1fyVmYatZIKD3PV6POn5marzKxUqG4qBEKBxc470MJgiGIRp7kNTR0JMXTfpJ5uWqOpRrKw+K4ZArzmeXQVEq64LRIDnORVkW1W1jQFFgIVCapddczoT0qSDunzmMaWV1iW4Nxv1L68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dlhcF3wyBzKHMKl
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 14:49:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E4BE640573
	for <linux-raid@vger.kernel.org>; Tue,  6 Jan 2026 14:50:28 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgCX+Pi0sFxpMD09Cw--.5465S3;
	Tue, 06 Jan 2026 14:50:28 +0800 (CST)
Message-ID: <6c5971c7-bd68-7e5f-af30-d9c2727560e7@huaweicloud.com>
Date: Tue, 6 Jan 2026 14:50:28 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 07/11] md: add a helper md_config_align_limits()
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
Cc: colyli@fnnas.com
References: <20260103154543.832844-1-yukuai@fnnas.com>
 <20260103154543.832844-8-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260103154543.832844-8-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCX+Pi0sFxpMD09Cw--.5465S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGry7JF4fXr13tFWkWFWUXFb_yoW5Gw48pa
	1DZFy3Za43Jay5C3ZxZa4UuFW5J3WagrWqkFy3Gws5uF1UuFyUC3yUt3yDJ34DCrn5K347
	K3W8Cr4DGF1rt3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l
	5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67
	AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07Al
	zVAYIcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jrv_JF1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07UCD7
	3UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/3 23:45, Yu Kuai 写道:
> This helper will be used by personalities that want to align bio to
> io_opt to get best IO bandwidth.
> 
> Also add the new flag to UNSUPPORTED_MDDEV_FLAGS for now, following
> patches will enable this for personalities.
> 
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> ---
>   drivers/md/md.h    | 11 +++++++++++
>   drivers/md/raid0.c |  3 ++-
>   drivers/md/raid1.c |  3 ++-
>   drivers/md/raid5.c |  3 ++-
>   4 files changed, 17 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index e7aba83b708b..ddf989f2a139 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -1091,6 +1091,17 @@ static inline bool rdev_blocked(struct md_rdev *rdev)
>   	return false;
>   }
>   
> +static inline void md_config_align_limits(struct mddev *mddev,
> +					  struct queue_limits *lim)
> +{
> +	if ((lim->max_hw_sectors << 9) < lim->io_opt)
> +		lim->max_hw_sectors = lim->io_opt >> 9;
> +	else
> +		lim->max_hw_sectors = rounddown(lim->max_hw_sectors,
> +						lim->io_opt >> 9);
> +	set_bit(MD_BIO_ALIGN, &mddev->flags);
> +}
> +
>   #define mddev_add_trace_msg(mddev, fmt, args...)			\
>   do {									\
>   	if (!mddev_is_dm(mddev))					\
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index d83b2b1c0049..f3814a69cd13 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -29,7 +29,8 @@ module_param(default_layout, int, 0644);
>   	 (1L << MD_HAS_PPL) |		\
>   	 (1L << MD_HAS_MULTIPLE_PPLS) |	\
>   	 (1L << MD_FAILLAST_DEV) |	\
> -	 (1L << MD_SERIALIZE_POLICY))
> +	 (1L << MD_SERIALIZE_POLICY) |	\
> +	 (1L << MD_BIO_ALIGN))
>   
>   /*
>    * inform the user of the raid configuration
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index f4c7004888af..1a957dba2640 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -42,7 +42,8 @@
>   	((1L << MD_HAS_JOURNAL) |	\
>   	 (1L << MD_JOURNAL_CLEAN) |	\
>   	 (1L << MD_HAS_PPL) |		\
> -	 (1L << MD_HAS_MULTIPLE_PPLS))
> +	 (1L << MD_HAS_MULTIPLE_PPLS) |	\
> +	 (1L << MD_BIO_ALIGN))
>   
>   static void allow_barrier(struct r1conf *conf, sector_t sector_nr);
>   static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index db0afb0b70e8..005a2404de27 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -59,7 +59,8 @@
>   #define UNSUPPORTED_MDDEV_FLAGS		\
>   	((1L << MD_FAILFAST_SUPPORTED) |	\
>   	 (1L << MD_FAILLAST_DEV) |		\
> -	 (1L << MD_SERIALIZE_POLICY))
> +	 (1L << MD_SERIALIZE_POLICY) |		\
> +	 (1L << MD_BIO_ALIGN))
>   
>   
>   #define cpu_to_group(cpu) cpu_to_node(cpu)

LGTM

Reviewed-by: Li Nan <linan122@huawei.com>

-- 
Thanks,
Nan


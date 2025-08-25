Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EB8D13959D;
	Mon, 25 Aug 2025 08:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756109498; cv=none; b=QdoIDBzrt5/IvxgLbMDIU/tdnKdWdqsogwYT8re0esM7DLRHn3YOpKhSWFyVH/lCX9RPsW4ODJ+pu6yOF4YZ4jcdEwOvCZ/Hj1t0uQFiyk9pAoPOHTrg6eaJc19etaRKMvNm0aEOxM5/zBVcq1jAZJswsPt4j7aVs+YN5CXCdkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756109498; c=relaxed/simple;
	bh=SubSTqKpLjU7USCCg+5o81bnnBG1jhVBvw/6bln9bDQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SFEYi5wnD1geZH1qfSME/RR7VWhEEj6RhA0SNsTsjruObDS+NJiD8m4ozw5LyNk4efEs4d+kXV0r3kdEp+Yc6P7NmuS62Ku6ZAhYVlMC2SWQBZ81vDkqHtVkGyxECxnjuQpMi3oH4tuqUyTfMlyKiQAVwEsELeQmduKX+tb6GIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.0.5] (ip5f5af7f1.dynamic.kabel-deutschland.de [95.90.247.241])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id B336261E64852;
	Mon, 25 Aug 2025 10:10:27 +0200 (CEST)
Message-ID: <76d66b0b-afaa-4835-9d55-9e61be83ce01@molgen.mpg.de>
Date: Mon, 25 Aug 2025 10:10:26 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] md: prevent adding disks with larger
 logical_block_size to active arrays
To: Li Nan <linan666@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
 bvanassche@acm.org, hch@infradead.org, filipe.c.maia@gmail.com,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250825075924.2696723-1-linan666@huaweicloud.com>
 <20250825075924.2696723-2-linan666@huaweicloud.com>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20250825075924.2696723-2-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Li,


Thank you for your patch.

Am 25.08.25 um 09:59 schrieb linan666@huaweicloud.com:
> From: Li Nan <linan122@huawei.com>
> 
> When adding a disk to a md array, avoid updating the array's
> logical_block_size to match the new disk. This prevents accidental
> partition table loss that renders the array unusable.

Do you have a reproducer to test this?

> The later patch will introduce a way to configure the array's
> logical_block_size.
> 
> Signed-off-by: Li Nan <linan122@huawei.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   drivers/md/md.c | 7 +++++++
>   1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index cea8fc96abd3..206434591b97 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6064,6 +6064,13 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
>   	if (mddev_is_dm(mddev))
>   		return 0;
>   
> +	if (queue_logical_block_size(rdev->bdev->bd_disk->queue) >
> +	    queue_logical_block_size(mddev->gendisk->queue)) {
> +		pr_err("%s: incompatible logical_block_size, can not add\n",
> +		       mdname(mddev));
> +		return -EINVAL;
> +	}
> +
>   	lim = queue_limits_start_update(mddev->gendisk->queue);
>   	queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
>   				mddev->gendisk->disk_name);


Kind regards,

Paul

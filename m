Received: from sender4-op-o12.zoho.com (sender4-op-o12.zoho.com [136.143.188.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FEF1FE471;
	Sat, 20 Sep 2025 09:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758362261; cv=pass; b=NvYNHJDL0kUM784Fgy4EHy+PJ8n3judz00dyztfM/6krZ9nqHkByDlCbziUZmh9A0+fn44i5n+J1vEB54aWXwAJpyD+GP3GGUot1FUVxGYiPDdKuvdNxOfJLNB+oe9S24UJ9+CV1T9RZnPf6casO0R/1KQsXkOtCBTRvbyb7RAE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758362261; c=relaxed/simple;
	bh=vg7j/N6KXr4IxoEWjbu3712EZQFLFn7MEqAtw/QHWNg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=l8tRiZL9rV3b77Coys8OU/bCsVFD5gIOSNifg7V05PdfhfhFlud/SO4+O9adCphbIPrfLiOUFgbIxjGe4vyjpZktdIrUQ46HPsRTg7rBJR6OWsSTzpjzjw3ecj6PWBkhO/CjYvjkkpppyTOuaoKyxZC3K6tH4DoozoWzbCAHQeY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yukuai.org.cn; spf=pass smtp.mailfrom=yukuai.org.cn; dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b=Z//h7M5s; arc=pass smtp.client-ip=136.143.188.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b="Z//h7M5s"
ARC-Seal: i=1; a=rsa-sha256; t=1758362109; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=VatK7+SEVKjEtmqc7MOpL6d+S3QQhRrPMjcgLO0s5qxHMuhv4/sTZt+gDzaGzDRnx+p4/iQG3+NXG+uVXr2rdEEyvbTebMXEDEEEoZh3NWfL9WzHTU2t2U5SGJJxblHWr62IeaRklfqFHs98yYxmESaS2jIfpR1pAEBP2tRAPig=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1758362109; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=SAqzt1Sj3XOdOFgz+QpclQltJ2gaRbdazDpGE9LVmuM=; 
	b=dSAaOqq5B0gTUZSyI85rVOaB2pNEaMoKaXQe8IHubn6Qd5Z2YEEa2elMM9BToVJwlWS0tyL/Qd/X/BatVapFEbp2HoDUboTFOcxZh5LLHRv4ugAaaE6wjJhvzU2e/y+dHQZDE+iHd84ZC2grenVHLjflAkzQZUQBDx9juDYjsIU=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=yukuai.org.cn;
	spf=pass  smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=pass header.from=<hailan@yukuai.org.cn>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1758362109;
	s=zmail; d=yukuai.org.cn; i=hailan@yukuai.org.cn;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=SAqzt1Sj3XOdOFgz+QpclQltJ2gaRbdazDpGE9LVmuM=;
	b=Z//h7M5sDMkueGzkmFWZNS6Be/oZXBpgjrvm8GrCRVmlmmMUQSws2dhn7Zp6HmpD
	MUjUnZZe6oK+nJQkYTruwaHe50aOkyUsiXx5JgpPDMjMmRGFPQjjw8VKmaUR4j3BUmb
	EMNQxiGFDBxWtXdznb80r6hjxRbwnSZISBl2edmo=
Received: by mx.zohomail.com with SMTPS id 1758362107098827.5660583693088;
	Sat, 20 Sep 2025 02:55:07 -0700 (PDT)
Message-ID: <bbde2bbd-e2d0-4d6d-aee2-0c454519627e@yukuai.org.cn>
Date: Sat, 20 Sep 2025 17:55:02 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 1/2] md: prevent adding disks with larger
 logical_block_size to active arrays
To: linan666@huaweicloud.com, corbet@lwn.net, song@kernel.org,
 yukuai3@huawei.com, linan122@huawei.com, hare@suse.de, xni@redhat.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250918115759.334067-1-linan666@huaweicloud.com>
 <20250918115759.334067-2-linan666@huaweicloud.com>
From: Yu Kuai <hailan@yukuai.org.cn>
In-Reply-To: <20250918115759.334067-2-linan666@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

在 2025/9/18 19:57, linan666@huaweicloud.com 写道:

> From: Li Nan <linan122@huawei.com>
>
> When adding a disk to a md array, avoid updating the array's
> logical_block_size to match the new disk. This prevents accidental
> partition table loss that renders the array unusable.
>
> The later patch will introduce a way to configure the array's
> logical_block_size.
>
> The issue was introduced before Linux 2.6.12-rc2.
>
> Fixes: d2e45eace8 ("[PATCH] Fix raid "bio too big" failures")
> Signed-off-by: Li Nan <linan122@huawei.com>
> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> ---
>   drivers/md/md.c | 7 +++++++
>   1 file changed, 7 insertions(+)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index a77c59527d4c..40f56183c744 100644
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

Apply patch 1/2 to md-6.18
Thanks


Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC2CE3559CF
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 11:24:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768217074; cv=none; b=PFVg7i8iQqtkCwWBDuzsxUDpr4TQNHS8N4F4+t0yGrUsV0SWzORQug8SsminOZ5KyF6O79vb7KCyr2EAg84V9iQrDVRXSiaXKSX2x7B0mn6T0effvRb/RE4Q9nhg8lYPynjXI3G7yd78BAOC4tW4ifICvkjXwaiNaYs0lAx+AM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768217074; c=relaxed/simple;
	bh=sS0kzrcRSsvExkSjQcevPovbE3NwFDFZb19Xe1kz4c4=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=a9gsCpA+pLfO1y5RZK9kULAdDIoIiD2zVkLXxjRrn8yG+8Zux0fXM5855bH2yVLyvNhMuYChOtJExQ1v1e87oamWopknrvA/x//PmBRFp/6IdK64v9E7HK1tojlrZlZykpGZL6eZQJQOpbFBuN9FlWZN119Llw83V0yPFODW8BE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dqVPR0z44zKHLtj
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 19:23:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 075BB40573
	for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 19:24:28 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgD3WPno2WRp1YMkDg--.14783S3;
	Mon, 12 Jan 2026 19:24:25 +0800 (CST)
Message-ID: <c1b71e5b-4a94-6b35-c0a6-f92bd1fa9dc4@huaweicloud.com>
Date: Mon, 12 Jan 2026 19:24:24 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 06/11] md: support to align bio to limits
To: Yu Kuai <yukuai@fnnas.com>, linux-raid@vger.kernel.org
References: <20260112042857.2334264-1-yukuai@fnnas.com>
 <20260112042857.2334264-7-yukuai@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260112042857.2334264-7-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3WPno2WRp1YMkDg--.14783S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw1rKr17Ww18AF13ZF4rAFb_yoW8uw4UpF
	WxGrZ3ZrW5JF12gwnxt3WUuF95X34rGr1jqrW7C34kGFnxGF9rGF4YgwsYqr9xCr9rWF15
	Cw1YvF98Cw43trDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1Y6r17
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07URwZ
	7UUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/12 12:28, Yu Kuai 写道:
> For personalities that report optimal IO size, it indicates that users
> can get the best IO bandwidth if they issue IO with this size. However
> there is also an implicit condition that IO should also be aligned to the
> optimal IO size.
> 
> Currently, bio will only be split by limits, if bio offset is not aligned
> to limits, then all split bio will not be aligned. This patch add a new
> feature to align bio to limits first, and following patches will support
> this for each personality if necessary.
> 
> Link: https://lore.kernel.org/linux-raid/20260103154543.832844-7-yukuai@fnnas.com
> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
> Reviewed-by: Li Nan <linan122@huawei.com>
> ---
>   drivers/md/md.c | 54 +++++++++++++++++++++++++++++++++++++++++++++++++
>   drivers/md/md.h |  2 ++
>   2 files changed, 56 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 21b0bc3088d2..731ec800f5cb 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -428,6 +428,56 @@ bool md_handle_request(struct mddev *mddev, struct bio *bio)
>   }
>   EXPORT_SYMBOL(md_handle_request);
>   
> +static struct bio *__md_bio_align_to_limits(struct mddev *mddev,
> +					     struct bio *bio)
> +{
> +	unsigned int max_sectors = mddev->gendisk->queue->limits.max_sectors;
> +	sector_t start = bio->bi_iter.bi_sector;
> +	sector_t end = start + bio_sectors(bio);
> +	sector_t align_start;
> +	sector_t align_end;
> +	u32 rem;
> +
> +	/* calculate align_start = roundup(start, max_sectors) */

Can we use roundup_u64() here?

> +	align_start = start;
> +	rem = sector_div(align_start, max_sectors);
> +	/* already aligned */
> +	if (!rem)
> +		return bio;
> +
> +	align_start = start + max_sectors - rem;
> +
> +	/* calculate align_end = rounddown(end, max_sectors) */

Use div64_u64_rem() here seems better.

> +	align_end = end;
> +	rem = sector_div(align_end, max_sectors);
> +	align_end = end - rem;
> +
> +	/* bio is too small to split */
> +	if (align_end <= align_start)
> +		return bio;
> +
> +	return bio_submit_split_bioset(bio, align_start - start,
> +				       &mddev->gendisk->bio_split);
> +}
> +
-- 
Thanks,
Nan


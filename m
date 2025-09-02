Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D5F2F6175
	for <linux-raid@vger.kernel.org>; Tue,  2 Sep 2025 10:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756810763; cv=pass; b=DjVKNNDYYyxJcKjugx4iXrjSKU+Y6wH5aCMlGYWGYDBPfxmbk1vvVf9WX9mCBNZT5+TBZhZUZA9ecj7mCKpqd/JzZNP12EyAGuevQtiJ8N6BkPzTd6sAXXbW/8Z37EMHjPBjWwNt0BiYkDDo5acQAl4UzAoxVw92pJXBs8qQiX0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756810763; c=relaxed/simple;
	bh=U8Gex1MWHcjSr5ZlRkNr7w3Br11nCOW13v8k0TYlocs=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=e1JnCM4qgrYnIA1a0nOkrRaI010/KiA1YKhe8A/4tcaaQR4hKqFcq3GlaJ470PdudsMNuMT03OCyCdsk6esCOm4XYQvkp6tWmUI1xl80uwUeaYLEfxIbD6lmaEgtVWCjhMYmrsOAROOfQo0KN9rZhQ+ARUU8i4ZSojcki3vnLMQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=yukuai.org.cn; spf=pass smtp.mailfrom=yukuai.org.cn; dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b=OWPQFo5f; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yukuai.org.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yukuai.org.cn header.i=hailan@yukuai.org.cn header.b="OWPQFo5f"
ARC-Seal: i=1; a=rsa-sha256; t=1756810743; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=PqqGTeKGFmnZdPYqTXxfODQfQ4JzKn9mNA4ypKZF0ex0OiygqVxxkrELrK4D7FtFCvsMHd8kN5Z2+m3F2ydVcWff7DtvcLC8VSbQhp44hKUoAHJQdH11jijwiA3aMB/EjQFqJCAambXavbQbXaQziFsmVqSMgGzboaO3LkjTt3c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1756810743; h=Content-Type:Content-Transfer-Encoding:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To:Cc; 
	bh=HHlzAC41EWUkyyLw+59SX+i8tH4FpfzmbYxV2MjMLiU=; 
	b=escVsWtd6/JHAk/jgfZ0k488Z5gMulU93FiQZgCLjkfNb2Dl8YiUXKVQ5l6InwOptbhSsDUBgDPzHVBDry0o9VUbi7k08/LA0MStK0+U4kWhp9j1bVfPJmgpXP0Cx9wlmc8qMVDHJgSuywkOa3s4uu81ZdGMbNpkcdNBeoiqAUQ=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=yukuai.org.cn;
	spf=pass  smtp.mailfrom=hailan@yukuai.org.cn;
	dmarc=pass header.from=<hailan@yukuai.org.cn>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1756810743;
	s=zmail; d=yukuai.org.cn; i=hailan@yukuai.org.cn;
	h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=HHlzAC41EWUkyyLw+59SX+i8tH4FpfzmbYxV2MjMLiU=;
	b=OWPQFo5fOpmQEFRrH0sVC7lr6C/5Dh1i4nE2BIPDSUb/Q75E5e99y3PhtP7DZyfe
	GrABMktd5U2nRnXSfDVhncIlUl/0+WLUiPwiLZXgQODgTfP9vg/cVUmN96pHOSv5TFm
	43WN46kSeF1bXlK9Kbath9txHOdAcbLfAeXPaaAU=
Received: by mx.zohomail.com with SMTPS id 1756810741646488.65564848484996;
	Tue, 2 Sep 2025 03:59:01 -0700 (PDT)
Message-ID: <0c28296f-1661-4629-9114-72bb55c97fa3@yukuai.org.cn>
Date: Tue, 2 Sep 2025 18:58:55 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: Correctly disable write zeroes for raid 1, 10 and 5
To: Damien Le Moal <dlemoal@kernel.org>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org
References: <20250902093843.187767-1-dlemoal@kernel.org>
From: Yu Kuai <hailan@yukuai.org.cn>
In-Reply-To: <20250902093843.187767-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External

Hi,

在 2025/9/2 17:38, Damien Le Moal 写道:
> raid1_set_limits(), raid10_set_queue_limits() and raid5_set_limits()
> set max_write_zeroes_sectors to 0 to disable write zeroes support.
>
> However, blk_validate_limits() checks that if
> max_hw_wzeroes_unmap_sectors is not zero, it must be equal to
> max_write_zeroes_sectors. When creating a RAID1, RAID10 or RAID5 array
> of block devices that have a non-zero max_hw_wzeroes_unmap_sectors
> limit, blk_validate_limits() returns an error resulting in a failure
> to start the array.
>
> Fix this by setting max_hw_wzeroes_unmap_sectors to 0 as well in
> raid1_set_limits(), raid10_set_queue_limits() and raid5_set_limits().
>
> Fixes: 0c40d7cb5ef3 ("block: introduce max_{hw|user}_wzeroes_unmap_sectors to queue limits")
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/md/raid1.c  | 2 ++
>   drivers/md/raid10.c | 1 +
>   drivers/md/raid5.c  | 1 +
>   3 files changed, 4 insertions(+)

Yi already posted a fix:

[PATCH 1/2] md: init queue_limits->max_hw_wzeroes_unmap_sectors 
parameter - Zhang Yi <https://lore.kernel.org/all/20250825083320.797165-2-yi.zhang@huaweicloud.com/>

Thanks,
Kuai

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 408c26398321..b366438f3c00 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -3211,6 +3211,8 @@ static int raid1_set_limits(struct mddev *mddev)
>   
>   	md_init_stacking_limits(&lim);
>   	lim.max_write_zeroes_sectors = 0;
> +	lim.max_hw_wzeroes_unmap_sectors = 0;
> +
>   	lim.features |= BLK_FEAT_ATOMIC_WRITES;
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err)
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index b60c30bfb6c7..fe3390948326 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -4008,6 +4008,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
>   
>   	md_init_stacking_limits(&lim);
>   	lim.max_write_zeroes_sectors = 0;
> +	lim.max_hw_wzeroes_unmap_sectors = 0
>   	lim.io_min = mddev->chunk_sectors << 9;
>   	lim.chunk_sectors = mddev->chunk_sectors;
>   	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 023649fe2476..5f65dd80e2ef 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7732,6 +7732,7 @@ static int raid5_set_limits(struct mddev *mddev)
>   	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
>   	lim.discard_granularity = stripe;
>   	lim.max_write_zeroes_sectors = 0;
> +	lim.max_hw_wzeroes_unmap_sectors = 0
>   	mddev_stack_rdev_limits(mddev, &lim, 0);
>   	rdev_for_each(rdev, mddev)
>   		queue_limits_stack_bdev(&lim, rdev->bdev, rdev->new_data_offset,

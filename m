Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6797D2DF152;
	Wed, 15 Apr 2026 01:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776217243; cv=none; b=Mfa3nM9RcLsxL/7CYOVGK+fnVVour2hEcGZkWhemgTvhGBAZElGrvI/U7M0RDTHDt8eZ4dfpVRKXFJtDJd1kKGnwUKbzrYpAOtFZkLOEr6CGICXrQhCGFBauyNfGZlbomuXVp5tQyDGHBpiMm0VQrR5Tqqd1rAwRdNySioQh10s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776217243; c=relaxed/simple;
	bh=4VtovoQTz+WnsDas9TmXcUweoBQ2l0j3pRRvcGCTsaw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=G7YaT5uv/QWQSpRFCjFy7PC7vX8ScAX41rCLjRdxl0TzQP8IkjuYQ2Qb7C4DnwCNYIC+E+kBLnMdM3Grg2ZIv6wlsSaba8Ulu/34umEf5cG78T2HEEGLS/KvpMs5LjalLgwcp/+bbx9HpkntF9xj0JJFySyeBREdYsjWEQoJ13E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4fwP2x74jpzYQtxw;
	Wed, 15 Apr 2026 09:39:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 3CA8340573;
	Wed, 15 Apr 2026 09:40:39 +0800 (CST)
Received: from [10.174.178.255] (unknown [10.174.178.255])
	by APP3 (Coremail) with SMTP id _Ch0CgBXBb+V7N5pFjnGAQ--.36590S3;
	Wed, 15 Apr 2026 09:40:39 +0800 (CST)
Message-ID: <71b0cc21-bc22-dce0-dd92-d1f691f7d52a@huaweicloud.com>
Date: Wed, 15 Apr 2026 09:40:37 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md: fix kobject reference leak in md_import_device()
To: Guangshuo Li <lgs201920130244@gmail.com>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, Greg Kroah-Hartman <gregkh@suse.de>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org
References: <20260412154219.2560732-1-lgs201920130244@gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260412154219.2560732-1-lgs201920130244@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBXBb+V7N5pFjnGAQ--.36590S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF1fAr4kXw4UZFykKw4UArb_yoW8JFy7pr
	yaqFZ0vrW5Jr4UGwnrZa18uFyruws2vrW8CF1avw1Iq3W5AryDJFy5Cr9xur1DKrWxuF13
	XF1jgFs5K3WrZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x07UMnQUUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/4/12 23:42, Guangshuo Li 写道:
> md_import_device() initializes rdev->kobj with kobject_init() before
> checking the device size and loading the superblock.
> 
> When one of the later checks fails, the error path still frees rdev
> directly with kfree(). This bypasses the kobject release path and leaves
> the kobject reference unbalanced.
> 
> After kobject_init(), release rdev through kobject_put() instead of
> kfree().
> 
> Fixes: f9cb074bff8e ("Kobject: rename kobject_init_ng() to kobject_init()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
> ---
>   drivers/md/md.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 6d73f6e196a9..4ce7512dc834 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3871,6 +3871,9 @@ static struct md_rdev *md_import_device(dev_t newdev, int super_format, int supe
>   
>   out_blkdev_put:
>   	fput(rdev->bdev_file);
> +	md_rdev_clear(rdev);
> +	kobject_put(&rdev->kobj);
> +	return ERR_PTR(err);
>   out_clear_rdev:
>   	md_rdev_clear(rdev);
>   out_free_rdev:

Multiple return points in error handling are strange. Can we move
kobject_init() before return rdev? It would be simpler.

-- 
Thanks,
Nan


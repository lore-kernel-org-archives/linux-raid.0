Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD6F288B5;
	Thu, 31 Oct 2024 01:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730339866; cv=none; b=tEI4+tLO7kRZ46WiPBrZ9G1zWTNtmk9m76H+mb8AS6x1TnUCrgoQ2po1M+IHBM8cq59Gbe9h6vt9DdwkSldufxVDNUHs2IpGYHfanZU5fNT+wHdctEBrKBNVlq4yZ838e2HJ67KNuxbFSPvNptpVuC/avRIdBUV8KX9ni3AbORc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730339866; c=relaxed/simple;
	bh=Nvk6gtzOUBBKduL7W20nZi58AzXjD2xlg9jDt0cmKuQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=MJWB6a681CwCFIMTo2meA2IVC9oxDNJs7BGAlc6xgfNN4Pj0N+lrf1QURv/070jnpXvlEB9PNVtcRue3J1WwxnRgX/RGuHfh0J+5FWv/qiiQC9ZMSv4dn6QUhfZi/HhVOeagZR651DLk6e0HUm35TjHIFIhBSyi3W/IwSvk7xp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xf6ZG3rWJz4f3jkV;
	Thu, 31 Oct 2024 09:57:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 28F101A058E;
	Thu, 31 Oct 2024 09:57:39 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHYoYR5CJnOgSvAQ--.50242S3;
	Thu, 31 Oct 2024 09:57:39 +0800 (CST)
Subject: Re: [PATCH v2 4/5] md/raid1: Atomic write support
To: John Garry <john.g.garry@oracle.com>, axboe@kernel.dk, song@kernel.org,
 hch@lst.de
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241030094912.3960234-1-john.g.garry@oracle.com>
 <20241030094912.3960234-5-john.g.garry@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d4d9d0cf-08ff-6494-172a-44694b6d13f9@huaweicloud.com>
Date: Thu, 31 Oct 2024 09:57:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241030094912.3960234-5-john.g.garry@oracle.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYoYR5CJnOgSvAQ--.50242S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww48GFy7tF1xAF18Cr45KFg_yoW8Wr1rp3
	9Iga4Yyr4Ut3W2kasrAFWUCa1Fyw4kKFWIkF1fJ3yFvrnIgrWDKF4FqFWDWr1jvFyfX34U
	tanYkrZrGF13JaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UAwI
	DUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/10/30 17:49, John Garry Ð´µÀ:
> Set BLK_FEAT_ATOMIC_WRITES_STACKED to enable atomic writes.
> 
> For an attempt to atomic write to a region which has bad blocks, error
> the write as we just cannot do this. It is unlikely to find devices which
> support atomic writes and bad blocks.
> 
> Signed-off-by: John Garry <john.g.garry@oracle.com>
> ---
>   drivers/md/raid1.c | 8 ++++++++
>   1 file changed, 8 insertions(+)
> 
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index a10018282629..b57f69e3e8a7 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1524,6 +1524,13 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>   				blocked_rdev = rdev;
>   				break;
>   			}
> +
> +			if (is_bad && bio->bi_opf & REQ_ATOMIC) {
> +				/* We just cannot atomically write this ... */
> +				error = -EFAULT;
> +				goto err_handle;
> +			}

One nit here. If the write range are all badblocks, then this rdev is
skipped, and bio won't be splited, so I think atomic write is still fine
in this case. Perhaps move this conditon below?

Same for raid10.

Thanks,
Kuai

> +
>   			if (is_bad && first_bad <= r1_bio->sector) {
>   				/* Cannot write here at all */
>   				bad_sectors -= (r1_bio->sector - first_bad);
> @@ -3220,6 +3227,7 @@ static int raid1_set_limits(struct mddev *mddev)
>   
>   	md_init_stacking_limits(&lim);
>   	lim.max_write_zeroes_sectors = 0;
> +	lim.features |= BLK_FEAT_ATOMIC_WRITES_STACKED;
>   	err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>   	if (err) {
>   		queue_limits_cancel_update(mddev->gendisk->queue);
> 


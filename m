Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F714211A11;
	Mon, 18 Aug 2025 02:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755485877; cv=none; b=cd0Hz5Ed69WkyRH1DngY3ueQ6RQQRS/cXHKJYtYSNudRHJ+xjELFzG9kV2pF4Vw3KrAXVVSD2NTuyfuYX2ULU/8aA8f7CKpY3AsLHQYhbdLTTnua0YPksepjzQkzEnDpi8m2v8H/8QVTIyjlAjpusYb9oWt340MTyU54so/7El0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755485877; c=relaxed/simple;
	bh=QxrWNLmgVm6jvDz1RGXpLJXMoaWYFPl1x3f+p9U+mO4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AvATqWYpCGcTPMaTWvp9XstNy2qwMuszUI/+Y2Xy0dHfnMyqn2fUvlYcAV7r7uHpkyli6ZGT4K01hgked5xEvSIlMOqBCttj6DkqJzyPRZLb9gGcjeR2Zx9MzxRWQ/1L0Od2rd3uP+Pznz4GBodBen8LScH6IbwOUnPQZ24HblE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c4y7j2VGjzYQts5;
	Mon, 18 Aug 2025 10:57:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E97E41A0359;
	Mon, 18 Aug 2025 10:57:51 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAHzw+vlqJoK8s7EA--.47149S3;
	Mon, 18 Aug 2025 10:57:51 +0800 (CST)
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
To: Damien Le Moal <dlemoal@kernel.org>, colyli@kernel.org,
 linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250817152645.7115-1-colyli@kernel.org>
 <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ffa13f8c-5dfe-20d4-f67d-e3ccd0c70b86@huaweicloud.com>
Date: Mon, 18 Aug 2025 10:57:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHzw+vlqJoK8s7EA--.47149S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGF4rArWfuFWxuF1kGFy3Jwb_yoWrXry7pF
	n7CFW7Ca1jqF10va4qv3W3CF9Yvw4YyrW8Cr1fGw40kryq9r17KryxtFy5Xrnrtwsxu3y5
	t3W8KF98CFy5u37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvjb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1D
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUwz
	uWDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/08/18 10:51, Damien Le Moal 写道:
> On 8/18/25 12:26 AM, colyli@kernel.org wrote:
>> From: Coly Li <colyli@kernel.org>
>>
>> This patch adds a new BLK_FLAG_STACK_IO_OPT for stack block device. If a
>> stack block device like md raid5 declares its io_opt when don't want
>> blk_stack_limits() to change it with io_opt of underlying non-stack
>> block devices, BLK_FLAG_STACK_IO_OPT can be set on limits.flags. Then in
>> blk_stack_limits(), lcm_not_zero(t->io_opt, b->io_opt) will be avoided.
>>
>> For md raid5, it is necessary to keep a proper io_opt size for better
>> I/O thoughput.
>>
>> Signed-off-by: Coly Li <colyli@kernel.org>
>> ---
>>   block/blk-settings.c   | 6 +++++-
>>   drivers/md/raid5.c     | 1 +
>>   include/linux/blkdev.h | 3 +++
>>   3 files changed, 9 insertions(+), 1 deletion(-)
>>
>> diff --git a/block/blk-settings.c b/block/blk-settings.c
>> index 07874e9b609f..46ee538b2be9 100644
>> --- a/block/blk-settings.c
>> +++ b/block/blk-settings.c
>> @@ -782,6 +782,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>>   		t->features &= ~BLK_FEAT_POLL;
>>   
>>   	t->flags |= (b->flags & BLK_FLAG_MISALIGNED);
>> +	t->flags |= (b->flags & BLK_FLAG_STACK_IO_OPT);
>>   
>>   	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
>>   	t->max_user_sectors = min_not_zero(t->max_user_sectors,
>> @@ -839,7 +840,10 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
>>   				     b->physical_block_size);
>>   
>>   	t->io_min = max(t->io_min, b->io_min);
>> -	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
>> +	if (!t->io_opt || !(t->flags & BLK_FLAG_STACK_IO_OPT) ||
>> +	    (b->flags & BLK_FLAG_STACK_IO_OPT))
>> +		t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
>> +
>>   	t->dma_alignment = max(t->dma_alignment, b->dma_alignment);
>>   
>>   	/* Set non-power-of-2 compatible chunk_sectors boundary */
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 023649fe2476..989acd8abd98 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -7730,6 +7730,7 @@ static int raid5_set_limits(struct mddev *mddev)
>>   	lim.io_min = mddev->chunk_sectors << 9;
>>   	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
> 
> It seems to me that moving this *after* the call to mddev_stack_rdev_limits()
> would simply overwrite the io_opt limit coming from stacking and get you the
> same result as your patch, but without adding the new limit flags.

This is not enough, we have the case array is build on the top of
another array, we still need the lcm_not_zero() to not break this case.
And I would expect this flag for all the arrays, not just raid5.

Thanks,
Kuai

> 
> I do not think that the use of such flag is good as we definitely do not want
> to have more of these. That would make the limit stacking far too complicated
> with too many corner cases. Instead, drivers should simply change whatever
> limit they do not like. DM has the .io_hint method for that. md should have
> something similar.
> 
>>   	lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
>> +	lim.flags |= BLK_FLAG_STACK_IO_OPT;
>>   	lim.discard_granularity = stripe;
>>   	lim.max_write_zeroes_sectors = 0;
>>   	mddev_stack_rdev_limits(mddev, &lim, 0);
>> diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
>> index 95886b404b16..a22c7cea9836 100644
>> --- a/include/linux/blkdev.h
>> +++ b/include/linux/blkdev.h
>> @@ -366,6 +366,9 @@ typedef unsigned int __bitwise blk_flags_t;
>>   /* passthrough command IO accounting */
>>   #define BLK_FLAG_IOSTATS_PASSTHROUGH	((__force blk_flags_t)(1u << 2))
>>   
>> +/* ignore underlying non-stack devices io_opt */
>> +#define BLK_FLAG_STACK_IO_OPT		((__force blk_flags_t)(1u << 3))
>> +
>>   struct queue_limits {
>>   	blk_features_t		features;
>>   	blk_flags_t		flags;
> 
> 


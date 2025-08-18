Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C64253B56;
	Mon, 18 Aug 2025 03:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755488462; cv=none; b=ophgtWEgv2jFS30m+1jratThA7qm2GAImcpu6nOeWJz6nj7mbD7Vj5nFfjJBlDm8/GvE3K/YVnV8MPQ1A8q4vKJBFkrj34Gs5BDSU2LyU8/UOM6ZXnvuiKySu3PiAlG5Gfk5bytYRCnQol2sK1yPIdcNZ6tIFTj5cVMNwpE1kPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755488462; c=relaxed/simple;
	bh=PHmqE4fMlrDfB84UkdFglmG3L5kKYLYUMta5mRAqWEA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=fNij6qvlBMr6ZpYXK4b6oR+Qh0a7gHLpZqTC9lVRce8tHWSVdAUkS63/ax+nQtwFDw2YHtocqrpVOsrlgecXPq4JtPbitH8mduwQ+7Use32kY0T61Ynp/+z1UQeE6FCH7qnTkVSvfibaPKEhiXMbbIP8pIagSSpc2Vuu4ehAKrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c4z5P3F5czKHMwK;
	Mon, 18 Aug 2025 11:40:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C9E751A01A0;
	Mon, 18 Aug 2025 11:40:56 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAXkxPHoKJoqEA_EA--.15353S3;
	Mon, 18 Aug 2025 11:40:56 +0800 (CST)
Subject: Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt
To: Damien Le Moal <dlemoal@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>,
 colyli@kernel.org, linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20250817152645.7115-1-colyli@kernel.org>
 <756b587d-2a5c-4749-a03b-cfc786740684@kernel.org>
 <ffa13f8c-5dfe-20d4-f67d-e3ccd0c70b86@huaweicloud.com>
 <fd5c1916-936b-4253-a7b8-ba53591653f3@kernel.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <4aa48545-7398-c346-5968-5d08f29748c4@huaweicloud.com>
Date: Mon, 18 Aug 2025 11:40:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <fd5c1916-936b-4253-a7b8-ba53591653f3@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXkxPHoKJoqEA_EA--.15353S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJr4rZr4ktw47tr18Xry3XFb_yoW8CF1Dpa
	n7Xayxuw1DXa1Skw17Z3yjvFWFyw15GrWjkr1rKw18Z3Z8Wryavr47tFZ0gr12qanYga12
	yF18CFyDuFnYq37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUf8nOUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/08/18 11:18, Damien Le Moal 写道:
> On 8/18/25 11:57 AM, Yu Kuai wrote:
>>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>>> index 023649fe2476..989acd8abd98 100644
>>>> --- a/drivers/md/raid5.c
>>>> +++ b/drivers/md/raid5.c
>>>> @@ -7730,6 +7730,7 @@ static int raid5_set_limits(struct mddev *mddev)
>>>>        lim.io_min = mddev->chunk_sectors << 9;
>>>>        lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
>>>
>>> It seems to me that moving this *after* the call to mddev_stack_rdev_limits()
>>> would simply overwrite the io_opt limit coming from stacking and get you the
>>> same result as your patch, but without adding the new limit flags.
>>
>> This is not enough, we have the case array is build on the top of
>> another array, we still need the lcm_not_zero() to not break this case.
>> And I would expect this flag for all the arrays, not just raid5.
> 
> Nothing prevents you from doing that in the md code. The block layer stacking
> limits provides a sensible default. If the block device driver does not like
> the default given, it is free to change it for whatever valid reason it has.
> As I said, that's what the DM .io_hint target driver method is for.

Then code will be much complex insdie md code, and we'll have to
reimplement the stack limits logical with the consideration if each rdev
is already a stacked rdev. I really do not like this ...

And in theroy, we can't handle this case just in md code:

scsi disk -> mdarray -> device mapper/loop/nbd ... -> mdarray

> 
> As for the "expected that flag for all arrays", that is optimistic at best. For
> scsi hardware raid, as discussed already, the optimal I/O size is *not* the
> stripe size. And good luck with any AHCI-based hardware RAID...
> 

Yes, I just mean mdraid arrays, we absolutely don't want to touch other
drivers.

Thanks,
Kuai


Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19070189;
	Fri, 19 Sep 2025 01:28:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758245339; cv=none; b=LxjBMO3e/4WO0kwnp+pzGPz9eBJbsMCwlIe2kZAYC5c2FDGr1HocnOSADLESOcn8tE3ATeutyW+oc2n7x88tWTCEKhjzIGRAteFV4/lHm6UYa/bAKwg4O2Bmh01CQsDkOre3B7rl6iezvgxThjalBGq0GhtqHAPJ5eqcoPU4N+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758245339; c=relaxed/simple;
	bh=beRbRfRtwY3JAiodbdYptrbjM59UwQ3ombgy/IWrSUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jSt2jx4op6Jf3lFTMF/GxoQgqK85KNNNx0+MTBY/fC6Ph2tyEetN479U3tgFQzxwnloUxrHODKZSaoE/zLtAxWuPNk9gXVtvSpswflfTaSNlw1UlfgkOMQJW0Yq38qYzSFlGtL+Irp2GH8B6P4wXem6pfjAyO0BD8GFy3/DOCyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cSZfJ3zC0zYQtf0;
	Fri, 19 Sep 2025 09:28:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 359881A1B78;
	Fri, 19 Sep 2025 09:28:55 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgBnK2PUscxo6lxAAA--.17696S3;
	Fri, 19 Sep 2025 09:28:53 +0800 (CST)
Message-ID: <cbce67bc-74c6-0c99-fdba-48cd8aa27dda@huaweicloud.com>
Date: Fri, 19 Sep 2025 09:28:52 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 6/9] md/raid1,raid10: Fix missing retries Failfast
 write bios on no-bbl rdevs
To: Kenta Akagi <k@mgml.me>, linan666@huaweicloud.com, song@kernel.org,
 yukuai3@huawei.com, mtkaczyk@kernel.org, shli@fb.com, jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <010601995da37ff4-b47cc6d9-a75b-4ef0-bced-e5a9a55c3f77-000000@ap-northeast-1.amazonses.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <010601995da37ff4-b47cc6d9-a75b-4ef0-bced-e5a9a55c3f77-000000@ap-northeast-1.amazonses.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBnK2PUscxo6lxAAA--.17696S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuF1Uuw1rur43JrWUCr45ZFb_yoW5Xr4Up3
	4kJFyrJrWUXr10q3W8tw1jqFyrt3y7Ga1DXr1UXF1UJ390yr12qF48XryYgF1jqrs7Gr17
	Xr4UWrZrZFyUJwUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUAxhLUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/19 0:23, Kenta Akagi 写道:
> 
> 
> On 2025/09/18 15:58, Li Nan wrote:
>>
>>
>> 在 2025/9/17 21:33, Kenta Akagi 写道:
>>>
>>>
>>> On 2025/09/17 19:06, Li Nan wrote:
>>>>
>>>>
>>>> 在 2025/9/15 11:42, Kenta Akagi 写道:
>>>>> In the current implementation, write failures are not retried on rdevs
>>>>> with badblocks disabled. This is because narrow_write_error, which issues
>>>>> retry bios, immediately returns when badblocks are disabled. As a result,
>>>>> a single write failure on such an rdev will immediately mark it as Faulty.
>>>>>
>>>>
>>>> IMO, there's no need to add extra logic for scenarios where badblocks
>>>> is not enabled. Do you have real-world scenarios where badblocks is
>>>> disabled?
>>>
>>> No, badblocks are enabled in my environment.
>>> I'm fine if it's not added, but I still think it's worth adding WARN_ON like:
>>>
>>> @@ -2553,13 +2554,17 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
>>>     fail = true;
>>> + WARN_ON( (bio->bi_opf & MD_FAILFAST) && (rdev->badblocks.shift < 0) );
>>>     if (!narrow_write_error(r1_bio, m))
>>>
>>> What do you think?
>>>
>>
>> How about this?
>>
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2522,10 +2522,11 @@ static bool narrow_write_error(struct r1bio *r1_bio, int i)
>>          bool ok = true;
>>
>>          if (rdev->badblocks.shift < 0)
>> -               return false;
>> +               block_sectors = bdev_logical_block_size(rdev->bdev) >> 9;
>> +       else
>> +               block_sectors = roundup(1 << rdev->badblocks.shift,
>> +                                       bdev_logical_block_size(rdev->bdev) >> 9);
>>
>> -       block_sectors = roundup(1 << rdev->badblocks.shift,
>> -                               bdev_logical_block_size(rdev->bdev) >> 9);
>>          sector = r1_bio->sector;
>>          sectors = ((sector + block_sectors)
>>                     & ~(sector_t)(block_sectors - 1))
>>
>> rdev_set_badblocks() checks shift, too. rdev is marked to Faulty if setting
>> badblocks fails.
> 
> Sounds good. If badblocks are disabled, rdev_set_badblocks() returns false, so there
> should be no problem.
> 
> Can this be included in the cleanup?
> https://lore.kernel.org/linux-raid/20250917093508.456790-3-linan666@huaweicloud.com/T/#u
> 
> or should I resend this patch as proposed?

Yes, please resend. I will rewrite my patch.

-- 
Thanks,
Nan


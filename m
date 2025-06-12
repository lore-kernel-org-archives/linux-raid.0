Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F9462222AF;
	Thu, 12 Jun 2025 09:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749719871; cv=none; b=uJAfIWJcMmAv9oe11Nv9ANE+VF35Z4MSfT1hANRq471IMtd8j2TmCofgKHG96xLYo2/eDjYj8HhnPV9aEgR8DUWg2TvbNmr00KVteJypCi75OBIvAzvMCzuEbfR2TvTaFJlxfVp0XN0uEzqn9zwkkIW7L040i5NXEP5Hop08f5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749719871; c=relaxed/simple;
	bh=AYn6w5HqdoefDuqIJEeom4HNHLTtpuUVZFxF2Pelyo4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=QeXomeZqgtj9N0uYHygTiEkJgYXRaE77vyb4hsMGP+8y+M6QJk1VUeeqmzf9DI0mRCmvYhTC502pPA7iDuKOIGIDTZOr4mScvchjuSFqJF4KxfYmwLGWTi4nPXP98M+TV2n7zX1po/cCAtz5iicSFARivqGf3iM6UgLnK20IggQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bHxkz3mz5zKHMsZ;
	Thu, 12 Jun 2025 17:17:47 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id DB31C1A08FF;
	Thu, 12 Jun 2025 17:17:45 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDXOl84m0pof0wePQ--.20994S3;
	Thu, 12 Jun 2025 17:17:45 +0800 (CST)
Subject: Re: [PATCH v2] md/raid1: Fix stack memory use after return in
 raid1_reshape
To: Wang Jinchao <wangjinchao600@gmail.com>, Yu Kuai
 <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250611090203.271488-1-wangjinchao600@gmail.com>
 <5143c5c3-3a77-919f-0d38-8adb0e8923e9@huaweicloud.com>
 <06935480-a959-4e3f-8e41-286d7f54754a@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9c7d5e66-4f5f-b984-c291-f19c3d568b85@huaweicloud.com>
Date: Thu, 12 Jun 2025 17:17:44 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <06935480-a959-4e3f-8e41-286d7f54754a@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDXOl84m0pof0wePQ--.20994S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw48WFykCFW7Cry5Jr45GFg_yoW7Kr4xpr
	s5tFyUGrW5u3s3Jr1UXr1UXFyYkr1kJ3WDJr18JFy8XrsrJr1Fgr4UXr90gr1UXr4kJr1U
	Jr15JrsrZF17XrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/06/12 15:45, Wang Jinchao 写道:
> 在 2025/6/12 15:31, Yu Kuai 写道:
>> Hi,
>>
>> 在 2025/06/11 16:55, Wang Jinchao 写道:
>>> In the raid1_reshape function, newpool is
>>> allocated on the stack and assigned to conf->r1bio_pool.
>>> This results in conf->r1bio_pool.wait.head pointing
>>> to a stack address.
>>> Accessing this address later can lead to a kernel panic.
>>>
>>> Example access path:
>>>
>>> raid1_reshape()
>>> {
>>>     // newpool is on the stack
>>>     mempool_t newpool, oldpool;
>>>     // initialize newpool.wait.head to stack address
>>>     mempool_init(&newpool, ...);
>>>     conf->r1bio_pool = newpool;
>>> }
>>>
>>> raid1_read_request() or raid1_write_request()
>>> {
>>>     alloc_r1bio()
>>>     {
>>>         mempool_alloc()
>>>         {
>>>             // if pool->alloc fails
>>>             remove_element()
>>>             {
>>>                 --pool->curr_nr;
>>>             }
>>>         }
>>>     }
>>> }
>>>
>>> mempool_free()
>>> {
>>>     if (pool->curr_nr < pool->min_nr) {
>>>         // pool->wait.head is a stack address
>>>         // wake_up() will try to access this invalid address
>>>         // which leads to a kernel panic
>>>         return;
>>>         wake_up(&pool->wait);
>>>     }
>>> }
>>>
>>> Fix:
>>> The solution is to avoid using a stack-based newpool.
>>> Instead, directly initialize conf->r1bio_pool.
>>>
>>> Signed-off-by: Wang Jinchao <wangjinchao600@gmail.com>
>>> ---
>>> v1 -> v2:
>>> - change subject
>>> - use mempool_init(&conf->r1bio_pool) instead of reinitializing the 
>>> list on stack
>>> ---
>>>   drivers/md/raid1.c | 34 +++++++++++++++++++---------------
>>>   1 file changed, 19 insertions(+), 15 deletions(-)
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 19c5a0ce5a40..f2436262092a 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -3366,7 +3366,7 @@ static int raid1_reshape(struct mddev *mddev)
>>>        * At the same time, we "pack" the devices so that all the missing
>>>        * devices have the higher raid_disk numbers.
>>>        */
>>> -    mempool_t newpool, oldpool;
>>> +    mempool_t oldpool;
>>>       struct pool_info *newpoolinfo;
>>>       struct raid1_info *newmirrors;
>>>       struct r1conf *conf = mddev->private;
>>> @@ -3375,9 +3375,6 @@ static int raid1_reshape(struct mddev *mddev)
>>>       int d, d2;
>>>       int ret;
>>> -    memset(&newpool, 0, sizeof(newpool));
>>> -    memset(&oldpool, 0, sizeof(oldpool));
>>> -
>>>       /* Cannot change chunk_size, layout, or level */
>>>       if (mddev->chunk_sectors != mddev->new_chunk_sectors ||
>>>           mddev->layout != mddev->new_layout ||
>>> @@ -3408,26 +3405,33 @@ static int raid1_reshape(struct mddev *mddev)
>>>       newpoolinfo->mddev = mddev;
>>>       newpoolinfo->raid_disks = raid_disks * 2;
>>> -    ret = mempool_init(&newpool, NR_RAID_BIOS, r1bio_pool_alloc,
>>> -               rbio_pool_free, newpoolinfo);
>>> -    if (ret) {
>>> -        kfree(newpoolinfo);
>>> -        return ret;
>>> -    }
>>>       newmirrors = kzalloc(array3_size(sizeof(struct raid1_info),
>>> -                     raid_disks, 2),
>>> -                 GFP_KERNEL);
>>> +    raid_disks, 2),
>>> +    GFP_KERNEL);
>>>       if (!newmirrors) {
>>>           kfree(newpoolinfo);
>>> -        mempool_exit(&newpool);
>>>           return -ENOMEM;
>>>       }
>>> +    /* stop everything before switching the pool */
>>>       freeze_array(conf, 0);
>>> -    /* ok, everything is stopped */
>>> +    /* backup old pool in case restore is needed */
>>>       oldpool = conf->r1bio_pool;
>>> -    conf->r1bio_pool = newpool;
>>> +
>>> +    ret = mempool_init(&conf->r1bio_pool, NR_RAID_BIOS, 
>>> r1bio_pool_alloc,
>>> +               rbio_pool_free, newpoolinfo);
>>> +    if (ret) {
>>> +        kfree(newpoolinfo);
>>> +        kfree(newmirrors);
>>> +        mempool_exit(&conf->r1bio_pool);
>>> +        /* restore the old pool */
>>> +        conf->r1bio_pool = oldpool;
>>> +        unfreeze_array(conf);
>>> +        pr_err("md/raid1:%s: cannot allocate r1bio_pool for reshape\n",
>>> +            mdname(mddev));
>>> +        return ret;
>>> +    }
>>>       for (d = d2 = 0; d < conf->raid_disks; d++) {
>>>           struct md_rdev *rdev = conf->mirrors[d].rdev;
>>>
>>
>> Any specific reason not to use mempool_resize() and krealloc() here?
>> In the case if new raid_disks is greater than the old one.
> The element size is different between the old pool and the new pool.
> mempool_resize only resizes the pool size (i.e., the number of elements 
> in pool->elements), but does not handle changes in element size, which 
> occurs in raid1_reshape.
> 
> Another reason may be to avoid modifying the old pool directly — in case 
> initializing the new pool fails, the old one remains usable.
> 
> If we modify the old pool directly and the operation fails, not only 
> will the reshaped RAID be unusable, but the original RAID may also be 
> corrupted.

Yes, you're right, thanks for the explanation.

I feel like raid1_reshape() need better coding, anyway, your fix looks
good.

Reviewed-by: Yu Kuai <yukuai3@huawei.com>

>>
>> Thanks,
>> Kuai
>>
> 
> .
> 


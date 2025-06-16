Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6C12D9EF3;
	Mon, 16 Jun 2025 11:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750073565; cv=none; b=uJ9Vi6zXLvEIRggfuL+AJWDeViPV3xRdpxefHo/ZVAjwuv4nsjvDZHCmlJkFUpMIXx75Uo4XjOmwYhwD2mqM03OJST4WKVhAXbi93m8XvhBpYbWh1lVjiN3RMCOKE/v1uU0o8ObeqySeD1e6MvXWMVESgwF7Ad8l9SWmp741trc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750073565; c=relaxed/simple;
	bh=qFzH7nDxVxhBuZ6wfSoR0S5kYoV5v/qxy6rZqdqeRgM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=BXgch+Zsww1gH+tnbUCkihnxUO6XdrE0hN/SHf1aWVWl/tYDMxNzmFeMGZnKLrSFBsN2WPUHOv69fHPJacekWnZWzXgLcCFKO7zrW+y5bHcMB7uXHAYyE7fmK8KC5qfzsC6YtYv23MjftOJhtiOPJeq/EkdyBHAoM4cePvvzkfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bLSXm5d2nzYQvpc;
	Mon, 16 Jun 2025 19:32:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BCF381A2208;
	Mon, 16 Jun 2025 19:32:39 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXul7WAFBoyYfHPg--.11393S3;
	Mon, 16 Jun 2025 19:32:39 +0800 (CST)
Subject: Re: [PATCH v2] md/raid1: Fix stack memory use after return in
 raid1_reshape
To: Wang Jinchao <wangjinchao600@gmail.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 Song Liu <song@kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
References: <20250611090203.271488-1-wangjinchao600@gmail.com>
 <5143c5c3-3a77-919f-0d38-8adb0e8923e9@huaweicloud.com>
 <06935480-a959-4e3f-8e41-286d7f54754a@gmail.com>
 <9c7d5e66-4f5f-b984-c291-f19c3d568b85@huaweicloud.com>
 <938b0969-cace-4998-8e4a-88d445c220b1@gmail.com>
 <8a876d8f-b8d1-46c0-d969-cbabb544eb03@huaweicloud.com>
 <726fe46d-afd5-4247-86a0-14d7f0eeb3b3@gmail.com>
 <c328bc72-0143-d11c-2345-72d307920428@huaweicloud.com>
 <9275145b-3066-41e5-a971-eba219ef0d3c@gmail.com>
 <a4f9b5a2-bf83-482e-e1fe-589f9ff004a1@huaweicloud.com>
 <0ccb9479-92ac-4c8e-afdc-a1e3f14fe401@gmail.com>
 <351b7dc4-7a2c-4032-bf2c-2edaa9da9300@gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d7022eb3-4dee-8d15-1018-051b882467b2@huaweicloud.com>
Date: Mon, 16 Jun 2025 19:32:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <351b7dc4-7a2c-4032-bf2c-2edaa9da9300@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXul7WAFBoyYfHPg--.11393S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGFy7Jw4xuFyDJw1kXry3XFb_yoW5CF4Dpa
	18KasIkr4vvrnIyrsrAa1xuFy5tw4IgFWxGrs3G3y7Zr9I9a4fWr4UKry3CF4UXr4rXw40
	va15JFykZFyj9aDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2025/06/16 18:11, Wang Jinchao 写道:
> On 6/13/25 19:53, Wang Jinchao wrote:
>> On 2025/6/13 17:15, Yu Kuai wrote:
>>> Hi,
>>>
>>> 在 2025/06/12 20:21, Wang Jinchao 写道:
>>>> BTW, I feel raid1_reshape can be better coding with following：
>>>
>>> And another hint:
>>>
>>> The poolinfo can be removed directly, the only other place to use it
>>> is r1buf_pool, and can covert to pass in conf or &conf->raid_disks.
>> Thanks, I'll review these relationships carefully before refactoring.
>>>
>>> Thanks,
>>> Kuai
>>>
>>
> Hi Kuai,
> 
> After reading the related code, I’d like to discuss the possibility of 
> rewriting raid1_reshape.
> 
> I am considering converting r1bio_pool to use 
> mempool_create_kmalloc_pool. However, mempool_create_kmalloc_pool 
> requires the element size as a parameter, but the size is calculated 
> dynamically in r1bio_pool_alloc(). Because of this, I feel that 
> mempool_create() may be more suitable here.

You only need raid_disks to calculate the size, the value will not
change.
> 
> I noticed that mempool_create() was used historically and was later 
> replaced by mempool_init() in commit afeee514ce7f. Using 
> mempool_create() would essentially be a partial revert of that commit, 
> so I’m not sure whether this is appropriate.

This is fine, the commit introduce the porblem.
> 
> Regarding raid1_info and pool_info, I feel the original design might be 
> more suitable for the reshape process.
> 
> The goals of raid1_reshape() are:
> 
> - Keep the array usable for as long as possible.
This is not needed, reshape is a slow path, just don't introduce
problems.

> - Be able to restore the previous state if reshape fails.
Yes.

> So I think we need to follow some constraints:
> 
> - conf should not be modified before freeze_array().
> - We should try to prepare everything possible before freeze_array().
> - If an error occurs after freeze_array(), it must be possible to roll 
> back.
> 
> Now, regarding the idea of rewriting raid1_info or pool_info:
> 
> Convert raid1_info using krealloc:

1) If raid_disks decreases, you don't need to realloc it;
2) If raid_disks increases, call krealloc after freezing the array, you
can't call it before in order to prevent concurrent access.
> 
> According to rule 1, krealloc() must be called after freeze_array(). 
> According to rule 2, it should be called before freeze_array(). → So 
> this approach seems to violate one of the rules.
> 
> Use conf instead of pool_info:

I'm suggesting to remove pool_info, you should change conf->raid_disks
as it is now, while the array is freezed.

Thanks,
Kuai

> 
> According to rule 1, conf->raid_disks must be modified after 
> freeze_array(). According to rule 2, conf->raid_disks needs to be 
> updated before calling mempool_create(), i.e., before freeze_array().
> These also seem to conflict.
> 
> For now, I’m not considering rule 3, as that would make the logic even 
> more complex.
> 
> I’d really appreciate your thoughts on whether this direction makes 
> sense or if there’s a better approach.
> 
> Thank you for your time and guidance.
> .
> 


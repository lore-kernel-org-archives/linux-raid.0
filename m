Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2F30157E99;
	Thu, 17 Apr 2025 01:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744854435; cv=none; b=HjgjAvNa+qZXg/mEw+mXiYwssU70s+QTZzCGvmShNmx0VaIwGiWMuN0JNhuZqEcu1QUyr+mBhXoHGumsNDKEo17WaB8JFSfr8r6a4UYKwiFshWbIddvocZKzAfxlQkWkrr9/mGv8efRADBdLny+H6UJQTs7N9lAUsOosmf112Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744854435; c=relaxed/simple;
	bh=vAcIja/yPzEK6VYFQ9AlYR0BZHj9McAx2cs4ghgRe8M=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YIQQ1p46w+78En6R1qDBpeSklbUto58hsARw6SynOfnhCTi7Q9v3CLd2ew75BZ3ND14ddgfr3p1i2Iqy3f+x2LsiV30FVEXFZxqRu/JW+0EYrd43b/Gq/+NXw/9I4Vq4gubfdZ4F0M5rMxL1rVnfGkyCCodEz7BsSZDqvX8S4x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4ZdLNN1q5Xz4f3jdC;
	Thu, 17 Apr 2025 09:46:44 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EF9051A1332;
	Thu, 17 Apr 2025 09:47:07 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgD3W2CaXQBok7DVJg--.731S3;
	Thu, 17 Apr 2025 09:47:07 +0800 (CST)
Subject: Re: [PATCH 3/4] md: fix is_mddev_idle()
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, song@kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250412073202.3085138-1-yukuai1@huaweicloud.com>
 <20250412073202.3085138-4-yukuai1@huaweicloud.com>
 <c085664e-3a52-4a1c-b973-8d2ba6e5d509@redhat.com>
 <42cbe72e-1db5-1723-789d-a93b5dc95f8f@huaweicloud.com>
 <4358e07e-f78b-cd32-bbed-c597b8bb4c19@huaweicloud.com>
 <CALTww294r=ZFrmyK4=s8NMs4MZfdvZ-m6cLTQqXy+b+tW7gkBA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2acd0bd5-f514-6c59-e90e-18a6d46174c2@huaweicloud.com>
Date: Thu, 17 Apr 2025 09:47:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww294r=ZFrmyK4=s8NMs4MZfdvZ-m6cLTQqXy+b+tW7gkBA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3W2CaXQBok7DVJg--.731S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uF18XrW8ZrWfAw1kJF47urg_yoW8CFyfpa
	4Uu3W5tFWUGry3KwsFv3Z3Wa45t3yfXwnIqr15tr17u398KrnYkay8t3s5u34rWr1kZr1j
	qw4jgay7AF15AFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/04/16 17:44, Xiao Ni 写道:
> On Wed, Apr 16, 2025 at 5:29 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2025/04/16 15:42, Yu Kuai 写道:
>>> Hi,
>>>
>>> 在 2025/04/16 14:20, Xiao Ni 写道:
>>>>> +static bool is_rdev_idle(struct md_rdev *rdev, bool init)
>>>>> +{
>>>>> +    unsigned long last_events = rdev->last_events;
>>>>> +
>>>>> +    if (!bdev_is_partition(rdev->bdev))
>>>>> +        return true;
>>>>
>>>>
>>>> For md array, I think is_rdev_idle is not useful. Because
>>>> mddev->last_events must be increased while upper ios come in and idle
>>>> will be set to false. For dm array, mddev->last_events can't work. So
>>>> is_rdev_idle is for dm array. If member disk is one partition,
>>>> is_rdev_idle alwasy returns true, and is_mddev_idle always return
>>>> true. It's a bug here. Do we need to check bdev_is_partition here?
>>>
>>> is_rdev_idle() is not used for current array, for example:
>>>
>>> sda1 is used for array md0, and user doesn't issue IO to md0, while
>>> user issues IO to sda2. In this case, is_mddev_idle() still fail for
>>> array md0 because is_rdev_idle() fail.
> 
> Thanks very much for the explanation. It makes sense :)
> 
>>
>> Perhaps the name is_rdev_holder_idle() is better.
> 
> Your suggestion is better. And it's better to add some comments before
> this function.
> 
> But how about dm-raid? Can this patch work for dm-raid?

is_rdev_holder_idle() can work for dm-raid, however, the part to
check if normal IO is inflight or completed can't work for dm-raid,
currently there is no way to grab dm gendisk from mddev. However, I
think there won't be regression since the old buggy is_mddev_idle()
almost always return false.

Thanks,
Kuai

> 
> Regards
> Xiao
> 
>>
>> Thanks,
>> Kuai
>>
>>>
>>> This is just inherited from the old behaviour.
>>>
>>> Thanks,
>>> Kuai
>>>
>>>>
>>>> Best Regards
>>>>
>>>> Xiao
>>>
>>> .
>>>
>>
> 
> 
> .
> 


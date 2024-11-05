Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87DCD18A931
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 09:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730798555; cv=none; b=GflFXMton055/Sab14hqsc4VnUm0oDOoIfXB7pqL8UU7SBNKjaAfKJuUd4MrWiusoEJRATdXALD+hwPhO5SYfHKxGW5N4zlJaXBpi/MQBTesIqMBuSHNB1YeGysaDmkFFeW7yfuXKjxbT1sfSYzG8kYrGGiDUU8B7m9bOkDBMzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730798555; c=relaxed/simple;
	bh=4FLaI9ULsB/sCcL9++mT80X8YR1KdoF/ldeZ1F55pQI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=omP5wY1Z4TagAAEqaQc5Vs8TRES9oL6wE3LghBC24J8tZlouFkqLZT3SFreEutdZ/yw+pB0XXHvHvClzXGOxHkuRdIRNhJUjBvvQiX/o8U6T3Hm/0A/sipoLcTWdZkl2XJ0ZXBPdGDZ4Bfvc+Bp8N2kyd2ID/E9LBDZfj8yyyoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XjNC56F9Sz4f3jXl
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 17:22:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id CA0641A0568
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 17:22:27 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXc4fS4yln3vqkAw--.61518S3;
	Tue, 05 Nov 2024 17:22:27 +0800 (CST)
Subject: Re: [PATCH RFC 1/1] md: Use pers->quiesce in mddev_suspend
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, song@kernel.org,
 linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20241105075733.66101-1-xni@redhat.com>
 <20241105091601.00001267@linux.intel.com>
 <08186a07-57b4-9e8f-d088-0e009ebe8fa5@huaweicloud.com>
 <CALTww2_PV8=1G1TUasA=nwXgE2+jRWcVtQpVxmB35xSAQ1ea2Q@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <14d9288b-6ac6-6573-5d3c-5667becff0aa@huaweicloud.com>
Date: Tue, 5 Nov 2024 17:22:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww2_PV8=1G1TUasA=nwXgE2+jRWcVtQpVxmB35xSAQ1ea2Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXc4fS4yln3vqkAw--.61518S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXF4fXF18KFyDAr1DurWktFb_yoW5Xw4Up3
	97tF4Yya1UJr98Cw1jqw1kWryrtw1UKr42vry7G3s8K3srKr1fXrW5Wa15WrZFkFySkwsI
	vw45tw1fXryUCF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2024/11/05 17:01, Xiao Ni 写道:
> On Tue, Nov 5, 2024 at 4:29 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/11/05 16:16, Mariusz Tkaczyk 写道:
>>> On Tue,  5 Nov 2024 15:57:33 +0800
>>> Xiao Ni <xni@redhat.com> wrote:
>>>
>>>> One customer reports a bug: raid5 is hung when changing thread cnt
>>>> while resync is running. The stripes are all in conf->handle_list
>>>> and new threads can't handle them.
>>>
>>> Is issue fixed with this patch? Is is missing here :)
>>>>
>>>> Commit b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removes
>>>> pers->quiesce from mddev_suspend/resume, then we can't guarantee sync
>>>> requests finish in suspend operation. One personality knows itself the
>>>> best. So pers->quiesce is a proper way to let personality quiesce.
>>>
>>>>
>>>> Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
>>>> Signed-off-by: Xiao Ni <xni@redhat.com>
>>>> ---
>>>>    drivers/md/md.c | 6 ++++++
>>>>    1 file changed, 6 insertions(+)
>>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index 67108c397c5a..7409ecb2df68 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -482,6 +482,9 @@ int mddev_suspend(struct mddev *mddev, bool interruptible)
>>>>               return err;
>>>>       }
>>>>
>>>> +    if (mddev->pers)
>>>> +            mddev->pers->quiesce(mddev, 1);
>>>> +
>>>
>>> Shouldn't it be implemented as below? According to b39f35ebe86d, some levels are
>>> not implementing this?
>>>
>>> +     if (mddev->pers && mddev->pers->quiesce)
>>> +             mddev->pers->quiesce(mddev, 1);
>>
>> It's fine, the fops is never NULL, just some levels points to an empty
>> function.
>>
>> The tricky part here is that accessing "mddev->pers" is not safe here,
>> 'reconfig_mutex' is not held in mddev_suspend(), and can concurrent
>> with, for example, change levels. :(
> 
> Hi Kuai
> 
> Now mddev->suspended is protected by mddev->suspend_mutex. It should
> can avoid the problem you mentioned above? level_store calls
> mddev_suspend and mddev->suspended is set to mddev->suspended+1. So
> other paths will return because mddev->suspended is not 0.

Yeah, level store is just an wrong example, key point here is that
mddev->pers is not protected by 'suspend_mutex'. Other places are
md_run() and md_stop(), these path doesn't hold 'suspend_mutex' right?
And they look like can concurrent with suspend, for example,
suspend_lo_store()

Did you consider just fail raid5_store_group_thread_cnt() if sync_thread
is active?

Or call ->quiesce() directly here with 'reconfig_mutex' held before
suspend?

Thanks,
Kuai

> 
> Regards
> Xiao
>>
>> Thanks,
>> Kuai
>>
>>>
>>> Is it reproducible with upstream kernel?
>>>
>>> Thanks,
>>> Mariusz
>>>
>>> .
>>>
>>
> 
> 
> .
> 


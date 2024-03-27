Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC9817BA6
	for <linux-raid@vger.kernel.org>; Wed, 27 Mar 2024 01:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711501643; cv=none; b=ROlt7L3Fu/lvfkAsf2dbLYLh93W7jjUX9j3x2e6s70L515E05yxUCnP3PE0rgZP9Ii/5V9SDsKFgenKzf9Cok/vukMj/z1W8LyLGzN9aty+klWpa8DS52Me8A1FvHIzrJXdTpAARycSnDKzMLl7d0Tyq4gxbBIkA/joAXk6sL0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711501643; c=relaxed/simple;
	bh=79SAt9AX3n2iv6Cw3e9FFy8+sAFhxj1IMuxp8ArQQ/s=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NaoNYmUzLyEe+BQJtL+kPnbEtWcxnsakLyvQ+JN3oIzGPP71Z5+dvvVh/dyUfG1Usl3JOTkVPsxLW44B+HUOzZxcZ1wB9RVN6h6FF9ui11DZYCL5WIShiD4uA2vp/TAibhMX/9Wc9oluhtCLvLxuCT/2M1idjXysBN604awBSWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4V47mt5G2rz4f3kFs
	for <linux-raid@vger.kernel.org>; Wed, 27 Mar 2024 09:07:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id EB73C1A01A8
	for <linux-raid@vger.kernel.org>; Wed, 27 Mar 2024 09:07:16 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBXKBFDcQNmi_7CIA--.30163S3;
	Wed, 27 Mar 2024 09:07:16 +0800 (CST)
Subject: Re: [PATCHv3] md: Replace md_thread's wait queue with the swait
 variant
To: =?UTF-8?Q?Florian-Ewald_M=c3=bcller?= <florian-ewald.mueller@ionos.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: Jinpu Wang <jinpu.wang@ionos.com>, song@kernel.org,
 linux-raid@vger.kernel.org, Paul Menzel <pmenzel@molgen.mpg.de>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240307120835.87390-1-jinpu.wang@ionos.com>
 <CAMGffEm8hhg=C1BayDxRhGSTT2b0DBzopr3RWB7aM+XG3yTYNg@mail.gmail.com>
 <551949c9-c6ff-1ae6-fa05-660f1bd76249@huaweicloud.com>
 <CAHJVUei1TOy07B_k-6j7ZRD1AaAS-xMGPX+GSL0ZWR4=f01FJw@mail.gmail.com>
 <CAHJVUeiaDCnCF7Z2Hvj+n4VnB7VMfkorEWqytU5cBq3o9_vayw@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8488f430-ec23-9cee-a90c-58648096cbde@huaweicloud.com>
Date: Wed, 27 Mar 2024 09:07:15 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAHJVUeiaDCnCF7Z2Hvj+n4VnB7VMfkorEWqytU5cBq3o9_vayw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBXKBFDcQNmi_7CIA--.30163S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur47KF13WryDJr4DKFyfJFb_yoW5Cw4xpF
	98JFyqkFWkAryYyws2yws7X348tw4fWr45WFn8Wr17Awn0gF9agry0gry5Ca4q9rn7Gw1j
	qr4UKFWfArs0y37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/03/27 3:49, Florian-Ewald Müller 写道:
> Hi Kuai,
> 
> here (attached) the promised simple patch.
> 

You can send this patch, LGTM.

Thanks,
Kuai

> Best,
> Florian
> 
> On Tue, Mar 26, 2024 at 4:51 PM Florian-Ewald Müller
> <florian-ewald.mueller@ionos.com> wrote:
>>
>> Hello Kuai,
>>
>> Thank you for your comments and questions.
>>
>> About our tests:
>> - we used many (>= 100) logical volumes (each 100 GiB big) on top of 3
>> x md-raid5s (making up a raid50) on 8 SSDs each.
>> - further we started a fio instance doing random rd/wr (also of random
>> sizes) on each of those volumes,
>>
>> And, yes indeed, as you suggested, we observed some performance change
>> already after adding (first) wq_has_sleeper().
>> The fio IOPS results improved by around 3-4% - but, in my experience,
>> every fluctuation <= 3% can also have other reasons (e.g. different
>> timings, temperature on SSDs, etc.).
>>
>> Only afterwards, I've also changed the wait queue construct with the
>> swait variant (sufficient here), as its wake up path is simpler,
>> faster and with a smaller stack footprint.
>> Also used the (now since some years available) IDLE state for the
>> waiting thread to eliminate the (not anymore necessary) checking and
>> flushing of signals.
>> This second round of changes, although theoretically an improvement,
>> didn't bring any measurable performance increase, though.
>> This was more or less expected.
>>
>> If you think, the simple adding of the wq_has_sleeper() is more
>> justifiable, please apply only this change.
>> Later today, I'll also send you a patch containing only this simple change.
>>
>> Best regards,
>> Florian
>>
>> On Tue, Mar 26, 2024 at 3:09 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>
>>> Hi,
>>>
>>> 在 2024/03/26 13:22, Jinpu Wang 写道:
>>>> Hi Song, hi Kuai,
>>>>
>>>> ping, Any comments?
>>>>
>>>> Thx!
>>>>
>>>> On Thu, Mar 7, 2024 at 1:08 PM Jack Wang <jinpu.wang@ionos.com> wrote:
>>>>>
>>>>> From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
>>>>>
>>>>> Replace md_thread's wait_event()/wake_up() related calls with their
>>>>> simple swait~ variants to improve performance as well as memory and
>>>>> stack footprint.
>>>>>
>>>>> Use the IDLE state for the worker thread put to sleep instead of
>>>>> misusing the INTERRUPTIBLE state combined with flushing signals
>>>>> just for not contributing to system's cpu load-average stats.
>>>>>
>>>>> Also check for sleeping thread before attempting its wake_up in
>>>>> md_wakeup_thread() for avoiding unnecessary spinlock contention.
>>>
>>> I think it'll be better to split this into a seperate patch.
>>> And can you check if we just add wq_has_sleeper(), will there be
>>> performance improvement?
>>>
>>>>>
>>>>> With this patch (backported) on a kernel 6.1, the IOPS improved
>>>>> by around 4% with raid1 and/or raid5, in high IO load scenarios.
>>>
>>> Can you be more specifical about your test? because from what I know,
>>> IO fast path doesn't involved with daemon thread, and I don't understand
>>> yet where the 4% improvement is from.
>>>
>>> Thanks,
>>> Kuai
>>>


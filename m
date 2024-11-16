Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D04AE23C9
	for <linux-raid@vger.kernel.org>; Sat, 16 Nov 2024 03:14:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731726878; cv=none; b=CwL7PKGix7tY2L+PF+HV7D1nqo/ObblOBnSU+zSqF9cseOXikk9mOPW6tc+eSBx90orE+lYVLEQSdXlH4iCivCKL5IMm9Kv+CGhDfAmbyXMupcgszFVT7JZd2oViynY3UoDIO6JX7AF5scUOiWj2TKp7FcMQHQ0LEzZde8wXyJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731726878; c=relaxed/simple;
	bh=OMuGscuQqatgm90LfZX+xdOOFftlIaXoM0JqwYZ1xoU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=A7r+5NbQyQ9az8YRHIFhVPEmMZvH16IlNKUV0uO6hU/2tI73cwE1zF8UctYytCX3XHLe4dsMW9n+VefDo63BBBIyQERZ62tgCY1HAqwNsiXtvRPDylrNnlZ7puihC6pb6pRwJ0J3APaxZTfqlOUZ6OcQ7fP0xMYczhOPKJvdd8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XqzWQ3tTzz4f3lDF
	for <linux-raid@vger.kernel.org>; Sat, 16 Nov 2024 11:14:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id C3C6F1A018D
	for <linux-raid@vger.kernel.org>; Sat, 16 Nov 2024 11:14:29 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCnzoITDjhn17KoBw--.31696S3;
	Sat, 16 Nov 2024 11:14:29 +0800 (CST)
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Haris Iqbal <haris.iqbal@ionos.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Xiao Ni <xni@redhat.com>
Cc: =?UTF-8?Q?Dragan_Milivojevi=c4=87?= <galileo@pkm-inc.com>,
 linux-raid@vger.kernel.org,
 =?UTF-8?Q?Florian-Ewald_M=c3=bcller?= <florian-ewald.mueller@ionos.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 David Jeffery <djeffery@redhat.com>, Jinpu Wang <jinpu.wang@ionos.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
 <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
 <4a914bc9-0d4e-e7c8-bed8-7b781f585587@huaweicloud.com>
 <CALTww297-iYB1m2Y0_ceHn1Y43nB-RZdw67QSm6zWZ3hGEtkig@mail.gmail.com>
 <CAJpMwyiR3B0ismDXXyqS-HSzyiiVDj7YYE85m91oDvB9apnB6g@mail.gmail.com>
 <8f7173c6-8847-129c-c5ed-27eb3b8a8458@huaweicloud.com>
 <CAJpMwyjPcLQ=HF5EOXgQFOy=bGHLDWZQJ5CwUV0UHMnyeSPM_g@mail.gmail.com>
 <fb9db285-dff0-681c-1dcf-7f01350ccb48@huaweicloud.com>
 <CAJpMwyi8v2LvdVG2nJ-aJOHDpw79tcwGfPbgV--4xH67NC2B3Q@mail.gmail.com>
 <3fbe69c8-375c-c397-d40d-bc26d4aeda1a@huaweicloud.com>
 <CAMGffEnSJ9KMtB8O4x7Mzyvt4X53CHDMHi9WArGecjOhjh2dTg@mail.gmail.com>
 <6691be8d-994f-b219-213d-26557c258559@huaweicloud.com>
 <CAMGffE=BmZJB2orbrP6SiL=vSPz8E0JZT6OeFb7tNONCBepUEQ@mail.gmail.com>
 <CAJpMwyiSsw2zr9-WYVkNJMrw8RU3Lpt-AvNHr30wor5+GpL2yg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <71228ad0-054c-682d-be74-29b6fe216ce6@huaweicloud.com>
Date: Sat, 16 Nov 2024 11:14:27 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAJpMwyiSsw2zr9-WYVkNJMrw8RU3Lpt-AvNHr30wor5+GpL2yg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnzoITDjhn17KoBw--.31696S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WF43tFyUtry5Wr4DGrWDtwb_yoW8urWxp3
	yqvF1aqaykJrsxGrsFvw18u3WFy3srKr4xX34rJw4fWas0qr98GF48JrWDCr1DGr4Sk3yf
	ta1UJrnrAF1DZa7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

在 2024/11/15 17:26, Haris Iqbal 写道:
> On Thu, Nov 14, 2024 at 1:54 PM Jinpu Wang <jinpu.wang@ionos.com> wrote:
>>
>> On Thu, Nov 14, 2024 at 1:19 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>
>>> Hi,
>>>
>>> 在 2024/11/14 18:27, Jinpu Wang 写道:
>>>> Do you want us to try the following change on top of the md/md-6.13
>>>> branch without Xiao's patch and your fixup alone, or combine them all
>>>> together?
>>>
>>> Combine them please, sorry that I forgot to mention it.
>>>
>>> And for md/md-6.13 there will be conflicts. So try v6.11 is better I
>>> think.
>> Thanks for clarification.
>> I have to chery-pick the following 3 commits to apply clean on v6.11.5
>>
>> 6f039cc42f21 md/raid5: rename wait_for_overlap to wait_for_reshape
>> 0e4aac736666 md/raid5: only add to wq if reshape is in progress
>> e6a03207b925 md/raid5: use wait_on_bit() for R5_Overlap
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 2868e2e20dea..6df5e9e65494 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -5867,17 +5867,6 @@ static int add_all_stripe_bios(struct r5conf *conf,
>>                          wait_on_bit(&dev->flags, R5_Overlap,
>> TASK_UNINTERRUPTIBLE);
>>                          return 0;
>>                  }
>> -       }
>> -
>> -       for (dd_idx = 0; dd_idx < sh->disks; dd_idx++) {
>> -               struct r5dev *dev = &sh->dev[dd_idx];
>> -
>> -               if (dd_idx == sh->pd_idx || dd_idx == sh->qd_idx)
>> -                       continue;
>> -
>> -               if (dev->sector < ctx->first_sector ||
>> -                   dev->sector >= ctx->last_sector)
>> -                       continue;
>>
>>                  __add_stripe_bio(sh, bi, dd_idx, forwrite, previous);
>>                  clear_bit((dev->sector - ctx->first_sector) >>
>>
>> Will report back the result.
> 
> Ran the above patches and changes, and there was no hang.

Thanks for the test! AlthoughI'm not 100% sure for my sulotion for now,
at least the problem is located.

Give me sometime to sort things out. :)

Thanks,
Kuai

> 
>>
>>>
>>>>
>>>> BTW: we hit similar hung since kernel 4.19.
>>>
>>> Good to know, I think Xiao's patch alone is fine for 4.19, the
>>> BUG_ON() probabaly won't be triggered.
>>
>> Thx!
>>>
>>> Thanks,
>>> Kuai
>>>
>>>
> 
> .
> 


Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B75D154454
	for <linux-raid@vger.kernel.org>; Fri, 22 Nov 2024 08:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732262686; cv=none; b=n9PmqqHPXyeGeg7kqvaAs1hGmySs9MtFWUYu0f/B3DsoJsQKCo6yzkbXEooWfGOjwcS6fuHD2FoKUXPTcugfgnFTjrZLumK+S5NdgnWM+2V7EYp4775a12fRLb55LKzqeHVKJ+tN6OoNINATTGGHJG6O/u0GndLMy3dm3h/ool4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732262686; c=relaxed/simple;
	bh=+2C7fWg73UFK/jfu2zCvxngVrPjvuOqupTu9AwuVBWk=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Yko6cWvVsVh5v+kOSH+xcEXRDdr8ahNd+Lq0ddzGkBbaDcTwwQQ/4WM2GbbbEUi9sneFV9Dk+1/dzcJrdgGRYZ+bN2l3qNdwtfbkgo8n0thry00jBILddqqQIJf32QHTpfZS6LWXm6pNmqWo1Q3F4+t5oJxM2u6coAalVdEq9+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XvngR5RdHz4f3mHt
	for <linux-raid@vger.kernel.org>; Fri, 22 Nov 2024 16:04:19 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 445421A0194
	for <linux-raid@vger.kernel.org>; Fri, 22 Nov 2024 16:04:39 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXc4cVO0BnDKL9CQ--.61455S3;
	Fri, 22 Nov 2024 16:04:39 +0800 (CST)
Subject: Re: [PATCH v3 3/4] mdadm: remove bitmap file support
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241120064637.3657385-1-yukuai1@huaweicloud.com>
 <20241120064637.3657385-4-yukuai1@huaweicloud.com>
 <20241120112730.00002cbe@linux.intel.com>
 <6e8270ba-a188-96ff-d8c5-30a3dc614be6@huaweicloud.com>
 <20241121091500.00004ce6@linux.intel.com>
 <122fe099-6e2b-8b1e-a9c2-d027cadb08b8@huaweicloud.com>
 <20241122085555.00003318@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <5753b3ec-28fe-8653-bfc7-ed2db18ca695@huaweicloud.com>
Date: Fri, 22 Nov 2024 16:04:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241122085555.00003318@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXc4cVO0BnDKL9CQ--.61455S3
X-Coremail-Antispam: 1UD129KBjvJXoWxXF4fKFykWw4ruryrCr1kuFg_yoW5KrykpF
	4rtF15KF1xJr1jk347t34FgFy8Kwn7Jr17WrnrJa4rXas0gFna9r4rKFy09F9rZrZ7Z34j
	vw43Za4xuFnYvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUjuHq7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/22 15:55, Mariusz Tkaczyk 写道:
> On Fri, 22 Nov 2024 09:13:18 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> 在 2024/11/21 16:15, Mariusz Tkaczyk 写道:
>>> On Thu, 21 Nov 2024 09:25:50 +0800
>>> Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>>    
>>>>> BitmapUnknown should be used only if we failed to parse bitmap setting in
>>>>> cmdline. Otherwise first and default value should be always BitmapNone
>>>>> because data access is always highest priority and dropping bitmap is
>>>>> always safe. We can print warning in config parse failed or bitmap value
>>>>> is repeated- it is reasonable. If I'm wrong here, please let me know.
>>>>
>>>> Hi, there is a little difference betewwn BitmapNone and BitmapUnknow, if
>>>> user doesn't pass in the "bitmap=xxx", then the BitmapUnkonw will be
>>>> used to decide choosing BitmapNone or BimtapInternal based on the disk
>>>> size. In Create:
>>>>
>>>>            if (!s->bitmap_file &&
>>>>            ┊   !st->ss->external &&
>>>>            ┊   s->level >= 1 &&
>>>>            ┊   st->ss->add_internal_bitmap &&
>>>>            ┊   s->journaldisks == 0 &&
>>>>            ┊   (s->consistency_policy != CONSISTENCY_POLICY_RESYNC &&
>>>>            ┊    s->consistency_policy != CONSISTENCY_POLICY_PPL) &&
>>>>            ┊   (s->write_behind || s->size > 100*1024*1024ULL)) {
>>>>                    if (c->verbose > 0)
>>>>                            pr_err("automatically enabling write-intent
>>>> bitmap on large array\n");
>>>>                    s->bitmap_file = "internal";
>>>>            }
>>>>
>>>> And I realized that I should used BitmapUnknow here, not BimtapNone.
>>>
>>> Oh yes.. Looking on that from the interface perspective suggest me that we
>>> should remove it and always let user to decide. If the are not satisfied
>>> with resync times they can enable bitmap in any moment but it may cause
>>> functional regression for users that are used to this auto turning on.
>>>
>>> Maybe, we can move it to main() and ask without checking raid size, assuming
>>> that array size <100GB is used mainly for testing nowadays?
>>>
>>> Here, proposal based on current code, your change may require some
>>> adjustments:
>>>
>>> diff --git a/mdadm.c b/mdadm.c
>>> index 8cb4ba66ac20..2e803d441dd4 100644
>>> --- a/mdadm.c
>>> +++ b/mdadm.c
>>> @@ -1535,6 +1535,13 @@ int main(int argc, char *argv[])
>>>                           break;
>>>                   }
>>>
>>> +               if (!s->bitmap_file && !c.runstop != 1 && s->level >= 1) {
>>> +                       int response = ask("To optimalize resync speed, it
>>> is recommended to enable write-indent bitmap, do you want to enable it
>>> now?"); +
>>> +                       if (response)
>>> +                               s->bitmap_file = "internal";
>>> +               }
>>> +
>>>                   rv = Create(ss, &ident, devs_found - 1, devlist->next, &s,
>>> &c); break;
>>>           case MISC:
>>>
>>> This is more reasonable than auto-forcing bitmap without possibility
>>> to skip it (even for testing). I added c->runstop verification because it is
>>> often used in Create to skip some errors and questions.
>>>
>>> What do you think?
>>
>> I think it's good! I used to be curious why bitmap is not enabled by
>> default for testing, and have to look into the source code.
>>
> One note here (this one is easy to be missed):
> If user set --bitmap=None we should not prompt this question, assuming that user
> already made his decision. You need to differentiate default BitmapNone
> and user defined BitmapNone (boolean is_bitmap_set should be fine, because
> adding another enum status is not valuable I think).

TBO, I'll prefer keep the BitmapUnknow for initiazation. Only prompt
this question for BitmapUnknow, and switch to none or internal for
response.

Thanks,
Kuai

> 
> Mariusz
> 
> 
> .
> 


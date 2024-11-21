Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B523B23099D;
	Thu, 21 Nov 2024 08:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732178692; cv=none; b=qGdYJij532EyPHhRmsOEtFw1fnk0ov9gAImFx8cT0rD30eFPsrWeZ7CgvSvy9DVIrR4dAR4gFV7rwz1ritFL0sasgb3H+Qsh/h8jWLpSgVwh28CShFiCQusu2FpkzaMsJy9MCRX4yIZnwJ0DROxVLYrfbU2+RXGhlUeHT8LoqVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732178692; c=relaxed/simple;
	bh=FoeFGTI96Du72kve/j6LnmKN4UCy9AlL83qFjZEsyU0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=H29vkiqrzqw7DRpzRIIM4kEsmj8EHlDtDtH8BVvEamXfP3uMbMzpVEWIrv0haN5OPpyswHZjBFRyGsj/q3h1JAEhAdTkRQAiG2iWWKUZ/gn92TCF2vYK8weS1IL/9bCLAX0bBAG5gy9OMzulrcGVrOCOB5wc0R0kZDML+RqItl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XvBc54mngz4f3jYJ;
	Thu, 21 Nov 2024 16:44:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 38CA11A0196;
	Thu, 21 Nov 2024 16:44:40 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgDHo4f28j5nV6ugCQ--.36204S3;
	Thu, 21 Nov 2024 16:44:40 +0800 (CST)
Subject: Re: [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector()
To: Jinpu Wang <jinpu.wang@ionos.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Haris Iqbal <haris.iqbal@ionos.com>, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, song@kernel.org, xni@redhat.com,
 yangerkun@huawei.com, yi.zhang@huawei.com,
 =?UTF-8?Q?Florian-Ewald_M=c3=bcller?= <florian-ewald.mueller@ionos.com>,
 Christian Theune <ct@flyingcircus.io>, "yukuai (C)" <yukuai3@huawei.com>
References: <adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweicloud.com>
 <20241119152939.158819-1-jinpu.wang@ionos.com>
 <CAMGffEkODwo19u0EjKojQ0WaWVkvOOB8aRR8R3NXn+oC6TFQWQ@mail.gmail.com>
 <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com>
 <CAMGffE=hKeWTJzna8gFi=Q9wSuY9SLFScftdGVqc5MNW_jxQ4Q@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <19e59a67-35a8-164d-67e7-bc55508f4dd0@huaweicloud.com>
Date: Thu, 21 Nov 2024 16:44:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAMGffE=hKeWTJzna8gFi=Q9wSuY9SLFScftdGVqc5MNW_jxQ4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHo4f28j5nV6ugCQ--.36204S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKr1fZr4UJF4UAF15Ww48JFb_yoWDJwc_XF
	y5AryDu3s7GF18AFsrt3W5trsrJFZ7GrZ5J3y8JF10v34kJF15Xr48Ww1xXw1fAa1rKrn2
	9w1rZFn8Kw42gjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VU13ku3UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/21 16:40, Jinpu Wang 写道:
> Hi
> On Thu, Nov 21, 2024 at 9:33 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/11/21 16:10, Jinpu Wang 写道:
>>> On Tue, Nov 19, 2024 at 4:29 PM Jack Wang <jinpu.wang@ionos.com> wrote:
>>>>
>>>> Hi Kuai,
>>>>
>>>> We will test on our side and report back.
>>> Hi Kuai,
>>>
>>> Haris tested the new patchset, and it works fine.
>>> Thanks for the work.
>>
>> Thanks for the test! And just to be sure, the BUG_ON() problem in the
>> other thread is not triggered as well, right?
> Yes, we tested the patchset on top of md/for-6.13 branch, no hang, no
> BUG_ON, it was running fine
>>
>> +CC Christian
>>
>> Are you able to test this set for lastest kernel?
> see above.

Are you guys the same team with Christian? Because there is another
thread that he reported the same problem.

Thanks,
Kuai

>>
>> Thanks,
>> Kuai
> Thx!
>>
>>>>
>>>> Yes, I meant patch5.
>>>>
>>>> Regards!
>>>> Jinpu Wang @ IONOS
>>>>
>>>
>>> .
>>>
>>
> 
> .
> 


Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E731BBBDC;
	Thu, 21 Nov 2024 11:01:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732186903; cv=none; b=LurqZZMf7Asfr7fSOZQXdxAHol6NGDWfr3VSlwBQGhZATLBbDSqoRpvjERUtqIu4X6DLTxHbf2H9W5KWuk2A5ZmRb76Asw1WJpNmyWOK5LetFjCt8v5MKkRGKsFtc4uuCJ8dmgKLkoviHkHN+EqlcPkgKFu8NI2vJEZ57Ut+iTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732186903; c=relaxed/simple;
	bh=408LT1IWjoN4marM98RDb+DLNXIp7h5tz8bHKxqodvI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=RGSVpX9RIa3doBOHyGdfEsKWaVUeCZ1HpX1+6+5vmJAZyk+4RoVfYp7p3Fg0CSFz5XNDQ5tGX53JPekyJmdVY0BWz2RceeivhjXORFWcBKcRbgLPntiXeYCJ7W+EhsUSpohJE2AlGDN0INwKmYq2wggg3PMhe+PVSdgWoodUohA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4XvFf55JDqz4f3jcs;
	Thu, 21 Nov 2024 19:01:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 485111A0196;
	Thu, 21 Nov 2024 19:01:36 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgB3U4cOEz9nKJ6pCQ--.29643S3;
	Thu, 21 Nov 2024 19:01:36 +0800 (CST)
Subject: Re: [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector()
To: Christian Theune <ct@flyingcircus.io>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Jinpu Wang <jinpu.wang@ionos.com>, Haris Iqbal <haris.iqbal@ionos.com>,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, song@kernel.org,
 xni@redhat.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 =?UTF-8?Q?Florian-Ewald_M=c3=bcller?= <florian-ewald.mueller@ionos.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweicloud.com>
 <20241119152939.158819-1-jinpu.wang@ionos.com>
 <CAMGffEkODwo19u0EjKojQ0WaWVkvOOB8aRR8R3NXn+oC6TFQWQ@mail.gmail.com>
 <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com>
 <DFAA8E00-E2CD-4BD0-99E5-FD879A6B2057@flyingcircus.io>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6434853a-4df4-d3c4-14b9-a0d4ad599602@huaweicloud.com>
Date: Thu, 21 Nov 2024 19:01:34 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <DFAA8E00-E2CD-4BD0-99E5-FD879A6B2057@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3U4cOEz9nKJ6pCQ--.29643S3
X-Coremail-Antispam: 1UD129KBjvdXoWrKFW8JrW7urW7AF1xCF4xXrb_yoWDZrc_WF
	W5ZFyqk348XF40yFsrtFyYqrWkGFyxC34rJ348GF4I934kXFn8WrsYg3s5Za1xZF4ftFna
	kr93Z3Z0kws2qjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbfxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr0_
	Cr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s
	1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0
	cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8Jw
	ACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka0xkI
	wI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/21 17:30, Christian Theune 写道:
> Hi,
> 
>> On 21. Nov 2024, at 09:33, Yu Kuai <yukuai1@huaweicloud.com> wrote:
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
>>> Haris tested the new patchset, and it works fine.
>>> Thanks for the work.
>>
>> Thanks for the test! And just to be sure, the BUG_ON() problem in the
>> other thread is not triggered as well, right?
>>
>> +CC Christian
>>
>> Are you able to test this set for lastest kernel?
> 
> I have scheduled testing for later today. My current plan was to try Xiao Ni’s fix on 6.6 as that did fix it on 6.11 for me.
> 
> Which way forward makes more sense now? Are those two patches independent or amalgamated or might they be stepping on each others’ toes?

Our plan is to apply this set to latest kernel first, and then backport
this to older kernel. Xiao's fix will not be considered. :(

Thanks,
Kuai

> 
> Christian
> 


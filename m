Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532EB320391;
	Tue, 23 Sep 2025 09:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758618622; cv=none; b=PXHpCWPRN8xMew382+N0grznn5TnhTbelC9YAj8PjJ7uU0+NlwEc8hpj4aObWCkoZPVky8fPII3IUngBrX24g0yhCiZvwLD45dpCVWGhLMcDwoiM25CQR9JIt3sDX14svAwPNHWmS4owq4SekqU7UWwRLPin4cACl5GnyvzRfqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758618622; c=relaxed/simple;
	bh=Ie3KuNDVsGGcq2MePqHSIBuVXMHsD/6PiGILJ+mecn4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=HLQ5ZFDGgarrg9mAS4dsrQOMbezMMdeQsevmwIVKezNpymW2Zz5rIULe9nd7LFsv31t3SiFFLfnwHYLvgCMF/YQx3Og3nDz49UIIVYVe3Frn4ZaqtFGW65p4dZjplH+y4LxcSMGxslZrY51ODFFOCUYTTUvHP+Ekw51B5GFZGNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cWDhf4w1KzKHMS5;
	Tue, 23 Sep 2025 17:10:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A15E21A14C4;
	Tue, 23 Sep 2025 17:10:15 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDn+GDzY9Jo2psqAg--.16669S3;
	Tue, 23 Sep 2025 17:10:12 +0800 (CST)
Subject: Re: [PATCH] md/md-linear: Enable atomic writes
To: John Garry <john.g.garry@oracle.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 martin.petersen@oracle.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250903161052.3326176-1-john.g.garry@oracle.com>
 <b6820280-cc1f-beae-2c1c-077d46bbf721@huaweicloud.com>
 <557f39a4-a760-4b10-80e3-229f7a4892cb@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <84bbff83-b5db-6789-a668-61cc5cb7c761@huaweicloud.com>
Date: Tue, 23 Sep 2025 17:10:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <557f39a4-a760-4b10-80e3-229f7a4892cb@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDn+GDzY9Jo2psqAg--.16669S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Aw4DXr1fKw4DWw1xGF47CFg_yoW8ZFyrpr
	Z7XFWIyFyDJFy8X3yjq347uFWFqrWDJw42qF15X3W8Kr4qgrnFgFWSqw4qgFnrAw4rAwnr
	J3W0ka9FvF1DWr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
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

在 2025/09/23 16:21, John Garry 写道:
> On 05/09/2025 10:02, Yu Kuai wrote:
>> 在 2025/09/04 0:10, John Garry 写道:
>>> All the infrastructure has already been plumbed to support this for
>>> stacked devices, so just enable the request_queue limits features flag.
>>>
>>> A note about chunk sectors for linear arrays:
>>> While it is possible to set a chunk sectors param for building a linear
>>> array, this is for specifying the granularity at which data sectors from
>>> the device are used. It is not the same as a stripe size, like for 
>>> RAID0.
>>>
>>> As such, it is not appropriate to set chunk_sectors request queue 
>>> limit to
>>> the same value, as chunk_sectors request limit is a boundary for which
>>> requests cannot straddle.
>>>
>>> However, request_queue limit max_hw_sectors is set to chunk sectors, 
>>> which
>>> almost has the same effect as setting chunk_sectors limit.
>>>
>>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>>>
>>> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
>>> index 5d9b081153757..30ac29b990c9b 100644
>>> --- a/drivers/md/md-linear.c
>>> +++ b/drivers/md/md-linear.c
>>> @@ -74,6 +74,7 @@ static int linear_set_limits(struct mddev *mddev)
>>>       lim.max_hw_sectors = mddev->chunk_sectors;
>>>       lim.max_write_zeroes_sectors = mddev->chunk_sectors;
>>>       lim.io_min = mddev->chunk_sectors << 9;
>>> +    lim.features |= BLK_FEAT_ATOMIC_WRITES;
>>>       err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>>>       if (err)
>>>           return err;
>>>
>>
>> LGRM
>> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
>>
> 
> thanks
> 
> Could I have this picked up now? Maybe it was missed.
> 
Already picked last weekend, sorry that I forgot to reply.

https://git.kernel.org/pub/scm/linux/kernel/git/mdraid/linux.git/commit/?h=md-6.18&id=b481e72d24feac15017b579232370aa4b33d4129

Thanks,
Kuai
> .
> 


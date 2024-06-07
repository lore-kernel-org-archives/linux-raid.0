Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD2014F9E6
	for <linux-raid@vger.kernel.org>; Fri,  7 Jun 2024 06:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717741042; cv=none; b=oQyxMxU/lqgXgVUAp7LKu2k4oh57V+GfvSxP7TH0BaVeAZy0ag19uUJHGJ/52K1WqCIhqTLb0KDHd4OiT4447Q7mv5ixULTmSqqtxRsii9ENb6Iu0vXhzuHYIVF3NGHj7CC2FRynbXK7m4Sh43t8prHj7Ssm+rnYDiaAoIyWJMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717741042; c=relaxed/simple;
	bh=Ey2nXfgcWuiaeFe+k3sjp/GxI8amGGj0PStPSV2Hae8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Nt7ilHRhBTk4SHkC2faclEBc9ruq1O2EXLQqsa8fSlBFFkJqmhymSKjiT8ejUyoZbh9aYV1v86YrWJjRoZcxCwFhpIjM9dkkWp2V0QiLkKONjC9X2tdU29nxL4G5mz15MHQTiAj9RtisQFbEERWFD3V8ztcrdizDCD/s/4A8hKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VwWFF60mnz4f3jd7
	for <linux-raid@vger.kernel.org>; Fri,  7 Jun 2024 14:17:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 98EC31A0181
	for <linux-raid@vger.kernel.org>; Fri,  7 Jun 2024 14:17:15 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAn+RHrpWJm3G8wOw--.29365S3;
	Fri, 07 Jun 2024 14:17:15 +0800 (CST)
Subject: Re: [PATCH 1/2] md/raid0: don't free conf on raid0_run failure
To: Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@lst.de>,
 Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <20240604172607.3185916-1-hch@lst.de>
 <20240604172607.3185916-2-hch@lst.de>
 <45ab7eb3-02d4-dbc2-8956-1387a008e53f@huaweicloud.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <703d7cf4-e869-d96c-1778-818b29192a3e@huaweicloud.com>
Date: Fri, 7 Jun 2024 14:17:14 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <45ab7eb3-02d4-dbc2-8956-1387a008e53f@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAn+RHrpWJm3G8wOw--.29365S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFy7XryUtryDtFy8uFyfZwb_yoW5Jryfpr
	s5tay5XrWUKr93Gw1DJrWDWa4Yyr47t34DKrykZa48AF43AryqgFy5Zr1qgryUArW8Xw1r
	Jr45trnxuFyDJrJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkK14x267AKxVWUJVW8JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7VUbWCJP
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/06/07 14:08, Yu Kuai 写道:
> 在 2024/06/05 1:25, Christoph Hellwig 写道:
>> The core md code calls the ->free method which already frees conf.
>>
>> Fixes: 0c031fd37f69 ("md: Move alloc/free acct bioset in to personality")
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> LGTM
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>

Sorry that I just noticed that the sysfs api level_store() calls the
pers->run() as well, and it didn't handle failure by pers->free().
It's weried that the api will return success in this case, and after
this patch, it will require __md_stop() to free the conf.

Can you also fix the level_store()? By checking pers->run() and if it
failed, call pers->free() and return error.

Thanks,
Kuai

> 
>> ---
>>   drivers/md/raid0.c | 21 +++++----------------
>>   1 file changed, 5 insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index c5d4aeb68404c9..81c01347cd24e6 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -365,18 +365,13 @@ static sector_t raid0_size(struct mddev *mddev, 
>> sector_t sectors, int raid_disks
>>       return array_sectors;
>>   }
>> -static void free_conf(struct mddev *mddev, struct r0conf *conf)
>> -{
>> -    kfree(conf->strip_zone);
>> -    kfree(conf->devlist);
>> -    kfree(conf);
>> -}
>> -
>>   static void raid0_free(struct mddev *mddev, void *priv)
>>   {
>>       struct r0conf *conf = priv;
>> -    free_conf(mddev, conf);
>> +    kfree(conf->strip_zone);
>> +    kfree(conf->devlist);
>> +    kfree(conf);
>>   }
>>   static int raid0_set_limits(struct mddev *mddev)
>> @@ -415,7 +410,7 @@ static int raid0_run(struct mddev *mddev)
>>       if (!mddev_is_dm(mddev)) {
>>           ret = raid0_set_limits(mddev);
>>           if (ret)
>> -            goto out_free_conf;
>> +            return ret;
>>       }
>>       /* calculate array device size */
>> @@ -427,13 +422,7 @@ static int raid0_run(struct mddev *mddev)
>>       dump_zones(mddev);
>> -    ret = md_integrity_register(mddev);
>> -    if (ret)
>> -        goto out_free_conf;
>> -    return 0;
>> -out_free_conf:
>> -    free_conf(mddev, conf);
>> -    return ret;
>> +    return md_integrity_register(mddev);
>>   }
>>   /*
>>
> 
> .
> 


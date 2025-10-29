Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB0426B77D;
	Wed, 29 Oct 2025 02:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761705471; cv=none; b=GVGf3pBYJrWsaYBIW5murIUwhVFZGoioQr8OcKB65LikoOHh1cSk5s8NXdG6pgDAaN852+siKK2CiGws8qqGua+dyP9ampVOMPEVICu+3JhNPi0QFm58bD2aab5aZ90lBW/wJu+bwQGM2FYjQqzDHm1L6GxPtoNRFK6R3BKovJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761705471; c=relaxed/simple;
	bh=9YpRAqYF+SB0tzdtMEzMP6O2WGTVhNRPl9H+sSZku/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iqx0CHEMIPkeOEZ1mkzf1OMNQs5c3c8B6dq1S6dYBNauTsgQTNWGI6gYw7AW+yx+mfcQf9WMp5aZN3Czqyi4tlaewvQDgugSSe9MISzV+3TW5I8JXPgxeYNrHFqzupwk5dIMu/UGLpJk8r1WW2i6q6dnMDg3PucyrahXOVkWXOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cxBH96b5PzYQtm5;
	Wed, 29 Oct 2025 10:37:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 5054C1A01A1;
	Wed, 29 Oct 2025 10:37:46 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgCHK0T5fQFpWAjgBw--.19209S3;
	Wed, 29 Oct 2025 10:37:46 +0800 (CST)
Message-ID: <409b20e7-b030-2998-df66-b188b313f8f8@huaweicloud.com>
Date: Wed, 29 Oct 2025 10:37:45 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v7 3/4] md/raid0: Move queue limit setup before r0conf
 initialization
To: yukuai@fnnas.com, corbet@lwn.net, song@kernel.org, hare@suse.de,
 xni@redhat.com
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, linan666@huaweicloud.com, yangerkun@huawei.com,
 yi.zhang@huawei.com
References: <20251027072915.3014463-1-linan122@huawei.com>
 <20251027072915.3014463-4-linan122@huawei.com>
 <effbcb62-9bf7-45ff-ad39-1e3be1e63650@fnnas.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <effbcb62-9bf7-45ff-ad39-1e3be1e63650@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCHK0T5fQFpWAjgBw--.19209S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tr4rJrykJw47uFWUGFyUZFb_yoW8tr1rpr
	4kKa1qgr48KFW3WayDXrWDCa4Fq3W8KrWDKFZxJa48XrnFyryrKFy3WFy5uFyay34fAF18
	Xw15KrZ3urW3trJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPI14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7
	AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUA
	xhLUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/10/28 20:12, Yu Kuai 写道:
> Hi,
> 
> 在 2025/10/27 15:29, linan122@huawei.com 写道:
>> From: Li Nan <linan122@huawei.com>
>>
>> Prepare for making logical blocksize configurable.
>>
>> Move raid0_set_limits() before create_strip_zones(). It is safe as fields
>> modified in create_strip_zones() do not involve mddev configuration, and
>> rdev modifications there are not used in raid0_set_limits().
>>
>> 'blksize' in create_strip_zones() fetches mddev's logical block size. This
>> change has no impact until logical block size becomes configurable.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>    drivers/md/raid0.c | 13 +++++++------
>>    1 file changed, 7 insertions(+), 6 deletions(-)
>>
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index e443e478645a..49477b560cc9 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -68,7 +68,7 @@ static int create_strip_zones(struct mddev *mddev, struct r0conf **private_conf)
>>    	struct strip_zone *zone;
>>    	int cnt;
>>    	struct r0conf *conf = kzalloc(sizeof(*conf), GFP_KERNEL);
>> -	unsigned blksize = 512;
>> +	unsigned int blksize = queue_logical_block_size(mddev->gendisk->queue);
>>    
>>    	*private_conf = ERR_PTR(-ENOMEM);
>>    	if (!conf)
> 
> I think the following setting of blksize can be removed as well.
> 
> blksize = max(blksize, ...)
> 
> Thanks,
> Kuai
> 

Agree. I will remove it later. Thanks for your review.

>> @@ -405,6 +405,12 @@ static int raid0_run(struct mddev *mddev)
>>    	if (md_check_no_bitmap(mddev))
>>    		return -EINVAL;
>>    
>> +	if (!mddev_is_dm(mddev)) {
>> +		ret = raid0_set_limits(mddev);
>> +		if (ret)
>> +			return ret;
>> +	}
>> +
>>    	/* if private is not null, we are here after takeover */
>>    	if (mddev->private == NULL) {
>>    		ret = create_strip_zones(mddev, &conf);
>> @@ -413,11 +419,6 @@ static int raid0_run(struct mddev *mddev)
>>    		mddev->private = conf;
>>    	}
>>    	conf = mddev->private;
>> -	if (!mddev_is_dm(mddev)) {
>> -		ret = raid0_set_limits(mddev);
>> -		if (ret)
>> -			return ret;
>> -	}
>>    
>>    	/* calculate array device size */
>>    	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
> 
> .

-- 
Thanks,
Nan


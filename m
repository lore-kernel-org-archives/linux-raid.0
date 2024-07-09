Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C98641C73;
	Tue,  9 Jul 2024 02:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720493849; cv=none; b=TktUM6ugWS83CkiFYdDypPgGUfeulHTJz0k/wU7yEN6QjPd1Iy8iErS/9rNE8zLyuEKRO1HJRGStQTd3FJ5M7S+c7kIo9DRP6ZKq/J6/b3aIRLQkJvywTDE29v2RC6ThzBrDNYN4hxlRY6dUkfG/Ysv49yikn9TpSFP2ZKDYCAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720493849; c=relaxed/simple;
	bh=f8tf64RYLXczMC87XQUo/kloKRfhEw9Bo//uVd9bMow=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=WRt6Zp4FOVTohw6HhXzQI3BpUjX/1B/Lo3LMcqH00QjHFHvsxw2YdbNs/TEmtWFLPDfGwDSM812gReHxCA/po1bS0M3uqCvW5JcNdB7jTjw2RhZ9wlVjZTN02IeS70ZfokRu95RBFAB99AGv6VWzHHyRS+t3gxR8iseNxiSBA1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WJ5Hp1GrDz4f3kvv;
	Tue,  9 Jul 2024 10:57:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id EDAF81A0B14;
	Tue,  9 Jul 2024 10:57:22 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP2 (Coremail) with SMTP id Syh0CgBn0YYRp4xmfplTBg--.35701S3;
	Tue, 09 Jul 2024 10:57:21 +0800 (CST)
Subject: Re: [REGRESSION] Cannot start degraded RAID1 array with device with
 write-mostly flag
To: =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: regressions@lists.linux.dev, Song Liu <song@kernel.org>,
 Paul Luse <paul.e.luse@linux.intel.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <20240706143038.7253-1-mat.jonczyk@o2.pl>
 <a703ec45-6cd5-4970-db22-fb9e7469332a@huawei.com>
 <e6c48984-01ee-411f-a013-7e5068641363@o2.pl>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <349e4894-b6ea-6bc4-b040-4a816b6960ab@huaweicloud.com>
Date: Tue, 9 Jul 2024 10:57:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <e6c48984-01ee-411f-a013-7e5068641363@o2.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBn0YYRp4xmfplTBg--.35701S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw4UCw43Wr4rtw48Kw1DAwb_yoW8Cr1kpw
	1kJFWrZrWUGr18Aw1Utr18Wryrtw1UGa4UXr18X3W8XrnFqFyqqr1UXryqgr1DJr4rGw17
	X3WUJr17uF1jvFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
	xK8VAvwI8IcIk0rVW3JVWrJr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY
	1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IUbPEf5UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/07/09 4:09, Mateusz Jończyk 写道:
> W dniu 8.07.2024 o 03:54, Yu Kuai pisze:
>> Hi,
>>
>> 在 2024/07/06 22:30, Mateusz Jończyk 写道:
>>> Subject: [RFC PATCH] md/raid1: fill in max_sectors
>>>
>>>
>>>
>>> Not yet fully tested or carefully investigated.
>>>
>>>
>>>
>>> Signed-off-by: Mateusz Jo艅czyk<mat.jonczyk@o2.pl>
>>>
>>>
>>>
>>> ---
>>>
>>>    drivers/md/raid1.c | 1 +
>>>
>>>    1 file changed, 1 insertion(+)
>>>
>>>
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>>
>>> index 7b8a71ca66dd..82f70a4ce6ed 100644
>>>
>>> --- a/drivers/md/raid1.c
>>>
>>> +++ b/drivers/md/raid1.c
>>>
>>> @@ -680,6 +680,7 @@ static int choose_slow_rdev(struct r1conf *conf, struct r1bio *r1_bio,
>>>
>>>            len = r1_bio->sectors;
>>>
>>>            read_len = raid1_check_read_range(rdev, this_sector, &len);
>>>
>>>            if (read_len == r1_bio->sectors) {
>>>
>>> +            *max_sectors = read_len;
>>>
>>>                update_read_sectors(conf, disk, this_sector, read_len);
>>>
>>>                return disk;
>>>
>>>            }
>>
>> This looks correct, can you give it a test and cook a patch?
>>
>> Thanks,
>> Kuai
> Hello,
> 
> Yes, I'm working on it. Patch description is nearly done.
> Kernel with this patch works well with normal usage and
> fsstress, except when modifying the array, as I have written
> in my previous email. Will test some more.

Please run mdadm tests at least. And we may need to add a new test.

https://kernel.googlesource.com/pub/scm/utils/mdadm/mdadm.git

./test --dev=loop

Thanks,
Kuai

> 
> I'm feeling nervous working on such sensitive code as md, though.
> I'm not an experienced kernel dev.
> 
> Greetings,
> 
> Mateusz
> 
> .
> 


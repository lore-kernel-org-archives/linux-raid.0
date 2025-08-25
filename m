Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047D027AC34;
	Mon, 25 Aug 2025 08:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756111400; cv=none; b=eypwwmD5z/JeP0uDZMrXT1H1Zs8ZdAIU8FnykGA1nWeYLQ2KtyAwATjrTYoys5xpeYTYmizDHpDE2st2MbZXljOm0zgMfH5g+pDzjeoTnoOYCTf/cjaDb3Ki0sEYIQbW/goCSABt8tfpKiQP8gokfrHxcp0uoJZ7ZOUHcqfA9go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756111400; c=relaxed/simple;
	bh=/HmWPUJ/QVxY3311v4PtW5t2r2BCqnsZtbdJnqGkUI8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XUSz4DJMoVRonxK0lMQYr55Y2YBmCi1T3VNRLVCaOEv9OFJ639sh+uzUeWwJ+7lrJHfVylRz+6Tc1TXzXKbIE54L3RRturM4Ta06Nt1sG/AMLx70T+G3SKfHjZEaAV4Hnvfa1NXO45zXz7PPsw23R1IcMEfiBvbo/ZFkIZOXZnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4c9PSz4SkjzKHMx7;
	Mon, 25 Aug 2025 16:43:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 335931A0EFD;
	Mon, 25 Aug 2025 16:43:15 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgCX4o4hIqxo0ZfsAA--.61435S3;
	Mon, 25 Aug 2025 16:43:14 +0800 (CST)
Message-ID: <3e26e8a3-e0c1-cd40-af79-06424fb2d54b@huaweicloud.com>
Date: Mon, 25 Aug 2025 16:43:13 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v3 1/2] md: prevent adding disks with larger
 logical_block_size to active arrays
To: Paul Menzel <pmenzel@molgen.mpg.de>, Li Nan <linan666@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, martin.petersen@oracle.com,
 bvanassche@acm.org, hch@infradead.org, filipe.c.maia@gmail.com,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250825075924.2696723-1-linan666@huaweicloud.com>
 <20250825075924.2696723-2-linan666@huaweicloud.com>
 <76d66b0b-afaa-4835-9d55-9e61be83ce01@molgen.mpg.de>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <76d66b0b-afaa-4835-9d55-9e61be83ce01@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCX4o4hIqxo0ZfsAA--.61435S3
X-Coremail-Antispam: 1UD129KBjvJXoW7uw45uF1ktryxCF45Ww48Zwb_yoW8uF1Dpa
	n7X3W5G3y7Ar10va47JF1rAFy3Xr1kGayDtry7XFWUZrZxAr12gF4xWF90gr1jqws7Jr1U
	X3WUKrZ7uF1fJF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPI14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7
	AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQ
	vtAUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/8/25 16:10, Paul Menzel 写道:
> Dear Li,
> 
> 
> Thank you for your patch.
> 
> Am 25.08.25 um 09:59 schrieb linan666@huaweicloud.com:
>> From: Li Nan <linan122@huawei.com>
>>
>> When adding a disk to a md array, avoid updating the array's
>> logical_block_size to match the new disk. This prevents accidental
>> partition table loss that renders the array unusable.
> 
> Do you have a reproducer to test this?

Please try the following script:

```
#sd[de] lbs is 512, sdf is 4096
mdadm -CR /dev/md0 -l1 -n2 /dev/sd[de] --assume-clean

#512
cat /sys/block/md0/queue/logical_block_size

#create md0p1
printf "g\nn\n\n\n\nw\n" | fdisk /dev/md0
lsblk | grep md0

mdadm --fail /dev/md0 /dev/sdd
mdadm --add /dev/md0 /dev/sdf

#4096
cat /sys/block/md0/queue/logical_block_size

#partition loss
partprobe /dev/md0
lsblk | grep md0
```

> 
>> The later patch will introduce a way to configure the array's
>> logical_block_size.
>>
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
>> ---
>>   drivers/md/md.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index cea8fc96abd3..206434591b97 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -6064,6 +6064,13 @@ int mddev_stack_new_rdev(struct mddev *mddev, 
>> struct md_rdev *rdev)
>>       if (mddev_is_dm(mddev))
>>           return 0;
>> +    if (queue_logical_block_size(rdev->bdev->bd_disk->queue) >
>> +        queue_logical_block_size(mddev->gendisk->queue)) {
>> +        pr_err("%s: incompatible logical_block_size, can not add\n",
>> +               mdname(mddev));
>> +        return -EINVAL;
>> +    }
>> +
>>       lim = queue_limits_start_update(mddev->gendisk->queue);
>>       queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
>>                   mddev->gendisk->disk_name);
> 
> 
> Kind regards,
> 
> Paul
> 
> 
> .

-- 
Thanks,
Nan


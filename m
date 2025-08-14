Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D637163;
	Thu, 14 Aug 2025 01:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755134697; cv=none; b=jrElJ2yHHG0yjVngIbc4V368X+OrgKAUQUuPz476HXE2PNRCaQHLirOIZaXIMZZDRybwfUb5BaSiymyhyppWkwZsBAaQKfhDD29QlAhIU/cj5IfM0oxKg3qN38kgKUMCSKG5hLGOGvI3MWRv06ubw3gwQ2ZfsHmjv2x8iaOZvRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755134697; c=relaxed/simple;
	bh=z6n8Pa627onIbQgas4Z+6P4BRJXmQKBMzZgXaZM/Tn8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EH+GoQ0j/9Sa05932q2n3lZilc6M33a+tARCIhEQRJYDfpd4hPrP0YuP+YjYszsMyZ/odxkpZu1JKZhBPXRHfk+cS9B1ZN3dbhcIT9zgZa7W/VaDYSNZ0cKAt1XqFDyq6JHhgqD5ZoglAHgjLyjRFbF1yJpwTMQJOT46g/5wPpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c2SGF5wQVzYQtwp;
	Thu, 14 Aug 2025 09:24:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 6DF031A018D;
	Thu, 14 Aug 2025 09:24:52 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP4 (Coremail) with SMTP id gCh0CgDHjxDiOp1oAvNsDg--.31485S3;
	Thu, 14 Aug 2025 09:24:52 +0800 (CST)
Message-ID: <a0026dc7-03a2-4281-881f-abb2421a9ede@huaweicloud.com>
Date: Thu, 14 Aug 2025 09:24:50 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] md: add helper rdev_needs_recovery()
To: Yu Kuai <yukuai1@huaweicloud.com>, song@kernel.org, linan122@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, houtao1@huawei.com,
 zhengqixing@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250812021738.3722569-1-zhengqixing@huaweicloud.com>
 <20250812021738.3722569-2-zhengqixing@huaweicloud.com>
 <258db10c-f80f-5975-d879-ec0d16f1db6e@huaweicloud.com>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <258db10c-f80f-5975-d879-ec0d16f1db6e@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHjxDiOp1oAvNsDg--.31485S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur4DAr13AFW5Ar1xtry7Jrb_yoW5tFW3pF
	1kJFy5JryUur18Gr1UJr1UJFy5Jr1UJw4UJr17J3WUJry5Jr1jqF1UXryYgr1UJF48Ar15
	Jr1UXr4xZr1UGr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
	v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
	1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
	AIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

Hi,


在 2025/8/14 8:52, Yu Kuai 写道:
> Hi,
>
> 在 2025/08/12 10:17, Zheng Qixing 写道:
>> From: Zheng Qixing <zhengqixing@huawei.com>
>>
>> Add a helper for checking if an rdev needs recovery.
>>
>> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
>> ---
>>   drivers/md/md.c | 20 ++++++++++++--------
>>   1 file changed, 12 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index ac85ec73a409..4ea956a80343 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -4835,6 +4835,16 @@ metadata_store(struct mddev *mddev, const char 
>> *buf, size_t len)
>>   static struct md_sysfs_entry md_metadata =
>>   __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, 
>> metadata_store);
>>   +static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t 
>> sectors)
>> +{
>> +    if (!test_bit(Journal, &rdev->flags) &&
>> +        !test_bit(Faulty, &rdev->flags) &&
>> +        !test_bit(In_sync, &rdev->flags) &&
>> +        rdev->recovery_offset < sectors)
>> +        return true;
>> +    return false;
> return directly:
>
> return !test_bit(Journal, &rdev->flags) &&
>     !test_bit(Faulty, &rdev->flags) &&
>     !test_bit(In_sync, &rdev->flags) &&
>     rdev->recovery_offset < sectors);
>
Okay.


Thanks,

Qixing


> Otherwise, feel free to add
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
>
> Kuai
>
>> +}
>> +
>>   enum sync_action md_sync_action(struct mddev *mddev)
>>   {
>>       unsigned long recovery = mddev->recovery;
>> @@ -8969,10 +8979,7 @@ static sector_t md_sync_position(struct mddev 
>> *mddev, enum sync_action action)
>>           rcu_read_lock();
>>           rdev_for_each_rcu(rdev, mddev)
>>               if (rdev->raid_disk >= 0 &&
>> -                !test_bit(Journal, &rdev->flags) &&
>> -                !test_bit(Faulty, &rdev->flags) &&
>> -                !test_bit(In_sync, &rdev->flags) &&
>> -                rdev->recovery_offset < start)
>> +                rdev_needs_recovery(rdev, start))
>>                   start = rdev->recovery_offset;
>>           rcu_read_unlock();
>>   @@ -9333,10 +9340,7 @@ void md_do_sync(struct md_thread *thread)
>>                   rdev_for_each_rcu(rdev, mddev)
>>                       if (rdev->raid_disk >= 0 &&
>>                           mddev->delta_disks >= 0 &&
>> -                        !test_bit(Journal, &rdev->flags) &&
>> -                        !test_bit(Faulty, &rdev->flags) &&
>> -                        !test_bit(In_sync, &rdev->flags) &&
>> -                        rdev->recovery_offset < mddev->curr_resync)
>> +                        rdev_needs_recovery(rdev, mddev->curr_resync))
>>                           rdev->recovery_offset = mddev->curr_resync;
>>                   rcu_read_unlock();
>>               }
>>


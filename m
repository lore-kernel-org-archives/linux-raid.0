Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CC02F0C66;
	Thu, 14 Aug 2025 11:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755169800; cv=none; b=aCk8/M2vgGNfQtBlq2nizvrRTX+gpVxeoYvkeZXNc5rhm3emA6Lzm11Iy+kr68ayUINbadO4nee4yuZDf9dx8s4N6HRqNlqOfA3QiI48FT3Njh+1GKhA7pbyTaSZwfWICj+cAMJqUdf8mhekGTCKN/KoyreVb9rgdjrd41dPg/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755169800; c=relaxed/simple;
	bh=AgKpJR63+jLRsNWIgdjfzyb983CVreNGrFiByRt6oxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QzdF5jBbUT/6F9Cj1+UZizxMZfSFR3581s47CQFt7hgosw34RNeKYfQaq9g2n2L32ZcTkGT+riaX5MeZgEOk6y5eJAS/Ed0TkZLMqF3wSWfiJMWhhFq2VB287yIk4qCU9wiVe29lC9KtyYXBJF3+k6poMZ3tJzxrQt/CrwYya7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4c2jFF14hYzYQvHm;
	Thu, 14 Aug 2025 19:09:53 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id BBD4A1A1648;
	Thu, 14 Aug 2025 19:09:51 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP4 (Coremail) with SMTP id gCh0CgC3MxT9w51oE2ebDg--.19609S3;
	Thu, 14 Aug 2025 19:09:51 +0800 (CST)
Message-ID: <dc6e25cd-17b6-4a32-8ef9-162069646a25@huaweicloud.com>
Date: Thu, 14 Aug 2025 19:09:49 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] md: add helper rdev_needs_recovery()
To: Li Nan <linan666@huaweicloud.com>, song@kernel.org, yukuai3@huawei.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 pmenzel@molgen.mpg.de, yi.zhang@huawei.com, yangerkun@huawei.com,
 houtao1@huawei.com, zhengqixing@huawei.com
References: <20250814015721.3764005-1-zhengqixing@huaweicloud.com>
 <20250814015721.3764005-2-zhengqixing@huaweicloud.com>
 <0e94be00-769c-dab0-a14c-a49c137e054c@huaweicloud.com>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <0e94be00-769c-dab0-a14c-a49c137e054c@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3MxT9w51oE2ebDg--.19609S3
X-Coremail-Antispam: 1UD129KBjvJXoWxur4fAFWfZw1DKryxtr43Wrg_yoW5uFWxpF
	1kJFyUJryUCr18Gr1UJr1UJFyUJr1UJw4UJry7J3WUJryUJr1jqr1UXryYgr1UJr48Ar1U
	Jr1UXr4UZr1UGr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvE14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWI
	evJa73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

Hi,


在 2025/8/14 15:09, Li Nan 写道:
>
>
> 在 2025/8/14 9:57, Zheng Qixing 写道:
>> From: Zheng Qixing <zhengqixing@huawei.com>
>>
>> Add a helper for checking if an rdev needs recovery.
>>
>> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
>> Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
>> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md.c | 18 ++++++++++--------
>>   1 file changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index ac85ec73a409..4663e172864e 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -4835,6 +4835,14 @@ metadata_store(struct mddev *mddev, const char 
>> *buf, size_t len)
>>   static struct md_sysfs_entry md_metadata =
>>   __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, 
>> metadata_store);
>>   +static bool rdev_needs_recovery(struct md_rdev *rdev, sector_t 
>> sectors)
>> +{
>> +    return !test_bit(Journal, &rdev->flags) &&
>> +           !test_bit(Faulty, &rdev->flags) &&
>> +           !test_bit(In_sync, &rdev->flags) &&
>> +           rdev->recovery_offset < sectors;
>> +}
>> +
>
> Every caller is already checking 'rdev->raid_disk >= 0'. Should we 
> move it
> into rdev_needs_recovery()?
>

Good point, thanks.


Qixing


>>   enum sync_action md_sync_action(struct mddev *mddev)
>>   {
>>       unsigned long recovery = mddev->recovery;
>> @@ -8969,10 +8977,7 @@ static sector_t md_sync_position(struct mddev 
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
>>   @@ -9333,10 +9338,7 @@ void md_do_sync(struct md_thread *thread)
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
>


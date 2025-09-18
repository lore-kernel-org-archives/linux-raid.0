Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745C62253A1;
	Thu, 18 Sep 2025 08:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758184011; cv=none; b=jZAh2D/BUksA2ihsAvUZW/aizE/94qQYXB8AdiHuUsCAsn34iL1QuvmpwLYWOHiH5HsTI38W7n2k7aLezFh3TtxyxXppOiNZpyxXc5kGPtGCYS+KWTLVQfhNdD5VPtwbPrEJmBrmm88dfOdWIlZLihalLVQ5CBzXdp3OwuhVno4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758184011; c=relaxed/simple;
	bh=jgxXsUVeX1P4B4g2XsORYY6Jl9Iyca8HlIGfYT9R2/E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S8ex31vGRSC8/eiSHWGu84glWqaIYWRbVyMNI4JyHWh0WbznqAq/V3LSv0qa9900Y0x/YVqk+9NRb551IO80oOAmNDvZdR7FIFDC0lkGk9OmyB9VIpM4UJXDcKh16biC8VaQLQCaMfbaOXuCVSizACRwMT1CkZpiWe/p/vZ90hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cS7yl6RM7zKHN6j;
	Thu, 18 Sep 2025 16:26:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id ADA8F1A1A85;
	Thu, 18 Sep 2025 16:26:40 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgD3QY4+wstoaGihCw--.7655S3;
	Thu, 18 Sep 2025 16:26:40 +0800 (CST)
Message-ID: <9281d56a-c4ef-9a2b-e06b-12b00e9dccba@huaweicloud.com>
Date: Thu, 18 Sep 2025 16:26:38 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] md/raid1: skip recovery of already synced areas
To: John Stoffel <john@stoffel.org>, linan666@huaweicloud.com
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250910082544.271923-1-linan666@huaweicloud.com>
 <26827.5265.32245.268569@quad.stoffel.home>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <26827.5265.32245.268569@quad.stoffel.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3QY4+wstoaGihCw--.7655S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJF4DWFy8Zr4fAF47Ww45Wrg_yoW5Xw1UpF
	43Ja4akryDGF13Ga4kXryUGa4Fya4xGrWfGr13W347W3s8CF90gFW0gFyYgFyDAF43Xr4j
	qw4kZ3y3uF1YqaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBj14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1lnxkEFVAIw20F6cxK64vIFxWle2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xv
	F2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r
	4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v
	4I1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwI
	xGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480
	Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7
	IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k2
	6cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUvg4fUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/18 4:05, John Stoffel 写道:
>>>>>> "linan666" == linan666  <linan666@huaweicloud.com> writes:
> 
>> From: Li Nan <linan122@huawei.com>
>> When a new disk is added during running recovery, the kernel may
>> restart recovery from the beginning of the device and submit write
>> io to ranges that have already been synchronized.
> 
> Isn't it beter to be safe than sorry?  If the resync fails for some
> reason, how can we be sure the devices really are in sync if you don't
> force the re-write?
> 
>> Reproduce:
>>    mdadm -CR /dev/md0 -l1 -n3 /dev/sda missing missing
>>    mdadm --add /dev/md0 /dev/sdb
>>    sleep 10
>>    cat /proc/mdstat	# partially synchronized
>>    mdadm --add /dev/md0 /dev/sdc
>>    cat /proc/mdstat	# start from 0
>>    iostat 1 sdb sdc	# sdb has io, too
> 
>> If 'rdev->recovery_offset' is ahead of the current recovery sector,
>> read from that device instead of issuing a write. It prevents
>> unnecessary writes while still preserving the chance to back up data
>> if it is the last copy.
> 
> 
> Are you saying that sdb here can continute writing from block N, but
> that your change will only force sdc to start writing from block 0?
> Your description of the problem isn't really clear.
> 
Thanks for your review. You're right, I will describe it more accurately
in the next patch.

> I think it's because you're using the word device for both the MD
> device itself, as well as the underlying device(s) or component(s) of
> the MD device.
> 
> 
> 
>> Signed-off-by: Li Nan <linan122@huawei.com>
>> ---
>>   drivers/md/raid1.c | 6 +++++-
>>   1 file changed, 5 insertions(+), 1 deletion(-)
> 
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 3e422854cafb..ac5a9b73157a 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2894,7 +2894,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>>   		    test_bit(Faulty, &rdev->flags)) {
>>   			if (i < conf->raid_disks)
>>   				still_degraded = true;
>> -		} else if (!test_bit(In_sync, &rdev->flags)) {
>> +		} else if (!test_bit(In_sync, &rdev->flags) &&
>> +			   rdev->recovery_offset <= sector_nr) {
> bio-> bi_opf = REQ_OP_WRITE;
> bio-> bi_end_io = end_sync_write;

As Yu Kuai mentioned, I will refactor this part of the code later.
This patch will be dropped.

>>   			write_targets ++;
>> @@ -2903,6 +2904,9 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>>   			sector_t first_bad = MaxSector;
>>   			sector_t bad_sectors;
>   
>> +			if (!test_bit(In_sync, &rdev->flags))
>> +				good_sectors = min(rdev->recovery_offset - sector_nr,
>> +						   (u64)good_sectors);
>>   			if (is_badblock(rdev, sector_nr, good_sectors,
>>   					&first_bad, &bad_sectors)) {
>>   				if (first_bad > sector_nr)
>> -- 
>> 2.39.2
> 
> 
> 
> .

-- 
Thanks,
Nan


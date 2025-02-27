Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D12F92F30;
	Thu, 27 Feb 2025 02:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740624547; cv=none; b=CIV10ZGTECwCOMSn6PZK2SNaz6qWqbdhYoQzhiifCoz/3iPr4EpNdmNM2uyO+LxqltX0Xbwn8ZtinEqnu8/4xXRQiiZlfLJ1fhi4Sq5oWU9DOb4V7PTB7xJEIC7ch4ocSrag3MDBaVO3JwgCRW0VYIdWSAB4Kp05MWL8KkZ0DJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740624547; c=relaxed/simple;
	bh=A6r9CHT/7Kio6QFWKWHV6XcInFVYuOYKb+4mUQuerv4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=CPGUvcOVXfsbna1qbQLk1VvIu/WqqJ7tR+0d9KpxYrh30Ukme0doC7Bbvk1G8cqYQfAZpTjIr+7THoFPEUiyqNYkLrZyyIjJWhURHm18lrUolIGZJHyMMCOgcFsGHyORBX9ngvlRltkUQQJPF6/AIsKogtgauWo4wvIxiNFcNjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Z3G4P5W8Jz4f3kvl;
	Thu, 27 Feb 2025 10:48:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1508F1A0A22;
	Thu, 27 Feb 2025 10:49:01 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB32l6b0r9nsiIMFA--.27217S3;
	Thu, 27 Feb 2025 10:49:00 +0800 (CST)
Subject: Re: [PATCH] md/raid1,raid10: don't ignore IO flags
To: Paul Menzel <pmenzel@molgen.mpg.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250226063011.968761-1-yukuai1@huaweicloud.com>
 <5697c1c7-eb46-41e6-b0cb-31f120b416de@molgen.mpg.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <e7ba770d-fb9f-a4d8-c1dc-24765dfe55bd@huaweicloud.com>
Date: Thu, 27 Feb 2025 10:48:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <5697c1c7-eb46-41e6-b0cb-31f120b416de@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB32l6b0r9nsiIMFA--.27217S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GF4fuF48GFWkAr1kAFykAFb_yoW7ZF17pa
	1ktFW8JrW5Cw1kZr1UJF4Uu3y5tr4DtayDKr18G3W3Jr42yr1qqF4UXrW0gFn8ZF4rGr1U
	Xr1UJrsrZr4aqFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/02/26 16:29, Paul Menzel 写道:
> Dear Kuai,
> 
> 
> Thank you for your patch.
> 
> Am 26.02.25 um 07:30 schrieb Yu Kuai:
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> If blk-wbt is enabled by default, it's found that raid write performance
>> is quite bad because all IO are throttled by wbt of underlying disks,
>> due to flag REQ_IDLE is ignored. And turns out this behaviour exist since
>> blk-wbt is introduced.
>>
>> Other than REQ_IDLE, other flags should not be ignored as well, for
>> example REQ_META can be set for filesystems, clear it can cause priority
> 
> clear*ing*
> 
>> reverse problems; And REQ_NOWAIT should not be cleared as well, because
> 
> … problems. REQ…NOWAIT …
> 
>> io will wait instead of fail directly in underlying disks.
> 
> fail*ing*
> 
>> Fix those problems by keeping IO flags from master bio.
> 
> Add a Fixes: tag?

I didn't find an appropriate tag yet, raid is invented like this, before
v2.x. And later wbt and other IO falgs are introduced.
> 
> Do you have a test case, how to reproduce the issue?

Test case is simple, just enable wbt for underlying disks, and then
issue direct IO, then check if IO are throttled by wbt.

Thanks,
Kuai

> 
> 
> Kind regards,
> 
> Paul
> 
> 
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/raid1.c  | 5 -----
>>   drivers/md/raid10.c | 8 --------
>>   2 files changed, 13 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index a87eb9a3b016..347de0e36d59 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1316,8 +1316,6 @@ static void raid1_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>       struct r1conf *conf = mddev->private;
>>       struct raid1_info *mirror;
>>       struct bio *read_bio;
>> -    const enum req_op op = bio_op(bio);
>> -    const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
>>       int max_sectors;
>>       int rdisk, error;
>>       bool r1bio_existed = !!r1_bio;
>> @@ -1405,7 +1403,6 @@ static void raid1_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>       read_bio->bi_iter.bi_sector = r1_bio->sector +
>>           mirror->rdev->data_offset;
>>       read_bio->bi_end_io = raid1_end_read_request;
>> -    read_bio->bi_opf = op | do_sync;
>>       if (test_bit(FailFast, &mirror->rdev->flags) &&
>>           test_bit(R1BIO_FailFast, &r1_bio->state))
>>               read_bio->bi_opf |= MD_FAILFAST;
>> @@ -1654,8 +1651,6 @@ static void raid1_write_request(struct mddev 
>> *mddev, struct bio *bio,
>>           mbio->bi_iter.bi_sector    = (r1_bio->sector + 
>> rdev->data_offset);
>>           mbio->bi_end_io    = raid1_end_write_request;
>> -        mbio->bi_opf = bio_op(bio) |
>> -            (bio->bi_opf & (REQ_SYNC | REQ_FUA | REQ_ATOMIC));
>>           if (test_bit(FailFast, &rdev->flags) &&
>>               !test_bit(WriteMostly, &rdev->flags) &&
>>               conf->raid_disks - mddev->degraded > 1)
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index efe93b979167..e294ba00ea0e 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1146,8 +1146,6 @@ static void raid10_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>   {
>>       struct r10conf *conf = mddev->private;
>>       struct bio *read_bio;
>> -    const enum req_op op = bio_op(bio);
>> -    const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
>>       int max_sectors;
>>       struct md_rdev *rdev;
>>       char b[BDEVNAME_SIZE];
>> @@ -1228,7 +1226,6 @@ static void raid10_read_request(struct mddev 
>> *mddev, struct bio *bio,
>>       read_bio->bi_iter.bi_sector = r10_bio->devs[slot].addr +
>>           choose_data_offset(r10_bio, rdev);
>>       read_bio->bi_end_io = raid10_end_read_request;
>> -    read_bio->bi_opf = op | do_sync;
>>       if (test_bit(FailFast, &rdev->flags) &&
>>           test_bit(R10BIO_FailFast, &r10_bio->state))
>>               read_bio->bi_opf |= MD_FAILFAST;
>> @@ -1247,10 +1244,6 @@ static void raid10_write_one_disk(struct mddev 
>> *mddev, struct r10bio *r10_bio,
>>                     struct bio *bio, bool replacement,
>>                     int n_copy)
>>   {
>> -    const enum req_op op = bio_op(bio);
>> -    const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
>> -    const blk_opf_t do_fua = bio->bi_opf & REQ_FUA;
>> -    const blk_opf_t do_atomic = bio->bi_opf & REQ_ATOMIC;
>>       unsigned long flags;
>>       struct r10conf *conf = mddev->private;
>>       struct md_rdev *rdev;
>> @@ -1269,7 +1262,6 @@ static void raid10_write_one_disk(struct mddev 
>> *mddev, struct r10bio *r10_bio,
>>       mbio->bi_iter.bi_sector    = (r10_bio->devs[n_copy].addr +
>>                      choose_data_offset(r10_bio, rdev));
>>       mbio->bi_end_io    = raid10_end_write_request;
>> -    mbio->bi_opf = op | do_sync | do_fua | do_atomic;
>>       if (!replacement && test_bit(FailFast,
>>                        &conf->mirrors[devnum].rdev->flags)
>>                && enough(conf, devnum))
> 
> .
> 


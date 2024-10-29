Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7BE5188CDC;
	Tue, 29 Oct 2024 12:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730203835; cv=none; b=akkHLuk1OEv13iH511NKRttwcK/Z9TXw+xLU2j5Zy09CN8Qxnq6QP0WrnH0B+Do+KnRrEdNJ++/F59u4s2UurR1lJNoJfad5tRJP5qe4FqglhHhiXRA5S2+24rlFkFoY/xk/Ibheh4lGyQpgyx5rwqd54hpLPoQC+98rPCESSmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730203835; c=relaxed/simple;
	bh=JWN2yKRVAsTYbOiMY1fo1Pn+gqGzZJiTgrvBje3uEF8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=DeHK+M8wOSx0d+wdBQHE03vtDV5v5PxGHKq93rGEMANqeePwbaZSulG3wLpY92ZD3esS4pMJZVFaSaHYtGy56lEHzrMj/fm8Phn6FQQURELvcld4VDIeCopwGceT2dPO8oWT0Lgfs23PNv0OfW6XVvz4dT1NfXee+/4pVZC/FZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xd8G963TTz4f3nTf;
	Tue, 29 Oct 2024 20:10:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 543C11A0359;
	Tue, 29 Oct 2024 20:10:28 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCngYWy0CBn3_0aAQ--.51388S3;
	Tue, 29 Oct 2024 20:10:28 +0800 (CST)
Subject: Re: [PATCH v2 7/7] md/raid10: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 axboe@kernel.dk, song@kernel.org, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
 Johannes.Thumshirn@wdc.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-8-john.g.garry@oracle.com>
 <eeb9ca32-6862-6a07-bc51-7bd05430f018@huaweicloud.com>
 <f0ecb0b1-7963-42ed-a26d-9b155884abb6@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <93532589-13d9-2b48-4a6d-7f2a29e1ecf5@huaweicloud.com>
Date: Tue, 29 Oct 2024 20:10:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <f0ecb0b1-7963-42ed-a26d-9b155884abb6@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCngYWy0CBn3_0aAQ--.51388S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GF4kZFyDWr1UKr45Kw4DArb_yoW7Cw48pr
	4ktFWUArW5Jrn5Jr12qF4UJFyFyr18Ja1DJr18J3WUJr47tryqgF4UXr1qgr1UCr48Gr1U
	Xr15WrsxurnrJFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/10/29 20:05, John Garry 写道:
> On 29/10/2024 11:55, Yu Kuai wrote:
>> Hi,
>>
>> 在 2024/10/28 23:27, John Garry 写道:
>>> Add proper bio_split() error handling. For any error, call
>>> raid_end_bio_io() and return. Except for discard, where we end the bio
>>> directly.
>>>
>>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>>> ---
>>>   drivers/md/raid10.c | 47 ++++++++++++++++++++++++++++++++++++++++++++-
>>>   1 file changed, 46 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>> index f3bf1116794a..9c56b27b754a 100644
>>> --- a/drivers/md/raid10.c
>>> +++ b/drivers/md/raid10.c
>>> @@ -1159,6 +1159,7 @@ static void raid10_read_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>       int slot = r10_bio->read_slot;
>>>       struct md_rdev *err_rdev = NULL;
>>>       gfp_t gfp = GFP_NOIO;
>>> +    int error;
>>>       if (slot >= 0 && r10_bio->devs[slot].rdev) {
>>>           /*
>>> @@ -1206,6 +1207,10 @@ static void raid10_read_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>       if (max_sectors < bio_sectors(bio)) {
>>>           struct bio *split = bio_split(bio, max_sectors,
>>>                             gfp, &conf->bio_split);
>>> +        if (IS_ERR(split)) {
>>> +            error = PTR_ERR(split);
>>> +            goto err_handle;
>>> +        }
>>>           bio_chain(split, bio);
>>>           allow_barrier(conf);
>>>           submit_bio_noacct(bio);
>>> @@ -1236,6 +1241,12 @@ static void raid10_read_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>       mddev_trace_remap(mddev, read_bio, r10_bio->sector);
>>>       submit_bio_noacct(read_bio);
>>>       return;
>>> +err_handle:
>>> +    atomic_dec(&rdev->nr_pending);
>>
>> I just realized that for the raid1 patch, this is missed. read_balance()
>> from raid1 will increase nr_pending as well. :(
> 
> hmmm... I have the rdev_dec_pending() call for raid1 at the error label, 
> which does the appropriate nr_pending dec, right? Or not?

Looks not, I'll reply here. :)
> 
>>
>>> +
>>> +    bio->bi_status = errno_to_blk_status(error);
>>> +    set_bit(R10BIO_Uptodate, &r10_bio->state);
>>> +    raid_end_bio_io(r10_bio);
>>>   }
>>>   static void raid10_write_one_disk(struct mddev *mddev, struct 
>>> r10bio *r10_bio,
>>> @@ -1347,9 +1358,10 @@ static void raid10_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>                    struct r10bio *r10_bio)
>>>   {
>>>       struct r10conf *conf = mddev->private;
>>> -    int i;
>>> +    int i, k;
>>>       sector_t sectors;
>>>       int max_sectors;
>>> +    int error;
>>>       if ((mddev_is_clustered(mddev) &&
>>>            md_cluster_ops->area_resyncing(mddev, WRITE,
>>> @@ -1482,6 +1494,10 @@ static void raid10_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>       if (r10_bio->sectors < bio_sectors(bio)) {
>>>           struct bio *split = bio_split(bio, r10_bio->sectors,
>>>                             GFP_NOIO, &conf->bio_split);
>>> +        if (IS_ERR(split)) {
>>> +            error = PTR_ERR(split);
>>> +            goto err_handle;
>>> +        }
>>>           bio_chain(split, bio);
>>>           allow_barrier(conf);
>>>           submit_bio_noacct(bio);
>>> @@ -1503,6 +1519,25 @@ static void raid10_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>               raid10_write_one_disk(mddev, r10_bio, bio, true, i);
>>>       }
>>>       one_write_done(r10_bio);
>>> +    return;
>>> +err_handle:
>>> +    for (k = 0;  k < i; k++) {
>>> +        struct md_rdev *rdev, *rrdev;
>>> +
>>> +        rdev = conf->mirrors[k].rdev;
>>> +        rrdev = conf->mirrors[k].replacement;
>>
>> This looks wrong, r10_bio->devs[k].devnum should be used to deference
>> rdev from mirrors.
> 
> ok
> 
>>> +
>>> +        if (rdev)
>>> +            rdev_dec_pending(conf->mirrors[k].rdev, mddev);
>>> +        if (rrdev)
>>> +            rdev_dec_pending(conf->mirrors[k].rdev, mddev);
>>
>> This is not correct for now, for the case that rdev is all BB in the
>> write range, continue will be reached in the loop and rrdev is skipped(
>> This doesn't look correct to skip rrdev). However, I'll suggest to use:
>>
>> int d = r10_bio->devs[k].devnum;
>> if (r10_bio->devs[k].bio == NULL)
> 
> eh, should this be:
> if (r10_bio->devs[k].bio != NULL)

Of course, sorry about the typo.

Thanks,
Kuai

> 
>>      rdev_dec_pending(conf->mirrors[d].rdev);
>> if (r10_bio->devs[k].repl_bio == NULL)
>>      rdev_dec_pending(conf->mirrors[d].replacement);
>>
> 
> 
> 
>>
>>> +        r10_bio->devs[k].bio = NULL;
>>> +        r10_bio->devs[k].repl_bio = NULL;
>>> +    }
>>> +
>>> +    bio->bi_status = errno_to_blk_status(error);
>>> +    set_bit(R10BIO_Uptodate, &r10_bio->state);
>>> +    raid_end_bio_io(r10_bio);
> 
> Thanks,
> John
> 
> .
> 


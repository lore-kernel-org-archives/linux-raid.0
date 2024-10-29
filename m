Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230491FF7A3;
	Tue, 29 Oct 2024 11:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730201417; cv=none; b=h0LiKZWcvJZ0YNuM7HKZ3YFKrJjAwlerJrMeBnX6z4er+4a7FbDtbRFLIjDsCwbc1G6qJ6/Buqbw3c0es45ci5XGRWe3lgqPg3gZuN2ZH1WIVa2z/EHPvY0puAs8G1mVvMBTubU09dN+mzOe3SW2ka1vjy7vtbMonZ6KANWpUZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730201417; c=relaxed/simple;
	bh=41y14gQZSKoB6yJqFCWXHMG6MD7kdl5Mpu9u4Ed5ncA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NnDzBOrLGdfyNld6+3fQXT0Ftl4A7fpJpHI9wNjSG3nBSsvSW4HQxnbL3m2w8Va1zRSq1UCHXtoKmSvjRICcJZkXpG5eRkH0BvvpiOEa5Xlx+cJhivmNDPIxny8LsTuuYa2BHcwScRVy1yeT2Ucur0u0jccZiH6c01uly1b/3ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xd7Mf00Nzz4f3n6H;
	Tue, 29 Oct 2024 19:29:49 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 77E111A0568;
	Tue, 29 Oct 2024 19:30:08 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHYoY+xyBnu2kYAQ--.53165S3;
	Tue, 29 Oct 2024 19:30:08 +0800 (CST)
Subject: Re: [PATCH v2 6/7] md/raid1: Handle bio_split() errors
To: John Garry <john.g.garry@oracle.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 axboe@kernel.dk, song@kernel.org, hch@lst.de
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de,
 Johannes.Thumshirn@wdc.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241028152730.3377030-1-john.g.garry@oracle.com>
 <20241028152730.3377030-7-john.g.garry@oracle.com>
 <c79e7bb4-6f53-344e-9651-fc146b12d240@huaweicloud.com>
 <879c8b67-2eb4-4e9d-81bd-8f207adef7e1@oracle.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6325d143-b8f2-7287-201b-d3a2e53a556b@huaweicloud.com>
Date: Tue, 29 Oct 2024 19:30:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <879c8b67-2eb4-4e9d-81bd-8f207adef7e1@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYoY+xyBnu2kYAQ--.53165S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GF4DuF4rWF17Gr47JF4DXFb_yoWxJw4fpr
	4ktFWUJrW5Jrs5tw1UJFyjqa4rAr1Uta4DJr48J3WUJr47tryqgF4UXr1qgr1UJr48Gr1U
	Jr1UGrZxur17XrUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBY14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/10/29 16:45, John Garry 写道:
> On 29/10/2024 03:48, Yu Kuai wrote:
>> Hi,
>>
>> 在 2024/10/28 23:27, John Garry 写道:
>>> Add proper bio_split() error handling. For any error, call
>>> raid_end_bio_io() and return.
>>>
>>> For the case of an in the write path, we need to undo the increment in
>>> the rdev panding count and NULLify the r1_bio->bios[] pointers.
>>>
>>> Signed-off-by: John Garry <john.g.garry@oracle.com>
>>> ---
>>>   drivers/md/raid1.c | 32 ++++++++++++++++++++++++++++++--
>>>   1 file changed, 30 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>> index 6c9d24203f39..a10018282629 100644
>>> --- a/drivers/md/raid1.c
>>> +++ b/drivers/md/raid1.c
>>> @@ -1322,7 +1322,7 @@ static void raid1_read_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>       const enum req_op op = bio_op(bio);
>>>       const blk_opf_t do_sync = bio->bi_opf & REQ_SYNC;
>>>       int max_sectors;
>>> -    int rdisk;
>>> +    int rdisk, error;
>>>       bool r1bio_existed = !!r1_bio;
>>>       /*
>>> @@ -1383,6 +1383,11 @@ static void raid1_read_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>       if (max_sectors < bio_sectors(bio)) {
>>>           struct bio *split = bio_split(bio, max_sectors,
>>>                             gfp, &conf->bio_split);
>>> +
>>> +        if (IS_ERR(split)) {
>>> +            error = PTR_ERR(split);
>>> +            goto err_handle;
>>> +        }
>>>           bio_chain(split, bio);
>>>           submit_bio_noacct(bio);
>>>           bio = split;
>>> @@ -1410,6 +1415,12 @@ static void raid1_read_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>       read_bio->bi_private = r1_bio;
>>>       mddev_trace_remap(mddev, read_bio, r1_bio->sector);
>>>       submit_bio_noacct(read_bio);
>>> +    return;
>>> +
>>> +err_handle:
>>> +    bio->bi_status = errno_to_blk_status(error);
>>> +    set_bit(R1BIO_Uptodate, &r1_bio->state);
>>> +    raid_end_bio_io(r1_bio);
>>>   }
>>>   static void raid1_write_request(struct mddev *mddev, struct bio *bio,
>>> @@ -1417,7 +1428,7 @@ static void raid1_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>   {
>>>       struct r1conf *conf = mddev->private;
>>>       struct r1bio *r1_bio;
>>> -    int i, disks;
>>> +    int i, disks, k, error;
>>>       unsigned long flags;
>>>       struct md_rdev *blocked_rdev;
>>>       int first_clone;
>>> @@ -1576,6 +1587,11 @@ static void raid1_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>       if (max_sectors < bio_sectors(bio)) {
>>>           struct bio *split = bio_split(bio, max_sectors,
>>>                             GFP_NOIO, &conf->bio_split);
>>> +
>>> +        if (IS_ERR(split)) {
>>> +            error = PTR_ERR(split);
>>> +            goto err_handle;
>>> +        }
>>>           bio_chain(split, bio);
>>>           submit_bio_noacct(bio);
>>>           bio = split;
>>> @@ -1660,6 +1676,18 @@ static void raid1_write_request(struct mddev 
>>> *mddev, struct bio *bio,
>>>       /* In case raid1d snuck in to freeze_array */
>>>       wake_up_barrier(conf);
>>> +    return;
>>> +err_handle:
>>> +    for (k = 0; k < i; k++) {
>>> +        if (r1_bio->bios[k]) {
>>> +            rdev_dec_pending(conf->mirrors[k].rdev, mddev);
>>> +            r1_bio->bios[k] = NULL;
>>> +        }
>>> +    }
>>> +
>>> +    bio->bi_status = errno_to_blk_status(error);
>>> +    set_bit(R1BIO_Uptodate, &r1_bio->state);
>>> +    raid_end_bio_io(r1_bio);
> 
> Hi Kuai,
> 
>>
>> Looks good that error code is passed to orig bio. However,
>> I really think badblocks should be handled somehow, it just doesn't make
>> sense to return IO error to filesystems or user if one underlying disk
>> contain BB, while others are good.
> 
> Please be aware that this change is not for handling splits in atomic 
> writes. It is for situation when split fails for whatever reason - 
> likely a software bug.
> 
> For when atomic writes are supported for raid1, my plan is that an 
> atomic write over a region which covers a BB will error, i.e. goto 
> err_handle, like:
> 
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -1514,6 +1514,12 @@ static void raid1_write_request(struct mddev 
> *mddev, struct bio *bio,
>                   break;
>               }
> 
> +            if (is_bad && bio->bi_opf & REQ_ATOMIC) {
> +                /* We just cannot atomically write this ... */
> +                err = -EIO;
> +                goto err_handle;
> +            }
> +
>               if (is_bad && first_bad <= r1_bio->sector) {
> 
> 
> I just think that if we try to write a region atomically which contains 
> BBs then we should error. Indeed, as I mentioned previously, I really 
> don't expect BBs on devices which support atomic writes. But we should 
> still handle it.
> 
Agreed.

> OTOH, if we did want to handle atomic writes to regions with BBs, we 
> could make a bigger effort and write the disks which don't have BBs 
> atomically (so that we don't split for those good disks). But this is 
> too complicated and does not achieve much.

Agreed.

> 
>>
>> Or is it guaranteed that IO error by atomic write won't hurt anyone,
>> user will handle this error and retry with non atomic write?
> 
> Yes, I think that the user could retry non-atomically for the same 
> write. Maybe returning a special error code could be useful for this.

And can you update the above error path comment when you support raid1
and raid10?

Thanks,
Kuai

> 
> Thanks,
> John
> 
> .
> 


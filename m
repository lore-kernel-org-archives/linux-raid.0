Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB1831DF254
	for <linux-raid@vger.kernel.org>; Tue,  8 Oct 2024 13:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393848; cv=none; b=aNcz1ONNFM+Zl5sL27J8Ur4/jNQK+rQjiqKfB+Y4sLSXlpAwyCBfsvXbm7cL/TqLZh76/H6fiVxX/cq/B57Jk2YeUQmcAY4AEEA3K16EzccVlV1TJWiYN5Vuq3uEDmQ0/kFa2yx8q8I+ylYTNxRx7aAiGWCuV3w8euSXsduz5L4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393848; c=relaxed/simple;
	bh=ZuhJjvIQxmgU3DOY/clVgxBCHVMxkQmEHAwN3hDpI20=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dqNFbL8vPXyXx3B7LjQtzTPHefecGIChn874+1CyclulKKBt3AYyduYmvizqm/yHh9xJmv1FneaaaAJhRkDHMmrxSB1MOZSFoSAgNO/9KRZN1bOVBTVTKupXuZDDpDJ9hsShKT926/5NtVsEo6p4tnVdhWcSCghfi7eEKUvNwG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mUhDXoYf; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mUhDXoYf"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7ea12e0dc7aso1327516a12.3
        for <linux-raid@vger.kernel.org>; Tue, 08 Oct 2024 06:24:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728393846; x=1728998646; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LLYECzaGkAYo7pszC1lnMS07RTqxvP7PmDhhtGa8joA=;
        b=mUhDXoYfT5mcAjxMnn3C0hPRpAp2MLLmggxZlPyyfpsk2WTo51vii83qAkaOE9eSWY
         Arw0zZIgSgFcibUcaqWk13KNe7C44jW/NsYzdrTCJ3y1sfqOHiMZJZsEc6br8jv7TQL2
         ZjBQGe0z72maajjfZx24Q29tg4vpW1b9RCQwqsF2Rq/2wscmzg0EgSGDPcDiR6YQrEP1
         G4i9q/eHrAqYfBEEm9mNEpStUGtMuCthgDyVhXeScYa7etctQp+OzG6TrIuuYzsOnIqg
         QjEZviIqrNf08rC8LqpgZqSIv6kyO8wZhydulHMXB0/SyITM69+VQqaDXMmS1UqBELNn
         8/Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728393846; x=1728998646;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LLYECzaGkAYo7pszC1lnMS07RTqxvP7PmDhhtGa8joA=;
        b=qlIoEwJg/A+s7BBwoaxbSTLpmr/p1UF/5GLg6fCvtnVGFev9Ff6Y/YPhjoevXVNXJ4
         BNCbgNuKw2yzuBCZl47SoaKfyx+wf+TZkJ4KCvvM9SXhm1PZGpiSIpMrfLBCM0XEv2iF
         plUUjRsE8nH3hS64b5n0FUTzdBXcBjwiLGse+uDiM6mfi7GDqAExQCDkpyBx1FBrEO4L
         +VB29FbN7lkbiIA5n0+0yBwUwbbOcKEcT0rScYashPiHIL12TIDkaoAjdt4uLD9y2v+0
         dLz2OzqCUiQIztSBZ09hJAOKBRFNv334dFIwRMw7LdK5LXxcra8H3zp4+htvYvHGbcBK
         +GEw==
X-Forwarded-Encrypted: i=1; AJvYcCU8EqoD/eoeUX8hGuj8g/yKO6RwmeMQJwMzb5nHy/9pi+07wSFJVV8XmaRKeY+9HO2HvCXo25VqKxui@vger.kernel.org
X-Gm-Message-State: AOJu0YyZOyLxmISqrIYKg+voN6pHe9L81lfx0omw9zfJtD3+Xs+ihw5V
	UX8RBgZLHsSWdgcqfNtCM1DxFoRhMjC1qslMMlyHYV5MuyWlOHtyYyuvkJLk
X-Google-Smtp-Source: AGHT+IEea8siY9D2mznwAmsmrUnqjtidrPsdf/DaF4gSnwwV/HJIvSVp2U6Q8LnXB1KE9842V7bcig==
X-Received: by 2002:a05:6a21:2d8a:b0:1d4:becc:6ef1 with SMTP id adf61e73a8af0-1d6dfac9a42mr22242327637.31.1728393846131;
        Tue, 08 Oct 2024 06:24:06 -0700 (PDT)
Received: from [192.168.1.31] (ip68-231-38-120.ph.ph.cox.net. [68.231.38.120])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0cd08c9sm6114125b3a.75.2024.10.08.06.24.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 06:24:05 -0700 (PDT)
Message-ID: <a345285d-8e51-42e0-9197-06396bd0d226@gmail.com>
Date: Tue, 8 Oct 2024 06:24:04 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md: raid1 mixed RW performance improvement
To: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org
Cc: paul.e.luse@intel.com, "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20241004140514.20209-1-paulluselinux@gmail.com>
 <117cb186-8ec0-2fad-7852-10a0c0406181@huaweicloud.com>
Content-Language: en-US
From: Paul E Luse <paulluselinux@gmail.com>
In-Reply-To: <117cb186-8ec0-2fad-7852-10a0c0406181@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 10/7/24 8:20 PM, Yu Kuai wrote:
> Hi,
> 
> 在 2024/10/04 22:05, Paul Luse 写道:
>> While working on read_balance() earlier this year I realized that
>> for nonrot media the primary disk selection criteria for RAID1 reads
>> was to choose the disk with the least pending IO. At the same time it
>> was noticed that rarely did this work out to a 50/50 split between
>> the disks.  Initially I looked at a round-robin scheme however this
>> proved to be too complex when taking into account concurrency.
>>
>> That led to this patch.  Writes typically take longer than
>> reads for nonrot media so choosing the disk with the least pending
>> IO without knowing the mix of outstanding IO, reads vs writes, is not
>> optimal.
>>
>> This patch takes a very simple implantation approach to place more
>> weight on writes vs reads when selecting a disk to read from.  Based
>> on empirical testing of multiple drive vendors NVMe and SATA (some
>> data included below) I found that weighing writes by 1.25x and rounding
>> gave the best overall performance improvement.  The boost varies by
>> drive, as do most drive dependent performance optimizations.  Kioxia
>> gets the least benefit while Samsung gets the most.  I also confirmed
>> no impact on pure read cases (or writes of course).  I left the total
>> pending counter in place and simply added one specific to reads, there
>> was no reason to count them separately especially given the additional
>> complexity in the write path for tracking pending IO.
>>
>> The fewer writes that are outstanding the less positive impact this
>> patch has.  So the math works out well.  Here are the non-weighted
>> and weighted values for looking at outstanding writes.  The first column
>> is the unweighted value and the second is what is used with this patch.
>> Until there are at least 4 pending, no change.  The more pending, the
>> more the value is weighted which is perfect for how the drives behave.
>>
>> 1 1
>> 2 2
>> 3 3
>> 4 5
>> 5 6
>> 6 7
>> 7 8
>> 8 10
>> 9 11
>> 10 12
>> 11 13
>> 12 15
>> 13 16
>> 14 17
>> 15 18
>> 16 20
>>
>> Below is performance data for the patch, 3 different NVMe drives
>> and one SATA.
>>
>> WD SATA: https://photos.app.goo.gl/1smadpDEzgLaa5G48
>> WD NVMe: https://photos.app.goo.gl/YkTTcYfU8Yc8XWA58
>> SamSung NVMe: https://photos.app.goo.gl/F6MvEfmbGtRyPUFz6
>> Kioxia NVMe: https://photos.app.goo.gl/BAEhi8hUwsdTyj9y5
>>
>> Signed-off-by: Paul Luse <paulluselinux@gmail.com>
>> ---
>>   drivers/md/md.h    |  9 +++++++++
>>   drivers/md/raid1.c | 34 +++++++++++++++++++++++++---------
>>   2 files changed, 34 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 5d2e6bd58e4d..1a1040ec3c4a 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -162,6 +162,9 @@ struct md_rdev {
>>                        */
>>       };
>> +    atomic_t nr_reads_pending;      /* tracks only mirrored reads 
>> pending
>> +                     * to support a performance optimization
>> +                     */
>>       atomic_t    nr_pending;    /* number of pending requests.
>>                        * only maintained for arrays that
>>                        * support hot removal
>> @@ -923,6 +926,12 @@ static inline void rdev_dec_pending(struct 
>> md_rdev *rdev, struct mddev *mddev)
>>       }
>>   }
>> +static inline void mirror_rdev_dec_pending(struct md_rdev *rdev, 
>> struct mddev *mddev)
>> +{
>> +    atomic_dec(&rdev->nr_reads_pending);
>> +    rdev_dec_pending(rdev, mddev);
> 
> I know that this will cause more code changes, will it make more sense
> just to split writes and reads? With following apis:
> 
> rdev_inc_pending(rdev, rw);
> rdev_dec_pending(rdev, rw);
> rdev_pending(rdev);
> rdev_rw_pending(rdev, rw);
> 
> Thanks,
> Kuai


Thanks Kwai.  Yes I started that way and as mentioned in the commit
message the write path will require more testing and closer review
as there are many inc/dec as compared to the read path.  I will work
on it though, thanks!

-Paul

> 
>> +}
>> +
>>   extern const struct md_cluster_operations *md_cluster_ops;
>>   static inline int mddev_is_clustered(struct mddev *mddev)
>>   {
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index f55c8e67d059..5315b46d2cca 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -394,7 +394,7 @@ static void raid1_end_read_request(struct bio *bio)
>>       if (uptodate) {
>>           raid_end_bio_io(r1_bio);
>> -        rdev_dec_pending(rdev, conf->mddev);
>> +        mirror_rdev_dec_pending(rdev, conf->mddev);
>>       } else {
>>           /*
>>            * oops, read error:
>> @@ -584,6 +584,7 @@ static void update_read_sectors(struct r1conf 
>> *conf, int disk,
>>       struct raid1_info *info = &conf->mirrors[disk];
>>       atomic_inc(&info->rdev->nr_pending);
>> +    atomic_inc(&info->rdev->nr_reads_pending);
>>       if (info->next_seq_sect != this_sector)
>>           info->seq_start = this_sector;
>>       info->next_seq_sect = this_sector + len;
>> @@ -760,9 +761,11 @@ struct read_balance_ctl {
>>       int readable_disks;
>>   };
>> +#define WRITE_WEIGHT 2
>>   static int choose_best_rdev(struct r1conf *conf, struct r1bio *r1_bio)
>>   {
>>       int disk;
>> +    int nonrot = READ_ONCE(conf->nonrot_disks);
>>       struct read_balance_ctl ctl = {
>>           .closest_dist_disk      = -1,
>>           .closest_dist           = MaxSector,
>> @@ -774,7 +777,7 @@ static int choose_best_rdev(struct r1conf *conf, 
>> struct r1bio *r1_bio)
>>       for (disk = 0 ; disk < conf->raid_disks * 2 ; disk++) {
>>           struct md_rdev *rdev;
>>           sector_t dist;
>> -        unsigned int pending;
>> +        unsigned int total_pending, reads_pending;
>>           if (r1_bio->bios[disk] == IO_BLOCKED)
>>               continue;
>> @@ -787,7 +790,21 @@ static int choose_best_rdev(struct r1conf *conf, 
>> struct r1bio *r1_bio)
>>           if (ctl.readable_disks++ == 1)
>>               set_bit(R1BIO_FailFast, &r1_bio->state);
>> -        pending = atomic_read(&rdev->nr_pending);
>> +        total_pending = atomic_read(&rdev->nr_pending);
>> +        if (nonrot) {
>> +            /* for nonrot we weigh writes slightly heavier than
>> +             * reads when deciding disk based on pending IOs as
>> +             * writes typically take longer
>> +             */
>> +            reads_pending = atomic_read(&rdev->nr_reads_pending);
>> +            if (total_pending > reads_pending) {
>> +                int writes;
>> +
>> +                writes = total_pending - reads_pending;
>> +                writes += (writes >> WRITE_WEIGHT);
>> +                total_pending = writes + reads_pending;
>> +            }
>> +        }
>>           dist = abs(r1_bio->sector - conf->mirrors[disk].head_position);
>>           /* Don't change to another disk for sequential reads */
>> @@ -799,7 +816,7 @@ static int choose_best_rdev(struct r1conf *conf, 
>> struct r1bio *r1_bio)
>>                * Add 'pending' to avoid choosing this disk if
>>                * there is other idle disk.
>>                */
>> -            pending++;
>> +            total_pending++;
>>               /*
>>                * If there is no other idle disk, this disk
>>                * will be chosen.
>> @@ -807,8 +824,8 @@ static int choose_best_rdev(struct r1conf *conf, 
>> struct r1bio *r1_bio)
>>               ctl.sequential_disk = disk;
>>           }
>> -        if (ctl.min_pending > pending) {
>> -            ctl.min_pending = pending;
>> +        if (ctl.min_pending > total_pending) {
>> +            ctl.min_pending = total_pending;
>>               ctl.min_pending_disk = disk;
>>           }
>> @@ -831,8 +848,7 @@ static int choose_best_rdev(struct r1conf *conf, 
>> struct r1bio *r1_bio)
>>        * disk is rotational, which might/might not be optimal for 
>> raids with
>>        * mixed ratation/non-rotational disks depending on workload.
>>        */
>> -    if (ctl.min_pending_disk != -1 &&
>> -        (READ_ONCE(conf->nonrot_disks) || ctl.min_pending == 0))
>> +    if (ctl.min_pending_disk != -1 && (nonrot || ctl.min_pending == 0))
>>           return ctl.min_pending_disk;
>>       else
>>           return ctl.closest_dist_disk;
>> @@ -2622,7 +2638,7 @@ static void handle_read_error(struct r1conf 
>> *conf, struct r1bio *r1_bio)
>>           r1_bio->bios[r1_bio->read_disk] = IO_BLOCKED;
>>       }
>> -    rdev_dec_pending(rdev, conf->mddev);
>> +    mirror_rdev_dec_pending(rdev, conf->mddev);
>>       sector = r1_bio->sector;
>>       bio = r1_bio->master_bio;
>>
> 


Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61F75624;
	Mon, 23 Dec 2024 07:50:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734940212; cv=none; b=AMzYxabrqOyU+i2Xq59liiuo/9Fo1oGmLP95xHtjevW1xLh7SkoHUkH/c++ei3LSlVrYEax5N2Bp6N/4XpVU+3f+gDwvWLYH0opz4scLDDEharUDAkqz/MNk5D5h0WiIe1/veUl/fPo/SXCtqkefeKFU+sf26dWV+g7+PrJpuJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734940212; c=relaxed/simple;
	bh=MiuJvSH+eFWOaAZwUtBpc5S89edN93oV2OtpDLGAxv4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Jf09quaNfvAng1gguXzBCmsNnBAXdCShePmocN5CNb7Vxvvd6y+X1+7Aibc6KjjEuidakYtYtL8Z93q2qEqfbwBIV6J+7sd46ZL+FBOrZz+w5wYb3jyFP+VUHU6rHTgOnVQSlNTtRwCjm1C7lEj3q3MftZK9CzXAsnzqoFqVE6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YGqtK5C4dz4f3jdK;
	Mon, 23 Dec 2024 15:49:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5DABD1A058E;
	Mon, 23 Dec 2024 15:50:05 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHYoYrFmlnoo2VFQ--.41840S3;
	Mon, 23 Dec 2024 15:50:05 +0800 (CST)
Subject: Re: [PATCH v2 md-6.14 2/5] md/md-bitmap: remove the last parameter
 for bimtap_ops->endwrite()
To: Xiao Ni <xni@redhat.com>, yukuai@kernel.org
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@hauwei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241218121745.2459-1-yukuai@kernel.org>
 <20241218121745.2459-3-yukuai@kernel.org>
 <CALTww2-nXW5Uv=+z0LHPvSkJMs7bTqoiWOE+8bKJrpf6XEB1-g@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6decfd12-111b-3eca-e781-9b4dbbdfda98@huaweicloud.com>
Date: Mon, 23 Dec 2024 15:50:03 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww2-nXW5Uv=+z0LHPvSkJMs7bTqoiWOE+8bKJrpf6XEB1-g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYoYrFmlnoo2VFQ--.41840S3
X-Coremail-Antispam: 1UD129KBjvJXoWxuFW5CFWfAF4rXw15KFW5GFg_yoWxtFW7p3
	93JFyakryYgrWYvw17ZFyDuFyFv3s2grZrKryI93s8ua4vvr98GF4rWFWj9r1DZF13Za4S
	v3W5Jr47Cr90gFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkKb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnUUI43ZEXa7IU1veHD
	UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/12/23 15:31, Xiao Ni 写道:
> On Wed, Dec 18, 2024 at 8:21 PM <yukuai@kernel.org> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> It is useless, because for the case IO failed for one rdev:
>>
>> - If badblocks is set and rdev is not faulty, there is no need to
>>   mark the bit as NEEDED;
> 
> 
> Hi Kuai
> 
> It's better to add some comments before here. Before this patch, it's
> easy to understand. It needs to set bitmap bit when a write request
> fails. 

This is not accurate, it's doesn't matter if IO fails or succeed, bit
must be set if data is not consistent, either IO is not done yet, or the
array is degaraded.

> With this patch, there are some hidden logics here. To me, it's
> not easy to maintain in the future. And in man mdadm, there is no-bbl
> option, so it looks like an array may not have a bad block. And I
> don't know how dmraid maintain badblock. So this patch needs to be
> more careful.

no-bbl is one of the option of mdadm --update, I think it means remove
current badblock entries, not that disable badblocks.

In kernel, badblocks is always enabled by default, and IO error will
always try to set badblocks first. For example:

  - badblocks_init() is called from md_rdev_init(), and if
badblocks_init() fails, the array can't be assembled.
  - The only thing stop rdev to record badblocks after IO failure is that
rdev is faulty.

Thanks,
Kuai

> 
> Regards
> Xiao
> 
>> - If rdev is faulty, then mddev->degraded will be set, and we can use
>> it to mard the bit as NEEDED;
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> Signed-off-by: Yu Kuai <yukuai@kernel.org>
>> ---
>>   drivers/md/md-bitmap.c   | 19 ++++++++++---------
>>   drivers/md/md-bitmap.h   |  2 +-
>>   drivers/md/raid1.c       |  3 +--
>>   drivers/md/raid10.c      |  3 +--
>>   drivers/md/raid5-cache.c |  3 +--
>>   drivers/md/raid5.c       |  9 +++------
>>   6 files changed, 17 insertions(+), 22 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index 84fb4cc67d5e..b40a84b01085 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -1726,7 +1726,7 @@ static int bitmap_startwrite(struct mddev *mddev, sector_t offset,
>>   }
>>
>>   static void bitmap_endwrite(struct mddev *mddev, sector_t offset,
>> -                           unsigned long sectors, bool success)
>> +                           unsigned long sectors)
>>   {
>>          struct bitmap *bitmap = mddev->bitmap;
>>
>> @@ -1745,15 +1745,16 @@ static void bitmap_endwrite(struct mddev *mddev, sector_t offset,
>>                          return;
>>                  }
>>
>> -               if (success && !bitmap->mddev->degraded &&
>> -                   bitmap->events_cleared < bitmap->mddev->events) {
>> -                       bitmap->events_cleared = bitmap->mddev->events;
>> -                       bitmap->need_sync = 1;
>> -                       sysfs_notify_dirent_safe(bitmap->sysfs_can_clear);
>> -               }
>> -
>> -               if (!success && !NEEDED(*bmc))
>> +               if (!bitmap->mddev->degraded) {
>> +                       if (bitmap->events_cleared < bitmap->mddev->events) {
>> +                               bitmap->events_cleared = bitmap->mddev->events;
>> +                               bitmap->need_sync = 1;
>> +                               sysfs_notify_dirent_safe(
>> +                                               bitmap->sysfs_can_clear);
>> +                       }
>> +               } else if (!NEEDED(*bmc)) {
>>                          *bmc |= NEEDED_MASK;
>> +               }
>>
>>                  if (COUNTER(*bmc) == COUNTER_MAX)
>>                          wake_up(&bitmap->overflow_wait);
>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>> index e87a1f493d3c..31c93019c76b 100644
>> --- a/drivers/md/md-bitmap.h
>> +++ b/drivers/md/md-bitmap.h
>> @@ -92,7 +92,7 @@ struct bitmap_operations {
>>          int (*startwrite)(struct mddev *mddev, sector_t offset,
>>                            unsigned long sectors);
>>          void (*endwrite)(struct mddev *mddev, sector_t offset,
>> -                        unsigned long sectors, bool success);
>> +                        unsigned long sectors);
>>          bool (*start_sync)(struct mddev *mddev, sector_t offset,
>>                             sector_t *blocks, bool degraded);
>>          void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 15ba7a001f30..81dff2cea0db 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -423,8 +423,7 @@ static void close_write(struct r1bio *r1_bio)
>>          if (test_bit(R1BIO_BehindIO, &r1_bio->state))
>>                  mddev->bitmap_ops->end_behind_write(mddev);
>>          /* clear the bitmap if all writes complete successfully */
>> -       mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sectors,
>> -                                   !test_bit(R1BIO_Degraded, &r1_bio->state));
>> +       mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sectors);
>>          md_write_end(mddev);
>>   }
>>
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index c3a93b2a26a6..3dc0170125b2 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -429,8 +429,7 @@ static void close_write(struct r10bio *r10_bio)
>>          struct mddev *mddev = r10_bio->mddev;
>>
>>          /* clear the bitmap if all writes complete successfully */
>> -       mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->sectors,
>> -                                   !test_bit(R10BIO_Degraded, &r10_bio->state));
>> +       mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->sectors);
>>          md_write_end(mddev);
>>   }
>>
>> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>> index 4c7ecdd5c1f3..ba4f9577c737 100644
>> --- a/drivers/md/raid5-cache.c
>> +++ b/drivers/md/raid5-cache.c
>> @@ -314,8 +314,7 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
>>                          set_bit(R5_UPTODATE, &sh->dev[i].flags);
>>                          r5c_return_dev_pending_writes(conf, &sh->dev[i]);
>>                          conf->mddev->bitmap_ops->endwrite(conf->mddev,
>> -                                       sh->sector, RAID5_STRIPE_SECTORS(conf),
>> -                                       !test_bit(STRIPE_DEGRADED, &sh->state));
>> +                                       sh->sector, RAID5_STRIPE_SECTORS(conf));
>>                  }
>>          }
>>   }
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 93cc7e252dd4..6eb2841ce28c 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -3664,8 +3664,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>>                  }
>>                  if (bitmap_end)
>>                          conf->mddev->bitmap_ops->endwrite(conf->mddev,
>> -                                       sh->sector, RAID5_STRIPE_SECTORS(conf),
>> -                                       false);
>> +                                       sh->sector, RAID5_STRIPE_SECTORS(conf));
>>                  bitmap_end = 0;
>>                  /* and fail all 'written' */
>>                  bi = sh->dev[i].written;
>> @@ -3711,8 +3710,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>>                  }
>>                  if (bitmap_end)
>>                          conf->mddev->bitmap_ops->endwrite(conf->mddev,
>> -                                       sh->sector, RAID5_STRIPE_SECTORS(conf),
>> -                                       false);
>> +                                       sh->sector, RAID5_STRIPE_SECTORS(conf));
>>                  /* If we were in the middle of a write the parity block might
>>                   * still be locked - so just clear all R5_LOCKED flags
>>                   */
>> @@ -4062,8 +4060,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
>>                                          wbi = wbi2;
>>                                  }
>>                                  conf->mddev->bitmap_ops->endwrite(conf->mddev,
>> -                                       sh->sector, RAID5_STRIPE_SECTORS(conf),
>> -                                       !test_bit(STRIPE_DEGRADED, &sh->state));
>> +                                       sh->sector, RAID5_STRIPE_SECTORS(conf));
>>                                  if (head_sh->batch_head) {
>>                                          sh = list_first_entry(&sh->batch_list,
>>                                                                struct stripe_head,
>> --
>> 2.43.0
>>
>>
> 
> 
> .
> 


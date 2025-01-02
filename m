Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5751C28F3;
	Thu,  2 Jan 2025 01:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735780652; cv=none; b=ZacVo7W4iCo6sNdt/yOEoVZ2CXoruUQNY+itjVpjNmcOBxnA3QN/pw98/6IpGwtWqKfvrkQ0+p4FlFcwCxkCAU8TdXj7YedWJeEG6pM1IXgorgQ7yo5QG190PpNAGraItpNCxHzPL/d1GsS7P8tUIQHBiIbILWPu9bsMjyAhvrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735780652; c=relaxed/simple;
	bh=jN09KAMgGNH56/Dbz6/ruQrmLnBetotq6PyI5LOI7c0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=OPW5FMLaRSs96ajcDXm6lslgpP6M7cMqMMlrmrenaxmcsvW/wU5Ck9dxv2pcrn6t6Ksa1e54sbalJANm/0RnguMfASqMZuOY/g20+DRPMXBDUKpv8egZhUomGDaO+Pl7HglY59GkaaDLjM+vYMM50/tCJUuBEBnjLrqmNfBW5Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YNphX0cn4z4f3jHy;
	Thu,  2 Jan 2025 09:17:00 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0E0F31A0DFA;
	Thu,  2 Jan 2025 09:17:20 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgC33oIe6XVnV_4vGQ--.22857S3;
	Thu, 02 Jan 2025 09:17:19 +0800 (CST)
Subject: Re: [PATCH v2 md-6.14 2/5] md/md-bitmap: remove the last parameter
 for bimtap_ops->endwrite()
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: yukuai@kernel.org, song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@hauwei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241218121745.2459-1-yukuai@kernel.org>
 <20241218121745.2459-3-yukuai@kernel.org>
 <CALTww2-nXW5Uv=+z0LHPvSkJMs7bTqoiWOE+8bKJrpf6XEB1-g@mail.gmail.com>
 <6decfd12-111b-3eca-e781-9b4dbbdfda98@huaweicloud.com>
 <CALTww29Y0jUGZBAaKVTDYQWRYAs_MxtriR7WjmDcxVqO77KRSQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <307308e9-f5dd-daf0-97ef-f53644c65dd8@huaweicloud.com>
Date: Thu, 2 Jan 2025 09:17:18 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww29Y0jUGZBAaKVTDYQWRYAs_MxtriR7WjmDcxVqO77KRSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC33oIe6XVnV_4vGQ--.22857S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKFW5ZFy3XF1kWw1rGw43GFg_yoW3tFyrp3
	9rJFW3C398XryYvw12vFyj9F9Yq3s2gr9Fgr1xK345ua4vvF98GF48WFWj9r1kZF13ZF12
	v3W5GrW3Cry5tFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbGQ6JUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/12/30 13:01, Xiao Ni 写道:
> On Mon, Dec 23, 2024 at 3:50 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2024/12/23 15:31, Xiao Ni 写道:
>>> On Wed, Dec 18, 2024 at 8:21 PM <yukuai@kernel.org> wrote:
>>>>
>>>> From: Yu Kuai <yukuai3@huawei.com>
>>>>
>>>> It is useless, because for the case IO failed for one rdev:
>>>>
>>>> - If badblocks is set and rdev is not faulty, there is no need to
>>>>    mark the bit as NEEDED;
>>>
>>>
>>> Hi Kuai
>>>
>>> It's better to add some comments before here. Before this patch, it's
>>> easy to understand. It needs to set bitmap bit when a write request
>>> fails.
> 
> Hi Kuai
> 
>>
>> This is not accurate, it's doesn't matter if IO fails or succeed, bit
>> must be set if data is not consistent, either IO is not done yet, or the
>> array is degaraded.
> 
> Sorry for the wrong words. I want to say bitmap NEEDED bit is set when
> a write request fails. After this patch, we can't see the logic
> directly. So it's a hidden logic. It's better to add more comments
> here for future maintenance.

Ok.
> 
> And I read the codes, R1BIO_Degraded, STRIPE_DEGRADED,
> R10BIO_Degraded, these three flags are only used to tell bitmap if it
> needs to set NEEDED bit. After this patch, it looks like these flags
> are not useful anymore.

Yes, the xxx_DEGRADED flag is useless now and can be cleaned up.

Thanks,
Kuai

> 
>>
>>> With this patch, there are some hidden logics here. To me, it's
>>> not easy to maintain in the future. And in man mdadm, there is no-bbl
>>> option, so it looks like an array may not have a bad block. And I
>>> don't know how dmraid maintain badblock. So this patch needs to be
>>> more careful.
>>
>> no-bbl is one of the option of mdadm --update, I think it means remove
>> current badblock entries, not that disable badblocks.
>>
>> In kernel, badblocks is always enabled by default, and IO error will
>> always try to set badblocks first. For example:
>>
>>    - badblocks_init() is called from md_rdev_init(), and if
>> badblocks_init() fails, the array can't be assembled.
>>    - The only thing stop rdev to record badblocks after IO failure is that
>> rdev is faulty.
> 
> Yes, thanks for pointing out this.
>>
>> Thanks,
>> Kuai
>>
>>>
>>> Regards
>>> Xiao
>>>
>>>> - If rdev is faulty, then mddev->degraded will be set, and we can use
>>>> it to mard the bit as NEEDED;
>>>>
>>>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>>>> Signed-off-by: Yu Kuai <yukuai@kernel.org>
>>>> ---
>>>>    drivers/md/md-bitmap.c   | 19 ++++++++++---------
>>>>    drivers/md/md-bitmap.h   |  2 +-
>>>>    drivers/md/raid1.c       |  3 +--
>>>>    drivers/md/raid10.c      |  3 +--
>>>>    drivers/md/raid5-cache.c |  3 +--
>>>>    drivers/md/raid5.c       |  9 +++------
>>>>    6 files changed, 17 insertions(+), 22 deletions(-)
>>>>
>>>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>>>> index 84fb4cc67d5e..b40a84b01085 100644
>>>> --- a/drivers/md/md-bitmap.c
>>>> +++ b/drivers/md/md-bitmap.c
>>>> @@ -1726,7 +1726,7 @@ static int bitmap_startwrite(struct mddev *mddev, sector_t offset,
>>>>    }
>>>>
>>>>    static void bitmap_endwrite(struct mddev *mddev, sector_t offset,
>>>> -                           unsigned long sectors, bool success)
>>>> +                           unsigned long sectors)
>>>>    {
>>>>           struct bitmap *bitmap = mddev->bitmap;
>>>>
>>>> @@ -1745,15 +1745,16 @@ static void bitmap_endwrite(struct mddev *mddev, sector_t offset,
>>>>                           return;
>>>>                   }
>>>>
>>>> -               if (success && !bitmap->mddev->degraded &&
>>>> -                   bitmap->events_cleared < bitmap->mddev->events) {
>>>> -                       bitmap->events_cleared = bitmap->mddev->events;
>>>> -                       bitmap->need_sync = 1;
>>>> -                       sysfs_notify_dirent_safe(bitmap->sysfs_can_clear);
>>>> -               }
>>>> -
>>>> -               if (!success && !NEEDED(*bmc))
>>>> +               if (!bitmap->mddev->degraded) {
>>>> +                       if (bitmap->events_cleared < bitmap->mddev->events) {
>>>> +                               bitmap->events_cleared = bitmap->mddev->events;
>>>> +                               bitmap->need_sync = 1;
>>>> +                               sysfs_notify_dirent_safe(
>>>> +                                               bitmap->sysfs_can_clear);
>>>> +                       }
>>>> +               } else if (!NEEDED(*bmc)) {
>>>>                           *bmc |= NEEDED_MASK;
>>>> +               }
>>>>
>>>>                   if (COUNTER(*bmc) == COUNTER_MAX)
>>>>                           wake_up(&bitmap->overflow_wait);
>>>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>>>> index e87a1f493d3c..31c93019c76b 100644
>>>> --- a/drivers/md/md-bitmap.h
>>>> +++ b/drivers/md/md-bitmap.h
>>>> @@ -92,7 +92,7 @@ struct bitmap_operations {
>>>>           int (*startwrite)(struct mddev *mddev, sector_t offset,
>>>>                             unsigned long sectors);
>>>>           void (*endwrite)(struct mddev *mddev, sector_t offset,
>>>> -                        unsigned long sectors, bool success);
>>>> +                        unsigned long sectors);
>>>>           bool (*start_sync)(struct mddev *mddev, sector_t offset,
>>>>                              sector_t *blocks, bool degraded);
>>>>           void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t *blocks);
>>>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>>>> index 15ba7a001f30..81dff2cea0db 100644
>>>> --- a/drivers/md/raid1.c
>>>> +++ b/drivers/md/raid1.c
>>>> @@ -423,8 +423,7 @@ static void close_write(struct r1bio *r1_bio)
>>>>           if (test_bit(R1BIO_BehindIO, &r1_bio->state))
>>>>                   mddev->bitmap_ops->end_behind_write(mddev);
>>>>           /* clear the bitmap if all writes complete successfully */
>>>> -       mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sectors,
>>>> -                                   !test_bit(R1BIO_Degraded, &r1_bio->state));
>>>> +       mddev->bitmap_ops->endwrite(mddev, r1_bio->sector, r1_bio->sectors);
>>>>           md_write_end(mddev);
>>>>    }
>>>>
>>>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>>>> index c3a93b2a26a6..3dc0170125b2 100644
>>>> --- a/drivers/md/raid10.c
>>>> +++ b/drivers/md/raid10.c
>>>> @@ -429,8 +429,7 @@ static void close_write(struct r10bio *r10_bio)
>>>>           struct mddev *mddev = r10_bio->mddev;
>>>>
>>>>           /* clear the bitmap if all writes complete successfully */
>>>> -       mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->sectors,
>>>> -                                   !test_bit(R10BIO_Degraded, &r10_bio->state));
>>>> +       mddev->bitmap_ops->endwrite(mddev, r10_bio->sector, r10_bio->sectors);
>>>>           md_write_end(mddev);
>>>>    }
>>>>
>>>> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
>>>> index 4c7ecdd5c1f3..ba4f9577c737 100644
>>>> --- a/drivers/md/raid5-cache.c
>>>> +++ b/drivers/md/raid5-cache.c
>>>> @@ -314,8 +314,7 @@ void r5c_handle_cached_data_endio(struct r5conf *conf,
>>>>                           set_bit(R5_UPTODATE, &sh->dev[i].flags);
>>>>                           r5c_return_dev_pending_writes(conf, &sh->dev[i]);
>>>>                           conf->mddev->bitmap_ops->endwrite(conf->mddev,
>>>> -                                       sh->sector, RAID5_STRIPE_SECTORS(conf),
>>>> -                                       !test_bit(STRIPE_DEGRADED, &sh->state));
>>>> +                                       sh->sector, RAID5_STRIPE_SECTORS(conf));
>>>>                   }
>>>>           }
>>>>    }
>>>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>>>> index 93cc7e252dd4..6eb2841ce28c 100644
>>>> --- a/drivers/md/raid5.c
>>>> +++ b/drivers/md/raid5.c
>>>> @@ -3664,8 +3664,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>>>>                   }
>>>>                   if (bitmap_end)
>>>>                           conf->mddev->bitmap_ops->endwrite(conf->mddev,
>>>> -                                       sh->sector, RAID5_STRIPE_SECTORS(conf),
>>>> -                                       false);
>>>> +                                       sh->sector, RAID5_STRIPE_SECTORS(conf));
>>>>                   bitmap_end = 0;
>>>>                   /* and fail all 'written' */
>>>>                   bi = sh->dev[i].written;
>>>> @@ -3711,8 +3710,7 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
>>>>                   }
>>>>                   if (bitmap_end)
>>>>                           conf->mddev->bitmap_ops->endwrite(conf->mddev,
>>>> -                                       sh->sector, RAID5_STRIPE_SECTORS(conf),
>>>> -                                       false);
>>>> +                                       sh->sector, RAID5_STRIPE_SECTORS(conf));
>>>>                   /* If we were in the middle of a write the parity block might
>>>>                    * still be locked - so just clear all R5_LOCKED flags
>>>>                    */
>>>> @@ -4062,8 +4060,7 @@ static void handle_stripe_clean_event(struct r5conf *conf,
>>>>                                           wbi = wbi2;
>>>>                                   }
>>>>                                   conf->mddev->bitmap_ops->endwrite(conf->mddev,
>>>> -                                       sh->sector, RAID5_STRIPE_SECTORS(conf),
>>>> -                                       !test_bit(STRIPE_DEGRADED, &sh->state));
>>>> +                                       sh->sector, RAID5_STRIPE_SECTORS(conf));
>>>>                                   if (head_sh->batch_head) {
>>>>                                           sh = list_first_entry(&sh->batch_list,
>>>>                                                                 struct stripe_head,
>>>> --
>>>> 2.43.0
>>>>
>>>>
>>>
>>>
>>> .
>>>
>>
> 
> 
> .
> 


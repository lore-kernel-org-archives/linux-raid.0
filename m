Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720A314BFB0;
	Mon, 26 Aug 2024 08:27:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724660849; cv=none; b=Ab/tDA9DjbD1ETi6ylYwHxD3MWa5SaqGlYTPB9mvB/+9HVfIMwuOPb7jqpEOnFwLV/bYm4hBZc9WJEjNkTX/DMf4IN16X3jkveTvdcTGz4hTRKkP8b/3qJdK35iFx3Q4Ga/vCgYTQtATZTlK+AQxsq0Pn8ipMvlPtb2WUZlStxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724660849; c=relaxed/simple;
	bh=3mPy++LZVuJNjQa+/M9RvhCVINEq4ZckXWcx8buqjQI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KjWwR1RwqjrI0xyVQ/2RJICyJXXFeEzf0yJLBS+0qx/pXMrDUMit7v2ZTp2jKplUlWDN3g3yuNrqORsTYfPVTGHbPlL221HbR1W4jsbJzWGhxWfqlisvmIBxLRDaWxE3VsqCfoBSLTH8kEazNm9Q9/otXm7ZwBKQ90qDCIvQFIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WskLN6Wq6z4f3lVb;
	Mon, 26 Aug 2024 16:27:08 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 448761A0359;
	Mon, 26 Aug 2024 16:27:24 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgAXPoRrPMxmEuAGCw--.22714S3;
	Mon, 26 Aug 2024 16:27:24 +0800 (CST)
Subject: Re: [PATCH md-6.12 v2 29/42] md/md-bitmap: mrege
 md_bitmap_cond_end_sync() into bitmap_operations
To: Paul Menzel <pmenzel@molgen.mpg.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@linux.intel.com, xni@redhat.com, song@kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20240826074452.1490072-1-yukuai1@huaweicloud.com>
 <20240826074452.1490072-30-yukuai1@huaweicloud.com>
 <dedf0d3b-bc45-4d04-a987-9df498f51661@molgen.mpg.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <816ded2c-148f-d282-0943-50a9556d10c3@huaweicloud.com>
Date: Mon, 26 Aug 2024 16:27:23 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <dedf0d3b-bc45-4d04-a987-9df498f51661@molgen.mpg.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXPoRrPMxmEuAGCw--.22714S3
X-Coremail-Antispam: 1UD129KBjvJXoW3XF1xtFyDXw15XryrGFWxZwb_yoWxJF15pr
	4kJFy3G345GrZ5X34UAryDCFyrA3s7t3srtr18Wa4fGr1UJr1qgF48WF1jgF1UJF4fJF1U
	tw1UJr45ur17Xr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Cr0_Gr1UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjfUFg4SDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/26 16:09, Paul Menzel 写道:
> Dear Kuai,
> 
> 
> Thank you for your patch. (I am still confused, what your given and 
> surname is.)
> 
> Am 26.08.24 um 09:44 schrieb Yu Kuai:
>> From: Yu Kuai <yukuai3@huawei.com>
> 
> There is a typo in the summary: mrege → merge.

Got it!.
> 
>> So that the implementation won't be exposed, and it'll be possible
>> to invent a new bitmap by replacing bitmap_operations.
>>
>> Also change the parameter from bitmap to mddev, to avoid access
>> bitmap outside md-bitmap.c as much as possible.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md-bitmap.c | 6 ++++--
>>   drivers/md/md-bitmap.h | 2 +-
>>   drivers/md/raid1.c     | 6 +++---
>>   drivers/md/raid10.c    | 2 +-
>>   drivers/md/raid5.c     | 2 +-
>>   5 files changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
>> index e1dceff2d9a5..2d9d9689f721 100644
>> --- a/drivers/md/md-bitmap.c
>> +++ b/drivers/md/md-bitmap.c
>> @@ -1690,10 +1690,12 @@ static void bitmap_close_sync(struct mddev 
>> *mddev)
>>       }
>>   }
>> -void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, 
>> bool force)
>> +static void bitmap_cond_end_sync(struct mddev *mddev, sector_t sector,
>> +                 bool force)
>>   {
>>       sector_t s = 0;
>>       sector_t blocks;
>> +    struct bitmap *bitmap = mddev->bitmap;
>>       if (!bitmap)
>>           return;
>> @@ -1718,7 +1720,6 @@ void md_bitmap_cond_end_sync(struct bitmap 
>> *bitmap, sector_t sector, bool force)
>>       bitmap->last_end_sync = jiffies;
>>       sysfs_notify_dirent_safe(bitmap->mddev->sysfs_completed);
>>   }
>> -EXPORT_SYMBOL(md_bitmap_cond_end_sync);
>>   void md_bitmap_sync_with_cluster(struct mddev *mddev,
>>                     sector_t old_lo, sector_t old_hi,
>> @@ -2747,6 +2748,7 @@ static struct bitmap_operations bitmap_ops = {
>>       .endwrite        = bitmap_endwrite,
>>       .start_sync        = bitmap_start_sync,
>>       .end_sync        = bitmap_end_sync,
>> +    .cond_end_sync        = bitmap_cond_end_sync,
>>       .close_sync        = bitmap_close_sync,
>>       .update_sb        = bitmap_update_sb,
>> diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
>> index 5d919b530317..027de097f96a 100644
>> --- a/drivers/md/md-bitmap.h
>> +++ b/drivers/md/md-bitmap.h
>> @@ -262,6 +262,7 @@ struct bitmap_operations {
>>       bool (*start_sync)(struct mddev *mddev, sector_t offset,
>>                  sector_t *blocks, bool degraded);
>>       void (*end_sync)(struct mddev *mddev, sector_t offset, sector_t 
>> *blocks);
>> +    void (*cond_end_sync)(struct mddev *mddev, sector_t sector, bool 
>> force);
>>       void (*close_sync)(struct mddev *mddev);
>>       void (*update_sb)(struct bitmap *bitmap);
>> @@ -272,7 +273,6 @@ struct bitmap_operations {
>>   void mddev_set_bitmap_ops(struct mddev *mddev);
>>   /* these are exported */
>> -void md_bitmap_cond_end_sync(struct bitmap *bitmap, sector_t sector, 
>> bool force);
>>   void md_bitmap_sync_with_cluster(struct mddev *mddev,
>>                    sector_t old_lo, sector_t old_hi,
>>                    sector_t new_lo, sector_t new_hi);
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 52ca5619d9b4..00174cacb1f4 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -2828,9 +2828,9 @@ static sector_t raid1_sync_request(struct mddev 
>> *mddev, sector_t sector_nr,
>>        * sector_nr + two times RESYNC_SECTORS
>>        */
>> -    md_bitmap_cond_end_sync(mddev->bitmap, sector_nr,
>> -        mddev_is_clustered(mddev) && (sector_nr + 2 * RESYNC_SECTORS 
>> > conf->cluster_sync_high));
>> -
>> +    mddev->bitmap_ops->cond_end_sync(mddev, sector_nr,
>> +        mddev_is_clustered(mddev) &&
>> +        (sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
>>       if (raise_barrier(conf, sector_nr))
>>           return 0;
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 5b1c86c368b1..5a7b19f48c45 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -3543,7 +3543,7 @@ static sector_t raid10_sync_request(struct mddev 
>> *mddev, sector_t sector_nr,
>>            * safety reason, which ensures curr_resync_completed is
>>            * updated in bitmap_cond_end_sync.
>>            */
>> -        md_bitmap_cond_end_sync(mddev->bitmap, sector_nr,
>> +        mddev->bitmap_ops->cond_end_sync(mddev, sector_nr,
>>                       mddev_is_clustered(mddev) &&
>>                       (sector_nr + 2 * RESYNC_SECTORS > 
>> conf->cluster_sync_high));
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index d2b8d2517abf..87b8d19ab601 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -6540,7 +6540,7 @@ static inline sector_t raid5_sync_request(struct 
>> mddev *mddev, sector_t sector_n
>>           return sync_blocks * RAID5_STRIPE_SECTORS(conf);
>>       }
>> -    md_bitmap_cond_end_sync(mddev->bitmap, sector_nr, false);
>> +    mddev->bitmap_ops->cond_end_sync(mddev, sector_nr, false);
>>       sh = raid5_get_active_stripe(conf, NULL, sector_nr,
>>                        R5_GAS_NOBLOCK);
> 
> The diff looks good to me.
> 
> 
> Kind regards,

Thanks for the review!.
Kuai

> 
> Paul
> .
> 


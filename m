Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED87C7E9;
	Thu,  2 Jan 2025 01:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735780878; cv=none; b=Zh6UOgJ+yFTZnP5GTlzfS8IfKPptNCf47NGdl2gBw8WEMo6QzheLFi0Gi9Rx2jnEbqMTgkDmZvfz2aqas5e6HHI5j0hXQNCnLCMy0H6tCqBmQyYdfoWBbUOWeqIyOPS5+WG8SOwm3AVyPJ9GKosmRE+lB9hrivr6xBNCPXfENJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735780878; c=relaxed/simple;
	bh=66WFAnivQ/lzHcD8W31/LAP+4Fn+GLuewnsoU9MS3Yg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=WNc+yJM7OX2jzYuyF7ubs4Mhs/8Iq32VOvMkueLw+wb2gKV9CZvX4qeWMWmrvEzwhgQr5cRL4aKn7N/CjW51jl7JfgtCDVTtY3Lpo+8/409zy6o+4MisNaGISk2xGoAdptlSRCdQMt6TW6gY8noVOCMSTnGRuMzikNBLe8KED9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YNpms1wWTz4f3kvs;
	Thu,  2 Jan 2025 09:20:45 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5CE3D1A0AD1;
	Thu,  2 Jan 2025 09:21:06 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHYoYB6nVnKzswGQ--.54219S3;
	Thu, 02 Jan 2025 09:21:06 +0800 (CST)
Subject: Re: [PATCH v2 md-6.14 4/5] md/raid5: implement pers->bitmap_sector()
To: Xiao Ni <xni@redhat.com>, yukuai@kernel.org
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@hauwei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241218121745.2459-1-yukuai@kernel.org>
 <20241218121745.2459-5-yukuai@kernel.org>
 <CALTww2_7rfHO-B_bBTgk0iZig_qyMJhoEoiqaSci1i_Ao4MUHQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <eca236bc-27de-887a-4339-5a73ed045aca@huaweicloud.com>
Date: Thu, 2 Jan 2025 09:21:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww2_7rfHO-B_bBTgk0iZig_qyMJhoEoiqaSci1i_Ao4MUHQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYoYB6nVnKzswGQ--.54219S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZr17WFW3trW5Aw4Dur1DAwb_yoW5CF17pa
	nFyFsI9r47Zr15uwnrJ348uF1Fyas3KrZrtFy3J3Z5G3ZxGr93Z3W8Kw45uF1UCFyrtr4j
	yw1UGr9ruFs8KFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFyl
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07Upyx
	iUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/01/01 13:36, Xiao Ni 写道:
> On Wed, Dec 18, 2024 at 8:22 PM <yukuai@kernel.org> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Bitmap is used for the whole array for raid1/raid10, hence IO for the
>> array can be used directly for bitmap. However, bitmap is used for
>> underlying disks for raid5, hence IO for the array can't be used
>> directly for bitmap.
>>
>> Implement pers->bitmap_sector() for raid5 to convert IO ranges from the
>> array to the underlying disks.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> Signed-off-by: Yu Kuai <yukuai@kernel.org>
>> ---
>>   drivers/md/raid5.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index 6eb2841ce28c..b2fe201b599d 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -2950,6 +2950,23 @@ static void raid5_error(struct mddev *mddev, struct md_rdev *rdev)
>>          r5c_update_on_rdev_error(mddev, rdev);
>>   }
>>
>> +static void raid5_bitmap_sector(struct mddev *mddev, sector_t *offset,
>> +                               unsigned long *sectors)
>> +{
>> +       struct r5conf *conf = mddev->private;
>> +       int sectors_per_chunk = conf->chunk_sectors * (conf->raid_disks -
>> +                                                      conf->max_degraded);
>> +       sector_t start = *offset;
>> +       sector_t end = start + *sectors;
>> +       int dd_idx;
>> +
>> +       start = round_down(start, sectors_per_chunk);
>> +       end = round_up(end, sectors_per_chunk);
>> +
>> +       *offset = raid5_compute_sector(conf, start, 0, &dd_idx, NULL);
>> +       *sectors = raid5_compute_sector(conf, end, 0, &dd_idx, NULL) - *offset;
>> +}
> 
> Hi Kuai
> 
> This function needs to think about reshape like make_stripe_request does.
> 

Yes, we need to handle reshape. However, we can't retry like
make_stripe_request(). I guess I'll compute sector for both before
reshape and after reshape, and set the bits together.

Thanks,
Kuai

> Regards
> Xiao
>> +
>>   /*
>>    * Input: a 'big' sector number,
>>    * Output: index of the data and parity disk, and the sector # in them.
>> @@ -8972,6 +8989,7 @@ static struct md_personality raid6_personality =
>>          .takeover       = raid6_takeover,
>>          .change_consistency_policy = raid5_change_consistency_policy,
>>          .prepare_suspend = raid5_prepare_suspend,
>> +       .bitmap_sector  = raid5_bitmap_sector,
>>   };
>>   static struct md_personality raid5_personality =
>>   {
>> @@ -8997,6 +9015,7 @@ static struct md_personality raid5_personality =
>>          .takeover       = raid5_takeover,
>>          .change_consistency_policy = raid5_change_consistency_policy,
>>          .prepare_suspend = raid5_prepare_suspend,
>> +       .bitmap_sector  = raid5_bitmap_sector,
>>   };
>>
>>   static struct md_personality raid4_personality =
>> @@ -9023,6 +9042,7 @@ static struct md_personality raid4_personality =
>>          .takeover       = raid4_takeover,
>>          .change_consistency_policy = raid5_change_consistency_policy,
>>          .prepare_suspend = raid5_prepare_suspend,
>> +       .bitmap_sector  = raid5_bitmap_sector,
>>   };
>>
>>   static int __init raid5_init(void)
>> --
>> 2.43.0
>>
>>
> 
> .
> 


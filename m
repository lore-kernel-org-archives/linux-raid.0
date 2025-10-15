Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E78522A7F1;
	Wed, 15 Oct 2025 02:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760495334; cv=none; b=LP8slcV9/cM0z7c1oV2tBAMyvWmzh/OjBZQuHAbmmLWFjmUJCjkeX8TpSo6w7CYz5YNsl13rP/FA4KNTnNnd9+uRJl5R7ri4/+kpyKaTU/ij078vm2KegQztZrhBV5I8B0p3k9K2H7yws2JH/SCf3bBvWz5G3ieAY7ACtLh7NSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760495334; c=relaxed/simple;
	bh=Pnf/qnqJz9NgamP/ECW9F/JPfHOWs56Y+IrDwsLPPyo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FnwNBEyj75SoMDR9EZxMzm0QqbkwhCG459P/AoMS6ntlCHcgeX4MUjg5jv4P74Jh1DzpkBFkAgjGZqWbWzjj2Q3bMz4tJ3rS0mL8CLp4XiS+aTMWiywKpEVX7P6YLqdap/0+pqm1Z9dzPcWWkVcz5cmYnMIJpzqVErvTpNxu2rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cmZkb2VkCzYQtff;
	Wed, 15 Oct 2025 10:28:07 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 540BF1A1725;
	Wed, 15 Oct 2025 10:28:49 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP2 (Coremail) with SMTP id Syh0CgBXrETfBu9oH8eiAQ--.51312S3;
	Wed, 15 Oct 2025 10:28:49 +0800 (CST)
Message-ID: <858e807b-6fea-57e0-f077-f8d24f412fae@huaweicloud.com>
Date: Wed, 15 Oct 2025 10:28:47 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6] md: allow configuring logical block size
To: Xiao Ni <xni@redhat.com>, linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, hare@suse.de,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250926071837.766910-1-linan666@huaweicloud.com>
 <CALTww284K51ppg8XO5e6QHG+bzXhHSdJbsQAgh0fes5Jp4DW7w@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww284K51ppg8XO5e6QHG+bzXhHSdJbsQAgh0fes5Jp4DW7w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBXrETfBu9oH8eiAQ--.51312S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZry7KF4kJr45XFW3uw4fAFb_yoWrZr17p3
	97AFyIvw1DXa4Fya9rZw1DZ3WrX3yUKFWqkFyaga10yr9rur17GFWfXFy5Wryqq3Z8Zwn7
	t3W0kFyDZF1F9FJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14
	v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQV
	y7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/28 9:46, Xiao Ni 写道:

>> +static struct md_sysfs_entry md_logical_block_size =
>> +__ATTR(logical_block_size, S_IRUGO|S_IWUSR, lbs_show, lbs_store);
>>
>>   static struct attribute *md_default_attrs[] = {
>>          &md_level.attr,
>> @@ -5933,6 +5995,7 @@ static struct attribute *md_redundancy_attrs[] = {
>>          &md_scan_mode.attr,
>>          &md_last_scan_mode.attr,
>>          &md_mismatches.attr,
>> +       &md_logical_block_size.attr,
> 
> Hi
> 
> I just saw your v5 replied email and noticed this place. The logcial
> block size doesn't have relationship with sync action, right?
> md_redundancy_attrs is used for sync attributes. So is it better to
> put this into md_default_attrs?
> 
> 

Hi, Thansks for your review.

Agree, I will move it to md_default_attrs in the next version.


>>          &md_sync_min.attr,
>>          &md_sync_max.attr,
>>          &md_sync_io_depth.attr,
>> @@ -6052,6 +6115,17 @@ int mddev_stack_rdev_limits(struct mddev *mddev, struct queue_limits *lim,
>>                          return -EINVAL;
>>          }
>>
>> +       /*
>> +        * Before RAID adding folio support, the logical_block_size
>> +        * should be smaller than the page size.
>> +        */
>> +       if (lim->logical_block_size > PAGE_SIZE) {
>> +               pr_err("%s: logical_block_size must not larger than PAGE_SIZE\n",
>> +                       mdname(mddev));
>> +               return -EINVAL;
>> +       }
>> +       mddev->logical_block_size = lim->logical_block_size;
>> +
>>          return 0;
>>   }
>>   EXPORT_SYMBOL_GPL(mddev_stack_rdev_limits);
>> @@ -6690,6 +6764,7 @@ static void md_clean(struct mddev *mddev)
>>          mddev->chunk_sectors = 0;
>>          mddev->ctime = mddev->utime = 0;
>>          mddev->layout = 0;
>> +       mddev->logical_block_size = 0;
>>          mddev->max_disks = 0;
>>          mddev->events = 0;
>>          mddev->can_decrease_events = 0;
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index f1d8811a542a..705889a09fc1 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -382,6 +382,7 @@ static int raid0_set_limits(struct mddev *mddev)
>>          md_init_stacking_limits(&lim);
>>          lim.max_hw_sectors = mddev->chunk_sectors;
>>          lim.max_write_zeroes_sectors = mddev->chunk_sectors;
>> +       lim.logical_block_size = mddev->logical_block_size;
> 
> raid0 creates zone stripes first based on the member disk's LBS. So
> it's not right to change the logical block size here?
> 
> Best Regards
> Xiao

On further check, it is feasible to move raid0_set_limits before
create_strip_zones. I will fix it in the next version. Thank you for your
detailed review.

>>          lim.io_min = mddev->chunk_sectors << 9;
>>          lim.io_opt = lim.io_min * mddev->raid_disks;
>>          lim.chunk_sectors = mddev->chunk_sectors;
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index d0f6afd2f988..de0c843067dc 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -3223,6 +3223,7 @@ static int raid1_set_limits(struct mddev *mddev)
>>
>>          md_init_stacking_limits(&lim);
>>          lim.max_write_zeroes_sectors = 0;
>> +       lim.logical_block_size = mddev->logical_block_size;
>>          lim.features |= BLK_FEAT_ATOMIC_WRITES;
>>          err = mddev_stack_rdev_limits(mddev, &lim, MDDEV_STACK_INTEGRITY);
>>          if (err)
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index c3cfbb0347e7..68c8148386b0 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -4005,6 +4005,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
>>
>>          md_init_stacking_limits(&lim);
>>          lim.max_write_zeroes_sectors = 0;
>> +       lim.logical_block_size = mddev->logical_block_size;
>>          lim.io_min = mddev->chunk_sectors << 9;
>>          lim.chunk_sectors = mddev->chunk_sectors;
>>          lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index c32ffd9cffce..ff0daa22df65 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -7747,6 +7747,7 @@ static int raid5_set_limits(struct mddev *mddev)
>>          stripe = roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9));
>>
>>          md_init_stacking_limits(&lim);
>> +       lim.logical_block_size = mddev->logical_block_size;
>>          lim.io_min = mddev->chunk_sectors << 9;
>>          lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
>>          lim.features |= BLK_FEAT_RAID_PARTIAL_STRIPES_EXPENSIVE;
>> --
>> 2.39.2
>>
> 
> 
> .

-- 
Thanks,
Nan


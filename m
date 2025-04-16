Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E2F158520;
	Wed, 16 Apr 2025 08:19:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744791603; cv=none; b=lO29YJC9cIgBFOYci8Ab7iaJF/53LuTzjaNV78FbA+QoVOu2oYgdJ6foScCOYJjL+ESOlN/fJqPAeYejFDL5lk2IM5hn4tAthgzDsP8EhDC7FtXPF2syLW60NKRqPE4Tr4rYOZwMFtsYqfUQSy16bsHndilyAPYZ9OK7im0Mw3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744791603; c=relaxed/simple;
	bh=LEdsZgYyyJn3eLhzBrsi9GDJWL/o/T+gL45WIcdg/HM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=LPPG7UOFpcC1AFIZ3a6QZZ+Tc4A9yGV1olfmI4zClqv4mBkZHN5QSTaH0qH5VGTZ5hx7v+Wylj/h+BAe39u6sw2AOicIs+NkjjUuw/iXdky4Vq/HKEqSOZQXgaOI+kf0HtcnuE+4JDI0LiHeHlZqnNsdpx4n6wGrIZCFccfolmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Zcv834t74z4f3jYS;
	Wed, 16 Apr 2025 16:19:31 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 5D9011A06DC;
	Wed, 16 Apr 2025 16:19:55 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgC3Gl8paP9nR7WNJg--.53124S3;
	Wed, 16 Apr 2025 16:19:55 +0800 (CST)
Subject: Re: [PATCH 2/4] md: add a new api sync_io_depth
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, song@kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250412073202.3085138-1-yukuai1@huaweicloud.com>
 <20250412073202.3085138-3-yukuai1@huaweicloud.com>
 <CALTww29xMyNq0SpPGvVqp6YPmCVu+N+d_neeJD_mogiviiZpYw@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <bf3deb80-4ed2-21b4-e919-a96cf329e947@huaweicloud.com>
Date: Wed, 16 Apr 2025 16:19:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww29xMyNq0SpPGvVqp6YPmCVu+N+d_neeJD_mogiviiZpYw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgC3Gl8paP9nR7WNJg--.53124S3
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw18uF47CF15Xr17Cw4xXrb_yoW3WFWfpa
	yUJFW3Gr4UXrZxXry2qFsxCa4Sqw4fKrWjy3y7G3WfJFnI9r9xGF1FgrW5WFykua4rCrn2
	v3WUJa9xua1ftrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/04/16 13:32, Xiao Ni 写道:
> On Sat, Apr 12, 2025 at 3:39 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> Currently if sync speed is above speed_min and below speed_max,
>> md_do_sync() will wait for all sync IOs to be done before issuing new
>> sync IO, means sync IO depth is limited to just 1.
>>
>> This limit is too low, in order to prevent sync speed drop conspicuously
>> after fixing is_mddev_idle() in the next patch, add a new api for
>> limiting sync IO depth, the default value is 32.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
>> ---
>>   drivers/md/md.c | 103 +++++++++++++++++++++++++++++++++++++++---------
>>   drivers/md/md.h |   1 +
>>   2 files changed, 85 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 438e71e45c16..8966c4afc62a 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -111,32 +111,42 @@ static void md_wakeup_thread_directly(struct md_thread __rcu *thread);
>>   /* Default safemode delay: 200 msec */
>>   #define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 +1)
>>   /*
>> - * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
>> - * is 1000 KB/sec, so the extra system load does not show up that much.
>> - * Increase it if you want to have more _guaranteed_ speed. Note that
>> - * the RAID driver will use the maximum available bandwidth if the IO
>> - * subsystem is idle. There is also an 'absolute maximum' reconstruction
>> - * speed limit - in case reconstruction slows down your system despite
>> - * idle IO detection.
> 
> These comments are useful. They only describe the meaning of those
> control values. Is it good to keep them?

Sure
> 
>> + * Background sync IO speed control:
>>    *
>> - * you can change it via /proc/sys/dev/raid/speed_limit_min and _max.
>> - * or /sys/block/mdX/md/sync_speed_{min,max}
>> + * - below speed min:
>> + *   no limit;
>> + * - above speed min and below speed max:
>> + *   a) if mddev is idle, then no limit;
>> + *   b) if mddev is busy handling normal IO, then limit inflight sync IO
>> + *   to sync_io_depth;
>> + * - above speed max:
>> + *   sync IO can't be issued;
>> + *
>> + * Following configurations can be changed via /proc/sys/dev/raid/ for system
>> + * or /sys/block/mdX/md/ for one array.
>>    */
>> -
>>   static int sysctl_speed_limit_min = 1000;
>>   static int sysctl_speed_limit_max = 200000;
>> -static inline int speed_min(struct mddev *mddev)
>> +static int sysctl_sync_io_depth = 32;
>> +
>> +static int speed_min(struct mddev *mddev)
>>   {
>>          return mddev->sync_speed_min ?
>>                  mddev->sync_speed_min : sysctl_speed_limit_min;
>>   }
>>
>> -static inline int speed_max(struct mddev *mddev)
>> +static int speed_max(struct mddev *mddev)
>>   {
>>          return mddev->sync_speed_max ?
>>                  mddev->sync_speed_max : sysctl_speed_limit_max;
>>   }
>>
>> +static int sync_io_depth(struct mddev *mddev)
>> +{
>> +       return mddev->sync_io_depth ?
>> +               mddev->sync_io_depth : sysctl_sync_io_depth;
>> +}
>> +
>>   static void rdev_uninit_serial(struct md_rdev *rdev)
>>   {
>>          if (!test_and_clear_bit(CollisionCheck, &rdev->flags))
>> @@ -293,14 +303,21 @@ static const struct ctl_table raid_table[] = {
>>                  .procname       = "speed_limit_min",
>>                  .data           = &sysctl_speed_limit_min,
>>                  .maxlen         = sizeof(int),
>> -               .mode           = S_IRUGO|S_IWUSR,
>> +               .mode           = 0644,
> 
> Is it better to use macro rather than number directly here?

checkpatch will suggest 0644 over S_IRUGO|S_IWUSR.

Thanks,
Kuai

> 
>>                  .proc_handler   = proc_dointvec,
>>          },
>>          {
>>                  .procname       = "speed_limit_max",
>>                  .data           = &sysctl_speed_limit_max,
>>                  .maxlen         = sizeof(int),
>> -               .mode           = S_IRUGO|S_IWUSR,
>> +               .mode           = 0644,
>> +               .proc_handler   = proc_dointvec,
>> +       },
>> +       {
>> +               .procname       = "sync_io_depth",
>> +               .data           = &sysctl_sync_io_depth,
>> +               .maxlen         = sizeof(int),
>> +               .mode           = 0644,
>>                  .proc_handler   = proc_dointvec,
>>          },
>>   };
>> @@ -5091,7 +5108,7 @@ static ssize_t
>>   sync_min_show(struct mddev *mddev, char *page)
>>   {
>>          return sprintf(page, "%d (%s)\n", speed_min(mddev),
>> -                      mddev->sync_speed_min ? "local": "system");
>> +                      mddev->sync_speed_min ? "local" : "system");
>>   }
>>
>>   static ssize_t
>> @@ -5100,7 +5117,7 @@ sync_min_store(struct mddev *mddev, const char *buf, size_t len)
>>          unsigned int min;
>>          int rv;
>>
>> -       if (strncmp(buf, "system", 6)==0) {
>> +       if (strncmp(buf, "system", 6) == 0) {
>>                  min = 0;
>>          } else {
>>                  rv = kstrtouint(buf, 10, &min);
>> @@ -5120,7 +5137,7 @@ static ssize_t
>>   sync_max_show(struct mddev *mddev, char *page)
>>   {
>>          return sprintf(page, "%d (%s)\n", speed_max(mddev),
>> -                      mddev->sync_speed_max ? "local": "system");
>> +                      mddev->sync_speed_max ? "local" : "system");
>>   }
>>
>>   static ssize_t
>> @@ -5129,7 +5146,7 @@ sync_max_store(struct mddev *mddev, const char *buf, size_t len)
>>          unsigned int max;
>>          int rv;
>>
>> -       if (strncmp(buf, "system", 6)==0) {
>> +       if (strncmp(buf, "system", 6) == 0) {
>>                  max = 0;
>>          } else {
>>                  rv = kstrtouint(buf, 10, &max);
>> @@ -5145,6 +5162,35 @@ sync_max_store(struct mddev *mddev, const char *buf, size_t len)
>>   static struct md_sysfs_entry md_sync_max =
>>   __ATTR(sync_speed_max, S_IRUGO|S_IWUSR, sync_max_show, sync_max_store);
>>
>> +static ssize_t
>> +sync_io_depth_show(struct mddev *mddev, char *page)
>> +{
>> +       return sprintf(page, "%d (%s)\n", sync_io_depth(mddev),
>> +                      mddev->sync_io_depth ? "local" : "system");
>> +}
>> +
>> +static ssize_t
>> +sync_io_depth_store(struct mddev *mddev, const char *buf, size_t len)
>> +{
>> +       unsigned int max;
>> +       int rv;
>> +
>> +       if (strncmp(buf, "system", 6) == 0) {
>> +               max = 0;
>> +       } else {
>> +               rv = kstrtouint(buf, 10, &max);
>> +               if (rv < 0)
>> +                       return rv;
>> +               if (max == 0)
>> +                       return -EINVAL;
>> +       }
>> +       mddev->sync_io_depth = max;
>> +       return len;
>> +}
>> +
>> +static struct md_sysfs_entry md_sync_io_depth =
>> +__ATTR_RW(sync_io_depth);
>> +
>>   static ssize_t
>>   degraded_show(struct mddev *mddev, char *page)
>>   {
>> @@ -5671,6 +5717,7 @@ static struct attribute *md_redundancy_attrs[] = {
>>          &md_mismatches.attr,
>>          &md_sync_min.attr,
>>          &md_sync_max.attr,
>> +       &md_sync_io_depth.attr,
>>          &md_sync_speed.attr,
>>          &md_sync_force_parallel.attr,
>>          &md_sync_completed.attr,
>> @@ -8927,6 +8974,23 @@ static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
>>          }
>>   }
>>
>> +static bool sync_io_within_limit(struct mddev *mddev)
>> +{
>> +       int io_sectors;
>> +
>> +       /*
>> +        * For raid456, sync IO is stripe(4k) per IO, for other levels, it's
>> +        * RESYNC_PAGES(64k) per IO.
>> +        */
>> +       if (mddev->level == 4 || mddev->level == 5 || mddev->level == 6)
>> +               io_sectors = 8;
>> +       else
>> +               io_sectors = 128;
>> +
>> +       return atomic_read(&mddev->recovery_active) <
>> +               io_sectors * sync_io_depth(mddev);
>> +}
>> +
>>   #define SYNC_MARKS     10
>>   #define        SYNC_MARK_STEP  (3*HZ)
>>   #define UPDATE_FREQUENCY (5*60*HZ)
>> @@ -9195,7 +9259,8 @@ void md_do_sync(struct md_thread *thread)
>>                                  msleep(500);
>>                                  goto repeat;
>>                          }
>> -                       if (!is_mddev_idle(mddev, 0)) {
>> +                       if (!sync_io_within_limit(mddev) &&
>> +                           !is_mddev_idle(mddev, 0)) {
>>                                  /*
>>                                   * Give other IO more of a chance.
>>                                   * The faster the devices, the less we wait.
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 1cf00a04bcdd..63be622467c6 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -483,6 +483,7 @@ struct mddev {
>>          /* if zero, use the system-wide default */
>>          int                             sync_speed_min;
>>          int                             sync_speed_max;
>> +       int                             sync_io_depth;
>>
>>          /* resync even though the same disks are shared among md-devices */
>>          int                             parallel_resync;
>> --
>> 2.39.2
>>
> 
> This part looks good to me.
> 
> Acked-by: Xiao Ni <xni@redhat.com>
> 
> 
> 
> .
> 


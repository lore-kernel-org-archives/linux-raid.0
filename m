Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FCAA1E502
	for <linux-raid@vger.kernel.org>; Sun, 21 Sep 2025 14:49:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758466165; cv=none; b=J3BGhfzljMuMHZDeXb/T37MJUepkZAw1cb+kkcpCPFeYMOICLD0YZqMrd1eXP32O47YOS1F5iupjVpYbVr8nG+YvP8PJN6oUOsodQUgcgQPfsZOjz0xperZ7S0/o8izh67bW3LL7f1uWTrQUpjWheuXvGywVD3/5NRhHiayPTsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758466165; c=relaxed/simple;
	bh=t5GM36bLnT2Tb+7cz1gIRjOEPpmXcgyffFG+EGwy6i4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sXgh8N8Inz+3bE9xKMB+6SBO1ZM3C2oNuJjEkXgvg7uGvTqQ10NR6gY2feJpxkCpfaXj9/folb4qtRbilHcG/zfp6AIRAKJ6AGcS+PczPaYM2xasqdSMiFjY5y9SLkC6oGgeh/z9h0Mf6JcjMI42IUvg7zTeAY3kreRa/MEacWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fwd.mgml.me; spf=pass smtp.mailfrom=fwd.mgml.me; dkim=pass (2048-bit key) header.d=fwd.mgml.me header.i=@fwd.mgml.me header.b=GOGsnqAG; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fwd.mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fwd.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fwd.mgml.me header.i=@fwd.mgml.me header.b="GOGsnqAG"
Received: from NEET (p3802011-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.53.179.11])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58LEmaLA019086
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 21 Sep 2025 23:48:36 +0900 (JST)
	(envelope-from k@fwd.mgml.me)
DKIM-Signature: a=rsa-sha256; bh=eVxpXDxPuZq2d3D5n7/Gd/w3ZZ4WUNur6IL0OAw8UEA=;
        c=relaxed/relaxed; d=fwd.mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250919; t=1758466116; v=1;
        b=GOGsnqAGuMkMURSfkaklC78xq0V6wV88dDv4b0rSWOAyXuC50jj4KAyT6N3UPK5t
         OPWPaPZzWQClNAAJyfdVm/i5LpDZZ5AqEDu3KUsFd9VWePNPdsAGGLPHIXCmaBXo
         CCkhULWtVLFKOYg+zeLzvgIrPoo2smHiyCaPIT1U2CQGjHy8JUbjWV+Ka8k4rcnm
         17m2pftxz8T+fbp/zKoW0s6u8tMkz43vpRgu/UdWJa5Wdqr8tXk87znrwheaQq6l
         3oEXEbVWc9H4NXalEdngF6u+OXrj8jc1MVz0ggcKRkvjJEk+J0vQvGxnE6a45Wg7
         HEstqbBL7WpmYDdMTpOmrw==
Message-ID: <b64fc92d-cb30-4b9e-b9c2-5652d50458dd@fwd.mgml.me>
Date: Sun, 21 Sep 2025 23:48:35 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/9] md/raid1,raid10: Set the LastDev flag when the
 configuration changes
To: Xiao Ni <xni@redhat.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
        Guoqing Jiang <jgq516@gmail.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kenta Akagi <k@fwd.mgml.me>
References: <20250915034210.8533-1-k@mgml.me>
 <20250915034210.8533-2-k@mgml.me>
 <CALTww2_XBBBP3NHRjxrxsJ3eqjJ_bB8SmCeHFocun1hQiUedkA@mail.gmail.com>
Content-Language: en-US
From: Kenta Akagi <k@fwd.mgml.me>
In-Reply-To: <CALTww2_XBBBP3NHRjxrxsJ3eqjJ_bB8SmCeHFocun1hQiUedkA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,
Thank you for review.

On 2025/09/21 16:54, Xiao Ni wrote:
> Hi Kenta
> 
> On Mon, Sep 15, 2025 at 11:44 AM Kenta Akagi <k@mgml.me> wrote:
>>
>> Currently, the LastDev flag is set on an rdev that failed a failfast
>> metadata write and called md_error, but did not become Faulty. It is
>> cleared when the metadata write retry succeeds. This has problems for
>> the following reasons:
>>
>> * Despite its name, the flag is only set during a metadata write window.
>> * Unlike when LastDev and Failfast was introduced, md_error on the last
>>   rdev of a RAID1/10 array now sets MD_BROKEN. Thus when LastDev is set,
>>   the array is already unwritable.
>>
>> A following commit will prevent failfast bios from breaking the array,
>> which requires knowing from outside the personality whether an rdev is
>> the last one. For that purpose, LastDev should be set on rdevs that must
>> not be lost.
>>
>> This commit ensures that LastDev is set on the indispensable rdev in a
>> degraded RAID1/10 array.
>>
>> Signed-off-by: Kenta Akagi <k@mgml.me>
>> ---
>>  drivers/md/md.c     |  4 +---
>>  drivers/md/md.h     |  6 +++---
>>  drivers/md/raid1.c  | 34 +++++++++++++++++++++++++++++++++-
>>  drivers/md/raid10.c | 34 +++++++++++++++++++++++++++++++++-
>>  4 files changed, 70 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 4e033c26fdd4..268410b66b83 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -1007,10 +1007,8 @@ static void super_written(struct bio *bio)
>>                 if (!test_bit(Faulty, &rdev->flags)
>>                     && (bio->bi_opf & MD_FAILFAST)) {
>>                         set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
>> -                       set_bit(LastDev, &rdev->flags);
>>                 }
>> -       } else
>> -               clear_bit(LastDev, &rdev->flags);
>> +       }
>>
>>         bio_put(bio);
>>
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 51af29a03079..ec598f9a8381 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -281,9 +281,9 @@ enum flag_bits {
>>                                  * It is expects that no bad block log
>>                                  * is present.
>>                                  */
>> -       LastDev,                /* Seems to be the last working dev as
>> -                                * it didn't fail, so don't use FailFast
>> -                                * any more for metadata
>> +       LastDev,                /* This is the last working rdev.
>> +                                * so don't use FailFast any more for
>> +                                * metadata.
>>                                  */
>>         CollisionCheck,         /*
>>                                  * check if there is collision between raid1
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index bf44878ec640..32ad6b102ff7 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1733,6 +1733,33 @@ static void raid1_status(struct seq_file *seq, struct mddev *mddev)
>>         seq_printf(seq, "]");
>>  }
>>
>> +/**
>> + * update_lastdev - Set or clear LastDev flag for all rdevs in array
>> + * @conf: pointer to r1conf
>> + *
>> + * Sets LastDev if the device is In_sync and cannot be lost for the array.
>> + * Otherwise, clear it.
>> + *
>> + * Caller must hold ->device_lock.
>> + */
>> +static void update_lastdev(struct r1conf *conf)
>> +{
>> +       int i;
>> +       int alive_disks = conf->raid_disks - conf->mddev->degraded;
>> +
>> +       for (i = 0; i < conf->raid_disks; i++) {
>> +               struct md_rdev *rdev = conf->mirrors[i].rdev;
>> +
>> +               if (rdev) {
>> +                       if (test_bit(In_sync, &rdev->flags) &&
>> +                           alive_disks == 1)
>> +                               set_bit(LastDev, &rdev->flags);
>> +                       else
>> +                               clear_bit(LastDev, &rdev->flags);
>> +               }
>> +       }
>> +}
>> +
>>  /**
>>   * raid1_error() - RAID1 error handler.
>>   * @mddev: affected md device.
>> @@ -1767,8 +1794,10 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>                 }
>>         }
>>         set_bit(Blocked, &rdev->flags);
>> -       if (test_and_clear_bit(In_sync, &rdev->flags))
>> +       if (test_and_clear_bit(In_sync, &rdev->flags)) {
>>                 mddev->degraded++;
>> +               update_lastdev(conf);
>> +       }
>>         set_bit(Faulty, &rdev->flags);
>>         spin_unlock_irqrestore(&conf->device_lock, flags);
>>         /*
>> @@ -1864,6 +1893,7 @@ static int raid1_spare_active(struct mddev *mddev)
>>                 }
>>         }
>>         mddev->degraded -= count;
>> +       update_lastdev(conf);
> 
> update_lastdev is called in raid1_spare_active, raid1_run and
> raid1_reshape. Could you explain the reason why it needs to call this
> function? Is it the reason you want to clear LastDev flag? If so, is
> it a right place to do it? As your commit message says, it will be
> cleared after retry metadata successfully. In raid1, is it the right
> place that fixes read/write successfully?

The intention was to set LastDev only when the rdev is the last device in the array.

As suggested in review, I will check whether it is the last device when
md_error is called, instead of using a flag.
As a result, update_lastdev() will be removed, and the purpose and behavior
of LastDev will remain unchanged in v5.

Thanks,
Akagi

> 
> Best Regards
> Xiao
> 
>>         spin_unlock_irqrestore(&conf->device_lock, flags);
>>
>>         print_conf(conf);
>> @@ -3290,6 +3320,7 @@ static int raid1_run(struct mddev *mddev)
>>         rcu_assign_pointer(conf->thread, NULL);
>>         mddev->private = conf;
>>         set_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
>> +       update_lastdev(conf);
>>
>>         md_set_array_sectors(mddev, raid1_size(mddev, 0, 0));
>>
>> @@ -3427,6 +3458,7 @@ static int raid1_reshape(struct mddev *mddev)
>>
>>         spin_lock_irqsave(&conf->device_lock, flags);
>>         mddev->degraded += (raid_disks - conf->raid_disks);
>> +       update_lastdev(conf);
>>         spin_unlock_irqrestore(&conf->device_lock, flags);
>>         conf->raid_disks = mddev->raid_disks = raid_disks;
>>         mddev->delta_disks = 0;
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index b60c30bfb6c7..dc4edd4689f8 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1983,6 +1983,33 @@ static int enough(struct r10conf *conf, int ignore)
>>                 _enough(conf, 1, ignore);
>>  }
>>
>> +/**
>> + * update_lastdev - Set or clear LastDev flag for all rdevs in array
>> + * @conf: pointer to r10conf
>> + *
>> + * Sets LastDev if the device is In_sync and cannot be lost for the array.
>> + * Otherwise, clear it.
>> + *
>> + * Caller must hold ->reconfig_mutex or ->device_lock.
>> + */
>> +static void update_lastdev(struct r10conf *conf)
>> +{
>> +       int i;
>> +       int raid_disks = max(conf->geo.raid_disks, conf->prev.raid_disks);
>> +
>> +       for (i = 0; i < raid_disks; i++) {
>> +               struct md_rdev *rdev = conf->mirrors[i].rdev;
>> +
>> +               if (rdev) {
>> +                       if (test_bit(In_sync, &rdev->flags) &&
>> +                           !enough(conf, i))
>> +                               set_bit(LastDev, &rdev->flags);
>> +                       else
>> +                               clear_bit(LastDev, &rdev->flags);
>> +               }
>> +       }
>> +}
>> +
>>  /**
>>   * raid10_error() - RAID10 error handler.
>>   * @mddev: affected md device.
>> @@ -2013,8 +2040,10 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>>                         return;
>>                 }
>>         }
>> -       if (test_and_clear_bit(In_sync, &rdev->flags))
>> +       if (test_and_clear_bit(In_sync, &rdev->flags)) {
>>                 mddev->degraded++;
>> +               update_lastdev(conf);
>> +       }
>>
>>         set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>         set_bit(Blocked, &rdev->flags);
>> @@ -2102,6 +2131,7 @@ static int raid10_spare_active(struct mddev *mddev)
>>         }
>>         spin_lock_irqsave(&conf->device_lock, flags);
>>         mddev->degraded -= count;
>> +       update_lastdev(conf);
>>         spin_unlock_irqrestore(&conf->device_lock, flags);
>>
>>         print_conf(conf);
>> @@ -4159,6 +4189,7 @@ static int raid10_run(struct mddev *mddev)
>>         md_set_array_sectors(mddev, size);
>>         mddev->resync_max_sectors = size;
>>         set_bit(MD_FAILFAST_SUPPORTED, &mddev->flags);
>> +       update_lastdev(conf);
>>
>>         if (md_integrity_register(mddev))
>>                 goto out_free_conf;
>> @@ -4567,6 +4598,7 @@ static int raid10_start_reshape(struct mddev *mddev)
>>          */
>>         spin_lock_irq(&conf->device_lock);
>>         mddev->degraded = calc_degraded(conf);
>> +       update_lastdev(conf);
>>         spin_unlock_irq(&conf->device_lock);
>>         mddev->raid_disks = conf->geo.raid_disks;
>>         mddev->reshape_position = conf->reshape_progress;
>> --
>> 2.50.1
>>
>>
> 
> 


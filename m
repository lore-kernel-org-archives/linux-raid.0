Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21EB11FBEB9
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 08:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757924437; cv=none; b=VQkSSeQzaeI6xeOBc1YKvfLNWM9sK3KjWHtSRaSUZpFtqmzvDYI0ImMqhQeLVr936IOfwj6XHWPYGuNnWwXKOVEri1P6BtQ0FvLKzNWc4oaRA473sL2K8WrXhPCToCLri4UOyMlitRxq45skDiw7d8+DmrwqRcwk1p2kGsPFVmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757924437; c=relaxed/simple;
	bh=2HOBMxoqlOC0BaSpoWPJBKoJc482GK9h/fVAiHbibug=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=B7MYKk4i15cOVgLBGtZjO1pVw6Z1hkdIuO/b94dNWwYIzbXK0XF1hJu1o7UoIKXgePe5RRrpQc1F/ozMkd+P2BqoaqpycNESXdLtKdzZycQey1SqZEyNM54Q6zOUvwhKIGCMs19i+GqX/HKIvWcAclE2PMosfRHx7ie/f79ChJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=mgml.me; dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b=DDWdF5qD; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mgml.me header.i=@mgml.me header.b="DDWdF5qD"
Received: from NEET (p3772120-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.15.213.120])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58F8Jo2b015313
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 15 Sep 2025 17:19:50 +0900 (JST)
	(envelope-from k@mgml.me)
DKIM-Signature: a=rsa-sha256; bh=NwsdKi3QQSMhItmAL8kpbE/nwv0wh/koiSYbd6Ijq5o=;
        c=relaxed/relaxed; d=mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250315; t=1757924390; v=1;
        b=DDWdF5qDa7+uVJw7/pws7esQPw4bayUJfE2Z1J3imwGFpLTmgL6IRh07tkSHsJJf
         hkac1621kpnS0Getc/VK90K3xElAigU+SYVgacnl6CugZZhmhFbmRXZy3ClhSMJx
         ORbodJS16ataUjniGDwZjkEHwq/IWPpWE8vbieNOqWpItQ53kYFHs1tMgNxI0qMk
         vQiMalRgGo8VymePCVWWmYLXscdbpWXBF4V7eG2A8JcAjgt2NTc8Rj/ktl2rVks4
         06Q6hUid0mCGkngsrDOrCxOrnIk6grOEwy97L57eGp41tSnR+i/4gpEiMuBWal4U
         kfFV4Jl7z+rnR1/Y89+LuQ==
Message-ID: <7c427515-9ba0-4d12-928f-4acb79b68f6d@mgml.me>
Date: Mon, 15 Sep 2025 17:19:50 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
        Mariusz Tkaczyk <mtkaczyk@kernel.org>, Shaohua Li <shli@fb.com>,
        Guoqing Jiang <jgq516@gmail.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kenta Akagi <k@mgml.me>
Subject: Re: [PATCH v4 9/9] md/raid1,raid10: Fix: Operation continuing on 0
 devices.
To: Paul Menzel <pmenzel@molgen.mpg.de>
References: <20250915034210.8533-1-k@mgml.me>
 <20250915034210.8533-10-k@mgml.me>
 <b1487963-a07e-4850-98f7-0eda07c31214@molgen.mpg.de>
Content-Language: en-US
From: Kenta Akagi <k@mgml.me>
In-Reply-To: <b1487963-a07e-4850-98f7-0eda07c31214@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,
Thank you for reviewing.

On 2025/09/15 16:19, Paul Menzel wrote:
> Dear Kenta,
> 
> 
> Thank you for your patch, and well-written commit message and test. Reading just the summary, I didn’t know what it’s about. Should you resend, maybe:
> 
>> md/raid1,raid10: Fix logging `Operation continuing on 0 devices.`

Understood.
I'll fix commit message and title as you advised.

> 
> Am 15.09.25 um 05:42 schrieb Kenta Akagi:
>> Since commit 9a567843f7ce ("md: allow last device to be forcibly
>> removed from RAID1/RAID10."), RAID1/10 arrays can now lose all rdevs.
>>
>> Before that commit, losing the array last rdev or reaching the end of
>> the function without early return in raid{1,10}_error never occurred.
>> However, both situations can occur in the current implementation.
>>
>> As a result, when mddev->fail_last_dev is set, a spurious pr_crit
>> message can be printed.
>>
>> This patch prevents "Operation continuing" printed if the array
>> is not operational.
>>
>> root@fedora:~# mdadm --create --verbose /dev/md0 --level=1 \
>> --raid-devices=2  /dev/loop0 /dev/loop1
>> mdadm: Note: this array has metadata at the start and
>>      may not be suitable as a boot device.  If you plan to
>>      store '/boot' on this device please ensure that
>>      your boot-loader understands md/v1.x metadata, or use
>>      --metadata=0.90
>> mdadm: size set to 1046528K
>> Continue creating array? y
>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md0 started.
>> root@fedora:~# echo 1 > /sys/block/md0/md/fail_last_dev
>> root@fedora:~# mdadm --fail /dev/md0 loop0
>> mdadm: set loop0 faulty in /dev/md0
>> root@fedora:~# mdadm --fail /dev/md0 loop1
>> mdadm: set device faulty failed for loop1:  Device or resource busy
>> root@fedora:~# dmesg | tail -n 4
>> [ 1314.359674] md/raid1:md0: Disk failure on loop0, disabling device.
>>                 md/raid1:md0: Operation continuing on 1 devices.
>> [ 1315.506633] md/raid1:md0: Disk failure on loop1, disabling device.
>>                 md/raid1:md0: Operation continuing on 0 devices.
> 
> Shouldn’t the first line of the critical log still be printed, but your patch would remove it?
> 

"Operation continuing on 1 devices." will remain after this patch.
"Operation continuing on 0 devices." will be removed.

I thought that since Patch 8 in this series introduces the message
"Cannot continue operation", the message "Continuing operation on 0 devices"
would no longer be necessary.

However, the conditions under which the messages are output differ slightly.
"Cannot continue operation" is output when md_error is called on the last
rdev and MD_BROKEN is set.
"Operation continuing on 0 devices." is output when, after md_error is called
on the last rdev and MD_BROKEN is set, the rdev becomes Faulty because
fail_last_dev is set. In both cases, there is no difference in the fact that
the array cannot operate normally, but the state of the rdevs and whether it
can still be read are different.

Would it be better to only adjust the message itself?
e.g. "Operation cannot continue, there are 0 devices."
Or, since setting fail_last_dev is presumably done only by power users,
perhaps it is acceptable to leave this odd "continuing on 0 device" message as is.

Thanks,
Akagi

>> root@fedora:~#
>>
>> Fixes: 9a567843f7ce ("md: allow last device to be forcibly removed from RAID1/RAID10.")
>> Signed-off-by: Kenta Akagi <k@mgml.me>
>> ---
>>   drivers/md/raid1.c  | 9 +++++----
>>   drivers/md/raid10.c | 9 +++++----
>>   2 files changed, 10 insertions(+), 8 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index febe2849a71a..b3c845855841 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1803,6 +1803,11 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>           update_lastdev(conf);
>>       }
>>       set_bit(Faulty, &rdev->flags);
>> +    if ((conf->raid_disks - mddev->degraded) > 0)
>> +        pr_crit("md/raid1:%s: Disk failure on %pg, disabling device.\n"
>> +            "md/raid1:%s: Operation continuing on %d devices.\n",
>> +            mdname(mddev), rdev->bdev,
>> +            mdname(mddev), conf->raid_disks - mddev->degraded);
>>       spin_unlock_irqrestore(&conf->device_lock, flags);
>>       /*
>>        * if recovery is running, make sure it aborts.
>> @@ -1810,10 +1815,6 @@ static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>       set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>       set_mask_bits(&mddev->sb_flags, 0,
>>                 BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
>> -    pr_crit("md/raid1:%s: Disk failure on %pg, disabling device.\n"
>> -        "md/raid1:%s: Operation continuing on %d devices.\n",
>> -        mdname(mddev), rdev->bdev,
>> -        mdname(mddev), conf->raid_disks - mddev->degraded);
>>   }
>>     static void print_conf(struct r1conf *conf)
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index be5fd77da3e1..4f3ef43ebd2a 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -2059,11 +2059,12 @@ static void raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>>       set_bit(Faulty, &rdev->flags);
>>       set_mask_bits(&mddev->sb_flags, 0,
>>                 BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
>> +    if (enough(conf, -1))
>> +        pr_crit("md/raid10:%s: Disk failure on %pg, disabling device.\n"
>> +            "md/raid10:%s: Operation continuing on %d devices.\n",
>> +            mdname(mddev), rdev->bdev,
>> +            mdname(mddev), conf->geo.raid_disks - mddev->degraded);
>>       spin_unlock_irqrestore(&conf->device_lock, flags);
>> -    pr_crit("md/raid10:%s: Disk failure on %pg, disabling device.\n"
>> -        "md/raid10:%s: Operation continuing on %d devices.\n",
>> -        mdname(mddev), rdev->bdev,
>> -        mdname(mddev), conf->geo.raid_disks - mddev->degraded);
>>   }
>>     static void print_conf(struct r10conf *conf)
> 
> 
> Kind regards,
> 
> Paul
> 


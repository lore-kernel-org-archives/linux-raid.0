Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2BB18DF9C
	for <linux-raid@vger.kernel.org>; Tue, 30 Jul 2024 20:42:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.222.135.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722372157; cv=none; b=XdkOZhKcJqWUT81HiUU0ibLFFxgQtSNfAN0Jyd9hJwqygzxXZBuLH+zN9O3ktYDbdQy56D4Eal4BBcOKRX7G+JCfSgsuQBSXYV2tF4/wP1hvjLQsl0JyiLz0m3A/kM3++BPn3fXYJRHegffFPqp2gZAhn5UfQ55Piy+ATubsQNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722372157; c=relaxed/simple;
	bh=XVZkvr8rRK1fFs58uRtlrNGnzD6sb3MOuVh+AvEFx1A=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=V0+a1G7lTuIrfbZD5tP4cjhD42q+MTwRcMP95vE0cLGUxx3xcoJeSMcgxXhMzLzHUYk7yGpCRjnqL/g079YjWtO1dYp8W6IAfoxvjl5f6PdzetSD7hpa5KAa2aLGOrmqI4B2WtS7pzNRTX7O/wXfFQnP7Z14GRS0+12dsjDJwr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl; spf=pass smtp.mailfrom=o2.pl; dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b=EnFIPKC+; arc=none smtp.client-ip=193.222.135.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b="EnFIPKC+"
Received: (wp-smtpd smtp.tlen.pl 38704 invoked from network); 30 Jul 2024 22:35:51 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1722371752; bh=XVZkvr8rRK1fFs58uRtlrNGnzD6sb3MOuVh+AvEFx1A=;
          h=Subject:From:To:Cc;
          b=EnFIPKC+Rtb518OCwjia/+Ix/LiFdrgtUuOLjeLT0VxItTdokZhEafo1bALnFmmhE
           KnWZUMeLUqsl+ekJ3w6F+KD52oJ5y4nmKQyli+Jwh26Roht4GxpgRapFNjAs1mAq54
           b5clI3HA0/hW2fBDll0kwdBwjWxrD57SpT+62Qlg=
Received: from aaen12.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.117.12])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <paul.e.luse@linux.intel.com>; 30 Jul 2024 22:35:51 +0200
Message-ID: <3f2b66d4-8d4e-440b-b67e-1665925c359c@o2.pl>
Date: Tue, 30 Jul 2024 22:35:49 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] Filesystem corruption when adding a new RAID device
 (delayed-resync, write-mostly)
From: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
To: Paul E Luse <paul.e.luse@linux.intel.com>
Cc: linux-raid@vger.kernel.org, Yu Kuai <yukuai3@huawei.com>,
 linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>,
 regressions@lists.linux.dev,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl>
 <ce95e64c-1a67-4a92-984a-c1eab0894857@o2.pl>
 <f28f9eec-d318-46e2-b2a1-430c9302ba43@o2.pl>
 <20240724141906.10b4fc4e@peluse-desk5>
 <2123BF84-5F16-4938-915B-B1EE0931AC03@o2.pl>
 <20240725072742.1664beec@peluse-desk5>
 <713ce46b-8751-49fb-b61f-2eb3e19459dc@o2.pl>
Content-Language: en-GB
Autocrypt: addr=mat.jonczyk@o2.pl; keydata=
 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
 TANkZ3QqXNX2
In-Reply-To: <713ce46b-8751-49fb-b61f-2eb3e19459dc@o2.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: db89ae2a4c4e0c6ebb362d93f9e08e3b
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [MRPF]                               

W dniu 28.07.2024 o 12:30, Mateusz Jończyk pisze:
> W dniu 25.07.2024 o 16:27, Paul E Luse pisze:
>> On Thu, 25 Jul 2024 09:15:40 +0200
>> Mateusz Jończyk <mat.jonczyk@o2.pl> wrote:
>>
>>> Dnia 24 lipca 2024 23:19:06 CEST, Paul E Luse
>>> <paul.e.luse@linux.intel.com> napisał/a:
>>>> On Wed, 24 Jul 2024 22:35:49 +0200
>>>> Mateusz Jończyk <mat.jonczyk@o2.pl> wrote:
>>>>
>>>>> W dniu 22.07.2024 o 07:39, Mateusz Jończyk pisze:
>>>>>> W dniu 20.07.2024 o 16:47, Mateusz Jończyk pisze:
>>>>>>> Hello,
>>>>>>>
>>>>>>> In my laptop, I used to have two RAID1 arrays on top of NVMe and
>>>>>>> SATA SSD drives: /dev/md0 for /boot (not partitioned), /dev/md1
>>>>>>> for remaining data (LUKS
>>>>>>> + LVM + ext4). For performance, I have marked the RAID component
>>>>>>> device for /dev/md1 on the SATA SSD drive write-mostly, which
>>>>>>> "means that the 'md' driver will avoid reading from these
>>>>>>> devices if at all possible" (man mdadm).
>>>>>>>
>>>>>>> Recently, the NVMe drive started having problems (PCI AER errors
>>>>>>> and the controller disappearing), so I removed it from the
>>>>>>> arrays and wiped it. However, I have reseated the drive in the
>>>>>>> M.2 socket and this apparently fixed it (verified with tests).
>>>>>>>
>>>>>>>     $ cat /proc/mdstat
>>>>>>>     Personalities : [raid1] [linear] [multipath] [raid0] [raid6]
>>>>>>> [raid5] [raid4] [raid10] md1 : active raid1 sdb5[1](W)
>>>>>>>           471727104 blocks super 1.2 [2/1] [_U]
>>>>>>>           bitmap: 4/4 pages [16KB], 65536KB chunk
>>>>>>>
>>>>>>>     md2 : active (auto-read-only) raid1 sdb6[3](W) sda1[2]
>>>>>>>           3142656 blocks super 1.2 [2/2] [UU]
>>>>>>>           bitmap: 0/1 pages [0KB], 65536KB chunk
>>>>>>>
>>>>>>>     md0 : active raid1 sdb4[3]
>>>>>>>           2094080 blocks super 1.2 [2/1] [_U]
>>>>>>>          
>>>>>>>     unused devices: <none>
>>>>>>>
>>>>>>> (md2 was used just for testing, ignore it).
>>>>>>>
>>>>>>> Today, I have tried to add the drive back to the arrays by
>>>>>>> using a script that executed in quick succession:
>>>>>>>
>>>>>>>     mdadm /dev/md0 --add --readwrite /dev/nvme0n1p2
>>>>>>>     mdadm /dev/md1 --add --readwrite /dev/nvme0n1p3
>>>>>>>
>>>>>>> This was on Linux 6.10.0, patched with my previous patch:
>>>>>>>
>>>>>>>     https://lore.kernel.org/linux-raid/20240711202316.10775-1-mat.jonczyk@o2.pl/
>>>>>>>
>>>>>>> (which fixed a regression in the kernel and allows it to start
>>>>>>> /dev/md1 with a single drive in write-mostly mode).
>>>>>>> In the background, I was running "rdiff-backup --compare" that
>>>>>>> was comparing data between my array contents and a backup
>>>>>>> attached via USB.
>>>>>>>
>>>>>>> This, however resulted in mayhem - I was unable to start any
>>>>>>> program with an input-output error, etc. I used SysRQ + C to
>>>>>>> save a kernel log:
>>>>>>>
>>>>> Hello,
>>>>>
>>>>> Unfortunately, hardware failure seems not to be the case.
>>>>>
>>>>> I did test it again on 6.10, twice, and in both cases I got
>>>>> filesystem corruption (but not as severe).
>>>>>
>>>>> On Linux 6.1.96 it seems to be working well (also did two tries).
>>>>>
>>>>> Please note: in my tests, I was using a RAID component device with
>>>>> a write-mostly bit set. This setup does not work on 6.9+ out of the
>>>>> box and requires the following patch:
>>>>>
>>>>> commit 36a5c03f23271 ("md/raid1: set max_sectors during early
>>>>> return from choose_slow_rdev()")
>>>>>
>>>>> that is in master now.
>>>>>
>>>>> It is also heading into stable, which I'm going to interrupt.
> Hello,
>
> With much effort (challenging to reproduce reliably) I think have nailed down the issue to the read_balance refactoring series in 6.9:
[snip]
> After code analysis, I have noticed that the following check that was present in old
> read_balance() is not present (in equivalent form in the new code):
>
>                 if (!test_bit(In_sync, &rdev->flags) &&
>                     rdev->recovery_offset < this_sector + sectors)
>                         continue;
>
> (in choose_slow_rdev() and choose_first_rdev() and possibly other functions)
>
> which would cause the kernel to read from the device being synced to before
> it is ready.

Hello,

I think have made a reliable (and safe) reproducer for this bug:

Prerequisite: create an array on top of 2 devices 1GB+ large:

mdadm --create /dev/md4 --level=1 --raid-devices=2 /dev/nvme0n1p5 --write-mostly /dev/sdb8
The script:
-------------------------------8<------------------------

#!/bin/bash

mdadm /dev/md4 --fail /dev/nvme0n1p5
sleep 1
mdadm /dev/md4 --remove failed
sleep 1

# fill with random data
shred -n1 -v /dev/md4
# fill with zeros
shred -n0 -zv /dev/nvme0n1p5

sha256sum /dev/md4

echo 1 > /proc/sys/vm/drop_caches

date

# calculate a shasum while the array is being synced
( sha256sum /dev/md4; date ) &
mdadm /dev/md4 --add --readwrite /dev/nvme0n1p5
date

-------------------------------8<------------------------

The two shasums should be equal, but they were different in my tests on affected kernels.

Also, in my tests with the script, *without* a write-mostly device in the array, the problems did not happen.

Greetings,

Mateusz


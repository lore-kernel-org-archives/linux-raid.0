Received: from mx-out.tlen.pl (mx-out.tlen.pl [193.222.135.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F274BA20
	for <linux-raid@vger.kernel.org>; Sun, 28 Jul 2024 10:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.222.135.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722162617; cv=none; b=XaGUvZNfhWANtp6nTL2FNr1Nvt6BntiMAd4teDmXAw4s/UfD0Gpy/Ve3TMjP0Y1SHwLMbVLN6SMbkNWtZkJv/vTMN0GtXNOWaYrXXHrI6AGlDA0jsa0vgvV1MQCtB4aTHhFS+DP8ZBalt20UjoqIE+NvTdhJ1swg4JvGOMZqLsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722162617; c=relaxed/simple;
	bh=ltQ3anKKiP7pr+Wvk0Q+1fGeuvz0Iyao5QbFcaA2J7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Iz5oXB9oIIxy10fqMpVMYfeCzijCNLHEJcDVOYtYviZwjqs5LL8y2nT+HNMfA/a2SqkQmUKpu22IjJax3BMaBUaBcZII7EcMVIh6UePWEiL9jzfn0ABGDiILyILiaoMfgeGNRkYsjzGAnSSUT1VGvgemBpiWGCX7/cq+oN9kOmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl; spf=pass smtp.mailfrom=o2.pl; dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b=lbjZR01A; arc=none smtp.client-ip=193.222.135.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=o2.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=o2.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=o2.pl header.i=@o2.pl header.b="lbjZR01A"
Received: (wp-smtpd smtp.tlen.pl 46799 invoked from network); 28 Jul 2024 12:30:05 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=o2.pl; s=1024a;
          t=1722162605; bh=ltQ3anKKiP7pr+Wvk0Q+1fGeuvz0Iyao5QbFcaA2J7k=;
          h=Subject:To:Cc:From;
          b=lbjZR01AArlynDlpGYaIdgySJbFc/n2+UoWLot0POQvRPu7XD97xMFD3bKaTFOKcF
           o3oIz73mk17tvU2HiTFX2w22MUHTD38m/eynHIrLE+FnO2xmghEVWpfbg4mtYDQDKL
           QOVf4FpZbH0D1zaYQOZtCLiHRHXjAOEZD1ZOtTjk=
Received: from aaen12.neoplus.adsl.tpnet.pl (HELO [192.168.1.22]) (mat.jonczyk@o2.pl@[83.4.117.12])
          (envelope-sender <mat.jonczyk@o2.pl>)
          by smtp.tlen.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <paul.e.luse@linux.intel.com>; 28 Jul 2024 12:30:05 +0200
Message-ID: <713ce46b-8751-49fb-b61f-2eb3e19459dc@o2.pl>
Date: Sun, 28 Jul 2024 12:30:02 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] Filesystem corruption when adding a new RAID device
 (delayed-resync, write-mostly)
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
Content-Language: en-GB
From: =?UTF-8?Q?Mateusz_Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Autocrypt: addr=mat.jonczyk@o2.pl; keydata=
 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
 TANkZ3QqXNX2
In-Reply-To: <20240725072742.1664beec@peluse-desk5>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-WP-MailID: 53919b6df59c911850cfe96872e6b6be
X-WP-AV: skaner antywirusowy Poczty o2
X-WP-SPAM: NO 0000000 [kfOQ]                               

W dniu 25.07.2024 o 16:27, Paul E Luse pisze:
> On Thu, 25 Jul 2024 09:15:40 +0200
> Mateusz Jończyk <mat.jonczyk@o2.pl> wrote:
>
>> Dnia 24 lipca 2024 23:19:06 CEST, Paul E Luse
>> <paul.e.luse@linux.intel.com> napisał/a:
>>> On Wed, 24 Jul 2024 22:35:49 +0200
>>> Mateusz Jończyk <mat.jonczyk@o2.pl> wrote:
>>>
>>>> W dniu 22.07.2024 o 07:39, Mateusz Jończyk pisze:
>>>>> W dniu 20.07.2024 o 16:47, Mateusz Jończyk pisze:
>>>>>> Hello,
>>>>>>
>>>>>> In my laptop, I used to have two RAID1 arrays on top of NVMe and
>>>>>> SATA SSD drives: /dev/md0 for /boot (not partitioned), /dev/md1
>>>>>> for remaining data (LUKS
>>>>>> + LVM + ext4). For performance, I have marked the RAID component
>>>>>> device for /dev/md1 on the SATA SSD drive write-mostly, which
>>>>>> "means that the 'md' driver will avoid reading from these
>>>>>> devices if at all possible" (man mdadm).
>>>>>>
>>>>>> Recently, the NVMe drive started having problems (PCI AER errors
>>>>>> and the controller disappearing), so I removed it from the
>>>>>> arrays and wiped it. However, I have reseated the drive in the
>>>>>> M.2 socket and this apparently fixed it (verified with tests).
>>>>>>
>>>>>>     $ cat /proc/mdstat
>>>>>>     Personalities : [raid1] [linear] [multipath] [raid0] [raid6]
>>>>>> [raid5] [raid4] [raid10] md1 : active raid1 sdb5[1](W)
>>>>>>           471727104 blocks super 1.2 [2/1] [_U]
>>>>>>           bitmap: 4/4 pages [16KB], 65536KB chunk
>>>>>>
>>>>>>     md2 : active (auto-read-only) raid1 sdb6[3](W) sda1[2]
>>>>>>           3142656 blocks super 1.2 [2/2] [UU]
>>>>>>           bitmap: 0/1 pages [0KB], 65536KB chunk
>>>>>>
>>>>>>     md0 : active raid1 sdb4[3]
>>>>>>           2094080 blocks super 1.2 [2/1] [_U]
>>>>>>          
>>>>>>     unused devices: <none>
>>>>>>
>>>>>> (md2 was used just for testing, ignore it).
>>>>>>
>>>>>> Today, I have tried to add the drive back to the arrays by
>>>>>> using a script that executed in quick succession:
>>>>>>
>>>>>>     mdadm /dev/md0 --add --readwrite /dev/nvme0n1p2
>>>>>>     mdadm /dev/md1 --add --readwrite /dev/nvme0n1p3
>>>>>>
>>>>>> This was on Linux 6.10.0, patched with my previous patch:
>>>>>>
>>>>>>     https://lore.kernel.org/linux-raid/20240711202316.10775-1-mat.jonczyk@o2.pl/
>>>>>>
>>>>>> (which fixed a regression in the kernel and allows it to start
>>>>>> /dev/md1 with a single drive in write-mostly mode).
>>>>>> In the background, I was running "rdiff-backup --compare" that
>>>>>> was comparing data between my array contents and a backup
>>>>>> attached via USB.
>>>>>>
>>>>>> This, however resulted in mayhem - I was unable to start any
>>>>>> program with an input-output error, etc. I used SysRQ + C to
>>>>>> save a kernel log:
>>>>>>
>>>> Hello,
>>>>
>>>> Unfortunately, hardware failure seems not to be the case.
>>>>
>>>> I did test it again on 6.10, twice, and in both cases I got
>>>> filesystem corruption (but not as severe).
>>>>
>>>> On Linux 6.1.96 it seems to be working well (also did two tries).
>>>>
>>>> Please note: in my tests, I was using a RAID component device with
>>>> a write-mostly bit set. This setup does not work on 6.9+ out of the
>>>> box and requires the following patch:
>>>>
>>>> commit 36a5c03f23271 ("md/raid1: set max_sectors during early
>>>> return from choose_slow_rdev()")
>>>>
>>>> that is in master now.
>>>>
>>>> It is also heading into stable, which I'm going to interrupt.

Hello,

With much effort (challenging to reproduce reliably) I think have nailed down the issue to the read_balance refactoring series in 6.9:

86b1e613eb3b Merge tag 'md-6.9-20240301' of https://git.kernel.org/pub/scm/linux/kernel/git/song/md into for-6.9/block e81faa91a580 Merge branch 'raid1-read_balance' into md-6.9 0091c5a269ec md/raid1:
factor out helpers to choose the best rdev from read_balance() ba58f57fdf98 md/raid1: factor out the code to manage sequential IO 9f3ced792203 md/raid1: factor out choose_bb_rdev() from read_balance()
dfa8ecd167c1 md/raid1: factor out choose_slow_rdev() from read_balance() 31a73331752d md/raid1: factor out read_first_rdev() from read_balance() f10920762955 md/raid1-10: factor out a new helper
raid1_should_read_first() f29841ff3b27 md/raid1-10: add a helper raid1_check_read_range() 257ac239ffcf md/raid1: fix choose next idle in read_balance() 2c27d09d3a76 md/raid1: record nonrot rdevs while
adding/removing rdevs to conf 969d6589abcb md/raid1: factor out helpers to add rdev to conf 3a0f007b6979 md: add a new helper rdev_has_badblock()

In particular, 86b1e613eb3b is definitely bad, and 13fe8e6825e4 is 95% good.

I was testing with the following two commits on top of the series to make this setup work for me:

commit 36a5c03f23271 ("md/raid1: set max_sectors during early return from choose_slow_rdev()") commit b561ea56a264 ("block: allow device to have both virt_boundary_mask and max segment size")

After code analysis, I have noticed that the following check that was present in old
read_balance() is not present (in equivalent form in the new code):

                if (!test_bit(In_sync, &rdev->flags) &&
                    rdev->recovery_offset < this_sector + sectors)
                        continue;

(in choose_slow_rdev() and choose_first_rdev() and possibly other functions)

which would cause the kernel to read from the device being synced to before
it is ready.

In my debug patch (I'll send in a while), I have copied the check to raid1_check_read_range and it seems
that the problems do not happen any longer with it.

I'm not so sure now that this bug is limited to write-mostly though - previous tests may have been unreliable.

#regzbot introduced: 13fe8e6825e4..86b1e613eb3b

#regzbot monitor: https://lore.kernel.org/lkml/20240724141906.10b4fc4e@peluse-desk5/T/#m671d6d3a7eda44d39d0882864a98824f52c52917

Greetings,

Mateusz


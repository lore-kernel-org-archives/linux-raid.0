Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884A98BEA;
	Wed, 31 Jul 2024 01:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722388269; cv=none; b=YBkXS90ewvjPHbzWvFgKVUqwqf9Ogof2R64NYq0Rs1axkyefGwx9bzu7i0rRDKXvya9pZfZwZvhETUdsywb2107Tol78u2e91XhA9YRyYFMEPq914xjkrqEI22pRUzDM27XYHVS+yvRt8Rq65K/cPdPjdA1yfLV2y+8xjn3lcHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722388269; c=relaxed/simple;
	bh=IIrXAHhSoz8qYRX6fqDUFXq+/tLxenTktb7r504tQ1I=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=G2lceHjGbDJ2HXym4lfJzM+Ft6I2IZZ0h42QnAU7gHpEF9K8JlHbF5HCqG+b8YhUsDMC46lD6ZdEAyinhE49WC7dLrzFQQH6xrp/cr689X0OlAllZaAHmC5u12wdG/bYq+jvQvCs5eSNrgNvR/YpZ8tOnNE/mtDpOUGZIuWvlfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4WYYv22f4Cz4f3jM1;
	Wed, 31 Jul 2024 09:10:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0676C1A07BB;
	Wed, 31 Jul 2024 09:11:03 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBXfoQjj6lmFbVTAQ--.38027S3;
	Wed, 31 Jul 2024 09:11:01 +0800 (CST)
Subject: Re: [REGRESSION] Filesystem corruption when adding a new RAID device
 (delayed-resync, write-mostly)
To: =?UTF-8?Q?Mateusz_Jo=c5=84czyk?= <mat.jonczyk@o2.pl>,
 Paul E Luse <paul.e.luse@linux.intel.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 Song Liu <song@kernel.org>, regressions@lists.linux.dev,
 Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <9952f532-2554-44bf-b906-4880b2e88e3a@o2.pl>
 <ce95e64c-1a67-4a92-984a-c1eab0894857@o2.pl>
 <f28f9eec-d318-46e2-b2a1-430c9302ba43@o2.pl>
 <20240724141906.10b4fc4e@peluse-desk5>
 <2123BF84-5F16-4938-915B-B1EE0931AC03@o2.pl>
 <20240725072742.1664beec@peluse-desk5>
 <713ce46b-8751-49fb-b61f-2eb3e19459dc@o2.pl>
 <3f2b66d4-8d4e-440b-b67e-1665925c359c@o2.pl>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <018dd7bf-e7f6-3561-a522-5dea143947eb@huaweicloud.com>
Date: Wed, 31 Jul 2024 09:10:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <3f2b66d4-8d4e-440b-b67e-1665925c359c@o2.pl>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXfoQjj6lmFbVTAQ--.38027S3
X-Coremail-Antispam: 1UD129KBjvJXoW3GF4fCF1kJrW8tF4fuF4rZrb_yoW7urWfpF
	yfJF13try8Jr18Jw1Dtr18GFyUtr1UJ3W5Wr1UJFyxZrnFvryjqF1UXr1FgryDArWrJr1U
	Xr15Jry7Zry5JF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21lc7CjxVAaw2AF
	wI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2N
	tUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/07/31 4:35, Mateusz Jończyk 写道:
> W dniu 28.07.2024 o 12:30, Mateusz Jończyk pisze:
>> W dniu 25.07.2024 o 16:27, Paul E Luse pisze:
>>> On Thu, 25 Jul 2024 09:15:40 +0200
>>> Mateusz Jończyk <mat.jonczyk@o2.pl> wrote:
>>>
>>>> Dnia 24 lipca 2024 23:19:06 CEST, Paul E Luse
>>>> <paul.e.luse@linux.intel.com> napisał/a:
>>>>> On Wed, 24 Jul 2024 22:35:49 +0200
>>>>> Mateusz Jończyk <mat.jonczyk@o2.pl> wrote:
>>>>>
>>>>>> W dniu 22.07.2024 o 07:39, Mateusz Jończyk pisze:
>>>>>>> W dniu 20.07.2024 o 16:47, Mateusz Jończyk pisze:
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> In my laptop, I used to have two RAID1 arrays on top of NVMe and
>>>>>>>> SATA SSD drives: /dev/md0 for /boot (not partitioned), /dev/md1
>>>>>>>> for remaining data (LUKS
>>>>>>>> + LVM + ext4). For performance, I have marked the RAID component
>>>>>>>> device for /dev/md1 on the SATA SSD drive write-mostly, which
>>>>>>>> "means that the 'md' driver will avoid reading from these
>>>>>>>> devices if at all possible" (man mdadm).
>>>>>>>>
>>>>>>>> Recently, the NVMe drive started having problems (PCI AER errors
>>>>>>>> and the controller disappearing), so I removed it from the
>>>>>>>> arrays and wiped it. However, I have reseated the drive in the
>>>>>>>> M.2 socket and this apparently fixed it (verified with tests).
>>>>>>>>
>>>>>>>>      $ cat /proc/mdstat
>>>>>>>>      Personalities : [raid1] [linear] [multipath] [raid0] [raid6]
>>>>>>>> [raid5] [raid4] [raid10] md1 : active raid1 sdb5[1](W)
>>>>>>>>            471727104 blocks super 1.2 [2/1] [_U]
>>>>>>>>            bitmap: 4/4 pages [16KB], 65536KB chunk
>>>>>>>>
>>>>>>>>      md2 : active (auto-read-only) raid1 sdb6[3](W) sda1[2]
>>>>>>>>            3142656 blocks super 1.2 [2/2] [UU]
>>>>>>>>            bitmap: 0/1 pages [0KB], 65536KB chunk
>>>>>>>>
>>>>>>>>      md0 : active raid1 sdb4[3]
>>>>>>>>            2094080 blocks super 1.2 [2/1] [_U]
>>>>>>>>           
>>>>>>>>      unused devices: <none>
>>>>>>>>
>>>>>>>> (md2 was used just for testing, ignore it).
>>>>>>>>
>>>>>>>> Today, I have tried to add the drive back to the arrays by
>>>>>>>> using a script that executed in quick succession:
>>>>>>>>
>>>>>>>>      mdadm /dev/md0 --add --readwrite /dev/nvme0n1p2
>>>>>>>>      mdadm /dev/md1 --add --readwrite /dev/nvme0n1p3
>>>>>>>>
>>>>>>>> This was on Linux 6.10.0, patched with my previous patch:
>>>>>>>>
>>>>>>>>      https://lore.kernel.org/linux-raid/20240711202316.10775-1-mat.jonczyk@o2.pl/
>>>>>>>>
>>>>>>>> (which fixed a regression in the kernel and allows it to start
>>>>>>>> /dev/md1 with a single drive in write-mostly mode).
>>>>>>>> In the background, I was running "rdiff-backup --compare" that
>>>>>>>> was comparing data between my array contents and a backup
>>>>>>>> attached via USB.
>>>>>>>>
>>>>>>>> This, however resulted in mayhem - I was unable to start any
>>>>>>>> program with an input-output error, etc. I used SysRQ + C to
>>>>>>>> save a kernel log:
>>>>>>>>
>>>>>> Hello,
>>>>>>
>>>>>> Unfortunately, hardware failure seems not to be the case.
>>>>>>
>>>>>> I did test it again on 6.10, twice, and in both cases I got
>>>>>> filesystem corruption (but not as severe).
>>>>>>
>>>>>> On Linux 6.1.96 it seems to be working well (also did two tries).
>>>>>>
>>>>>> Please note: in my tests, I was using a RAID component device with
>>>>>> a write-mostly bit set. This setup does not work on 6.9+ out of the
>>>>>> box and requires the following patch:
>>>>>>
>>>>>> commit 36a5c03f23271 ("md/raid1: set max_sectors during early
>>>>>> return from choose_slow_rdev()")
>>>>>>
>>>>>> that is in master now.
>>>>>>
>>>>>> It is also heading into stable, which I'm going to interrupt.
>> Hello,
>>
>> With much effort (challenging to reproduce reliably) I think have nailed down the issue to the read_balance refactoring series in 6.9:
> [snip]
>> After code analysis, I have noticed that the following check that was present in old
>> read_balance() is not present (in equivalent form in the new code):
>>
>>                  if (!test_bit(In_sync, &rdev->flags) &&
>>                      rdev->recovery_offset < this_sector + sectors)
>>                          continue;
>>
>> (in choose_slow_rdev() and choose_first_rdev() and possibly other functions)
>>
>> which would cause the kernel to read from the device being synced to before
>> it is ready.
> 
> Hello,
> 
> I think have made a reliable (and safe) reproducer for this bug:
> 
> Prerequisite: create an array on top of 2 devices 1GB+ large:
> 
> mdadm --create /dev/md4 --level=1 --raid-devices=2 /dev/nvme0n1p5 --write-mostly /dev/sdb8
> The script:
> -------------------------------8<------------------------
> 
> #!/bin/bash
> 
> mdadm /dev/md4 --fail /dev/nvme0n1p5
> sleep 1
> mdadm /dev/md4 --remove failed
> sleep 1
> 
> # fill with random data
> shred -n1 -v /dev/md4
> # fill with zeros
> shred -n0 -zv /dev/nvme0n1p5
> 
> sha256sum /dev/md4
> 
> echo 1 > /proc/sys/vm/drop_caches
> 
> date
> 
> # calculate a shasum while the array is being synced
> ( sha256sum /dev/md4; date ) &
> mdadm /dev/md4 --add --readwrite /dev/nvme0n1p5
> date
> 
> -------------------------------8<------------------------
> 
> The two shasums should be equal, but they were different in my tests on affected kernels.
> 
> Also, in my tests with the script, *without* a write-mostly device in the array, the problems did not happen.

Thanks for the test,

Can you send a new version of patch, and this test to mdadm?
Kuai

> 
> Greetings,
> 
> Mateusz
> 
> .
> 


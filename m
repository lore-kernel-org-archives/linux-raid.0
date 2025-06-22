Received: from ocaml.xvm.mit.edu (sipb-vm-99.mit.edu [18.25.128.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6B5186342
	for <linux-raid@vger.kernel.org>; Sun, 22 Jun 2025 18:03:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.25.128.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750615409; cv=none; b=PJ/vG01m0N9YwDueJk6eWrIhhj2I7KHk6wAnlg8MJjc1A9h8phZEuILwKP+Bd2ERdBMfgVdx+erkNJYb1OC0zT0idBvg0BQEpUZXi4IPVjicMTVCZ16Fg+stdyCqbdRNGj2WKG/fXNixyQkwavlwD6+if8Ut8dl/3FvvQJ5odFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750615409; c=relaxed/simple;
	bh=byzdJZErllRIiK3amKPx+CnjZvlslvU8cLOdlLawluk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=jmBUVlUkUp+dxW9nCf2UVWKYQ+7kqOxSxDgBtZngJfNHzANqwvwYdGfjbZ+jOjdOrMo6ThKPunUE5WauRZDNJOzs8v+SuS5ttHfFAgBsvextECd7wZLE4Ko/euAS+l6zPPIR/mLRgCYE3/itC8YApz8tgBAyB4RUaUQODHYCejQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xsdg.org; spf=pass smtp.mailfrom=xsdg.org; arc=none smtp.client-ip=18.25.128.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=xsdg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xsdg.org
Received: from 23-120-35-113.lightspeed.sntcca.sbcglobal.net ([23.120.35.113] helo=[192.168.1.60])
	by ocaml.xvm.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.97)
	(envelope-from <xsdg@xsdg.org>)
	id 1uTP2L-00000004qQq-0wxO;
	Sun, 22 Jun 2025 14:03:25 -0400
Message-ID: <c700ab1f-9e62-49a6-807c-3a37023a0b9e@xsdg.org>
Date: Sun, 22 Jun 2025 18:03:16 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Kernel mistakenly "starts" resync on fully-degraded,
 newly-created raid10 array
To: Wol <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
References: <b696bee2-3c10-45be-8f5a-be3c607d0676@xsdg.org>
 <7bccda92-7b27-44ed-a240-b124c99a3b53@youngman.org.uk>
Content-Language: en-US
From: Omari Stephens <xsdg@xsdg.org>
In-Reply-To: <7bccda92-7b27-44ed-a240-b124c99a3b53@youngman.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/22/25 09:30, Wol wrote:
> On 22/06/2025 02:39, Omari Stephens wrote:
>> I tried asking on Reddit, and ended up resolving the issue myself:
>> https://www.reddit.com/r/linuxquestions/comments/1lh9to0/ 
>> kernel_is_stuck_resyncing_a_4drive_raid10_array/
>>
>> I run Debian SID, and am using kernel 6.12.32-amd64
>>
>> #apt-cache policy linux-image-amd64
>> linux-image-amd64:
>>    Installed: 6.12.32-1
>>    Candidate: 6.12.32-1
>>    Version table:
>>   *** 6.12.32-1 500
>>          500 http://mirrors.kernel.org/debian unstable/main amd64 
>> Packages
>>          500 http://http.us.debian.org/debian unstable/main amd64 
>> Packages
>>          100 /var/lib/dpkg/status
>>
>> #uname -r
>> 6.12.32-amd64
>>
>> To summarize the issue and my diagnostic steps, I ran this command to 
>> create a new raid10 array:
>>
>> |#mdadm --create md13 --name=media --level=10 --layout=f2 -n 4 /dev/ 
>> sdb1 missing /dev/sdf1 missing|
>>
>> |At that point, /proc/mdstat showed the following, which makes no sense:|
>>
> Why doesn't it make any sense?
> 
> Don't forget a raid-10 in linux is NOT a two raid-0s in a raid-1, it's 
> its own thing entirely.

Understood.  I've been using Linux MD raid10 for over a decade.  I've 
read through this (and other references) in depth:
https://en.wikipedia.org/wiki/Non-standard_RAID_levels#Linux_MD_RAID_10

My question is this: Suppose you create a 4-drive array.  2 drives are 
missing.  What data is there to synchronize?  What should get copied 
where, or what should get recomputed and written where?

To my understanding, in that situation, each block in the array only 
appears in one place on the physical media, and there is no redundancy 
or parity for any block that could be out of sync.

When you read from the array, yes, you're going to get interleaved bits 
of whatever happened to be on the physical media to start with, but 
that's basically the same as reading directly from any new physical 
media -- it's not initialized until it's initialized, and until it is, 
you don't know what you're going to read.

> 
>> md127 : active raid10 sdb1[2] sdc1[0]
>>        23382980608 blocks super 1.2 512K chunks 2 far-copies [4/2] [U_U_]
>>        [>....................]  resync =  0.0% (8594688/23382980608) 
>> finish=25176161501.3min speed=0K/sec
>>        bitmap: 175/175 pages [700KB], 65536KB chunk
>>
>> With 2 drives present and 2 drives absent, the array can only start if 
>> the present drives are considered in sync.  The kernel spent most of a 
>> day in this state.  The
>> "8594688" count increased very slowly over time, but after 24 hours, 
>> it was only up to 0.1%.  During that time, I had mounted the array and 
>> transfered 11TB of data onto it.
> 
> I can't see any mention of drive size, so your % complete is 
> meaningless, but I would say my raid with about 12TB of disk takes a a 
> couple of days to sort itself out ...

The rate of resync completion was ~0.  The estimated time to completion 
was 17483445 _years_.  Again, my hypothesis is that this is because the 
system was confused and wasn't actually doing anything meaningful. 
(Although the md127_resync process was sitting at 100% cpu usage the 
entire time; no clue what it was spending those cycles on)

Here's my disk layout, currently, after successfully adding the last two 
drives:
$lsblk /dev/sda /dev/sdb /dev/sdc /dev/sde
NAME              MAJ:MIN RM   SIZE RO TYPE   MOUNTPOINTS
sda                 8:0    0  10.9T  0 disk
└─sda1              8:1    0  10.9T  0 part
   └─md127           9:127  0  21.8T  0 raid10
     ├─media_crypt 253:0    0  21.8T  0 crypt  /mnt/home_media
     └─md127p1     259:0    0 492.2G  0 part
sdb                 8:16   0  10.9T  0 disk
└─sdb1              8:17   0  10.9T  0 part
   └─md127           9:127  0  21.8T  0 raid10
     ├─media_crypt 253:0    0  21.8T  0 crypt  /mnt/home_media
     └─md127p1     259:0    0 492.2G  0 part
sdc                 8:32   0  10.9T  0 disk
└─sdc1              8:33   0  10.9T  0 part
   └─md127           9:127  0  21.8T  0 raid10
     ├─media_crypt 253:0    0  21.8T  0 crypt  /mnt/home_media
     └─md127p1     259:0    0 492.2G  0 part
sde                 8:64   0  10.9T  0 disk
└─sde1              8:65   0  10.9T  0 part
   └─md127           9:127  0  21.8T  0 raid10
     ├─media_crypt 253:0    0  21.8T  0 crypt  /mnt/home_media
     └─md127p1     259:0    0 492.2G  0 part

>>
>> Then when power-cycled, swapped SATA cables, and added the remaining 
>> drives, they were marked as spares and weren't added to the array 
>> (likely because the array was considered to be already resyncing):
>>
> I think you're right - if the array is already rebuilding, it can't 
> start a new, different rebuild half way through the old one ...
> 
>> #mdadm --detail /dev/md127
>> /dev/md127:
>> [...]
>>      Number   Major   Minor   RaidDevice State
>>         0       8       33        0      active sync   /dev/sdc1
>>         -       0        0        1      removed
>>         2       8       17        2      active sync   /dev/sdb1
>>         -       0        0        3      removed
>>
>>         4       8        1        -      spare   /dev/sda1
>>         5       8       65        -      spare   /dev/sde1
>>
>>
>> I ended up resolving the issue by recreating the array with --assume- 
>> clean:
>>
> Bad idea !!! It's okay, especially with new drives and a new array, but 
> it will leave the array in a random state. Not good ...
> 
>> #mdadm --create md19 --name=media3 --assume-clean --readonly -- 
>> level=10 --layout=f2 -n 4 /dev/sdc1 missing /dev/sdb1 missing
>> To optimalize recovery speed, it is recommended to enable write-indent 
>> bitmap, do you want to enable it now? [y/N]? y
>> mdadm: /dev/sdc1 appears to be part of a raid array:
>>         level=raid10 devices=4 ctime=Sun Jun 22 00:51:33 2025
>> mdadm: /dev/sdb1 appears to be part of a raid array:
>>         level=raid10 devices=4 ctime=Sun Jun 22 00:51:33 2025
>> Continue creating array [y/N]? y
>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md/md19 started.
>>
>> #cat /proc/mdstat
>> Personalities : [raid1] [raid10] [raid0] [raid6] [raid5] [raid4]
>> md127 : active (read-only) raid10 sdb1[2] sdc1[0]
>>        23382980608 blocks super 1.2 512K chunks 2 far-copies [4/2] [U_U_]
>>        bitmap: 175/175 pages [700KB], 65536KB chunk
>>
>> At which point, I was able to add the new devices and have the array 
>> (start to) resync as expected:
>>
> Yup. Now the two-drive array is not resyncing, the new drives can be 
> added and will resync.
> 
>> #mdadm --manage /dev/md127 --add /dev/sda1 --add /dev/sde1
>> mdadm: added /dev/sda1
>> mdadm: added /dev/sde1
>>
>> #cat /proc/mdstat
>> Personalities : [raid1] [raid10] [raid0] [raid6] [raid5] [raid4]
>> md127 : active raid10 sde1[5] sda1[4] sdc1[0] sdb1[2]
>>        23382980608 blocks super 1.2 512K chunks 2 far-copies [4/2] [U_U_]
>>        [>....................]  recovery =  0.0% (714112/11691490304) 
>> finish=1091.3min speed=178528K/sec
>>        bitmap: 0/175 pages [0KB], 65536KB chunk
>>
>> #mdadm --detail /dev/md127
>> /dev/md127:
>> [...]
>>      Number   Major   Minor   RaidDevice State
>>         0       8       33        0      active sync   /dev/sdc1
>>         5       8       65        1      spare rebuilding   /dev/sde1
>>         2       8       17        2      active sync   /dev/sdb1
>>         4       8        1        3      spare rebuilding   /dev/sda1
>>
>> --xsdg
>>
>>
> Now you have an array where anything you have written will be okay 
> (which I guess is what you care about), but the rest of the disk is 
> uninitialised garbage that will instantly trigger a read fault if you 
> try to read it.

Because these happen to be brand new (but pre-zeroed) hard disks, it 
happens that the initialized state is all zeroes.  Where would the read 
fault come from, though?  What is there to be out of sync?  raid10 has 
no parity, and there's no redundancy across 2 disks in a 4-disk raid10.

#dd if=/dev/md127 bs=1 skip=20T count=1M | hd
00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
|................|
*
00100000
1048576+0 records in
1048576+0 records out
1048576 bytes (1.0 MB, 1.0 MiB) copied, 1.37091 s, 765 kB/s

And to be clear, that's way past where the resync status is right now:
$cat /proc/mdstat
Personalities : [raid1] [raid10] [raid0] [raid6] [raid5] [raid4]
md127 : active raid10 sde1[5] sda1[4] sdc1[0] sdb1[2]
       23382980608 blocks super 1.2 512K chunks 2 far-copies [4/2] [U_U_]
       [=============>.......]  recovery = 69.8% 
(8170708928/11691490304) finish=415.6min speed=141166K/sec
       bitmap: 13/175 pages [52KB], 65536KB chunk

--xsdg

> 
> You need to set off a scrub, which will do those reads and get the array 
> itself (not just your data) into a sane state.
> 
> https://archive.kernel.org/oldwiki/raid.wiki.kernel.org/
> 
> Ignore the obsolete content crap. Somebody clearly thinks that replacing 
> USER documentation by double-dutch programmer documentation (aimed at a 
> completely different audience) is a good idea ...
> 
> Cheers,
> Wol


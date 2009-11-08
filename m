From: Andrew Dunn <andrew.g.dunn@gmail.com>
Subject: Re: RAID 6 Failure follow up
Date: Sun, 08 Nov 2009 09:30:21 -0500
Message-ID: <4AF6D5FD.2010602@gmail.com>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D461.3050109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF6D461.3050109@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>, robin@robinhill.me.uk
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

storrgie@ALEXANDRIA:~$ dmesg | grep sdi
[   31.019358] sd 11:0:0:0: [sdi] 1953525168 512-byte logical blocks:
(1.00 TB/931 GiB)
[   31.032233] sd 11:0:0:0: [sdi] Write Protect is off
[   31.032235] sd 11:0:0:0: [sdi] Mode Sense: 73 00 00 08
[   31.037483] sd 11:0:0:0: [sdi] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[   31.066991]  sdi:
[   31.075719]  sdi1
[   31.124713] sd 11:0:0:0: [sdi] Attached SCSI disk
[   31.147407] md: bind<sdi1>
[   31.712366] raid5: device sdi1 operational as raid disk 4
[   31.713153]  disk 4, o:1, dev:sdi1
[   33.112975]  disk 4, o:1, dev:sdi1
[  297.528544] sd 11:0:0:0: [sdi] Sense Key : Recovered Error [current]
[descriptor]
[  297.528573] sd 11:0:0:0: [sdi] Add. Sense: ATA pass through
information available
[  297.591382] sd 11:0:0:0: [sdi] Sense Key : Recovered Error [current]
[descriptor]
[  297.591407] sd 11:0:0:0: [sdi] Add. Sense: ATA pass through
information available

I don't see anything glaring.

You should be able to force an assembly anyway (using the --force flag)
but I'd make sure you know exactly what the issue is first, otherwise
this is likely to happen again.

Do you think that the controller is dropping out? I know that I have 4
drives on one controller (AOC-USAS-L8i) and 5 drives on the other
controller (SAME make/model). but I think they are sequentially
connected... as in sd[efghi] should be on one device and sd[jklm] should
be on the other... any easy way to verify?

Roger Heflin wrote:
> Andrew Dunn wrote:
>> This is kind of interesting:
>>
>> storrgie@ALEXANDRIA:~$ sudo mdadm --assemble --force /dev/md0
>> mdadm: no devices found for /dev/md0
>>
>> All of the devices are there in /dev, so I wanted to examine them:
>>
>> storrgie@ALEXANDRIA:~$ sudo mdadm --examine /dev/sde1
>> /dev/sde1:
>>           Magic : a92b4efc
>>         Version : 00.90.00
>>            UUID : 397e0b3f:34cbe4cc:613e2239:070da8c8 (local to host
>> ALEXANDRIA)
>>   Creation Time : Fri Nov  6 07:06:34 2009
>>      Raid Level : raid6
>>   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>>      Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
>>    Raid Devices : 9
>>   Total Devices : 9
>> Preferred Minor : 0
>>
>>     Update Time : Sun Nov  8 08:57:04 2009
>>           State : clean
>>  Active Devices : 5
>> Working Devices : 5
>>  Failed Devices : 4
>>   Spare Devices : 0
>>        Checksum : 4ff41c5f - correct
>>          Events : 43
>>
>>      Chunk Size : 1024K
>>
>>       Number   Major   Minor   RaidDevice State
>> this     0       8       65        0      active sync   /dev/sde1
>>
>>    0     0       8       65        0      active sync   /dev/sde1
>>    1     1       8       81        1      active sync   /dev/sdf1
>>    2     2       8       97        2      active sync   /dev/sdg1
>>    3     3       8      113        3      active sync   /dev/sdh1
>>    4     4       0        0        4      faulty removed
>>    5     5       0        0        5      faulty removed
>>    6     6       0        0        6      faulty removed
>>    7     7       0        0        7      faulty removed
>>    8     8       8      193        8      active sync   /dev/sdm1
>>
>> First raid device shows the failures....
>>
>> One of the 'removed' devices:
>>
>> storrgie@ALEXANDRIA:~$ sudo mdadm --examine /dev/sdi1
>> /dev/sdi1:
>>           Magic : a92b4efc
>>         Version : 00.90.00
>>            UUID : 397e0b3f:34cbe4cc:613e2239:070da8c8 (local to host
>> ALEXANDRIA)
>>   Creation Time : Fri Nov  6 07:06:34 2009
>>      Raid Level : raid6
>>   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>>      Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
>>    Raid Devices : 9
>>   Total Devices : 9
>> Preferred Minor : 0
>>
>>     Update Time : Sun Nov  8 08:53:30 2009
>>           State : active
>>  Active Devices : 9
>> Working Devices : 9
>>  Failed Devices : 0
>>   Spare Devices : 0
>>        Checksum : 4ff41b2f - correct
>>          Events : 21
>>
>>      Chunk Size : 1024K
>>
>>       Number   Major   Minor   RaidDevice State
>> this     4       8      129        4      active sync   /dev/sdi1
>>
>>    0     0       8       65        0      active sync   /dev/sde1
>>    1     1       8       81        1      active sync   /dev/sdf1
>>    2     2       8       97        2      active sync   /dev/sdg1
>>    3     3       8      113        3      active sync   /dev/sdh1
>>    4     4       8      129        4      active sync   /dev/sdi1
>>    5     5       8      145        5      active sync   /dev/sdj1
>>    6     6       8      161        6      active sync   /dev/sdk1
>>    7     7       8      177        7      active sync   /dev/sdl1
>>    8     8       8      193        8      active sync   /dev/sdm1
>>
>
>
> Did you check dmesg and see if there were errors on those disks?
>
>

-- 
Andrew Dunn
http://agdunn.net


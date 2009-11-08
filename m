From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: RAID 6 Failure follow up
Date: Sun, 08 Nov 2009 08:23:29 -0600
Message-ID: <4AF6D461.3050109@gmail.com>
References: <4AF6D0A9.6000901@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF6D0A9.6000901@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Andrew Dunn wrote:
> This is kind of interesting:
> 
> storrgie@ALEXANDRIA:~$ sudo mdadm --assemble --force /dev/md0
> mdadm: no devices found for /dev/md0
> 
> All of the devices are there in /dev, so I wanted to examine them:
> 
> storrgie@ALEXANDRIA:~$ sudo mdadm --examine /dev/sde1
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 397e0b3f:34cbe4cc:613e2239:070da8c8 (local to host
> ALEXANDRIA)
>   Creation Time : Fri Nov  6 07:06:34 2009
>      Raid Level : raid6
>   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>      Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
>    Raid Devices : 9
>   Total Devices : 9
> Preferred Minor : 0
> 
>     Update Time : Sun Nov  8 08:57:04 2009
>           State : clean
>  Active Devices : 5
> Working Devices : 5
>  Failed Devices : 4
>   Spare Devices : 0
>        Checksum : 4ff41c5f - correct
>          Events : 43
> 
>      Chunk Size : 1024K
> 
>       Number   Major   Minor   RaidDevice State
> this     0       8       65        0      active sync   /dev/sde1
> 
>    0     0       8       65        0      active sync   /dev/sde1
>    1     1       8       81        1      active sync   /dev/sdf1
>    2     2       8       97        2      active sync   /dev/sdg1
>    3     3       8      113        3      active sync   /dev/sdh1
>    4     4       0        0        4      faulty removed
>    5     5       0        0        5      faulty removed
>    6     6       0        0        6      faulty removed
>    7     7       0        0        7      faulty removed
>    8     8       8      193        8      active sync   /dev/sdm1
> 
> First raid device shows the failures....
> 
> One of the 'removed' devices:
> 
> storrgie@ALEXANDRIA:~$ sudo mdadm --examine /dev/sdi1
> /dev/sdi1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 397e0b3f:34cbe4cc:613e2239:070da8c8 (local to host
> ALEXANDRIA)
>   Creation Time : Fri Nov  6 07:06:34 2009
>      Raid Level : raid6
>   Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>      Array Size : 6837318656 (6520.58 GiB 7001.41 GB)
>    Raid Devices : 9
>   Total Devices : 9
> Preferred Minor : 0
> 
>     Update Time : Sun Nov  8 08:53:30 2009
>           State : active
>  Active Devices : 9
> Working Devices : 9
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 4ff41b2f - correct
>          Events : 21
> 
>      Chunk Size : 1024K
> 
>       Number   Major   Minor   RaidDevice State
> this     4       8      129        4      active sync   /dev/sdi1
> 
>    0     0       8       65        0      active sync   /dev/sde1
>    1     1       8       81        1      active sync   /dev/sdf1
>    2     2       8       97        2      active sync   /dev/sdg1
>    3     3       8      113        3      active sync   /dev/sdh1
>    4     4       8      129        4      active sync   /dev/sdi1
>    5     5       8      145        5      active sync   /dev/sdj1
>    6     6       8      161        6      active sync   /dev/sdk1
>    7     7       8      177        7      active sync   /dev/sdl1
>    8     8       8      193        8      active sync   /dev/sdm1
> 


Did you check dmesg and see if there were errors on those disks?



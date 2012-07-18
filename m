From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Need to remove failed disk from RAID5 array
Date: Wed, 18 Jul 2012 16:26:50 -0400
Message-ID: <50071C0A.8080307@tmr.com>
References: <CAB1R3shxBWebm13ie5gR0h++-GBTyfZrranHr8tjGkbPipV32w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3shxBWebm13ie5gR0h++-GBTyfZrranHr8tjGkbPipV32w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Alex wrote:
> Hi,
>
> I have a degraded RAID5 array on an fc15 box due to sda failing:
>
> Personalities : [raid6] [raid5] [raid4]
> md1 : active raid5 sda3[5](F) sdd2[4] sdc2[2] sdb2[1]
>        2890747392 blocks super 1.1 level 5, 512k chunk, algorithm 2 [4/3] [_UUU]
>        bitmap: 8/8 pages [32KB], 65536KB chunk
>
> md0 : active raid5 sda2[5] sdd1[4] sdc1[2] sdb1[1]
>        30715392 blocks super 1.1 level 5, 512k chunk, algorithm 2 [4/4] [UUUU]
>        bitmap: 0/1 pages [0KB], 65536KB chunk
>
> There's a ton of messages like these:
>
> end_request: I/O error, dev sda, sector 1668467332
> md/raid:md1: read error NOT corrected!! (sector 1646961280 on sda3).
> md/raid:md1: Disk failure on sda3, disabling device.
> md/raid:md1: Operation continuing on 3 devices.
> md/raid:md1: read error not correctable (sector 1646961288 on sda3).
>
> What is the proper procedure to remove the disk from the array,
> shutdown the server, and reboot with a new sda?
>
> # mdadm --version
> mdadm - v3.2.5 - 18th May 2012
>
> # mdadm -Es
> ARRAY /dev/md/0 metadata=1.1 UUID=4b5a3704:c681f663:99e744e4:254ebe3e
> name=pixie.example.com:0
> ARRAY /dev/md/1 metadata=1.1 UUID=d5032866:15381f0b:e725e8ae:26f9a971
> name=pixie.example.com:1
>
> # mdadm --detail /dev/md1
> /dev/md1:
>          Version : 1.1
>    Creation Time : Sun Aug  7 12:52:18 2011
>       Raid Level : raid5
>       Array Size : 2890747392 (2756.83 GiB 2960.13 GB)
>    Used Dev Size : 963582464 (918.94 GiB 986.71 GB)
>     Raid Devices : 4
>    Total Devices : 4
>      Persistence : Superblock is persistent
>
>    Intent Bitmap : Internal
>
>      Update Time : Mon Jul 16 19:14:11 2012
>            State : active, degraded
>   Active Devices : 3
> Working Devices : 3
>   Failed Devices : 1
>    Spare Devices : 0
>
>           Layout : left-symmetric
>       Chunk Size : 512K
>
>             Name : pixie.example.com:1  (local to host pixie.example.com)
>             UUID : d5032866:15381f0b:e725e8ae:26f9a971
>           Events : 162567
>
>      Number   Major   Minor   RaidDevice State
>         0       0        0        0      removed
>         1       8       18        1      active sync   /dev/sdb2
>         2       8       34        2      active sync   /dev/sdc2
>         4       8       50        3      active sync   /dev/sdd2
>
>         5       8        3        -      faulty spare   /dev/sda3
>
> I'd appreciate a pointer to any existing documentation, or some
> general guidance on the proper procedure.
>

Once the drive is failed about all you can do is add another drive as a spare, 
wait until the rebuild completes, then remove the old drive from the array. If 
you have a new kernel, 3.3 or newer you might have been able to use the 
undocumented but amazing "want_replacement" action to speed your rebuild, but 
when it is so bad it gets kicked I think it's too late.

Neil might have a thought on this, the option makes the rebuild vastly faster 
and safer.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot



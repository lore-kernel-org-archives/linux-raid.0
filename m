From: Farkas Levente <lfarkas@bppiac.hu>
Subject: Re: why the kernel and mdadm report differently
Date: Mon, 05 Sep 2005 15:30:39 +0200
Message-ID: <431C487F.3010908@bppiac.hu>
References: <431C0968.10301@bppiac.hu> <17180.3031.193961.445535@cse.unsw.edu.au> <431C30E3.2040404@bppiac.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <431C30E3.2040404@bppiac.hu>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Farkas Levente wrote:
>>> and one more stange thing that it's currently not working, kernel 
>>> report inactive while mdadm said it's active, degraded. what's more 
>>> we cant put this array into active state.
>>
>>
>>
>> Looks like you need to stop in (mdadm -S /dev/md2) and re-assemble it
>> with --force:
>>   mdadm -A /dev/md2 -f /dev/sd[abcefgh]1
>>
>> It looks like the computer crashed and when it came back up it was
>> missing a drive.  This situation can result in silent data corruption,
>> which is why md won't automatically assemble it.  When you do assemble
>> it, you should at least fsck the filesystem, and possibly check for
>> data corruption if that is possible.  At least be aware that some data
>> could be corrupt (there is a good chance that nothing is, but it is by
>> no means certain).
> 
> 
> it works. but shouldn't it have to be both inactive or active?

or seems to works, but now do nothing?!:
--------------------------------------------------------
[root@kek:~] cat /proc/mdstat
Personalities : [raid1] [raid5]
md1 : active raid1 hdc1[0] hda1[1]
       1048704 blocks [2/2] [UU]

md2 : active raid5 sdc1[7] sda1[0] sdh1[8] sdg1[6] sdf1[5] sde1[4] sdb1[1]
       720321792 blocks level 5, 128k chunk, algorithm 2 [7/5] [UU__UUU]

md0 : active raid1 hdc2[0] hda2[1]
       39097664 blocks [2/2] [UU]

unused devices: <none>
[root@kek:~] mdadm --detail /dev/md2
/dev/md2:
         Version : 00.90.01
   Creation Time : Tue Jun  1 09:37:17 2004
      Raid Level : raid5
      Array Size : 720321792 (686.95 GiB 737.61 GB)
     Device Size : 120053632 (114.49 GiB 122.93 GB)
    Raid Devices : 7
   Total Devices : 7
Preferred Minor : 2
     Persistence : Superblock is persistent

     Update Time : Mon Sep  5 15:28:20 2005
           State : clean, degraded
  Active Devices : 5
Working Devices : 7
  Failed Devices : 0
   Spare Devices : 2

          Layout : left-symmetric
      Chunk Size : 128K

            UUID : 79b566fd:924d9c94:15304031:0c945006
          Events : 0.4244279

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       17        1      active sync   /dev/sdb1
        2       0        0        -      removed
        3       0        0        -      removed
        4       8       65        4      active sync   /dev/sde1
        5       8       81        5      active sync   /dev/sdf1
        6       8       97        6      active sync   /dev/sdg1

        7       8       33        2      spare rebuilding   /dev/sdc1
        8       8      113        3      spare rebuilding   /dev/sdh1
--------------------------------------------------------


-- 
   Levente                               "Si vis pacem para bellum!"


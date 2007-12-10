From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: unable to remove failed drive
Date: Mon, 10 Dec 2007 14:12:56 -0500
Message-ID: <475D8FB8.90408@tmr.com>
References: <e03b90ae0712071755l1defdcaft511b2c41a10fe838@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e03b90ae0712071755l1defdcaft511b2c41a10fe838@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jeff Breidenbach wrote:
> ... and all access to array hangs indefinitely, resulting in unkillable zombie
> processes. Have to hard reboot the machine. Any thoughts on the matter?
>
> ===
>
> # cat /proc/mdstat
> Personalities : [raid1]
> md1 : active raid1 sde1[6](F) sdg1[1] sdb1[4] sdd1[3] sdc1[2]
>       488383936 blocks [6/4] [_UUUU_]
>
> unused devices: <none>
>
> # mdadm --fail /dev/md1 /dev/sde1
> mdadm: set /dev/sde1 faulty in /dev/md1
>
> # mdadm --remove /dev/md1 /dev/sde1
> mdadm: hot remove failed for /dev/sde1: Device or resource busy
>
> # mdadm -D /dev/md1
> /dev/md1:
>         Version : 00.90.03
>   Creation Time : Sun Dec 25 16:12:34 2005
>      Raid Level : raid1
>      Array Size : 488383936 (465.76 GiB 500.11 GB)
>     Device Size : 488383936 (465.76 GiB 500.11 GB)
>    Raid Devices : 6
>   Total Devices : 5
> Preferred Minor : 1
>     Persistence : Superblock is persistent
>
>     Update Time : Fri Dec  7 11:37:46 2007
>           State : active, degraded
>  Active Devices : 4
> Working Devices : 4
>  Failed Devices : 1
>   Spare Devices : 0
>
>            UUID : f3ee6aa3:2f1d5767:f443dfc0:c23e80af
>          Events : 0.22331500
>
>     Number   Major   Minor   RaidDevice State
>        0       0        0        -      removed
>        1       8       97        1      active sync   /dev/sdg1
>        2       8       33        2      active sync   /dev/sdc1
>        3       8       49        3      active sync   /dev/sdd1
>        4       8       17        4      active sync   /dev/sdb1
>        5       0        0        -      removed
>
>        6       8       65        0      faulty   /dev/sde1
>
>   
This is without doubt really messed up! You have four active devices, 
four working devices, five total devices, and six(!) raid devices. And 
at the end of the output seven(!!) devices, four active, two removed, 
and one faulty. I wouldn't even be able to make a guess how you go to 
this point, but I would guess that some system administration was involved.

If this is an array you can live without and still have a working system 
I do have a thought, however. If you can unmount everything on this 
device and then stop it, you may be able to assemble (-A) it with just 
the four working drives. If that succeeds you may be able to remove 
sde1, although I suspect that the two removed drives shown are really 
caused by partially removal of sde1 in the past. Either that or you have 
a serious problem with reliability...

I'm sure others will have some ideas on this, if it were mine a backup 
would be my first order of business.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 



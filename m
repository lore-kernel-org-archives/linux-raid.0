From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Spare disk not becoming active
Date: Wed, 19 Dec 2012 18:03:13 -0600
Message-ID: <CAAMCDefzx+eDVRqqX0kDz-xD-inzTYChLi=BvmViaMej-3iXLA@mail.gmail.com>
References: <50BBEC7E.7080200@smartguide.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50BBEC7E.7080200@smartguide.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Tudor Holton <tudor@smartguide.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 2, 2012 at 6:04 PM, Tudor Holton <tudor@smartguide.com.au> wrote:
> Hallo,
>
> I'm having some trouble with an array I have that has become degraded.
>
> I have an array with this array state:
>
> md101 : active raid1 sdf1[0] sdb1[2](S)
>       1953511936 blocks [2/1] [U_]
>
>
> mdadm --detail says:
>
> /dev/md101:
>         Version : 0.90
>   Creation Time : Thu Jan 13 14:34:27 2011
>      Raid Level : raid1
>      Array Size : 1953511936 (1863.01 GiB 2000.40 GB)
>   Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>    Raid Devices : 2
>   Total Devices : 2
> Preferred Minor : 101
>     Persistence : Superblock is persistent
>
>     Update Time : Fri Nov 23 03:23:04 2012
>           State : clean, degraded
>  Active Devices : 1
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 1
>
>            UUID : 43e92a79:90295495:0a76e71e:56c99031 (local to host barney)
>          Events : 0.2127
>
>     Number   Major   Minor   RaidDevice State
>        0       8       81        0      active sync /dev/sdf1
>        1       0        0        1      removed
>
>        2       8       17        -      spare   /dev/sdb1
>
>
> If I attempt to force the spare to become active it begins to recover:
> $ sudo mdadm -S /dev/md101
> mdadm: stopped /dev/md101
> $ sudo mdadm --assemble --force --no-degraded /dev/md101 /dev/sdf1 /dev/sdb1
> mdadm: /dev/md101 has been started with 1 drive (out of 2) and 1 spare.
> $ cat /proc/mdstat
> md101 : active raid1 sdf1[0] sdb1[2]
>       1953511936 blocks [2/1] [U_]
>       [>....................]  recovery =  0.0% (541440/1953511936)
> finish=420.8min speed=77348K/sec
>
> This runs for the allotted time but returns to the state of spare.
>
> Neither disk partition report errors:
> $ cat /sys/block/md101/md/dev-sdf1/errors
> 0
> $ cat /sys/block/md101/md/dev-sdb1/errors
> 0
>
> Are there mdadm logs to find out why this is not recovering properly?  How
> otherwise do I debug this?
>
> Cheers,
> Tudor.

Did you look in the various /var/log/messages (current and previous
ones) to see what it indicated happened the about the time it
completed?

There is almost certainly something in there indicating what went wrong.

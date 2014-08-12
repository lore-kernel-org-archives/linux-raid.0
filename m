From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Sleepy drives and MD RAID 6
Date: Mon, 11 Aug 2014 20:21:37 -0500
Message-ID: <53E96C21.2050309@nuclearwinter.com>
References: <CAH_2GheOOaJRp7YimEsorFzGUJyObG2QsOpu87CYvwLPwz-V+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH_2GheOOaJRp7YimEsorFzGUJyObG2QsOpu87CYvwLPwz-V+A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Talbot <ajtalbot1@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was in the same boat and decided to solve the problem with some code.

I wrote a daemon that monitors /sys/block/sd?/stat for each member of
the array. If all the drives have been idle for X seconds the daemon
sends a spindown command to each member in parallel. If the array is
spun down the daemon watches for any change in the aforementioned stat
file and if there is it spins up all members in parallel.

The affect of this is the array spin-up time is only as long as the
slowest drive and all the drives spin down at the same time. My
experience has been that leaving spindown up to the drives is a bad
idea. Different models and different manufacturers have varying notions
of what 10 minutes means. Also, leaving spin-up to the controller is
also not so hot since some controllers spin-up the drives sequentially
rather than in parallel.

I'd be happy to share the code and even happier if someone wrote
something better!

--Larkin

On 8/11/2014 8:03 PM, Adam Talbot wrote:
> I need help from the Linux RAID pros.
>
> To make a very long story short; I have a 7 disk in a RAID 6 array.  I
> put the drives to sleep after 7 minutes of inactivity.  When I go to
> use this array the spin up time is causing applications to hang.
> Current spin up time is 50 seconds, but will be getting worse as I add
> drives.
>
> Here is the MUCH longer description including more specs (DingbatCA):
> http://forums.gentoo.org/viewtopic-p-7599010.html
>
> Any help would be greatly appreciated.  I think this would make a
> great wiki article.
>
> More details bellow:
> root@nas:/data# smartctl -a /dev/sdd | grep Spin_Up
>   3 Spin_Up_Time            0x0027   150   137   021    Pre-fail
> Always       -       9608
>
> root@nas:/data# time (touch foo ; sync)
> real    0m49.004s
> user    0m0.000s
> sys     0m0.004s
>
> root@nas:/data# time (touch foo ; sync)
> real    0m50.647s
> user    0m0.000s
> sys     0m0.008s
>
> root@nas:/data# df -h /data
> Filesystem      Size  Used Avail Use% Mounted on
> /dev/md125      9.1T  3.8T  5.4T  42% /data
>
> root@nas:/data# mdadm -D /dev/md125
> /dev/md125:
>         Version : 1.2
>   Creation Time : Wed Jun 18 07:54:38 2014
>      Raid Level : raid6
>      Array Size : 9766909440 (9314.45 GiB 10001.32 GB)
>   Used Dev Size : 1953381888 (1862.89 GiB 2000.26 GB)
>    Raid Devices : 7
>   Total Devices : 7
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Aug 11 16:30:16 2014
>           State : clean
>  Active Devices : 7
> Working Devices : 7
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : left-symmetric
>      Chunk Size : 512K
>
>            Name : nas:data  (local to host nas)
>            UUID : 74f9ce7a:df1c2698:c8ec7259:5fdb2618
>          Events : 1038642
>
>     Number   Major   Minor   RaidDevice State
>        0       8       17        0      active sync   /dev/sdb1
>        1       8       33        1      active sync   /dev/sdc1
>        3       8       49        2      active sync   /dev/sdd1
>        4       8       65        3      active sync   /dev/sde1
>        5       8       81        4      active sync   /dev/sdf1
>        7       8      145        5      active sync   /dev/sdj1
>        6       8      129        6      active sync   /dev/sdi1
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


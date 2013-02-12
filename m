From: Dave Cundiff <syshackmin@gmail.com>
Subject: Re: Unable to reactivate a RAID10 mdadm device
Date: Tue, 12 Feb 2013 03:42:48 -0500
Message-ID: <CAKHEz2bCyaqTa7dH-OFNR8_xs9O=XUD918vpVb+kL-gfOSq7gA@mail.gmail.com>
References: <CAHhM8gBza3j-3qE3dRkZy14_cO-6EjOjW-zU8mtHVxhy6EWrtw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHhM8gBza3j-3qE3dRkZy14_cO-6EjOjW-zU8mtHVxhy6EWrtw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Arun Khan <knura9@gmail.com>
Cc: Linux MDADM Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 12, 2013 at 2:16 AM, Arun Khan <knura9@gmail.com> wrote:
> Recovery OS -- System Rescue CD v 2.8.0
>
> Production OS - Debian Squeeze (6) 2.6.32 stock kernel, using mdadm raid
>
> /dev/md0 in raid level RAID10 - members /dev/sdb1, /dev/sdc1,
> /dev/sdd1, /dev/sde1 all with partion id=fd
>
> HDD /dev/sdb went bad, replaced it with another disk with same size
> partion (id=fd)
> using System Rescue CD v2.8.0
>
> 1. System Rescue CD recognized the md devices but it comes up as 'inactive'
>
> Searched for possible solutions and I have tried several things including
> zeroing the super block and adding them back to the array.
>
> Still unable to bring back /dev/md0 with all 4 partions in active mode.
>
> I have included below, the entire transcript of the commands I have
> tried to recover /dev/md0
>
> I have data on /dev/md0 that I need. I do have back ups of critical
> files (but not all).
>
> I prefer solving the problem v/s recreating the /dev/md0 from scratch.
>
> Any help in solving this problem would be highly appreciated.
>
> TIA,
> -- Arun Khan
>
> ---------------  transcript of mdadm activity  with System Rescue CD
> v2.8.0  ----------------
>
> # mdadm -V
> mdadm - v3.1.4 - 31st August 2010
>
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : inactive sdd1[2] sde1[3]
>       312574512 blocks super 1.0
>
> # mdadm -S /dev/md0
> mdadm: stopped /dev/md0
>
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> unused devices: <none>
>
>
> # mdadm -v -v -A /dev/md0 -R /dev/sd[bcde]1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
> mdadm: added /dev/sdb1 to /dev/md0 as 0
> mdadm: added /dev/sdc1 to /dev/md0 as 1
> mdadm: added /dev/sde1 to /dev/md0 as 3
> mdadm: added /dev/sdd1 to /dev/md0 as 2
> mdadm: failed to RUN_ARRAY /dev/md0: Input/output error
> mdadm: Not enough devices to start the array.
>
> # cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : inactive sdd1[2] sde1[3]
>       312574512 blocks super 1.0
>
> unused devices: <none>
>
> from /var/log/messages
> Feb 12 06:13:59 sysresccd kernel: [ 7593.339015] md: md0 stopped.
> Feb 12 06:13:59 sysresccd kernel: [ 7593.374016] md: bind<sdb1>
> Feb 12 06:13:59 sysresccd kernel: [ 7593.374417] md: bind<sdc1>
> Feb 12 06:13:59 sysresccd kernel: [ 7593.374604] md: bind<sde1>
> Feb 12 06:13:59 sysresccd kernel: [ 7593.374869] md: bind<sdd1>
> Feb 12 06:13:59 sysresccd kernel: [ 7593.374899] md: kicking non-fresh
> sdc1 from array!
> Feb 12 06:13:59 sysresccd kernel: [ 7593.374903] md: unbind<sdc1>
> Feb 12 06:13:59 sysresccd kernel: [ 7593.379016] md: export_rdev(sdc1)
> Feb 12 06:13:59 sysresccd kernel: [ 7593.379041] md: kicking non-fresh
> sdb1 from array!
> Feb 12 06:13:59 sysresccd kernel: [ 7593.379044] md: unbind<sdb1>
> Feb 12 06:13:59 sysresccd kernel: [ 7593.386010] md: export_rdev(sdb1)
> Feb 12 06:13:59 sysresccd kernel: [ 7593.387382] md/raid10:md0: not
> enough operational mirrors.
> Feb 12 06:13:59 sysresccd kernel: [ 7593.387410] md: pers->run() failed ...
>
> # mdadm -D /dev/md0
> /dev/md0:
>         Version : 1.0
>   Creation Time : Fri Apr 29 04:27:04 2011
>      Raid Level : raid10
>   Used Dev Size : 156287232 (149.05 GiB 160.04 GB)
>    Raid Devices : 4
>   Total Devices : 2
>     Persistence : Superblock is persistent
>
>     Update Time : Mon Feb 11 13:43:52 2013
>           State : active, FAILED, Not Started
>  Active Devices : 2
> Working Devices : 2
>  Failed Devices : 0
>   Spare Devices : 0
>
>          Layout : near=2
>      Chunk Size : 32K
>
>            Name : brahmaputra:0
>            UUID : f2d4e898:2e026f85:244a7e9c:908e1af7
>          Events : 783527
>
>     Number   Major   Minor   RaidDevice State
>        0       0        0        0      removed
>        1       0        0        1      removed
>        2       8       49        2      active sync   /dev/sdd1
>        3       8       65        3      active sync   /dev/sde1
>
>
> # mdadm -E /dev/sdc1
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : f2d4e898:2e026f85:244a7e9c:908e1af7
>            Name : brahmaputra:0
>   Creation Time : Fri Apr 29 04:27:04 2011
>      Raid Level : raid10
>    Raid Devices : 4
>
>  Avail Dev Size : 312574512 (149.05 GiB 160.04 GB)
>      Array Size : 625148928 (298.09 GiB 320.08 GB)
>   Used Dev Size : 312574464 (149.05 GiB 160.04 GB)
>    Super Offset : 312574640 sectors
>           State : clean
>     Device UUID : 2fbc103e:ca40e0c2:b8e4d64f:0fbc7b94
>
> Internal Bitmap : -8 sectors from superblock
>     Update Time : Mon Feb 11 13:43:52 2013
>        Checksum : 2e8e9fad - correct
>          Events : 0
>
>          Layout : near=2
>      Chunk Size : 32K
>
>    Device Role : spare
>    Array State : ..AA ('A' == active, '.' == missing)
>
>
> #  mdadm -E /dev/sdb1
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : f2d4e898:2e026f85:244a7e9c:908e1af7
>            Name : brahmaputra:0
>   Creation Time : Fri Apr 29 04:27:04 2011
>      Raid Level : raid10
>    Raid Devices : 4
>
>  Avail Dev Size : 312574512 (149.05 GiB 160.04 GB)
>      Array Size : 625148928 (298.09 GiB 320.08 GB)
>   Used Dev Size : 312574464 (149.05 GiB 160.04 GB)
>    Super Offset : 312574640 sectors
>           State : clean
>     Device UUID : e27c187b:9004cb93:5bb05639:164822cd
>
> Internal Bitmap : -8 sectors from superblock
>     Update Time : Mon Feb 11 13:43:52 2013
>        Checksum : 5ea77bd0 - correct
>          Events : 0
>
>          Layout : near=2
>      Chunk Size : 32K
>
>    Device Role : spare
>    Array State : ..AA ('A' == active, '.' == missing)
>
> #  mdadm -E /dev/sde1
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : f2d4e898:2e026f85:244a7e9c:908e1af7
>            Name : brahmaputra:0
>   Creation Time : Fri Apr 29 04:27:04 2011
>      Raid Level : raid10
>    Raid Devices : 4
>
>  Avail Dev Size : 312574512 (149.05 GiB 160.04 GB)
>      Array Size : 625148928 (298.09 GiB 320.08 GB)
>   Used Dev Size : 312574464 (149.05 GiB 160.04 GB)
>    Super Offset : 312574640 sectors
>           State : clean
>     Device UUID : 78fc82bc:2eb18f07:56c98922:7639269e
>
> Internal Bitmap : -8 sectors from superblock
>     Update Time : Mon Feb 11 13:43:52 2013
>        Checksum : ce19a703 - correct
>          Events : 783527
>
>          Layout : near=2
>      Chunk Size : 32K
>
>    Device Role : Active device 3
>    Array State : ..AA ('A' == active, '.' == missing)
>
> #  mdadm -E /dev/sdd1
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x1
>      Array UUID : f2d4e898:2e026f85:244a7e9c:908e1af7
>            Name : brahmaputra:0
>   Creation Time : Fri Apr 29 04:27:04 2011
>      Raid Level : raid10
>    Raid Devices : 4
>
>  Avail Dev Size : 312574512 (149.05 GiB 160.04 GB)
>      Array Size : 625148928 (298.09 GiB 320.08 GB)
>   Used Dev Size : 312574464 (149.05 GiB 160.04 GB)
>    Super Offset : 312574640 sectors
>           State : clean
>     Device UUID : 1dce2f63:fef488cb:1a362c57:7ed908ac
>
> Internal Bitmap : -8 sectors from superblock
>     Update Time : Mon Feb 11 13:43:52 2013
>        Checksum : 7b44c944 - correct
>          Events : 783527
>
>          Layout : near=2
>      Chunk Size : 32K
>
>    Device Role : Active device 2
>    Array State : ..AA ('A' == active, '.' == missing)
>
> # mdadm --zero-superblock /dev/sdb1
>
> # mdadm -E /dev/sdb1
> mdadm: No md superblock detected on /dev/sdb1.
>
> # mdadm /dev/md0 --add /dev/sdb1
> mdadm: add new device failed for /dev/sdb1 as 4: Invalid argument
>
> from /var/log/messages
> Feb 12 06:52:26 sysresccd kernel: [ 9900.298880] md0: ADD_NEW_DISK not supported
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

According to what I can see your array refuses to start because the
mirrored pair sdb1 and sdc1 are both out of sync. Both are showing an
event count of zero. That generally means the disk has never attempted
to sync. The device role of "spare" on both of these disks reinforces
that fact.

Are you sure sdc1 was active, sync'd, and in the array before sdb1 failed?
Could you have accidentally cleared the superblock on sdc1 as well?


--
Dave Cundiff
System Administrator
A2Hosting, Inc
http://www.a2hosting.com

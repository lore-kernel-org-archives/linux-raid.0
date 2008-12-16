From: Bernd Schubert <bs@q-leap.de>
Subject: Re: RAID 6 recovery (it's not looking good)
Date: Tue, 16 Dec 2008 20:18:43 +0100
Message-ID: <20081216191843.GA25097@lanczos.q-leap.de>
References: <C56D7711.B960%groups@email.iain.rauch.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <C56D7711.B960%groups@email.iain.rauch.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Iain Rauch <groups@email.iain.rauch.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Iain,

can you please describe what is the *present* status? 

> /dev/md0 has been started with 22 drives (out of 24) and 1 spare

So in short, you had failure of 3 drives, reassembled it with 22 drives and 
while you rebuild it again a drive failed?

If so, take this last failed drive, clone it to a new drive (e.g. dd_rescue)
and continue.

(Sorry, but this is by far too much output below for my tired eyes. 
Sometimes a short description is more helpful).


Cheers,
Bernd



On Tue, Dec 16, 2008 at 03:17:37PM +0000, Iain Rauch wrote:
> Hi,
> 
> Here's the situation:
> 
> 24 disk array.
> Disk fails - usage continues for a while.
> Power cut - array in unknown state at the time, but I expect it was just
> running degraded.
> Restart and assemble the array.
> *story continues further down.
> 
> 1 disk is way out of sync and 1 disk doesn't work. 2 disks are marked spare
> - the faulty one and another. I think I need to set the status of one of the
> 'spare' disks to clean and then assemble the array. I can then rebuild the
> disk that is way out of sync, and when I have a replacement, rebuild the
> failed disk. Is this possible? It doesn't matter if I can assemble the array
> to get some of the data even if most of it is corrupt. At the very least I'd
> like to be able to see the names of the files I had on it.
> 
> Hope someone can help, but I'm not holding my breath.
> 
> Iain
> 
> 
> root@skinner:/home/iain# mdadm -D /dev/md0
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Thu May 31 17:24:32 2007
>      Raid Level : raid6
>      Array Size : 10744267776 (10246.53 GiB 11002.13 GB)
>   Used Dev Size : 488375808 (465.75 GiB 500.10 GB)
>    Raid Devices : 24
>   Total Devices : 22
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Sat Oct 18 20:52:53 2008
>           State : clean, degraded
>  Active Devices : 22
> Working Devices : 22
>  Failed Devices : 0
>   Spare Devices : 0
> 
>      Chunk Size : 128K
> 
>            UUID : 2aa31867:40c370a7:61c202b9:07c4b1c4
>          Events : 0.1273570
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       49        0      active sync   /dev/sdd1
>        1       8       65        1      active sync   /dev/sde1
>        2       8       81        2      active sync   /dev/sdf1
>        3       8       33        3      active sync   /dev/sdc1
>        4       8      225        4      active sync   /dev/sdo1
>        5       8      241        5      active sync   /dev/sdp1
>        6       8      193        6      active sync   /dev/sdm1
>        7       8      209        7      active sync   /dev/sdn1
>        8      65       17        8      active sync   /dev/sdr1
>        9      65       81        9      active sync   /dev/sdv1
>       10       0        0       10      removed
>       11      65      113       11      active sync   /dev/sdx1
>       12       0        0       12      removed
>       13      65       49       13      active sync   /dev/sdt1
>       14      65        1       14      active sync   /dev/sdq1
>       15      65       65       15      active sync   /dev/sdu1
>       16       8      129       16      active sync   /dev/sdi1
>       17       8      161       17      active sync   /dev/sdk1
>       18       8      145       18      active sync   /dev/sdj1
>       19       8      177       19      active sync   /dev/sdl1
>       20       8        1       20      active sync   /dev/sda1
>       21       8       97       21      active sync   /dev/sdg1
>       22       8       17       22      active sync   /dev/sdb1
>       23       8      113       23      active sync   /dev/sdh1
> 
> Not so long after:
> 
> root@skinner:/home/iain# mdadm -D /dev/md0
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Thu May 31 17:24:32 2007
>      Raid Level : raid6
>      Array Size : 10744267776 (10246.53 GiB 11002.13 GB)
>   Used Dev Size : 488375808 (465.75 GiB 500.10 GB)
>    Raid Devices : 24
>   Total Devices : 22
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Dec 16 12:56:38 2008
>           State : clean, degraded
>  Active Devices : 21
> Working Devices : 21
>  Failed Devices : 1
>   Spare Devices : 0
> 
>      Chunk Size : 128K
> 
>            UUID : 2aa31867:40c370a7:61c202b9:07c4b1c4
>          Events : 0.1273576
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       49        0      active sync   /dev/sdd1
>        1       8       65        1      active sync   /dev/sde1
>        2       8       81        2      active sync   /dev/sdf1
>        3       8       33        3      active sync   /dev/sdc1
>        4       8      225        4      active sync   /dev/sdo1
>        5       8      241        5      active sync   /dev/sdp1
>        6       8      193        6      active sync   /dev/sdm1
>        7       8      209        7      active sync   /dev/sdn1
>        8      65       17        8      active sync   /dev/sdr1
>        9      65       81        9      active sync   /dev/sdv1
>       10       0        0       10      removed
>       11      65      113       11      active sync   /dev/sdx1
>       12       0        0       12      removed
>       13      65       49       13      active sync   /dev/sdt1
>       14      65        1       14      active sync   /dev/sdq1
>       15       0        0       15      removed
>       16       8      129       16      active sync   /dev/sdi1
>       17       8      161       17      active sync   /dev/sdk1
>       18       8      145       18      active sync   /dev/sdj1
>       19       8      177       19      active sync   /dev/sdl1
>       20       8        1       20      active sync   /dev/sda1
>       21       8       97       21      active sync   /dev/sdg1
>       22       8       17       22      active sync   /dev/sdb1
>       23       8      113       23      active sync   /dev/sdh1
> 
>       24      65       65        -      faulty spare   /dev/sdu1
> 
> root@skinner:/home/iain# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdd1[0] sdh1[23] sdb1[22] sdg1[21] sda1[20] sdl1[19]
> sdj1[18] sdk1[17] sdi1[16] sdu1[24](F) sdq1[14] sdt1[13] sdx1[11] sdv1[9]
> sdr1[8] sdn1[7] sdm1[6] sdp1[5] sdo1[4] sdc1[3] sdf1[2] sde1[1]
>       10744267776 blocks level 6, 128k chunk, algorithm 2 [24/21]
> [UUUUUUUUUU_U_UU_UUUUUUUU]
> 
> root@skinner:/home/iain# mdadm -E /dev/sd[a-x]1 | grep Events
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1273578
>          Events : 0.1271254
>          Events : 0.1273578
>          Events : 0.1273572
>          Events : 0.1273578
>          Events : 0.1273570
>          Events : 0.1273578
> 
> So from this I think sds1 was the one that first failed. Looks like it but
> letters are now reallocated (since reboot).
> 
> root@skinner:/home/iain# mdadm -E /dev/sds1
> /dev/sds1:
>           Magic : a92b4efc
>         Version : 00.90.00
>            UUID : 2aa31867:40c370a7:61c202b9:07c4b1c4
>   Creation Time : Thu May 31 17:24:32 2007
>      Raid Level : raid6
>   Used Dev Size : 488375808 (465.75 GiB 500.10 GB)
>      Array Size : 10744267776 (10246.53 GiB 11002.13 GB)
>    Raid Devices : 24
>   Total Devices : 24
> Preferred Minor : 0
> 
>     Update Time : Sat Oct 18 12:56:28 2008
>           State : clean
>  Active Devices : 24
> Working Devices : 24
>  Failed Devices : 0
>   Spare Devices : 0
>        Checksum : 2ab633fc - correct
>          Events : 0.1271254
> 
>      Chunk Size : 128K
> 
>       Number   Major   Minor   RaidDevice State
> this    12      65       97       12      active sync   /dev/sdw1
> 
>    0     0       8      145        0      active sync   /dev/sdj1
>    1     1       8      177        1      active sync   /dev/sdl1
>    2     2       8      129        2      active sync   /dev/sdi1
>    3     3       8      161        3      active sync   /dev/sdk1
>    4     4       8      225        4      active sync   /dev/sdo1
>    5     5       8      241        5      active sync   /dev/sdp1
>    6     6       8      193        6      active sync   /dev/sdm1
>    7     7       8      209        7      active sync   /dev/sdn1
>    8     8      65       65        8      active sync   /dev/sdu1
>    9     9      65       49        9      active sync   /dev/sdt1
>   10    10      65       33       10      active sync   /dev/sds1
>   11    11      65        1       11      active sync   /dev/sdq1
>   12    12      65       97       12      active sync   /dev/sdw1
>   13    13      65      113       13      active sync   /dev/sdx1
>   14    14      65       81       14      active sync   /dev/sdv1
>   15    15      65       17       15      active sync   /dev/sdr1
>   16    16       8       97       16      active sync   /dev/sdg1
>   17    17       8      113       17      active sync   /dev/sdh1
>   18    18       8       65       18      active sync   /dev/sde1
>   19    19       8       81       19      active sync   /dev/sdf1
>   20    20       8       49       20      active sync   /dev/sdd1
>   21    21       8       33       21      active sync   /dev/sdc1
>   22    22       8       17       22      active sync   /dev/sdb1
>   23    23       8        1       23      active sync   /dev/sda1
> 
> Next:
> Start without sds1 as that was the one that was left behind when there was
> still activity going on.
> 
> root@skinner:/home/iain# mdadm -v -S /dev/md0
> mdadm: stopped /dev/md0
> 
> root@skinner:/home/iain# mdadm -A /dev/md0 /dev/sd[abcdefghijklmnopqrtuvwx]1
> mdadm: /dev/md0 assembled from 21 drives - not enough to start the array.
> 
> root@skinner:/home/iain# mdadm -A -f -v /dev/md0
> /dev/sd[abcdefghijklmnopqrtuvwx]1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 20.
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 22.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 21.
> mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 23.
> mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 16.
> mdadm: /dev/sdj1 is identified as a member of /dev/md0, slot 18.
> mdadm: /dev/sdk1 is identified as a member of /dev/md0, slot 17.
> mdadm: /dev/sdl1 is identified as a member of /dev/md0, slot 19.
> mdadm: /dev/sdm1 is identified as a member of /dev/md0, slot 6.
> mdadm: /dev/sdn1 is identified as a member of /dev/md0, slot 7.
> mdadm: /dev/sdo1 is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/sdp1 is identified as a member of /dev/md0, slot 5.
> mdadm: /dev/sdq1 is identified as a member of /dev/md0, slot 14.
> mdadm: /dev/sdr1 is identified as a member of /dev/md0, slot 8.
> mdadm: /dev/sdt1 is identified as a member of /dev/md0, slot 13.
> mdadm: /dev/sdu1 is identified as a member of /dev/md0, slot 15.
> mdadm: /dev/sdv1 is identified as a member of /dev/md0, slot 9.
> mdadm: /dev/sdw1 is identified as a member of /dev/md0, slot 10.
> mdadm: /dev/sdx1 is identified as a member of /dev/md0, slot 11.
> mdadm: forcing event count in /dev/sdu1(15) from 1273572 upto 1273578
> mdadm: clearing FAULTY flag for device 19 in /dev/md0 for /dev/sdu1
> mdadm: added /dev/sde1 to /dev/md0 as 1
> mdadm: added /dev/sdf1 to /dev/md0 as 2
> mdadm: added /dev/sdc1 to /dev/md0 as 3
> mdadm: added /dev/sdo1 to /dev/md0 as 4
> mdadm: added /dev/sdp1 to /dev/md0 as 5
> mdadm: added /dev/sdm1 to /dev/md0 as 6
> mdadm: added /dev/sdn1 to /dev/md0 as 7
> mdadm: added /dev/sdr1 to /dev/md0 as 8
> mdadm: added /dev/sdv1 to /dev/md0 as 9
> mdadm: added /dev/sdw1 to /dev/md0 as 10
> mdadm: added /dev/sdx1 to /dev/md0 as 11
> mdadm: no uptodate device for slot 12 of /dev/md0
> mdadm: added /dev/sdt1 to /dev/md0 as 13
> mdadm: added /dev/sdq1 to /dev/md0 as 14
> mdadm: added /dev/sdu1 to /dev/md0 as 15
> mdadm: added /dev/sdi1 to /dev/md0 as 16
> mdadm: added /dev/sdk1 to /dev/md0 as 17
> mdadm: added /dev/sdj1 to /dev/md0 as 18
> mdadm: added /dev/sdl1 to /dev/md0 as 19
> mdadm: added /dev/sda1 to /dev/md0 as 20
> mdadm: added /dev/sdg1 to /dev/md0 as 21
> mdadm: added /dev/sdb1 to /dev/md0 as 22
> mdadm: added /dev/sdh1 to /dev/md0 as 23
> mdadm: added /dev/sdd1 to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 22 drives (out of 24).
> 
> 
> root@skinner:/home/iain# mdadm --add /dev/md0 /dev/sd[ws]1
> mdadm: re-added /dev/sds1
> mdadm: re-added /dev/sdw1
> root@skinner:/home/iain# mdadm -D /dev/md0
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Thu May 31 17:24:32 2007
>      Raid Level : raid6
>      Array Size : 10744267776 (10246.53 GiB 11002.13 GB)
>   Used Dev Size : 488375808 (465.75 GiB 500.10 GB)
>    Raid Devices : 24
>   Total Devices : 24
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Dec 16 13:10:29 2008
>           State : clean, degraded, recovering
>  Active Devices : 22
> Working Devices : 24
>  Failed Devices : 0
>   Spare Devices : 2
> 
>      Chunk Size : 128K
> 
>  Rebuild Status : 0% complete
> 
>            UUID : 2aa31867:40c370a7:61c202b9:07c4b1c4
>          Events : 0.1273586
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       49        0      active sync   /dev/sdd1
>        1       8       65        1      active sync   /dev/sde1
>        2       8       81        2      active sync   /dev/sdf1
>        3       8       33        3      active sync   /dev/sdc1
>        4       8      225        4      active sync   /dev/sdo1
>        5       8      241        5      active sync   /dev/sdp1
>        6       8      193        6      active sync   /dev/sdm1
>        7       8      209        7      active sync   /dev/sdn1
>        8      65       17        8      active sync   /dev/sdr1
>        9      65       81        9      active sync   /dev/sdv1
>       25      65       33       10      spare rebuilding   /dev/sds1
>       11      65      113       11      active sync   /dev/sdx1
>       12       0        0       12      removed
>       13      65       49       13      active sync   /dev/sdt1
>       14      65        1       14      active sync   /dev/sdq1
>       15      65       65       15      active sync   /dev/sdu1
>       16       8      129       16      active sync   /dev/sdi1
>       17       8      161       17      active sync   /dev/sdk1
>       18       8      145       18      active sync   /dev/sdj1
>       19       8      177       19      active sync   /dev/sdl1
>       20       8        1       20      active sync   /dev/sda1
>       21       8       97       21      active sync   /dev/sdg1
>       22       8       17       22      active sync   /dev/sdb1
>       23       8      113       23      active sync   /dev/sdh1
> 
>       24      65       97        -      spare   /dev/sdw1
> 
> root@skinner:/home/iain# mount -a
> mount: /dev/md0: can't read superblock
> 
> root@skinner:/mnt/md0raid# xfs_check /dev/md0
> ERROR: The filesystem has valuable metadata changes in a log which needs to
> be replayed.  Mount the filesystem to replay the log, and unmount it before
> re-running xfs_check.  If you are unable to mount the filesystem, then use
> the xfs_repair -L option to destroy the log and attempt a repair.
> Note that destroying the log may cause corruption -- please attempt a mount
> of the filesystem before doing this.
> 
> root@skinner:/mnt/md0raid# cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid6 sdw1[24](S) sds1[25](S) sdd1[0] sdh1[23] sdb1[22]
> sdg1[21] sda1[20] sdl1[19] sdj1[18] sdk1[17] sdi1[16] sdu1[26](F) sdq1[14]
> sdt1[13] sdx1[11] sdv1[9] sdr1[8] sdn1[7] sdm1[6] sdp1[5] sdo1[4] sdc1[3]
> sdf1[2] sde1[1]
>       10744267776 blocks level 6, 128k chunk, algorithm 2 [24/21]
> [UUUUUUUUUU_U_UU_UUUUUUUU]
>       
> root@skinner:/mnt/md0raid# mdadm -D /dev/md0
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Thu May 31 17:24:32 2007
>      Raid Level : raid6
>      Array Size : 10744267776 (10246.53 GiB 11002.13 GB)
>   Used Dev Size : 488375808 (465.75 GiB 500.10 GB)
>    Raid Devices : 24
>   Total Devices : 24
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Dec 16 13:13:55 2008
>           State : clean, degraded
>  Active Devices : 21
> Working Devices : 23
>  Failed Devices : 1
>   Spare Devices : 2
> 
>      Chunk Size : 128K
> 
>            UUID : 2aa31867:40c370a7:61c202b9:07c4b1c4
>          Events : 0.1273598
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       49        0      active sync   /dev/sdd1
>        1       8       65        1      active sync   /dev/sde1
>        2       8       81        2      active sync   /dev/sdf1
>        3       8       33        3      active sync   /dev/sdc1
>        4       8      225        4      active sync   /dev/sdo1
>        5       8      241        5      active sync   /dev/sdp1
>        6       8      193        6      active sync   /dev/sdm1
>        7       8      209        7      active sync   /dev/sdn1
>        8      65       17        8      active sync   /dev/sdr1
>        9      65       81        9      active sync   /dev/sdv1
>       10       0        0       10      removed
>       11      65      113       11      active sync   /dev/sdx1
>       12       0        0       12      removed
>       13      65       49       13      active sync   /dev/sdt1
>       14      65        1       14      active sync   /dev/sdq1
>       15       0        0       15      removed
>       16       8      129       16      active sync   /dev/sdi1
>       17       8      161       17      active sync   /dev/sdk1
>       18       8      145       18      active sync   /dev/sdj1
>       19       8      177       19      active sync   /dev/sdl1
>       20       8        1       20      active sync   /dev/sda1
>       21       8       97       21      active sync   /dev/sdg1
>       22       8       17       22      active sync   /dev/sdb1
>       23       8      113       23      active sync   /dev/sdh1
> 
>       24      65       97        -      spare   /dev/sdw1
>       25      65       33        -      spare   /dev/sds1
>       26      65       65        -      faulty spare   /dev/sdu1
> 
> root@skinner:/mnt/md0raid# mdadm -E /dev/sd[a-x]1 | grep Events
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273589
>          Events : 0.1273600
>          Events : 0.1273600
>          Events : 0.1273600
> 
> root@skinner:/mnt/md0raid# mdadm -v -S /dev/md0
> mdadm: stopped /dev/md0
> root@skinner:/mnt/md0raid# mdadm -A /dev/md0
> /dev/sd[abcdefghijklmnopqrstvwx]1
> mdadm: /dev/md0 assembled from 21 drives and 2 spares - not enough to start
> the array.
> 
> sdu has spontainiously changed to sdy
> 
> root@skinner:/mnt/md0raid# mdadm -E /dev/sd[a-z]1 | grep
> "Events\|/dev/sd[a-z]1:"
> /dev/sda1:
>          Events : 0.1273608
> /dev/sdb1:
>          Events : 0.1273608
> /dev/sdc1:
>          Events : 0.1273608
> /dev/sdd1:
>          Events : 0.1273608
> /dev/sde1:
>          Events : 0.1273608
> /dev/sdf1:
>          Events : 0.1273608
> /dev/sdg1:
>          Events : 0.1273608
> /dev/sdh1:
>          Events : 0.1273608
> /dev/sdi1:
>          Events : 0.1273608
> /dev/sdj1:
>          Events : 0.1273608
> /dev/sdk1:
>          Events : 0.1273608
> /dev/sdl1:
>          Events : 0.1273608
> /dev/sdm1:
>          Events : 0.1273608
> /dev/sdn1:
>          Events : 0.1273608
> /dev/sdo1:
>          Events : 0.1273608
> /dev/sdp1:
>          Events : 0.1273608
> /dev/sdq1:
>          Events : 0.1273608
> /dev/sdr1:
>          Events : 0.1273608
> /dev/sds1:
>          Events : 0.1273608
> /dev/sdt1:
>          Events : 0.1273608
> /dev/sdv1:
>          Events : 0.1273608
> /dev/sdw1:
>          Events : 0.1273608
> /dev/sdx1:
>          Events : 0.1273608
> /dev/sdy1:
>          Events : 0.1273589
> 
> root@skinner:/mnt/md0raid# mdadm -v -A -f /dev/md0
> /dev/sd[abcdefghijklmnopqrtvwxy]1
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 20.
> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 22.
> mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 2.
> mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 21.
> mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 23.
> mdadm: /dev/sdi1 is identified as a member of /dev/md0, slot 16.
> mdadm: /dev/sdj1 is identified as a member of /dev/md0, slot 18.
> mdadm: /dev/sdk1 is identified as a member of /dev/md0, slot 17.
> mdadm: /dev/sdl1 is identified as a member of /dev/md0, slot 19.
> mdadm: /dev/sdm1 is identified as a member of /dev/md0, slot 6.
> mdadm: /dev/sdn1 is identified as a member of /dev/md0, slot 7.
> mdadm: /dev/sdo1 is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/sdp1 is identified as a member of /dev/md0, slot 5.
> mdadm: /dev/sdq1 is identified as a member of /dev/md0, slot 14.
> mdadm: /dev/sdr1 is identified as a member of /dev/md0, slot 8.
> mdadm: /dev/sdt1 is identified as a member of /dev/md0, slot 13.
> mdadm: /dev/sdv1 is identified as a member of /dev/md0, slot 9.
> mdadm: /dev/sdw1 is identified as a member of /dev/md0, slot 24.
> mdadm: /dev/sdx1 is identified as a member of /dev/md0, slot 11.
> mdadm: /dev/sdy1 is identified as a member of /dev/md0, slot 15.
> mdadm: forcing event count in /dev/sdy1(15) from 1273589 upto 1273608
> mdadm: clearing FAULTY flag for device 22 in /dev/md0 for /dev/sdy1
> mdadm: added /dev/sde1 to /dev/md0 as 1
> mdadm: added /dev/sdf1 to /dev/md0 as 2
> mdadm: added /dev/sdc1 to /dev/md0 as 3
> mdadm: added /dev/sdo1 to /dev/md0 as 4
> mdadm: added /dev/sdp1 to /dev/md0 as 5
> mdadm: added /dev/sdm1 to /dev/md0 as 6
> mdadm: added /dev/sdn1 to /dev/md0 as 7
> mdadm: added /dev/sdr1 to /dev/md0 as 8
> mdadm: added /dev/sdv1 to /dev/md0 as 9
> mdadm: no uptodate device for slot 10 of /dev/md0
> mdadm: added /dev/sdx1 to /dev/md0 as 11
> mdadm: no uptodate device for slot 12 of /dev/md0
> mdadm: added /dev/sdt1 to /dev/md0 as 13
> mdadm: added /dev/sdq1 to /dev/md0 as 14
> mdadm: added /dev/sdy1 to /dev/md0 as 15
> mdadm: added /dev/sdi1 to /dev/md0 as 16
> mdadm: added /dev/sdk1 to /dev/md0 as 17
> mdadm: added /dev/sdj1 to /dev/md0 as 18
> mdadm: added /dev/sdl1 to /dev/md0 as 19
> mdadm: added /dev/sda1 to /dev/md0 as 20
> mdadm: added /dev/sdg1 to /dev/md0 as 21
> mdadm: added /dev/sdb1 to /dev/md0 as 22
> mdadm: added /dev/sdh1 to /dev/md0 as 23
> mdadm: added /dev/sdw1 to /dev/md0 as 24
> mdadm: added /dev/sdd1 to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 22 drives (out of 24) and 1 spare.
> 
> root@skinner:/mnt/md0raid# mdadm -D /dev/md0
> /dev/md0:
>         Version : 00.90.03
>   Creation Time : Thu May 31 17:24:32 2007
>      Raid Level : raid6
>      Array Size : 10744267776 (10246.53 GiB 11002.13 GB)
>   Used Dev Size : 488375808 (465.75 GiB 500.10 GB)
>    Raid Devices : 24
>   Total Devices : 23
> Preferred Minor : 0
>     Persistence : Superblock is persistent
> 
>     Update Time : Tue Dec 16 14:43:57 2008
>           State : clean, degraded
>  Active Devices : 21
> Working Devices : 22
>  Failed Devices : 1
>   Spare Devices : 1
> 
>      Chunk Size : 128K
> 
>            UUID : 2aa31867:40c370a7:61c202b9:07c4b1c4
>          Events : 0.1273614
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       49        0      active sync   /dev/sdd1
>        1       8       65        1      active sync   /dev/sde1
>        2       8       81        2      active sync   /dev/sdf1
>        3       8       33        3      active sync   /dev/sdc1
>        4       8      225        4      active sync   /dev/sdo1
>        5       8      241        5      active sync   /dev/sdp1
>        6       8      193        6      active sync   /dev/sdm1
>        7       8      209        7      active sync   /dev/sdn1
>        8      65       17        8      active sync   /dev/sdr1
>        9      65       81        9      active sync   /dev/sdv1
>       10       0        0       10      removed
>       11      65      113       11      active sync   /dev/sdx1
>       12       0        0       12      removed
>       13      65       49       13      active sync   /dev/sdt1
>       14      65        1       14      active sync   /dev/sdq1
>       15       0        0       15      removed
>       16       8      129       16      active sync   /dev/sdi1
>       17       8      161       17      active sync   /dev/sdk1
>       18       8      145       18      active sync   /dev/sdj1
>       19       8      177       19      active sync   /dev/sdl1
>       20       8        1       20      active sync   /dev/sda1
>       21       8       97       21      active sync   /dev/sdg1
>       22       8       17       22      active sync   /dev/sdb1
>       23       8      113       23      active sync   /dev/sdh1
> 
>       24      65       97        -      spare   /dev/sdw1
>       25      65      129        -      faulty spare   /dev/sdy1
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

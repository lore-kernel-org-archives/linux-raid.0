From: Andrew Farley <andrew@neonsurge.com>
Subject: Re: No md superblock immediately after creating RAID 5 /dev/md0
Date: Thu, 28 Aug 2008 02:17:52 -0700
Message-ID: <FAAEBA88-13F6-469A-B1A6-CB1AE04A1352@neonsurge.com>
References: <8CAD6FFC01AB7AC-524-231A@webmail-nf07.sim.aol.com>
Mime-Version: 1.0 (Apple Message framework v926)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8CAD6FFC01AB7AC-524-231A@webmail-nf07.sim.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: thomas62186218@aol.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thomas,

I have seen this happen to me before when your kernel doesn't have  
large block device support (CONFIG_LBD).  I still forget it sometimes  
in between making large file servers and seem to waste time every time  
figuring it out.

See here: http://www.suse.de/~aj/linux_lfs.html

Check if it's compiled into your kernel if you compiled it yourself by  
looking for CONFIG_LBD=y in /usr/src/linux/.config or if it's  
supported in your kernel extract from and search in /proc/config.gz.   
If it's not in there go recompile your kernel to support LBD.

Cheers,

Farley

On Aug 28, 2008, at 1:32 AM, thomas62186218@aol.com wrote:

> Hi all,
>
> I am struggling with an issue on an Ubuntu 8.0.4 64-bit system. The  
> system has 12 SATA drives. I create a RAID 5 array using mdadm as  
> follows:
>
> mdadm -Cv /dev/md0 -n12 -l5 -c128 /dev/sd[b-m] -R -f
>
> The device creates successfully and starts and is visible as syncing  
> in cat /proc/mdstat. But, according to mdadm -X /dev/md0, there is  
> no md superblock on the device. Doing the same mdadm -X command for  
> all components /dev/sdb through /dev/sdm shows superblocks. If I  
> reboot the system, /dev/md0 is completely gone, and a mdadm -- 
> assemble --scan produces no results. I've also tried creating the md  
> with Version 1 and 1.2 superblocks, but the same problem occurs.  
> Below is complete output.
>
> Thank you for your assistance on this strange issue!
>
> Best,
> Thomas
>
>
> root@localhost:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]  
> [raid4] [ra           id10]
> md0 : active raid5 sdm1[11](S) sdl1[10] sdk1[9] sdj1[8] sdi1[7]  
> sdh1[6] sdg1[5]            sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
>      4883839360 blocks level 5, 16k chunk, algorithm 2 [11/11]  
> [UUUUUUUUUUU]
>      [>....................]  resync =  0.6% (3207984/488383936)  
> finish=158.8mi           n speed=50916K/sec
>
> unused devices: <none>
>
> root@localhost:~# pvs
> PV         VG        Fmt  Attr PSize PFree
> /dev/md0   raid5test lvm2 a-   4.55T 4.55T
>
> root@localhost:~# cat /etc/mdadm.conf
> DEVICE  /dev/sd*
> ARRAY /dev/md0 level=raid5 num-devices=12  
> UUID=9f962f09:2d47f553:417df021:0032bb           18
>
> root@localhost:~# reboot
>
> Broadcast message from root@localhost
>       (/dev/pts/0) at 9:35 ...
>
> The system is going down for reboot NOW!
>
> root@localhost:~#
> login as: root
> root@192.168.0.70's password:
> Last login: Thu Aug 28 09:28:34 2008 from 192.168.0.114
>
>
> root@localhost:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]  
> [raid4] [ra           id10]
> unused devices: <none>
>
>
> root@localhost:~# mdadm --assemble --scan
> mdadm: no devices found for /dev/md0
>
> root@localhost:~# mdadm --query /dev/md0
> /dev/md0: is an md device which is not active
>
> root@localhost:/var/log# mdadm --examine /dev/sdb1
> /dev/sdb1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : 9f962f09:2d47f553:417df021:0032bb18
> Creation Time : Thu Aug 28 09:33:49 2008
>    Raid Level : raid5
> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)
>  Raid Devices : 11
> Total Devices : 12
> Preferred Minor : 0
>
>   Update Time : Thu Aug 28 09:36:07 2008
>         State : active
> Active Devices : 11
> Working Devices : 12
> Failed Devices : 0
> Spare Devices : 1
>      Checksum : 670c7e62 - correct
>        Events : 5
>
>        Layout : left-symmetric
>    Chunk Size : 16K
>
>     Number   Major   Minor   RaidDevice State
> this     0       8       17        0      active sync   /dev/sdb1
>
>  0     0       8       17        0      active sync   /dev/sdb1
>  1     1       8       33        1      active sync   /dev/sdc1
>  2     2       8       49        2      active sync   /dev/sdd1
>  3     3       8       65        3      active sync   /dev/sde1
>  4     4       8       81        4      active sync   /dev/sdf1
>  5     5       8       97        5      active sync   /dev/sdg1
>  6     6       8      113        6      active sync   /dev/sdh1
>  7     7       8      129        7      active sync   /dev/sdi1
>  8     8       8      145        8      active sync   /dev/sdj1
>  9     9       8      161        9      active sync   /dev/sdk1
> 10    10       8      177       10      active sync   /dev/sdl1
> 11    11       8      193       11      spare   /dev/sdm1
>
> root@localhost:/var/log# mdadm --examine /dev/sdc1
> /dev/sdc1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : 9f962f09:2d47f553:417df021:0032bb18
> Creation Time : Thu Aug 28 09:33:49 2008
>    Raid Level : raid5
> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)
>  Raid Devices : 11
> Total Devices : 12
> Preferred Minor : 0
>
>   Update Time : Thu Aug 28 09:36:07 2008
>         State : active
> Active Devices : 11
> Working Devices : 12
> Failed Devices : 0
> Spare Devices : 1
>      Checksum : 670c7e74 - correct
>        Events : 5
>
>        Layout : left-symmetric
>    Chunk Size : 16K
>
>     Number   Major   Minor   RaidDevice State
> this     1       8       33        1      active sync   /dev/sdc1
>
>  0     0       8       17        0      active sync   /dev/sdb1
>  1     1       8       33        1      active sync   /dev/sdc1
>  2     2       8       49        2      active sync   /dev/sdd1
>  3     3       8       65        3      active sync   /dev/sde1
>  4     4       8       81        4      active sync   /dev/sdf1
>  5     5       8       97        5      active sync   /dev/sdg1
>  6     6       8      113        6      active sync   /dev/sdh1
>  7     7       8      129        7      active sync   /dev/sdi1
>  8     8       8      145        8      active sync   /dev/sdj1
>  9     9       8      161        9      active sync   /dev/sdk1
> 10    10       8      177       10      active sync   /dev/sdl1
> 11    11       8      193       11      spare   /dev/sdm1
>
> root@localhost:/var/log# mdadm --examine /dev/sdd1
> /dev/sdd1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : 9f962f09:2d47f553:417df021:0032bb18
> Creation Time : Thu Aug 28 09:33:49 2008
>    Raid Level : raid5
> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)
>  Raid Devices : 11
> Total Devices : 12
> Preferred Minor : 0
>
>   Update Time : Thu Aug 28 09:36:07 2008
>         State : active
> Active Devices : 11
> Working Devices : 12
> Failed Devices : 0
> Spare Devices : 1
>      Checksum : 670c7e86 - correct
>        Events : 5
>
>        Layout : left-symmetric
>    Chunk Size : 16K
>
>     Number   Major   Minor   RaidDevice State
> this     2       8       49        2      active sync   /dev/sdd1
>
>  0     0       8       17        0      active sync   /dev/sdb1
>  1     1       8       33        1      active sync   /dev/sdc1
>  2     2       8       49        2      active sync   /dev/sdd1
>  3     3       8       65        3      active sync   /dev/sde1
>  4     4       8       81        4      active sync   /dev/sdf1
>  5     5       8       97        5      active sync   /dev/sdg1
>  6     6       8      113        6      active sync   /dev/sdh1
>  7     7       8      129        7      active sync   /dev/sdi1
>  8     8       8      145        8      active sync   /dev/sdj1
>  9     9       8      161        9      active sync   /dev/sdk1
> 10    10       8      177       10      active sync   /dev/sdl1
> 11    11       8      193       11      spare   /dev/sdm1
>
> root@localhost:/var/log# mdadm --examine /dev/sde1
> /dev/sde1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : 9f962f09:2d47f553:417df021:0032bb18
> Creation Time : Thu Aug 28 09:33:49 2008
>    Raid Level : raid5
> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)
>  Raid Devices : 11
> Total Devices : 12
> Preferred Minor : 0
>
>   Update Time : Thu Aug 28 09:36:07 2008
>         State : active
> Active Devices : 11
> Working Devices : 12
> Failed Devices : 0
> Spare Devices : 1
>      Checksum : 670c7e98 - correct
>        Events : 5
>
>        Layout : left-symmetric
>    Chunk Size : 16K
>
>     Number   Major   Minor   RaidDevice State
> this     3       8       65        3      active sync   /dev/sde1
>
>  0     0       8       17        0      active sync   /dev/sdb1
>  1     1       8       33        1      active sync   /dev/sdc1
>  2     2       8       49        2      active sync   /dev/sdd1
>  3     3       8       65        3      active sync   /dev/sde1
>  4     4       8       81        4      active sync   /dev/sdf1
>  5     5       8       97        5      active sync   /dev/sdg1
>  6     6       8      113        6      active sync   /dev/sdh1
>  7     7       8      129        7      active sync   /dev/sdi1
>  8     8       8      145        8      active sync   /dev/sdj1
>  9     9       8      161        9      active sync   /dev/sdk1
> 10    10       8      177       10      active sync   /dev/sdl1
> 11    11       8      193       11      spare   /dev/sdm1
>
> root@localhost:/var/log# mdadm --examine /dev/sdf1
> /dev/sdf1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : 9f962f09:2d47f553:417df021:0032bb18
> Creation Time : Thu Aug 28 09:33:49 2008
>    Raid Level : raid5
> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)
>  Raid Devices : 11
> Total Devices : 12
> Preferred Minor : 0
>
>   Update Time : Thu Aug 28 09:36:07 2008
>         State : active
> Active Devices : 11
> Working Devices : 12
> Failed Devices : 0
> Spare Devices : 1
>      Checksum : 670c7eaa - correct
>        Events : 5
>
>        Layout : left-symmetric
>    Chunk Size : 16K
>
>     Number   Major   Minor   RaidDevice State
> this     4       8       81        4      active sync   /dev/sdf1
>
>  0     0       8       17        0      active sync   /dev/sdb1
>  1     1       8       33        1      active sync   /dev/sdc1
>  2     2       8       49        2      active sync   /dev/sdd1
>  3     3       8       65        3      active sync   /dev/sde1
>  4     4       8       81        4      active sync   /dev/sdf1
>  5     5       8       97        5      active sync   /dev/sdg1
>  6     6       8      113        6      active sync   /dev/sdh1
>  7     7       8      129        7      active sync   /dev/sdi1
>  8     8       8      145        8      active sync   /dev/sdj1
>  9     9       8      161        9      active sync   /dev/sdk1
> 10    10       8      177       10      active sync   /dev/sdl1
> 11    11       8      193       11      spare   /dev/sdm1
>
> root@localhost:/var/log# mdadm --examine /dev/sdg1
> /dev/sdg1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : 9f962f09:2d47f553:417df021:0032bb18
> Creation Time : Thu Aug 28 09:33:49 2008
>    Raid Level : raid5
> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)
>  Raid Devices : 11
> Total Devices : 12
> Preferred Minor : 0
>
>   Update Time : Thu Aug 28 09:36:07 2008
>         State : active
> Active Devices : 11
> Working Devices : 12
> Failed Devices : 0
> Spare Devices : 1
>      Checksum : 670c7ebc - correct
>        Events : 5
>
>        Layout : left-symmetric
>    Chunk Size : 16K
>
>     Number   Major   Minor   RaidDevice State
> this     5       8       97        5      active sync   /dev/sdg1
>
>  0     0       8       17        0      active sync   /dev/sdb1
>  1     1       8       33        1      active sync   /dev/sdc1
>  2     2       8       49        2      active sync   /dev/sdd1
>  3     3       8       65        3      active sync   /dev/sde1
>  4     4       8       81        4      active sync   /dev/sdf1
>  5     5       8       97        5      active sync   /dev/sdg1
>  6     6       8      113        6      active sync   /dev/sdh1
>  7     7       8      129        7      active sync   /dev/sdi1
>  8     8       8      145        8      active sync   /dev/sdj1
>  9     9       8      161        9      active sync   /dev/sdk1
> 10    10       8      177       10      active sync   /dev/sdl1
> 11    11       8      193       11      spare   /dev/sdm1
>
> root@localhost:/var/log# mdadm --examine /dev/sdh1
> /dev/sdh1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : 9f962f09:2d47f553:417df021:0032bb18
> Creation Time : Thu Aug 28 09:33:49 2008
>    Raid Level : raid5
> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)
>  Raid Devices : 11
> Total Devices : 12
> Preferred Minor : 0
>
>   Update Time : Thu Aug 28 09:36:07 2008
>         State : active
> Active Devices : 11
> Working Devices : 12
> Failed Devices : 0
> Spare Devices : 1
>      Checksum : 670c7ece - correct
>        Events : 5
>
>        Layout : left-symmetric
>    Chunk Size : 16K
>
>     Number   Major   Minor   RaidDevice State
> this     6       8      113        6      active sync   /dev/sdh1
>
>  0     0       8       17        0      active sync   /dev/sdb1
>  1     1       8       33        1      active sync   /dev/sdc1
>  2     2       8       49        2      active sync   /dev/sdd1
>  3     3       8       65        3      active sync   /dev/sde1
>  4     4       8       81        4      active sync   /dev/sdf1
>  5     5       8       97        5      active sync   /dev/sdg1
>  6     6       8      113        6      active sync   /dev/sdh1
>  7     7       8      129        7      active sync   /dev/sdi1
>  8     8       8      145        8      active sync   /dev/sdj1
>  9     9       8      161        9      active sync   /dev/sdk1
> 10    10       8      177       10      active sync   /dev/sdl1
> 11    11       8      193       11      spare   /dev/sdm1
>
> root@localhost:/var/log# mdadm --examine /dev/sdi1
> /dev/sdi1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : 9f962f09:2d47f553:417df021:0032bb18
> Creation Time : Thu Aug 28 09:33:49 2008
>    Raid Level : raid5
> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)
>  Raid Devices : 11
> Total Devices : 12
> Preferred Minor : 0
>
>   Update Time : Thu Aug 28 09:36:07 2008
>         State : active
> Active Devices : 11
> Working Devices : 12
> Failed Devices : 0
> Spare Devices : 1
>      Checksum : 670c7ee0 - correct
>        Events : 5
>
>        Layout : left-symmetric
>    Chunk Size : 16K
>
>     Number   Major   Minor   RaidDevice State
> this     7       8      129        7      active sync   /dev/sdi1
>
>  0     0       8       17        0      active sync   /dev/sdb1
>  1     1       8       33        1      active sync   /dev/sdc1
>  2     2       8       49        2      active sync   /dev/sdd1
>  3     3       8       65        3      active sync   /dev/sde1
>  4     4       8       81        4      active sync   /dev/sdf1
>  5     5       8       97        5      active sync   /dev/sdg1
>  6     6       8      113        6      active sync   /dev/sdh1
>  7     7       8      129        7      active sync   /dev/sdi1
>  8     8       8      145        8      active sync   /dev/sdj1
>  9     9       8      161        9      active sync   /dev/sdk1
> 10    10       8      177       10      active sync   /dev/sdl1
> 11    11       8      193       11      spare   /dev/sdm1
>
> root@localhost:/var/log# mdadm --examine /dev/sdj1
> /dev/sdj1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : 9f962f09:2d47f553:417df021:0032bb18
> Creation Time : Thu Aug 28 09:33:49 2008
>    Raid Level : raid5
> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)
>  Raid Devices : 11
> Total Devices : 12
> Preferred Minor : 0
>
>   Update Time : Thu Aug 28 09:36:07 2008
>         State : active
> Active Devices : 11
> Working Devices : 12
> Failed Devices : 0
> Spare Devices : 1
>      Checksum : 670c7ef2 - correct
>        Events : 5
>
>        Layout : left-symmetric
>    Chunk Size : 16K
>
>     Number   Major   Minor   RaidDevice State
> this     8       8      145        8      active sync   /dev/sdj1
>
>  0     0       8       17        0      active sync   /dev/sdb1
>  1     1       8       33        1      active sync   /dev/sdc1
>  2     2       8       49        2      active sync   /dev/sdd1
>  3     3       8       65        3      active sync   /dev/sde1
>  4     4       8       81        4      active sync   /dev/sdf1
>  5     5       8       97        5      active sync   /dev/sdg1
>  6     6       8      113        6      active sync   /dev/sdh1
>  7     7       8      129        7      active sync   /dev/sdi1
>  8     8       8      145        8      active sync   /dev/sdj1
>  9     9       8      161        9      active sync   /dev/sdk1
> 10    10       8      177       10      active sync   /dev/sdl1
> 11    11       8      193       11      spare   /dev/sdm1
>
> root@localhost:/var/log# mdadm --examine /dev/sdk1
> /dev/sdk1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : 9f962f09:2d47f553:417df021:0032bb18
> Creation Time : Thu Aug 28 09:33:49 2008
>    Raid Level : raid5
> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)
>  Raid Devices : 11
> Total Devices : 12
> Preferred Minor : 0
>
>   Update Time : Thu Aug 28 09:36:07 2008
>         State : active
> Active Devices : 11
> Working Devices : 12
> Failed Devices : 0
> Spare Devices : 1
>      Checksum : 670c7f04 - correct
>        Events : 5
>
>        Layout : left-symmetric
>    Chunk Size : 16K
>
>     Number   Major   Minor   RaidDevice State
> this     9       8      161        9      active sync   /dev/sdk1
>
>  0     0       8       17        0      active sync   /dev/sdb1
>  1     1       8       33        1      active sync   /dev/sdc1
>  2     2       8       49        2      active sync   /dev/sdd1
>  3     3       8       65        3      active sync   /dev/sde1
>  4     4       8       81        4      active sync   /dev/sdf1
>  5     5       8       97        5      active sync   /dev/sdg1
>  6     6       8      113        6      active sync   /dev/sdh1
>  7     7       8      129        7      active sync   /dev/sdi1
>  8     8       8      145        8      active sync   /dev/sdj1
>  9     9       8      161        9      active sync   /dev/sdk1
> 10    10       8      177       10      active sync   /dev/sdl1
> 11    11       8      193       11      spare   /dev/sdm1
>
> root@localhost:/var/log# mdadm --examine /dev/sdl1
> /dev/sdl1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : 9f962f09:2d47f553:417df021:0032bb18
> Creation Time : Thu Aug 28 09:33:49 2008
>    Raid Level : raid5
> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)
>  Raid Devices : 11
> Total Devices : 12
> Preferred Minor : 0
>
>   Update Time : Thu Aug 28 09:36:07 2008
>         State : active
> Active Devices : 11
> Working Devices : 12
> Failed Devices : 0
> Spare Devices : 1
>      Checksum : 670c7f16 - correct
>        Events : 5
>
>        Layout : left-symmetric
>    Chunk Size : 16K
>
>     Number   Major   Minor   RaidDevice State
> this    10       8      177       10      active sync   /dev/sdl1
>
>  0     0       8       17        0      active sync   /dev/sdb1
>  1     1       8       33        1      active sync   /dev/sdc1
>  2     2       8       49        2      active sync   /dev/sdd1
>  3     3       8       65        3      active sync   /dev/sde1
>  4     4       8       81        4      active sync   /dev/sdf1
>  5     5       8       97        5      active sync   /dev/sdg1
>  6     6       8      113        6      active sync   /dev/sdh1
>  7     7       8      129        7      active sync   /dev/sdi1
>  8     8       8      145        8      active sync   /dev/sdj1
>  9     9       8      161        9      active sync   /dev/sdk1
> 10    10       8      177       10      active sync   /dev/sdl1
> 11    11       8      193       11      spare   /dev/sdm1
>
> root@localhost:/var/log# mdadm --examine /dev/sdm1
> /dev/sdm1:
>         Magic : a92b4efc
>       Version : 00.90.00
>          UUID : 9f962f09:2d47f553:417df021:0032bb18
> Creation Time : Thu Aug 28 09:33:49 2008
>    Raid Level : raid5
> Used Dev Size : 488383936 (465.76 GiB 500.11 GB)
>    Array Size : 4883839360 (4657.59 GiB 5001.05 GB)
>  Raid Devices : 11
> Total Devices : 12
> Preferred Minor : 0
>
>   Update Time : Thu Aug 28 09:36:07 2008
>         State : active
> Active Devices : 11
> Working Devices : 12
> Failed Devices : 0
> Spare Devices : 1
>      Checksum : 670c7f22 - correct
>        Events : 5
>
>        Layout : left-symmetric
>    Chunk Size : 16K
>
>     Number   Major   Minor   RaidDevice State
> this    11       8      193       11      spare   /dev/sdm1
>
>  0     0       8       17        0      active sync   /dev/sdb1
>  1     1       8       33        1      active sync   /dev/sdc1
>  2     2       8       49        2      active sync   /dev/sdd1
>  3     3       8       65        3      active sync   /dev/sde1
>  4     4       8       81        4      active sync   /dev/sdf1
>  5     5       8       97        5      active sync   /dev/sdg1
>  6     6       8      113        6      active sync   /dev/sdh1
>  7     7       8      129        7      active sync   /dev/sdi1
>  8     8       8      145        8      active sync   /dev/sdj1
>  9     9       8      161        9      active sync   /dev/sdk1
> 10    10       8      177       10      active sync   /dev/sdl1
> 11    11       8      193       11      spare   /dev/sdm1
>
> root@localhost:/var/log# mdadm --examine /dev/md0
> mdadm: No md superblock detected on /dev/md0.
>
> root@localhost:/var/log# mdadm --detail /dev/md0
> mdadm: md device /dev/md0 does not appear to be active.
>
> root@localhost:/var/log# cat /etc/mdadm.conf
> DEVICE  /dev/sd*
> ARRAY /dev/md0 level=raid5 num-devices=12  
> UUID=9f962f09:2d47f553:417df021:0032bb18
>
> root@localhost:/var/log# mdadm --query /dev/md0
> /dev/md0: is an md device which is not active
>
> root@localhost:/var/log# mdadm --assemble --scan
> mdadm: no devices found for /dev/md0
>
> root@localhost:/var/log# mdadm -X /dev/md0
> mdadm: failed to read superblock of bitmap file: No such device
>
> root@localhost:/var/log# mdadm -E /dev/md0
> mdadm: No md superblock detected on /dev/md0.
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


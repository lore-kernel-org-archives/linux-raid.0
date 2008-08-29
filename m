From: thomas62186218@aol.com
Subject: Re: No md superblock immediately after creating RAID 5 /dev/md0
Date: Fri, 29 Aug 2008 01:47:50 -0400
Message-ID: <8CAD7B1E82C6F54-1068-40D8@MBLK-M01.sysops.aol.com>
References: <8CAD6FFC01AB7AC-524-231A@webmail-nf07.sim.aol.com> <9b4ac8ccbe69d232ff2d77fd4e3590c2.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9b4ac8ccbe69d232ff2d77fd4e3590c2.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Neil,

Sorry for the confusion. I mistyped the -C command in my initial email 
(forgot the hot-spare) and thus the confusion.

Here is the full output from the top using copy/paste. Thank you in 
advance for your help!!


root@localhost:~# fdisk -l

Disk /dev/sda: 2095 MB, 2095865856 bytes
65 heads, 62 sectors/track, 1015 cylinders
Units = cylinders of 4030 * 512 = 2063360 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1         500     1007469   83  Linux
/dev/sda2   *         501        1015     1037725   83  Linux

Disk /dev/sdb: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x0b65bb81

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdc: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x273d0b7e

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdd: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x03cf614e

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sde: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xa6b886bb

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdf: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x65752a1a

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdg: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x9f188135

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdh: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xc19605d4

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdi: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x1e6c4f8e

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdj: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xd13edb81

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdk: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x5bbd83b9

Disk /dev/sdk doesn't contain a valid partition table

Disk /dev/sdl: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xebcdc998

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdm: 1000.2 GB, 1000204886016 bytes
255 heads, 63 sectors/track, 121601 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xd90b43ff

   Device Boot      Start         End      Blocks   Id  System
root@localhost:~#
root@localhost:~# cat /etc/mdadm.conf
root@localhost:~#
root@localhost:~# mdadm --examine --scan --verbose
root@localhost:~#
root@localhost:~# mdadm -Cv /dev/md0 -n11 -l5 -c128 /dev/sd[b-l] -x1 
/dev/sdm -R -f --verbose
mdadm: layout defaults to left-symmetric
mdadm: size set to 976762496K
mdadm: array /dev/md0 started.
root@localhost:~#
root@localhost:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid5 sdm[11](S) sdl[10] sdk[9] sdj[8] sdi[7] sdh[6] 
sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
       9767624960 blocks level 5, 128k chunk, algorithm 2 [11/11] 
[UUUUUUUUUUU]
       [>....................]  resync =  0.0% (265128/976762496) 
finish=306.8min speed=53025K/sec

unused devices: <none>
root@localhost:~#
root@localhost:~# cat /etc/mdadm.conf
root@localhost:~#
root@localhost:~# mdadm --examine --scan --verbose
ARRAY /dev/md0 level=raid5 num-devices=11 
UUID=09db8873:25545721:e5d66b81:63573add
    spares=1   
devices=/dev/sdm,/dev/sdl,/dev/sdk,/dev/sdj,/dev/sdi,/dev/sdh,/dev/sdg,/d
ev/sdf,/dev/sde,/dev/sdd,/dev/sdc,/dev/sdb
root@localhost:~#
root@localhost:~# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90
  Creation Time : Fri Aug 29 05:34:40 2008
     Raid Level : raid5
     Array Size : 9767624960 (9315.13 GiB 10002.05 GB)
  Used Dev Size : 976762496 (931.51 GiB 1000.20 GB)
   Raid Devices : 11
  Total Devices : 12
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Fri Aug 29 05:34:41 2008
          State : active, resyncing
 Active Devices : 11
Working Devices : 12
 Failed Devices : 0
  Spare Devices : 1

         Layout : left-symmetric
     Chunk Size : 128K

 Rebuild Status : 0% complete

           UUID : 09db8873:25545721:e5d66b81:63573add
         Events : 0.3

    Number   Major   Minor   RaidDevice State
       0       8       16        0      active sync   /dev/sdb
       1       8       32        1      active sync   /dev/sdc
       2       8       48        2      active sync   /dev/sdd
       3       8       64        3      active sync   /dev/sde
       4       8       80        4      active sync   /dev/sdf
       5       8       96        5      active sync   /dev/sdg
       6       8      112        6      active sync   /dev/sdh
       7       8      128        7      active sync   /dev/sdi
       8       8      144        8      active sync   /dev/sdj
       9       8      160        9      active sync   /dev/sdk
      10       8      176       10      active sync   /dev/sdl

      11       8      192        -      spare   /dev/sdm
root@localhost:~#
root@localhost:~# shutdown -r now

Broadcast message from root@localhost
        (/dev/pts/0) at 5:35 ...

The system is going down for reboot NOW!
root@localhost:~# login as: root
root@192.168.1.15's password:
root@localhost:~#
root@localhost:~#
root@localhost:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
unused devices: <none>
root@localhost:~#
root@localhost:~# mdadm --examine --scan --verbose
ARRAY /dev/md0 level=raid5 num-devices=11 
UUID=09db8873:25545721:e5d66b81:63573add
    spares=1   
devices=/dev/sdm,/dev/sdl,/dev/sdk,/dev/sdj,/dev/sdi,/dev/sdh,/dev/sdg,/d
ev/sdf,/dev/sde,/dev/sdd,/dev/sdc,/dev/sdb
root@localhost:~#
root@localhost:~# cat /etc/mdadm.conf
root@localhost:~#
root@localhost:~# mdadm --assemble --scan --verbose
mdadm: No arrays found in config file
root@localhost:~#
root@localhost:~# mdadm --scan
mdadm: --scan does not set the mode, and so cannot be the first option.
root@localhost:~# mdadm -E /dev/md0
mdadm: cannot open /dev/md0: No such file or directory
root@localhost:~#
root@localhost:~# mdadm -X /dev/md0
mdadm: failed to find file /dev/md0: No such file or directory
root@localhost:~# mdadm --assemble --scan --verbose /dev/md0
mdadm: /dev/md0 not identified in config file.
root@localhost:~# mdadm --query /dev/md0
mdadm: cannot open /dev/md0: No such file or directory
root@localhost:~#





-----Original Message-----
From: NeilBrown <neilb@suse.de>
To: thomas62186218@aol.com
Sent: Thu, 28 Aug 2008 5:04 am
Subject: Re: No md superblock immediately after creating RAID 5 /dev/md0










On Thu, August 28, 2008 6:32 pm, thomas62186218@aol.com wrote:

>
> mdadm -Cv /dev/md0 -n12 -l5 -c128 /dev/sd[b-m] -R -f
                       ^^
12.



>
> root@localhost:~# cat /proc/mdstat
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [ra           id10]
> md0 : active raid5 sdm1[11](S) sdl1[10] sdk1[9] sdj1[8] sdi1[7] 
sdh1[6]
> sdg1[5]            sdf1[4] sde1[3] sdd1[2] sdc1[1] sdb1[0]
>        4883839360 blocks level 5, 16k chunk, algorithm 2 [11/11]
                                                            ^^
11!


> root@localhost:~# cat /etc/mdadm.conf
> DEVICE  /dev/sd*
> ARRAY /dev/md0 level=raid5 num-devices=12
                                         ^^
12 ??


>    Raid Devices : 11
                    ^^

Something odd here.


> root@localhost:/var/log# mdadm --assemble --scan
> mdadm: no devices found for /dev/md0

Could you add --verbose to that line and try again?

NeilBrown

P.S.  Thanks for including lots of details!






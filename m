From: linbloke <linbloke@fastmail.fm>
Subject: mdadm not creating symlinks for partitioned arrays
Date: Mon, 30 May 2011 12:23:35 +1000
Message-ID: <4DE2FFA7.2060605@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi mdadm-ers,

I'm pretty sure I have a complete /etc/mdadm.conf and I've regenerated 
the initramfs, but the symlinks from /dev/md/array0p1 to /dev/md_123p1 
are not being created,  neither on boot or with a manual assembly. My 
read of the mdadm man page suggests that mdadm should create these 
symlinks when the array name ends in a number, the array device is 
specified in /dev/md/, and the CREATE auto line exists in 
/etc/mdadm.conf. I've got config for other services that specifies these 
array partitions as targets and when they are not created, the services 
fail to start (naturally :-) I chose these names as they should be 
stationary targets, ie persistent names across reboots, whereas the 
/dev/md_d127 names seem to be dynamically assigned, based on order of 
raid array discovery and position in the mdadm.conf file.

The partitioned arrays are started ok and the partitions detected, I 
just can't get mdadm(/udev ??) to create the appropriate symlinks. Does 
anyone know how to get these to be created for a partitioned array?

I have:
/dev:
brw-rw---- 1 root disk 254, 8128 2011-05-30 11:39 /dev/md_d127
brw-rw---- 1 root disk 254, 8129 2011-05-30 11:39 /dev/md_d127p1

/dev/md:
total 0
lrwxrwxrwx 1 root root 10 2011-05-30 11:39 h001r003 -> ../md_d127


I need:
/dev/md:
lrwxrwxrwx 1 root root 10 2011-05-30 11:39 h001r003p1 -> ../md_d127p1


Thanks kindly,

Josh



wynyard:~ # cat /etc/SuSE-release
SUSE Linux Enterprise Server 11 (x86_64)
VERSION = 11
PATCHLEVEL = 1

wynyard:~ # mdadm -V
mdadm - v3.0.3 - 22nd October 2009

wynyard:~ # uname -a
Linux wynyard 2.6.32.36-0.5-xen #1 SMP 2011-04-14 10:12:31 +0200 x86_64 
x86_64 x86_64 GNU/Linux


wynyard:~ # cat /proc/mdstat
Personalities : [raid1] [raid0] [raid10] [raid6] [raid5] [raid4] [linear]
md_d127 : active (auto-read-only) raid10 sdd[0] sdg[3] sdf[2] sde[1]
      3907027968 blocks super 1.2 256K chunks 2 far-copies [4/4] [UUUU]
      
md_d125 : active (auto-read-only) raid1 sdj[0] sdk[1]
      293036048 blocks super 1.2 [2/2] [UU]
      
md_d126 : active (auto-read-only) raid1 sdh[0] sdi[1]
      1953514448 blocks super 1.2 [2/2] [UU]
      
md0 : active raid1 sda1[0] sdb1[1]
      506004 blocks super 1.0 [2/2] [UU]
      bitmap: 0/8 pages [0KB], 32KB chunk

md1 : active raid1 sda2[0] sdb2[1]
      160328628 blocks super 1.0 [2/2] [UU]
      bitmap: 2/153 pages [8KB], 512KB chunk

unused devices: <none>


wynyard:~ # cat /etc/mdadm.conf
DEVICE containers partitions

CREATE auto=part8

ARRAY /dev/md0 UUID=62862472:2a1986f3:3aaf03f8:98f91297
ARRAY /dev/md1 UUID=b74f4f13:637b1874:9681b4f8:789d572c
ARRAY /dev/md/h001r003 auto=part8 metadata=1.02 name=wynyard:h001r003 
UUID=9ca01512:203443f7:a2173168:5f44986e
ARRAY /dev/md/h001r004 auto=part8 metadata=1.02 name=wynyard:h001r004 
UUID=5b4f3aa8:f8de5a24:7933c52c:18096707
ARRAY /dev/md/h001r005 auto=part8 metadata=1.02 name=wynyard:h001r005 
UUID=b25a5f84:57861501:efe9943a:a804fc03



wynyard:~ # ls -l /dev/md*
brw-rw---- 1 root disk   9,    0 2011-05-11 01:28 /dev/md0
brw-rw---- 1 root disk   9,    1 2011-05-11 01:28 /dev/md1
brw-r----- 1 root disk   9,   10 2011-05-11 01:28 /dev/md10
brw-r----- 1 root disk   9,   11 2011-05-11 01:28 /dev/md11
brw-r----- 1 root disk   9,   12 2011-05-11 01:28 /dev/md12
brw-r----- 1 root disk   9,   13 2011-05-11 01:28 /dev/md13
brw-r----- 1 root disk   9,   14 2011-05-11 01:28 /dev/md14
brw-r----- 1 root disk   9,   15 2011-05-11 01:28 /dev/md15
brw-r----- 1 root disk   9,   16 2011-05-11 01:28 /dev/md16
brw-r----- 1 root disk   9,   17 2011-05-11 01:28 /dev/md17
brw-r----- 1 root disk   9,   18 2011-05-11 01:28 /dev/md18
brw-r----- 1 root disk   9,   19 2011-05-11 01:28 /dev/md19
brw-r----- 1 root disk   9,    2 2011-05-11 01:28 /dev/md2
brw-r----- 1 root disk   9,   20 2011-05-11 01:28 /dev/md20
brw-r----- 1 root disk   9,   21 2011-05-11 01:28 /dev/md21
brw-r----- 1 root disk   9,   22 2011-05-11 01:28 /dev/md22
brw-r----- 1 root disk   9,   23 2011-05-11 01:28 /dev/md23
brw-r----- 1 root disk   9,   24 2011-05-11 01:28 /dev/md24
brw-r----- 1 root disk   9,   25 2011-05-11 01:28 /dev/md25
brw-r----- 1 root disk   9,   26 2011-05-11 01:28 /dev/md26
brw-r----- 1 root disk   9,   27 2011-05-11 01:28 /dev/md27
brw-r----- 1 root disk   9,   28 2011-05-11 01:28 /dev/md28
brw-r----- 1 root disk   9,   29 2011-05-11 01:28 /dev/md29
brw-r----- 1 root disk   9,    3 2011-05-11 01:28 /dev/md3
brw-r----- 1 root disk   9,   30 2011-05-11 01:28 /dev/md30
brw-r----- 1 root disk   9,   31 2011-05-11 01:28 /dev/md31
brw-r----- 1 root disk   9,    4 2011-05-11 01:28 /dev/md4
brw-r----- 1 root disk   9,    5 2011-05-11 01:28 /dev/md5
brw-r----- 1 root disk   9,    6 2011-05-11 01:28 /dev/md6
brw-r----- 1 root disk   9,    7 2011-05-11 01:28 /dev/md7
brw-r----- 1 root disk   9,    8 2011-05-11 01:28 /dev/md8
brw-r----- 1 root disk   9,    9 2011-05-11 01:28 /dev/md9
brw-rw---- 1 root disk 254, 8000 2011-05-30 11:36 /dev/md_d125
brw-rw---- 1 root disk 254, 8001 2011-05-30 11:36 /dev/md_d125p1
brw-rw---- 1 root disk 254, 8002 2011-05-30 11:36 /dev/md_d125p2
brw-rw---- 1 root disk 254, 8064 2011-05-30 11:36 /dev/md_d126
brw-rw---- 1 root disk 254, 8065 2011-05-30 11:36 /dev/md_d126p1
brw-rw---- 1 root disk 254, 8066 2011-05-30 11:36 /dev/md_d126p2
brw-rw---- 1 root disk 254, 8128 2011-05-30 11:39 /dev/md_d127
brw-rw---- 1 root disk 254, 8129 2011-05-30 11:39 /dev/md_d127p1

/dev/md:
total 0
lrwxrwxrwx 1 root root 10 2011-05-30 11:39 h001r003 -> ../md_d127
lrwxrwxrwx 1 root root 10 2011-05-30 11:36 h001r004 -> ../md_d126
lrwxrwxrwx 1 root root 10 2011-05-30 11:36 h001r005 -> ../md_d125

dmesg:
[  263.689751] md: bind<sde>
[  263.689834] md: bind<sdf>
[  263.689914] md: bind<sdg>
[  263.689998] md: bind<sdd>
[  263.691438] raid10: raid set md_d127 active with 4 out of 4 devices
[  263.691454] md_d127: detected capacity change from 0 to 4000796639232
[  263.692855]  md_d127: p1

wynyard:~ # mdadm -vD /dev/md/h001r003
/dev/md/h001r003:
        Version : 1.02
  Creation Time : Sat May 21 15:26:26 2011
     Raid Level : raid10
     Array Size : 3907027968 (3726.03 GiB 4000.80 GB)
  Used Dev Size : 1953513984 (1863.02 GiB 2000.40 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Mon May 30 12:20:31 2011
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : far=2
     Chunk Size : 256K

           Name : wynyard:h001r003  (local to host wynyard)
           UUID : 9ca01512:203443f7:a2173168:5f44986e
         Events : 40

    Number   Major   Minor   RaidDevice State
       0       8       48        0      active sync   /dev/sdd
       1       8       64        1      active sync   /dev/sde
       2       8       80        2      active sync   /dev/sdf
       3       8       96        3      active sync   /dev/sdg


wynyard:~ # mdadm -vE /dev/sd[d-g]
/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9ca01512:203443f7:a2173168:5f44986e
           Name : wynyard:h001r003  (local to host wynyard)
  Creation Time : Sat May 21 15:26:26 2011
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 7814055936 (3726.03 GiB 4000.80 GB)
  Used Dev Size : 3907027968 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a1f7a0dc:7112a2bc:e11d6cd5:930ec677

    Update Time : Mon May 30 12:22:36 2011
       Checksum : f57561d9 - correct
         Events : 40

         Layout : far=2
     Chunk Size : 256K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9ca01512:203443f7:a2173168:5f44986e
           Name : wynyard:h001r003  (local to host wynyard)
  Creation Time : Sat May 21 15:26:26 2011
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 7814055936 (3726.03 GiB 4000.80 GB)
  Used Dev Size : 3907027968 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b9904f82:b7aa0ded:fe828141:f556af7d

    Update Time : Mon May 30 12:22:36 2011
       Checksum : 3d8e40b7 - correct
         Events : 40

         Layout : far=2
     Chunk Size : 256K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9ca01512:203443f7:a2173168:5f44986e
           Name : wynyard:h001r003  (local to host wynyard)
  Creation Time : Sat May 21 15:26:26 2011
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 7814055936 (3726.03 GiB 4000.80 GB)
  Used Dev Size : 3907027968 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 82ea41f3:8d897dcd:6c0cfe16:b8b2a35a

    Update Time : Mon May 30 12:22:36 2011
       Checksum : 41615e88 - correct
         Events : 40

         Layout : far=2
     Chunk Size : 256K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing)
/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 9ca01512:203443f7:a2173168:5f44986e
           Name : wynyard:h001r003  (local to host wynyard)
  Creation Time : Sat May 21 15:26:26 2011
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 3907028896 (1863.02 GiB 2000.40 GB)
     Array Size : 7814055936 (3726.03 GiB 4000.80 GB)
  Used Dev Size : 3907027968 (1863.02 GiB 2000.40 GB)
    Data Offset : 272 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : a6f5741b:bbe0092a:2568b4fd:5dff4755

    Update Time : Mon May 30 12:22:36 2011
       Checksum : a77b6938 - correct
         Events : 40

         Layout : far=2
     Chunk Size : 256K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing)




wynyard:~ # fdisk -l /dev/sd[d-g]

Disk /dev/sdd: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x000a1c3c

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sde: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x0005e157

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdf: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x000592c0

   Device Boot      Start         End      Blocks   Id  System

Disk /dev/sdg: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x0009242e

   Device Boot      Start         End      Blocks   Id  System



From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: Re: Inactive arrays
Date: Tue, 13 Sep 2016 22:46:19 +0100
Message-ID: <CAHscji1WEoeyHEhYguEiYWDoPunHM+jjoRU8=kz3M7JYLskCaQ@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <57D72092.20704@youngman.org.uk> <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
 <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
 <CAHscji0H7kEDzhg3KpUYrdk5MA06k-F5Xe95=EL7mo-_mS3y5A@mail.gmail.com>
 <CAJCQCtS-aYNgy7MM990CTKFqcNk8bf+ggzX3QRrD+yQZfdVxnA@mail.gmail.com>
 <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com>
 <CAJCQCtT_4O8r-cJQaw7P-47ekawYUH7cuw-30vbB8J_J+Kf+WQ@mail.gmail.com>
 <CAHscji3LX3+c_ighYMMDQo1E4ygdepr=Gt2wVmWzdLj+F+tVsQ@mail.gmail.com> <CAJCQCtRnundJMzxe-7_KrCav-rBHxUw7U0dPifurE4dyXtY59w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtRnundJMzxe-7_KrCav-rBHxUw7U0dPifurE4dyXtY59w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Sorry, mdadm -E on the individual drives and their partitions. I'm
> curious what metadata it finds on each if any.

[root@lamachine ~]# mdadm -E /dev/sd*
/dev/sda:
   MBR Magic : aa55
Partition[0] :     61440000 sectors at           63 (type fd)
Partition[1] :    512000000 sectors at     61440063 (type fd)
Partition[2] :    403328002 sectors at    573440063 (type 05)
/dev/sda1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 9af006ca:8845bbd3:bfe78010:bc810f04
  Creation Time : Thu Dec  3 22:12:12 2009
     Raid Level : raid10
  Used Dev Size : 30719936 (29.30 GiB 31.46 GB)
     Array Size : 30719936 (29.30 GiB 31.46 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 126

    Update Time : Tue Sep 13 22:43:06 2016
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ed981d35 - correct
         Events : 264152

         Layout : near=2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8        1        1      active sync   /dev/sda1

   0     0       8       82        0      active sync   /dev/sdf2
   1     1       8        1        1      active sync   /dev/sda1
/dev/sda2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 2cff15d1:e411447b:fd5d4721:03e44022 (local to host lamachine)
  Creation Time : Mon Feb 11 07:54:36 2013
     Raid Level : raid5
  Used Dev Size : 255999936 (244.14 GiB 262.14 GB)
     Array Size : 511999872 (488.28 GiB 524.29 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 2

    Update Time : Tue Sep 13 20:29:02 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 73b16d69 - correct
         Events : 611

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8        2        2      active sync   /dev/sda2

   0     0       8       83        0      active sync   /dev/sdf3
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8        2        2      active sync   /dev/sda2
/dev/sda3:
   MBR Magic : aa55
Partition[0] :     62910589 sectors at           63 (type 83)
Partition[1] :      7116795 sectors at     82445692 (type 05)
/dev/sda5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : acd5374f:72628c93:6a906c4b:5f675ce5
           Name : reading.homeunix.com:3
  Creation Time : Tue Jul 26 19:00:28 2011
     Raid Level : raid0
   Raid Devices : 3

 Avail Dev Size : 62908541 (30.00 GiB 32.21 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=0 sectors
          State : clean
    Device UUID : a0efc1b3:94cc6eb8:deea76ca:772b2d2d

    Update Time : Tue Jul 26 19:00:28 2011
       Checksum : 9eba9119 - correct
         Events : 0

     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
mdadm: No md superblock detected on /dev/sda6.
/dev/sdb:
   MBR Magic : aa55
Partition[1] :    512000000 sectors at       409663 (type fd)
Partition[2] :     16384000 sectors at    512409663 (type 82)
Partition[3] :    447974402 sectors at    528793663 (type 05)
/dev/sdb2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 2cff15d1:e411447b:fd5d4721:03e44022 (local to host lamachine)
  Creation Time : Mon Feb 11 07:54:36 2013
     Raid Level : raid5
  Used Dev Size : 255999936 (244.14 GiB 262.14 GB)
     Array Size : 511999872 (488.28 GiB 524.29 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 2

    Update Time : Tue Sep 13 20:29:02 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 73b16d77 - correct
         Events : 611

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       18        1      active sync   /dev/sdb2

   0     0       8       83        0      active sync   /dev/sdf3
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8        2        2      active sync   /dev/sda2
mdadm: No md superblock detected on /dev/sdb3.
/dev/sdb4:
   MBR Magic : aa55
Partition[0] :     62912354 sectors at           63 (type 83)
Partition[1] :      7116795 sectors at     82447457 (type 05)
/dev/sdb5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : acd5374f:72628c93:6a906c4b:5f675ce5
           Name : reading.homeunix.com:3
  Creation Time : Tue Jul 26 19:00:28 2011
     Raid Level : raid0
   Raid Devices : 3

 Avail Dev Size : 62910306 (30.00 GiB 32.21 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=0 sectors
          State : clean
    Device UUID : 152d0202:64efb3e7:f23658c3:82a239a1

    Update Time : Tue Jul 26 19:00:28 2011
       Checksum : 892dbb61 - correct
         Events : 0

     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
mdadm: No md superblock detected on /dev/sdb6.
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : f2372cb9:d3816fd6:ce86d826:882ec82e
           Name : lamachine:128  (local to host lamachine)
  Creation Time : Fri Oct 24 15:24:38 2014
     Raid Level : raid5
   Raid Devices : 3

 Avail Dev Size : 4294705152 (2047.88 GiB 2198.89 GB)
     Array Size : 4294705152 (4095.75 GiB 4397.78 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 1f652d4f:92fccd8e:b439abf2:76b881e1

Internal Bitmap : 8 sectors from superblock
    Update Time : Thu Feb  4 18:55:34 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : ed602b13 - correct
         Events : 4154

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd2:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 895dae98:d1a496de:4f590b8b:cb8ac12a
           Name : lamachine:129  (local to host lamachine)
  Creation Time : Mon Nov 10 16:28:11 2014
     Raid Level : raid0
   Raid Devices : 3

 Avail Dev Size : 1048313856 (499.88 GiB 536.74 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=262056 sectors, after=0 sectors
          State : clean
    Device UUID : 562dd382:5ccc00aa:449ea7e4:d8b266c2

    Update Time : Mon Nov 10 16:28:11 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 937158c1 - correct
         Events : 0

     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdf:
   MBR Magic : aa55
Partition[0] :       407552 sectors at         2048 (type 83)
Partition[1] :     61440000 sectors at       409663 (type fd)
Partition[2] :    512000000 sectors at     61849663 (type fd)
Partition[3] :    402918402 sectors at    573849663 (type 05)
mdadm: No md superblock detected on /dev/sdf1.
/dev/sdf2:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 9af006ca:8845bbd3:bfe78010:bc810f04
  Creation Time : Thu Dec  3 22:12:12 2009
     Raid Level : raid10
  Used Dev Size : 30719936 (29.30 GiB 31.46 GB)
     Array Size : 30719936 (29.30 GiB 31.46 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 126

    Update Time : Tue Sep 13 22:43:06 2016
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ed981d84 - correct
         Events : 264152

         Layout : near=2
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       82        0      active sync   /dev/sdf2

   0     0       8       82        0      active sync   /dev/sdf2
   1     1       8        1        1      active sync   /dev/sda1
/dev/sdf3:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 2cff15d1:e411447b:fd5d4721:03e44022 (local to host lamachine)
  Creation Time : Mon Feb 11 07:54:36 2013
     Raid Level : raid5
  Used Dev Size : 255999936 (244.14 GiB 262.14 GB)
     Array Size : 511999872 (488.28 GiB 524.29 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 2

    Update Time : Tue Sep 13 20:29:02 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 73b16db6 - correct
         Events : 611

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       83        0      active sync   /dev/sdf3

   0     0       8       83        0      active sync   /dev/sdf3
   1     1       8       18        1      active sync   /dev/sdb2
   2     2       8        2        2      active sync   /dev/sda2
/dev/sdf4:
   MBR Magic : aa55
Partition[0] :     62918679 sectors at           63 (type 83)
Partition[1] :      7116795 sectors at     82453782 (type 05)
/dev/sdf5:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : acd5374f:72628c93:6a906c4b:5f675ce5
           Name : reading.homeunix.com:3
  Creation Time : Tue Jul 26 19:00:28 2011
     Raid Level : raid0
   Raid Devices : 3

 Avail Dev Size : 62916631 (30.00 GiB 32.21 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=1968 sectors, after=0 sectors
          State : clean
    Device UUID : 5778cd64:0bbba183:ef3270a8:41f83aca

    Update Time : Tue Jul 26 19:00:28 2011
       Checksum : 96003cba - correct
         Events : 0

     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
mdadm: No md superblock detected on /dev/sdf6.
[root@lamachine ~]#

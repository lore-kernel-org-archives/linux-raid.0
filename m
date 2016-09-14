From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: Re: Inactive arrays
Date: Wed, 14 Sep 2016 19:16:57 +0100
Message-ID: <CAHscji2BKxNDLzZUonGHVB8PzeFbtuwn32NBaX315QPvvhOxyg@mail.gmail.com>
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
 <CAJCQCtRdbWg7HgX=wghd8OBUcauiVfES6NSOKOZj38HMWVg65A@mail.gmail.com>
 <CAHscji1fgVrKwOwf+sCfOrg-MNz0MwRzXAJswKcP=vP2x0PVug@mail.gmail.com>
 <CAJCQCtSTaByUR_2dnGrA0y0dtTaS_sweLKn19QD1=wv+2mnvHg@mail.gmail.com>
 <CAHscji2dhdE7mL-4i8mE6sShQtGCB6v1K02TBQQD4-6R-ZtoZw@mail.gmail.com>
 <CAJCQCtQXd6GgXhu-7h9nNjA1zfdoH_TAEkeQajYv5vsmuG2Vpw@mail.gmail.com>
 <CAHscji1wVYzpzu8X+GYuuxZPdLzY-f+8oogyH7ttqVwMJe2=iQ@mail.gmail.com>
 <CAJCQCtQ3kAKd4U=MgVawU9D6QKuxC+XjLYR6EyL87wuyBvvmtg@mail.gmail.com> <CAJCQCtSsC3=hh60PudHqziubnv_KVFevbCgV3MNZKnL44Fow=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtSsC3=hh60PudHqziubnv_KVFevbCgV3MNZKnL44Fow=Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

BRAVO!!!!!!

Thanks a million Chris! After following your advice on recovering the
MBR and the GPT the arrays re-assembled automatically and all data is
there.

I already changed the type to make it consistent (FD00 on both
partitions) and working on setting up the timeouts to 180 at boot
time. Other than replacing the green drives with something more
suitable (any suggestions are welcome), what else would you suggest to
change to make the setup a bit more consistent and upgrade proof (i.e.
having different metadata versions doesn't look right to me)?

I'd also like to thank Wol and Adam for their help and for keeping the
thread alive.

Thanks again and again,

This is the current status:

[root@lamachine ~]# mdadm -D /dev/md*
/dev/md126:
        Version : 0.90
  Creation Time : Thu Dec  3 22:12:12 2009
     Raid Level : raid10
     Array Size : 30719936 (29.30 GiB 31.46 GB)
  Used Dev Size : 30719936 (29.30 GiB 31.46 GB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 126
    Persistence : Superblock is persistent

    Update Time : Wed Sep 14 19:02:55 2016
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=2
     Chunk Size : 64K

           UUID : 9af006ca:8845bbd3:bfe78010:bc810f04
         Events : 0.264152

    Number   Major   Minor   RaidDevice State
       0       8       82        0      active sync set-A   /dev/sdf2
       1       8        1        1      active sync set-B   /dev/sda1
/dev/md127:
        Version : 1.2
  Creation Time : Tue Jul 26 19:00:28 2011
     Raid Level : raid0
     Array Size : 94367232 (90.00 GiB 96.63 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Tue Jul 26 19:00:28 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 512K

           Name : reading.homeunix.com:3
           UUID : acd5374f:72628c93:6a906c4b:5f675ce5
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       85        0      active sync   /dev/sdf5
       1       8       21        1      active sync   /dev/sdb5
       2       8        5        2      active sync   /dev/sda5
/dev/md128:
        Version : 1.2
  Creation Time : Fri Oct 24 15:24:38 2014
     Raid Level : raid5
     Array Size : 4294705152 (4095.75 GiB 4397.78 GB)
  Used Dev Size : 2147352576 (2047.88 GiB 2198.89 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed Sep 14 18:46:47 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 512K

           Name : lamachine:128  (local to host lamachine)
           UUID : f2372cb9:d3816fd6:ce86d826:882ec82e
         Events : 4154

    Number   Major   Minor   RaidDevice State
       0       8       65        0      active sync   /dev/sde1
       1       8       33        1      active sync   /dev/sdc1
       3       8       49        2      active sync   /dev/sdd1
/dev/md129:
        Version : 1.2
  Creation Time : Mon Nov 10 16:28:11 2014
     Raid Level : raid0
     Array Size : 1572470784 (1499.63 GiB 1610.21 GB)
   Raid Devices : 3
  Total Devices : 3
    Persistence : Superblock is persistent

    Update Time : Mon Nov 10 16:28:11 2014
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

     Chunk Size : 512K

           Name : lamachine:129  (local to host lamachine)
           UUID : 895dae98:d1a496de:4f590b8b:cb8ac12a
         Events : 0

    Number   Major   Minor   RaidDevice State
       0       8       66        0      active sync   /dev/sde2
       1       8       34        1      active sync   /dev/sdc2
       2       8       50        2      active sync   /dev/sdd2
/dev/md2:
        Version : 0.90
  Creation Time : Mon Feb 11 07:54:36 2013
     Raid Level : raid5
     Array Size : 511999872 (488.28 GiB 524.29 GB)
  Used Dev Size : 255999936 (244.14 GiB 262.14 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Wed Sep 14 18:48:51 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           UUID : 2cff15d1:e411447b:fd5d4721:03e44022 (local to host lamachine)
         Events : 0.611

    Number   Major   Minor   RaidDevice State
       0       8       83        0      active sync   /dev/sdf3
       1       8       18        1      active sync   /dev/sdb2
       2       8        2        2      active sync   /dev/sda2
[root@lamachine ~]#

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

    Update Time : Wed Sep 14 19:07:26 2016
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ed993c29 - correct
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

    Update Time : Wed Sep 14 18:48:51 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 73b2a76e - correct
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

    Update Time : Wed Sep 14 18:48:51 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 73b2a77c - correct
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
/dev/sdc1:
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
    Device UUID : 8b1bac5c:6c2cb5a4:bff59099:986b26cd

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Sep 14 18:46:47 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : a4766ee5 - correct
         Events : 4154

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc2:
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
    Device UUID : 8bc41f51:9af76d31:36349135:2d004cb3

    Update Time : Mon Nov 10 16:28:11 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 2af9fe79 - correct
         Events : 0

     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
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
    Update Time : Wed Sep 14 18:46:47 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : ee861974 - correct
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
/dev/sde1:
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
    Device UUID : 95334f42:beba0d90:8a0854f4:7dfdbd31

Internal Bitmap : 8 sectors from superblock
    Update Time : Wed Sep 14 18:46:47 2016
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 34ccb9f0 - correct
         Events : 4154

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde2:
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
    Device UUID : fd6e6f59:89dad658:e361db17:7c15a63f

    Update Time : Mon Nov 10 16:28:11 2014
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : c956ced4 - correct
         Events : 0

     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAA ('A' == active, '.' == missing, 'R' == replacing)
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

    Update Time : Wed Sep 14 19:07:26 2016
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ed993c78 - correct
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

    Update Time : Wed Sep 14 18:48:51 2016
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 73b2a7bb - correct
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
[root@lamachine ~]# cat /etc/mdadm.conf
# mdadm.conf written out by anaconda
MAILADDR root
AUTO +imsm +1.x -all
ARRAY /dev/md2 level=raid5 num-devices=3
UUID=2cff15d1:e411447b:fd5d4721:03e44022
ARRAY /dev/md126 level=raid10 num-devices=2
UUID=9af006ca:8845bbd3:bfe78010:bc810f04
ARRAY /dev/md127 level=raid0 num-devices=3
UUID=acd5374f:72628c93:6a906c4b:5f675ce5
ARRAY /dev/md128 metadata=1.2 spares=1 name=lamachine:128
UUID=f2372cb9:d3816fd6:ce86d826:882ec82e
ARRAY /dev/md129 metadata=1.2 name=lamachine:129
UUID=895dae98:d1a496de:4f590b8b:cb8ac12a
[root@lamachine ~]#

On 14 September 2016 at 17:13, Chris Murphy <lists@colorremedies.com> wrote:
> Low priority but you could make the type codes consistent for both
> partitions. It doesn't matter if they're 8300 or FD00 on GPT disks,
> there's nothing I know that actually uses this information. FD00 is
> maybe slightly better only in that it'll flag a human to expect that
> there's mdadm metadata on this partition rather than a file system.
>
>
> Chris

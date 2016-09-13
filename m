From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: Re: Inactive arrays
Date: Tue, 13 Sep 2016 21:36:08 +0100
Message-ID: <CAHscji3LX3+c_ighYMMDQo1E4ygdepr=Gt2wVmWzdLj+F+tVsQ@mail.gmail.com>
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
 <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com> <CAJCQCtT_4O8r-cJQaw7P-47ekawYUH7cuw-30vbB8J_J+Kf+WQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtT_4O8r-cJQaw7P-47ekawYUH7cuw-30vbB8J_J+Kf+WQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Maybe start out with 'mdadm -D' on everything... literally everything,
> every whole drive (i.e. /dev/sdd, /dev/sdc, all of them) and also
> everyone of their partitions; and see if it's possible to sort out
> this mess.

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

    Update Time : Tue Sep 13 21:33:13 2016
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
     Raid Level : raid0
  Total Devices : 1
    Persistence : Superblock is persistent

          State : inactive

           Name : lamachine:128  (local to host lamachine)
           UUID : f2372cb9:d3816fd6:ce86d826:882ec82e
         Events : 4154

    Number   Major   Minor   RaidDevice

       -       8       49        -        /dev/sdd1
/dev/md129:
        Version : 1.2
     Raid Level : raid0
  Total Devices : 1
    Persistence : Superblock is persistent

          State : inactive

           Name : lamachine:129  (local to host lamachine)
           UUID : 895dae98:d1a496de:4f590b8b:cb8ac12a
         Events : 0

    Number   Major   Minor   RaidDevice

       -       8       50        -        /dev/sdd2
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

    Update Time : Tue Sep 13 20:29:02 2016
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
[root@lamachine ~]# mdadm -D /dev/sd*
mdadm: /dev/sda does not appear to be an md device
mdadm: /dev/sda1 does not appear to be an md device
mdadm: /dev/sda2 does not appear to be an md device
mdadm: /dev/sda3 does not appear to be an md device
mdadm: /dev/sda5 does not appear to be an md device
mdadm: /dev/sda6 does not appear to be an md device
mdadm: /dev/sdb does not appear to be an md device
mdadm: /dev/sdb2 does not appear to be an md device
mdadm: /dev/sdb3 does not appear to be an md device
mdadm: /dev/sdb4 does not appear to be an md device
mdadm: /dev/sdb5 does not appear to be an md device
mdadm: /dev/sdb6 does not appear to be an md device
mdadm: /dev/sdc does not appear to be an md device
mdadm: /dev/sdd does not appear to be an md device
mdadm: /dev/sdd1 does not appear to be an md device
mdadm: /dev/sdd2 does not appear to be an md device
mdadm: /dev/sde does not appear to be an md device
mdadm: /dev/sdf does not appear to be an md device
mdadm: /dev/sdf1 does not appear to be an md device
mdadm: /dev/sdf2 does not appear to be an md device
mdadm: /dev/sdf3 does not appear to be an md device
mdadm: /dev/sdf4 does not appear to be an md device
mdadm: /dev/sdf5 does not appear to be an md device
mdadm: /dev/sdf6 does not appear to be an md device
[root@lamachine ~]#

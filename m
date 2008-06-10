From: Wayne Gemmell <wayne@flashmedia.co.za>
Subject: Re: Wierd critical node problem
Date: Tue, 10 Jun 2008 12:34:59 +0200
Message-ID: <200806101235.00027.wayne@flashmedia.co.za>
References: <200806100924.48763.wayne@flashmedia.co.za> <200806101030.09019.wayne@flashmedia.co.za> <42492.192.168.1.70.1213092370.squirrel@neil.brown.name>
Reply-To: wayne@flashmedia.co.za
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42492.192.168.1.70.1213092370.squirrel@neil.brown.name>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 10 June 2008 12:06:10 NeilBrown wrote:
> On Tue, June 10, 2008 6:30 pm, Wayne Gemmell wrote:
> > Sure thingk.
> >
> > On Tuesday 10 June 2008 10:15:22 you wrote:
> >> I suggest you provide lots more details.
> >> Probably
> >>   mdadm -Dsv
>
> Damn, I meant to say "-Dsvv" (2 v's) but it doens't really matter,
> I think that is a good enough picture.
> However....
Just for thouroughness....

/dev/md5:
        Version : 00.90.03
  Creation Time : Mon Jul 30 13:41:01 2007
     Raid Level : raid1
     Array Size : 979840 (957.04 MiB 1003.36 MB)
  Used Dev Size : 979840 (957.04 MiB 1003.36 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 5
    Persistence : Superblock is persistent

    Update Time : Tue Jun 10 10:08:45 2008
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : 6868a02e:0e985748:cae821e2:1cf91e6d (local to host lloyd)
         Events : 0.84

    Number   Major   Minor   RaidDevice State
       0       8       34        0      active sync   /dev/sdc2
       1       8       50        1      active sync   /dev/sdd2
/dev/md0:
        Version : 00.90.03
  Creation Time : Wed Aug 30 08:17:25 2006
     Raid Level : raid1
     Array Size : 489856 (478.46 MiB 501.61 MB)
  Used Dev Size : 489856 (478.46 MiB 501.61 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Mon Jun  9 18:02:55 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

           UUID : 222850cc:3ee166b9:9e71a84f:e86d40a1
         Events : 0.1598

    Number   Major   Minor   RaidDevice State
       0       8       17        0      active sync   /dev/sdb1
       1       8        1        1      active sync   /dev/sda1
       2       8       49        2      active sync   /dev/sdd1
       3       8       33        3      active sync   /dev/sdc1
/dev/md6:
        Version : 00.90.03
  Creation Time : Mon Jul 30 13:46:12 2007
     Raid Level : raid1
     Array Size : 979840 (957.04 MiB 1003.36 MB)
  Used Dev Size : 979840 (957.04 MiB 1003.36 MB)
   Raid Devices : 2
  Total Devices : 2
Preferred Minor : 6
    Persistence : Superblock is persistent

    Update Time : Tue Jun 10 10:08:46 2008
          State : clean
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           UUID : bfa44b7a:d6a2d5fc:cae821e2:1cf91e6d (local to host lloyd)
         Events : 0.5980

    Number   Major   Minor   RaidDevice State
       0       8       18        0      active sync   /dev/sdb2
       1       8        2        1      active sync   /dev/sda2
/dev/md1:
        Version : 00.90.03
  Creation Time : Wed Aug 30 08:18:01 2006
     Raid Level : raid1
     Array Size : 4883648 (4.66 GiB 5.00 GB)
  Used Dev Size : 4883648 (4.66 GiB 5.00 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 1
    Persistence : Superblock is persistent

    Update Time : Tue Jun 10 12:24:23 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

           UUID : 5f6e694f:1d5441a3:7c5e3c07:b6a0267e
         Events : 0.17895140

    Number   Major   Minor   RaidDevice State
       0       8       19        0      active sync   /dev/sdb3
       1       8       51        1      active sync   /dev/sdd3
       2       8       35        2      active sync   /dev/sdc3
       3       8        3        3      active sync   /dev/sda3
/dev/md2:
        Version : 00.90.03
  Creation Time : Wed Aug 30 08:18:46 2006
     Raid Level : raid1
     Array Size : 9767424 (9.31 GiB 10.00 GB)
  Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 2
    Persistence : Superblock is persistent

    Update Time : Tue Jun 10 12:24:08 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

           UUID : 020b3642:b32a5fda:ebae4acf:da43fee2
         Events : 0.15926826

    Number   Major   Minor   RaidDevice State
       0       8       37        0      active sync   /dev/sdc5
       1       8       53        1      active sync   /dev/sdd5
       2       8        5        2      active sync   /dev/sda5
       3       8       21        3      active sync   /dev/sdb5
/dev/md3:
        Version : 00.90.03
  Creation Time : Wed Aug 30 08:19:37 2006
     Raid Level : raid1
     Array Size : 1951744 (1906.32 MiB 1998.59 MB)
  Used Dev Size : 1951744 (1906.32 MiB 1998.59 MB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 3
    Persistence : Superblock is persistent

    Update Time : Tue Jun 10 12:24:03 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

           UUID : da7d0fc4:ba7f7bd0:bfe35e68:eec9a5cb
         Events : 0.1515534

    Number   Major   Minor   RaidDevice State
       0       8        6        0      active sync   /dev/sda6
       1       8       38        1      active sync   /dev/sdc6
       2       8       54        2      active sync   /dev/sdd6
       3       8       22        3      active sync   /dev/sdb6
/dev/md4:
        Version : 00.90.03
  Creation Time : Fri Sep 15 11:20:47 2006
     Raid Level : raid1
     Array Size : 138215104 (131.81 GiB 141.53 GB)
  Used Dev Size : 138215104 (131.81 GiB 141.53 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 4
    Persistence : Superblock is persistent

    Update Time : Tue Jun 10 12:24:27 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

           UUID : 5785dcb6:10ba80a4:b169e59f:d80bc484
         Events : 0.28934180

    Number   Major   Minor   RaidDevice State
       0       8       39        0      active sync   /dev/sdc7
       1       8        7        1      active sync   /dev/sda7
       2       8       23        2      active sync   /dev/sdb7
       3       8       55        3      active sync   /dev/sdd7


>
> > I have found the following in my logs,
> > Jun  9 17:01:50 lloyd kernel: [   52.912904] mdadm[2656]: segfault at
> > 0000000000000004 rip 000000000041724c rsp 00007ffff99d9b30 error 4
>
> I suspect this is the real problem.
> Which version of mdadm (mdadm -V)?
mdadm - v2.6.2 - 21st May 2007

>
> If these arrays are being assembled by the initrd, you would need
> to find out what mdadm is in the initrd, though it is probably
> the same as in /sbin.  What distro.  What kernel version?
I'm running Ubuntu Gutsy running 2.6.22-14-server kernel. I May have an old 
version of mdadm in initrd so I've regenerated it now. I'll only really get 
to test it again tomorrow.


-- 
Regards
Wayne

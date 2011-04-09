From: sanktnelson 1 <sanktnelson@googlemail.com>
Subject: Re: help please - recovering from failed RAID5 rebuild
Date: Sat, 9 Apr 2011 11:27:20 +0200
Message-ID: <BANLkTimSh8f8cVihRxbKgKZq4zFv6VUmVQ@mail.gmail.com>
References: <BANLkTinAmEgsbOx4k5yxCdHmM0GBWbXdBA@mail.gmail.com>
	<20110408220130.4830852d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110408220130.4830852d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011/4/8 NeilBrown <neilb@suse.de>:

>
> Maybe the best thing to do at this point is post the output of
> =A0mdadm -E /dev/sd[bcdef]1
> and I'll see if I can make sense of it.

Thanks for your advice! here is the output:


/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 07ca9dc0:8d91f663:fe51d0ea:fe5e38c2
  Creation Time : Mon Jun  8 20:38:29 2009
     Raid Level : raid5
  Used Dev Size : 1465135872 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543488 (5589.05 GiB 6001.20 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Thu Apr  7 20:49:01 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 2a930ff9 - correct
         Events : 1885746

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     3       8       17        3      active sync   /dev/sdb1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       17        3      active sync   /dev/sdb1
   4     4       8       81        4      active sync   /dev/sdf1
/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 07ca9dc0:8d91f663:fe51d0ea:fe5e38c2
  Creation Time : Mon Jun  8 20:38:29 2009
     Raid Level : raid5
  Used Dev Size : 1465135872 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543488 (5589.05 GiB 6001.20 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Thu Apr  7 20:48:31 2011
          State : clean
 Active Devices : 3
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 2a930fe8 - correct
         Events : 1885744

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     6       8       33        6      spare   /dev/sdc1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       17        3      active sync   /dev/sdb1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       49        5      faulty   /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 07ca9dc0:8d91f663:fe51d0ea:fe5e38c2
  Creation Time : Mon Jun  8 20:38:29 2009
     Raid Level : raid5
  Used Dev Size : 1465135872 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543488 (5589.05 GiB 6001.20 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Thu Apr  7 20:45:10 2011
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 1
  Spare Devices : 1
       Checksum : 2a930f0c - correct
         Events : 1885736

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0       8       49        0      active sync   /dev/sdd1

   0     0       8       49        0      active sync   /dev/sdd1
   1     1       0        0        1      faulty removed
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       17        3      active sync   /dev/sdb1
   4     4       8       81        4      active sync   /dev/sdf1
   5     5       8       33        5      spare   /dev/sdc1
/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 07ca9dc0:8d91f663:fe51d0ea:fe5e38c2
  Creation Time : Mon Jun  8 20:38:29 2009
     Raid Level : raid5
  Used Dev Size : 1465135872 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543488 (5589.05 GiB 6001.20 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Thu Apr  7 20:49:01 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 2a931027 - correct
         Events : 1885746

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     2       8       65        2      active sync   /dev/sde1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       17        3      active sync   /dev/sdb1
   4     4       8       81        4      active sync   /dev/sdf1
/dev/sdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 07ca9dc0:8d91f663:fe51d0ea:fe5e38c2
  Creation Time : Mon Jun  8 20:38:29 2009
     Raid Level : raid5
  Used Dev Size : 1465135872 (1397.26 GiB 1500.30 GB)
     Array Size : 5860543488 (5589.05 GiB 6001.20 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 0

    Update Time : Thu Apr  7 20:49:01 2011
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 2a93103b - correct
         Events : 1885746

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     4       8       81        4      active sync   /dev/sdf1

   0     0       0        0        0      removed
   1     1       0        0        1      faulty removed
   2     2       8       65        2      active sync   /dev/sde1
   3     3       8       17        3      active sync   /dev/sdb1
   4     4       8       81        4      active sync   /dev/sdf1


~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
md0 : inactive sdf1[4](S) sdd1[0](S) sde1[2](S) sdb1[3](S) sdc1[6](S)
      7325679680 blocks

unused devices: <none>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

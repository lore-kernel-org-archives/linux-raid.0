From: Christian <cjs703@gmail.com>
Subject: Re: RAID6 array won't start
Date: Fri, 11 Feb 2011 23:08:34 -0500
Message-ID: <AANLkTimfH1zNiuetZeKvqWpGQkMiojMt8fe7+WEt81MY@mail.gmail.com>
References: <AANLkTimLfJHc2waPkvjUXn=mewc37qkCd-r0GG4k=e-D@mail.gmail.com>
	<AANLkTi=dtMbuszU3x_hGduN-y5ATbgD0tgby_2mj4YsH@mail.gmail.com>
	<20110212074904.41e113ed@notabene.brown>
	<AANLkTikmCmutS_96PNYR0RKAv07cG5Vje0kyzzQ7U9rd@mail.gmail.com>
	<20110212083224.6b1c2cee@notabene.brown>
	<AANLkTi=Y7zf9v6dobfWj-z97FSfkVk2FpWT9Yi4MMKMr@mail.gmail.com>
	<AANLkTi=em0Wkj48SOECZqSuyJ01AwDnDdE76aQPzWiTp@mail.gmail.com>
	<20110212115235.5e38c3db@notabene.brown>
	<AANLkTikY5AvGBTS_P88z_WzPVBqbmRfS0qxOo98vcb1Y@mail.gmail.com>
	<20110212120325.07d55a2c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110212120325.07d55a2c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here's the combined output

/dev/sde1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0959650a:8a397113:e0647a97:fc2066cc (local to host ra=
id)
  Creation Time : Sat Sep 25 13:23:40 2010
     Raid Level : raid6
  Used Dev Size : 1953513472 (1863.02 GiB 2000.40 GB)
     Array Size : 15628107776 (14904.13 GiB 16003.18 GB)
   Raid Devices : 10
  Total Devices : 8
Preferred Minor : 1

    Update Time : Wed Feb  9 19:24:09 2011
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 27a7ead4 - correct
         Events : 147226

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     9       8       65        9      active sync   /dev/sde1

   0     0       0        0        0      removed
   1     1      65       49        1      active sync   /dev/sdt1
   2     2      65       17        2      active sync   /dev/sdr1
   3     3       0        0        3      faulty removed
   4     4      65        1        4      active sync   /dev/sdq1
   5     5       8      161        5      active sync   /dev/sdk1
   6     6       8       81        6      active sync   /dev/sdf1
   7     7       8       97        7      active sync   /dev/sdg1
   8     8       8      177        8      active sync   /dev/sdl1
   9     9       8       65        9      active sync   /dev/sde1
/dev/sdf1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0959650a:8a397113:e0647a97:fc2066cc (local to host ra=
id)
  Creation Time : Sat Sep 25 13:23:40 2010
     Raid Level : raid6
  Used Dev Size : 1953513472 (1863.02 GiB 2000.40 GB)
     Array Size : 15628107776 (14904.13 GiB 16003.18 GB)
   Raid Devices : 10
  Total Devices : 8
Preferred Minor : 1

    Update Time : Wed Feb  9 19:24:09 2011
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 27a7eade - correct
         Events : 147226

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       81        6      active sync   /dev/sdf1

   0     0       0        0        0      removed
   1     1      65       49        1      active sync   /dev/sdt1
   2     2      65       17        2      active sync   /dev/sdr1
   3     3       0        0        3      faulty removed
   4     4      65        1        4      active sync   /dev/sdq1
   5     5       8      161        5      active sync   /dev/sdk1
   6     6       8       81        6      active sync   /dev/sdf1
   7     7       8       97        7      active sync   /dev/sdg1
   8     8       8      177        8      active sync   /dev/sdl1
   9     9       8       65        9      active sync   /dev/sde1
/dev/sdg1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0959650a:8a397113:e0647a97:fc2066cc (local to host ra=
id)
  Creation Time : Sat Sep 25 13:23:40 2010
     Raid Level : raid6
  Used Dev Size : 1953513472 (1863.02 GiB 2000.40 GB)
     Array Size : 15628107776 (14904.13 GiB 16003.18 GB)
   Raid Devices : 10
  Total Devices : 8
Preferred Minor : 1

    Update Time : Wed Feb  9 19:24:09 2011
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 27a7eaf0 - correct
         Events : 147226

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     7       8       97        7      active sync   /dev/sdg1

   0     0       0        0        0      removed
   1     1      65       49        1      active sync   /dev/sdt1
   2     2      65       17        2      active sync   /dev/sdr1
   3     3       0        0        3      faulty removed
   4     4      65        1        4      active sync   /dev/sdq1
   5     5       8      161        5      active sync   /dev/sdk1
   6     6       8       81        6      active sync   /dev/sdf1
   7     7       8       97        7      active sync   /dev/sdg1
   8     8       8      177        8      active sync   /dev/sdl1
   9     9       8       65        9      active sync   /dev/sde1
/dev/sdk1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0959650a:8a397113:e0647a97:fc2066cc (local to host ra=
id)
  Creation Time : Sat Sep 25 13:23:40 2010
     Raid Level : raid6
  Used Dev Size : 1953513472 (1863.02 GiB 2000.40 GB)
     Array Size : 15628107776 (14904.13 GiB 16003.18 GB)
   Raid Devices : 10
  Total Devices : 8
Preferred Minor : 1

    Update Time : Wed Feb  9 19:24:09 2011
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 27a7eb2c - correct
         Events : 147226

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8      161        5      active sync   /dev/sdk1

   0     0       0        0        0      removed
   1     1      65       49        1      active sync   /dev/sdt1
   2     2      65       17        2      active sync   /dev/sdr1
   3     3       0        0        3      faulty removed
   4     4      65        1        4      active sync   /dev/sdq1
   5     5       8      161        5      active sync   /dev/sdk1
   6     6       8       81        6      active sync   /dev/sdf1
   7     7       8       97        7      active sync   /dev/sdg1
   8     8       8      177        8      active sync   /dev/sdl1
   9     9       8       65        9      active sync   /dev/sde1
/dev/sdl1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0959650a:8a397113:e0647a97:fc2066cc (local to host ra=
id)
  Creation Time : Sat Sep 25 13:23:40 2010
     Raid Level : raid6
  Used Dev Size : 1953513472 (1863.02 GiB 2000.40 GB)
     Array Size : 15628107776 (14904.13 GiB 16003.18 GB)
   Raid Devices : 10
  Total Devices : 8
Preferred Minor : 1

    Update Time : Wed Feb  9 19:24:09 2011
          State : active
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 27a7eb42 - correct
         Events : 147226

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     8       8      177        8      active sync   /dev/sdl1

   0     0       0        0        0      removed
   1     1      65       49        1      active sync   /dev/sdt1
   2     2      65       17        2      active sync   /dev/sdr1
   3     3       0        0        3      faulty removed
   4     4      65        1        4      active sync   /dev/sdq1
   5     5       8      161        5      active sync   /dev/sdk1
   6     6       8       81        6      active sync   /dev/sdf1
   7     7       8       97        7      active sync   /dev/sdg1
   8     8       8      177        8      active sync   /dev/sdl1
   9     9       8       65        9      active sync   /dev/sde1
/dev/sdm1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0959650a:8a397113:e0647a97:fc2066cc (local to host ra=
id)
  Creation Time : Sat Sep 25 13:23:40 2010
     Raid Level : raid6
  Used Dev Size : 1953513472 (1863.02 GiB 2000.40 GB)
     Array Size : 15628107776 (14904.13 GiB 16003.18 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 1

    Update Time : Wed Feb  9 18:45:59 2011
          State : clean
 Active Devices : 10
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 27aa228c - correct
         Events : 147221

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8      193        0      active sync   /dev/sdm1

   0     0       8      193        0      active sync   /dev/sdm1
   1     1      65       49        1      active sync   /dev/sdt1
   2     2      65       17        2      active sync   /dev/sdr1
   3     3      65       33        3      active sync   /dev/sds1
   4     4      65        1        4      active sync   /dev/sdq1
   5     5       8      161        5      active sync   /dev/sdk1
   6     6       8       81        6      active sync   /dev/sdf1
   7     7       8       97        7      active sync   /dev/sdg1
   8     8       8      177        8      active sync   /dev/sdl1
   9     9       8       65        9      active sync   /dev/sde1
/dev/sdq1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0959650a:8a397113:e0647a97:fc2066cc (local to host ra=
id)
  Creation Time : Sat Sep 25 13:23:40 2010
     Raid Level : raid6
  Used Dev Size : 1953513472 (1863.02 GiB 2000.40 GB)
     Array Size : 15628107776 (14904.13 GiB 16003.18 GB)
   Raid Devices : 10
  Total Devices : 8
Preferred Minor : 1

    Update Time : Wed Feb  9 19:20:33 2011
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 27aa2904 - correct
         Events : 147225

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4      65        1        4      active sync   /dev/sdq1

   0     0       0        0        0      removed
   1     1      65       49        1      active sync   /dev/sdt1
   2     2      65       17        2      active sync   /dev/sdr1
   3     3       0        0        3      faulty removed
   4     4      65        1        4      active sync   /dev/sdq1
   5     5       8      161        5      active sync   /dev/sdk1
   6     6       8       81        6      active sync   /dev/sdf1
   7     7       8       97        7      active sync   /dev/sdg1
   8     8       8      177        8      active sync   /dev/sdl1
   9     9       8       65        9      active sync   /dev/sde1
/dev/sdr1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0959650a:8a397113:e0647a97:fc2066cc (local to host ra=
id)
  Creation Time : Sat Sep 25 13:23:40 2010
     Raid Level : raid6
  Used Dev Size : 1953513472 (1863.02 GiB 2000.40 GB)
     Array Size : 15628107776 (14904.13 GiB 16003.18 GB)
   Raid Devices : 10
  Total Devices : 8
Preferred Minor : 1

    Update Time : Wed Feb  9 19:20:33 2011
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 27aa2910 - correct
         Events : 147225

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2      65       17        2      active sync   /dev/sdr1

   0     0       0        0        0      removed
   1     1      65       49        1      active sync   /dev/sdt1
   2     2      65       17        2      active sync   /dev/sdr1
   3     3       0        0        3      faulty removed
   4     4      65        1        4      active sync   /dev/sdq1
   5     5       8      161        5      active sync   /dev/sdk1
   6     6       8       81        6      active sync   /dev/sdf1
   7     7       8       97        7      active sync   /dev/sdg1
   8     8       8      177        8      active sync   /dev/sdl1
   9     9       8       65        9      active sync   /dev/sde1
/dev/sds1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0959650a:8a397113:e0647a97:fc2066cc (local to host ra=
id)
  Creation Time : Sat Sep 25 13:23:40 2010
     Raid Level : raid6
  Used Dev Size : 1953513472 (1863.02 GiB 2000.40 GB)
     Array Size : 15628107776 (14904.13 GiB 16003.18 GB)
   Raid Devices : 10
  Total Devices : 10
Preferred Minor : 1

    Update Time : Wed Feb  9 18:45:59 2011
          State : clean
 Active Devices : 10
Working Devices : 10
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 27aa222b - correct
         Events : 147221

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3      65       33        3      active sync   /dev/sds1

   0     0       8      193        0      active sync   /dev/sdm1
   1     1      65       49        1      active sync   /dev/sdt1
   2     2      65       17        2      active sync   /dev/sdr1
   3     3      65       33        3      active sync   /dev/sds1
   4     4      65        1        4      active sync   /dev/sdq1
   5     5       8      161        5      active sync   /dev/sdk1
   6     6       8       81        6      active sync   /dev/sdf1
   7     7       8       97        7      active sync   /dev/sdg1
   8     8       8      177        8      active sync   /dev/sdl1
   9     9       8       65        9      active sync   /dev/sde1
/dev/sdt1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 0959650a:8a397113:e0647a97:fc2066cc (local to host ra=
id)
  Creation Time : Sat Sep 25 13:23:40 2010
     Raid Level : raid6
  Used Dev Size : 1953513472 (1863.02 GiB 2000.40 GB)
     Array Size : 15628107776 (14904.13 GiB 16003.18 GB)
   Raid Devices : 10
  Total Devices : 8
Preferred Minor : 1

    Update Time : Wed Feb  9 19:20:33 2011
          State : clean
 Active Devices : 8
Working Devices : 8
 Failed Devices : 1
  Spare Devices : 0
       Checksum : 27aa292e - correct
         Events : 147225

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1      65       49        1      active sync   /dev/sdt1

   0     0       0        0        0      removed
   1     1      65       49        1      active sync   /dev/sdt1
   2     2      65       17        2      active sync   /dev/sdr1
   3     3       0        0        3      faulty removed
   4     4      65        1        4      active sync   /dev/sdq1
   5     5       8      161        5      active sync   /dev/sdk1
   6     6       8       81        6      active sync   /dev/sdf1
   7     7       8       97        7      active sync   /dev/sdg1
   8     8       8      177        8      active sync   /dev/sdl1
   9     9       8       65        9      active sync   /dev/sde1


On Fri, Feb 11, 2011 at 8:03 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 11 Feb 2011 19:57:52 -0500 Christian <cjs703@gmail.com> wrote=
:
>
>> # mdadm -V
>> mdadm - v3.1.4 - 31st August 2010
>
> So either I didn't fix it like I thought, or I subsequently broke it.
>
> Could you send me the combined --examine output that you saved?
> That might help me reproduce the exact problem, then add it to the
> mdadm test suite. =A0Then fix it.
>
> Thanks,
> NeilBrown
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

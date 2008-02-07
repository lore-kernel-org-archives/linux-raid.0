From: Marcin Krol <admin@domeny.pl>
Subject: Re: Deleting mdadm RAID arrays
Date: Thu, 7 Feb 2008 10:56:33 +0100
Message-ID: <200802071056.33221.admin@domeny.pl>
References: <200802051142.19625.admin@domeny.pl> <200802061303.50017.admin@domeny.pl> <18346.28335.256479.27397@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18346.28335.256479.27397@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thursday 07 February 2008 03:36:31 Neil Brown napisa=C5=82(a):

> > =C2=A0 =C2=A08 =C2=A0 =C2=A0 0 =C2=A0390711384 sda
> > =C2=A0 =C2=A08 =C2=A0 =C2=A0 1 =C2=A0390708801 sda1
> > =C2=A0 =C2=A08 =C2=A0 =C2=A016 =C2=A0390711384 sdb
> > =C2=A0 =C2=A08 =C2=A0 =C2=A017 =C2=A0390708801 sdb1
> > =C2=A0 =C2=A08 =C2=A0 =C2=A032 =C2=A0390711384 sdc
> > =C2=A0 =C2=A08 =C2=A0 =C2=A033 =C2=A0390708801 sdc1
> > =C2=A0 =C2=A08 =C2=A0 =C2=A048 =C2=A0390710327 sdd
> > =C2=A0 =C2=A08 =C2=A0 =C2=A049 =C2=A0390708801 sdd1
> > =C2=A0 =C2=A08 =C2=A0 =C2=A064 =C2=A0390711384 sde
> > =C2=A0 =C2=A08 =C2=A0 =C2=A065 =C2=A0390708801 sde1
> > =C2=A0 =C2=A08 =C2=A0 =C2=A080 =C2=A0390711384 sdf
> > =C2=A0 =C2=A08 =C2=A0 =C2=A081 =C2=A0390708801 sdf1
> > =C2=A0 =C2=A03 =C2=A0 =C2=A064 =C2=A0 78150744 hdb
> > =C2=A0 =C2=A03 =C2=A0 =C2=A065 =C2=A0 =C2=A01951866 hdb1
> > =C2=A0 =C2=A03 =C2=A0 =C2=A066 =C2=A0 =C2=A07815622 hdb2
> > =C2=A0 =C2=A03 =C2=A0 =C2=A067 =C2=A0 =C2=A04883760 hdb3
> > =C2=A0 =C2=A03 =C2=A0 =C2=A068 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A01 =
hdb4
> > =C2=A0 =C2=A03 =C2=A0 =C2=A069 =C2=A0 =C2=A0 979933 hdb5
> > =C2=A0 =C2=A03 =C2=A0 =C2=A070 =C2=A0 =C2=A0 979933 hdb6
> > =C2=A0 =C2=A03 =C2=A0 =C2=A071 =C2=A0 61536951 hdb7
> > =C2=A0 =C2=A09 =C2=A0 =C2=A0 1 =C2=A0781417472 md1
> > =C2=A0 =C2=A09 =C2=A0 =C2=A0 0 =C2=A0781417472 md0
>
> So all the expected partitions are known to the kernel - good.

It 's not good really!!

I can't trust /dev/sd* devices - they get swapped randomly depending=20
on sequence of module loading!! I have two drivers, ahci for onboard
SATA controllers and sata_sil for additional controller.

Sometimes the system boots ahci first and sata_sil later, sometimes=20
in reverse sequence.=20

Then, sda becomes sdc, sdb becomes sdd, etc.=20

It is exactly the problem that I cannot rely on kernel's information wh=
ich
physical drive is which logical drive!

> Then
>   mdadm /dev/md0 -f /dev/d_1
>=20
> will fail d_1, abort the recovery, and release d_1.
>=20
> Then
>   mdadm --zero-superblock /dev/d_1
>=20
> should work.

Thanks, though I managed to fail the drives, remove them, zero superblo=
cks=20
and reassemble the arrays anyway.=20

The problem I have now is that mdadm seems to be of 'two minds' when it=
 comes=20
to where it gets the info on which disk is what part of the array.=20

As you may remember, I have configured udev to associate /dev/d_* devic=
es with
serial numbers (to keep them from changing depending on boot module loa=
ding=20
sequence).=20

Now, when I swap two (random) drives in order to test if it keeps devic=
e names=20
associated with serial numbers I get the following effect:

1. mdadm -Q --detail /dev/md* gives correct results before *and* after =
the swapping:

% mdadm -Q --detail /dev/md0
/dev/md0:
[...]
    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/d_1
       1       8       17        1      active sync   /dev/d_2
       2       8       81        2      active sync   /dev/d_3

% mdadm -Q --detail /dev/md1
/dev/md1:
[...]
    Number   Major   Minor   RaidDevice State
       0       8       49        0      active sync   /dev/d_4
       1       8       65        1      active sync   /dev/d_5
       2       8       33        2      active sync   /dev/d_6


2. However, cat /proc/mdstat gives shows different layout of the arrays=
!

BEFORE the swap:

% cat mdstat-16_51
Personalities : [raid6] [raid5] [raid4]
md1 : active raid5 sdb1[2] sdf1[0] sda1[1]
      781417472 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md0 : active raid5 sde1[2] sdc1[0] sdd1[1]
      781417472 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>


AFTER the swap:

% cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md1 : active(auto-read-only) raid5 sdd1[0] sdc1[2] sde1[1]
      781417472 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md0 : active(auto-read-only) raid5 sda1[0] sdf1[2] sdb1[1]
      781417472 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

unused devices: <none>

I have no idea now if the array is functioning (it keeps the drives
according to /dev/d_* devices and superblock info is unimportant)
or if my arrays fell apart because of that swapping.=20

And I made *damn* sure I zeroed all the superblocks before reassembling=
=20
the arrays. Yet it still shows the old partitions on those arrays!

Here's current mdadm -E information if it might help with diagnosing th=
is:

% mdadm -E /dev/d_1
/dev/d_1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : dc150d95:d1aea7bc:a6d4720f:52a5051f
  Creation Time : Wed Feb  6 13:44:00 2008
     Raid Level : raid5
  Used Dev Size : 390708736 (372.61 GiB 400.09 GB)
     Array Size : 781417472 (745.22 GiB 800.17 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Feb  6 20:23:33 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f706efc3 - correct
         Events : 0.16

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       33        0      active sync   /dev/d_6

   0     0       8       33        0      active sync   /dev/d_6
   1     1       8       49        1      active sync   /dev/d_4
   2     2       8       65        2      active sync   /dev/d_5
b1 (192.168.1.235) ~ % mdadm -E /dev/d_2
/dev/d_2:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : dc150d95:d1aea7bc:a6d4720f:52a5051f
  Creation Time : Wed Feb  6 13:44:00 2008
     Raid Level : raid5
  Used Dev Size : 390708736 (372.61 GiB 400.09 GB)
     Array Size : 781417472 (745.22 GiB 800.17 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Feb  6 20:23:33 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f706efd5 - correct
         Events : 0.16

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       49        1      active sync   /dev/d_4

   0     0       8       33        0      active sync   /dev/d_6
   1     1       8       49        1      active sync   /dev/d_4
   2     2       8       65        2      active sync   /dev/d_5
b1 (192.168.1.235) ~ % mdadm -E /dev/d_3
/dev/d_3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : dc150d95:d1aea7bc:a6d4720f:52a5051f
  Creation Time : Wed Feb  6 13:44:00 2008
     Raid Level : raid5
  Used Dev Size : 390708736 (372.61 GiB 400.09 GB)
     Array Size : 781417472 (745.22 GiB 800.17 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 0

    Update Time : Wed Feb  6 20:23:33 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : f706efe7 - correct
         Events : 0.16

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       65        2      active sync   /dev/d_5

   0     0       8       33        0      active sync   /dev/d_6
   1     1       8       49        1      active sync   /dev/d_4
   2     2       8       65        2      active sync   /dev/d_5
b1 (192.168.1.235) ~ % mdadm -E /dev/d_4
/dev/d_4:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 0ccf5692:82985f35:a6d4720f:52a5051f
  Creation Time : Wed Feb  6 13:43:24 2008
     Raid Level : raid5
  Used Dev Size : 390708736 (372.61 GiB 400.09 GB)
     Array Size : 781417472 (745.22 GiB 800.17 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1

    Update Time : Wed Feb  6 20:23:40 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d8aaf014 - correct
         Events : 0.12

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       81        0      active sync   /dev/d_3

   0     0       8       81        0      active sync   /dev/d_3
   1     1       8        1        1      active sync   /dev/d_1
   2     2       8       17        2      active sync   /dev/d_2
b1 (192.168.1.235) ~ % mdadm -E /dev/d_5
/dev/d_5:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 0ccf5692:82985f35:a6d4720f:52a5051f
  Creation Time : Wed Feb  6 13:43:24 2008
     Raid Level : raid5
  Used Dev Size : 390708736 (372.61 GiB 400.09 GB)
     Array Size : 781417472 (745.22 GiB 800.17 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1

    Update Time : Wed Feb  6 20:23:40 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d8aaefc6 - correct
         Events : 0.12

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8        1        1      active sync   /dev/d_1

   0     0       8       81        0      active sync   /dev/d_3
   1     1       8        1        1      active sync   /dev/d_1
   2     2       8       17        2      active sync   /dev/d_2
b1 (192.168.1.235) ~ % mdadm -E /dev/d_6
/dev/d_6:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 0ccf5692:82985f35:a6d4720f:52a5051f
  Creation Time : Wed Feb  6 13:43:24 2008
     Raid Level : raid5
  Used Dev Size : 390708736 (372.61 GiB 400.09 GB)
     Array Size : 781417472 (745.22 GiB 800.17 GB)
   Raid Devices : 3
  Total Devices : 3
Preferred Minor : 1

    Update Time : Wed Feb  6 20:23:40 2008
          State : clean
 Active Devices : 3
Working Devices : 3
 Failed Devices : 0
  Spare Devices : 0
       Checksum : d8aaefd8 - correct
         Events : 0.12

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       17        2      active sync   /dev/d_2

   0     0       8       81        0      active sync   /dev/d_3
   1     1       8        1        1      active sync   /dev/d_1
   2     2       8       17        2      active sync   /dev/d_2






=20


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

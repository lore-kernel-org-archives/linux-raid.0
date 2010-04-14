From: Mark Knecht <markknecht@gmail.com>
Subject: Re: First experience with drive being kicked
Date: Tue, 13 Apr 2010 19:24:22 -0700
Message-ID: <p2z5bdc1c8b1004131924u1c4cd1ebj55f6ea59797fe1f6@mail.gmail.com>
References: <n2t5bdc1c8b1004131554m1541784eve2987e7637723aeb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <n2t5bdc1c8b1004131554m1541784eve2987e7637723aeb@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Apr 13, 2010 at 3:54 PM, Mark Knecht <markknecht@gmail.com> wro=
te:
> OK, I was messing around in the box today adding two more drives and =
I
> probably hit a cable or something but maybe not. /dev/md3 was
> effected, but md5 built on the same drives wasn't. Possibly this has
> been there for a day or two and I didn't notice it. =C2=A0These drive=
s are
> only a few days old so I hope I'm not seeing some sort of early
> problem. Supposedly good drives - WD 500GB RAID Edition.
>
> Currently all my RAIDs are RAID1 assembled by the kernel at boot time=
=2E
> I have no mdadm.conf file. mdadm is a running daemon.
>
> From dmesg:
>
> md: considering sdb3 ...
> md: =C2=A0adding sdb3 ...
> md: =C2=A0adding sdc3 ...
> md: =C2=A0adding sda3 ...
> md: created md3
> md: bind<sda3>
> md: bind<sdc3>
> md: bind<sdb3>
> md: running: <sdb3><sdc3><sda3>
> md: kicking non-fresh sdb3 from array!
> md: unbind<sdb3>
> md: export_rdev(sdb3)
> raid1: raid set md3 active with 2 out of 3 mirrors
> md3: detected capacity change from 0 to 53694562304
>
> How do I go about trying to /dev/sdb3 back into the array and what
> sort of checking is advised when this happens before I add it back?
> The bad drive (sdb) doesn't look much different than the good drives.
> (sda shown, sdc)
>
> cruncher ~ # smartctl -A /dev/sdb
> smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
> Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforg=
e.net
>
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =C2=A0=
 VALUE WORST THRESH TYPE
> UPDATED =C2=A0WHEN_FAILED RAW_VALUE
> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x002f =C2=A0 200 =C2=A0 20=
0 =C2=A0 051 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0027 =
=C2=A0 239 =C2=A0 236 =C2=A0 021 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 1016
> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100=
 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 24
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 200 =C2=A0 200 =C2=
=A0 140 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x002e =C2=A0 200=
 =C2=A0 200 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 100 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 87
> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 10=
0 =C2=A0 253 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A011 Calibration_Retry_Count 0x0032 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 22
> 192 Power-Off_Retract_Count 0x0032 =C2=A0 200 =C2=A0 200 =C2=A0 000 =C2=
=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 12
> 193 Load_Cycle_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 200 =C2=
=A0 200 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 11
> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0022 =C2=A0 109 =C2=A0 105 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 38
> 196 Reallocated_Event_Count 0x0032 =C2=A0 200 =C2=A0 200 =C2=A0 000 =C2=
=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 197 Current_Pending_Sector =C2=A00x0032 =C2=A0 200 =C2=A0 200 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 198 Offline_Uncorrectable =C2=A0 0x0030 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x0032 =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 200 Multi_Zone_Error_Rate =C2=A0 0x0008 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>
> cruncher ~ # smartctl -A /dev/sda
> smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
> Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforg=
e.net
>
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0FLAG =C2=A0 =C2=A0=
 VALUE WORST THRESH TYPE
> UPDATED =C2=A0WHEN_FAILED RAW_VALUE
> =C2=A01 Raw_Read_Error_Rate =C2=A0 =C2=A0 0x002f =C2=A0 200 =C2=A0 20=
0 =C2=A0 051 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A03 Spin_Up_Time =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0027 =
=C2=A0 239 =C2=A0 235 =C2=A0 021 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 1016
> =C2=A04 Start_Stop_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 100=
 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 24
> =C2=A05 Reallocated_Sector_Ct =C2=A0 0x0033 =C2=A0 200 =C2=A0 200 =C2=
=A0 140 =C2=A0 =C2=A0Pre-fail
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A07 Seek_Error_Rate =C2=A0 =C2=A0 =C2=A0 =C2=A0 0x002e =C2=A0 200=
 =C2=A0 200 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A09 Power_On_Hours =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0=
 100 =C2=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 87
> =C2=A010 Spin_Retry_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 10=
0 =C2=A0 253 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A011 Calibration_Retry_Count 0x0032 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> =C2=A012 Power_Cycle_Count =C2=A0 =C2=A0 =C2=A0 0x0032 =C2=A0 100 =C2=
=A0 100 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 22
> 192 Power-Off_Retract_Count 0x0032 =C2=A0 200 =C2=A0 200 =C2=A0 000 =C2=
=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 11
> 193 Load_Cycle_Count =C2=A0 =C2=A0 =C2=A0 =C2=A00x0032 =C2=A0 200 =C2=
=A0 200 =C2=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 12
> 194 Temperature_Celsius =C2=A0 =C2=A0 0x0022 =C2=A0 108 =C2=A0 106 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 39
> 196 Reallocated_Event_Count 0x0032 =C2=A0 200 =C2=A0 200 =C2=A0 000 =C2=
=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 197 Current_Pending_Sector =C2=A00x0032 =C2=A0 200 =C2=A0 200 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 198 Offline_Uncorrectable =C2=A0 0x0030 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
> 199 UDMA_CRC_Error_Count =C2=A0 =C2=A00x0032 =C2=A0 200 =C2=A0 200 =C2=
=A0 000 =C2=A0 =C2=A0Old_age
> Always =C2=A0 =C2=A0 =C2=A0 - =C2=A0 =C2=A0 =C2=A0 0
> 200 Multi_Zone_Error_Rate =C2=A0 0x0008 =C2=A0 100 =C2=A0 253 =C2=A0 =
000 =C2=A0 =C2=A0Old_age
> Offline =C2=A0 =C2=A0 =C2=A0- =C2=A0 =C2=A0 =C2=A0 0
>
> cruncher ~ #
>
> Thanks,
> Mark
>

So hopefully the process used below is basically correct.

- Mark

cruncher ~ # man mdadm
cruncher ~ # cat /proc/mdstat
Personalities : [raid0] [raid1]
md11 : active raid0 sde1[1] sdd1[0]
      104871936 blocks super 1.1 512k chunks

md3 : active raid1 sdc3[2] sda3[0]
      52436096 blocks [3/2] [U_U]

md5 : active raid1 sdb5[1] sdc5[2] sda5[0]
      52436032 blocks [3/3] [UUU]

unused devices: <none>
cruncher ~ # mdadm /dev/md3 -f /dev/sdb3
mdadm: set device faulty failed for /dev/sdb3:  No such device
cruncher ~ # mdadm /dev/md3 -r /dev/sdb3
mdadm: hot remove failed for /dev/sdb3: No such device or address
cruncher ~ # fdisk /dev/sdb

WARNING: DOS-compatible mode is deprecated. It's strongly recommended t=
o
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units =3D cylinders of 16065 * 512 =3D 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x703d11ba

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1           7       56196   83  Linux
/dev/sdb2               8         530     4200997+  82  Linux swap / So=
laris
/dev/sdb3             536        7063    52436160   fd  Linux raid auto=
detect
/dev/sdb4            7064       60801   431650485    5  Extended
/dev/sdb5            7064       13591    52436128+  fd  Linux raid auto=
detect

Command (m for help): q

cruncher ~ # mdadm /dev/md3 -a /dev/sdb3
mdadm: re-added /dev/sdb3
cruncher ~ # cat /proc/mdstat
Personalities : [raid0] [raid1]
md11 : active raid0 sde1[1] sdd1[0]
      104871936 blocks super 1.1 512k chunks

md3 : active raid1 sdb3[3] sdc3[2] sda3[0]
      52436096 blocks [3/2] [U_U]
      [>....................]  recovery =3D  1.3% (695488/52436096)
finish=3D8.6min speed=3D99355K/sec

md5 : active raid1 sdb5[1] sdc5[2] sda5[0]
      52436032 blocks [3/3] [UUU]

unused devices: <none>
cruncher ~ # cat /proc/mdstat
Personalities : [raid0] [raid1]
md11 : active raid0 sde1[1] sdd1[0]
      104871936 blocks super 1.1 512k chunks

md3 : active raid1 sdb3[3] sdc3[2] sda3[0]
      52436096 blocks [3/2] [U_U]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>.........]  recovery =3D 56.3%=
 (29540736/52436096)
finish=3D5.0min speed=3D75950K/sec

md5 : active raid1 sdb5[1] sdc5[2] sda5[0]
      52436032 blocks [3/3] [UUU]

unused devices: <none>
cruncher ~ # cat /proc/mdstat
Personalities : [raid0] [raid1]
md11 : active raid0 sde1[1] sdd1[0]
      104871936 blocks super 1.1 512k chunks

md3 : active raid1 sdb3[1] sdc3[2] sda3[0]
      52436096 blocks [3/3] [UUU]

md5 : active raid1 sdb5[1] sdc5[2] sda5[0]
      52436032 blocks [3/3] [UUU]

unused devices: <none>
cruncher ~ #
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

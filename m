From: "Stephan Hafiz" <forum@hafis.de>
Subject: AW: md_raid5 recovering failed need help
Date: Mon, 29 Dec 2014 22:18:13 +0100
Message-ID: <004001d023ac$f4e7bf80$deb73e80$@hafis.de>
References: <!&!AAAAAAAAAAAYAAAAAAAAAOgLllvGWotKlJcBYHqu4VUCgQAAEAAAAJjrgwWxkKFFjrGxfwSsmpoBAAAAAA==@hafis.de> <549ECF26.2040104@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <549ECF26.2040104@turmel.org>
Content-Language: de
Sender: linux-raid-owner@vger.kernel.org
To: 'Phil Turmel' <philip@turmel.org>, 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good day Phil,

David is ok, Stephan too. David is my second firstname. I always think =
stephan is for english native speaker hard to say (?)

!SMART -x at the end

!Distro
PRETTY_NAME=3D"Ubuntu 14.04.1 LTS"
Ubuntu 3.13.0-43.72-generic 3.13.11.11
Linux pluto 3.13.0-43-generic #72-Ubuntu SMP Mon Dec 8 19:35:06 UTC 201=
4 x86_64 x86_64 x86_64 GNU/Linux

!logs
Unfortunately, no syslogmessages, the raid has failed in july.... since=
 then i try to find the cause ...
I have only my puttylogs.

! sysrescuecd.org CD
:-) !!! yes, it works now! But on disk was/is removed. Backup to an oth=
er NAS is in progress.
( The md was /dev/md0 )

I can't understand why this distro has no problems to assemble this rai=
d ???

Thx very mutch for your time to help me.... in german we say "i stand o=
n the hose" :-)

Happy new Year for you an your familie, David (Stephan)



-----Urspr=C3=BCngliche Nachricht-----
Von: Phil Turmel [mailto:philip@turmel.org]=20
Gesendet: Samstag, 27. Dezember 2014 16:24
An: Stephan Hafiz; linux-raid
Betreff: Re: md_raid5 recovering failed need help

Good morning David,

{ or Stephan ? }

On 12/25/2014 09:24 AM, Stephan Hafiz wrote:
> Hi! I=E2=80=99m from germany and my raid and me needs help.
> My english isn=E2=80=99t very good, but i think it=E2=80=99s sufficie=
nt. And i think,=20
> this mailinglist is my last hope =E2=98=BA

This is the right place for problems with linux raid arrays.

> So on, =E2=80=A6. Here ist my problem.
> The raid5 has lost 2 of 5 disks. First one disk and then the second o=
ne.

Ok.  Not uncommon.

[trim /]

> !SMART Status
> for i in a b c d e f; do echo Device  sd$i; smartctl -H /dev/sd$i |=20
> egrep overall; echo; done; Device sda SMART overall-health=20
> self-assessment test result: PASSED
>=20
> Device sdb
> SMART overall-health self-assessment test result: PASSED
>=20
> Device sdc
> SMART overall-health self-assessment test result: PASSED
>=20
> Device sdd
> SMART overall-health self-assessment test result: PASSED
>=20
> Device sde
> SMART overall-health self-assessment test result: PASSED
>=20
> Device sdf
> SMART overall-health self-assessment test result: PASSED

It is extremely common to have an overall result of "PASSED" when you a=
ren't safe at all.  Please redo this without trimming, like so:
     =20
for x in /dev/sd[b-f] ; do echo $x ; smartctl -x $x ; done

Paste the result at the end of you next mail--no need to attach nor nee=
d for pastebin services.

Also, if you still have any syslogs from the time of the failure, it wo=
uld be good to see the kernel messages that triggered the drive ejectio=
ns from the raid.

> !mdadm version
> mdadm - v3.2.5 - 18th May 2012
> I have read about recent versions 3.3.x @ raid.wiki.kernel.org, i hav=
en=E2=80=99t tested this version.

It may be necessary.  You haven't reported your distro nor your kernel =
version.

> !superblock informations
> Only the Events from sdb1 are off

[trim /]

Very good report!  You've saved all the superblocks and you haven't tri=
ed to do any --create operations.

[trim /]

> !reassemble force
> mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1=20
> /dev/sdf1 --force
> mdadm: ignoring /dev/sdd1 as it reports /dev/sdc1 as failed
> mdadm: ignoring /dev/sde1 as it reports /dev/sdc1 as failed
> mdadm: ignoring /dev/sdf1 as it reports /dev/sdc1 as failed
> mdadm: /dev/md0 assembled from 1 drive - not enough to start the arra=
y.

This should have worked.  Hmmm.

> i hope i don=E2=80=99t get the award =E2=80=9Epaint onself in to the =
corner=E2=80=9C =E2=80=A6=E2=80=A6

Probably not. :-)

The simplest way forward would probably be to boot a rescue CD (I gener=
ally use the one from sysrescuecd.org) that has a recent kernel and mda=
dm combination.  Such CDs will probably attempt to assemble your array =
during boot to /dev/md127 instead of /dev/md0, but it will fail.

So, within the rescue environment, do:

mdadm --stop /dev/md127  {or whatever shows in /proc/mdstat}

mdadm --assemble --force --verbose /dev/md0 /dev/sd[b-f]1

If that doesn't work, show us the verbose output, along with the matchi=
ng part of the dmesg.

If it does work, just do a clean shutdown and reboot back into your reg=
ular OS.

> merry christmas =E2=80=A6 David

And Merry Christmas to you!

When you are done celebrating the revival of your array, you will need =
to find out why it broke in the first place.  The most common cause see=
n on this list is the use of consumer-grade drives without dealing with=
 the timeout mismatch problem.  You might want to review this old threa=
d:

http://marc.info/?l=3Dlinux-raid&m=3D135811522817345&w=3D1

Phil
#######################################################################=
##############


root@pluto:~# for x in /dev/sd[b-f] ; do echo $x ; smartctl -x $x ; don=
e
/dev/sdb
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-43-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Red (AF)
Device Model:     WDC WD30EFRX-68AX9N0
Serial Number:    WD-WMC1T3211821
LU WWN Device Id: 5 0014ee 6034288f1
=46irmware Version: 80.00A80
User Capacity:    3.000.592.982.016 bytes [3,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sun Dec 28 21:36:39 2014 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activit=
y
                                        was never started.
                                        Auto Offline Data Collection: D=
isabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                (40680) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate=
=2E
                                        Auto Offline data collection on=
/off support.
                                        Suspend Offline collection upon=
 new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before enterin=
g
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging support=
ed.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 408) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x70bd) SCT Status supported.
                                        SCT Error Recovery Control supp=
orted.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   208   176   021    -    4583
  4 Start_Stop_Count        -O--CK   100   100   000    -    108
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   094   094   000    -    4704
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    107
192 Power-Off_Retract_Count -O--CK   200   200   000    -    16
193 Load_Cycle_Count        -O--CK   200   200   000    -    91
194 Temperature_Celsius     -O---K   113   103   000    -    37
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Device Error Count: 31646 (device log contains only the most recent 24 =
errors)
        CR     =3D Command Register
        FEATR  =3D Features Register
        COUNT  =3D Count (was: Sector Count) Register
        LBA_48 =3D Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
        LH     =3D LBA High (was: Cylinder High) Register    ]   LBA
        LM     =3D LBA Mid (was: Cylinder Low) Register      ] Register
        LL     =3D LBA Low (was: Sector Number) Register     ]
        DV     =3D Device (was: Device/Head) Register
        DC     =3D Device Control Register
        ER     =3D Error register
        ST     =3D Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.

Error 31646 [13] occurred at disk power-on lifetime: 4520 hours (188 da=
ys + 8 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 02 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.154  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08 11d+03:17:23.154  IDENTIFY DEV=
ICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08 11d+03:17:23.154  SET FEATURES=
 [Set transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.153  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08 11d+03:17:23.153  IDENTIFY DEV=
ICE

Error 31645 [12] occurred at disk power-on lifetime: 4520 hours (188 da=
ys + 8 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 46 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ef 00 03 00 46 00 00 00 00 00 00 a0 08 11d+03:17:23.154  SET FEATURES=
 [Set transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.153  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08 11d+03:17:23.153  IDENTIFY DEV=
ICE
  c8 00 00 00 08 00 00 00 00 00 00 e0 08 11d+03:17:23.153  READ DMA
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.153  SET FEATURES=
 [Enable SATA feature]

Error 31644 [11] occurred at disk power-on lifetime: 4520 hours (188 da=
ys + 8 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 02 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.153  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08 11d+03:17:23.153  IDENTIFY DEV=
ICE
  c8 00 00 00 08 00 00 00 00 00 00 e0 08 11d+03:17:23.153  READ DMA
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.153  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08 11d+03:17:23.151  IDENTIFY DEV=
ICE

Error 31643 [10] occurred at disk power-on lifetime: 4520 hours (188 da=
ys + 8 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 08 00 00 00 00 00 00 e0 00  Device Fault; Error: ABRT 8 s=
ectors at LBA =3D 0x00000000 =3D 0

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  c8 00 00 00 08 00 00 00 00 00 00 e0 08 11d+03:17:23.153  READ DMA
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.153  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08 11d+03:17:23.151  IDENTIFY DEV=
ICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08 11d+03:17:23.151  SET FEATURES=
 [Set transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.151  SET FEATURES=
 [Enable SATA feature]

Error 31642 [9] occurred at disk power-on lifetime: 4520 hours (188 day=
s + 8 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 02 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.153  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08 11d+03:17:23.151  IDENTIFY DEV=
ICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08 11d+03:17:23.151  SET FEATURES=
 [Set transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.151  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08 11d+03:17:23.151  IDENTIFY DEV=
ICE

Error 31641 [8] occurred at disk power-on lifetime: 4520 hours (188 day=
s + 8 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 46 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ef 00 03 00 46 00 00 00 00 00 00 a0 08 11d+03:17:23.151  SET FEATURES=
 [Set transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.151  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08 11d+03:17:23.151  IDENTIFY DEV=
ICE
  c8 00 00 00 08 00 00 00 00 00 00 e0 08 11d+03:17:23.150  READ DMA
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.150  SET FEATURES=
 [Enable SATA feature]

Error 31640 [7] occurred at disk power-on lifetime: 4520 hours (188 day=
s + 8 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 02 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.151  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08 11d+03:17:23.151  IDENTIFY DEV=
ICE
  c8 00 00 00 08 00 00 00 00 00 00 e0 08 11d+03:17:23.150  READ DMA
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.150  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08 11d+03:17:23.150  IDENTIFY DEV=
ICE

Error 31639 [6] occurred at disk power-on lifetime: 4520 hours (188 day=
s + 8 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 08 00 00 00 00 00 00 e0 00  Device Fault; Error: ABRT 8 s=
ectors at LBA =3D 0x00000000 =3D 0

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  c8 00 00 00 08 00 00 00 00 00 00 e0 08 11d+03:17:23.150  READ DMA
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.150  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08 11d+03:17:23.150  IDENTIFY DEV=
ICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08 11d+03:17:23.149  SET FEATURES=
 [Set transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08 11d+03:17:23.149  SET FEATURES=
 [Enable SATA feature]

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(ho=
urs)  LBA_of_first_error
# 1  Extended offline    Interrupted (host reset)      60%      1605   =
      -
# 2  Extended offline    Completed without error       00%      1600   =
      -
# 3  Extended offline    Completed without error       00%      1579   =
      -
# 4  Extended offline    Completed without error       00%      1567   =
      -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    37 Celsius
Power Cycle Min/Max Temperature:     21/39 Celsius
Lifetime    Min/Max Temperature:     16/47 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (135)

Index    Estimated Time   Temperature Celsius
 136    2014-12-28 13:39    37  ******************
 ...    ..(476 skipped).    ..  ******************
 135    2014-12-28 21:36    37  ******************

SCT Error Recovery Control:
           Read:     70 (7,0 seconds)
          Write:     70 (7,0 seconds)

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            4  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            3  Device-to-host register FISes sent due to a COM=
RESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS,=
 CRC
0x8000  4       303936  Vendor specific

/dev/sdc
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-43-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Red (AF)
Device Model:     WDC WD30EFRX-68AX9N0
Serial Number:    WD-WMC1T3022609
LU WWN Device Id: 5 0014ee 603429af6
=46irmware Version: 80.00A80
User Capacity:    3.000.592.982.016 bytes [3,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sun Dec 28 21:36:40 2014 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activit=
y
                                        was never started.
                                        Auto Offline Data Collection: D=
isabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                (39840) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate=
=2E
                                        Auto Offline data collection on=
/off support.
                                        Suspend Offline collection upon=
 new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before enterin=
g
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging support=
ed.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 399) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x70bd) SCT Status supported.
                                        SCT Error Recovery Control supp=
orted.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   191   174   021    -    5450
  4 Start_Stop_Count        -O--CK   100   100   000    -    105
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   094   094   000    -    4713
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    104
192 Power-Off_Retract_Count -O--CK   200   200   000    -    12
193 Load_Cycle_Count        -O--CK   200   200   000    -    92
194 Temperature_Celsius     -O---K   113   102   000    -    37
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Device Error Count: 17984 (device log contains only the most recent 24 =
errors)
        CR     =3D Command Register
        FEATR  =3D Features Register
        COUNT  =3D Count (was: Sector Count) Register
        LBA_48 =3D Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
        LH     =3D LBA High (was: Cylinder High) Register    ]   LBA
        LM     =3D LBA Mid (was: Cylinder Low) Register      ] Register
        LL     =3D LBA Low (was: Sector Number) Register     ]
        DV     =3D Device (was: Device/Head) Register
        DC     =3D Device Control Register
        ER     =3D Error register
        ST     =3D Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.

Error 17984 [7] occurred at disk power-on lifetime: 4545 hours (189 day=
s + 9 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 3f 00 00 0f 00 00 01 af 00

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  91 00 20 00 3f 00 00 0f 00 00 01 af 00     15:41:39.736  INITIALIZE D=
EVICE PARAMETERS [OBS-6]
  ec 00 00 00 00 00 00 00 00 00 01 a0 00     15:41:39.734  IDENTIFY DEV=
ICE
  ec 00 00 00 01 00 00 00 00 00 01 a0 00     15:41:39.438  IDENTIFY DEV=
ICE
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.452  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     15:41:32.451  IDENTIFY DEV=
ICE

Error 17983 [6] occurred at disk power-on lifetime: 4545 hours (189 day=
s + 9 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 02 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.452  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     15:41:32.451  IDENTIFY DEV=
ICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     15:41:32.451  SET FEATURES=
 [Set transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.447  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     15:41:32.446  IDENTIFY DEV=
ICE

Error 17982 [5] occurred at disk power-on lifetime: 4545 hours (189 day=
s + 9 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 46 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     15:41:32.451  SET FEATURES=
 [Set transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.447  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     15:41:32.446  IDENTIFY DEV=
ICE
  ea 00 00 00 00 00 00 00 00 00 00 e0 08     15:41:32.421  FLUSH CACHE =
EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.417  SET FEATURES=
 [Enable SATA feature]

Error 17981 [4] occurred at disk power-on lifetime: 4545 hours (189 day=
s + 9 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 02 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.447  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     15:41:32.446  IDENTIFY DEV=
ICE
  ea 00 00 00 00 00 00 00 00 00 00 e0 08     15:41:32.421  FLUSH CACHE =
EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.417  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     15:41:32.417  IDENTIFY DEV=
ICE

Error 17980 [3] occurred at disk power-on lifetime: 4545 hours (189 day=
s + 9 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 00 00 00 00 00 00 00 a0 00

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ea 00 00 00 00 00 00 00 00 00 00 e0 08     15:41:32.421  FLUSH CACHE =
EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.417  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     15:41:32.417  IDENTIFY DEV=
ICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     15:41:32.416  SET FEATURES=
 [Set transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.412  SET FEATURES=
 [Enable SATA feature]

Error 17979 [2] occurred at disk power-on lifetime: 4545 hours (189 day=
s + 9 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 02 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.417  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     15:41:32.417  IDENTIFY DEV=
ICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     15:41:32.416  SET FEATURES=
 [Set transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.412  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     15:41:32.412  IDENTIFY DEV=
ICE

Error 17978 [1] occurred at disk power-on lifetime: 4545 hours (189 day=
s + 9 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 46 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     15:41:32.416  SET FEATURES=
 [Set transfer mode]
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.412  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     15:41:32.412  IDENTIFY DEV=
ICE
  ea 00 00 00 00 00 00 00 00 00 00 e0 08     15:41:32.387  FLUSH CACHE =
EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.383  SET FEATURES=
 [Enable SATA feature]

Error 17977 [0] occurred at disk power-on lifetime: 4545 hours (189 day=
s + 9 hours)
  When the command that caused the error occurred, the device was activ=
e or idle.

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  04 -- 61 00 02 00 00 00 00 00 00 a0 00  Device Fault; Error: ABRT

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feat=
ure_Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  ---------=
------  --------------------
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.412  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     15:41:32.412  IDENTIFY DEV=
ICE
  ea 00 00 00 00 00 00 00 00 00 00 e0 08     15:41:32.387  FLUSH CACHE =
EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     15:41:32.383  SET FEATURES=
 [Enable SATA feature]
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     15:41:32.383  IDENTIFY DEV=
ICE

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(ho=
urs)  LBA_of_first_error
# 1  Extended offline    Interrupted (host reset)      60%      1614   =
      -
# 2  Extended offline    Completed without error       00%      1609   =
      -
# 3  Extended offline    Completed without error       00%      1588   =
      -
# 4  Extended offline    Completed without error       00%      1575   =
      -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    37 Celsius
Power Cycle Min/Max Temperature:     22/39 Celsius
Lifetime    Min/Max Temperature:     15/48 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (190)

Index    Estimated Time   Temperature Celsius
 191    2014-12-28 13:39    37  ******************
 ...    ..(476 skipped).    ..  ******************
 190    2014-12-28 21:36    37  ******************

SCT Error Recovery Control:
           Read:     70 (7,0 seconds)
          Write:     70 (7,0 seconds)

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            4  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            3  Device-to-host register FISes sent due to a COM=
RESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS,=
 CRC
0x8000  4       303934  Vendor specific

/dev/sdd
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-43-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Red (AF)
Device Model:     WDC WD30EFRX-68AX9N0
Serial Number:    WD-WMC1T3222539
LU WWN Device Id: 5 0014ee 603429eeb
=46irmware Version: 80.00A80
User Capacity:    3.000.592.982.016 bytes [3,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sun Dec 28 21:36:40 2014 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activit=
y
                                        was never started.
                                        Auto Offline Data Collection: D=
isabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                (38400) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate=
=2E
                                        Auto Offline data collection on=
/off support.
                                        Suspend Offline collection upon=
 new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before enterin=
g
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging support=
ed.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 385) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x70bd) SCT Status supported.
                                        SCT Error Recovery Control supp=
orted.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   205   171   021    -    4733
  4 Start_Stop_Count        -O--CK   100   100   000    -    105
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   094   094   000    -    4696
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    104
192 Power-Off_Retract_Count -O--CK   200   200   000    -    11
193 Load_Cycle_Count        -O--CK   200   200   000    -    93
194 Temperature_Celsius     -O---K   110   099   000    -    40
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   147   000    -    67
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(ho=
urs)  LBA_of_first_error
# 1  Extended offline    Interrupted (host reset)      60%      1597   =
      -
# 2  Extended offline    Completed without error       00%      1591   =
      -
# 3  Extended offline    Completed without error       00%      1570   =
      -
# 4  Extended offline    Completed without error       00%      1557   =
      -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    40 Celsius
Power Cycle Min/Max Temperature:     21/41 Celsius
Lifetime    Min/Max Temperature:     15/51 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (70)

Index    Estimated Time   Temperature Celsius
  71    2014-12-28 13:39    39  ********************
 ...    ..(186 skipped).    ..  ********************
 258    2014-12-28 16:46    39  ********************
 259    2014-12-28 16:47    40  *********************
 ...    ..( 10 skipped).    ..  *********************
 270    2014-12-28 16:58    40  *********************
 271    2014-12-28 16:59    39  ********************
 ...    ..(276 skipped).    ..  ********************
  70    2014-12-28 21:36    39  ********************

SCT Error Recovery Control:
           Read:     70 (7,0 seconds)
          Write:     70 (7,0 seconds)

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            4  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            3  Device-to-host register FISes sent due to a COM=
RESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS,=
 CRC
0x8000  4       303940  Vendor specific

/dev/sde
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-43-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Red (AF)
Device Model:     WDC WD30EFRX-68AX9N0
Serial Number:    WD-WMC1T3057889
LU WWN Device Id: 5 0014ee 658a09a4d
=46irmware Version: 80.00A80
User Capacity:    3.000.592.982.016 bytes [3,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sun Dec 28 21:36:40 2014 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activit=
y
                                        was never started.
                                        Auto Offline Data Collection: D=
isabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                (39720) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate=
=2E
                                        Auto Offline data collection on=
/off support.
                                        Suspend Offline collection upon=
 new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before enterin=
g
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging support=
ed.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 399) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x70bd) SCT Status supported.
                                        SCT Error Recovery Control supp=
orted.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   187   171   021    -    5608
  4 Start_Stop_Count        -O--CK   100   100   000    -    101
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   094   094   000    -    4606
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    100
192 Power-Off_Retract_Count -O--CK   200   200   000    -    9
193 Load_Cycle_Count        -O--CK   200   200   000    -    91
194 Temperature_Celsius     -O---K   113   105   000    -    37
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
Num  Test_Description    Status                  Remaining  LifeTime(ho=
urs)  LBA_of_first_error
# 1  Extended offline    Interrupted (host reset)      60%      1508   =
      -
# 2  Extended offline    Completed without error       00%      1502   =
      -
# 3  Extended offline    Completed without error       00%      1481   =
      -
# 4  Extended offline    Completed without error       00%      1469   =
      -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    37 Celsius
Power Cycle Min/Max Temperature:     22/39 Celsius
Lifetime    Min/Max Temperature:     16/46 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (9)

Index    Estimated Time   Temperature Celsius
  10    2014-12-28 13:39    37  ******************
 ...    ..(476 skipped).    ..  ******************
   9    2014-12-28 21:36    37  ******************

SCT Error Recovery Control:
           Read:     70 (7,0 seconds)
          Write:     70 (7,0 seconds)

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            4  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            3  Device-to-host register FISes sent due to a COM=
RESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS,=
 CRC
0x8000  4       303940  Vendor specific

/dev/sdf
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-43-generic] (local b=
uild)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Red (AF)
Device Model:     WDC WD30EFRX-68EUZN0
Serial Number:    WD-WMC4N0368841
LU WWN Device Id: 5 0014ee 6ae752b54
=46irmware Version: 80.00A80
User Capacity:    3.000.592.982.016 bytes [3,00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sun Dec 28 21:36:40 2014 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activit=
y
                                        was never started.
                                        Auto Offline Data Collection: D=
isabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                (40980) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate=
=2E
                                        Auto Offline data collection on=
/off support.
                                        Suspend Offline collection upon=
 new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before enterin=
g
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging support=
ed.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 411) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x703d) SCT Status supported.
                                        SCT Error Recovery Control supp=
orted.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   207   173   021    -    4641
  4 Start_Stop_Count        -O--CK   100   100   000    -    50
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   096   096   000    -    3098
 10 Spin_Retry_Count        -O--CK   100   253   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    50
192 Power-Off_Retract_Count -O--CK   200   200   000    -    6
193 Load_Cycle_Count        -O--CK   200   200   000    -    43
194 Temperature_Celsius     -O---K   113   102   000    -    37
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   100   253   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   100   253   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    37 Celsius
Power Cycle Min/Max Temperature:     22/39 Celsius
Lifetime    Min/Max Temperature:     16/48 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (401)

Index    Estimated Time   Temperature Celsius
 402    2014-12-28 13:39    37  ******************
 ...    ..(476 skipped).    ..  ******************
 401    2014-12-28 21:36    37  ******************

SCT Error Recovery Control:
           Read:     70 (7,0 seconds)
          Write:     70 (7,0 seconds)

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            4  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            3  Device-to-host register FISes sent due to a COM=
RESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS,=
 CRC
0x8000  4       303942  Vendor specific

root@pluto:~#

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

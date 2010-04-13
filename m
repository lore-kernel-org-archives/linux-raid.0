From: Mark Knecht <markknecht@gmail.com>
Subject: First experience with drive being kicked
Date: Tue, 13 Apr 2010 15:54:32 -0700
Message-ID: <n2t5bdc1c8b1004131554m1541784eve2987e7637723aeb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

OK, I was messing around in the box today adding two more drives and I
probably hit a cable or something but maybe not. /dev/md3 was
effected, but md5 built on the same drives wasn't. Possibly this has
been there for a day or two and I didn't notice it.  These drives are
only a few days old so I hope I'm not seeing some sort of early
problem. Supposedly good drives - WD 500GB RAID Edition.

Currently all my RAIDs are RAID1 assembled by the kernel at boot time.
I have no mdadm.conf file. mdadm is a running daemon.

From dmesg:

md: considering sdb3 ...
md:  adding sdb3 ...
md:  adding sdc3 ...
md:  adding sda3 ...
md: created md3
md: bind<sda3>
md: bind<sdc3>
md: bind<sdb3>
md: running: <sdb3><sdc3><sda3>
md: kicking non-fresh sdb3 from array!
md: unbind<sdb3>
md: export_rdev(sdb3)
raid1: raid set md3 active with 2 out of 3 mirrors
md3: detected capacity change from 0 to 53694562304

How do I go about trying to /dev/sdb3 back into the array and what
sort of checking is advised when this happens before I add it back?
The bad drive (sdb) doesn't look much different than the good drives.
(sda shown, sdc)

cruncher ~ # smartctl -A /dev/sdb
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   239   236   021    Pre-fail
Always       -       1016
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       24
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       87
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       22
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       12
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       11
194 Temperature_Celsius     0x0022   109   105   000    Old_age
Always       -       38
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

cruncher ~ # smartctl -A /dev/sda
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF READ SMART DATA SECTION ===
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   239   235   021    Pre-fail
Always       -       1016
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       24
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       87
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       22
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       11
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       12
194 Temperature_Celsius     0x0022   108   106   000    Old_age
Always       -       39
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

cruncher ~ #

Thanks,
Mark

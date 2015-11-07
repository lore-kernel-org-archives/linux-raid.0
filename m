From: Francisco Parada <cisco@abitofthisabitofthat.com>
Subject: Re: RAID 6 Not Mounting (Block device is empty)
Date: Sat, 7 Nov 2015 14:17:29 -0500
Message-ID: <6AC4B7C0-0AE8-4E0A-9B25-049025C386C3@abitofthisabitofthat.com>
References: <BD358508-33D4-4463-99AB-118019C2EB06@abitofthisabitofthat.com> <563E479E.50409@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2104\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <563E479E.50409@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

=46irst, I want to thank you for taking the time to reply to me, I trul=
y appreciate it.  Secondly, I must correct my statement =E2=80=9CI adde=
d two new arrays to my system last night=E2=80=9D =E2=80=A6 I had start=
ed writing this email a few nights ago, and shut down the system in ord=
er to prevent me from getting frustrated and doing something stupid.  S=
o I walked away from all of it, and just forgot to amend my original em=
ail.  So the system was off for a few days, and I turned it back on a f=
ew minutes before sending my email, and dmesg only shows today=E2=80=99=
s output, and interestingly enough, no timestamps are on there.

> 1) the dmesg from the time around the event, +/- a few minutes.

Having said that, dmesg isn=E2=80=99t showing me anything from that day=
 either, and I just found out that /var/log/messages doesn=E2=80=99t ev=
en exist in my Ubuntu Server 15.04.  It seems I have to enable that, so=
 that=E2=80=99s one more thing I=E2=80=99m about to do now.  Are there =
any other ways I could possibly retrieve that?  I=E2=80=99m afraid the =
answer will be a solid =E2=80=9Cno=E2=80=9D, but worth asking.

> 2) the output of the following drive diagnostics:
>=20
> for x in /dev/sd[a-z] ; do echo $x ; smartctl -i -A -l scterc $x ; do=
ne

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.19.0-31-generic] (local b=
uild)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Blue Serial ATA
Device Model:     WDC WD2500AAJS-00VTA0
Serial Number:    WD-WMART0793031
LU WWN Device Id: 5 0014ee 0ab2d3f8e
=46irmware Version: 01.01B01
User Capacity:    250,059,350,016 bytes [250 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
Local Time is:    Sat Nov  7 14:03:27 2015 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0003   177   177   021    Pre-fail  Alway=
s       -       2125
  4 Start_Stop_Count        0x0032   094   094   000    Old_age   Alway=
s       -       6885
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x000e   100   253   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   094   094   000    Old_age   Alway=
s       -       4641
 10 Spin_Retry_Count        0x0012   100   100   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0012   100   100   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       226
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       163
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s       -       226
194 Temperature_Celsius     0x0022   116   082   000    Old_age   Alway=
s       -       27
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0010   200   200   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Alway=
s       -       4
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.19.0-31-generic] (local b=
uild)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Green (AF, SATA 6Gb/s)
Device Model:     WDC WD30EZRX-00MMMB0
Serial Number:    WD-WCAWZ2971763
LU WWN Device Id: 5 0014ee 2b2105a3c
=46irmware Version: 80.00A80
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Nov  7 14:03:27 2015 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       1
  3 Spin_Up_Time            0x0027   153   148   021    Pre-fail  Alway=
s       -       9350
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       122
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   070   070   000    Old_age   Alway=
s       -       22291
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       106
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       60
193 Load_Cycle_Count        0x0032   094   094   000    Old_age   Alway=
s       -       318888
194 Temperature_Celsius     0x0022   118   090   000    Old_age   Alway=
s       -       34
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   176   000    Old_age   Alway=
s       -       14946
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

SCT Error Recovery Control command not supported

smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.19.0-31-generic] (local b=
uild)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Green (AF, SATA 6Gb/s)
Device Model:     WDC WD30EZRX-00D8PB0
Serial Number:    WD-WMC4N0H5ZZ3V
LU WWN Device Id: 5 0014ee 6afd6e011
=46irmware Version: 80.00A80
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Nov  7 14:03:27 2015 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       4
  3 Spin_Up_Time            0x0027   181   178   021    Pre-fail  Alway=
s       -       5933
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       42
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   095   095   000    Old_age   Alway=
s       -       3994
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       35
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       13
193 Load_Cycle_Count        0x0032   172   172   000    Old_age   Alway=
s       -       86564
194 Temperature_Celsius     0x0022   118   110   000    Old_age   Alway=
s       -       32
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s       -       895
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

SCT Error Recovery Control command not supported

smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.19.0-31-generic] (local b=
uild)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Green (AF, SATA 6Gb/s)
Device Model:     WDC WD30EZRX-00MMMB0
Serial Number:    WD-WCAWZ2957084
LU WWN Device Id: 5 0014ee 25cb87409
=46irmware Version: 80.00A80
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Nov  7 14:03:27 2015 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   148   144   021    Pre-fail  Alway=
s       -       9600
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       117
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   070   070   000    Old_age   Alway=
s       -       22299
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       100
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       57
193 Load_Cycle_Count        0x0032   096   096   000    Old_age   Alway=
s       -       314144
194 Temperature_Celsius     0x0022   116   092   000    Old_age   Alway=
s       -       36
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   188   000    Old_age   Alway=
s       -       17745
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

SCT Error Recovery Control command not supported

smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.19.0-31-generic] (local b=
uild)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Green (AF, SATA 6Gb/s)
Device Model:     WDC WD30EZRX-00MMMB0
Serial Number:    WD-WCAWZ2968521
LU WWN Device Id: 5 0014ee 2b20fc98b
=46irmware Version: 80.00A80
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Nov  7 14:03:27 2015 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   148   142   021    Pre-fail  Alway=
s       -       9583
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       123
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   070   070   000    Old_age   Alway=
s       -       22302
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       104
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       52
193 Load_Cycle_Count        0x0032   092   092   000    Old_age   Alway=
s       -       326940
194 Temperature_Celsius     0x0022   116   096   000    Old_age   Alway=
s       -       36
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   199   000    Old_age   Alway=
s       -       14499
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

SCT Error Recovery Control command not supported

smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.19.0-31-generic] (local b=
uild)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Green (AF, SATA 6Gb/s)
Device Model:     WDC WD30EZRX-00SPEB0
Serial Number:    WD-WCC4E0437242
LU WWN Device Id: 5 0014ee 25e91d5af
=46irmware Version: 80.00A80
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Nov  7 14:03:27 2015 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       6
  3 Spin_Up_Time            0x0027   176   172   021    Pre-fail  Alway=
s       -       8200
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       97
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   081   081   000    Old_age   Alway=
s       -       14450
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       81
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       47
193 Load_Cycle_Count        0x0032   159   159   000    Old_age   Alway=
s       -       124845
194 Temperature_Celsius     0x0022   118   099   000    Old_age   Alway=
s       -       34
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   199   000    Old_age   Alway=
s       -       12706
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

SCT Error Recovery Control command not supported

smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.19.0-31-generic] (local b=
uild)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Green (AF, SATA 6Gb/s)
Device Model:     WDC WD30EZRX-00MMMB0
Serial Number:    WD-WCAWZ2963057
LU WWN Device Id: 5 0014ee 20762f880
=46irmware Version: 80.00A80
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Nov  7 14:03:27 2015 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   177   147   021    Pre-fail  Alway=
s       -       8108
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       124
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   070   070   000    Old_age   Alway=
s       -       22301
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       108
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       62
193 Load_Cycle_Count        0x0032   090   090   000    Old_age   Alway=
s       -       330837
194 Temperature_Celsius     0x0022   117   096   000    Old_age   Alway=
s       -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   179   000    Old_age   Alway=
s       -       27256
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

SCT Error Recovery Control command not supported

smartctl 6.4 2014-10-07 r4002 [x86_64-linux-3.19.0-31-generic] (local b=
uild)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Green (AF, SATA 6Gb/s)
Device Model:     WDC WD30EZRX-00D8PB0
Serial Number:    WD-WMC4N1816663
LU WWN Device Id: 5 0014ee 0592d9c0a
=46irmware Version: 80.00A80
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Sat Nov  7 14:03:27 2015 EST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s       -       0
  3 Spin_Up_Time            0x0027   165   165   021    Pre-fail  Alway=
s       -       6733
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s       -       36
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s       -       0
  9 Power_On_Hours          0x0032   097   097   000    Old_age   Alway=
s       -       2716
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s       -       32
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s       -       11
193 Load_Cycle_Count        0x0032   192   192   000    Old_age   Alway=
s       -       24669
194 Temperature_Celsius     0x0022   122   112   000    Old_age   Alway=
s       -       28
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne      -       0
199 UDMA_CRC_Error_Count    0x0032   200   182   000    Old_age   Alway=
s       -       1640
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne      -       0

SCT Error Recovery Control command not supported
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

> Do *not* perform any --create operation on your array.
No worries, I=E2=80=99m not touching that.  Thank you for your input.

> *Do* read the list archives linked below -- if any part of it is
> unclear, please ask in your next reply.
>=20
> Phil
>=20
> [1] http://marc.info/?l=3Dlinux-raid&m=3D139050322510249&w=3D2
> [2] http://marc.info/?l=3Dlinux-raid&m=3D135863964624202&w=3D2
> [3] http://marc.info/?l=3Dlinux-raid&m=3D135811522817345&w=3D1
> [4] http://marc.info/?l=3Dlinux-raid&m=3D133761065622164&w=3D2
> [5] http://marc.info/?l=3Dlinux-raid&m=3D132477199207506
> [6] http://marc.info/?l=3Dlinux-raid&m=3D133665797115876&w=3D2
> [7] http://marc.info/?l=3Dlinux-raid&m=3D142487508806844&w=3D3

Much appreciated, giving those a look now.

Thank you,

Cisco--
=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Mark Knecht <markknecht@gmail.com>
Subject: Re: crash/dmesg - RAID locking up?
Date: Mon, 29 Mar 2010 05:44:35 -0700
Message-ID: <5bdc1c8b1003290544h10a1b71mea9d4ab996fe2729@mail.gmail.com>
References: <5bdc1c8b1003281531r2fe1e3e5q47212843bbaa0641@mail.gmail.com>
	 <4BB0267E.8080605@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB0267E.8080605@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Mar 28, 2010 at 9:03 PM, Stefan /*St0fF*/ H=C3=BCbner
<stefan.huebner@stud.tu-ilmenau.de> wrote:
> Am 29.03.2010 00:31, schrieb Mark Knecht:
>> So I'm giving up on mdadm/RAID1/WD10EARS Green Drive experiment for
>> the next day or two. I've tried 4 times in the last two days to see =
if
>> I can get this machine to boot using RAID. I keep running into crash=
es
>> that look like the one below. I will try a non-RAID install and see =
if
>> the hardware is stable and then come back to this later if
>> appropriate.
>>
>> I was running a March, 2010 Gentoo install CD when this happened. On=
e
>> terminal doing bash completion of all things was hung with 1 CPU stu=
ck
>> in a 100% wait condition. New terminals continued to work if I didn'=
t
>> try to access the hard drive. I can run things from the CD.
>
> Hi Mark, that's been the desktop-nature of the disks. =C2=A0Please ru=
n
> smartctl -A /dev/sdX on those disks and see if any have _raw_ values =
of
> "pending_sector_count" larger than zero.
> If so, let the disks get exchanged by your vendor, stating: "data los=
s
> already occurred" or "computer freezes with this disk connected".
> They'll (at least WD) exchange the disk without questions.
>
> To clarify: it seems to me that at least one disk has bad magnetizati=
on
> on at least one platter, causing it to enter error correction code al=
l
> the time and by that not responding...
>
<SNIP>

None of the items that look like errors to me have counts greater than
0 so far. I do not see "pending_sector_Count" reported by these
drives.

- Mark

keeper ~ # smartctl -A /dev/sda
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   136   134   021    Pre-fail
Always       -       6175
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       13
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       21
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       11
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       10
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       345
194 Temperature_Celsius     0x0022   125   102   000    Old_age
Always       -       22
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

keeper ~ # smartctl -A /dev/sdb
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   134   130   021    Pre-fail
Always       -       6258
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       14
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       21
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       12
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       11
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       203
194 Temperature_Celsius     0x0022   125   098   000    Old_age
Always       -       22
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

keeper ~ # smartctl -A /dev/sdc
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   131   128   021    Pre-fail
Always       -       6416
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       14
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age
Always       -       21
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       12
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       11
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       199
194 Temperature_Celsius     0x0022   125   099   000    Old_age
Always       -       22
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

keeper ~ #

I ran the short selftest in the devices and there were no errors
reported. I've started the long selftest but that takes 4 hours to
complete so I'll have to report on that later.

keeper ~ # smartctl -l error /dev/sda
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Error Log Version: 1
No Errors Logged

keeper ~ # smartctl -l error /dev/sdb
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Error Log Version: 1
No Errors Logged

keeper ~ # smartctl -l error /dev/sdc
smartctl 5.39.1 2010-01-28 r3054 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Error Log Version: 1
No Errors Logged

keeper ~ #

Thanks,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

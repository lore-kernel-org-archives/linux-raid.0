From: Mark Knecht <markknecht@gmail.com>
Subject: Considering a complete rework of RAID on my home compute server
Date: Wed, 29 Dec 2010 11:54:15 -0800
Message-ID: <AANLkTinsQoPVaYVe4H9kMK7_-GFzHoKt_Zdf4nUKc+C2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   I set up RAID using mdadm for the first time 8-9 months ago. As a
complete newbie, of which class I still consider myself, I made a
bunch of compromises at that time. I am now considering reworking the
setup and am looking for some guidance.

   The system has 5 500GB WD RAID Edition drives. They are all the
same model purchased at the same time so they are subject to some of
the  statistical problems that happen when one does this. The system
runs MySQL in Linux and then (typically) runs 3 or 4 VirtualBox VMs
running different versions of Windows.

1) The Linux/MySQL stuff is a 3 drive RAID1. (sda/sdb/sdc)

2) The Windows VMs run on a 2 drive RAID0 (sdd/sde)

3) There is a second RAID1 (sda/sdb/sdc) used for backups of the
RAID0. The RAID0 is backed up to RAID1 nightly. If the RAID0 fails
then I lose 1 day's work.

The RAID1 is backed up to another machine every week or two. This is a
home network, not a business but I do depend on the data to be there
if there's some hardware failure. With a 3 drive RAID1 I figure I'm
not in huge danger unless a power supply failure takes out all of the
drives.

   I will copy smartctl -a data at the end of this email ifor all
drives n case it might impact any inputs.


   OK - the problems I have with this arrangement are:

1) I used the older v0.9 metadata.

2) The RAIDs are assembled by the kernel automatically. I do not use
an initrd. (Because I don't know how/newer have)

3) I think with 5 disks I could get better performance  than I
currently get , with similar or better safety using maybe RAID5 or
RAID6.

   Overall, as I see it, I can suffer no disk loss on the RAID0, and
can handle a 2 disk loss on the RAID1. (Is that correct?) I'm thinking
that with a 5-drive RAID6 I might well get better performance than
either of the current RAIDs and (from reading) more protection during
a rebuild if one of my drives goes bad.

   All said, I'm leaning toward RAID6 support everything (MySQL and
VMs), probably about 100GB to start with, and then would hopefully
scale the size up using the rest of the drives after data is copied
over to the new RAID6. I'd build RAID6, copy everything from the
current system, ensure the new RAID boots, etc, then eventually blow
away the old partitions and resize the RAID 6 larger.

   Does this make sense? What am I missing or should be thinking about.

   I have no problem buying maybe 1 new drive now as a spare. The
chassis is filled at this time and there's no way to run what I think
is considered a hot spare.

Thanks in advance,
Mark







c2stable ~ # smartctl -a /dev/sda
smartctl 5.40 2010-10-16 r3189 [x86_64-pc-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital RE3 Serial ATA family
Device Model:     WDC WD5002ABYS-02B1B0
Serial Number:    WD-WCASYA846988
Firmware Version: 02.03B03
User Capacity:    500,107,862,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Dec 29 11:31:35 2010 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
<SNIP>
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   238   235   021    Pre-fail
Always       -       1100
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       308
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   099   099   000    Old_age
Always       -       1363
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       306
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       15
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       292
194 Temperature_Celsius     0x0022   099   089   000    Old_age
Always       -       48
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

SMART Error Log Version: 1
No Errors Logged



c2stable ~ # smartctl -a /dev/sdb
<SNIP>

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   237   236   021    Pre-fail
Always       -       1108
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       308
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   099   099   000    Old_age
Always       -       1362
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       306
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       16
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       291
194 Temperature_Celsius     0x0022   098   090   000    Old_age
Always       -       49
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

SMART Error Log Version: 1
No Errors Logged




c2stable ~ # smartctl -a /dev/sdc
<SNIP>

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   238   236   021    Pre-fail
Always       -       1100
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       308
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   099   099   000    Old_age
Always       -       1362
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       306
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       15
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       292
194 Temperature_Celsius     0x0022   102   091   000    Old_age
Always       -       45
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

SMART Error Log Version: 1
No Errors Logged



c2stable ~ # smartctl -a /dev/sdd
<SNIP>

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   238   235   021    Pre-fail
Always       -       1100
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       296
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   099   099   000    Old_age
Always       -       1299
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       294
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       29
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       266
194 Temperature_Celsius     0x0022   098   090   000    Old_age
Always       -       49
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

SMART Error Log Version: 1
No Errors Logged



c2stable ~ # smartctl -a /dev/sde
<SNIP>

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   237   236   021    Pre-fail
Always       -       1108
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       297
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   099   099   000    Old_age
Always       -       1300
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       295
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       17
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       279
194 Temperature_Celsius     0x0022   103   094   000    Old_age
Always       -       44
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

SMART Error Log Version: 1
No Errors Logged

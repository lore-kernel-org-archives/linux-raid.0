From: Ben <benjammin2068@gmail.com>
Subject: Re: Need Help with crashed RAID5 (that was rebuilding and then had
 SATA error on another drive)
Date: Thu, 25 Aug 2016 20:20:37 -0500
Message-ID: <57BF9965.1020403@gmail.com>
References: <CADDTLRB9z6J0F6+uO3k-u74qnjZxiagbNLWrg_tP5GSZt-Vd5A@mail.gmail.com>
 <215fd175-65b6-e24b-338f-0c44ae030573@websitemanagers.com.au>
 <CADDTLRBf9NPO6OuF4a3b+xffZgeZRqHRG+pJdPmbc9-Jat0HVQ@mail.gmail.com>
 <d6d3fe0d-3f9f-985f-9bfb-051428cf221b@websitemanagers.com.au>
 <57BBDA5B.3020706@gmail.com> <57BBDC15.5030301@gmail.com>
 <b8c6a380-7e6a-fda9-5834-b85271b26892@websitemanagers.com.au>
 <57BC61F7.8070102@gmail.com>
 <aca4e83f-9a3f-c200-7c16-3b5d9df52c1e@websitemanagers.com.au>
 <57BE450B.4030700@gmail.com>
 <56e86db5-456d-e9c1-339d-ba8903fe5dde@websitemanagers.com.au>
 <57BE52BC.6040908@gmail.com>
 <933228e0-bce4-ffad-f48d-034bf89bc07f@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080008030004000200030401"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <933228e0-bce4-ffad-f48d-034bf89bc07f@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------080008030004000200030401
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit

As an update,

Adam's been helping me out (and I'm not used to hitting "reply-all" for mailing lists as pretty  much all the ones I'm on set the "reply-to:")

I've turned on sct/erc for the drives... and the one that went bonkers during the rebuild (sde) still would have read issues during a rebuild.

SMART reports it's ok. but.. (shrug) I ended up running ddrescue to the new replacement drive (sdc) that kept getting put back into spare status when the rebuilds would fail.

So I just copied sde -> sdc which went pretty much flawlessly (ddrescue completed without any final complaints)

I also played with badblocks after doing my copy and could find bad blocks -- but apparnently ddrescue had no issues.

So - I went back to

*bringing up the array. No problems.
* adding ANOTHER new drive (that I ordered Sunday night) and it rebuilt fine.
* doing an FSCK -n first which reported no issues - so I did a regular fsck (without -y) and it never prompted me for anything.

My last step is to run rsync -n from my backup to see if it can find any issues between my last backup and the current data for any files with byte oddities.

All this has me wonder if those old bad sectors left some files with a sector of garbage in them or not.

Adam seems to think everything is fine -- so far, that seems to be the case.

A last few questions I have are:

The new drive I got was (supposed to be) the same model as the last Seagate I ordered, but SMART reports them differently. (see attached)

The question on the new drive is that it says it does offline collection... but with gsmartcontrol, I can't seem to turn it on.

This new drive also doesn't seem to support SCT/ERC the same way.

Again,

/dev/sdc - old new spare (bought after seagate bought Samsung and discontinued the HD103SJ model)
/dev/sdd - original RAID member
/dev/sde - brand spanking new drive purchased Sunday.
/dev/sdf - original RAID member

I realize now one says: ST1000DM005 vs ST1000DM003 - Grrr!!!

So I'd like recommendations on whether I should get better matching drives (I can use these elsewhere) or it doesn't matter.

Can I mix/match this array with WD REDs? (and eventually retire all these HD103SJ drives) Do people even like these? They seem ok?

I read a lot of conflicting info on SCT/ERC online (well, TLER anyway) -- Adam likes it enabled. What say the rest of you?

And last -- any caveats as to upgrading this array to RAID6 from RAID5? Can I even do that while in place?

Thanks all, (especially Adam!)

  -Ben

p.s. Check out some of the SMART parms on the /dev/sde. Head flying hours?? And they're not zero. Weird. :/ This drive kinda creeps me out.


--------------080008030004000200030401
Content-Type: text/plain; charset=UTF-8;
 name="RAID.smart-info.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="RAID.smart-info.txt"

[root@quantum ~]# smartctl -a /dev/sdc
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-2.6.32-642.el6.centos.plus.x86_64] (local build)
Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     ST1000DM005 HD103SJ
Serial Number:    S246JQ0D800949
LU WWN Device Id: 5 0000f0 080bb4909
Firmware Version: 1AJ10001
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 6
Local Time is:    Thu Aug 25 20:04:06 2016 CDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                ( 9120) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 152) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   100   051    Pre-fail  Always       -       0
  2 Throughput_Performance  0x0026   054   054   000    Old_age   Always       -       8630
  3 Spin_Up_Time            0x0023   076   071   025    Pre-fail  Always       -       7526
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       11
  5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   252   252   051    Old_age   Always       -       0
  8 Seek_Time_Performance   0x0024   252   252   015    Old_age   Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       133
 10 Spin_Retry_Count        0x0032   252   252   051    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   252   252   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       14
191 G-Sense_Error_Rate      0x0022   252   252   000    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age   Always       -       0
194 Temperature_Celsius     0x0002   064   063   000    Old_age   Always       -       30 (Min/Max 21/37)
195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age   Always       -       0
196 Reallocated_Event_Count 0x0032   252   252   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   252   252   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   252   252   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0036   100   100   000    Old_age   Always       -       10
200 Multi_Zone_Error_Rate   0x002a   100   096   000    Old_age   Always       -       558
223 Load_Retry_Count        0x0032   252   252   000    Old_age   Always       -       0
225 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       14
========================================================================================================================
[root@quantum ~]# smartctl -a /dev/sdd
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-2.6.32-642.el6.centos.plus.x86_64] (local build)
Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F3
Device Model:     SAMSUNG HD103SJ
Serial Number:    S246J9AB404176
LU WWN Device Id: 5 0024e9 204fbf695
Firmware Version: 1AJ10001
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 6
Local Time is:    Thu Aug 25 20:05:32 2016 CDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                ( 9180) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 153) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   100   051    Pre-fail  Always       -       195
  2 Throughput_Performance  0x0026   252   252   000    Old_age   Always       -       0
  3 Spin_Up_Time            0x0023   073   070   025    Pre-fail  Always       -       8310
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       58
  5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   252   252   051    Old_age   Always       -       0
  8 Seek_Time_Performance   0x0024   252   252   015    Old_age   Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       37763
 10 Spin_Retry_Count        0x0032   252   252   051    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   252   252   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       75
191 G-Sense_Error_Rate      0x0022   252   252   000    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age   Always       -       0
194 Temperature_Celsius     0x0002   064   062   000    Old_age   Always       -       31 (Min/Max 20/43)
195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age   Always       -       0
196 Reallocated_Event_Count 0x0032   252   252   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   252   252   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   252   252   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0036   100   100   000    Old_age   Always       -       8
200 Multi_Zone_Error_Rate   0x002a   100   100   000    Old_age   Always       -       146
223 Load_Retry_Count        0x0032   252   252   000    Old_age   Always       -       0
225 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       77
========================================================================================================================
[root@quantum ~]# smartctl -a /dev/sde
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-2.6.32-642.el6.centos.plus.x86_64] (local build)
Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda (SATA 3Gb/s, 4K Sectors)
Device Model:     ST1000DM003-1ER162
Serial Number:    Z4YDLXWJ
LU WWN Device Id: 5 000c50 091877801
Firmware Version: CC45
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ACS-2 (unknown minor revision code: 0x001f)
Local Time is:    Thu Aug 25 20:06:33 2016 CDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                (   80) seconds.
Offline data collection
capabilities:                    (0x73) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        No Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 105) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x1085) SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   108   100   006    Pre-fail  Always       -       18255632
  3 Spin_Up_Time            0x0003   100   100   000    Pre-fail  Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always       -       2
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x000f   100   253   030    Pre-fail  Always       -       269743
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       9
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always       -       2
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age   Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   Always       -       0
189 High_Fly_Writes         0x003a   099   099   000    Old_age   Always       -       1
190 Airflow_Temperature_Cel 0x0022   071   068   045    Old_age   Always       -       29 (Min/Max 26/32)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age   Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age   Always       -       1
193 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       21
194 Temperature_Celsius     0x0022   029   040   000    Old_age   Always       -       29 (0 25 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   Offline      -       109964047679495
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   Offline      -       3907074414
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   Offline      -       5102115

========================================================================================================================
[root@quantum ~]# smartctl -a /dev/sdf
smartctl 5.43 2012-06-30 r3573 [x86_64-linux-2.6.32-642.el6.centos.plus.x86_64] (local build)
Copyright (C) 2002-12 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     SAMSUNG SpinPoint F3
Device Model:     SAMSUNG HD103SJ
Serial Number:    S246J9AB404174
LU WWN Device Id: 5 0024e9 204fbf676
Firmware Version: 1AJ10001
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 6
Local Time is:    Thu Aug 25 20:07:19 2016 CDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80) Offline data collection activity
                                        was never started.
                                        Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
                                        without error or no self-test has ever
                                        been run.
Total time to complete Offline
data collection:                ( 9360) seconds.
Offline data collection
capabilities:                    (0x5b) SMART execute Offline immediate.
                                        Auto Offline data collection on/off support.
                                        Suspend Offline collection upon new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        No Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 156) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
                                        SCT Error Recovery Control supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   100   100   051    Pre-fail  Always       -       353
  2 Throughput_Performance  0x0026   055   055   000    Old_age   Always       -       8559
  3 Spin_Up_Time            0x0023   073   069   025    Pre-fail  Always       -       8389
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       74
  5 Reallocated_Sector_Ct   0x0033   252   252   010    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   252   252   051    Old_age   Always       -       0
  8 Seek_Time_Performance   0x0024   252   252   015    Old_age   Offline      -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Always       -       43724
 10 Spin_Retry_Count        0x0032   252   252   051    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   252   252   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       92
191 G-Sense_Error_Rate      0x0022   100   100   000    Old_age   Always       -       1
192 Power-Off_Retract_Count 0x0022   252   252   000    Old_age   Always       -       0
194 Temperature_Celsius     0x0002   064   063   000    Old_age   Always       -       30 (Min/Max 15/40)
195 Hardware_ECC_Recovered  0x003a   100   100   000    Old_age   Always       -       0
196 Reallocated_Event_Count 0x0032   252   252   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   252   252   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   252   252   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0036   100   100   000    Old_age   Always       -       91
200 Multi_Zone_Error_Rate   0x002a   100   100   000    Old_age   Always       -       229
223 Load_Retry_Count        0x0032   252   252   000    Old_age   Always       -       0
225 Load_Cycle_Count        0x0032   100   100   000    Old_age   Always       -       100

========================================================================================================================





--------------080008030004000200030401--

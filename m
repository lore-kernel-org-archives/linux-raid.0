From: Eli Morris <ermorris@ucsc.edu>
Subject: Fwd: 4 out of 16 drives show up as 'removed'
Date: Wed, 7 Dec 2011 13:27:47 -0800
Message-ID: <3EF1DB53-E58E-44B4-BCE0-C78C4CAD517F@ucsc.edu>
References: <FCC79D15-074C-4DBC-B05F-F3BDF8A3B495@ucsc.edu>
Mime-Version: 1.0 (Apple Message framework v1251.1)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> On 7 December 2011 20:42, Eli Morris <ermorris@ucsc.edu> wrote:
>> Hi All,
>> 
>>  I thought maybe someone could help me out. I have a 16 disk software RAID that we use for backup. This is at least the second time this happened- all at once, four of the drives report as 'removed' when none of them actually were. These drives also disappeared from the 'lsscsi' list until I restarted the disk expansion chassis where they live.
>> 
>> These are the dreaded Caviar Green drives. We bought 16 of them as an upgrade for a hardware RAID originally, because the tech from that company said they would work fine. After running them for a while, four drives dropped out of that array. So I put them in the software RAID expansion chassis they are in now, thinking I might have better luck. In this configuration, this happened once before. That time, the drives looked to all have significant numbers of bad sectors, so I got those ones replaced and thought that that might have been the problem all along. Now it has happened again. So I have two fairly predictable questions and I'm hoping someone might be able to offer a suggestion:
>> 
>> 1) Any ideas on how to get this array working again without starting from scratch? It's all backup data, so it's not do or die, but it is also 30 TB and I really don't want to rebuild the whole thing again from scratch.
>> 
>> I tried the re-add command and the error was something like 'not allowed'
>> 
>> 2) Any idea on how to stop this from happening again? I was thinking of playing with the disk timeout in the OS (not the one on the drive firmware).
>> 
>> If anyway can help, I'd greatly appreciate it, because, at this point, I have no idea what to do about this mess.
>> 
>> Thanks!
>> 
>> Eli
>> 
>> 
>> [root@stratus ~]# mdadm --detail /dev/md5
>> /dev/md5:
>>        Version : 1.2
>>  Creation Time : Wed Oct 12 16:32:41 2011
>>     Raid Level : raid5
>>  Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>>   Raid Devices : 16
>>  Total Devices : 13
>>    Persistence : Superblock is persistent
>> 
>>    Update Time : Mon Dec  5 12:52:46 2011
>>          State : active, FAILED, Not Started
>>  Active Devices : 12
>> Working Devices : 13
>>  Failed Devices : 0
>>  Spare Devices : 1
>> 
>>         Layout : left-symmetric
>>     Chunk Size : 512K
>> 
>>           Name : stratus.pmc.ucsc.edu:5  (local to host stratus.pmc.ucsc.edu)
>>           UUID : 3189ca06:ccf973d0:7ef41366:98a75a32
>>         Events : 32
>> 
>>    Number   Major   Minor   RaidDevice State
>>       0       8        1        0      active sync   /dev/sda1
>>       1       0        0        1      removed
>>       2       8       33        2      active sync   /dev/sdc1
>>       3       8       49        3      active sync   /dev/sdd1
>>       4       8       65        4      active sync   /dev/sde1
>>       5       8       81        5      active sync   /dev/sdf1
>>       6       8       97        6      active sync   /dev/sdg1
>>       7       8      113        7      active sync   /dev/sdh1
>>       8       0        0        8      removed
>>       9       8      145        9      active sync   /dev/sdj1
>>      10       8      161       10      active sync   /dev/sdk1
>>      11       8      177       11      active sync   /dev/sdl1
>>      12       8      193       12      active sync   /dev/sdm1
>>      13       8      209       13      active sync   /dev/sdn1
>>      14       0        0       14      removed
>>      15       0        0       15      removed
>> 
>>      16       8      225        -      spare   /dev/sdo1
>> [root@stratus ~]#
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> Hi,
> 
> To eliminate bad disks, can you post the smartctl -a output of all the
> removed drives? (if you can get the OS to see them again)
> 
> Also, do you have any log files from when this happened? (kernel log,
> dmesg, syslog etc)
> 
> Regards,
> Mathias
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi Mathias,

First of all, thanks for answering. Once I power cycled the disk expansion enclosure and rebooted, all the drives were recognized by the OS. Last time this happened, the same thing occurred. Once I cycled the enclosure and rebooted, all the drives seemed to work OK. I was immediately able to reformat them and recreate the array, so it's more like something is causing a glitch rather than the drives actually permanently failing. 

Below is the output from smartctl and the section of the 'messages' log from when I tried to mount and use the disk array and it's failure. I will look through the other system files and see if I can post anything from them also. This is a long enough post as is. Sorry. I'm not sure what info on these will help or I'd condense it.

Thanks again,

Eli


Here is the 'smartctl -a'  output for the four bad drives:

[root@stratus ~]#  smartctl -a /dev/sdb
smartctl 5.39.1 2010-01-28 r3054 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green family
Device Model:     WDC WD20EADS-32S2B0
Serial Number:    WD-WCAVY0634185
Firmware Version: 01.00A01
User Capacity:    2,000,398,934,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Dec  7 12:56:38 2011 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 (43800) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.
SCT capabilities: 	       (0x303f)	SCT Status supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
  3 Spin_Up_Time            0x0027   149   149   021    Pre-fail  Always       -       9541
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       52
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   091   091   000    Old_age   Always       -       7252
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       51
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       33
193 Load_Cycle_Count        0x0032   174   174   000    Old_age   Always       -       79577
194 Temperature_Celsius     0x0022   124   103   000    Old_age   Always       -       28
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      7208         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

[root@stratus ~]#  smartctl -a /dev/sdi
smartctl 5.39.1 2010-01-28 r3054 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green family
Device Model:     WDC WD20EADS-00S2B0
Serial Number:    WD-WCAVY1135408
Firmware Version: 01.00A01
User Capacity:    2,000,398,934,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Dec  7 12:57:19 2011 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)	Offline data collection activity
					was completed without error.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 (39900) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.
SCT capabilities: 	       (0x303f)	SCT Status supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
  3 Spin_Up_Time            0x0027   152   152   021    Pre-fail  Always       -       9375
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       37
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   091   091   000    Old_age   Always       -       6694
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       36
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       21
193 Load_Cycle_Count        0x0032   178   178   000    Old_age   Always       -       66473
194 Temperature_Celsius     0x0022   125   113   000    Old_age   Always       -       27
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   180   000    Old_age   Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
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
If Selective self-test is pending on power-up, resume after 0 minute delay.

[root@stratus ~]#  smartctl -a /dev/sdo
smartctl 5.39.1 2010-01-28 r3054 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green family
Device Model:     WDC WD20EADS-00S2B0
Serial Number:    WD-WCAVY1300654
Firmware Version: 01.00A01
User Capacity:    2,000,398,934,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Dec  7 12:57:44 2011 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)	Offline data collection activity
					was suspended by an interrupting command from host.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 (41460) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.
SCT capabilities: 	       (0x303f)	SCT Status supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
  3 Spin_Up_Time            0x0027   152   152   021    Pre-fail  Always       -       9400
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       76
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   085   085   000    Old_age   Always       -       11352
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       75
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       47
193 Load_Cycle_Count        0x0032   118   118   000    Old_age   Always       -       246444
194 Temperature_Celsius     0x0022   123   100   000    Old_age   Always       -       29
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   001   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%      5496         -

SMART Selective self-test log data structure revision number 1
 SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
    1        0        0  Not_testing
    2        0        0  Not_testing
    3        0        0  Not_testing
    4        0        0  Not_testing
    5        0        0  Not_testing
Selective self-test flags (0x0):
  After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

[root@stratus ~]#  smartctl -a /dev/sdp
smartctl 5.39.1 2010-01-28 r3054 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green family
Device Model:     WDC WD20EADS-00S2B0
Serial Number:    WD-WCAVY1141137
Firmware Version: 01.00A01
User Capacity:    2,000,398,934,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Dec  7 12:57:51 2011 PST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)	Offline data collection activity
					was suspended by an interrupting command from host.
					Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)	The previous self-test routine completed
					without error or no self-test has ever 
					been run.
Total time to complete Offline 
data collection: 		 (39780) seconds.
Offline data collection
capabilities: 			 (0x7b) SMART execute Offline immediate.
					Auto Offline data collection on/off support.
					Suspend Offline collection upon new
					command.
					Offline surface scan supported.
					Self-test supported.
					Conveyance Self-test supported.
					Selective Self-test supported.
SMART capabilities:            (0x0003)	Saves SMART data before entering
					power-saving mode.
					Supports SMART auto save timer.
Error logging capability:        (0x01)	Error logging supported.
					General Purpose Logging supported.
Short self-test routine 
recommended polling time: 	 (   2) minutes.
Extended self-test routine
recommended polling time: 	 ( 255) minutes.
Conveyance self-test routine
recommended polling time: 	 (   5) minutes.
SCT capabilities: 	       (0x303f)	SCT Status supported.
					SCT Feature Control supported.
					SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Always       -       0
  3 Spin_Up_Time            0x0027   151   151   021    Pre-fail  Always       -       9433
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Always       -       57
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Always       -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Always       -       0
  9 Power_On_Hours          0x0032   088   088   000    Old_age   Always       -       9322
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Always       -       56
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always       -       19
193 Load_Cycle_Count        0x0032   154   154   000    Old_age   Always       -       140315
194 Temperature_Celsius     0x0022   123   104   000    Old_age   Always       -       29
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
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
If Selective self-test is pending on power-up, resume after 0 minute delay.

[root@stratus ~]# 

Here are the log files from 'messages' from when the problems occurred:


Dec  5 12:52:19 stratus mountd[6145]: authenticated mount request from 128.114.68.33:632 for /backup (/backup)
Dec  5 12:52:39 stratus kernel: scsi 0:0:1:0: rejecting I/O to dead device
Dec  5 12:52:39 stratus kernel: end_request: I/O error, dev sdb, sector 0
Dec  5 12:52:39 stratus kernel: scsi 0:0:14:0: rejecting I/O to dead device
Dec  5 12:52:39 stratus kernel: end_request: I/O error, dev sdo, sector 0
Dec  5 12:52:39 stratus kernel: scsi 0:0:15:0: rejecting I/O to dead device
Dec  5 12:52:39 stratus kernel: end_request: I/O error, dev sdp, sector 0
Dec  5 12:52:39 stratus kernel: scsi 0:0:8:0: rejecting I/O to dead device
Dec  5 12:52:39 stratus kernel: end_request: I/O error, dev sdi, sector 0
Dec  5 12:52:42 stratus kernel: scsi 0:0:1:0: rejecting I/O to dead device
Dec  5 12:52:42 stratus kernel: scsi 0:0:1:0: rejecting I/O to dead device
Dec  5 12:52:42 stratus kernel: end_request: I/O error, dev sdb, sector 8
Dec  5 12:52:42 stratus kernel: md: super_written gets error=-5, uptodate=0
Dec  5 12:52:42 stratus kernel: raid5: Disk failure on sdb1, disabling device.
Dec  5 12:52:42 stratus kernel: raid5: Operation continuing on 15 devices.
Dec  5 12:52:42 stratus kernel: scsi 0:0:14:0: rejecting I/O to dead device
Dec  5 12:52:42 stratus kernel: scsi 0:0:14:0: rejecting I/O to dead device
Dec  5 12:52:42 stratus kernel: end_request: I/O error, dev sdo, sector 8
Dec  5 12:52:42 stratus kernel: md: super_written gets error=-5, uptodate=0
Dec  5 12:52:42 stratus kernel: raid5: Disk failure on sdo1, disabling device.
Dec  5 12:52:42 stratus kernel: raid5: Operation continuing on 14 devices.
Dec  5 12:52:42 stratus kernel: scsi 0:0:15:0: rejecting I/O to dead device
Dec  5 12:52:42 stratus kernel: scsi 0:0:15:0: rejecting I/O to dead device
Dec  5 12:52:42 stratus kernel: end_request: I/O error, dev sdp, sector 8
Dec  5 12:52:42 stratus kernel: md: super_written gets error=-5, uptodate=0
Dec  5 12:52:42 stratus kernel: raid5: Disk failure on sdp1, disabling device.
Dec  5 12:52:42 stratus kernel: raid5: Operation continuing on 13 devices.
Dec  5 12:52:42 stratus kernel: scsi 0:0:8:0: rejecting I/O to dead device
Dec  5 12:52:42 stratus kernel: scsi 0:0:8:0: rejecting I/O to dead device
Dec  5 12:52:42 stratus kernel: end_request: I/O error, dev sdi, sector 8
Dec  5 12:52:42 stratus kernel: md: super_written gets error=-5, uptodate=0
Dec  5 12:52:42 stratus kernel: raid5: Disk failure on sdi1, disabling device.
Dec  5 12:52:42 stratus kernel: raid5: Operation continuing on 12 devices.
Dec  5 12:52:46 stratus kernel: RAID5 conf printout:
Dec  5 12:52:46 stratus kernel: --- rd:16 wd:12
Dec  5 12:52:46 stratus kernel: disk 0, o:1, dev:sda1
Dec  5 12:52:46 stratus kernel: disk 1, o:0, dev:sdb1
Dec  5 12:52:46 stratus kernel: disk 2, o:1, dev:sdc1
Dec  5 12:52:46 stratus kernel: disk 3, o:1, dev:sdd1
Dec  5 12:52:46 stratus kernel: disk 4, o:1, dev:sde1
Dec  5 12:52:46 stratus kernel: disk 5, o:1, dev:sdf1
Dec  5 12:52:46 stratus kernel: disk 6, o:1, dev:sdg1
Dec  5 12:52:46 stratus kernel: disk 7, o:1, dev:sdh1
Dec  5 12:52:46 stratus kernel: disk 8, o:0, dev:sdi1
Dec  5 12:52:46 stratus kernel: disk 9, o:1, dev:sdj1
Dec  5 12:52:46 stratus kernel: disk 10, o:1, dev:sdk1
Dec  5 12:52:46 stratus kernel: disk 11, o:1, dev:sdl1
Dec  5 12:52:46 stratus kernel: disk 12, o:1, dev:sdm1
Dec  5 12:52:46 stratus kernel: disk 13, o:1, dev:sdn1
Dec  5 12:52:46 stratus kernel: disk 14, o:0, dev:sdo1
Dec  5 12:52:46 stratus kernel: disk 15, o:0, dev:sdp1
Dec  5 12:52:46 stratus kernel: RAID5 conf printout:
Dec  5 12:52:46 stratus kernel: --- rd:16 wd:12
Dec  5 12:52:46 stratus kernel: disk 0, o:1, dev:sda1
Dec  5 12:52:46 stratus kernel: disk 2, o:1, dev:sdc1
Dec  5 12:52:46 stratus kernel: disk 3, o:1, dev:sdd1
Dec  5 12:52:46 stratus kernel: disk 4, o:1, dev:sde1
Dec  5 12:52:46 stratus kernel: disk 5, o:1, dev:sdf1
Dec  5 12:52:46 stratus kernel: disk 6, o:1, dev:sdg1
Dec  5 12:52:46 stratus kernel: disk 7, o:1, dev:sdh1
Dec  5 12:52:46 stratus kernel: disk 8, o:0, dev:sdi1
Dec  5 12:52:46 stratus kernel: disk 9, o:1, dev:sdj1
Dec  5 12:52:46 stratus kernel: disk 10, o:1, dev:sdk1
Dec  5 12:52:46 stratus kernel: disk 11, o:1, dev:sdl1
Dec  5 12:52:46 stratus kernel: disk 12, o:1, dev:sdm1
Dec  5 12:52:46 stratus kernel: disk 13, o:1, dev:sdn1
Dec  5 12:52:46 stratus kernel: disk 14, o:0, dev:sdo1
Dec  5 12:52:46 stratus kernel: disk 15, o:0, dev:sdp1
Dec  5 12:52:46 stratus kernel: RAID5 conf printout:
Dec  5 12:52:46 stratus kernel: --- rd:16 wd:12
Dec  5 12:52:46 stratus kernel: disk 0, o:1, dev:sda1
Dec  5 12:52:46 stratus kernel: disk 2, o:1, dev:sdc1
Dec  5 12:52:46 stratus kernel: disk 3, o:1, dev:sdd1
Dec  5 12:52:46 stratus kernel: disk 4, o:1, dev:sde1
Dec  5 12:52:46 stratus kernel: disk 5, o:1, dev:sdf1
Dec  5 12:52:46 stratus kernel: disk 6, o:1, dev:sdg1
Dec  5 12:52:46 stratus kernel: disk 7, o:1, dev:sdh1
Dec  5 12:52:46 stratus kernel: disk 8, o:0, dev:sdi1
Dec  5 12:52:46 stratus kernel: disk 9, o:1, dev:sdj1
Dec  5 12:52:46 stratus kernel: disk 10, o:1, dev:sdk1
Dec  5 12:52:46 stratus kernel: disk 11, o:1, dev:sdl1
Dec  5 12:52:46 stratus kernel: disk 12, o:1, dev:sdm1
Dec  5 12:52:46 stratus kernel: disk 13, o:1, dev:sdn1
Dec  5 12:52:46 stratus kernel: disk 14, o:0, dev:sdo1
Dec  5 12:52:46 stratus kernel: disk 15, o:0, dev:sdp1
Dec  5 12:52:46 stratus kernel: RAID5 conf printout:
Dec  5 12:52:46 stratus kernel: --- rd:16 wd:12
Dec  5 12:52:46 stratus kernel: disk 0, o:1, dev:sda1
Dec  5 12:52:46 stratus kernel: disk 2, o:1, dev:sdc1
Dec  5 12:52:46 stratus kernel: disk 3, o:1, dev:sdd1
Dec  5 12:52:46 stratus kernel: disk 4, o:1, dev:sde1
Dec  5 12:52:46 stratus kernel: disk 5, o:1, dev:sdf1
Dec  5 12:52:46 stratus kernel: disk 6, o:1, dev:sdg1
Dec  5 12:52:46 stratus kernel: disk 7, o:1, dev:sdh1
Dec  5 12:52:46 stratus kernel: disk 8, o:0, dev:sdi1
Dec  5 12:52:46 stratus kernel: disk 9, o:1, dev:sdj1
Dec  5 12:52:46 stratus kernel: disk 10, o:1, dev:sdk1
Dec  5 12:52:46 stratus kernel: disk 11, o:1, dev:sdl1
Dec  5 12:52:46 stratus kernel: disk 12, o:1, dev:sdm1
Dec  5 12:52:46 stratus kernel: disk 13, o:1, dev:sdn1
Dec  5 12:52:46 stratus kernel: disk 15, o:0, dev:sdp1
Dec  5 12:52:46 stratus kernel: RAID5 conf printout:
Dec  5 12:52:46 stratus kernel: --- rd:16 wd:12
Dec  5 12:52:46 stratus kernel: disk 0, o:1, dev:sda1
Dec  5 12:52:46 stratus kernel: disk 2, o:1, dev:sdc1
Dec  5 12:52:46 stratus kernel: disk 3, o:1, dev:sdd1
Dec  5 12:52:46 stratus kernel: disk 4, o:1, dev:sde1
Dec  5 12:52:46 stratus kernel: disk 5, o:1, dev:sdf1
Dec  5 12:52:46 stratus kernel: disk 6, o:1, dev:sdg1
Dec  5 12:52:46 stratus kernel: disk 7, o:1, dev:sdh1
Dec  5 12:52:46 stratus kernel: disk 8, o:0, dev:sdi1
Dec  5 12:52:46 stratus kernel: disk 9, o:1, dev:sdj1
Dec  5 12:52:46 stratus kernel: disk 10, o:1, dev:sdk1
Dec  5 12:52:46 stratus kernel: disk 11, o:1, dev:sdl1
Dec  5 12:52:46 stratus kernel: disk 12, o:1, dev:sdm1
Dec  5 12:52:46 stratus kernel: disk 13, o:1, dev:sdn1
Dec  5 12:52:46 stratus kernel: disk 15, o:0, dev:sdp1
Dec  5 12:52:46 stratus kernel: RAID5 conf printout:
Dec  5 12:52:46 stratus kernel: --- rd:16 wd:12
Dec  5 12:52:46 stratus kernel: disk 0, o:1, dev:sda1
Dec  5 12:52:46 stratus kernel: disk 2, o:1, dev:sdc1
Dec  5 12:52:46 stratus kernel: disk 3, o:1, dev:sdd1
Dec  5 12:52:46 stratus kernel: disk 4, o:1, dev:sde1
Dec  5 12:52:46 stratus kernel: disk 5, o:1, dev:sdf1
Dec  5 12:52:46 stratus kernel: disk 6, o:1, dev:sdg1
Dec  5 12:52:46 stratus kernel: disk 7, o:1, dev:sdh1
Dec  5 12:52:46 stratus kernel: disk 8, o:0, dev:sdi1
Dec  5 12:52:46 stratus kernel: disk 9, o:1, dev:sdj1
Dec  5 12:52:46 stratus kernel: disk 10, o:1, dev:sdk1
Dec  5 12:52:46 stratus kernel: disk 11, o:1, dev:sdl1
Dec  5 12:52:46 stratus kernel: disk 12, o:1, dev:sdm1
Dec  5 12:52:46 stratus kernel: disk 13, o:1, dev:sdn1
Dec  5 12:52:46 stratus kernel: RAID5 conf printout:
Dec  5 12:52:46 stratus kernel: --- rd:16 wd:12
Dec  5 12:52:46 stratus kernel: disk 0, o:1, dev:sda1
Dec  5 12:52:46 stratus kernel: disk 2, o:1, dev:sdc1
Dec  5 12:52:46 stratus kernel: disk 3, o:1, dev:sdd1
Dec  5 12:52:46 stratus kernel: disk 4, o:1, dev:sde1
Dec  5 12:52:46 stratus kernel: disk 5, o:1, dev:sdf1
Dec  5 12:52:46 stratus kernel: disk 6, o:1, dev:sdg1
Dec  5 12:52:46 stratus kernel: disk 7, o:1, dev:sdh1
Dec  5 12:52:46 stratus kernel: disk 8, o:0, dev:sdi1
Dec  5 12:52:46 stratus kernel: disk 9, o:1, dev:sdj1
Dec  5 12:52:46 stratus kernel: disk 10, o:1, dev:sdk1
Dec  5 12:52:46 stratus kernel: disk 11, o:1, dev:sdl1
Dec  5 12:52:46 stratus kernel: disk 12, o:1, dev:sdm1
Dec  5 12:52:46 stratus kernel: disk 13, o:1, dev:sdn1
Dec  5 12:52:46 stratus kernel: RAID5 conf printout:
Dec  5 12:52:46 stratus kernel: --- rd:16 wd:12
Dec  5 12:52:46 stratus kernel: disk 0, o:1, dev:sda1
Dec  5 12:52:46 stratus kernel: disk 2, o:1, dev:sdc1
Dec  5 12:52:46 stratus kernel: disk 3, o:1, dev:sdd1
Dec  5 12:52:46 stratus kernel: disk 4, o:1, dev:sde1
Dec  5 12:52:46 stratus kernel: disk 5, o:1, dev:sdf1
Dec  5 12:52:46 stratus kernel: disk 6, o:1, dev:sdg1
Dec  5 12:52:46 stratus kernel: disk 7, o:1, dev:sdh1
Dec  5 12:52:46 stratus kernel: disk 9, o:1, dev:sdj1
Dec  5 12:52:46 stratus kernel: disk 10, o:1, dev:sdk1
Dec  5 12:52:46 stratus kernel: disk 11, o:1, dev:sdl1
Dec  5 12:52:46 stratus kernel: disk 12, o:1, dev:sdm1
Dec  5 12:52:46 stratus kernel: disk 13, o:1, dev:sdn1
Dec  5 12:52:46 stratus kernel: I/O error in filesystem ("md5") meta-data dev md5 block 0x6d2ab37c0       ("xlog_iodone") error 5 buf count 32768
Dec  5 12:52:46 stratus kernel: xfs_force_shutdown(md5,0x2) called from line 917 of file fs/xfs/xfs_log.c.  Return address = 0xffffffffa03b4f26
Dec  5 12:52:46 stratus kernel: Filesystem "md5": Log I/O Error Detected.  Shutting down filesystem: md5
Dec  5 12:52:46 stratus kernel: Please umount the filesystem, and rectify the problem(s)





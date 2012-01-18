From: Jan Ceuleers <jan.ceuleers@gmail.com>
Subject: Preventative replacement of active RAID1 disks
Date: Wed, 18 Jan 2012 18:04:16 +0100
Message-ID: <4F16FB90.5000905@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

List,

I have two 2-partition RAID1 sets, each with a spare. The SMART info for 
both active disks suggests that I should replace them. Both of them. I 
based this on the Seek_Error_Rate in the smartctl -a output (below).

I am looking for advice on how best to do this.

root@zotac:~# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] 
[raid4] [raid10]
md0 : active raid1 sde1[1] sdb2[2](S) sdd1[0]
       521984 blocks [2/2] [UU]

md1 : active raid1 sde2[1] sdd2[0] sdb3[2](S)
       487861824 blocks [2/2] [UU]

unused devices: <none>
root@zotac:~# mdadm -V
mdadm - v2.6.7.1 - 15th October 2008
root@zotac:~# uname -a
Linux zotac 2.6.35-31-generic #63-Ubuntu SMP Mon Nov 28 19:29:10 UTC 
2011 x86_64 GNU/Linux

Here are my constraints:

- I have space in the enclosure for one additional drive (not two).

- Given that both drives are potentially flaky I don't want any period 
of time during which there is a single point of failure.

- I would like the partition which is currently the spare to remain the 
spare, although that does not need to be the case at all times.

- I do not have hot-swap capability, so each time I add or remove a 
drive I need to shut down and reboot afterwards.

I've got two new drives. So I think the steps I should take are as 
follows; comments welcome.

1. Install the first new drive in the cabinet. Create partitions whose 
size is compatible with the current RAID sets.
2. For each of the two RAIDs, mdadm /dev/mdX --add /dev/sdfY the new 
partitions to the respective md sets.
3. Increase the number of active devices from 2 to 3 (or to 4?), thereby 
forcing a resync. I.e. mdadm --grow /dev/mdX --raid-devices=3 or 4. Wait 
for completion.

Here I'm not sure what to do. If I increase the number of active devices 
to 4 then I'm sure that all partitions contain valid data. Is this 
necessary? If I go from two to three active devices, can I tell mdadm 
which of the two available spares to make active?

4. Fail the partitions that are on one of the old disks: mdadm /dev/md0 
--fail /dev/sde1 and mdadm /dev/md1 --fail /dev/sde2

I could now either (scenario A: 3 active devices) uninstall this old 
disk, install the new disk and partition/--add, or (scenario B) if I've 
gone to 4 active devices above I could in fact repeat step 4 above for 
the other old drive so that I can uninstall them both at the same time, 
then install the second new drive. This is described in more detail below.

A.5. Find out what /dev/sde's serial number is by means of hdparm -i. 
Shut down. Uninstall /dev/sde, making doubly sure that it's the correct 
serial number. Install the second new drive.
A.6. Boot, partition the new device as above.
A.7. Add the new partitions to the md sets (mdadm --add).
A.8. Fail the partitions that reside on the disk that I want to be the 
spare, thereby forcing a resync onto the new partitions. I.e. mdadm 
/dev/md0 --fail /dev/sdb2 (assuming persistent device naming across 
reboots) and mdadm /dev/md1 --fail /dev/sdb3 . This fails my constraint 
of wanting to have full RAID redundancy at all times, at least until the 
resync completes. Wait for completion.
A.9. Remove and re-add the failed partitions so that they become spares 
again.

B.5. Fail the partitions that are on the other old disk: mdadm /dev/md0 
--fail /dev/sdf1 and mdadm /dev/md1 --fail /dev/sdf2
B.6. Shut down and uninstall both old drives. No need to bother with 
serial numbers: I can recognise the disks by their type (the other disks 
in the system are from a different manufacturer). Install the other new 
disk.
B.7. Boot, partition the new device as above.
B.8. Add the new partitions to the md sets (mdadm --add). This will 
trigger a resync since the number of active devices is 4. Wait for 
completion.
B.9. Fail the partitions that reside on the disk that I want to be the 
spare.
B.10. Reduce the number of active devices to 2.
B.11. Re-add the spare partitions.

I would be most grateful for any comments or pointers to wikis etc.

Many thanks (smartctl output below).


Jan








root@zotac:~# smartctl -a /dev/sdb
smartctl 5.40 2010-03-16 r3077 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Caviar Green family
Device Model:     WDC WD20EADS-00R6B0
Serial Number:    WD-WCAVY1722132
Firmware Version: 01.00A01
User Capacity:    2,000,398,934,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Wed Jan 18 17:27:03 2012 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)    Offline data collection activity
                     was suspended by an interrupting command from host.
                     Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test 
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:          (41580) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 255) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x303f)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  
Always       -       0
   3 Spin_Up_Time            0x0027   147   142   021    Pre-fail  
Always       -       9641
   4 Start_Stop_Count        0x0032   100   100   000    Old_age   
Always       -       502
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  
Always       -       0
   7 Seek_Error_Rate         0x002e   200   200   000    Old_age   
Always       -       0
   9 Power_On_Hours          0x0032   080   080   000    Old_age   
Always       -       15069
  10 Spin_Retry_Count        0x0032   100   100   000    Old_age   
Always       -       0
  11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age   
Always       -       92
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   
Always       -       42
193 Load_Cycle_Count        0x0032   199   199   000    Old_age   
Always       -       4366
194 Temperature_Celsius     0x0022   118   100   000    Old_age   
Always       -       34
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   
Always       -       114
200 Multi_Zone_Error_Rate   0x0008   200   198   000    Old_age   
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining  
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%     
15025         -

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

root@zotac:~# smartctl -a /dev/sdd
smartctl 5.40 2010-03-16 r3077 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.12 family
Device Model:     ST3500418AS
Serial Number:    9VMK33L9
Firmware Version: CC44
User Capacity:    500,107,862,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Wed Jan 18 17:27:44 2012 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                     was completed without error.
                     Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test 
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:          ( 600) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   1) minutes.
Extended self-test routine
recommended polling time:      (  92) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x103f)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   107   099   006    Pre-fail  
Always       -       14023533
   3 Spin_Up_Time            0x0003   097   097   000    Pre-fail  
Always       -       0
   4 Start_Stop_Count        0x0032   100   100   020    Old_age   
Always       -       50
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  
Always       -       0
   7 Seek_Error_Rate         0x000f   079   060   030    Pre-fail  
Always       -       93484948
   9 Power_On_Hours          0x0032   088   088   000    Old_age   
Always       -       10875
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   020    Old_age   
Always       -       50
183 Runtime_Bad_Block       0x0000   100   100   000    Old_age   
Offline      -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age   
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   
Always       -       0
188 Command_Timeout         0x0032   100   098   000    Old_age   
Always       -       87
189 High_Fly_Writes         0x003a   100   100   000    Old_age   
Always       -       0
190 Airflow_Temperature_Cel 0x0022   068   059   045    Old_age   
Always       -       32 (Lifetime Min/Max 30/37)
194 Temperature_Celsius     0x0022   032   041   000    Old_age   
Always       -       32 (0 13 0 0)
195 Hardware_ECC_Recovered  0x001a   033   025   000    Old_age   
Always       -       14023533
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   
Offline      -       220718369352436
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   
Offline      -       1672825376
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   
Offline      -       3414488901

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

root@zotac:~# smartctl -a /dev/sde
smartctl 5.40 2010-03-16 r3077 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.12 family
Device Model:     ST3500418AS
Serial Number:    9VMM6EY4
Firmware Version: CC38
User Capacity:    500,107,862,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Wed Jan 18 17:28:33 2012 CET
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                     was completed without error.
                     Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test 
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:          ( 600) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   1) minutes.
Extended self-test routine
recommended polling time:      (  85) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x103f)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   118   099   006    Pre-fail  
Always       -       193389141
   3 Spin_Up_Time            0x0003   097   097   000    Pre-fail  
Always       -       0
   4 Start_Stop_Count        0x0032   100   100   020    Old_age   
Always       -       98
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  
Always       -       0
   7 Seek_Error_Rate         0x000f   079   060   030    Pre-fail  
Always       -       97304022
   9 Power_On_Hours          0x0032   088   088   000    Old_age   
Always       -       10875
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   020    Old_age   
Always       -       49
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   
Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age   
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age   
Always       -       0
189 High_Fly_Writes         0x003a   100   100   000    Old_age   
Always       -       0
190 Airflow_Temperature_Cel 0x0022   068   054   045    Old_age   
Always       -       32 (Lifetime Min/Max 31/37)
194 Temperature_Celsius     0x0022   032   046   000    Old_age   
Always       -       32 (0 14 0 0)
195 Hardware_ECC_Recovered  0x001a   034   021   000    Old_age   
Always       -       193389141
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age   
Offline      -       256985073199860
241 Total_LBAs_Written      0x0000   100   253   000    Old_age   
Offline      -       1127059227
242 Total_LBAs_Read         0x0000   100   253   000    Old_age   
Offline      -       3458581684

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



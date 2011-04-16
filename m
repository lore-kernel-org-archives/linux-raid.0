From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Dying drive(s)... tips?
Date: Sat, 16 Apr 2011 16:07:42 +0100
Message-ID: <4DA9B0BE.6060408@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When I posted in a previous thread ("Re: RAID6 data-check took almost 2 
hours, clicking sounds, system unresponsive"), I decided to run long 
SMART tests on all the drives in the array on my workgroup server.

One drive, a Samsung Spinpoint F1 1TB, which had been showing one 
pending sector (SMART attribute 197) and 331 Reported_Uncorrect (SMART 
attribute 187) failed its SMART test at 90% and LBA of first error 
1953520763.

I've subsequently tested reading the disc with dd, and found I have 24 
unreadable sectors at consecutive LBAs 1953520760 to 1953520783.

I wondered how my weekly RAID checks never found these errors. It turns 
out my disc was partitioned by the old fdisk which had an out-by-one 
error and didn't use the last cylinder; the partition making up my main 
array ends at LBA 1953520064. That's really handy, it means the part of 
the disc the array is on is probably OK. Attempting to overwrite the bad 
LBAs fails, so presumably the drive has run out of spare sectors with 
which to reallocate bad ones, even though it's reporting zero reallocated.

Now the real problem: another drive in my array is another Samsung 
Spinpoint F1, as is the only spare drive I have, both have a lot of 
hours on them and both have non-zero Reported_Uncorrect (57 and 78 
respectively), but no reallocated, pending or offline sectors and no 
errors logged. All three drives were from the same batch, though they've 
been run in different machines at different times. The one still in the 
array has already passed a long SMART self-test and is currently being 
surface scanned with dd, but even if it passes, should I trust it or do 
I need to replace it too? Similarly if the spare one passes a long SMART 
self-test and a surface scan with dd, should I trust it?

Given that I have one definitely duff drive in my RAID6 array, how 
should I go about replacing it? dd_rescue onto a fresh drive? Just pull 
and replace?

Once I've replaced at least one drive I can get to RMA'ing the dying one 
and think about replacing others...

Cheers,

John.

General info: Asus P5Q mobo with ICH10R, all six drives connected to 
ICH10R in AHCI mode; CentOS 5.5, kernel 2.6.18-243.el5xen, mdadm 
mdadm-2.6.9-3.el5, though I am happy to do anything with SystemRescueCD 
with more recent kernel, mdadm etc.

smartctl output follows:
Firstly, /dev/sde, the bad Samsung in the array:

smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8 
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     SAMSUNG HD103UJ
Serial Number:    S1PVJ1CQ602163
Firmware Version: 1AA01112
User Capacity:    1,000,204,886,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3b
Local Time is:    Sat Apr 16 15:44:55 2011 BST

==> WARNING: May need -F samsung or -F samsung2 enabled; see manual for 
details.

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                         was never started.
                                         Auto Offline Data Collection: 
Disabled.
Self-test execution status:      ( 121) The previous self-test completed 
having
                                         the read element of the test 
failed.
Total time to complete Offline
data collection:                 (11847) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                         Auto Offline data collection 
on/off support.
                                         Suspend Offline collection upon new
                                         command.
                                         Offline surface scan supported.
                                         Self-test supported.
                                         Conveyance Self-test supported.
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                         power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 198) minutes.
Conveyance self-test routine
recommended polling time:        (  21) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   099   098   051    Pre-fail 
Always       -       635
   3 Spin_Up_Time            0x0007   069   069   011    Pre-fail 
Always       -       10070
   4 Start_Stop_Count        0x0032   100   100   000    Old_age 
Always       -       75
   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
Always       -       0
   7 Seek_Error_Rate         0x000f   100   100   051    Pre-fail 
Always       -       0
   8 Seek_Time_Performance   0x0025   100   100   015    Pre-fail 
Offline      -       9881
   9 Power_On_Hours          0x0032   098   098   000    Old_age 
Always       -       12285
  10 Spin_Retry_Count        0x0033   100   100   051    Pre-fail 
Always       -       0
  11 Calibration_Retry_Count 0x0012   100   100   000    Old_age 
Always       -       3
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age 
Always       -       67
  13 Read_Soft_Error_Rate    0x000e   099   099   000    Old_age 
Always       -       383
183 Unknown_Attribute       0x0032   100   100   000    Old_age   Always 
       -       0
184 Unknown_Attribute       0x0033   100   100   099    Pre-fail  Always 
       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always 
       -       709
188 Unknown_Attribute       0x0032   100   100   000    Old_age   Always 
       -       0
190 Airflow_Temperature_Cel 0x0022   074   061   000    Old_age   Always 
       -       26 (Lifetime Min/Max 18/28)
194 Temperature_Celsius     0x0022   074   060   000    Old_age   Always 
       -       26 (Lifetime Min/Max 18/29)
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always 
       -       462505759
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always 
       -       0
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always 
       -       4
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age 
Offline      -       1
199 UDMA_CRC_Error_Count    0x003e   100   100   000    Old_age   Always 
       -       0
200 Multi_Zone_Error_Rate   0x000a   100   100   000    Old_age   Always 
       -       0
201 Soft_Read_Error_Rate    0x000a   095   094   000    Old_age   Always 
       -       475

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 0
Warning: ATA Specification requires self-test log structure revision 
number = 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed: read failure       90%     12245 
      1953520763
# 2  Extended offline    Aborted by host               00%      6704 
      -
# 3  Extended offline    Aborted by host               00%      6691 
      -
# 4  Short offline       Aborted by host               00%      6688 
      -
# 5  Extended offline    Aborted by host               90%      6515 
      -
# 6  Short offline       Aborted by host               20%      6515 
      -
# 7  Short offline       Aborted by host               20%       931 
      -

SMART Selective Self-Test Log Data Structure Revision Number (0) should be 1
SMART Selective self-test log data structure revision number 0
Warning: ATA Specification requires selective self-test log data 
structure revision number = 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

-------------------------------------------------------------------------
Now the "good" Samsung, /dev/sdb:

smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8 
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     SAMSUNG HD103UJ
Serial Number:    S1PVJ1CQ602162
Firmware Version: 1AA01112
User Capacity:    1,000,204,886,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3b
Local Time is:    Sat Apr 16 15:45:54 2011 BST

==> WARNING: May need -F samsung or -F samsung2 enabled; see manual for 
details.

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                         was never started.
                                         Auto Offline Data Collection: 
Disabled.
Self-test execution status:      (   0) The previous self-test routine 
completed
                                         without error or no self-test 
has ever
                                         been run.
Total time to complete Offline
data collection:                 (12159) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                         Auto Offline data collection 
on/off support.
                                         Suspend Offline collection upon new
                                         command.
                                         Offline surface scan supported.
                                         Self-test supported.
                                         Conveyance Self-test supported.
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                         power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 203) minutes.
Conveyance self-test routine
recommended polling time:        (  22) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   100   099   051    Pre-fail 
Always       -       10
   3 Spin_Up_Time            0x0007   067   067   011    Pre-fail 
Always       -       10550
   4 Start_Stop_Count        0x0032   100   100   000    Old_age 
Always       -       66
   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
Always       -       0
   7 Seek_Error_Rate         0x000f   100   100   051    Pre-fail 
Always       -       0
   8 Seek_Time_Performance   0x0025   100   100   015    Pre-fail 
Offline      -       9901
   9 Power_On_Hours          0x0032   097   097   000    Old_age 
Always       -       13978
  10 Spin_Retry_Count        0x0033   100   100   051    Pre-fail 
Always       -       0
  11 Calibration_Retry_Count 0x0012   100   100   000    Old_age 
Always       -       3
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age 
Always       -       66
  13 Read_Soft_Error_Rate    0x000e   100   099   000    Old_age 
Always       -       9
183 Unknown_Attribute       0x0032   100   100   000    Old_age   Always 
       -       0
184 Unknown_Attribute       0x0033   100   100   099    Pre-fail  Always 
       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always 
       -       57
188 Unknown_Attribute       0x0032   100   100   000    Old_age   Always 
       -       0
190 Airflow_Temperature_Cel 0x0022   071   069   000    Old_age   Always 
       -       29 (Lifetime Min/Max 16/31)
194 Temperature_Celsius     0x0022   069   068   000    Old_age   Always 
       -       31 (Lifetime Min/Max 16/33)
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always 
       -       559643952
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always 
       -       0
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always 
       -       0
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age 
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   100   100   000    Old_age   Always 
       -       0
200 Multi_Zone_Error_Rate   0x000a   100   100   000    Old_age   Always 
       -       0
201 Soft_Read_Error_Rate    0x000a   100   100   000    Old_age   Always 
       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 0
Warning: ATA Specification requires self-test log structure revision 
number = 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     13942 
      -
# 2  Extended offline    Aborted by host               00%      6517 
      -
# 3  Short offline       Aborted by host               00%      6514 
      -

SMART Selective Self-Test Log Data Structure Revision Number (0) should be 1
SMART Selective self-test log data structure revision number 0
Warning: ATA Specification requires selective self-test log data 
structure revision number = 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.


-------------------------------------------------------------------------
And the spare Samsung, /dev/sdf:

smartctl version 5.38 [x86_64-redhat-linux-gnu] Copyright (C) 2002-8 
Bruce Allen
Home page is http://smartmontools.sourceforge.net/

=== START OF INFORMATION SECTION ===
Device Model:     SAMSUNG HD103UJ
Serial Number:    S1PVJ1CQ602164
Firmware Version: 1AA01112
User Capacity:    1,000,204,886,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3b
Local Time is:    Sat Apr 16 15:46:41 2011 BST

==> WARNING: May need -F samsung or -F samsung2 enabled; see manual for 
details.

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x00) Offline data collection activity
                                         was never started.
                                         Auto Offline Data Collection: 
Disabled.
Self-test execution status:      ( 244) Self-test routine in progress...
                                         40% of test remaining.
Total time to complete Offline
data collection:                 (11854) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                         Auto Offline data collection 
on/off support.
                                         Suspend Offline collection upon new
                                         command.
                                         Offline surface scan supported.
                                         Self-test supported.
                                         Conveyance Self-test supported.
                                         Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before entering
                                         power-saving mode.
                                         Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                         General Purpose Logging supported.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 198) minutes.
Conveyance self-test routine
recommended polling time:        (  21) minutes.
SCT capabilities:              (0x003f) SCT Status supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE 
UPDATED  WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   100   098   051    Pre-fail 
Always       -       0
   3 Spin_Up_Time            0x0007   076   076   011    Pre-fail 
Always       -       8040
   4 Start_Stop_Count        0x0032   100   100   000    Old_age 
Always       -       49
   5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail 
Always       -       0
   7 Seek_Error_Rate         0x000f   100   100   051    Pre-fail 
Always       -       0
   8 Seek_Time_Performance   0x0025   100   100   015    Pre-fail 
Offline      -       10888
   9 Power_On_Hours          0x0032   098   098   000    Old_age 
Always       -       9967
  10 Spin_Retry_Count        0x0033   100   100   051    Pre-fail 
Always       -       0
  11 Calibration_Retry_Count 0x0012   100   100   000    Old_age 
Always       -       2
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age 
Always       -       49
  13 Read_Soft_Error_Rate    0x000e   100   098   000    Old_age 
Always       -       0
183 Unknown_Attribute       0x0032   100   100   000    Old_age   Always 
       -       0
184 Unknown_Attribute       0x0033   100   100   099    Pre-fail  Always 
       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always 
       -       78
188 Unknown_Attribute       0x0032   100   100   000    Old_age   Always 
       -       0
190 Airflow_Temperature_Cel 0x0022   071   059   000    Old_age   Always 
       -       29 (Lifetime Min/Max 15/29)
194 Temperature_Celsius     0x0022   065   059   000    Old_age   Always 
       -       35 (Lifetime Min/Max 15/35)
195 Hardware_ECC_Recovered  0x001a   100   100   000    Old_age   Always 
       -       1434
196 Reallocated_Event_Count 0x0032   100   100   000    Old_age   Always 
       -       0
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always 
       -       0
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age 
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   100   100   000    Old_age   Always 
       -       0
200 Multi_Zone_Error_Rate   0x000a   100   100   000    Old_age   Always 
       -       0
201 Soft_Read_Error_Rate    0x000a   100   100   000    Old_age   Always 
       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 0
Warning: ATA Specification requires self-test log structure revision 
number = 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Self-test routine in progress 40%      9967 
      -
# 2  Extended offline    Aborted by host               00%      6702 
      -
# 3  Extended offline    Aborted by host               00%      6689 
      -
# 4  Short offline       Aborted by host               00%      6686 
      -
# 5  Extended offline    Aborted by host               90%      6513 
      -
# 6  Short offline       Aborted by host               20%      6513 
      -

SMART Selective Self-Test Log Data Structure Revision Number (0) should be 1
SMART Selective self-test log data structure revision number 0
Warning: ATA Specification requires selective self-test log data 
structure revision number = 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.


-------------------------------------------------------------------------
Log from attempting to overwrite bad sectors on /dev/sde:

Apr 16 14:59:34 beast kernel: ata7.00: exception Emask 0x0 SAct 0x1 SErr 
0x0 action 0x0
Apr 16 14:59:34 beast kernel: ata7.00: irq_stat 0x40000008
Apr 16 14:59:34 beast kernel: ata7.00: cmd 
60/08:00:78:5c:70/00:00:74:00:00/40 tag 0 ncq 4096 in
Apr 16 14:59:34 beast kernel:          res 
41/40:00:7b:5c:70/00:00:74:00:00/40 Emask 0x409 (medi
a error) <F>
Apr 16 14:59:34 beast kernel: ata7.00: status: { DRDY ERR }
Apr 16 14:59:34 beast kernel: ata7.00: error: { UNC }
Apr 16 14:59:34 beast kernel: ata7.00: configured for UDMA/133
Apr 16 14:59:34 beast kernel: ata7: EH complete
Apr 16 14:59:36 beast kernel: ata7.00: exception Emask 0x0 SAct 0x1 SErr 
0x0 action 0x0
Apr 16 14:59:36 beast kernel: ata7.00: irq_stat 0x40000008
Apr 16 14:59:36 beast kernel: ata7.00: cmd 
60/08:00:78:5c:70/00:00:74:00:00/40 tag 0 ncq 4096 in
Apr 16 14:59:36 beast kernel:          res 
41/40:00:7b:5c:70/00:00:74:00:00/40 Emask 0x409 (media error) <F>
Apr 16 14:59:36 beast kernel: ata7.00: status: { DRDY ERR }
Apr 16 14:59:43 beast kernel: ata7.00: error: { UNC }
Apr 16 14:59:43 beast kernel: ata7.00: configured for UDMA/133
Apr 16 14:59:43 beast kernel: ata7: EH complete
Apr 16 14:59:44 beast kernel: ata7.00: exception Emask 0x0 SAct 0x1 SErr 
0x0 action 0x0
Apr 16 14:59:44 beast kernel: ata7.00: irq_stat 0x40000008
Apr 16 14:59:44 beast kernel: ata7.00: cmd 
60/08:00:78:5c:70/00:00:74:00:00/40 tag 0 ncq 4096 in
Apr 16 14:59:44 beast kernel:          res 
41/40:00:7b:5c:70/00:00:74:00:00/40 Emask 0x409 (media error) <F>
Apr 16 14:59:44 beast kernel: ata7.00: status: { DRDY ERR }
Apr 16 14:59:44 beast kernel: ata7.00: error: { UNC }
Apr 16 14:59:44 beast kernel: ata7.00: configured for UDMA/133
Apr 16 14:59:44 beast kernel: ata7: EH complete
Apr 16 14:59:44 beast kernel: ata7.00: exception Emask 0x0 SAct 0x1 SErr 
0x0 action 0x0
Apr 16 14:59:44 beast kernel: ata7.00: irq_stat 0x40000008
Apr 16 14:59:44 beast kernel: ata7.00: cmd 
60/08:00:78:5c:70/00:00:74:00:00/40 tag 0 ncq 4096 in
Apr 16 14:59:44 beast kernel:          res 
41/40:00:7b:5c:70/00:00:74:00:00/40 Emask 0x409 (media error) <F>
Apr 16 14:59:44 beast kernel: ata7.00: status: { DRDY ERR }
Apr 16 14:59:44 beast kernel: ata7.00: error: { UNC }
Apr 16 14:59:44 beast kernel: ata7.00: configured for UDMA/133
Apr 16 14:59:44 beast kernel: ata7: EH complete
Apr 16 14:59:44 beast kernel: ata7.00: exception Emask 0x0 SAct 0x1 SErr 
0x0 action 0x0
Apr 16 14:59:44 beast kernel: ata7.00: irq_stat 0x40000008
Apr 16 14:59:44 beast kernel: ata7.00: cmd 
60/08:00:78:5c:70/00:00:74:00:00/40 tag 0 ncq 4096 in
Apr 16 14:59:44 beast kernel:          res 
41/40:00:7b:5c:70/00:00:74:00:00/40 Emask 0x409 (media error) <F>
Apr 16 14:59:44 beast kernel: ata7.00: status: { DRDY ERR }
Apr 16 14:59:44 beast kernel: ata7.00: error: { UNC }
Apr 16 14:59:44 beast kernel: ata7.00: configured for UDMA/133
Apr 16 14:59:44 beast kernel: ata7: EH complete
Apr 16 14:59:44 beast kernel: ata7.00: exception Emask 0x0 SAct 0x1 SErr 
0x0 action 0x0
Apr 16 14:59:44 beast kernel: ata7.00: irq_stat 0x40000008
Apr 16 14:59:44 beast kernel: ata7.00: cmd 
60/08:00:78:5c:70/00:00:74:00:00/40 tag 0 ncq 4096 in
Apr 16 14:59:44 beast kernel:          res 
41/40:00:7b:5c:70/00:00:74:00:00/40 Emask 0x409 (media error) <F>
Apr 16 14:59:44 beast kernel: ata7.00: status: { DRDY ERR }
Apr 16 14:59:44 beast kernel: ata7.00: error: { UNC }
Apr 16 14:59:44 beast kernel: ata7.00: configured for UDMA/133
Apr 16 14:59:44 beast kernel: sd 6:0:0:0: SCSI error: return code = 
0x08000002
Apr 16 14:59:44 beast kernel: sde: Current [descriptor]: sense key: 
Medium Error
Apr 16 14:59:44 beast kernel:     Add. Sense: Unrecovered read error - 
auto reallocate failed
Apr 16 14:59:44 beast kernel:
Apr 16 14:59:44 beast kernel: Descriptor sense data with sense 
descriptors (in hex):
Apr 16 14:59:44 beast kernel:         72 03 11 04 00 00 00 0c 00 0a 80 
00 00 00 00 00
Apr 16 14:59:44 beast kernel:         74 70 5c 7b
Apr 16 14:59:44 beast kernel: end_request: I/O error, dev sde, sector 
1953520763
Apr 16 14:59:44 beast kernel: ata7: EH complete
Apr 16 14:59:44 beast kernel: SCSI device sde: 1953525168 512-byte hdwr 
sectors (1000205 MB)
Apr 16 14:59:44 beast kernel: sde: Write Protect is off
Apr 16 14:59:44 beast kernel: SCSI device sde: drive cache: write back
Apr 16 14:59:44 beast kernel: SCSI device sde: 1953525168 512-byte hdwr 
sectors (1000205 MB)
Apr 16 14:59:44 beast kernel: sde: Write Protect is off
Apr 16 14:59:44 beast kernel: SCSI device sde: drive cache: write back

-------------------------------------------------------------------------
And just for completeness, array status from mdadm -D:

/dev/md1:
         Version : 0.90
   Creation Time : Mon Jul 28 15:49:09 2008
      Raid Level : raid6
      Array Size : 2929966080 (2794.23 GiB 3000.29 GB)
   Used Dev Size : 976655360 (931.41 GiB 1000.10 GB)
    Raid Devices : 5
   Total Devices : 5
Preferred Minor : 1
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Sat Apr 16 16:05:42 2011
           State : active
  Active Devices : 5
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 0

      Chunk Size : 512K

            UUID : d8c57a89:166ee722:23adec48:1574b5fc
          Events : 0.1332600

     Number   Major   Minor   RaidDevice State
        0       8        2        0      active sync   /dev/sda2
        1       8       18        1      active sync   /dev/sdb2
        2       8       34        2      active sync   /dev/sdc2
        3       8       50        3      active sync   /dev/sdd2
        4       8       66        4      active sync   /dev/sde2

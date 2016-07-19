From: Amit Biswas <abiswas@nyu.edu>
Subject: Re: Recovering RAID Volumes from 6 Disks
Date: Tue, 19 Jul 2016 18:34:12 -0400
Message-ID: <CADsVfeyz=KiAqSBe11jjBT-yOWpZp_eyP_BctkjvWC5UPNLXuQ@mail.gmail.com>
References: <CADsVfeyiiAgxeeATrX9UqmWb+Hr3MCf2_eMPjL8hbD7Gpj5Ksg@mail.gmail.com>
 <578E8616.4000908@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <578E8616.4000908@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here are the smart reports for all six drives. drive sda was not co-operating...

/dev/sda

smartctl 6.2 2013-07-26 r3841 [x86_64-linux-4.2.0-27-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Vendor:               /2:0:0:0
Product:
User Capacity:        600,332,565,813,390,450 bytes [600 PB]
Logical block size:   774843950 bytes
>> Terminate command early due to bad response to IEC mode page

=== START OF READ SMART DATA SECTION ===

Error Counter logging not supported

Device does not support Self Test logging

/dev/sdb

smartctl 6.2 2013-07-26 r3841 [x86_64-linux-4.2.0-27-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST1000DM003-9YN162
Serial Number:    Z1D05TKG
LU WWN Device Id: 5 000c50 03ec23134
Firmware Version: CC9C
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Thu Jul  7 18:58:22 2016 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                    was completed without error.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (  575) seconds.
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
recommended polling time:      ( 116) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x3081)    SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   119   099   006    Pre-fail
Always       -       205143226
  3 Spin_Up_Time            0x0003   097   097   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       152
  5 Reallocated_Sector_Ct   0x0033   095   095   036    Pre-fail
Always       -       7808
  7 Seek_Error_Rate         0x000f   084   060   030    Pre-fail
Always       -       4573741014
  9 Power_On_Hours          0x0032   067   067   000    Old_age
Always       -       29429
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       151
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age
Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age
Always       -       4 5 5
189 High_Fly_Writes         0x003a   100   100   000    Old_age
Always       -       0
190 Airflow_Temperature_Cel 0x0022   069   035   045    Old_age
Always   In_the_past 31 (0 101 31 30 0)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       149
193 Load_Cycle_Count        0x0032   087   087   000    Old_age
Always       -       26214
194 Temperature_Celsius     0x0022   031   065   000    Old_age
Always       -       31 (0 14 0 0 0)
197 Current_Pending_Sector  0x0012   080   080   000    Old_age
Always       -       3359
198 Offline_Uncorrectable   0x0010   080   080   000    Old_age
Offline      -       3359
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       15576h+39m+12.722s
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       42665052319107
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       234087115868324

SMART Error Log Version: 1
ATA Error Count: 342 (device log contains only the most recent five errors)
    CR = Command Register [HEX]
    FR = Features Register [HEX]
    SC = Sector Count Register [HEX]
    SN = Sector Number Register [HEX]
    CL = Cylinder Low Register [HEX]
    CH = Cylinder High Register [HEX]
    DH = Device/Head Register [HEX]
    DC = Device Command Register [HEX]
    ER = Error register [HEX]
    ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 342 occurred at disk power-on lifetime: 29429 hours (1226 days + 5 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 09 f8 0e 00  Error: UNC at LBA = 0x000ef809 = 981001

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 08 f8 0e 40 00      02:57:13.845  READ FPDMA QUEUED
  60 00 08 00 f8 0e 40 00      02:57:13.845  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00      02:57:13.844  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00      02:57:13.844  READ FPDMA QUEUED
  b0 da 00 00 4f c2 00 00      02:49:00.670  SMART RETURN STATUS

Error 341 occurred at disk power-on lifetime: 29429 hours (1226 days + 5 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 09 f8 0e 00  Error: UNC at LBA = 0x000ef809 = 981001

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 08 f8 0e 40 00      02:57:13.845  READ FPDMA QUEUED
  60 00 08 00 f8 0e 40 00      02:57:13.845  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00      02:57:13.844  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00      02:57:13.844  READ FPDMA QUEUED
  b0 da 00 00 4f c2 00 00      02:49:00.670  SMART RETURN STATUS

Error 340 occurred at disk power-on lifetime: 29428 hours (1226 days + 4 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 09 f8 0e 00  Error: UNC at LBA = 0x000ef809 = 981001

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 08 f8 0e 40 00      01:36:54.470  READ FPDMA QUEUED
  60 00 08 00 f8 0e 40 00      01:36:54.470  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00      01:36:54.470  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00      01:36:54.469  READ FPDMA QUEUED
  60 00 08 08 10 00 40 00      01:36:12.430  READ FPDMA QUEUED

Error 339 occurred at disk power-on lifetime: 29428 hours (1226 days + 4 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 09 f8 0e 00  Error: UNC at LBA = 0x000ef809 = 981001

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 08 f8 0e 40 00      01:36:54.470  READ FPDMA QUEUED
  60 00 08 00 f8 0e 40 00      01:36:54.470  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00      01:36:54.470  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00      01:36:54.469  READ FPDMA QUEUED
  60 00 08 08 10 00 40 00      01:36:12.430  READ FPDMA QUEUED

Error 338 occurred at disk power-on lifetime: 29427 hours (1226 days + 3 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 09 f8 0e 00  Error: UNC at LBA = 0x000ef809 = 981001

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 08 f8 0e 40 00      01:28:40.063  READ FPDMA QUEUED
  60 00 08 08 00 00 40 00      01:28:37.685  READ FPDMA QUEUED
  60 00 08 08 08 00 40 00      01:28:37.685  READ FPDMA QUEUED
  60 00 08 08 10 00 40 00      01:28:37.684  READ FPDMA QUEUED
  ef 10 02 00 00 00 a0 00      01:28:37.684  SET FEATURES [Enable SATA feature]

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%         1         -

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


/dev/sdc

smartctl 6.2 2013-07-26 r3841 [x86_64-linux-4.2.0-27-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Constellation ES (SATA 6Gb/s)
Device Model:     ST1000NM0011
Serial Number:    Z1N4DQG8
LU WWN Device Id: 5 000c50 064169d91
Firmware Version: SN03
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7202 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Thu Jul  7 18:58:31 2016 UTC
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
data collection:         (  600) seconds.
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
recommended polling time:      ( 149) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x10bd)    SCT Status supported.
                    SCT Error Recovery Control supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   069   064   044    Pre-fail
Always       -       10352612
  3 Spin_Up_Time            0x0003   096   096   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       21
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   081   060   030    Pre-fail
Always       -       129759408
  9 Power_On_Hours          0x0032   080   080   000    Old_age
Always       -       17545
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       21
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   099   000    Old_age
Always       -       3
189 High_Fly_Writes         0x003a   100   100   000    Old_age
Always       -       0
190 Airflow_Temperature_Cel 0x0022   069   062   045    Old_age
Always       -       31 (Min/Max 30/31)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       16
193 Load_Cycle_Count        0x0032   096   096   000    Old_age
Always       -       9383
194 Temperature_Celsius     0x0022   031   040   000    Old_age
Always       -       31 (0 14 0 0 0)
195 Hardware_ECC_Recovered  0x001a   105   100   000    Old_age
Always       -       10352612
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   199   000    Old_age
Always       -       66

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


/dev/sdc

smartctl 6.2 2013-07-26 r3841 [x86_64-linux-4.2.0-27-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Constellation ES (SATA 6Gb/s)
Device Model:     ST1000NM0011
Serial Number:    Z1N4DQG8
LU WWN Device Id: 5 000c50 064169d91
Firmware Version: SN03
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7202 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Thu Jul  7 18:58:31 2016 UTC
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
data collection:         (  600) seconds.
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
recommended polling time:      ( 149) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x10bd)    SCT Status supported.
                    SCT Error Recovery Control supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   069   064   044    Pre-fail
Always       -       10352612
  3 Spin_Up_Time            0x0003   096   096   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       21
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   081   060   030    Pre-fail
Always       -       129759408
  9 Power_On_Hours          0x0032   080   080   000    Old_age
Always       -       17545
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       21
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   099   000    Old_age
Always       -       3
189 High_Fly_Writes         0x003a   100   100   000    Old_age
Always       -       0
190 Airflow_Temperature_Cel 0x0022   069   062   045    Old_age
Always       -       31 (Min/Max 30/31)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       16
193 Load_Cycle_Count        0x0032   096   096   000    Old_age
Always       -       9383
194 Temperature_Celsius     0x0022   031   040   000    Old_age
Always       -       31 (0 14 0 0 0)
195 Hardware_ECC_Recovered  0x001a   105   100   000    Old_age
Always       -       10352612
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   199   000    Old_age
Always       -       66

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


/dev/sdd

smartctl 6.2 2013-07-26 r3841 [x86_64-linux-4.2.0-27-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Constellation ES (SATA 6Gb/s)
Device Model:     ST1000NM0011
Serial Number:    Z1N4DX3G
LU WWN Device Id: 5 000c50 06416d153
Firmware Version: SN03
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7202 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Thu Jul  7 18:58:38 2016 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                    was completed without error.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (  609) seconds.
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
recommended polling time:      ( 153) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x10bd)    SCT Status supported.
                    SCT Error Recovery Control supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   078   063   044    Pre-fail
Always       -       59676424
  3 Spin_Up_Time            0x0003   096   094   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       64
  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   083   060   030    Pre-fail
Always       -       202527202
  9 Power_On_Hours          0x0032   074   074   000    Old_age
Always       -       23267
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       60
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age
Always       -       0
189 High_Fly_Writes         0x003a   100   100   000    Old_age
Always       -       0
190 Airflow_Temperature_Cel 0x0022   067   032   045    Old_age
Always   In_the_past 33 (0 111 33 31 0)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       51
193 Load_Cycle_Count        0x0032   095   095   000    Old_age
Always       -       10161
194 Temperature_Celsius     0x0022   033   068   000    Old_age
Always       -       33 (0 16 0 0 0)
195 Hardware_ECC_Recovered  0x001a   114   099   000    Old_age
Always       -       59676424
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00%       478         -
# 2  Extended offline    Aborted by host               80%       462         -

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


/dev/sde

smartctl 6.2 2013-07-26 r3841 [x86_64-linux-4.2.0-27-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST1000DM003-1CH162
Serial Number:    S1D8EGH8
LU WWN Device Id: 5 000c50 05c135595
Firmware Version: CC46
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Thu Jul  7 18:58:46 2016 UTC

==> WARNING: A firmware update for this drive is available,
see the following Seagate web pages:
http://knowledge.seagate.com/articles/en_US/FAQ/207931en
http://knowledge.seagate.com/articles/en_US/FAQ/223651en

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                    was completed without error.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (  575) seconds.
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
recommended polling time:      ( 115) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x3085)    SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   119   099   006    Pre-fail
Always       -       203719328
  3 Spin_Up_Time            0x0003   098   097   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       122
  5 Reallocated_Sector_Ct   0x0033   100   100   010    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x000f   081   060   030    Pre-fail
Always       -       156895542
  9 Power_On_Hours          0x0032   068   068   000    Old_age
Always       -       28487
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       121
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age
Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age
Always       -       0 0 0
189 High_Fly_Writes         0x003a   100   100   000    Old_age
Always       -       0
190 Airflow_Temperature_Cel 0x0022   071   033   045    Old_age
Always   In_the_past 29 (0 200 29 27 0)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       119
193 Load_Cycle_Count        0x0032   095   095   000    Old_age
Always       -       11202
194 Temperature_Celsius     0x0022   029   067   000    Old_age
Always       -       29 (0 11 0 0 0)
197 Current_Pending_Sector  0x0012   100   100   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       27611h+29m+28.145s
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       10984310419
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       42457231761

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


/dev/sdf

smartctl 6.2 2013-07-26 r3841 [x86_64-linux-4.2.0-27-generic] (local build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda 7200.14 (AF)
Device Model:     ST1000DM003-9YN162
Serial Number:    Z1D04N3L
LU WWN Device Id: 5 000c50 03633f4d6
Firmware Version: CC9C
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Thu Jul  7 18:58:53 2016 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                    was completed without error.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (  584) seconds.
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
recommended polling time:      ( 115) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x3081)    SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x000f   089   087   006    Pre-fail
Always       -       107847548
  3 Spin_Up_Time            0x0003   098   097   000    Pre-fail
Always       -       0
  4 Start_Stop_Count        0x0032   100   100   020    Old_age
Always       -       148
  5 Reallocated_Sector_Ct   0x0033   072   051   036    Pre-fail
Always       -       37616
  7 Seek_Error_Rate         0x000f   084   060   030    Pre-fail
Always       -       235958313
  9 Power_On_Hours          0x0032   066   066   000    Old_age
Always       -       30474
 10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   020    Old_age
Always       -       147
183 Runtime_Bad_Block       0x0032   098   098   000    Old_age
Always       -       2
184 End-to-End_Error        0x0032   100   100   099    Old_age
Always       -       0
187 Reported_Uncorrect      0x0032   001   001   000    Old_age
Always       -       587
188 Command_Timeout         0x0032   100   098   000    Old_age
Always       -       13 13 13
189 High_Fly_Writes         0x003a   100   100   000    Old_age
Always       -       0
190 Airflow_Temperature_Cel 0x0022   069   034   045    Old_age
Always   In_the_past 31 (0 102 31 29 0)
191 G-Sense_Error_Rate      0x0032   100   100   000    Old_age
Always       -       0
192 Power-Off_Retract_Count 0x0032   100   100   000    Old_age
Always       -       145
193 Load_Cycle_Count        0x0032   088   088   000    Old_age
Always       -       24193
194 Temperature_Celsius     0x0022   031   066   000    Old_age
Always       -       31 (0 13 0 0 0)
197 Current_Pending_Sector  0x0012   001   001   000    Old_age
Always       -       33664
198 Offline_Uncorrectable   0x0010   001   001   000    Old_age
Offline      -       33664
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age
Offline      -       29478h+42m+45.934s
241 Total_LBAs_Written      0x0000   100   253   000    Old_age
Offline      -       35126025198006
242 Total_LBAs_Read         0x0000   100   253   000    Old_age
Offline      -       233821549666301

SMART Error Log Version: 1
ATA Error Count: 561 (device log contains only the most recent five errors)
    CR = Command Register [HEX]
    FR = Features Register [HEX]
    SC = Sector Count Register [HEX]
    SN = Sector Number Register [HEX]
    CL = Cylinder Low Register [HEX]
    CH = Cylinder High Register [HEX]
    DH = Device/Head Register [HEX]
    DC = Device Command Register [HEX]
    ER = Error register [HEX]
    ST = Status register [HEX]
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 561 occurred at disk power-on lifetime: 28893 hours (1203 days + 21 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 00 ff ff ff 4f 00  12d+01:32:01.326  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  12d+01:32:01.325  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  12d+01:32:01.325  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  12d+01:32:01.325  READ FPDMA QUEUED
  60 00 00 ff ff ff 4f 00  12d+01:32:01.325  READ FPDMA QUEUED

Error 560 occurred at disk power-on lifetime: 28893 hours (1203 days + 21 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  12d+01:31:16.334  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00  12d+01:31:15.803  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00  12d+01:31:13.683  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00  12d+01:31:13.683  READ FPDMA QUEUED
  61 00 08 ff ff ff 4f 00  12d+01:31:13.683  WRITE FPDMA QUEUED

Error 559 occurred at disk power-on lifetime: 28893 hours (1203 days + 21 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  12d+01:31:10.402  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00  12d+01:31:07.982  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00  12d+01:31:07.982  READ FPDMA QUEUED
  61 00 08 ff ff ff 4f 00  12d+01:31:07.982  WRITE FPDMA QUEUED
  ef 10 02 00 00 00 a0 00  12d+01:31:07.922  SET FEATURES [Enable SATA feature]

Error 558 occurred at disk power-on lifetime: 28893 hours (1203 days + 21 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  12d+01:31:04.755  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00  12d+01:31:04.755  READ FPDMA QUEUED
  61 00 08 ff ff ff 4f 00  12d+01:31:04.755  WRITE FPDMA QUEUED
  ef 10 02 00 00 00 a0 00  12d+01:31:04.694  SET FEATURES [Enable SATA feature]
  27 00 00 00 00 00 e0 00  12d+01:31:04.694  READ NATIVE MAX ADDRESS
EXT [OBS-ACS-3]

Error 557 occurred at disk power-on lifetime: 28893 hours (1203 days + 21 hours)
  When the command that caused the error occurred, the device was
active or idle.

  After command completion occurred, registers were:
  ER ST SC SN CL CH DH
  -- -- -- -- -- -- --
  40 51 00 ff ff ff 0f  Error: UNC at LBA = 0x0fffffff = 268435455

  Commands leading to the command that caused the error were:
  CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
  -- -- -- -- -- -- -- --  ----------------  --------------------
  60 00 08 ff ff ff 4f 00  12d+01:31:01.457  READ FPDMA QUEUED
  60 00 08 ff ff ff 4f 00  12d+01:31:01.457  READ FPDMA QUEUED
  61 00 08 ff ff ff 4f 00  12d+01:31:01.457  WRITE FPDMA QUEUED
  ef 10 02 00 00 00 a0 00  12d+01:31:01.444  SET FEATURES [Enable SATA feature]
  27 00 00 00 00 00 e0 00  12d+01:31:01.444  READ NATIVE MAX ADDRESS
EXT [OBS-ACS-3]

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%         1         -

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

Amit Biswas
Lab Manager
CSE Department
NYU Tandon School Of Engineering
Office: 1-646-997-3023


On Tue, Jul 19, 2016 at 3:57 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> Another bit of useful information - can you post the output of smartctl
> on all your drives?
>
> smartctl -x /dev/sd[a,b,c...]
>
> Seeing as the drives are Seagate 1TB drives, I suspect they do support
> ERC and timeout mismatch is not the problem, but this will tell us.
>
> I'll let others chime in with recovery info, but this information will
> definitely help them.
>
> Cheers,
> Wol
>
> On 19/07/16 17:29, Amit Biswas wrote:
>> Greetings!
>>
>> Backup server was acting up and the issue was the drives (all of them)
>> :( Could use some guidance or verdict.
>>
>> It has a total of 6 drives: sda,b,c,d,e,f. From the superblock info
>> (attached), there is a raid 1, and a raid 10 volume. Problem is all
>> the disks are part of both raid volumes (according to superblock).
>>
>> I am currently booted into an ubuntu live disk shell.
>>
>

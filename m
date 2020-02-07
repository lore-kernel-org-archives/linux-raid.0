From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Question
Date: Fri, 7 Feb 2020 09:49:56 -0600
Message-ID: <CAPpdf5-FJ0cP36pOLm40ESBOws8x5R6XbUOssFFCsY6xtb4_xw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Greetings

Running a Raid-10 array made up of 4 - 1 TB drives on a debian testing
(11) system.
mdadm - v4.1 - 2018-10-01 is the version being used.

Some weirdness is happening - - - vis a vis - - - I have one directory
(not small) that has disappeared. I last accessed said directory
(still have the pdf open which is how I could get this information)
'Last accessed 2020-01-19 6:32 A.M.'  as indicated in the 'Properties'
section of the file in question.

Has been suggested to me that I make the array read only until this is resolved.
I have space on the the array on a different system to recover this array.
Suggestions on how to do both of the above would be aprreciated

Checked the drives that make up the array using smartctl and the
results are (I removed text from each result that did not seem to have
any bearing on the test results (I likely used the wrong 'code')):

# smartctl -a /dev/sdb
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-2-amd64] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD10EFRX-68FYTN0
Serial Number:    WD-WCC4J3TC25D3
LU WWN Device Id: 5 0014ee 20cd9cd93
Firmware Version: 82.00A82
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Fri Feb  7 08:35:51 2020 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   132   130   021    Pre-fail
Always       -       4391
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       165
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   058   058   000    Old_age
Always       -       31314
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       148
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       81
193 Load_Cycle_Count        0x0032   187   187   000    Old_age
Always       -       39644
194 Temperature_Celsius     0x0022   115   101   000    Old_age
Always       -       28
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

SMART Error Log Version: 1
No Errors Logged

# smartctl -a /dev/sdc
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-2-amd64] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD10EFRX-68FYTN0
Serial Number:    WD-WCC4J6TTLZTE
LU WWN Device Id: 5 0014ee 2b784490e
Firmware Version: 82.00A82
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Fri Feb  7 08:36:49 2020 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   132   130   021    Pre-fail
Always       -       4375
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       151
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   056   056   000    Old_age
Always       -       32529
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       149
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       80
193 Load_Cycle_Count        0x0032   187   187   000    Old_age
Always       -       39651
194 Temperature_Celsius     0x0022   115   099   000    Old_age
Always       -       28
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

SMART Error Log Version: 1
No Errors Logged

# smartctl -a /dev/sde
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-2-amd64] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD10EFRX-68FYTN0
Serial Number:    WD-WCC4J6XRY5AN
LU WWN Device Id: 5 0014ee 20cd940c6
Firmware Version: 82.00A82
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Feb  7 08:37:21 2020 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   131   129   021    Pre-fail
Always       -       4441
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       152
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   056   056   000    Old_age
Always       -       32530
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       150
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       83
193 Load_Cycle_Count        0x0032   187   187   000    Old_age
Always       -       39603
194 Temperature_Celsius     0x0022   113   094   000    Old_age
Always       -       30
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       1
200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

# smartctl -a /dev/sdf
smartctl 7.1 2019-12-30 r5022 [x86_64-linux-5.4.0-2-amd64] (local build)
Copyright (C) 2002-19, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Red
Device Model:     WDC WD10EFRX-68FYTN0
Serial Number:    WD-WCC4J4XV62F4
LU WWN Device Id: 5 0014ee 20cd9d7d1
Firmware Version: 82.00A82
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Fri Feb  7 08:37:44 2020 CST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       8
  3 Spin_Up_Time            0x0027   135   134   021    Pre-fail
Always       -       4241
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       165
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   059   059   000    Old_age
Always       -       30121
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       148
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       82
193 Load_Cycle_Count        0x0032   187   187   000    Old_age
Always       -       39528
194 Temperature_Celsius     0x0022   115   097   000    Old_age
Always       -       28
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

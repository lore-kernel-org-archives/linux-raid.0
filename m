From: Daniel Sanabria <sanabria.d@gmail.com>
Subject: Re: Inactive arrays
Date: Tue, 13 Sep 2016 07:56:12 +0100
Message-ID: <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com> <57D72092.20704@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57D72092.20704@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> What does smartctl report on sdc and sde (I think you want smartctl -x,
> the extended "display everything" command)?

[root@lamachine ~]# smartctl -x /dev/{sdc,sdd,sde}
smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.3.3-303.fc23.x86_64] (local build)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools.org

ERROR: smartctl takes ONE device name as the final command-line argument.
You have provided 3 device names:
/dev/sdc
/dev/sdd
/dev/sde

Use smartctl -h to get a usage summary

[root@lamachine ~]# smartctl -x /dev/sdc
smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.3.3-303.fc23.x86_64] (local build)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Green
Device Model:     WDC WD30EZRX-00D8PB0
Serial Number:    WD-WCC4NCWT13RF
LU WWN Device Id: 5 0014ee 25fc9e460
Firmware Version: 80.00A80
User Capacity:    3,000,591,900,160 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Sep 13 07:53:18 2016 BST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
was completed without error.
Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (38940) seconds.
Offline data collection
capabilities: (0x7b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
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
recommended polling time: (   2) minutes.
Extended self-test routine
recommended polling time: ( 391) minutes.
Conveyance self-test routine
recommended polling time: (   5) minutes.
SCT capabilities:       (0x7035) SCT Status supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   177   177   021    -    6116
  4 Start_Stop_Count        -O--CK   100   100   000    -    41
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   085   085   000    -    11128
 10 Spin_Retry_Count        -O--CK   100   253   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    41
192 Power-Off_Retract_Count -O--CK   200   200   000    -    20
193 Load_Cycle_Count        -O--CK   142   142   000    -    175500
194 Temperature_Celsius     -O---K   123   114   000    -    27
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
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

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    27 Celsius
Power Cycle Min/Max Temperature:     23/27 Celsius
Lifetime    Min/Max Temperature:     15/36 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (376)

Index    Estimated Time   Temperature Celsius
 377    2016-09-12 23:56     ?  -
 378    2016-09-12 23:57    23  ****
 379    2016-09-12 23:58    24  *****
 ...    ..(  4 skipped).    ..  *****
 384    2016-09-13 00:03    24  *****
 385    2016-09-13 00:04    25  ******
 386    2016-09-13 00:05    25  ******
 387    2016-09-13 00:06    25  ******
 388    2016-09-13 00:07    26  *******
 ...    ..(  2 skipped).    ..  *******
 391    2016-09-13 00:10    26  *******
 392    2016-09-13 00:11    27  ********
 ...    ..(  7 skipped).    ..  ********
 400    2016-09-13 00:19    27  ********
 401    2016-09-13 00:20    29  **********
 402    2016-09-13 00:21    28  *********
 ...    ..(  4 skipped).    ..  *********
 407    2016-09-13 00:26    28  *********
 408    2016-09-13 00:27    29  **********
 ...    ..(  4 skipped).    ..  **********
 413    2016-09-13 00:32    29  **********
 414    2016-09-13 00:33    30  ***********
 ...    ..(  5 skipped).    ..  ***********
 420    2016-09-13 00:39    30  ***********
 421    2016-09-13 00:40    31  ************
 ...    ..( 23 skipped).    ..  ************
 445    2016-09-13 01:04    31  ************
 446    2016-09-13 01:05    32  *************
 ...    ..( 24 skipped).    ..  *************
 471    2016-09-13 01:30    32  *************
 472    2016-09-13 01:31     ?  -
 473    2016-09-13 01:32    33  **************
 474    2016-09-13 01:33    32  *************
 ...    ..(  9 skipped).    ..  *************
   6    2016-09-13 01:43    32  *************
   7    2016-09-13 01:44    33  **************
 ...    ..( 20 skipped).    ..  **************
  28    2016-09-13 02:05    33  **************
  29    2016-09-13 02:06    32  *************
  30    2016-09-13 02:07    32  *************
  31    2016-09-13 02:08    32  *************
  32    2016-09-13 02:09    33  **************
  33    2016-09-13 02:10    32  *************
 ...    ..( 62 skipped).    ..  *************
  96    2016-09-13 03:13    32  *************
  97    2016-09-13 03:14     ?  -
  98    2016-09-13 03:15    24  *****
 ...    ..(  4 skipped).    ..  *****
 103    2016-09-13 03:20    24  *****
 104    2016-09-13 03:21    25  ******
 105    2016-09-13 03:22    25  ******
 106    2016-09-13 03:23    25  ******
 107    2016-09-13 03:24    26  *******
 ...    ..(  2 skipped).    ..  *******
 110    2016-09-13 03:27    26  *******
 111    2016-09-13 03:28    27  ********
 ...    ..(  6 skipped).    ..  ********
 118    2016-09-13 03:35    27  ********
 119    2016-09-13 03:36    28  *********
 ...    ..( 11 skipped).    ..  *********
 131    2016-09-13 03:48    28  *********
 132    2016-09-13 03:49    29  **********
 ...    ..(  8 skipped).    ..  **********
 141    2016-09-13 03:58    29  **********
 142    2016-09-13 03:59    30  ***********
 ...    ..( 11 skipped).    ..  ***********
 154    2016-09-13 04:11    30  ***********
 155    2016-09-13 04:12    31  ************
 ...    ..( 42 skipped).    ..  ************
 198    2016-09-13 04:55    31  ************
 199    2016-09-13 04:56     ?  -
 200    2016-09-13 04:57    22  ***
 201    2016-09-13 04:58    22  ***
 202    2016-09-13 04:59    23  ****
 203    2016-09-13 05:00    23  ****
 204    2016-09-13 05:01    24  *****
 205    2016-09-13 05:02    24  *****
 206    2016-09-13 05:03    25  ******
 ...    ..(  3 skipped).    ..  ******
 210    2016-09-13 05:07    25  ******
 211    2016-09-13 05:08    26  *******
 212    2016-09-13 05:09    27  ********
 ...    ..(  7 skipped).    ..  ********
 220    2016-09-13 05:17    27  ********
 221    2016-09-13 05:18    28  *********
 ...    ..( 13 skipped).    ..  *********
 235    2016-09-13 05:32    28  *********
 236    2016-09-13 05:33    29  **********
 ...    ..( 10 skipped).    ..  **********
 247    2016-09-13 05:44    29  **********
 248    2016-09-13 05:45    30  ***********
 ...    ..( 16 skipped).    ..  ***********
 265    2016-09-13 06:02    30  ***********
 266    2016-09-13 06:03    31  ************
 ...    ..( 96 skipped).    ..  ************
 363    2016-09-13 07:40    31  ************
 364    2016-09-13 07:41     ?  -
 365    2016-09-13 07:42    31  ************
 366    2016-09-13 07:43    31  ************
 367    2016-09-13 07:44    30  ***********
 368    2016-09-13 07:45    30  ***********
 369    2016-09-13 07:46    30  ***********
 370    2016-09-13 07:47    31  ************
 ...    ..(  5 skipped).    ..  ************
 376    2016-09-13 07:53    31  ************

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            2  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            2  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4         1280  Vendor specific

[root@lamachine ~]# smartctl -x /dev/sdd
smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.3.3-303.fc23.x86_64] (local build)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Green
Device Model:     WDC WD30EZRX-00D8PB0
Serial Number:    WD-WCC4NPRDD6D7
LU WWN Device Id: 5 0014ee 25fca27b1
Firmware Version: 80.00A80
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Sep 13 07:53:20 2016 BST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
was completed without error.
Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (39060) seconds.
Offline data collection
capabilities: (0x7b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
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
recommended polling time: (   2) minutes.
Extended self-test routine
recommended polling time: ( 392) minutes.
Conveyance self-test routine
recommended polling time: (   5) minutes.
SCT capabilities:       (0x7035) SCT Status supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   176   176   021    -    6166
  4 Start_Stop_Count        -O--CK   100   100   000    -    41
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   085   085   000    -    11129
 10 Spin_Retry_Count        -O--CK   100   253   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    41
192 Power-Off_Retract_Count -O--CK   200   200   000    -    27
193 Load_Cycle_Count        -O--CK   137   137   000    -    191240
194 Temperature_Celsius     -O---K   123   114   000    -    27
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
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

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    27 Celsius
Power Cycle Min/Max Temperature:     23/27 Celsius
Lifetime    Min/Max Temperature:     15/36 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (401)

Index    Estimated Time   Temperature Celsius
 402    2016-09-12 23:56     ?  -
 403    2016-09-12 23:57    23  ****
 404    2016-09-12 23:58    23  ****
 405    2016-09-12 23:59    24  *****
 ...    ..(  3 skipped).    ..  *****
 409    2016-09-13 00:03    24  *****
 410    2016-09-13 00:04    25  ******
 411    2016-09-13 00:05    25  ******
 412    2016-09-13 00:06    25  ******
 413    2016-09-13 00:07    26  *******
 ...    ..(  2 skipped).    ..  *******
 416    2016-09-13 00:10    26  *******
 417    2016-09-13 00:11    27  ********
 ...    ..(  7 skipped).    ..  ********
 425    2016-09-13 00:19    27  ********
 426    2016-09-13 00:20    28  *********
 427    2016-09-13 00:21    29  **********
 ...    ..( 10 skipped).    ..  **********
 438    2016-09-13 00:32    29  **********
 439    2016-09-13 00:33    30  ***********
 ...    ..(  4 skipped).    ..  ***********
 444    2016-09-13 00:38    30  ***********
 445    2016-09-13 00:39    31  ************
 ...    ..( 23 skipped).    ..  ************
 469    2016-09-13 01:03    31  ************
 470    2016-09-13 01:04    32  *************
 ...    ..( 26 skipped).    ..  *************
  19    2016-09-13 01:31    32  *************
  20    2016-09-13 01:32     ?  -
  21    2016-09-13 01:33    33  **************
  22    2016-09-13 01:34    32  *************
 ...    ..( 11 skipped).    ..  *************
  34    2016-09-13 01:46    32  *************
  35    2016-09-13 01:47    33  **************
 ...    ..( 11 skipped).    ..  **************
  47    2016-09-13 01:59    33  **************
  48    2016-09-13 02:00    32  *************
 ...    ..( 73 skipped).    ..  *************
 122    2016-09-13 03:14    32  *************
 123    2016-09-13 03:15     ?  -
 124    2016-09-13 03:16    23  ****
 125    2016-09-13 03:17    24  *****
 ...    ..(  3 skipped).    ..  *****
 129    2016-09-13 03:21    24  *****
 130    2016-09-13 03:22    25  ******
 131    2016-09-13 03:23    25  ******
 132    2016-09-13 03:24    25  ******
 133    2016-09-13 03:25    26  *******
 134    2016-09-13 03:26    26  *******
 135    2016-09-13 03:27    26  *******
 136    2016-09-13 03:28    27  ********
 ...    ..(  7 skipped).    ..  ********
 144    2016-09-13 03:36    27  ********
 145    2016-09-13 03:37    28  *********
 ...    ..( 11 skipped).    ..  *********
 157    2016-09-13 03:49    28  *********
 158    2016-09-13 03:50    29  **********
 ...    ..(  9 skipped).    ..  **********
 168    2016-09-13 04:00    29  **********
 169    2016-09-13 04:01    30  ***********
 ...    ..( 12 skipped).    ..  ***********
 182    2016-09-13 04:14    30  ***********
 183    2016-09-13 04:15    31  ************
 ...    ..( 40 skipped).    ..  ************
 224    2016-09-13 04:56    31  ************
 225    2016-09-13 04:57     ?  -
 226    2016-09-13 04:58    22  ***
 227    2016-09-13 04:59    22  ***
 228    2016-09-13 05:00    23  ****
 229    2016-09-13 05:01    23  ****
 230    2016-09-13 05:02    24  *****
 231    2016-09-13 05:03    24  *****
 232    2016-09-13 05:04    25  ******
 ...    ..(  3 skipped).    ..  ******
 236    2016-09-13 05:08    25  ******
 237    2016-09-13 05:09    26  *******
 238    2016-09-13 05:10    27  ********
 ...    ..(  6 skipped).    ..  ********
 245    2016-09-13 05:17    27  ********
 246    2016-09-13 05:18    28  *********
 ...    ..( 13 skipped).    ..  *********
 260    2016-09-13 05:32    28  *********
 261    2016-09-13 05:33    29  **********
 ...    ..( 11 skipped).    ..  **********
 273    2016-09-13 05:45    29  **********
 274    2016-09-13 05:46    30  ***********
 ...    ..( 20 skipped).    ..  ***********
 295    2016-09-13 06:07    30  ***********
 296    2016-09-13 06:08    31  ************
 ...    ..( 92 skipped).    ..  ************
 389    2016-09-13 07:41    31  ************
 390    2016-09-13 07:42     ?  -
 391    2016-09-13 07:43    31  ************
 ...    ..(  9 skipped).    ..  ************
 401    2016-09-13 07:53    31  ************

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            3  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            3  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4         1283  Vendor specific

[root@lamachine ~]# smartctl -x /dev/sde
smartctl 6.4 2015-06-04 r4109 [x86_64-linux-4.3.3-303.fc23.x86_64] (local build)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Green
Device Model:     WDC WD30EZRX-00D8PB0
Serial Number:    WD-WCC4N1294906
LU WWN Device Id: 5 0014ee 25f968120
Firmware Version: 80.00A80
User Capacity:    3,000,591,900,160 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Tue Sep 13 07:53:23 2016 BST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
was completed without error.
Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0) The previous self-test routine completed
without error or no self-test has ever
been run.
Total time to complete Offline
data collection: (43200) seconds.
Offline data collection
capabilities: (0x7b) SMART execute Offline immediate.
Auto Offline data collection on/off support.
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
recommended polling time: (   2) minutes.
Extended self-test routine
recommended polling time: ( 433) minutes.
Conveyance self-test routine
recommended polling time: (   5) minutes.
SCT capabilities:       (0x7035) SCT Status supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   175   175   021    -    6208
  4 Start_Stop_Count        -O--CK   100   100   000    -    40
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   085   085   000    -    11141
 10 Spin_Retry_Count        -O--CK   100   253   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    40
192 Power-Off_Retract_Count -O--CK   200   200   000    -    27
193 Load_Cycle_Count        -O--CK   143   143   000    -    172837
194 Temperature_Celsius     -O---K   123   113   000    -    27
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
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

SCT Status Version:                  3
SCT Version (vendor specific):       258 (0x0102)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    27 Celsius
Power Cycle Min/Max Temperature:     23/27 Celsius
Lifetime    Min/Max Temperature:     16/37 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (145)

Index    Estimated Time   Temperature Celsius
 146    2016-09-12 23:56     ?  -
 147    2016-09-12 23:57    23  ****
 148    2016-09-12 23:58    23  ****
 149    2016-09-12 23:59    24  *****
 ...    ..(  3 skipped).    ..  *****
 153    2016-09-13 00:03    24  *****
 154    2016-09-13 00:04    25  ******
 155    2016-09-13 00:05    25  ******
 156    2016-09-13 00:06    25  ******
 157    2016-09-13 00:07    26  *******
 158    2016-09-13 00:08    26  *******
 159    2016-09-13 00:09    26  *******
 160    2016-09-13 00:10    27  ********
 ...    ..(  8 skipped).    ..  ********
 169    2016-09-13 00:19    27  ********
 170    2016-09-13 00:20    28  *********
 ...    ..(  6 skipped).    ..  *********
 177    2016-09-13 00:27    28  *********
 178    2016-09-13 00:28    29  **********
 ...    ..(  5 skipped).    ..  **********
 184    2016-09-13 00:34    29  **********
 185    2016-09-13 00:35    30  ***********
 ...    ..(  5 skipped).    ..  ***********
 191    2016-09-13 00:41    30  ***********
 192    2016-09-13 00:42    31  ************
 ...    ..( 25 skipped).    ..  ************
 218    2016-09-13 01:08    31  ************
 219    2016-09-13 01:09    32  *************
 ...    ..( 20 skipped).    ..  *************
 240    2016-09-13 01:30    32  *************
 241    2016-09-13 01:31     ?  -
 242    2016-09-13 01:32    33  **************
 243    2016-09-13 01:33    32  *************
 ...    ..( 35 skipped).    ..  *************
 279    2016-09-13 02:09    32  *************
 280    2016-09-13 02:10    33  **************
 ...    ..( 63 skipped).    ..  **************
 344    2016-09-13 03:14    33  **************
 345    2016-09-13 03:15     ?  -
 346    2016-09-13 03:16    23  ****
 347    2016-09-13 03:17    24  *****
 ...    ..(  3 skipped).    ..  *****
 351    2016-09-13 03:21    24  *****
 352    2016-09-13 03:22    25  ******
 353    2016-09-13 03:23    25  ******
 354    2016-09-13 03:24    25  ******
 355    2016-09-13 03:25    26  *******
 356    2016-09-13 03:26    26  *******
 357    2016-09-13 03:27    26  *******
 358    2016-09-13 03:28    27  ********
 ...    ..(  5 skipped).    ..  ********
 364    2016-09-13 03:34    27  ********
 365    2016-09-13 03:35    28  *********
 ...    ..(  9 skipped).    ..  *********
 375    2016-09-13 03:45    28  *********
 376    2016-09-13 03:46    29  **********
 ...    ..(  5 skipped).    ..  **********
 382    2016-09-13 03:52    29  **********
 383    2016-09-13 03:53    30  ***********
 ...    ..(  7 skipped).    ..  ***********
 391    2016-09-13 04:01    30  ***********
 392    2016-09-13 04:02    31  ************
 ...    ..( 28 skipped).    ..  ************
 421    2016-09-13 04:31    31  ************
 422    2016-09-13 04:32    32  *************
 ...    ..( 23 skipped).    ..  *************
 446    2016-09-13 04:56    32  *************
 447    2016-09-13 04:57     ?  -
 448    2016-09-13 04:58    22  ***
 449    2016-09-13 04:59    22  ***
 450    2016-09-13 05:00    23  ****
 451    2016-09-13 05:01    23  ****
 452    2016-09-13 05:02    24  *****
 453    2016-09-13 05:03    24  *****
 454    2016-09-13 05:04    25  ******
 ...    ..(  3 skipped).    ..  ******
 458    2016-09-13 05:08    25  ******
 459    2016-09-13 05:09    26  *******
 460    2016-09-13 05:10    27  ********
 461    2016-09-13 05:11    28  *********
 ...    ..( 12 skipped).    ..  *********
 474    2016-09-13 05:24    28  *********
 475    2016-09-13 05:25    29  **********
 ...    ..(  6 skipped).    ..  **********
   4    2016-09-13 05:32    29  **********
   5    2016-09-13 05:33    30  ***********
 ...    ..(  8 skipped).    ..  ***********
  14    2016-09-13 05:42    30  ***********
  15    2016-09-13 05:43    31  ************
 ...    ..( 41 skipped).    ..  ************
  57    2016-09-13 06:25    31  ************
  58    2016-09-13 06:26    32  *************
 ...    ..( 74 skipped).    ..  *************
 133    2016-09-13 07:41    32  *************
 134    2016-09-13 07:42     ?  -
 135    2016-09-13 07:43    32  *************
 ...    ..(  9 skipped).    ..  *************
 145    2016-09-13 07:53    32  *************

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2            3  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            3  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4         1285  Vendor specific

[root@lamachine ~]#

> And looking at the lsdrv stuff, were you using LVM? That's got a load of
> references to LV.

yes I was using LVM on top of raid

Thanks for the help so far guys!

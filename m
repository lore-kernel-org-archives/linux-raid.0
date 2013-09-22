From: Dave Gomboc <dave_gomboc@acm.org>
Subject: Re: raid10 recovery assistance requested
Date: Sun, 22 Sep 2013 23:04:38 +0000
Message-ID: <CA+dwz-2iWGu6LNkywDX1bebB_Gx1dYETfEoSiggsNdmm9bJ1Bw@mail.gmail.com>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com>
 <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com>
 <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com>
 <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com>
 <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Here is the information retrieved from the original 4 drives:


root@sysresccd /root % mdadm -E /dev/sda1
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3c76af95:fa16ca54:330b7547:b9040b8a
           Name : cheap:teramooch
  Creation Time : Mon Jan  3 05:47:11 2011
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
     Array Size : 7814041600 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907020800 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 45ffddf1:080172d2:ff5db863:5f6d84e8

    Update Time : Sun Sep 15 09:54:22 2013
       Checksum : 1cbfeaea - correct
         Events : 599

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : .AAA ('A' == active, '.' == missing)


root@sysresccd /root % mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3c76af95:fa16ca54:330b7547:b9040b8a
           Name : cheap:teramooch
  Creation Time : Mon Jan  3 05:47:11 2011
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
     Array Size : 7814041600 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907020800 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 66806913:402f8cfb:a74e11fd:5ca17fee

    Update Time : Sat Sep 14 06:14:13 2013
       Checksum : 6b7397f - correct
         Events : 520

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)


root@sysresccd /root % mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3c76af95:fa16ca54:330b7547:b9040b8a
           Name : cheap:teramooch
  Creation Time : Mon Jan  3 05:47:11 2011
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
     Array Size : 7814041600 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907020800 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 66806913:402f8cfb:a74e11fd:5ca17fee

    Update Time : Sat Sep 14 06:14:13 2013
       Checksum : 6b7397f - correct
         Events : 520

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA ('A' == active, '.' == missing)


root@sysresccd /root % mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 3c76af95:fa16ca54:330b7547:b9040b8a
           Name : cheap:teramooch
  Creation Time : Mon Jan  3 05:47:11 2011
     Raid Level : raid10
   Raid Devices : 4

 Avail Dev Size : 3907021954 (1863.01 GiB 2000.40 GB)
     Array Size : 7814041600 (3726.03 GiB 4000.79 GB)
  Used Dev Size : 3907020800 (1863.01 GiB 2000.39 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 45ffddf1:080172d2:ff5db863:5f6d84e8

    Update Time : Sun Sep 15 09:54:22 2013
       Checksum : 1cbfeaea - correct
         Events : 599

         Layout : near=2
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : .AAA ('A' == active, '.' == missing)


root@sysresccd /root % smartctl -x /dev/sda
smartctl 5.42 2011-10-20 r3458 [x86_64-linux-3.4.52-std371-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda LP
Device Model:     ST32000542AS
Serial Number:    5XW1P41K
LU WWN Device Id: 5 000c50 02abd04fd
Firmware Version: CC34
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Sep 22 15:57:05 2013 UTC
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
data collection: (  643) seconds.
Offline data collection
capabilities: (0x73) SMART execute Offline immediate.
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
recommended polling time: (   1) minutes.
Extended self-test routine
recommended polling time: ( 255) minutes.
Conveyance self-test routine
recommended polling time: (   2) minutes.
SCT capabilities:       (0x103f) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   117   099   006    -    167407251
  3 Spin_Up_Time            PO----   100   100   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    95
  5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
  7 Seek_Error_Rate         POSR--   075   060   030    -    37488616
  9 Power_On_Hours          -O--CK   086   086   000    -    12539
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   100   020    -    86
183 Runtime_Bad_Block       -O--CK   095   095   000    -    5
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   100   000    -    196611
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   072   051   045    -    28 (Min/Max 26/28)
194 Temperature_Celsius     -O---K   028   049   000    -    28 (0 16 0 0 0)
195 Hardware_ECC_Recovered  -O-RC-   048   014   000    -    167407251
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    4
240 Head_Flying_Hours       ------   100   253   000    -    195481141522647
241 Total_LBAs_Written      ------   100   253   000    -    243233184
242 Total_LBAs_Read         ------   100   253   000    -    4126437910
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
GP/S  Log at address 0x01 has    1 sectors [Summary SMART error log]
GP/S  Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
GP/S  Log at address 0x03 has    5 sectors [Ext. Comprehensive SMART error log]
GP/S  Log at address 0x06 has    1 sectors [SMART self-test log]
GP/S  Log at address 0x07 has    1 sectors [Extended self-test log]
GP/S  Log at address 0x09 has    1 sectors [Selective self-test log]
GP/S  Log at address 0x10 has    1 sectors [NCQ Command Error log]
GP/S  Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP/S  Log at address 0x21 has    1 sectors [Write stream error log]
GP/S  Log at address 0x22 has    1 sectors [Read stream error log]
GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0xa1 has   20 sectors [Device vendor specific log]
GP    Log at address 0xa2 has 2248 sectors [Device vendor specific log]
GP/S  Log at address 0xa8 has  129 sectors [Device vendor specific log]
GP/S  Log at address 0xa9 has    1 sectors [Device vendor specific log]
GP    Log at address 0xb0 has 2928 sectors [Device vendor specific log]
GP/S  Log at address 0xbd has  252 sectors [Device vendor specific log]
GP    Log at address 0xbe has 65535 sectors [Device vendor specific log]
GP    Log at address 0xbf has 65535 sectors [Device vendor specific log]
GP/S  Log at address 0xc0 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
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
SCT Version (vendor specific):       522 (0x020a)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    28 Celsius
Power Cycle Min/Max Temperature:     26/28 Celsius
Lifetime    Min/Max Temperature:     16/49 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         10 minutes
Temperature Logging Interval:        59 minutes
Min/Max recommended Temperature:     14/55 Celsius
Min/Max Temperature Limit:           10/60 Celsius
Temperature History Size (Index):    128 (21)

Index    Estimated Time   Temperature Celsius
  22    2013-09-17 10:35    29  **********
  23    2013-09-17 11:34     ?  -
  24    2013-09-17 12:33    29  **********
  25    2013-09-17 13:32     ?  -
  26    2013-09-17 14:31    29  **********
  27    2013-09-17 15:30     ?  -
  28    2013-09-17 16:29    29  **********
  29    2013-09-17 17:28     ?  -
  30    2013-09-17 18:27    29  **********
  31    2013-09-17 19:26     ?  -
  32    2013-09-17 20:25    29  **********
  33    2013-09-17 21:24     ?  -
  34    2013-09-17 22:23    30  ***********
  35    2013-09-17 23:22     ?  -
  36    2013-09-18 00:21    30  ***********
  37    2013-09-18 01:20     ?  -
  38    2013-09-18 02:19    30  ***********
  39    2013-09-18 03:18     ?  -
  40    2013-09-18 04:17    25  ******
  41    2013-09-18 05:16     ?  -
  42    2013-09-18 06:15    29  **********
  43    2013-09-18 07:14     ?  -
  44    2013-09-18 08:13    29  **********
  45    2013-09-18 09:12     ?  -
  46    2013-09-18 10:11    29  **********
  47    2013-09-18 11:10    29  **********
  48    2013-09-18 12:09    29  **********
  49    2013-09-18 13:08    30  ***********
  50    2013-09-18 14:07    29  **********
  51    2013-09-18 15:06    30  ***********
  52    2013-09-18 16:05    29  **********
  53    2013-09-18 17:04    30  ***********
  54    2013-09-18 18:03    30  ***********
  55    2013-09-18 19:02    29  **********
  56    2013-09-18 20:01    30  ***********
  57    2013-09-18 21:00    29  **********
  58    2013-09-18 21:59    30  ***********
  59    2013-09-18 22:58    29  **********
  60    2013-09-18 23:57    30  ***********
  61    2013-09-19 00:56    29  **********
  62    2013-09-19 01:55    30  ***********
  63    2013-09-19 02:54    29  **********
  64    2013-09-19 03:53    29  **********
  65    2013-09-19 04:52    30  ***********
  66    2013-09-19 05:51    30  ***********
  67    2013-09-19 06:50    30  ***********
  68    2013-09-19 07:49     ?  -
  69    2013-09-19 08:48    29  **********
  70    2013-09-19 09:47    29  **********
  71    2013-09-19 10:46    30  ***********
  72    2013-09-19 11:45    31  ************
  73    2013-09-19 12:44    29  **********
  74    2013-09-19 13:43    29  **********
  75    2013-09-19 14:42    28  *********
  76    2013-09-19 15:41     ?  -
  77    2013-09-19 16:40    35  ****************
  78    2013-09-19 17:39     ?  -
  79    2013-09-19 18:38    30  ***********
  80    2013-09-19 19:37     ?  -
  81    2013-09-19 20:36    29  **********
  82    2013-09-19 21:35     ?  -
  83    2013-09-19 22:34    26  *******
  84    2013-09-19 23:33     ?  -
  85    2013-09-20 00:32    25  ******
  86    2013-09-20 01:31     ?  -
  87    2013-09-20 02:30    23  ****
  88    2013-09-20 03:29    23  ****
  89    2013-09-20 04:28     ?  -
  90    2013-09-20 05:27    26  *******
  91    2013-09-20 06:26     ?  -
  92    2013-09-20 07:25    27  ********
  93    2013-09-20 08:24     ?  -
  94    2013-09-20 09:23    27  ********
  95    2013-09-20 10:22     ?  -
  96    2013-09-20 11:21    30  ***********
  97    2013-09-20 12:20    30  ***********
  98    2013-09-20 13:19    29  **********
  99    2013-09-20 14:18    28  *********
 100    2013-09-20 15:17    27  ********
 101    2013-09-20 16:16    27  ********
 102    2013-09-20 17:15    26  *******
 103    2013-09-20 18:14    26  *******
 104    2013-09-20 19:13    25  ******
 105    2013-09-20 20:12    25  ******
 106    2013-09-20 21:11    25  ******
 107    2013-09-20 22:10    24  *****
 108    2013-09-20 23:09    24  *****
 109    2013-09-21 00:08     ?  -
 110    2013-09-21 01:07    22  ***
 111    2013-09-21 02:06     ?  -
 112    2013-09-21 03:05    23  ****
 113    2013-09-21 04:04     ?  -
 114    2013-09-21 05:03    29  **********
 115    2013-09-21 06:02     ?  -
 116    2013-09-21 07:01    29  **********
 117    2013-09-21 08:00     ?  -
 118    2013-09-21 08:59    25  ******
 119    2013-09-21 09:58    25  ******
 120    2013-09-21 10:57    35  ****************
 121    2013-09-21 11:56     ?  -
 122    2013-09-21 12:55    31  ************
 123    2013-09-21 13:54     ?  -
 124    2013-09-21 14:53    26  *******
 125    2013-09-21 15:52    26  *******
 126    2013-09-21 16:51    28  *********
 127    2013-09-21 17:50     ?  -
   0    2013-09-21 18:49    36  *****************
   1    2013-09-21 19:48     ?  -
   2    2013-09-21 20:47    34  ***************
   3    2013-09-21 21:46     ?  -
   4    2013-09-21 22:45    40  *********************
   5    2013-09-21 23:44    40  *********************
   6    2013-09-22 00:43    41  **********************
   7    2013-09-22 01:42     ?  -
   8    2013-09-22 02:41    31  ************
   9    2013-09-22 03:40     ?  -
  10    2013-09-22 04:39    25  ******
  11    2013-09-22 05:38    25  ******
  12    2013-09-22 06:37    40  *********************
  13    2013-09-22 07:36    41  **********************
  14    2013-09-22 08:35    40  *********************
 ...    ..(  3 skipped).    ..  *********************
  18    2013-09-22 12:31    40  *********************
  19    2013-09-22 13:30     ?  -
  20    2013-09-22 14:29    26  *******
  21    2013-09-22 15:28    26  *******

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            6  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS


root@sysresccd /root % smartctl -x /dev/sdb
smartctl 5.42 2011-10-20 r3458 [x86_64-linux-3.4.52-std371-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda LP
Device Model:     ST32000542AS
Serial Number:    5XW1P852
LU WWN Device Id: 5 000c50 02abf5ce5
Firmware Version: CC34
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Sep 22 15:57:56 2013 UTC
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
data collection: (  633) seconds.
Offline data collection
capabilities: (0x73) SMART execute Offline immediate.
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
recommended polling time: (   1) minutes.
Extended self-test routine
recommended polling time: ( 255) minutes.
Conveyance self-test routine
recommended polling time: (   2) minutes.
SCT capabilities:       (0x103f) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   117   099   006    -    140233800
  3 Spin_Up_Time            PO----   100   100   000    -    0
  4 Start_Stop_Count        -O--CK   099   099   020    -    1385
  5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
  7 Seek_Error_Rate         POSR--   066   051   030    -    30097052991
  9 Power_On_Hours          -O--CK   086   086   000    -    12590
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   100   020    -    85
183 Runtime_Bad_Block       -O--CK   085   085   000    -    15
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   100   000    -    4295032833
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   075   051   045    -    25 (Min/Max 24/25)
194 Temperature_Celsius     -O---K   025   049   000    -    25 (0 14 0 0 0)
195 Hardware_ECC_Recovered  -O-RC-   048   016   000    -    140233800
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    -    85594403254559
241 Total_LBAs_Written      ------   100   253   000    -    686988228
242 Total_LBAs_Read         ------   100   253   000    -    3116625490
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
GP/S  Log at address 0x01 has    1 sectors [Summary SMART error log]
GP/S  Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
GP/S  Log at address 0x03 has    5 sectors [Ext. Comprehensive SMART error log]
GP/S  Log at address 0x06 has    1 sectors [SMART self-test log]
GP/S  Log at address 0x07 has    1 sectors [Extended self-test log]
GP/S  Log at address 0x09 has    1 sectors [Selective self-test log]
GP/S  Log at address 0x10 has    1 sectors [NCQ Command Error log]
GP/S  Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP/S  Log at address 0x21 has    1 sectors [Write stream error log]
GP/S  Log at address 0x22 has    1 sectors [Read stream error log]
GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0xa1 has   20 sectors [Device vendor specific log]
GP    Log at address 0xa2 has 2248 sectors [Device vendor specific log]
GP/S  Log at address 0xa8 has  129 sectors [Device vendor specific log]
GP/S  Log at address 0xa9 has    1 sectors [Device vendor specific log]
GP    Log at address 0xb0 has 2928 sectors [Device vendor specific log]
GP/S  Log at address 0xbd has  252 sectors [Device vendor specific log]
GP    Log at address 0xbe has 65535 sectors [Device vendor specific log]
GP    Log at address 0xbf has 65535 sectors [Device vendor specific log]
GP/S  Log at address 0xc0 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
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
SCT Version (vendor specific):       522 (0x020a)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    25 Celsius
Power Cycle Min/Max Temperature:     24/25 Celsius
Lifetime    Min/Max Temperature:     14/49 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         10 minutes
Temperature Logging Interval:        59 minutes
Min/Max recommended Temperature:     14/55 Celsius
Min/Max Temperature Limit:           10/60 Celsius
Temperature History Size (Index):    128 (68)

Index    Estimated Time   Temperature Celsius
  69    2013-09-17 10:35     ?  -
  70    2013-09-17 11:34    29  **********
  71    2013-09-17 12:33     ?  -
  72    2013-09-17 13:32    28  *********
  73    2013-09-17 14:31     ?  -
  74    2013-09-17 15:30    25  ******
  75    2013-09-17 16:29     ?  -
  76    2013-09-17 17:28    24  *****
  77    2013-09-17 18:27     ?  -
  78    2013-09-17 19:26    22  ***
  79    2013-09-17 20:25     ?  -
  80    2013-09-17 21:24    25  ******
  81    2013-09-17 22:23     ?  -
  82    2013-09-17 23:22    26  *******
  83    2013-09-18 00:21     ?  -
  84    2013-09-18 01:20    26  *******
  85    2013-09-18 02:19     ?  -
  86    2013-09-18 03:18    28  *********
  87    2013-09-18 04:17    28  *********
  88    2013-09-18 05:16    27  ********
  89    2013-09-18 06:15    27  ********
  90    2013-09-18 07:14    26  *******
  91    2013-09-18 08:13    25  ******
  92    2013-09-18 09:12    24  *****
  93    2013-09-18 10:11    24  *****
  94    2013-09-18 11:10    24  *****
  95    2013-09-18 12:09    23  ****
  96    2013-09-18 13:08    23  ****
  97    2013-09-18 14:07    22  ***
  98    2013-09-18 15:06    22  ***
  99    2013-09-18 16:05     ?  -
 100    2013-09-18 17:04    20  *
 101    2013-09-18 18:03     ?  -
 102    2013-09-18 19:02    21  **
 103    2013-09-18 20:01     ?  -
 104    2013-09-18 21:00    28  *********
 105    2013-09-18 21:59     ?  -
 106    2013-09-18 22:58    28  *********
 107    2013-09-18 23:57     ?  -
 108    2013-09-19 00:56    24  *****
 109    2013-09-19 01:55    24  *****
 110    2013-09-19 02:54    39  ********************
 111    2013-09-19 03:53    43  ************************
 112    2013-09-19 04:52    44  *************************
 113    2013-09-19 05:51     ?  -
 114    2013-09-19 06:50    31  ************
 115    2013-09-19 07:49     ?  -
 116    2013-09-19 08:48    35  ****************
 117    2013-09-19 09:47     ?  -
 118    2013-09-19 10:46    32  *************
 119    2013-09-19 11:45     ?  -
 120    2013-09-19 12:44    33  **************
 121    2013-09-19 13:43    33  **************
 122    2013-09-19 14:42    33  **************
 123    2013-09-19 15:41     ?  -
 124    2013-09-19 16:40    27  ********
 125    2013-09-19 17:39    27  ********
 126    2013-09-19 18:38    35  ****************
 127    2013-09-19 19:37    36  *****************
   0    2013-09-19 20:36    35  ****************
   1    2013-09-19 21:35    35  ****************
   2    2013-09-19 22:34    35  ****************
   3    2013-09-19 23:33    33  **************
 ...    ..(  7 skipped).    ..  **************
  11    2013-09-20 07:25    33  **************
  12    2013-09-20 08:24    34  ***************
  13    2013-09-20 09:23    35  ****************
  14    2013-09-20 10:22    35  ****************
  15    2013-09-20 11:21    36  *****************
 ...    ..(  2 skipped).    ..  *****************
  18    2013-09-20 14:18    36  *****************
  19    2013-09-20 15:17    35  ****************
  20    2013-09-20 16:16    36  *****************
  21    2013-09-20 17:15    35  ****************
 ...    ..(  2 skipped).    ..  ****************
  24    2013-09-20 20:12    35  ****************
  25    2013-09-20 21:11    36  *****************
  26    2013-09-20 22:10    35  ****************
 ...    ..(  3 skipped).    ..  ****************
  30    2013-09-21 02:06    35  ****************
  31    2013-09-21 03:05    33  **************
  32    2013-09-21 04:04    32  *************
  33    2013-09-21 05:03    32  *************
  34    2013-09-21 06:02    33  **************
 ...    ..(  3 skipped).    ..  **************
  38    2013-09-21 09:58    33  **************
  39    2013-09-21 10:57    34  ***************
  40    2013-09-21 11:56    35  ****************
  41    2013-09-21 12:55    34  ***************
 ...    ..(  3 skipped).    ..  ***************
  45    2013-09-21 16:51    34  ***************
  46    2013-09-21 17:50    33  **************
  47    2013-09-21 18:49    33  **************
  48    2013-09-21 19:48    34  ***************
  49    2013-09-21 20:47    33  **************
  50    2013-09-21 21:46    33  **************
  51    2013-09-21 22:45    32  *************
  52    2013-09-21 23:44    33  **************
  53    2013-09-22 00:43    33  **************
  54    2013-09-22 01:42    32  *************
  55    2013-09-22 02:41    32  *************
  56    2013-09-22 03:40    34  ***************
  57    2013-09-22 04:39    34  ***************
  58    2013-09-22 05:38    33  **************
  59    2013-09-22 06:37    33  **************
  60    2013-09-22 07:36    32  *************
  61    2013-09-22 08:35    33  **************
  62    2013-09-22 09:34    33  **************
  63    2013-09-22 10:33    32  *************
  64    2013-09-22 11:32    35  ****************
  65    2013-09-22 12:31    35  ****************
  66    2013-09-22 13:30     ?  -
  67    2013-09-22 14:29    24  *****
  68    2013-09-22 15:28    24  *****

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            2  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS


root@sysresccd /root % smartctl -x /dev/sdc
smartctl 5.42 2011-10-20 r3458 [x86_64-linux-3.4.52-std371-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda LP
Device Model:     ST32000542AS
Serial Number:    6XW1T14N
LU WWN Device Id: 5 000c50 02b5bf6b9
Firmware Version: CC34
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Sep 22 15:59:14 2013 UTC
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
data collection: (  643) seconds.
Offline data collection
capabilities: (0x73) SMART execute Offline immediate.
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
recommended polling time: (   1) minutes.
Extended self-test routine
recommended polling time: ( 255) minutes.
Conveyance self-test routine
recommended polling time: (   2) minutes.
SCT capabilities:       (0x103f) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   114   099   006    -    65310841
  3 Spin_Up_Time            PO----   100   100   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    107
  5 Reallocated_Sector_Ct   PO--CK   098   098   036    -    107
  7 Seek_Error_Rate         POSR--   065   052   030    -    25791702551
  9 Power_On_Hours          -O--CK   086   086   000    -    12575
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   100   020    -    89
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   099   000    -    4295032833
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   075   052   045    -    25 (Min/Max 24/25)
194 Temperature_Celsius     -O---K   025   048   000    -    25 (0 14 0 0 0)
195 Hardware_ECC_Recovered  -O-RC-   048   019   000    -    65310841
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    -    4707284168973
241 Total_LBAs_Written      ------   100   253   000    -    3046759665
242 Total_LBAs_Read         ------   100   253   000    -    3165076617
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
GP/S  Log at address 0x01 has    1 sectors [Summary SMART error log]
GP/S  Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
GP/S  Log at address 0x03 has    5 sectors [Ext. Comprehensive SMART error log]
GP/S  Log at address 0x06 has    1 sectors [SMART self-test log]
GP/S  Log at address 0x07 has    1 sectors [Extended self-test log]
GP/S  Log at address 0x09 has    1 sectors [Selective self-test log]
GP/S  Log at address 0x10 has    1 sectors [NCQ Command Error log]
GP/S  Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP/S  Log at address 0x21 has    1 sectors [Write stream error log]
GP/S  Log at address 0x22 has    1 sectors [Read stream error log]
GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0xa1 has   20 sectors [Device vendor specific log]
GP    Log at address 0xa2 has 2248 sectors [Device vendor specific log]
GP/S  Log at address 0xa8 has  129 sectors [Device vendor specific log]
GP/S  Log at address 0xa9 has    1 sectors [Device vendor specific log]
GP    Log at address 0xb0 has 2928 sectors [Device vendor specific log]
GP/S  Log at address 0xbd has  252 sectors [Device vendor specific log]
GP    Log at address 0xbe has 65535 sectors [Device vendor specific log]
GP    Log at address 0xbf has 65535 sectors [Device vendor specific log]
GP/S  Log at address 0xc0 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
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
SCT Version (vendor specific):       522 (0x020a)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    25 Celsius
Power Cycle Min/Max Temperature:     24/25 Celsius
Lifetime    Min/Max Temperature:     14/48 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         10 minutes
Temperature Logging Interval:        59 minutes
Min/Max recommended Temperature:     14/55 Celsius
Min/Max Temperature Limit:           10/60 Celsius
Temperature History Size (Index):    128 (55)

Index    Estimated Time   Temperature Celsius
  56    2013-09-17 10:35    28  *********
  57    2013-09-17 11:34    27  ********
  58    2013-09-17 12:33    28  *********
  59    2013-09-17 13:32    28  *********
  60    2013-09-17 14:31    27  ********
  61    2013-09-17 15:30    28  *********
  62    2013-09-17 16:29    27  ********
  63    2013-09-17 17:28    28  *********
  64    2013-09-17 18:27    27  ********
  65    2013-09-17 19:26    29  **********
  66    2013-09-17 20:25    27  ********
  67    2013-09-17 21:24    28  *********
 ...    ..(  3 skipped).    ..  *********
  71    2013-09-18 01:20    28  *********
  72    2013-09-18 02:19     ?  -
  73    2013-09-18 03:18    28  *********
 ...    ..(  2 skipped).    ..  *********
  76    2013-09-18 06:15    28  *********
  77    2013-09-18 07:14    27  ********
  78    2013-09-18 08:13    27  ********
  79    2013-09-18 09:12    26  *******
  80    2013-09-18 10:11     ?  -
  81    2013-09-18 11:10    33  **************
  82    2013-09-18 12:09     ?  -
  83    2013-09-18 13:08    28  *********
  84    2013-09-18 14:07     ?  -
  85    2013-09-18 15:06    27  ********
  86    2013-09-18 16:05     ?  -
  87    2013-09-18 17:04    23  ****
  88    2013-09-18 18:03     ?  -
  89    2013-09-18 19:02    23  ****
  90    2013-09-18 20:01     ?  -
  91    2013-09-18 21:00    20  *
  92    2013-09-18 21:59    20  *
  93    2013-09-18 22:58     ?  -
  94    2013-09-18 23:57    25  ******
  95    2013-09-19 00:56     ?  -
  96    2013-09-19 01:55    27  ********
  97    2013-09-19 02:54     ?  -
  98    2013-09-19 03:53    28  *********
  99    2013-09-19 04:52     ?  -
 100    2013-09-19 05:51    30  ***********
 101    2013-09-19 06:50    30  ***********
 102    2013-09-19 07:49    26  *******
 103    2013-09-19 08:48    26  *******
 104    2013-09-19 09:47    26  *******
 105    2013-09-19 10:46    25  ******
 106    2013-09-19 11:45    25  ******
 107    2013-09-19 12:44    24  *****
 108    2013-09-19 13:43    24  *****
 109    2013-09-19 14:42    23  ****
 110    2013-09-19 15:41    23  ****
 111    2013-09-19 16:40    22  ***
 112    2013-09-19 17:39    22  ***
 113    2013-09-19 18:38     ?  -
 114    2013-09-19 19:37    20  *
 115    2013-09-19 20:36     ?  -
 116    2013-09-19 21:35    21  **
 117    2013-09-19 22:34     ?  -
 118    2013-09-19 23:33    28  *********
 119    2013-09-20 00:32     ?  -
 120    2013-09-20 01:31    28  *********
 121    2013-09-20 02:30     ?  -
 122    2013-09-20 03:29    24  *****
 123    2013-09-20 04:28    24  *****
 124    2013-09-20 05:27    36  *****************
 125    2013-09-20 06:26    42  ***********************
 126    2013-09-20 07:25    26  *******
 127    2013-09-20 08:24     ?  -
   0    2013-09-20 09:23    30  ***********
   1    2013-09-20 10:22     ?  -
   2    2013-09-20 11:21    33  **************
   3    2013-09-20 12:20     ?  -
   4    2013-09-20 13:19    34  ***************
   5    2013-09-20 14:18     ?  -
   6    2013-09-20 15:17    34  ***************
   7    2013-09-20 16:16    34  ***************
   8    2013-09-20 17:15    33  **************
   9    2013-09-20 18:14     ?  -
  10    2013-09-20 19:13    22  ***
  11    2013-09-20 20:12    22  ***
  12    2013-09-20 21:11    34  ***************
  13    2013-09-20 22:10    34  ***************
  14    2013-09-20 23:09    35  ****************
 ...    ..(  3 skipped).    ..  ****************
  18    2013-09-21 03:05    35  ****************
  19    2013-09-21 04:04    36  *****************
 ...    ..(  6 skipped).    ..  *****************
  26    2013-09-21 10:57    36  *****************
  27    2013-09-21 11:56    35  ****************
 ...    ..(  5 skipped).    ..  ****************
  33    2013-09-21 17:50    35  ****************
  34    2013-09-21 18:49    34  ***************
  35    2013-09-21 19:48    34  ***************
  36    2013-09-21 20:47    34  ***************
  37    2013-09-21 21:46    35  ****************
  38    2013-09-21 22:45    36  *****************
  39    2013-09-21 23:44    36  *****************
  40    2013-09-22 00:43    36  *****************
  41    2013-09-22 01:42    35  ****************
  42    2013-09-22 02:41    35  ****************
  43    2013-09-22 03:40    36  *****************
  44    2013-09-22 04:39    36  *****************
  45    2013-09-22 05:38    37  ******************
  46    2013-09-22 06:37    38  *******************
  47    2013-09-22 07:36    37  ******************
  48    2013-09-22 08:35    40  *********************
  49    2013-09-22 09:34    39  ********************
 ...    ..(  2 skipped).    ..  ********************
  52    2013-09-22 12:31    39  ********************
  53    2013-09-22 13:30     ?  -
  54    2013-09-22 14:29    24  *****
  55    2013-09-22 15:28    24  *****

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            2  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS


root@sysresccd /root % smartctl -x /dev/sdd
smartctl 5.42 2011-10-20 r3458 [x86_64-linux-3.4.52-std371-amd64] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda LP
Device Model:     ST32000542AS
Serial Number:    6XW1T1CG
LU WWN Device Id: 5 000c50 02b5c5911
Firmware Version: CC34
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Sep 22 16:01:32 2013 UTC
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
data collection: (  633) seconds.
Offline data collection
capabilities: (0x73) SMART execute Offline immediate.
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
recommended polling time: (   1) minutes.
Extended self-test routine
recommended polling time: ( 255) minutes.
Conveyance self-test routine
recommended polling time: (   2) minutes.
SCT capabilities:       (0x103f) SCT Status supported.
SCT Error Recovery Control supported.
SCT Feature Control supported.
SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   119   099   006    -    212966341
  3 Spin_Up_Time            PO----   100   100   000    -    0
  4 Start_Stop_Count        -O--CK   100   100   020    -    106
  5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
  7 Seek_Error_Rate         POSR--   065   053   030    -    30090297916
  9 Power_On_Hours          -O--CK   086   086   000    -    12579
 10 Spin_Retry_Count        PO--C-   100   100   097    -    0
 12 Power_Cycle_Count       -O--CK   100   100   020    -    89
183 Runtime_Bad_Block       -O--CK   099   099   000    -    1
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   099   000    -    17180131333
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   075   053   045    -    25 (Min/Max 24/25)
194 Temperature_Celsius     -O---K   025   047   000    -    25 (0 14 0 0 0)
195 Hardware_ECC_Recovered  -O-RC-   052   018   000    -    212966341
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    -    133221295599862
241 Total_LBAs_Written      ------   100   253   000    -    1574498906
242 Total_LBAs_Read         ------   100   253   000    -    2425164431
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
GP/S  Log at address 0x01 has    1 sectors [Summary SMART error log]
GP/S  Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
GP/S  Log at address 0x03 has    5 sectors [Ext. Comprehensive SMART error log]
GP/S  Log at address 0x06 has    1 sectors [SMART self-test log]
GP/S  Log at address 0x07 has    1 sectors [Extended self-test log]
GP/S  Log at address 0x09 has    1 sectors [Selective self-test log]
GP/S  Log at address 0x10 has    1 sectors [NCQ Command Error log]
GP/S  Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
GP/S  Log at address 0x21 has    1 sectors [Write stream error log]
GP/S  Log at address 0x22 has    1 sectors [Read stream error log]
GP/S  Log at address 0x80 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x81 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x82 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x83 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x84 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x85 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x86 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x87 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x88 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x89 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x8f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x90 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x91 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x92 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x93 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x94 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x95 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x96 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x97 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x98 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x99 has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9a has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9b has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9c has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9d has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9e has   16 sectors [Host vendor specific log]
GP/S  Log at address 0x9f has   16 sectors [Host vendor specific log]
GP/S  Log at address 0xa1 has   20 sectors [Device vendor specific log]
GP    Log at address 0xa2 has 2248 sectors [Device vendor specific log]
GP/S  Log at address 0xa8 has  129 sectors [Device vendor specific log]
GP/S  Log at address 0xa9 has    1 sectors [Device vendor specific log]
GP    Log at address 0xb0 has 2928 sectors [Device vendor specific log]
GP/S  Log at address 0xbd has  252 sectors [Device vendor specific log]
GP    Log at address 0xbe has 65535 sectors [Device vendor specific log]
GP    Log at address 0xbf has 65535 sectors [Device vendor specific log]
GP/S  Log at address 0xc0 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
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
SCT Version (vendor specific):       522 (0x020a)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    25 Celsius
Power Cycle Min/Max Temperature:     24/25 Celsius
Lifetime    Min/Max Temperature:     14/47 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         10 minutes
Temperature Logging Interval:        59 minutes
Min/Max recommended Temperature:     14/55 Celsius
Min/Max Temperature Limit:           10/60 Celsius
Temperature History Size (Index):    128 (53)

Index    Estimated Time   Temperature Celsius
  54    2013-09-17 10:35    27  ********
  55    2013-09-17 11:34    27  ********
  56    2013-09-17 12:33    28  *********
  57    2013-09-17 13:32    27  ********
  58    2013-09-17 14:31    28  *********
  59    2013-09-17 15:30    27  ********
  60    2013-09-17 16:29    28  *********
  61    2013-09-17 17:28    28  *********
  62    2013-09-17 18:27    27  ********
  63    2013-09-17 19:26    28  *********
  64    2013-09-17 20:25    27  ********
  65    2013-09-17 21:24    28  *********
  66    2013-09-17 22:23    27  ********
  67    2013-09-17 23:22    28  *********
  68    2013-09-18 00:21    27  ********
  69    2013-09-18 01:20    28  *********
 ...    ..(  3 skipped).    ..  *********
  73    2013-09-18 05:16    28  *********
  74    2013-09-18 06:15     ?  -
  75    2013-09-18 07:14    27  ********
  76    2013-09-18 08:13    27  ********
  77    2013-09-18 09:12    28  *********
  78    2013-09-18 10:11    29  **********
  79    2013-09-18 11:10    28  *********
  80    2013-09-18 12:09    26  *******
  81    2013-09-18 13:08    26  *******
  82    2013-09-18 14:07     ?  -
  83    2013-09-18 15:06    33  **************
  84    2013-09-18 16:05     ?  -
  85    2013-09-18 17:04    28  *********
  86    2013-09-18 18:03     ?  -
  87    2013-09-18 19:02    27  ********
  88    2013-09-18 20:01     ?  -
  89    2013-09-18 21:00    22  ***
  90    2013-09-18 21:59     ?  -
  91    2013-09-18 22:58    23  ****
  92    2013-09-18 23:57     ?  -
  93    2013-09-19 00:56    20  *
  94    2013-09-19 01:55    20  *
  95    2013-09-19 02:54    22  ***
  96    2013-09-19 03:53     ?  -
  97    2013-09-19 04:52    25  ******
  98    2013-09-19 05:51     ?  -
  99    2013-09-19 06:50    26  *******
 100    2013-09-19 07:49     ?  -
 101    2013-09-19 08:48    26  *******
 102    2013-09-19 09:47     ?  -
 103    2013-09-19 10:46    27  ********
 104    2013-09-19 11:45     ?  -
 105    2013-09-19 12:44    29  **********
 106    2013-09-19 13:43    29  **********
 107    2013-09-19 14:42    27  ********
 108    2013-09-19 15:41    26  *******
 109    2013-09-19 16:40    25  ******
 110    2013-09-19 17:39    25  ******
 111    2013-09-19 18:38    24  *****
 112    2013-09-19 19:37    24  *****
 113    2013-09-19 20:36    23  ****
 114    2013-09-19 21:35    23  ****
 115    2013-09-19 22:34    23  ****
 116    2013-09-19 23:33    22  ***
 117    2013-09-20 00:32    22  ***
 118    2013-09-20 01:31     ?  -
 119    2013-09-20 02:30    20  *
 120    2013-09-20 03:29     ?  -
 121    2013-09-20 04:28    21  **
 122    2013-09-20 05:27     ?  -
 123    2013-09-20 06:26    28  *********
 124    2013-09-20 07:25     ?  -
 125    2013-09-20 08:24    28  *********
 126    2013-09-20 09:23     ?  -
 127    2013-09-20 10:22    24  *****
   0    2013-09-20 11:21    24  *****
   1    2013-09-20 12:20    37  ******************
   2    2013-09-20 13:19    42  ***********************
   3    2013-09-20 14:18    26  *******
   4    2013-09-20 15:17     ?  -
   5    2013-09-20 16:16    31  ************
   6    2013-09-20 17:15     ?  -
   7    2013-09-20 18:14    34  ***************
   8    2013-09-20 19:13     ?  -
   9    2013-09-20 20:12    36  *****************
  10    2013-09-20 21:11     ?  -
  11    2013-09-20 22:10    39  ********************
  12    2013-09-20 23:09    39  ********************
  13    2013-09-21 00:08    40  *********************
  14    2013-09-21 01:07     ?  -
  15    2013-09-21 02:06    31  ************
  16    2013-09-21 03:05    31  ************
  17    2013-09-21 04:04    40  *********************
  18    2013-09-21 05:03    40  *********************
  19    2013-09-21 06:02    36  *****************
  20    2013-09-21 07:01    36  *****************
  21    2013-09-21 08:00    35  ****************
  22    2013-09-21 08:59    35  ****************
  23    2013-09-21 09:58    35  ****************
  24    2013-09-21 10:57    33  **************
 ...    ..(  7 skipped).    ..  **************
  32    2013-09-21 18:49    33  **************
  33    2013-09-21 19:48    34  ***************
  34    2013-09-21 20:47    35  ****************
  35    2013-09-21 21:46    35  ****************
  36    2013-09-21 22:45    36  *****************
  37    2013-09-21 23:44    36  *****************
  38    2013-09-22 00:43    37  ******************
  39    2013-09-22 01:42    36  *****************
 ...    ..( 10 skipped).    ..  *****************
  50    2013-09-22 12:31    36  *****************
  51    2013-09-22 13:30     ?  -
  52    2013-09-22 14:29    24  *****
  53    2013-09-22 15:28    24  *****

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            2  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS


Dave


On 22 September 2013 22:45, Dave Gomboc <dave_gomboc@acm.org> wrote:
> Yikes.  The data had been accessible on the evening of Sat. Sept 14.
[remainder snipped]

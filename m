From: Kyle Logue <teque5@gmail.com>
Subject: Re: Wierd: Degrading while recovering raid5
Date: Tue, 10 Feb 2015 16:50:45 -0500
Message-ID: <CAP7a4USu+650JJh9yX-WUU6eyxOGowa5r72W8JABCJpLnO=gtg@mail.gmail.com>
References: <CAP7a4UQCB=jdf7=sz8MoYL+WGbMbT_09_xL460DLX-epLAS0Sw@mail.gmail.com>
	<54D9B4AD.8010204@websitemanagers.com.au>
	<54DA0CDA.2010800@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DA0CDA.2010800@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phil:

Thanks for your detailed response. That link does seem to describe my
problem and I do understand that desktop grade drives are sub-optimal.
It was many years ago when I first set up this array on my home
theater pc.  Until now I had no idea about the cron job - I'll make
sure to implement that. I am preparing to move to 6 tb disks sometime
soon and i'll definitely go enterprise this time.

Regarding the drive timeout: I understand that I need to increase it
from 30 seconds to something larger (2+ min) but am unaware how to do
this. Is it a kernel variable? I'll keep googling but this seems like
it's whats going to save me.

tl;dr: How do I change the drive timeout?

Here is the smartctl -x for all my drives:

Reminder: SDA is the new drive. SDC is the troublemaker. SDE is the
one I failed.

> sudo smartctl -x /dev/sda
> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-45-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> === START OF INFORMATION SECTION ===
> Model Family:     Seagate Barracuda 7200.14 (AF)
> Device Model:     ST2000DM001-1CH164
> Serial Number:    Z340F2SP
> LU WWN Device Id: 5 000c50 064d5887d
> Firmware Version: CC27
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    7200 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Tue Feb 10 16:37:52 2015 EST
> ==> WARNING: A firmware update for this drive may be available,
> see the following Seagate web pages:
> http://knowledge.seagate.com/articles/en_US/FAQ/207931en
> http://knowledge.seagate.com/articles/en_US/FAQ/223651en
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Unavailable
> APM level is:     254 (maximum performance)
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Write SCT (Get) XXX Error Recovery Control Command failed: scsi error aborted command
> Wt Cache Reorder: N/A
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> General SMART Values:
> Offline data collection status:  (0x82) Offline data collection activity
>                                         was completed without error.
>                                         Auto Offline Data Collection: Enabled.
> Self-test execution status:      (   0) The previous self-test routine completed
>                                         without error or no self-test has ever
>                                         been run.
> Total time to complete Offline
> data collection:                (  584) seconds.
> Offline data collection
> capabilities:                    (0x7b) SMART execute Offline immediate.
>                                         Auto Offline data collection on/off support.
>                                         Suspend Offline collection upon new
>                                         command.
>                                         Offline surface scan supported.
>                                         Self-test supported.
>                                         Conveyance Self-test supported.
>                                         Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before entering
>                                         power-saving mode.
>                                         Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
>                                         General Purpose Logging supported.
> Short self-test routine
> recommended polling time:        (   1) minutes.
> Extended self-test routine
> recommended polling time:        ( 212) minutes.
> Conveyance self-test routine
> recommended polling time:        (   2) minutes.
> SCT capabilities:              (0x3085) SCT Status supported.
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   1 Raw_Read_Error_Rate     POSR--   105   099   006    -    9806192
>   3 Spin_Up_Time            PO----   097   097   000    -    0
>   4 Start_Stop_Count        -O--CK   100   100   020    -    4
>   5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
>   7 Seek_Error_Rate         POSR--   100   253   030    -    289070
>   9 Power_On_Hours          -O--CK   100   100   000    -    35
>  10 Spin_Retry_Count        PO--C-   100   100   097    -    0
>  12 Power_Cycle_Count       -O--CK   100   100   020    -    5
> 183 Runtime_Bad_Block       -O--CK   099   099   000    -    1
> 184 End-to-End_Error        -O--CK   100   100   099    -    0
> 187 Reported_Uncorrect      -O--CK   100   100   000    -    0
> 188 Command_Timeout         -O--CK   100   100   000    -    0 0 0
> 189 High_Fly_Writes         -O-RCK   100   100   000    -    0
> 190 Airflow_Temperature_Cel -O---K   073   062   045    -    27 (Min/Max 25/27)
> 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    4
> 193 Load_Cycle_Count        -O--CK   100   100   000    -    8
> 194 Temperature_Celsius     -O---K   027   040   000    -    27 (0 22 0 0 0)
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
> 198 Offline_Uncorrectable   ----C-   100   100   000    -    0
> 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
> 240 Head_Flying_Hours       ------   100   253   000    -    35h+41m+13.042s
> 241 Total_LBAs_Written      ------   100   253   000    -    11031892416
> 242 Total_LBAs_Read         ------   100   253   000    -    2769646
>                             ||||||_ K auto-keep
>                             |||||__ C event count
>                             ||||___ R error rate
>                             |||____ S speed/performance
>                             ||_____ O updated online
>                             |______ P prefailure warning
> General Purpose Log Directory Version 1
> SMART           Log Directory Version 1 [multi-sector log support]
> Address    Access  R/W   Size  Description
> 0x00       GPL,SL  R/O      1  Log Directory
> 0x01           SL  R/O      1  Summary SMART error log
> 0x02           SL  R/O      5  Comprehensive SMART error log
> 0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
> 0x06           SL  R/O      1  SMART self-test log
> 0x07       GPL     R/O      1  Extended self-test log
> 0x09           SL  R/W      1  Selective self-test log
> 0x10       GPL     R/O      1  NCQ Command Error log
> 0x11       GPL     R/O      1  SATA Phy Event Counters
> 0x21       GPL     R/O      1  Write stream error log
> 0x22       GPL     R/O      1  Read stream error log
> 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
> 0xa1       GPL,SL  VS      20  Device vendor specific log
> 0xa2       GPL     VS    4496  Device vendor specific log
> 0xa8       GPL,SL  VS     129  Device vendor specific log
> 0xa9       GPL,SL  VS       1  Device vendor specific log
> 0xab       GPL     VS       1  Device vendor specific log
> 0xb0       GPL     VS    5176  Device vendor specific log
> 0xbe-0xbf  GPL     VS   65535  Device vendor specific log
> 0xc0       GPL,SL  VS       1  Device vendor specific log
> 0xc1       GPL,SL  VS      10  Device vendor specific log
> 0xc4       GPL,SL  VS       5  Device vendor specific log
> 0xe0       GPL,SL  R/W      1  SCT Command/Status
> 0xe1       GPL,SL  R/W      1  SCT Data Transfer
> SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
> No Errors Logged
> SMART Extended Self-test Log Version: 1 (1 sectors)
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
> SMART Selective self-test log data structure revision number 1
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Not_testing
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute delay.
> SCT Data Table command not supported
> SCT Error Recovery Control command not supported
> Device Statistics (GP Log 0x04) not supported
> SATA Phy Event Counters (GP Log 0x11)
> ID      Size     Value  Description
> 0x000a  2            6  Device-to-host register FISes sent due to a COMRESET
> 0x0001  2            0  Command failed due to ICRC error
> 0x0003  2            0  R_ERR response for device-to-host data FIS
> 0x0004  2            0  R_ERR response for host-to-device data FIS
> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
>
> sudo smartctl -x /dev/sdb
> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-45-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> === START OF INFORMATION SECTION ===
> Model Family:     Seagate Barracuda 7200.14 (AF)
> Device Model:     ST2000DM001-1CH164
> Serial Number:    S1E1CW9Y
> LU WWN Device Id: 5 000c50 05c085bef
> Firmware Version: CC24
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    7200 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Tue Feb 10 16:40:24 2015 EST
> ==> WARNING: A firmware update for this drive may be available,
> see the following Seagate web pages:
> http://knowledge.seagate.com/articles/en_US/FAQ/207931en
> http://knowledge.seagate.com/articles/en_US/FAQ/223651en
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Unavailable
> APM level is:     254 (maximum performance)
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Write SCT (Get) XXX Error Recovery Control Command failed: scsi error aborted command
> Wt Cache Reorder: N/A
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> General SMART Values:
> Offline data collection status:  (0x82) Offline data collection activity
>                                         was completed without error.
>                                         Auto Offline Data Collection: Enabled.
> Self-test execution status:      (   0) The previous self-test routine completed
>                                         without error or no self-test has ever
>                                         been run.
> Total time to complete Offline
> data collection:                (  584) seconds.
> Offline data collection
> capabilities:                    (0x7b) SMART execute Offline immediate.
>                                         Auto Offline data collection on/off support.
>                                         Suspend Offline collection upon new
>                                         command.
>                                         Offline surface scan supported.
>                                         Self-test supported.
>                                         Conveyance Self-test supported.
>                                         Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before entering
>                                         power-saving mode.
>                                         Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
>                                         General Purpose Logging supported.
> Short self-test routine
> recommended polling time:        (   1) minutes.
> Extended self-test routine
> recommended polling time:        ( 225) minutes.
> Conveyance self-test routine
> recommended polling time:        (   2) minutes.
> SCT capabilities:              (0x3085) SCT Status supported.
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   1 Raw_Read_Error_Rate     POSR--   117   099   006    -    153090384
>   3 Spin_Up_Time            PO----   096   096   000    -    0
>   4 Start_Stop_Count        -O--CK   100   100   020    -    58
>   5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
>   7 Seek_Error_Rate         POSR--   063   058   030    -    8594213138
>   9 Power_On_Hours          -O--CK   084   084   000    -    14743
>  10 Spin_Retry_Count        PO--C-   100   100   097    -    0
>  12 Power_Cycle_Count       -O--CK   100   100   020    -    58
> 183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
> 184 End-to-End_Error        -O--CK   100   100   099    -    0
> 187 Reported_Uncorrect      -O--CK   100   100   000    -    0
> 188 Command_Timeout         -O--CK   100   099   000    -    1 1 1
> 189 High_Fly_Writes         -O-RCK   100   100   000    -    0
> 190 Airflow_Temperature_Cel -O---K   072   057   045    -    28 (Min/Max 26/28)
> 191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    34
> 193 Load_Cycle_Count        -O--CK   100   100   000    -    110
> 194 Temperature_Celsius     -O---K   028   043   000    -    28 (0 18 0 0 0)
> 197 Current_Pending_Sector  -O--C-   100   100   000    -    0
> 198 Offline_Uncorrectable   ----C-   100   100   000    -    0
> 199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
> 240 Head_Flying_Hours       ------   100   253   000    -    14740h+55m+31.297s
> 241 Total_LBAs_Written      ------   100   253   000    -    9249405614
> 242 Total_LBAs_Read         ------   100   253   000    -    100539385901
>                             ||||||_ K auto-keep
>                             |||||__ C event count
>                             ||||___ R error rate
>                             |||____ S speed/performance
>                             ||_____ O updated online
>                             |______ P prefailure warning
> General Purpose Log Directory Version 1
> SMART           Log Directory Version 1 [multi-sector log support]
> Address    Access  R/W   Size  Description
> 0x00       GPL,SL  R/O      1  Log Directory
> 0x01           SL  R/O      1  Summary SMART error log
> 0x02           SL  R/O      5  Comprehensive SMART error log
> 0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
> 0x06           SL  R/O      1  SMART self-test log
> 0x07       GPL     R/O      1  Extended self-test log
> 0x09           SL  R/W      1  Selective self-test log
> 0x10       GPL     R/O      1  NCQ Command Error log
> 0x11       GPL     R/O      1  SATA Phy Event Counters
> 0x21       GPL     R/O      1  Write stream error log
> 0x22       GPL     R/O      1  Read stream error log
> 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
> 0xa1       GPL,SL  VS      20  Device vendor specific log
> 0xa2       GPL     VS    4496  Device vendor specific log
> 0xa8       GPL,SL  VS     129  Device vendor specific log
> 0xa9       GPL,SL  VS       1  Device vendor specific log
> 0xab       GPL     VS       1  Device vendor specific log
> 0xb0       GPL     VS    5176  Device vendor specific log
> 0xbd       GPL     VS     512  Device vendor specific log
> 0xbe-0xbf  GPL     VS   65535  Device vendor specific log
> 0xc0       GPL,SL  VS       1  Device vendor specific log
> 0xc1       GPL,SL  VS      10  Device vendor specific log
> 0xc4       GPL,SL  VS       5  Device vendor specific log
> 0xe0       GPL,SL  R/W      1  SCT Command/Status
> 0xe1       GPL,SL  R/W      1  SCT Data Transfer
> SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
> No Errors Logged
> SMART Extended Self-test Log Version: 1 (1 sectors)
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
> SMART Selective self-test log data structure revision number 1
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Not_testing
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute delay.
> SCT Data Table command not supported
> SCT Error Recovery Control command not supported
> Device Statistics (GP Log 0x04) not supported
> SATA Phy Event Counters (GP Log 0x11)
> ID      Size     Value  Description
> 0x000a  2            6  Device-to-host register FISes sent due to a COMRESET
> 0x0001  2            0  Command failed due to ICRC error
> 0x0003  2            0  R_ERR response for device-to-host data FIS
> 0x0004  2            0  R_ERR response for host-to-device data FIS
> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
> THIS IS THE BAD DISK:
> sudo smartctl -x /dev/sdc
> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-45-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> === START OF INFORMATION SECTION ===
> Model Family:     Seagate Barracuda 7200.14 (AF)
> Device Model:     ST2000DM001-1CH164
> Serial Number:    S240V6VR
> LU WWN Device Id: 5 000c50 05c05c2e7
> Firmware Version: CC24
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    7200 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Tue Feb 10 16:42:53 2015 EST
> ==> WARNING: A firmware update for this drive may be available,
> see the following Seagate web pages:
> http://knowledge.seagate.com/articles/en_US/FAQ/207931en
> http://knowledge.seagate.com/articles/en_US/FAQ/223651en
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Unavailable
> APM level is:     254 (maximum performance)
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Write SCT (Get) XXX Error Recovery Control Command failed: scsi error aborted command
> Wt Cache Reorder: N/A
> Read SMART Data failed: scsi error aborted command
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: UNKNOWN!
> SMART Status, Attributes and Thresholds cannot be read.
> General Purpose Log Directory Version 1
> SMART           Log Directory Version 1 [multi-sector log support]
> Address    Access  R/W   Size  Description
> 0x00       GPL,SL  R/O      1  Log Directory
> 0x01           SL  R/O      1  Summary SMART error log
> 0x02           SL  R/O      5  Comprehensive SMART error log
> 0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
> 0x06           SL  R/O      1  SMART self-test log
> 0x07       GPL     R/O      1  Extended self-test log
> 0x09           SL  R/W      1  Selective self-test log
> 0x10       GPL     R/O      1  NCQ Command Error log
> 0x11       GPL     R/O      1  SATA Phy Event Counters
> 0x21       GPL     R/O      1  Write stream error log
> 0x22       GPL     R/O      1  Read stream error log
> 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
> 0xa1       GPL,SL  VS      20  Device vendor specific log
> 0xa2       GPL     VS    4496  Device vendor specific log
> 0xa8       GPL,SL  VS     129  Device vendor specific log
> 0xa9       GPL,SL  VS       1  Device vendor specific log
> 0xab       GPL     VS       1  Device vendor specific log
> 0xb0       GPL     VS    5176  Device vendor specific log
> 0xbd       GPL     VS     512  Device vendor specific log
> 0xbe-0xbf  GPL     VS   65535  Device vendor specific log
> 0xc0       GPL,SL  VS       1  Device vendor specific log
> 0xc1       GPL,SL  VS      10  Device vendor specific log
> 0xc4       GPL,SL  VS       5  Device vendor specific log
> 0xe0       GPL,SL  R/W      1  SCT Command/Status
> 0xe1       GPL,SL  R/W      1  SCT Data Transfer
> SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
> Device Error Count: 9
>         CR     = Command Register
>         FEATR  = Features Register
>         COUNT  = Count (was: Sector Count) Register
>         LBA_48 = Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
>         LH     = LBA High (was: Cylinder High) Register    ]   LBA
>         LM     = LBA Mid (was: Cylinder Low) Register      ] Register
>         LL     = LBA Low (was: Sector Number) Register     ]
>         DV     = Device (was: Device/Head) Register
>         DC     = Device Control Register
>         ER     = Error register
>         ST     = Status register
> Powered_Up_Time is measured from power on, and printed as
> DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
> SS=sec, and sss=millisec. It "wraps" after 49.710 days.
> Error 9 [8] occurred at disk power-on lifetime: 14697 hours (612 days + 9 hours)
>   When the command that caused the error occurred, the device was active or idle.
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   40 -- 51 00 00 00 00 a4 1c 1d e8 00 00  Error: UNC at LBA = 0xa41c1de8 = 2753306088
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 00 00 80 00 00 a4 1c 1d e8 e0 00     04:55:26.791  READ DMA EXT
>   25 00 00 04 00 00 00 a4 1c 21 00 e0 00     04:55:26.776  READ DMA EXT
>   ef 00 10 00 02 00 00 00 00 00 00 a0 00     04:55:26.775  SET FEATURES [Enable SATA feature]
>   27 00 00 00 00 00 00 00 00 00 00 e0 00     04:55:26.775  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
>   ec 00 00 00 00 00 00 00 00 00 00 a0 00     04:55:26.774  IDENTIFY DEVICE
> Error 8 [7] occurred at disk power-on lifetime: 14697 hours (612 days + 9 hours)
>   When the command that caused the error occurred, the device was active or idle.
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   40 -- 51 00 00 00 00 a4 1c 1d e8 00 00  Error: UNC at LBA = 0xa41c1de8 = 2753306088
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 00 04 00 00 00 a4 1c 1d 00 e0 00     04:55:23.631  READ DMA EXT
>   25 00 00 04 00 00 00 a4 1c 19 00 e0 00     04:55:23.553  READ DMA EXT
>   25 00 00 04 00 00 00 a4 1c 15 00 e0 00     04:55:23.108  READ DMA EXT
>   25 00 00 04 00 00 00 a4 1c 11 00 e0 00     04:55:23.004  READ DMA EXT
>   25 00 00 04 00 00 00 a4 1c 0d 00 e0 00     04:55:22.893  READ DMA EXT
> Error 7 [6] occurred at disk power-on lifetime: 14686 hours (611 days + 22 hours)
>   When the command that caused the error occurred, the device was active or idle.
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   40 -- 51 00 00 00 00 a4 1c 1d e8 00 00  Error: UNC at LBA = 0xa41c1de8 = 2753306088
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 00 03 c0 00 00 a4 1c 1d e8 e0 00  1d+00:26:44.862  READ DMA EXT
>   25 00 00 00 08 00 00 a4 1c 21 a8 e0 00  1d+00:26:44.852  READ DMA EXT
>   ec 00 00 00 01 00 00 00 00 00 00 00 00  1d+00:26:44.851  IDENTIFY DEVICE
>   ec 00 00 00 01 00 00 00 00 00 00 00 00  1d+00:26:44.851  IDENTIFY DEVICE
>   e5 00 00 00 00 00 00 00 00 00 00 00 00  1d+00:26:44.851  CHECK POWER MODE
> Error 6 [5] occurred at disk power-on lifetime: 14686 hours (611 days + 22 hours)
>   When the command that caused the error occurred, the device was active or idle.
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   40 -- 51 00 00 00 00 a4 1c 1d e8 00 00  Error: UNC at LBA = 0xa41c1de8 = 2753306088
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 00 04 00 00 00 a4 1c 1d a8 e0 00  1d+00:26:30.653  READ DMA EXT
>   ef 00 90 00 03 00 00 00 00 00 00 a0 00  1d+00:26:30.638  SET FEATURES [Disable SATA feature]
>   ef 00 10 00 02 00 00 00 00 00 00 a0 00  1d+00:26:30.638  SET FEATURES [Enable SATA feature]
>   27 00 00 00 00 00 00 00 00 00 00 e0 00  1d+00:26:30.638  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
>   ec 00 00 00 00 00 00 00 00 00 00 a0 00  1d+00:26:30.638  IDENTIFY DEVICE
> Error 5 [4] occurred at disk power-on lifetime: 14676 hours (611 days + 12 hours)
>   When the command that caused the error occurred, the device was active or idle.
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   40 -- 51 00 00 00 00 a4 1c 1d e8 00 00  Error: UNC at LBA = 0xa41c1de8 = 2753306088
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 00 00 a8 00 00 a4 1c 1d e8 e0 00     14:43:09.384  READ DMA EXT
>   e5 00 00 00 00 00 00 00 00 00 00 00 00     14:43:09.383  CHECK POWER MODE
>   25 00 00 04 00 00 00 a4 1c 1e 90 e0 00     14:43:09.371  READ DMA EXT
>   ef 00 10 00 02 00 00 00 00 00 00 a0 00     14:43:09.370  SET FEATURES [Enable SATA feature]
>   27 00 00 00 00 00 00 00 00 00 00 e0 00     14:43:09.370  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
> Error 4 [3] occurred at disk power-on lifetime: 14676 hours (611 days + 12 hours)
>   When the command that caused the error occurred, the device was active or idle.
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   40 -- 51 00 00 00 00 a4 1c 1d e8 00 00  Error: UNC at LBA = 0xa41c1de8 = 2753306088
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 00 04 00 00 00 a4 1c 1a 90 e0 00     14:43:06.283  READ DMA EXT
>   25 00 00 04 00 00 00 a4 1c 16 90 e0 00     14:43:06.205  READ DMA EXT
>   25 00 00 04 00 00 00 a4 1c 12 90 e0 00     14:43:04.892  READ DMA EXT
>   25 00 00 04 00 00 00 a4 1c 0e 90 e0 00     14:43:04.855  READ DMA EXT
>   25 00 00 04 00 00 00 a4 1c 0a 90 e0 00     14:43:04.819  READ DMA EXT
> Error 3 [2] occurred at disk power-on lifetime: 14670 hours (611 days + 6 hours)
>   When the command that caused the error occurred, the device was active or idle.
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   40 -- 51 00 00 00 00 a4 1c 1d e8 00 00  Error: UNC at LBA = 0xa41c1de8 = 2753306088
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 00 04 00 00 00 a4 1c 1a 00 e0 00     08:33:02.502  READ DMA EXT
>   ef 00 10 00 02 00 00 00 00 00 00 a0 00     08:33:02.501  SET FEATURES [Enable SATA feature]
>   27 00 00 00 00 00 00 00 00 00 00 e0 00     08:33:02.501  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
>   ec 00 00 00 00 00 00 00 00 00 00 a0 00     08:33:02.501  IDENTIFY DEVICE
>   ef 00 03 00 42 00 00 00 00 00 00 a0 00     08:33:02.501  SET FEATURES [Set transfer mode]
> Error 2 [1] occurred at disk power-on lifetime: 14670 hours (611 days + 6 hours)
>   When the command that caused the error occurred, the device was active or idle.
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   40 -- 51 00 00 00 00 a4 1c 13 d0 00 00  Error: UNC at LBA = 0xa41c13d0 = 2753303504
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 00 02 30 00 00 a4 1c 13 d0 e0 00     08:32:59.645  READ DMA EXT
>   e5 00 00 00 00 00 00 00 00 00 00 00 00     08:32:59.643  CHECK POWER MODE
>   25 00 00 04 00 00 00 a4 1c 16 00 e0 00     08:32:59.581  READ DMA EXT
>   ef 00 10 00 02 00 00 00 00 00 00 a0 00     08:32:59.580  SET FEATURES [Enable SATA feature]
>   27 00 00 00 00 00 00 00 00 00 00 e0 00     08:32:59.580  READ NATIVE MAX ADDRESS EXT [OBS-ACS-3]
> SMART Extended Self-test Log Version: 1 (1 sectors)
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
> Selective Self-tests/Logging not supported
> SCT Data Table command not supported
> SCT Error Recovery Control command not supported
> Device Statistics (GP Log 0x04) not supported
> SATA Phy Event Counters (GP Log 0x11)
> ID      Size     Value  Description
> 0x000a  2            6  Device-to-host register FISes sent due to a COMRESET
> 0x0001  2            0  Command failed due to ICRC error
> 0x0003  2            0  R_ERR response for device-to-host data FIS
> 0x0004  2            0  R_ERR response for host-to-device data FIS
> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
> sudo smartctl -x /dev/sdd
> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-45-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> === START OF INFORMATION SECTION ===
> Model Family:     Hitachi Deskstar 7K3000
> Device Model:     Hitachi HDS723020BLA642
> Serial Number:    MN3220F32GX10E
> LU WWN Device Id: 5 000cca 369e2f56f
> Firmware Version: MN6OA5C0
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    7200 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 2.6, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Tue Feb 10 16:45:04 2015 EST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Unavailable
> APM feature is:   Disabled
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> General SMART Values:
> Offline data collection status:  (0x84) Offline data collection activity
>                                         was suspended by an interrupting command from host.
>                                         Auto Offline Data Collection: Enabled.
> Self-test execution status:      (   0) The previous self-test routine completed
>                                         without error or no self-test has ever
>                                         been run.
> Total time to complete Offline
> data collection:                (18096) seconds.
> Offline data collection
> capabilities:                    (0x5b) SMART execute Offline immediate.
>                                         Auto Offline data collection on/off support.
>                                         Suspend Offline collection upon new
>                                         command.
>                                         Offline surface scan supported.
>                                         Self-test supported.
>                                         No Conveyance Self-test supported.
>                                         Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before entering
>                                         power-saving mode.
>                                         Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
>                                         General Purpose Logging supported.
> Short self-test routine
> recommended polling time:        (   1) minutes.
> Extended self-test routine
> recommended polling time:        ( 302) minutes.
> SCT capabilities:              (0x003d) SCT Status supported.
>                                         SCT Error Recovery Control supported.
>                                         SCT Feature Control supported.
>                                         SCT Data Table supported.
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
>   2 Throughput_Performance  P-S---   136   136   054    -    82
>   3 Spin_Up_Time            POS---   152   152   024    -    434 (Average 320)
>   4 Start_Stop_Count        -O--C-   100   100   000    -    97
>   5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
>   7 Seek_Error_Rate         PO-R--   100   100   067    -    0
>   8 Seek_Time_Performance   P-S---   135   135   020    -    26
>   9 Power_On_Hours          -O--C-   097   097   000    -    27235
>  10 Spin_Retry_Count        PO--C-   100   100   060    -    0
>  12 Power_Cycle_Count       -O--CK   100   100   000    -    97
> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    755
> 193 Load_Cycle_Count        -O--C-   100   100   000    -    755
> 194 Temperature_Celsius     -O----   200   200   000    -    30 (Min/Max 19/45)
> 196 Reallocated_Event_Count -O--CK   100   100   000    -    0
> 197 Current_Pending_Sector  -O---K   100   100   000    -    0
> 198 Offline_Uncorrectable   ---R--   100   100   000    -    0
> 199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    0
>                             ||||||_ K auto-keep
>                             |||||__ C event count
>                             ||||___ R error rate
>                             |||____ S speed/performance
>                             ||_____ O updated online
>                             |______ P prefailure warning
> General Purpose Log Directory Version 1
> SMART           Log Directory Version 1 [multi-sector log support]
> Address    Access  R/W   Size  Description
> 0x00       GPL,SL  R/O      1  Log Directory
> 0x01           SL  R/O      1  Summary SMART error log
> 0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
> 0x04       GPL     R/O      7  Device Statistics log
> 0x06           SL  R/O      1  SMART self-test log
> 0x07       GPL     R/O      1  Extended self-test log
> 0x08       GPL     R/O      1  Power Conditions log
> 0x09           SL  R/W      1  Selective self-test log
> 0x10       GPL     R/O      1  NCQ Command Error log
> 0x11       GPL     R/O      1  SATA Phy Event Counters
> 0x20       GPL     R/O      1  Streaming performance log [OBS-8]
> 0x21       GPL     R/O      1  Write stream error log
> 0x22       GPL     R/O      1  Read stream error log
> 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
> 0xe0       GPL,SL  R/W      1  SCT Command/Status
> 0xe1       GPL,SL  R/W      1  SCT Data Transfer
> SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
> No Errors Logged
> SMART Extended Self-test Log Version: 1 (1 sectors)
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
> SMART Selective self-test log data structure revision number 1
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Not_testing
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute delay.
> SCT Status Version:                  3
> SCT Version (vendor specific):       256 (0x0100)
> SCT Support Level:                   1
> Device State:                        SMART Off-line Data Collection executing in background (4)
> Current Temperature:                    30 Celsius
> Power Cycle Min/Max Temperature:     27/30 Celsius
> Lifetime    Min/Max Temperature:     19/45 Celsius
> Under/Over Temperature Limit Count:   0/0
> SCT Temperature History Version:     2
> Temperature Sampling Period:         1 minute
> Temperature Logging Interval:        1 minute
> Min/Max recommended Temperature:      0/60 Celsius
> Min/Max Temperature Limit:           -40/70 Celsius
> Temperature History Size (Index):    128 (52)
> Index    Estimated Time   Temperature Celsius
>   53    2015-02-10 14:38    37  ******************
>  ...    ..( 24 skipped).    ..  ******************
>   78    2015-02-10 15:03    37  ******************
>   79    2015-02-10 15:04    36  *****************
>   80    2015-02-10 15:05    36  *****************
>   81    2015-02-10 15:06    37  ******************
>  ...    ..(  5 skipped).    ..  ******************
>   87    2015-02-10 15:12    37  ******************
>   88    2015-02-10 15:13    36  *****************
>   89    2015-02-10 15:14    37  ******************
>  ...    ..(  5 skipped).    ..  ******************
>   95    2015-02-10 15:20    37  ******************
>   96    2015-02-10 15:21    36  *****************
>   97    2015-02-10 15:22    37  ******************
>   98    2015-02-10 15:23    37  ******************
>   99    2015-02-10 15:24    36  *****************
>  100    2015-02-10 15:25    37  ******************
>  ...    ..(  4 skipped).    ..  ******************
>  105    2015-02-10 15:30    37  ******************
>  106    2015-02-10 15:31    36  *****************
>  107    2015-02-10 15:32    36  *****************
>  108    2015-02-10 15:33    37  ******************
>  ...    ..(  6 skipped).    ..  ******************
>  115    2015-02-10 15:40    37  ******************
>  116    2015-02-10 15:41    36  *****************
>  117    2015-02-10 15:42    36  *****************
>  118    2015-02-10 15:43    36  *****************
>  119    2015-02-10 15:44    37  ******************
>  ...    ..(  2 skipped).    ..  ******************
>  122    2015-02-10 15:47    37  ******************
>  123    2015-02-10 15:48    36  *****************
>  124    2015-02-10 15:49    37  ******************
>  125    2015-02-10 15:50    37  ******************
>  126    2015-02-10 15:51    36  *****************
>  127    2015-02-10 15:52    36  *****************
>    0    2015-02-10 15:53    37  ******************
>    1    2015-02-10 15:54    36  *****************
>    2    2015-02-10 15:55    37  ******************
>    3    2015-02-10 15:56    36  *****************
>    4    2015-02-10 15:57    36  *****************
>    5    2015-02-10 15:58    37  ******************
>  ...    ..(  2 skipped).    ..  ******************
>    8    2015-02-10 16:01    37  ******************
>    9    2015-02-10 16:02    36  *****************
>   10    2015-02-10 16:03    37  ******************
>  ...    ..(  2 skipped).    ..  ******************
>   13    2015-02-10 16:06    37  ******************
>   14    2015-02-10 16:07    36  *****************
>   15    2015-02-10 16:08    37  ******************
>  ...    ..( 10 skipped).    ..  ******************
>   26    2015-02-10 16:19    37  ******************
>   27    2015-02-10 16:20    36  *****************
>  ...    ..(  5 skipped).    ..  *****************
>   33    2015-02-10 16:26    36  *****************
>   34    2015-02-10 16:27    37  ******************
>  ...    ..(  4 skipped).    ..  ******************
>   39    2015-02-10 16:32    37  ******************
>   40    2015-02-10 16:33     ?  -
>   41    2015-02-10 16:34    27  ********
>   42    2015-02-10 16:35    28  *********
>   43    2015-02-10 16:36    28  *********
>   44    2015-02-10 16:37    28  *********
>   45    2015-02-10 16:38    29  **********
>  ...    ..(  2 skipped).    ..  **********
>   48    2015-02-10 16:41    29  **********
>   49    2015-02-10 16:42    30  ***********
>  ...    ..(  2 skipped).    ..  ***********
>   52    2015-02-10 16:45    30  ***********
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled
> Device Statistics (GP Log 0x04)
> Page Offset Size         Value  Description
>   1  =====  =                =  == General Statistics (rev 1) ==
>   1  0x008  4               97  Lifetime Power-On Resets
>   1  0x010  4            27235  Power-on Hours
>   1  0x018  6      11734342067  Logical Sectors Written
>   1  0x020  6         27559380  Number of Write Commands
>   1  0x028  6    2738754035727  Logical Sectors Read
>   1  0x030  6       5733165681  Number of Read Commands
>   3  =====  =                =  == Rotating Media Statistics (rev 1) ==
>   3  0x008  4            27229  Spindle Motor Power-on Hours
>   3  0x010  4            27229  Head Flying Hours
>   3  0x018  4              755  Head Load Events
>   3  0x020  4                0  Number of Reallocated Logical Sectors
>   3  0x028  4              276  Read Recovery Attempts
>   3  0x030  4                7  Number of Mechanical Start Failures
>   4  =====  =                =  == General Errors Statistics (rev 1) ==
>   4  0x008  4                0  Number of Reported Uncorrectable Errors
>   4  0x010  4                2  Resets Between Cmd Acceptance and Completion
>   5  =====  =                =  == Temperature Statistics (rev 1) ==
>   5  0x008  1               30  Current Temperature
>   5  0x010  1               35~ Average Short Term Temperature
>   5  0x018  1               33~ Average Long Term Temperature
>   5  0x020  1               45  Highest Temperature
>   5  0x028  1               19  Lowest Temperature
>   5  0x030  1               42~ Highest Average Short Term Temperature
>   5  0x038  1               24~ Lowest Average Short Term Temperature
>   5  0x040  1               39~ Highest Average Long Term Temperature
>   5  0x048  1               25~ Lowest Average Long Term Temperature
>   5  0x050  4                0  Time in Over-Temperature
>   5  0x058  1               60  Specified Maximum Operating Temperature
>   5  0x060  4                0  Time in Under-Temperature
>   5  0x068  1                0  Specified Minimum Operating Temperature
>   6  =====  =                =  == Transport Statistics (rev 1) ==
>   6  0x008  4             1122  Number of Hardware Resets
>   6  0x010  4             1027  Number of ASR Events
>   6  0x018  4                0  Number of Interface CRC Errors
>                               |_ ~ normalized value
> SATA Phy Event Counters (GP Log 0x11)
> ID      Size     Value  Description
> 0x0001  2            0  Command failed due to ICRC error
> 0x0002  2            0  R_ERR response for data FIS
> 0x0003  2            0  R_ERR response for device-to-host data FIS
> 0x0004  2            0  R_ERR response for host-to-device data FIS
> 0x0005  2            0  R_ERR response for non-data FIS
> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
> 0x0009  2            6  Transition from drive PhyRdy to drive PhyNRdy
> 0x000a  2            5  Device-to-host register FISes sent due to a COMRESET
> 0x000b  2            0  CRC errors within host-to-device FIS
> 0x000d  2            0  Non-CRC errors within host-to-device FIS
> sudo smartctl -x /dev/sde
> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-45-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> === START OF INFORMATION SECTION ===
> Model Family:     Hitachi Deskstar 7K2000
> Device Model:     Hitachi HDS722020ALA330
> Serial Number:    JK1171YAGAD8LS
> LU WWN Device Id: 5 000cca 221c4b9cc
> Firmware Version: JKAOA20N
> User Capacity:    2,000,398,934,016 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    7200 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 2.6, 3.0 Gb/s
> Local Time is:    Tue Feb 10 16:45:31 2015 EST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Disabled
> APM feature is:   Disabled
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> General SMART Values:
> Offline data collection status:  (0x84) Offline data collection activity
>                                         was suspended by an interrupting command from host.
>                                         Auto Offline Data Collection: Enabled.
> Self-test execution status:      (   0) The previous self-test routine completed
>                                         without error or no self-test has ever
>                                         been run.
> Total time to complete Offline
> data collection:                (21007) seconds.
> Offline data collection
> capabilities:                    (0x5b) SMART execute Offline immediate.
>                                         Auto Offline data collection on/off support.
>                                         Suspend Offline collection upon new
>                                         command.
>                                         Offline surface scan supported.
>                                         Self-test supported.
>                                         No Conveyance Self-test supported.
>                                         Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before entering
>                                         power-saving mode.
>                                         Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
>                                         General Purpose Logging supported.
> Short self-test routine
> recommended polling time:        (   1) minutes.
> Extended self-test routine
> recommended polling time:        ( 350) minutes.
> SCT capabilities:              (0x003d) SCT Status supported.
>                                         SCT Error Recovery Control supported.
>                                         SCT Feature Control supported.
>                                         SCT Data Table supported.
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
>   2 Throughput_Performance  P-S---   134   134   054    -    98
>   3 Spin_Up_Time            POS---   137   137   024    -    619 (Average 439)
>   4 Start_Stop_Count        -O--C-   100   100   000    -    207
>   5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
>   7 Seek_Error_Rate         PO-R--   100   100   067    -    0
>   8 Seek_Time_Performance   P-S---   112   112   020    -    39
>   9 Power_On_Hours          -O--C-   094   094   000    -    44002
>  10 Spin_Retry_Count        PO--C-   100   100   060    -    0
>  12 Power_Cycle_Count       -O--CK   100   100   000    -    207
> 192 Power-Off_Retract_Count -O--CK   099   099   000    -    1267
> 193 Load_Cycle_Count        -O--C-   099   099   000    -    1267
> 194 Temperature_Celsius     -O----   181   181   000    -    33 (Min/Max 20/53)
> 196 Reallocated_Event_Count -O--CK   100   100   000    -    0
> 197 Current_Pending_Sector  -O---K   100   100   000    -    0
> 198 Offline_Uncorrectable   ---R--   100   100   000    -    0
> 199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    9
>                             ||||||_ K auto-keep
>                             |||||__ C event count
>                             ||||___ R error rate
>                             |||____ S speed/performance
>                             ||_____ O updated online
>                             |______ P prefailure warning
> General Purpose Log Directory Version 1
> SMART           Log Directory Version 1 [multi-sector log support]
> Address    Access  R/W   Size  Description
> 0x00       GPL,SL  R/O      1  Log Directory
> 0x01           SL  R/O      1  Summary SMART error log
> 0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
> 0x04       GPL     R/O      7  Device Statistics log
> 0x06           SL  R/O      1  SMART self-test log
> 0x07       GPL     R/O      1  Extended self-test log
> 0x09           SL  R/W      1  Selective self-test log
> 0x10       GPL     R/O      1  NCQ Command Error log
> 0x11       GPL     R/O      1  SATA Phy Event Counters
> 0x20       GPL     R/O      1  Streaming performance log [OBS-8]
> 0x21       GPL     R/O      1  Write stream error log
> 0x22       GPL     R/O      1  Read stream error log
> 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
> 0xe0       GPL,SL  R/W      1  SCT Command/Status
> 0xe1       GPL,SL  R/W      1  SCT Data Transfer
> SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
> Device Error Count: 10 (device log contains only the most recent 4 errors)
>         CR     = Command Register
>         FEATR  = Features Register
>         COUNT  = Count (was: Sector Count) Register
>         LBA_48 = Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
>         LH     = LBA High (was: Cylinder High) Register    ]   LBA
>         LM     = LBA Mid (was: Cylinder Low) Register      ] Register
>         LL     = LBA Low (was: Sector Number) Register     ]
>         DV     = Device (was: Device/Head) Register
>         DC     = Device Control Register
>         ER     = Error register
>         ST     = Status register
> Powered_Up_Time is measured from power on, and printed as
> DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
> SS=sec, and sss=millisec. It "wraps" after 49.710 days.
> Error 10 [1] occurred at disk power-on lifetime: 1655 hours (68 days + 23 hours)
>   When the command that caused the error occurred, the device was active or idle.
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   84 -- 51 01 28 00 00 50 83 5d e8 00 00  Error: ICRC, ABRT 296 sectors at LBA = 0x50835de8 = 1350786536
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 00 02 a8 00 00 50 83 5c 68 e0 08 23d+05:05:37.425  READ DMA EXT
>   25 00 00 03 68 00 00 50 83 59 00 e0 08 23d+05:05:37.413  READ DMA EXT
>   25 00 00 01 00 00 00 50 83 58 00 e0 08 23d+05:05:37.409  READ DMA EXT
>   25 00 00 00 f0 00 00 50 83 57 10 e0 08 23d+05:05:37.405  READ DMA EXT
>   25 00 00 02 a0 00 00 50 83 54 70 e0 08 23d+05:05:37.352  READ DMA EXT
> Error 9 [0] occurred at disk power-on lifetime: 1654 hours (68 days + 22 hours)
>   When the command that caused the error occurred, the device was active or idle.
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   84 -- 51 00 90 00 00 4e eb 15 70 00 00  Error: ICRC, ABRT 144 sectors at LBA = 0x4eeb1570 = 1324029296
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 00 01 00 00 00 4e eb 15 00 ee 08 23d+04:47:42.788  READ DMA EXT
>   25 00 00 02 28 00 00 4e eb 12 d8 ee 08 23d+04:47:42.713  READ DMA EXT
>   25 00 00 03 d8 00 00 4e eb 0f 00 ee 08 23d+04:47:42.698  READ DMA EXT
>   25 00 00 01 00 00 00 4e eb 0e 00 ee 08 23d+04:47:42.694  READ DMA EXT
>   25 00 00 01 00 00 00 4e eb 0d 00 ee 08 23d+04:47:42.691  READ DMA EXT
> Error 8 [3] occurred at disk power-on lifetime: 1654 hours (68 days + 22 hours)
>   When the command that caused the error occurred, the device was active or idle.
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   84 -- 51 00 28 00 00 36 08 f1 d8 00 00  Error: ICRC, ABRT 40 sectors at LBA = 0x3608f1d8 = 906555864
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 00 00 f8 00 00 36 08 f1 08 e6 08 23d+00:06:40.966  READ DMA EXT
>   25 00 00 02 78 00 00 36 08 ee 90 e6 08 23d+00:06:40.914  READ DMA EXT
>   25 00 00 03 90 00 00 36 08 eb 00 e6 08 23d+00:06:40.900  READ DMA EXT
>   25 00 00 01 00 00 00 36 08 ea 00 e6 08 23d+00:06:40.896  READ DMA EXT
>   25 00 00 00 f8 00 00 36 08 e9 08 e6 08 23d+00:06:40.893  READ DMA EXT
> Error 7 [2] occurred at disk power-on lifetime: 1654 hours (68 days + 22 hours)
>   When the command that caused the error occurred, the device was active or idle.
>   After command completion occurred, registers were:
>   ER -- ST COUNT  LBA_48  LH LM LL DV DC
>   -- -- -- == -- == == == -- -- -- -- --
>   84 -- 51 01 28 00 00 33 d1 bb 40 00 00  Error: ICRC, ABRT 296 sectors at LBA = 0x33d1bb40 = 869382976
>   Commands leading to the command that caused the error were:
>   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
>   -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
>   25 00 00 03 68 00 00 33 d1 b9 00 e3 08 22d+23:42:04.107  READ DMA EXT
>   25 00 00 01 00 00 00 33 d1 b8 00 e3 08 22d+23:42:04.103  READ DMA EXT
>   25 00 00 00 f0 00 00 33 d1 b7 10 e3 08 22d+23:42:04.099  READ DMA EXT
>   25 00 00 02 b0 00 00 33 d1 b4 60 e3 08 22d+23:42:04.022  READ DMA EXT
>   25 00 00 03 60 00 00 33 d1 b1 00 e3 08 22d+23:42:04.009  READ DMA EXT
> SMART Extended Self-test Log Version: 1 (1 sectors)
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
> SMART Selective self-test log data structure revision number 1
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Not_testing
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute delay.
> SCT Status Version:                  3
> SCT Version (vendor specific):       256 (0x0100)
> SCT Support Level:                   1
> Device State:                        SMART Off-line Data Collection executing in background (4)
> Current Temperature:                    33 Celsius
> Power Cycle Min/Max Temperature:     27/33 Celsius
> Lifetime    Min/Max Temperature:     20/53 Celsius
> Under/Over Temperature Limit Count:   0/0
> SCT Temperature History Version:     2
> Temperature Sampling Period:         1 minute
> Temperature Logging Interval:        1 minute
> Min/Max recommended Temperature:      0/60 Celsius
> Min/Max Temperature Limit:           -40/70 Celsius
> Temperature History Size (Index):    128 (81)
> Index    Estimated Time   Temperature Celsius
>   82    2015-02-10 14:38    41  **********************
>  ...    ..(113 skipped).    ..  **********************
>   68    2015-02-10 16:32    41  **********************
>   69    2015-02-10 16:33     ?  -
>   70    2015-02-10 16:34    28  *********
>   71    2015-02-10 16:35    28  *********
>   72    2015-02-10 16:36    29  **********
>   73    2015-02-10 16:37    29  **********
>   74    2015-02-10 16:38    30  ***********
>   75    2015-02-10 16:39    30  ***********
>   76    2015-02-10 16:40    31  ************
>   77    2015-02-10 16:41    31  ************
>   78    2015-02-10 16:42    32  *************
>   79    2015-02-10 16:43    32  *************
>   80    2015-02-10 16:44    33  **************
>   81    2015-02-10 16:45    33  **************
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled
> Device Statistics (GP Log 0x04)
> Page Offset Size         Value  Description
>   1  =====  =                =  == General Statistics (rev 1) ==
>   1  0x008  4              207  Lifetime Power-On Resets
>   1  0x010  4            44002  Power-on Hours
>   1  0x018  6      19676641503  Logical Sectors Written
>   1  0x020  6         47285021  Number of Write Commands
>   1  0x028  6    4518358603939  Logical Sectors Read
>   1  0x030  6       5982270826  Number of Read Commands
>   3  =====  =                =  == Rotating Media Statistics (rev 1) ==
>   3  0x008  4            43993  Spindle Motor Power-on Hours
>   3  0x010  4            43993  Head Flying Hours
>   3  0x018  4             1267  Head Load Events
>   3  0x020  4                0  Number of Reallocated Logical Sectors
>   3  0x028  4               14  Read Recovery Attempts
>   3  0x030  4                1  Number of Mechanical Start Failures
>   4  =====  =                =  == General Errors Statistics (rev 1) ==
>   4  0x008  4                0  Number of Reported Uncorrectable Errors
>   4  0x010  4              180  Resets Between Cmd Acceptance and Completion
>   5  =====  =                =  == Temperature Statistics (rev 1) ==
>   5  0x008  1               33  Current Temperature
>   5  0x010  1               41~ Average Short Term Temperature
>   5  0x018  1               41~ Average Long Term Temperature
>   5  0x020  1               53  Highest Temperature
>   5  0x028  1               20  Lowest Temperature
>   5  0x030  1               49~ Highest Average Short Term Temperature
>   5  0x038  1                0~ Lowest Average Short Term Temperature
>   5  0x040  1               47~ Highest Average Long Term Temperature
>   5  0x048  1                0~ Lowest Average Long Term Temperature
>   5  0x050  4                0  Time in Over-Temperature
>   5  0x058  1               60  Specified Maximum Operating Temperature
>   5  0x060  4                0  Time in Under-Temperature
>   5  0x068  1                0  Specified Minimum Operating Temperature
>   6  =====  =                =  == Transport Statistics (rev 1) ==
>   6  0x008  4             1957  Number of Hardware Resets
>   6  0x010  4             1773  Number of ASR Events
>   6  0x018  4                9  Number of Interface CRC Errors
>                               |_ ~ normalized value
> SATA Phy Event Counters (GP Log 0x11)
> ID      Size     Value  Description
> 0x0001  2            0  Command failed due to ICRC error
> 0x0002  2            0  R_ERR response for data FIS
> 0x0005  2            0  R_ERR response for non-data FIS
> 0x0009  2            6  Transition from drive PhyRdy to drive PhyNRdy
> 0x000a  2            4  Device-to-host register FISes sent due to a COMRESET
> 0x000b  2            0  CRC errors within host-to-device FIS
> 0x000d  2            0  Non-CRC errors within host-to-device FIS
>  sudo smartctl -x /dev/sdf
> smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.13.0-45-generic] (local build)
> Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools.org
> === START OF INFORMATION SECTION ===
> Model Family:     Hitachi Deskstar 7K2000
> Device Model:     Hitachi HDS722020ALA330
> Serial Number:    JK1171YAGDAD5S
> LU WWN Device Id: 5 000cca 221c59b77
> Firmware Version: JKAOA20N
> User Capacity:    2,000,397,852,160 bytes [2.00 TB]
> Sector Size:      512 bytes logical/physical
> Rotation Rate:    7200 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA8-ACS T13/1699-D revision 4
> SATA Version is:  SATA 2.6, 3.0 Gb/s
> Local Time is:    Tue Feb 10 16:46:04 2015 EST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
> AAM feature is:   Disabled
> APM feature is:   Disabled
> Rd look-ahead is: Enabled
> Write cache is:   Enabled
> ATA Security is:  Disabled, NOT FROZEN [SEC1]
> Wt Cache Reorder: Enabled
> === START OF READ SMART DATA SECTION ===
> SMART overall-health self-assessment test result: PASSED
> General SMART Values:
> Offline data collection status:  (0x84) Offline data collection activity
>                                         was suspended by an interrupting command from host.
>                                         Auto Offline Data Collection: Enabled.
> Self-test execution status:      (   0) The previous self-test routine completed
>                                         without error or no self-test has ever
>                                         been run.
> Total time to complete Offline
> data collection:                (22917) seconds.
> Offline data collection
> capabilities:                    (0x5b) SMART execute Offline immediate.
>                                         Auto Offline data collection on/off support.
>                                         Suspend Offline collection upon new
>                                         command.
>                                         Offline surface scan supported.
>                                         Self-test supported.
>                                         No Conveyance Self-test supported.
>                                         Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before entering
>                                         power-saving mode.
>                                         Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
>                                         General Purpose Logging supported.
> Short self-test routine
> recommended polling time:        (   1) minutes.
> Extended self-test routine
> recommended polling time:        ( 382) minutes.
> SCT capabilities:              (0x003d) SCT Status supported.
>                                         SCT Error Recovery Control supported.
>                                         SCT Feature Control supported.
>                                         SCT Data Table supported.
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
>   1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
>   2 Throughput_Performance  P-S---   133   133   054    -    101
>   3 Spin_Up_Time            POS---   134   134   024    -    627 (Average 452)
>   4 Start_Stop_Count        -O--C-   100   100   000    -    203
>   5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
>   7 Seek_Error_Rate         PO-R--   100   100   067    -    0
>   8 Seek_Time_Performance   P-S---   112   112   020    -    39
>   9 Power_On_Hours          -O--C-   094   094   000    -    44006
>  10 Spin_Retry_Count        PO--C-   100   100   060    -    0
>  12 Power_Cycle_Count       -O--CK   100   100   000    -    203
> 192 Power-Off_Retract_Count -O--CK   099   099   000    -    1248
> 193 Load_Cycle_Count        -O--C-   099   099   000    -    1248
> 194 Temperature_Celsius     -O----   193   193   000    -    31 (Min/Max 20/50)
> 196 Reallocated_Event_Count -O--CK   100   100   000    -    0
> 197 Current_Pending_Sector  -O---K   100   100   000    -    0
> 198 Offline_Uncorrectable   ---R--   100   100   000    -    0
> 199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    0
>                             ||||||_ K auto-keep
>                             |||||__ C event count
>                             ||||___ R error rate
>                             |||____ S speed/performance
>                             ||_____ O updated online
>                             |______ P prefailure warning
> General Purpose Log Directory Version 1
> SMART           Log Directory Version 1 [multi-sector log support]
> Address    Access  R/W   Size  Description
> 0x00       GPL,SL  R/O      1  Log Directory
> 0x01           SL  R/O      1  Summary SMART error log
> 0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
> 0x04       GPL     R/O      7  Device Statistics log
> 0x06           SL  R/O      1  SMART self-test log
> 0x07       GPL     R/O      1  Extended self-test log
> 0x09           SL  R/W      1  Selective self-test log
> 0x10       GPL     R/O      1  NCQ Command Error log
> 0x11       GPL     R/O      1  SATA Phy Event Counters
> 0x20       GPL     R/O      1  Streaming performance log [OBS-8]
> 0x21       GPL     R/O      1  Write stream error log
> 0x22       GPL     R/O      1  Read stream error log
> 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
> 0xe0       GPL,SL  R/W      1  SCT Command/Status
> 0xe1       GPL,SL  R/W      1  SCT Data Transfer
> SMART Extended Comprehensive Error Log Version: 0 (1 sectors)
> No Errors Logged
> SMART Extended Self-test Log Version: 1 (1 sectors)
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
> SMART Selective self-test log data structure revision number 1
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Not_testing
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute delay.
> SCT Status Version:                  3
> SCT Version (vendor specific):       256 (0x0100)
> SCT Support Level:                   1
> Device State:                        SMART Off-line Data Collection executing in background (4)
> Current Temperature:                    31 Celsius
> Power Cycle Min/Max Temperature:     27/31 Celsius
> Lifetime    Min/Max Temperature:     20/50 Celsius
> Under/Over Temperature Limit Count:   0/0
> SCT Temperature History Version:     2
> Temperature Sampling Period:         1 minute
> Temperature Logging Interval:        1 minute
> Min/Max recommended Temperature:      0/60 Celsius
> Min/Max Temperature Limit:           -40/70 Celsius
> Temperature History Size (Index):    128 (47)
> Index    Estimated Time   Temperature Celsius
>   48    2015-02-10 14:39    39  ********************
>  ...    ..( 98 skipped).    ..  ********************
>   19    2015-02-10 16:18    39  ********************
>   20    2015-02-10 16:19    40  *********************
>   21    2015-02-10 16:20    39  ********************
>  ...    ..(  3 skipped).    ..  ********************
>   25    2015-02-10 16:24    39  ********************
>   26    2015-02-10 16:25    38  *******************
>  ...    ..(  6 skipped).    ..  *******************
>   33    2015-02-10 16:32    38  *******************
>   34    2015-02-10 16:33     ?  -
>   35    2015-02-10 16:34    27  ********
>   36    2015-02-10 16:35    28  *********
>   37    2015-02-10 16:36    28  *********
>   38    2015-02-10 16:37    29  **********
>   39    2015-02-10 16:38    29  **********
>   40    2015-02-10 16:39    30  ***********
>  ...    ..(  2 skipped).    ..  ***********
>   43    2015-02-10 16:42    30  ***********
>   44    2015-02-10 16:43    31  ************
>  ...    ..(  2 skipped).    ..  ************
>   47    2015-02-10 16:46    31  ************
> SCT Error Recovery Control:
>            Read: Disabled
>           Write: Disabled
> Device Statistics (GP Log 0x04)
> Page Offset Size         Value  Description
>   1  =====  =                =  == General Statistics (rev 1) ==
>   1  0x008  4              203  Lifetime Power-On Resets
>   1  0x010  4            44006  Power-on Hours
>   1  0x018  6      15872353160  Logical Sectors Written
>   1  0x020  6         39140100  Number of Write Commands
>   1  0x028  6    4462388816379  Logical Sectors Read
>   1  0x030  6       5927428317  Number of Read Commands
>   3  =====  =                =  == Rotating Media Statistics (rev 1) ==
>   3  0x008  4            43997  Spindle Motor Power-on Hours
>   3  0x010  4            43997  Head Flying Hours
>   3  0x018  4             1248  Head Load Events
>   3  0x020  4                0  Number of Reallocated Logical Sectors
>   3  0x028  4               32  Read Recovery Attempts
>   3  0x030  4                0  Number of Mechanical Start Failures
>   4  =====  =                =  == General Errors Statistics (rev 1) ==
>   4  0x008  4                0  Number of Reported Uncorrectable Errors
>   4  0x010  4              192  Resets Between Cmd Acceptance and Completion
>   5  =====  =                =  == Temperature Statistics (rev 1) ==
>   5  0x008  1               31  Current Temperature
>   5  0x010  1               37~ Average Short Term Temperature
>   5  0x018  1               35~ Average Long Term Temperature
>   5  0x020  1               50  Highest Temperature
>   5  0x028  1               20  Lowest Temperature
>   5  0x030  1               44~ Highest Average Short Term Temperature
>   5  0x038  1                0~ Lowest Average Short Term Temperature
>   5  0x040  1               42~ Highest Average Long Term Temperature
>   5  0x048  1                0~ Lowest Average Long Term Temperature
>   5  0x050  4                0  Time in Over-Temperature
>   5  0x058  1               60  Specified Maximum Operating Temperature
>   5  0x060  4                0  Time in Under-Temperature
>   5  0x068  1                0  Specified Minimum Operating Temperature
>   6  =====  =                =  == Transport Statistics (rev 1) ==
>   6  0x008  4             1947  Number of Hardware Resets
>   6  0x010  4             1765  Number of ASR Events
>   6  0x018  4                0  Number of Interface CRC Errors
>                               |_ ~ normalized value
> SATA Phy Event Counters (GP Log 0x11)
> ID      Size     Value  Description
> 0x0001  2            0  Command failed due to ICRC error
> 0x0002  2            0  R_ERR response for data FIS
> 0x0005  2            0  R_ERR response for non-data FIS
> 0x0009  2            6  Transition from drive PhyRdy to drive PhyNRdy
> 0x000a  2            4  Device-to-host register FISes sent due to a COMRESET
> 0x000b  2            0  CRC errors within host-to-device FIS
> 0x000d  2            0  Non-CRC errors within host-to-device FIS



Adam:

I actually read that exact stackexchange article about using the
--replace command but I neither had kernel 3.2+ nor mdadm 3.3+ that
seemed to be a necessary requirement. I suppose I could have booted to
a more recent kernel livecd, but sadly i did not.

Thank you both for your help,

Kyle L

On Tue, Feb 10, 2015 at 8:51 AM, Phil Turmel <philip@turmel.org> wrote:
> Hi Kyle,
>
> Your symptoms look like classic timeout mismatch.  Details interleaved.
>
> On 02/10/2015 02:35 AM, Adam Goryachev wrote:
>
>> There are other people who will jump in and help you with your problem,
>> but I'll add a couple of pointers while you are waiting. See below.
>
>> On 10/02/15 15:20, Kyle Logue wrote:
>>> Hey all:
>>>
>>> I have a 5 disk software raid5 that was working fine until I decided
>>> to swap out an old disk with a new one.
>>>
>>> mdadm /dev/md0 --add /dev/sda1
>>> mdadm /dev/md0 --fail /dev/sde1
>
> As Adam pointed out, you should have used --replace, but you probably
> wouldn't have made it through the replace function anyways.
>
>>> At this point it started automatically rebuilding the array.
>>> About 60%? of the way in it stops and I see a lot of this repeated in
>>> my dmesg:
>>>
>>> [Mon Feb  9 18:06:48 2015] ata5.00: exception Emask 0x0 SAct 0x0 SErr
>>> 0x0 action 0x6 frozen
>>> [Mon Feb  9 18:06:48 2015] ata5.00: failed command: SMART
>>> [Mon Feb  9 18:06:48 2015] ata5.00: cmd
>>> b0/da:00:00:4f:c2/00:00:00:00:00/00 tag 7
>>> [Mon Feb  9 18:06:48 2015]          res
>>> 40/00:ff:00:00:00/00:00:00:00:00/40 Emask 0x4 (timeout)
>                                                  ^^^^^^^^^
> Smoking gun.
>
>>> [Mon Feb  9 18:06:48 2015] ata5.00: status: { DRDY }
>>> [Mon Feb  9 18:06:48 2015] ata5: hard resetting link
>>> [Mon Feb  9 18:06:58 2015] ata5: softreset failed (1st FIS failed)
>>> [Mon Feb  9 18:06:58 2015] ata5: hard resetting link
>>> [Mon Feb  9 18:07:08 2015] ata5: softreset failed (1st FIS failed)
>>> [Mon Feb  9 18:07:08 2015] ata5: hard resetting link
>>> [Mon Feb  9 18:07:12 2015] ata5: SATA link up 1.5 Gbps (SStatus 113
>>> SControl 310)
>>> [Mon Feb  9 18:07:12 2015] ata5.00: configured for UDMA/33
>>> [Mon Feb  9 18:07:12 2015] ata5: EH complete
>
> Notice that after a timeout error, the drive is unresponsive for several
> more seconds -- about 24 in your case.
>
>> ....  read about timing mismatches
>> between the kernel and the hard drive, and how to solve that. There was
>> another post earlier today with some links to specific posts that will
>> be helpful (check the online archive).
>
> That would have been me.  Start with this link for a description of what
> you are experiencing:
>
> http://marc.info/?l=linux-raid&m=135811522817345&w=1
>
> First, you need to protect yourself from timeout mismatch due to the use
> of desktop-grade drives.  (Enterprise and raid-rated drives don't have
> this problem.)
>
> { If you were stuck in the middle of a replace a you had just
> worked-around your timeout problem, it would likely continue and
> complete.  You've lost that opportunity. }
>
> Show us the output of "smartctl -x" for all of your drives if you'd like
> advice on your particular drives.  (Pasted inline is preferred.)
>
> Second, you need to find and overwrite (with zeros) the bad sectors on
> your drives.  Or ddrescue to a complete set of replacement drives and
> assemble those.
>
> Third, you need to set up a cron job to scrub your array regularly to
> clean out UREs before they accumulate beyond MD's ability to handle it
> (20 read errors in an hour, 10 per hour sustained).
>
> Phil

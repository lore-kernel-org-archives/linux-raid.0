From: Robert Steinmetz <rob@steinmetznet.com>
Subject: Re: Hard Drive Partition Table shows partition larger than drive
Date: Mon, 27 Apr 2020 10:40:52 -0400
Message-ID: <c3b5d1be-3ee6-303e-63f5-51faf2053f63@steinmetznet.com>
References: <6ee9392d-8867-f0b5-193e-17a516bb7e0e@steinmetznet.com>
 <5EA5ED5D.8060006@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5EA5ED5D.8060006@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 4/26/20 4:21 PM, Wols Lists wrote:
> Run lsdrv over the drive and see what that reports.
> https://raid.wiki.kernel.org/index.php/Asking_for_help
>
> If you post that here, hopefully somebody can help you reconstruct
> whatever was there.
>
> Cheers,
> Wol

here is the output of lsdrv for the drive.

USB [usb-storage] Bus 001 Device 002: ID 152d:2338 JMicron Technology 
Corp. / JMicron USA Technology Corp. JM20337 Hi-Speed USB to SATA & PATA 
Combo Bridge {000000000005}
└scsi 4:0:0:0 TOSHIBA  HDWD110          {585T7P6NS}
  └sdb 931.51g [8:16] Partitioned (dos)
   └sdb1 931.51g [8:17] Empty/Unknown

Here is the smartctl output

# smartctl --xall /dev/sdb
smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.15.0-96-generic] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Device Model:     TOSHIBA HDWD110
Serial Number:    585T7P6NS
LU WWN Device Id: 5 000039 fd6d91d41
Firmware Version: MS2OA8R0
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
Local Time is:    Mon Apr 27 10:35:19 2020 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Disabled
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Write SCT (Get) Feature Control Command failed: Read of ATA output 
registers not implemented [JMicron]
Wt Cache Reorder: Unknown (SCT Feature Control command failed)

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection activity
                     was completed without error.
                     Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test 
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:         ( 7070) seconds.
Offline data collection
capabilities:              (0x5b) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     No Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   1) minutes.
Extended self-test routine
recommended polling time:      ( 118) minutes.
SCT capabilities:            (0x003d)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
   2 Throughput_Performance  P-S---   142   142   054    -    68
   3 Spin_Up_Time            POS---   160   160   024    -    152 
(Average 135)
   4 Start_Stop_Count        -O--C-   100   100   000    -    22
   5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
   7 Seek_Error_Rate         PO-R--   100   100   067    -    0
   8 Seek_Time_Performance   P-S---   110   110   020    -    36
   9 Power_On_Hours          -O--C-   100   100   000    -    1417
  10 Spin_Retry_Count        PO--C-   100   100   060    -    0
  12 Power_Cycle_Count       -O--CK   100   100   000    -    17
192 Power-Off_Retract_Count -O--CK   100   100   000    -    55
193 Load_Cycle_Count        -O--C-   100   100   000    -    55
194 Temperature_Celsius     -O----   200   200   000    -    30 (Min/Max 
24/38)
196 Reallocated_Event_Count -O--CK   100   100   000    -    0
197 Current_Pending_Sector  -O---K   100   100   000    -    0
198 Offline_Uncorrectable   ---R--   100   100   000    -    0
199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    0
                             ||||||_ K auto-keep
                             |||||__ C event count
                             ||||___ R error rate
                             |||____ S speed/performance
                             ||_____ O updated online
                             |______ P prefailure warning

ATA_READ_LOG_EXT (addr=0x00:0x00, page=0, n=1) failed: 48-bit ATA 
commands not implemented [JMicron]
Read GP Log Directory failed

SMART Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00           SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x06           SL  R/O      1  SMART self-test log
0x09           SL  R/W      1  Selective self-test log
0x80-0x9f      SL  R/W     16  Host vendor specific log
0xe0           SL  R/W      1  SCT Command/Status
0xe1           SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log (GP Log 0x03) not supported

SMART Error Log Version: 1
No Errors Logged

SMART Extended Self-test Log (GP Log 0x07) not supported

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00% 444         -

SMART Selective self-test log data structure revision number 1
  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
     1        0        0  Not_testing
     2        0        0  Not_testing
     3        0        0  Not_testing
     4        0        0  Not_testing
     5        0        0  Not_testing
Selective self-test flags (0x0):
   After scanning selected spans, do NOT read-scan remainder of disk.
If Selective self-test is pending on power-up, resume after 0 minute delay.

SCT Status Version:                  3
SCT Version (vendor specific):       256 (0x0100)
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    30 Celsius
Power Cycle Min/Max Temperature:     27/33 Celsius
Lifetime    Min/Max Temperature:     24/38 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -40/70 Celsius
Temperature History Size (Index):    128 (55)

Index    Estimated Time   Temperature Celsius
   56    2020-04-27 08:28    29  **********
  ...    ..( 58 skipped).    ..  **********
  115    2020-04-27 09:27    29  **********
  116    2020-04-27 09:28    30  ***********
  117    2020-04-27 09:29    29  **********
  118    2020-04-27 09:30    29  **********
  119    2020-04-27 09:31    29  **********
  120    2020-04-27 09:32    30  ***********
  121    2020-04-27 09:33    29  **********
  122    2020-04-27 09:34    29  **********
  123    2020-04-27 09:35    30  ***********
  124    2020-04-27 09:36    29  **********
  125    2020-04-27 09:37    29  **********
  126    2020-04-27 09:38    30  ***********
  127    2020-04-27 09:39    30  ***********
    0    2020-04-27 09:40    30  ***********
    1    2020-04-27 09:41    29  **********
    2    2020-04-27 09:42    29  **********
    3    2020-04-27 09:43    30  ***********
    4    2020-04-27 09:44    29  **********
    5    2020-04-27 09:45    29  **********
    6    2020-04-27 09:46    30  ***********
    7    2020-04-27 09:47    30  ***********
    8    2020-04-27 09:48    29  **********
    9    2020-04-27 09:49    30  ***********
  ...    ..( 45 skipped).    ..  ***********
   55    2020-04-27 10:35    30  ***********

Write SCT (Get) Error Recovery Control Command failed: Read of ATA 
output registers not implemented [JMicron]
SCT (Get) Error Recovery Control command failed

Device Statistics (GP/SMART Log 0x04) not supported

ATA_READ_LOG_EXT (addr=0x11:0x00, page=0, n=1) failed: 48-bit ATA 
commands not implemented [JMicron]
Read SATA Phy Event Counters failed

From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: RAID Recovery
Date: Tue, 7 Mar 2017 02:07:14 +1100
Message-ID: <936e84af-f190-3541-bdf8-eaa0c42d2ddc@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I'm trying to assist a friend to recover their RAID array, it consists 
of 4 drives, most likely in RAID10. It was a linux based NAS (AFAIK). I 
would really appreciate any tips or suggestions...

First, the bad news:

mdadm --misc --detail /dev/sd[abcd]
mdadm: /dev/sda does not appear to be an md device
mdadm: /dev/sdb does not appear to be an md device
mdadm: /dev/sdc does not appear to be an md device
mdadm: /dev/sdd does not appear to be an md device

mdadm --misc --examine /dev/sd[abcd]
/dev/sda:
    MBR Magic : aa55
/dev/sdb:
    MBR Magic : aa55
/dev/sdc:
    MBR Magic : aa55
/dev/sdd:
    MBR Magic : aa55

This really doesn't look promising.... but the disks themselves look 
"healthy"... at least mostly.

Looking at the content of the drives, it might be possible that all four 
drives were in RAID1 ... at least, I can find identical data on all four 
of the drives:

Running this command for each drive:

strings /dev/sdd |cat -n |less

looking for some "text", and I find what looks like a log file snipped 
which is identical across all four drives. Thats 25 lines of output, 
that exists on the same output line number, matching across all 4 
drives. So perhaps I have a 4 drive RAID1, which I guess should make it 
easier to recover from.


Disks are /dev/sda /dev/sdb /dev/sdc /dev/sdd, all identical 
"partitions" that don't seem to exist, but there is a MBR partition table

gdisk -l /dev/sda
GPT fdisk (gdisk) version 1.0.1

Partition table scan:
   MBR: MBR only
   BSD: not present
   APM: not present
   GPT: not present


***************************************************************
Found invalid GPT and valid MBR; converting MBR to GPT format
in memory.
***************************************************************

Disk /dev/sda: 1953525168 sectors, 931.5 GiB
Logical sector size: 512 bytes
Disk identifier (GUID): 145F71F0-4D0B-4941-9F9E-2C5301BF518F
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 1953525134
Partitions will be aligned on 2048-sector boundaries
Total free space is 1953525101 sectors (931.5 GiB)

The first two drives look like this (lots of read errors), the second 
two look perfectly clean...

/dev/sda

Number  Start (sector)    End (sector)  Size       Code  Name

=== START OF INFORMATION SECTION ===
Device Model:     ST1000NM0033         81Y9807 81Y3867IBM
Serial Number:    Z1W2ZG3M
LU WWN Device Id: 5 000c50 079c48262
Firmware Version: BB5A
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Mar  6 14:44:32 2017 UTC
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
                                         Auto Offline Data Collection: 
Enabled.
Self-test execution status:      (   0) The previous self-test routine 
completed
                                         without error or no self-test 
has ever
                                         been run.
Total time to complete Offline
data collection:                (  592) seconds.
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
recommended polling time:        (   1) minutes.
Extended self-test routine
recommended polling time:        ( 115) minutes.
Conveyance self-test routine
recommended polling time:        (   2) minutes.
SCT capabilities:              (0x50bd) SCT Status supported.
                                         SCT Error Recovery Control 
supported.
                                         SCT Feature Control supported.
                                         SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR--   081   063   044 -    120486603
   3 Spin_Up_Time            PO----   097   096   000 -    0
   4 Start_Stop_Count        -O--CK   100   100   020 -    80
   5 Reallocated_Sector_Ct   PO--CK   100   100   010 -    0
   7 Seek_Error_Rate         POSR--   082   060   030 -    181785851
   9 Power_On_Hours          -O--CK   087   087   000 -    11874
  10 Spin_Retry_Count        PO--C-   100   100   097 -    0
  12 Power_Cycle_Count       -O--CK   100   100   020 -    65
184 End-to-End_Error        -O--CK   100   100   099 -    0
187 Reported_Uncorrect      -O--CK   100   100   000 -    0
188 Command_Timeout         -O--CK   100   100   000 -    0
189 High_Fly_Writes         -O-RCK   100   100   000 -    0
190 Airflow_Temperature_Cel -O---K   060   051   045 -    40 (Min/Max 37/40)
191 G-Sense_Error_Rate      -O--CK   100   100   000 -    0
192 Power-Off_Retract_Count -O--CK   100   100   000 -    60
193 Load_Cycle_Count        -O--CK   100   100   000 -    559
194 Temperature_Celsius     -O---K   040   049   000 -    40 (0 21 0 0 0)
195 Hardware_ECC_Recovered  -O-RC-   021   007   000 -    120486603
197 Current_Pending_Sector  -O--C-   100   100   000 -    0
198 Offline_Uncorrectable   ----C-   100   100   000 -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000 -    0
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
0x03       GPL     R/O      5  Ext. Comprehensive SMART error log
0x04       GPL,SL  R/O      8  Device Statistics log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x08       GPL,SL  R/O      2  Power Conditions log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x24       GPL     R/O    512  Current Device Internal Status Data log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa1       GPL,SL  VS      20  Device vendor specific log
0xa2       GPL     VS    4496  Device vendor specific log
0xa8       GPL,SL  VS     129  Device vendor specific log
0xa9       GPL,SL  VS       1  Device vendor specific log
0xb0       GPL,SL  VS       1  Device vendor specific log
0xbd       GPL     VS     512  Device vendor specific log
0xbe-0xbf  GPL     VS   65535  Device vendor specific log
0xc1       GPL,SL  VS      10  Device vendor specific log
0xc2       GPL,SL  VS      50  Device vendor specific log
0xc3       GPL,SL  VS       8  Device vendor specific log
0xc4       GPL,SL  VS       5  Device vendor specific log
0xd1       GPL,SL  VS       8  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

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
Current Temperature:                    40 Celsius
Power Cycle Min/Max Temperature:     37/40 Celsius
Lifetime    Min/Max Temperature:     21/49 Celsius
Under/Over Temperature Limit Count:   0/8

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        10 minutes
Min/Max recommended Temperature:      0/ 0 Celsius
Min/Max Temperature Limit:            0/ 0 Celsius
Temperature History Size (Index):    128 (50)
[SNIP TEMPERATURE SECTION]

SCT Error Recovery Control:
            Read:     75 (7.5 seconds)
           Write:     75 (7.5 seconds)

Device Statistics (GP Log 0x04)
Page  Offset Size        Value Flags Description
0x01  =====  =               =  ===  == General Statistics (rev 2) ==
0x01  0x008  4              65  ---  Lifetime Power-On Resets
0x01  0x010  4           11874  ---  Power-on Hours
0x01  0x018  6      2728215464  ---  Logical Sectors Written
0x01  0x020  6        60447755  ---  Number of Write Commands
0x01  0x028  6     72441102919  ---  Logical Sectors Read
0x01  0x030  6        47955151  ---  Number of Read Commands
0x01  0x038  6               -  ---  Date and Time TimeStamp
0x03  =====  =               =  ===  == Rotating Media Statistics (rev 1) ==
0x03  0x008  4           11667  ---  Spindle Motor Power-on Hours
0x03  0x010  4             437  ---  Head Flying Hours
0x03  0x018  4             559  ---  Head Load Events
0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
0x03  0x028  4               0  ---  Read Recovery Attempts
0x03  0x030  4               0  ---  Number of Mechanical Start Failures
0x04  =====  =               =  ===  == General Errors Statistics (rev 1) ==
0x04  0x008  4               0  ---  Number of Reported Uncorrectable Errors
0x04  0x010  4               0  ---  Resets Between Cmd Acceptance and 
Completion
0x05  =====  =               =  ===  == Temperature Statistics (rev 1) ==
0x05  0x008  1              40  N--  Current Temperature
0x05  0x010  1              38  N--  Average Short Term Temperature
0x05  0x018  1              38  N--  Average Long Term Temperature
0x05  0x020  1              49  N--  Highest Temperature
0x05  0x028  1              21  N--  Lowest Temperature
0x05  0x030  1              41  N--  Highest Average Short Term Temperature
0x05  0x038  1               2  N--  Lowest Average Short Term Temperature
0x05  0x040  1              39  N--  Highest Average Long Term Temperature
0x05  0x050  4               0  ---  Time in Over-Temperature
0x05  0x058  1              55  ---  Specified Maximum Operating Temperature
0x05  0x060  4               0  ---  Time in Under-Temperature
0x05  0x068  1              13  ---  Specified Minimum Operating Temperature
                                 |||_ C monitored condition met
                                 ||__ D supports DSN
                                 |___ N normalized value

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x000a  2            3  Device-to-host register FISes sent due to a COMRESET
0x0001  2            0  Command failed due to ICRC error
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS

/dev/sdb is similar:
=== START OF INFORMATION SECTION ===
Device Model:     ST1000NM0033         81Y9807 81Y3867IBM
Serial Number:    Z1W2ZKKD
LU WWN Device Id: 5 000c50 079c557df
Firmware Version: BB5A
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Mar  6 14:47:49 2017 UTC
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
SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR--   083   063   044 -    224696760
   3 Spin_Up_Time            PO----   097   096   000 -    0
   4 Start_Stop_Count        -O--CK   100   100   020 -    80
   5 Reallocated_Sector_Ct   PO--CK   100   100   010 -    0
   7 Seek_Error_Rate         POSR--   082   060   030 -    192122915
   9 Power_On_Hours          -O--CK   087   087   000 -    11874
  10 Spin_Retry_Count        PO--C-   100   100   097 -    0
  12 Power_Cycle_Count       -O--CK   100   100   020 -    66
184 End-to-End_Error        -O--CK   100   100   099 -    0
187 Reported_Uncorrect      -O--CK   100   100   000 -    0
188 Command_Timeout         -O--CK   100   100   000 -    0
189 High_Fly_Writes         -O-RCK   100   100   000 -    0
190 Airflow_Temperature_Cel -O---K   056   047   045 -    44 (Min/Max 41/44)
191 G-Sense_Error_Rate      -O--CK   100   100   000 -    0
192 Power-Off_Retract_Count -O--CK   100   100   000 -    58
193 Load_Cycle_Count        -O--CK   100   100   000 -    556
194 Temperature_Celsius     -O---K   044   053   000 -    44 (0 21 0 0 0)
195 Hardware_ECC_Recovered  -O-RC-   023   013   000 -    224696760
197 Current_Pending_Sector  -O--C-   100   100   000 -    0
198 Offline_Uncorrectable   ----C-   100   100   000 -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000 -    0
                             ||||||_ K auto-keep
                             |||||__ C event count
                             ||||___ R error rate
                             |||____ S speed/performance
                             ||_____ O updated online
                             |______ P prefailure warning


while /dev/sdc looks OK

=== START OF INFORMATION SECTION ===
Device Model:     WD1003FBYX-23        81Y9807 81Y3867IBM
Serial Number:    WD-WCAW37DULJLP
LU WWN Device Id: 5 0014ee 261450c09
Firmware Version: WB35
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Mon Mar  6 14:48:21 2017 UTC
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM level is:     254 (maximum performance)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, NOT FROZEN [SEC1]
Wt Cache Reorder: Enabled

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR-K   200   200   051 -    3
   3 Spin_Up_Time            POS--K   186   173   021 -    3691
   4 Start_Stop_Count        -O--CK   100   100   000 -    90
   5 Reallocated_Sector_Ct   PO--CK   200   200   140 -    0
   7 Seek_Error_Rate         -OSR-K   100   253   000 -    0
   9 Power_On_Hours          -O--CK   084   084   000 -    11759
  10 Spin_Retry_Count        -O--CK   100   253   000 -    0
  11 Calibration_Retry_Count -O--CK   100   253   000 -    0
  12 Power_Cycle_Count       -O--CK   100   100   000 -    76
192 Power-Off_Retract_Count -O--CK   200   200   000 -    69
193 Load_Cycle_Count        -O--CK   200   200   000 -    20
194 Temperature_Celsius     -O---K   102   092   000 -    45
196 Reallocated_Event_Count -O--CK   200   200   000 -    0
197 Current_Pending_Sector  -O--CK   200   200   000 -    0
198 Offline_Uncorrectable   ----CK   200   200   000 -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000 -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000 -    0
                             ||||||_ K auto-keep
                             |||||__ C event count
                             ||||___ R error rate
                             |||____ S speed/performance
                             ||_____ O updated online
                             |______ P prefailure warning


Can anyone provide some hints or suggestions on how I should proceed?

Regards,
Adam



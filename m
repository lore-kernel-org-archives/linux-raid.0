From: Robert Schultz <rob@schultzfamily.ca>
Subject: Re: RAID 5 3-drive array failed 2 disks at once - can anything be
 saved?
Date: Sun, 15 Sep 2013 16:42:00 -0400
Message-ID: <52361B98.9030705@schultzfamily.ca>
References: <52332763.30901@schultzfamily.ca> <52347194.7010602@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52347194.7010602@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

Phil:

Thank you for the information. This is my backup machine. Up to this 
point I wasn't concerned about having a second copy of this machine, but 
I have a tendency to decommission a computer and leave the backups on by 
backuppc for archive purposes. I probably don't really, really need 
anything on this PC. That said I'm am very paranoid that I will have 
some other failure before I can resolve this :-(

I hadn't read anything about timing in disks in RAID - I'll have to go 
do some research. I see WD has their RED series that appears to be 
directed to this market.

Here is the information requested. Please let me know if this changes 
anything in your instructions. I'll hold off until you confirm.


 >1) Redo your "mdadm -E /dec/sdd1", as you cut off part of its output.

root@bkpr:~# mdadm -E /dev/sdd1
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 77965a25:38a24b98:9ab5899c:7795ded7
            Name : bkp1:0
   Creation Time : Fri May 31 11:06:39 2013
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 3906764976 (1862.89 GiB 2000.26 GB)
      Array Size : 3906763776 (3725.78 GiB 4000.53 GB)
   Used Dev Size : 3906763776 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : active
     Device UUID : 1d29c79a:2a7c1bb3:130cbed5:9afce2e8

     Update Time : Wed Sep 11 03:34:39 2013
        Checksum : 8e8eabd9 - correct
          Events : 308467

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAA ('A' == active, '.' == missing)


 >2) show "for x in /sys/block/*/device/timeout ; do echo $x $(< $x) ; 
done" to see your driver timeouts.

root@bkpr:~# for x in /sys/block/*/device/timeout ; do echo $x $(< $x) ; 
done
/sys/block/sda/device/timeout 30
/sys/block/sdb/device/timeout 30
/sys/block/sdc/device/timeout 30
/sys/block/sdd/device/timeout 30
/sys/block/sde/device/timeout 30
/sys/block/sdf/device/timeout 30
/sys/block/sdg/device/timeout 30
/sys/block/sdh/device/timeout 30
/sys/block/sdi/device/timeout 30

We're only interested in sdb/sdc/sdd for the array. sda is a 20GB IDE 
drive as the boot/sys disk. f-i would be the USB live CD

 >3) show "for x in sdb sdc sdd ; do echo $s ; smartctl -x /dev/$x ; 
done" so we can see your drive health in detail, and the scterc 
capability. (Sure to be none for the ST2000DM001 -- I have a couple of 
those.)


smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.32-21-generic] (local 
build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda LP
Device Model:     ST32000542AS
Serial Number:    5XW21KAF
LU WWN Device Id: 5 000c50 02ecc7806
Firmware Version: CC34
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Sep 15 14:14:44 2013 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x00)    Offline data collection activity
                     was never started.
                     Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)    The previous self-test 
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:         (  643) seconds.
Offline data collection
capabilities:              (0x73) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     No Offline surface scan supported.
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
recommended polling time:      ( 255) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x103f)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR--   118   099   006    - 194290954
   3 Spin_Up_Time            PO----   100   100   000    -    0
   4 Start_Stop_Count        -O--CK   100   100   020    -    223
   5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
   7 Seek_Error_Rate         POSR--   094   060   030    - 2889012633
   9 Power_On_Hours          -O--CK   076   076   000    -    21491
  10 Spin_Retry_Count        PO--C-   100   100   097    -    0
  12 Power_Cycle_Count       -O--CK   100   100   020    -    224
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   100   000    -    0
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   056   045   045    Past 44 (Min/Max 
40/44)
194 Temperature_Celsius     -O---K   044   055   000    -    44 (0 18 0 0)
195 Hardware_ECC_Recovered  -O-RC-   046   021   000    - 194290954
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    - 140621524259782
241 Total_LBAs_Written      ------   100   253   000    - 1857243927
242 Total_LBAs_Read         ------   100   253   000    - 2508858022
                             ||||||_ K auto-keep
                             |||||__ C event count
                             ||||___ R error rate
                             |||____ S speed/performance
                             ||_____ O updated online
                             |______ P prefailure warning

ATA_READ_LOG_EXT (addr=0x00:0x00, page=0, n=1) failed: scsi error 
aborted command
Read GP Log Directory failed.

SMART Log Directory Version 1 [multi-sector log support]
SMART Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
SMART Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
SMART Log at address 0x03 has    5 sectors [Ext. Comprehensive SMART 
error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
SMART Log at address 0x07 has    1 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
SMART Log at address 0x10 has    1 sectors [NCQ Command Error]
SMART Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
SMART Log at address 0x21 has    1 sectors [Write stream error log]
SMART Log at address 0x22 has    1 sectors [Read stream error log]
SMART Log at address 0x80 has   16 sectors [Host vendor specific log]
SMART Log at address 0x81 has   16 sectors [Host vendor specific log]
SMART Log at address 0x82 has   16 sectors [Host vendor specific log]
SMART Log at address 0x83 has   16 sectors [Host vendor specific log]
SMART Log at address 0x84 has   16 sectors [Host vendor specific log]
SMART Log at address 0x85 has   16 sectors [Host vendor specific log]
SMART Log at address 0x86 has   16 sectors [Host vendor specific log]
SMART Log at address 0x87 has   16 sectors [Host vendor specific log]
SMART Log at address 0x88 has   16 sectors [Host vendor specific log]
SMART Log at address 0x89 has   16 sectors [Host vendor specific log]
SMART Log at address 0x8a has   16 sectors [Host vendor specific log]
SMART Log at address 0x8b has   16 sectors [Host vendor specific log]
SMART Log at address 0x8c has   16 sectors [Host vendor specific log]
SMART Log at address 0x8d has   16 sectors [Host vendor specific log]
SMART Log at address 0x8e has   16 sectors [Host vendor specific log]
SMART Log at address 0x8f has   16 sectors [Host vendor specific log]
SMART Log at address 0x90 has   16 sectors [Host vendor specific log]
SMART Log at address 0x91 has   16 sectors [Host vendor specific log]
SMART Log at address 0x92 has   16 sectors [Host vendor specific log]
SMART Log at address 0x93 has   16 sectors [Host vendor specific log]
SMART Log at address 0x94 has   16 sectors [Host vendor specific log]
SMART Log at address 0x95 has   16 sectors [Host vendor specific log]
SMART Log at address 0x96 has   16 sectors [Host vendor specific log]
SMART Log at address 0x97 has   16 sectors [Host vendor specific log]
SMART Log at address 0x98 has   16 sectors [Host vendor specific log]
SMART Log at address 0x99 has   16 sectors [Host vendor specific log]
SMART Log at address 0x9a has   16 sectors [Host vendor specific log]
SMART Log at address 0x9b has   16 sectors [Host vendor specific log]
SMART Log at address 0x9c has   16 sectors [Host vendor specific log]
SMART Log at address 0x9d has   16 sectors [Host vendor specific log]
SMART Log at address 0x9e has   16 sectors [Host vendor specific log]
SMART Log at address 0x9f has   16 sectors [Host vendor specific log]
SMART Log at address 0xa1 has   20 sectors [Device vendor specific log]
SMART Log at address 0xa8 has  129 sectors [Device vendor specific log]
SMART Log at address 0xa9 has    1 sectors [Device vendor specific log]
SMART Log at address 0xbd has  252 sectors [Device vendor specific log]
SMART Log at address 0xc0 has    1 sectors [Device vendor specific log]
SMART Log at address 0xe0 has    1 sectors [SCT Command/Status]
SMART Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log (GP Log 0x03) not supported
SMART Error Log Version: 1
No Errors Logged

SMART Extended Self-test Log (GP Log 0x07) not supported
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00% 21425         -

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
Current Temperature:                    44 Celsius
Power Cycle Min/Max Temperature:     40/44 Celsius
Lifetime    Min/Max Temperature:     18/55 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         10 minutes
Temperature Logging Interval:        59 minutes
Min/Max recommended Temperature:     14/55 Celsius
Min/Max Temperature Limit:           10/60 Celsius
Temperature History Size (Index):    128 (19)

Index    Estimated Time   Temperature Celsius
   20    2013-09-10 08:24    45  **************************
   21    2013-09-10 09:23    44  *************************
  ...    ..(  7 skipped).    ..  *************************
   29    2013-09-10 17:15    44  *************************
   30    2013-09-10 18:14    45  **************************
   31    2013-09-10 19:13    47  ****************************
   32    2013-09-10 20:12    46  ***************************
   33    2013-09-10 21:11    48  *****************************
   34    2013-09-10 22:10    51  ********************************
   35    2013-09-10 23:09    51  ********************************
   36    2013-09-11 00:08    50  *******************************
   37    2013-09-11 01:07    47  ****************************
   38    2013-09-11 02:06    45  **************************
   39    2013-09-11 03:05    49  ******************************
   40    2013-09-11 04:04    46  ***************************
   41    2013-09-11 05:03    45  **************************
   42    2013-09-11 06:02    45  **************************
   43    2013-09-11 07:01    49  ******************************
   44    2013-09-11 08:00    50  *******************************
   45    2013-09-11 08:59    50  *******************************
   46    2013-09-11 09:58    49  ******************************
   47    2013-09-11 10:57    46  ***************************
   48    2013-09-11 11:56    45  **************************
  ...    ..(  5 skipped).    ..  **************************
   54    2013-09-11 17:50    45  **************************
   55    2013-09-11 18:49    47  ****************************
   56    2013-09-11 19:48    47  ****************************
   57    2013-09-11 20:47    47  ****************************
   58    2013-09-11 21:46    50  *******************************
   59    2013-09-11 22:45    51  ********************************
   60    2013-09-11 23:44    50  *******************************
   61    2013-09-12 00:43    50  *******************************
   62    2013-09-12 01:42    46  ***************************
   63    2013-09-12 02:41    49  ******************************
   64    2013-09-12 03:40    48  *****************************
   65    2013-09-12 04:39    45  **************************
  ...    ..( 12 skipped).    ..  **************************
   78    2013-09-12 17:26    45  **************************
   79    2013-09-12 18:25    47  ****************************
   80    2013-09-12 19:24    50  *******************************
   81    2013-09-12 20:23    48  *****************************
   82    2013-09-12 21:22    50  *******************************
   83    2013-09-12 22:21    51  ********************************
   84    2013-09-12 23:20    50  *******************************
   85    2013-09-13 00:19    48  *****************************
   86    2013-09-13 01:18    46  ***************************
   87    2013-09-13 02:17    49  ******************************
   88    2013-09-13 03:16    47  ****************************
   89    2013-09-13 04:15    45  **************************
  ...    ..(  7 skipped).    ..  **************************
   97    2013-09-13 12:07    45  **************************
   98    2013-09-13 13:06    46  ***************************
   99    2013-09-13 14:05    45  **************************
  100    2013-09-13 15:04    45  **************************
  101    2013-09-13 16:03    46  ***************************
  102    2013-09-13 17:02    49  ******************************
  103    2013-09-13 18:01    51  ********************************
  104    2013-09-13 19:00    52  *********************************
  105    2013-09-13 19:59    48  *****************************
  106    2013-09-13 20:58    51  ********************************
  107    2013-09-13 21:57    51  ********************************
  108    2013-09-13 22:56    49  ******************************
  109    2013-09-13 23:55    46  ***************************
  110    2013-09-14 00:54    46  ***************************
  111    2013-09-14 01:53    46  ***************************
  112    2013-09-14 02:52    45  **************************
  ...    ..(  5 skipped).    ..  **************************
  118    2013-09-14 08:46    45  **************************
  119    2013-09-14 09:45    46  ***************************
  ...    ..(  4 skipped).    ..  ***************************
  124    2013-09-14 14:40    46  ***************************
  125    2013-09-14 15:39    45  **************************
  126    2013-09-14 16:38     ?  -
  127    2013-09-14 17:37    45  **************************
    0    2013-09-14 18:36     ?  -
    1    2013-09-14 19:35    44  *************************
    2    2013-09-14 20:34     ?  -
    3    2013-09-14 21:33    22  ***
    4    2013-09-14 22:32     ?  -
    5    2013-09-14 23:31    27  ********
    6    2013-09-15 00:30     ?  -
    7    2013-09-15 01:29    27  ********
    8    2013-09-15 02:28     ?  -
    9    2013-09-15 03:27    40  *********************
   10    2013-09-15 04:26     ?  -
   11    2013-09-15 05:25    40  *********************
   12    2013-09-15 06:24     ?  -
   13    2013-09-15 07:23    40  *********************
   14    2013-09-15 08:22     ?  -
   15    2013-09-15 09:21    40  *********************
   16    2013-09-15 10:20    40  *********************
   17    2013-09-15 11:19    44  *************************
   18    2013-09-15 12:18    44  *************************
   19    2013-09-15 13:17    44  *************************

SCT Error Recovery Control:
            Read: Disabled
           Write: Disabled

SATA Phy Event Counters (GP Log 0x11) not supported

smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.32-21-generic] (local 
build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Device Model:     ST2000DM001-1CH164
Serial Number:    Z1E27DHL
LU WWN Device Id: 5 000c50 04f1ae32f
Firmware Version: CC24
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        Not in smartctl database [for details use: -P showall]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Sep 15 14:14:44 2013 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x00)    Offline data collection activity
                     was never started.
                     Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)    The previous self-test 
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:         (  584) seconds.
Offline data collection
capabilities:              (0x73) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     No Offline surface scan supported.
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
recommended polling time:      ( 221) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x3085)    SCT Status supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR--   117   099   006    - 125736168
   3 Spin_Up_Time            PO----   096   096   000    -    0
   4 Start_Stop_Count        -O--CK   100   100   020    -    14
   5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
   7 Seek_Error_Rate         POSR--   076   060   030    - 13007233819
   9 Power_On_Hours          -O--CK   098   098   000    -    2592
  10 Spin_Retry_Count        PO--C-   100   100   097    -    0
  12 Power_Cycle_Count       -O--CK   100   100   020    -    14
183 Runtime_Bad_Block       -O--CK   099   099   000    -    1
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   100   100   000    -    0
188 Command_Timeout         -O--CK   100   100   000    -    0
189 High_Fly_Writes         -O-RCK   097   097   000    -    3
190 Airflow_Temperature_Cel -O---K   053   040   045    Past 47 (16 76 
47 41)
191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
192 Power-Off_Retract_Count -O--CK   100   100   000    -    14
193 Load_Cycle_Count        -O--CK   100   100   000    -    49
194 Temperature_Celsius     -O---K   047   060   000    -    47 (0 20 0 0)
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    - 108306190305758
241 Total_LBAs_Written      ------   100   253   000    - 10738051480
242 Total_LBAs_Read         ------   100   253   000    - 22593654149
                             ||||||_ K auto-keep
                             |||||__ C event count
                             ||||___ R error rate
                             |||____ S speed/performance
                             ||_____ O updated online
                             |______ P prefailure warning

ATA_READ_LOG_EXT (addr=0x00:0x00, page=0, n=1) failed: scsi error 
aborted command
Read GP Log Directory failed.

SMART Log Directory Version 1 [multi-sector log support]
SMART Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
SMART Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
SMART Log at address 0x80 has   16 sectors [Host vendor specific log]
SMART Log at address 0x81 has   16 sectors [Host vendor specific log]
SMART Log at address 0x82 has   16 sectors [Host vendor specific log]
SMART Log at address 0x83 has   16 sectors [Host vendor specific log]
SMART Log at address 0x84 has   16 sectors [Host vendor specific log]
SMART Log at address 0x85 has   16 sectors [Host vendor specific log]
SMART Log at address 0x86 has   16 sectors [Host vendor specific log]
SMART Log at address 0x87 has   16 sectors [Host vendor specific log]
SMART Log at address 0x88 has   16 sectors [Host vendor specific log]
SMART Log at address 0x89 has   16 sectors [Host vendor specific log]
SMART Log at address 0x8a has   16 sectors [Host vendor specific log]
SMART Log at address 0x8b has   16 sectors [Host vendor specific log]
SMART Log at address 0x8c has   16 sectors [Host vendor specific log]
SMART Log at address 0x8d has   16 sectors [Host vendor specific log]
SMART Log at address 0x8e has   16 sectors [Host vendor specific log]
SMART Log at address 0x8f has   16 sectors [Host vendor specific log]
SMART Log at address 0x90 has   16 sectors [Host vendor specific log]
SMART Log at address 0x91 has   16 sectors [Host vendor specific log]
SMART Log at address 0x92 has   16 sectors [Host vendor specific log]
SMART Log at address 0x93 has   16 sectors [Host vendor specific log]
SMART Log at address 0x94 has   16 sectors [Host vendor specific log]
SMART Log at address 0x95 has   16 sectors [Host vendor specific log]
SMART Log at address 0x96 has   16 sectors [Host vendor specific log]
SMART Log at address 0x97 has   16 sectors [Host vendor specific log]
SMART Log at address 0x98 has   16 sectors [Host vendor specific log]
SMART Log at address 0x99 has   16 sectors [Host vendor specific log]
SMART Log at address 0x9a has   16 sectors [Host vendor specific log]
SMART Log at address 0x9b has   16 sectors [Host vendor specific log]
SMART Log at address 0x9c has   16 sectors [Host vendor specific log]
SMART Log at address 0x9d has   16 sectors [Host vendor specific log]
SMART Log at address 0x9e has   16 sectors [Host vendor specific log]
SMART Log at address 0x9f has   16 sectors [Host vendor specific log]
SMART Log at address 0xa1 has   20 sectors [Device vendor specific log]
SMART Log at address 0xa8 has  129 sectors [Device vendor specific log]
SMART Log at address 0xa9 has    1 sectors [Device vendor specific log]
SMART Log at address 0xc0 has    1 sectors [Device vendor specific log]
SMART Log at address 0xc1 has   10 sectors [Device vendor specific log]
SMART Log at address 0xc4 has    5 sectors [Device vendor specific log]
SMART Log at address 0xe0 has    1 sectors [SCT Command/Status]
SMART Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log (GP Log 0x03) not supported
SMART Error Log Version: 1
No Errors Logged

SMART Extended Self-test Log (GP Log 0x07) not supported
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed without error       00% 2526         -

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

Warning: device does not support SCT Data Table command
Warning: device does not support SCT Error Recovery Control command
SATA Phy Event Counters (GP Log 0x11) not supported

smartctl 5.41 2011-06-09 r3365 [x86_64-linux-2.6.32-21-generic] (local 
build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

=== START OF INFORMATION SECTION ===
Model Family:     Seagate Barracuda LP
Device Model:     ST32000542AS
Serial Number:    5XW24A5V
LU WWN Device Id: 5 000c50 02ece5bf0
Firmware Version: CC34
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 4
Local Time is:    Sun Sep 15 14:14:44 2013 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED
See vendor-specific Attribute list for marginal Attributes.

General SMART Values:
Offline data collection status:  (0x00)    Offline data collection activity
                     was never started.
                     Auto Offline Data Collection: Disabled.
Self-test execution status:      (   0)    The previous self-test 
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:         (  633) seconds.
Offline data collection
capabilities:              (0x73) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     No Offline surface scan supported.
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
recommended polling time:      ( 255) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x103f)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR--   095   095   006    - 164677781
   3 Spin_Up_Time            PO----   100   100   000    -    0
   4 Start_Stop_Count        -O--CK   100   100   020    -    223
   5 Reallocated_Sector_Ct   PO--CK   100   100   036    -    0
   7 Seek_Error_Rate         POSR--   094   060   030    - 2933855450
   9 Power_On_Hours          -O--CK   075   075   000    -    22657
  10 Spin_Retry_Count        PO--C-   100   100   097    -    0
  12 Power_Cycle_Count       -O--CK   100   100   020    -    224
183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
184 End-to-End_Error        -O--CK   100   100   099    -    0
187 Reported_Uncorrect      -O--CK   001   001   000    -    211
188 Command_Timeout         -O--CK   100   099   000    - 4295032835
189 High_Fly_Writes         -O-RCK   100   100   000    -    0
190 Airflow_Temperature_Cel -O---K   053   042   045    Past 47 (17 206 
47 42)
194 Temperature_Celsius     -O---K   047   058   000    -    47 (0 18 0 0)
195 Hardware_ECC_Recovered  -O-RC-   041   024   000    - 164677781
197 Current_Pending_Sector  -O--C-   098   095   000    -    91
198 Offline_Uncorrectable   ----C-   098   095   000    -    91
199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
240 Head_Flying_Hours       ------   100   253   000    - 163088498186598
241 Total_LBAs_Written      ------   100   253   000    - 2802097688
242 Total_LBAs_Read         ------   100   253   000    - 189741710
                             ||||||_ K auto-keep
                             |||||__ C event count
                             ||||___ R error rate
                             |||____ S speed/performance
                             ||_____ O updated online
                             |______ P prefailure warning

ATA_READ_LOG_EXT (addr=0x00:0x00, page=0, n=1) failed: scsi error 
aborted command
Read GP Log Directory failed.

SMART Log Directory Version 1 [multi-sector log support]
SMART Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
SMART Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
SMART Log at address 0x03 has    5 sectors [Ext. Comprehensive SMART 
error log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
SMART Log at address 0x07 has    1 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
SMART Log at address 0x10 has    1 sectors [NCQ Command Error]
SMART Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
SMART Log at address 0x21 has    1 sectors [Write stream error log]
SMART Log at address 0x22 has    1 sectors [Read stream error log]
SMART Log at address 0x80 has   16 sectors [Host vendor specific log]
SMART Log at address 0x81 has   16 sectors [Host vendor specific log]
SMART Log at address 0x82 has   16 sectors [Host vendor specific log]
SMART Log at address 0x83 has   16 sectors [Host vendor specific log]
SMART Log at address 0x84 has   16 sectors [Host vendor specific log]
SMART Log at address 0x85 has   16 sectors [Host vendor specific log]
SMART Log at address 0x86 has   16 sectors [Host vendor specific log]
SMART Log at address 0x87 has   16 sectors [Host vendor specific log]
SMART Log at address 0x88 has   16 sectors [Host vendor specific log]
SMART Log at address 0x89 has   16 sectors [Host vendor specific log]
SMART Log at address 0x8a has   16 sectors [Host vendor specific log]
SMART Log at address 0x8b has   16 sectors [Host vendor specific log]
SMART Log at address 0x8c has   16 sectors [Host vendor specific log]
SMART Log at address 0x8d has   16 sectors [Host vendor specific log]
SMART Log at address 0x8e has   16 sectors [Host vendor specific log]
SMART Log at address 0x8f has   16 sectors [Host vendor specific log]
SMART Log at address 0x90 has   16 sectors [Host vendor specific log]
SMART Log at address 0x91 has   16 sectors [Host vendor specific log]
SMART Log at address 0x92 has   16 sectors [Host vendor specific log]
SMART Log at address 0x93 has   16 sectors [Host vendor specific log]
SMART Log at address 0x94 has   16 sectors [Host vendor specific log]
SMART Log at address 0x95 has   16 sectors [Host vendor specific log]
SMART Log at address 0x96 has   16 sectors [Host vendor specific log]
SMART Log at address 0x97 has   16 sectors [Host vendor specific log]
SMART Log at address 0x98 has   16 sectors [Host vendor specific log]
SMART Log at address 0x99 has   16 sectors [Host vendor specific log]
SMART Log at address 0x9a has   16 sectors [Host vendor specific log]
SMART Log at address 0x9b has   16 sectors [Host vendor specific log]
SMART Log at address 0x9c has   16 sectors [Host vendor specific log]
SMART Log at address 0x9d has   16 sectors [Host vendor specific log]
SMART Log at address 0x9e has   16 sectors [Host vendor specific log]
SMART Log at address 0x9f has   16 sectors [Host vendor specific log]
SMART Log at address 0xa1 has   20 sectors [Device vendor specific log]
SMART Log at address 0xa8 has  129 sectors [Device vendor specific log]
SMART Log at address 0xa9 has    1 sectors [Device vendor specific log]
SMART Log at address 0xbd has  252 sectors [Device vendor specific log]
SMART Log at address 0xc0 has    1 sectors [Device vendor specific log]
SMART Log at address 0xe0 has    1 sectors [SCT Command/Status]
SMART Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log (GP Log 0x03) not supported
SMART Error Log Version: 1
ATA Error Count: 204 (device log contains only the most recent five errors)
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

Error 204 occurred at disk power-on lifetime: 22591 hours (941 days + 7 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 c0 08 00 00  Error: UNC at LBA = 0x000008c0 = 2240

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   42 0b 00 c0 08 00 e0 00      00:42:42.402  READ VERIFY SECTOR(S) EXT
   42 0b 00 bd 08 00 e0 00      00:42:38.690  READ VERIFY SECTOR(S) EXT
   42 0b 00 ba 08 00 e0 00      00:42:35.017  READ VERIFY SECTOR(S) EXT
   42 0b 00 b7 08 00 e0 00      00:42:31.314  READ VERIFY SECTOR(S) EXT
   42 0b 00 b5 08 00 e0 00      00:42:27.631  READ VERIFY SECTOR(S) EXT

Error 203 occurred at disk power-on lifetime: 22591 hours (941 days + 7 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 bf 08 00 00  Error: UNC at LBA = 0x000008bf = 2239

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   42 0b 00 bd 08 00 e0 00      00:42:38.690  READ VERIFY SECTOR(S) EXT
   42 0b 00 ba 08 00 e0 00      00:42:35.017  READ VERIFY SECTOR(S) EXT
   42 0b 00 b7 08 00 e0 00      00:42:31.314  READ VERIFY SECTOR(S) EXT
   42 0b 00 b5 08 00 e0 00      00:42:27.631  READ VERIFY SECTOR(S) EXT
   42 0b 00 b4 08 00 e0 00      00:42:23.908  READ VERIFY SECTOR(S) EXT

Error 202 occurred at disk power-on lifetime: 22591 hours (941 days + 7 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 bc 08 00 00  Error: UNC at LBA = 0x000008bc = 2236

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   42 0b 00 ba 08 00 e0 00      00:42:35.017  READ VERIFY SECTOR(S) EXT
   42 0b 00 b7 08 00 e0 00      00:42:31.314  READ VERIFY SECTOR(S) EXT
   42 0b 00 b5 08 00 e0 00      00:42:27.631  READ VERIFY SECTOR(S) EXT
   42 0b 00 b4 08 00 e0 00      00:42:23.908  READ VERIFY SECTOR(S) EXT
   42 0b 00 b0 08 00 e0 00      00:42:20.225  READ VERIFY SECTOR(S) EXT

Error 201 occurred at disk power-on lifetime: 22591 hours (941 days + 7 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 b9 08 00 00  Error: UNC at LBA = 0x000008b9 = 2233

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   42 0b 00 b7 08 00 e0 00      00:42:31.314  READ VERIFY SECTOR(S) EXT
   42 0b 00 b5 08 00 e0 00      00:42:27.631  READ VERIFY SECTOR(S) EXT
   42 0b 00 b4 08 00 e0 00      00:42:23.908  READ VERIFY SECTOR(S) EXT
   42 0b 00 b0 08 00 e0 00      00:42:20.225  READ VERIFY SECTOR(S) EXT
   42 0b 00 af 08 00 e0 00      00:42:16.513  READ VERIFY SECTOR(S) EXT

Error 200 occurred at disk power-on lifetime: 22591 hours (941 days + 7 
hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER ST SC SN CL CH DH
   -- -- -- -- -- -- --
   40 51 00 b6 08 00 00  Error: UNC at LBA = 0x000008b6 = 2230

   Commands leading to the command that caused the error were:
   CR FR SC SN CL CH DH DC   Powered_Up_Time  Command/Feature_Name
   -- -- -- -- -- -- -- --  ----------------  --------------------
   42 0b 00 b5 08 00 e0 00      00:42:27.631  READ VERIFY SECTOR(S) EXT
   42 0b 00 b4 08 00 e0 00      00:42:23.908  READ VERIFY SECTOR(S) EXT
   42 0b 00 b0 08 00 e0 00      00:42:20.225  READ VERIFY SECTOR(S) EXT
   42 0b 00 af 08 00 e0 00      00:42:16.513  READ VERIFY SECTOR(S) EXT
   42 0b 00 ae 08 00 e0 00      00:42:12.850  READ VERIFY SECTOR(S) EXT

SMART Extended Self-test Log (GP Log 0x07) not supported
SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining 
LifeTime(hours)  LBA_of_first_error
# 1  Short offline       Completed: read failure       90% 22591         
2241
# 2  Short offline       Completed: read failure       90% 22591         
2058
# 3  Short offline       Completed: read failure       90% 22591         
2058

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
Current Temperature:                    47 Celsius
Power Cycle Min/Max Temperature:     42/47 Celsius
Lifetime    Min/Max Temperature:     18/58 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         10 minutes
Temperature Logging Interval:        59 minutes
Min/Max recommended Temperature:     14/55 Celsius
Min/Max Temperature Limit:           10/60 Celsius
Temperature History Size (Index):    128 (20)

Index    Estimated Time   Temperature Celsius
   21    2013-09-10 08:24    49  ******************************
   22    2013-09-10 09:23    48  *****************************
  ...    ..(  7 skipped).    ..  *****************************
   30    2013-09-10 17:15    48  *****************************
   31    2013-09-10 18:14    49  ******************************
   32    2013-09-10 19:13    50  *******************************
   33    2013-09-10 20:12    51  ********************************
   34    2013-09-10 21:11    50  *******************************
   35    2013-09-10 22:10    55 ************************************
   36    2013-09-10 23:09    55 ************************************
   37    2013-09-11 00:08    54 ***********************************
   38    2013-09-11 01:07    52  *********************************
   39    2013-09-11 02:06    50  *******************************
   40    2013-09-11 03:05    53  **********************************
   41    2013-09-11 04:04    51  ********************************
   42    2013-09-11 05:03    50  *******************************
   43    2013-09-11 06:02    49  ******************************
   44    2013-09-11 07:01    54 ***********************************
   45    2013-09-11 08:00    55 ************************************
   46    2013-09-11 08:59    55 ************************************
   47    2013-09-11 09:58    53  **********************************
   48    2013-09-11 10:57    50  *******************************
   49    2013-09-11 11:56    49  ******************************
  ...    ..(  5 skipped).    ..  ******************************
   55    2013-09-11 17:50    49  ******************************
   56    2013-09-11 18:49    50  *******************************
   57    2013-09-11 19:48    52  *********************************
   58    2013-09-11 20:47    51  ********************************
   59    2013-09-11 21:46    55 ************************************
   60    2013-09-11 22:45    56 *************************************
   61    2013-09-11 23:44    55 ************************************
   62    2013-09-12 00:43    55 ************************************
   63    2013-09-12 01:42    52  *********************************
   64    2013-09-12 02:41    52  *********************************
   65    2013-09-12 03:40    54 ***********************************
   66    2013-09-12 04:39    50  *******************************
   67    2013-09-12 05:38    49  ******************************
  ...    ..( 11 skipped).    ..  ******************************
   79    2013-09-12 17:26    49  ******************************
   80    2013-09-12 18:25    50  *******************************
   81    2013-09-12 19:24    55 ************************************
   82    2013-09-12 20:23    52  *********************************
   83    2013-09-12 21:22    55 ************************************
   84    2013-09-12 22:21    56 *************************************
   85    2013-09-12 23:20    55 ************************************
   86    2013-09-13 00:19    54 ***********************************
   87    2013-09-13 01:18    51  ********************************
   88    2013-09-13 02:17    52  *********************************
   89    2013-09-13 03:16    53  **********************************
   90    2013-09-13 04:15    50  *******************************
   91    2013-09-13 05:14    49  ******************************
  ...    ..(  3 skipped).    ..  ******************************
   95    2013-09-13 09:10    49  ******************************
   96    2013-09-13 10:09    50  *******************************
   97    2013-09-13 11:08    50  *******************************
   98    2013-09-13 12:07    49  ******************************
  ...    ..(  3 skipped).    ..  ******************************
  102    2013-09-13 16:03    49  ******************************
  103    2013-09-13 17:02    53  **********************************
  104    2013-09-13 18:01    56 *************************************
  105    2013-09-13 19:00    57 **************************************
  106    2013-09-13 19:59    53  **********************************
  107    2013-09-13 20:58    56 *************************************
  108    2013-09-13 21:57    56 *************************************
  109    2013-09-13 22:56    56 *************************************
  110    2013-09-13 23:55    51  ********************************
  111    2013-09-14 00:54    51  ********************************
  112    2013-09-14 01:53    50  *******************************
  113    2013-09-14 02:52    50  *******************************
  114    2013-09-14 03:51    49  ******************************
  ...    ..(  4 skipped).    ..  ******************************
  119    2013-09-14 08:46    49  ******************************
  120    2013-09-14 09:45    50  *******************************
  ...    ..(  5 skipped).    ..  *******************************
  126    2013-09-14 15:39    50  *******************************
  127    2013-09-14 16:38     ?  -
    0    2013-09-14 17:37    49  ******************************
    1    2013-09-14 18:36     ?  -
    2    2013-09-14 19:35    48  *****************************
    3    2013-09-14 20:34     ?  -
    4    2013-09-14 21:33    22  ***
    5    2013-09-14 22:32     ?  -
    6    2013-09-14 23:31    27  ********
    7    2013-09-15 00:30     ?  -
    8    2013-09-15 01:29    28  *********
    9    2013-09-15 02:28     ?  -
   10    2013-09-15 03:27    42  ***********************
   11    2013-09-15 04:26     ?  -
   12    2013-09-15 05:25    42  ***********************
   13    2013-09-15 06:24     ?  -
   14    2013-09-15 07:23    42  ***********************
   15    2013-09-15 08:22     ?  -
   16    2013-09-15 09:21    42  ***********************
   17    2013-09-15 10:20    42  ***********************
   18    2013-09-15 11:19    45  **************************
   19    2013-09-15 12:18    47  ****************************
   20    2013-09-15 13:17    47  ****************************

SCT Error Recovery Control:
            Read: Disabled
           Write: Disabled

SATA Phy Event Counters (GP Log 0x11) not supported
HTH, Phil


Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B7BCE7A89
	for <linux-raid@archiver.kernel.org>; Sat, 23 Sep 2023 10:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjIWKzG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 23 Sep 2023 06:55:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229848AbjIWKzF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 23 Sep 2023 06:55:05 -0400
Received: from micaiah.parthemores.com (micaiah.parthemores.com [199.26.172.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD34CC2
        for <linux-raid@vger.kernel.org>; Sat, 23 Sep 2023 03:54:55 -0700 (PDT)
Received: from [192.168.50.170] (h-155-4-132-6.NA.cust.bahnhof.se [155.4.132.6])
        by micaiah.parthemores.com (Postfix) with ESMTPSA id DECB9300A6B
        for <linux-raid@vger.kernel.org>; Sat, 23 Sep 2023 12:53:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parthemores.com;
        s=micaiah; t=1695466437;
        bh=52h2OFr3M/skxvZjIGi2CtCCabBnVhGuh3IirATqwdg=;
        h=Date:From:Subject:To;
        b=NFeyVwtWBL9a1hDsjK/Zsjqt0TzL0xbGnT+dzA39e17WEI7mb+gb7c5q5vQrIWvj/
         qQ+0f9B8K4GA4U50KYOjdu+WilTM20WxD3aJO1jCBmxhXUcxu6dD4xTRVQtiCC7Elo
         HSZBWYO5PQ3+yoMzKpJFEp2EXG77vv0B8s9BnORA=
Message-ID: <507b6ab0-fd8f-d770-ba82-28def5f53d25@parthemores.com>
Date:   Sat, 23 Sep 2023 12:54:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
From:   Joel Parthemore <joel@parthemores.com>
Subject: request for help on IMSM-metadata RAID-5 array
To:     linux-raid@vger.kernel.org
Content-Language: en-GB
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Apologies in advance for the long email, but I wanted to include 
everything that is asked for on the "asking for help" page associated 
with the mailing list. The output from some of the requested commands is 
pretty lengthy.

My home directory is on a three-disk RAID-5 array that, for whatever 
reason (it seemed like a good idea at the time?), I built using the 
hooks from the UEFI BIOS (or so I understand what I did). That is to 
say, it's a "real" software-based RAID array in Linux that's built on a 
"fake" RAID array in the UEFI BIOS. Mostly nothing important is stored 
on the /home partition, but I forgot to back up a few important things 
that are (or, at least, were). So I'd like to get the RAID array back if 
I can, or know if I can't; and I will be extremely grateful to anyone 
who can tell me one way or the other.

All was well for some number of years until a few days ago. After I 
installed the latest KDE updates, the RAID array would lock up entirely 
when I tried to log in to a new KDE Wayland session. It all came down to 
one process that refused to die, running startplasma-wayland. Because 
the process refused to die, the RAID array could not be stopped cleanly 
and rebooting the computer therefore caused the RAID array to go out of 
sync. After that, any attempt whatsoever to access the RAID array would 
cause the RAID array to lock up again.

The first few times this happened, I was able to start the computer 
without starting the RAID array, reassemble the RAID array using the 
command mdadm --assemble --run --force /dev/md126 /dev/sda /dev/sde 
/dev/sdc and have it working fine -- I could fix any filestore problems 
with e2fsck, mount /home, log in to my home directory, do pretty much 
whatever I wanted -- until I tried logging into a new KDE Wayland 
session again. This happened several times while I was trying to 
troubleshoot the problem with startplasma-wayland.

Unfortunately, one time this didn't work. I was still able to start the 
computer without starting the RAID array, reassemble it and reboot with 
the RAID array looking seemingly okay (according to mdadm -D) BUT this 
time, any attempt to access the RAID array or even just stop the array 
(mdadm --stop /dev/md126, mdadm --stop /dev/md127) once it was started 
would cause the RAID array to lock up. That means (I think) that I can't 
create an image of the array contents using dd, which is what -- of 
course -- I should have done in the first place. (I could assemble the 
RAID array read-only, but the RAID array is out of sync because it 
didn't shut down properly.)

I'm guessing that the contents of the filestore on the RAID array are 
probably still there. Does anyone have suggestions on getting the RAID 
array working properly again and accessing them? I have avoided doing 
anything further myself because, of course, if the contents of the 
filestore are still there, I don't want to do anything to jeopardize 
them. You may tell me that I've done too much already. :-)


uname -a

Linux bjoernbaer 6.5.3-gentoo #7 SMP PREEMPT_DYNAMIC Wed Sep 20 22:46:24 
CEST 2023 x86_64 Intel(R) Core(TM) i9-10900K CPU @ 3.70GHz GenuineIntel 
GNU/Linux


mdadm --version

mdadm - v4.2 - 2021-12-30


cat /proc/mdstat

Personalities : [raid6] [raid5] [raid4]
md126 : active raid5 sda[2] sde[1] sdd[0]
       1953513472 blocks super external:/md127/0 level 5, 128k chunk, 
algorithm 0 [3/3] [UUU]

md127 : inactive sdd[2](S) sda[1](S) sde[0](S)
       15603 blocks super external:imsm

unused devices: <none>


mdstat -D /dev/md126

/dev/md126:
          Container : /dev/md/imsm0, member 0
         Raid Level : raid5
         Array Size : 1953513472 (1863.02 GiB 2000.40 GB)
      Used Dev Size : 976756736 (931.51 GiB 1000.20 GB)
       Raid Devices : 3
      Total Devices : 3

              State : clean
     Active Devices : 3
    Working Devices : 3
     Failed Devices : 0

             Layout : left-asymmetric
         Chunk Size : 128K

Consistency Policy : resync


               UUID : aa989aae:6526b858:7b1edb5f:4f4b2686
     Number   Major   Minor   RaidDevice State
        2       8        0        0      active sync   /dev/sda
        1       8       64        1      active sync   /dev/sde
        0       8       48        2      active sync   /dev/sdd

mdstat -D /dev/md127

/dev/md127:
            Version : imsm
         Raid Level : container
      Total Devices : 3

    Working Devices : 3


               UUID : 01ce9128:9a9d46c6:efc9650f:28fe9662
      Member Arrays : /dev/md/vol0

     Number   Major   Minor   RaidDevice

        -       8       64        -        /dev/sde
        -       8        0        -        /dev/sda
        -       8       48        -        /dev/sdd


The output of smartctl --xall /dev/sdX and lsdrv follows.

smartctl --xall /dev/sda

smartctl 7.4 2023-08-01 r5530 [x86_64-linux-6.5.3-gentoo] (local build)
Copyright (C) 2002-23, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Blue
Device Model:     WDC WD10EZEX-75WN4A1
Serial Number:    WD-WCC6Y3LCXY73
LU WWN Device Id: 5 0014ee 2bcc2d9cf
Firmware Version: 13057113
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database 7.3/5533
ATA Version is:   ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Sep 23 09:33:42 2023 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

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
data collection:         (11580) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 120) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x3035)    SCT Status supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
   3 Spin_Up_Time            POS--K   179   170   021    -    2050
   4 Start_Stop_Count        -O--CK   099   099   000    -    1171
   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
   7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
   9 Power_On_Hours          -O--CK   079   079   000    -    15674
  10 Spin_Retry_Count        -O--CK   100   100   000    -    0
  11 Calibration_Retry_Count -O--CK   100   100   000    -    0
  12 Power_Cycle_Count       -O--CK   099   099   000    -    1171
192 Power-Off_Retract_Count -O--CK   200   200   000    -    192
193 Load_Cycle_Count        -O--CK   138   138   000    - 187769
194 Temperature_Celsius     -O---K   104   084   000    -    39
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
240 Head_Flying_Hours       -O--CK   082   082   000    -    13596
241 Total_LBAs_Written      -O--CK   200   200   000    - 11248575141
242 Total_LBAs_Read         -O--CK   200   200   000    - 148189090777
                             ||||||_ K auto-keep
                             |||||__ C event count
                             ||||___ R error rate
                             |||____ S speed/performance
                             ||_____ O updated online
                             |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb6  GPL,SL  VS       1  Device vendor specific log
0xb7       GPL,SL  VS      48  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Device Error Count: 2
     CR     = Command Register
     FEATR  = Features Register
     COUNT  = Count (was: Sector Count) Register
     LBA_48 = Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
     LH     = LBA High (was: Cylinder High) Register    ]   LBA
     LM     = LBA Mid (was: Cylinder Low) Register      ] Register
     LL     = LBA Low (was: Sector Number) Register     ]
     DV     = Device (was: Device/Head) Register
     DC     = Device Control Register
     ER     = Error register
     ST     = Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
SS=sec, and sss=millisec. It "wraps" after 49.710 days.

Error 2 [1] occurred at disk power-on lifetime: 13994 hours (583 days + 
2 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 00 00 00 00 18 a5 f5 80 40 00  Error: UNC at LBA = 
0x18a5f580 = 413529472

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 00 08 00 c0 00 00 18 a5 f9 48 40 08  1d+13:49:57.480  READ FPDMA 
QUEUED
   60 00 08 00 b8 00 00 18 a5 f9 50 40 08  1d+13:49:57.480  READ FPDMA 
QUEUED
   60 00 08 00 b0 00 00 18 a5 f9 58 40 08  1d+13:49:57.480  READ FPDMA 
QUEUED
   60 00 20 00 a8 00 00 18 a7 eb e0 40 08  1d+13:49:57.480  READ FPDMA 
QUEUED
   60 00 08 00 20 00 00 18 a5 f5 80 40 08  1d+13:49:57.448  READ FPDMA 
QUEUED

Error 1 [0] occurred at disk power-on lifetime: 13994 hours (583 days + 
2 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 00 00 00 00 18 a5 f5 80 40 00  Error: UNC at LBA = 
0x18a5f580 = 413529472

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 05 40 00 18 00 00 18 a6 91 a0 40 08  1d+13:49:52.955  READ FPDMA 
QUEUED
   60 05 40 00 10 00 00 18 a6 8c 60 40 08  1d+13:49:52.951  READ FPDMA 
QUEUED
   60 05 40 00 08 00 00 18 a6 87 20 40 08  1d+13:49:52.946  READ FPDMA 
QUEUED
   60 05 40 00 00 00 00 18 a6 81 e0 40 08  1d+13:49:52.943  READ FPDMA 
QUEUED
   60 05 40 00 f8 00 00 18 a6 7c a0 40 08  1d+13:49:52.940  READ FPDMA 
QUEUED

SMART Extended Self-test Log Version: 1 (1 sectors)
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

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
SCT Version (vendor specific):       258 (0x0102)
Device State:                        Active (0)
Current Temperature:                    39 Celsius
Power Cycle Min/Max Temperature:     23/44 Celsius
Lifetime    Min/Max Temperature:     17/58 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (358)

Index    Estimated Time   Temperature Celsius
  359    2023-09-23 01:36    39  ********************
  ...    ..( 23 skipped).    ..  ********************
  383    2023-09-23 02:00    39  ********************
  384    2023-09-23 02:01    38  *******************
  385    2023-09-23 02:02    39  ********************
  386    2023-09-23 02:03    39  ********************
  387    2023-09-23 02:04    39  ********************
  388    2023-09-23 02:05    38  *******************
  389    2023-09-23 02:06    39  ********************
  390    2023-09-23 02:07    38  *******************
  ...    ..(144 skipped).    ..  *******************
   57    2023-09-23 04:32    38  *******************
   58    2023-09-23 04:33    39  ********************
  ...    ..( 18 skipped).    ..  ********************
   77    2023-09-23 04:52    39  ********************
   78    2023-09-23 04:53    38  *******************
  ...    ..(  4 skipped).    ..  *******************
   83    2023-09-23 04:58    38  *******************
   84    2023-09-23 04:59    39  ********************
  ...    ..( 17 skipped).    ..  ********************
  102    2023-09-23 05:17    39  ********************
  103    2023-09-23 05:18    40  *********************
  ...    ..( 30 skipped).    ..  *********************
  134    2023-09-23 05:49    40  *********************
  135    2023-09-23 05:50    39  ********************
  ...    ..(222 skipped).    ..  ********************
  358    2023-09-23 09:33    39  ********************

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

Pending Defects log (GP Log 0x0c) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           38  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           40  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4       223809  Vendor specific

smartctl --xall /dev/sde

smartctl 7.4 2023-08-01 r5530 [x86_64-linux-6.5.3-gentoo] (local build)
Copyright (C) 2002-23, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Blue
Device Model:     WDC WD10EZEX-75WN4A1
Serial Number:    WD-WCC6Y5KP9A25
LU WWN Device Id: 5 0014ee 21217afbc
Firmware Version: 13057113
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database 7.3/5533
ATA Version is:   ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Sep 23 09:33:46 2023 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

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
data collection:         (11100) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 115) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x3035)    SCT Status supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
   3 Spin_Up_Time            POS--K   175   166   021    -    2208
   4 Start_Stop_Count        -O--CK   099   099   000    -    1171
   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
   7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
   9 Power_On_Hours          -O--CK   079   079   000    -    15673
  10 Spin_Retry_Count        -O--CK   100   100   000    -    0
  11 Calibration_Retry_Count -O--CK   100   100   000    -    0
  12 Power_Cycle_Count       -O--CK   099   099   000    -    1171
192 Power-Off_Retract_Count -O--CK   200   200   000    -    192
193 Load_Cycle_Count        -O--CK   136   136   000    - 192695
194 Temperature_Celsius     -O---K   106   087   000    -    37
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    1
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
240 Head_Flying_Hours       -O--CK   082   082   000    -    13573
241 Total_LBAs_Written      -O--CK   200   200   000    - 11125049534
242 Total_LBAs_Read         -O--CK   200   200   000    - 148752593578
                             ||||||_ K auto-keep
                             |||||__ C event count
                             ||||___ R error rate
                             |||____ S speed/performance
                             ||_____ O updated online
                             |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb6  GPL,SL  VS       1  Device vendor specific log
0xb7       GPL,SL  VS      48  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

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
SCT Version (vendor specific):       258 (0x0102)
Device State:                        Active (0)
Current Temperature:                    37 Celsius
Power Cycle Min/Max Temperature:     23/41 Celsius
Lifetime    Min/Max Temperature:     17/55 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (278)

Index    Estimated Time   Temperature Celsius
  279    2023-09-23 01:36    37  ******************
  ...    ..(220 skipped).    ..  ******************
   22    2023-09-23 05:17    37  ******************
   23    2023-09-23 05:18    38  *******************
  ...    ..( 86 skipped).    ..  *******************
  110    2023-09-23 06:45    38  *******************
  111    2023-09-23 06:46    37  ******************
  112    2023-09-23 06:47    38  *******************
  113    2023-09-23 06:48    37  ******************
  114    2023-09-23 06:49    37  ******************
  115    2023-09-23 06:50    38  *******************
  116    2023-09-23 06:51    37  ******************
  ...    ..(  4 skipped).    ..  ******************
  121    2023-09-23 06:56    37  ******************
  122    2023-09-23 06:57    38  *******************
  123    2023-09-23 06:58    37  ******************
  ...    ..(  5 skipped).    ..  ******************
  129    2023-09-23 07:04    37  ******************
  130    2023-09-23 07:05    38  *******************
  131    2023-09-23 07:06    37  ******************
  ...    ..(146 skipped).    ..  ******************
  278    2023-09-23 09:33    37  ******************

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

Pending Defects log (GP Log 0x0c) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           46  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           48  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4       223816  Vendor specific

smartctl --xall /dev/sdd

smartctl 7.4 2023-08-01 r5530 [x86_64-linux-6.5.3-gentoo] (local build)
Copyright (C) 2002-23, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital Blue
Device Model:     WDC WD10EZEX-75WN4A1
Serial Number:    WD-WCC6Y3NF1PD2
LU WWN Device Id: 5 0014ee 2676cfff8
Firmware Version: 13057113
User Capacity:    1,000,204,886,016 bytes [1.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database 7.3/5533
ATA Version is:   ACS-3 T13/2161-D revision 3b
SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Sat Sep 23 09:33:49 2023 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

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
data collection:         (10740) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 112) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x3035)    SCT Status supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
   3 Spin_Up_Time            POS--K   178   169   021    -    2075
   4 Start_Stop_Count        -O--CK   099   099   000    -    1171
   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
   7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
   9 Power_On_Hours          -O--CK   079   079   000    -    15674
  10 Spin_Retry_Count        -O--CK   100   100   000    -    0
  11 Calibration_Retry_Count -O--CK   100   100   000    -    0
  12 Power_Cycle_Count       -O--CK   099   099   000    -    1171
192 Power-Off_Retract_Count -O--CK   200   200   000    -    193
193 Load_Cycle_Count        -O--CK   139   139   000    - 184449
194 Temperature_Celsius     -O---K   104   085   000    -    39
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    1
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
240 Head_Flying_Hours       -O--CK   082   082   000    -    13577
241 Total_LBAs_Written      -O--CK   200   200   000    - 10965137767
242 Total_LBAs_Read         -O--CK   200   200   000    - 149454382073
                             ||||||_ K auto-keep
                             |||||__ C event count
                             ||||___ R error rate
                             |||____ S speed/performance
                             ||_____ O updated online
                             |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
Address    Access  R/W   Size  Description
0x00       GPL,SL  R/O      1  Log Directory
0x01           SL  R/O      1  Summary SMART error log
0x02           SL  R/O      5  Comprehensive SMART error log
0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb6  GPL,SL  VS       1  Device vendor specific log
0xb7       GPL,SL  VS      48  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      93  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
No Errors Logged

SMART Extended Self-test Log Version: 1 (1 sectors)
No self-tests have been logged.  [To run self-tests, use: smartctl -t]

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
SCT Version (vendor specific):       258 (0x0102)
Device State:                        Active (0)
Current Temperature:                    39 Celsius
Power Cycle Min/Max Temperature:     23/45 Celsius
Lifetime    Min/Max Temperature:     17/58 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (333)

Index    Estimated Time   Temperature Celsius
  334    2023-09-23 01:36    39  ********************
  ...    ..(220 skipped).    ..  ********************
   77    2023-09-23 05:17    39  ********************
   78    2023-09-23 05:18    41  **********************
   79    2023-09-23 05:19    40  *********************
   80    2023-09-23 05:20    40  *********************
   81    2023-09-23 05:21    41  **********************
   82    2023-09-23 05:22    41  **********************
   83    2023-09-23 05:23    40  *********************
   84    2023-09-23 05:24    41  **********************
   85    2023-09-23 05:25    40  *********************
  ...    ..(  2 skipped).    ..  *********************
   88    2023-09-23 05:28    40  *********************
   89    2023-09-23 05:29    41  **********************
   90    2023-09-23 05:30    40  *********************
  ...    ..(182 skipped).    ..  *********************
  273    2023-09-23 08:33    40  *********************
  274    2023-09-23 08:34    39  ********************
  275    2023-09-23 08:35    40  *********************
  276    2023-09-23 08:36    39  ********************
  ...    ..( 56 skipped).    ..  ********************
  333    2023-09-23 09:33    39  ********************

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

Pending Defects log (GP Log 0x0c) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0008  2            0  Device-to-host non-data FIS retries
0x0009  2           46  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2           48  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4       223818  Vendor specific


lsdrv

PCI [nvme] 03:00.0 Non-Volatile memory controller: Intel Corporation SSD 
660P Series (rev 03)
└nvme nvme0 INTEL SSDPEKNW010T8 {BTNH94442DT11P0B}
  └nvme0n1 953.87g [259:0] ext4 'work' 
{86c116a2-351a-4b71-b54a-e92e8adbb9c7}
   └Mounted as /dev/nvme0n1 @ /work
PCI [nvme] 09:00.0 Non-Volatile memory controller: Intel Corporation SSD 
660P Series (rev 03)
└nvme nvme1 INTEL SSDPEKNW010T8 {BTNH94141GH01P0B}
  └nvme1n1 953.87g [259:1] ext4 {8a83519a-9bec-4d5b-9303-f8ce71cfe36c}
PCI [ahci] 00:17.0 RAID bus controller: Intel Corporation Comet Lake 
PCH-H RAID
├scsi 0:0:0:0 ATA      WDC WD10EZEX-75W {WD-WCC6Y3LCXY73}
│└sda 931.51g [8:0] isw_raid_member
│ ├md126 1.82t [9:126] MD vexternal:/md127/0 raid5 (3) write-pending, 
128k Chunk {00000000:-0000-00:00-0000-:000000000000}
│ │                    ext4 'HOME' {2f44f848-3665-4663-a0d7-70e19ad99b30}
│ └md127 0.00k [9:127] MD vexternal:imsm  () inactive, None (None) None 
{00000000:-0000-00:00-0000-:000000000000}
│                      Empty/Unknown
├scsi 1:0:0:0 TSSTcorp DVDWBD SH-B123L  {R84A6GDC2003Y7}
│└sr0 1.00g [11:0] Empty/Unknown
├scsi 2:0:0:0 ATA      Corsair Neutron  {12437904000021010029}
│└sdb 447.13g [8:16] Partitioned (gpt)
│ ├sdb1 92.00m [8:17] vfat 'EFI' {AD3D-F277}
│ │└Mounted as /dev/sdb1 @ /boot/efi
│ ├sdb2 977.00m [8:18] swap 'swap' {f5fafe65-ed0f-48fe-91e1-e9244d372f1e}
│ ├sdb3 976.00m [8:19] ext4 'boot' {763fb069-ad45-4f2d-b887-d6673cdbe74f}
│ │└Mounted as /dev/sdb3 @ /boot
│ └sdb4 445.10g [8:20] ext4 'root' {6bd121cd-69a4-41eb-b469-cfbb2e91022f}
│  └Mounted as /dev/root @ /
├scsi 3:0:0:0 ATA      ST2000DM008-2UB1 {ZK30CAMT}
│└sdc 1.82t [8:32] ext4 'HOME' {2f44f848-3665-4663-a0d7-70e19ad99b30}
├scsi 4:0:0:0 ATA      WDC WD10EZEX-75W {WD-WCC6Y3NF1PD2}
│└sdd 931.51g [8:48] isw_raid_member
│ ├md126 1.82t [9:126] MD vexternal:/md127/0 raid5 (3) write-pending, 
128k Chunk {00000000:-0000-00:00-0000-:000000000000}
│ │                    ext4 'HOME' {2f44f848-3665-4663-a0d7-70e19ad99b30}
└scsi 5:0:0:0 ATA      WDC WD10EZEX-75W {WD-WCC6Y5KP9A25}
  └sde 931.51g [8:64] isw_raid_member
   ├md126 1.82t [9:126] MD vexternal:/md127/0 raid5 (3) write-pending, 
128k Chunk {00000000:-0000-00:00-0000-:000000000000}
   │                    ext4 'HOME' {2f44f848-3665-4663-a0d7-70e19ad99b30}
PCI [ahci] 05:00.0 SATA controller: ASMedia Technology Inc. ASM1062 
Serial ATA Controller (rev 02)
└scsi 6:x:x:x [Empty]
USB [usb-storage] Bus 005 Device 002: ID 1058:1100 Western Digital 
Technologies, Inc. My Book Essential Edition 2.0 (WDH1U) 
{57442D574D41535530313138313235}
└scsi 8:0:0:0 WD       5000AAC External {WD-WMASU0118125}
  └sdf 465.76g [8:80] Partitioned (mac)
USB [usb-storage] Bus 001 Device 016: ID 0781:5595 SanDisk Corp. SanDisk 
3.2Gen1 {00010320101721124020}
└scsi 9:0:0:0  USB      SanDisk 3.2Gen1 {00010320101721124020}
  └sdg 114.56g [8:96] Partitioned (dos)
   └sdg1 114.56g [8:97] vfat 'UUI' {FBA7-BB71}
    └Mounted as /dev/sdg1 @ /mnt/tmp
USB [usb-storage] Bus 001 Device 015: ID 174c:55aa ASMedia Technology 
Inc. ASM1051E SATA 6Gb/s bridge, ASM1053E SATA 6Gb/s bridge, ASM1153 
SATA 3Gb/s bridge, ASM1153E SATA 6Gb/s bridge {0000000002F8}
└scsi 10:0:0:0 ST1000DM 003-9YN162       {S1D254AM}
  └sdh 931.51g [8:112] Partitioned (dos)
   └sdh1 931.51g [8:113] ext4 'BACKUP' 
{161c4a60-6abd-458e-ab2b-00c6365095a7}
    └Mounted as /dev/sdh1 @ /backup
Other Block Devices
├loop0 0.00k [7:0] Empty/Unknown
├loop1 0.00k [7:1] Empty/Unknown
├loop2 0.00k [7:2] Empty/Unknown
├loop3 0.00k [7:3] Empty/Unknown
├loop4 0.00k [7:4] Empty/Unknown
├loop5 0.00k [7:5] Empty/Unknown
├loop6 0.00k [7:6] Empty/Unknown
└loop7 0.00k [7:7] Empty/Unknown


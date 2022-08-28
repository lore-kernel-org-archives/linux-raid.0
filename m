Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3539ECAAD1
	for <linux-raid@archiver.kernel.org>; Sun, 28 Aug 2022 02:00:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbiH1CAu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 27 Aug 2022 22:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiH1CAt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 27 Aug 2022 22:00:49 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC653ED41
        for <linux-raid@vger.kernel.org>; Sat, 27 Aug 2022 19:00:45 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id h14so934190ilh.10
        for <linux-raid@vger.kernel.org>; Sat, 27 Aug 2022 19:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc;
        bh=/8+aO8Q+rEgl+pEr70neF1QB/MZLZiQhbR8hwCumhas=;
        b=dpvqOCYPP64YtmgGi2+zeRmcunESnxY1n0/0nNWDJN1nseOYGfSOykxwW9Lbv2K3A9
         an/ci93evdLIYmX3eivEcwM07psWh5AFCcpLoNrngTRbtv6q7sHdh8EMKyhadHBwwaVi
         koUaM6diohSAu0JH2CRzRV9K6p7WlPWnpRU7LUYjysQxChW7ReyVkkDJ+1mTAWty4lv+
         OvkW52liTKcrJHAGfYrrJXeBK13y/7on1nYuCkctiRRZ8hwIKkib2ZYbJRyU+ssUxYA1
         j3BzyceWP/EqV21WvDb3DuUVBRSFac1bkEYQMv9Dwxnqjed+ztEoUdtPqew9O1SC/unu
         +tEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/8+aO8Q+rEgl+pEr70neF1QB/MZLZiQhbR8hwCumhas=;
        b=uvA+lDCXeE5yzVYaXAtEsfcD0Lr6KABn/5t4HVjyPY6W0poXg2PqI+7VbTw02U59X2
         fxE4upyWC96sg1cSSFkODN1loBiShL1WAYpwNqTXKlmqScPnj6RHRwk3Rhq+zbqbwQMr
         TgT8v3p+69fvSOrgibXeJi9GiOoDCNKMMAfQXDKzOphWqE7REKxOHjYcLG00+Ia3gyAC
         SrB+4vdstUCORhEnxwl+oCKFmm62scftaLBUnicPxeFUxgP677bNwlvq+MUh/S6NZ8HF
         yhBbqkjD/hbvI/I0Aqvswcq+Z0rBg1Hbtc682IKE5KakRc9KZR3hxTDSMVGECw2TfzON
         +6Cg==
X-Gm-Message-State: ACgBeo2zjBfyTpOHWXio4W0pzQkcddOheqPLIIxEaJjkAyX5AtLgI6Ea
        XyanXZEG3saOX886iBUiGW6XxB7bVfxhu1IFJRukD3gU+A==
X-Google-Smtp-Source: AA6agR4b03OEwqrxHYfXnajxaUnplQllzJKcWXDza7GN8SJKOUfdKos59j/2cDJ3IAhzsR5kPorB/zN7SLReZHOVFXI=
X-Received: by 2002:a05:6e02:1347:b0:2ea:e939:fef1 with SMTP id
 k7-20020a056e02134700b002eae939fef1mr1180060ilr.114.1661652043953; Sat, 27
 Aug 2022 19:00:43 -0700 (PDT)
MIME-Version: 1.0
From:   Peter Sanders <plsander@gmail.com>
Date:   Sat, 27 Aug 2022 22:00:32 -0400
Message-ID: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
Subject: RAID 6, 6 device array - all devices lost superblock
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

have a RAID 6 array, 6 devices.  Been running it for years without much iss=
ue.

Had hardware issues with my system - ended up replacing the
motherboard, video card, and power supply and re-installing the OS
(Debian 11).

As the hardware issues evolved, I'd crash, reboot, un-mount the array,
run fsck, mount and continue on my way - no problems.

After the hardware was replaced, my array will not assemble - mdadm
assemble reports no RAID superblock on the devices.
root@superior:/etc/mdadm# mdadm --assemble --scan --verbose
mdadm: looking for devices for /dev/md/0
mdadm: cannot open device /dev/sr0: No medium found
mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got 00000=
000)
mdadm: no RAID superblock on /dev/sda
mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 00000=
000)
mdadm: no RAID superblock on /dev/sdb

Examine reports
/dev/sda:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)

Searching for these results indicate I can rebuild the superblock, but
details on how to do that are lacking, at least on the pages I found.

Currently I have no /dev/md* devices.
I have access to the old mdadm.conf file - have tried assembling with
it, with the default mdadm.conf, and with no mdadm.conf file in /etc
and /etc/mdadm.

Suggestions for how to get the array back would be most appreciated.

Thanks
- Peter

Here is the data suggested from the wiki page:

root@superior:/etc/mdadm# mdadm --assemble --scan --verbose
mdadm: looking for devices for /dev/md/0
mdadm: cannot open device /dev/sr0: No medium found
mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got 00000=
000)
mdadm: no RAID superblock on /dev/sda
mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 00000=
000)
mdadm: no RAID superblock on /dev/sdb
mdadm: No super block found on /dev/sdd (Expected magic a92b4efc, got 00000=
000)
mdadm: no RAID superblock on /dev/sdd
mdadm: No super block found on /dev/sde (Expected magic a92b4efc, got 00000=
000)
mdadm: no RAID superblock on /dev/sde
mdadm: No super block found on /dev/sdf (Expected magic a92b4efc, got 00000=
000)
mdadm: no RAID superblock on /dev/sdf
mdadm: No super block found on /dev/sdc (Expected magic a92b4efc, got 00000=
000)
mdadm: no RAID superblock on /dev/sdc
mdadm: No super block found on /dev/nvme0n1p9 (Expected magic
a92b4efc, got 00000000)
mdadm: no RAID superblock on /dev/nvme0n1p9
mdadm: No super block found on /dev/nvme0n1p8 (Expected magic
a92b4efc, got 0000040c)
mdadm: no RAID superblock on /dev/nvme0n1p8
mdadm: No super block found on /dev/nvme0n1p7 (Expected magic
a92b4efc, got 00002004)
mdadm: no RAID superblock on /dev/nvme0n1p7
mdadm: No super block found on /dev/nvme0n1p6 (Expected magic
a92b4efc, got 0000040d)
mdadm: no RAID superblock on /dev/nvme0n1p6
mdadm: No super block found on /dev/nvme0n1p5 (Expected magic
a92b4efc, got 00000409)
mdadm: no RAID superblock on /dev/nvme0n1p5
mdadm: /dev/nvme0n1p2 is too small for md: size is 2 sectors.
mdadm: no RAID superblock on /dev/nvme0n1p2
mdadm: No super block found on /dev/nvme0n1p1 (Expected magic
a92b4efc, got 00040001)
mdadm: no RAID superblock on /dev/nvme0n1p1
mdadm: No super block found on /dev/nvme0n1 (Expected magic a92b4efc,
got 7a78e8ed)
mdadm: no RAID superblock on /dev/nvme0n1
root@superior:/etc/mdadm#


uname -a
Linux superior 5.10.0-17-amd64 #1 SMP Debian 5.10.136-1 (2022-08-13)
x86_64 GNU/Linux

mdadm --version
mdadm - v4.1 - 2018-10-01

smartctl devices ------------
smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-17-amd64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Toshiba P300
Device Model:     TOSHIBA HDWD130
Serial Number:    477ALBNAS
LU WWN Device Id: 5 000039 fe6d2e832
Firmware Version: MX6OACF0
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Thu Aug 25 21:19:49 2022 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Disabled
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80)    Offline data collection activity
                    was never started.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (21791) seconds.
Offline data collection
capabilities:              (0x5b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    No Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   1) minutes.
Extended self-test routine
recommended polling time:      ( 364) minutes.
SCT capabilities:            (0x003d)    SCT Status supported.
                    SCT Error Recovery Control supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
  2 Throughput_Performance  P-S---   141   141   054    -    66
  3 Spin_Up_Time            POS---   160   160   024    -    361 (Average 3=
57)
  4 Start_Stop_Count        -O--C-   100   100   000    -    204
  5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
  7 Seek_Error_Rate         PO-R--   100   100   067    -    0
  8 Seek_Time_Performance   P-S---   124   124   020    -    33
  9 Power_On_Hours          -O--C-   095   095   000    -    41740
 10 Spin_Retry_Count        PO--C-   100   100   060    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    204
192 Power-Off_Retract_Count -O--CK   100   100   000    -    759
193 Load_Cycle_Count        -O--C-   100   100   000    -    759
194 Temperature_Celsius     -O----   181   181   000    -    33 (Min/Max 20=
/50)
196 Reallocated_Event_Count -O--CK   100   100   000    -    0
197 Current_Pending_Sector  -O---K   100   100   000    -    0
198 Offline_Uncorrectable   ---R--   100   100   000    -    0
199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    0
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
0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
0x04       GPL     R/O      7  Device Statistics log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x08       GPL     R/O      2  Power Conditions log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x20       GPL     R/O      1  Streaming performance log [OBS-8]
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
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
SCT Version (vendor specific):       256 (0x0100)
Device State:                        Active (0)
Current Temperature:                    33 Celsius
Power Cycle Min/Max Temperature:     29/33 Celsius
Lifetime    Min/Max Temperature:     20/50 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -40/70 Celsius
Temperature History Size (Index):    128 (51)

Index    Estimated Time   Temperature Celsius
  52    2022-08-25 19:12    33  **************
 ...    ..( 76 skipped).    ..  **************
   1    2022-08-25 20:29    33  **************
   2    2022-08-25 20:30     ?  -
   3    2022-08-25 20:31    33  **************
   4    2022-08-25 20:32    34  ***************
   5    2022-08-25 20:33    33  **************
   6    2022-08-25 20:34    34  ***************
 ...    ..(  2 skipped).    ..  ***************
   9    2022-08-25 20:37    34  ***************
  10    2022-08-25 20:38     ?  -
  11    2022-08-25 20:39    29  **********
  12    2022-08-25 20:40    30  ***********
 ...    ..(  2 skipped).    ..  ***********
  15    2022-08-25 20:43    30  ***********
  16    2022-08-25 20:44    31  ************
 ...    ..(  3 skipped).    ..  ************
  20    2022-08-25 20:48    31  ************
  21    2022-08-25 20:49    32  *************
 ...    ..(  9 skipped).    ..  *************
  31    2022-08-25 20:59    32  *************
  32    2022-08-25 21:00    33  **************
 ...    ..( 18 skipped).    ..  **************
  51    2022-08-25 21:19    33  **************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

Device Statistics (GP Log 0x04)
Page  Offset Size        Value Flags Description
0x01  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D General Sta=
tistics (rev 1) =3D=3D
0x01  0x008  4             204  ---  Lifetime Power-On Resets
0x01  0x010  4           41740  ---  Power-on Hours
0x01  0x018  6     20304278904  ---  Logical Sectors Written
0x01  0x020  6        64656942  ---  Number of Write Commands
0x01  0x028  6    350269182084  ---  Logical Sectors Read
0x01  0x030  6       481405773  ---  Number of Read Commands
0x03  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D Rotating Me=
dia Statistics (rev 1) =3D=3D
0x03  0x008  4           41734  ---  Spindle Motor Power-on Hours
0x03  0x010  4           41734  ---  Head Flying Hours
0x03  0x018  4             759  ---  Head Load Events
0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
0x03  0x028  4              22  ---  Read Recovery Attempts
0x03  0x030  4               6  ---  Number of Mechanical Start Failures
0x04  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D General Err=
ors Statistics (rev 1) =3D=3D
0x04  0x008  4               0  ---  Number of Reported Uncorrectable Error=
s
0x04  0x010  4               1  ---  Resets Between Cmd Acceptance and
Completion
0x05  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D Temperature=
 Statistics (rev 1) =3D=3D
0x05  0x008  1              33  ---  Current Temperature
0x05  0x010  1              33  N--  Average Short Term Temperature
0x05  0x018  1              37  N--  Average Long Term Temperature
0x05  0x020  1              50  ---  Highest Temperature
0x05  0x028  1              20  ---  Lowest Temperature
0x05  0x030  1              46  N--  Highest Average Short Term Temperature
0x05  0x038  1              25  N--  Lowest Average Short Term Temperature
0x05  0x040  1              43  N--  Highest Average Long Term Temperature
0x05  0x048  1              25  N--  Lowest Average Long Term Temperature
0x05  0x050  4               0  ---  Time in Over-Temperature
0x05  0x058  1              60  ---  Specified Maximum Operating Temperatur=
e
0x05  0x060  4               0  ---  Time in Under-Temperature
0x05  0x068  1               0  ---  Specified Minimum Operating Temperatur=
e
0x06  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D Transport S=
tatistics (rev 1) =3D=3D
0x06  0x008  4            1006  ---  Number of Hardware Resets
0x06  0x010  4             494  ---  Number of ASR Events
0x06  0x018  4               0  ---  Number of Interface CRC Errors
                                |||_ C monitored condition met
                                ||__ D supports DSN
                                |___ N normalized value

Pending Defects log (GP Log 0x0c) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0009  2           35  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            5  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS

smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-17-amd64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Green
Device Model:     WDC WD30EZRX-00DC0B0
Serial Number:    WD-WCC1T0668790
LU WWN Device Id: 5 0014ee 2084d406a
Firmware Version: 80.00A80
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Thu Aug 25 21:19:51 2022 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
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
data collection:         (40560) seconds.
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
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 407) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x70b5)    SCT Status supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   181   178   021    -    5916
  4 Start_Stop_Count        -O--CK   100   100   000    -    377
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   007   007   000    -    68295
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    296
192 Power-Off_Retract_Count -O--CK   200   200   000    -    242
193 Load_Cycle_Count        -O--CK   052   052   000    -    445057
194 Temperature_Celsius     -O---K   121   102   000    -    29
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
0x10       GPL     R/O      1  NCQ Command Error log
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
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%         7       =
  -
# 2  Short offline       Completed without error       00%         0       =
  -

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
Device State:                        Active (0)
Current Temperature:                    29 Celsius
Power Cycle Min/Max Temperature:     28/29 Celsius
Lifetime    Min/Max Temperature:      2/48 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (138)

Index    Estimated Time   Temperature Celsius
 139    2022-08-25 13:22    30  ***********
 140    2022-08-25 13:23    29  **********
 ...    ..(  5 skipped).    ..  **********
 146    2022-08-25 13:29    29  **********
 147    2022-08-25 13:30     ?  -
 148    2022-08-25 13:31    26  *******
 149    2022-08-25 13:32     ?  -
 150    2022-08-25 13:33    28  *********
 151    2022-08-25 13:34     ?  -
 152    2022-08-25 13:35    28  *********
 153    2022-08-25 13:36    28  *********
 154    2022-08-25 13:37    29  **********
 ...    ..( 55 skipped).    ..  **********
 210    2022-08-25 14:33    29  **********
 211    2022-08-25 14:34    30  ***********
 ...    ..( 11 skipped).    ..  ***********
 223    2022-08-25 14:46    30  ***********
 224    2022-08-25 14:47    29  **********
 ...    ..(103 skipped).    ..  **********
 328    2022-08-25 16:31    29  **********
 329    2022-08-25 16:32    30  ***********
 ...    ..( 18 skipped).    ..  ***********
 348    2022-08-25 16:51    30  ***********
 349    2022-08-25 16:52    29  **********
 ...    ..( 33 skipped).    ..  **********
 383    2022-08-25 17:26    29  **********
 384    2022-08-25 17:27    30  ***********
 ...    ..( 10 skipped).    ..  ***********
 395    2022-08-25 17:38    30  ***********
 396    2022-08-25 17:39    29  **********
 ...    ..(218 skipped).    ..  **********
 137    2022-08-25 21:18    29  **********
 138    2022-08-25 21:19     ?  -

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

Pending Defects log (GP Log 0x0c) not supported

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
0x0009  2          305  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            5  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4         2491  Vendor specific

smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-17-amd64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Toshiba P300
Device Model:     TOSHIBA HDWD130
Serial Number:    Y7211KPAS
LU WWN Device Id: 5 000039 fe6dca946
Firmware Version: MX6OACF0
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Thu Aug 25 21:19:51 2022 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Disabled
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80)    Offline data collection activity
                    was never started.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (21791) seconds.
Offline data collection
capabilities:              (0x5b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    No Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   1) minutes.
Extended self-test routine
recommended polling time:      ( 364) minutes.
SCT capabilities:            (0x003d)    SCT Status supported.
                    SCT Error Recovery Control supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
  2 Throughput_Performance  P-S---   139   139   054    -    71
  3 Spin_Up_Time            POS---   160   160   024    -    361 (Average 3=
55)
  4 Start_Stop_Count        -O--C-   100   100   000    -    189
  5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
  7 Seek_Error_Rate         PO-R--   100   100   067    -    0
  8 Seek_Time_Performance   P-S---   128   128   020    -    31
  9 Power_On_Hours          -O--C-   095   095   000    -    35428
 10 Spin_Retry_Count        PO--C-   100   100   060    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    189
192 Power-Off_Retract_Count -O--CK   100   100   000    -    599
193 Load_Cycle_Count        -O--C-   100   100   000    -    599
194 Temperature_Celsius     -O----   176   176   000    -    34 (Min/Max 19=
/50)
196 Reallocated_Event_Count -O--CK   100   100   000    -    0
197 Current_Pending_Sector  -O---K   100   100   000    -    0
198 Offline_Uncorrectable   ---R--   100   100   000    -    0
199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    0
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
0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
0x04       GPL     R/O      7  Device Statistics log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x08       GPL     R/O      2  Power Conditions log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x20       GPL     R/O      1  Streaming performance log [OBS-8]
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
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
SCT Version (vendor specific):       256 (0x0100)
Device State:                        Active (0)
Current Temperature:                    34 Celsius
Power Cycle Min/Max Temperature:     28/34 Celsius
Lifetime    Min/Max Temperature:     19/50 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -40/70 Celsius
Temperature History Size (Index):    128 (15)

Index    Estimated Time   Temperature Celsius
  16    2022-08-25 19:12    33  **************
 ...    ..( 66 skipped).    ..  **************
  83    2022-08-25 20:19    33  **************
  84    2022-08-25 20:20    34  ***************
 ...    ..(  8 skipped).    ..  ***************
  93    2022-08-25 20:29    34  ***************
  94    2022-08-25 20:30     ?  -
  95    2022-08-25 20:31    34  ***************
 ...    ..(  5 skipped).    ..  ***************
 101    2022-08-25 20:37    34  ***************
 102    2022-08-25 20:38     ?  -
 103    2022-08-25 20:39    29  **********
 104    2022-08-25 20:40    29  **********
 105    2022-08-25 20:41    30  ***********
 106    2022-08-25 20:42    30  ***********
 107    2022-08-25 20:43    31  ************
 ...    ..(  3 skipped).    ..  ************
 111    2022-08-25 20:47    31  ************
 112    2022-08-25 20:48    32  *************
 ...    ..(  4 skipped).    ..  *************
 117    2022-08-25 20:53    32  *************
 118    2022-08-25 20:54    33  **************
 ...    ..( 15 skipped).    ..  **************
   6    2022-08-25 21:10    33  **************
   7    2022-08-25 21:11    34  ***************
   8    2022-08-25 21:12    33  **************
   9    2022-08-25 21:13    34  ***************
 ...    ..(  5 skipped).    ..  ***************
  15    2022-08-25 21:19    34  ***************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

Device Statistics (GP Log 0x04)
Page  Offset Size        Value Flags Description
0x01  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D General Sta=
tistics (rev 1) =3D=3D
0x01  0x008  4             189  ---  Lifetime Power-On Resets
0x01  0x010  4           35428  ---  Power-on Hours
0x01  0x018  6     12728825059  ---  Logical Sectors Written
0x01  0x020  6        36220308  ---  Number of Write Commands
0x01  0x028  6    289884223915  ---  Logical Sectors Read
0x01  0x030  6       321688917  ---  Number of Read Commands
0x03  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D Rotating Me=
dia Statistics (rev 1) =3D=3D
0x03  0x008  4           35423  ---  Spindle Motor Power-on Hours
0x03  0x010  4           35423  ---  Head Flying Hours
0x03  0x018  4             599  ---  Head Load Events
0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
0x03  0x028  4               7  ---  Read Recovery Attempts
0x03  0x030  4               6  ---  Number of Mechanical Start Failures
0x04  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D General Err=
ors Statistics (rev 1) =3D=3D
0x04  0x008  4               0  ---  Number of Reported Uncorrectable Error=
s
0x04  0x010  4               1  ---  Resets Between Cmd Acceptance and
Completion
0x05  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D Temperature=
 Statistics (rev 1) =3D=3D
0x05  0x008  1              34  ---  Current Temperature
0x05  0x010  1              34  N--  Average Short Term Temperature
0x05  0x018  1              37  N--  Average Long Term Temperature
0x05  0x020  1              50  ---  Highest Temperature
0x05  0x028  1              19  ---  Lowest Temperature
0x05  0x030  1              46  N--  Highest Average Short Term Temperature
0x05  0x038  1              25  N--  Lowest Average Short Term Temperature
0x05  0x040  1              43  N--  Highest Average Long Term Temperature
0x05  0x048  1              25  N--  Lowest Average Long Term Temperature
0x05  0x050  4               0  ---  Time in Over-Temperature
0x05  0x058  1              60  ---  Specified Maximum Operating Temperatur=
e
0x05  0x060  4               0  ---  Time in Under-Temperature
0x05  0x068  1               0  ---  Specified Minimum Operating Temperatur=
e
0x06  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D Transport S=
tatistics (rev 1) =3D=3D
0x06  0x008  4          147297  ---  Number of Hardware Resets
0x06  0x010  4            8793  ---  Number of ASR Events
0x06  0x018  4               0  ---  Number of Interface CRC Errors
                                |||_ C monitored condition met
                                ||__ D supports DSN
                                |___ N normalized value

Pending Defects log (GP Log 0x0c) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0009  2           29  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            5  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS

smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-17-amd64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Green
Device Model:     WDC WD30EZRX-00D8PB0
Serial Number:    WD-WCC4N0091255
LU WWN Device Id: 5 0014ee 2b3d4ffa1
Firmware Version: 80.00A80
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    5400 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ACS-2 (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Thu Aug 25 21:19:53 2022 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
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
data collection:         (42480) seconds.
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
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 426) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x7035)    SCT Status supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    2
  3 Spin_Up_Time            POS--K   184   181   021    -    5783
  4 Start_Stop_Count        -O--CK   100   100   000    -    275
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   039   039   000    -    44593
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    273
192 Power-Off_Retract_Count -O--CK   200   200   000    -    225
193 Load_Cycle_Count        -O--CK   047   047   000    -    461100
194 Temperature_Celsius     -O---K   122   105   000    -    28
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
0x10       GPL     R/O      1  NCQ Command Error log
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
Device State:                        Active (0)
Current Temperature:                    28 Celsius
Power Cycle Min/Max Temperature:     27/28 Celsius
Lifetime    Min/Max Temperature:      2/44 Celsius
Under/Over Temperature Limit Count:   0/0
Vendor specific:
01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (444)

Index    Estimated Time   Temperature Celsius
 445    2022-08-25 13:22    29  **********
 ...    ..( 33 skipped).    ..  **********
   1    2022-08-25 13:56    29  **********
   2    2022-08-25 13:57     ?  -
   3    2022-08-25 13:58    29  **********
 ...    ..(  6 skipped).    ..  **********
  10    2022-08-25 14:05    29  **********
  11    2022-08-25 14:06     ?  -
  12    2022-08-25 14:07    26  *******
  13    2022-08-25 14:08     ?  -
  14    2022-08-25 14:09    27  ********
  15    2022-08-25 14:10    27  ********
  16    2022-08-25 14:11    28  *********
 ...    ..( 37 skipped).    ..  *********
  54    2022-08-25 14:49    28  *********
  55    2022-08-25 14:50    29  **********
 ...    ..(388 skipped).    ..  **********
 444    2022-08-25 21:19    29  **********

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

Pending Defects log (GP Log 0x0c) not supported

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
0x0009  2          286  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            5  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
0x8000  4         2493  Vendor specific

smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-17-amd64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Green
Device Model:     WDC WD30EZRX-00MMMB0
Serial Number:    WD-WCAWZ2669166
LU WWN Device Id: 5 0014ee 15a13d994
Firmware Version: 80.00A80
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Thu Aug 25 21:19:53 2022 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
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
data collection:         (50160) seconds.
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
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 482) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x3035)    SCT Status supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
  3 Spin_Up_Time            POS--K   153   138   021    -    9350
  4 Start_Stop_Count        -O--CK   100   100   000    -    297
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   040   040   000    -    44409
 10 Spin_Retry_Count        -O--CK   100   100   000    -    0
 11 Calibration_Retry_Count -O--CK   100   100   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    268
192 Power-Off_Retract_Count -O--CK   200   200   000    -    218
193 Load_Cycle_Count        -O--CK   001   001   000    -    1082082
194 Temperature_Celsius     -O---K   122   105   000    -    30
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    1
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
0x10       GPL     R/O      1  NCQ Command Error log
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
Device State:                        Active (0)
Current Temperature:                    30 Celsius
Power Cycle Min/Max Temperature:     27/30 Celsius
Lifetime    Min/Max Temperature:      0/47 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (88)

Index    Estimated Time   Temperature Celsius
  89    2022-08-25 13:22    30  ***********
 ...    ..( 33 skipped).    ..  ***********
 123    2022-08-25 13:56    30  ***********
 124    2022-08-25 13:57     ?  -
 125    2022-08-25 13:58    31  ************
 126    2022-08-25 13:59    30  ***********
 ...    ..(  5 skipped).    ..  ***********
 132    2022-08-25 14:05    30  ***********
 133    2022-08-25 14:06     ?  -
 134    2022-08-25 14:07    26  *******
 135    2022-08-25 14:08     ?  -
 136    2022-08-25 14:09    27  ********
 ...    ..(  3 skipped).    ..  ********
 140    2022-08-25 14:13    27  ********
 141    2022-08-25 14:14    28  *********
 ...    ..(  3 skipped).    ..  *********
 145    2022-08-25 14:18    28  *********
 146    2022-08-25 14:19    29  **********
 ...    ..( 13 skipped).    ..  **********
 160    2022-08-25 14:33    29  **********
 161    2022-08-25 14:34    30  ***********
 ...    ..( 43 skipped).    ..  ***********
 205    2022-08-25 15:18    30  ***********
 206    2022-08-25 15:19    31  ************
 207    2022-08-25 15:20    30  ***********
 ...    ..(168 skipped).    ..  ***********
 376    2022-08-25 18:09    30  ***********
 377    2022-08-25 18:10    31  ************
 378    2022-08-25 18:11    30  ***********
 ...    ..( 34 skipped).    ..  ***********
 413    2022-08-25 18:46    30  ***********
 414    2022-08-25 18:47    31  ************
 415    2022-08-25 18:48    30  ***********
 ...    ..(  7 skipped).    ..  ***********
 423    2022-08-25 18:56    30  ***********
 424    2022-08-25 18:57    31  ************
 425    2022-08-25 18:58    30  ***********
 ...    ..(  7 skipped).    ..  ***********
 433    2022-08-25 19:06    30  ***********
 434    2022-08-25 19:07    31  ************
 435    2022-08-25 19:08    30  ***********
 ...    ..( 47 skipped).    ..  ***********
   5    2022-08-25 19:56    30  ***********
   6    2022-08-25 19:57    31  ************
   7    2022-08-25 19:58    30  ***********
 ...    ..( 80 skipped).    ..  ***********
  88    2022-08-25 21:19    30  ***********

SCT Error Recovery Control command not supported

Device Statistics (GP/SMART Log 0x04) not supported

Pending Defects log (GP Log 0x0c) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x000a  2            3  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x8000  4         2492  Vendor specific

smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-17-amd64] (local build)
Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Toshiba P300
Device Model:     TOSHIBA HDWD130
Serial Number:    477ABEJAS
LU WWN Device Id: 5 000039 fe6d2ce25
Firmware Version: MX6OACF0
User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Sector Sizes:     512 bytes logical, 4096 bytes physical
Rotation Rate:    7200 rpm
Form Factor:      3.5 inches
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Thu Aug 25 21:19:53 2022 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Disabled
Rd look-ahead is: Enabled
Write cache is:   Enabled
DSN feature is:   Unavailable
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x80)    Offline data collection activity
                    was never started.
                    Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test
routine completed
                    without error or no self-test has ever
                    been run.
Total time to complete Offline
data collection:         (23082) seconds.
Offline data collection
capabilities:              (0x5b) SMART execute Offline immediate.
                    Auto Offline data collection on/off support.
                    Suspend Offline collection upon new
                    command.
                    Offline surface scan supported.
                    Self-test supported.
                    No Conveyance Self-test supported.
                    Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before entering
                    power-saving mode.
                    Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                    General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   1) minutes.
Extended self-test routine
recommended polling time:      ( 385) minutes.
SCT capabilities:            (0x003d)    SCT Status supported.
                    SCT Error Recovery Control supported.
                    SCT Feature Control supported.
                    SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
  2 Throughput_Performance  P-S---   140   140   054    -    68
  3 Spin_Up_Time            POS---   161   161   024    -    358 (Average 3=
54)
  4 Start_Stop_Count        -O--C-   100   100   000    -    243
  5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
  7 Seek_Error_Rate         PO-R--   100   100   067    -    0
  8 Seek_Time_Performance   P-S---   126   126   020    -    32
  9 Power_On_Hours          -O--C-   094   094   000    -    44046
 10 Spin_Retry_Count        PO--C-   100   100   060    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    243
192 Power-Off_Retract_Count -O--CK   100   100   000    -    912
193 Load_Cycle_Count        -O--C-   100   100   000    -    912
194 Temperature_Celsius     -O----   193   193   000    -    31 (Min/Max 19=
/46)
196 Reallocated_Event_Count -O--CK   100   100   000    -    0
197 Current_Pending_Sector  -O---K   100   100   000    -    0
198 Offline_Uncorrectable   ---R--   100   100   000    -    0
199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    0
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
0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
0x04       GPL     R/O      7  Device Statistics log
0x06           SL  R/O      1  SMART self-test log
0x07       GPL     R/O      1  Extended self-test log
0x08       GPL     R/O      2  Power Conditions log
0x09           SL  R/W      1  Selective self-test log
0x10       GPL     R/O      1  NCQ Command Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x20       GPL     R/O      1  Streaming performance log [OBS-8]
0x21       GPL     R/O      1  Write stream error log
0x22       GPL     R/O      1  Read stream error log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
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
SCT Version (vendor specific):       256 (0x0100)
Device State:                        Active (0)
Current Temperature:                    31 Celsius
Power Cycle Min/Max Temperature:     28/32 Celsius
Lifetime    Min/Max Temperature:     19/46 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -40/70 Celsius
Temperature History Size (Index):    128 (117)

Index    Estimated Time   Temperature Celsius
 118    2022-08-25 19:12    31  ************
 ...    ..( 76 skipped).    ..  ************
  67    2022-08-25 20:29    31  ************
  68    2022-08-25 20:30     ?  -
  69    2022-08-25 20:31    31  ************
  70    2022-08-25 20:32    32  *************
  71    2022-08-25 20:33    31  ************
  72    2022-08-25 20:34    31  ************
  73    2022-08-25 20:35    32  *************
  74    2022-08-25 20:36    32  *************
  75    2022-08-25 20:37    32  *************
  76    2022-08-25 20:38     ?  -
  77    2022-08-25 20:39    28  *********
  78    2022-08-25 20:40    29  **********
 ...    ..(  2 skipped).    ..  **********
  81    2022-08-25 20:43    29  **********
  82    2022-08-25 20:44    30  ***********
 ...    ..(  5 skipped).    ..  ***********
  88    2022-08-25 20:50    30  ***********
  89    2022-08-25 20:51    31  ************
 ...    ..( 27 skipped).    ..  ************
 117    2022-08-25 21:19    31  ************

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

Device Statistics (GP Log 0x04)
Page  Offset Size        Value Flags Description
0x01  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D General Sta=
tistics (rev 1) =3D=3D
0x01  0x008  4             243  ---  Lifetime Power-On Resets
0x01  0x010  4           44046  ---  Power-on Hours
0x01  0x018  6     27756962802  ---  Logical Sectors Written
0x01  0x020  6        86355955  ---  Number of Write Commands
0x01  0x028  6    381193626849  ---  Logical Sectors Read
0x01  0x030  6       791200694  ---  Number of Read Commands
0x03  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D Rotating Me=
dia Statistics (rev 1) =3D=3D
0x03  0x008  4           44040  ---  Spindle Motor Power-on Hours
0x03  0x010  4           44040  ---  Head Flying Hours
0x03  0x018  4             912  ---  Head Load Events
0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
0x03  0x028  4               0  ---  Read Recovery Attempts
0x03  0x030  4               6  ---  Number of Mechanical Start Failures
0x04  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D General Err=
ors Statistics (rev 1) =3D=3D
0x04  0x008  4               0  ---  Number of Reported Uncorrectable Error=
s
0x04  0x010  4               0  ---  Resets Between Cmd Acceptance and
Completion
0x05  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D Temperature=
 Statistics (rev 1) =3D=3D
0x05  0x008  1              32  ---  Current Temperature
0x05  0x010  1              31  N--  Average Short Term Temperature
0x05  0x018  1              35  N--  Average Long Term Temperature
0x05  0x020  1              46  ---  Highest Temperature
0x05  0x028  1              19  ---  Lowest Temperature
0x05  0x030  1              43  N--  Highest Average Short Term Temperature
0x05  0x038  1              25  N--  Lowest Average Short Term Temperature
0x05  0x040  1              41  N--  Highest Average Long Term Temperature
0x05  0x048  1              25  N--  Lowest Average Long Term Temperature
0x05  0x050  4               0  ---  Time in Over-Temperature
0x05  0x058  1              60  ---  Specified Maximum Operating Temperatur=
e
0x05  0x060  4               0  ---  Time in Under-Temperature
0x05  0x068  1               0  ---  Specified Minimum Operating Temperatur=
e
0x06  =3D=3D=3D=3D=3D  =3D               =3D  =3D=3D=3D  =3D=3D Transport S=
tatistics (rev 1) =3D=3D
0x06  0x008  4            4706  ---  Number of Hardware Resets
0x06  0x010  4            3910  ---  Number of ASR Events
0x06  0x018  4               0  ---  Number of Interface CRC Errors
                                |||_ C monitored condition met
                                ||__ D supports DSN
                                |___ N normalized value

Pending Defects log (GP Log 0x0c) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x0009  2           29  Transition from drive PhyRdy to drive PhyNRdy
0x000a  2            5  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x000d  2            0  Non-CRC errors within host-to-device FIS


mdadm --examine devices -----
/dev/sda:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdb:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdc:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdd:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sde:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)
/dev/sdf:
   MBR Magic : aa55
Partition[0] :   4294967295 sectors at            1 (type ee)

mdadm --detail /dev/md0 ------

lsdrv ------------------------
PCI [nvme] 01:00.0 Non-Volatile memory controller: Phison Electronics
Corporation E12 NVMe Controller (rev 01)
=E2=94=94nvme nvme0 PCIe SSD                                 {2111292560604=
7}
 =E2=94=94nvme0n1 238.47g [259:0] Partitioned (dos)
  =E2=94=9Cnvme0n1p1 485.00m [259:1] ext4 {f38776ac-1ce9-4fc8-ba50-94844b9f=
504e}
  =E2=94=82=E2=94=94Mounted as /dev/nvme0n1p1 @ /boot
  =E2=94=9Cnvme0n1p2 1.00k [259:2] Partitioned (dos)
  =E2=94=9Cnvme0n1p5 60.54g [259:3] ext4 {5ee1c3c0-3a05-466c-9f98-f5807c8d8=
13b}
  =E2=94=82=E2=94=94Mounted as /dev/nvme0n1p5 @ /
  =E2=94=9Cnvme0n1p6 93.13g [259:4] ext4 {9064169f-4fe3-4836-a906-28c1b445c=
dff}
  =E2=94=82=E2=94=94Mounted as /dev/nvme0n1p6 @ /var
  =E2=94=9Cnvme0n1p7 37.00m [259:5] ext4 {25e161ad-94a0-4298-afaf-18e243376=
6ee}
  =E2=94=9Cnvme0n1p8 82.89g [259:6] ext4 {ac874071-d759-4d33-b32f-83272f3ea=
cd9}
  =E2=94=82=E2=94=94Mounted as /dev/nvme0n1p8 @ /home
  =E2=94=94nvme0n1p9 1.41g [259:7] swap {02cef84b-9a9d-4a0a-973c-fda1a78c53=
3c}
PCI [pata_jmicron] 26:00.1 IDE interface: JMicron Technology Corp.
JMB368 IDE controller (rev 10)
=E2=94=94scsi 0:0:0:0 MAD DOG  LS-DVDRW TSH652M {MAD_DOG_LS-DVDRW_TSH652M}
 =E2=94=94sr0 1.00g [11:0] Empty/Unknown
PCI [ahci] 26:00.0 SATA controller: JMicron Technology Corp. JMB363
SATA/IDE Controller (rev 10)
=E2=94=94scsi 2:x:x:x [Empty]
PCI [ahci] 2b:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
FCH SATA Controller [AHCI mode] (rev 51)
=E2=94=9Cscsi 6:0:0:0 ATA      TOSHIBA HDWD130  {477ALBNAS}
=E2=94=82=E2=94=94sda 2.73t [8:0] Partitioned (PMBR)
=E2=94=94scsi 7:0:0:0 ATA      TOSHIBA HDWD130  {Y7211KPAS}
 =E2=94=94sdc 2.73t [8:32] Partitioned (gpt)
PCI [ahci] 2c:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
FCH SATA Controller [AHCI mode] (rev 51)
=E2=94=9Cscsi 8:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC1T0668790}
=E2=94=82=E2=94=94sdb 2.73t [8:16] Partitioned (gpt)
=E2=94=9Cscsi 9:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC4N0091255}
=E2=94=82=E2=94=94sdd 2.73t [8:48] Partitioned (gpt)
=E2=94=9Cscsi 12:0:0:0 ATA      WDC WD30EZRX-00M {WD-WCAWZ2669166}
=E2=94=82=E2=94=94sde 2.73t [8:64] Partitioned (gpt)
=E2=94=94scsi 13:0:0:0 ATA      TOSHIBA HDWD130  {477ABEJAS}
 =E2=94=94sdf 2.73t [8:80] Partitioned (gpt)

cat /proc/mdstat -------------
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
[raid4] [raid10]
unused devices: <none>

cat /etc/mdadm/mdadm.conf ----
# mdadm.conf
#
# !NB! Run update-initramfs -u after updating this file.
# !NB! This will ensure that initramfs has an uptodate copy.
#
# Please refer to mdadm.conf(5) for information about this file.
#

# by default (built-in), scan all partitions (/proc/partitions) and all
# containers for MD superblocks. alternatively, specify devices to scan, us=
ing
# wildcards if desired.
#DEVICE partitions containers

# automatically tag new arrays as belonging to the local system
HOMEHOST <system>

# instruct the monitoring daemon where to send mail alerts
MAILADDR root

# definitions of existing MD arrays
ARRAY /dev/md/0  metadata=3D1.2 UUID=3D109fa7b0:cf08fdba:e36284a9:5786ffff
name=3Dsuperior:0

# This configuration was auto-generated on Sun, 26 Dec 2021 13:31:14
-0500 by mkconf

cat /proc/partitions ---------
major minor  #blocks  name

 259        0  250059096 nvme0n1
 259        1     496640 nvme0n1p1
 259        2          1 nvme0n1p2
 259        3   63475712 nvme0n1p5
 259        4   97654784 nvme0n1p6
 259        5      37888 nvme0n1p7
 259        6   86913024 nvme0n1p8
 259        7    1474560 nvme0n1p9
   8       32 2930266584 sdc
   8       80 2930266584 sdf
   8       64 2930266584 sde
   8       48 2930266584 sdd
   8       16 2930266584 sdb
   8        0 2930266584 sda
  11        0    1048575 sr0

Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82015ECAAD5
	for <linux-raid@archiver.kernel.org>; Sun, 28 Aug 2022 15:19:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiH1PTT convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 28 Aug 2022 11:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229517AbiH1PTS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 28 Aug 2022 11:19:18 -0400
X-Greylist: delayed 539 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 28 Aug 2022 08:19:14 PDT
Received: from mail.stoffel.org (li1843-175.members.linode.com [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 067D832BBD
        for <linux-raid@vger.kernel.org>; Sun, 28 Aug 2022 08:19:14 -0700 (PDT)
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 027571E853;
        Sun, 28 Aug 2022 11:10:15 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 33707A7E23; Sun, 28 Aug 2022 11:10:14 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <25355.34134.74972.828202@quad.stoffel.home>
Date:   Sun, 28 Aug 2022 11:10:14 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Peter Sanders <plsander@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: RAID 6, 6 device array - all devices lost superblock
In-Reply-To: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:

Peter> have a RAID 6 array, 6 devices.  Been running it for years without much issue.
Peter> Had hardware issues with my system - ended up replacing the
Peter> motherboard, video card, and power supply and re-installing the OS
Peter> (Debian 11).

Can you give us details on the old vs new motherboard/cpu?  It might
be that you need to tweak the BIOS of the motherboard to expose the
old SATA formats as well.  

Did you install debian onto a fresh boot disk?  Is your BIOS setup to
only do the new form of booting from UEFI devices, so maybe check your
BIOS settings that the data drives are all in AHCI mode, or possibly
even in IDE mode.  It all depends on how old the original hardware
was.  

I just recenly upgraded from a 2010 MB/CPU combo and I had to tweak
the BIOS defaults to see my disks.  I guess I should do a clean
install from a blank disk, but I wanted to minimize downtime.  

Wols has some great advice here, and I heartily recommend that you use
overlayfs when doing your testing.  Check the RAID WIKI for
suggestions.

And don't panic!  Your data is probably there, but just missing the
super blocks or partition tables. 

John


Peter> As the hardware issues evolved, I'd crash, reboot, un-mount the array,
Peter> run fsck, mount and continue on my way - no problems.

Peter> After the hardware was replaced, my array will not assemble - mdadm
Peter> assemble reports no RAID superblock on the devices.
Peter> root@superior:/etc/mdadm# mdadm --assemble --scan --verbose
Peter> mdadm: looking for devices for /dev/md/0
Peter> mdadm: cannot open device /dev/sr0: No medium found
Peter> mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got 00000000)
Peter> mdadm: no RAID superblock on /dev/sda
Peter> mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 00000000)
Peter> mdadm: no RAID superblock on /dev/sdb

Peter> Examine reports
Peter> /dev/sda:
Peter>    MBR Magic : aa55
Peter> Partition[0] :   4294967295 sectors at            1 (type ee)

Peter> Searching for these results indicate I can rebuild the superblock, but
Peter> details on how to do that are lacking, at least on the pages I found.

Peter> Currently I have no /dev/md* devices.
Peter> I have access to the old mdadm.conf file - have tried assembling with
Peter> it, with the default mdadm.conf, and with no mdadm.conf file in /etc
Peter> and /etc/mdadm.

Peter> Suggestions for how to get the array back would be most appreciated.

Peter> Thanks
Peter> - Peter

Peter> Here is the data suggested from the wiki page:

Peter> root@superior:/etc/mdadm# mdadm --assemble --scan --verbose
Peter> mdadm: looking for devices for /dev/md/0
Peter> mdadm: cannot open device /dev/sr0: No medium found
Peter> mdadm: No super block found on /dev/sda (Expected magic a92b4efc, got 00000000)
Peter> mdadm: no RAID superblock on /dev/sda
Peter> mdadm: No super block found on /dev/sdb (Expected magic a92b4efc, got 00000000)
Peter> mdadm: no RAID superblock on /dev/sdb
Peter> mdadm: No super block found on /dev/sdd (Expected magic a92b4efc, got 00000000)
Peter> mdadm: no RAID superblock on /dev/sdd
Peter> mdadm: No super block found on /dev/sde (Expected magic a92b4efc, got 00000000)
Peter> mdadm: no RAID superblock on /dev/sde
Peter> mdadm: No super block found on /dev/sdf (Expected magic a92b4efc, got 00000000)
Peter> mdadm: no RAID superblock on /dev/sdf
Peter> mdadm: No super block found on /dev/sdc (Expected magic a92b4efc, got 00000000)
Peter> mdadm: no RAID superblock on /dev/sdc
Peter> mdadm: No super block found on /dev/nvme0n1p9 (Expected magic
Peter> a92b4efc, got 00000000)
Peter> mdadm: no RAID superblock on /dev/nvme0n1p9
Peter> mdadm: No super block found on /dev/nvme0n1p8 (Expected magic
Peter> a92b4efc, got 0000040c)
Peter> mdadm: no RAID superblock on /dev/nvme0n1p8
Peter> mdadm: No super block found on /dev/nvme0n1p7 (Expected magic
Peter> a92b4efc, got 00002004)
Peter> mdadm: no RAID superblock on /dev/nvme0n1p7
Peter> mdadm: No super block found on /dev/nvme0n1p6 (Expected magic
Peter> a92b4efc, got 0000040d)
Peter> mdadm: no RAID superblock on /dev/nvme0n1p6
Peter> mdadm: No super block found on /dev/nvme0n1p5 (Expected magic
Peter> a92b4efc, got 00000409)
Peter> mdadm: no RAID superblock on /dev/nvme0n1p5
Peter> mdadm: /dev/nvme0n1p2 is too small for md: size is 2 sectors.
Peter> mdadm: no RAID superblock on /dev/nvme0n1p2
Peter> mdadm: No super block found on /dev/nvme0n1p1 (Expected magic
Peter> a92b4efc, got 00040001)
Peter> mdadm: no RAID superblock on /dev/nvme0n1p1
Peter> mdadm: No super block found on /dev/nvme0n1 (Expected magic a92b4efc,
Peter> got 7a78e8ed)
Peter> mdadm: no RAID superblock on /dev/nvme0n1
Peter> root@superior:/etc/mdadm#


Peter> uname -a
Peter> Linux superior 5.10.0-17-amd64 #1 SMP Debian 5.10.136-1 (2022-08-13)
Peter> x86_64 GNU/Linux

Peter> mdadm --version
Peter> mdadm - v4.1 - 2018-10-01

Peter> smartctl devices ------------
Peter> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-17-amd64] (local build)
Peter> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

Peter> === START OF INFORMATION SECTION ===
Peter> Model Family:     Toshiba P300
Peter> Device Model:     TOSHIBA HDWD130
Peter> Serial Number:    477ALBNAS
Peter> LU WWN Device Id: 5 000039 fe6d2e832
Peter> Firmware Version: MX6OACF0
Peter> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Peter> Sector Sizes:     512 bytes logical, 4096 bytes physical
Peter> Rotation Rate:    7200 rpm
Peter> Form Factor:      3.5 inches
Peter> Device is:        In smartctl database [for details use: -P show]
Peter> ATA Version is:   ATA8-ACS T13/1699-D revision 4
Peter> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Peter> Local Time is:    Thu Aug 25 21:19:49 2022 EDT
Peter> SMART support is: Available - device has SMART capability.
Peter> SMART support is: Enabled
Peter> AAM feature is:   Unavailable
Peter> APM feature is:   Disabled
Peter> Rd look-ahead is: Enabled
Peter> Write cache is:   Enabled
Peter> DSN feature is:   Unavailable
Peter> ATA Security is:  Disabled, frozen [SEC2]
Peter> Wt Cache Reorder: Enabled

Peter> === START OF READ SMART DATA SECTION ===
Peter> SMART overall-health self-assessment test result: PASSED

Peter> General SMART Values:
Peter> Offline data collection status:  (0x80)    Offline data collection activity
Peter>                     was never started.
Peter>                     Auto Offline Data Collection: Enabled.
Peter> Self-test execution status:      (   0)    The previous self-test
Peter> routine completed
Peter>                     without error or no self-test has ever
Peter>                     been run.
Peter> Total time to complete Offline
Peter> data collection:         (21791) seconds.
Peter> Offline data collection
Peter> capabilities:              (0x5b) SMART execute Offline immediate.
Peter>                     Auto Offline data collection on/off support.
Peter>                     Suspend Offline collection upon new
Peter>                     command.
Peter>                     Offline surface scan supported.
Peter>                     Self-test supported.
Peter>                     No Conveyance Self-test supported.
Peter>                     Selective Self-test supported.
Peter> SMART capabilities:            (0x0003)    Saves SMART data before entering
Peter>                     power-saving mode.
Peter>                     Supports SMART auto save timer.
Peter> Error logging capability:        (0x01)    Error logging supported.
Peter>                     General Purpose Logging supported.
Peter> Short self-test routine
Peter> recommended polling time:      (   1) minutes.
Peter> Extended self-test routine
Peter> recommended polling time:      ( 364) minutes.
Peter> SCT capabilities:            (0x003d)    SCT Status supported.
Peter>                     SCT Error Recovery Control supported.
Peter>                     SCT Feature Control supported.
Peter>                     SCT Data Table supported.

Peter> SMART Attributes Data Structure revision number: 16
Peter> Vendor Specific SMART Attributes with Thresholds:
Peter> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
Peter>   1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
Peter>   2 Throughput_Performance  P-S---   141   141   054    -    66
Peter>   3 Spin_Up_Time            POS---   160   160   024    -    361 (Average 357)
Peter>   4 Start_Stop_Count        -O--C-   100   100   000    -    204
Peter>   5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
Peter>   7 Seek_Error_Rate         PO-R--   100   100   067    -    0
Peter>   8 Seek_Time_Performance   P-S---   124   124   020    -    33
Peter>   9 Power_On_Hours          -O--C-   095   095   000    -    41740
Peter>  10 Spin_Retry_Count        PO--C-   100   100   060    -    0
Peter>  12 Power_Cycle_Count       -O--CK   100   100   000    -    204
Peter> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    759
Peter> 193 Load_Cycle_Count        -O--C-   100   100   000    -    759
Peter> 194 Temperature_Celsius     -O----   181   181   000    -    33 (Min/Max 20/50)
Peter> 196 Reallocated_Event_Count -O--CK   100   100   000    -    0
Peter> 197 Current_Pending_Sector  -O---K   100   100   000    -    0
Peter> 198 Offline_Uncorrectable   ---R--   100   100   000    -    0
Peter> 199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    0
Peter>                             ||||||_ K auto-keep
Peter>                             |||||__ C event count
Peter>                             ||||___ R error rate
Peter>                             |||____ S speed/performance
Peter>                             ||_____ O updated online
Peter>                             |______ P prefailure warning

Peter> General Purpose Log Directory Version 1
Peter> SMART           Log Directory Version 1 [multi-sector log support]
Peter> Address    Access  R/W   Size  Description
Peter> 0x00       GPL,SL  R/O      1  Log Directory
Peter> 0x01           SL  R/O      1  Summary SMART error log
Peter> 0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
Peter> 0x04       GPL     R/O      7  Device Statistics log
Peter> 0x06           SL  R/O      1  SMART self-test log
Peter> 0x07       GPL     R/O      1  Extended self-test log
Peter> 0x08       GPL     R/O      2  Power Conditions log
Peter> 0x09           SL  R/W      1  Selective self-test log
Peter> 0x10       GPL     R/O      1  NCQ Command Error log
Peter> 0x11       GPL     R/O      1  SATA Phy Event Counters log
Peter> 0x20       GPL     R/O      1  Streaming performance log [OBS-8]
Peter> 0x21       GPL     R/O      1  Write stream error log
Peter> 0x22       GPL     R/O      1  Read stream error log
Peter> 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
Peter> 0xe0       GPL,SL  R/W      1  SCT Command/Status
Peter> 0xe1       GPL,SL  R/W      1  SCT Data Transfer

Peter> SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
Peter> No Errors Logged

Peter> SMART Extended Self-test Log Version: 1 (1 sectors)
Peter> No self-tests have been logged.  [To run self-tests, use: smartctl -t]

Peter> SMART Selective self-test log data structure revision number 1
Peter>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
Peter>     1        0        0  Not_testing
Peter>     2        0        0  Not_testing
Peter>     3        0        0  Not_testing
Peter>     4        0        0  Not_testing
Peter>     5        0        0  Not_testing
Peter> Selective self-test flags (0x0):
Peter>   After scanning selected spans, do NOT read-scan remainder of disk.
Peter> If Selective self-test is pending on power-up, resume after 0 minute delay.

Peter> SCT Status Version:                  3
Peter> SCT Version (vendor specific):       256 (0x0100)
Peter> Device State:                        Active (0)
Peter> Current Temperature:                    33 Celsius
Peter> Power Cycle Min/Max Temperature:     29/33 Celsius
Peter> Lifetime    Min/Max Temperature:     20/50 Celsius
Peter> Under/Over Temperature Limit Count:   0/0

Peter> SCT Temperature History Version:     2
Peter> Temperature Sampling Period:         1 minute
Peter> Temperature Logging Interval:        1 minute
Peter> Min/Max recommended Temperature:      0/60 Celsius
Peter> Min/Max Temperature Limit:           -40/70 Celsius
Peter> Temperature History Size (Index):    128 (51)

Peter> Index    Estimated Time   Temperature Celsius
Peter>   52    2022-08-25 19:12    33  **************
Peter>  ...    ..( 76 skipped).    ..  **************
Peter>    1    2022-08-25 20:29    33  **************
Peter>    2    2022-08-25 20:30     ?  -
Peter>    3    2022-08-25 20:31    33  **************
Peter>    4    2022-08-25 20:32    34  ***************
Peter>    5    2022-08-25 20:33    33  **************
Peter>    6    2022-08-25 20:34    34  ***************
Peter>  ...    ..(  2 skipped).    ..  ***************
Peter>    9    2022-08-25 20:37    34  ***************
Peter>   10    2022-08-25 20:38     ?  -
Peter>   11    2022-08-25 20:39    29  **********
Peter>   12    2022-08-25 20:40    30  ***********
Peter>  ...    ..(  2 skipped).    ..  ***********
Peter>   15    2022-08-25 20:43    30  ***********
Peter>   16    2022-08-25 20:44    31  ************
Peter>  ...    ..(  3 skipped).    ..  ************
Peter>   20    2022-08-25 20:48    31  ************
Peter>   21    2022-08-25 20:49    32  *************
Peter>  ...    ..(  9 skipped).    ..  *************
Peter>   31    2022-08-25 20:59    32  *************
Peter>   32    2022-08-25 21:00    33  **************
Peter>  ...    ..( 18 skipped).    ..  **************
Peter>   51    2022-08-25 21:19    33  **************

Peter> SCT Error Recovery Control:
Peter>            Read: Disabled
Peter>           Write: Disabled

Peter> Device Statistics (GP Log 0x04)
Peter> Page  Offset Size        Value Flags Description
Peter> 0x01  =====  =               =  ===  == General Statistics (rev 1) ==
Peter> 0x01  0x008  4             204  ---  Lifetime Power-On Resets
Peter> 0x01  0x010  4           41740  ---  Power-on Hours
Peter> 0x01  0x018  6     20304278904  ---  Logical Sectors Written
Peter> 0x01  0x020  6        64656942  ---  Number of Write Commands
Peter> 0x01  0x028  6    350269182084  ---  Logical Sectors Read
Peter> 0x01  0x030  6       481405773  ---  Number of Read Commands
Peter> 0x03  =====  =               =  ===  == Rotating Media Statistics (rev 1) ==
Peter> 0x03  0x008  4           41734  ---  Spindle Motor Power-on Hours
Peter> 0x03  0x010  4           41734  ---  Head Flying Hours
Peter> 0x03  0x018  4             759  ---  Head Load Events
Peter> 0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
Peter> 0x03  0x028  4              22  ---  Read Recovery Attempts
Peter> 0x03  0x030  4               6  ---  Number of Mechanical Start Failures
Peter> 0x04  =====  =               =  ===  == General Errors Statistics (rev 1) ==
Peter> 0x04  0x008  4               0  ---  Number of Reported Uncorrectable Errors
Peter> 0x04  0x010  4               1  ---  Resets Between Cmd Acceptance and
Peter> Completion
Peter> 0x05  =====  =               =  ===  == Temperature Statistics (rev 1) ==
Peter> 0x05  0x008  1              33  ---  Current Temperature
Peter> 0x05  0x010  1              33  N--  Average Short Term Temperature
Peter> 0x05  0x018  1              37  N--  Average Long Term Temperature
Peter> 0x05  0x020  1              50  ---  Highest Temperature
Peter> 0x05  0x028  1              20  ---  Lowest Temperature
Peter> 0x05  0x030  1              46  N--  Highest Average Short Term Temperature
Peter> 0x05  0x038  1              25  N--  Lowest Average Short Term Temperature
Peter> 0x05  0x040  1              43  N--  Highest Average Long Term Temperature
Peter> 0x05  0x048  1              25  N--  Lowest Average Long Term Temperature
Peter> 0x05  0x050  4               0  ---  Time in Over-Temperature
Peter> 0x05  0x058  1              60  ---  Specified Maximum Operating Temperature
Peter> 0x05  0x060  4               0  ---  Time in Under-Temperature
Peter> 0x05  0x068  1               0  ---  Specified Minimum Operating Temperature
Peter> 0x06  =====  =               =  ===  == Transport Statistics (rev 1) ==
Peter> 0x06  0x008  4            1006  ---  Number of Hardware Resets
Peter> 0x06  0x010  4             494  ---  Number of ASR Events
Peter> 0x06  0x018  4               0  ---  Number of Interface CRC Errors
Peter>                                 |||_ C monitored condition met
Peter>                                 ||__ D supports DSN
Peter>                                 |___ N normalized value

Peter> Pending Defects log (GP Log 0x0c) not supported

Peter> SATA Phy Event Counters (GP Log 0x11)
Peter> ID      Size     Value  Description
Peter> 0x0001  2            0  Command failed due to ICRC error
Peter> 0x0002  2            0  R_ERR response for data FIS
Peter> 0x0003  2            0  R_ERR response for device-to-host data FIS
Peter> 0x0004  2            0  R_ERR response for host-to-device data FIS
Peter> 0x0005  2            0  R_ERR response for non-data FIS
Peter> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
Peter> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
Peter> 0x0009  2           35  Transition from drive PhyRdy to drive PhyNRdy
Peter> 0x000a  2            5  Device-to-host register FISes sent due to a COMRESET
Peter> 0x000b  2            0  CRC errors within host-to-device FIS
Peter> 0x000d  2            0  Non-CRC errors within host-to-device FIS

Peter> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-17-amd64] (local build)
Peter> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

Peter> === START OF INFORMATION SECTION ===
Peter> Model Family:     Western Digital Green
Peter> Device Model:     WDC WD30EZRX-00DC0B0
Peter> Serial Number:    WD-WCC1T0668790
Peter> LU WWN Device Id: 5 0014ee 2084d406a
Peter> Firmware Version: 80.00A80
Peter> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Peter> Sector Sizes:     512 bytes logical, 4096 bytes physical
Peter> Device is:        In smartctl database [for details use: -P show]
Peter> ATA Version is:   ACS-2 (minor revision not indicated)
Peter> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Peter> Local Time is:    Thu Aug 25 21:19:51 2022 EDT
Peter> SMART support is: Available - device has SMART capability.
Peter> SMART support is: Enabled
Peter> AAM feature is:   Unavailable
Peter> APM feature is:   Unavailable
Peter> Rd look-ahead is: Enabled
Peter> Write cache is:   Enabled
Peter> DSN feature is:   Unavailable
Peter> ATA Security is:  Disabled, frozen [SEC2]
Peter> Wt Cache Reorder: Enabled

Peter> === START OF READ SMART DATA SECTION ===
Peter> SMART overall-health self-assessment test result: PASSED

Peter> General SMART Values:
Peter> Offline data collection status:  (0x82)    Offline data collection activity
Peter>                     was completed without error.
Peter>                     Auto Offline Data Collection: Enabled.
Peter> Self-test execution status:      (   0)    The previous self-test
Peter> routine completed
Peter>                     without error or no self-test has ever
Peter>                     been run.
Peter> Total time to complete Offline
Peter> data collection:         (40560) seconds.
Peter> Offline data collection
Peter> capabilities:              (0x7b) SMART execute Offline immediate.
Peter>                     Auto Offline data collection on/off support.
Peter>                     Suspend Offline collection upon new
Peter>                     command.
Peter>                     Offline surface scan supported.
Peter>                     Self-test supported.
Peter>                     Conveyance Self-test supported.
Peter>                     Selective Self-test supported.
Peter> SMART capabilities:            (0x0003)    Saves SMART data before entering
Peter>                     power-saving mode.
Peter>                     Supports SMART auto save timer.
Peter> Error logging capability:        (0x01)    Error logging supported.
Peter>                     General Purpose Logging supported.
Peter> Short self-test routine
Peter> recommended polling time:      (   2) minutes.
Peter> Extended self-test routine
Peter> recommended polling time:      ( 407) minutes.
Peter> Conveyance self-test routine
Peter> recommended polling time:      (   5) minutes.
Peter> SCT capabilities:            (0x70b5)    SCT Status supported.
Peter>                     SCT Feature Control supported.
Peter>                     SCT Data Table supported.

Peter> SMART Attributes Data Structure revision number: 16
Peter> Vendor Specific SMART Attributes with Thresholds:
Peter> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
Peter>   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
Peter>   3 Spin_Up_Time            POS--K   181   178   021    -    5916
Peter>   4 Start_Stop_Count        -O--CK   100   100   000    -    377
Peter>   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
Peter>   7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
Peter>   9 Power_On_Hours          -O--CK   007   007   000    -    68295
Peter>  10 Spin_Retry_Count        -O--CK   100   100   000    -    0
Peter>  11 Calibration_Retry_Count -O--CK   100   100   000    -    0
Peter>  12 Power_Cycle_Count       -O--CK   100   100   000    -    296
Peter> 192 Power-Off_Retract_Count -O--CK   200   200   000    -    242
Peter> 193 Load_Cycle_Count        -O--CK   052   052   000    -    445057
Peter> 194 Temperature_Celsius     -O---K   121   102   000    -    29
Peter> 196 Reallocated_Event_Count -O--CK   200   200   000    -    0
Peter> 197 Current_Pending_Sector  -O--CK   200   200   000    -    0
Peter> 198 Offline_Uncorrectable   ----CK   200   200   000    -    0
Peter> 199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
Peter> 200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
Peter>                             ||||||_ K auto-keep
Peter>                             |||||__ C event count
Peter>                             ||||___ R error rate
Peter>                             |||____ S speed/performance
Peter>                             ||_____ O updated online
Peter>                             |______ P prefailure warning

Peter> General Purpose Log Directory Version 1
Peter> SMART           Log Directory Version 1 [multi-sector log support]
Peter> Address    Access  R/W   Size  Description
Peter> 0x00       GPL,SL  R/O      1  Log Directory
Peter> 0x01           SL  R/O      1  Summary SMART error log
Peter> 0x02           SL  R/O      5  Comprehensive SMART error log
Peter> 0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
Peter> 0x06           SL  R/O      1  SMART self-test log
Peter> 0x07       GPL     R/O      1  Extended self-test log
Peter> 0x09           SL  R/W      1  Selective self-test log
Peter> 0x10       GPL     R/O      1  NCQ Command Error log
Peter> 0x11       GPL     R/O      1  SATA Phy Event Counters log
Peter> 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
Peter> 0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
Peter> 0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
Peter> 0xbd       GPL,SL  VS       1  Device vendor specific log
Peter> 0xc0       GPL,SL  VS       1  Device vendor specific log
Peter> 0xc1       GPL     VS      93  Device vendor specific log
Peter> 0xe0       GPL,SL  R/W      1  SCT Command/Status
Peter> 0xe1       GPL,SL  R/W      1  SCT Data Transfer

Peter> SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Peter> No Errors Logged

Peter> SMART Extended Self-test Log Version: 1 (1 sectors)
Peter> Num  Test_Description    Status                  Remaining
Peter> LifeTime(hours)  LBA_of_first_error
Peter> # 1  Extended offline    Completed without error       00%         7         -
Peter> # 2  Short offline       Completed without error       00%         0         -

Peter> SMART Selective self-test log data structure revision number 1
Peter>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
Peter>     1        0        0  Not_testing
Peter>     2        0        0  Not_testing
Peter>     3        0        0  Not_testing
Peter>     4        0        0  Not_testing
Peter>     5        0        0  Not_testing
Peter> Selective self-test flags (0x0):
Peter>   After scanning selected spans, do NOT read-scan remainder of disk.
Peter> If Selective self-test is pending on power-up, resume after 0 minute delay.

Peter> SCT Status Version:                  3
Peter> SCT Version (vendor specific):       258 (0x0102)
Peter> Device State:                        Active (0)
Peter> Current Temperature:                    29 Celsius
Peter> Power Cycle Min/Max Temperature:     28/29 Celsius
Peter> Lifetime    Min/Max Temperature:      2/48 Celsius
Peter> Under/Over Temperature Limit Count:   0/0
Peter> Vendor specific:
Peter> 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Peter> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Peter> SCT Temperature History Version:     2
Peter> Temperature Sampling Period:         1 minute
Peter> Temperature Logging Interval:        1 minute
Peter> Min/Max recommended Temperature:      0/60 Celsius
Peter> Min/Max Temperature Limit:           -41/85 Celsius
Peter> Temperature History Size (Index):    478 (138)

Peter> Index    Estimated Time   Temperature Celsius
Peter>  139    2022-08-25 13:22    30  ***********
Peter>  140    2022-08-25 13:23    29  **********
Peter>  ...    ..(  5 skipped).    ..  **********
Peter>  146    2022-08-25 13:29    29  **********
Peter>  147    2022-08-25 13:30     ?  -
Peter>  148    2022-08-25 13:31    26  *******
Peter>  149    2022-08-25 13:32     ?  -
Peter>  150    2022-08-25 13:33    28  *********
Peter>  151    2022-08-25 13:34     ?  -
Peter>  152    2022-08-25 13:35    28  *********
Peter>  153    2022-08-25 13:36    28  *********
Peter>  154    2022-08-25 13:37    29  **********
Peter>  ...    ..( 55 skipped).    ..  **********
Peter>  210    2022-08-25 14:33    29  **********
Peter>  211    2022-08-25 14:34    30  ***********
Peter>  ...    ..( 11 skipped).    ..  ***********
Peter>  223    2022-08-25 14:46    30  ***********
Peter>  224    2022-08-25 14:47    29  **********
Peter>  ...    ..(103 skipped).    ..  **********
Peter>  328    2022-08-25 16:31    29  **********
Peter>  329    2022-08-25 16:32    30  ***********
Peter>  ...    ..( 18 skipped).    ..  ***********
Peter>  348    2022-08-25 16:51    30  ***********
Peter>  349    2022-08-25 16:52    29  **********
Peter>  ...    ..( 33 skipped).    ..  **********
Peter>  383    2022-08-25 17:26    29  **********
Peter>  384    2022-08-25 17:27    30  ***********
Peter>  ...    ..( 10 skipped).    ..  ***********
Peter>  395    2022-08-25 17:38    30  ***********
Peter>  396    2022-08-25 17:39    29  **********
Peter>  ...    ..(218 skipped).    ..  **********
Peter>  137    2022-08-25 21:18    29  **********
Peter>  138    2022-08-25 21:19     ?  -

Peter> SCT Error Recovery Control command not supported

Peter> Device Statistics (GP/SMART Log 0x04) not supported

Peter> Pending Defects log (GP Log 0x0c) not supported

Peter> SATA Phy Event Counters (GP Log 0x11)
Peter> ID      Size     Value  Description
Peter> 0x0001  2            0  Command failed due to ICRC error
Peter> 0x0002  2            0  R_ERR response for data FIS
Peter> 0x0003  2            0  R_ERR response for device-to-host data FIS
Peter> 0x0004  2            0  R_ERR response for host-to-device data FIS
Peter> 0x0005  2            0  R_ERR response for non-data FIS
Peter> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
Peter> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
Peter> 0x0008  2            0  Device-to-host non-data FIS retries
Peter> 0x0009  2          305  Transition from drive PhyRdy to drive PhyNRdy
Peter> 0x000a  2            5  Device-to-host register FISes sent due to a COMRESET
Peter> 0x000b  2            0  CRC errors within host-to-device FIS
Peter> 0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
Peter> 0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
Peter> 0x8000  4         2491  Vendor specific

Peter> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-17-amd64] (local build)
Peter> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

Peter> === START OF INFORMATION SECTION ===
Peter> Model Family:     Toshiba P300
Peter> Device Model:     TOSHIBA HDWD130
Peter> Serial Number:    Y7211KPAS
Peter> LU WWN Device Id: 5 000039 fe6dca946
Peter> Firmware Version: MX6OACF0
Peter> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Peter> Sector Sizes:     512 bytes logical, 4096 bytes physical
Peter> Rotation Rate:    7200 rpm
Peter> Form Factor:      3.5 inches
Peter> Device is:        In smartctl database [for details use: -P show]
Peter> ATA Version is:   ATA8-ACS T13/1699-D revision 4
Peter> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Peter> Local Time is:    Thu Aug 25 21:19:51 2022 EDT
Peter> SMART support is: Available - device has SMART capability.
Peter> SMART support is: Enabled
Peter> AAM feature is:   Unavailable
Peter> APM feature is:   Disabled
Peter> Rd look-ahead is: Enabled
Peter> Write cache is:   Enabled
Peter> DSN feature is:   Unavailable
Peter> ATA Security is:  Disabled, frozen [SEC2]
Peter> Wt Cache Reorder: Enabled

Peter> === START OF READ SMART DATA SECTION ===
Peter> SMART overall-health self-assessment test result: PASSED

Peter> General SMART Values:
Peter> Offline data collection status:  (0x80)    Offline data collection activity
Peter>                     was never started.
Peter>                     Auto Offline Data Collection: Enabled.
Peter> Self-test execution status:      (   0)    The previous self-test
Peter> routine completed
Peter>                     without error or no self-test has ever
Peter>                     been run.
Peter> Total time to complete Offline
Peter> data collection:         (21791) seconds.
Peter> Offline data collection
Peter> capabilities:              (0x5b) SMART execute Offline immediate.
Peter>                     Auto Offline data collection on/off support.
Peter>                     Suspend Offline collection upon new
Peter>                     command.
Peter>                     Offline surface scan supported.
Peter>                     Self-test supported.
Peter>                     No Conveyance Self-test supported.
Peter>                     Selective Self-test supported.
Peter> SMART capabilities:            (0x0003)    Saves SMART data before entering
Peter>                     power-saving mode.
Peter>                     Supports SMART auto save timer.
Peter> Error logging capability:        (0x01)    Error logging supported.
Peter>                     General Purpose Logging supported.
Peter> Short self-test routine
Peter> recommended polling time:      (   1) minutes.
Peter> Extended self-test routine
Peter> recommended polling time:      ( 364) minutes.
Peter> SCT capabilities:            (0x003d)    SCT Status supported.
Peter>                     SCT Error Recovery Control supported.
Peter>                     SCT Feature Control supported.
Peter>                     SCT Data Table supported.

Peter> SMART Attributes Data Structure revision number: 16
Peter> Vendor Specific SMART Attributes with Thresholds:
Peter> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
Peter>   1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
Peter>   2 Throughput_Performance  P-S---   139   139   054    -    71
Peter>   3 Spin_Up_Time            POS---   160   160   024    -    361 (Average 355)
Peter>   4 Start_Stop_Count        -O--C-   100   100   000    -    189
Peter>   5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
Peter>   7 Seek_Error_Rate         PO-R--   100   100   067    -    0
Peter>   8 Seek_Time_Performance   P-S---   128   128   020    -    31
Peter>   9 Power_On_Hours          -O--C-   095   095   000    -    35428
Peter>  10 Spin_Retry_Count        PO--C-   100   100   060    -    0
Peter>  12 Power_Cycle_Count       -O--CK   100   100   000    -    189
Peter> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    599
Peter> 193 Load_Cycle_Count        -O--C-   100   100   000    -    599
Peter> 194 Temperature_Celsius     -O----   176   176   000    -    34 (Min/Max 19/50)
Peter> 196 Reallocated_Event_Count -O--CK   100   100   000    -    0
Peter> 197 Current_Pending_Sector  -O---K   100   100   000    -    0
Peter> 198 Offline_Uncorrectable   ---R--   100   100   000    -    0
Peter> 199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    0
Peter>                             ||||||_ K auto-keep
Peter>                             |||||__ C event count
Peter>                             ||||___ R error rate
Peter>                             |||____ S speed/performance
Peter>                             ||_____ O updated online
Peter>                             |______ P prefailure warning

Peter> General Purpose Log Directory Version 1
Peter> SMART           Log Directory Version 1 [multi-sector log support]
Peter> Address    Access  R/W   Size  Description
Peter> 0x00       GPL,SL  R/O      1  Log Directory
Peter> 0x01           SL  R/O      1  Summary SMART error log
Peter> 0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
Peter> 0x04       GPL     R/O      7  Device Statistics log
Peter> 0x06           SL  R/O      1  SMART self-test log
Peter> 0x07       GPL     R/O      1  Extended self-test log
Peter> 0x08       GPL     R/O      2  Power Conditions log
Peter> 0x09           SL  R/W      1  Selective self-test log
Peter> 0x10       GPL     R/O      1  NCQ Command Error log
Peter> 0x11       GPL     R/O      1  SATA Phy Event Counters log
Peter> 0x20       GPL     R/O      1  Streaming performance log [OBS-8]
Peter> 0x21       GPL     R/O      1  Write stream error log
Peter> 0x22       GPL     R/O      1  Read stream error log
Peter> 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
Peter> 0xe0       GPL,SL  R/W      1  SCT Command/Status
Peter> 0xe1       GPL,SL  R/W      1  SCT Data Transfer

Peter> SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
Peter> No Errors Logged

Peter> SMART Extended Self-test Log Version: 1 (1 sectors)
Peter> No self-tests have been logged.  [To run self-tests, use: smartctl -t]

Peter> SMART Selective self-test log data structure revision number 1
Peter>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
Peter>     1        0        0  Not_testing
Peter>     2        0        0  Not_testing
Peter>     3        0        0  Not_testing
Peter>     4        0        0  Not_testing
Peter>     5        0        0  Not_testing
Peter> Selective self-test flags (0x0):
Peter>   After scanning selected spans, do NOT read-scan remainder of disk.
Peter> If Selective self-test is pending on power-up, resume after 0 minute delay.

Peter> SCT Status Version:                  3
Peter> SCT Version (vendor specific):       256 (0x0100)
Peter> Device State:                        Active (0)
Peter> Current Temperature:                    34 Celsius
Peter> Power Cycle Min/Max Temperature:     28/34 Celsius
Peter> Lifetime    Min/Max Temperature:     19/50 Celsius
Peter> Under/Over Temperature Limit Count:   0/0

Peter> SCT Temperature History Version:     2
Peter> Temperature Sampling Period:         1 minute
Peter> Temperature Logging Interval:        1 minute
Peter> Min/Max recommended Temperature:      0/60 Celsius
Peter> Min/Max Temperature Limit:           -40/70 Celsius
Peter> Temperature History Size (Index):    128 (15)

Peter> Index    Estimated Time   Temperature Celsius
Peter>   16    2022-08-25 19:12    33  **************
Peter>  ...    ..( 66 skipped).    ..  **************
Peter>   83    2022-08-25 20:19    33  **************
Peter>   84    2022-08-25 20:20    34  ***************
Peter>  ...    ..(  8 skipped).    ..  ***************
Peter>   93    2022-08-25 20:29    34  ***************
Peter>   94    2022-08-25 20:30     ?  -
Peter>   95    2022-08-25 20:31    34  ***************
Peter>  ...    ..(  5 skipped).    ..  ***************
Peter>  101    2022-08-25 20:37    34  ***************
Peter>  102    2022-08-25 20:38     ?  -
Peter>  103    2022-08-25 20:39    29  **********
Peter>  104    2022-08-25 20:40    29  **********
Peter>  105    2022-08-25 20:41    30  ***********
Peter>  106    2022-08-25 20:42    30  ***********
Peter>  107    2022-08-25 20:43    31  ************
Peter>  ...    ..(  3 skipped).    ..  ************
Peter>  111    2022-08-25 20:47    31  ************
Peter>  112    2022-08-25 20:48    32  *************
Peter>  ...    ..(  4 skipped).    ..  *************
Peter>  117    2022-08-25 20:53    32  *************
Peter>  118    2022-08-25 20:54    33  **************
Peter>  ...    ..( 15 skipped).    ..  **************
Peter>    6    2022-08-25 21:10    33  **************
Peter>    7    2022-08-25 21:11    34  ***************
Peter>    8    2022-08-25 21:12    33  **************
Peter>    9    2022-08-25 21:13    34  ***************
Peter>  ...    ..(  5 skipped).    ..  ***************
Peter>   15    2022-08-25 21:19    34  ***************

Peter> SCT Error Recovery Control:
Peter>            Read: Disabled
Peter>           Write: Disabled

Peter> Device Statistics (GP Log 0x04)
Peter> Page  Offset Size        Value Flags Description
Peter> 0x01  =====  =               =  ===  == General Statistics (rev 1) ==
Peter> 0x01  0x008  4             189  ---  Lifetime Power-On Resets
Peter> 0x01  0x010  4           35428  ---  Power-on Hours
Peter> 0x01  0x018  6     12728825059  ---  Logical Sectors Written
Peter> 0x01  0x020  6        36220308  ---  Number of Write Commands
Peter> 0x01  0x028  6    289884223915  ---  Logical Sectors Read
Peter> 0x01  0x030  6       321688917  ---  Number of Read Commands
Peter> 0x03  =====  =               =  ===  == Rotating Media Statistics (rev 1) ==
Peter> 0x03  0x008  4           35423  ---  Spindle Motor Power-on Hours
Peter> 0x03  0x010  4           35423  ---  Head Flying Hours
Peter> 0x03  0x018  4             599  ---  Head Load Events
Peter> 0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
Peter> 0x03  0x028  4               7  ---  Read Recovery Attempts
Peter> 0x03  0x030  4               6  ---  Number of Mechanical Start Failures
Peter> 0x04  =====  =               =  ===  == General Errors Statistics (rev 1) ==
Peter> 0x04  0x008  4               0  ---  Number of Reported Uncorrectable Errors
Peter> 0x04  0x010  4               1  ---  Resets Between Cmd Acceptance and
Peter> Completion
Peter> 0x05  =====  =               =  ===  == Temperature Statistics (rev 1) ==
Peter> 0x05  0x008  1              34  ---  Current Temperature
Peter> 0x05  0x010  1              34  N--  Average Short Term Temperature
Peter> 0x05  0x018  1              37  N--  Average Long Term Temperature
Peter> 0x05  0x020  1              50  ---  Highest Temperature
Peter> 0x05  0x028  1              19  ---  Lowest Temperature
Peter> 0x05  0x030  1              46  N--  Highest Average Short Term Temperature
Peter> 0x05  0x038  1              25  N--  Lowest Average Short Term Temperature
Peter> 0x05  0x040  1              43  N--  Highest Average Long Term Temperature
Peter> 0x05  0x048  1              25  N--  Lowest Average Long Term Temperature
Peter> 0x05  0x050  4               0  ---  Time in Over-Temperature
Peter> 0x05  0x058  1              60  ---  Specified Maximum Operating Temperature
Peter> 0x05  0x060  4               0  ---  Time in Under-Temperature
Peter> 0x05  0x068  1               0  ---  Specified Minimum Operating Temperature
Peter> 0x06  =====  =               =  ===  == Transport Statistics (rev 1) ==
Peter> 0x06  0x008  4          147297  ---  Number of Hardware Resets
Peter> 0x06  0x010  4            8793  ---  Number of ASR Events
Peter> 0x06  0x018  4               0  ---  Number of Interface CRC Errors
Peter>                                 |||_ C monitored condition met
Peter>                                 ||__ D supports DSN
Peter>                                 |___ N normalized value

Peter> Pending Defects log (GP Log 0x0c) not supported

Peter> SATA Phy Event Counters (GP Log 0x11)
Peter> ID      Size     Value  Description
Peter> 0x0001  2            0  Command failed due to ICRC error
Peter> 0x0002  2            0  R_ERR response for data FIS
Peter> 0x0003  2            0  R_ERR response for device-to-host data FIS
Peter> 0x0004  2            0  R_ERR response for host-to-device data FIS
Peter> 0x0005  2            0  R_ERR response for non-data FIS
Peter> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
Peter> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
Peter> 0x0009  2           29  Transition from drive PhyRdy to drive PhyNRdy
Peter> 0x000a  2            5  Device-to-host register FISes sent due to a COMRESET
Peter> 0x000b  2            0  CRC errors within host-to-device FIS
Peter> 0x000d  2            0  Non-CRC errors within host-to-device FIS

Peter> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-17-amd64] (local build)
Peter> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

Peter> === START OF INFORMATION SECTION ===
Peter> Model Family:     Western Digital Green
Peter> Device Model:     WDC WD30EZRX-00D8PB0
Peter> Serial Number:    WD-WCC4N0091255
Peter> LU WWN Device Id: 5 0014ee 2b3d4ffa1
Peter> Firmware Version: 80.00A80
Peter> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Peter> Sector Sizes:     512 bytes logical, 4096 bytes physical
Peter> Rotation Rate:    5400 rpm
Peter> Device is:        In smartctl database [for details use: -P show]
Peter> ATA Version is:   ACS-2 (minor revision not indicated)
Peter> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Peter> Local Time is:    Thu Aug 25 21:19:53 2022 EDT
Peter> SMART support is: Available - device has SMART capability.
Peter> SMART support is: Enabled
Peter> AAM feature is:   Unavailable
Peter> APM feature is:   Unavailable
Peter> Rd look-ahead is: Enabled
Peter> Write cache is:   Enabled
Peter> DSN feature is:   Unavailable
Peter> ATA Security is:  Disabled, frozen [SEC2]
Peter> Wt Cache Reorder: Enabled

Peter> === START OF READ SMART DATA SECTION ===
Peter> SMART overall-health self-assessment test result: PASSED

Peter> General SMART Values:
Peter> Offline data collection status:  (0x82)    Offline data collection activity
Peter>                     was completed without error.
Peter>                     Auto Offline Data Collection: Enabled.
Peter> Self-test execution status:      (   0)    The previous self-test
Peter> routine completed
Peter>                     without error or no self-test has ever
Peter>                     been run.
Peter> Total time to complete Offline
Peter> data collection:         (42480) seconds.
Peter> Offline data collection
Peter> capabilities:              (0x7b) SMART execute Offline immediate.
Peter>                     Auto Offline data collection on/off support.
Peter>                     Suspend Offline collection upon new
Peter>                     command.
Peter>                     Offline surface scan supported.
Peter>                     Self-test supported.
Peter>                     Conveyance Self-test supported.
Peter>                     Selective Self-test supported.
Peter> SMART capabilities:            (0x0003)    Saves SMART data before entering
Peter>                     power-saving mode.
Peter>                     Supports SMART auto save timer.
Peter> Error logging capability:        (0x01)    Error logging supported.
Peter>                     General Purpose Logging supported.
Peter> Short self-test routine
Peter> recommended polling time:      (   2) minutes.
Peter> Extended self-test routine
Peter> recommended polling time:      ( 426) minutes.
Peter> Conveyance self-test routine
Peter> recommended polling time:      (   5) minutes.
Peter> SCT capabilities:            (0x7035)    SCT Status supported.
Peter>                     SCT Feature Control supported.
Peter>                     SCT Data Table supported.

Peter> SMART Attributes Data Structure revision number: 16
Peter> Vendor Specific SMART Attributes with Thresholds:
Peter> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
Peter>   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    2
Peter>   3 Spin_Up_Time            POS--K   184   181   021    -    5783
Peter>   4 Start_Stop_Count        -O--CK   100   100   000    -    275
Peter>   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
Peter>   7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
Peter>   9 Power_On_Hours          -O--CK   039   039   000    -    44593
Peter>  10 Spin_Retry_Count        -O--CK   100   100   000    -    0
Peter>  11 Calibration_Retry_Count -O--CK   100   100   000    -    0
Peter>  12 Power_Cycle_Count       -O--CK   100   100   000    -    273
Peter> 192 Power-Off_Retract_Count -O--CK   200   200   000    -    225
Peter> 193 Load_Cycle_Count        -O--CK   047   047   000    -    461100
Peter> 194 Temperature_Celsius     -O---K   122   105   000    -    28
Peter> 196 Reallocated_Event_Count -O--CK   200   200   000    -    0
Peter> 197 Current_Pending_Sector  -O--CK   200   200   000    -    0
Peter> 198 Offline_Uncorrectable   ----CK   200   200   000    -    0
Peter> 199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
Peter> 200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    0
Peter>                             ||||||_ K auto-keep
Peter>                             |||||__ C event count
Peter>                             ||||___ R error rate
Peter>                             |||____ S speed/performance
Peter>                             ||_____ O updated online
Peter>                             |______ P prefailure warning

Peter> General Purpose Log Directory Version 1
Peter> SMART           Log Directory Version 1 [multi-sector log support]
Peter> Address    Access  R/W   Size  Description
Peter> 0x00       GPL,SL  R/O      1  Log Directory
Peter> 0x01           SL  R/O      1  Summary SMART error log
Peter> 0x02           SL  R/O      5  Comprehensive SMART error log
Peter> 0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
Peter> 0x06           SL  R/O      1  SMART self-test log
Peter> 0x07       GPL     R/O      1  Extended self-test log
Peter> 0x09           SL  R/W      1  Selective self-test log
Peter> 0x10       GPL     R/O      1  NCQ Command Error log
Peter> 0x11       GPL     R/O      1  SATA Phy Event Counters log
Peter> 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
Peter> 0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
Peter> 0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
Peter> 0xbd       GPL,SL  VS       1  Device vendor specific log
Peter> 0xc0       GPL,SL  VS       1  Device vendor specific log
Peter> 0xc1       GPL     VS      93  Device vendor specific log
Peter> 0xe0       GPL,SL  R/W      1  SCT Command/Status
Peter> 0xe1       GPL,SL  R/W      1  SCT Data Transfer

Peter> SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Peter> No Errors Logged

Peter> SMART Extended Self-test Log Version: 1 (1 sectors)
Peter> No self-tests have been logged.  [To run self-tests, use: smartctl -t]

Peter> SMART Selective self-test log data structure revision number 1
Peter>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
Peter>     1        0        0  Not_testing
Peter>     2        0        0  Not_testing
Peter>     3        0        0  Not_testing
Peter>     4        0        0  Not_testing
Peter>     5        0        0  Not_testing
Peter> Selective self-test flags (0x0):
Peter>   After scanning selected spans, do NOT read-scan remainder of disk.
Peter> If Selective self-test is pending on power-up, resume after 0 minute delay.

Peter> SCT Status Version:                  3
Peter> SCT Version (vendor specific):       258 (0x0102)
Peter> Device State:                        Active (0)
Peter> Current Temperature:                    28 Celsius
Peter> Power Cycle Min/Max Temperature:     27/28 Celsius
Peter> Lifetime    Min/Max Temperature:      2/44 Celsius
Peter> Under/Over Temperature Limit Count:   0/0
Peter> Vendor specific:
Peter> 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Peter> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00

Peter> SCT Temperature History Version:     2
Peter> Temperature Sampling Period:         1 minute
Peter> Temperature Logging Interval:        1 minute
Peter> Min/Max recommended Temperature:      0/60 Celsius
Peter> Min/Max Temperature Limit:           -41/85 Celsius
Peter> Temperature History Size (Index):    478 (444)

Peter> Index    Estimated Time   Temperature Celsius
Peter>  445    2022-08-25 13:22    29  **********
Peter>  ...    ..( 33 skipped).    ..  **********
Peter>    1    2022-08-25 13:56    29  **********
Peter>    2    2022-08-25 13:57     ?  -
Peter>    3    2022-08-25 13:58    29  **********
Peter>  ...    ..(  6 skipped).    ..  **********
Peter>   10    2022-08-25 14:05    29  **********
Peter>   11    2022-08-25 14:06     ?  -
Peter>   12    2022-08-25 14:07    26  *******
Peter>   13    2022-08-25 14:08     ?  -
Peter>   14    2022-08-25 14:09    27  ********
Peter>   15    2022-08-25 14:10    27  ********
Peter>   16    2022-08-25 14:11    28  *********
Peter>  ...    ..( 37 skipped).    ..  *********
Peter>   54    2022-08-25 14:49    28  *********
Peter>   55    2022-08-25 14:50    29  **********
Peter>  ...    ..(388 skipped).    ..  **********
Peter>  444    2022-08-25 21:19    29  **********

Peter> SCT Error Recovery Control command not supported

Peter> Device Statistics (GP/SMART Log 0x04) not supported

Peter> Pending Defects log (GP Log 0x0c) not supported

Peter> SATA Phy Event Counters (GP Log 0x11)
Peter> ID      Size     Value  Description
Peter> 0x0001  2            0  Command failed due to ICRC error
Peter> 0x0002  2            0  R_ERR response for data FIS
Peter> 0x0003  2            0  R_ERR response for device-to-host data FIS
Peter> 0x0004  2            0  R_ERR response for host-to-device data FIS
Peter> 0x0005  2            0  R_ERR response for non-data FIS
Peter> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
Peter> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
Peter> 0x0008  2            0  Device-to-host non-data FIS retries
Peter> 0x0009  2          286  Transition from drive PhyRdy to drive PhyNRdy
Peter> 0x000a  2            5  Device-to-host register FISes sent due to a COMRESET
Peter> 0x000b  2            0  CRC errors within host-to-device FIS
Peter> 0x000f  2            0  R_ERR response for host-to-device data FIS, CRC
Peter> 0x0012  2            0  R_ERR response for host-to-device non-data FIS, CRC
Peter> 0x8000  4         2493  Vendor specific

Peter> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-17-amd64] (local build)
Peter> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

Peter> === START OF INFORMATION SECTION ===
Peter> Model Family:     Western Digital Green
Peter> Device Model:     WDC WD30EZRX-00MMMB0
Peter> Serial Number:    WD-WCAWZ2669166
Peter> LU WWN Device Id: 5 0014ee 15a13d994
Peter> Firmware Version: 80.00A80
Peter> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Peter> Sector Sizes:     512 bytes logical, 4096 bytes physical
Peter> Device is:        In smartctl database [for details use: -P show]
Peter> ATA Version is:   ATA8-ACS (minor revision not indicated)
Peter> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Peter> Local Time is:    Thu Aug 25 21:19:53 2022 EDT
Peter> SMART support is: Available - device has SMART capability.
Peter> SMART support is: Enabled
Peter> AAM feature is:   Unavailable
Peter> APM feature is:   Unavailable
Peter> Rd look-ahead is: Enabled
Peter> Write cache is:   Enabled
Peter> DSN feature is:   Unavailable
Peter> ATA Security is:  Disabled, frozen [SEC2]
Peter> Wt Cache Reorder: Enabled

Peter> === START OF READ SMART DATA SECTION ===
Peter> SMART overall-health self-assessment test result: PASSED

Peter> General SMART Values:
Peter> Offline data collection status:  (0x82)    Offline data collection activity
Peter>                     was completed without error.
Peter>                     Auto Offline Data Collection: Enabled.
Peter> Self-test execution status:      (   0)    The previous self-test
Peter> routine completed
Peter>                     without error or no self-test has ever
Peter>                     been run.
Peter> Total time to complete Offline
Peter> data collection:         (50160) seconds.
Peter> Offline data collection
Peter> capabilities:              (0x7b) SMART execute Offline immediate.
Peter>                     Auto Offline data collection on/off support.
Peter>                     Suspend Offline collection upon new
Peter>                     command.
Peter>                     Offline surface scan supported.
Peter>                     Self-test supported.
Peter>                     Conveyance Self-test supported.
Peter>                     Selective Self-test supported.
Peter> SMART capabilities:            (0x0003)    Saves SMART data before entering
Peter>                     power-saving mode.
Peter>                     Supports SMART auto save timer.
Peter> Error logging capability:        (0x01)    Error logging supported.
Peter>                     General Purpose Logging supported.
Peter> Short self-test routine
Peter> recommended polling time:      (   2) minutes.
Peter> Extended self-test routine
Peter> recommended polling time:      ( 482) minutes.
Peter> Conveyance self-test routine
Peter> recommended polling time:      (   5) minutes.
Peter> SCT capabilities:            (0x3035)    SCT Status supported.
Peter>                     SCT Feature Control supported.
Peter>                     SCT Data Table supported.

Peter> SMART Attributes Data Structure revision number: 16
Peter> Vendor Specific SMART Attributes with Thresholds:
Peter> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
Peter>   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
Peter>   3 Spin_Up_Time            POS--K   153   138   021    -    9350
Peter>   4 Start_Stop_Count        -O--CK   100   100   000    -    297
Peter>   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
Peter>   7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
Peter>   9 Power_On_Hours          -O--CK   040   040   000    -    44409
Peter>  10 Spin_Retry_Count        -O--CK   100   100   000    -    0
Peter>  11 Calibration_Retry_Count -O--CK   100   100   000    -    0
Peter>  12 Power_Cycle_Count       -O--CK   100   100   000    -    268
Peter> 192 Power-Off_Retract_Count -O--CK   200   200   000    -    218
Peter> 193 Load_Cycle_Count        -O--CK   001   001   000    -    1082082
Peter> 194 Temperature_Celsius     -O---K   122   105   000    -    30
Peter> 196 Reallocated_Event_Count -O--CK   200   200   000    -    0
Peter> 197 Current_Pending_Sector  -O--CK   200   200   000    -    0
Peter> 198 Offline_Uncorrectable   ----CK   200   200   000    -    0
Peter> 199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
Peter> 200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    1
Peter>                             ||||||_ K auto-keep
Peter>                             |||||__ C event count
Peter>                             ||||___ R error rate
Peter>                             |||____ S speed/performance
Peter>                             ||_____ O updated online
Peter>                             |______ P prefailure warning

Peter> General Purpose Log Directory Version 1
Peter> SMART           Log Directory Version 1 [multi-sector log support]
Peter> Address    Access  R/W   Size  Description
Peter> 0x00       GPL,SL  R/O      1  Log Directory
Peter> 0x01           SL  R/O      1  Summary SMART error log
Peter> 0x02           SL  R/O      5  Comprehensive SMART error log
Peter> 0x03       GPL     R/O      6  Ext. Comprehensive SMART error log
Peter> 0x06           SL  R/O      1  SMART self-test log
Peter> 0x07       GPL     R/O      1  Extended self-test log
Peter> 0x09           SL  R/W      1  Selective self-test log
Peter> 0x10       GPL     R/O      1  NCQ Command Error log
Peter> 0x11       GPL     R/O      1  SATA Phy Event Counters log
Peter> 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
Peter> 0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
Peter> 0xa8-0xb7  GPL,SL  VS       1  Device vendor specific log
Peter> 0xbd       GPL,SL  VS       1  Device vendor specific log
Peter> 0xc0       GPL,SL  VS       1  Device vendor specific log
Peter> 0xc1       GPL     VS      93  Device vendor specific log
Peter> 0xe0       GPL,SL  R/W      1  SCT Command/Status
Peter> 0xe1       GPL,SL  R/W      1  SCT Data Transfer

Peter> SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Peter> No Errors Logged

Peter> SMART Extended Self-test Log Version: 1 (1 sectors)
Peter> No self-tests have been logged.  [To run self-tests, use: smartctl -t]

Peter> SMART Selective self-test log data structure revision number 1
Peter>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
Peter>     1        0        0  Not_testing
Peter>     2        0        0  Not_testing
Peter>     3        0        0  Not_testing
Peter>     4        0        0  Not_testing
Peter>     5        0        0  Not_testing
Peter> Selective self-test flags (0x0):
Peter>   After scanning selected spans, do NOT read-scan remainder of disk.
Peter> If Selective self-test is pending on power-up, resume after 0 minute delay.

Peter> SCT Status Version:                  3
Peter> SCT Version (vendor specific):       258 (0x0102)
Peter> Device State:                        Active (0)
Peter> Current Temperature:                    30 Celsius
Peter> Power Cycle Min/Max Temperature:     27/30 Celsius
Peter> Lifetime    Min/Max Temperature:      0/47 Celsius
Peter> Under/Over Temperature Limit Count:   0/0

Peter> SCT Temperature History Version:     2
Peter> Temperature Sampling Period:         1 minute
Peter> Temperature Logging Interval:        1 minute
Peter> Min/Max recommended Temperature:      0/60 Celsius
Peter> Min/Max Temperature Limit:           -41/85 Celsius
Peter> Temperature History Size (Index):    478 (88)

Peter> Index    Estimated Time   Temperature Celsius
Peter>   89    2022-08-25 13:22    30  ***********
Peter>  ...    ..( 33 skipped).    ..  ***********
Peter>  123    2022-08-25 13:56    30  ***********
Peter>  124    2022-08-25 13:57     ?  -
Peter>  125    2022-08-25 13:58    31  ************
Peter>  126    2022-08-25 13:59    30  ***********
Peter>  ...    ..(  5 skipped).    ..  ***********
Peter>  132    2022-08-25 14:05    30  ***********
Peter>  133    2022-08-25 14:06     ?  -
Peter>  134    2022-08-25 14:07    26  *******
Peter>  135    2022-08-25 14:08     ?  -
Peter>  136    2022-08-25 14:09    27  ********
Peter>  ...    ..(  3 skipped).    ..  ********
Peter>  140    2022-08-25 14:13    27  ********
Peter>  141    2022-08-25 14:14    28  *********
Peter>  ...    ..(  3 skipped).    ..  *********
Peter>  145    2022-08-25 14:18    28  *********
Peter>  146    2022-08-25 14:19    29  **********
Peter>  ...    ..( 13 skipped).    ..  **********
Peter>  160    2022-08-25 14:33    29  **********
Peter>  161    2022-08-25 14:34    30  ***********
Peter>  ...    ..( 43 skipped).    ..  ***********
Peter>  205    2022-08-25 15:18    30  ***********
Peter>  206    2022-08-25 15:19    31  ************
Peter>  207    2022-08-25 15:20    30  ***********
Peter>  ...    ..(168 skipped).    ..  ***********
Peter>  376    2022-08-25 18:09    30  ***********
Peter>  377    2022-08-25 18:10    31  ************
Peter>  378    2022-08-25 18:11    30  ***********
Peter>  ...    ..( 34 skipped).    ..  ***********
Peter>  413    2022-08-25 18:46    30  ***********
Peter>  414    2022-08-25 18:47    31  ************
Peter>  415    2022-08-25 18:48    30  ***********
Peter>  ...    ..(  7 skipped).    ..  ***********
Peter>  423    2022-08-25 18:56    30  ***********
Peter>  424    2022-08-25 18:57    31  ************
Peter>  425    2022-08-25 18:58    30  ***********
Peter>  ...    ..(  7 skipped).    ..  ***********
Peter>  433    2022-08-25 19:06    30  ***********
Peter>  434    2022-08-25 19:07    31  ************
Peter>  435    2022-08-25 19:08    30  ***********
Peter>  ...    ..( 47 skipped).    ..  ***********
Peter>    5    2022-08-25 19:56    30  ***********
Peter>    6    2022-08-25 19:57    31  ************
Peter>    7    2022-08-25 19:58    30  ***********
Peter>  ...    ..( 80 skipped).    ..  ***********
Peter>   88    2022-08-25 21:19    30  ***********

Peter> SCT Error Recovery Control command not supported

Peter> Device Statistics (GP/SMART Log 0x04) not supported

Peter> Pending Defects log (GP Log 0x0c) not supported

Peter> SATA Phy Event Counters (GP Log 0x11)
Peter> ID      Size     Value  Description
Peter> 0x0001  2            0  Command failed due to ICRC error
Peter> 0x0002  2            0  R_ERR response for data FIS
Peter> 0x0003  2            0  R_ERR response for device-to-host data FIS
Peter> 0x0004  2            0  R_ERR response for host-to-device data FIS
Peter> 0x0005  2            0  R_ERR response for non-data FIS
Peter> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
Peter> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
Peter> 0x000a  2            3  Device-to-host register FISes sent due to a COMRESET
Peter> 0x000b  2            0  CRC errors within host-to-device FIS
Peter> 0x8000  4         2492  Vendor specific

Peter> smartctl 7.2 2020-12-30 r5155 [x86_64-linux-5.10.0-17-amd64] (local build)
Peter> Copyright (C) 2002-20, Bruce Allen, Christian Franke, www.smartmontools.org

Peter> === START OF INFORMATION SECTION ===
Peter> Model Family:     Toshiba P300
Peter> Device Model:     TOSHIBA HDWD130
Peter> Serial Number:    477ABEJAS
Peter> LU WWN Device Id: 5 000039 fe6d2ce25
Peter> Firmware Version: MX6OACF0
Peter> User Capacity:    3,000,592,982,016 bytes [3.00 TB]
Peter> Sector Sizes:     512 bytes logical, 4096 bytes physical
Peter> Rotation Rate:    7200 rpm
Peter> Form Factor:      3.5 inches
Peter> Device is:        In smartctl database [for details use: -P show]
Peter> ATA Version is:   ATA8-ACS T13/1699-D revision 4
Peter> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Peter> Local Time is:    Thu Aug 25 21:19:53 2022 EDT
Peter> SMART support is: Available - device has SMART capability.
Peter> SMART support is: Enabled
Peter> AAM feature is:   Unavailable
Peter> APM feature is:   Disabled
Peter> Rd look-ahead is: Enabled
Peter> Write cache is:   Enabled
Peter> DSN feature is:   Unavailable
Peter> ATA Security is:  Disabled, frozen [SEC2]
Peter> Wt Cache Reorder: Enabled

Peter> === START OF READ SMART DATA SECTION ===
Peter> SMART overall-health self-assessment test result: PASSED

Peter> General SMART Values:
Peter> Offline data collection status:  (0x80)    Offline data collection activity
Peter>                     was never started.
Peter>                     Auto Offline Data Collection: Enabled.
Peter> Self-test execution status:      (   0)    The previous self-test
Peter> routine completed
Peter>                     without error or no self-test has ever
Peter>                     been run.
Peter> Total time to complete Offline
Peter> data collection:         (23082) seconds.
Peter> Offline data collection
Peter> capabilities:              (0x5b) SMART execute Offline immediate.
Peter>                     Auto Offline data collection on/off support.
Peter>                     Suspend Offline collection upon new
Peter>                     command.
Peter>                     Offline surface scan supported.
Peter>                     Self-test supported.
Peter>                     No Conveyance Self-test supported.
Peter>                     Selective Self-test supported.
Peter> SMART capabilities:            (0x0003)    Saves SMART data before entering
Peter>                     power-saving mode.
Peter>                     Supports SMART auto save timer.
Peter> Error logging capability:        (0x01)    Error logging supported.
Peter>                     General Purpose Logging supported.
Peter> Short self-test routine
Peter> recommended polling time:      (   1) minutes.
Peter> Extended self-test routine
Peter> recommended polling time:      ( 385) minutes.
Peter> SCT capabilities:            (0x003d)    SCT Status supported.
Peter>                     SCT Error Recovery Control supported.
Peter>                     SCT Feature Control supported.
Peter>                     SCT Data Table supported.

Peter> SMART Attributes Data Structure revision number: 16
Peter> Vendor Specific SMART Attributes with Thresholds:
Peter> ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
Peter>   1 Raw_Read_Error_Rate     PO-R--   100   100   016    -    0
Peter>   2 Throughput_Performance  P-S---   140   140   054    -    68
Peter>   3 Spin_Up_Time            POS---   161   161   024    -    358 (Average 354)
Peter>   4 Start_Stop_Count        -O--C-   100   100   000    -    243
Peter>   5 Reallocated_Sector_Ct   PO--CK   100   100   005    -    0
Peter>   7 Seek_Error_Rate         PO-R--   100   100   067    -    0
Peter>   8 Seek_Time_Performance   P-S---   126   126   020    -    32
Peter>   9 Power_On_Hours          -O--C-   094   094   000    -    44046
Peter>  10 Spin_Retry_Count        PO--C-   100   100   060    -    0
Peter>  12 Power_Cycle_Count       -O--CK   100   100   000    -    243
Peter> 192 Power-Off_Retract_Count -O--CK   100   100   000    -    912
Peter> 193 Load_Cycle_Count        -O--C-   100   100   000    -    912
Peter> 194 Temperature_Celsius     -O----   193   193   000    -    31 (Min/Max 19/46)
Peter> 196 Reallocated_Event_Count -O--CK   100   100   000    -    0
Peter> 197 Current_Pending_Sector  -O---K   100   100   000    -    0
Peter> 198 Offline_Uncorrectable   ---R--   100   100   000    -    0
Peter> 199 UDMA_CRC_Error_Count    -O-R--   200   200   000    -    0
Peter>                             ||||||_ K auto-keep
Peter>                             |||||__ C event count
Peter>                             ||||___ R error rate
Peter>                             |||____ S speed/performance
Peter>                             ||_____ O updated online
Peter>                             |______ P prefailure warning

Peter> General Purpose Log Directory Version 1
Peter> SMART           Log Directory Version 1 [multi-sector log support]
Peter> Address    Access  R/W   Size  Description
Peter> 0x00       GPL,SL  R/O      1  Log Directory
Peter> 0x01           SL  R/O      1  Summary SMART error log
Peter> 0x03       GPL     R/O      1  Ext. Comprehensive SMART error log
Peter> 0x04       GPL     R/O      7  Device Statistics log
Peter> 0x06           SL  R/O      1  SMART self-test log
Peter> 0x07       GPL     R/O      1  Extended self-test log
Peter> 0x08       GPL     R/O      2  Power Conditions log
Peter> 0x09           SL  R/W      1  Selective self-test log
Peter> 0x10       GPL     R/O      1  NCQ Command Error log
Peter> 0x11       GPL     R/O      1  SATA Phy Event Counters log
Peter> 0x20       GPL     R/O      1  Streaming performance log [OBS-8]
Peter> 0x21       GPL     R/O      1  Write stream error log
Peter> 0x22       GPL     R/O      1  Read stream error log
Peter> 0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
Peter> 0xe0       GPL,SL  R/W      1  SCT Command/Status
Peter> 0xe1       GPL,SL  R/W      1  SCT Data Transfer

Peter> SMART Extended Comprehensive Error Log Version: 1 (1 sectors)
Peter> No Errors Logged

Peter> SMART Extended Self-test Log Version: 1 (1 sectors)
Peter> No self-tests have been logged.  [To run self-tests, use: smartctl -t]

Peter> SMART Selective self-test log data structure revision number 1
Peter>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
Peter>     1        0        0  Not_testing
Peter>     2        0        0  Not_testing
Peter>     3        0        0  Not_testing
Peter>     4        0        0  Not_testing
Peter>     5        0        0  Not_testing
Peter> Selective self-test flags (0x0):
Peter>   After scanning selected spans, do NOT read-scan remainder of disk.
Peter> If Selective self-test is pending on power-up, resume after 0 minute delay.

Peter> SCT Status Version:                  3
Peter> SCT Version (vendor specific):       256 (0x0100)
Peter> Device State:                        Active (0)
Peter> Current Temperature:                    31 Celsius
Peter> Power Cycle Min/Max Temperature:     28/32 Celsius
Peter> Lifetime    Min/Max Temperature:     19/46 Celsius
Peter> Under/Over Temperature Limit Count:   0/0

Peter> SCT Temperature History Version:     2
Peter> Temperature Sampling Period:         1 minute
Peter> Temperature Logging Interval:        1 minute
Peter> Min/Max recommended Temperature:      0/60 Celsius
Peter> Min/Max Temperature Limit:           -40/70 Celsius
Peter> Temperature History Size (Index):    128 (117)

Peter> Index    Estimated Time   Temperature Celsius
Peter>  118    2022-08-25 19:12    31  ************
Peter>  ...    ..( 76 skipped).    ..  ************
Peter>   67    2022-08-25 20:29    31  ************
Peter>   68    2022-08-25 20:30     ?  -
Peter>   69    2022-08-25 20:31    31  ************
Peter>   70    2022-08-25 20:32    32  *************
Peter>   71    2022-08-25 20:33    31  ************
Peter>   72    2022-08-25 20:34    31  ************
Peter>   73    2022-08-25 20:35    32  *************
Peter>   74    2022-08-25 20:36    32  *************
Peter>   75    2022-08-25 20:37    32  *************
Peter>   76    2022-08-25 20:38     ?  -
Peter>   77    2022-08-25 20:39    28  *********
Peter>   78    2022-08-25 20:40    29  **********
Peter>  ...    ..(  2 skipped).    ..  **********
Peter>   81    2022-08-25 20:43    29  **********
Peter>   82    2022-08-25 20:44    30  ***********
Peter>  ...    ..(  5 skipped).    ..  ***********
Peter>   88    2022-08-25 20:50    30  ***********
Peter>   89    2022-08-25 20:51    31  ************
Peter>  ...    ..( 27 skipped).    ..  ************
Peter>  117    2022-08-25 21:19    31  ************

Peter> SCT Error Recovery Control:
Peter>            Read: Disabled
Peter>           Write: Disabled

Peter> Device Statistics (GP Log 0x04)
Peter> Page  Offset Size        Value Flags Description
Peter> 0x01  =====  =               =  ===  == General Statistics (rev 1) ==
Peter> 0x01  0x008  4             243  ---  Lifetime Power-On Resets
Peter> 0x01  0x010  4           44046  ---  Power-on Hours
Peter> 0x01  0x018  6     27756962802  ---  Logical Sectors Written
Peter> 0x01  0x020  6        86355955  ---  Number of Write Commands
Peter> 0x01  0x028  6    381193626849  ---  Logical Sectors Read
Peter> 0x01  0x030  6       791200694  ---  Number of Read Commands
Peter> 0x03  =====  =               =  ===  == Rotating Media Statistics (rev 1) ==
Peter> 0x03  0x008  4           44040  ---  Spindle Motor Power-on Hours
Peter> 0x03  0x010  4           44040  ---  Head Flying Hours
Peter> 0x03  0x018  4             912  ---  Head Load Events
Peter> 0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
Peter> 0x03  0x028  4               0  ---  Read Recovery Attempts
Peter> 0x03  0x030  4               6  ---  Number of Mechanical Start Failures
Peter> 0x04  =====  =               =  ===  == General Errors Statistics (rev 1) ==
Peter> 0x04  0x008  4               0  ---  Number of Reported Uncorrectable Errors
Peter> 0x04  0x010  4               0  ---  Resets Between Cmd Acceptance and
Peter> Completion
Peter> 0x05  =====  =               =  ===  == Temperature Statistics (rev 1) ==
Peter> 0x05  0x008  1              32  ---  Current Temperature
Peter> 0x05  0x010  1              31  N--  Average Short Term Temperature
Peter> 0x05  0x018  1              35  N--  Average Long Term Temperature
Peter> 0x05  0x020  1              46  ---  Highest Temperature
Peter> 0x05  0x028  1              19  ---  Lowest Temperature
Peter> 0x05  0x030  1              43  N--  Highest Average Short Term Temperature
Peter> 0x05  0x038  1              25  N--  Lowest Average Short Term Temperature
Peter> 0x05  0x040  1              41  N--  Highest Average Long Term Temperature
Peter> 0x05  0x048  1              25  N--  Lowest Average Long Term Temperature
Peter> 0x05  0x050  4               0  ---  Time in Over-Temperature
Peter> 0x05  0x058  1              60  ---  Specified Maximum Operating Temperature
Peter> 0x05  0x060  4               0  ---  Time in Under-Temperature
Peter> 0x05  0x068  1               0  ---  Specified Minimum Operating Temperature
Peter> 0x06  =====  =               =  ===  == Transport Statistics (rev 1) ==
Peter> 0x06  0x008  4            4706  ---  Number of Hardware Resets
Peter> 0x06  0x010  4            3910  ---  Number of ASR Events
Peter> 0x06  0x018  4               0  ---  Number of Interface CRC Errors
Peter>                                 |||_ C monitored condition met
Peter>                                 ||__ D supports DSN
Peter>                                 |___ N normalized value

Peter> Pending Defects log (GP Log 0x0c) not supported

Peter> SATA Phy Event Counters (GP Log 0x11)
Peter> ID      Size     Value  Description
Peter> 0x0001  2            0  Command failed due to ICRC error
Peter> 0x0002  2            0  R_ERR response for data FIS
Peter> 0x0003  2            0  R_ERR response for device-to-host data FIS
Peter> 0x0004  2            0  R_ERR response for host-to-device data FIS
Peter> 0x0005  2            0  R_ERR response for non-data FIS
Peter> 0x0006  2            0  R_ERR response for device-to-host non-data FIS
Peter> 0x0007  2            0  R_ERR response for host-to-device non-data FIS
Peter> 0x0009  2           29  Transition from drive PhyRdy to drive PhyNRdy
Peter> 0x000a  2            5  Device-to-host register FISes sent due to a COMRESET
Peter> 0x000b  2            0  CRC errors within host-to-device FIS
Peter> 0x000d  2            0  Non-CRC errors within host-to-device FIS


Peter> mdadm --examine devices -----
Peter> /dev/sda:
Peter>    MBR Magic : aa55
Peter> Partition[0] :   4294967295 sectors at            1 (type ee)
Peter> /dev/sdb:
Peter>    MBR Magic : aa55
Peter> Partition[0] :   4294967295 sectors at            1 (type ee)
Peter> /dev/sdc:
Peter>    MBR Magic : aa55
Peter> Partition[0] :   4294967295 sectors at            1 (type ee)
Peter> /dev/sdd:
Peter>    MBR Magic : aa55
Peter> Partition[0] :   4294967295 sectors at            1 (type ee)
Peter> /dev/sde:
Peter>    MBR Magic : aa55
Peter> Partition[0] :   4294967295 sectors at            1 (type ee)
Peter> /dev/sdf:
Peter>    MBR Magic : aa55
Peter> Partition[0] :   4294967295 sectors at            1 (type ee)

Peter> mdadm --detail /dev/md0 ------

Peter> lsdrv ------------------------
Peter> PCI [nvme] 01:00.0 Non-Volatile memory controller: Phison Electronics
Peter> Corporation E12 NVMe Controller (rev 01)
Peter> └nvme nvme0 PCIe SSD                                 {21112925606047}
Peter>  └nvme0n1 238.47g [259:0] Partitioned (dos)
Peter>   ├nvme0n1p1 485.00m [259:1] ext4 {f38776ac-1ce9-4fc8-ba50-94844b9f504e}
Peter>   │└Mounted as /dev/nvme0n1p1 @ /boot
Peter>   ├nvme0n1p2 1.00k [259:2] Partitioned (dos)
Peter>   ├nvme0n1p5 60.54g [259:3] ext4 {5ee1c3c0-3a05-466c-9f98-f5807c8d813b}
Peter>   │└Mounted as /dev/nvme0n1p5 @ /
Peter>   ├nvme0n1p6 93.13g [259:4] ext4 {9064169f-4fe3-4836-a906-28c1b445cdff}
Peter>   │└Mounted as /dev/nvme0n1p6 @ /var
Peter>   ├nvme0n1p7 37.00m [259:5] ext4 {25e161ad-94a0-4298-afaf-18e2433766ee}
Peter>   ├nvme0n1p8 82.89g [259:6] ext4 {ac874071-d759-4d33-b32f-83272f3eacd9}
Peter>   │└Mounted as /dev/nvme0n1p8 @ /home
Peter>   └nvme0n1p9 1.41g [259:7] swap {02cef84b-9a9d-4a0a-973c-fda1a78c533c}
Peter> PCI [pata_jmicron] 26:00.1 IDE interface: JMicron Technology Corp.
Peter> JMB368 IDE controller (rev 10)
Peter> └scsi 0:0:0:0 MAD DOG  LS-DVDRW TSH652M {MAD_DOG_LS-DVDRW_TSH652M}
Peter>  └sr0 1.00g [11:0] Empty/Unknown
Peter> PCI [ahci] 26:00.0 SATA controller: JMicron Technology Corp. JMB363
Peter> SATA/IDE Controller (rev 10)
Peter> └scsi 2:x:x:x [Empty]
Peter> PCI [ahci] 2b:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
Peter> FCH SATA Controller [AHCI mode] (rev 51)
Peter> ├scsi 6:0:0:0 ATA      TOSHIBA HDWD130  {477ALBNAS}
Peter> │└sda 2.73t [8:0] Partitioned (PMBR)
Peter> └scsi 7:0:0:0 ATA      TOSHIBA HDWD130  {Y7211KPAS}
Peter>  └sdc 2.73t [8:32] Partitioned (gpt)
Peter> PCI [ahci] 2c:00.0 SATA controller: Advanced Micro Devices, Inc. [AMD]
Peter> FCH SATA Controller [AHCI mode] (rev 51)
Peter> ├scsi 8:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC1T0668790}
Peter> │└sdb 2.73t [8:16] Partitioned (gpt)
Peter> ├scsi 9:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC4N0091255}
Peter> │└sdd 2.73t [8:48] Partitioned (gpt)
Peter> ├scsi 12:0:0:0 ATA      WDC WD30EZRX-00M {WD-WCAWZ2669166}
Peter> │└sde 2.73t [8:64] Partitioned (gpt)
Peter> └scsi 13:0:0:0 ATA      TOSHIBA HDWD130  {477ABEJAS}
Peter>  └sdf 2.73t [8:80] Partitioned (gpt)

Peter> cat /proc/mdstat -------------
Peter> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
Peter> [raid4] [raid10]
Peter> unused devices: <none>

Peter> cat /etc/mdadm/mdadm.conf ----
Peter> # mdadm.conf
Peter> #
Peter> # !NB! Run update-initramfs -u after updating this file.
Peter> # !NB! This will ensure that initramfs has an uptodate copy.
Peter> #
Peter> # Please refer to mdadm.conf(5) for information about this file.
Peter> #

Peter> # by default (built-in), scan all partitions (/proc/partitions) and all
Peter> # containers for MD superblocks. alternatively, specify devices to scan, using
Peter> # wildcards if desired.
Peter> #DEVICE partitions containers

Peter> # automatically tag new arrays as belonging to the local system
Peter> HOMEHOST <system>

Peter> # instruct the monitoring daemon where to send mail alerts
Peter> MAILADDR root

Peter> # definitions of existing MD arrays
Peter> ARRAY /dev/md/0  metadata=1.2 UUID=109fa7b0:cf08fdba:e36284a9:5786ffff
Peter> name=superior:0

Peter> # This configuration was auto-generated on Sun, 26 Dec 2021 13:31:14
Peter> -0500 by mkconf

Peter> cat /proc/partitions ---------
Peter> major minor  #blocks  name

Peter>  259        0  250059096 nvme0n1
Peter>  259        1     496640 nvme0n1p1
Peter>  259        2          1 nvme0n1p2
Peter>  259        3   63475712 nvme0n1p5
Peter>  259        4   97654784 nvme0n1p6
Peter>  259        5      37888 nvme0n1p7
Peter>  259        6   86913024 nvme0n1p8
Peter>  259        7    1474560 nvme0n1p9
Peter>    8       32 2930266584 sdc
Peter>    8       80 2930266584 sdf
Peter>    8       64 2930266584 sde
Peter>    8       48 2930266584 sdd
Peter>    8       16 2930266584 sdb
Peter>    8        0 2930266584 sda
Peter>   11        0    1048575 sr0

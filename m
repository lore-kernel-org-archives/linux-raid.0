From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: RAID Issues - RAID10 working but with errors
Date: Thu, 2 Apr 2020 13:28:30 +1100
Message-ID: <d934f662-9fde-370b-bb4b-b92bd1730c96@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all,

I've got a fairly old system which has been working reliably for a long 
time, and I've become somewhat lazy in maintaining it, but since it's 
still in production, and rather important, I figured it was time for a 
checkup while I'm basically confined.

I have run a raid check, and these are the logs from the system:

[11243683.671268] md: data-check of RAID array md1
[11243683.671305] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[11243683.671339] md: using maximum available idle IO bandwidth (but not 
more than 200000 KB/sec) for data-check.
[11243683.671417] md: using 128k window, over a total of 3867693056k.
[11244378.142926] ata8.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[11244378.142986] ata8.00: irq_stat 0x40000008
[11244378.143018] ata8.00: failed command: READ FPDMA QUEUED
[11244378.143057] ata8.00: cmd 60/00:b8:00:93:5c/0a:00:0a:00:00/40 tag 
23 ncq dma 1310720 in
                            res 41/40:00:12:97:5c/00:00:0a:00:00/40 
Emask 0x409 (media error) <F>
[11244378.143166] ata8.00: status: { DRDY ERR }
[11244378.143196] ata8.00: error: { UNC }
[11244378.150605] ata8.00: configured for UDMA/133
[11244378.150706] sd 7:0:0:0: [sdf] tag#23 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11244378.150783] sd 7:0:0:0: [sdf] tag#23 Sense Key : Medium Error 
[current]
[11244378.150821] sd 7:0:0:0: [sdf] tag#23 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11244378.150881] sd 7:0:0:0: [sdf] tag#23 CDB: Read(10) 28 00 0a 5c 93 
00 00 0a 00 00
[11244378.150936] blk_update_request: I/O error, dev sdf, sector 173840146
[11244378.150990] ata8: EH complete
[11245290.555454] ata8.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[11245290.555513] ata8.00: irq_stat 0x40000008
[11245290.555545] ata8.00: failed command: READ FPDMA QUEUED
[11245290.555584] ata8.00: cmd 60/00:88:80:35:e0/0a:00:14:00:00/40 tag 
17 ncq dma 1310720 in
                            res 41/40:00:b2:3b:e0/00:00:14:00:00/40 
Emask 0x409 (media error) <F>
[11245290.555693] ata8.00: status: { DRDY ERR }
[11245290.555723] ata8.00: error: { UNC }
[11245290.563543] ata8.00: configured for UDMA/133
[11245290.563643] sd 7:0:0:0: [sdf] tag#17 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11245290.563703] sd 7:0:0:0: [sdf] tag#17 Sense Key : Medium Error 
[current]
[11245290.563741] sd 7:0:0:0: [sdf] tag#17 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11245290.563802] sd 7:0:0:0: [sdf] tag#17 CDB: Read(10) 28 00 14 e0 35 
80 00 0a 00 00
[11245290.563857] blk_update_request: I/O error, dev sdf, sector 350239666
[11245290.563915] ata8: EH complete
[11245297.098980] ata6.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[11245297.099039] ata6.00: irq_stat 0x40000008
[11245297.099072] ata6.00: failed command: READ FPDMA QUEUED
[11245297.099110] ata6.00: cmd 60/00:70:00:fa:ee/02:00:14:00:00/40 tag 
14 ncq dma 262144 in
                            res 41/40:00:38:fa:ee/00:00:14:00:00/40 
Emask 0x409 (media error) <F>
[11245297.099219] ata6.00: status: { DRDY ERR }
[11245297.099249] ata6.00: error: { UNC }
[11245297.108981] ata6.00: configured for UDMA/133
[11245297.109064] sd 5:0:0:0: [sdd] tag#14 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11245297.109124] sd 5:0:0:0: [sdd] tag#14 Sense Key : Medium Error 
[current]
[11245297.109161] sd 5:0:0:0: [sdd] tag#14 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11245297.109222] sd 5:0:0:0: [sdd] tag#14 CDB: Read(10) 28 00 14 ee fa 
00 00 02 00 00
[11245297.109276] blk_update_request: I/O error, dev sdd, sector 351205944
[11245297.109333] ata6: EH complete

The rest of the log is included below, but it repeats with errors for 
both sdd and sdf, but all other drives are not mentioned.

Is there a method to determine if this is a HDD error (ie, 2 drives that 
have errors) or a cabling issue (with just these two drives) or some 
strange driver/motherboard issue?

I notice in the output below MD is showing a number of bad blocks on the 
drives, and logs suggest that the drives have run out of "spare" space 
to re-allocate these to.

Is there some test I could run on the drive itself to narrow down the 
issue?

Should I replace one of these drives with the spare?

Is there some method to check the status of the spare to ensure it is 
working properly?

Any other suggestions?


##################################################################

Kernel: 4.9.0-8-amd64 #1 SMP Debian 4.9.110-3+deb9u6 (2018-10-08) x86_64 
GNU/Linux
All RAID drives are attached to this controller (lspci output):
00:1f.2 SATA controller: Intel Corporation 6 Series/C200 Series Chipset 
Family SATA AHCI Controller (rev 05) (prog-if 01 [AHCI 1.0])
         Subsystem: Intel Corporation Server Board S1200BTS
         Flags: bus master, 66MHz, medium devsel, latency 0, IRQ 31
         I/O ports at 5090 [size=8]
         I/O ports at 5080 [size=4]
         I/O ports at 5070 [size=8]
         I/O ports at 5060 [size=4]
         I/O ports at 5020 [size=32]
         Memory at c1c40000 (32-bit, non-prefetchable) [size=2K]
         Capabilities: [80] MSI: Enable+ Count=1/1 Maskable- 64bit-
         Capabilities: [70] Power Management version 3
         Capabilities: [a8] SATA HBA v1.0
         Capabilities: [b0] PCI Advanced Features
         Kernel driver in use: ahci
         Kernel modules: ahci

##################################################################

cat /proc/mdstat
Personalities : [raid1] [raid10] [linear] [multipath] [raid0] [raid6] 
[raid5] [raid4]
md1 : active raid10 sdd2[2] sde2[3](S) sdb2[0] sdf2[4] sdc2[1]
       3867693056 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
       bitmap: 7/29 pages [28KB], 65536KB chunk

##################################################################

mdadm --misc --examine /dev/sdd2
/dev/sdd2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x9
      Array UUID : da434497:622f4dc4:5d3861c0:4cf322fd
            Name : san2.websitemanagers.com.au:1
   Creation Time : Tue Mar  1 01:04:23 2016
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 3867693232 (1844.26 GiB 1980.26 GB)
      Array Size : 3867693056 (3688.52 GiB 3960.52 GB)
   Used Dev Size : 3867693056 (1844.26 GiB 1980.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=176 sectors
           State : active
     Device UUID : 56c20ce1:c61ec674:e69e2a29:3ced20c7

Internal Bitmap : 8 sectors from superblock
     Update Time : Thu Apr  2 12:58:32 2020
   Bad Block Log : 512 entries available at offset 72 sectors - bad 
blocks present.
        Checksum : 1ad84fb - correct
          Events : 443256

          Layout : near=2
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

##################################################################

mdadm --detail /dev/md1
/dev/md1:
         Version : 1.2
   Creation Time : Tue Mar  1 01:04:23 2016
      Raid Level : raid10
      Array Size : 3867693056 (3688.52 GiB 3960.52 GB)
   Used Dev Size : 1933846528 (1844.26 GiB 1980.26 GB)
    Raid Devices : 4
   Total Devices : 5
     Persistence : Superblock is persistent

   Intent Bitmap : Internal

     Update Time : Thu Apr  2 12:55:22 2020
           State : active
  Active Devices : 4
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 1

          Layout : near=2
      Chunk Size : 512K

            Name : san2.websitemanagers.com.au:1
            UUID : da434497:622f4dc4:5d3861c0:4cf322fd
          Events : 443256

     Number   Major   Minor   RaidDevice State
        0       8       18        0      active sync set-A /dev/sdb2
        1       8       34        1      active sync set-B /dev/sdc2
        2       8       50        2      active sync set-A /dev/sdd2
        4       8       82        3      active sync set-B /dev/sdf2

        3       8       66        -      spare   /dev/sde2


##################################################################


smartctl -x /dev/sdd
smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.9.0-8-amd64] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital RE4
Device Model:     WDC WD2003FYYS-02W0B0
Serial Number:    WD-WMAY00922575
LU WWN Device Id: 5 0014ee 0ad395cea
Firmware Version: 01.01D01
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Thu Apr  2 12:56:11 2020 AEDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Disabled
APM level is:     254 (maximum performance)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)    Offline data collection activity
                     was suspended by an interrupting command from host.
                     Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test 
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:         (30180) seconds.
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
recommended polling time:      ( 307) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x303f)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    23
   3 Spin_Up_Time            POS--K   253   253   021    -    8583
   4 Start_Stop_Count        -O--CK   100   100   000    -    77
   5 Reallocated_Sector_Ct   PO--CK   184   184   140    -    126
   7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
   9 Power_On_Hours          -O--CK   017   017   000    -    61089
  10 Spin_Retry_Count        -O--CK   100   253   000    -    0
  11 Calibration_Retry_Count -O--CK   100   253   000    -    0
  12 Power_Cycle_Count       -O--CK   100   100   000    -    67
192 Power-Off_Retract_Count -O--CK   200   200   000    -    48
193 Load_Cycle_Count        -O--CK   200   200   000    -    28
194 Temperature_Celsius     -O---K   118   105   000    -    34
196 Reallocated_Event_Count -O--CK   095   095   000    -    105
197 Current_Pending_Sector  -O--CK   200   200   000    -    21
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    2
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
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb5  GPL,SL  VS       1  Device vendor specific log
0xb6       GPL     VS       1  Device vendor specific log
0xb7       GPL,SL  VS       1  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      24  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Device Error Count: 765 (device log contains only the most recent 24 errors)
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

Error 765 [20] occurred at disk power-on lifetime: 61077 hours (2544 
days + 21 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 36 8e d1 98 40 00  Error: UNC at LBA = 
0x368ed198 = 915329432

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 00 80 00 78 00 00 36 8f 43 80 40 08 30d+15:33:32.976  READ FPDMA 
QUEUED
   60 00 80 00 70 00 00 36 8f 43 00 40 08 30d+15:33:32.976  READ FPDMA 
QUEUED
   60 00 80 00 68 00 00 36 8f 42 80 40 08 30d+15:33:32.976  READ FPDMA 
QUEUED
   60 00 80 00 60 00 00 36 8f 42 00 40 08 30d+15:33:32.976  READ FPDMA 
QUEUED
   60 00 80 00 58 00 00 36 8f 41 80 40 08 30d+15:33:32.976  READ FPDMA 
QUEUED

Error 764 [19] occurred at disk power-on lifetime: 61077 hours (2544 
days + 21 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 26 cd e5 56 40 00  Error: UNC at LBA = 
0x26cde556 = 651027798

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 b0 00 00 26 ce 35 00 40 08 30d+15:08:38.213  READ FPDMA 
QUEUED
   60 0a 00 00 a8 00 00 26 ce 2b 00 40 08 30d+15:08:38.203  READ FPDMA 
QUEUED
   60 0a 00 00 a0 00 00 26 ce 21 00 40 08 30d+15:08:38.194  READ FPDMA 
QUEUED
   60 0a 00 00 98 00 00 26 ce 17 00 40 08 30d+15:08:38.185  READ FPDMA 
QUEUED
   60 09 00 00 90 00 00 26 ce 0e 00 40 08 30d+15:08:38.176  READ FPDMA 
QUEUED

Error 763 [18] occurred at disk power-on lifetime: 61077 hours (2544 
days + 21 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 09 f0 00 00 23 5a 13 92 40 00  Error: UNC at LBA = 
0x235a1392 = 593105810

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 a0 00 00 23 5a 92 00 40 08 30d+15:03:34.673  READ FPDMA 
QUEUED
   60 00 80 00 98 00 00 23 5a 91 80 40 08 30d+15:03:34.673  READ FPDMA 
QUEUED
   60 00 80 00 90 00 00 23 5a 91 00 40 08 30d+15:03:34.095  READ FPDMA 
QUEUED
   60 00 80 00 88 00 00 23 5a 90 80 40 08 30d+15:03:34.095  READ FPDMA 
QUEUED
   60 00 80 00 80 00 00 23 5a 90 00 40 08 30d+15:03:34.095  READ FPDMA 
QUEUED

Error 762 [17] occurred at disk power-on lifetime: 61076 hours (2544 
days + 20 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 06 00 00 00 1b 67 f3 60 40 00  Error: UNC at LBA = 
0x1b67f360 = 459797344

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 09 00 00 18 00 00 1b 68 77 00 40 08 30d+14:51:09.346  READ FPDMA 
QUEUED
   60 0a 00 00 10 00 00 1b 68 6d 00 40 08 30d+14:51:09.346  READ FPDMA 
QUEUED
   60 08 80 00 08 00 00 1b 68 64 80 40 08 30d+14:51:09.335  READ FPDMA 
QUEUED
   60 05 80 00 00 00 00 1b 68 5f 00 40 08 30d+14:51:09.327  READ FPDMA 
QUEUED
   60 09 00 00 f0 00 00 1b 68 56 00 40 08 30d+14:51:09.326  READ FPDMA 
QUEUED

Error 761 [16] occurred at disk power-on lifetime: 61076 hours (2544 
days + 20 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 02 00 00 00 14 ee fa 38 40 00  Error: UNC at LBA = 
0x14eefa38 = 351205944

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 60 00 00 14 ef 38 80 40 08 30d+14:41:21.903  READ FPDMA 
QUEUED
   60 0a 00 00 58 00 00 14 ef 2e 80 40 08 30d+14:41:21.903  READ FPDMA 
QUEUED
   60 08 00 00 50 00 00 14 ef 26 80 40 08 30d+14:41:21.901  READ FPDMA 
QUEUED
   60 0a 00 00 48 00 00 14 ef 1c 80 40 08 30d+14:41:21.892  READ FPDMA 
QUEUED
   60 00 80 00 40 00 00 14 ef 1c 00 40 08 30d+14:41:21.886  READ FPDMA 
QUEUED

Error 760 [15] occurred at disk power-on lifetime: 60311 hours (2512 
days + 23 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 2b e2 10 8a 40 00  Error: UNC at LBA = 
0x2be2108a = 736235658

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 b0 00 00 2b e2 0a 00 40 08 48d+10:17:23.966  READ FPDMA 
QUEUED
   60 0a 00 00 a8 00 00 2b e2 00 00 40 08 48d+10:17:23.957  READ FPDMA 
QUEUED
   60 0a 00 00 a0 00 00 2b e1 f6 00 40 08 48d+10:17:23.947  READ FPDMA 
QUEUED
   60 0a 00 00 98 00 00 2b e1 ec 00 40 08 48d+10:17:23.938  READ FPDMA 
QUEUED
   60 0a 00 00 90 00 00 2b e1 e2 00 40 08 48d+10:17:23.928  READ FPDMA 
QUEUED

Error 759 [14] occurred at disk power-on lifetime: 60311 hours (2512 
days + 23 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 00 18 00 00 23 5a 13 59 40 00  Error: UNC at LBA = 
0x235a1359 = 593105753

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 00 18 00 20 00 00 23 5a 13 50 40 08 48d+10:05:03.788  READ FPDMA 
QUEUED
   60 00 08 00 18 00 00 23 5a 13 38 40 08 48d+10:05:02.381  READ FPDMA 
QUEUED
   60 03 00 00 10 00 00 23 5a 10 00 40 08 48d+10:05:01.879  READ FPDMA 
QUEUED
   60 0a 00 00 08 00 00 23 5a 06 00 40 08 48d+10:05:01.869  READ FPDMA 
QUEUED
   60 0a 00 00 00 00 00 23 59 fc 00 40 08 48d+10:05:01.860  READ FPDMA 
QUEUED

Error 758 [13] occurred at disk power-on lifetime: 60311 hours (2512 
days + 23 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 22 26 06 1a 40 00  Error: UNC at LBA = 
0x2226061a = 572917274

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 78 00 00 22 25 ff 80 40 08 48d+10:03:15.973  READ FPDMA 
QUEUED
   60 0a 00 00 70 00 00 22 25 f5 80 40 08 48d+10:03:15.964  READ FPDMA 
QUEUED
   60 0a 00 00 68 00 00 22 25 eb 80 40 08 48d+10:03:15.955  READ FPDMA 
QUEUED
   60 0a 00 00 60 00 00 22 25 e1 80 40 08 48d+10:03:15.946  READ FPDMA 
QUEUED
   60 0a 00 00 58 00 00 22 25 d7 80 40 08 48d+10:03:15.928  READ FPDMA 
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
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    34 Celsius
Power Cycle Min/Max Temperature:     31/42 Celsius
Lifetime    Min/Max Temperature:     31/47 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (265)

Index    Estimated Time   Temperature Celsius
  266    2020-04-02 04:59    34  ***************
  ...    ..(280 skipped).    ..  ***************
   69    2020-04-02 09:40    34  ***************
   70    2020-04-02 09:41    35  ****************
  ...    ..(129 skipped).    ..  ****************
  200    2020-04-02 11:51    35  ****************
  201    2020-04-02 11:52    34  ***************
  ...    ..( 63 skipped).    ..  ***************
  265    2020-04-02 12:56    34  ***************

SCT Error Recovery Control:
            Read:     70 (7.0 seconds)
           Write:     70 (7.0 seconds)

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x000a  2            2  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x8000  4     11280431  Vendor specific

##################################################################

smartctl -x /dev/sdf
smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.9.0-8-amd64] (local build)
Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

=== START OF INFORMATION SECTION ===
Model Family:     Western Digital RE4
Device Model:     WDC WD2003FYYS-02W0B0
Serial Number:    WD-WMAY00611922
LU WWN Device Id: 5 0014ee 0ad2d9d92
Firmware Version: 01.01D01
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Thu Apr  2 12:57:00 2020 AEDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Disabled
APM level is:     254 (maximum performance)
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]
Wt Cache Reorder: Enabled

=== START OF READ SMART DATA SECTION ===
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)    Offline data collection activity
                     was suspended by an interrupting command from host.
                     Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test 
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:         (28500) seconds.
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
recommended polling time:      ( 290) minutes.
Conveyance self-test routine
recommended polling time:      (   5) minutes.
SCT capabilities:            (0x303f)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
   1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    0
   3 Spin_Up_Time            POS--K   253   253   021    -    7350
   4 Start_Stop_Count        -O--CK   100   100   000    -    73
   5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
   7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
   9 Power_On_Hours          -O--CK   051   051   000    -    36231
  10 Spin_Retry_Count        -O--CK   100   253   000    -    0
  11 Calibration_Retry_Count -O--CK   100   253   000    -    0
  12 Power_Cycle_Count       -O--CK   100   100   000    -    64
192 Power-Off_Retract_Count -O--CK   200   200   000    -    46
193 Load_Cycle_Count        -O--CK   200   200   000    -    26
194 Temperature_Celsius     -O---K   118   094   000    -    34
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    0
198 Offline_Uncorrectable   ----CK   200   200   000    -    0
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    2
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
0x10       GPL     R/O      1  SATA NCQ Queued Error log
0x11       GPL     R/O      1  SATA Phy Event Counters log
0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
0xa0-0xa7  GPL,SL  VS      16  Device vendor specific log
0xa8-0xb5  GPL,SL  VS       1  Device vendor specific log
0xb6       GPL     VS       1  Device vendor specific log
0xb7       GPL,SL  VS       1  Device vendor specific log
0xbd       GPL,SL  VS       1  Device vendor specific log
0xc0       GPL,SL  VS       1  Device vendor specific log
0xc1       GPL     VS      24  Device vendor specific log
0xe0       GPL,SL  R/W      1  SCT Command/Status
0xe1       GPL,SL  R/W      1  SCT Data Transfer

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Device Error Count: 79 (device log contains only the most recent 24 errors)
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

Error 79 [6] occurred at disk power-on lifetime: 36219 hours (1509 days 
+ 3 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 2b cc 8c e9 40 00  Error: UNC at LBA = 
0x2bcc8ce9 = 734825705

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 58 00 00 2b cc 86 00 40 08 30d+15:17:33.518  READ FPDMA 
QUEUED
   60 0a 00 00 50 00 00 2b cc 7c 00 40 08 30d+15:17:33.518  READ FPDMA 
QUEUED
   60 0a 00 00 48 00 00 2b cc 72 00 40 08 30d+15:17:33.518  READ FPDMA 
QUEUED
   60 0a 00 00 40 00 00 2b cc 68 00 40 08 30d+15:17:33.518  READ FPDMA 
QUEUED
   60 0a 00 00 38 00 00 2b cc 5e 00 40 08 30d+15:17:33.518  READ FPDMA 
QUEUED

Error 78 [5] occurred at disk power-on lifetime: 36219 hours (1509 days 
+ 3 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 2a 25 4e 10 40 00  Error: UNC at LBA = 
0x2a254e10 = 707087888

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 09 80 00 c8 00 00 2a 25 9a 00 40 08 30d+15:15:04.767  READ FPDMA 
QUEUED
   60 06 00 00 c0 00 00 2a 25 94 00 40 08 30d+15:15:04.750  READ FPDMA 
QUEUED
   60 0a 00 00 b8 00 00 2a 25 8a 00 40 08 30d+15:15:04.741  READ FPDMA 
QUEUED
   60 0a 00 00 b0 00 00 2a 25 80 00 40 08 30d+15:15:04.732  READ FPDMA 
QUEUED
   60 0a 00 00 a8 00 00 2a 25 76 00 40 08 30d+15:15:04.732  READ FPDMA 
QUEUED

Error 77 [4] occurred at disk power-on lifetime: 36219 hours (1509 days 
+ 3 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 1e 5a 3e 86 40 00  Error: UNC at LBA = 
0x1e5a3e86 = 509230726

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 00 80 00 40 00 00 1e 5a b5 00 40 08 30d+14:57:14.678  READ FPDMA 
QUEUED
   60 00 80 00 38 00 00 1e 5a b4 80 40 08 30d+14:57:14.678  READ FPDMA 
QUEUED
   60 00 80 00 30 00 00 1e 5a b4 00 40 08 30d+14:57:14.678  READ FPDMA 
QUEUED
   60 00 80 00 28 00 00 1e 5a b3 80 40 08 30d+14:57:14.677  READ FPDMA 
QUEUED
   60 00 80 00 20 00 00 1e 5a b3 00 40 08 30d+14:57:14.677  READ FPDMA 
QUEUED

Error 76 [3] occurred at disk power-on lifetime: 36219 hours (1509 days 
+ 3 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   04 -- 51 00 00 00 00 ae ee 79 1f ae 00

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   ea 00 00 00 00 00 00 00 00 00 00 e0 08 30d+14:56:32.314  FLUSH CACHE EXT
   61 0a 00 00 d8 00 00 1e 0c 77 80 40 08 30d+14:56:32.308  WRITE FPDMA 
QUEUED
   61 00 08 00 d0 00 00 02 54 38 10 40 08 30d+14:56:32.308  WRITE FPDMA 
QUEUED
   ea 00 00 00 00 00 00 00 00 00 00 e0 08 30d+14:56:32.261  FLUSH CACHE EXT
   60 0a 00 00 08 00 00 1e 0c 81 80 40 08 30d+14:56:32.181  READ FPDMA 
QUEUED

Error 75 [2] occurred at disk power-on lifetime: 36219 hours (1509 days 
+ 3 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 1e 0c 77 d3 40 00  Error: UNC at LBA = 
0x1e0c77d3 = 504133587

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 08 80 00 c8 00 00 1e 0c 9f 80 40 08 30d+14:56:28.883  READ FPDMA 
QUEUED
   60 0a 00 00 c0 00 00 1e 0c 95 80 40 08 30d+14:56:28.883  READ FPDMA 
QUEUED
   60 0a 00 00 b8 00 00 1e 0c 8b 80 40 08 30d+14:56:28.883  READ FPDMA 
QUEUED
   60 0a 00 00 b0 00 00 1e 0c 81 80 40 08 30d+14:56:28.883  READ FPDMA 
QUEUED
   60 0a 00 00 a8 00 00 1e 0c 77 80 40 08 30d+14:56:28.883  READ FPDMA 
QUEUED

Error 74 [1] occurred at disk power-on lifetime: 36219 hours (1509 days 
+ 3 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 1d e4 17 e7 40 00  Error: UNC at LBA = 
0x1de417e7 = 501487591

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 02 00 00 a8 00 00 1d e4 52 00 40 08 30d+14:56:10.974  READ FPDMA 
QUEUED
   60 0a 00 00 a0 00 00 1d e4 48 00 40 08 30d+14:56:10.974  READ FPDMA 
QUEUED
   60 0a 00 00 98 00 00 1d e4 3e 00 40 08 30d+14:56:10.974  READ FPDMA 
QUEUED
   60 0a 00 00 90 00 00 1d e4 34 00 40 08 30d+14:56:10.974  READ FPDMA 
QUEUED
   60 0a 00 00 88 00 00 1d e4 2a 00 40 08 30d+14:56:10.974  READ FPDMA 
QUEUED

Error 73 [0] occurred at disk power-on lifetime: 36219 hours (1509 days 
+ 3 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 1d c0 73 99 40 00  Error: UNC at LBA = 
0x1dc07399 = 499151769

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 0a 00 00 78 00 00 1d c0 c2 80 40 08 30d+14:55:55.699  READ FPDMA 
QUEUED
   60 0a 00 00 70 00 00 1d c0 b8 80 40 08 30d+14:55:55.693  READ FPDMA 
QUEUED
   60 00 80 00 68 00 00 1d c0 b8 00 40 08 30d+14:55:55.684  READ FPDMA 
QUEUED
   60 02 00 00 60 00 00 1d c0 b6 00 40 08 30d+14:55:55.627  READ FPDMA 
QUEUED
   60 00 80 00 58 00 00 1d c0 b5 80 40 08 30d+14:55:55.627  READ FPDMA 
QUEUED

Error 72 [23] occurred at disk power-on lifetime: 36219 hours (1509 days 
+ 3 hours)
   When the command that caused the error occurred, the device was 
active or idle.

   After command completion occurred, registers were:
   ER -- ST COUNT  LBA_48  LH LM LL DV DC
   -- -- -- == -- == == == -- -- -- -- --
   40 -- 51 0a 00 00 00 1d 23 fc 01 40 00  Error: UNC at LBA = 
0x1d23fc01 = 488897537

   Commands leading to the command that caused the error were:
   CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time 
Command/Feature_Name
   -- == -- == -- == == == -- -- -- -- --  --------------- 
--------------------
   60 06 80 00 b0 00 00 1d 24 12 00 40 08 30d+14:54:51.370  READ FPDMA 
QUEUED
   60 0a 00 00 a8 00 00 1d 24 08 00 40 08 30d+14:54:51.370  READ FPDMA 
QUEUED
   60 0a 00 00 a0 00 00 1d 23 fe 00 40 08 30d+14:54:51.370  READ FPDMA 
QUEUED
   60 0a 00 00 98 00 00 1d 23 f4 00 40 08 30d+14:54:51.369  READ FPDMA 
QUEUED
   60 0a 00 00 90 00 00 1d 23 ea 00 40 08 30d+14:54:51.369  READ FPDMA 
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
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    34 Celsius
Power Cycle Min/Max Temperature:     32/43 Celsius
Lifetime    Min/Max Temperature:     32/58 Celsius
Under/Over Temperature Limit Count:   0/0

SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (407)

Index    Estimated Time   Temperature Celsius
  408    2020-04-02 05:00    35  ****************
  ...    ..( 59 skipped).    ..  ****************
  468    2020-04-02 06:00    35  ****************
  469    2020-04-02 06:01    34  ***************
  ...    ..(219 skipped).    ..  ***************
  211    2020-04-02 09:41    34  ***************
  212    2020-04-02 09:42    35  ****************
  ...    ..(194 skipped).    ..  ****************
  407    2020-04-02 12:57    35  ****************

SCT Error Recovery Control:
            Read:     70 (7.0 seconds)
           Write:     70 (7.0 seconds)

Device Statistics (GP/SMART Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x000a  2            2  Device-to-host register FISes sent due to a COMRESET
0x000b  2            0  CRC errors within host-to-device FIS
0x8000  4     11280539  Vendor specific

##################################################################

System logs:

[11245659.844193] ata8.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[11245659.844253] ata8.00: irq_stat 0x40000008
[11245659.844286] ata8.00: failed command: READ FPDMA QUEUED
[11245659.844325] ata8.00: cmd 60/00:f0:80:33:15/0a:00:19:00:00/40 tag 
30 ncq dma 1310720 in
                            res 41/40:00:a7:3b:15/00:00:19:00:00/40 
Emask 0x409 (media error) <F>
[11245659.844434] ata8.00: status: { DRDY ERR }
[11245659.844464] ata8.00: error: { UNC }
[11245659.851322] ata8.00: configured for UDMA/133
[11245659.851424] sd 7:0:0:0: [sdf] tag#30 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11245659.851484] sd 7:0:0:0: [sdf] tag#30 Sense Key : Medium Error 
[current]
[11245659.851521] sd 7:0:0:0: [sdf] tag#30 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11245659.851581] sd 7:0:0:0: [sdf] tag#30 CDB: Read(10) 28 00 19 15 33 
80 00 0a 00 00
[11245659.851636] blk_update_request: I/O error, dev sdf, sector 420821927
[11245659.851684] ata8: EH complete
[11245662.543958] ata8.00: exception Emask 0x0 SAct 0xc0000 SErr 0x0 
action 0x0
[11245662.544000] ata8.00: irq_stat 0x40000008
[11245662.544032] ata8.00: failed command: READ FPDMA QUEUED
[11245662.544071] ata8.00: cmd 60/80:90:00:ee:15/08:00:19:00:00/40 tag 
18 ncq dma 1114112 in
                            res 41/40:00:5b:f3:15/00:00:19:00:00/40 
Emask 0x409 (media error) <F>
[11245662.544179] ata8.00: status: { DRDY ERR }
[11245662.544209] ata8.00: error: { UNC }
[11245662.551701] ata8.00: configured for UDMA/133
[11245662.551766] sd 7:0:0:0: [sdf] tag#18 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11245662.551826] sd 7:0:0:0: [sdf] tag#18 Sense Key : Medium Error 
[current]
[11245662.551864] sd 7:0:0:0: [sdf] tag#18 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11245662.551924] sd 7:0:0:0: [sdf] tag#18 CDB: Read(10) 28 00 19 15 ee 
00 00 08 80 00
[11245662.551979] blk_update_request: I/O error, dev sdf, sector 420868955
[11245662.552031] ata8: EH complete
[11245666.003705] ata8.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[11245666.003763] ata8.00: irq_stat 0x40000008
[11245666.003795] ata8.00: failed command: READ FPDMA QUEUED
[11245666.003834] ata8.00: cmd 60/00:d0:80:e2:16/0a:00:19:00:00/40 tag 
26 ncq dma 1310720 in
                            res 41/40:00:ae:e6:16/00:00:19:00:00/40 
Emask 0x409 (media error) <F>
[11245666.007915] ata8.00: status: { DRDY ERR }
[11245666.007947] ata8.00: error: { UNC }
[11245666.015145] ata8.00: configured for UDMA/133
[11245666.015245] sd 7:0:0:0: [sdf] tag#26 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11245666.015305] sd 7:0:0:0: [sdf] tag#26 Sense Key : Medium Error 
[current]
[11245666.015343] sd 7:0:0:0: [sdf] tag#26 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11245666.015415] sd 7:0:0:0: [sdf] tag#26 CDB: Read(10) 28 00 19 16 e2 
80 00 0a 00 00
[11245666.015471] blk_update_request: I/O error, dev sdf, sector 420931246
[11245666.015523] ata8: EH complete
[11245667.895545] ata8.00: exception Emask 0x0 SAct 0x39fc0000 SErr 0x0 
action 0x0
[11245667.895602] ata8.00: irq_stat 0x40000008
[11245667.895635] ata8.00: failed command: READ FPDMA QUEUED
[11245667.895673] ata8.00: cmd 60/00:e8:80:f6:16/0a:00:19:00:00/40 tag 
29 ncq dma 1310720 in
                            res 41/40:00:b8:fa:16/00:00:19:00:00/40 
Emask 0x409 (media error) <F>
[11245667.895782] ata8.00: status: { DRDY ERR }
[11245667.895813] ata8.00: error: { UNC }
[11245667.903392] ata8.00: configured for UDMA/133
[11245667.903468] sd 7:0:0:0: [sdf] tag#29 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11245667.903527] sd 7:0:0:0: [sdf] tag#29 Sense Key : Medium Error 
[current]
[11245667.903565] sd 7:0:0:0: [sdf] tag#29 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11245667.903625] sd 7:0:0:0: [sdf] tag#29 CDB: Read(10) 28 00 19 16 f6 
80 00 0a 00 00
[11245667.903680] blk_update_request: I/O error, dev sdf, sector 420936376
[11245667.903729] ata8: EH complete
[11245670.779337] ata8.00: exception Emask 0x0 SAct 0x80000 SErr 0x0 
action 0x0
[11245670.779380] ata8.00: irq_stat 0x40000008
[11245670.779412] ata8.00: failed command: READ FPDMA QUEUED
[11245670.779451] ata8.00: cmd 60/00:98:00:96:17/06:00:19:00:00/40 tag 
19 ncq dma 786432 in
                            res 41/40:00:03:99:17/00:00:19:00:00/40 
Emask 0x409 (media error) <F>
[11245670.779560] ata8.00: status: { DRDY ERR }
[11245670.779590] ata8.00: error: { UNC }
[11245670.787087] ata8.00: configured for UDMA/133
[11245670.787148] sd 7:0:0:0: [sdf] tag#19 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11245670.787208] sd 7:0:0:0: [sdf] tag#19 Sense Key : Medium Error 
[current]
[11245670.787246] sd 7:0:0:0: [sdf] tag#19 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11245670.787306] sd 7:0:0:0: [sdf] tag#19 CDB: Read(10) 28 00 19 17 96 
00 00 06 00 00
[11245670.787361] blk_update_request: I/O error, dev sdf, sector 420976899
[11245670.787413] ata8: EH complete
[11245673.595136] ata8.00: exception Emask 0x0 SAct 0x3fff8000 SErr 0x0 
action 0x0
[11245673.595196] ata8.00: irq_stat 0x40000008
[11245673.595228] ata8.00: failed command: READ FPDMA QUEUED
[11245673.595267] ata8.00: cmd 60/00:78:80:ee:17/0a:00:19:00:00/40 tag 
15 ncq dma 1310720 in
                            res 41/40:00:c2:ef:17/00:00:19:00:00/40 
Emask 0x409 (media error) <F>
[11245673.595376] ata8.00: status: { DRDY ERR }
[11245673.595406] ata8.00: error: { UNC }
[11245673.603723] ata8.00: configured for UDMA/133
[11245673.603799] sd 7:0:0:0: [sdf] tag#15 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11245673.603859] sd 7:0:0:0: [sdf] tag#15 Sense Key : Medium Error 
[current]
[11245673.603897] sd 7:0:0:0: [sdf] tag#15 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11245673.603957] sd 7:0:0:0: [sdf] tag#15 CDB: Read(10) 28 00 19 17 ee 
80 00 0a 00 00
[11245673.604012] blk_update_request: I/O error, dev sdf, sector 420999106
[11245673.604077] ata8: EH complete
[11245675.542997] ata8.00: exception Emask 0x0 SAct 0x7e SErr 0x0 action 0x0
[11245675.543039] ata8.00: irq_stat 0x40000008
[11245675.543071] ata8.00: failed command: READ FPDMA QUEUED
[11245675.543109] ata8.00: cmd 60/80:30:00:48:18/09:00:19:00:00/40 tag 6 
ncq dma 1245184 in
                            res 41/40:00:f2:50:18/00:00:19:00:00/40 
Emask 0x409 (media error) <F>
[11245675.543217] ata8.00: status: { DRDY ERR }
[11245675.543248] ata8.00: error: { UNC }
[11245675.550967] ata8.00: configured for UDMA/133
[11245675.551042] sd 7:0:0:0: [sdf] tag#6 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[11245675.551102] sd 7:0:0:0: [sdf] tag#6 Sense Key : Medium Error 
[current]
[11245675.551140] sd 7:0:0:0: [sdf] tag#6 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11245675.551199] sd 7:0:0:0: [sdf] tag#6 CDB: Read(10) 28 00 19 18 48 
00 00 09 80 00
[11245675.551255] blk_update_request: I/O error, dev sdf, sector 421023986
[11245675.551303] ata8: EH complete
[11245885.111468] ata6.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[11245885.111528] ata6.00: irq_stat 0x40000008
[11245885.111560] ata6.00: failed command: READ FPDMA QUEUED
[11245885.111598] ata6.00: cmd 60/00:20:00:ee:67/06:00:1b:00:00/40 tag 4 
ncq dma 786432 in
                            res 41/40:00:60:f3:67/00:00:1b:00:00/40 
Emask 0x409 (media error) <F>
[11245885.111707] ata6.00: status: { DRDY ERR }
[11245885.111737] ata6.00: error: { UNC }
[11245885.121706] ata6.00: configured for UDMA/133
[11245885.121806] sd 5:0:0:0: [sdd] tag#4 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[11245885.121865] sd 5:0:0:0: [sdd] tag#4 Sense Key : Medium Error 
[current]
[11245885.121903] sd 5:0:0:0: [sdd] tag#4 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11245885.121961] sd 5:0:0:0: [sdd] tag#4 CDB: Read(10) 28 00 1b 67 ee 
00 00 06 00 00
[11245885.122016] blk_update_request: I/O error, dev sdd, sector 459797344
[11245885.122074] ata6: EH complete
[11245953.390426] ata8.00: exception Emask 0x0 SAct 0x7ffffc0f SErr 0x0 
action 0x0
[11245953.390486] ata8.00: irq_stat 0x40000008
[11245953.390518] ata8.00: failed command: READ FPDMA QUEUED
[11245953.390557] ata8.00: cmd 60/00:50:80:7f:19/09:00:1c:00:00/40 tag 
10 ncq dma 1179648 in
                            res 41/40:00:03:88:19/00:00:1c:00:00/40 
Emask 0x409 (media error) <F>
[11245953.390665] ata8.00: status: { DRDY ERR }
[11245953.390695] ata8.00: error: { UNC }
[11245953.397630] ata8.00: configured for UDMA/133
[11245953.397713] sd 7:0:0:0: [sdf] tag#10 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11245953.397780] sd 7:0:0:0: [sdf] tag#10 Sense Key : Medium Error 
[current]
[11245953.397817] sd 7:0:0:0: [sdf] tag#10 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11245953.397878] sd 7:0:0:0: [sdf] tag#10 CDB: Read(10) 28 00 1c 19 7f 
80 00 09 00 00
[11245953.397932] blk_update_request: I/O error, dev sdf, sector 471435267
[11245953.397987] ata8: EH complete
[11246048.451449] ata8.00: exception Emask 0x0 SAct 0x780000 SErr 0x0 
action 0x0
[11246048.451492] ata8.00: irq_stat 0x40000008
[11246048.451524] ata8.00: failed command: READ FPDMA QUEUED
[11246048.451563] ata8.00: cmd 60/00:98:00:f4:23/0a:00:1d:00:00/40 tag 
19 ncq dma 1310720 in
                            res 41/40:00:01:fc:23/00:00:1d:00:00/40 
Emask 0x409 (media error) <F>
[11246048.451670] ata8.00: status: { DRDY ERR }
[11246048.451700] ata8.00: error: { UNC }
[11246048.458682] ata8.00: configured for UDMA/133
[11246048.458749] sd 7:0:0:0: [sdf] tag#19 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11246048.458809] sd 7:0:0:0: [sdf] tag#19 Sense Key : Medium Error 
[current]
[11246048.458847] sd 7:0:0:0: [sdf] tag#19 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11246048.458908] sd 7:0:0:0: [sdf] tag#19 CDB: Read(10) 28 00 1d 23 f4 
00 00 0a 00 00
[11246048.458962] blk_update_request: I/O error, dev sdf, sector 488897537
[11246048.459015] ata8: EH complete
[11246112.786663] ata8.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[11246112.786724] ata8.00: irq_stat 0x40000008
[11246112.786756] ata8.00: failed command: READ FPDMA QUEUED
[11246112.786795] ata8.00: cmd 60/00:88:80:73:c0/0a:00:1d:00:00/40 tag 
17 ncq dma 1310720 in
                            res 41/40:00:99:73:c0/00:00:1d:00:00/40 
Emask 0x409 (media error) <F>
[11246112.786904] ata8.00: status: { DRDY ERR }
[11246112.786934] ata8.00: error: { UNC }
[11246112.793935] ata8.00: configured for UDMA/133
[11246112.794026] sd 7:0:0:0: [sdf] tag#17 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11246112.794086] sd 7:0:0:0: [sdf] tag#17 Sense Key : Medium Error 
[current]
[11246112.794124] sd 7:0:0:0: [sdf] tag#17 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11246112.794184] sd 7:0:0:0: [sdf] tag#17 CDB: Read(10) 28 00 1d c0 73 
80 00 0a 00 00
[11246112.794239] blk_update_request: I/O error, dev sdf, sector 499151769
[11246112.794302] ata8: EH complete
[11246128.145504] ata8.00: exception Emask 0x0 SAct 0x3f8000 SErr 0x0 
action 0x0
[11246128.145546] ata8.00: irq_stat 0x40000008
[11246128.145579] ata8.00: failed command: READ FPDMA QUEUED
[11246128.145617] ata8.00: cmd 60/00:78:00:16:e4/0a:00:1d:00:00/40 tag 
15 ncq dma 1310720 in
                            res 41/40:00:e7:17:e4/00:00:1d:00:00/40 
Emask 0x409 (media error) <F>
[11246128.145726] ata8.00: status: { DRDY ERR }
[11246128.145756] ata8.00: error: { UNC }
[11246128.157322] ata8.00: configured for UDMA/133
[11246128.157386] sd 7:0:0:0: [sdf] tag#15 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11246128.157445] sd 7:0:0:0: [sdf] tag#15 Sense Key : Medium Error 
[current]
[11246128.157483] sd 7:0:0:0: [sdf] tag#15 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11246128.157543] sd 7:0:0:0: [sdf] tag#15 CDB: Read(10) 28 00 1d e4 16 
00 00 0a 00 00
[11246128.157598] blk_update_request: I/O error, dev sdf, sector 501487591
[11246128.157655] ata8: EH complete
[11246147.488076] ata8.00: exception Emask 0x0 SAct 0x3e00000 SErr 0x0 
action 0x0
[11246147.488136] ata8.00: irq_stat 0x40000008
[11246147.488168] ata8.00: failed command: READ FPDMA QUEUED
[11246147.488207] ata8.00: cmd 60/00:a8:80:77:0c/0a:00:1e:00:00/40 tag 
21 ncq dma 1310720 in
                            res 41/40:00:d3:77:0c/00:00:1e:00:00/40 
Emask 0x409 (media error) <F>
[11246147.488316] ata8.00: status: { DRDY ERR }
[11246147.488346] ata8.00: error: { UNC }
[11246147.496292] ata8.00: configured for UDMA/133
[11246147.496358] sd 7:0:0:0: [sdf] tag#21 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11246147.496418] sd 7:0:0:0: [sdf] tag#21 Sense Key : Medium Error 
[current]
[11246147.496456] sd 7:0:0:0: [sdf] tag#21 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11246147.496517] sd 7:0:0:0: [sdf] tag#21 CDB: Read(10) 28 00 1e 0c 77 
80 00 0a 00 00
[11246147.496572] blk_update_request: I/O error, dev sdf, sector 504133587
[11246147.496635] ata8: EH complete
[11246154.639292] ata8.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[11246154.639333] ata8.00: irq_stat 0x40000001
[11246154.639365] ata8.00: failed command: FLUSH CACHE EXT
[11246154.639404] ata8.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 29
                            res 51/04:00:1f:79:ee/00:00:00:00:00/ae 
Emask 0x1 (device error)
[11246154.639491] ata8.00: status: { DRDY ERR }
[11246154.639521] ata8.00: error: { ABRT }
[11246154.647149] ata8.00: configured for UDMA/133
[11246154.647192] ata8: EH complete
[11246191.856803] ata8.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[11246191.856862] ata8.00: irq_stat 0x40000008
[11246191.856894] ata8.00: failed command: READ FPDMA QUEUED
[11246191.856932] ata8.00: cmd 60/00:48:00:3b:5a/0a:00:1e:00:00/40 tag 9 
ncq dma 1310720 in
                            res 41/40:00:86:3e:5a/00:00:1e:00:00/40 
Emask 0x409 (media error) <F>
[11246191.857042] ata8.00: status: { DRDY ERR }
[11246191.857072] ata8.00: error: { UNC }
[11246191.864899] ata8.00: configured for UDMA/133
[11246191.864990] sd 7:0:0:0: [sdf] tag#9 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_SENSE
[11246191.865050] sd 7:0:0:0: [sdf] tag#9 Sense Key : Medium Error 
[current]
[11246191.865088] sd 7:0:0:0: [sdf] tag#9 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11246191.865147] sd 7:0:0:0: [sdf] tag#9 CDB: Read(10) 28 00 1e 5a 3b 
00 00 0a 00 00
[11246191.865203] blk_update_request: I/O error, dev sdf, sector 509230726
[11246191.865265] ata8: EH complete
[11246632.028233] ata6.00: exception Emask 0x0 SAct 0x7f1fffff SErr 0x0 
action 0x0
[11246632.028293] ata6.00: irq_stat 0x40000008
[11246632.028326] ata6.00: failed command: READ FPDMA QUEUED
[11246632.028365] ata6.00: cmd 60/f0:c0:90:13:5a/09:00:23:00:00/40 tag 
24 ncq dma 1302528 in
                            res 41/40:00:92:13:5a/00:00:23:00:00/40 
Emask 0x409 (media error) <F>
[11246632.028474] ata6.00: status: { DRDY ERR }
[11246632.028504] ata6.00: error: { UNC }
[11246632.038079] ata6.00: configured for UDMA/133
[11246632.038171] sd 5:0:0:0: [sdd] tag#24 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11246632.038230] sd 5:0:0:0: [sdd] tag#24 Sense Key : Medium Error 
[current]
[11246632.038268] sd 5:0:0:0: [sdd] tag#24 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11246632.038328] sd 5:0:0:0: [sdd] tag#24 CDB: Read(10) 28 00 23 5a 13 
90 00 09 f0 00
[11246632.038383] blk_update_request: I/O error, dev sdd, sector 593105810
[11246632.038439] ata6: EH complete
[11246934.977824] ata6.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[11246934.977884] ata6.00: irq_stat 0x40000008
[11246934.977916] ata6.00: failed command: READ FPDMA QUEUED
[11246934.977955] ata6.00: cmd 60/00:c0:00:de:cd/0a:00:26:00:00/40 tag 
24 ncq dma 1310720 in
                            res 41/40:00:56:e5:cd/00:00:26:00:00/40 
Emask 0x409 (media error) <F>
[11246934.978064] ata6.00: status: { DRDY ERR }
[11246934.978094] ata6.00: error: { UNC }
[11246934.986281] ata6.00: configured for UDMA/133
[11246934.986390] sd 5:0:0:0: [sdd] tag#24 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11246934.986450] sd 5:0:0:0: [sdd] tag#24 Sense Key : Medium Error 
[current]
[11246934.986488] sd 5:0:0:0: [sdd] tag#24 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11246934.986549] sd 5:0:0:0: [sdd] tag#24 CDB: Read(10) 28 00 26 cd de 
00 00 0a 00 00
[11246934.986603] blk_update_request: I/O error, dev sdd, sector 651027798
[11246934.986656] ata6: EH complete
[11247262.925561] ata8.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[11247262.925621] ata8.00: irq_stat 0x40000008
[11247262.925653] ata8.00: failed command: READ FPDMA QUEUED
[11247262.925692] ata8.00: cmd 60/00:d8:80:46:25/0a:00:2a:00:00/40 tag 
27 ncq dma 1310720 in
                            res 41/40:00:10:4e:25/00:00:2a:00:00/40 
Emask 0x409 (media error) <F>
[11247262.925801] ata8.00: status: { DRDY ERR }
[11247262.925831] ata8.00: error: { UNC }
[11247262.934244] ata8.00: configured for UDMA/133
[11247262.934345] sd 7:0:0:0: [sdf] tag#27 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11247262.934405] sd 7:0:0:0: [sdf] tag#27 Sense Key : Medium Error 
[current]
[11247262.934443] sd 7:0:0:0: [sdf] tag#27 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11247262.934503] sd 7:0:0:0: [sdf] tag#27 CDB: Read(10) 28 00 2a 25 46 
80 00 0a 00 00
[11247262.934558] blk_update_request: I/O error, dev sdf, sector 707087888
[11247262.934608] ata8: EH complete
[11247412.132945] ata8.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[11247412.133004] ata8.00: irq_stat 0x40000008
[11247412.133036] ata8.00: failed command: READ FPDMA QUEUED
[11247412.133075] ata8.00: cmd 60/00:58:00:86:cc/0a:00:2b:00:00/40 tag 
11 ncq dma 1310720 in
                            res 41/40:00:e9:8c:cc/00:00:2b:00:00/40 
Emask 0x409 (media error) <F>
[11247412.133184] ata8.00: status: { DRDY ERR }
[11247412.133214] ata8.00: error: { UNC }
[11247412.140402] ata8.00: configured for UDMA/133
[11247412.140495] sd 7:0:0:0: [sdf] tag#11 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11247412.140556] sd 7:0:0:0: [sdf] tag#11 Sense Key : Medium Error 
[current]
[11247412.140594] sd 7:0:0:0: [sdf] tag#11 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11247412.140655] sd 7:0:0:0: [sdf] tag#11 CDB: Read(10) 28 00 2b cc 86 
00 00 0a 00 00
[11247412.140710] blk_update_request: I/O error, dev sdf, sector 734825705
[11247412.140768] ata8: EH complete
[11248431.854940] ata6.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 
action 0x0
[11248431.855000] ata6.00: irq_stat 0x40000008
[11248431.855032] ata6.00: failed command: READ FPDMA QUEUED
[11248431.855071] ata6.00: cmd 60/00:80:00:cb:8e/0a:00:36:00:00/40 tag 
16 ncq dma 1310720 in
                            res 41/40:00:98:d1:8e/00:00:36:00:00/40 
Emask 0x409 (media error) <F>
[11248431.855179] ata6.00: status: { DRDY ERR }
[11248431.855209] ata6.00: error: { UNC }
[11248431.864561] ata6.00: configured for UDMA/133
[11248431.864659] sd 5:0:0:0: [sdd] tag#16 FAILED Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE
[11248431.864719] sd 5:0:0:0: [sdd] tag#16 Sense Key : Medium Error 
[current]
[11248431.864757] sd 5:0:0:0: [sdd] tag#16 Add. Sense: Unrecovered read 
error - auto reallocate failed
[11248431.864817] sd 5:0:0:0: [sdd] tag#16 CDB: Read(10) 28 00 36 8e cb 
00 00 0a 00 00
[11248431.864872] blk_update_request: I/O error, dev sdd, sector 915329432
[11248431.864929] ata6: EH complete
[11269366.179625] md: md1: data-check done.
[11269366.356954] RAID10 conf printout:
[11269366.356957]  --- wd:4 rd:4
[11269366.356959]  disk 0, wo:0, o:1, dev:sdb2
[11269366.356960]  disk 1, wo:0, o:1, dev:sdc2
[11269366.356962]  disk 2, wo:0, o:1, dev:sdd2
[11269366.356963]  disk 3, wo:0, o:1, dev:sdf2

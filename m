From: David T-G <davidtg-robot@justpickone.org>
Subject: Re: failed disks, mapper, and "Invalid argument"
Date: Wed, 20 May 2020 19:53:47 -0400
Message-ID: <20200520235347.GF1415@justpickone.org>
References: <20200520200514.GE1415@justpickone.org>
 <5EC5BBEF.7070002@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5EC5BBEF.7070002@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Wols, et al --

...and then Wols Lists said...
% 
% On 20/05/20 21:05, David T-G wrote:
% > 
% > I have a four-partition RAID5 array of which one disk failed while I was
% > out of town and a second failed just today.  Both failed smartctl tests
...
% > 
% > I've been through the wiki and other found documentation and have scraped
...
% > long post if it's a bit ridiculous; I wanted to make sure that you have
% > all information :-)
% 
% https://raid.wiki.kernel.org/index.php/Asking_for_help

Yep.  Tried almost all of those things, too.  [I don't git much, although
I'd like to in my copious free time, so I didn't bother to suck down
lsdrv and run it.]


% 
% Hate to say it, but if you've found the wiki, there's an awful lot of
% info missing from this post ...

I'll take that.  I never said I knew what I was doing :-)  Aaaaand ...
after 8+ hours at this, now I see

  If they don't, post a description of your problem, accompanied by the
  output of all those commands, to the mailing list.

down at the very bottom.  Yup, I missed it :-)


% > 
% > Here's the array after I swapped ports and booted up:
% > 
% >   diskfarm:root:10:~> mdadm --detail /dev/md0
...
% > 
% >   diskfarm:root:10:~> mdadm --examine /dev/sd[abcd]1 | egrep '/dev|vents'
...
% > 
% > I'd say sdd is the former sde that went away first and sdc that was sdf
% > only just fell over.
% 
% Okay, you DON'T want to include sdd in your attempts - sdc is only 4
% events behind so if you can assemble those three, you'll be almost
% perfect ...

The easy answer didn't work :-(

  diskfarm:root:13:/mnt/scratch/disks> OVERLAYS='/dev/mapper/sda1 /dev/mapper/sdb1 /dev/mapper/sdc1'

  diskfarm:root:13:/mnt/scratch/disks> mdadm --assemble --force /dev/md0 --verbose $OVERLAYS
  mdadm: looking for devices for /dev/md0
  mdadm: /dev/mapper/sda1 is identified as a member of /dev/md0, slot 3.
  mdadm: /dev/mapper/sdb1 is identified as a member of /dev/md0, slot 0.
  mdadm: /dev/mapper/sdc1 is identified as a member of /dev/md0, slot 2.
  mdadm: no uptodate device for slot 1 of /dev/md0
  mdadm: failed to add /dev/mapper/sdc1 to /dev/md0: Invalid argument
  mdadm: failed to add /dev/mapper/sda1 to /dev/md0: Invalid argument
  mdadm: failed to add /dev/mapper/sdb1 to /dev/md0: Invalid argument
  mdadm: failed to RUN_ARRAY /dev/md0: Invalid argument

It looks

  diskfarm:root:13:/mnt/scratch/disks> mdadm --assemble --force /dev/md0 --verbose /dev/sda1 /dev/sdb1 /dev/sdc1
  mdadm: looking for devices for /dev/md0
  mdadm: /dev/sda1 is busy - skipping
  mdadm: /dev/sdb1 is busy - skipping
  mdadm: /dev/sdc1 is busy - skipping

like the overlay is keeping me from the raw devices, so I'd have to tear
down all of that to try the real thing.  I'll h old off on that...


% > 
...
% > I whipped up four loop devices and created overlay files
% > 
% >   diskfarm:root:13:/mnt/scratch/disks> parallel truncate -s8G overlay-{/} ::: $DEVICES
...
% > and tried md0
% > 
% >   diskfarm:root:13:/mnt/scratch/disks> mdadm --assemble --force /dev/md0 $OVERLAYS
...
% > and STILL got nowhere.  It was at this point that I figured I need to
% > back away and call for help!  I don't want to try rebuilding the actual
% > array in case it's out of sync and I lose data.
% > 
% > Soooooo...  There it is.  Any suggestions to correct whatever oops I've
% > made or complete a step I overlooked?  Any ideas why my assemble didn't?
% > 
% What I *always* jump on ...
% 
% https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
% 
% You don't have any of these drives you shouldn't?

These are too old to be SMR, but they are pretty basic:

  diskfarm:root:11:/mnt/scratch/disks> for D in sd{a,b,c,d} ; do echo '## parted' ; parted /dev/$D print | egrep "Model|$D" ; echo '## Version' ; smartctl -a /dev/$D | egrep 'Version|SCT' ; echo '## scterc' ; smartctl -l scterc /dev/$D | egrep SCT ; echo '' ; done
  ## parted
  Model: ATA ST4000DM000-1F21 (scsi)
  Disk /dev/sda: 4001GB
  ## Version
  Firmware Version: CC52
  ATA Version is:   ATA8-ACS T13/1699-D revision 4
  SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
  SCT capabilities:              (0x1085) SCT Status supported.
  SMART Error Log Version: 1
  ## scterc
  SCT Error Recovery Control command not supported

  ## parted
  Model: ATA ST4000DM000-1F21 (scsi)
  Disk /dev/sdb: 4001GB
  ## Version
  Firmware Version: CC54
  ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
  SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
  SCT capabilities:              (0x1085) SCT Status supported.
  SMART Error Log Version: 1
  ## scterc
  SCT Error Recovery Control command not supported

  ## parted
  Model: ATA ST4000DM000-1F21 (scsi)
  Disk /dev/sdc: 4001GB
  ## Version
  Firmware Version: CC54
  ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
  SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
  SCT capabilities:              (0x1085) SCT Status supported.
  SMART Error Log Version: 1
  ## scterc
  SCT Error Recovery Control command not supported

  ## parted
  Model: ATA ST4000DM000-1F21 (scsi)
  Disk /dev/sdd: 4001GB
  ## Version
  Firmware Version: CC54
  ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
  SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
  SCT capabilities:              (0x1085) SCT Status supported.
  SMART Error Log Version: 1
  ## scterc
  SCT Error Recovery Control command not supported

Curiously, note that querying just scterc as the wiki instructs says "not
supported", but a general smartctl query says yes.  I'm not sure how to
interpret this...


% 
% I'll let someone else play about with all the device mapper stuff, I'm
% only just getting in to it, but as I say, drop sdd and you should get
% your array back with pretty much no corruption. Adding sdd runs the risk
% of corrupting much more ...

I could believe that; thanks.  But we still aren't up on three.

Here is everything from the Asking page:

  diskfarm:root:11:/mnt/scratch/disks> for D in sd{a,b,c,d} ; do smartctl --xall /dev/$D >smartctl--xall.$D.out ; done

  smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.16.5-64] (local build)
  Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

  === START OF INFORMATION SECTION ===
  Model Family:     Seagate Desktop HDD.15
  Device Model:     ST4000DM000-1F2168
  Serial Number:    W300EYNA
  LU WWN Device Id: 5 000c50 069a8d76f
  Firmware Version: CC52
  User Capacity:    4,000,787,030,016 bytes [4.00 TB]
  Sector Sizes:     512 bytes logical, 4096 bytes physical
  Rotation Rate:    5900 rpm
  Form Factor:      3.5 inches
  Device is:        In smartctl database [for details use: -P show]
  ATA Version is:   ATA8-ACS T13/1699-D revision 4
  SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
  Local Time is:    Wed May 20 19:43:02 2020 EDT
  SMART support is: Available - device has SMART capability.
  SMART support is: Enabled
  AAM feature is:   Unavailable
  APM level is:     128 (minimum power consumption without standby)
  Rd look-ahead is: Enabled
  Write cache is:   Enabled
  ATA Security is:  Disabled, frozen [SEC2]
  Wt Cache Reorder: Unavailable

  === START OF READ SMART DATA SECTION ===
  SMART overall-health self-assessment test result: PASSED
  See vendor-specific Attribute list for marginal Attributes.

  General SMART Values:
  Offline data collection status:  (0x00)	Offline data collection activity
                                          was never started.
                                          Auto Offline Data Collection: Disabled.
  Self-test execution status:      (   0)	The previous self-test routine completed
                                          without error or no self-test has ever 
                                          been run.
  Total time to complete Offline 
  data collection: 		(  602) seconds.
  Offline data collection
  capabilities: 			 (0x73) SMART execute Offline immediate.
                                          Auto Offline data collection on/off support.
                                          Suspend Offline collection upon new
                                          command.
                                          No Offline surface scan supported.
                                          Self-test supported.
                                          Conveyance Self-test supported.
                                          Selective Self-test supported.
  SMART capabilities:            (0x0003)	Saves SMART data before entering
                                          power-saving mode.
                                          Supports SMART auto save timer.
  Error logging capability:        (0x01)	Error logging supported.
                                          General Purpose Logging supported.
  Short self-test routine 
  recommended polling time: 	 (   1) minutes.
  Extended self-test routine
  recommended polling time: 	 ( 535) minutes.
  Conveyance self-test routine
  recommended polling time: 	 (   2) minutes.
  SCT capabilities: 	       (0x1085)	SCT Status supported.

  SMART Attributes Data Structure revision number: 10
  Vendor Specific SMART Attributes with Thresholds:
  ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
    1 Raw_Read_Error_Rate     POSR--   117   072   006    -    166858032
    3 Spin_Up_Time            PO----   092   091   000    -    0
    4 Start_Stop_Count        -O--CK   100   100   020    -    230
    5 Reallocated_Sector_Ct   PO--CK   099   099   010    -    1496
    7 Seek_Error_Rate         POSR--   077   060   030    -    21729719097
    9 Power_On_Hours          -O--CK   036   036   000    -    56266
   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
   12 Power_Cycle_Count       -O--CK   100   100   020    -    232
  183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
  184 End-to-End_Error        -O--CK   096   096   099    NOW  4
  187 Reported_Uncorrect      -O--CK   001   001   000    -    8955
  188 Command_Timeout         -O--CK   100   064   000    -    10 50 50
  189 High_Fly_Writes         -O-RCK   100   100   000    -    0
  190 Airflow_Temperature_Cel -O---K   054   044   045    Past 46 (Min/Max 39/46 #2)
  191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
  192 Power-Off_Retract_Count -O--CK   100   100   000    -    167
  193 Load_Cycle_Count        -O--CK   024   024   000    -    152866
  194 Temperature_Celsius     -O---K   046   056   000    -    46 (0 17 0 0 0)
  197 Current_Pending_Sector  -O--C-   089   076   000    -    1944
  198 Offline_Uncorrectable   ----C-   089   076   000    -    1944
  199 UDMA_CRC_Error_Count    -OSRCK   200   001   000    -    2012
  240 Head_Flying_Hours       ------   100   253   000    -    30059h+12m+46.217s
  241 Total_LBAs_Written      ------   100   253   000    -    43386440059
  242 Total_LBAs_Read         ------   100   253   000    -    431627548432
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
  0x06           SL  R/O      1  SMART self-test log
  0x07       GPL     R/O      1  Extended self-test log
  0x09           SL  R/W      1  Selective self-test log
  0x10       GPL     R/O      1  SATA NCQ Queued Error log
  0x11       GPL     R/O      1  SATA Phy Event Counters log
  0x21       GPL     R/O      1  Write stream error log
  0x22       GPL     R/O      1  Read stream error log
  0x24       GPL     R/O   1223  Current Device Internal Status Data log
  0x25       GPL     R/O   1223  Saved Device Internal Status Data log
  0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
  0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
  0xa1       GPL,SL  VS      20  Device vendor specific log
  0xa2       GPL     VS    4496  Device vendor specific log
  0xa8       GPL,SL  VS     129  Device vendor specific log
  0xa9       GPL,SL  VS       1  Device vendor specific log
  0xab       GPL     VS       1  Device vendor specific log
  0xb0       GPL     VS    5176  Device vendor specific log
  0xbe-0xbf  GPL     VS   65535  Device vendor specific log
  0xc0       GPL,SL  VS       1  Device vendor specific log
  0xc1       GPL,SL  VS      10  Device vendor specific log
  0xc3       GPL,SL  VS       8  Device vendor specific log
  0xc4       GPL,SL  VS       5  Device vendor specific log
  0xe0       GPL,SL  R/W      1  SCT Command/Status
  0xe1       GPL,SL  R/W      1  SCT Data Transfer

  SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
  Device Error Count: 8958 (device log contains only the most recent 20 errors)
          CR     = Command Register
          FEATR  = Features Register
          COUNT  = Count (was: Sector Count) Register
          LBA_48 = Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
          LH     = LBA High (was: Cylinder High) Register    ]   LBA
          LM     = LBA Mid (was: Cylinder Low) Register      ] Register
          LL     = LBA Low (was: Sector Number) Register     ]
          DV     = Device (was: Device/Head) Register
          DC     = Device Control Register
          ER     = Error register
          ST     = Status register
  Powered_Up_Time is measured from power on, and printed as
  DDd+hh:mm:SS.sss where DD=days, hh=hours, mm=minutes,
  SS=sec, and sss=millisec. It "wraps" after 49.710 days.

  Error 8958 [17] occurred at disk power-on lifetime: 55189 hours (2299 days + 13 hours)
    When the command that caused the error occurred, the device was active or idle.

    After command completion occurred, registers were:
    ER -- ST COUNT  LBA_48  LH LM LL DV DC
    -- -- -- == -- == == == -- -- -- -- --
    40 -- 51 00 00 00 01 4d 52 79 60 00 00  Error: UNC at LBA = 0x14d527960 = 5592217952

    Commands leading to the command that caused the error were:
    CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
    -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
    60 00 00 02 c0 00 01 4d 54 95 78 40 00 29d+01:34:04.331  READ FPDMA QUEUED
    60 00 00 05 40 00 01 4d 54 90 38 40 00 29d+01:34:04.330  READ FPDMA QUEUED
    60 00 00 02 c0 00 01 4d 54 8d 78 40 00 29d+01:34:04.309  READ FPDMA QUEUED
    60 00 00 05 40 00 01 4d 54 88 38 40 00 29d+01:34:04.308  READ FPDMA QUEUED
    60 00 00 02 c0 00 01 4d 54 85 78 40 00 29d+01:34:04.288  READ FPDMA QUEUED

  Error 8957 [16] occurred at disk power-on lifetime: 55189 hours (2299 days + 13 hours)
    When the command that caused the error occurred, the device was active or idle.

    After command completion occurred, registers were:
    ER -- ST COUNT  LBA_48  LH LM LL DV DC
    -- -- -- == -- == == == -- -- -- -- --
    40 -- 51 00 00 00 01 4d 52 73 c0 00 00  Error: UNC at LBA = 0x14d5273c0 = 5592216512

    Commands leading to the command that caused the error were:
    CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
    -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
    60 00 00 00 08 00 01 4d 52 73 f0 40 00 29d+01:33:59.553  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 52 73 e8 40 00 29d+01:33:59.543  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 52 73 e0 40 00 29d+01:33:59.532  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 52 73 d8 40 00 29d+01:33:59.532  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 52 73 d0 40 00 29d+01:33:59.523  READ FPDMA QUEUED

  Error 8956 [15] occurred at disk power-on lifetime: 55189 hours (2299 days + 13 hours)
    When the command that caused the error occurred, the device was active or idle.

    After command completion occurred, registers were:
    ER -- ST COUNT  LBA_48  LH LM LL DV DC
    -- -- -- == -- == == == -- -- -- -- --
    40 -- 51 00 00 00 01 4d 52 1a 40 00 00  Error: UNC at LBA = 0x14d521a40 = 5592193600

    Commands leading to the command that caused the error were:
    CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
    -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
    60 00 00 00 08 00 01 4d 52 1b 30 40 00 29d+01:33:55.394  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 52 1b 28 40 00 29d+01:33:55.393  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 52 1b 20 40 00 29d+01:33:55.383  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 52 1b 18 40 00 29d+01:33:55.383  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 52 1b 10 40 00 29d+01:33:55.383  READ FPDMA QUEUED

  Error 8955 [14] occurred at disk power-on lifetime: 55189 hours (2299 days + 13 hours)
    When the command that caused the error occurred, the device was active or idle.

    After command completion occurred, registers were:
    ER -- ST COUNT  LBA_48  LH LM LL DV DC
    -- -- -- == -- == == == -- -- -- -- --
    40 -- 51 00 00 00 01 4d 52 79 60 00 00  Error: UNC at LBA = 0x14d527960 = 5592217952

    Commands leading to the command that caused the error were:
    CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
    -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
    60 00 00 05 40 00 01 4d 52 b3 d0 40 00 29d+01:33:46.322  READ FPDMA QUEUED
    60 00 00 05 40 00 01 4d 52 ae 90 40 00 29d+01:33:46.086  READ FPDMA QUEUED
    60 00 00 05 40 00 01 4d 52 a9 50 40 00 29d+01:33:45.890  READ FPDMA QUEUED
    60 00 00 05 40 00 01 4d 52 a4 10 40 00 29d+01:33:45.890  READ FPDMA QUEUED
    60 00 00 05 40 00 01 4d 52 9e d0 40 00 29d+01:33:45.506  READ FPDMA QUEUED

  Error 8954 [13] occurred at disk power-on lifetime: 55189 hours (2299 days + 13 hours)
    When the command that caused the error occurred, the device was active or idle.

    After command completion occurred, registers were:
    ER -- ST COUNT  LBA_48  LH LM LL DV DC
    -- -- -- == -- == == == -- -- -- -- --
    40 -- 51 00 00 00 01 4d 52 73 c0 00 00  Error: UNC at LBA = 0x14d5273c0 = 5592216512

    Commands leading to the command that caused the error were:
    CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
    -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
    60 00 00 05 40 00 01 4d 52 94 50 40 00 29d+01:33:41.717  READ FPDMA QUEUED
    60 00 00 05 40 00 01 4d 52 54 50 40 00 29d+01:33:41.717  READ FPDMA QUEUED
    60 00 00 02 c0 00 01 4d 52 59 90 40 00 29d+01:33:41.716  READ FPDMA QUEUED
    60 00 00 05 40 00 01 4d 52 5c 50 40 00 29d+01:33:41.716  READ FPDMA QUEUED
    60 00 00 02 c0 00 01 4d 52 61 90 40 00 29d+01:33:41.716  READ FPDMA QUEUED

  Error 8953 [12] occurred at disk power-on lifetime: 55189 hours (2299 days + 13 hours)
    When the command that caused the error occurred, the device was active or idle.

    After command completion occurred, registers were:
    ER -- ST COUNT  LBA_48  LH LM LL DV DC
    -- -- -- == -- == == == -- -- -- -- --
    40 -- 51 00 00 00 01 4d 52 1a 40 00 00  Error: UNC at LBA = 0x14d521a40 = 5592193600

    Commands leading to the command that caused the error were:
    CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
    -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
    60 00 00 02 c0 00 01 4d 52 49 90 40 00 29d+01:33:38.068  READ FPDMA QUEUED
    60 00 00 05 40 00 01 4d 52 44 50 40 00 29d+01:33:38.068  READ FPDMA QUEUED
    60 00 00 02 c0 00 01 4d 52 41 90 40 00 29d+01:33:38.068  READ FPDMA QUEUED
    60 00 00 05 40 00 01 4d 52 3c 50 40 00 29d+01:33:38.068  READ FPDMA QUEUED
    60 00 00 02 c0 00 01 4d 52 39 90 40 00 29d+01:33:38.068  READ FPDMA QUEUED

  Error 8952 [11] occurred at disk power-on lifetime: 55189 hours (2299 days + 13 hours)
    When the command that caused the error occurred, the device was active or idle.

    After command completion occurred, registers were:
    ER -- ST COUNT  LBA_48  LH LM LL DV DC
    -- -- -- == -- == == == -- -- -- -- --
    40 -- 51 00 00 00 01 4d 48 ac b0 00 00  Error: UNC at LBA = 0x14d48acb0 = 5591575728

    Commands leading to the command that caused the error were:
    CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
    -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
    60 00 00 00 08 00 01 4d 48 ad a0 40 00 29d+01:33:29.016  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 48 ad 98 40 00 29d+01:33:29.005  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 48 ad 90 40 00 29d+01:33:29.004  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 48 ad 88 40 00 29d+01:33:28.995  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 48 ad 80 40 00 29d+01:33:28.995  READ FPDMA QUEUED

  Error 8951 [10] occurred at disk power-on lifetime: 55189 hours (2299 days + 13 hours)
    When the command that caused the error occurred, the device was active or idle.

    After command completion occurred, registers were:
    ER -- ST COUNT  LBA_48  LH LM LL DV DC
    -- -- -- == -- == == == -- -- -- -- --
    40 -- 51 00 00 00 01 4d 48 a4 60 00 00  Error: UNC at LBA = 0x14d48a460 = 5591573600

    Commands leading to the command that caused the error were:
    CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_Name
    -- == -- == -- == == == -- -- -- -- --  ---------------  --------------------
    60 00 00 00 08 00 01 4d 48 a5 50 40 00 29d+01:33:24.927  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 48 a5 48 40 00 29d+01:33:24.916  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 48 a5 40 40 00 29d+01:33:24.907  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 48 a5 38 40 00 29d+01:33:24.907  READ FPDMA QUEUED
    60 00 00 00 08 00 01 4d 48 a5 30 40 00 29d+01:33:24.907  READ FPDMA QUEUED

  SMART Extended Self-test Log Version: 1 (1 sectors)
  Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
  # 1  Short offline       Completed: read failure       90%     54480         66032
  # 2  Short offline       Completed: read failure       90%     54456         66032
  # 3  Extended offline    Completed without error       00%     18918         -
  # 4  Short offline       Completed without error       00%     18909         -
  # 5  Extended captive    Completed without error       00%     17667         -
  # 6  Short captive       Completed without error       00%     17659         -

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
  Current Temperature:                    45 Celsius
  Power Cycle Min/Max Temperature:     39/45 Celsius
  Lifetime    Min/Max Temperature:     17/55 Celsius
  Under/Over Temperature Limit Count:   0/0

  SCT Data Table command not supported

  SCT Error Recovery Control command not supported

  Device Statistics (GP/SMART Log 0x04) not supported

  SATA Phy Event Counters (GP Log 0x11)
  ID      Size     Value  Description
  0x000a  2            4  Device-to-host register FISes sent due to a COMRESET
  0x0001  2            0  Command failed due to ICRC error
  0x0003  2            0  R_ERR response for device-to-host data FIS
  0x0004  2            0  R_ERR response for host-to-device data FIS
  0x0006  2            0  R_ERR response for device-to-host non-data FIS
  0x0007  2            0  R_ERR response for host-to-device non-data FIS

  smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.16.5-64] (local build)
  Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

  === START OF INFORMATION SECTION ===
  Model Family:     Seagate Desktop HDD.15
  Device Model:     ST4000DM000-1F2168
  Serial Number:    Z3035ZY3
  LU WWN Device Id: 5 000c50 07a720d6c
  Firmware Version: CC54
  User Capacity:    4,000,787,030,016 bytes [4.00 TB]
  Sector Sizes:     512 bytes logical, 4096 bytes physical
  Rotation Rate:    5900 rpm
  Form Factor:      3.5 inches
  Device is:        In smartctl database [for details use: -P show]
  ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
  SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
  Local Time is:    Wed May 20 19:43:03 2020 EDT
  SMART support is: Available - device has SMART capability.
  SMART support is: Enabled
  AAM feature is:   Unavailable
  APM level is:     128 (minimum power consumption without standby)
  Rd look-ahead is: Enabled
  Write cache is:   Enabled
  ATA Security is:  Disabled, frozen [SEC2]
  Wt Cache Reorder: Unavailable

  === START OF READ SMART DATA SECTION ===
  SMART overall-health self-assessment test result: PASSED

  General SMART Values:
  Offline data collection status:  (0x00)	Offline data collection activity
                                          was never started.
                                          Auto Offline Data Collection: Disabled.
  Self-test execution status:      (   0)	The previous self-test routine completed
                                          without error or no self-test has ever 
                                          been run.
  Total time to complete Offline 
  data collection: 		(  107) seconds.
  Offline data collection
  capabilities: 			 (0x73) SMART execute Offline immediate.
                                          Auto Offline data collection on/off support.
                                          Suspend Offline collection upon new
                                          command.
                                          No Offline surface scan supported.
                                          Self-test supported.
                                          Conveyance Self-test supported.
                                          Selective Self-test supported.
  SMART capabilities:            (0x0003)	Saves SMART data before entering
                                          power-saving mode.
                                          Supports SMART auto save timer.
  Error logging capability:        (0x01)	Error logging supported.
                                          General Purpose Logging supported.
  Short self-test routine 
  recommended polling time: 	 (   1) minutes.
  Extended self-test routine
  recommended polling time: 	 ( 503) minutes.
  Conveyance self-test routine
  recommended polling time: 	 (   2) minutes.
  SCT capabilities: 	       (0x1085)	SCT Status supported.

  SMART Attributes Data Structure revision number: 10
  Vendor Specific SMART Attributes with Thresholds:
  ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
    1 Raw_Read_Error_Rate     POSR--   117   099   006    -    134186720
    3 Spin_Up_Time            PO----   092   092   000    -    0
    4 Start_Stop_Count        -O--CK   100   100   020    -    58
    5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
    7 Seek_Error_Rate         POSR--   083   060   030    -    230358180
    9 Power_On_Hours          -O--CK   068   068   000    -    28032
   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
   12 Power_Cycle_Count       -O--CK   100   100   020    -    58
  183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
  184 End-to-End_Error        -O--CK   100   100   099    -    0
  187 Reported_Uncorrect      -O--CK   100   100   000    -    0
  188 Command_Timeout         -O--CK   100   100   000    -    0 0 0
  189 High_Fly_Writes         -O-RCK   100   100   000    -    0
  190 Airflow_Temperature_Cel -O---K   056   047   045    -    44 (Min/Max 38/44)
  191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
  192 Power-Off_Retract_Count -O--CK   100   100   000    -    0
  193 Load_Cycle_Count        -O--CK   042   042   000    -    117617
  194 Temperature_Celsius     -O---K   044   053   000    -    44 (0 19 0 0 0)
  197 Current_Pending_Sector  -O--C-   100   100   000    -    0
  198 Offline_Uncorrectable   ----C-   100   100   000    -    0
  199 UDMA_CRC_Error_Count    -OSRCK   200   200   000    -    0
  240 Head_Flying_Hours       ------   100   253   000    -    10752h+43m+59.647s
  241 Total_LBAs_Written      ------   100   253   000    -    24192515816
  242 Total_LBAs_Read         ------   100   253   000    -    2898959142485
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
  0x09           SL  R/W      1  Selective self-test log
  0x10       GPL     R/O      1  SATA NCQ Queued Error log
  0x11       GPL     R/O      1  SATA Phy Event Counters log
  0x21       GPL     R/O      1  Write stream error log
  0x22       GPL     R/O      1  Read stream error log
  0x24       GPL     R/O   1223  Current Device Internal Status Data log
  0x25       GPL     R/O   1223  Saved Device Internal Status Data log
  0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
  0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
  0xa1       GPL,SL  VS      20  Device vendor specific log
  0xa2       GPL     VS    4496  Device vendor specific log
  0xa8       GPL,SL  VS     129  Device vendor specific log
  0xa9       GPL,SL  VS       1  Device vendor specific log
  0xab       GPL     VS       1  Device vendor specific log
  0xb0       GPL     VS    5176  Device vendor specific log
  0xbe-0xbf  GPL     VS   65535  Device vendor specific log
  0xc0       GPL,SL  VS       1  Device vendor specific log
  0xc1       GPL,SL  VS      10  Device vendor specific log
  0xc3       GPL,SL  VS       8  Device vendor specific log
  0xc4       GPL,SL  VS       5  Device vendor specific log
  0xe0       GPL,SL  R/W      1  SCT Command/Status
  0xe1       GPL,SL  R/W      1  SCT Data Transfer

  SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
  No Errors Logged

  SMART Extended Self-test Log Version: 1 (1 sectors)
  Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
  # 1  Short offline       Completed without error       00%     26246         -
  # 2  Short offline       Completed without error       00%     26222         -

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
  Power Cycle Min/Max Temperature:     38/44 Celsius
  Lifetime    Min/Max Temperature:     19/53 Celsius
  Under/Over Temperature Limit Count:   0/0

  SCT Data Table command not supported

  SCT Error Recovery Control command not supported

  Device Statistics (GP Log 0x04)
  Page  Offset Size        Value Flags Description
  0x01  =====  =               =  ===  == General Statistics (rev 2) ==
  0x01  0x008  4              58  ---  Lifetime Power-On Resets
  0x01  0x010  4           28032  ---  Power-on Hours
  0x01  0x018  6     24186897631  ---  Logical Sectors Written
  0x01  0x020  6        83891648  ---  Number of Write Commands
  0x01  0x028  6    291514196745  ---  Logical Sectors Read
  0x01  0x030  6      1032191692  ---  Number of Read Commands
  0x01  0x038  6               -  ---  Date and Time TimeStamp
  0x03  =====  =               =  ===  == Rotating Media Statistics (rev 1) ==
  0x03  0x008  4           28032  ---  Spindle Motor Power-on Hours
  0x03  0x010  4            7604  ---  Head Flying Hours
  0x03  0x018  4          117617  ---  Head Load Events
  0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
  0x03  0x028  4               0  ---  Read Recovery Attempts
  0x03  0x030  4               0  ---  Number of Mechanical Start Failures
  0x04  =====  =               =  ===  == General Errors Statistics (rev 1) ==
  0x04  0x008  4               0  ---  Number of Reported Uncorrectable Errors
  0x04  0x010  4               0  ---  Resets Between Cmd Acceptance and Completion
                                  |||_ C monitored condition met
                                  ||__ D supports DSN
                                  |___ N normalized value

  SATA Phy Event Counters (GP Log 0x11)
  ID      Size     Value  Description
  0x000a  2            4  Device-to-host register FISes sent due to a COMRESET
  0x0001  2            0  Command failed due to ICRC error
  0x0003  2            0  R_ERR response for device-to-host data FIS
  0x0004  2            0  R_ERR response for host-to-device data FIS
  0x0006  2            0  R_ERR response for device-to-host non-data FIS
  0x0007  2            0  R_ERR response for host-to-device non-data FIS

  smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.16.5-64] (local build)
  Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

  === START OF INFORMATION SECTION ===
  Model Family:     Seagate Desktop HDD.15
  Device Model:     ST4000DM000-1F2168
  Serial Number:    Z3035YD9
  LU WWN Device Id: 5 000c50 07a7290ae
  Firmware Version: CC54
  User Capacity:    4,000,787,030,016 bytes [4.00 TB]
  Sector Sizes:     512 bytes logical, 4096 bytes physical
  Rotation Rate:    5900 rpm
  Form Factor:      3.5 inches
  Device is:        In smartctl database [for details use: -P show]
  ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
  SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
  Local Time is:    Wed May 20 19:43:03 2020 EDT
  SMART support is: Available - device has SMART capability.
  SMART support is: Enabled
  AAM feature is:   Unavailable
  APM level is:     128 (minimum power consumption without standby)
  Rd look-ahead is: Enabled
  Write cache is:   Enabled
  ATA Security is:  Disabled, frozen [SEC2]
  Wt Cache Reorder: Unavailable

  === START OF READ SMART DATA SECTION ===
  SMART overall-health self-assessment test result: PASSED

  General SMART Values:
  Offline data collection status:  (0x00)	Offline data collection activity
                                          was never started.
                                          Auto Offline Data Collection: Disabled.
  Self-test execution status:      (   0)	The previous self-test routine completed
                                          without error or no self-test has ever 
                                          been run.
  Total time to complete Offline 
  data collection: 		(  117) seconds.
  Offline data collection
  capabilities: 			 (0x73) SMART execute Offline immediate.
                                          Auto Offline data collection on/off support.
                                          Suspend Offline collection upon new
                                          command.
                                          No Offline surface scan supported.
                                          Self-test supported.
                                          Conveyance Self-test supported.
                                          Selective Self-test supported.
  SMART capabilities:            (0x0003)	Saves SMART data before entering
                                          power-saving mode.
                                          Supports SMART auto save timer.
  Error logging capability:        (0x01)	Error logging supported.
                                          General Purpose Logging supported.
  Short self-test routine 
  recommended polling time: 	 (   1) minutes.
  Extended self-test routine
  recommended polling time: 	 ( 497) minutes.
  Conveyance self-test routine
  recommended polling time: 	 (   2) minutes.
  SCT capabilities: 	       (0x1085)	SCT Status supported.

  SMART Attributes Data Structure revision number: 10
  Vendor Specific SMART Attributes with Thresholds:
  ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
    1 Raw_Read_Error_Rate     POSR--   119   099   006    -    208585728
    3 Spin_Up_Time            PO----   092   092   000    -    0
    4 Start_Stop_Count        -O--CK   100   100   020    -    58
    5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
    7 Seek_Error_Rate         POSR--   084   060   030    -    274639681
    9 Power_On_Hours          -O--CK   069   069   000    -    28031
   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
   12 Power_Cycle_Count       -O--CK   100   100   020    -    58
  183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
  184 End-to-End_Error        -O--CK   100   100   099    -    0
  187 Reported_Uncorrect      -O--CK   100   100   000    -    0
  188 Command_Timeout         -O--CK   100   100   000    -    0 0 0
  189 High_Fly_Writes         -O-RCK   100   100   000    -    0
  190 Airflow_Temperature_Cel -O---K   057   048   045    -    43 (Min/Max 39/43)
  191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
  192 Power-Off_Retract_Count -O--CK   100   100   000    -    0
  193 Load_Cycle_Count        -O--CK   042   042   000    -    117317
  194 Temperature_Celsius     -O---K   043   052   000    -    43 (0 19 0 0 0)
  197 Current_Pending_Sector  -O--C-   100   100   000    -    0
  198 Offline_Uncorrectable   ----C-   100   100   000    -    0
  199 UDMA_CRC_Error_Count    -OSRCK   200   196   000    -    28238
  240 Head_Flying_Hours       ------   100   253   000    -    10748h+14m+07.951s
  241 Total_LBAs_Written      ------   100   253   000    -    32001521506
  242 Total_LBAs_Read         ------   100   253   000    -    1283277590183
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
  0x09           SL  R/W      1  Selective self-test log
  0x10       GPL     R/O      1  SATA NCQ Queued Error log
  0x11       GPL     R/O      1  SATA Phy Event Counters log
  0x21       GPL     R/O      1  Write stream error log
  0x22       GPL     R/O      1  Read stream error log
  0x24       GPL     R/O   1223  Current Device Internal Status Data log
  0x25       GPL     R/O   1223  Saved Device Internal Status Data log
  0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
  0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
  0xa1       GPL,SL  VS      20  Device vendor specific log
  0xa2       GPL     VS    4496  Device vendor specific log
  0xa8       GPL,SL  VS     129  Device vendor specific log
  0xa9       GPL,SL  VS       1  Device vendor specific log
  0xab       GPL     VS       1  Device vendor specific log
  0xb0       GPL     VS    5176  Device vendor specific log
  0xbe-0xbf  GPL     VS   65535  Device vendor specific log
  0xc0       GPL,SL  VS       1  Device vendor specific log
  0xc1       GPL,SL  VS      10  Device vendor specific log
  0xc3       GPL,SL  VS       8  Device vendor specific log
  0xc4       GPL,SL  VS       5  Device vendor specific log
  0xe0       GPL,SL  R/W      1  SCT Command/Status
  0xe1       GPL,SL  R/W      1  SCT Data Transfer

  SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
  No Errors Logged

  SMART Extended Self-test Log Version: 1 (1 sectors)
  Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
  # 1  Short offline       Completed without error       00%     26246         -
  # 2  Short offline       Completed without error       00%     26222         -

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
  Current Temperature:                    43 Celsius
  Power Cycle Min/Max Temperature:     39/43 Celsius
  Lifetime    Min/Max Temperature:     19/52 Celsius
  Under/Over Temperature Limit Count:   0/0

  SCT Data Table command not supported

  SCT Error Recovery Control command not supported

  Device Statistics (GP Log 0x04)
  Page  Offset Size        Value Flags Description
  0x01  =====  =               =  ===  == General Statistics (rev 2) ==
  0x01  0x008  4              58  ---  Lifetime Power-On Resets
  0x01  0x010  4           28031  ---  Power-on Hours
  0x01  0x018  6     32001349231  ---  Logical Sectors Written
  0x01  0x020  6        88313724  ---  Number of Write Commands
  0x01  0x028  6    276446233896  ---  Logical Sectors Read
  0x01  0x030  6       677150509  ---  Number of Read Commands
  0x01  0x038  6               -  ---  Date and Time TimeStamp
  0x03  =====  =               =  ===  == Rotating Media Statistics (rev 1) ==
  0x03  0x008  4           28031  ---  Spindle Motor Power-on Hours
  0x03  0x010  4            7500  ---  Head Flying Hours
  0x03  0x018  4          117317  ---  Head Load Events
  0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
  0x03  0x028  4               0  ---  Read Recovery Attempts
  0x03  0x030  4               0  ---  Number of Mechanical Start Failures
  0x04  =====  =               =  ===  == General Errors Statistics (rev 1) ==
  0x04  0x008  4               0  ---  Number of Reported Uncorrectable Errors
  0x04  0x010  4               0  ---  Resets Between Cmd Acceptance and Completion
                                  |||_ C monitored condition met
                                  ||__ D supports DSN
                                  |___ N normalized value

  SATA Phy Event Counters (GP Log 0x11)
  ID      Size     Value  Description
  0x000a  2            4  Device-to-host register FISes sent due to a COMRESET
  0x0001  2            0  Command failed due to ICRC error
  0x0003  2            0  R_ERR response for device-to-host data FIS
  0x0004  2            0  R_ERR response for host-to-device data FIS
  0x0006  2            0  R_ERR response for device-to-host non-data FIS
  0x0007  2            0  R_ERR response for host-to-device non-data FIS

  smartctl 6.6 2016-05-31 r4324 [x86_64-linux-4.16.5-64] (local build)
  Copyright (C) 2002-16, Bruce Allen, Christian Franke, www.smartmontools.org

  === START OF INFORMATION SECTION ===
  Model Family:     Seagate Desktop HDD.15
  Device Model:     ST4000DM000-1F2168
  Serial Number:    Z3037GC5
  LU WWN Device Id: 5 000c50 07a8050a3
  Firmware Version: CC54
  User Capacity:    4,000,787,030,016 bytes [4.00 TB]
  Sector Sizes:     512 bytes logical, 4096 bytes physical
  Rotation Rate:    5900 rpm
  Form Factor:      3.5 inches
  Device is:        In smartctl database [for details use: -P show]
  ATA Version is:   ACS-2, ACS-3 T13/2161-D revision 3b
  SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 3.0 Gb/s)
  Local Time is:    Wed May 20 19:43:03 2020 EDT
  SMART support is: Available - device has SMART capability.
  SMART support is: Enabled
  AAM feature is:   Unavailable
  APM level is:     128 (minimum power consumption without standby)
  Rd look-ahead is: Enabled
  Write cache is:   Enabled
  ATA Security is:  Disabled, frozen [SEC2]
  Wt Cache Reorder: Unavailable

  === START OF READ SMART DATA SECTION ===
  SMART overall-health self-assessment test result: PASSED

  General SMART Values:
  Offline data collection status:  (0x00)	Offline data collection activity
                                          was never started.
                                          Auto Offline Data Collection: Disabled.
  Self-test execution status:      (   0)	The previous self-test routine completed
                                          without error or no self-test has ever 
                                          been run.
  Total time to complete Offline 
  data collection: 		(  117) seconds.
  Offline data collection
  capabilities: 			 (0x73) SMART execute Offline immediate.
                                          Auto Offline data collection on/off support.
                                          Suspend Offline collection upon new
                                          command.
                                          No Offline surface scan supported.
                                          Self-test supported.
                                          Conveyance Self-test supported.
                                          Selective Self-test supported.
  SMART capabilities:            (0x0003)	Saves SMART data before entering
                                          power-saving mode.
                                          Supports SMART auto save timer.
  Error logging capability:        (0x01)	Error logging supported.
                                          General Purpose Logging supported.
  Short self-test routine 
  recommended polling time: 	 (   1) minutes.
  Extended self-test routine
  recommended polling time: 	 ( 493) minutes.
  Conveyance self-test routine
  recommended polling time: 	 (   2) minutes.
  SCT capabilities: 	       (0x1085)	SCT Status supported.

  SMART Attributes Data Structure revision number: 10
  Vendor Specific SMART Attributes with Thresholds:
  ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
    1 Raw_Read_Error_Rate     POSR--   110   099   006    -    25174232
    3 Spin_Up_Time            PO----   092   091   000    -    0
    4 Start_Stop_Count        -O--CK   100   100   020    -    61
    5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
    7 Seek_Error_Rate         POSR--   084   060   030    -    268138154
    9 Power_On_Hours          -O--CK   069   069   000    -    27636
   10 Spin_Retry_Count        PO--C-   100   100   097    -    0
   12 Power_Cycle_Count       -O--CK   100   100   020    -    61
  183 Runtime_Bad_Block       -O--CK   100   100   000    -    0
  184 End-to-End_Error        -O--CK   100   100   099    -    0
  187 Reported_Uncorrect      -O--CK   100   100   000    -    0
  188 Command_Timeout         -O--CK   100   099   000    -    1 1 1
  189 High_Fly_Writes         -O-RCK   100   100   000    -    0
  190 Airflow_Temperature_Cel -O---K   059   052   045    -    41 (Min/Max 38/41)
  191 G-Sense_Error_Rate      -O--CK   100   100   000    -    0
  192 Power-Off_Retract_Count -O--CK   100   100   000    -    2
  193 Load_Cycle_Count        -O--CK   043   043   000    -    114940
  194 Temperature_Celsius     -O---K   041   048   000    -    41 (0 18 0 0 0)
  197 Current_Pending_Sector  -O--C-   100   100   000    -    0
  198 Offline_Uncorrectable   ----C-   100   100   000    -    0
  199 UDMA_CRC_Error_Count    -OSRCK   200   188   000    -    28116
  240 Head_Flying_Hours       ------   100   253   000    -    10650h+15m+10.785s
  241 Total_LBAs_Written      ------   100   253   000    -    24437975895
  242 Total_LBAs_Read         ------   100   253   000    -    1681117138889
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
  0x09           SL  R/W      1  Selective self-test log
  0x10       GPL     R/O      1  SATA NCQ Queued Error log
  0x11       GPL     R/O      1  SATA Phy Event Counters log
  0x21       GPL     R/O      1  Write stream error log
  0x22       GPL     R/O      1  Read stream error log
  0x24       GPL     R/O   1223  Current Device Internal Status Data log
  0x25       GPL     R/O   1223  Saved Device Internal Status Data log
  0x30       GPL,SL  R/O      9  IDENTIFY DEVICE data log
  0x80-0x9f  GPL,SL  R/W     16  Host vendor specific log
  0xa1       GPL,SL  VS      20  Device vendor specific log
  0xa2       GPL     VS    4496  Device vendor specific log
  0xa8       GPL,SL  VS     129  Device vendor specific log
  0xa9       GPL,SL  VS       1  Device vendor specific log
  0xab       GPL     VS       1  Device vendor specific log
  0xb0       GPL     VS    5176  Device vendor specific log
  0xbe-0xbf  GPL     VS   65535  Device vendor specific log
  0xc0       GPL,SL  VS       1  Device vendor specific log
  0xc1       GPL,SL  VS      10  Device vendor specific log
  0xc3       GPL,SL  VS       8  Device vendor specific log
  0xc4       GPL,SL  VS       5  Device vendor specific log
  0xe0       GPL,SL  R/W      1  SCT Command/Status
  0xe1       GPL,SL  R/W      1  SCT Data Transfer

  SMART Extended Comprehensive Error Log Version: 1 (5 sectors)
  No Errors Logged

  SMART Extended Self-test Log Version: 1 (1 sectors)
  Num  Test_Description    Status                  Remaining  LifeTime(hours)  LBA_of_first_error
  # 1  Short offline       Completed without error       00%     26248         -
  # 2  Short offline       Completed without error       00%     26224         -

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
  Current Temperature:                    41 Celsius
  Power Cycle Min/Max Temperature:     39/41 Celsius
  Lifetime    Min/Max Temperature:     18/48 Celsius
  Under/Over Temperature Limit Count:   0/0

  SCT Data Table command not supported

  SCT Error Recovery Control command not supported

  Device Statistics (GP Log 0x04)
  Page  Offset Size        Value Flags Description
  0x01  =====  =               =  ===  == General Statistics (rev 2) ==
  0x01  0x008  4              61  ---  Lifetime Power-On Resets
  0x01  0x010  4           27636  ---  Power-on Hours
  0x01  0x018  6     24437103178  ---  Logical Sectors Written
  0x01  0x020  6        78600744  ---  Number of Write Commands
  0x01  0x028  6    283564947845  ---  Logical Sectors Read
  0x01  0x030  6       696278294  ---  Number of Read Commands
  0x01  0x038  6               -  ---  Date and Time TimeStamp
  0x03  =====  =               =  ===  == Rotating Media Statistics (rev 1) ==
  0x03  0x008  4           27636  ---  Spindle Motor Power-on Hours
  0x03  0x010  4            7490  ---  Head Flying Hours
  0x03  0x018  4          114940  ---  Head Load Events
  0x03  0x020  4               0  ---  Number of Reallocated Logical Sectors
  0x03  0x028  4               0  ---  Read Recovery Attempts
  0x03  0x030  4               0  ---  Number of Mechanical Start Failures
  0x04  =====  =               =  ===  == General Errors Statistics (rev 1) ==
  0x04  0x008  4               0  ---  Number of Reported Uncorrectable Errors
  0x04  0x010  4               1  ---  Resets Between Cmd Acceptance and Completion
                                  |||_ C monitored condition met
                                  ||__ D supports DSN
                                  |___ N normalized value

  SATA Phy Event Counters (GP Log 0x11)
  ID      Size     Value  Description
  0x000a  2            4  Device-to-host register FISes sent due to a COMRESET
  0x0001  2            0  Command failed due to ICRC error
  0x0003  2            0  R_ERR response for device-to-host data FIS
  0x0004  2            0  R_ERR response for host-to-device data FIS
  0x0006  2            0  R_ERR response for device-to-host non-data FIS
  0x0007  2            0  R_ERR response for host-to-device non-data FIS

  diskfarm:root:11:/mnt/scratch/disks> for D in sd{a,b,c,d} ; do mdadm --examine /dev/${D} >mdadm--examine.${D}.out ; mdadm --examine /dev/${D}1 >mdadm--examine.${D}1.out ; done

  /dev/sda:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)

  /dev/sda1:
            Magic : a92b4efc
          Version : 1.2
      Feature Map : 0x0
       Array UUID : ca7008ef:90693dae:6c231ad7:08b3f92d
             Name : diskfarm:0  (local to host diskfarm)
    Creation Time : Mon Feb  6 00:56:35 2017
       Raid Level : raid5
     Raid Devices : 4

   Avail Dev Size : 7813510799 (3725.77 GiB 4000.52 GB)
       Array Size : 11720265216 (11177.32 GiB 12001.55 GB)
    Used Dev Size : 7813510144 (3725.77 GiB 4000.52 GB)
      Data Offset : 262144 sectors
     Super Offset : 8 sectors
     Unused Space : before=262064 sectors, after=655 sectors
            State : clean
      Device UUID : f05a143b:50c9b024:36714b9a:44b6a159

      Update Time : Mon May 18 01:10:07 2020
         Checksum : 48106c75 - correct
           Events : 57840

           Layout : left-symmetric
       Chunk Size : 512K

     Device Role : Active device 3
     Array State : A..A ('A' == active, '.' == missing, 'R' == replacing)

  /dev/sdb:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)

  /dev/sdb1:
            Magic : a92b4efc
          Version : 1.2
      Feature Map : 0x0
       Array UUID : ca7008ef:90693dae:6c231ad7:08b3f92d
             Name : diskfarm:0  (local to host diskfarm)
    Creation Time : Mon Feb  6 00:56:35 2017
       Raid Level : raid5
     Raid Devices : 4

   Avail Dev Size : 7813510799 (3725.77 GiB 4000.52 GB)
       Array Size : 11720265216 (11177.32 GiB 12001.55 GB)
    Used Dev Size : 7813510144 (3725.77 GiB 4000.52 GB)
      Data Offset : 262144 sectors
     Super Offset : 8 sectors
     Unused Space : before=262064 sectors, after=655 sectors
            State : clean
      Device UUID : bbcf5aff:e4a928b8:4fd788c2:c3f298da

      Update Time : Mon May 18 01:10:07 2020
         Checksum : 49035472 - correct
           Events : 57840

           Layout : left-symmetric
       Chunk Size : 512K

     Device Role : Active device 0
     Array State : A..A ('A' == active, '.' == missing, 'R' == replacing)

  /dev/sdc:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)

  /dev/sdc1:
            Magic : a92b4efc
          Version : 1.2
      Feature Map : 0x0
       Array UUID : ca7008ef:90693dae:6c231ad7:08b3f92d
             Name : diskfarm:0  (local to host diskfarm)
    Creation Time : Mon Feb  6 00:56:35 2017
       Raid Level : raid5
     Raid Devices : 4

   Avail Dev Size : 7813510799 (3725.77 GiB 4000.52 GB)
       Array Size : 11720265216 (11177.32 GiB 12001.55 GB)
    Used Dev Size : 7813510144 (3725.77 GiB 4000.52 GB)
      Data Offset : 262144 sectors
     Super Offset : 8 sectors
     Unused Space : before=262064 sectors, after=655 sectors
            State : clean
      Device UUID : c0a32425:2d206e98:78f9c264:d39e9720

      Update Time : Mon May 18 01:03:28 2020
         Checksum : 374f6d76 - correct
           Events : 57836

           Layout : left-symmetric
       Chunk Size : 512K

     Device Role : Active device 2
     Array State : A.AA ('A' == active, '.' == missing, 'R' == replacing)

  /dev/sdd:
     MBR Magic : aa55
  Partition[0] :   4294967295 sectors at            1 (type ee)

  /dev/sdd1:
            Magic : a92b4efc
          Version : 1.2
      Feature Map : 0xa
       Array UUID : ca7008ef:90693dae:6c231ad7:08b3f92d
             Name : diskfarm:0  (local to host diskfarm)
    Creation Time : Mon Feb  6 00:56:35 2017
       Raid Level : raid5
     Raid Devices : 4

   Avail Dev Size : 7813510799 (3725.77 GiB 4000.52 GB)
       Array Size : 11720265216 (11177.32 GiB 12001.55 GB)
    Used Dev Size : 7813510144 (3725.77 GiB 4000.52 GB)
      Data Offset : 262144 sectors
     Super Offset : 8 sectors
  Recovery Offset : 210494872 sectors
     Unused Space : before=261864 sectors, after=655 sectors
            State : clean
      Device UUID : a1109a7b:abd58fc5:89313c87:232df49b

      Update Time : Sun May  3 23:03:44 2020
    Bad Block Log : 512 entries available at offset 264 sectors - bad blocks present.
         Checksum : 65408715 - correct
           Events : 48959

           Layout : left-symmetric
       Chunk Size : 512K

     Device Role : Active device 1
     Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

  diskfarm:root:11:/mnt/scratch/disks> mdadm --detail /dev/md0 >mdadm--detail.md0.out

  /dev/md0:
          Version : 
       Raid Level : raid0
    Total Devices : 0

            State : inactive

      Number   Major   Minor   RaidDevice

  diskfarm:root:11:/mnt/scratch/disks> cat /proc/mdstat >mdstat

  Personalities : [raid6] [raid5] [raid4] 
  md127 : active raid5 sdf2[0] sdg2[1] sdh2[3]
        1464622080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/3] [UUU]

  unused devices: <none>

  diskfarm:root:11:/mnt/scratch/disks> ./lsdrv/lsdrv >lsdrv.out 2>&1

  Traceback (most recent call last):
    File "./lsdrv/lsdrv", line 423, in <module>
      probe_block('/sys/block/'+x)
    File "./lsdrv/lsdrv", line 419, in probe_block
      probe_block(blkpath+'/'+part)
    File "./lsdrv/lsdrv", line 399, in probe_block
      blk.FS = "MD %s (%s/%s)%s %s" % (blk.array.md.LEVEL, blk.slave.slot, blk.array.md.raid_disks, peers, blk.slave.state)
  AttributeError: 'NoneType' object has no attribute 'LEVEL'

  Thank you all SO VERY MUCH.  Guide me!


% 
% Cheers,
% Wol
% 


HANN

:-D
-- 
David T-G
See http://justpickone.org/davidtg/email/
See http://justpickone.org/davidtg/tofu.txt

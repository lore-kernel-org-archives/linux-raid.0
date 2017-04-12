From: linuxknight <linuxknight@gmail.com>
Subject: Linux software raid troubles
Date: Wed, 12 Apr 2017 10:31:46 -0400
Message-ID: <CAAO=44Y=8xrnWvMp214RFq9Y-KVDQVfEYa2vL-Ahgmbvgs6Y4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Last weekend I was moving a server with a raid1 configuration,
controlled by a Intel Corporation 82801 SATA RAID Controller.  Upon
reboot I noticed the degraded message (server hadnt been rebooted in a
couple years).

The raid1 array was two 500gb black WD drives.  I wasnt able to locate
an identical 500gb disk, but did find a 2TB just to get things
mirrored again.  The bios screen accepted the replacement disk and
said it would rebuild in the OS.  mdsync seemed to do its thing but I
noticed mdmon process was taking 200% cpu.  I let it go a few days
thinking it was just taking longer than normal to sync, then rebooted.
It was in a complete failed state and wouldnt boot at all.  After
removing the 2TB disk I was able to boot into the OS again.  I just
assumed I needed a similar drive size for the second part of the
mirror.

Today I installed an identical black WD 500gb drive and its doing the
same behavior.  Currently running a bad block check but in the
meantime I found the wiki and read up a bit on some basic
troubleshooting and asking for help
(https://raid.wiki.kernel.org/index.php/Asking_for_help)

I wanted to attach the output of the commands on that page and hope
someone may have some ideas for rebuilding this second drive.  Thank
you in advance for any suggestions.  Im concerned at this point I only
have one good drive and could possibly lose everything if that failed.

mail:~ # smartctl --xall /dev/sda
smartctl 6.0 2012-10-10 r3643 [i686-linux-3.1.10-1.29-pae] (SUSE RPM)
Copyright (C) 2002-12, Bruce Allen, Christian Franke, www.smartmontools.org

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Black
Device Model:     WDC WD5002AALX-00J37A0
Serial Number:    WD-WMAYUL169523
LU WWN Device Id: 5 0014ee 104a23be3
Firmware Version: 15.01H15
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Wed Apr 12 09:33:54 2017 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled
AAM feature is:   Unavailable
APM feature is:   Unavailable
Rd look-ahead is: Enabled
Write cache is:   Enabled
ATA Security is:  Disabled, frozen [SEC2]

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activity
                                        was completed without error.
                                        Auto Offline Data Collection: Enabl=
ed.
Self-test execution status:      (   0) The previous self-test routine comp=
leted
                                        without error or no self-test has e=
ver
                                        been run.
Total time to complete Offline
data collection:                ( 8280) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate.
                                        Auto Offline data collection
on/off supp

                          ort.
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
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        (  84) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x3037) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR-K   200   200   051    -    273
  3 Spin_Up_Time            POS--K   144   144   021    -    3783
  4 Start_Stop_Count        -O--CK   100   100   000    -    42
  5 Reallocated_Sector_Ct   PO--CK   200   200   140    -    0
  7 Seek_Error_Rate         -OSR-K   200   200   000    -    0
  9 Power_On_Hours          -O--CK   046   046   000    -    39646
 10 Spin_Retry_Count        -O--CK   100   253   000    -    0
 11 Calibration_Retry_Count -O--CK   100   253   000    -    0
 12 Power_Cycle_Count       -O--CK   100   100   000    -    39
192 Power-Off_Retract_Count -O--CK   200   200   000    -    36
193 Load_Cycle_Count        -O--CK   200   200   000    -    5
194 Temperature_Celsius     -O---K   104   104   000    -    39
196 Reallocated_Event_Count -O--CK   200   200   000    -    0
197 Current_Pending_Sector  -O--CK   200   200   000    -    9
198 Offline_Uncorrectable   ----CK   200   200   000    -    7
199 UDMA_CRC_Error_Count    -O--CK   200   200   000    -    0
200 Multi_Zone_Error_Rate   ---R--   200   200   000    -    15
                            ||||||_ K auto-keep
                            |||||__ C event count
                            ||||___ R error rate
                            |||____ S speed/performance
                            ||_____ O updated online
                            |______ P prefailure warning

General Purpose Log Directory Version 1
SMART           Log Directory Version 1 [multi-sector log support]
GP/S  Log at address 0x00 has    1 sectors [Log Directory]
SMART Log at address 0x01 has    1 sectors [Summary SMART error log]
SMART Log at address 0x02 has    5 sectors [Comprehensive SMART error log]
GP    Log at address 0x03 has    6 sectors [Ext. Comprehensive SMART error =
log]
SMART Log at address 0x06 has    1 sectors [SMART self-test log]
GP    Log at address 0x07 has    1 sectors [Extended self-test log]
SMART Log at address 0x09 has    1 sectors [Selective self-test log]
GP    Log at address 0x10 has    1 sectors [NCQ Command Error log]
GP    Log at address 0x11 has    1 sectors [SATA Phy Event Counters]
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
GP/S  Log at address 0xa0 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa1 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa2 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa3 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa4 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa5 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa6 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa7 has   16 sectors [Device vendor specific log]
GP/S  Log at address 0xa8 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xa9 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xaa has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xab has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xac has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xad has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xae has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xaf has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb0 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb1 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb2 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb3 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb4 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb5 has    1 sectors [Device vendor specific log]
GP    Log at address 0xb6 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xb7 has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xbd has    1 sectors [Device vendor specific log]
GP/S  Log at address 0xc0 has    1 sectors [Device vendor specific log]
GP    Log at address 0xc1 has   24 sectors [Device vendor specific log]
GP/S  Log at address 0xe0 has    1 sectors [SCT Command/Status]
GP/S  Log at address 0xe1 has    1 sectors [SCT Data Transfer]

SMART Extended Comprehensive Error Log Version: 1 (6 sectors)
Device Error Count: 209 (device log contains only the most recent 24 errors=
)
        CR     =3D Command Register
        FEATR  =3D Features Register
        COUNT  =3D Count (was: Sector Count) Register
        LBA_48 =3D Upper bytes of LBA High/Mid/Low Registers ]  ATA-8
        LH     =3D LBA High (was: Cylinder High) Register    ]   LBA
        LM     =3D LBA Mid (was: Cylinder Low) Register      ] Register
        LL     =3D LBA Low (was: Sector Number) Register     ]
        DV     =3D Device (was: Device/Head) Register
        DC     =3D Device Control Register
        ER     =3D Error register
        ST     =3D Status register
Powered_Up_Time is measured from power on, and printed as
DDd+hh:mm:SS.sss where DD=3Ddays, hh=3Dhours, mm=3Dminutes,
SS=3Dsec, and sss=3Dmillisec. It "wraps" after 49.710 days.

Error 209 [16] occurred at disk power-on lifetime: 39645 hours (1651
days + 21 h

                          ours)
  When the command that caused the error occurred, the device was
active or idle

                             .

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 13 34 8f 60 40 00  Error: UNC at LBA =3D
0x13348f60 =3D 32221

                                 1680

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 00 00 00 13 34 8f 60 40 08     01:11:05.460  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     01:11:05.460  SET
FEATURES [Reserve

                                d for Serial ATA]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     01:11:05.460  READ NATIVE
MAX ADDRE

                        SS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     01:11:05.457  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     01:11:05.457  SET
FEATURES [Set tra

                                nsfer mode]

Error 208 [15] occurred at disk power-on lifetime: 39645 hours (1651
days + 21 h

                          ours)
  When the command that caused the error occurred, the device was
active or idle

                             .

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 13 34 8f 60 40 00  Error: UNC at LBA =3D
0x13348f60 =3D 32221

                                 1680

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 00 00 00 13 34 8f 60 40 08     01:11:03.702  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     01:11:03.702  SET
FEATURES [Reserve

                                d for Serial ATA]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     01:11:03.702  READ NATIVE
MAX ADDRE

                        SS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     01:11:03.701  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     01:11:03.701  SET
FEATURES [Set tra

                                nsfer mode]

Error 207 [14] occurred at disk power-on lifetime: 39645 hours (1651
days + 21 h

                          ours)
  When the command that caused the error occurred, the device was
active or idle

                             .

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 13 34 8f 60 40 00  Error: UNC at LBA =3D
0x13348f60 =3D 32221

                                 1680

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 00 00 00 13 34 8f 60 40 08     01:11:01.947  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     01:11:01.947  SET
FEATURES [Reserve

                                d for Serial ATA]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     01:11:01.947  READ NATIVE
MAX ADDRE

                        SS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     01:11:01.944  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     01:11:01.944  SET
FEATURES [Set tra

                                nsfer mode]

Error 206 [13] occurred at disk power-on lifetime: 39645 hours (1651
days + 21 h

                          ours)
  When the command that caused the error occurred, the device was
active or idle

                             .

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 13 34 8f 60 40 00  Error: UNC at LBA =3D
0x13348f60 =3D 32221

                                 1680

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 00 00 00 13 34 8f 60 40 08     01:11:00.189  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     01:11:00.189  SET
FEATURES [Reserve

                                d for Serial ATA]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     01:11:00.189  READ NATIVE
MAX ADDRE

                        SS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     01:11:00.188  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     01:11:00.188  SET
FEATURES [Set tra

                                nsfer mode]

Error 205 [12] occurred at disk power-on lifetime: 39645 hours (1651
days + 21 h

                          ours)
  When the command that caused the error occurred, the device was
active or idle

                             .

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 13 34 8f 60 40 00  Error: UNC at LBA =3D
0x13348f60 =3D 32221

                                 1680

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 00 00 00 13 34 8f 60 40 08     01:10:58.434  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     01:10:58.434  SET
FEATURES [Reserve

                                d for Serial ATA]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     01:10:58.434  READ NATIVE
MAX ADDRE

                        SS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     01:10:58.431  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     01:10:58.431  SET
FEATURES [Set tra

                                nsfer mode]

Error 204 [11] occurred at disk power-on lifetime: 39645 hours (1651
days + 21 h

                          ours)
  When the command that caused the error occurred, the device was
active or idle

                             .

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 13 34 8f 60 40 00  Error: UNC at LBA =3D
0x13348f60 =3D 32221

                                 1680

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 00 00 00 13 34 8f 60 40 08     01:10:56.681  READ FPDMA QUEUE=
D
  ea 00 00 00 00 00 00 00 00 00 00 e0 08     01:10:56.660  FLUSH CACHE EXT
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     01:10:56.659  SET
FEATURES [Reserve

                                d for Serial ATA]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     01:10:56.659  READ NATIVE
MAX ADDRE

                        SS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     01:10:56.658  IDENTIFY DEVICE

Error 203 [10] occurred at disk power-on lifetime: 39645 hours (1651
days + 21 h

                          ours)
  When the command that caused the error occurred, the device was
active or idle

                             .

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 13 34 8f 60 40 00  Error: UNC at LBA =3D
0x13348f60 =3D 32221

                                 1680

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 00 00 00 13 34 8f 60 40 08     01:10:54.903  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     01:10:54.903  SET
FEATURES [Reserve

                                d for Serial ATA]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     01:10:54.903  READ NATIVE
MAX ADDRE

                        SS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     01:10:54.901  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     01:10:54.901  SET
FEATURES [Set tra

                                nsfer mode]

Error 202 [9] occurred at disk power-on lifetime: 39645 hours (1651
days + 21 ho

                           urs)
  When the command that caused the error occurred, the device was
active or idle

                             .

  After command completion occurred, registers were:
  ER -- ST COUNT  LBA_48  LH LM LL DV DC
  -- -- -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --
  40 -- 51 00 00 00 00 13 34 8f 60 40 00  Error: UNC at LBA =3D
0x13348f60 =3D 32221

                                 1680

  Commands leading to the command that caused the error were:
  CR FEATR COUNT  LBA_48  LH LM LL DV DC  Powered_Up_Time  Command/Feature_=
Name
  -- =3D=3D -- =3D=3D -- =3D=3D =3D=3D =3D=3D -- -- -- -- --  -------------=
--  --------------------
  60 00 08 00 00 00 00 13 34 8f 60 40 08     01:10:53.148  READ FPDMA QUEUE=
D
  ef 00 10 00 02 00 00 00 00 00 00 a0 08     01:10:53.147  SET
FEATURES [Reserve

                                d for Serial ATA]
  27 00 00 00 00 00 00 00 00 00 00 e0 08     01:10:53.146  READ NATIVE
MAX ADDRE

                        SS EXT
  ec 00 00 00 00 00 00 00 00 00 00 a0 08     01:10:53.145  IDENTIFY DEVICE
  ef 00 03 00 46 00 00 00 00 00 00 a0 08     01:10:53.145  SET
FEATURES [Set tra

                                nsfer mode]

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
SCT Support Level:                   1
Device State:                        Active (0)
Current Temperature:                    39 Celsius
Power Cycle Min/Max Temperature:     30/39 Celsius
Lifetime    Min/Max Temperature:      0/39 Celsius
Under/Over Temperature Limit Count:   0/0
SCT Temperature History Version:     2
Temperature Sampling Period:         1 minute
Temperature Logging Interval:        1 minute
Min/Max recommended Temperature:      0/60 Celsius
Min/Max Temperature Limit:           -41/85 Celsius
Temperature History Size (Index):    478 (368)

Index    Estimated Time   Temperature Celsius
 369    2017-04-12 01:36    29  **********
 ...    ..(198 skipped).    ..  **********
  90    2017-04-12 04:55    29  **********
  91    2017-04-12 04:56    28  *********
  92    2017-04-12 04:57    29  **********
 ...    ..( 71 skipped).    ..  **********
 164    2017-04-12 06:09    29  **********
 165    2017-04-12 06:10     ?  -
 166    2017-04-12 06:11    30  ***********
 167    2017-04-12 06:12    30  ***********
 168    2017-04-12 06:13    30  ***********
 169    2017-04-12 06:14    31  ************
 170    2017-04-12 06:15    32  *************
 ...    ..(  3 skipped).    ..  *************
 174    2017-04-12 06:19    32  *************
 175    2017-04-12 06:20    33  **************
 176    2017-04-12 06:21    33  **************
 177    2017-04-12 06:22    33  **************
 178    2017-04-12 06:23    34  ***************
 179    2017-04-12 06:24    34  ***************
 180    2017-04-12 06:25    35  ****************
 ...    ..(  8 skipped).    ..  ****************
 189    2017-04-12 06:34    35  ****************
 190    2017-04-12 06:35    36  *****************
 ...    ..( 23 skipped).    ..  *****************
 214    2017-04-12 06:59    36  *****************
 215    2017-04-12 07:00    37  ******************
 ...    ..(  4 skipped).    ..  ******************
 220    2017-04-12 07:05    37  ******************
 221    2017-04-12 07:06    38  *******************
 222    2017-04-12 07:07    37  ******************
 223    2017-04-12 07:08    38  *******************
 ...    ..(  6 skipped).    ..  *******************
 230    2017-04-12 07:15    38  *******************
 231    2017-04-12 07:16    37  ******************
 232    2017-04-12 07:17    38  *******************
 ...    ..( 14 skipped).    ..  *******************
 247    2017-04-12 07:32    38  *******************
 248    2017-04-12 07:33    39  ********************
 249    2017-04-12 07:34    39  ********************
 250    2017-04-12 07:35    38  *******************
 251    2017-04-12 07:36    39  ********************
 ...    ..(  4 skipped).    ..  ********************
 256    2017-04-12 07:41    39  ********************
 257    2017-04-12 07:42    29  **********
 ...    ..(110 skipped).    ..  **********
 368    2017-04-12 09:33    29  **********

SCT Error Recovery Control command not supported

Device Statistics (GP Log 0x04) not supported

SATA Phy Event Counters (GP Log 0x11)
ID      Size     Value  Description
0x0001  2            0  Command failed due to ICRC error
0x0002  2            0  R_ERR response for data FIS
0x0003  2            0  R_ERR response for device-to-host data FIS
0x0004  2            0  R_ERR response for host-to-device data FIS
0x0005  2            0  R_ERR response for non-data FIS
0x0006  2            0  R_ERR response for device-to-host non-data FIS
0x0007  2            0  R_ERR response for host-to-device non-data FIS
0x000a  2            7  Device-to-host register FISes sent due to a COMRESE=
T
0x000b  2            0  CRC errors within host-to-device FIS
0x8000  4         5831  Vendor specific

mail:~ # mdadm --examine /dev/sda
/dev/sda:
          Magic : Intel Raid ISM Cfg Sig.
        Version : 1.1.00
    Orig Family : 80d98105
         Family : 68a98654
     Generation : 00b83763
     Attributes : All supported
           UUID : 81a6fcf3:48d205e9:aa868e3f:9ad94fa5
       Checksum : 7e0e85bb correct
    MPB Sectors : 2
          Disks : 3
   RAID Devices : 1

[Volume0]:
           UUID : 44c0fda9:b2d38c01:e48120f6:4bed6635
     RAID Level : 1
        Members : 2
          Slots : [__]
    Failed disk : 1
      This Slot : ?
     Array Size : 976766976 (465.76 GiB 500.10 GB)
   Per Dev Size : 976767240 (465.76 GiB 500.10 GB)
  Sector Offset : 0
    Num Stripes : 3815496
     Chunk Size : 64 KiB
       Reserved : 0
  Migrate State : idle
      Map State : failed
    Dirty State : dirty

  Disk00 Serial : WD-WMAYUL169523
          State : active failed
             Id : 00040000
    Usable Size : 976766862 (465.76 GiB 500.10 GB)

  Disk01 Serial : WD-WCC6Y1VENZK4
          State : active failed
             Id : 00050000
    Usable Size : 976766862 (465.76 GiB 500.10 GB)

  Disk02 Serial : Z4Z6V3CV:0
          State : active failed
             Id : ffffffff
    Usable Size : 3907022862 (1863.01 GiB 2000.40 GB)

    Disk Serial : WD-WMAYUL169523
          State : active failed
             Id : 00040000
    Usable Size : 976766862 (465.76 GiB 500.10 GB)
mail:~ # mdadm --detail /dev/sda
mdadm: /dev/sda does not appear to be an md device
mail:~ # mdadm --detail /dev/md126
md126    md126p1  md126p2
mail:~ # mdadm --detail /dev/md126
md126    md126p1  md126p2
mail:~ # mdadm --detail /dev/md126
/dev/md126:
      Container : /dev/md127, member 0
     Raid Level : raid1
     Array Size : 488383488 (465.76 GiB 500.10 GB)
  Used Dev Size : 488383620 (465.76 GiB 500.10 GB)
   Raid Devices : 2
  Total Devices : 1

          State : clean, degraded
 Active Devices : 1
Working Devices : 1
 Failed Devices : 0
  Spare Devices : 0


           UUID : 44c0fda9:b2d38c01:e48120f6:4bed6635
    Number   Major   Minor   RaidDevice State
       1       8        0        0      active sync   /dev/sda
       1       0        0        1      removed
mail:~ # mdadm --detail /dev/md127
/dev/md127:
        Version : imsm
     Raid Level : container
  Total Devices : 2

Working Devices : 2


           UUID : 81a6fcf3:48d205e9:aa868e3f:9ad94fa5
  Member Arrays : /dev/md126

    Number   Major   Minor   RaidDevice

       0       8       16        -        /dev/sdb
       1       8        0        -        /dev/sda
mail:~/lsdrv # ./lsdrv
PCI [ahci] 00:1f.2 RAID bus controller: Intel Corporation 82801 SATA
RAID Controller (rev 05)
=E2=94=9Cscsi 0:0:0:0 ATAPI    iHAS424   B      {3524253_2N8147500192}
=E2=94=82=E2=94=94sr0 1.00g [11:0] Empty/Unknown
=E2=94=9Cscsi 1:x:x:x [Empty]
=E2=94=9Cscsi 2:x:x:x [Empty]
=E2=94=9Cscsi 3:x:x:x [Empty]
=E2=94=9Cscsi 4:0:0:0 ATA      WDC WD5002AALX-0 {WD-WMAYUL169523}
=E2=94=82=E2=94=94sda 465.76g [8:0] isw_raid_member
=E2=94=82 =E2=94=9Cmd126 465.76g [9:126] MD vexternal:/md127/0 raid1 (2) ac=
tive
DEGRADED, 64k Chunk, recover (none) none
{44c0fda9:b2d38c01:e48120f6:4bed6635}
=E2=94=82 =E2=94=82=E2=94=82                     Partitioned (dos)
=E2=94=82 =E2=94=82=E2=94=9Cmd126p1 4.01g [259:0] swap {57b97914-1b5f-4ac9-=
b7ca-c0e866535f68}
=E2=94=82 =E2=94=82=E2=94=94md126p2 461.75g [259:1] Partitioned (dos)
{bc3d52aa-a6d5-49a5-ab72-333b8dd5bc6d}
=E2=94=82 =E2=94=82 =E2=94=94Mounted as /dev/md126p2 @ /
=E2=94=82 =E2=94=9Cmd127 0.00k [9:127] MD vexternal:imsm  () inactive, None=
 (None)
None {81a6fcf3:48d205e9:aa868e3f:9ad94fa5}
=E2=94=82 =E2=94=82                    Empty/Unknown
=E2=94=82 =E2=94=9Csda1 4.01g [8:1] swap {57b97914-1b5f-4ac9-b7ca-c0e866535=
f68}
=E2=94=82 =E2=94=94sda2 461.75g [8:2] Partitioned (dos) {bc3d52aa-a6d5-49a5=
-ab72-333b8dd5bc6d}
=E2=94=94scsi 5:0:0:0 ATA      WDC WD5003AZEX-0 {WD-WCC6Y1VENZK4}
 =E2=94=94sdb 465.76g [8:16] isw_raid_member
  =E2=94=94md127 0.00k [9:127] MD vexternal:imsm  () inactive, None (None)
None {81a6fcf3:48d205e9:aa868e3f:9ad94fa5}
                       Empty/Unknown
PCI [sata_sil24] 04:00.0 RAID bus controller: Silicon Image, Inc. SiI
3124 PCI-X Serial ATA Controller (rev 02)
=E2=94=9Cscsi 6:x:x:x [Empty]
=E2=94=9Cscsi 7:x:x:x [Empty]
=E2=94=9Cscsi 8:x:x:x [Empty]
=E2=94=94scsi 9:x:x:x [Empty]
mail:~/lsdrv # cat /proc/mdstat
Personalities : [raid1] [raid0] [raid10] [raid6] [raid5] [raid4]
md126 : active raid1 sda[1]
      488383488 blocks super external:/md127/0 [2/1] [U_]

md127 : inactive sda[1](S) sdb[0](S)
      5928 blocks super external:imsm

unused devices: <none>

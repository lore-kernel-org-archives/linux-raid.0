From: Marc Desharnais <marcdesharnais@hotmail.com>
Subject: Re: Raid5 fails to assemble automatically
Date: Sun, 19 Jul 2015 19:40:06 -0400
Message-ID: <BLU437-SMTP566F1275E9035D33983D4CCE860@phx.gbl>
References: <BLU437-SMTP68684C478276C82E113DE6CE860@phx.gbl>
 <55ABBDC3.2070305@grumpydevil.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55ABBDC3.2070305@grumpydevil.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Rudy,

I was able to assemble the raid by stopping the array first, and forcin=
g=20
the assemble.
I backed up most of my data now and I can breathe :)

Now I want to know which drive I should replace.

Here's what I got from dmesg :

[    0.284287] scsi host0: pata_marvell
[    0.284404] scsi host1: pata_marvell
[    0.284417] sata_promise 0000:07:02.0: version 2.12
[    0.284453] ata1: PATA max UDMA/100 cmd 0x2018 ctl 0x2024 bmdma=20
0x2000 irq 17
[    0.284455] ata2: DUMMY
[    0.285013] scsi host2: sata_promise
[    0.285089] scsi host3: sata_promise
[    0.285162] scsi host4: sata_promise
[    0.285238] scsi host5: sata_promise
[    0.285285] ata3: SATA max UDMA/133 mmio m4096@0xe3124000 ata=20
0xe3124380 irq 18
[    0.285288] ata4: SATA max UDMA/133 mmio m4096@0xe3124000 ata=20
0xe3124280 irq 18
[    0.285290] ata5: SATA max UDMA/133 mmio m4096@0xe3124000 ata=20
0xe3124200 irq 18
[    0.285293] ata6: SATA max UDMA/133 mmio m4096@0xe3124000 ata=20
0xe3124300 irq 18
[    0.308447] ata_piix 0000:00:1f.2: version 2.13
[    0.308556] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
[    0.308956] scsi host6: ata_piix
[    0.309047] scsi host7: ata_piix
[    0.309101] ata7: SATA max UDMA/133 cmd 0x4458 ctl 0x446c bmdma=20
0x4430 irq 21
[    0.309105] ata8: SATA max UDMA/133 cmd 0x4450 ctl 0x4468 bmdma=20
0x4438 irq 21
[    0.309221] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
[    0.309583] scsi host8: ata_piix
[    0.309672] scsi host9: ata_piix
[    0.309722] ata9: SATA max UDMA/133 cmd 0x4448 ctl 0x4464 bmdma=20
0x4410 irq 21
[    0.309725] ata10: SATA max UDMA/133 cmd 0x4440 ctl 0x4460 bmdma=20
0x4418 irq 21
[    0.637315] ata9: SATA link down (SStatus 0 SControl 300)
[    0.763382] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.776449] ata3.00: ATA-7: WDC WD5000AAKS-00TMA0, 12.01C01, max UDM=
A/133
[    0.776453] ata3.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/=
32)
[    0.787974] ata3.00: configured for UDMA/133
[    0.793390] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    0.800314] ata10.00: ATA-8: ST3500418AS, CC38, max UDMA/133
[    0.800317] ata10.00: 976773168 sectors, multi 16: LBA48 NCQ (depth =
0/32)
[    0.813769] ata10.00: configured for UDMA/133
[    0.960644] ata7.00: SATA link down (SStatus 0 SControl 300)
[    0.960655] ata7.01: SATA link down (SStatus 0 SControl 300)
[    1.113401] ata8.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300=
)
[    1.113413] ata8.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300=
)
[    1.167224] ata8.00: ATA-7: ST3320620AS, 3.AAD, max UDMA/133
[    1.167228] ata8.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0=
/32)
[    1.186876] ata8.01: ATA-7: WDC WD5000AAKS-00TMA0, 12.01C01, max UDM=
A/133
[    1.186879] ata8.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0=
/32)
[    1.233838] ata8.00: configured for UDMA/133
[    1.247117] ata8.01: configured for UDMA/133
[    1.260050] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.284063] ata4.00: ATA-7: WDC WD5000AAKS-00TMA0, 12.01C01, max UDM=
A/133
[    1.284066] ata4.00: 976773168 sectors, multi 0: LBA48 NCQ (depth 0/=
32)
[    1.297703] ata4.00: configured for UDMA/133
[    1.616704] ata5: SATA link down (SStatus 0 SControl 300)
[    1.936703] ata6: SATA link down (SStatus 0 SControl 300)
[    3.788841] EXT4-fs (sdc3): mounted filesystem with ordered data=20
mode. Opts: (null)
[    6.250846] EXT4-fs (sdc3): re-mounted. Opts: data=3Dordered
[   16.065124] REISERFS (device sdc6): using ordered data mode
[   16.157157] REISERFS (device sdc7): using ordered data mode
[ 2654.314204] md: md0 stopped.
[ 2654.314211] md: unbind<sdd>
[ 2654.349758] md: export_rdev(sdd)
[ 2654.349787] md: unbind<sdb>
[ 2654.376421] md: export_rdev(sdb)
[ 2654.376465] md: unbind<sde>
[ 2654.403083] md: export_rdev(sde)
[ 2654.403121] md: unbind<sda>
[ 2654.429751] md: export_rdev(sda)
[ 2683.902046] md: md0 stopped.
[ 2683.906627]  sda: unknown partition table
[ 2683.908554]  sdb: unknown partition table
[ 2683.909356]  sde: unknown partition table
[ 2683.945959] md: bind<sdb>
[ 2683.946159] md: bind<sda>
[ 2683.946360] md: bind<sde>
[ 2683.946386] md: md0 stopped.
[ 2683.946390] md: unbind<sde>
[ 2683.966426] md: export_rdev(sde)
[ 2683.966431] md: unbind<sda>
[ 2683.999745] md: export_rdev(sda)
[ 2683.999749] md: unbind<sdb>
[ 2684.019745] md: export_rdev(sdb)
[ 2684.040292] md: bind<sde>
[ 2684.041464] md: bind<sdb>
[ 2684.042870] md: bind<sda>
[ 2684.153079] raid6: sse2x1    4293 MB/s
[ 2684.209756] raid6: sse2x2    4367 MB/s
[ 2684.266411] raid6: sse2x4    6959 MB/s
[ 2684.266412] raid6: using algorithm sse2x4 (6959 MB/s)
[ 2684.266413] raid6: using ssse3x2 recovery algorithm
[ 2684.274830] async_tx: api initialized (async)
[ 2684.275378] xor: measuring software checksum speed
[ 2684.306408]    prefetch64-sse: 10915.200 MB/sec
[ 2684.339741]    generic_sse:  8464.800 MB/sec
[ 2684.339742] xor: using function: prefetch64-sse (10915.200 MB/sec)
[ 2684.371389] md: raid6 personality registered for level 6
[ 2684.371389] md: raid5 personality registered for level 5
[ 2684.371390] md: raid4 personality registered for level 4
[ 2684.371740] md/raid:md0: device sda operational as raid disk 3
[ 2684.371741] md/raid:md0: device sdb operational as raid disk 2
[ 2684.371742] md/raid:md0: device sde operational as raid disk 0
[ 2684.372092] md/raid:md0: allocated 0kB
[ 2684.372115] md/raid:md0: raid level 5 active with 3 out of 4 devices=
,=20
algorithm 2
[ 2684.372116] RAID conf printout:
[ 2684.372117]  --- level:5 rd:4 wd:3
[ 2684.372117]  disk 0, o:1, dev:sde
[ 2684.372118]  disk 2, o:1, dev:sdb
[ 2684.372119]  disk 3, o:1, dev:sda
[ 2684.372149] md0: detected capacity change from 0 to 1500323119104
[ 2684.372426]  md0: unknown partition table
[ 2934.325679] SGI XFS with ACLs, security attributes, realtime, no=20
debug enabled
[ 3090.249640] XFS (md0): Mounting V4 Filesystem
[ 3090.403449] XFS (md0): Starting recovery (logdev: internal)
[ 3090.445679] XFS (md0): Ending recovery (logdev: internal)



cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sda[3] sdb[2] sde[0]
       1465159296 blocks level 5, 128k chunk, algorithm 2 [4/3] [U_UU]

unused devices: <none>



Here's the smart info


for /dev/sda :

smartctl 6.4 2015-06-04 r4109 [x86_64-linux-3.17.4-1-ARCH] (local build=
)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Blue (SATA)
Device Model:     WDC WD5000AAKS-00TMA0
Serial Number:    WD-WCAPW1796747
LU WWN Device Id: 5 0014ee 2003d9fca
=46irmware Version: 12.01C01
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA/ATAPI-7 (minor revision not indicated)
Local Time is:    Sun Jul 19 15:01:42 2015 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)    Offline data collection acti=
vity
                     was suspended by an interrupting command from host=
=2E
                     Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test=20
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:         (13200) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before ente=
ring
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 164) minutes.
Conveyance self-test routine
recommended polling time:      (   6) minutes.
SCT capabilities:            (0x303f)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED =20
WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail=20
Always       -       0
   3 Spin_Up_Time            0x0003   221   164   021    Pre-fail=20
Always       -       3950
   4 Start_Stop_Count        0x0032   100   100   000    Old_age=20
Always       -       350
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail=20
Always       -       0
   7 Seek_Error_Rate         0x000e   200   200   051    Old_age=20
Always       -       0
   9 Power_On_Hours          0x0032   024   024   000    Old_age=20
Always       -       55688
  10 Spin_Retry_Count        0x0012   100   100   051    Old_age=20
Always       -       0
  11 Calibration_Retry_Count 0x0012   100   100   051    Old_age=20
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age=20
Always       -       344
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age=20
Always       -       253
193 Load_Cycle_Count        0x0032   200   200   000    Old_age=20
Always       -       364
194 Temperature_Celsius     0x0022   117   089   000    Old_age=20
Always       -       33
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age=20
Always       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age=20
Always       -       0
198 Offline_Uncorrectable   0x0010   200   200   000    Old_age=20
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   195   000    Old_age=20
Always       -       12
200 Multi_Zone_Error_Rate   0x0008   200   189   051    Old_age=20
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
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
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.



for /dev/sdb :

smartctl 6.4 2015-06-04 r4109 [x86_64-linux-3.17.4-1-ARCH] (local build=
)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Blue (SATA)
Device Model:     WDC WD5000AAKS-00TMA0
Serial Number:    WD-WCAPW1120688
LU WWN Device Id: 5 0014ee 2aaddb938
=46irmware Version: 12.01C01
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA/ATAPI-7 (minor revision not indicated)
Local Time is:    Sun Jul 19 15:01:46 2015 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)    Offline data collection acti=
vity
                     was suspended by an interrupting command from host=
=2E
                     Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test=20
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:         (12600) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before ente=
ring
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 157) minutes.
Conveyance self-test routine
recommended polling time:      (   6) minutes.
SCT capabilities:            (0x303f)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED =20
WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail=20
Always       -       0
   3 Spin_Up_Time            0x0003   172   165   021    Pre-fail=20
Always       -       6383
   4 Start_Stop_Count        0x0032   100   100   000    Old_age=20
Always       -       346
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail=20
Always       -       0
   7 Seek_Error_Rate         0x000e   200   200   051    Old_age=20
Always       -       0
   9 Power_On_Hours          0x0032   025   025   000    Old_age=20
Always       -       55369
  10 Spin_Retry_Count        0x0012   100   100   051    Old_age=20
Always       -       0
  11 Calibration_Retry_Count 0x0012   100   100   051    Old_age=20
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age=20
Always       -       340
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age=20
Always       -       231
193 Load_Cycle_Count        0x0032   200   200   000    Old_age=20
Always       -       356
194 Temperature_Celsius     0x0022   119   085   000    Old_age=20
Always       -       31
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age=20
Always       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age=20
Always       -       0
198 Offline_Uncorrectable   0x0010   200   200   000    Old_age=20
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age=20
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   051    Old_age=20
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
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
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.



for /dev/sdd :

smartctl 6.4 2015-06-04 r4109 [x86_64-linux-3.17.4-1-ARCH] (local build=
)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Blue (SATA)
Device Model:     WDC WD5000AAKS-00TMA0
Serial Number:    WD-WCAPW1122956
LU WWN Device Id: 5 0014ee 200331314
=46irmware Version: 12.01C01
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA/ATAPI-7 (minor revision not indicated)
Local Time is:    Sun Jul 19 15:01:49 2015 EDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84)    Offline data collection acti=
vity
                     was suspended by an interrupting command from host=
=2E
                     Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test=20
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:         (12000) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before ente=
ring
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   2) minutes.
Extended self-test routine
recommended polling time:      ( 150) minutes.
Conveyance self-test routine
recommended polling time:      (   6) minutes.
SCT capabilities:            (0x303f)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED =20
WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   200   200   051    Pre-fail=20
Always       -       0
   3 Spin_Up_Time            0x0003   171   165   021    Pre-fail=20
Always       -       6425
   4 Start_Stop_Count        0x0032   100   100   000    Old_age=20
Always       -       482
   5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail=20
Always       -       0
   7 Seek_Error_Rate         0x000e   200   200   051    Old_age=20
Always       -       0
   9 Power_On_Hours          0x0032   022   022   000    Old_age=20
Always       -       57661
  10 Spin_Retry_Count        0x0012   100   100   051    Old_age=20
Always       -       0
  11 Calibration_Retry_Count 0x0012   100   100   051    Old_age=20
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   000    Old_age=20
Always       -       467
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age=20
Always       -       528
193 Load_Cycle_Count        0x0032   200   200   000    Old_age=20
Always       -       662
194 Temperature_Celsius     0x0022   118   086   000    Old_age=20
Always       -       32
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age=20
Always       -       0
197 Current_Pending_Sector  0x0012   200   200   000    Old_age=20
Always       -       0
198 Offline_Uncorrectable   0x0010   200   200   000    Old_age=20
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age=20
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   051    Old_age=20
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
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
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.



for /dev/sde :


smartctl 6.4 2015-06-04 r4109 [x86_64-linux-3.17.4-1-ARCH] (local build=
)
Copyright (C) 2002-15, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Seagate Barracuda 7200.12
Device Model:     ST3500418AS
Serial Number:    5VM49NSD
LU WWN Device Id: 5 000c50 01c4cf9ab
=46irmware Version: CC38
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS T13/1699-D revision 4
SATA Version is:  SATA 2.6, 3.0 Gb/s
Local Time is:    Sun Jul 19 15:01:53 2015 EDT

=3D=3D> WARNING: A firmware update for this drive may be available,
see the following Seagate web pages:
http://knowledge.seagate.com/articles/en_US/FAQ/207931en
http://knowledge.seagate.com/articles/en_US/FAQ/213891en

SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82)    Offline data collection acti=
vity
                     was completed without error.
                     Auto Offline Data Collection: Enabled.
Self-test execution status:      (   0)    The previous self-test=20
routine completed
                     without error or no self-test has ever
                     been run.
Total time to complete Offline
data collection:         (  600) seconds.
Offline data collection
capabilities:              (0x7b) SMART execute Offline immediate.
                     Auto Offline data collection on/off support.
                     Suspend Offline collection upon new
                     command.
                     Offline surface scan supported.
                     Self-test supported.
                     Conveyance Self-test supported.
                     Selective Self-test supported.
SMART capabilities:            (0x0003)    Saves SMART data before ente=
ring
                     power-saving mode.
                     Supports SMART auto save timer.
Error logging capability:        (0x01)    Error logging supported.
                     General Purpose Logging supported.
Short self-test routine
recommended polling time:      (   1) minutes.
Extended self-test routine
recommended polling time:      (  87) minutes.
Conveyance self-test routine
recommended polling time:      (   2) minutes.
SCT capabilities:            (0x103f)    SCT Status supported.
                     SCT Error Recovery Control supported.
                     SCT Feature Control supported.
                     SCT Data Table supported.

SMART Attributes Data Structure revision number: 10
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED =20
WHEN_FAILED RAW_VALUE
   1 Raw_Read_Error_Rate     0x000f   112   099   006    Pre-fail=20
Always       -       49016311
   3 Spin_Up_Time            0x0003   097   097   000    Pre-fail=20
Always       -       0
   4 Start_Stop_Count        0x0032   100   100   020    Old_age=20
Always       -       398
   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail=20
Always       -       0
   7 Seek_Error_Rate         0x000f   069   060   030    Pre-fail=20
Always       -       7542794
   9 Power_On_Hours          0x0032   047   047   000    Old_age=20
Always       -       46448
  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail=20
Always       -       0
  12 Power_Cycle_Count       0x0032   100   100   020    Old_age=20
Always       -       199
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age=20
Always       -       0
184 End-to-End_Error        0x0032   100   100   099    Old_age=20
Always       -       0
187 Reported_Uncorrect      0x0032   100   100   000    Old_age=20
Always       -       0
188 Command_Timeout         0x0032   100   100   000    Old_age=20
Always       -       0
189 High_Fly_Writes         0x003a   100   100   000    Old_age=20
Always       -       0
190 Airflow_Temperature_Cel 0x0022   064   059   045    Old_age=20
Always       -       36 (Min/Max 36/39)
194 Temperature_Celsius     0x0022   036   041   000    Old_age=20
Always       -       36 (0 17 0 0 0)
195 Hardware_ECC_Recovered  0x001a   016   015   000    Old_age=20
Always       -       49016311
197 Current_Pending_Sector  0x0012   100   100   000    Old_age=20
Always       -       0
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age=20
Offline      -       0
199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age=20
Always       -       0
240 Head_Flying_Hours       0x0000   100   253   000    Old_age=20
Offline      -       46876 (84 165 0)
241 Total_LBAs_Written      0x0000   100   253   000    Old_age=20
Offline      -       166857433
242 Total_LBAs_Read         0x0000   100   253   000    Old_age=20
Offline      -       3494978241

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
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
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.




I'm not sure what to think of this.  Which drive is really dead? Or wer=
e=20
they simply synched but still usable?

Let me know if more information could help you to help me :)


Thanks!




Le 2015-07-19 11:09, Rudy Zijlstra a =C3=A9crit :
> Hi Marc,
>
> On 19-07-15 16:26, Marc Desharnais wrote:
>> Hi,
>>
>> I'm new to this mailing list but I subscribed because of this proble=
m=20
>> with my raid5.
>> I really don't want to mess this up and it was clearly suggested to=20
>> not rush things on the wiki. So I'm looking for help :)
>> My raid has been running great for a long time now but I think it=20
>> needs so serious maintenance.
>> I have a 4 disks raid 5 on ArchLinux, mdadm version 3.3.1.
>>
>> First, the raid status :
>>
>> /dev/sda:
>>
>>    1     1       0        0        1      faulty removed
>>
>> /dev/sdb:
>>
>>    1     1       0        0        1      faulty removed
>>    3     3       0        0        3      faulty removed
>> /dev/sdd:
>>
>>       Number   Major   Minor   RaidDevice State
>> this     1       8       16        1      active sync   /dev/sdb
>>
>>    0     0       8       32        0      active sync   /dev/sdc
>>    1     1       8       16        1      active sync   /dev/sdb
>>    2     2       8       48        2      active sync   /dev/sdd
>>    3     3       8       64        3      active sync   /dev/sde
>> /dev/sde:
>>
>>
>>       Number   Major   Minor   RaidDevice State
>> this     0       8       64        0      active sync   /dev/sde
>>
>>    0     0       8       64        0      active sync   /dev/sde
>>    1     1       0        0        1      faulty removed
>>    2     2       8       16        2      active sync   /dev/sdb
>>    3     3       0        0        3      faulty removed
>>
>>
>>
>> Obvisously the event count is wrong on 2 disks. One disk has been=20
>> gone for a long time now...
>>
>> 1 - First question : how can I safely assemble the raid to the lates=
t=20
>> sync state? I don't want to mess this up.
>> 2 - Does this mean my hard drives are dead, or simply desync?
>>
>>
>> Also I tried to force assemble :
>>  mdadm --assemble --force /dev/md0 /dev/sda /dev/sdb /dev/sde
>>
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
> First:
> - what information is in dmesg or kern.log, or whererever your distro=
=20
> stores disk messages? Asking only for the relevant parts about the=20
> disks :)
> - Do  you have any idea when the disks were kicked out?
> - can you give the output of smartctl -a for each disk?
> - output of cat /proc/mdstat?
>
> The assemble you tried is probably failing because the raid is=20
> assembled but not started. Doing a "mdadm -S /dev/md0" should take=20
> care of that.
>
> Cheers
>
> Rudy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

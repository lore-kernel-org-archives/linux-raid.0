From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: HDD reports errors while completing RAID6 array check
Date: Fri, 10 Jun 2011 18:37:06 +0100
Message-ID: <BANLkTik87PZChAzgBnDM170uJHU=3Yc6Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi list,

When I run a check ( echo check > /sys/block/md0/md/sync_action ) on
my RAID6 array I see errors regarding ata4 in dmesg. When I check the
SMART data all appears to be fine, which is what confuses me. I saw
someone on the list posted a link to a blog post about Google's drive
failures and their analysis, and they concluded that many drives fail
without reporting any type of issue in the SMART table. Therefore I'm
wondering if what I'm seeing here could be an indicator of a pending
drive failure? (heh, aren't all drives pending failures...)

The array is healthy and working.

Here is the dmesg:

[774777.586500] md: data-check of RAID array md0
[774777.586510] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[774777.586516] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for data-check.
[774777.586537] md: using 128k window, over a total of 1950351360 block=
s.
[804382.162553] forcedeth 0000:00:0a.0: eth0: link down
[804382.181483] br0: port 2(eth0) entering forwarding state
[804384.461232] forcedeth 0000:00:0a.0: eth0: link up
[804384.462858] br0: port 2(eth0) entering learning state
[804384.462866] br0: port 2(eth0) entering learning state
[804399.492930] br0: port 2(eth0) entering forwarding state
[816754.318388] ata4.00: exception Emask 0x0 SAct 0x1fc1f SErr 0x0
action 0x6 frozen
[816754.318397] ata4.00: failed command: READ FPDMA QUEUED
[816754.318409] ata4.00: cmd 60/88:00:18:69:46/00:00:e5:00:00/40 tag 0
ncq 69632 in
[816754.318411]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[816754.318417] ata4.00: status: { DRDY }
[816754.318421] ata4.00: failed command: READ FPDMA QUEUED
[816754.318432] ata4.00: cmd 60/38:08:00:6b:46/00:00:e5:00:00/40 tag 1
ncq 28672 in
[816754.318434]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[816754.318439] ata4.00: status: { DRDY }
[816754.318444] ata4.00: failed command: READ FPDMA QUEUED
[816754.318454] ata4.00: cmd 60/b0:10:00:6c:46/00:00:e5:00:00/40 tag 2
ncq 90112 in
[816754.318457]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[816754.318462] ata4.00: status: { DRDY }
[816754.318466] ata4.00: failed command: READ FPDMA QUEUED
[816754.318476] ata4.00: cmd 60/18:18:00:6e:46/00:00:e5:00:00/40 tag 3
ncq 12288 in
[816754.318479]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[816754.318484] ata4.00: status: { DRDY }
[816754.318488] ata4.00: failed command: READ FPDMA QUEUED
[816754.318499] ata4.00: cmd 60/c8:20:00:6f:46/00:00:e5:00:00/40 tag 4
ncq 102400 in
[816754.318501]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[816754.318506] ata4.00: status: { DRDY }
[816754.318511] ata4.00: failed command: READ FPDMA QUEUED
[816754.318521] ata4.00: cmd 60/60:50:a0:69:46/00:00:e5:00:00/40 tag
10 ncq 49152 in
[816754.318524]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[816754.318529] ata4.00: status: { DRDY }
[816754.318533] ata4.00: failed command: READ FPDMA QUEUED
[816754.318543] ata4.00: cmd 60/00:58:00:6a:46/01:00:e5:00:00/40 tag
11 ncq 131072 in
[816754.318546]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[816754.318551] ata4.00: status: { DRDY }
[816754.318555] ata4.00: failed command: READ FPDMA QUEUED
[816754.318566] ata4.00: cmd 60/60:60:38:6b:46/00:00:e5:00:00/40 tag
12 ncq 49152 in
[816754.318568]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[816754.318573] ata4.00: status: { DRDY }
[816754.318577] ata4.00: failed command: READ FPDMA QUEUED
[816754.318588] ata4.00: cmd 60/68:68:98:6b:46/00:00:e5:00:00/40 tag
13 ncq 53248 in
[816754.318590]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[816754.318595] ata4.00: status: { DRDY }
[816754.318600] ata4.00: failed command: READ FPDMA QUEUED
[816754.318610] ata4.00: cmd 60/50:70:b0:6c:46/00:00:e5:00:00/40 tag
14 ncq 40960 in
[816754.318613]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[816754.318617] ata4.00: status: { DRDY }
[816754.318622] ata4.00: failed command: READ FPDMA QUEUED
[816754.318632] ata4.00: cmd 60/00:78:00:6d:46/01:00:e5:00:00/40 tag
15 ncq 131072 in
[816754.318635]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[816754.318640] ata4.00: status: { DRDY }
[816754.318644] ata4.00: failed command: READ FPDMA QUEUED
[816754.318654] ata4.00: cmd 60/e8:80:18:6e:46/00:00:e5:00:00/40 tag
16 ncq 118784 in
[816754.318657]          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask
0x4 (timeout)
[816754.318662] ata4.00: status: { DRDY }
[816754.318670] ata4: hard resetting link
[816754.638361] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[816754.645454] ata4.00: configured for UDMA/133
[816754.645466] ata4.00: device reported invalid CHS sector 0
[816754.645472] ata4.00: device reported invalid CHS sector 0
[816754.645477] ata4.00: device reported invalid CHS sector 0
[816754.645482] ata4.00: device reported invalid CHS sector 0
[816754.645488] ata4.00: device reported invalid CHS sector 0
[816754.645493] ata4.00: device reported invalid CHS sector 0
[816754.645498] ata4.00: device reported invalid CHS sector 0
[816754.645502] ata4.00: device reported invalid CHS sector 0
[816754.645507] ata4.00: device reported invalid CHS sector 0
[816754.645512] ata4.00: device reported invalid CHS sector 0
[816754.645516] ata4.00: device reported invalid CHS sector 0
[816754.645521] ata4.00: device reported invalid CHS sector 0
[816754.645555] ata4: EH complete
[817317.467510] md: md0: data-check done.

Here is mdadm -D /dev/md0:

$ mdadm -D /dev/md0
/dev/md0:
        Version : 1.2
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid6
     Array Size : 9751756800 (9300.00 GiB 9985.80 GB)
  Used Dev Size : 1950351360 (1860.00 GiB 1997.16 GB)
   Raid Devices : 7
  Total Devices : 7
    Persistence : Superblock is persistent

    Update Time : Fri Jun 10 18:30:56 2011
          State : clean
 Active Devices : 7
Working Devices : 7
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 64K

           Name : ion:0  (local to host ion)
           UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
         Events : 6158735

    Number   Major   Minor   RaidDevice State
       0       8       97        0      active sync   /dev/sdg1
       1       8       17        1      active sync   /dev/sdb1
       4       8       49        2      active sync   /dev/sdd1
       3       8       33        3      active sync   /dev/sdc1
       5       8       81        4      active sync   /dev/sdf1
       6       8      113        5      active sync   /dev/sdh1
       7       8       65        6      active sync   /dev/sde1

Below is the output of the lsdrv python script, ata4 mentioned in
dmesg should be sdd:

 $ sudo python2 lsdrv
PCI [ahci] 00:0b.0 SATA controller: nVidia Corporation MCP79 AHCI
Controller (rev b1)
 =E2=94=9C=E2=94=80scsi 0:0:0:0 ATA Corsair CSSD-F60 {10326505580009990=
027}
 =E2=94=82  =E2=94=94=E2=94=80sda: Partitioned (dos) 55.90g
 =E2=94=82     =E2=94=9C=E2=94=80sda1: (ext4) 100.00m 'ssd_boot' {ae879=
f86-73a4-451f-bb6b-e778ad1b57d6}
 =E2=94=82     =E2=94=82  =E2=94=94=E2=94=80Mounted as /dev/sda1 @ /boo=
t
 =E2=94=82     =E2=94=9C=E2=94=80sda2: (swap) 2.00g 'ssd_swap' {a28e32f=
a-628c-419a-9693-ca88166d230f}
 =E2=94=82     =E2=94=94=E2=94=80sda3: (ext4) 53.80g 'ssd_root' {6e812e=
d7-01c4-4a76-ae31-7b3d36d847f5}
 =E2=94=82        =E2=94=94=E2=94=80Mounted as /dev/disk/by-label/ssd_r=
oot @ /
 =E2=94=9C=E2=94=80scsi 1:0:0:0 ATA WDC WD20EARS-00M {WD-WCAZA1022443}
 =E2=94=82  =E2=94=94=E2=94=80sdb: Partitioned (dos) 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdb1: MD raid6 (1/7) 1.82t md0 clean i=
n_sync 'ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}
 =E2=94=82        =E2=94=94=E2=94=80md0: PV LVM2_member 9.08t/9.08t VG =
lvstorage 9.08t
{YLEUKB-klxF-X3gF-6dG3-DL4R-xebv-6gKQc2}
 =E2=94=82            =E2=94=94=E2=94=80Volume Group lvstorage (md0) 0 =
free {
Xd0HTM-azdN-v9kJ-C7vD-COcU-Cnn8-6AJ6hI}
 =E2=94=82              =E2=94=94=E2=94=80dm-0: (ext4) 9.08t 'storage'
{0ca82f13-680f-4b0d-a5d0-08c246a838e5}
 =E2=94=82                 =E2=94=94=E2=94=80Mounted as /dev/mapper/lvs=
torage-storage @ /raid6volume
 =E2=94=9C=E2=94=80scsi 2:0:0:0 ATA WDC WD20EARS-00M {WD-WMAZ20152590}
 =E2=94=82  =E2=94=94=E2=94=80sdc: Partitioned (dos) 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdc1: MD raid6 (3/7) 1.82t md0 clean i=
n_sync 'ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}
 =E2=94=9C=E2=94=80scsi 3:0:0:0 ATA WDC WD20EARS-00M {WD-WMAZ20188479}
 =E2=94=82  =E2=94=94=E2=94=80sdd: Partitioned (dos) 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdd1: MD raid6 (2/7) 1.82t md0 clean i=
n_sync 'ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}
 =E2=94=9C=E2=94=80scsi 4:x:x:x [Empty]
 =E2=94=94=E2=94=80scsi 5:x:x:x [Empty]
PCI [sata_mv] 05:00.0 SCSI storage controller: HighPoint Technologies,
Inc. RocketRAID 230x 4 Port SATA-II Controller (rev 02)
 =E2=94=9C=E2=94=80scsi 6:0:0:0 ATA WDC WD20EARS-00M {WD-WCAZA3609190}
 =E2=94=82  =E2=94=94=E2=94=80sde: Partitioned (dos) 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sde1: MD raid6 (6/7) 1.82t md0 clean i=
n_sync 'ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}
 =E2=94=9C=E2=94=80scsi 7:0:0:0 ATA SAMSUNG HD204UI {S2HGJ1RZ800964}
 =E2=94=82  =E2=94=94=E2=94=80sdf: Partitioned (dos) 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdf1: MD raid6 (4/7) 1.82t md0 clean i=
n_sync 'ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}
 =E2=94=9C=E2=94=80scsi 8:0:0:0 ATA WDC WD20EARS-00M {WD-WCAZA1000331}
 =E2=94=82  =E2=94=94=E2=94=80sdg: Partitioned (dos) 1.82t
 =E2=94=82     =E2=94=94=E2=94=80sdg1: MD raid6 (0/7) 1.82t md0 clean i=
n_sync 'ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}
 =E2=94=94=E2=94=80scsi 9:0:0:0 ATA SAMSUNG HD204UI {S2HGJ1RZ800850}
    =E2=94=94=E2=94=80sdh: Partitioned (dos) 1.82t
       =E2=94=94=E2=94=80sdh1: MD raid6 (5/7) 1.82t md0 clean in_sync '=
ion:0'
{e6595c64-b3ae-90b3-f011-33ac3f402d20}

Here's mdadm -E /dev/sdd1:

 $ sudo mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : e6595c64:b3ae90b3:f01133ac:3f402d20
           Name : ion:0  (local to host ion)
  Creation Time : Tue Oct 19 08:58:41 2010
     Raid Level : raid6
   Raid Devices : 7

 Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
     Array Size : 19503513600 (9300.00 GiB 9985.80 GB)
  Used Dev Size : 3900702720 (1860.00 GiB 1997.16 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : f9f0e2b3:ab659d71:66cfdb9d:2b87dcea

    Update Time : Fri Jun 10 18:33:55 2011
       Checksum : 6c60e800 - correct
         Events : 6158735

         Layout : left-symmetric
     Chunk Size : 64K

   Device Role : Active device 2
   Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

And finally the SMART status of sdd:

 $ sudo smartctl -a /dev/sdd
smartctl 5.40 2010-10-16 r3189 [x86_64-unknown-linux-gnu] (local build)
Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforge.=
net

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital Caviar Green (Adv. Format) family
Device Model:     WDC WD20EARS-00MVWB0
Serial Number:    WD-WMAZ20188479
=46irmware Version: 50.0AB50
User Capacity:    2,000,398,934,016 bytes
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  Exact ATA specification draft version not indicated
Local Time is:    Fri Jun 10 18:35:58 2011 IST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x82) Offline data collection activit=
y
                                        was completed without error.
                                        Auto Offline Data Collection: E=
nabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                 (36000) seconds.
Offline data collection
capabilities:                    (0x7b) SMART execute Offline immediate=
=2E
                                        Auto Offline data collection
on/off support.
                                        Suspend Offline collection upon=
 new
                                        command.
                                        Offline surface scan supported.
                                        Self-test supported.
                                        Conveyance Self-test supported.
                                        Selective Self-test supported.
SMART capabilities:            (0x0003) Saves SMART data before enterin=
g
                                        power-saving mode.
                                        Supports SMART auto save timer.
Error logging capability:        (0x01) Error logging supported.
                                        General Purpose Logging support=
ed.
Short self-test routine
recommended polling time:        (   2) minutes.
Extended self-test routine
recommended polling time:        ( 255) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x3035) SCT Status supported.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   176   162   021    Pre-fail
Always       -       6183
  4 Start_Stop_Count        0x0032   100   100   000    Old_age
Always       -       59
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   090   090   000    Old_age
Always       -       7781
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
Always       -       53
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       32
193 Load_Cycle_Count        0x0032   162   162   000    Old_age
Always       -       114636
194 Temperature_Celsius     0x0022   111   102   000    Old_age
Always       -       39
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       1

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%      6827   =
      -
# 2  Extended offline    Completed without error       00%      6550   =
      -
# 3  Extended offline    Completed without error       00%      6468   =
      -
# 4  Extended offline    Completed without error       00%      6329   =
      -
# 5  Extended offline    Completed without error       00%      6040   =
      -
# 6  Extended offline    Completed without error       00%      5584   =
      -
# 7  Extended offline    Completed without error       00%      5178   =
      -
# 8  Extended offline    Completed without error       00%      4761   =
      -
# 9  Short offline       Completed without error       00%      2285   =
      -
#10  Extended offline    Completed without error       00%      1514   =
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
If Selective self-test is pending on power-up, resume after 0 minute de=
lay.

Sure, the load_cycle_count is a tad high, but the drive is not new
either. Multi_Zone_Error_Rate is 1, but I'm not sure what that even
is, some vendors don't have this in their SMART table AFAIK.

If anyone could give me any clues that would be appreciated. Thanks!

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

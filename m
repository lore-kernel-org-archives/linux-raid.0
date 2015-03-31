From: Mark Knecht <markknecht@gmail.com>
Subject: Two system lockups, Magic SysKeys works, RAID6 resyncs on reboot
Date: Tue, 31 Mar 2015 08:00:27 -0700
Message-ID: <CAK2H+efDuxdjmWZiOiJw+EK3wohY6FxRWgsm8rJc1j1+fniWig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,
   In the past week, having moved from a gentoo-sources-3.14.34 kernel
to a gentoo-sources-3.18.10 kernel, I've had two full system lockups
on what has been a very stable, day-to-day machine I use for my
everyday work at home 7 days a week. I've run this machine in this
basic configuration for about 5 years without anything like this
happening. Two in a week is alarming. The Linux part of recovering
hasn't been a big problem but making sure my Win 7 VMs are OK takes
quite awhile. I was running 3 VMs at the time of this morning's
lockup, one of them being new yesterday so it wasn't involved in the
first lockup. The other two RAID1s on the system are not mounted or
effected by this event.

   I'm going to try to supply all the stuff I see asked for in most
threads like this. If I miss something please let me know. Attached
are the initramfs setup stuff, mdadm -D & mdadm -E outputs, smartctl
--all for all 5 drives, the output of lsdrv run as root and the
contents of /var/log/messages around the time of the reboot. (7AM)

 By my quick read I think the disks look OK but maybe someone with a
deeper skillset can double check that and point out anything I'm
missing. smartctl --long testing is run on each drive once a week
(probably overkill) and other than a couple of system shutdowns while
in progress the smartctl data looks OK to me.

   Backups are done every Sunday and the system is functional right
now (I'm writing this email) so I can do more
investigation/backups/study as needed. I don't think there's much
chance of anything really important being lost yet but I'd like to try
and understand what's causing this.

   The lockups seem to effect the apps but not the mouse or keyboard.
I can switch to the console and the machine responds to the magic
syskey sequence REISUB. When the machine reboots there's no obvious
problem however the main system drive, a 5-drive RAID6, is in the
process of resyncing by the time I log in and look around. The first
time this happened the resync completed with no problems and this one
is proceeding OK so far.

c2RAID6 ~ # eix mdadm
[I] sys-fs/mdadm
     Available versions:  3.2.6-r1^t 3.3.1-r2^t{tbz2} ~3.3.2^t {static}
     Installed versions:  3.3.1-r2^t{tbz2}(15:11:51 11/14/14)(static)
     Homepage:            http://neil.brown.name/blog/mdadm
     Description:         A useful tool for running RAID systems - it
can be used as a replacement for the raidtools

c2RAID6 ~ #

c2RAID6 ~ # cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid=
4]
md10 : active raid1 sda10[0] sdb10[1]
      1430135296 blocks super 1.2 [2/2] [UU]

md4 : active raid1 sdb3[1] sda3[0]
      524156736 blocks super 1.2 [2/2] [UU]

md3 : active raid6 sdc3[9] sdg3[5] sdf3[6] sde3[7] sdd3[8]
      1452264480 blocks super 1.2 level 6, 16k chunk, algorithm 2 [5/5]=
 [UUUUU]
      [=3D=3D=3D=3D>................]  resync =3D 22.8% (110608304/4840=
88160)
finish=3D78.5min speed=3D79206K/sec

unused devices: <none>
c2RAID6 ~ #


    Again, nothing appears lost at this time but if there's a way to
find out what's causing this I'd very much like to learn how to do
that.

Thanks,
Mark



1) The disk is assembled in my (by hand) initramfs which is built into
the kernel.

c2RAID6 ~ # cat /usr/src/initramfs_init_new.sh
#!/bin/busybox sh

rescue_shell() {
    echo "-----"
    echo "!!!!!"
    echo "Something went wrong."
    echo "Dropping into busybox"
    echo "!!!!!"
    echo "-----"
    busybox --install -s
    exec /bin/sh
}

/bin/busybox --install -s

# Mount the /proc and /sys filesystems.
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devtmpfs none /dev

# Do your stuff here.
echo "   "
echo "This init script assembles the RAID6 root as /dev/md3"
echo "mounts it as rootfs and, if there are no problems,"
echo "boots it up, else calls rescue_shell/busybox"
echo "   "

mdadm --assemble /dev/md3

# Mount the root filesystem.
mount -o ro /dev/md3 /realroot  || rescue_shell

# Clean up.
umount /dev
umount /proc
umount /sys

# Boot the real thing.
exec switch_root /realroot /sbin/init
c2RAID6 ~ #


c2RAID6 ~ # cat /usr/src/mdadm_initramfs.conf
ARRAY /dev/md/3 metadata=3D1.2 UUID=3Dde47f991:86d98467:0637635b:9c6d05=
91
ARRAY /dev/md/4 metadata=3D1.2 UUID=3Dc3e562a4:6871679e:2d83518e:fefd23=
7f
ARRAY /dev/md/10 metadata=3D1.2 UUID=3Dd9624704:b29e1a8e:148b47be:cabad=
736
c2RAID6 ~ #


c2RAID6 ~ # mdadm -D /dev/md3
/dev/md3:
        Version : 1.2
  Creation Time : Thu Dec 30 17:40:50 2010
     Raid Level : raid6
     Array Size : 1452264480 (1384.99 GiB 1487.12 GB)
  Used Dev Size : 484088160 (461.66 GiB 495.71 GB)
   Raid Devices : 5
  Total Devices : 5
    Persistence : Superblock is persistent

    Update Time : Tue Mar 31 07:11:01 2015
          State : active, resyncing
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0

         Layout : left-symmetric
     Chunk Size : 16K

  Resync Status : 15% complete

           Name : c2stable:3
           UUID : de47f991:86d98467:0637635b:9c6d0591
         Events : 38369

    Number   Major   Minor   RaidDevice State
       9       8       35        0      active sync   /dev/sdc3
       8       8       51        1      active sync   /dev/sdd3
       7       8       67        2      active sync   /dev/sde3
       6       8       83        3      active sync   /dev/sdf3
       5       8       99        4      active sync   /dev/sdg3
c2RAID6 ~ #


c2RAID6 ~ # mdadm -E /dev/sdc3
/dev/sdc3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : de47f991:86d98467:0637635b:9c6d0591
           Name : c2stable:3
  Creation Time : Thu Dec 30 17:40:50 2010
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 968176345 (461.66 GiB 495.71 GB)
     Array Size : 1452264480 (1384.99 GiB 1487.12 GB)
  Used Dev Size : 968176320 (461.66 GiB 495.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1968 sectors, after=3D25 sectors
          State : active
    Device UUID : da06e9db:a8a3dffe:feec1851:d0cbdde6

    Update Time : Tue Mar 31 07:26:02 2015
       Checksum : 909e27f6 - correct
         Events : 38372

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 0
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
c2RAID6 ~ #


c2RAID6 ~ # mdadm -E /dev/sdd3
/dev/sdd3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : de47f991:86d98467:0637635b:9c6d0591
           Name : c2stable:3
  Creation Time : Thu Dec 30 17:40:50 2010
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 968176345 (461.66 GiB 495.71 GB)
     Array Size : 1452264480 (1384.99 GiB 1487.12 GB)
  Used Dev Size : 968176320 (461.66 GiB 495.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1968 sectors, after=3D25 sectors
          State : active
    Device UUID : f3dd1d1e:8fb1a087:1060acfe:b8c9a537

    Update Time : Tue Mar 31 07:26:02 2015
       Checksum : 59ef7dee - correct
         Events : 38372

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 1
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
c2RAID6 ~ #


c2RAID6 ~ # mdadm -E /dev/sde3
/dev/sde3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : de47f991:86d98467:0637635b:9c6d0591
           Name : c2stable:3
  Creation Time : Thu Dec 30 17:40:50 2010
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 968176345 (461.66 GiB 495.71 GB)
     Array Size : 1452264480 (1384.99 GiB 1487.12 GB)
  Used Dev Size : 968176320 (461.66 GiB 495.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1968 sectors, after=3D25 sectors
          State : active
    Device UUID : 6bbd236b:77c22abc:da7c8fc2:e29e601e

    Update Time : Tue Mar 31 07:26:02 2015
       Checksum : 861d6041 - correct
         Events : 38372

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 2
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
c2RAID6 ~ #


c2RAID6 ~ # mdadm -E /dev/sdf3
/dev/sdf3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : de47f991:86d98467:0637635b:9c6d0591
           Name : c2stable:3
  Creation Time : Thu Dec 30 17:40:50 2010
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 968176345 (461.66 GiB 495.71 GB)
     Array Size : 1452264480 (1384.99 GiB 1487.12 GB)
  Used Dev Size : 968176320 (461.66 GiB 495.71 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1968 sectors, after=3D25 sectors
          State : active
    Device UUID : 8a361a4a:ac34f9cc:cee70fc3:5a8bed2f

    Update Time : Tue Mar 31 07:26:02 2015
       Checksum : 87efa300 - correct
         Events : 38372

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 3
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
c2RAID6 ~ #


c2RAID6 ~ # mdadm -E /dev/sdg3
/dev/sdg3:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : de47f991:86d98467:0637635b:9c6d0591
           Name : c2stable:3
  Creation Time : Thu Dec 30 17:40:50 2010
     Raid Level : raid6
   Raid Devices : 5

 Avail Dev Size : 968176320 (461.66 GiB 495.71 GB)
     Array Size : 1452264480 (1384.99 GiB 1487.12 GB)
    Data Offset : 1392 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D1312 sectors, after=3D0 sectors
          State : active
    Device UUID : c56ca951:928864db:c2746525:37716872

    Update Time : Tue Mar 31 07:26:02 2015
       Checksum : 42ba9d48 - correct
         Events : 38372

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 4
   Array State : AAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
c2RAID6 ~ #


c2RAID6 ~ # smartctl --all /dev/sdc
smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.18.10-gentoo] (local buil=
d)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE3 Serial ATA
Device Model:     WDC WD5002ABYS-02B1B0
Serial Number:    WD-WCASYA846988
LU WWN Device Id: 5 0014ee 2042c3477
=46irmware Version: 02.03B03
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.5, 3.0 Gb/s
Local Time is:    Tue Mar 31 07:30:21 2015 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activit=
y
                                        was suspended by an
interrupting command from host.
                                        Auto Offline Data Collection: E=
nabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                ( 9480) seconds.
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
recommended polling time:        ( 112) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x303f) SCT Status supported.
                                        SCT Error Recovery Control supp=
orted.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   239   229   021    Pre-fail
Always       -       1033
  4 Start_Stop_Count        0x0032   098   098   000    Old_age
Always       -       2477
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   075   075   000    Old_age
Always       -       18331
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   098   098   000    Old_age
Always       -       2474
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       48
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       2428
194 Temperature_Celsius     0x0022   092   080   000    Old_age
Always       -       55
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     18262   =
      -
# 2  Extended offline    Completed without error       00%     18180   =
      -
# 3  Extended offline    Completed without error       00%     18095   =
      -
# 4  Extended offline    Completed without error       00%     18011   =
      -
# 5  Extended offline    Completed without error       00%     17930   =
      -
# 6  Extended offline    Completed without error       00%     17848   =
      -
# 7  Extended offline    Completed without error       00%     17682   =
      -
# 8  Extended offline    Completed without error       00%     17592   =
      -
# 9  Extended offline    Completed without error       00%     17505   =
      -
#10  Extended offline    Completed without error       00%     17423   =
      -
#11  Extended offline    Completed without error       00%     17340   =
      -
#12  Extended offline    Completed without error       00%     17260   =
      -
#13  Extended offline    Completed without error       00%     17173   =
      -
#14  Extended offline    Completed without error       00%     17128   =
      -
#15  Extended offline    Completed without error       00%     17032   =
      -
#16  Extended offline    Completed without error       00%     16942   =
      -
#17  Extended offline    Completed without error       00%     16865   =
      -
#18  Extended offline    Completed without error       00%     16657   =
      -
#19  Extended offline    Completed without error       00%     16581   =
      -
#20  Extended offline    Completed without error       00%     16489   =
      -
#21  Extended offline    Interrupted (host reset)      30%     16397   =
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

c2RAID6 ~ #


c2RAID6 ~ # smartctl --all /dev/sdd
smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.18.10-gentoo] (local buil=
d)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE3 Serial ATA
Device Model:     WDC WD5002ABYS-02B1B0
Serial Number:    WD-WCASYA811977
LU WWN Device Id: 5 0014ee 2042c29e7
=46irmware Version: 02.03B03
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.5, 3.0 Gb/s
Local Time is:    Tue Mar 31 07:30:50 2015 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activit=
y
                                        was suspended by an
interrupting command from host.
                                        Auto Offline Data Collection: E=
nabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                ( 9480) seconds.
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
recommended polling time:        ( 112) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x303f) SCT Status supported.
                                        SCT Error Recovery Control supp=
orted.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   239   228   021    Pre-fail
Always       -       1033
  4 Start_Stop_Count        0x0032   098   098   000    Old_age
Always       -       2476
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   075   075   000    Old_age
Always       -       18330
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   098   098   000    Old_age
Always       -       2473
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       48
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       2427
194 Temperature_Celsius     0x0022   093   080   000    Old_age
Always       -       54
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     18272   =
      -
# 2  Extended offline    Completed without error       00%     18195   =
      -
# 3  Extended offline    Completed without error       00%     18109   =
      -
# 4  Extended offline    Completed without error       00%     18023   =
      -
# 5  Extended offline    Completed without error       00%     17940   =
      -
# 6  Extended offline    Completed without error       00%     17859   =
      -
# 7  Extended offline    Completed without error       00%     17779   =
      -
# 8  Extended offline    Completed without error       00%     17692   =
      -
# 9  Extended offline    Completed without error       00%     17606   =
      -
#10  Extended offline    Interrupted (host reset)      30%     17516   =
      -
#11  Extended offline    Completed without error       00%     17437   =
      -
#12  Extended offline    Completed without error       00%     17352   =
      -
#13  Extended offline    Completed without error       00%     17183   =
      -
#14  Extended offline    Completed without error       00%     17137   =
      -
#15  Extended offline    Completed without error       00%     17045   =
      -
#16  Extended offline    Completed without error       00%     16956   =
      -
#17  Extended offline    Completed without error       00%     16876   =
      -
#18  Extended offline    Completed without error       00%     16794   =
      -
#19  Extended offline    Completed without error       00%     16668   =
      -
#20  Extended offline    Completed without error       00%     16592   =
      -
#21  Extended offline    Completed without error       00%     16501   =
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

c2RAID6 ~ #


c2RAID6 ~ # smartctl --all /dev/sde
smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.18.10-gentoo] (local buil=
d)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE3 Serial ATA
Device Model:     WDC WD5002ABYS-02B1B0
Serial Number:    WD-WCASYA814051
LU WWN Device Id: 5 0014ee 259812251
=46irmware Version: 02.03B03
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.5, 3.0 Gb/s
Local Time is:    Tue Mar 31 07:31:19 2015 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activit=
y
                                        was suspended by an
interrupting command from host.
                                        Auto Offline Data Collection: E=
nabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                ( 9480) seconds.
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
recommended polling time:        ( 112) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x303f) SCT Status supported.
                                        SCT Error Recovery Control supp=
orted.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   239   229   021    Pre-fail
Always       -       1050
  4 Start_Stop_Count        0x0032   098   098   000    Old_age
Always       -       2476
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   075   075   000    Old_age
Always       -       18329
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   098   098   000    Old_age
Always       -       2473
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       47
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       2428
194 Temperature_Celsius     0x0022   095   084   000    Old_age
Always       -       52
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     18286   =
      -
# 2  Extended offline    Completed without error       00%     18206   =
      -
# 3  Extended offline    Completed without error       00%     18119   =
      -
# 4  Extended offline    Completed without error       00%     18034   =
      -
# 5  Extended offline    Completed without error       00%     17953   =
      -
# 6  Extended offline    Completed without error       00%     17871   =
      -
# 7  Extended offline    Completed without error       00%     17790   =
      -
# 8  Extended offline    Completed without error       00%     17706   =
      -
# 9  Extended offline    Completed without error       00%     17617   =
      -
#10  Extended offline    Completed without error       00%     17446   =
      -
#11  Extended offline    Completed without error       00%     17362   =
      -
#12  Extended offline    Completed without error       00%     17279   =
      -
#13  Extended offline    Completed without error       00%     17195   =
      -
#14  Extended offline    Completed without error       00%     17061   =
      -
#15  Extended offline    Completed without error       00%     16968   =
      -
#16  Extended offline    Completed without error       00%     16885   =
      -
#17  Extended offline    Completed without error       00%     16678   =
      -
#18  Extended offline    Completed without error       00%     16512   =
      -
#19  Extended offline    Completed without error       00%     16423   =
      -
#20  Extended offline    Interrupted (host reset)      40%     16342   =
      -
#21  Extended offline    Completed without error       00%     16265   =
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

c2RAID6 ~ #


c2RAID6 ~ # smartctl --all /dev/sdf
smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.18.10-gentoo] (local buil=
d)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE3 Serial ATA
Device Model:     WDC WD5002ABYS-02B1B0
Serial Number:    WD-WCASYA837674
LU WWN Device Id: 5 0014ee 2042bc993
=46irmware Version: 02.03B03
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.5, 3.0 Gb/s
Local Time is:    Tue Mar 31 07:31:53 2015 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activit=
y
                                        was suspended by an
interrupting command from host.
                                        Auto Offline Data Collection: E=
nabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                ( 9480) seconds.
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
recommended polling time:        ( 112) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x303f) SCT Status supported.
                                        SCT Error Recovery Control supp=
orted.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       1
  3 Spin_Up_Time            0x0027   239   229   021    Pre-fail
Always       -       1033
  4 Start_Stop_Count        0x0032   098   098   000    Old_age
Always       -       2465
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   076   076   000    Old_age
Always       -       18242
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   098   098   000    Old_age
Always       -       2461
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       62
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       2402
194 Temperature_Celsius     0x0022   094   083   000    Old_age
Always       -       53
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Interrupted (host reset)      10%     18135   =
      -
# 2  Extended offline    Completed without error       00%     18046   =
      -
# 3  Extended offline    Completed without error       00%     17962   =
      -
# 4  Extended offline    Completed without error       00%     17876   =
      -
# 5  Extended offline    Completed without error       00%     17719   =
      -
# 6  Extended offline    Completed without error       00%     17632   =
      -
# 7  Extended offline    Completed without error       00%     17541   =
      -
# 8  Extended offline    Completed without error       00%     17456   =
      -
# 9  Extended offline    Completed without error       00%     17372   =
      -
#10  Extended offline    Completed without error       00%     17291   =
      -
#11  Extended offline    Completed without error       00%     17204   =
      -
#12  Extended offline    Completed without error       00%     17124   =
      -
#13  Extended offline    Completed without error       00%     16991   =
      -
#14  Extended offline    Completed without error       00%     16896   =
      -
#15  Extended offline    Completed without error       00%     16808   =
      -
#16  Extended offline    Completed without error       00%     16727   =
      -
#17  Extended offline    Completed without error       00%     16646   =
      -
#18  Extended offline    Completed without error       00%     16608   =
      -
#19  Extended offline    Completed without error       00%     16526   =
      -
#20  Extended offline    Completed without error       00%     16440   =
      -
#21  Extended offline    Completed without error       00%     16350   =
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

c2RAID6 ~ #


c2RAID6 ~ # smartctl --all /dev/sdg
smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.18.10-gentoo] (local buil=
d)
Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE3 Serial ATA
Device Model:     WDC WD5002ABYS-02B1B0
Serial Number:    WD-WCASYA831311
LU WWN Device Id: 5 0014ee 259814854
=46irmware Version: 02.03B03
User Capacity:    500,107,862,016 bytes [500 GB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 2.5, 3.0 Gb/s
Local Time is:    Tue Mar 31 07:32:25 2015 PDT
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART overall-health self-assessment test result: PASSED

General SMART Values:
Offline data collection status:  (0x84) Offline data collection activit=
y
                                        was suspended by an
interrupting command from host.
                                        Auto Offline Data Collection: E=
nabled.
Self-test execution status:      (   0) The previous self-test routine =
completed
                                        without error or no self-test h=
as ever
                                        been run.
Total time to complete Offline
data collection:                ( 9480) seconds.
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
recommended polling time:        ( 112) minutes.
Conveyance self-test routine
recommended polling time:        (   5) minutes.
SCT capabilities:              (0x303f) SCT Status supported.
                                        SCT Error Recovery Control supp=
orted.
                                        SCT Feature Control supported.
                                        SCT Data Table supported.

SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
UPDATED  WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
Always       -       0
  3 Spin_Up_Time            0x0027   239   229   021    Pre-fail
Always       -       1050
  4 Start_Stop_Count        0x0032   098   098   000    Old_age
Always       -       2462
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
Always       -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age
Always       -       0
  9 Power_On_Hours          0x0032   076   076   000    Old_age
Always       -       18241
 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
Always       -       0
 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
Always       -       0
 12 Power_Cycle_Count       0x0032   098   098   000    Old_age
Always       -       2458
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
Always       -       49
193 Load_Cycle_Count        0x0032   200   200   000    Old_age
Always       -       2412
194 Temperature_Celsius     0x0022   093   084   000    Old_age
Always       -       54
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
Always       -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age
Always       -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age
Offline      -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
Always       -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age
Offline      -       0

SMART Error Log Version: 1
No Errors Logged

SMART Self-test log structure revision number 1
Num  Test_Description    Status                  Remaining
LifeTime(hours)  LBA_of_first_error
# 1  Extended offline    Completed without error       00%     18237   =
      -
# 2  Extended offline    Completed without error       00%     18160   =
      -
# 3  Extended offline    Completed without error       00%     18079   =
      -
# 4  Extended offline    Completed without error       00%     17993   =
      -
# 5  Extended offline    Completed without error       00%     17908   =
      -
# 6  Extended offline    Completed without error       00%     17828   =
      -
# 7  Extended offline    Completed without error       00%     17747   =
      -
# 8  Extended offline    Completed without error       00%     17667   =
      -
# 9  Extended offline    Completed without error       00%     17578   =
      -
#10  Extended offline    Completed without error       00%     17491   =
      -
#11  Extended offline    Completed without error       00%     17404   =
      -
#12  Extended offline    Completed without error       00%     17240   =
      -
#13  Extended offline    Completed without error       00%     17157   =
      -
#14  Extended offline    Completed without error       00%     17071   =
      -
#15  Extended offline    Completed without error       00%     17026   =
      -
#16  Extended offline    Completed without error       00%     16931   =
      -
#17  Extended offline    Completed without error       00%     16764   =
      -
#18  Extended offline    Completed without error       00%     16682   =
      -
#19  Extended offline    Completed without error       00%     16555   =
      -
#20  Extended offline    Interrupted (host reset)      40%     16475   =
      -
#21  Extended offline    Completed without error       00%     16388   =
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

c2RAID6 ~ #


c2RAID6 ~ # /home/mark/lsdrv
PCI [ahci] 03:00.0 SATA controller: Marvell Technology Group Ltd.
88SE9123 PCIe SATA 6.0 Gb/s controller (rev 11)
 =C3=A2=C3=A2scsi 0:0:0:0 ATA WDC WD30EFRX-68E {WD-WCC4N0990937}
 =C3=A2  =C3=A2=C3=A2sda: [8:0] Partitioned (gpt) 2.73t
 =C3=A2     =C3=A2=C3=A2sda1: [8:1] (ext2) 200.00m {c0e7f8e7-0871-4b07-=
80da-ed0fae480491}
 =C3=A2     =C3=A2=C3=A2sda2: [8:2] (swap) 6.00g {9f9d2c4a-6a47-481f-a5=
be-06b0bb8b0dca}
 =C3=A2     =C3=A2=C3=A2sda3: [8:3] MD raid1 (0/2) 500.00g md4 clean in=
_sync
'c2RAID6:4' {c3e562a4-6871-679e-2d83-518efefd237f}
 =C3=A2     =C3=A2  =C3=A2=C3=A2md4: [9:4] (ext4) 499.87g 'RAID1root'
{08d7f067-ec60-4d80-ab28-39b3eff5896b}
 =C3=A2     =C3=A2=C3=A2sda10: [8:10] MD raid1 (0/2) 1.33t md10 clean i=
n_sync
'c2RAID6:videoBack' {d9624704-b29e-1a8e-148b-47becabad736}
 =C3=A2        =C3=A2=C3=A2md10: [9:10] (ext4) 1.33t 'VideoLib'
{3b25ecce-99f2-4e60-87fa-3c69f3a8331e}
 =C3=A2=C3=A2scsi 1:0:0:0 ATA WDC WD30EFRX-68E {WD-WCC4N0959002}
 =C3=A2  =C3=A2=C3=A2sdb: [8:16] Partitioned (gpt) 2.73t
 =C3=A2     =C3=A2=C3=A2sdb1: [8:17] Empty/Unknown 200.00m
 =C3=A2     =C3=A2=C3=A2sdb2: [8:18] (swap) 6.00g {307ecb02-80cf-4ff3-8=
35b-a7b70a463282}
 =C3=A2     =C3=A2=C3=A2sdb3: [8:19] MD raid1 (1/2) 500.00g md4 clean i=
n_sync
'c2RAID6:4' {c3e562a4-6871-679e-2d83-518efefd237f}
 =C3=A2     =C3=A2=C3=A2sdb10: [8:26] MD raid1 (1/2) 1.33t md10 clean i=
n_sync
'c2RAID6:videoBack' {d9624704-b29e-1a8e-148b-47becabad736}
 =C3=A2=C3=A2scsi 2:x:x:x [Empty]
 =C3=A2=C3=A2scsi 3:x:x:x [Empty]
 =C3=A2=C3=A2scsi 4:x:x:x [Empty]
 =C3=A2=C3=A2scsi 5:x:x:x [Empty]
 =C3=A2=C3=A2scsi 6:x:x:x [Empty]
PCI [ahci] 06:00.0 SATA controller: JMicron Technology Corp. JMB363
SATA/IDE Controller (rev 03)
 =C3=A2=C3=A2scsi 8:x:x:x [Empty]
 =C3=A2=C3=A2scsi 9:x:x:x [Empty]
PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation 82801JI (ICH10
=46amily) 4 port SATA IDE Controller #1
 =C3=A2=C3=A2scsi 10:0:0:0 Optiarc DVD RW AD-7241S {Optiarc_DVD_RW_AD-7=
241S}
 =C3=A2  =C3=A2=C3=A2sr0: [11:0] Empty/Unknown 1.00g
 =C3=A2=C3=A2scsi 10:0:1:0 ATA WDC WD5002ABYS-0 {WD-WCASYA846988}
 =C3=A2  =C3=A2=C3=A2sdc: [8:32] Partitioned (dos) 465.76g
 =C3=A2     =C3=A2=C3=A2sdc1: [8:33] (ext2) 54.88m 'boot'
{4efd04f2-839f-4e11-a32d-8fa25129b541}
 =C3=A2     =C3=A2=C3=A2sdc2: [8:34] (swap) 4.01g 'swapA'
{ed41217e-abf4-4c60-a985-c0420eb054f3}
 =C3=A2     =C3=A2=C3=A2sdc3: [8:35] MD raid6 (0/5) 461.66g md3 active =
in_sync
'c2stable:3' {de47f991-86d9-8467-0637-635b9c6d0591}
 =C3=A2        =C3=A2=C3=A2md3: [9:3] (ext4) 1.35t 'RAID6root'
{80c3ebf0-d92f-415f-a6d7-1cdb1ceab593}
 =C3=A2           =C3=A2=C3=A2Mounted as /dev/md3 @ /
 =C3=A2=C3=A2scsi 11:0:0:0 ATA WDC WD5002ABYS-0 {WD-WCASYA811977}
 =C3=A2  =C3=A2=C3=A2sdd: [8:48] Partitioned (dos) 465.76g
 =C3=A2     =C3=A2=C3=A2sdd1: [8:49] (ext2) 54.88m {b9dd1fb9-5c7b-459c-=
a7fc-ca8ebe032fcc}
 =C3=A2     =C3=A2=C3=A2sdd2: [8:50] (swap) 4.01g 'swapB'
{2ea74bbb-8c1d-4a32-939d-512db4e40a54}
 =C3=A2     =C3=A2=C3=A2sdd3: [8:51] MD raid6 (1/5) 461.66g md3 active =
in_sync
'c2stable:3' {de47f991-86d9-8467-0637-635b9c6d0591}
 =C3=A2=C3=A2scsi 11:0:1:0 ATA WDC WD5002ABYS-0 {WD-WCASYA814051}
    =C3=A2=C3=A2sde: [8:64] Partitioned (dos) 465.76g
       =C3=A2=C3=A2sde1: [8:65] (ext2) 54.88m {27f276fa-6f62-4769-b9d7-=
deb511dfc60a}
       =C3=A2=C3=A2sde2: [8:66] (swap) 4.01g 'swapC'
{0c6a1bd0-291e-4157-9b6a-67f7801c7a5e}
       =C3=A2=C3=A2sde3: [8:67] MD raid6 (2/5) 461.66g md3 active in_sy=
nc
'c2stable:3' {de47f991-86d9-8467-0637-635b9c6d0591}
PCI [ata_piix] 00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10
=46amily) 2 port SATA IDE Controller #2
 =C3=A2=C3=A2scsi 12:0:0:0 ATA WDC WD5002ABYS-0 {WD-WCASYA837674}
 =C3=A2  =C3=A2=C3=A2sdf: [8:80] Partitioned (dos) 465.76g
 =C3=A2     =C3=A2=C3=A2sdf1: [8:81] Empty/Unknown 4.10g
 =C3=A2     =C3=A2=C3=A2sdf3: [8:83] MD raid6 (3/5) 461.66g md3 active =
in_sync
'c2stable:3' {de47f991-86d9-8467-0637-635b9c6d0591}
 =C3=A2=C3=A2scsi 13:0:0:0 ATA WDC WD5002ABYS-0 {WD-WCASYA831311}
    =C3=A2=C3=A2sdg: [8:96] Partitioned (dos) 465.76g
       =C3=A2=C3=A2sdg1: [8:97] (ext2) 4.10g {e7b2dbb0-df11-4bd4-902c-d=
a2221b53e88}
       =C3=A2=C3=A2sdg3: [8:99] MD raid6 (4/5) 461.66g md3 active in_sy=
nc
'c2stable:3' {de47f991-86d9-8467-0637-635b9c6d0591}
Other Block Devices
 =C3=A2=C3=A2ram0: [1:0] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram1: [1:1] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram2: [1:2] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram3: [1:3] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram4: [1:4] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram5: [1:5] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram6: [1:6] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram7: [1:7] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram8: [1:8] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram9: [1:9] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram10: [1:10] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram11: [1:11] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram12: [1:12] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram13: [1:13] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram14: [1:14] Empty/Unknown 16.00m
 =C3=A2=C3=A2ram15: [1:15] Empty/Unknown 16.00m
c2RAID6 ~ #




Mar 31 06:19:23 c2RAID6 kdm[2588]: :0[2588]:
pam_ck_connector(kde:session): nox11 mode, ignoring PAM_TTY :0
Mar 31 06:19:32 c2RAID6 dbus[2273]: [system] Activating service
name=3D'org.freedesktop.UPower' (using servicehelper)
Mar 31 06:19:32 c2RAID6 dbus[2273]: [system] Successfully activated
service 'org.freedesktop.UPower'
Mar 31 06:19:32 c2RAID6 dbus[2273]: [system] Activating service
name=3D'org.freedesktop.UDisks2' (using servicehelper)
Mar 31 06:19:33 c2RAID6 udisksd[3062]: udisks daemon version 2.1.3 star=
ting
Mar 31 06:19:33 c2RAID6 dbus[2273]: [system] Successfully activated
service 'org.freedesktop.UDisks2'
Mar 31 06:19:33 c2RAID6 udisksd[3062]: Acquired the name
org.freedesktop.UDisks2 on the system message bus
Mar 31 06:19:33 c2RAID6 dbus[2273]: [system] Activating service
name=3D'org.kde.powerdevil.backlighthelper' (using servicehelper)
Mar 31 06:19:33 c2RAID6 dbus[2273]: [system] Successfully activated
service 'org.kde.powerdevil.backlighthelper'
Mar 31 06:19:47 c2RAID6 polkitd[2954]: Registered Authentication Agent
for unix-session:/org/freedesktop/ConsoleKit/Session1 (system bus name
:1.19 [/usr/lib64/kde4/libexec/polkit-kde-authentication-agent-1],
object path /org/kde/PolicyKit1/AuthenticationAgent, locale
en_US.UTF-8)
Mar 31 06:19:59 c2RAID6 kernel: capability: warning: `VirtualBox' uses
32-bit capabilities (legacy support in use)
Mar 31 06:20:01 c2RAID6 cron[3442]: (root) CMD (test -x
/usr/sbin/run-crons && /usr/sbin/run-crons)
Mar 31 06:20:01 c2RAID6 cron[3441]: (root) CMD (updatedb)
Mar 31 06:20:08 c2RAID6 kernel: device eth0 entered promiscuous mode
Mar 31 06:30:01 c2RAID6 cron[5497]: (root) CMD (test -x
/usr/sbin/run-crons && /usr/sbin/run-crons)
Mar 31 06:40:01 c2RAID6 cron[5911]: (root) CMD (test -x
/usr/sbin/run-crons && /usr/sbin/run-crons)
Mar 31 06:50:01 c2RAID6 cron[7406]: (root) CMD (test -x
/usr/sbin/run-crons && /usr/sbin/run-crons)
Mar 31 07:01:14 c2RAID6 syslog-ng[2227]: syslog-ng starting up; version=
=3D'3.6.2'
Mar 31 07:01:14 c2RAID6 acpid[2247]: starting up with netlink and the
input layer
Mar 31 07:01:14 c2RAID6 acpid[2247]: 1 rule loaded
Mar 31 07:01:14 c2RAID6 acpid[2247]: waiting for events: event logging =
is off
Mar 31 07:01:16 c2RAID6 kernel: sky2 0000:07:00.0 eth0: enabling interf=
ace
Mar 31 07:01:18 c2RAID6 kernel: sky2 0000:07:00.0 eth0: Link is up at
100 Mbps, full duplex, flow control both
Mar 31 07:01:19 c2RAID6 kernel: nvidia 0000:02:00.0: irq 37 for MSI/MSI=
-X
Mar 31 07:01:20 c2RAID6 kernel: nvidia 0000:04:00.0: irq 38 for MSI/MSI=
-X
Mar 31 07:01:19 c2RAID6 acpid[2247]: client connected from 2479[0:0]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

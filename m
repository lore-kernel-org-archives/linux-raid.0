From: Jun-Kai Teoh <kai.teoh@gmail.com>
Subject: `Raid 5 array down/missing - went through wiki steps
Date: Thu, 9 Nov 2017 08:51:59 -0800
Message-ID: <AD1A4E1D-3326-4468-8020-25ECCAC3606A@gmail.com>
References: <CAA4aoFardnK8fOck4kkCWeYNZc=8-03FJzn6KxS6K9wuYN5bdg@mail.gmail.com>
 <e917e077-a87e-5322-68dd-e25b53bf7678@youngman.org.uk>
 <CAA4aoFatrJQFPHOUm9C6LjUAeNkSE9eH08T8xphuYNPErVg=QQ@mail.gmail.com>
 <59F51E3C.1050509@youngman.org.uk>
 <CAA4aoFb-QoHoL0ucTPXiCJMPXfxTtXOF51UjzRC+ViLHEvkW1g@mail.gmail.com>
 <CAK2H+efxSWfJ9ehoOr-tRazDNMzhR=ZdsfRS1z4dziDz23kf0A@mail.gmail.com>
 <F9CBFCC4-8A09-4022-BB2D-73A62750ADB0@gmail.com>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F9CBFCC4-8A09-4022-BB2D-73A62750ADB0@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

Bump?

Kai Teoh

> On Nov 6, 2017, at 9:10 AM, Jun-Kai Teoh <kai.teoh@gmail.com> wrote:
>=20
> Hi all,
>=20
> Soft bumping this thread again. My raid array is still down, and I =
haven't touched anything. I'll briefly run through the basics:
>=20
> - 7x4TB raid 5 array
> - One of the 4TB drives dropped (according to the pros here, I was =
unaware of it because I didn't have a monitor set up)
> - I added another 4TB drive, making it an 8x4TB array
> - Partway during reshaping, machine lost power.=20
> - Brought machine back, tried to bring array up, it doesn't work and =
says 6 drives, 1 rebuilding
> - /dev/sda is the drive that was dropped
>=20
> *the mdadm config also changed from md126 to md127, and the new one =
looks way too little. mdadm config shows md127, but mdadm -D shows =
md126.
>=20
> Below are all the stuff I provided the last time since I think it =
might be buried now.=20
>=20
> In order of appearance
> 1. mdadm version
> 2. kernel
> 3. distro
> 4. mdadm -E=20
> 5. mdadm -D
> 6. SMART info
>=20
> --------
> mdadm version (mdadm --version)
> mdadm - v3.3 - 3rd September 2013
> --------
>=20
> --------
> kernel (uname -mrsn)
> Linux livingrm-server 4.4.0-97-generic x86_64
> --------
>=20
> --------
> distro
> Ubuntu 16.04 LTS
> --------
>=20
> /dev/sda:
>         Magic : a92b4efc
>       Version : 1.2
>   Feature Map : 0x1
>    Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
>          Name : livingrm-server:2  (local to host livingrm-server)
> Creation Time : Thu Jun 30 07:57:36 2016
>    Raid Level : raid5
>  Raid Devices : 7
>=20
> Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>    Array Size : 23441323008 (22355.39 GiB 24003.91 GB)
> Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
>   Data Offset : 262144 sectors
>  Super Offset : 8 sectors
>  Unused Space : before=3D262056 sectors, after=3D688 sectors
>         State : clean
>   Device UUID : 9c14bcb8:be8310f5:5b50c3a7:e6e57423
>=20
> Internal Bitmap : 8 sectors from superblock
>   Update Time : Sun Jan 15 08:09:15 2017
> Bad Block Log : 512 entries available at offset 72 sectors
>      Checksum : 13425c44 - correct
>        Events : 5667
>=20
>        Layout : left-symmetric
>    Chunk Size : 512K
>=20
>  Device Role : Active device 2
>  Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> /dev/sdb:
>         Magic : a92b4efc
>       Version : 1.2
>   Feature Map : 0x45
>    Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
>          Name : livingrm-server:2  (local to host livingrm-server)
> Creation Time : Thu Jun 30 07:57:36 2016
>    Raid Level : raid5
>  Raid Devices : 8
>=20
> Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>    Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
> Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
>   Data Offset : 262144 sectors
>    New Offset : 254976 sectors
>  Super Offset : 8 sectors
>         State : active
>   Device UUID : 15d85573:6e78f040:8c028ef3:d1301f9d
>=20
> Internal Bitmap : 8 sectors from superblock
> Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
> Delta Devices : 1 (7->8)
>=20
>   Update Time : Fri Oct 27 19:46:43 2017
> Bad Block Log : 512 entries available at offset 72 sectors
>      Checksum : e568d9d9 - correct
>        Events : 650554
>=20
>        Layout : left-symmetric
>    Chunk Size : 512K
>=20
>  Device Role : Active device 3
>  Array State : AAAAAAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> /dev/sdc:
>         Magic : a92b4efc
>       Version : 1.2
>   Feature Map : 0x45
>    Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
>          Name : livingrm-server:2  (local to host livingrm-server)
> Creation Time : Thu Jun 30 07:57:36 2016
>    Raid Level : raid5
>  Raid Devices : 8
>=20
> Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>    Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
> Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
>   Data Offset : 262144 sectors
>    New Offset : 254976 sectors
>  Super Offset : 8 sectors
>         State : clean
>   Device UUID : 64d5961e:230e558c:3748b561:a7c6ab8c
>=20
> Internal Bitmap : 8 sectors from superblock
> Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
> Delta Devices : 1 (7->8)
>=20
>   Update Time : Fri Oct 27 19:46:43 2017
> Bad Block Log : 512 entries available at offset 72 sectors
>      Checksum : 39c2485b - correct
>        Events : 650554
>=20
>        Layout : left-symmetric
>    Chunk Size : 512K
>=20
>  Device Role : Active device 0
>  Array State : AAAAAAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> /dev/sde:
>         Magic : a92b4efc
>       Version : 1.2
>   Feature Map : 0x45
>    Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
>          Name : livingrm-server:2  (local to host livingrm-server)
> Creation Time : Thu Jun 30 07:57:36 2016
>    Raid Level : raid5
>  Raid Devices : 8
>=20
> Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>    Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
> Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
>   Data Offset : 262144 sectors
>    New Offset : 254976 sectors
>  Super Offset : 8 sectors
>         State : active
>   Device UUID : 2df0b319:bdb18eee:27b318ec:da55d53d
>=20
> Internal Bitmap : 8 sectors from superblock
> Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
> Delta Devices : 1 (7->8)
>=20
>   Update Time : Fri Oct 27 19:46:43 2017
> Bad Block Log : 512 entries available at offset 72 sectors
>      Checksum : d2a600e7 - correct
>        Events : 650554
>=20
>        Layout : left-symmetric
>    Chunk Size : 512K
>=20
>  Device Role : Active device 6
>  Array State : AAAAAAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> /dev/sdf:
>         Magic : a92b4efc
>       Version : 1.2
>   Feature Map : 0x45
>    Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
>          Name : livingrm-server:2  (local to host livingrm-server)
> Creation Time : Thu Jun 30 07:57:36 2016
>    Raid Level : raid5
>  Raid Devices : 8
>=20
> Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>    Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
> Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
>   Data Offset : 262144 sectors
>    New Offset : 254976 sectors
>  Super Offset : 8 sectors
>         State : active
>   Device UUID : f1a790a9:98e01257:d9ab257d:95c8f1fc
>=20
> Internal Bitmap : 8 sectors from superblock
> Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
> Delta Devices : 1 (7->8)
>=20
>   Update Time : Fri Oct 27 19:46:43 2017
> Bad Block Log : 512 entries available at offset 72 sectors
>      Checksum : 1b3052f2 - correct
>        Events : 650554
>=20
>        Layout : left-symmetric
>    Chunk Size : 512K
>=20
>  Device Role : Active device 4
>  Array State : AAAAAAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> /dev/sdg:
>         Magic : a92b4efc
>       Version : 1.2
>   Feature Map : 0x45
>    Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
>          Name : livingrm-server:2  (local to host livingrm-server)
> Creation Time : Thu Jun 30 07:57:36 2016
>    Raid Level : raid5
>  Raid Devices : 8
>=20
> Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>    Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
> Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
>   Data Offset : 262144 sectors
>    New Offset : 254976 sectors
>  Super Offset : 8 sectors
>         State : active
>   Device UUID : 6f44eba1:29d246a4:c5e8312e:bac00a7b
>=20
> Internal Bitmap : 8 sectors from superblock
> Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
> Delta Devices : 1 (7->8)
>=20
>   Update Time : Fri Oct 27 19:46:43 2017
> Bad Block Log : 512 entries available at offset 72 sectors
>      Checksum : 8fe4160e - correct
>        Events : 650554
>=20
>        Layout : left-symmetric
>    Chunk Size : 512K
>=20
>  Device Role : Active device 1
>  Array State : AAAAAAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> /dev/sdh:
>         Magic : a92b4efc
>       Version : 1.2
>   Feature Map : 0x47
>    Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
>          Name : livingrm-server:2  (local to host livingrm-server)
> Creation Time : Thu Jun 30 07:57:36 2016
>    Raid Level : raid5
>  Raid Devices : 8
>=20
> Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>    Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
> Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
>   Data Offset : 262144 sectors
>    New Offset : 254976 sectors
>  Super Offset : 8 sectors
> Recovery Offset : 11264816 sectors
>         State : active
>   Device UUID : 109b7a2f:0529794c:2cf95cc1:d6c0bd6b
>=20
> Internal Bitmap : 8 sectors from superblock
> Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
> Delta Devices : 1 (7->8)
>=20
>   Update Time : Fri Oct 27 19:46:43 2017
> Bad Block Log : 512 entries available at offset 72 sectors
>      Checksum : 4a2fb746 - correct
>        Events : 650554
>=20
>        Layout : left-symmetric
>    Chunk Size : 512K
>=20
>  Device Role : Active device 2
>  Array State : AAAAAAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
> /dev/sdi:
>         Magic : a92b4efc
>       Version : 1.2
>   Feature Map : 0x45
>    Array UUID : f7333d4f:8300969d:55148d64:93c8afc8
>          Name : livingrm-server:2  (local to host livingrm-server)
> Creation Time : Thu Jun 30 07:57:36 2016
>    Raid Level : raid5
>  Raid Devices : 8
>=20
> Avail Dev Size : 7813775024 (3725.90 GiB 4000.65 GB)
>    Array Size : 27348210176 (26081.29 GiB 28004.57 GB)
> Used Dev Size : 7813774336 (3725.90 GiB 4000.65 GB)
>   Data Offset : 262144 sectors
>    New Offset : 254976 sectors
>  Super Offset : 8 sectors
>         State : active
>   Device UUID : deb04cea:d6530966:6c70ca90:bebb143e
>=20
> Internal Bitmap : 8 sectors from superblock
> Reshape pos'n : 39348736 (37.53 GiB 40.29 GB)
> Delta Devices : 1 (7->8)
>=20
>   Update Time : Fri Oct 27 19:46:43 2017
> Bad Block Log : 512 entries available at offset 72 sectors
>      Checksum : bfaa86d9 - correct
>        Events : 650554
>=20
>        Layout : left-symmetric
>    Chunk Size : 512K
>=20
>  Device Role : Active device 5
>  Array State : AAAAAAA. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D=
 replacing)
>=20
>=20
> --------
> /dev/md126:
>       Version :
>    Raid Level : raid0
> Total Devices : 0
>=20
>         State : inactive
>=20
>   Number   Major   Minor   RaidDevice
> --------
>=20
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Western Digital Red
> Device Model:     WDC WD40EFRX-68WT0N0
> Serial Number:    WD-WCC4E6CUCC3R
> LU WWN Device Id: 5 0014ee 2b69e1ff1
> Firmware Version: 82.00A82
> User Capacity:    4,000,787,030,016 bytes [4.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2 (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Sat Oct 28 12:34:44 2017 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>=20
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>=20
> General SMART Values:
> Offline data collection status:  (0x00) Offline data collection =
activity
> was never started.
> Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0) The previous self-test routine =
completed
> without error or no self-test has ever
> been run.
> Total time to complete Offline
> data collection: (50580) seconds.
> Offline data collection
> capabilities: (0x7b) SMART execute Offline immediate.
> Auto Offline data collection on/off support.
> Suspend Offline collection upon new
> command.
> Offline surface scan supported.
> Self-test supported.
> Conveyance Self-test supported.
> Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before =
entering
> power-saving mode.
> Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
> General Purpose Logging supported.
> Short self-test routine
> recommended polling time: (   2) minutes.
> Extended self-test routine
> recommended polling time: ( 506) minutes.
> Conveyance self-test routine
> recommended polling time: (   5) minutes.
> SCT capabilities:        (0x703d) SCT Status supported.
> SCT Error Recovery Control supported.
> SCT Feature Control supported.
> SCT Data Table supported.
>=20
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
> 1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       0
> 3 Spin_Up_Time            0x0027   223   182   021    Pre-fail
> Always       -       5850
> 4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       212
> 5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
> 7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> Always       -       0
> 9 Power_On_Hours          0x0032   076   076   000    Old_age
> Always       -       17743
> 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
> Always       -       0
> 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
> Always       -       0
> 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       212
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       121
> 193 Load_Cycle_Count        0x0032   192   192   000    Old_age
> Always       -       25990
> 194 Temperature_Celsius     0x0022   120   092   000    Old_age
> Always       -       32
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   199   129   000    Old_age
> Always       -       421
> 200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
> Offline      -       0
>=20
> SMART Error Log Version: 1
> No Errors Logged
>=20
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
>=20
> SMART Selective self-test log data structure revision number 1
> SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>   1        0        0  Not_testing
>   2        0        0  Not_testing
>   3        0        0  Not_testing
>   4        0        0  Not_testing
>   5        0        0  Not_testing
> Selective self-test flags (0x0):
> After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute =
delay.
>=20
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-97-generic] (local =
build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, =
www.smartmontools.org
>=20
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Western Digital Red
> Device Model:     WDC WD40EFRX-68WT0N0
> Serial Number:    WD-WCC4E4K2JPZT
> LU WWN Device Id: 5 0014ee 2b510b64f
> Firmware Version: 80.00A80
> User Capacity:    4,000,787,030,016 bytes [4.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2 (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Sat Oct 28 12:35:00 2017 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>=20
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>=20
> General SMART Values:
> Offline data collection status:  (0x00) Offline data collection =
activity
> was never started.
> Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0) The previous self-test routine =
completed
> without error or no self-test has ever
> been run.
> Total time to complete Offline
> data collection: (52320) seconds.
> Offline data collection
> capabilities: (0x7b) SMART execute Offline immediate.
> Auto Offline data collection on/off support.
> Suspend Offline collection upon new
> command.
> Offline surface scan supported.
> Self-test supported.
> Conveyance Self-test supported.
> Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before =
entering
> power-saving mode.
> Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
> General Purpose Logging supported.
> Short self-test routine
> recommended polling time: (   2) minutes.
> Extended self-test routine
> recommended polling time: ( 523) minutes.
> Conveyance self-test routine
> recommended polling time: (   5) minutes.
> SCT capabilities:        (0x703d) SCT Status supported.
> SCT Error Recovery Control supported.
> SCT Feature Control supported.
> SCT Data Table supported.
>=20
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
> 1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       0
> 3 Spin_Up_Time            0x0027   222   179   021    Pre-fail
> Always       -       5891
> 4 Start_Stop_Count        0x0032   098   098   000    Old_age
> Always       -       2624
> 5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
> 7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> Always       -       0
> 9 Power_On_Hours          0x0032   064   064   000    Old_age
> Always       -       26647
> 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
> Always       -       0
> 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
> Always       -       0
> 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       310
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       184
> 193 Load_Cycle_Count        0x0032   188   188   000    Old_age
> Always       -       38893
> 194 Temperature_Celsius     0x0022   120   092   000    Old_age
> Always       -       32
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   192   000    Old_age
> Always       -       14
> 200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
> Offline      -       0
>=20
> SMART Error Log Version: 1
> No Errors Logged
>=20
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
>=20
> SMART Selective self-test log data structure revision number 1
> SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>   1        0        0  Not_testing
>   2        0        0  Not_testing
>   3        0        0  Not_testing
>   4        0        0  Not_testing
>   5        0        0  Not_testing
> Selective self-test flags (0x0):
> After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute =
delay.
>=20
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-97-generic] (local =
build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, =
www.smartmontools.org
>=20
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Western Digital Red
> Device Model:     WDC WD40EFRX-68WT0N0
> Serial Number:    WD-WCC4E4VTX9TP
> LU WWN Device Id: 5 0014ee 261485dc4
> Firmware Version: 82.00A82
> User Capacity:    4,000,787,030,016 bytes [4.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2 (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Sat Oct 28 12:35:03 2017 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>=20
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>=20
> General SMART Values:
> Offline data collection status:  (0x00) Offline data collection =
activity
> was never started.
> Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0) The previous self-test routine =
completed
> without error or no self-test has ever
> been run.
> Total time to complete Offline
> data collection: (54780) seconds.
> Offline data collection
> capabilities: (0x7b) SMART execute Offline immediate.
> Auto Offline data collection on/off support.
> Suspend Offline collection upon new
> command.
> Offline surface scan supported.
> Self-test supported.
> Conveyance Self-test supported.
> Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before =
entering
> power-saving mode.
> Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
> General Purpose Logging supported.
> Short self-test routine
> recommended polling time: (   2) minutes.
> Extended self-test routine
> recommended polling time: ( 548) minutes.
> Conveyance self-test routine
> recommended polling time: (   5) minutes.
> SCT capabilities:        (0x703d) SCT Status supported.
> SCT Error Recovery Control supported.
> SCT Feature Control supported.
> SCT Data Table supported.
>=20
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
> 1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       0
> 3 Spin_Up_Time            0x0027   222   181   021    Pre-fail
> Always       -       5866
> 4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       210
> 5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
> 7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> Always       -       0
> 9 Power_On_Hours          0x0032   076   076   000    Old_age
> Always       -       17748
> 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
> Always       -       0
> 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
> Always       -       0
> 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       210
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       121
> 193 Load_Cycle_Count        0x0032   189   189   000    Old_age
> Always       -       33283
> 194 Temperature_Celsius     0x0022   120   092   000    Old_age
> Always       -       32
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
> Offline      -       0
>=20
> SMART Error Log Version: 1
> No Errors Logged
>=20
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
>=20
> SMART Selective self-test log data structure revision number 1
> SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>   1        0        0  Not_testing
>   2        0        0  Not_testing
>   3        0        0  Not_testing
>   4        0        0  Not_testing
>   5        0        0  Not_testing
> Selective self-test flags (0x0):
> After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute =
delay.
>=20
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-97-generic] (local =
build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, =
www.smartmontools.org
>=20
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Western Digital Red
> Device Model:     WDC WD40EFRX-68WT0N0
> Serial Number:    WD-WCC4E2VKP3SV
> LU WWN Device Id: 5 0014ee 2620754c8
> Firmware Version: 82.00A82
> User Capacity:    4,000,787,030,016 bytes [4.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2 (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
> Local Time is:    Sat Oct 28 12:35:06 2017 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>=20
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>=20
> General SMART Values:
> Offline data collection status:  (0x00) Offline data collection =
activity
> was never started.
> Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0) The previous self-test routine =
completed
> without error or no self-test has ever
> been run.
> Total time to complete Offline
> data collection: (51120) seconds.
> Offline data collection
> capabilities: (0x7b) SMART execute Offline immediate.
> Auto Offline data collection on/off support.
> Suspend Offline collection upon new
> command.
> Offline surface scan supported.
> Self-test supported.
> Conveyance Self-test supported.
> Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before =
entering
> power-saving mode.
> Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
> General Purpose Logging supported.
> Short self-test routine
> recommended polling time: (   2) minutes.
> Extended self-test routine
> recommended polling time: ( 512) minutes.
> Conveyance self-test routine
> recommended polling time: (   5) minutes.
> SCT capabilities:        (0x703d) SCT Status supported.
> SCT Error Recovery Control supported.
> SCT Feature Control supported.
> SCT Data Table supported.
>=20
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
> 1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       0
> 3 Spin_Up_Time            0x0027   223   183   021    Pre-fail
> Always       -       5825
> 4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       180
> 5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
> 7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> Always       -       0
> 9 Power_On_Hours          0x0032   083   083   000    Old_age
> Always       -       12934
> 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
> Always       -       0
> 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
> Always       -       0
> 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       180
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       112
> 193 Load_Cycle_Count        0x0032   192   192   000    Old_age
> Always       -       26411
> 194 Temperature_Celsius     0x0022   120   101   000    Old_age
> Always       -       32
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
> Offline      -       0
>=20
> SMART Error Log Version: 1
> No Errors Logged
>=20
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
>=20
> SMART Selective self-test log data structure revision number 1
> SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>   1        0        0  Not_testing
>   2        0        0  Not_testing
>   3        0        0  Not_testing
>   4        0        0  Not_testing
>   5        0        0  Not_testing
> Selective self-test flags (0x0):
> After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute =
delay.
>=20
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-97-generic] (local =
build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, =
www.smartmontools.org
>=20
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Western Digital Red
> Device Model:     WDC WD40EFRX-68WT0N0
> Serial Number:    WD-WCC4E4JNHEC6
> LU WWN Device Id: 5 0014ee 2614842c3
> Firmware Version: 82.00A82
> User Capacity:    4,000,787,030,016 bytes [4.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2 (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
> Local Time is:    Sat Oct 28 12:35:10 2017 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>=20
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>=20
> General SMART Values:
> Offline data collection status:  (0x00) Offline data collection =
activity
> was never started.
> Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0) The previous self-test routine =
completed
> without error or no self-test has ever
> been run.
> Total time to complete Offline
> data collection: (53940) seconds.
> Offline data collection
> capabilities: (0x7b) SMART execute Offline immediate.
> Auto Offline data collection on/off support.
> Suspend Offline collection upon new
> command.
> Offline surface scan supported.
> Self-test supported.
> Conveyance Self-test supported.
> Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before =
entering
> power-saving mode.
> Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
> General Purpose Logging supported.
> Short self-test routine
> recommended polling time: (   2) minutes.
> Extended self-test routine
> recommended polling time: ( 539) minutes.
> Conveyance self-test routine
> recommended polling time: (   5) minutes.
> SCT capabilities:        (0x703d) SCT Status supported.
> SCT Error Recovery Control supported.
> SCT Feature Control supported.
> SCT Data Table supported.
>=20
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
> 1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       0
> 3 Spin_Up_Time            0x0027   222   180   021    Pre-fail
> Always       -       5875
> 4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       212
> 5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
> 7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> Always       -       0
> 9 Power_On_Hours          0x0032   076   076   000    Old_age
> Always       -       17748
> 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
> Always       -       0
> 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
> Always       -       0
> 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       212
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       127
> 193 Load_Cycle_Count        0x0032   190   190   000    Old_age
> Always       -       32835
> 194 Temperature_Celsius     0x0022   120   092   000    Old_age
> Always       -       32
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
> Offline      -       0
>=20
> SMART Error Log Version: 1
> No Errors Logged
>=20
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
>=20
> SMART Selective self-test log data structure revision number 1
> SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>   1        0        0  Not_testing
>   2        0        0  Not_testing
>   3        0        0  Not_testing
>   4        0        0  Not_testing
>   5        0        0  Not_testing
> Selective self-test flags (0x0):
> After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute =
delay.
>=20
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-97-generic] (local =
build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, =
www.smartmontools.org
>=20
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Western Digital Red
> Device Model:     WDC WD40EFRX-68WT0N0
> Serial Number:    WD-WCC4E2ZYE8AN
> LU WWN Device Id: 5 0014ee 20bf26ce9
> Firmware Version: 82.00A82
> User Capacity:    4,000,787,030,016 bytes [4.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2 (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
> Local Time is:    Sat Oct 28 12:35:13 2017 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>=20
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>=20
> General SMART Values:
> Offline data collection status:  (0x00) Offline data collection =
activity
> was never started.
> Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0) The previous self-test routine =
completed
> without error or no self-test has ever
> been run.
> Total time to complete Offline
> data collection: (54960) seconds.
> Offline data collection
> capabilities: (0x7b) SMART execute Offline immediate.
> Auto Offline data collection on/off support.
> Suspend Offline collection upon new
> command.
> Offline surface scan supported.
> Self-test supported.
> Conveyance Self-test supported.
> Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before =
entering
> power-saving mode.
> Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
> General Purpose Logging supported.
> Short self-test routine
> recommended polling time: (   2) minutes.
> Extended self-test routine
> recommended polling time: ( 550) minutes.
> Conveyance self-test routine
> recommended polling time: (   5) minutes.
> SCT capabilities:        (0x703d) SCT Status supported.
> SCT Error Recovery Control supported.
> SCT Feature Control supported.
> SCT Data Table supported.
>=20
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
> 1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       0
> 3 Spin_Up_Time            0x0027   219   178   021    Pre-fail
> Always       -       6016
> 4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       212
> 5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
> 7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> Always       -       0
> 9 Power_On_Hours          0x0032   076   076   000    Old_age
> Always       -       17751
> 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
> Always       -       0
> 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
> Always       -       0
> 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       212
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       120
> 193 Load_Cycle_Count        0x0032   189   189   000    Old_age
> Always       -       33470
> 194 Temperature_Celsius     0x0022   120   098   000    Old_age
> Always       -       32
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
> Offline      -       0
>=20
> SMART Error Log Version: 1
> No Errors Logged
>=20
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
>=20
> SMART Selective self-test log data structure revision number 1
> SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>   1        0        0  Not_testing
>   2        0        0  Not_testing
>   3        0        0  Not_testing
>   4        0        0  Not_testing
>   5        0        0  Not_testing
> Selective self-test flags (0x0):
> After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute =
delay.
>=20
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-97-generic] (local =
build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, =
www.smartmontools.org
>=20
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Western Digital Red
> Device Model:     WDC WD40EFRX-68N32N0
> Serial Number:    WD-WCC7K7PZ7R6Z
> LU WWN Device Id: 5 0014ee 26410129e
> Firmware Version: 82.00A82
> User Capacity:    4,000,787,030,016 bytes [4.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Form Factor:      3.5 inches
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-3 T13/2161-D revision 5
> SATA Version is:  SATA 3.1, 6.0 Gb/s (current: 1.5 Gb/s)
> Local Time is:    Sat Oct 28 12:35:16 2017 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>=20
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>=20
> General SMART Values:
> Offline data collection status:  (0x00) Offline data collection =
activity
> was never started.
> Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0) The previous self-test routine =
completed
> without error or no self-test has ever
> been run.
> Total time to complete Offline
> data collection: (46440) seconds.
> Offline data collection
> capabilities: (0x7b) SMART execute Offline immediate.
> Auto Offline data collection on/off support.
> Suspend Offline collection upon new
> command.
> Offline surface scan supported.
> Self-test supported.
> Conveyance Self-test supported.
> Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before =
entering
> power-saving mode.
> Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
> General Purpose Logging supported.
> Short self-test routine
> recommended polling time: (   2) minutes.
> Extended self-test routine
> recommended polling time: ( 492) minutes.
> Conveyance self-test routine
> recommended polling time: (   5) minutes.
> SCT capabilities:        (0x303d) SCT Status supported.
> SCT Error Recovery Control supported.
> SCT Feature Control supported.
> SCT Data Table supported.
>=20
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
> 1 Raw_Read_Error_Rate     0x002f   100   253   051    Pre-fail
> Always       -       0
> 3 Spin_Up_Time            0x0027   100   253   021    Pre-fail
> Always       -       0
> 4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       3
> 5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
> 7 Seek_Error_Rate         0x002e   100   253   000    Old_age
> Always       -       0
> 9 Power_On_Hours          0x0032   100   100   000    Old_age
> Always       -       11
> 10 Spin_Retry_Count        0x0032   100   253   000    Old_age
> Always       -       0
> 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age
> Always       -       0
> 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       3
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       1
> 193 Load_Cycle_Count        0x0032   200   200   000    Old_age
> Always       -       3
> 194 Temperature_Celsius     0x0022   121   117   000    Old_age
> Always       -       29
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
> Offline      -       0
>=20
> SMART Error Log Version: 1
> No Errors Logged
>=20
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
>=20
> SMART Selective self-test log data structure revision number 1
> SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>   1        0        0  Not_testing
>   2        0        0  Not_testing
>   3        0        0  Not_testing
>   4        0        0  Not_testing
>   5        0        0  Not_testing
> Selective self-test flags (0x0):
> After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute =
delay.
>=20
> smartctl 6.5 2016-01-24 r4214 [x86_64-linux-4.4.0-97-generic] (local =
build)
> Copyright (C) 2002-16, Bruce Allen, Christian Franke, =
www.smartmontools.org
>=20
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Western Digital Red
> Device Model:     WDC WD40EFRX-68WT0N0
> Serial Number:    WD-WCC4E4JNHKL9
> LU WWN Device Id: 5 0014ee 2b69e186b
> Firmware Version: 82.00A82
> User Capacity:    4,000,787,030,016 bytes [4.00 TB]
> Sector Sizes:     512 bytes logical, 4096 bytes physical
> Rotation Rate:    5400 rpm
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ACS-2 (minor revision not indicated)
> SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 1.5 Gb/s)
> Local Time is:    Sat Oct 28 12:35:19 2017 PDT
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>=20
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
>=20
> General SMART Values:
> Offline data collection status:  (0x00) Offline data collection =
activity
> was never started.
> Auto Offline Data Collection: Disabled.
> Self-test execution status:      (   0) The previous self-test routine =
completed
> without error or no self-test has ever
> been run.
> Total time to complete Offline
> data collection: (55260) seconds.
> Offline data collection
> capabilities: (0x7b) SMART execute Offline immediate.
> Auto Offline data collection on/off support.
> Suspend Offline collection upon new
> command.
> Offline surface scan supported.
> Self-test supported.
> Conveyance Self-test supported.
> Selective Self-test supported.
> SMART capabilities:            (0x0003) Saves SMART data before =
entering
> power-saving mode.
> Supports SMART auto save timer.
> Error logging capability:        (0x01) Error logging supported.
> General Purpose Logging supported.
> Short self-test routine
> recommended polling time: (   2) minutes.
> Extended self-test routine
> recommended polling time: ( 552) minutes.
> Conveyance self-test routine
> recommended polling time: (   5) minutes.
> SCT capabilities:        (0x703d) SCT Status supported.
> SCT Error Recovery Control supported.
> SCT Feature Control supported.
> SCT Data Table supported.
>=20
> SMART Attributes Data Structure revision number: 16
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE
> UPDATED  WHEN_FAILED RAW_VALUE
> 1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail
> Always       -       1
> 3 Spin_Up_Time            0x0027   220   180   021    Pre-fail
> Always       -       5958
> 4 Start_Stop_Count        0x0032   100   100   000    Old_age
> Always       -       673
> 5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail
> Always       -       0
> 7 Seek_Error_Rate         0x002e   200   200   000    Old_age
> Always       -       0
> 9 Power_On_Hours          0x0032   075   075   000    Old_age
> Always       -       18933
> 10 Spin_Retry_Count        0x0032   100   100   000    Old_age
> Always       -       0
> 11 Calibration_Retry_Count 0x0032   100   100   000    Old_age
> Always       -       0
> 12 Power_Cycle_Count       0x0032   100   100   000    Old_age
> Always       -       261
> 192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age
> Always       -       162
> 193 Load_Cycle_Count        0x0032   189   189   000    Old_age
> Always       -       35904
> 194 Temperature_Celsius     0x0022   119   091   000    Old_age
> Always       -       33
> 196 Reallocated_Event_Count 0x0032   200   200   000    Old_age
> Always       -       0
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0030   100   253   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0008   100   253   000    Old_age
> Offline      -       0
>=20
> SMART Error Log Version: 1
> No Errors Logged
>=20
> SMART Self-test log structure revision number 1
> No self-tests have been logged.  [To run self-tests, use: smartctl -t]
>=20
> SMART Selective self-test log data structure revision number 1
> SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>   1        0        0  Not_testing
>   2        0        0  Not_testing
>   3        0        0  Not_testing
>   4        0        0  Not_testing
>   5        0        0  Not_testing
> Selective self-test flags (0x0):
> After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute =
delay.
>=20
> Kai Teoh
>=20
>=20
>> On Oct 30, 2017, at 11:18 AM, Mark Knecht <markknecht@gmail.com> =
wrote:
>>=20
>> On Mon, Oct 30, 2017 at 11:08 AM, Jun-Kai Teoh <kai.teoh@gmail.com> =
wrote:
>>> Thanks for all the responses, Mark, Anthony and Wol.
>>>=20
>>> I have another hard drive on the way, just in case sda is truly =
dead.
>>> I had no idea that when a drive "dies" in a RAID5 array - nothing
>>> would notify me. I obviously have much to learn, really appreciate =
all
>>> the input from folks so far.
>>>=20
>>> I think I've provided the details of my setup (kernel, mdadm ver,
>>> distro, smartctl output, and mdadm -E output) - do let me know if =
I've
>>> left anything out. Left the machine alone this weekend and did not =
do
>>> anything with it.
>>>=20
>>> Kai Teoh
>>>=20
>>=20
>> Kai Teoh,
>>  I don't think it's fair to say 'nothing will warn you' as there are =
ways to
>> get messages about this stuff. More fair to say that different =
distros will
>> better automate some of this stuff but it's always up to the sys =
admin to
>> ensure the system does what you want.
>>=20
>>  Someone will likely give you input in the next day or two. Give =
folks
>> a chance to catch up.
>>=20
>> Good luck,
>> Mark
>=20


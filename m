From: Thomas MARCHESSEAU <marchesseau@gmail.com>
Subject: Re: RAID 5 "magicaly" become a RAID0
Date: Mon, 13 Apr 2015 10:55:27 +0200
Message-ID: <D15148A7.3B83B%marchesseau@gmail.com>
References: <D150B36B.8EE37%marchesseau@gmail.com>
 <552B0B58.8050102@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <552B0B58.8050102@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Roger Heflin <rogerheflin@gmail.com>, Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

Hi all,=20

Thanks a lot for your time. I appreciate .

Immediate Feedback  (with jet lag :) -

Roger, =20
	I=E2=80=99ve already forced the =E2=80=94- assemble, just forget to wr=
ite it  , no more
	mdadm  --assemble --force  /dev/md127 /dev/sdb /dev/sdc /dev/sdd /dev/=
sde
 /dev/sdf /dev/sdg /dev/sdh
	mdadm: /dev/md127 assembled from 5 drives - not enough to start the ar=
ray.
=20
	I=E2=80=99ll move to raid6 , that was my 1st choice, but i didn=E2=80=99=
t build it

Phil,
	Md0 ..  I got the point,  I will use it again to avoid mistakes


=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=20
OUTPUT of : or x in /dev/sd[b-h] ; do mdadm -E $x ; smartctl -iA -l sct=
erc
$x ; done > report.txt
/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
           Name : Cerebro:0  (local to host Cerebro)
  Creation Time : Sat Feb  7 23:02:47 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720300544 (11177.35 GiB 12001.59 GB)
  Used Dev Size : 3906766848 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          State : clean
    Device UUID : 3c496797:3cf85a2f:295fbd9b:2e077213

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 12 06:10:59 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 15dbf80e - correct
         Events : 21958

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 5
   Array State : AAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-34-generic] (local
build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE4 (SATA 6Gb/s)
Device Model:     WDC WD2000FYYZ-01UL1B1
Serial Number:    WD-WCC1P1091161
LU WWN Device Id: 5 0014ee 25ee4fcd6
=46irmware Version: 01.01K02
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Mon Apr 13 10:03:15 2015 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Disabled

SMART Disabled. Use option -s with argument 'on' to enable it.
(override with '-T permissive' option)
--------------------------------------------------------------

/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
           Name : Cerebro:0  (local to host Cerebro)
  Creation Time : Sat Feb  7 23:02:47 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720300544 (11177.35 GiB 12001.59 GB)
  Used Dev Size : 3906766848 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          State : clean
    Device UUID : 8df5ff53:7e7b70cd:8f4f00f1:62d06766

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 12 06:10:59 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 18c2e134 - correct
         Events : 21958

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 0
   Array State : AAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-34-generic] (local
build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE4 (SATA 6Gb/s)
Device Model:     WDC WD2000FYYZ-01UL1B1
Serial Number:    WD-WCC1P1097832
LU WWN Device Id: 5 0014ee 2b4399815
=46irmware Version: 01.01K02
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Apr 13 10:03:15 2015 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Disabled

SMART Disabled. Use option -s with argument 'on' to enable it.
(override with '-T permissive' option)
--------------------------------------------------------------



/dev/sdd:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
           Name : Cerebro:0  (local to host Cerebro)
  Creation Time : Sat Feb  7 23:02:47 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720300544 (11177.35 GiB 12001.59 GB)
  Used Dev Size : 3906766848 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          State : clean
    Device UUID : ce00382c:1af27788:009df454:44e23f65

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 12 06:10:59 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : ecec264 - correct
         Events : 21958

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-34-generic] (local
build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE4 (SATA 6Gb/s)
Device Model:     WDC WD2000FYYZ-01UL1B1
Serial Number:    WD-WCC1P1097658
LU WWN Device Id: 5 0014ee 2098fea8e
=46irmware Version: 01.01K02
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Apr 13 10:03:16 2015 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Disabled

SMART Disabled. Use option -s with argument 'on' to enable it.
(override with '-T permissive' option)
--------------------------------------------------------------


/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
           Name : Cerebro:0  (local to host Cerebro)
  Creation Time : Sat Feb  7 23:02:47 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720300544 (11177.35 GiB 12001.59 GB)
  Used Dev Size : 3906766848 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          State : clean
    Device UUID : c31958a3:769ae8c1:c610013a:8ac4ced9

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 12 06:10:59 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 18fad9c3 - correct
         Events : 21958

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-34-generic] (local
build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE4 (SATA 6Gb/s)
Device Model:     WDC WD2000FYYZ-01UL1B1
Serial Number:    WD-WCC1P1111248
LU WWN Device Id: 5 0014ee 2b43abede
=46irmware Version: 01.01K02
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Apr 13 10:03:16 2015 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s
    -       0
  3 Spin_Up_Time            0x0027   174   169   021    Pre-fail  Alway=
s
    -       6266
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s
    -       45
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s
    -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Alway=
s
    -       0
  9 Power_On_Hours          0x0032   089   089   000    Old_age   Alway=
s
    -       8298
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s
    -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s
    -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s
    -       43
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Alway=
s
    -       0
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s
    -       30
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s
    -       14
194 Temperature_Celsius     0x0022   101   092   000    Old_age   Alway=
s
    -       49
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s
    -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s
    -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne
    -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s
    -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne
    -       0


SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)
--------------------------------------------------------------


/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
           Name : Cerebro:0  (local to host Cerebro)
  Creation Time : Sat Feb  7 23:02:47 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720300544 (11177.35 GiB 12001.59 GB)
  Used Dev Size : 3906766848 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          State : clean
    Device UUID : 486831b4:ce34ac6f:c5f43616:8042099d

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 12 06:10:59 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 77082495 - correct
         Events : 21958

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-34-generic] (local
build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE4 (SATA 6Gb/s)
Device Model:     WDC WD2000FYYZ-01UL1B1
Serial Number:    WD-WCC1P1107956
LU WWN Device Id: 5 0014ee 2b4399801
=46irmware Version: 01.01K02
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Apr 13 10:03:16 2015 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s
    -       0
  3 Spin_Up_Time            0x0027   178   173   021    Pre-fail  Alway=
s
    -       6058
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s
    -       43
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s
    -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Alway=
s
    -       0
  9 Power_On_Hours          0x0032   089   089   000    Old_age   Alway=
s
    -       8297
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s
    -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s
    -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s
    -       42
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Alway=
s
    -       0
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s
    -       29
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s
    -       13
194 Temperature_Celsius     0x0022   103   094   000    Old_age   Alway=
s
    -       47
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s
    -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s
    -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne
    -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s
    -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne
    -       0

SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)
--------------------------------------------------------------


/dev/sdg:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
           Name : Cerebro:0  (local to host Cerebro)
  Creation Time : Sat Feb  7 23:02:47 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720300544 (11177.35 GiB 12001.59 GB)
  Used Dev Size : 3906766848 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          State : clean
    Device UUID : fd209577:7efc364a:aae51364:230eefcd

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 12 06:09:14 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 93c0611b - correct
         Events : 21954

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 4
   Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-34-generic] (local
build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE4 (SATA 6Gb/s)
Device Model:     WDC WD2000FYYZ-01UL1B1
Serial Number:    WD-WCC1P1164520
LU WWN Device Id: 5 0014ee 2b4562c3e
=46irmware Version: 01.01K02
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Apr 13 10:03:16 2015 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s
    -       0
  3 Spin_Up_Time            0x0027   170   165   021    Pre-fail  Alway=
s
    -       6466
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s
    -       43
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s
    -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Alway=
s
    -       0
  9 Power_On_Hours          0x0032   089   089   000    Old_age   Alway=
s
    -       8298
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s
    -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s
    -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s
    -       42
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Alway=
s
    -       0
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s
    -       29
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s
    -       13
194 Temperature_Celsius     0x0022   105   092   000    Old_age   Alway=
s
    -       45
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s
    -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s
    -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne
    -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s
    -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne
    -       0


SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)
--------------------------------------------------------------


/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
           Name : Cerebro:0  (local to host Cerebro)
  Creation Time : Sat Feb  7 23:02:47 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720300544 (11177.35 GiB 12001.59 GB)
  Used Dev Size : 3906766848 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          State : clean
    Device UUID : b1146034:7d8ab0e5:3c975a91:8f786829

Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 12 06:09:14 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 74c4fecf - correct
         Events : 21954

         Layout : left-symmetric
     Chunk Size : 512K

   Device Role : Active device 6
   Array State : AAAAAAA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-34-generic] (local
build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE4 (SATA 6Gb/s)
Device Model:     WDC WD2000FYYZ-01UL1B1
Serial Number:    WD-WCC1P1154279
LU WWN Device Id: 5 0014ee 25f0218e4
=46irmware Version: 01.01K02
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Apr 13 10:03:16 2015 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s
    -       0
  3 Spin_Up_Time            0x0027   170   170   021    Pre-fail  Alway=
s
    -       6491
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s
    -       18
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s
    -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s
    -       0
  9 Power_On_Hours          0x0032   098   098   000    Old_age   Alway=
s
    -       1534
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s
    -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s
    -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s
    -       18
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Alway=
s
    -       0
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s
    -       12
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s
    -       5
194 Temperature_Celsius     0x0022   106   100   000    Old_age   Alway=
s
    -       44
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s
    -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s
    -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne
    -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s
    -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne
    -       0


SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)
--------------------------------------------------------------




Regards,
Thomas


















Le 13/04/15 02:18, =C2=AB Phil Turmel =C2=BB <philip@turmel.org> a =C3=A9=
crit :

>Hi Thomas,
>
>On 04/12/2015 05:42 PM, Thomas MARCHESSEAU wrote:
>> Hi team ,
>>=20
>> Like probably lot of  new subscriber , i mail you, guys,  for help .
>>=20
>> I=C2=B9m running a raid5 on 7 HDD for several month now ( and years =
on other
>> system) without problem .
>> last week i had a crash disk (sdg)  , i=C2=B9ve add a new drive (sdi=
)  and
>> rebuild ..  Works fine , and i dont think this is the cause of my to=
day
>> problem.
>
>Agreed.  Probably not related.
>
>> Yesterday , i=C2=B9v upgraded my ubuntu 14.10 , and the system warm =
me with a
>> message that i can=C2=B9t recall and rewrite exactly , but something=
 like :
>> md127 doesn=C2=B9t not match with /etc/mdadm/mdadm.conf ,  blah blah=
 , run
>> /usr/share/mdadm/mkconf , and fix /etc/mdadm/mdadm.conf
>>=20
>> i=C2=B9ve done it , and reboot , all looks good .
>> All the drive have been rename after reboot ( orginal sdg was extrac=
t
>>form
>> the bay ) =20
>
>Yes, you cannot trust drives to keep their names through upgrades.  Th=
e
>names are pseudo-random during boot.
>
>You should know that md127 is the default name chosen by mdadm when
>assembling an array for which it doesn't know any other name.  Followe=
d
>by md126, then md125 and so on.  You really should give your arrays
>other names.  Most commonly starting with md0 or md1.
>
>> I=C2=B9ve setup a rsync of my most important data on a external driv=
e this
>> night, who partially failed  (only 25% ha been backuped , bad luck )=
  ,
>> (probably) because  this morning  i have re-inserted by mistake the
>>faulty
>> drive ( for information , i think the drive was in fact ok , the sat=
a
>> connector was a bit disconnect )
>>=20
>> I did not pay attention of the situation at the moment , but few hou=
r
>> later , i ssh my filer and my =C2=AB home =C2=BB  (on the raid parti=
tion) was not
>> available anymore .
>
>You should collect your 'dmesg' and post it here.  Or cut and paste fr=
om
>it anything related to your drives or array.
>
>> I didn=C2=B9t try to fschk or any thing else than :
>>=20
>> Mdadm =E2=80=B9stop /dev/md127
>> mdadm --assemble /dev/md127 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev=
/sdf
>> /dev/sdg /dev/sdh
>> mdadm: /dev/md127 assembled from 5 drives - not enough to start the
>>array.
>>=20
>>=20
>> So i=C2=B9ve read a bunch of usefull link , one of them :) ,
>> https://raid.wiki.kernel.org/index.php/RAID_Recovery  , says , don=C2=
=B9t do
>> stupid thing until drop a mail on linux-raid mailling =C5=A0 so i=C2=
=B9m here  .
>>=20
>> i=C2=B9ve collected  this usefull info :
>> mdadm --examine /dev/sd[a-z] | egrep 'Event|/dev/sd'
>> /dev/sda: (system HDD )
>> /dev/sdb:
>>          Events : 21958
>> /dev/sdc:
>>          Events : 21958
>> /dev/sdd:
>>          Events : 21958
>> /dev/sde:
>>          Events : 21958
>> /dev/sdf:
>>          Events : 21958
>> /dev/sdg:
>>          Events : 21954  <=E2=80=B9 here
>> /dev/sdh:
>>          Events : 21954  <=E2=80=B9 and here
>
>In general, people on this list want to see the full --examine reports=
=2E
> As do I.
>
>Also, you need to record which drive serial numbers correspond to whic=
h
>device roles, just in case.  You can show the smartctl data along with
>the examines like so:
>
>for x in /dev/sd[b-h] ; do mdadm -E $x ; smartctl -iA -l scterc $x ;
>done > report.txt
>
>Then paste report.txt into your next mail.
>
>> The strange thing is that  my raid array is now seen as a RAID0 in
>> mdadm --detail /dev/md127
>> /dev/md127:
>>         Version :
>>      Raid Level : raid0
>>   Total Devices : 0
>>=20
>>           State : inactive
>
>It didn't start, so that info isn't meaningful.
>
>> But individually all drive in mdadm =E2=80=B9examine , are RAID 5 me=
mber .
>>=20
>> Anyone for help  ?
>
>Your array should be fixable.  The use of "mdadm --assemble --force" a=
s
>recommended by Roger is likely to work.  But it won't be enough if you
>don't also figure out why the array stopped after a few hours.  That
>sounds like a common problem with raid5 rebuilds.
>
>> i=C2=B9 was on the way to perform a
>> mdadm --create --assume-clean =E2=80=B9level=3D5 --raid-devices=3D7
>>--size=3D11720300544
>> /dev/md127 /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg
>>/dev/sdh
>>=20
>> Which looks a bit stupid before ask for help
>
>Yes, this is what the wiki means when it refers to doing something
>stupid.  Any form of --create is destructive and should only be
>attempted when all other attempts have failed.
>
>Phil
>


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

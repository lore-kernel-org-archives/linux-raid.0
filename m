From: Thomas MARCHESSEAU <marchesseau@gmail.com>
Subject: Re: RAID 5 "magicaly" become a RAID0
Date: Mon, 13 Apr 2015 14:27:48 +0200
Message-ID: <D1517793.3D82D%marchesseau@gmail.com>
References: <D150B36B.8EE37%marchesseau@gmail.com>
 <552B0B58.8050102@turmel.org>
 <D15148A7.3B83B%marchesseau@gmail.com>
 <552BA12C.3010506@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <552BA12C.3010506@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
Cc: Roger Heflin <rogerheflin@gmail.com>
List-Id: linux-raid.ids

Hi Phil,


>{ Convention on kernel.org is to reply-to-all, trim quotes, and place
>your response inline or at the bottom. }

Ok, sorry thanks , i=B9ll do it

>
>Hmmm.  Based on the below, this should have worked. Please report your
>mdadm version.  Your kernel appears to be 3.16.0.  There have been som=
e
>assembly bugs fixed in the past year.  You will certainly want to try
>with a recent livecd before giving up on --assemble --force.

Yep , the Kernel is  3.16.0-34-generic, 64bits
mdadm -V
mdadm - v3.3 - 3rd September 2013
=20
>Wait!  One thing at a time.  First we must recover your array and help
>you get a better backup.  Then you may add another drive to make a rai=
d6.

Yeah  of course , i=B9ll do that  later ;) , i really want to recove  m=
y
kids picture :) at 1st , my own dev , and other less important crap .


>
>Very good.  Some of your devices have SMART disabled.  You should enab=
le
>those, and re-do the smart report for them.

/dev/sdb:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
           Name : Cerebro:0  (loal to host Cerebro)
  Creation Time : Sat Feb  7 23:02:47 2015
     Raid Level : raid5
   Raid Devices : 7

 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 G)
     Array Size : 11720300544 (11177.35 GiB 12001.59 GB)
  Used Dev Size : 3906766848 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Supe Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          State : clean
    Device UUID : 3c496797:3cf85a2f:295fbd9b:2e077213
Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 12 06:10:59 215
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
Serial Number:    WD-WCC1P191161
LU WWN Device Id: 5 0014ee 25ee4fcd6
=46irmware Version: 01.01K02
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Secto Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Versio is:  SATA 3.0, 6.0 Gb/s (current: 3.0 Gb/s)
Local Time is:    Mon Apr 13 13:32:002015 CEST
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
  3 Spin_Up_Time            0x0027   171   171   021    Pre-fail  Alway=
s
    -       6450
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s
    -       7
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Prefail  Always
    -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Alway=
s
    -       0
  9 Power_On_Hours          0x0032   100   100   000    Old_age   Alway=
s
    -       566
10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Always
   -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s
    -       0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s
    -       7
183 untime_Bad_Block       0x0032   100   100   000    Old_age   Always
    -       0
192 Power-Off_Retract_Count 0x0032   200   00   000    Old_age   Always
    -       4
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s
    -       2
194 Temperature_Celsius     0x0022   115   109   000    Old_age   Alway=
s
    -       35
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s
    -       0
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s
    -       0
198 Offline_Unorrectable   0x0030   200   200   000    Old_age   Offlin=
e
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


/dev/sdc:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
          Name : Cerebro:0  (local to host Cerebro)
  Creation Time : Sa Feb  7 23:02:47 2015
     Raid Level : raid5
   Raid Devices : 7


 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720300544 (11177.35 GiB 12001.59 GB)
  Used Dev Size : 3906766848 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          State : clan
    Device UUID : 8df5ff53:7e7b70cd:8f4f00f1:62d06766


Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 12 06:10:59 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 18c2e134 - corrct
         Events : 21958


         Layout : left-symmetric
     Chunk Size : 512


   Device Role : Active device 0
   Array State : AAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-34-generic] (local
build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg


=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE4 (SATA 6Gb/s
Device Model:     WDC WD2000FYYZ-01UL1B1
Serial Number:    WD-WCC1P1097832
LU WWN Device Id: 5 0014ee 2b4399815
=46irmware Version: 01.01K02
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:    512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
Device is:        n smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor reision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Apr 13 13:32:00 2015 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled


=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributs with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s
    -      0
  3 Spin_Up_Time            0x0027   166   165   021    Pre-fail  Alway=
s
   -       6691
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s    -       44
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alays
    -       0
  7 Seek_Error_Rate         0x002e   200   200   000    Old_age   Aways
    -       0
  9 Power_On_Hours          0x0032   089   089   000    Old_age   Alway=
s
    -       8301
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s
    -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s
    -      0
 12 Power_Cycle_Count       0x0032   100   100   000    Old_age   Alway=
s
    -       43
183 Runtime_Bad_Block       0x0032   100   100   000    Old_age   Alway=
s
    -       0
192 Power-Off_Retract_ount 0x0032   200   200   000    Old_age   Always
    -       30
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s
    -       13
194 Temperature_Celsius     0x0022   101   090   000    Old_age   Alway=
s
    -       49
196 Reallocated_Event_Count0x0032   200   200   000    Old_age   Always
    -       0
197 Current_Pending_Sector  0x003   200   200   000    Old_age   Always
    -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne
    -       0
199 UDMA_CRC_Error_Count    0x0032   200   200  000    Old_age   Always
    -       0
200 Multi_Zone_Error_Rate   0x0008   200   20   000    Old_age   Offlin=
e
    -       0


SCT Error Recovery Control:
           Rad:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)


/dev/sdd:
         Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
           Name : Cerebro:0  (lcal to host Cerebro)
  Creation Time : Sat Feb  7 23:02:47 2015
     Raid Level : raid5
   Rid Devices : 7


 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720300544 (11177.35 GiB 12001.59 GB)
  Usd Dev Size : 3906766848 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
  Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          State : clean
    Device UUID : ce00382c:1af27788:00df454:44e23f65


Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 12 0610:59 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : ecec264 - correct
         Events : 21958


        Layout : left-symmetric

     Chunk Size : 512K


   Device Role : Active device=20
   Array State : AAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-34-generic] (local
build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontoos.=
org


=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital E4 (SATA 6Gb/s)
Device Model:     WDC WD2000FYYZ-01UL1B1
Serial Number:    WD-WCC1P1097658
LU WWN Device Id: 5 0014ee 2098fea8e
=46irmware Version: 01.01K02
User Capacity:    2,000,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:       In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revsion not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Tie is:    Mon Apr 13 13:32:00 2015 CEST
SMART support is: Available - device has SMARTcapability.
SMART support is: Enabled


=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMAR Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with hresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED
HEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail Always
    -       0
  3 Spin_Up_Time            0x0027   161   159   021    Pre-fail  Alway=
s
    -       6933
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
    -       8301
 10 Spin_Retry_Count       0x0032   100   253   000    Old_age   Always
    -       0
 11 Calibration_Rety_Count 0x0032   100   253   000    Old_age   Always
    -       0
 12 Power_Cyce_Count       0x0032   100   100   000    Old_age   Always
    -       42
183 Rutime_Bad_Block       0x0032   100   100   000    Old_age   Always
    -       0
92 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Always
    -      29
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s
    -       13
194 Temperature_Celsius     0x0022   099   091   000    Old_age   Alway=
s
    -       51
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s
    -       0
197 Current_Pending_Sector  0x002   200   200   000    Old_age   Always
    -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne
           0
199 UDMA_CRC_Error_Count    0x0032   200   200   000    Old_age   Alway=
s
    -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    ld_age   Offlin=
e
    -       0


SCT Error Recovery Control:
           Read:     70 (7.0 secods)
          Write:     70 (7.0 seconds)


/dev/sde:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
           Nme : Cerebro:0  (local to host Cerebro)
  Creation Time : Sat Feb  7 23:02:47 2015
     Raid Level : raid5
   Raid Devices : 7

Avail Dev Size : 3906767024 (1862.89 GiB 000.26 GB)
     Array Size : 11720300544 (11177.35 GiB 12001.59 GB)
  Used Dev Size : 3906766848 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectos
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          State : clean
    Device UUID : c31958a3:769ae8c1:c61003a:8ac4ced9


Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 12 0:10:59 2015
  Bad Block Log : 512 entries available at offset 72 sectors
       Checksum : 18fad9c3 - correct
         Events : 21958


         Layout : left-symmetric
     Chunk Size : 512K


   Device Role : Active device 2
   Array State : AAAA.A. ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
martctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-34-generic] (local
build)
Copyright (C) 2002-13, Bruce Alle, Christian Franke, www.smartmontools.=
org


=3D=3D=3D START OF INFORMATION SECTION =3D=3D
Model Family:     Western Digital RE4 (SATA 6Gb/s)
Device Model:     WDC WD2000FYYZ-01UL1B1
Serial Number:    WD-WCC1P1111248
LU WWN Device Id: 5 0014ee 2b43abede
=46irmware Version: 01.01K02
User Capacity:    2,000398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Apr 13 13:32:00 2015 CEST
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
  4 Start_Stop_Count        0x0032   100   100   000    Old_age  Always
    -       45
  5 Reallocated_Sector_Ct   0x0033   200   200   140    re-fail  Always
    -       0
  7 Seek_Error_Rate         0x002e   100   253   00    Old_age   Always
    -       0
  9 Power_On_Hours          0x0032   089   89   000    Old_age   Always
    -       8301
 10 Spin_Retry_Count        0x0032   100   253   000    Old_age   Alway=
s
    -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s
    -       0
 12 Power_Cycle_Count       0x0032   100   100  000    Old_age   Always
    -       43
183 Runtime_Bad_Block       0x0032   10   100   000    Old_age   Always
    -       0
192 Power-Off_Retract_Count 0x0032  200   200   000    Old_age   Always
    -       30
193 Load_Cycle_Count       0x0032   200   200   000    Old_age   Always
    -       14
194 Temperature_Celsius     0x0022   101   092   000    Old_age   Alway=
s
    -       49
196 eallocated_Event_Count 0x0032   200   200   000    Old_age   Always
    -      =20
197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Alway=
s
    -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne
    -       0
199 UDMA_CRC_Error_Count    0x0032   200   200   00    Old_age   Always
    -       0
200 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offli=
ne
    -       0


SCT Error Recovery ontrol:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)


/dev/sdf:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Array UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
           Name : Cerebro:0  (ocal to host Cerebro)
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
    Dvice UUID : 486831b4:ce34ac6f:c5f43616:8042099d


Internal Bitmap : 8 sectors from superblock
    Update Time : Sun Apr 12 06:10:59 2015
  Bad Block Log : 512 entries available at offst 72 sectors
       Checksum : 77082495 - correct
         Events : 21958


         Layout : left-symmetric
     Chunk Size : 512K


   Device Role : Active device 3
   Array State : AAAA.A.('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=
=3D replacing)
smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-34-generic] (local
build)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg


=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western Digital RE4 (SATA 6Gb/s)
Device Model:     WDC WD2000YYZ-01UL1B1
Serial Number:    WD-WCC1P1107956
LU WWN Device Id: 5 0014ee 2b4399801
=46irmware Version: 01.01K02
User Capacity:    2,000,398,934,016 bytes [200 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device i:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Apr13 13:32:00 2015 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESHTYPE      UPDATE=
D
WHEN_FAILED RAW_VALUE
ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDAT=
ED
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f  200   200   051    Pre-fail  Always
    -       0
  3 Spin_Up_Time            0x0027   178   173   021    Pre-fail  Alway=
s
    -       6058
  4 StartStop_Count        0x0032   100   100   000    Old_age   Always
    -       43
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s
    -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_age   Alway=
s
    -       0
  9 Powe_On_Hours          0x0032   089   089   000    Old_age   Always
    -       8301
 10 Spin_Retry_Count0032   100   253   000    Old_age   Always
    -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_age   Alway=
s
    -       0
 12 Power_Cycle_Count       00032   100   100   000    Old_age   Always
    -       42
183 Runtime_Bad_Block       0x0032   100   100   000    Oldage   Always
    -       0
192 Power-Off_Retract_Count 0x0032   200   200   000    Old_age   Alway=
s
    -       29
193 Load_Cycle_Count        0x0032   200   200   000    Old_age   Alway=
s
    -       13
194 Temperature_Celsius     0x0022   102   094   000    Old_age   Alway=
s
    -       48
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
200 Multi_Zone_Error_Rate   0x0008   200   200   000   Old_age   Offlin=
e
    -       0


SCT Error Recovery Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)


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
     Array Size : 1720300544 (11177.35 GiB 12001.59 GB)
  Used Dev Size : 3906766848 (1862.8 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          Stae : clean
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
=3D replacing)smartctl 6.2 2013-07-26 r3841 [x86_64-linux-3.16.0-34-gen=
eric] (local
buil)
Copyright (C) 2002-13, Bruce Allen, Christian Franke, www.smartmontools=
=2Eorg


=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     Western DigitalRE4 (SATA 6Gb/s)
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
Local Time is:    Mon Apr 13 13:32:00 2015 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled


=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRIBUTE_NAME         FLAG     VALUE WORST THRESH TYPE      UPDATE=
D
WHEN_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s
    -       0
  3 Spi_Up_Time            0x0027   170   165   021    Pre-fail  Alays
    -       6466
  4 Start_Stop_Count        0x0032   100   100   000    Old_age   Alway=
s    -       43
  5 Reallocated_Sector_Ct   0x0033   200   200   140    Pre-fail  Alway=
s
    -       0
  7 Seek_Error_Rate         0x002e   100   253   000    Old_ae   Always
    -       0
  9 Power_On_Hours          0x003   089   089   000    Old_age   Always
    -       8301
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
193Load_Cycle_Count        0x0032   200   200   000    Old_age   Always
    -       13
19 Temperature_Celsius     0x0022   105   092   000    Old_age   Always
   -       45
196 Reallocated_Event_Count 0x0032   200   200   000    Old_age   Alway=
s
    -       0
197 Current_Pnding_Sector  0x0032   200   200   000    Old_age   Always
    -       0
198 Offline_Uncorrectable   0x0030   200   200   000    Old_age   Offli=
ne
    -       0
199 UDMA_CRC_Errr_Count    0x0032   200   200   000    Old_age   Always
    -       0
20 Multi_Zone_Error_Rate   0x0008   200   200   000    Old_age   Offlin=
e
    -       0


SCT Error Recover Control:
           Read:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)


/dev/sdh:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x1
     Arry UUID : e0890308:1fd11c2e:138b5542:4b5cdc62
           Name : Cerebr:0  (local to host Cerebro)
  Creation Time : Sat Feb  7 23:02:47 2015
     Raid Level : raid5
   Raid Deices : 7


 Avail Dev Size : 3906767024 (1862.89 GiB 2000.26 GB)
     Array Size : 11720300544 (11177.35 GiB 12001.59 GB)
  Used Dev Size : 3906766848 (1862.89 GiB 2000.26 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262056 sectors, after=3D176 sectors
          State : clean
    Device UUID : b1146034:7d8ab0e5:3c975a918f786829


Internal Bitmap : 8 sectors from superblock

   Update Time : Su Apr 12 06:09:14 2015
  Bad Block Log : 512 entries available at offset 72 ectors
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
User Capacity:    2,00,398,934,016 bytes [2.00 TB]
Sector Size:      512 bytes logical/physical
Rotation Rate:    7200 rpm
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   ATA8-ACS (minor revision not indicated)
SATA Version is:  SATA 3.0, 6.0 Gb/s (current: 6.0 Gb/s)
Local Time is:    Mon Apr 13 13:32:01 2015 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled


=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
SMART Attributes Data Structure revision number: 16
Vendor Specific SMART Attributes with Thresholds:
ID# ATTRBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATE=
D
WHE_FAILED RAW_VALUE
  1 Raw_Read_Error_Rate     0x002f   200   200   051    Pre-fail  Alway=
s
    -       0
 3 Spin_Up_Time            0x0027   170   170  021    Pre-fail  Always
    -       6491
  4 Start_Stop_Count       0x0032   100   100   000    Old_age   Always
    -       18
  5 Reallocated_Sector_Ct   0x033   200   200   140    Pre-fail  Always
    -      0
  7 Seek_Error_Rate         0x002e   200   200  000    Old_age   Always
    -       0
  9 Power_On_Hours          0x0032   098   098   000    Old_ge   Always
    -       1538
 10 Spin_Retry_Count        0x0032   100  253   000    Old_age   Always
    -       0
 11 Calibration_Retry_Count 0x0032   100   253   000    Old_ag   Always
    -       0
 12 Power_Cycle_Count      0x0032   100   100   000    Old_age   Always
    -       18183 Runtime_Bad_Block       0x0032   100   100   000    O=
ld_age   Always
    -       0
192 Power-Of_Retract_Count 0x0032   200   200   000    Old_ae   Always
    -       12
193 Load_Cycle_Count        0x032   200   200   000    Old_age   Always
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
200 Multi_Zone_Error_Rate   0x0008   200   200   00    Old_age   Offlin=
e
    -       0


SCT Error Recovery Control:
           Red:     70 (7.0 seconds)
          Write:     70 (7.0 seconds)














>
>Meanwhile, please obtain your dmesg and paste it her.  I suggest
>turning off line wrap when you paste into your email.

Humm dmesg from when ? There  nothing before april 12th ,

dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-34-generic (buildd@roseapple) (gcc
version 4.9.1 (Ubuntu 4.9.1-16ubuntu6) ) #45-Ubuntu MP Mon Mar 23
17:21:27 UTC 2015 (Ubuntu 3.16.0-34.45-generic 3.16.7-ckt8)
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-3.16.0-34-gener=
ic
root=3DUUID=3D7cff9c6e-27b9-46c6-abaa-53870793f384 ro nomdmonddfnomdmon=
isw
[    0.000000] KERNEL supported cpus:
[    0.000000]   Intel GenuineIntel[    0.000000]   AMD AuthenticAMD
[    0.000000]   Centaur CentaurHauls
[    0.000000] e820: BIOS-provied physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009cfff]
sable
[    0.000000] BIOS-e820: [mem 0x000000000009d000-0x000000000009ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x00000000ce3b3fff]
usable
[    0000000] BIOS-e820: [mem 0x00000000ce3b4000-0x00000000ceddbfff]
reserved
[    0.000000] BIOS-e820: [mem x00000000ceddc000-0x00000000cedebfff] AC=
PI
data
[    0.000000] BIOS-e820: [mem 0x00000000cede000-0x00000000cf4adfff] AC=
PI
NVS
[    0.000000] BIOS-e820: [mem 0x00000000cf4ae000-0x00000000cf643fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000cf644000-0x00000000cf7ffff]
usable
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x0000000e3ffffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed01000-0x00000000fed03fff]
reserved
[    0.00000] BIOS-e820: [mem 0x00000000fed08000-0x0000000fed08fff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe0c000-0x00000000fed0ffff]
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c00-0x00000000fed1cfff]
reserved
[    0.000000] BIOS-e820: [mem 0x0000000fef00000-0x00000000feffffff]
reserved
[    0.000000]BIOS-e820: [mem 0x00000000ff800000-0x00000000ffffffff]
reserved
[    0.000000] BIS-e820: [mem 0x0000000100000000-0x000000082fffffff]
usable
[    .000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: To Be Filled By O.E.M. To Be Filled By
O.E.M./C2550D4I, BIOS P2.10 08/06/2014
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> =
rserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: N AGP bridge found
[    0.000000] e820: last_pfn =3D 0x830000 max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-ack
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-E7FFF write-through
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0D0000000 mask FF0000000 uncachable
[    0.000000]   1 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   2 base 0CF800000 mask FFF800000 uncachable
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] e820: last_pfn =3D 0xcf800 max_arch_pfn =3D 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fd880-0x000fd88f] mapped=
 at
[ffff8800000fd880]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size
24576
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01fd2000, 0x01fd2fff] PGTABLE
[    0.000000] BRK [0x01fd3000, 0x01fd3fff] PGTABLE
[    0.000000] BRK [0x01fd4000, 0x01fd4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x82fe00000-0x82fffffff]
[    0.000000]  [mem 0x82fe00000-0x82fffffff] page 2M
[    0.000000] BRK [0x01fd5000, 0x01fd5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x82c000000-0x82fdfffff]
[    0.000000]  [mem 0x82c000000-0x82fdfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x800000000-0x82bffffff]
[    0.000000]  [mem 0x800000000-0x82bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0xce3b3fff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0xce1fffff] page 2M
[    0.000000]  [mem 0xce200000-0xce3b3fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xcf644000-0xcf7fffff]
[    0.000000]  [mem 0xcf644000-0xcf7fffff] page 4k
[    0.000000] BRK [0x01fd6000, 0x01fd6fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x100000000-0x7ffffffff]
[    0.000000]  [mem 0x100000000-0x7ffffffff] page 2M
[    0.000000] BRK [0x01fd7000, 0x01fd7fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x357ae000-0x36bcefff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0490 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x00000000CEDE6098 0000AC (v01 ALASKA A M I
01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000CEDEA258 00010C (v05 ALASKA A M I
01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000CEDE61D0 004084 (v02 ALASKA A M I  =
 =20
01072009 INTL 20061109)
[    0.000000] ACPI: FACS 0x00000000CF4ABF80 000040
[    0.000000] ACPI: FPDT 0x00000000CEDEA368 000044 (v01 ALASKA A M I  =
 =20
01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x00000000CEDEA3B0 00009C (v01 ALASKA A M I  =
 =20
01072009 AMI  00010013)
[    0.000000] ACPI: HPET 0x00000000CEDEA450 000038 (v01 ALASKA        =
 =20
00000001 MSFT 01000013)
[    0.000000] ACPI: AAFT 0x00000000CEDEA488 00002F (v01 ALASKA OEMAAFT=
 =20
01072009 MSFT 00000097)
[    0.000000] ACPI: SPMI 0x00000000CEDEA4B8 000040 (v05 A M I  OEMSPMI=
 =20
00000000 AMI. 00000000)
[    0.000000] ACPI: MCFG 0x00000000CEDEA4F8 00003C (v01 ALASKA A M I  =
 =20
01072009 MSFT 00000097)
[    0.000000] ACPI: WDAT 0x00000000CEDEA538 0001AC (v01 ALASKA A M I  =
 =20
01072009 MSFT 00010013)
[    0.000000] ACPI: UEFI 0x00000000CEDEA6E8 000042 (v01               =
 =20
00000000      00000000)
[    0.000000] ACPI: APIC 0x00000000CEDEA730 000078 (v03 INTEL  TIANO  =
 =20
00000001 MSFT 00000000)
[    0.000000] ACPI: BDAT 0x00000000CEDEA7A8 000030 (v01               =
 =20
00000000      00000000)
[    0.000000] ACPI: SSDT 0x00000000CEDEA7D8 0009F1 (v01 PmRef  CpuPm  =
 =20
00003000 INTL 20061109)
[    0.000000] ACPI: SPCR 0x00000000CEDEB1D0 000050 (v01 A M I  APTIO V=
 =20
01072009 AMI. 00000005)
[    0.000000] ACPI: HEST 0x00000000CEDEB220 0000A8 (v01 INTEL  AVOTON =
B=20
00000001 INTL 00000001)
[    0.000000] ACPI: BERT 0x00000000CEDEB2C8 000030 (v01 INTEL  AVOTON =
B=20
00000001 INTL 00000001)
[    0.000000] ACPI: ERST 0x00000000CEDEB2F8 000230 (v01 INTEL  AVOTON =
B=20
00000001 INTL 00000001)
[    0.000000] ACPI: EINJ 0x00000000CEDEB528 000150 (v01 INTEL  AVOTON =
B=20
00000001 INTL 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000082ffff=
fff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x82fffffff]
[    0.000000]   NODE_DATA [mem 0x82ffdc000-0x82ffe0fff]
[    0.000000]  [ffffea0000000000-ffffea0020bfffff] PMD ->=20
[ffff88080f600000-ffff88082f5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x82fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0xce3b3fff]
[    0.000000]   node   0: [mem 0xcf644000-0xcf7fffff]
[    0.000000]   node   0: [mem 0x100000000-0x82fffffff]
[    0.000000] On node 0 totalpages: 8381708
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 21 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 13142 pages used for memmap
[    0.000000]   DMA32 zone: 841072 pages, LIFO batch:31
[    0.000000]   Normal zone: 117760 pages used for memmap
[    0.000000]   Normal zone: 7536640 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x04] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x06] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GS=
I=20
0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high lev=
el)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009ffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xce3b4000-0xceddbfff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xceddc000-0xcedebfff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xcedec000-0xcf4adfff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xcf4ae000-0xcf643fff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xcf800000-0xdfffffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xe3ffffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xe4000000-0xfed00fff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xfed01000-0xfed03fff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xfed04000-0xfed07fff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xfed08000-0xfed08fff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xfed09000-0xfed0bfff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xfed0c000-0xfed0ffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xfed10000-0xfed1bfff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1cfff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1d000-0xfeefffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xfef00000-0xfeffffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xff7fffff=
]
[    0.000000] PM: Registered nosave memory: [mem 0xff800000-0xffffffff=
]
[    0.000000] e820: [mem 0xe4000000-0xfed00fff] available for PCI devi=
ces
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256 nr_cpu_ids=
:4=20
nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff88082fc00000 s82432=20
r8192 d24064 u524288
[    0.000000] pcpu-alloc: s82432 r8192 d24064 u524288 alloc=3D1*209715=
2
[    0.000000] pcpu-alloc: [0] 0 1 2 3=20
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on. =20
Total pages: 8250721
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:=20
BOOT_IMAGE=3D/boot/vmlinuz-3.16.0-34-generic=20
root=3DUUID=3D7cff9c6e-27b9-46c6-abaa-53870793f384 ro nomdmonddf nomdmo=
nisw
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA -=20
bailing!
[    0.000000] Memory: 32898716K/33526832K available (7748K kernel code=
,=20
1197K rwdata, 3612K rodata, 1360K init, 1308K bss, 628116K reserved)
[    0.000000] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D=
4, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=3D256 to nr_cpu_ids=3D=
4.
[    0.000000] 	Offload RCU callbacks from all CPUs
[    0.000000] 	Offload RCU callbacks from CPUs: 0-3.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu=
_ids=3D4
[    0.000000] NR_IRQS:16640 nr_irqs:712 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 134217728 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't=
 want=20
memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration failed
[    0.000000] tsc: PIT calibration matches HPET. 1 loops
[    0.000000] tsc: Detected 2399.806 MHz processor
[    0.000034] Calibrating delay loop (skipped), value calculated using=
=20
timer frequency.. 4799.61 BogoMIPS (lpj=3D9599224)
[    0.000043] pid_max: default: 32768 minimum: 301
[    0.000068] ACPI: Core revision 20140424
[    0.005167] ACPI: All ACPI Tables successfully acquired
[    0.005690] Security Framework initialized
[    0.005725] AppArmor: AppArmor initialized
[    0.005730] Yama: becoming mindful.
[    0.008810] Dentry cache hash table entries: 4194304 (order: 13,=20
33554432 bytes)
[    0.021014] Inode-cache hash table entries: 2097152 (order: 12,=20
16777216 bytes)
[    0.026446] Mount-cache hash table entries: 65536 (order: 7, 524288=20
bytes)
[    0.026505] Mountpoint-cache hash table entries: 65536 (order: 7,=20
524288 bytes)
[    0.027082] Initializing cgroup subsys memory
[    0.027133] Initializing cgroup subsys devices
[    0.027148] Initializing cgroup subsys freezer
[    0.027155] Initializing cgroup subsys net_cls
[    0.027165] Initializing cgroup subsys blkio
[    0.027176] Initializing cgroup subsys perf_event
[    0.027182] Initializing cgroup subsys net_prio
[    0.027197] Initializing cgroup subsys hugetlb
[    0.027228] CPU: Physical Processor ID: 0
[    0.027232] CPU: Processor Core ID: 0
[    0.031038] mce: CPU supports 6 MCE banks
[    0.031050] CPU0: Thermal monitoring enabled (TM1)
[    0.031061] Last level iTLB entries: 4KB 48, 2MB 0, 4MB 0 Last level=
=20
dTLB entries: 4KB 128, 2MB 16, 4MB 16, 1GB 0 tlb_flushall_shift: 6
[    0.031192] Freeing SMP alternatives memory: 32K (ffffffff81e81000 -=
=20
ffffffff81e89000)
[    0.032295] ftrace: allocating 29331 entries in 115 pages
[    0.046388] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin=
2=3D-1
[    0.086648] smpboot: CPU0: Intel(R) Atom(TM) CPU  C2550  @ 2.40GHz=20
(fam: 06, model: 4d, stepping: 08)
[    0.086670] TSC deadline timer enabled
[    0.086705] Performance Events: PEBS fmt2+, 8-deep LBR, Silvermont=20
events, full-width counters, Intel PMU driver.
[    0.086723] ... version:                3
[    0.086726] ... bit width:              40
[    0.086729] ... generic registers:      2
[    0.086732] ... value mask:             000000ffffffffff
[    0.086736] ... max period:             000000ffffffffff
[    0.086739] ... fixed-purpose events:   3
[    0.086742] ... event mask:             0000000700000003
[    0.089575] x86: Booting SMP configuration:
[    0.089583] .... node  #0, CPUs:      #1
[    0.106525] NMI watchdog: enabled on all CPUs, permanently consumes =
one=20
hw-PMU counter.
[    0.106727]  #2 #3
[    0.141096] x86: Booted up 1 node, 4 CPUs
[    0.141104] smpboot: Total of 4 processors activated (19198.44 BogoM=
IPS)
[    0.141911] devtmpfs: initialized
[    0.153444] evm: security.selinux
[    0.153452] evm: security.SMACK64
[    0.153455] evm: security.SMACK64EXEC
[    0.153458] evm: security.SMACK64TRANSMUTE
[    0.153461] evm: security.SMACK64MMAP
[    0.153464] evm: security.ima
[    0.153467] evm: security.capability
[    0.153580] PM: Registering ACPI NVS region [mem 0xcedec000-0xcf4adf=
ff]=20
(7086080 bytes)
[    0.155393] pinctrl core: initialized pinctrl subsystem
[    0.155538] regulator-dummy: no parameters
[    0.155588] RTC time: 20:43:20, date: 04/12/15
[    0.155684] NET: Registered protocol family 16
[    0.155965] cpuidle: using governor ladder
[    0.155971] cpuidle: using governor menu
[    0.156073] ACPI: bus type PCI registered
[    0.156079] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.=
5
[    0.156200] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem=20
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.156208] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in=
=20
E820
[    0.156214] PCI: MMCONFIG for 0000 [bus00-3f] at [mem=20
0xe0000000-0xe3ffffff] (base 0xe0000000) (size reduced!)
[    0.156387] PCI: Using configuration type 1 for base access
[    0.161921] ACPI: Added _OSI(Module Device)
[    0.161929] ACPI: Added _OSI(Processor Device)
[    0.161933] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.161937] ACPI: Added _OSI(Processor Aggregator Device)
[    0.214248] ACPI: Dynamic OEM Table Load:
[    0.214266] ACPI: SSDT 0xFFFF880803A61000 000490 (v01 PmRef  Cpu0Ist=
 =20
00003000 INTL 20061109)
[    0.214679] ACPI: Dynamic OEM Table Load:
[    0.214689] ACPI: SSDT 0xFFFF880803A3FC00 0001FA (v01 PmRef  Cpu0Cst=
 =20
00003001 INTL 20061109)
[    0.222076] ACPI: Dynamic OEM Table Load:
[    0.222087] ACPI: SSDT 0xFFFF880803A61800 00047A (v01 PmRef  ApIst  =
 =20
00003000 INTL 20061109)
[    0.225799] ACPI: Dynamic OEM Table Load:
[    0.225809] ACPI: SSDT 0xFFFF880803A3FE00 000119 (v01 PmRef  ApCst  =
 =20
00003000 INTL 20061109)
[    0.230522] ACPI: Interpreter enabled
[    0.230534] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep Sta=
te=20
[\_S1_] (20140424/hwxface-580)
[    0.230544] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep Sta=
te=20
[\_S2_] (20140424/hwxface-580)
[    0.230552] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep Sta=
te=20
[\_S3_] (20140424/hwxface-580)
[    0.230561] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep Sta=
te=20
[\_S4_] (20140424/hwxface-580)
[    0.230575] ACPI: (supports S0 S5)
[    0.230580] ACPI: Using IOAPIC for interrupt routing
[    0.230701] HEST: Table parsing has been initialized.
[    0.230709] PCI: Using host bridge windows from ACPI; if necessary, =
use=20
"pci=3Dnocrs" and report a bug
[    0.236842] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.236855] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM=20
ClockPM Segments MSI]
[    0.237313] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME =
AER=20
PCIeCapability]
[    0.237574] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 00=
00=20
[bus 00-3f] only partially covers this bridge
[    0.237815] PCI host bridge to bus 0000:00
[    0.237822] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.237828] pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7]
[    0.237833] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.237838] pci_bus 0000:00: root bus resource [mem=20
0x000a0000-0x000bffff]
[    0.237843] pci_bus 0000:00: root bus resource [mem=20
0xd0000000-0xdfffffff]
[    0.237848] pci_bus 0000:00: root bus resource [mem=20
0x830000000-0xfffffffff]
[    0.237860] pci 0000:00:00.0: [8086:1f02] type 00 class 0x060000
[    0.237993] pci 0000:00:01.0: [8086:1f10] type 01 class 0x060400
[    0.238015] pci 0000:00:01.0: reg 0x10: [mem 0xdf740000-0xdf75ffff=20
64bit]
[    0.238068] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.238130] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.238199] pci 0000:00:03.0: [8086:1f12] type 01 class 0x060400
[    0.238219] pci 0000:00:03.0: reg 0x10: [mem 0xdf720000-0xdf73ffff=20
64bit]
[    0.238270] pci 0000:00:03.0: PME# supported from D0 D3hot D3cold
[    0.238330] pci 0000:00:03.0: System wakeup disabled by ACPI
[    0.238397] pci 0000:00:04.0: [8086:1f13] type 01 class 0x060400
[    0.238417] pci 0000:00:04.0: reg 0x10: [mem 0xdf700000-0xdf71ffff=20
64bit]
[    0.238468] pci 0000:00:04.0: PME# supported from D0 D3hot D3cold
[    0.238531] pci 0000:00:04.0: System wakeup disabled by ACPI
[    0.238609] pci 0000:00:0e.0: [8086:1f14] type 00 class 0x060000
[    0.238744] pci 0000:00:0f.0: [8086:1f16] type 00 class 0x080600
[    0.238798] pci 0000:00:0f.0: PME# supported from D0 D3hot D3cold
[    0.238917] pci 0000:00:13.0: [8086:1f15] type 00 class 0x088000
[    0.238939] pci 0000:00:13.0: reg 0x10: [mem 0xdf764000-0xdf7643ff=20
64bit]
[    0.239133] pci 0000:00:16.0: [8086:1f2c] type 00 class 0x0c0320
[    0.239160] pci 0000:00:16.0: reg 0x10: [mem 0xdf763000-0xdf7633ff]
[    0.239274] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.239338] pci 0000:00:16.0: System wakeup disabled by ACPI
[    0.239407] pci 0000:00:17.0: [8086:1f22] type 00 class 0x010601
[    0.239427] pci 0000:00:17.0: reg 0x10: [io  0xe0d0-0xe0d7]
[    0.239437] pci 0000:00:17.0: reg 0x14: [io  0xe0c0-0xe0c3]
[    0.239446] pci 0000:00:17.0: reg 0x18: [io  0xe0b0-0xe0b7]
[    0.239456] pci 0000:00:17.0: reg 0x1c: [io  0xe0a0-0xe0a3]
[    0.239465] pci 0000:00:17.0: reg 0x20: [io  0xe040-0xe05f]
[    0.239474] pci 0000:00:17.0: reg 0x24: [mem 0xdf762000-0xdf7627ff]
[    0.239518] pci 0000:00:17.0: PME# supported from D3hot
[    0.239638] pci 0000:00:18.0: [8086:1f32] type 00 class 0x010601
[    0.239657] pci 0000:00:18.0: reg 0x10: [io  0xe090-0xe097]
[    0.239667] pci 0000:00:18.0: reg 0x14: [io  0xe080-0xe083]
[    0.239676] pci 0000:00:18.0: reg 0x18: [io  0xe070-0xe077]
[    0.239686] pci 0000:00:18.0: reg 0x1c: [io  0xe060-0xe063]
[    0.239695] pci 0000:00:18.0: reg 0x20: [io  0xe020-0xe03f]
[    0.239705] pci 0000:00:18.0: reg 0x24: [mem 0xdf761000-0xdf7617ff]
[    0.239748] pci 0000:00:18.0: PME# supported from D3hot
[    0.239868] pci 0000:00:1f.0: [8086:1f38] type 00 class 0x060100
[    0.240040] pci 0000:00:1f.3: [8086:1f3c] type 00 class 0x0c0500
[    0.240058] pci 0000:00:1f.3: reg 0x10: [mem 0xdf760000-0xdf76001f]
[    0.240091] pci 0000:00:1f.3: reg 0x20: [io  0xe000-0xe01f]
[    0.240294] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.240395] pci 0000:02:00.0: [10b5:8608] type 01 class 0x060400
[    0.240413] pci 0000:02:00.0: reg 0x10: [mem 0xdf500000-0xdf51ffff]
[    0.240513] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.245729] pci 0000:00:03.0: PCI bridge to [bus 02-08]
[    0.245737] pci 0000:00:03.0:   bridge window [io  0x9000-0xcfff]
[    0.245742] pci 0000:00:03.0:   bridge window [mem=20
0xde000000-0xdf5fffff]
[    0.245837] pci 0000:03:01.0: [10b5:8608] type 01 class 0x060400
[    0.245947] pci 0000:03:01.0: PME# supported from D0 D3hot D3cold
[    0.246045] pci 0000:03:05.0: [10b5:8608] type 01 class 0x060400
[    0.246155] pci 0000:03:05.0: PME# supported from D0 D3hot D3cold
[    0.246252] pci 0000:03:07.0: [10b5:8608] type 01 class 0x060400
[    0.246362] pci 0000:03:07.0: PME# supported from D0 D3hot D3cold
[    0.246460] pci 0000:03:09.0: [10b5:8608] type 01 class 0x060400
[    0.246569] pci 0000:03:09.0: PME# supported from D0 D3hot D3cold
[    0.246677] pci 0000:02:00.0: PCI bridge to [bus 03-08]
[    0.246688] pci 0000:02:00.0:   bridge window [io  0x9000-0xcfff]
[    0.246693] pci 0000:02:00.0:   bridge window [mem=20
0xde000000-0xdf4fffff]
[    0.246793] pci 0000:04:00.0: [1b4b:9172] type 00 class 0x010601
[    0.246815] pci 0000:04:00.0: reg 0x10: [io  0xc040-0xc047]
[    0.246828] pci 0000:04:00.0: reg 0x14: [io  0xc030-0xc033]
[    0.246841] pci 0000:04:00.0: reg 0x18: [io  0xc020-0xc027]
[    0.246854] pci 0000:04:00.0: reg 0x1c: [io  0xc010-0xc013]
[    0.246867] pci 0000:04:00.0: reg 0x20: [io  0xc000-0xc00f]
[    0.246881] pci 0000:04:00.0: reg 0x24: [mem 0xdf410000-0xdf4101ff]
[    0.246895] pci 0000:04:00.0: reg 0x30: [mem 0xdf400000-0xdf40ffff p=
ref]
[    0.246956] pci 0000:04:00.0: PME# supported from D3hot
[    0.253742] pci 0000:03:01.0: PCI bridge to [bus 04]
[    0.253753] pci 0000:03:01.0:   bridge window [io  0xc000-0xcfff]
[    0.253758] pci 0000:03:01.0:   bridge window [mem=20
0xdf400000-0xdf4fffff]
[    0.253867] pci 0000:05:00.0: [1a03:1150] type 01 class 0x060400
[    0.254018] pci 0000:05:00.0: supports D1 D2
[    0.254022] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.254110] pci 0000:05:00.0: disabling ASPM on pre-1.1 PCIe device.=
 =20
You can enable it with 'pcie_aspm=3Dforce'
[    0.254127] pci 0000:03:05.0: PCI bridge to [bus 05-06]
[    0.254137] pci 0000:03:05.0:   bridge window [io  0xb000-0xbfff]
[    0.254142] pci 0000:03:05.0:   bridge window [mem=20
0xde000000-0xdf0fffff]
[    0.254261] pci 0000:06:00.0: [1a03:2000] type 00 class 0x030000
[    0.254296] pci 0000:06:00.0: reg 0x10: [mem 0xde000000-0xdeffffff]
[    0.254315] pci 0000:06:00.0: reg 0x14: [mem 0xdf000000-0xdf01ffff]
[    0.254335] pci 0000:06:00.0: reg 0x18: [io  0xb000-0xb07f]
[    0.254452] pci 0000:06:00.0: supports D1 D2
[    0.254455] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3c=
old
[    0.254611] pci 0000:05:00.0: PCI bridge to [bus 06]
[    0.254624] pci 0000:05:00.0:   bridge window [io  0xb000-0xbfff]
[    0.254631] pci 0000:05:00.0:   bridge window [mem=20
0xde000000-0xdf0fffff]
[    0.254752] pci 0000:07:00.0: [8086:1533] type 00 class 0x020000
[    0.254780] pci 0000:07:00.0: reg 0x10: [mem 0xdf300000-0xdf37ffff]
[    0.254812] pci 0000:07:00.0: reg 0x18: [io  0xa000-0xa01f]
[    0.254829] pci 0000:07:00.0: reg 0x1c: [mem 0xdf380000-0xdf383fff]
[    0.254976] pci 0000:07:00.0: PME# supported from D0 D3hot D3cold
[    0.261755] pci 0000:03:07.0: PCI bridge to [bus 07]
[    0.261766] pci 0000:03:07.0:   bridge window [io  0xa000-0xafff]
[    0.261772] pci 0000:03:07.0:   bridge window [mem=20
0xdf300000-0xdf3fffff]
[    0.261881] pci 0000:08:00.0: [8086:1533] type 00 class 0x020000
[    0.261910] pci 0000:08:00.0: reg 0x10: [mem 0xdf200000-0xdf27ffff]
[    0.261941] pci 0000:08:00.0: reg 0x18: [io  0x9000-0x901f]
[    0.261958] pci 0000:08:00.0: reg 0x1c: [mem 0xdf280000-0xdf283fff]
[    0.262104] pci 0000:08:00.0: PME# supported from D0 D3hot D3cold
[    0.269766] pci 0000:03:09.0: PCI bridge to [bus 08]
[    0.269776] pci 0000:03:09.0:   bridge window [io  0x9000-0x9fff]
[    0.269782] pci 0000:03:09.0:   bridge window [mem=20
0xdf200000-0xdf2fffff]
[    0.269910] pci 0000:09:00.0: [1b4b:9230] type 00 class 0x010601
[    0.269928] pci 0000:09:00.0: reg 0x10: [io  0xd050-0xd057]
[    0.269939] pci 0000:09:00.0: reg 0x14: [io  0xd040-0xd043]
[    0.269950] pci 0000:09:00.0: reg 0x18: [io  0xd030-0xd037]
[    0.269960] pci 0000:09:00.0: reg 0x1c: [io  0xd020-0xd023]
[    0.269971] pci 0000:09:00.0: reg 0x20: [io  0xd000-0xd01f]
[    0.269982] pci 0000:09:00.0: reg 0x24: [mem 0xdf610000-0xdf6107ff]
[    0.269993] pci 0000:09:00.0: reg 0x30: [mem 0xdf600000-0xdf60ffff p=
ref]
[    0.270046] pci 0000:09:00.0: PME# supported from D3hot
[    0.277771] pci 0000:00:04.0: PCI bridge to [bus 09]
[    0.277779] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.277784] pci 0000:00:04.0:   bridge window [mem=20
0xdf600000-0xdf6fffff]
[    0.277999] ACPI: PCI Interrupt Link [LNKA] (IRQs 6 7 10 *11 12)
[    0.278106] ACPI: PCI Interrupt Link [LNKB] (IRQs 6 7 10 11 12) *0,=20
disabled.
[    0.278213] ACPI: PCI Interrupt Link [LNKC] (IRQs 6 7 10 *11 12)
[    0.278318] ACPI: PCI Interrupt Link [LNKD] (IRQs 6 *7 10 11 12)
[    0.278423] ACPI: PCI Interrupt Link [LNKE] (IRQs 6 7 *10 11 12)
[    0.278529] ACPI: PCI Interrupt Link [LNKF] (IRQs 6 7 *10 11 12)
[    0.278634] ACPI: PCI Interrupt Link [LNKG] (IRQs 6 *7 10 11 12)
[    0.278740] ACPI: PCI Interrupt Link [LNKH] (IRQs 6 7 10 *11 12)
[    0.279455] ACPI: Enabled 1 GPEs in block 00 to 1F
[    0.279657] vgaarb: setting as boot device: PCI:0000:06:00.0
[    0.279663] vgaarb: device added:=20
PCI:0000:06:00.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
[    0.279668] vgaarb: loaded
[    0.279672] vgaarb: bridge control possible 0000:06:00.0
[    0.280075] SCSI subsystem initialized
[    0.280171] libata version 3.00 loaded.
[    0.280218] ACPI: bus type USB registered
[    0.280254] usbcore: registered new interface driver usbfs
[    0.280277] usbcore: registered new interface driver hub
[    0.280322] usbcore: registered new device driver usb
[    0.280562] PCI: Using ACPI for IRQ routing
[    0.281490] PCI: pci_cache_line_size set to 64 bytes
[    0.281567] e820: reserve RAM buffer [mem 0x0009d000-0x0009ffff]
[    0.281571] e820: reserve RAM buffer [mem 0xce3b4000-0xcfffffff]
[    0.281573] e820: reserve RAM buffer [mem 0xcf800000-0xcfffffff]
[    0.281754] NetLabel: Initializing
[    0.281768] NetLabel:  domain hash size =3D 128
[    0.281772] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.281792] NetLabel:  unlabeled traffic allowed by default
[    0.281906] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.281915] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
[    0.283985] Switched to clocksource hpet
[    0.293782] AppArmor: AppArmor Filesystem Enabled
[    0.293844] pnp: PnP ACPI init
[    0.293871] ACPI: bus type PNP registered
[    0.294233] system 00:00: [mem 0xe0000000-0xefffffff] could not be=20
reserved
[    0.294240] system 00:00: [mem 0xcf800000-0xcfffffff] could not be=20
reserved
[    0.294248] system 00:00: Plug and Play ACPI device, IDs PNP0c01=20
(active)
[    0.294346] system 00:01: [io  0x0680-0x069f] has been reserved
[    0.294353] system 00:01: [io  0x0400-0x047f] could not be reserved
[    0.294359] system 00:01: [io  0x0500-0x05fe] has been reserved
[    0.294365] system 00:01: [mem 0xfed00000-0xfedfffff] could not be=20
reserved
[    0.294371] system 00:01: [mem 0x000c0000-0x000dffff] could not be=20
reserved
[    0.294376] system 00:01: [mem 0x000e0000-0x000fffff] could not be=20
reserved
[    0.294382] system 00:01: [mem 0xffa00000-0xffffffff] has been reser=
ved
[    0.294388] system 00:01: [mem 0xfee00000-0xfeefffff] has been reser=
ved
[    0.294394] system 00:01: Plug and Play ACPI device, IDs PNP0c02=20
(active)
[    0.294456] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (activ=
e)
[    0.294570] system 00:03: Plug and Play ACPI device, IDs PNP0c02=20
(active)
[    0.294919] ACPI: IRQ 4 override to edge, high
[    0.294931] pnp 00:04: [dma 0 disabled]
[    0.295011] pnp 00:04: Plug and Play ACPI device, IDs PNP0501 (activ=
e)
[    0.295348] ACPI: IRQ 3 override to edge, high
[    0.295359] pnp 00:05: [dma 0 disabled]
[    0.295439] pnp 00:05: Plug and Play ACPI device, IDs PNP0501 (activ=
e)
[    0.295684] system 00:06: [io  0x0a00-0x0a0f] has been reserved
[    0.295691] system 00:06: [io  0x0a10-0x0a1f] has been reserved
[    0.295696] system 00:06: [io  0x0a20-0x0a2f] has been reserved
[    0.295703] system 00:06: Plug and Play ACPI device, IDs PNP0c02=20
(active)
[    0.295873] pnp 00:07: Plug and Play ACPI device, IDs IPI0001 (activ=
e)
[    0.296024] pnp: PnP ACPI: found 8 devices
[    0.296029] ACPI: bus type PNP unregistered
[    0.304897] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.304918] pci 0000:03:01.0: PCI bridge to [bus 04]
[    0.304925] pci 0000:03:01.0:   bridge window [io  0xc000-0xcfff]
[    0.304934] pci 0000:03:01.0:   bridge window [mem=20
0xdf400000-0xdf4fffff]
[    0.304946] pci 0000:05:00.0: PCI bridge to [bus 06]
[    0.304952] pci 0000:05:00.0:   bridge window [io  0xb000-0xbfff]
[    0.304963] pci 0000:05:00.0:   bridge window [mem=20
0xde000000-0xdf0fffff]
[    0.304978] pci 0000:03:05.0: PCI bridge to [bus 05-06]
[    0.304984] pci 0000:03:05.0:   bridge window [io  0xb000-0xbfff]
[    0.304992] pci 0000:03:05.0:   bridge window [mem=20
0xde000000-0xdf0fffff]
[    0.305004] pci 0000:03:07.0: PCI bridge to [bus 07]
[    0.305010] pci 0000:03:07.0:   bridge window [io  0xa000-0xafff]
[    0.305018] pci 0000:03:07.0:   bridge window [mem=20
0xdf300000-0xdf3fffff]
[    0.305029] pci 0000:03:09.0: PCI bridge to [bus 08]
[    0.305035] pci 0000:03:09.0:   bridge window [io  0x9000-0x9fff]
[    0.305043] pci 0000:03:09.0:   bridge window [mem=20
0xdf200000-0xdf2fffff]
[    0.305055] pci 0000:02:00.0: PCI bridge to [bus 03-08]
[    0.305061] pci 0000:02:00.0:   bridge window [io  0x9000-0xcfff]
[    0.305069] pci 0000:02:00.0:   bridge window [mem=20
0xde000000-0xdf4fffff]
[    0.305081] pci 0000:00:03.0: PCI bridge to [bus 02-08]
[    0.305086] pci 0000:00:03.0:   bridge window [io  0x9000-0xcfff]
[    0.305094] pci 0000:00:03.0:   bridge window [mem=20
0xde000000-0xdf5fffff]
[    0.305107] pci 0000:00:04.0: PCI bridge to [bus 09]
[    0.305113] pci 0000:00:04.0:   bridge window [io  0xd000-0xdfff]
[    0.305120] pci 0000:00:04.0:   bridge window [mem=20
0xdf600000-0xdf6fffff]
[    0.305134] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.305138] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.305141] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.305144] pci_bus 0000:00: resource 7 [mem 0xd0000000-0xdfffffff]
[    0.305147] pci_bus 0000:00: resource 8 [mem 0x830000000-0xfffffffff=
]
[    0.305151] pci_bus 0000:02: resource 0 [io  0x9000-0xcfff]
[    0.305154] pci_bus 0000:02: resource 1 [mem 0xde000000-0xdf5fffff]
[    0.305157] pci_bus 0000:03: resource 0 [io  0x9000-0xcfff]
[    0.305160] pci_bus 0000:03: resource 1 [mem 0xde000000-0xdf4fffff]
[    0.305163] pci_bus 0000:04: resource 0 [io  0xc000-0xcfff]
[    0.305167] pci_bus 0000:04: resource 1 [mem 0xdf400000-0xdf4fffff]
[    0.305170] pci_bus 0000:05: resource 0 [io  0xb000-0xbfff]
[    0.305173] pci_bus 0000:05: resource 1 [mem 0xde000000-0xdf0fffff]
[    0.305176] pci_bus 0000:06: resource 0 [io  0xb000-0xbfff]
[    0.305179] pci_bus 0000:06: resource 1 [mem 0xde000000-0xdf0fffff]
[    0.305182] pci_bus 0000:07: resource 0 [io  0xa000-0xafff]
[    0.305185] pci_bus 0000:07: resource 1 [mem 0xdf300000-0xdf3fffff]
[    0.305189] pci_bus 0000:08: resource 0 [io  0x9000-0x9fff]
[    0.305192] pci_bus 0000:08: resource 1 [mem 0xdf200000-0xdf2fffff]
[    0.305195] pci_bus 0000:09: resource 0 [io  0xd000-0xdfff]
[    0.305198] pci_bus 0000:09: resource 1 [mem 0xdf600000-0xdf6fffff]
[    0.305245] NET: Registered protocol family 2
[    0.305715] TCP established hash table entries: 262144 (order: 9,=20
2097152 bytes)
[    0.306421] TCP bind hash table entries: 65536 (order: 8, 1048576 by=
tes)
[    0.306709] TCP: Hash tables configured (established 262144 bind 655=
36)
[    0.306778] TCP: reno registered
[    0.306835] UDP hash table entries: 16384 (order: 7, 524288 bytes)
[    0.307072] UDP-Lite hash table entries: 16384 (order: 7, 524288 byt=
es)
[    0.307365] NET: Registered protocol family 1
[    0.320178] pci 0000:06:00.0: Video device with shadowed ROM
[    0.320196] PCI: CLS 64 bytes, default 64
[    0.320305] Trying to unpack rootfs image as initramfs...
[    0.782169] Freeing initrd memory: 20612K (ffff8800357ae000 -=20
ffff880036bcf000)
[    0.782217] PCI-DMA: Using software bounce buffering for IO (SWIOTLB=
)
[    0.782225] software IO TLB [mem 0xca3b4000-0xce3b4000] (64MB) mappe=
d=20
at [ffff8800ca3b4000-ffff8800ce3b3fff]
[    0.782569] microcode: CPU0 sig=3D0x406d8, pf=3D0x1, revision=3D0x12=
2
[    0.782582] microcode: CPU1 sig=3D0x406d8, pf=3D0x1, revision=3D0x12=
2
[    0.782600] microcode: CPU2 sig=3D0x406d8, pf=3D0x1, revision=3D0x12=
2
[    0.782617] microcode: CPU3 sig=3D0x406d8, pf=3D0x1, revision=3D0x12=
2
[    0.782758] microcode: Microcode Update Driver: v2.00=20
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.782824] Scanning for low memory corruption every 60 seconds
[    0.783382] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.783410] Initialise system trusted keyring
[    0.783449] audit: initializing netlink subsys (disabled)
[    0.783481] audit: type=3D2000 audit(1428871400.736:1): initialized
[    0.783918] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.786642] zpool: loaded
[    0.786649] zbud: loaded
[    0.786884] VFS: Disk quotas dquot_6.5.2
[    0.786950] Dquot-cache hash table entries: 512 (order 0, 4096 bytes=
)
[    0.787835] fuse init (API version 7.23)
[    0.787997] msgmni has been set to 32768
[    0.788094] Key type big_key registered
[    0.788830] Key type asymmetric registered
[    0.788837] Asymmetric key parser 'x509' registered
[    0.788907] Block layer SCSI generic (bsg) driver version 0.4 loaded=
=20
(major 252)
[    0.788998] io scheduler noop registered
[    0.789004] io scheduler deadline registered (default)
[    0.789089] io scheduler cfq registered
[    0.789378] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.789560] pcieport 0000:00:03.0: irq 41 for MSI/MSI-X
[    0.789710] pcieport 0000:00:04.0: can't derive routing for PCI INT =
A
[    0.789717] pcieport 0000:00:04.0: PCI INT A: no GSI
[    0.789745] pcieport 0000:00:04.0: irq 42 for MSI/MSI-X
[    0.789908] pcieport 0000:02:00.0: irq 43 for MSI/MSI-X
[    0.790111] pcieport 0000:03:01.0: irq 44 for MSI/MSI-X
[    0.790309] pcieport 0000:03:05.0: irq 45 for MSI/MSI-X
[    0.790505] pcieport 0000:03:07.0: irq 46 for MSI/MSI-X
[    0.790699] pcieport 0000:03:09.0: irq 47 for MSI/MSI-X
[    0.790885] aer 0000:00:01.0:pcie02: service driver aer loaded
[    0.790940] aer 0000:00:03.0:pcie02: service driver aer loaded
[    0.790972] aer 0000:00:04.0:pcie02: service driver aer loaded
[    0.791001] pcieport 0000:00:01.0: Signaling PME through PCIe PME=20
interrupt
[    0.791009] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme lo=
aded
[    0.791024] pcieport 0000:00:03.0: Signaling PME through PCIe PME=20
interrupt
[    0.791030] pcieport 0000:02:00.0: Signaling PME through PCIe PME=20
interrupt
[    0.791034] pcieport 0000:03:01.0: Signaling PME through PCIe PME=20
interrupt
[    0.791039] pci 0000:04:00.0: Signaling PME through PCIe PME interru=
pt
[    0.791044] pcieport 0000:03:05.0: Signaling PME through PCIe PME=20
interrupt
[    0.791048] pci 0000:05:00.0: Signaling PME through PCIe PME interru=
pt
[    0.791053] pci 0000:06:00.0: Signaling PME through PCIe PME interru=
pt
[    0.791057] pcieport 0000:03:07.0: Signaling PME through PCIe PME=20
interrupt
[    0.791062] pci 0000:07:00.0: Signaling PME through PCIe PME interru=
pt
[    0.791066] pcieport 0000:03:09.0: Signaling PME through PCIe PME=20
interrupt
[    0.791071] pci 0000:08:00.0: Signaling PME through PCIe PME interru=
pt
[    0.791077] pcie_pme 0000:00:03.0:pcie01: service driver pcie_pme lo=
aded
[    0.791092] pcieport 0000:00:04.0: Signaling PME through PCIe PME=20
interrupt
[    0.791097] pci 0000:09:00.0: Signaling PME through PCIe PME interru=
pt
[    0.791104] pcie_pme 0000:00:04.0:pcie01: service driver pcie_pme lo=
aded
[    0.791133] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.791169] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4
[    0.791260] vesafb: mode is 1024x768x32, linelength=3D4096, pages=3D=
0
[    0.791264] vesafb: scrolling: redraw
[    0.791269] vesafb: Truecolor: size=3D8:8:8:8, shift=3D24:16:8:0
[    0.791293] vesafb: framebuffer at 0xde000000, mapped to=20
0xffffc90007600000, using 3072k, total 3072k
[    0.936729] Console: switching to colour frame buffer device 128x48
[    1.083775] fb0: VESA VGA frame buffer device
[    1.085002] intel_idle: MWAIT substates: 0x3000020
[    1.085005] intel_idle: v0.4 model 0x4D
[    1.085008] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.085278] input: Power Button as=20
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    1.087259] ACPI: Power Button [PWRF]
[    1.088789] ERST: Error Record Serialization Table (ERST) support is=
=20
initialized.
[    1.090794] pstore: Registered erst as persistent store backend
[    1.093069] GHES: APEI firmware first mode is enabled by APEI bit an=
d=20
WHEA _OSC.
[    1.095270] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    1.117684] 00:04: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 1152=
00) is=20
a 16550A
[    1.140412] 00:05: ttyS4 at I/O 0x248 (irq =3D 3, base_baud =3D 1152=
00) is=20
a 16550A
[    1.145688] Linux agpgart interface v0.103
[    1.149503] brd: module loaded
[    1.151712] loop: module loaded
[    1.152918] libphy: Fixed MDIO Bus: probed
[    1.153998] tun: Universal TUN/TAP device driver, 1.6
[    1.155366] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    1.157161] PPP generic driver version 2.4.2
[    1.158379] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driv=
er
[    1.160127] ehci-pci: EHCI PCI platform driver
[    1.161485] ehci-pci 0000:00:16.0: EHCI Host Controller
[    1.162879] ehci-pci 0000:00:16.0: new USB bus registered, assigned =
bus=20
number 1
[    1.164909] ehci-pci 0000:00:16.0: debug port 2
[    1.170030] ehci-pci 0000:00:16.0: cache line size of 64 is not=20
supported
[    1.170054] ehci-pci 0000:00:16.0: irq 23, io mem 0xdf763000
[    1.180707] ehci-pci 0000:00:16.0: USB 2.0 started, EHCI 1.00
[    1.236051] usb usb1: New USB device found, idVendor=3D1d6b,=20
idProduct=3D0002
[    1.291860] usb usb1: New USB device strings: Mfr=3D3, Product=3D2,=20
SerialNumber=3D1
[    1.348162] usb usb1: Product: EHCI Host Controller
[    1.404295] usb usb1: Manufacturer: Linux 3.16.0-34-generic ehci_hcd
[    1.461875] usb usb1: SerialNumber: 0000:00:16.0
[    1.520057] hub 1-0:1.0: USB hub found
[    1.578743] hub 1-0:1.0: 8 ports detected
[    1.636886] ehci-platform: EHCI generic platform driver
[    1.694858] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    1.694865] ohci-pci: OHCI PCI platform driver
[    1.694885] ohci-platform: OHCI generic platform driver
[    1.694899] uhci_hcd: USB Universal Host Controller Interface driver
[    1.695011] i8042: PNP: No PS/2 controller found. Probing ports=20
directly.
[    1.781232] tsc: Refined TSC clocksource calibration: 2399.992 MHz
[    1.945411] usb 1-1: new high-speed USB device number 2 using ehci-p=
ci
[    1.975520] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.975871] mousedev: PS/2 mouse device common for all mice
[    1.979243] rtc_cmos 00:02: RTC can wake from S4
[    1.979666] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    1.979748] rtc_cmos 00:02: alarms up to one month, 242 bytes nvram,=
=20
hpet irqs
[    1.979876] device-mapper: uevent: version 1.0.3
[    1.980082] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30)=20
initialised: dm-devel@redhat.com
[    1.980105] ledtrig-cpu: registered to indicate activity on CPUs
[    1.980252] TCP: cubic registered
[    1.980448] NET: Registered protocol family 10
[    1.980807] NET: Registered protocol family 17
[    1.980869] Key type dns_resolver registered
[    1.981641] Loading compiled-in X.509 certificates
[    1.983313] Loaded X.509 cert 'Magrathea: Glacier signing key:=20
b5e4b3533b47259e0a1a978f5b0c6007ef6e33e7'
[    1.983335] registered taskstats version 1
[    1.987185] Key type trusted registered
[    1.994281] Key type encrypted registered
[    1.994291] AppArmor: AppArmor sha1 policy hashing enabled
[    1.994295] ima: No TPM chip found, activating TPM-bypass!
[    1.994326] evm: HMAC attrs: 0x1
[    1.996178]   Magic number: 11:694:750
[    1.996208] tty ttyS1: hash matches
[    2.019597] rtc_cmos 00:02: setting system clock to 2015-04-12 20:43=
:22=20
UTC (1428871402)
[    2.033036] input: AT Translated Set 2 keyboard as=20
/devices/platform/i8042/serio0/input/input1
[    2.151261] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    2.151262] EDD information not available.
[    2.151384] PM: Hibernation image not present or could not be loaded=
=2E
[    2.177936] usb 1-1: New USB device found, idVendor=3D8087, idProduc=
t=3D07db
[    2.177939] usb 1-1: New USB device strings: Mfr=3D0, Product=3D0,=20
SerialNumber=3D0
[    2.178226] hub 1-1:1.0: USB hub found
[    2.178432] hub 1-1:1.0: 4 ports detected
[    2.734114] usb 1-1.1: new low-speed USB device number 3 using ehci-=
pci
[    3.133547] usb 1-1.1: New USB device found, idVendor=3D413c,=20
idProduct=3D2112
[    3.133549] usb 1-1.1: New USB device strings: Mfr=3D1, Product=3D2,=
=20
SerialNumber=3D0
[    3.133550] usb 1-1.1: Product: Dell USB Wired Multimedia Keyboard
[    3.133552] usb 1-1.1: Manufacturer: DELL
[    3.310559] usb 1-1.2: new low-speed USB device number 4 using ehci-=
pci
[    3.780559] usb 1-1.2: New USB device found, idVendor=3D051d,=20
idProduct=3D0002
[    3.780561] usb 1-1.2: New USB device strings: Mfr=3D3, Product=3D1,=
=20
SerialNumber=3D2
[    3.780562] usb 1-1.2: Product: Back-UPS CS 500 FW:808.q8.I USB FW:q=
8
[    3.780564] usb 1-1.2: Manufacturer: American Power Conversion
[    3.780565] usb 1-1.2: SerialNumber: 4B1034P04531 =20
[    3.935062] usb 1-1.4: new high-speed USB device number 5 using ehci=
-pci
[    4.272319] usb 1-1.4: New USB device found, idVendor=3D046b,=20
idProduct=3Dff01
[    4.272321] usb 1-1.4: New USB device strings: Mfr=3D1, Product=3D2,=
=20
SerialNumber=3D3
[    4.272322] usb 1-1.4: Product: Virtual Hub
[    4.272324] usb 1-1.4: Manufacturer: American Megatrends Inc.
[    4.272326] usb 1-1.4: SerialNumber: serial
[    4.389672] hub 1-1.4:1.0: USB hub found
[    4.389778] hub 1-1.4:1.0: 5 ports detected
[    4.969710] Freeing unused kernel memory: 1360K (ffffffff81d2d000 -=20
ffffffff81e81000)
[    5.026718] Write protecting the kernel read-only data: 12288k
[    5.084392] Switched to clocksource tsc
[    5.084562] usb 1-1.4.4: new low-speed USB device number 6 using=20
ehci-pci
[    5.200588] Freeing unused kernel memory: 432K (ffff880001794000 -=20
ffff880001800000)
[    5.260494] Freeing unused kernel memory: 484K (ffff880001b87000 -=20
ffff880001c00000)
[    5.317018] usb 1-1.4.4: New USB device found, idVendor=3D046b,=20
idProduct=3Dff10
[    5.373820] usb 1-1.4.4: New USB device strings: Mfr=3D1, Product=3D=
2,=20
SerialNumber=3D0
[    5.373822] usb 1-1.4.4: Product: Virtual Keyboard and Mouse
[    5.373824] usb 1-1.4.4: Manufacturer: American Megatrends Inc.
[    5.626457] systemd-udevd[118]: starting version 208
[    5.686957] random: systemd-udevd urandom read with 19 bits of entro=
py=20
available
[    5.751456] md: linear personality registered for level -1
[    5.812697] pps_core: LinuxPPS API ver. 1 registered
[    5.874815] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodo=
lfo=20
Giometti <giometti@linux.it>
[    5.938774] ahci 0000:00:17.0: version 3.0
[    5.938874] md: multipath personality registered for level -4
[    5.938927] ahci 0000:00:17.0: irq 48 for MSI/MSI-X
[    5.939090] ahci 0000:00:17.0: AHCI 0001.0300 32 slots 4 ports 3 Gbp=
s=20
0xf impl SATA mode
[    5.939094] ahci 0000:00:17.0: flags: 64bit ncq led clo pio deso sad=
m=20
sds apst=20
[    5.940552] scsi0 : ahci
[    5.940793] scsi1 : ahci
[    5.940986] scsi2 : ahci
[    5.941171] scsi3 : ahci
[    5.941257] ata1: SATA max UDMA/133 abar m2048@0xdf762000 port=20
0xdf762100 irq 48
[    5.941263] ata2: SATA max UDMA/133 abar m2048@0xdf762000 port=20
0xdf762180 irq 48
[    5.941267] ata3: SATA max UDMA/133 abar m2048@0xdf762000 port=20
0xdf762200 irq 48
[    5.941272] ata4: SATA max UDMA/133 abar m2048@0xdf762000 port=20
0xdf762280 irq 48
[    5.941493] ahci 0000:00:18.0: irq 49 for MSI/MSI-X
[    5.941612] ahci 0000:00:18.0: AHCI 0001.0300 32 slots 2 ports 6 Gbp=
s=20
0x3 impl SATA mode
[    5.941615] ahci 0000:00:18.0: flags: 64bit ncq led clo pio deso sad=
m=20
sds apst=20
[    5.942530] scsi4 : ahci
[    5.942730] scsi5 : ahci
[    5.942815] ata5: SATA max UDMA/133 abar m2048@0xdf761000 port=20
0xdf761100 irq 49
[    5.942820] ata6: SATA max UDMA/133 abar m2048@0xdf761000 port=20
0xdf761180 irq 49
[    5.943042] ahci 0000:04:00.0: irq 50 for MSI/MSI-X
[    5.943182] ahci 0000:04:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbp=
s=20
0x3 impl SATA mode
[    5.943185] ahci 0000:04:00.0: flags: 64bit ncq sntf led only pmp fb=
s=20
pio slum part sxs=20
[    5.944036] scsi6 : ahci
[    5.944235] scsi7 : ahci
[    5.944319] ata7: SATA max UDMA/133 abar m512@0xdf410000 port=20
0xdf410100 irq 50
[    5.944325] ata8: SATA max UDMA/133 abar m512@0xdf410000 port=20
0xdf410180 irq 50
[    5.944483] ahci 0000:09:00.0: controller can do FBS, turning on CAP=
_FBS
[    5.944540] ahci 0000:09:00.0: irq 51 for MSI/MSI-X
[    5.960636] ahci 0000:09:00.0: AHCI 0001.0200 32 slots 8 ports 6 Gbp=
s=20
0xff impl SATA mode
[    5.960640] ahci 0000:09:00.0: flags: 64bit ncq fbs pio=20
[    5.963187] scsi8 : ahci
[    5.963398] scsi9 : ahci
[    5.963603] scsi10 : ahci
[    5.963805] scsi11 : ahci
[    5.964007] scsi12 : ahci
[    5.964213] scsi13 : ahci
[    5.964431] scsi14 : ahci
[    5.964651] scsi15 : ahci
[    5.964798] ata9: SATA max UDMA/133 abar m2048@0xdf610000 port=20
0xdf610100 irq 51
[    5.964804] ata10: SATA max UDMA/133 abar m2048@0xdf610000 port=20
0xdf610180 irq 51
[    5.964808] ata11: SATA max UDMA/133 abar m2048@0xdf610000 port=20
0xdf610200 irq 51
[    5.964813] ata12: SATA max UDMA/133 abar m2048@0xdf610000 port=20
0xdf610280 irq 51
[    5.964818] ata13: SATA max UDMA/133 abar m2048@0xdf610000 port=20
0xdf610300 irq 51
[    5.964823] ata14: SATA max UDMA/133 abar m2048@0xdf610000 port=20
0xdf610380 irq 51
[    5.964829] ata15: SATA max UDMA/133 abar m2048@0xdf610000 port=20
0xdf610400 irq 51
[    5.964833] ata16: SATA max UDMA/133 abar m2048@0xdf610000 port=20
0xdf610480 irq 51
[    6.260735] ata2: SATA link down (SStatus 0 SControl 300)
[    6.260823] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.260893] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.260960] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    6.261019] ata3: SATA link down (SStatus 0 SControl 300)
[    6.261103] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    6.261807] ata4.00: ATA-8: WDC WD2000FYYZ-01UL1B1, 01.01K02, max=20
UDMA/133
[    6.261809] ata4.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth=20
31/32), AA
[    6.261937] ata6.00: ATA-8: WDC WD2000FYYZ-01UL1B1, 01.01K02, max=20
UDMA/133
[    6.261939] ata6.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth=20
31/32), AA
[    6.262031] ata5.00: ATA-8: WDC WD2000FYYZ-01UL1B1, 01.01K02, max=20
UDMA/133
[    6.262033] ata5.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth=20
31/32), AA
[    6.263547] ata5.00: configured for UDMA/133
[    6.263593] ata6.00: configured for UDMA/133
[    6.272548] ata4.00: configured for UDMA/133
[    6.272905] ata1.00: ATA-8: KINGSTON SH103S3480G, 501ABBF0, max UDMA=
/133
[    6.272907] ata1.00: 937703088 sectors, multi 16: LBA48 NCQ (depth=20
31/32), AA
[    6.282853] ata1.00: configured for UDMA/133
[    6.282995] scsi 0:0:0:0: Direct-Access     ATA      KINGSTON SH103S=
3=20
BBF0 PQ: 0 ANSI: 5
[    6.283448] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    6.283660] scsi 3:0:0:0: Direct-Access     ATA      WDC WD2000FYYZ-=
0=20
1K02 PQ: 0 ANSI: 5
[    6.283937] sd 3:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2=
=2E00=20
TB/1.81 TiB)
[    6.284028] sd 3:0:0:0: [sdb] Write Protect is off
[    6.284030] sd 3:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    6.284069] sd 3:0:0:0: [sdb] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[    6.284287] sd 3:0:0:0: Attached scsi generic sg1 type 0
[    6.284491] scsi 4:0:0:0: Direct-Access     ATA      WDC WD2000FYYZ-=
0=20
1K02 PQ: 0 ANSI: 5
[    6.284768] sd 4:0:0:0: Attached scsi generic sg2 type 0
[    6.284953] scsi 5:0:0:0: Direct-Access     ATA      WDC WD2000FYYZ-=
0=20
1K02 PQ: 0 ANSI: 5
[    6.285208] sd 5:0:0:0: Attached scsi generic sg3 type 0
[    6.286051] sd 5:0:0:0: [sdd] 3907029168 512-byte logical blocks: (2=
=2E00=20
TB/1.81 TiB)
[    6.286120] sd 4:0:0:0: [sdc] 3907029168 512-byte logical blocks: (2=
=2E00=20
TB/1.81 TiB)
[    6.286243] sd 5:0:0:0: [sdd] Write Protect is off
[    6.286246] sd 5:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    6.286288] sd 4:0:0:0: [sdc] Write Protect is off
[    6.286290] sd 4:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    6.286349] sd 5:0:0:0: [sdd] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[    6.286458] sd 0:0:0:0: [sda] 937703088 512-byte logical blocks: (48=
0=20
GB/447 GiB)
[    6.286480] sd 4:0:0:0: [sdc] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[    6.286749] sd 0:0:0:0: [sda] Write Protect is off
[    6.286751] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    6.286825] sd 0:0:0:0: [sda] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[    6.292794] ata9: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    6.292859] ata15: SATA link down (SStatus 0 SControl 300)
[    6.292932] ata10: SATA link down (SStatus 0 SControl 300)
[    6.293020] ata13: SATA link down (SStatus 0 SControl 300)
[    6.293092] ata14: SATA link down (SStatus 0 SControl 300)
[    6.293171] ata16: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    6.295174]  sdd: unknown partition table
[    6.295441] sd 5:0:0:0: [sdd] Attached SCSI disk
[    6.296227]  sdb:
[    6.296468] sd 3:0:0:0: [sdb] Attached SCSI disk
[    6.296693]  sda: sda1 sda2 < sda5 >
[    6.297181] sd 0:0:0:0: [sda] Attached SCSI disk
[    6.436877] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    6.436937] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    6.437817] ata7.00: ATA-8: WDC WD2000FYYZ-01UL1B1, 01.01K02, max=20
UDMA/133
[    6.437819] ata7.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth=20
31/32), AA
[    6.437935] ata8.00: ATA-8: WDC WD2000FYYZ-01UL1B1, 01.01K02, max=20
UDMA/133
[    6.437937] ata8.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth=20
31/32), AA
[    6.460895] ata11: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    6.641374] ata16.00: ATAPI: MARVELL VIRTUALL, 1.09, max UDMA/66
[    6.641717] ata16.00: configured for UDMA/66
[    6.642321] ata9.00: ATA-8: WDC WD2000FYYZ-01UL1B1, 01.01K02, max=20
UDMA/133
[    6.642323] ata9.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth=20
31/32), AA
[    6.642334] ata11.00: ATA-8: WDC WD2000FYYZ-01UL1B1, 01.01K02, max=20
UDMA/133
[    6.642336] ata11.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth=20
31/32), AA
[    6.685074] ata12: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    6.685605] ata12.00: ATA-8: WDC WD4000F9YZ-09N20L0, 01.01A01, max=20
UDMA/133
[    6.685607] ata12.00: 7814037168 sectors, multi 0: LBA48 NCQ (depth=20
31/32), AA
[   11.437257] ata9.00: configured for UDMA/133
[   11.444691]  sdc: unknown partition table
[   11.444892] ata7.00: configured for UDMA/133
[   11.444989] scsi 6:0:0:0: Direct-Access     ATA      WDC WD2000FYYZ-=
0=20
1K02 PQ: 0 ANSI: 5
[   11.445332] sd 4:0:0:0: [sdc] Attached SCSI disk
[   11.445594] sd 6:0:0:0: [sde] 3907029168 512-byte logical blocks: (2=
=2E00=20
TB/1.81 TiB)
[   11.445679] sd 6:0:0:0: Attached scsi generic sg4 type 0
[   11.445750] sd 6:0:0:0: [sde] Write Protect is off
[   11.445752] sd 6:0:0:0: [sde] Mode Sense: 00 3a 00 00
[   11.445790] sd 6:0:0:0: [sde] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[   11.454337]  sde: unknown partition table
[   11.454650] sd 6:0:0:0: [sde] Attached SCSI disk
[   12.060877] ata11.00: configured for UDMA/133
[   12.116912] ata8.00: configured for UDMA/133
[   12.116923] PTP clock support registered
[   12.116935] ata12.00: configured for UDMA/133
[   12.199773] md: bind<sdd>
[   12.338271] scsi 7:0:0:0: Direct-Access     ATA      WDC WD2000FYYZ-=
0=20
1K02 PQ: 0 ANSI: 5
[   12.347182] md: bind<sdc>
[   12.448431] hidraw: raw HID events driver (C) Jiri Kosina
[   12.453506] sd 7:0:0:0: [sdf] 3907029168 512-byte logical blocks: (2=
=2E00=20
TB/1.81 TiB)
[   12.453598] sd 7:0:0:0: [sdf] Write Protect is off
[   12.453601] sd 7:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[   12.453639] sd 7:0:0:0: [sdf] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[   12.669411] sd 7:0:0:0: Attached scsi generic sg5 type 0
[   12.726632] random: nonblocking pool is initialized
[   12.726930]  sdf: unknown partition table
[   12.727380] sd 7:0:0:0: [sdf] Attached SCSI disk
[   12.741918] scsi 8:0:0:0: Direct-Access     ATA      WDC WD2000FYYZ-=
0=20
1K02 PQ: 0 ANSI: 5
[   12.742278] sd 8:0:0:0: Attached scsi generic sg6 type 0
[   12.742461] sd 8:0:0:0: [sdg] 3907029168 512-byte logical blocks: (2=
=2E00=20
TB/1.81 TiB)
[   12.742467] scsi 10:0:0:0: Direct-Access     ATA      WDC WD2000FYYZ=
-0=20
1K02 PQ: 0 ANSI: 5
[   12.742554] sd 8:0:0:0: [sdg] Write Protect is off
[   12.742557] sd 8:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[   12.742597] sd 8:0:0:0: [sdg] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[   12.742777] sd 10:0:0:0: [sdh] 3907029168 512-byte logical blocks:=20
(2.00 TB/1.81 TiB)
[   12.742869] sd 10:0:0:0: [sdh] Write Protect is off
[   12.742871] sd 10:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[   12.742913] sd 10:0:0:0: [sdh] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[   12.743163] sd 10:0:0:0: Attached scsi generic sg7 type 0
[   12.743441] scsi 11:0:0:0: Direct-Access     ATA      WDC WD4000F9YZ=
-0=20
1A01 PQ: 0 ANSI: 5
[   12.743854] sd 11:0:0:0: Attached scsi generic sg8 type 0
[   12.744086] sd 11:0:0:0: [sdi] 7814037168 512-byte logical blocks:=20
(4.00 TB/3.63 TiB)
[   12.744088] sd 11:0:0:0: [sdi] 4096-byte physical blocks
[   12.744203] sd 11:0:0:0: [sdi] Write Protect is off
[   12.744205] sd 11:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[   12.744261] sd 11:0:0:0: [sdi] Write cache: enabled, read cache:=20
enabled, doesn't support DPO or FUA
[   12.744436] scsi 15:0:0:0: Processor         Marvell  Console       =
  =20
1.01 PQ: 0 ANSI: 5
[   12.749777] ata16.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0=
x0
[   12.749779] ata16.00: irq_stat 0x40000001
[   12.749783] scsi 15:0:0:0: CDB:=20
[   12.749787] Inquiry: 12 01 00 00 ff 00
[   12.749793] ata16.00: cmd a0/01:00:00:00:01/00:00:00:00:00/a0 tag 3 =
dma=20
16640 in res 50/00:02:00:00:00/00:00:00:00:00/a0 Emask 0x1 (device erro=
r)
[   12.749794] ata16.00: status: { DRDY }
[   12.750061] scsi 15:0:0:0: Attached scsi generic sg9 type 3
[   14.470729]  sdh: unknown partition table
[   14.508071]  sdi: sdi1
[   14.508430] sd 11:0:0:0: [sdi] Attached SCSI disk
[   14.656895] dca service started, version 1.12.1
[   14.656927]  sdg: unknown partition table
[   14.657167] sd 10:0:0:0: [sdh] Attached SCSI disk
[   14.657248] sd 8:0:0:0: [sdg] Attached SCSI disk
[   14.901586] md: raid0 personality registered for level 0
[   14.968207] md: raid1 personality registered for level 1
[   15.028744] igb: Intel(R) Gigabit Ethernet Network Driver - version=20
5.2.13-k
[   15.031559] md: bind<sdb>
[   15.151157] igb: Copyright (c) 2007-2014 Intel Corporation.
[   15.152129] igb 0000:07:00.0: irq 52 for MSI/MSI-X
[   15.152135] igb 0000:07:00.0: irq 53 for MSI/MSI-X
[   15.152140] igb 0000:07:00.0: irq 54 for MSI/MSI-X
[   15.152147] igb 0000:07:00.0: irq 55 for MSI/MSI-X
[   15.152152] igb 0000:07:00.0: irq 56 for MSI/MSI-X
[   15.188784] igb 0000:07:00.0: added PHC on eth0
[   15.188786] igb 0000:07:00.0: Intel(R) Gigabit Ethernet Network=20
Connection
[   15.188789] igb 0000:07:00.0: eth0: (PCIe:2.5Gb/s:Width x1)=20
d0:50:99:45:e7:a2
[   15.188918] igb 0000:07:00.0: eth0: PBA No: 001300-000
[   15.188920] igb 0000:07:00.0: Using MSI-X interrupts. 4 rx queue(s),=
 4=20
tx queue(s)
[   15.189754] igb 0000:08:00.0: irq 57 for MSI/MSI-X
[   15.189761] igb 0000:08:00.0: irq 58 for MSI/MSI-X
[   15.189766] igb 0000:08:00.0: irq 59 for MSI/MSI-X
[   15.189771] igb 0000:08:00.0: irq 60 for MSI/MSI-X
[   15.189776] igb 0000:08:00.0: irq 61 for MSI/MSI-X
[   15.215617] raid6: sse2x1     806 MB/s
[   15.226907] igb 0000:08:00.0: added PHC on eth1
[   15.226909] igb 0000:08:00.0: Intel(R) Gigabit Ethernet Network=20
Connection
[   15.226911] igb 0000:08:00.0: eth1: (PCIe:2.5Gb/s:Width x1)=20
d0:50:99:45:e7:a3
[   15.227039] igb 0000:08:00.0: eth1: PBA No: 001300-000
[   15.227041] igb 0000:08:00.0: Using MSI-X interrupts. 4 rx queue(s),=
 4=20
tx queue(s)
[   15.283688] raid6: sse2x2    1050 MB/s
[   15.336749] md: bind<sde>
[   15.351743] raid6: sse2x4    1825 MB/s
[   15.351745] raid6: using algorithm sse2x4 (1825 MB/s)
[   15.351746] raid6: using ssse3x2 recovery algorithm
[   15.458061] md: bind<sdg>
[   15.458361] xor: measuring software checksum speed
[   15.495852]    prefetch64-sse:  8697.000 MB/sec
[   15.535879]    generic_sse:  7937.000 MB/sec
[   15.535880] xor: using function: prefetch64-sse (8697.000 MB/sec)
[   15.580910] md: bind<sdf>
[   15.729506] usbcore: registered new interface driver usbhid
[   15.729507] usbhid: USB HID core driver
[   15.758850] md: bind<sdh>
[   15.818660] async_tx: api initialized (async)
[   16.331090] input: DELL Dell USB Wired Multimedia Keyboard as=20
/devices/pci0000:00/0000:00:16.0/usb1/1-1/1-1.1/1-1.1:1.0/0003:413C:211=
2.00
01/input/input2
[   16.331272] hid-generic 0003:413C:2112.0001: input,hidraw0: USB HID=20
v1.10 Keyboard [DELL Dell USB Wired Multimedia Keyboard] on=20
usb-0000:00:16.0-1.1/input0
[   16.332699] input: DELL Dell USB Wired Multimedia Keyboard as=20
/devices/pci0000:00/0000:00:16.0/usb1/1-1/1-1.1/1-1.1:1.1/0003:413C:211=
2.00
02/input/input3
[   16.332872] hid-generic 0003:413C:2112.0002: input,hidraw1: USB HID=20
v1.10 Device [DELL Dell USB Wired Multimedia Keyboard] on=20
usb-0000:00:16.0-1.1/input1
[   17.175095] md: raid6 personality registered for level 6
[   17.239252] md: raid5 personality registered for level 5
[   17.302453] md: raid4 personality registered for level 4
[   17.374907] md: raid10 personality registered for level 10
[   17.441805] systemd-udevd[125]: renamed network interface eth0 to p1=
19p1
[   17.625710] systemd-udevd[127]: renamed network interface eth1 to p1=
21p1
[   17.861420] EXT4-fs (sda1): mounted filesystem with ordered data mod=
e.=20
Opts: (null)
[   18.067549] hid-generic 0003:051D:0002.0003: hiddev0,hidraw2: USB HI=
D=20
v1.10 Device [American Power Conversion Back-UPS CS 500 FW:808.q8.I USB=
=20
=46W:q8] on usb-0000:00:16.0-1.2/input0
[   18.210613] input: American Megatrends Inc. Virtual Keyboard and Mou=
se=20
as=20
/devices/pci0000:00/0000:00:16.0/usb1/1-1/1-1.4/1-1.4.4/1-1.4.4:1.0/000=
3:04
6B:FF10.0004/input/input4
[   18.210762] hid-generic 0003:046B:FF10.0004: input,hidraw3: USB HID=20
v1.10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on=
=20
usb-0000:00:16.0-1.4.4/input0
[   18.210915] input: American Megatrends Inc. Virtual Keyboard and Mou=
se=20
as=20
/devices/pci0000:00/0000:00:16.0/usb1/1-1/1-1.4/1-1.4.4/1-1.4.4:1.1/000=
3:04
6B:FF10.0005/input/input5
[   18.211063] hid-generic 0003:046B:FF10.0005: input,hidraw4: USB HID=20
v1.10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on=20
usb-0000:00:16.0-1.4.4/input1
[   19.046203] init: plymouth-upstart-bridge main process (258) termina=
ted=20
with status 1
[   19.132023] init: plymouth-upstart-bridge main process ended, respaw=
ning
[   19.347982] EXT4-fs (sda1): re-mounted. Opts: errors=3Dremount-ro
[   20.538396] systemd-udevd[475]: starting version 208
[   20.613582] shpchp: Standard Hot Plug PCI Controller Driver version:=
 0.4
[   20.634330] bonding: Ethernet Channel Bonding Driver: v3.7.1 (April =
27,=20
2011)
[   20.634337] bonding: Warning: miimon must be specified, otherwise=20
bonding will not detect link failure, speed and duplex which are essent=
ial=20
for 802.3ad operation
[   20.634339] bonding: Forcing miimon to 100msec
[   20.634341] bonding: MII link monitoring set to 100 ms
[   20.654879] ipmi message handler version 39.2
[   20.657974] IPMI System Interface driver.
[   20.658031] ipmi_si: probing via ACPI
[   20.658068] ipmi_si 00:07: [io  0x0ca2] regsize 1 spacing 1 irq 0
[   20.658071] ipmi_si: Adding ACPI-specified kcs state machine
[   20.658097] ipmi_si: probing via SPMI
[   20.658100] ipmi_si: SPMI: io 0xca8 regsize 1 spacing 1 irq 0
[   20.658102] ipmi_si: Adding SPMI-specified kcs state machine
[   20.658106] ipmi_si: Trying ACPI-specified kcs state machine at i/o=20
address 0xca2, slave address 0x0, irq 0
[   20.674570] ismt_smbus 0000:00:13.0: irq 62 for MSI/MSI-X
[   20.716881] [drm] Initialized drm 1.1.0 20060810
[   20.738741] [drm] AST 2300 detected
[   20.738779] [drm] dram 1632000000 1 32 01000000
[   20.739578] [TTM] Zone  kernel: Available graphics memory: 16460818 =
kiB
[   20.739587] [TTM] Zone   dma32: Available graphics memory: 2097152 k=
iB
[   20.739595] [TTM] Initializing pool allocator
[   20.739609] [TTM] Initializing DMA pool allocator
[   20.811833] audit: type=3D1400 audit(1428871421.293:2): apparmor=3D"=
STATUS"=20
operation=3D"profile_load" profile=3D"unconfined" name=3D"/sbin/dhclien=
t"=20
pid=3D568 comm=3D"apparmor_parser"
[   20.811845] audit: type=3D1400 audit(1428871421.293:3): apparmor=3D"=
STATUS"=20
operation=3D"profile_load" profile=3D"unconfined"=20
name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D568=20
comm=3D"apparmor_parser"
[   20.811853] audit: type=3D1400 audit(1428871421.293:4): apparmor=3D"=
STATUS"=20
operation=3D"profile_load" profile=3D"unconfined"=20
name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D568=20
comm=3D"apparmor_parser"
[   20.813440] audit: type=3D1400 audit(1428871421.297:5): apparmor=3D"=
STATUS"=20
operation=3D"profile_replace" profile=3D"unconfined" name=3D"/sbin/dhcl=
ient"=20
pid=3D570 comm=3D"apparmor_parser"
[   20.813454] audit: type=3D1400 audit(1428871421.297:6): apparmor=3D"=
STATUS"=20
operation=3D"profile_replace" profile=3D"unconfined"=20
name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D570=20
comm=3D"apparmor_parser"
[   20.813462] audit: type=3D1400 audit(1428871421.297:7): apparmor=3D"=
STATUS"=20
operation=3D"profile_replace" profile=3D"unconfined"=20
name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D570=20
comm=3D"apparmor_parser"
[   20.833286] checking generic (de000000 300000) vs hw (de000000 10000=
00)
[   20.833292] fb: switching to astdrmfb from VESA VGA
[   20.833327] Console: switching to colour dummy device 80x25
[   20.838100] fbcon: astdrmfb (fb0) is primary device
[   20.867738] Console: switching to colour frame buffer device 180x56
[   20.906787] ast 0000:06:00.0: fb0: astdrmfb frame buffer device
[   20.906790] ast 0000:06:00.0: registered panic notifier
[   20.938914] init: avahi-cups-reload main process (624) terminated wi=
th=20
status 1
[   20.940219] [drm] Initialized ast 0.1.0 20120228 for 0000:06:00.0 on=
=20
minor 0
[   20.982956] SSE version of gcm_enc/dec engaged.
[   21.016417] ipmi_si 00:07: Found new BMC (man_id: 0x000000, prod_id:=
=20
0xaabb, dev_id: 0x20)
[   21.016435] ipmi_si 00:07: IPMI kcs interface initialized
[   21.191014] gpio_ich: GPIO from 196 to 255 on gpio_ich
[   21.409788] IPv6: ADDRCONF(NETDEV_UP): bond0: link is not ready
[   21.421277] bonding: bond0: Adding slave p119p1
[   21.678578] IPv6: ADDRCONF(NETDEV_UP): p119p1: link is not ready
[   21.678883] bonding: bond0: Enslaving p119p1 as a backup interface w=
ith=20
a down link
[   21.680512] bonding: bond0: Adding slave p121p1
[   21.931185] IPv6: ADDRCONF(NETDEV_UP): p121p1: link is not ready
[   21.931511] bonding: bond0: Enslaving p121p1 as a backup interface w=
ith=20
a down link
[   24.639849] igb 0000:08:00.0 p121p1: igb: p121p1 NIC Link is Up 1000=
=20
Mbps Full Duplex, Flow Control: RX
[   24.711100] bonding: bond0: link status up for interface p121p1,=20
enabling it in 0 ms
[   24.711110] bonding: bond0: link status definitely up for interface=20
p121p1, 1000 Mbps full duplex
[   24.711116] bonding: bond0: now running without any active interface=
!
[   24.711440] IPv6: ADDRCONF(NETDEV_CHANGE): bond0: link becomes ready
[   25.168255] igb 0000:07:00.0 p119p1: igb: p119p1 NIC Link is Up 1000=
=20
Mbps Full Duplex, Flow Control: RX
[   25.211419] bonding: bond0: link status up for interface p119p1,=20
enabling it in 200 ms
[   25.411569] bonding: bond0: link status definitely up for interface=20
p119p1, 1000 Mbps full duplex
[   36.150836] init: failsafe main process (770) killed by TERM signal
[   36.253915] audit: type=3D1400 audit(1428871436.725:8): apparmor=3D"=
STATUS"=20
operation=3D"profile_replace" profile=3D"unconfined" name=3D"/sbin/dhcl=
ient"=20
pid=3D1112 comm=3D"apparmor_parser"
[   36.253930] audit: type=3D1400 audit(1428871436.725:9): apparmor=3D"=
STATUS"=20
operation=3D"profile_replace" profile=3D"unconfined"=20
name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D1112=20
comm=3D"apparmor_parser"
[   36.253938] audit: type=3D1400 audit(1428871436.725:10):=20
apparmor=3D"STATUS" operation=3D"profile_replace" profile=3D"unconfined=
"=20
name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D1112=20
comm=3D"apparmor_parser"
[   36.256053] audit: type=3D1400 audit(1428871436.729:11):=20
apparmor=3D"STATUS" operation=3D"profile_load" profile=3D"unconfined"=20
name=3D"/usr/sbin/tcpdump" pid=3D1112 comm=3D"apparmor_parser"
[   39.963233] init: plymouth-upstart-bridge main process ended, respaw=
ning
[   47.495473] systemd-logind[1716]: New seat seat0.
[   47.496236] systemd-logind[1716]: Watching system buttons on=20
/dev/input/event0 (Power Button)
[   47.498844] systemd-logind[1716]: Failed to start unit=20
user@1000.service: Unknown unit: user@1000.service
[   47.498933] systemd-logind[1716]: Failed to start user service: Unkn=
own=20
unit: user@1000.service
[   47.500096] systemd-logind[1716]: New session 1 of user tm.
[ 1401.719683] md: md127 stopped.
[ 1401.719704] md: unbind<sdh>
[ 1401.733947] md: export_rdev(sdh)
[ 1401.734095] md: unbind<sdf>
[ 1401.745943] md: export_rdev(sdf)
[ 1401.746030] md: unbind<sdg>
[ 1401.753964] md: export_rdev(sdg)
[ 1401.754049] md: unbind<sde>
[ 1401.761953] md: export_rdev(sde)
[ 1401.762038] md: unbind<sdb>
[ 1401.769959] md: export_rdev(sdb)
[ 1401.770038] md: unbind<sdc>
[ 1401.785975] md: export_rdev(sdc)
[ 1401.786064] md: unbind<sdd>
[ 1401.793981] md: export_rdev(sdd)
[ 1403.392910] md: md127 stopped.
[ 1403.396139] md: bind<sdd>
[ 1403.397115] md: bind<sde>
[ 1403.397349] md: bind<sdf>
[ 1403.397532] md: bind<sdg>
[ 1403.397686] md: bind<sdb>
[ 1403.397846] md: bind<sdh>
[ 1403.397985] md: bind<sdc>
[ 1403.398356] md: md127 stopped.
[ 1403.398369] md: unbind<sdc>
[ 1403.415283] md: export_rdev(sdc)
[ 1403.415342] md: unbind<sdh>
[ 1403.435259] md: export_rdev(sdh)
[ 1403.435290] md: unbind<sdb>
[ 1403.447270] md: export_rdev(sdb)
[ 1403.447298] md: unbind<sdg>
[ 1403.459253] md: export_rdev(sdg)
[ 1403.459268] md: unbind<sdf>
[ 1403.471260] md: export_rdev(sdf)
[ 1403.471275] md: unbind<sde>
[ 1403.483287] md: export_rdev(sde)
[ 1403.483302] md: unbind<sdd>
[ 1403.495283] md: export_rdev(sdd)
[40799.136302] systemd-logind[1716]: New session 16 of user tm.
[40862.518901] md: md127 stopped.
[40862.521171] md: bind<sde>
[40862.521397] md: bind<sdf>
[40862.521647] md: bind<sdg>
[40862.521874] md: bind<sdb>
[40862.522105] md: bind<sdh>
[40862.522303] md: bind<sdc>
[40862.522394] md: md127 stopped.
[40862.522406] md: unbind<sdc>
[40862.551020] md: export_rdev(sdc)
[40862.551104] md: unbind<sdh>
[40862.571029] md: export_rdev(sdh)
[40862.571060] md: unbind<sdb>
[40862.583040] md: export_rdev(sdb)
[40862.583073] md: unbind<sdg>
[40862.595022] md: export_rdev(sdg)
[40862.595036] md: unbind<sdf>
[40862.611045] md: export_rdev(sdf)
[40862.611061] md: unbind<sde>
[40862.627062] md: export_rdev(sde)
[41116.350227] systemd-logind[1716]: New session 17 of user tm.
[42775.055674] md: md127 stopped.
[42775.057210] md: bind<sdd>
[42775.057329] md: bind<sde>
[42775.057438] md: bind<sdf>
[42775.057571] md: bind<sdg>
[42775.057711] md: bind<sdb>
[42775.057836] md: bind<sdh>
[42775.057947] md: bind<sdc>
[42775.057992] md: md127 stopped.
[42775.057999] md: unbind<sdc>
[42775.081647] md: export_rdev(sdc)
[42775.081711] md: unbind<sdh>
[42775.089613] md: export_rdev(sdh)
[42775.089648] md: unbind<sdb>
[42775.105598] md: export_rdev(sdb)
[42775.105629] md: unbind<sdg>
[42775.109950] md: export_rdev(sdg)
[42775.109966] md: unbind<sdf>
[42775.117639] md: export_rdev(sdf)
[42775.117655] md: unbind<sde>
[42775.125644] md: export_rdev(sde)
[42775.125659] md: unbind<sdd>
[42775.133648] md: export_rdev(sdd)
[53243.732604] systemd-logind[1716]: New session 23 of user tm.
[56415.677328] systemd-logind[1716]: New session 25 of user tm=20






=8A. but i have kern.log  form the fatal  day

>
>Next, boot with a recent liveCD that has mdadm utilities (I recommend
>systemrescuecd from sysrescuecd.org.) and use its kernel and tools to
>try "mdadm -Afv /dev/md0 /dev/sd[b-h]=B2=20

Ok , i=B9m downloading,  but only can try tonight, when =8Cim back home=
=20
>
>You may have to --stop a partial assembly, as rescue CDs often attempt
>to assemble arrays found.  And adjust the device letters if it boots
>with your system disk as other than sda.
>
>Show the mdadm output if it fails.  If it works, back up your critical
>files immediately.  You should then do a clean shutdown, and it should
>let you boot back into your original system.

ok
>
>Phil

Thx, thomas
=20
>


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

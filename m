From: Phil Turmel <philip@turmel.org>
Subject: Re: reaid problem at reboot
Date: Tue, 21 Jun 2011 17:58:22 -0400
Message-ID: <4E0113FE.503@turmel.org>
References: <BAY158-W207004CCDC35695F84D5B4C0510@phx.gbl>,<4E00FC8A.1050908@turmel.org> <BAY158-w388BBEAFF686EAA222B346C0510@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY158-w388BBEAFF686EAA222B346C0510@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: william L'Heureux <wil_c_will@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi William,

On 06/21/2011 04:50 PM, william L'Heureux wrote:
>=20
> ./lsdrv
> PCI [sata_mv] 02:01.0 SCSI storage controller: Marvell Technology Gro=
up Ltd. MV8                                                            =
                            8SX6081 8-port SATA II PCI-X Controller (re=
v 09)
>  =C3=A2=C3=A2scsi 0:0:0:0 ATA Hitachi HDS72202 {JK1171YAGA977S}
>  =C3=A2  =C3=A2=C3=A2sda: [8:0] Partitioned (gpt) 1.82t
>  =C3=A2     =C3=A2=C3=A2sda1: [8:1] MD raid6 (6) 1.82t inactive 'BILL=
SSHACK:0' {3bcf45ef-da3e-d                                             =
                                           e81-09a8-d6635b58832d}
>  =C3=A2     =C3=A2=C3=A2sda2: [8:2] Empty/Unknown 1.00g
>  =C3=A2=C3=A2scsi 1:0:0:0 ATA WL2000GSA1672 {WOL240094387}
>  =C3=A2  =C3=A2=C3=A2sdb: [8:16] Partitioned (gpt) 1.82t
>  =C3=A2     =C3=A2=C3=A2sdb1: [8:17] MD raid6 (6) 1.82t inactive 'bil=
lsshack:3' {751fd632-4baf-                                             =
                                           7d64-ec26-eec1046592bc}
>  =C3=A2     =C3=A2=C3=A2sdb2: [8:18] Empty/Unknown 1.00g
>  =C3=A2=C3=A2scsi 2:x:x:x [Empty]
>  =C3=A2=C3=A2scsi 3:x:x:x [Empty]
>  =C3=A2=C3=A2scsi 4:0:0:0 ATA WL2000GSA1672 {WOL240094356}
>  =C3=A2  =C3=A2=C3=A2sdc: [8:32] Partitioned (gpt) 1.82t
>  =C3=A2     =C3=A2=C3=A2sdc1: [8:33] MD raid6 (6) 1.82t inactive 'BIL=
LSSHACK:0' {3bcf45ef-da3e-                                             =
                                           de81-09a8-d6635b58832d}
>  =C3=A2     =C3=A2=C3=A2sdc2: [8:34] Empty/Unknown 1.00g
>  =C3=A2=C3=A2scsi 5:0:0:0 ATA WL2000GSA3272C {WOL240146377}
>  =C3=A2  =C3=A2=C3=A2sdd: [8:48] Partitioned (gpt) 1.82t
>  =C3=A2     =C3=A2=C3=A2sdd1: [8:49] MD raid6 (6) 1.82t inactive 'BIL=
LSSHACK:0' {3bcf45ef-da3e-                                             =
                                           de81-09a8-d6635b58832d}
>  =C3=A2     =C3=A2=C3=A2sdd2: [8:50] Empty/Unknown 1.00g
>  =C3=A2=C3=A2scsi 6:x:x:x [Empty]
>  =C3=A2=C3=A2scsi 7:x:x:x [Empty]
> PCI [sata_mv] 03:02.0 SCSI storage controller: Marvell Technology Gro=
up Ltd. MV8                                                            =
                            8SX6081 8-port SATA II PCI-X Controller (re=
v 09)
>  =C3=A2=C3=A2scsi 8:0:0:0 ATA WL2000GSA3272 {WOL240102099}
>  =C3=A2  =C3=A2=C3=A2sde: [8:64] Partitioned (gpt) 1.82t
>  =C3=A2     =C3=A2=C3=A2sde1: [8:65] MD raid6 (6) 1.82t inactive 'bil=
lsshack:3' {751fd632-4baf-                                             =
                                           7d64-ec26-eec1046592bc}
>  =C3=A2     =C3=A2=C3=A2sde2: [8:66] Empty/Unknown 1.00g
>  =C3=A2=C3=A2scsi 9:x:x:x [Empty]
>  =C3=A2=C3=A2scsi 10:0:0:0 ATA Hitachi HDS72202 {JK1171YAGDDUGS}
>  =C3=A2  =C3=A2=C3=A2sdf: [8:80] Partitioned (gpt) 1.82t
>  =C3=A2     =C3=A2=C3=A2sdf1: [8:81] MD raid6 (6) 1.82t inactive 'bil=
lsshack:3' {751fd632-4baf-                                             =
                                           7d64-ec26-eec1046592bc}
>  =C3=A2     =C3=A2=C3=A2sdf2: [8:82] Empty/Unknown 1.00g
>  =C3=A2=C3=A2scsi 11:0:0:0 ATA ST32000542AS {6XW1B8WP}
>  =C3=A2  =C3=A2=C3=A2sdg: [8:96] Partitioned (gpt) 1.82t
>  =C3=A2     =C3=A2=C3=A2sdg1: [8:97] MD raid6 (6) 1.82t inactive 'bil=
lsshack:3' {751fd632-4baf-                                             =
                                           7d64-ec26-eec1046592bc}
>  =C3=A2     =C3=A2=C3=A2sdg2: [8:98] Empty/Unknown 1.00g
>  =C3=A2=C3=A2scsi 12:0:0:0 ATA WL2000GSA3272 {WOL240102098}
>  =C3=A2  =C3=A2=C3=A2sdh: [8:112] Partitioned (gpt) 1.82t
>  =C3=A2     =C3=A2=C3=A2sdh1: [8:113] MD raid6 (6) 1.82t inactive 'BI=
LLSSHACK:0' {3bcf45ef-da3e                                             =
                                           -de81-09a8-d6635b58832d}
>  =C3=A2     =C3=A2=C3=A2sdh2: [8:114] Empty/Unknown 1.00g
>  =C3=A2=C3=A2scsi 13:0:0:0 ATA WDC WD20EADS-00S {WD-WCAVY3323665}
>  =C3=A2  =C3=A2=C3=A2sdi: [8:128] Partitioned (gpt) 1.82t
>  =C3=A2     =C3=A2=C3=A2sdi1: [8:129] MD raid6 (6) 1.82t inactive 'BI=
LLSSHACK:0' {3bcf45ef-da3e                                             =
                                           -de81-09a8-d6635b58832d}
>  =C3=A2     =C3=A2=C3=A2sdi2: [8:130] Empty/Unknown 1.00g
>  =C3=A2=C3=A2scsi 14:0:0:0 ATA WDC WD20EADS-00S {WD-WCAVY3356471}
>  =C3=A2  =C3=A2=C3=A2sdj: [8:144] Partitioned (gpt) 1.82t
>  =C3=A2     =C3=A2=C3=A2sdj1: [8:145] MD raid6 (6) 1.82t inactive 'BI=
LLSSHACK:0' {3bcf45ef-da3e                                             =
                                           -de81-09a8-d6635b58832d}
>  =C3=A2     =C3=A2=C3=A2sdj2: [8:146] Empty/Unknown 1.00g
>  =C3=A2=C3=A2scsi 15:x:x:x [Empty]
> PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (=
ICH9R/DO/DH                                                            =
                            ) 6 port SATA AHCI Controller (rev 02)
>  =C3=A2=C3=A2scsi 16:x:x:x [Empty]
>  =C3=A2=C3=A2scsi 17:x:x:x [Empty]
>  =C3=A2=C3=A2scsi 18:0:0:0 ATA WDC WD20EADS-00S {WD-WCAVY3286477}
>  =C3=A2  =C3=A2=C3=A2sdk: [8:160] Partitioned (gpt) 1.82t
>  =C3=A2     =C3=A2=C3=A2sdk1: [8:161] MD raid6 (6) 1.82t inactive 'bi=
llsshack:3' {751fd632-4baf                                             =
                                           -7d64-ec26-eec1046592bc}
>  =C3=A2     =C3=A2=C3=A2sdk2: [8:162] Empty/Unknown 1.00g
>  =C3=A2=C3=A2scsi 19:0:0:0 ATA WDC WD400BD-60LT {WD-WMAME1857443}
>  =C3=A2  =C3=A2=C3=A2sdl: [8:176] Partitioned (dos) 37.27g
>  =C3=A2     =C3=A2=C3=A2sdl1: [8:177] Partitioned (dos) 133.32m {617e=
6b03-6cc1-4974-8acc-19a742                                             =
                                           cd06f4}
>  =C3=A2     =C3=A2  =C3=A2=C3=A2Mounted as /dev/sdl1 @ /boot
>  =C3=A2     =C3=A2=C3=A2sdl2: [8:178] PV LVM2_member 22.00g/37.14g VG=
 vgDeb 37.14g {0ecAby-vT4R                                             =
                                           -IHpt-5kEK-v1W0-u6AL-bUcFDG}
>  =C3=A2         =C3=A2=C3=A2Volume Group vgDeb (sdl2) 15.14g free {a6=
nM6t-LPKY-gMdi-9YP4-t2tv-H                                             =
                                           qjv-aMgmEa}
>  =C3=A2           =C3=A2=C3=A2dm-1: [251:1] LV 'root' (reiserfs) 10.0=
0g {f497b9bd-e24f-4d20-9f6                                             =
                                           b-282b6493f341}
>  =C3=A2           =C3=A2  =C3=A2=C3=A2Mounted as /dev/mapper/vgDeb-ro=
ot @ /mnt/debian
>  =C3=A2           =C3=A2=C3=A2dm-2: [251:2] LV 'rootu' (reiserfs) 10.=
00g {bc0f350c-4af7-4192-b1                                             =
                                           ea-4528101db28e}
>  =C3=A2           =C3=A2  =C3=A2=C3=A2Mounted as /dev/mapper/vgDeb-ro=
otu @ /
>  =C3=A2           =C3=A2=C3=A2dm-0: [251:0] LV 'swap' (swap) 2.00g {1=
3264e60-a1d1-4bf3-af9f-edd                                             =
                                           948212a63}
>  =C3=A2=C3=A2scsi 20:0:0:0 ATA WDC WD20EADS-00S {WD-WCAVY3271728}
>  =C3=A2  =C3=A2=C3=A2sdm: [8:192] MD raid6 (4) 1.82t inactive {b52df5=
61-301f-043c-b5a7-b1ab9d93                                             =
                                           4878}
>  =C3=A2     =C3=A2=C3=A2sdm1: [8:193] MD raid6 (6) 1.82t inactive 'bi=
llsshack:3' {751fd632-4baf                                             =
                                           -7d64-ec26-eec1046592bc}
>  =C3=A2     =C3=A2=C3=A2sdm2: [8:194] MD raid6 (6) 1.00g inactive 'bi=
llsshack:2' {cf2450e4-bc7a                                             =
                                           -9cea-cb5c-cda96f3ec87c}
>  =C3=A2=C3=A2scsi 21:x:x:x [Empty]
> Other Block Devices
>  =C3=A2=C3=A2ram0: [1:0] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram1: [1:1] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram2: [1:2] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram3: [1:3] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram4: [1:4] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram5: [1:5] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram6: [1:6] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram7: [1:7] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram8: [1:8] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram9: [1:9] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram10: [1:10] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram11: [1:11] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram12: [1:12] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram13: [1:13] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram14: [1:14] Empty/Unknown 64.00m
>  =C3=A2=C3=A2ram15: [1:15] Empty/Unknown 64.00m

OK.  We know the basic layout.  (I think I'm going to have to give up t=
he fancy line-drawing characters.  Very few emails get them right...)

>  mdadm --detail /dev/md0 /dev/md1
> /dev/md0:
>         Version : 1.2
>   Creation Time : Tue Jun 21 11:23:46 2011
>      Raid Level : raid6
>      Array Size : 7809854976 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 1952463744 (1862.01 GiB 1999.32 GB)
>    Raid Devices : 6
>   Total Devices : 6
>     Persistence : Superblock is persistent
> =20
>     Update Time : Tue Jun 21 11:23:46 2011
>           State : clean
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>            Name : BILLSSHACK:0  (local to host BILLSSHACK)
>            UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
>          Events : 0
> =20
>     Number   Major   Minor   RaidDevice State
>        0       8        1        0      active sync   /dev/sda1
>        1       8       33        1      active sync   /dev/sdc1
>        2       8       49        2      active sync   /dev/sdd1
>        3       8      113        3      active sync   /dev/sdh1
>        4       8      129        4      active sync   /dev/sdi1
>        5       8      145        5      active sync   /dev/sdj1
> /dev/md1:
>         Version : 1.2
>   Creation Time : Tue Jun 15 09:59:08 2010
>      Raid Level : raid6
>      Array Size : 7809855488 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 1952463872 (1862.01 GiB 1999.32 GB)
>    Raid Devices : 6
>   Total Devices : 6
>     Persistence : Superblock is persistent
> =20
>   Intent Bitmap : Internal
> =20
>     Update Time : Tue Jun 14 20:58:11 2011
>           State : active
>  Active Devices : 6
> Working Devices : 6
>  Failed Devices : 0
>   Spare Devices : 0
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>            Name : billsshack:3
>            UUID : 751fd632:4baf7d64:ec26eec1:046592bc
>          Events : 235082
> =20
>     Number   Major   Minor   RaidDevice State
>        0       8      161        0      active sync   /dev/sdk1
>        1       8       17        1      active sync   /dev/sdb1
>        8       8      193        2      active sync   /dev/sdm1
>        5       8       81        3      active sync   /dev/sdf1
>        6       8       65        4      active sync   /dev/sde1
>        7       8       97        5      active sync   /dev/sdg1

It is not immediately clear from this, or from your first email, which =
of your two raid6 arrays is messed up.

> mdadm --examine /dev/sd[abcdefghijkm]1
> /dev/sda1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
>            Name : BILLSSHACK:0  (local to host BILLSSHACK)
>   Creation Time : Tue Jun 21 11:23:46 2011
>      Raid Level : raid6
>    Raid Devices : 6
> =20
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 15619709952 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 3904927488 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : b6569293:759c2fbe:d52f346f:2ea85306
> =20
>     Update Time : Tue Jun 21 16:35:23 2011
>        Checksum : 9d90c200 - correct
>          Events : 2
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>    Device Role : Active device 0
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

2048 sectors offset.  This is important.


> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 751fd632:4baf7d64:ec26eec1:046592bc
>            Name : billsshack:3
>   Creation Time : Tue Jun 15 09:59:08 2010
>      Raid Level : raid6
>    Raid Devices : 6
> =20
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 15619710976 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 3904927744 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 0b6a5d24:bff1c401:259c054b:ca7ccc7f
> =20
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Tue Jun 21 16:35:23 2011
>        Checksum : bed09424 - correct
>          Events : 235082
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>    Device Role : Active device 1
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdc1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
>            Name : BILLSSHACK:0  (local to host BILLSSHACK)
>   Creation Time : Tue Jun 21 11:23:46 2011
>      Raid Level : raid6
>    Raid Devices : 6
> =20
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 15619709952 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 3904927488 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 298ee23a:4968978c:0557d189:1c45ff55
> =20
>     Update Time : Tue Jun 21 16:35:23 2011
>        Checksum : 7d918966 - correct
>          Events : 2
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>    Device Role : Active device 1
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdd1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
>            Name : BILLSSHACK:0  (local to host BILLSSHACK)
>   Creation Time : Tue Jun 21 11:23:46 2011
>      Raid Level : raid6
>    Raid Devices : 6
> =20
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 15619709952 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 3904927488 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 2b8ef61c:d3d59200:659d4367:573a992d
> =20
>     Update Time : Tue Jun 21 16:35:23 2011
>        Checksum : 88ad328d - correct
>          Events : 2
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>    Device Role : Active device 2
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sde1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 751fd632:4baf7d64:ec26eec1:046592bc
>            Name : billsshack:3
>   Creation Time : Tue Jun 15 09:59:08 2010
>      Raid Level : raid6
>    Raid Devices : 6
> =20
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 15619710976 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 3904927744 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 1de7b73d:73ff1f80:c0903159:87fc8287
> =20
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Tue Jun 21 16:35:23 2011
>        Checksum : 6c689348 - correct
>          Events : 235082
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>    Device Role : Active device 4
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 751fd632:4baf7d64:ec26eec1:046592bc
>            Name : billsshack:3
>   Creation Time : Tue Jun 15 09:59:08 2010
>      Raid Level : raid6
>    Raid Devices : 6
> =20
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 15619710976 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 3904927744 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 3247b37b:aa741693:0d58ccb6:b814a5d1
> =20
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Tue Jun 21 16:35:23 2011
>        Checksum : 65174812 - correct
>          Events : 235082
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>    Device Role : Active device 3
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdg1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 751fd632:4baf7d64:ec26eec1:046592bc
>            Name : billsshack:3
>   Creation Time : Tue Jun 15 09:59:08 2010
>      Raid Level : raid6
>    Raid Devices : 6
> =20
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 15619710976 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 3904927744 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 8483b8f7:8c3302c6:9403a3e9:3c3a094c
> =20
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Tue Jun 21 16:35:23 2011
>        Checksum : c1431453 - correct
>          Events : 235082
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>    Device Role : Active device 5
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdh1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
>            Name : BILLSSHACK:0  (local to host BILLSSHACK)
>   Creation Time : Tue Jun 21 11:23:46 2011
>      Raid Level : raid6
>    Raid Devices : 6
> =20
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 15619709952 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 3904927488 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 1abe5069:570c484e:2199572d:cd0d641f
> =20
>     Update Time : Tue Jun 21 16:35:23 2011
>        Checksum : da9b6833 - correct
>          Events : 2
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>    Device Role : Active device 3
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdi1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
>            Name : BILLSSHACK:0  (local to host BILLSSHACK)
>   Creation Time : Tue Jun 21 11:23:46 2011
>      Raid Level : raid6
>    Raid Devices : 6
> =20
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 15619709952 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 3904927488 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 083fa0cc:798c09bb:febe5adf:f99eb7b8
> =20
>     Update Time : Tue Jun 21 16:35:23 2011
>        Checksum : f603204f - correct
>          Events : 2
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>    Device Role : Active device 4
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdj1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
>            Name : BILLSSHACK:0  (local to host BILLSSHACK)
>   Creation Time : Tue Jun 21 11:23:46 2011
>      Raid Level : raid6
>    Raid Devices : 6
> =20
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 15619709952 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 3904927488 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : b91a18a4:8aba8cf8:bf046c8f:f683cf16
> =20
>     Update Time : Tue Jun 21 16:35:23 2011
>        Checksum : 192754d0 - correct
>          Events : 2
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>    Device Role : Active device 5
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdk1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 751fd632:4baf7d64:ec26eec1:046592bc
>            Name : billsshack:3
>   Creation Time : Tue Jun 15 09:59:08 2010
>      Raid Level : raid6
>    Raid Devices : 6
> =20
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 15619710976 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 3904927744 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 77b91aac:68eed1cc:e2404d60:f5962abc
> =20
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Tue Jun 21 16:35:23 2011
>        Checksum : 63409f22 - correct
>          Events : 235082
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>    Device Role : Active device 0
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
> /dev/sdm1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : 751fd632:4baf7d64:ec26eec1:046592bc
>            Name : billsshack:3
>   Creation Time : Tue Jun 15 09:59:08 2010
>      Raid Level : raid6
>    Raid Devices : 6
> =20
>  Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
>      Array Size : 15619710976 (7448.06 GiB 7997.29 GB)
>   Used Dev Size : 3904927744 (1862.01 GiB 1999.32 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 9b5a6d24:38202032:c40fc666:1f2570d7
> =20
> Internal Bitmap : 2 sectors from superblock
>     Update Time : Tue Jun 21 16:35:23 2011
>        Checksum : 629fcf29 - correct
>          Events : 235082
> =20
>          Layout : left-symmetric
>      Chunk Size : 128K
> =20
>    Device Role : Active device 2
>    Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)

They all have a 2048 sector offset.  This is good.  It means your good =
array and your bad array were both created with a fairly recent copy of=
 mdadm.

>  cat /etc/lvm/backup/*
> # Generated by LVM2 version 2.02.66(2) (2010-05-20): Sat May 21 09:40=
:02 2011
> =20
> contents =3D "Text Format Volume Group"
> version =3D 1
> =20
> description =3D "Created *after* executing 'vgcfgbackup'"
> =20
> creation_host =3D "BILLSSHACK"    # Linux BILLSSHACK 2.6.35-28-generi=
c-pae #49-Ubuntu SMP Tue Mar 1 14:58:06 UTC 2011 i686
> creation_time =3D 1305985202      # Sat May 21 09:40:02 2011
> =20
> vgDeb {
>         id =3D "a6nM6t-LPKY-gMdi-9YP4-t2tv-Hqjv-aMgmEa"
>         seqno =3D 10
>         status =3D ["RESIZEABLE", "READ", "WRITE"]
>         flags =3D []
>         extent_size =3D 8192              # 4 Megabytes
>         max_lv =3D 0
>         max_pv =3D 0
> =20
>         physical_volumes {
> =20
>                 pv0 {
>                         id =3D "0ecAby-vT4R-IHpt-5kEK-v1W0-u6AL-bUcFD=
G"
>                         device =3D "/dev/sdl2"    # Hint only
> =20
>                         status =3D ["ALLOCATABLE"]
>                         flags =3D []
>                         dev_size =3D 77883120     # 37.1376 Gigabytes
>                         pe_start =3D 384
>                         pe_count =3D 9507 # 37.1367 Gigabytes
>                 }
>         }
> =20
>         logical_volumes {
> =20
>                 swap {
>                         id =3D "ywPLVh-84xx-UvPV-fUaI-PPgU-ZiTw-j6rs0=
7"
>                         status =3D ["READ", "WRITE", "VISIBLE"]
>                         flags =3D []
>                         segment_count =3D 1
> =20
>                         segment1 {
>                                 start_extent =3D 0
>                                 extent_count =3D 512      # 2 Gigabyt=
es
> =20
>                                 type =3D "striped"
>                                 stripe_count =3D 1        # linear
> =20
>                                 stripes =3D [
>                                         "pv0", 0
>                                 ]
>                         }
>                 }
> =20
>                 root {
>                         id =3D "x0wMox-eWu2-EmDh-V0Ix-47Zl-iqVc-fTYjV=
B"
>                         status =3D ["READ", "WRITE", "VISIBLE"]
>                         flags =3D []
>                         segment_count =3D 1
> =20
>                         segment1 {
>                                 start_extent =3D 0
>                                 extent_count =3D 2560     # 10 Gigaby=
tes
> =20
>                                 type =3D "striped"
>                                 stripe_count =3D 1        # linear
> =20
>                                 stripes =3D [
>                                         "pv0", 512
>                                 ]
>                         }
>                 }
> =20
>                 rootu {
>                         id =3D "IFNTXp-4DBN-jjtc-PrCE-Mxs5-68FH-vY5QW=
K"
>                         status =3D ["READ", "WRITE", "VISIBLE"]
>                         flags =3D []
>                         segment_count =3D 1
> =20
>                         segment1 {
>                                 start_extent =3D 0
>                                 extent_count =3D 2560     # 10 Gigaby=
tes
> =20
>                                 type =3D "striped"
>                                 stripe_count =3D 1        # linear
> =20
>                                 stripes =3D [
>                                         "pv0", 5632
>                                 ]
>                         }
>                 }
>         }
> }

We won't need the above.  That's your system group.

> # Generated by LVM2 version 2.02.66(2) (2010-05-20): Sat May 21 09:40=
:02 2011
> =20
> contents =3D "Text Format Volume Group"
> version =3D 1
> =20
> description =3D "Created *after* executing 'vgcfgbackup'"
> =20
> creation_host =3D "BILLSSHACK"    # Linux BILLSSHACK 2.6.35-28-generi=
c-pae #49-Ubuntu SMP Tue Mar 1 14:58:06 UTC 2011 i686
> creation_time =3D 1305985202      # Sat May 21 09:40:02 2011
> =20
> vgRAID60 {
>         id =3D "RUodpI-jXin-DEjs-fS3R-4hjA-hQ4l-41dAaJ"
>         seqno =3D 58
>         status =3D ["RESIZEABLE", "READ", "WRITE"]
>         flags =3D []
>         extent_size =3D 8192              # 4 Megabytes
>         max_lv =3D 0
>         max_pv =3D 0
> =20
>         physical_volumes {
> =20
>                 pv0 {
>                         id =3D "V5c1yI-XD3D-FXlB-VDYd-tUfo-eIUC-hXQfV=
W"
>                         device =3D "/dev/md0"     # Hint only
> =20
>                         status =3D ["ALLOCATABLE"]
>                         flags =3D []
>                         dev_size =3D 15619710464  # 7.27349 Terabytes
>                         pe_start =3D 512
>                         pe_count =3D 1906702      # 7.27349 Terabytes
>                 }
> =20
>                 pv1 {
>                         id =3D "XRg0sr-C21F-4v2f-9FzZ-JSQr-JZe2-Tbexq=
f"
>                         device =3D "/dev/md1"     # Hint only
> =20
>                         status =3D ["ALLOCATABLE"]
>                         flags =3D []
>                         dev_size =3D 15619710464  # 7.27349 Terabytes
>                         pe_start =3D 512
>                         pe_count =3D 1906702      # 7.27349 Terabytes
>                 }
>         }

We can go hunting for these ids.  They'll certainly show up on the firs=
t disk in each raid.  They might also show up in the 5th disk in each r=
aid, if by chance the other data chunks in the stripe are zeros.  Pleas=
e show:

for x in /dev/sd[abcdefghijkm] ; do echo "**** $x ****" ; dd if=3D$x sk=
ip=3D2056 count=3D2 2>/dev/null |strings ; done

>         logical_volumes {
> =20
>                 data0 {
>                         id =3D "Odw7bi-10cB-8SSX-Y4BL-wqs6-4qWT-3AHaY=
L"
>                         status =3D ["READ", "WRITE", "VISIBLE"]
>                         flags =3D []
>                         segment_count =3D 1
> =20
>                         segment1 {
>                                 start_extent =3D 0
>                                 extent_count =3D 3670016  # 14 Teraby=
tes
> =20
>                                 type =3D "striped"
>                                 stripe_count =3D 2
>                                 stripe_size =3D 128       # 64 Kiloby=
tes
> =20
>                                 stripes =3D [
>                                         "pv0", 0,
>                                         "pv1", 0
>                                 ]
>                         }
>                 }
>         }
> }

Hmmm.  Striped LVM on top of raid6.  Trying to get better performance? =
 With this striping, getting the data back requires 100% success.  You =
won't get half of your data.  You might get all of it, or you might get=
 none of it.

> Again, i am not a raid pro. those commands i can understand, if anywh=
ere i make a mistake about a mdadm concept, please tell me.
> =20
> Nevertheless, thanks for you help

You are welcome.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

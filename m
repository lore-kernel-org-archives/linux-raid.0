From: william L'Heureux <wil_c_will@hotmail.com>
Subject: RE: reaid problem at reboot
Date: Tue, 21 Jun 2011 16:50:47 -0400
Message-ID: <BAY158-w388BBEAFF686EAA222B346C0510@phx.gbl>
References: <BAY158-W207004CCDC35695F84D5B4C0510@phx.gbl>,<4E00FC8A.1050908@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E00FC8A.1050908@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: philip@turmel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids









----------------------------------------
> Date: Tue, 21 Jun 2011 16:18:18 -0400
> From: philip@turmel.org
> To: wil_c_will@hotmail.com
> CC: linux-raid@vger.kernel.org
> Subject: Re: reaid problem at reboot
>
> Hi William,
>
> On 06/21/2011 09:14 AM, william L'Heureux wrote:
> > Hi,
> >
> > before we start, please note that im not a pro at mdadm or lvm, and=
 dont now the full terminology neither the full how it works.
>
> That's OK. We'll help as we can.
>
> > 1 week ago, 1 of my raid6 went wrong. it didnt have any superblock =
anymore. I know all the drives that belongs to that raid but
> > i
> > dont know the right order of the drives. I tried a python script wi=
th
> > assemble and permutation all combination possible. it then checks
> > the
> > header and do a e2fsck -n to check errors. Everytime i run the scri=
pt i
> > get several and different results on each run. Some say that
> > the
> > order of the drives doesnt matter, i agree but withotuh superblock =
its
> > another story. I got another raid6 which is fine and on top of thos=
e
> > 2
> > raid6, there is a lvm. if you have any question or output you want =
to
> > see, please tell me and i will provide further informations as soon=
 as i
> > can
> > if you dont understand me, i apologize, im trying to be better at e=
nglish everyday.
>
> First, an overview of what working: Please show the output of "lsdrv"=
=2E
>
> http://github.com/pturmel/lsdrv
>
> Then, some more detail: Please show "mdadm --detail /dev/md0 /dev/md1=
" and "mdadm --examine /dev/sd[abcdefghijkm]1"
>
> Finally, please show "cat /etc/lvm/backup/*"
>
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html



> Date: Tue, 21 Jun 2011 16:18:18 -0400
> From: philip@turmel.org
> To: wil_c_will@hotmail.com
> CC: linux-raid@vger.kernel.org
> Subject: Re: reaid problem at reboot
>=20
> Hi William,
>=20
> On 06/21/2011 09:14 AM, william L'Heureux wrote:
> > Hi,
> >=20
> > before we start, please note that im not a pro at mdadm or lvm, and=
 dont now the full terminology neither the full how it works.
>=20
> That's OK.  We'll help as we can.
>=20
> > 1 week ago, 1 of my raid6 went wrong. it didnt have any superblock =
anymore. I know all the drives that belongs to that raid but=20
> > i=20
> >  dont know the right order of the drives. I tried a python script w=
ith=20
> > assemble and permutation all combination possible. it then checks
> > the
> >  header and do a e2fsck -n to check errors. Everytime i run the scr=
ipt i
> >  get several and different results on each run. Some say that
> > the=20
> > order of the drives doesnt matter, i agree but withotuh superblock =
its=20
> > another story. I got another raid6 which is fine and on top of thos=
e=20
> > 2
> >  raid6, there is a lvm. if you have any question or output you want=
 to=20
> > see, please tell me and i will provide further informations as soon=
 as i
> >  can
> > if you dont understand me, i apologize, im trying to be better at e=
nglish everyday.
>=20
> First, an overview of what working:  Please show the output of "lsdrv=
".
>=20
> http://github.com/pturmel/lsdrv
>=20
> Then, some more detail:  Please show "mdadm --detail /dev/md0 /dev/md=
1" and "mdadm --examine /dev/sd[abcdefghijkm]1"
>=20
> Finally, please show "cat /etc/lvm/backup/*"
>=20
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
=20

=2E/lsdrv
PCI [sata_mv] 02:01.0 SCSI storage controller: Marvell Technology Group=
 Ltd. MV8                                                              =
                          8SX6081 8-port SATA II PCI-X Controller (rev =
09)
 =E2=E2scsi 0:0:0:0 ATA Hitachi HDS72202 {JK1171YAGA977S}
 =E2  =E2=E2sda: [8:0] Partitioned (gpt) 1.82t
 =E2     =E2=E2sda1: [8:1] MD raid6 (6) 1.82t inactive 'BILLSSHACK:0' {=
3bcf45ef-da3e-d                                                        =
                                e81-09a8-d6635b58832d}
 =E2     =E2=E2sda2: [8:2] Empty/Unknown 1.00g
 =E2=E2scsi 1:0:0:0 ATA WL2000GSA1672 {WOL240094387}
 =E2  =E2=E2sdb: [8:16] Partitioned (gpt) 1.82t
 =E2     =E2=E2sdb1: [8:17] MD raid6 (6) 1.82t inactive 'billsshack:3' =
{751fd632-4baf-                                                        =
                                7d64-ec26-eec1046592bc}
 =E2     =E2=E2sdb2: [8:18] Empty/Unknown 1.00g
 =E2=E2scsi 2:x:x:x [Empty]
 =E2=E2scsi 3:x:x:x [Empty]
 =E2=E2scsi 4:0:0:0 ATA WL2000GSA1672 {WOL240094356}
 =E2  =E2=E2sdc: [8:32] Partitioned (gpt) 1.82t
 =E2     =E2=E2sdc1: [8:33] MD raid6 (6) 1.82t inactive 'BILLSSHACK:0' =
{3bcf45ef-da3e-                                                        =
                                de81-09a8-d6635b58832d}
 =E2     =E2=E2sdc2: [8:34] Empty/Unknown 1.00g
 =E2=E2scsi 5:0:0:0 ATA WL2000GSA3272C {WOL240146377}
 =E2  =E2=E2sdd: [8:48] Partitioned (gpt) 1.82t
 =E2     =E2=E2sdd1: [8:49] MD raid6 (6) 1.82t inactive 'BILLSSHACK:0' =
{3bcf45ef-da3e-                                                        =
                                de81-09a8-d6635b58832d}
 =E2     =E2=E2sdd2: [8:50] Empty/Unknown 1.00g
 =E2=E2scsi 6:x:x:x [Empty]
 =E2=E2scsi 7:x:x:x [Empty]
PCI [sata_mv] 03:02.0 SCSI storage controller: Marvell Technology Group=
 Ltd. MV8                                                              =
                          8SX6081 8-port SATA II PCI-X Controller (rev =
09)
 =E2=E2scsi 8:0:0:0 ATA WL2000GSA3272 {WOL240102099}
 =E2  =E2=E2sde: [8:64] Partitioned (gpt) 1.82t
 =E2     =E2=E2sde1: [8:65] MD raid6 (6) 1.82t inactive 'billsshack:3' =
{751fd632-4baf-                                                        =
                                7d64-ec26-eec1046592bc}
 =E2     =E2=E2sde2: [8:66] Empty/Unknown 1.00g
 =E2=E2scsi 9:x:x:x [Empty]
 =E2=E2scsi 10:0:0:0 ATA Hitachi HDS72202 {JK1171YAGDDUGS}
 =E2  =E2=E2sdf: [8:80] Partitioned (gpt) 1.82t
 =E2     =E2=E2sdf1: [8:81] MD raid6 (6) 1.82t inactive 'billsshack:3' =
{751fd632-4baf-                                                        =
                                7d64-ec26-eec1046592bc}
 =E2     =E2=E2sdf2: [8:82] Empty/Unknown 1.00g
 =E2=E2scsi 11:0:0:0 ATA ST32000542AS {6XW1B8WP}
 =E2  =E2=E2sdg: [8:96] Partitioned (gpt) 1.82t
 =E2     =E2=E2sdg1: [8:97] MD raid6 (6) 1.82t inactive 'billsshack:3' =
{751fd632-4baf-                                                        =
                                7d64-ec26-eec1046592bc}
 =E2     =E2=E2sdg2: [8:98] Empty/Unknown 1.00g
 =E2=E2scsi 12:0:0:0 ATA WL2000GSA3272 {WOL240102098}
 =E2  =E2=E2sdh: [8:112] Partitioned (gpt) 1.82t
 =E2     =E2=E2sdh1: [8:113] MD raid6 (6) 1.82t inactive 'BILLSSHACK:0'=
 {3bcf45ef-da3e                                                        =
                                -de81-09a8-d6635b58832d}
 =E2     =E2=E2sdh2: [8:114] Empty/Unknown 1.00g
 =E2=E2scsi 13:0:0:0 ATA WDC WD20EADS-00S {WD-WCAVY3323665}
 =E2  =E2=E2sdi: [8:128] Partitioned (gpt) 1.82t
 =E2     =E2=E2sdi1: [8:129] MD raid6 (6) 1.82t inactive 'BILLSSHACK:0'=
 {3bcf45ef-da3e                                                        =
                                -de81-09a8-d6635b58832d}
 =E2     =E2=E2sdi2: [8:130] Empty/Unknown 1.00g
 =E2=E2scsi 14:0:0:0 ATA WDC WD20EADS-00S {WD-WCAVY3356471}
 =E2  =E2=E2sdj: [8:144] Partitioned (gpt) 1.82t
 =E2     =E2=E2sdj1: [8:145] MD raid6 (6) 1.82t inactive 'BILLSSHACK:0'=
 {3bcf45ef-da3e                                                        =
                                -de81-09a8-d6635b58832d}
 =E2     =E2=E2sdj2: [8:146] Empty/Unknown 1.00g
 =E2=E2scsi 15:x:x:x [Empty]
PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH (IC=
H9R/DO/DH                                                              =
                          ) 6 port SATA AHCI Controller (rev 02)
 =E2=E2scsi 16:x:x:x [Empty]
 =E2=E2scsi 17:x:x:x [Empty]
 =E2=E2scsi 18:0:0:0 ATA WDC WD20EADS-00S {WD-WCAVY3286477}
 =E2  =E2=E2sdk: [8:160] Partitioned (gpt) 1.82t
 =E2     =E2=E2sdk1: [8:161] MD raid6 (6) 1.82t inactive 'billsshack:3'=
 {751fd632-4baf                                                        =
                                -7d64-ec26-eec1046592bc}
 =E2     =E2=E2sdk2: [8:162] Empty/Unknown 1.00g
 =E2=E2scsi 19:0:0:0 ATA WDC WD400BD-60LT {WD-WMAME1857443}
 =E2  =E2=E2sdl: [8:176] Partitioned (dos) 37.27g
 =E2     =E2=E2sdl1: [8:177] Partitioned (dos) 133.32m {617e6b03-6cc1-4=
974-8acc-19a742                                                        =
                                cd06f4}
 =E2     =E2  =E2=E2Mounted as /dev/sdl1 @ /boot
 =E2     =E2=E2sdl2: [8:178] PV LVM2_member 22.00g/37.14g VG vgDeb 37.1=
4g {0ecAby-vT4R                                                        =
                                -IHpt-5kEK-v1W0-u6AL-bUcFDG}
 =E2         =E2=E2Volume Group vgDeb (sdl2) 15.14g free {a6nM6t-LPKY-g=
Mdi-9YP4-t2tv-H                                                        =
                                qjv-aMgmEa}
 =E2           =E2=E2dm-1: [251:1] LV 'root' (reiserfs) 10.00g {f497b9b=
d-e24f-4d20-9f6                                                        =
                                b-282b6493f341}
 =E2           =E2  =E2=E2Mounted as /dev/mapper/vgDeb-root @ /mnt/debi=
an
 =E2           =E2=E2dm-2: [251:2] LV 'rootu' (reiserfs) 10.00g {bc0f35=
0c-4af7-4192-b1                                                        =
                                ea-4528101db28e}
 =E2           =E2  =E2=E2Mounted as /dev/mapper/vgDeb-rootu @ /
 =E2           =E2=E2dm-0: [251:0] LV 'swap' (swap) 2.00g {13264e60-a1d=
1-4bf3-af9f-edd                                                        =
                                948212a63}
 =E2=E2scsi 20:0:0:0 ATA WDC WD20EADS-00S {WD-WCAVY3271728}
 =E2  =E2=E2sdm: [8:192] MD raid6 (4) 1.82t inactive {b52df561-301f-043=
c-b5a7-b1ab9d93                                                        =
                                4878}
 =E2     =E2=E2sdm1: [8:193] MD raid6 (6) 1.82t inactive 'billsshack:3'=
 {751fd632-4baf                                                        =
                                -7d64-ec26-eec1046592bc}
 =E2     =E2=E2sdm2: [8:194] MD raid6 (6) 1.00g inactive 'billsshack:2'=
 {cf2450e4-bc7a                                                        =
                                -9cea-cb5c-cda96f3ec87c}
 =E2=E2scsi 21:x:x:x [Empty]
Other Block Devices
 =E2=E2ram0: [1:0] Empty/Unknown 64.00m
 =E2=E2ram1: [1:1] Empty/Unknown 64.00m
 =E2=E2ram2: [1:2] Empty/Unknown 64.00m
 =E2=E2ram3: [1:3] Empty/Unknown 64.00m
 =E2=E2ram4: [1:4] Empty/Unknown 64.00m
 =E2=E2ram5: [1:5] Empty/Unknown 64.00m
 =E2=E2ram6: [1:6] Empty/Unknown 64.00m
 =E2=E2ram7: [1:7] Empty/Unknown 64.00m
 =E2=E2ram8: [1:8] Empty/Unknown 64.00m
 =E2=E2ram9: [1:9] Empty/Unknown 64.00m
 =E2=E2ram10: [1:10] Empty/Unknown 64.00m
 =E2=E2ram11: [1:11] Empty/Unknown 64.00m
 =E2=E2ram12: [1:12] Empty/Unknown 64.00m
 =E2=E2ram13: [1:13] Empty/Unknown 64.00m
 =E2=E2ram14: [1:14] Empty/Unknown 64.00m
 =E2=E2ram15: [1:15] Empty/Unknown 64.00m





=A0mdadm --detail /dev/md0 /dev/md1
/dev/md0:
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0 Creation Time : Tue Jun 21 11:23:46 2011
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0=A0=A0 Array Size : 7809854976 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 1952463744 (1862.01 GiB 1999.32 GB)
=A0=A0 Raid Devices : 6
=A0 Total Devices : 6
=A0=A0=A0 Persistence : Superblock is persistent
=20
=A0=A0=A0 Update Time : Tue Jun 21 11:23:46 2011
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0Active Devices : 6
Working Devices : 6
=A0Failed Devices : 0
=A0 Spare Devices : 0
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : BILLSSHACK:0=A0 (local to host BI=
LLSSHACK)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 3bcf45ef:da3ede81:09a8d663:5b5883=
2d
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 0
=20
=A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=
=A0=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sda1
=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 33=A0=A0=A0=A0=
=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc1
=A0=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 49=A0=A0=A0=A0=
=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdd1
=A0=A0=A0=A0=A0=A0 3=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 113=A0=A0=A0=A0=
=A0=A0=A0 3=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdh1
=A0=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 129=A0=A0=A0=A0=
=A0=A0=A0 4=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdi1
=A0=A0=A0=A0=A0=A0 5=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 145=A0=A0=A0=A0=
=A0=A0=A0 5=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdj1
/dev/md1:
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0 Creation Time : Tue Jun 15 09:59:08 2010
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0=A0=A0 Array Size : 7809855488 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 1952463872 (1862.01 GiB 1999.32 GB)
=A0=A0 Raid Devices : 6
=A0 Total Devices : 6
=A0=A0=A0 Persistence : Superblock is persistent
=20
=A0 Intent Bitmap : Internal
=20
=A0=A0=A0 Update Time : Tue Jun 14 20:58:11 2011
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active
=A0Active Devices : 6
Working Devices : 6
=A0Failed Devices : 0
=A0 Spare Devices : 0
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : billsshack:3
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 751fd632:4baf7d64:ec26eec1:046592=
bc
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 235082
=20
=A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 161=A0=A0=A0=A0=
=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdk1
=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=A0=
=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 193=A0=A0=A0=A0=
=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdm1
=A0=A0=A0=A0=A0=A0 5=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 81=A0=A0=A0=A0=
=A0=A0=A0 3=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdf1
=A0=A0=A0=A0=A0=A0 6=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=
=A0=A0=A0 4=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sde1
=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 97=A0=A0=A0=A0=
=A0=A0=A0 5=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdg1
=20
=20
=20
=20
mdadm --examine /dev/sd[abcdefghijkm]1
/dev/sda1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x0
=A0=A0=A0=A0 Array UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : BILLSSHACK:0=A0 (local to host BI=
LLSSHACK)
=A0 Creation Time : Tue Jun 21 11:23:46 2011
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 6
=20
=A0Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
=A0=A0=A0=A0 Array Size : 15619709952 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 3904927488 (1862.01 GiB 1999.32 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : b6569293:759c2fbe:d52f346f:2ea85306
=20
=A0=A0=A0 Update Time : Tue Jun 21 16:35:23 2011
=A0=A0=A0=A0=A0=A0 Checksum : 9d90c200 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 2
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0 Device Role : Active device 0
=A0=A0 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdb1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x1
=A0=A0=A0=A0 Array UUID : 751fd632:4baf7d64:ec26eec1:046592bc
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : billsshack:3
=A0 Creation Time : Tue Jun 15 09:59:08 2010
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 6
=20
=A0Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
=A0=A0=A0=A0 Array Size : 15619710976 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 3904927744 (1862.01 GiB 1999.32 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 0b6a5d24:bff1c401:259c054b:ca7ccc7f
=20
Internal Bitmap : 2 sectors from superblock
=A0=A0=A0 Update Time : Tue Jun 21 16:35:23 2011
=A0=A0=A0=A0=A0=A0 Checksum : bed09424 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 235082
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0 Device Role : Active device 1
=A0=A0 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdc1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x0
=A0=A0=A0=A0 Array UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : BILLSSHACK:0=A0 (local to host BI=
LLSSHACK)
=A0 Creation Time : Tue Jun 21 11:23:46 2011
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 6
=20
=A0Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
=A0=A0=A0=A0 Array Size : 15619709952 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 3904927488 (1862.01 GiB 1999.32 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 298ee23a:4968978c:0557d189:1c45ff55
=20
=A0=A0=A0 Update Time : Tue Jun 21 16:35:23 2011
=A0=A0=A0=A0=A0=A0 Checksum : 7d918966 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 2
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0 Device Role : Active device 1
=A0=A0 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdd1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x0
=A0=A0=A0=A0 Array UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : BILLSSHACK:0=A0 (local to host BI=
LLSSHACK)
=A0 Creation Time : Tue Jun 21 11:23:46 2011
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 6
=20
=A0Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
=A0=A0=A0=A0 Array Size : 15619709952 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 3904927488 (1862.01 GiB 1999.32 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 2b8ef61c:d3d59200:659d4367:573a992d
=20
=A0=A0=A0 Update Time : Tue Jun 21 16:35:23 2011
=A0=A0=A0=A0=A0=A0 Checksum : 88ad328d - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 2
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0 Device Role : Active device 2
=A0=A0 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sde1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x1
=A0=A0=A0=A0 Array UUID : 751fd632:4baf7d64:ec26eec1:046592bc
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : billsshack:3
=A0 Creation Time : Tue Jun 15 09:59:08 2010
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 6
=20
=A0Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
=A0=A0=A0=A0 Array Size : 15619710976 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 3904927744 (1862.01 GiB 1999.32 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 1de7b73d:73ff1f80:c0903159:87fc8287
=20
Internal Bitmap : 2 sectors from superblock
=A0=A0=A0 Update Time : Tue Jun 21 16:35:23 2011
=A0=A0=A0=A0=A0=A0 Checksum : 6c689348 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 235082
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0 Device Role : Active device 4
=A0=A0 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdf1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x1
=A0=A0=A0=A0 Array UUID : 751fd632:4baf7d64:ec26eec1:046592bc
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : billsshack:3
=A0 Creation Time : Tue Jun 15 09:59:08 2010
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 6
=20
=A0Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
=A0=A0=A0=A0 Array Size : 15619710976 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 3904927744 (1862.01 GiB 1999.32 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 3247b37b:aa741693:0d58ccb6:b814a5d1
=20
Internal Bitmap : 2 sectors from superblock
=A0=A0=A0 Update Time : Tue Jun 21 16:35:23 2011
=A0=A0=A0=A0=A0=A0 Checksum : 65174812 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 235082
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0 Device Role : Active device 3
=A0=A0 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdg1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x1
=A0=A0=A0=A0 Array UUID : 751fd632:4baf7d64:ec26eec1:046592bc
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : billsshack:3
=A0 Creation Time : Tue Jun 15 09:59:08 2010
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 6
=20
=A0Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
=A0=A0=A0=A0 Array Size : 15619710976 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 3904927744 (1862.01 GiB 1999.32 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 8483b8f7:8c3302c6:9403a3e9:3c3a094c
=20
Internal Bitmap : 2 sectors from superblock
=A0=A0=A0 Update Time : Tue Jun 21 16:35:23 2011
=A0=A0=A0=A0=A0=A0 Checksum : c1431453 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 235082
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0 Device Role : Active device 5
=A0=A0 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdh1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x0
=A0=A0=A0=A0 Array UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : BILLSSHACK:0=A0 (local to host BI=
LLSSHACK)
=A0 Creation Time : Tue Jun 21 11:23:46 2011
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 6
=20
=A0Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
=A0=A0=A0=A0 Array Size : 15619709952 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 3904927488 (1862.01 GiB 1999.32 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 1abe5069:570c484e:2199572d:cd0d641f
=20
=A0=A0=A0 Update Time : Tue Jun 21 16:35:23 2011
=A0=A0=A0=A0=A0=A0 Checksum : da9b6833 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 2
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0 Device Role : Active device 3
=A0=A0 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdi1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x0
=A0=A0=A0=A0 Array UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : BILLSSHACK:0=A0 (local to host BI=
LLSSHACK)
=A0 Creation Time : Tue Jun 21 11:23:46 2011
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 6
=20
=A0Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
=A0=A0=A0=A0 Array Size : 15619709952 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 3904927488 (1862.01 GiB 1999.32 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 083fa0cc:798c09bb:febe5adf:f99eb7b8
=20
=A0=A0=A0 Update Time : Tue Jun 21 16:35:23 2011
=A0=A0=A0=A0=A0=A0 Checksum : f603204f - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 2
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0 Device Role : Active device 4
=A0=A0 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdj1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x0
=A0=A0=A0=A0 Array UUID : 3bcf45ef:da3ede81:09a8d663:5b58832d
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : BILLSSHACK:0=A0 (local to host BI=
LLSSHACK)
=A0 Creation Time : Tue Jun 21 11:23:46 2011
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 6
=20
=A0Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
=A0=A0=A0=A0 Array Size : 15619709952 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 3904927488 (1862.01 GiB 1999.32 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : b91a18a4:8aba8cf8:bf046c8f:f683cf16
=20
=A0=A0=A0 Update Time : Tue Jun 21 16:35:23 2011
=A0=A0=A0=A0=A0=A0 Checksum : 192754d0 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 2
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0 Device Role : Active device 5
=A0=A0 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdk1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x1
=A0=A0=A0=A0 Array UUID : 751fd632:4baf7d64:ec26eec1:046592bc
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : billsshack:3
=A0 Creation Time : Tue Jun 15 09:59:08 2010
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 6
=20
=A0Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
=A0=A0=A0=A0 Array Size : 15619710976 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 3904927744 (1862.01 GiB 1999.32 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 77b91aac:68eed1cc:e2404d60:f5962abc
=20
Internal Bitmap : 2 sectors from superblock
=A0=A0=A0 Update Time : Tue Jun 21 16:35:23 2011
=A0=A0=A0=A0=A0=A0 Checksum : 63409f22 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 235082
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0 Device Role : Active device 0
=A0=A0 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
/dev/sdm1:
=A0=A0=A0=A0=A0=A0=A0=A0=A0 Magic : a92b4efc
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0=A0=A0 Feature Map : 0x1
=A0=A0=A0=A0 Array UUID : 751fd632:4baf7d64:ec26eec1:046592bc
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : billsshack:3
=A0 Creation Time : Tue Jun 15 09:59:08 2010
=A0=A0=A0=A0 Raid Level : raid6
=A0=A0 Raid Devices : 6
=20
=A0Avail Dev Size : 3904927887 (1862.01 GiB 1999.32 GB)
=A0=A0=A0=A0 Array Size : 15619710976 (7448.06 GiB 7997.29 GB)
=A0 Used Dev Size : 3904927744 (1862.01 GiB 1999.32 GB)
=A0=A0=A0 Data Offset : 2048 sectors
=A0=A0 Super Offset : 8 sectors
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : clean
=A0=A0=A0 Device UUID : 9b5a6d24:38202032:c40fc666:1f2570d7
=20
Internal Bitmap : 2 sectors from superblock
=A0=A0=A0 Update Time : Tue Jun 21 16:35:23 2011
=A0=A0=A0=A0=A0=A0 Checksum : 629fcf29 - correct
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 235082
=20
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 128K
=20
=A0=A0 Device Role : Active device 2
=A0=A0 Array State : AAAAAA ('A' =3D=3D active, '.' =3D=3D missing)
=20
=20
=20
=A0cat /etc/lvm/backup/*
# Generated by LVM2 version 2.02.66(2) (2010-05-20): Sat May 21 09:40:0=
2 2011
=20
contents =3D "Text Format Volume Group"
version =3D 1
=20
description =3D "Created *after* executing 'vgcfgbackup'"
=20
creation_host =3D "BILLSSHACK"=A0=A0=A0 # Linux BILLSSHACK 2.6.35-28-ge=
neric-pae #49-Ubuntu SMP Tue Mar 1 14:58:06 UTC 2011 i686
creation_time =3D 1305985202=A0=A0=A0=A0=A0 # Sat May 21 09:40:02 2011
=20
vgDeb {
=A0=A0=A0=A0=A0=A0=A0 id =3D "a6nM6t-LPKY-gMdi-9YP4-t2tv-Hqjv-aMgmEa"
=A0=A0=A0=A0=A0=A0=A0 seqno =3D 10
=A0=A0=A0=A0=A0=A0=A0 status =3D ["RESIZEABLE", "READ", "WRITE"]
=A0=A0=A0=A0=A0=A0=A0 flags =3D []
=A0=A0=A0=A0=A0=A0=A0 extent_size =3D 8192=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 # 4 Megabytes
=A0=A0=A0=A0=A0=A0=A0 max_lv =3D 0
=A0=A0=A0=A0=A0=A0=A0 max_pv =3D 0
=20
=A0=A0=A0=A0=A0=A0=A0 physical_volumes {
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pv0 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
d =3D "0ecAby-vT4R-IHpt-5kEK-v1W0-u6AL-bUcFDG"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
evice =3D "/dev/sdl2"=A0=A0=A0 # Hint only
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
tatus =3D ["ALLOCATABLE"]
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
lags =3D []
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
ev_size =3D 77883120=A0=A0=A0=A0 # 37.1376 Gigabytes
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p=
e_start =3D 384
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p=
e_count =3D 9507 # 37.1367 Gigabytes
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0 }
=20
=A0=A0=A0=A0=A0=A0=A0 logical_volumes {
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 swap {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
d =3D "ywPLVh-84xx-UvPV-fUaI-PPgU-ZiTw-j6rs07"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
tatus =3D ["READ", "WRITE", "VISIBLE"]
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
lags =3D []
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
egment_count =3D 1
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
egment1 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 start_extent =3D 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 extent_count =3D 512=A0=A0=A0=A0=A0 # 2 Gigabytes
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 type =3D "striped"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 stripe_count =3D 1=A0=A0=A0=A0=A0=A0=A0 # linear
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 stripes =3D [
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "pv0", 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 ]
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 root {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
d =3D "x0wMox-eWu2-EmDh-V0Ix-47Zl-iqVc-fTYjVB"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
tatus =3D ["READ", "WRITE", "VISIBLE"]
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
lags =3D []
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
egment_count =3D 1
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
egment1 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 start_extent =3D 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 extent_count =3D 2560=A0=A0=A0=A0 # 10 Gigabytes
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 type =3D "striped"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 stripe_count =3D 1=A0=A0=A0=A0=A0=A0=A0 # linear
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 stripes =3D [
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "pv0", 512
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 ]
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 rootu {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
d =3D "IFNTXp-4DBN-jjtc-PrCE-Mxs5-68FH-vY5QWK"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
tatus =3D ["READ", "WRITE", "VISIBLE"]
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
lags =3D []
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
egment_count =3D 1
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
egment1 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 start_extent =3D 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 extent_count =3D 2560=A0=A0=A0=A0 # 10 Gigabytes
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 type =3D "striped"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 stripe_count =3D 1=A0=A0=A0=A0=A0=A0=A0 # linear
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 stripes =3D [
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "pv0", 5632
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 ]
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0 }
}
# Generated by LVM2 version 2.02.66(2) (2010-05-20): Sat May 21 09:40:0=
2 2011
=20
contents =3D "Text Format Volume Group"
version =3D 1
=20
description =3D "Created *after* executing 'vgcfgbackup'"
=20
creation_host =3D "BILLSSHACK"=A0=A0=A0 # Linux BILLSSHACK 2.6.35-28-ge=
neric-pae #49-Ubuntu SMP Tue Mar 1 14:58:06 UTC 2011 i686
creation_time =3D 1305985202=A0=A0=A0=A0=A0 # Sat May 21 09:40:02 2011
=20
vgRAID60 {
=A0=A0=A0=A0=A0=A0=A0 id =3D "RUodpI-jXin-DEjs-fS3R-4hjA-hQ4l-41dAaJ"
=A0=A0=A0=A0=A0=A0=A0 seqno =3D 58
=A0=A0=A0=A0=A0=A0=A0 status =3D ["RESIZEABLE", "READ", "WRITE"]
=A0=A0=A0=A0=A0=A0=A0 flags =3D []
=A0=A0=A0=A0=A0=A0=A0 extent_size =3D 8192=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0 # 4 Megabytes
=A0=A0=A0=A0=A0=A0=A0 max_lv =3D 0
=A0=A0=A0=A0=A0=A0=A0 max_pv =3D 0
=20
=A0=A0=A0=A0=A0=A0=A0 physical_volumes {
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pv0 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
d =3D "V5c1yI-XD3D-FXlB-VDYd-tUfo-eIUC-hXQfVW"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
evice =3D "/dev/md0"=A0=A0=A0=A0 # Hint only
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
tatus =3D ["ALLOCATABLE"]
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
lags =3D []
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
ev_size =3D 15619710464=A0 # 7.27349 Terabytes
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p=
e_start =3D 512
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p=
e_count =3D 1906702=A0=A0=A0=A0=A0 # 7.27349 Terabytes
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pv1 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
d =3D "XRg0sr-C21F-4v2f-9FzZ-JSQr-JZe2-Tbexqf"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
evice =3D "/dev/md1"=A0=A0=A0=A0 # Hint only
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
tatus =3D ["ALLOCATABLE"]
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
lags =3D []
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 d=
ev_size =3D 15619710464=A0 # 7.27349 Terabytes
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p=
e_start =3D 512
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 p=
e_count =3D 1906702=A0=A0=A0=A0=A0 # 7.27349 Terabytes
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0 }
=20
=A0=A0=A0=A0=A0=A0=A0 logical_volumes {
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 data0 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 i=
d =3D "Odw7bi-10cB-8SSX-Y4BL-wqs6-4qWT-3AHaYL"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
tatus =3D ["READ", "WRITE", "VISIBLE"]
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 f=
lags =3D []
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
egment_count =3D 1
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 s=
egment1 {
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 start_extent =3D 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 extent_count =3D 3670016=A0 # 14 Terabytes
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 type =3D "striped"
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 stripe_count =3D 2
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 stripe_size =3D 128=A0=A0=A0=A0=A0=A0 # 64 Kiloby=
tes
=20
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 stripes =3D [
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "pv0", 0,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 "pv1", 0
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 ]
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 }
=A0=A0=A0=A0=A0=A0=A0 }
}
=20
=20
Again, i am not a raid pro. those commands i can understand, if anywher=
e i make a mistake about a mdadm concept, please tell me.
=20
Nevertheless, thanks for you help
=20
William
 		 	   		 =20
 		 	   		  --
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

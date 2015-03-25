From: Phil Turmel <philip@turmel.org>
Subject: Re: missing arrays after OS upgrade
Date: Wed, 25 Mar 2015 08:15:39 -0400
Message-ID: <5512A6EB.10104@turmel.org>
References: <CAHscji03jWu3EF0KUG45Hv4Y2t5beJmEoe9uWMfR=wGz_dkBbw@mail.gmail.com>	<5511FB3B.8030607@turmel.org> <CAHscji1spYx8vvUQ2=PsU4VRCb4+kOqAstJqyK0SbYJ6=OSYiQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji1spYx8vvUQ2=PsU4VRCb4+kOqAstJqyK0SbYJ6=OSYiQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Daniel,

{Convention on kernel.org is to trim quotes, then interleave replies or
bottom-post.}

On 03/25/2015 07:49 AM, Daniel Sanabria wrote:
> Thank you very much Phil,
>=20
> Below the output of lsdrv followed by /proc/mdstat and mdadm.conf
> (will clean up dmesg a bit before attaching it here):

When you do, turn off line wrap.  I forgot to suggest that.

> PCI [ahci] 07:00.0 SATA controller: JMicron Technology Corp. JMB363 S=
ATA/IDE Controller (rev 02)
> =E2=94=9Cscsi 0:x:x:x [Empty]
> =E2=94=94scsi 1:x:x:x [Empty]
> PCI [ata_piix] 00:1f.2 IDE interface: Intel Corporation 82801JI (ICH1=
0 Family) 4 port SATA IDE Controller #1
> =E2=94=9Cscsi 2:0:0:0 ATA      WDC WD5000AAKS-0 {WD-WMAWF0085724}
> =E2=94=82=E2=94=94sda 465.76g [8:0] Partitioned (dos)
> =E2=94=82 =E2=94=9Csda1 199.00m [8:1] ext4 {4e51f903-37ca-4479-9197-f=
ac7b2280557}
> =E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sda1 @ /boot
> =E2=94=82 =E2=94=9Csda2 29.30g [8:2] MD raid10,near2 (0/2) (w/ sdc1) =
in_sync {9af006ca-8845-bbd3-bfe7-8010bc810f04}
> =E2=94=82 =E2=94=82=E2=94=94md126 29.30g [9:126] MD v0.90 raid10,near=
2 (2) clean, 64k Chunk {9af006ca:8845bbd3:bfe78010:bc810f04}
> =E2=94=82 =E2=94=82 =E2=94=82                    PV LVM2_member 28.03=
g used, 1.26g free {cE4ePh-RWO8-Wgdy-YPOY-ehyC-KI6u-io1cyH}
> =E2=94=82 =E2=94=82 =E2=94=94VG vg_bigblackbox 29.29g 1.26g free {VWf=
uwI-5v2q-w8qf-FEbc-BdGW-3mKX-pZd7hR}
> =E2=94=82 =E2=94=82  =E2=94=9Cdm-6 7.81g [253:6] LV LogVol_opt ext4 {=
b08d7f5e-f15f-4241-804e-edccecab6003}
> =E2=94=82 =E2=94=82  =E2=94=82=E2=94=94Mounted as /dev/mapper/vg_bigb=
lackbox-LogVol_opt @ /opt
> =E2=94=82 =E2=94=82  =E2=94=9Cdm-0 9.77g [253:0] LV LogVol_root ext4 =
{4dabd6b0-b1a3-464d-8ed7-0aab93fab6c3}
> =E2=94=82 =E2=94=82  =E2=94=82=E2=94=94Mounted as /dev/mapper/vg_bigb=
lackbox-LogVol_root @ /
> =E2=94=82 =E2=94=82  =E2=94=9Cdm-8 1.95g [253:8] LV LogVol_tmp ext4 {=
f6b46363-170b-4038-83bd-2c5f9f6a1973}
> =E2=94=82 =E2=94=82  =E2=94=82=E2=94=94Mounted as /dev/mapper/vg_bigb=
lackbox-LogVol_tmp @ /tmp
> =E2=94=82 =E2=94=82  =E2=94=94dm-4 8.50g [253:4] LV LogVol_var ext4 {=
ab165c61-3d62-4c55-8639-6c2c2bf4b021}
> =E2=94=82 =E2=94=82   =E2=94=94Mounted as /dev/mapper/vg_bigblackbox-=
LogVol_var @ /var
> =E2=94=82 =E2=94=9Csda3 244.14g [8:3] MD raid5 (3) inactive {2cff15d1=
-e411-447b-fd5d-472103e44022}
> =E2=94=82 =E2=94=9Csda4 1.00k [8:4] Partitioned (dos)
> =E2=94=82 =E2=94=9Csda5 30.00g [8:5] MD raid0 (0/3) (w/ sdb5,sdc5) in=
_sync 'reading.homeunix.com:3' {acd5374f-7262-8c93-6a90-6c4b5f675ce5}
> =E2=94=82 =E2=94=82=E2=94=94md124 90.00g [9:124] MD v1.2 raid0 (3) cl=
ean, 512k Chunk, None (None) None {acd5374f:72628c93:6a906c4b:5f675ce5}
> =E2=94=82 =E2=94=82 =E2=94=82                    PV LVM2_member 86.00=
g used, 3.99g free {VmsWRd-8qHt-bauf-lvAn-FC97-KyH5-gk89ox}
> =E2=94=82 =E2=94=82 =E2=94=94VG libvirt_lvm 89.99g 3.99g free {t8GQck=
-f2Eu-iD2V-fnJQ-kBm6-QyKw-dR31PB}
> =E2=94=82 =E2=94=82  =E2=94=9Cdm-9 8.00g [253:9] LV builder Partition=
ed (dos)
> =E2=94=82 =E2=94=82  =E2=94=9Cdm-10 8.00g [253:10] LV builder2 Partit=
ioned (dos)
> =E2=94=82 =E2=94=82  =E2=94=9Cdm-11 8.00g [253:11] LV builder3 Partit=
ioned (dos)
> =E2=94=82 =E2=94=82  =E2=94=9Cdm-13 8.00g [253:13] LV builder5.3 Part=
itioned (dos)
> =E2=94=82 =E2=94=82  =E2=94=9Cdm-12 8.00g [253:12] LV builder5.6 Part=
itioned (dos)
> =E2=94=82 =E2=94=82  =E2=94=9Cdm-5 8.00g [253:5] LV centos_updt Parti=
tioned (dos)
> =E2=94=82 =E2=94=82  =E2=94=9Cdm-7 8.00g [253:7] LV cms Partitioned (=
dos)
> =E2=94=82 =E2=94=82  =E2=94=94dm-2 30.00g [253:2] LV win7 Partitioned=
 (dos)
> =E2=94=82 =E2=94=94sda6 3.39g [8:6] Empty/Unknown
> =E2=94=9Cscsi 2:0:1:0 ATA      WDC WD5000AAKS-0 {WD-WCASY7694185}
> =E2=94=82=E2=94=94sdb 465.76g [8:16] Partitioned (dos)
> =E2=94=82 =E2=94=9Csdb2 244.14g [8:18] MD raid5 (3) inactive {2cff15d=
1-e411-447b-fd5d-472103e44022}
> =E2=94=82 =E2=94=9Csdb3 7.81g [8:19] swap {9194f492-881a-4fc3-ac09-ca=
4e1cc2985a}
> =E2=94=82 =E2=94=9Csdb4 1.00k [8:20] Partitioned (dos)
> =E2=94=82 =E2=94=9Csdb5 30.00g [8:21] MD raid0 (1/3) (w/ sda5,sdc5) i=
n_sync 'reading.homeunix.com:3' {acd5374f-7262-8c93-6a90-6c4b5f675ce5}
> =E2=94=82 =E2=94=82=E2=94=94md124 90.00g [9:124] MD v1.2 raid0 (3) cl=
ean, 512k Chunk, None (None) None {acd5374f:72628c93:6a906c4b:5f675ce5}
> =E2=94=82 =E2=94=82                      PV LVM2_member 86.00g used, =
3.99g free {VmsWRd-8qHt-bauf-lvAn-FC97-KyH5-gk89ox}
> =E2=94=82 =E2=94=94sdb6 3.39g [8:22] Empty/Unknown
> =E2=94=9Cscsi 3:0:0:0 ATA      WDC WD5000AAKS-0 {WD-WCASZ0505379}
> =E2=94=82=E2=94=94sdc 465.76g [8:32] Partitioned (dos)
> =E2=94=82 =E2=94=9Csdc1 29.30g [8:33] MD raid10,near2 (1/2) (w/ sda2)=
 in_sync {9af006ca-8845-bbd3-bfe7-8010bc810f04}
> =E2=94=82 =E2=94=82=E2=94=94md126 29.30g [9:126] MD v0.90 raid10,near=
2 (2) clean, 64k Chunk {9af006ca:8845bbd3:bfe78010:bc810f04}
> =E2=94=82 =E2=94=82                      PV LVM2_member 28.03g used, =
1.26g free {cE4ePh-RWO8-Wgdy-YPOY-ehyC-KI6u-io1cyH}
> =E2=94=82 =E2=94=9Csdc2 244.14g [8:34] MD raid5 (3) inactive {2cff15d=
1-e411-447b-fd5d-472103e44022}
> =E2=94=82 =E2=94=9Csdc3 1.00k [8:35] Partitioned (dos)
> =E2=94=82 =E2=94=9Csdc5 30.00g [8:37] MD raid0 (2/3) (w/ sda5,sdb5) i=
n_sync 'reading.homeunix.com:3' {acd5374f-7262-8c93-6a90-6c4b5f675ce5}
> =E2=94=82 =E2=94=82=E2=94=94md124 90.00g [9:124] MD v1.2 raid0 (3) cl=
ean, 512k Chunk, None (None) None {acd5374f:72628c93:6a906c4b:5f675ce5}
> =E2=94=82 =E2=94=82                      PV LVM2_member 86.00g used, =
3.99g free {VmsWRd-8qHt-bauf-lvAn-FC97-KyH5-gk89ox}
> =E2=94=82 =E2=94=94sdc6 3.39g [8:38] Empty/Unknown
> =E2=94=94scsi 3:0:1:0 ATA      WDC WD30EZRX-00D {WD-WCC4N1294906}
>  =E2=94=94sdd 2.73t [8:48] Partitioned (gpt)
>   =E2=94=9Csdd1 2.00t [8:49] MD raid5 (0/3) (w/ sde1,sdf1) in_sync 'l=
amachine:128' {f2372cb9-d381-6fd6-ce86-d826882ec82e}
>   =E2=94=82=E2=94=94md127 4.00t [9:127] MD v1.2 raid5 (3) read-auto, =
512k Chunk {f2372cb9:d3816fd6:ce86d826:882ec82e}
>   =E2=94=82 =E2=94=82                   PV LVM2_member 3.50t used, 51=
1.75g free {NrF3vV-nS1f-wtjY-SfZk-xwUE-YbSB-TWWdLu}
>   =E2=94=82 =E2=94=94VG vg_media 4.00t 511.75g free {cPGpZK-OdZ6-sW71=
-8Rtf-x23f-BgEU-WGEmid}
>   =E2=94=82  =E2=94=94dm-1 3.50t [253:1] LV lv_media ext4 {ef90c386-7=
6e6-4843-a427-88412948d49f}
>   =E2=94=94sdd2 500.00g [8:50] MD raid0 (0/3) (w/ sde2,sdf2) in_sync =
'lamachine:129' {895dae98-d1a4-96de-4f59-0b8bcb8ac12a}
>    =E2=94=94md125 1.46t [9:125] MD v1.2 raid0 (3) clean, 512k Chunk, =
None (None) None {895dae98:d1a496de:4f590b8b:cb8ac12a}
>     =E2=94=82                   PV LVM2_member 512.00g used, 987.62g =
free {70aHF7-aTfj-X2y6-qYXF-szQu-QBFW-q4UlfG}
>     =E2=94=94VG vg_virt_dir 1.46t 987.62g free {SQXqhD-j5dR-Xsdh-NBoR=
-YMqk-YwfF-hyf9ur}
>      =E2=94=94dm-3 512.00g [253:3] LV lv_virt_dir1 ext4 {1929e452-ae8=
3-4766-bf0e-8575a7d1a3c8}
> PCI [ata_piix] 00:1f.5 IDE interface: Intel Corporation 82801JI (ICH1=
0 Family) 2 port SATA IDE Controller #2
> =E2=94=9Cscsi 4:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC4NCWT13RF}
> =E2=94=82=E2=94=94sde 2.73t [8:64] Partitioned (gpt)
> =E2=94=82 =E2=94=9Csde1 2.00t [8:65] MD raid5 (1/3) (w/ sdd1,sdf1) in=
_sync 'lamachine:128' {f2372cb9-d381-6fd6-ce86-d826882ec82e}
> =E2=94=82 =E2=94=82=E2=94=94md127 4.00t [9:127] MD v1.2 raid5 (3) rea=
d-auto, 512k Chunk {f2372cb9:d3816fd6:ce86d826:882ec82e}
> =E2=94=82 =E2=94=82                     PV LVM2_member 3.50t used, 51=
1.75g free {NrF3vV-nS1f-wtjY-SfZk-xwUE-YbSB-TWWdLu}
> =E2=94=82 =E2=94=94sde2 500.00g [8:66] MD raid0 (1/3) (w/ sdd2,sdf2) =
in_sync 'lamachine:129' {895dae98-d1a4-96de-4f59-0b8bcb8ac12a}
> =E2=94=82  =E2=94=94md125 1.46t [9:125] MD v1.2 raid0 (3) clean, 512k=
 Chunk, None (None) None {895dae98:d1a496de:4f590b8b:cb8ac12a}
> =E2=94=82                       PV LVM2_member 512.00g used, 987.62g =
free {70aHF7-aTfj-X2y6-qYXF-szQu-QBFW-q4UlfG}
> =E2=94=94scsi 5:0:0:0 ATA      WDC WD30EZRX-00D {WD-WCC4NPRDD6D7}
>  =E2=94=94sdf 2.73t [8:80] Partitioned (gpt)
>   =E2=94=9Csdf1 2.00t [8:81] MD raid5 (2/3) (w/ sdd1,sde1) in_sync 'l=
amachine:128' {f2372cb9-d381-6fd6-ce86-d826882ec82e}
>   =E2=94=82=E2=94=94md127 4.00t [9:127] MD v1.2 raid5 (3) read-auto, =
512k Chunk {f2372cb9:d3816fd6:ce86d826:882ec82e}
>   =E2=94=82                     PV LVM2_member 3.50t used, 511.75g fr=
ee {NrF3vV-nS1f-wtjY-SfZk-xwUE-YbSB-TWWdLu}
>   =E2=94=94sdf2 500.00g [8:82] MD raid0 (2/3) (w/ sdd2,sde2) in_sync =
'lamachine:129' {895dae98-d1a4-96de-4f59-0b8bcb8ac12a}
>    =E2=94=94md125 1.46t [9:125] MD v1.2 raid0 (3) clean, 512k Chunk, =
None (None) None {895dae98:d1a496de:4f590b8b:cb8ac12a}
>                         PV LVM2_member 512.00g used, 987.62g free {70=
aHF7-aTfj-X2y6-qYXF-szQu-QBFW-q4UlfG}
> PCI [pata_jmicron] 07:00.1 IDE interface: JMicron Technology Corp. JM=
B363 SATA/IDE Controller (rev 02)
> =E2=94=9Cscsi 6:x:x:x [Empty]
> =E2=94=94scsi 7:x:x:x [Empty]
>=20
> [root@localhost ~]# cat /proc/mdstat
> Personalities : [raid10] [raid0] [raid6] [raid5] [raid4]
> md124 : active raid0 sda5[0] sdb5[1] sdc5[2]
>       94367232 blocks super 1.2 512k chunks
>=20
> md125 : active raid0 sdf2[2] sdd2[0] sde2[1]
>       1572470784 blocks super 1.2 512k chunks
>=20
> md127 : active (auto-read-only) raid5 sdf1[3] sde1[1] sdd1[0]
>       4294705152 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3=
/3] [UUU]
>       bitmap: 0/16 pages [0KB], 65536KB chunk
>=20
> md126 : active raid10 sda2[0] sdc1[1]
>       30719936 blocks 2 near-copies [2/2] [UU]
>=20
> unused devices: <none>
> [root@localhost ~]# cat /etc/mdadm.conf
> # mdadm.conf written out by anaconda
> MAILADDR root
> AUTO +imsm +1.x -all
> ARRAY /dev/md/126 level=3Draid10 num-devices=3D2 UUID=3D9af006ca:8845=
bbd3:bfe78010:bc810f04

Ok.  Your array didn't assemble because mdadm.conf said not to.  The
AUTO clause is excluding unidentified v0.90 metadata.  The UUID
=2E...:bc810f04 was called out explicitly, so it assembled.

You should be safe to just assemble the array normally:

mdadm -A /dev/md2 /dev/sd{a3,b2,c2}

Then you need to create a new mdadm.conf.  I suggest you use "AUTO -all=
"
and explicitly list all of your arrays.  You only need the device name
and the UUID on each ARRAY line.  You can run "mdadm -Es
>>..../mdadm.conf" to add live arrays to the file, then trim out the
unnecessary details.

When mdadm.conf has your arrays, with the names you want them to keep,
update your initramfs.  (Command varies by distro.)

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

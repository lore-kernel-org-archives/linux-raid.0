From: Stefan Lamby <webmaster@peter-speer.de>
Subject: Re: Raid 1 needs repair
Date: Fri, 5 Feb 2016 11:02:57 +0100 (CET)
Message-ID: <1780660272.512114.1454666577942.JavaMail.open-xchange@app02.ox.hosteurope.de>
References: <285536573.454192.1454595669809.JavaMail.open-xchange@app01.ox.hosteurope.de> <56B36577.2030902@turmel.org> <1161942166.457494.1454601803851.JavaMail.open-xchange@app01.ox.hosteurope.de> <56B38012.5020404@turmel.org> <43098506.459602.1454607669214.JavaMail.open-xchange@app01.ox.hosteurope.de> <56B3C311.5060407@turmel.org>
Reply-To: Stefan Lamby <webmaster@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56B3C311.5060407@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> Please show lsdrv results after you add the proper utilities to the
> environment you run lsdrv from. At least install lvm utilities and
> mdadm utilities.
=20
This is the current output from the running system. sda is not the same=
 any
more, it has been changed to a new disk.
Hope it makes sense.
=20
lsdrv
PCI [ata_generic] 00:16.2 IDE interface: Intel Corporation 8 Series/C22=
0 Series
Chipset Family IDE-r Controller (rev 04)
=E2=94=9Cscsi 0:x:x:x [Empty]
=E2=94=94scsi 1:x:x:x [Empty]
PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 8 Series/C220 Ser=
ies
Chipset Family 6-port SATA Controller 1 [AHCI mode] (rev 05)
=E2=94=9Cscsi 2:0:0:0 ATA      WDC WD1003FZEX-0 {WD-WCC3F4PNVSLF}
=E2=94=82=E2=94=94sda 931.51g [8:0] Partitioned (dos)
=E2=94=82 =E2=94=94sda1 931.51g [8:1] Empty/Unknown
=E2=94=9Cscsi 3:0:0:0 ATA      WDC WD10EARS-00Y {WD-WCAV5D907687}
=E2=94=82=E2=94=94sdb 931.51g [8:16] Partitioned (dos)
=E2=94=82 =E2=94=94sdb1 931.51g [8:17] MD raid1 (1/2) in_sync 'speernix=
15:0'
{68c0c9ad-82ed-e879-2110-f4279f31c140}
=E2=94=82  =E2=94=94md0 931.39g [9:0] MD v1.2 raid1 (2) active DEGRADED
{68c0c9ad:82ede879:2110f427:9f31c140}
=E2=94=82   =E2=94=82                 PV LVM2_member 288,70g used, 642,=
68g free
{hHvrtB-7XOz-L6j6-AnXd-Q3Wh-uHqw-bQ3RQS}
=E2=94=82   =E2=94=94VG vg_raid1 931,38g 642,68g free {mopUew-B2i4-9fmo=
-mlXP-Z8C3-nPYO-XM56AY}
=E2=94=82    =E2=94=9Cdm-2 186.26g [252:2] LV home ext4 {8ee8d203-f306-=
4846-93fe-225b018f2965}
=E2=94=82    =E2=94=82=E2=94=94Mounted as /dev/mapper/vg_raid1-home @ /=
home
=E2=94=82    =E2=94=9Cdm-0 93.13g [252:0] LV root ext4 {9f9568cf-d48a-4=
690-97a8-14576d724daf}
=E2=94=82    =E2=94=82=E2=94=94Mounted as /dev/mapper/vg_raid1-root @ /
=E2=94=82    =E2=94=94dm-1 9.31g [252:1] LV swap swap {9fbbac0f-0d49-47=
b0-a50b-d293f19f23ef}
=E2=94=9Cscsi 4:x:x:x [Empty]
=E2=94=9Cscsi 5:0:0:0 ATA      SAMSUNG HD103UJ  {S13PJ9BQ900571}
=E2=94=82=E2=94=94sdc 931.51g [8:32] Partitioned (dos)
=E2=94=82 =E2=94=94sdc1 931.51g [8:33] MD raid1 (0/2) (w/ sdd1) in_sync=
 'speernix15:1'
{a9a43761-8148-b29e-5db4-9d7ac4d0a219}
=E2=94=82  =E2=94=94md1 931.39g [9:1] MD v1.2 raid1 (2) clean
{a9a43761:8148b29e:5db49d7a:c4d0a219}
=E2=94=82   =E2=94=82                 PV LVM2_member 500,00g used, 431,=
38g free
{JIUAPd-MMX8-k2UK-1NDY-h2Od-iBHk-a1QvgX}
=E2=94=82   =E2=94=94VG vg_backup_raid1 931,38g 431,38g free
{esKsCr-quUI-ckjF-Q6jc-wYYZ-eKL4-MRas87}
=E2=94=82    =E2=94=94dm-3 500.00g [252:3] LV lv_backup ext4
{e3600494-308f-4874-9083-ecd31a66e68a}
=E2=94=82     =E2=94=94Mounted as /dev/mapper/vg_backup_raid1-lv_backup=
 @ /backup
=E2=94=9Cscsi 6:0:0:0 ATA      SAMSUNG HD103UJ  {S13PJ9BQA17616}
=E2=94=82=E2=94=94sdd 931.51g [8:48] Partitioned (dos)
=E2=94=82 =E2=94=94sdd1 931.51g [8:49] MD raid1 (1/2) (w/ sdc1) in_sync=
 'speernix15:1'
{a9a43761-8148-b29e-5db4-9d7ac4d0a219}
=E2=94=82  =E2=94=94md1 931.39g [9:1] MD v1.2 raid1 (2) clean
{a9a43761:8148b29e:5db49d7a:c4d0a219}
=E2=94=82                     PV LVM2_member 500,00g used, 431,38g free
{JIUAPd-MMX8-k2UK-1NDY-h2Od-iBHk-a1QvgX}
=E2=94=94scsi 7:x:x:x [Empty]
=20
=20
cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4]
[raid10]
md1 : active raid1 sdd1[1] sdc1[0]
      976630336 blocks super 1.2 [2/2] [UU]
     =20
md0 : active raid1 sdb1[1]
      976629568 blocks super 1.2 [2/1] [_U]
     =20
unused devices: <none>

pvs
  PV         VG              Fmt  Attr PSize   PFree =20
  /dev/md0   vg_raid1        lvm2 a--  931,38g 642,68g
  /dev/md1   vg_backup_raid1 lvm2 a--  931,38g 431,38g
=20
lvs
  LV        VG              Attr      LSize   Pool Origin Data%  Move L=
og Copy%
 Convert
  lv_backup vg_backup_raid1 -wi-ao--- 500,00g
                                         =20
  home      vg_raid1        -wi-ao--- 186,26g
                                         =20
  root      vg_raid1        -wi-ao---  93,13g
                                         =20
  swap      vg_raid1        -wi-ao---   9,31g=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

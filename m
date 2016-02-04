From: Stefan Lamby <webmaster@peter-speer.de>
Subject: Raid 1 needs repair
Date: Thu, 4 Feb 2016 15:21:09 +0100 (CET)
Message-ID: <285536573.454192.1454595669809.JavaMail.open-xchange@app01.ox.hosteurope.de>
Reply-To: Stefan Lamby <webmaster@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi.
My md0 is broken because of a damaged sda.
It was simple to find out which on it is thanks to lsdrv by Mr Turmel.

Now I have a new disk, same size, as sda with sda1 partition - same siz=
e -
formatted as Linux raid autodetect.
In the end I like to end up with the new sda1 as member of md0 and I ne=
ed to put
my boot information there, since sdb1, also member of md0, seems to no =
have no
such info because the system wasn't booting with a missing sda1.

I am afraid of loosing data, so I prefer asking, what to do next.
Please guide, I have the system up and running on a sysrescd live distr=
o.

Thank you very much.
-fuz


Here is some further information.


----------------- /sbin/lsdrv specific information
------------------------------------------
PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 8 Series/C220 Ser=
ies
Chipset Family 6-port SATA Controller 1 [AHCI mode] (rev 05)
=E2=94=9Cscsi 0:0:0:0 ATA      WDC WD1001FALS-0 {WD-WMATV0444833}
=E2=94=82=E2=94=94sda 931.51g [8:0] Empty/Unknown
=E2=94=82 =E2=94=94sda1 931.51g [8:1] Empty/Unknown
=E2=94=82  =E2=94=94md0 931.39g [9:0] MD v1.2 raid1 (2) active {None}
=E2=94=82   =E2=94=82                 Empty/Unknown
=E2=94=82   =E2=94=9Cdm-1 93.13g [252:1] Empty/Unknown
=E2=94=82   =E2=94=82=E2=94=94Mounted as /dev/mapper/vg_raid1-root @ /
=E2=94=82   =E2=94=9Cdm-2 9.31g [252:2] Empty/Unknown
=E2=94=82   =E2=94=94dm-3 186.26g [252:3] Empty/Unknown
=E2=94=82    =E2=94=94Mounted as /dev/mapper/vg_raid1-home @ /home
=E2=94=9Cscsi 1:0:0:0 ATA      WDC WD10EARS-00Y {WD-WCAV5D907687}
=E2=94=82=E2=94=94sdb 931.51g [8:16] Empty/Unknown
=E2=94=82 =E2=94=94sdb1 931.51g [8:17] Empty/Unknown
=E2=94=82  =E2=94=94md0 931.39g [9:0] MD v1.2 raid1 (2) active {None}
=E2=94=82                     Empty/Unknown
=E2=94=9Cscsi 2:x:x:x [Empty]
=E2=94=9Cscsi 3:0:0:0 ATA      SAMSUNG HD103UJ  {S13PJ9BQ900571}
=E2=94=82=E2=94=94sdc 931.51g [8:32] Empty/Unknown
=E2=94=82 =E2=94=94sdc1 931.51g [8:33] Empty/Unknown
=E2=94=82  =E2=94=94md1 931.39g [9:1] MD v1.2 raid1 (2) clean {None}
=E2=94=82   =E2=94=82                 Empty/Unknown
=E2=94=82   =E2=94=94dm-0 500.00g [252:0] Empty/Unknown
=E2=94=82    =E2=94=94Mounted as /dev/mapper/vg_backup_raid1-lv_backup =
@ /backup
=E2=94=9Cscsi 4:0:0:0 ATA      SAMSUNG HD103UJ  {S13PJ9BQA17616}
=E2=94=82=E2=94=94sdd 931.51g [8:48] Empty/Unknown
=E2=94=82 =E2=94=94sdd1 931.51g [8:49] Empty/Unknown
=E2=94=82  =E2=94=94md1 931.39g [9:1] MD v1.2 raid1 (2) clean {None}
=E2=94=82                     Empty/Unknown
=E2=94=94scsi 5:x:x:x [Empty]
Other Block Devices
=E2=94=9Cloop0 0.00k [7:0] Empty/Unknown
=E2=94=9Cloop1 0.00k [7:1] Empty/Unknown
=E2=94=9Cloop2 0.00k [7:2] Empty/Unknown
=E2=94=9Cloop3 0.00k [7:3] Empty/Unknown
=E2=94=9Cloop4 0.00k [7:4] Empty/Unknown
=E2=94=9Cloop5 0.00k [7:5] Empty/Unknown
=E2=94=9Cloop6 0.00k [7:6] Empty/Unknown
=E2=94=9Cloop7 0.00k [7:7] Empty/Unknown
=E2=94=9Cram0 64.00m [1:0] Empty/Unknown
=E2=94=9Cram1 64.00m [1:1] Empty/Unknown
=E2=94=9Cram2 64.00m [1:2] Empty/Unknown
=E2=94=9Cram3 64.00m [1:3] Empty/Unknown
=E2=94=9Cram4 64.00m [1:4] Empty/Unknown
=E2=94=9Cram5 64.00m [1:5] Empty/Unknown
=E2=94=9Cram6 64.00m [1:6] Empty/Unknown
=E2=94=9Cram7 64.00m [1:7] Empty/Unknown
=E2=94=9Cram8 64.00m [1:8] Empty/Unknown
=E2=94=9Cram9 64.00m [1:9] Empty/Unknown
=E2=94=9Cram10 64.00m [1:10] Empty/Unknown
=E2=94=9Cram11 64.00m [1:11] Empty/Unknown
=E2=94=9Cram12 64.00m [1:12] Empty/Unknown
=E2=94=9Cram13 64.00m [1:13] Empty/Unknown
=E2=94=9Cram14 64.00m [1:14] Empty/Unknown
=E2=94=94ram15 64.00m [1:15] Empty/Unknown

----------------- RAID specific information (mdadm --examine /dev/sdXY)
---------------------
/dev/sda1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 68c0c9ad:82ede879:2110f427:9f31c140
           Name : speernix15:0
  Creation Time : Sun Nov 30 18:15:35 2014
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1953259520 (931.39 GiB 1000.07 GB)
     Array Size : 976629568 (931.39 GiB 1000.07 GB)
  Used Dev Size : 1953259136 (931.39 GiB 1000.07 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262064 sectors, after=3D384 sectors
          State : clean
    Device UUID : 94a0a338:7876e6f4:f8eaa27c:05a34dfa

    Update Time : Thu Feb  4 05:38:26 2016
       Checksum : 7fe3fbef - correct
         Events : 700


   Device Role : Active device 1
   Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)

/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : a9a43761:8148b29e:5db49d7a:c4d0a219
           Name : speernix15:1
  Creation Time : Sun Dec 21 10:18:05 2014
     Raid Level : raid1
   Raid Devices : 2

 Avail Dev Size : 1953260976 (931.39 GiB 1000.07 GB)
     Array Size : 976630336 (931.39 GiB 1000.07 GB)
  Used Dev Size : 1953260672 (931.39 GiB 1000.07 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
   Unused Space : before=3D262064 sectors, after=3D304 sectors
          State : clean
    Device UUID : 8150c54e:3b72da54:4544c33d:36372195

    Update Time : Thu Feb  4 11:58:22 2016
       Checksum : 56cbbb8d - correct
         Events : 571


   Device Role : Active device 0
   Array State : AA ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D =
replacing)


----------------- disk specific information (ls -l /dev/disk/by-id/)
-----------------------
insgesamt 0
lrwxrwxrwx 1 root root  9 Apr  9 09:36 ata-SAMSUNG_HD103UJ_S13PJ9BQ9005=
71 ->
=2E./../sdc
lrwxrwxrwx 1 root root 10 Apr  9 09:36 ata-SAMSUNG_HD103UJ_S13PJ9BQ9005=
71-part1
-> ../../sdc1
lrwxrwxrwx 1 root root  9 Apr  9 09:36 ata-SAMSUNG_HD103UJ_S13PJ9BQA176=
16 ->
=2E./../sdd
lrwxrwxrwx 1 root root 10 Apr  9 09:36 ata-SAMSUNG_HD103UJ_S13PJ9BQA176=
16-part1
-> ../../sdd1
lrwxrwxrwx 1 root root  9 Apr  9 09:36 ata-WDC_WD1001FALS-00J7B0_WD-WMA=
TV0444833
-> ../../sda
lrwxrwxrwx 1 root root 10 Apr  9 09:36
ata-WDC_WD1001FALS-00J7B0_WD-WMATV0444833-part1 -> ../../sda1
lrwxrwxrwx 1 root root  9 Apr  9 09:36 ata-WDC_WD10EARS-00Y5B1_WD-WCAV5=
D907687
-> ../../sdb
lrwxrwxrwx 1 root root 10 Apr  9 09:36
ata-WDC_WD10EARS-00Y5B1_WD-WCAV5D907687-part1 -> ../../sdb1
lrwxrwxrwx 1 root root 10 Apr  9 09:36 dm-name-vg_backup_raid1-lv_backu=
p ->
=2E./../dm-0
lrwxrwxrwx 1 root root 10 Apr  9 09:36 dm-name-vg_raid1-home -> ../../d=
m-3
lrwxrwxrwx 1 root root 10 Apr  9 09:36 dm-name-vg_raid1-root -> ../../d=
m-1
lrwxrwxrwx 1 root root 10 Apr  9 09:36 dm-name-vg_raid1-swap -> ../../d=
m-2
lrwxrwxrwx 1 root root 10 Apr  9 09:36
dm-uuid-LVM-esKsCrquUIckjFQ6jcwYYZeKL4MRas87bdFuJuYmp3W1AwMDgzs0twPC8CL=
UZfV6 ->
=2E./../dm-0
lrwxrwxrwx 1 root root 10 Apr  9 09:36
dm-uuid-LVM-mopUewB2i49fmomlXPZ8C3nPYOXM56AY3j92rd0GrGN3Ugvuxb8mlMbC36f=
MWbYO ->
=2E./../dm-2
lrwxrwxrwx 1 root root 10 Apr  9 09:36
dm-uuid-LVM-mopUewB2i49fmomlXPZ8C3nPYOXM56AYplkh4xXCaC38PiDHPMyzTTs9JE5=
BRIHa ->
=2E./../dm-3
lrwxrwxrwx 1 root root 10 Apr  9 09:36
dm-uuid-LVM-mopUewB2i49fmomlXPZ8C3nPYOXM56AYWBztmrFbDYLRGYdm6Eqi4oe4vvp=
Vir3t ->
=2E./../dm-1
lrwxrwxrwx 1 root root  9 Apr  9 09:36 md-name-speernix15:0 -> ../../md=
0
lrwxrwxrwx 1 root root  9 Apr  9 09:36 md-name-speernix15:1 -> ../../md=
1
lrwxrwxrwx 1 root root  9 Apr  9 09:36
md-uuid-68c0c9ad:82ede879:2110f427:9f31c140 -> ../../md0
lrwxrwxrwx 1 root root  9 Apr  9 09:36
md-uuid-a9a43761:8148b29e:5db49d7a:c4d0a219 -> ../../md1
lrwxrwxrwx 1 root root  9 Apr  9 09:36 wwn-0x50000f0007095017 -> ../../=
sdc
lrwxrwxrwx 1 root root 10 Apr  9 09:36 wwn-0x50000f0007095017-part1 ->
=2E./../sdc1
lrwxrwxrwx 1 root root  9 Apr  9 09:36 wwn-0x50000f00071a6761 -> ../../=
sdd
lrwxrwxrwx 1 root root 10 Apr  9 09:36 wwn-0x50000f00071a6761-part1 ->
=2E./../sdd1
lrwxrwxrwx 1 root root  9 Apr  9 09:36 wwn-0x50014ee0aba9f580 -> ../../=
sda
lrwxrwxrwx 1 root root 10 Apr  9 09:36 wwn-0x50014ee0aba9f580-part1 ->
=2E./../sda1
lrwxrwxrwx 1 root root  9 Apr  9 09:36 wwn-0x50014ee259f4ab35 -> ../../=
sdb
lrwxrwxrwx 1 root root 10 Apr  9 09:36 wwn-0x50014ee259f4ab35-part1 ->
=2E./../sdb1


Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [r=
aid4]
[raid10]
md1 : active raid1 sdb1[0] sdc1[1]
      976630336 blocks super 1.2 [2/2] [UU]
    =20
md0 : active raid1 sda1[1]
      976629568 blocks super 1.2 [2/1] [_U]
    =20
unused devices: <none>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

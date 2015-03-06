From: Stefan Lamby <webmaster@peter-speer.de>
Subject: Re: Raid 10 Issue - Booting in case raid failed
Date: Fri, 6 Mar 2015 20:06:40 +0100 (CET)
Message-ID: <322760937.22899.1425668800663.JavaMail.open-xchange@app04.ox.hosteurope.de>
References: <1888475554.226351.1425578160090.JavaMail.open-xchange@app09.ox.hosteurope.de> <54F8B792.9060206@turmel.org> <1315687872.8638.1425636591443.JavaMail.open-xchange@app04.ox.hosteurope.de>
Reply-To: Stefan Lamby <webmaster@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1315687872.8638.1425636591443.JavaMail.open-xchange@app04.ox.hosteurope.de>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi list.

If everything will work out OK, I will end up with an raid 10 array wit=
h 4
devices.

My partition design and layout structure will be found at the end, if n=
eeded.

There are a few questions left for me in case I have to boot with a fai=
led disk:

1) As you might have seen from the partition design, only partition sda=
1 has the
boot flag set. As far as I guess, the ubuntu installer was using grub-i=
nstall
only for sda. I am kind of afraid what will happen, in case sda will fa=
il in the
future. Will it be a good idea to grub-install to all the other devices=
 also?
2) What about the boot flag, if I need to grub-install the other device=
s also?
Should it be O or 1? Do I have to leave it set to false and in case thi=
ngs go
wrong boot from a live cd and set it to on to boot from another device?

What do you recommend?

Thanks
Stefan




Here is my layout - please do not care

root@kvm15:~# fdisk -l /dev/sda

Disk /dev/sda: 2000.4 GB, 2000398934016 bytes
255 K=C3=B6pfe, 63 Sektoren/Spur, 243201 Zylinder, zusammen 3907029168 =
Sektoren
Einheiten =3D Sektoren von 1 =C3=97 512 =3D 512 Bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
=46estplattenidentifikation: 0x00071c2b

   Ger=C3=A4t  boot.     Anfang        Ende     Bl=C3=B6cke   Id  Syste=
m
/dev/sda1   *    98435072  3907028991  1904296960   fd  Linux raid auto=
detect

Here as an example for all other disks

Disk /dev/sdb: 2000.4 GB, 2000398934016 bytes
255 K=C3=B6pfe, 63 Sektoren/Spur, 243201 Zylinder, zusammen 3907029168 =
Sektoren
Einheiten =3D Sektoren von 1 =C3=97 512 =3D 512 Bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 4096 bytes
=46estplattenidentifikation: 0x0008624b

   Ger=C3=A4t  boot.     Anfang        Ende     Bl=C3=B6cke   Id  Syste=
m
/dev/sdb1        98435072  3907028991  1904296960   fd  Linux raid auto=
detect

PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 82801JI (ICH10 Fa=
mily)
SATA AHCI Controller
=E2=94=9Cscsi 2:0:0:0 ATA      WDC WD20PURX-64P {WD-WCC4M1LPT1AE}
=E2=94=82=E2=94=94sda 1.82t [8:0] Partitioned (dos)
=E2=94=82 =E2=94=94sda1 1.77t [8:1] MD raid10,near2 (0/2) (w/ sdb1) in_=
sync 'kvm15:0'
{75079a2f-acb8-c475-85f8-ca430ad85c4c}
=E2=94=82  =E2=94=94md0 1.77t [9:0] MD v1.2 raid10,near2 (2) clean, 512=
k Chunk
{75079a2f:acb8c475:85f8ca43:0ad85c4c}
=E2=94=82   =E2=94=82               PV LVM2_member 1.01t used, 780.45g =
free
{2hsby0-0FOT-PPbC-il1r-ux9J-lUd2-nPHj7T}
=E2=94=82   =E2=94=94VG vg_raid10 5.32t (w/ md10) 3.30t free
{HbjouC-RgUe-YYNB-z2ns-4kzK-RwJH-RHWSWq}
=E2=94=82    =E2=94=9Cdm-0 479.39g [252:0] LV home ext4 {2d67d9cc-0378-=
4669-9d72-7b7c7071dea8}
=E2=94=82    =E2=94=82=E2=94=94Mounted as /dev/mapper/vg_raid10-home @ =
/home
=E2=94=82    =E2=94=9Cdm-1 93.13g [252:1] LV root ext4 {c14e4524-e95c-4=
5c2-bfa0-75d529ed48fe}
=E2=94=82    =E2=94=82=E2=94=94Mounted as /dev/mapper/vg_raid10-root @ =
/
=E2=94=82    =E2=94=9Cdm-4 23.28g [252:4] LV swap swap {9e1a582f-1c88-4=
4a2-be90-aafcb96805c7}
=E2=94=82    =E2=94=9Cdm-3 46.56g [252:3] LV tmp ext4 {ac67d0d9-049c-4c=
f2-9a0e-591cdb6a3559}
=E2=94=82    =E2=94=82=E2=94=94Mounted as /dev/mapper/vg_raid10-tmp @ /=
tmp
=E2=94=82    =E2=94=94dm-2 393.13g [252:2] LV var ext4 {ff71c558-c1f8-4=
410-8e2a-dc9c77c27a03}
=E2=94=82     =E2=94=94Mounted as /dev/mapper/vg_raid10-var @ /var
=E2=94=9Cscsi 3:0:0:0 ATA      WDC WD20PURX-64P {WD-WCC4M5LAR62D}
=E2=94=82=E2=94=94sdb 1.82t [8:16] Partitioned (dos)
=E2=94=82 =E2=94=94sdb1 1.77t [8:17] MD raid10,near2 (1/2) (w/ sda1) in=
_sync 'kvm15:0'
{75079a2f-acb8-c475-85f8-ca430ad85c4c}
=E2=94=82  =E2=94=94md0 1.77t [9:0] MD v1.2 raid10,near2 (2) clean, 512=
k Chunk
{75079a2f:acb8c475:85f8ca43:0ad85c4c}
=E2=94=82                   PV LVM2_member 1.01t used, 780.45g free
{2hsby0-0FOT-PPbC-il1r-ux9J-lUd2-nPHj7T}
=E2=94=9Cscsi 4:0:0:0 ATA      WDC WD20PURX-64P {WD-WCC4M7YA1ANR}
=E2=94=82=E2=94=94sdc 1.82t [8:32] Partitioned (dos)
=E2=94=82 =E2=94=94sdc1 1.77t [8:33] MD raid10,near2 (1/4) (w/ sdd1) in=
_sync 'kvm15:10'
{c4540426-9c66-8fe2-4795-13f242d233b4}
=E2=94=82  =E2=94=94md10 3.55t [9:10] MD v1.2 raid10,near2 (4) active D=
EGRADEDx2, 512k Chunk
{c4540426:9c668fe2:479513f2:42d233b4}
=E2=94=82   =E2=94=82                 PV LVM2_member 1.01t used, 2.54t =
free
{wYV8fH-uOp2-E88P-EIp5-6U33-chYg-S94vvy}
=E2=94=82   =E2=94=94VG vg_raid10 5.32t (w/ md0) 3.30t free
{HbjouC-RgUe-YYNB-z2ns-4kzK-RwJH-RHWSWq}
=E2=94=94scsi 5:0:0:0 ATA      WDC WD20PURX-64P {WD-WCC4M5AFRYVP}
 =E2=94=94sdd 1.82t [8:48] Partitioned (dos)
  =E2=94=94sdd1 1.77t [8:49] MD raid10,near2 (3/4) (w/ sdc1) in_sync 'k=
vm15:10'
{c4540426-9c66-8fe2-4795-13f242d233b4}
   =E2=94=94md10 3.55t [9:10] MD v1.2 raid10,near2 (4) active DEGRADEDx=
2, 512k Chunk
{c4540426:9c668fe2:479513f2:42d233b4}
                      PV LVM2_member 1.01t used, 2.54t free
{wYV8fH-uOp2-E88P-EIp5-6U33-chYg-S94vvy}
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

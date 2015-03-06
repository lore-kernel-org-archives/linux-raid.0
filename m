From: Stefan Lamby <webmaster@peter-speer.de>
Subject: Re: Raid 10 Issue - Swapping Data from Array to Array
Date: Fri, 6 Mar 2015 11:09:51 +0100 (CET)
Message-ID: <1315687872.8638.1425636591443.JavaMail.open-xchange@app04.ox.hosteurope.de>
References: <1888475554.226351.1425578160090.JavaMail.open-xchange@app09.ox.hosteurope.de> <54F8B792.9060206@turmel.org>
Reply-To: Stefan Lamby <webmaster@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54F8B792.9060206@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> Phil Turmel <philip@turmel.org> hat am 5. M=C3=A4rz 2015 um 21:07 ges=
chrieben:
>
>
> On 03/05/2015 12:56 PM, Stefan Lamby wrote:
> > Hello List.
> >
> > I was setting up a new machine using ubuntu 14.04.02 lts using its
> > installer,
> > configuring a raid 10 with 2 disks and lvm on top of it. I was usin=
g 2 disks
> > and
> > now I like to add 2 more disks to the array so i want to end up wit=
h 4
> > disks, no
> > spare.
> >
> > Searching the internet I found that I am not able to --grow the arr=
ay with
> > the
> > mdadm version this ubuntu is using (v3.2.5).
> > Is that right?
> >
> > So I decided to build a new array that way and try to move my data
> > afterwards,
> > which failed:
> > (Is it OK to do it that way or do you recommend another?)
>
> No, you should be able to do this. Probably without any shutdown.
> Please show the full layout of your drives, partitions, and lvm.
>
> I suggest lsdrv[1] for working layouts. If your email is set to use
> utf8, just paste the result in a reply.
>
> Regards,
>
> Phil Turmel
>
> [1] https://github.com/pturmel/lsdrv
>

Hi Phil.
I like your suggestion using lsdrv. Pretty nice. Here is the output (in=
cluding
the newly created array):

root@kvm15:~/lsdrv/lsdrv# ./lsdrv=20
PCI [ata_piix] 00:1f.5 IDE interface: Intel Corporation 82801JI (ICH10 =
=46amily) 2
port SATA IDE Controller #2
=E2=94=9Cscsi 0:0:0:0 HL-DT-ST DVD-RAM GH60L    {K1XA5SF1137}
=E2=94=82=E2=94=94sr0 3.68g [11:0] udf 'UDF_Volume'
=E2=94=94scsi 1:x:x:x [Empty]
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
=E2=94=82   =E2=94=94VG vg_raid10 1.77t 780.45g free {HbjouC-RgUe-YYNB-=
z2ns-4kzK-RwJH-RHWSWq}
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
=E2=94=82  =E2=94=94md10 3.55t [9:10] MD v1.2 raid10,near2 (4) clean DE=
GRADEDx2, 512k Chunk
{c4540426:9c668fe2:479513f2:42d233b4}
=E2=94=82                     Empty/Unknown
=E2=94=94scsi 5:0:0:0 ATA      WDC WD20PURX-64P {WD-WCC4M5AFRYVP}
 =E2=94=94sdd 1.82t [8:48] Partitioned (dos)
  =E2=94=94sdd1 1.77t [8:49] MD raid10,near2 (3/4) (w/ sdc1) in_sync 'k=
vm15:10'
{c4540426-9c66-8fe2-4795-13f242d233b4}
   =E2=94=94md10 3.55t [9:10] MD v1.2 raid10,near2 (4) clean DEGRADEDx2=
, 512k Chunk
{c4540426:9c668fe2:479513f2:42d233b4}
                      Empty/Unknown


This is what I got right now.
What do you recommend to do?

Stefan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

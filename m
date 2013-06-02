From: Chris Finley <debenbain@gmail.com>
Subject: Re: Wiki-recovering failed raid, overlay problem
Date: Sat, 1 Jun 2013 22:07:37 -0700
Message-ID: <CAGXrYFTyzG-hakGrU9j1=TSmjZHbzs2aRypJX=w8O4viS1+Dfg@mail.gmail.com>
References: <CAGXrYFTamGFyiOz34ZV+zaoXMA3D9z-eJjco3gApdK95QR9fPg@mail.gmail.com>
	<51AA83FD.8080500@turmel.org>
	<CAGXrYFSgoLpKO-UHd_tvOh3gs3Ub2qqOKA48kPEA1Pr=cnrUhA@mail.gmail.com>
	<51AAA0B9.3050908@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AAA0B9.3050908@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
> Please show the output of my 'lsdrv' script [1] as your system is now
> set up.
>

# ./raidfail/lsdrv
PCI [ahci] 00:1f.2 SATA controller: Intel Corporation 82801IR/IO/IH
(ICH9R/DO/DH) 6 port SATA Controller [AHCI mode] (rev 02)
=E2=94=9Cscsi 0:0:0:0 ATA      WDC WD20EARX-00P {WD-WCAZAL145223}
=E2=94=82=E2=94=94sda 1.82t [8:0] Partitioned (dos)
=E2=94=82 =E2=94=9Csda1 4.66g [8:1] ext4 {23b488a2-5a22-487a-a83f-bfa76=
1754617}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sda1 @ /boot
=E2=94=82 =E2=94=9Csda2 1.00k [8:2] Partitioned (dos)
=E2=94=82 =E2=94=9Csda5 29.80g [8:5] swap {720281cd-d82f-4368-ae44-f684=
08f28282}
=E2=94=82 =E2=94=9Csda6 51.22g [8:6] ext4 {321440e1-4078-4605-9d3d-4419=
bcb4d618}
=E2=94=82 =E2=94=82=E2=94=94Mounted as /dev/sda6 @ /var
=E2=94=82 =E2=94=94sda7 1.74t [8:7] ext4 {f52145cc-c13f-4230-89a0-e2a34=
3f956f7}
=E2=94=82  =E2=94=94Mounted as /dev/disk/by-uuid/f52145cc-c13f-4230-89a=
0-e2a343f956f7 @ /
=E2=94=9Cscsi 1:x:x:x [Empty]
=E2=94=9Cscsi 2:x:x:x [Empty]
=E2=94=9Cscsi 3:x:x:x [Empty]
=E2=94=9Cscsi 4:x:x:x [Empty]
=E2=94=94scsi 5:x:x:x [Empty]
PCI [ahci] 04:00.0 SATA controller: JMicron Technology Corp. JMB363
SATA/IDE Controller (rev 02)
=E2=94=9Cscsi 6:0:0:0 ATA      ST2000DL004 HD20 {S2H7J9FC302772}
=E2=94=82=E2=94=94sdb 1.82t [8:16] Partitioned (dos)
=E2=94=82 =E2=94=94sdb1 1.82t [8:17] MD raid5 (4) inactive
{44ecd957-d23c-44b1-b664-13437cc40f45}
=E2=94=94scsi 7:x:x:x [Empty]
PCI [sata_sil24] 07:01.0 RAID bus controller: Silicon Image, Inc. SiI
3124 PCI-X Serial ATA Controller (rev 02)
=E2=94=9Cscsi 8:0:0:0 ATA      SAMSUNG HD204UI  {S2H7JD2B105685}
=E2=94=82=E2=94=94sdc 1.82t [8:32] Partitioned (dos)
=E2=94=82 =E2=94=94sdc1 1.82t [8:33] MD raid5 (4) inactive
{44ecd957-d23c-44b1-b664-13437cc40f45}
=E2=94=9Cscsi 9:x:x:x [Empty]
=E2=94=9Cscsi 10:0:0:0 ATA      SAMSUNG HD204UI  {S2H7JD2B105686}
=E2=94=82=E2=94=94sdd 1.82t [8:48] Partitioned (dos)
=E2=94=82 =E2=94=94sdd1 1.82t [8:49] MD raid5 (4) inactive
{44ecd957-d23c-44b1-b664-13437cc40f45}
=E2=94=94scsi 11:0:0:0 ATA      SAMSUNG HD204UI  {S2H7JD2B105687}
 =E2=94=94sde 1.82t [8:64] Partitioned (dos)
  =E2=94=94sde1 1.82t [8:65] MD raid5 (4) inactive
{44ecd957-d23c-44b1-b664-13437cc40f45}
PCI [pata_jmicron] 04:00.1 IDE interface: JMicron Technology Corp.
JMB363 SATA/IDE Controller (rev 02)
=E2=94=9Cscsi 12:0:0:0 LITE-ON  DVDRW SHM-165H6S {LITE-ON_DVDRW_SHM-165=
H6S}
=E2=94=82=E2=94=94sr0 1.00g [11:0] Empty/Unknown
=E2=94=94scsi 13:x:x:x [Empty]
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


> Your drive with S/N S2H7JD2B105688 seems to be the worst, with
> triple-digit pending sectors.  This suggests a mismatch between your
> drives' error correction time limits and the linux drivers' default
> timeout.

I'm not sure that I understand this. Wouldn't the drive move a bad
sector regardless of the OS timeout?
Can you point me to more information on correcting the time limits?

The change in device mapping went like this:
At Failure --> Now
sdc                                              --> sdc
sdd  (2nd drop, most errors)       --> ddrescue to sdb and then unplugg=
ed
sde (1st drop, low event count)   --> sdd
sdf                                               --> sde


>  And a lack of regular scrubbing to clean up pending sectors.
> "smartctl -l scterc" for each drive would give useful information.
> Anyways, the drive may not be really failing--it has zero relocations=
=2E
>
> If S2H7JD2B105688 was the old /dev/sdd, then it doesn't matter, but
> you've now lost the opportunity to correct those sectors.

The failed sdd has the serial number S2H7JD2B105688. I still have the
drive, it's just unplugged.

Running "smartctl -l scterc" produces some interesting results.

# smartctl -l scterc /dev/sdb
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-44-generic] (local b=
uild)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

# smartctl -l scterc /dev/sdc
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-44-generic] (local b=
uild)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

l# smartctl -l scterc /dev/sdd
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-44-generic] (local b=
uild)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

# smartctl -l scterc /dev/sde
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-44-generic] (local b=
uild)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

SCT Error Recovery Control:
           Read: Disabled
          Write: Disabled

What is going on here? How would error recovery get disabled?

>
> Phil
>
> [1] http://github.com/pturmel/lsdrv/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

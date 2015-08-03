From: "Wilson, Jonathan" <i400s@hotmail.com>
Subject: How will mdadm handle a wrongly added drive, when the original
 comes back on line?
Date: Mon, 3 Aug 2015 14:14:58 +0100
Message-ID: <BLU437-SMTP91911FDCDB54E9FBB43E5BE1770@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Due to a bug in the driver for a Marvel chipset 4 port SATA card I thin=
k
I may have added an empty drive partition into a raid6 array and when I
get a new card I it will end up seeing not only the new drive, but also
the "missing" drive.

Events:
Upgraded jessie with latest updates (quite some time since I last did
it) and re-booted.

A 6 drive raid6 assembled, but all the drives were spare. Stopped the
array and did a mdadm --assemble /dev/md6.

It assembled with 5 drives, one missing.

Tried re-add, which failed, and then -add which completed ok.

Some time later I re-booted and the same problem happened.

All drives spare, stopped, assembled, added missing.

Its now working and I have a new card on order due to something going
badly wrong with the driver and/or card and/or chipset (Marvel 9230).

After some time passed after the second boot, I realised that one of my
drives was physically missing. I had a drive ready to go as a genuine
spare but not yet added as a spare to mdadm, so in theory it should hav=
e
been totally empty apart from a partition.

Now my problem is that firstly I can not be sure that when I looked
at /proc/mdstat/ and saw "all" the drives as spare there might have bee=
n
a missing one. (On either or both occasions.)

In my mdadm.config I don't specify the number of drives in the array,
just its name and the UUID.

Now my question is: if we call the drives in the array A,B,C,D,E,F and
the empty one G.

After the first boot I may have added G, so the array would be
A,B,C,D,E,G. (F missing from system)

After the second boot I may have added F back, so the array would be
A,B,C,D,E,F (G missing from system)

If after changing the card the system sees A,B,C,D,E,F,G how will mdadm
work? Will it fail to assemble as one of the drives is "extra" to the
metadata count (I assume even though I don't specify a count in the
conf, that internally on the partitions of the disks in the array it
knows there should be "6" disks.

Will it see that disk "7" is out of date/wrong count and decide it
should not be part of the array automagically?

If mdadm refuses to assemble the array, I assume I will need to assembl=
e
it using a full list of the drives that should be in it? So if I check
all the disks metadata I should be able to see the current state of the
devices with --examine and then do
mdadm --assemble /dev/md6 /dev/sda6 /dev/sdb6 etc...

Then clear the superblock on the drive I know should not be a part of
the array?

I guess the important bit is the events count?

The version of the array is 1.2

mdadm - v3.3.2 - 21st August 2014

Linux borgCube 3.16.0-4-amd64 #1 SMP Debian 3.16.7-ckt11-1+deb8u2
(2015-07-17) x86_64 GNU/Linux

=2E/lsdrv is: (for the drives in the array, the scsi 6:x:x:x is the
missing disk)

> PCI [ahci] 03:00.0 SATA controller: Marvell Technology Group Ltd. 88S=
E9230 PCIe SATA 6Gb/s Controller (rev 10)
> =E2=94=9Cscsi 6:x:x:x [Empty]
> =E2=94=9Cscsi 7:0:0:0 ATA      WDC WD30EFRX-68E {WD-WCC4N6XD5SV6}
> =E2=94=82=E2=94=94sdg 2.73t [8:96] Partitioned (gpt)
> =E2=94=82 =E2=94=94sdg6 2.64t [8:102] MD raid6 (0/6) (w/ sdh6,sdi6,sd=
k6,sdl6,sdm6) in_sync 'borgCube:R6Backup' {0e1215fc-1eab-5943-c28d-a7cb=
399353a3}
> =E2=94=82  =E2=94=94md6 10.54t [9:6] MD v1.2 raid6 (6) clean, 512k Ch=
unk {0e1215fc:1eab5943:c28da7cb:399353a3}
> =E2=94=82   =E2=94=82                ext4 'R6Backup' {142323a9-02d5-4=
fd5-b8a9-309a2cafde2a}
> =E2=94=82   =E2=94=94Mounted as /dev/md6 @ /mnt/md6R6Backup
> =E2=94=9Cscsi 8:0:0:0 ATA      WDC WD30EFRX-68E {WD-WCC4N7TS870E}
> =E2=94=82=E2=94=94sdh 2.73t [8:112] Partitioned (gpt)
> =E2=94=82 =E2=94=94sdh6 2.64t [8:118] MD raid6 (2/6) (w/ sdg6,sdi6,sd=
k6,sdl6,sdm6) in_sync 'borgCube:R6Backup' {0e1215fc-1eab-5943-c28d-a7cb=
399353a3}
> =E2=94=82  =E2=94=94md6 10.54t [9:6] MD v1.2 raid6 (6) clean, 512k Ch=
unk {0e1215fc:1eab5943:c28da7cb:399353a3}
> =E2=94=82                    ext4 'R6Backup' {142323a9-02d5-4fd5-b8a9=
-309a2cafde2a}
> =E2=94=9Cscsi 9:0:0:0 ATA      WDC WD30EFRX-68E {WD-WCC4N3UR60ZV}
> =E2=94=82=E2=94=94sdi 2.73t [8:128] Partitioned (gpt)
> =E2=94=82 =E2=94=94sdi6 2.64t [8:134] MD raid6 (3/6) (w/ sdg6,sdh6,sd=
k6,sdl6,sdm6) in_sync 'borgCube:R6Backup' {0e1215fc-1eab-5943-c28d-a7cb=
399353a3}
> =E2=94=82  =E2=94=94md6 10.54t [9:6] MD v1.2 raid6 (6) clean, 512k Ch=
unk {0e1215fc:1eab5943:c28da7cb:399353a3}
> =E2=94=82                    ext4 'R6Backup' {142323a9-02d5-4fd5-b8a9=
-309a2cafde2a}
> =E2=94=9Cscsi 10:x:x:x [Empty]
> =E2=94=9Cscsi 11:x:x:x [Empty]
> =E2=94=94scsi 12:x:x:x [Empty]
> PCI [ahci] 05:00.0 SATA controller: ASMedia Technology Inc. ASM1062 S=
erial ATA Controller (rev 01)
> =E2=94=9Cscsi 14:0:0:0 ATA      WDC WD30EFRX-68E {WD-WCC4N3YNA3SN}
> =E2=94=82=E2=94=94sdj 2.73t [8:144] Partitioned (gpt)
> =E2=94=82 =E2=94=94sdj5 2.64t [8:149] MD raid6 (4/5) (w/ sdc5,sdd5,sd=
e5,sdf5) in_sync 'BorgCUBE:51' {b1cdd470-a412-bff3-e62d-cac6cafd8762}
> =E2=94=82  =E2=94=94md51 7.90t [9:51] MD v1.2 raid6 (5) clean, 512k C=
hunk {b1cdd470:a412bff3:e62dcac6:cafd8762}
> =E2=94=82                     ext4 'md51mnt' {63c25cf7-d1aa-48e5-97d1=
-25c34819889c}
> =E2=94=94scsi 15:0:0:0 ATA      WDC WD30EFRX-68E {WD-WCC4N4LL7U4E}
>  =E2=94=94sdk 2.73t [8:160] Partitioned (gpt)
>   =E2=94=94sdk6 2.64t [8:166] MD raid6 (1/6) (w/ sdg6,sdh6,sdi6,sdl6,=
sdm6) in_sync 'borgCube:R6Backup' {0e1215fc-1eab-5943-c28d-a7cb399353a3=
}
>    =E2=94=94md6 10.54t [9:6] MD v1.2 raid6 (6) clean, 512k Chunk {0e1=
215fc:1eab5943:c28da7cb:399353a3}
>                      ext4 'R6Backup' {142323a9-02d5-4fd5-b8a9-309a2ca=
fde2a}
> PCI [ahci] 08:00.0 SATA controller: ASMedia Technology Inc. ASM1062 S=
erial ATA Controller (rev 01)
> =E2=94=9Cscsi 16:0:0:0 ATA      WDC WD30EFRX-68E {WD-WCC4N6XD5ZL3}
> =E2=94=82=E2=94=94sdl 2.73t [8:176] Partitioned (gpt)
> =E2=94=82 =E2=94=94sdl6 2.64t [8:182] MD raid6 (4/6) (w/ sdg6,sdh6,sd=
i6,sdk6,sdm6) in_sync 'borgCube:R6Backup' {0e1215fc-1eab-5943-c28d-a7cb=
399353a3}
> =E2=94=82  =E2=94=94md6 10.54t [9:6] MD v1.2 raid6 (6) clean, 512k Ch=
unk {0e1215fc:1eab5943:c28da7cb:399353a3}
> =E2=94=82                    ext4 'R6Backup' {142323a9-02d5-4fd5-b8a9=
-309a2cafde2a}
> =E2=94=94scsi 17:0:0:0 ATA      WDC WD30EFRX-68E {WD-WCC4N3UR625T}
>  =E2=94=94sdm 2.73t [8:192] Partitioned (gpt)
>   =E2=94=94sdm6 2.64t [8:198] MD raid6 (5/6) (w/ sdg6,sdh6,sdi6,sdk6,=
sdl6) in_sync 'borgCube:R6Backup' {0e1215fc-1eab-5943-c28d-a7cb399353a3=
}
>    =E2=94=94md6 10.54t [9:6] MD v1.2 raid6 (6) clean, 512k Chunk {0e1=
215fc:1eab5943:c28da7cb:399353a3}
>                      ext4 'R6Backup' {142323a9-02d5-4fd5-b8a9-309a2ca=
fde2a}


> ata7.00: ATA-7: MARVELL VIRTUALL, 1.09, max UDMA/66
> [    1.765384] ata7.00: 0 sectors, multi 0: LBA=20
> [    1.765749] ata14.00: failed to IDENTIFY (device reports invalid t=
ype, err_mask=3D0x0)
> [    1.766116] ata14.00: revalidation failed (errno=3D-22)
> [    1.766461] ata14: limiting SATA link speed to 1.5 Gbps
> [    1.766793] ata14.00: limiting speed to UDMA/66:PIO3
> [    1.785901] usb 1-12: new full-speed USB device number 4 using xhc=
i_hcd
> [    1.990155] usb 1-12: New USB device found, idVendor=3D0416, idPro=
duct=3De008
> [    1.990507] usb 1-12: New USB device strings: Mfr=3D1, Product=3D2=
, SerialNumber=3D3
> [    1.990843] usb 1-12: Product: OLED Display Controller
> [    1.991184] usb 1-12: Manufacturer: Nuvoton
> [    1.991526] usb 1-12: SerialNumber: B02013031501
> [    2.006243] input: Nuvoton OLED Display Controller as /devices/pci=
0000:00/0000:00:14.0/usb1/1-12/1-12:1.0/0003:0416:E008.0002/input/input=
2
> [    2.007001] hid-generic 0003:0416:E008.0002: input,hidraw1: USB HI=
D v1.10 Device [Nuvoton OLED Display Controller] on usb-0000:00:14.0-12=
/input0
> [    2.117789] usb 4-1: new high-speed USB device number 2 using ehci=
-pci
> [    2.250081] usb 4-1: New USB device found, idVendor=3D8087, idProd=
uct=3D8008
> [    2.250511] usb 4-1: New USB device strings: Mfr=3D0, Product=3D0,=
 SerialNumber=3D0
> [    2.251086] hub 4-1:1.0: USB hub found
> [    2.251580] hub 4-1:1.0: 6 ports detected
> [    2.361715] usb 6-1: new high-speed USB device number 2 using ehci=
-pci
> [    2.494011] usb 6-1: New USB device found, idVendor=3D8087, idProd=
uct=3D8000
> [    2.494446] usb 6-1: New USB device strings: Mfr=3D0, Product=3D0,=
 SerialNumber=3D0
> [    2.495038] hub 6-1:1.0: USB hub found
> [    2.495516] hub 6-1:1.0: 8 ports detected
> [    2.501791] Switched to clocksource tsc
> [    6.204677] ata8.00: ATA-9: WDC WD30EFRX-68EUZN0, 82.00A82, max UD=
MA/133
> [    6.205300] ata8.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth=
 31/32), AA
> [    6.205911] ata9.00: ATA-9: WDC WD30EFRX-68EUZN0, 82.00A82, max UD=
MA/133
> [    6.206526] ata9.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth=
 31/32), AA
> [    6.207245] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300=
)
> [    6.207966] ata7.00: model number mismatch 'MARVELL VIRTUALL' !=3D=
 'WDC WD30EFRX-68EUZN0'
> [    6.208615] ata7.00: revalidation failed (errno=3D-19)
> [    6.209256] ata7: limiting SATA link speed to 3.0 Gbps
> [    6.209896] ata7.00: limiting speed to UDMA/66:PIO3
> [    6.376797] ata8.00: configured for UDMA/133
> [    6.377453] ata9.00: configured for UDMA/133
> [    6.378094] ata10.00: ATA-9: WDC WD30EFRX-68EUZN0, 82.00A82, max U=
DMA/133
> [    6.378738] ata10.00: 5860533168 sectors, multi 0: LBA48 NCQ (dept=
h 31/32), AA
> [    6.380308] ata10.00: configured for UDMA/133
> [    6.696465] ata14: SATA link up 1.5 Gbps (SStatus 113 SControl 310=
)
> [    6.697195] ata14.00: configured for UDMA/66
> [    6.704462] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 320)
> [    6.705538] ata7.00: model number mismatch 'MARVELL VIRTUALL' !=3D=
 'WDC WD30EFRX-68EUZN0'
> [    6.706016] ata7.00: revalidation failed (errno=3D-19)
> [    6.706496] ata7.00: disabled

ata14 is spurious, even when all was working ok that error would show
up. (I think its the 4 port sata card)

ata7 is sdg

Annoyingly the ata numbers don't actually correspond to the scsi
numbers, because ata6 is actually port 6 of the intel on board chipset.

scsi14-17 are 4 additional on board ports, and 6-12 are the four port
card.

The card allows for 7 drives, 4 of which can be expanded on a single
port via a multiplier/external esata cable. (only 1 port at a time can
be expanded) and I think this is what is causing the problem.

Hopefully I wont have to boot the system for a couple of days so can
take in any replies before either a power cut or the new card arrives.

Thanks in advance.

Jon

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

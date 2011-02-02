From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Kernel 2.6.32-5-amd64 fails to boot.
Date: Wed, 2 Feb 2011 14:20:36 -0600
Message-ID: <3C.5E.05134.69CB94D4@cdptpa-omtalb.mail.rr.com>
References: <9A.25.13137.3DB684D4@cdptpa-omtalb.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9A.25.13137.3DB684D4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com, 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Leslie Rhorer
> Sent: Tuesday, February 01, 2011 2:24 PM
> To: 'Linux RAID'
> Subject: Kernel 2.6.32-5-amd64 fails to boot.
> 
> 	I have been attempting to upgrade a Debian "Squeeze" Linux box from
> 2.6.32-3-amd64 to 2.6.32-5-amd64, but the upgrade is a non-starter.  GRUB2
> comes up just fine, but when I select the new kernel version, a number of
> announcements flash by too fast to seen.  I am not 100% certain, but I
> believe the initrd starts to load OK. Some text flies by far too quickly
> to
> be seen, but then an error pops up concerning an address space collision
> of
> some PCI device. Then it shows three errors for RAID devices md1. md2, and
> md3, saying they are already in use. Immediately thereafter the system
> shows
> errors concerning  the RAID targets being already in use, after which
> point
> the system complains it can't mount / (md2), /dev, /sys, or /proc (in that
> order) because the sources do not exist (if /dev/md2 does not exist, how
> can
> it be busy?).

	OK, I've made some progress with the help of one of the guys on
usenet, at least in terms of getting to a point where I can do some
troubleshooting.  I went into the initrd configuration file and changed the
MODULES= line to "most", so that now the server recognizes the keyboard.

	For some reason, the system is not properly assembling the arrays,
or perhaps more accurately is not starting them.  Now the first thing that
pops out at me is the fact under the old kernel the array members were
/dev/hdaX and /dev/hdbX, but under the new kernel they are /dev/sdkX and
/dev/sdlX (sdl and sdm when the usb flash drive is inserted as detailed
below).  I don't see why that should cause any issues, however.  The arrays
all show to be there, but all four report to be inactive.  If I manually
stop and then re-assemble the drives, I can mount them, but otherwise, not.
Before stopping the arrays, the command `mdadm --assemble --scan` reports
the arrays in use, but after stopping any of them, the command works on any
stopped array, and I am then able to mount the array.

	In the initrd, the mdadm.conf file is simply:

DEVICE partitions
HOMEHOST <system>
ARRAY /dev/md0 level=raid6 num-devices=10 metadata=01.2 name=Backup:0
UUID=431244d6:45d9635a:e88b3de5:92f30255
ARRAY /dev/md1 level=raid1 num-devices=2 metadata=0.90
UUID=4cde286c:0687556a:4d9996dd:dd23e701
ARRAY /dev/md2 level=raid1 num-devices=2 metadata=01.2 name=Backup:2
UUID=d45ff663:9e53774c:6fcf9968:21692025
ARRAY /dev/md3 level=raid1 num-devices=2 metadata=01.2 name=Backup:3
UUID=51d22c47:10f58974:0b27ef04:5609d357

	...which should work.  Indeed, it is not a matter of mdadm not
finding the arrays.  It just does not seem to be starting them correctly.

	Here is the output of (most of) dmesg:

[    4.228353] ata4.04: hard resetting link
[    4.564319] ata4.04: SATA link down (SStatus 0 SControl 320)
[    4.564375] ata4.05: hard resetting link
[    4.900300] ata4.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
[    4.939162] ata4.00: ATA-8: WDC WD15EADS-00R6B0, 01.00A01, max UDMA/133
[    4.939164] ata4.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.943192] ata4.00: configured for UDMA/100
[    4.946435] ata4.01: ATA-8: WDC WD15EADS-00R6B0, 01.00A01, max UDMA/133
[    4.946438] ata4.01: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.950727] ata4.01: configured for UDMA/100
[    4.955783] ata4.02: ATA-8: WDC WD15EADS-00R6B0, 01.00A01, max UDMA/133
[    4.955785] ata4.02: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.961792] ata4.02: configured for UDMA/100
[    4.963501] ata4.03: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max UDMA/133
[    4.963503] ata4.03: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.965305] ata4.03: configured for UDMA/100
[    4.965365] ata4: EH complete
[    4.965449] scsi 3:0:0:0: Direct-Access     ATA      WDC WD15EADS-00R
01.0 PQ: 0 ANSI: 5
[    4.965585] scsi 3:1:0:0: Direct-Access     ATA      WDC WD15EADS-00R
01.0 PQ: 0 ANSI: 5
[    4.965707] scsi 3:2:0:0: Direct-Access     ATA      WDC WD15EADS-00R
01.0 PQ: 0 ANSI: 5
[    4.965832] scsi 3:3:0:0: Direct-Access     ATA      WDC WD15EADS-00P
01.0 PQ: 0 ANSI: 5
[    6.380157] usb-storage: device scan complete
[    6.380626] scsi 13:0:0:0: Direct-Access     SanDisk  SanDisk Cruzer
8.02 PQ: 0 ANSI: 0 CCS
[    6.380996] scsi 13:0:0:1: CD-ROM            SanDisk  SanDisk Cruzer
8.02 PQ: 0 ANSI: 0
[    7.076030] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    7.076258] ata5.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports,
feat 0x1/0x9
[    7.092219] ata5.00: hard resetting link
[    7.428322] ata5.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[    7.428352] ata5.01: hard resetting link
[    7.764293] ata5.01: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.764320] ata5.02: hard resetting link
[    8.100323] ata5.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    8.100353] ata5.03: hard resetting link
[    8.436319] ata5.03: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    8.436348] ata5.04: hard resetting link
[    8.772318] ata5.04: SATA link down (SStatus 0 SControl 320)
[    8.772374] ata5.05: hard resetting link
[    9.108293] ata5.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
[    9.110465] ata5.00: ATA-8: WDC WD15EARS-00Z5B1, 80.00A80, max UDMA/133
[    9.110468] ata5.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    9.113055] ata5.00: configured for UDMA/100
[    9.115434] ata5.01: ATA-8: WDC WD15EARS-00Z5B1, 80.00A80, max UDMA/133
[    9.115436] ata5.01: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    9.117420] ata5.01: configured for UDMA/100
[    9.119999] ata5.02: ATA-8: WDC WD15EARS-00Z5B1, 80.00A80, max UDMA/133
[    9.120001] ata5.02: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    9.121969] ata5.02: configured for UDMA/100
[    9.124597] ata5.03: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max UDMA/133
[    9.124600] ata5.03: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    9.127144] ata5.03: configured for UDMA/100
[    9.127204] ata5: EH complete
[    9.127291] scsi 4:0:0:0: Direct-Access     ATA      WDC WD15EARS-00Z
80.0 PQ: 0 ANSI: 5
[    9.127469] scsi 4:1:0:0: Direct-Access     ATA      WDC WD15EARS-00Z
80.0 PQ: 0 ANSI: 5
[    9.127593] scsi 4:2:0:0: Direct-Access     ATA      WDC WD15EARS-00Z
80.0 PQ: 0 ANSI: 5
[    9.127705] scsi 4:3:0:0: Direct-Access     ATA      WDC WD15EADS-00P
01.0 PQ: 0 ANSI: 5
[   11.252029] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   11.252255] ata6.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports,
feat 0x1/0x9
[   11.268197] ata6.00: hard resetting link
[   11.604322] ata6.00: SATA link up 3.0 Gbps (SStatus 123 SControl 320)
[   11.604353] ata6.01: hard resetting link
[   11.940321] ata6.01: SATA link down (SStatus 0 SControl 320)
[   11.940378] ata6.02: hard resetting link
[   12.276293] ata6.02: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   12.276320] ata6.03: hard resetting link
[   12.612321] ata6.03: SATA link down (SStatus 0 SControl 320)
[   12.612377] ata6.04: hard resetting link
[   12.948321] ata6.04: SATA link down (SStatus 0 SControl 320)
[   12.948378] ata6.05: hard resetting link
[   13.284318] ata6.05: SATA link up 1.5 Gbps (SStatus 113 SControl 320)
[   13.287633] ata6.00: ATA-8: WDC WD15EADS-00P8B0, 01.00A01, max UDMA/133
[   13.287635] ata6.00: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   13.290246] ata6.00: configured for UDMA/100
[   13.292122] ata6.02: ATA-8: WDC WD15EARS-00Z5B1, 80.00A80, max UDMA/133
[   13.292124] ata6.02: 2930277168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   13.294114] ata6.02: configured for UDMA/100
[   13.294174] ata6: EH complete
[   13.294229] scsi 5:0:0:0: Direct-Access     ATA      WDC WD15EADS-00P
01.0 PQ: 0 ANSI: 5
[   13.294344] scsi 5:2:0:0: Direct-Access     ATA      WDC WD15EARS-00Z
80.0 PQ: 0 ANSI: 5
[   23.324019] ata7: softreset failed (timeout)
[   33.340017] ata7: softreset failed (timeout)
[   68.364019] ata7: softreset failed (timeout)
[   68.364053] ata7: limiting SATA link speed to 1.5 Gbps
[   73.388016] ata7: softreset failed (timeout)
[   73.388049] ata7: reset failed, giving up
[   73.388183] scsi 11:0:0:0: Direct-Access     ATA      ST3500641A
3.AA PQ: 0 ANSI: 5
[   73.388293] scsi 11:0:1:0: Direct-Access     ATA      ST3500641A
3.AA PQ: 0 ANSI: 5
[   73.562936] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[   73.563158] r8169 0000:05:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ
18
[   73.563213] r8169 0000:05:00.0: setting latency timer to 64
[   73.563248]   alloc irq_desc for 28 on node 0
[   73.563250]   alloc kstat_irqs on node 0
[   73.563269] r8169 0000:05:00.0: irq 28 for MSI/MSI-X
[   73.567928] eth0: RTL8168c/8111c at 0xffffc90010ad0000,
00:22:15:59:63:1f, XID 1c4000c0 IRQ 28
[   73.581890] firewire_ohci 0000:04:00.0: PCI INT A -> GSI 17 (level, low)
-> IRQ 17
[   73.581898] firewire_ohci 0000:04:00.0: setting latency timer to 64
[   73.595412] sd 3:0:0:0: [sda] 2930277168 512-byte logical blocks: (1.50
TB/1.36 TiB)
[   73.595470] sd 3:0:0:0: [sda] Write Protect is off
[   73.595473] sd 3:0:0:0: [sda] Mode Sense: 00 3a 00 00
[   73.595483] sd 3:1:0:0: [sdb] 2930277168 512-byte logical blocks: (1.50
TB/1.36 TiB)
[   73.595495] sd 3:0:0:0: [sda] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   73.595533] sd 3:1:0:0: [sdb] Write Protect is off
[   73.595536] sd 3:1:0:0: [sdb] Mode Sense: 00 3a 00 00
[   73.595555] sd 3:1:0:0: [sdb] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   73.595651]  sda:
[   73.595737]  sdb:
[   73.595880] sd 3:2:0:0: [sdc] 2930277168 512-byte logical blocks: (1.50
TB/1.36 TiB)
[   73.595923] sd 3:2:0:0: [sdc] Write Protect is off
[   73.595925] sd 3:2:0:0: [sdc] Mode Sense: 00 3a 00 00
[   73.595943] sd 3:2:0:0: [sdc] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   73.596044]  sdc:
[   73.596784] sd 3:3:0:0: [sdd] 2930277168 512-byte logical blocks: (1.50
TB/1.36 TiB)
[   73.596853] sd 3:3:0:0: [sdd] Write Protect is off
[   73.596855] sd 3:3:0:0: [sdd] Mode Sense: 00 3a 00 00
[   73.596875] sd 3:3:0:0: [sdd] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   73.597002]  sdd:
[   73.597851] sd 13:0:0:0: [sde] 7856127 512-byte logical blocks: (4.02
GB/3.74 GiB)
[   73.598390] sd 13:0:0:0: [sde] Write Protect is off
[   73.598393] sd 13:0:0:0: [sde] Mode Sense: 45 00 00 08
[   73.598395] sd 13:0:0:0: [sde] Assuming drive cache: write through
[   73.598590] sd 4:0:0:0: [sdf] 2930277168 512-byte logical blocks: (1.50
TB/1.36 TiB)
[   73.598630] sd 4:0:0:0: [sdf] Write Protect is off
[   73.598633] sd 4:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[   73.598714] sd 4:0:0:0: [sdf] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   73.598832]  sdf:
[   73.598906] sd 4:1:0:0: [sdg] 2930277168 512-byte logical blocks: (1.50
TB/1.36 TiB)
[   73.598944] sd 4:1:0:0: [sdg] Write Protect is off
[   73.598946] sd 4:1:0:0: [sdg] Mode Sense: 00 3a 00 00
[   73.598962] sd 4:1:0:0: [sdg] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   73.599062]  sdg:
[   73.599116] sd 4:2:0:0: [sdh] 2930277168 512-byte logical blocks: (1.50
TB/1.36 TiB)
[   73.599169] sd 4:2:0:0: [sdh] Write Protect is off
[   73.599171] sd 4:2:0:0: [sdh] Mode Sense: 00 3a 00 00
[   73.599187] sd 4:2:0:0: [sdh] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   73.599286]  sdh:
[   73.599333] sd 4:3:0:0: [sdi] 2930277168 512-byte logical blocks: (1.50
TB/1.36 TiB)
[   73.599370] sd 4:3:0:0: [sdi] Write Protect is off
[   73.599372] sd 4:3:0:0: [sdi] Mode Sense: 00 3a 00 00
[   73.599394] sd 4:3:0:0: [sdi] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   73.599485]  sdi:
[   73.599548] sd 5:0:0:0: [sdj] 2930277168 512-byte logical blocks: (1.50
TB/1.36 TiB)
[   73.599588] sd 5:0:0:0: [sdj] Write Protect is off
[   73.599590] sd 5:0:0:0: [sdj] Mode Sense: 00 3a 00 00
[   73.599607] sd 5:0:0:0: [sdj] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   73.599708]  sdj:
[   73.599751] sd 5:2:0:0: [sdk] 2930277168 512-byte logical blocks: (1.50
TB/1.36 TiB)
[   73.599795] sd 5:2:0:0: [sdk] Write Protect is off
[   73.599797] sd 5:2:0:0: [sdk] Mode Sense: 00 3a 00 00
[   73.599814] sd 5:2:0:0: [sdk] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   73.599918]  sdk:
[   73.599988] sd 11:0:1:0: [sdm] 976773168 512-byte logical blocks: (500
GB/465 GiB)
[   73.600045] sd 11:0:0:0: [sdl] 976773168 512-byte logical blocks: (500
GB/465 GiB)
[   73.600086] sd 11:0:0:0: [sdl] Write Protect is off
[   73.600088] sd 11:0:0:0: [sdl] Mode Sense: 00 3a 00 00
[   73.600107] sd 11:0:0:0: [sdl] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   73.600165] sd 11:0:1:0: [sdm] Write Protect is off
[   73.600167] sd 11:0:1:0: [sdm] Mode Sense: 00 3a 00 00
[   73.600193] sd 11:0:1:0: [sdm] Write cache: enabled, read cache: enabled,
doesn't support DPO or FUA
[   73.600265] sd 13:0:0:0: [sde] Assuming drive cache: write through
[   73.600300]  sde:
[   73.600373]  sdl:sr0: scsi3-mmc drive: 48x/48x cd/rw xa/form2 cdda tray
[   73.600604] Uniform CD-ROM driver Revision: 3.20
[   73.600699] sr 2:0:1:0: Attached scsi CD-ROM sr0
[   73.603799]  sde1
[   73.603973] usbcore: registered new interface driver hiddev
[   73.608745] sr 2:0:1:0: Attached scsi generic sg0 type 5
[   73.608779] sd 3:0:0:0: Attached scsi generic sg1 type 0
[   73.608808] sd 3:1:0:0: Attached scsi generic sg2 type 0
[   73.608846] sd 3:2:0:0: Attached scsi generic sg3 type 0
[   73.608884] sr1: scsi3-mmc drive: 48x/48x tray
[   73.608994] sd 3:3:0:0: Attached scsi generic sg4 type 0
[   73.609060] sd 13:0:0:0: Attached scsi generic sg5 type 0
[   73.609192] sr 13:0:0:1: Attached scsi CD-ROM sr1
[   73.609410] sr 13:0:0:1: Attached scsi generic sg6 type 5
[   73.609479] sd 4:0:0:0: Attached scsi generic sg7 type 0
[   73.609542] sd 13:0:0:0: [sde] Assuming drive cache: write through
[   73.609548] sd 4:1:0:0: Attached scsi generic sg8 type 0
[   73.609580] sd 13:0:0:0: [sde] Attached SCSI removable disk
[   73.609651] sd 4:2:0:0: Attached scsi generic sg9 type 0
[   73.609718] sd 4:3:0:0: Attached scsi generic sg10 type 0
[   73.609776] sd 5:0:0:0: Attached scsi generic sg11 type 0
[   73.609833] sd 5:2:0:0: Attached scsi generic sg12 type 0
[   73.609897] sd 11:0:0:0: Attached scsi generic sg13 type 0
[   73.609956] sd 11:0:1:0: Attached scsi generic sg14 type 0
[   73.614471]  sdl1 sdl2 sdl3
[   73.635748]  sdm: sdm1 sdm2 sdm3
[   73.660020] firewire_ohci: Added fw-ohci device 0000:04:00.0, OHCI
version 1.10
[   73.672552] sd 11:0:0:0: [sdl] Attached SCSI disk
[   73.672739] sd 11:0:1:0: [sdm] Attached SCSI disk
[   73.996376]  unknown partition table
[   73.996582] sd 3:1:0:0: [sdb] Attached SCSI disk
[   74.058234]
[   74.058579] sd 5:2:0:0: [sdk] Attached SCSI disk
[   74.064289]
[   74.064451] sd 4:2:0:0: [sdh] Attached SCSI disk
[   74.073319]  unknown partition table
[   74.074050] sd 3:3:0:0: [sdd] Attached SCSI disk
[   74.074309]
[   74.074760] sd 4:0:0:0: [sdf] Attached SCSI disk
[   74.076343]
[   74.081240]
[   74.082740] sd 5:0:0:0: [sdj] Attached SCSI disk
[   74.088837] sd 4:1:0:0: [sdg] Attached SCSI disk
[   74.088979]  unknown partition table
[   74.089986] sd 4:3:0:0: [sdi] Attached SCSI disk
[   74.093092] md: bind<sdm1>
[   74.101862] md: bind<sdl2>
[   74.115438] md: bind<sdm3>
[   74.141257]  unknown partition table
[   74.141381]  unknown partition table
[   74.142712] sd 3:2:0:0: [sdc] Attached SCSI disk
[   74.142756] sd 3:0:0:0: [sda] Attached SCSI disk
[   74.143154] md: array md3 already has disks!
[   74.160601] firewire_core: created device fw0: GUID 001e8c000162dcce,
S400
[   74.161513] md: bind<sdi>
[   74.665772] generic-usb 0003:051D:0002.0001: hiddev0,hidraw0: USB HID
v1.10 Device [American Power Conversion Back-UPS RS 1000 FW:7.g7 .D USB
FW:g7 ] on usb-0000:00:12.1-3/input0
[   74.671912] input: Key Tronic Keytronic USB Keyboard as
/devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1.1/4-1.1:1.0/input/input1
[   74.671961] generic-usb 0003:03F9:0100.0002: input,hidraw1: USB HID v1.10
Keyboard [Key Tronic Keytronic USB Keyboard] on usb-0000:00:12.1-1.1/input0
[   74.676854] input: USB OpticalWheel Mouse as
/devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1.2/4-1.2:1.0/input/input2
[   74.676910] generic-usb 0003:04FC:0015.0003: input,hidraw2: USB HID v1.10
Mouse [USB OpticalWheel Mouse] on usb-0000:00:12.1-1.2/input0
[   74.681828] input: Justcom Technology USB KVM Switch as
/devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1.3/4-1.3:1.0/input/input3
[   74.681865] generic-usb 0003:06F2:0011.0004: input,hidraw3: USB HID v1.10
Keyboard [Justcom Technology USB KVM Switch] on usb-0000:00:12.1-1.3/input0
[   74.686841] input: Justcom Technology USB KVM Switch as
/devices/pci0000:00/0000:00:12.1/usb4/4-1/4-1.3/4-1.3:1.1/input/input4
[   74.686919] generic-usb 0003:06F2:0011.0005: input,hidraw4: USB HID v1.10
Mouse [Justcom Technology USB KVM Switch] on usb-0000:00:12.1-1.3/input1
[   74.686947] usbcore: registered new interface driver usbhid
[   74.686949] usbhid: v2.6:USB HID core driver
[   74.777699] md: raid1 personality registered for level 1
[   74.786167] async_tx: api initialized (async)
[   74.786639] xor: automatically using best checksumming function:
generic_sse
[   74.804011]    generic_sse:  8104.000 MB/sec
[   74.804013] xor: using function: generic_sse (8104.000 MB/sec)
[   74.872020] raid6: int64x1   2458 MB/s
[   74.940025] raid6: int64x2   3204 MB/s
[   75.008031] raid6: int64x4   2491 MB/s
[   75.076033] raid6: int64x8   2256 MB/s
[   75.144018] raid6: sse2x1    1299 MB/s
[   75.212039] raid6: sse2x2    2044 MB/s
[   75.280023] raid6: sse2x4    2774 MB/s
[   75.280024] raid6: using algorithm sse2x4 (2774 MB/s)
[   75.284431] md: raid6 personality registered for level 6
[   75.284434] md: raid5 personality registered for level 5
[   75.284436] md: raid4 personality registered for level 4
[   75.320682] device-mapper: uevent: version 1.0.3
[   75.320837] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised:
dm-devel@redhat.com


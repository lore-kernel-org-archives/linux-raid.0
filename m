From: "Chris Mason" <lists@masonc.com>
Subject: Raid is up but won't mount
Date: Sat, 29 Jan 2005 17:22:28 -0400
Message-ID: <000501c50648$a3a3cc40$0600a8c0@poseiden>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1250
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I decided to move my image server to a rack mount case today. It is
configured with four 160 GB IDE drives as a raid 5 array. Only the encl=
osure
was changing, everything moved across, so it should have worked without
incident.

I shut the server down after first checking the raid system was synced.=
=20
I moved the 4 RAID components to a new case after the motherboard and t=
he
PSU were installed and the boot drive was working. The system booted fi=
ne,
the array reassembled, but then I got an error as the array was mounted=
=2E I
can't figure out what went wrong and what to do about it. Any assistanc=
e
appreciated, I don=92t know what to do next.

OS: Centos 3.3
CPU: Celeron 1700MHz
RAID5: 2 x Promise ATA100 interfaces, 4 x 160GB WD1600 drives as
hde1,hdg1,hdi1,hdk1

It seesm to be a ext2 problem:

EXT3 FS 2.4-0.9.19, 19 August 2002 on ide0(3,2), internal journal
Adding Swap: 457844k swap-space (priority -1)
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on ide0(3,1), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
raid5: switching cache buffer size, 1024 --> 4096
EXT2-fs error (device md(9,0)): ext2_check_descriptors: Block bitmap fo=
r
group 1920 not in group (block 0)!
EXT2-fs: group descriptors corrupted!






Dmesg | less
ide: Assuming 33MHz system bus speed for PIO modes; override with idebu=
s=3Dxx
SIS5513: IDE controller at PCI slot 00:02.5
SIS5513: chipset revision 0
SIS5513: not 100% native mode: will probe irqs later
SiS651    ATA 133 controller
    ide0: BM-DMA at 0xa400-0xa407, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xa408-0xa40f, BIOS settings: hdc:pio, hdd:pio
PDC20268: IDE controller at PCI slot 00:0e.0
PDC20268: chipset revision 2
PDC20268: not 100% native mode: will probe irqs later
    ide2: BM-DMA at 0x7000-0x7007, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0x7008-0x700f, BIOS settings: hdg:pio, hdh:pio
PDC20268: IDE controller at PCI slot 00:0f.0
PDC20268: chipset revision 2
PDC20268: not 100% native mode: will probe irqs later
    ide4: BM-DMA at 0x5400-0x5407, BIOS settings: hdi:pio, hdj:pio
    ide5: BM-DMA at 0x5408-0x540f, BIOS settings: hdk:pio, hdl:pio
hda: Maxtor 2F040L0, ATA DISK drive
blk: queue c03cdfe0, I/O limit 4095Mb (mask 0xffffffff)
hde: WDC WD1600JB-00EVA0, ATA DISK drive
blk: queue c03ce8a8, I/O limit 4095Mb (mask 0xffffffff)
hdg: WDC WD1600LB-00EDA0, ATA DISK drive
blk: queue c03ced0c, I/O limit 4095Mb (mask 0xffffffff)
hdi: WDC WD1600BB-00HTA0, ATA DISK drive
blk: queue c03cf170, I/O limit 4095Mb (mask 0xffffffff)
hdk: WDC WD1600JB-00EVA0, ATA DISK drive
blk: queue c03cf5d4, I/O limit 4095Mb (mask 0xffffffff)
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide2 at 0x8400-0x8407,0x8002 on irq 10
ide3 at 0x7800-0x7807,0x7402 on irq 10
ide4 at 0x6800-0x6807,0x6402 on irq 12
ide5 at 0x6000-0x6007,0x5802 on irq 12
hda: attached ide-disk driver.
hda: host protected area =3D> 1
hda: 80293248 sectors (41110 MB) w/2048KiB Cache, CHS=3D4998/255/63, UD=
MA(133)
hde: attached ide-disk driver.
hde: host protected area =3D> 1
hde: 312581808 sectors (160042 MB) w/8192KiB Cache, CHS=3D19457/255/63,
UDMA(100)
hdg: attached ide-disk driver.
hdg: host protected area =3D> 1
hdg: 312581808 sectors (160042 MB) w/2048KiB Cache, CHS=3D19457/255/63,
UDMA(100)
hdi: attached ide-disk driver.
hdi: host protected area =3D> 1
hdi: 312581808 sectors (160042 MB) w/2048KiB Cache, CHS=3D19457/255/63,
UDMA(100)
hdk: attached ide-disk driver.
hdk: host protected area =3D> 1
hdk: 312581808 sectors (160042 MB) w/8192KiB Cache, CHS=3D19457/255/63,
UDMA(100)
ide-floppy driver 0.99.newide
Partition check:
 hda: hda1 hda2 hda3
 hde: hde1
 hdg: hdg1
 hdi: hdi1
 hdk: hdk1
ide-floppy driver 0.99.newide
md: md driver 0.90.0 MAX_MD_DEVS=3D256, MD_SB_DISKS=3D27
md: Autodetecting RAID arrays.
 [events: 0000005a]
 [events: 0000005a]
 [events: 0000005a]
 [events: 0000005a]
md: autorun ...
md: considering hdk1 ...
md:  adding hdk1 ...
md:  adding hdi1 ...
md:  adding hdg1 ...
md:  adding hde1 ...
md: created md0
md: bind<hde1,1>
md: bind<hdg1,2>
md: bind<hdi1,3>
md: bind<hdk1,4>
md: running: <hdk1><hdi1><hdg1><hde1>
md: hdk1's event counter: 0000005a
md: hdi1's event counter: 0000005a
md: hdg1's event counter: 0000005a
md: hde1's event counter: 0000005a
kmod: failed to exec /sbin/modprobe -s -k md-personality-4, errno =3D 2
md: personality 4 is not loaded!
md :do_md_run() returned -22
md: md0 stopped.
md: unbind<hdk1,3>
md: export_rdev(hdk1)
md: unbind<hdi1,2>
md: export_rdev(hdi1)
md: unbind<hdg1,1>
md: export_rdev(hdg1)
md: unbind<hde1,0>
md: export_rdev(hde1)
md: ... autorun DONE.
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 4096 buckets, 32Kbytes
TCP: Hash tables configured (established 32768 bind 65536)
Linux IP multicast router 0.06 plus PIM-SM
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
RAMDISK: Compressed image found at block 0
=46reeing initrd memory: 285k freed
VFS: Mounted root (ext2 filesystem).
SCSI subsystem driver Revision: 1.00
scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.8
        <Adaptec 2940 Ultra2 SCSI adapter>
        aic7890/91: Ultra2 Wide Channel A, SCSI Id=3D7, 32/253 SCBs

blk: queue c22a3e14, I/O limit 4095Mb (mask 0xffffffff)
raid5: measuring checksumming speed
   8regs     :  2026.800 MB/sec
   32regs    :  1183.200 MB/sec
   8regs_prefetch:  2021.600 MB/sec
   32regs_prefetch:  1180.800 MB/sec
   pII_mmx   :  2025.200 MB/sec
   p5_mmx    :  2030.000 MB/sec
raid5: using function: p5_mmx (2030.000 MB/sec)
md: raid5 personality registered as nr 4
Journalled Block Device driver loaded
md: Autodetecting RAID arrays.
 [events: 0000005a]
 [events: 0000005a]
 [events: 0000005a]
 [events: 0000005a]
md: autorun ...
md: considering hde1 ...
md:  adding hde1 ...
md:  adding hdg1 ...
md:  adding hdi1 ...
md:  adding hdk1 ...
md: created md0
md: bind<hdk1,1>
md: bind<hdi1,2>
md: bind<hdg1,3>
md: bind<hde1,4>
md: running: <hde1><hdg1><hdi1><hdk1>
md: hde1's event counter: 0000005a
md: hdg1's event counter: 0000005a
md: hdi1's event counter: 0000005a
md: hdk1's event counter: 0000005a
md0: max total readahead window set to 768k
md0: 3 data-disks, max readahead per data-disk: 256k
raid5: device hde1 operational as raid disk 0
raid5: device hdg1 operational as raid disk 1
raid5: device hdi1 operational as raid disk 2
raid5: device hdk1 operational as raid disk 3
raid5: allocated 4342kB for md0
raid5: raid level 5 set md0 active with 4 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:4 fd:0
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hde1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdg1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hdi1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdk1
RAID5 conf printout:
 --- rd:4 wd:4 fd:0
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:hde1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdg1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:hdi1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdk1
md: updating md0 RAID superblock on device
md: hde1 [events: 0000005b]<6>(write) hde1's sb offset: 156288256
md: hdg1 [events: 0000005b]<6>(write) hdg1's sb offset: 156288256
md: hdi1 [events: 0000005b]<6>(write) hdi1's sb offset: 156288256
md: hdk1 [events: 0000005b]<6>(write) hdk1's sb offset: 156288256
md: ... autorun DONE.
raid5: switching cache buffer size, 4096 --> 1024
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
=46reeing unused kernel memory: 132k freed
usb.c: registered new driver usbdevfs
usb.c: registered new driver hub
usb-ohci.c: USB OHCI at membase 0xde89b000, IRQ 5
usb-ohci.c: usb-00:03.0, Silicon Integrated Systems [SiS] 7001
usb.c: new USB bus registered, assigned bus number 1
hub.c: USB hub found
hub.c: 3 ports detected
usb-ohci.c: USB OHCI at membase 0xde89d000, IRQ 9
usb-ohci.c: usb-00:03.1, Silicon Integrated Systems [SiS] 7001 (#2)
usb.c: new USB bus registered, assigned bus number 2
hub.c: USB hub found
hub.c: 3 ports detected
ehci-hcd 00:03.3: PCI device 1039:7002 (Silicon Integrated Systems [SiS=
])
ehci-hcd 00:03.3: irq 9, pci mem de8a5000
usb.c: new USB bus registered, assigned bus number 3
PCI: 00:03.3 PCI cache line size set incorrectly (32 bytes) by BIOS/FW.
PCI: 00:03.3 PCI cache line size corrected to 128.
ehci-hcd 00:03.3: USB 2.0 enabled, EHCI 1.00, driver 2003-Jan-22
hub.c: USB hub found
hub.c: 6 ports detected
usb.c: registered new driver hiddev
usb.c: registered new driver hid
hid-core.c: v1.8.1 Andreas Gal, Vojtech Pavlik <vojtech@suse.cz>
hid-core.c: USB HID support drivers
mice: PS/2 mouse device common for all mice
EXT3 FS 2.4-0.9.19, 19 August 2002 on ide0(3,2), internal journal
Adding Swap: 457844k swap-space (priority -1)
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on ide0(3,1), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
raid5: switching cache buffer size, 1024 --> 4096
EXT2-fs error (device md(9,0)): ext2_check_descriptors: Block bitmap fo=
r
group 1920 not in group (block 0)!
EXT2-fs: group descriptors corrupted!
scsi1 : SCSI host adapter emulation for IDE ATAPI devices
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
parport0: irq 7 detected
ip_tables: (C) 2000-2002 Netfilter core team
sis900.c: v1.08.06 9/24/2002
divert: allocating divert_blk for eth0
eth0: Realtek RTL8201 PHY transceiver found at address 1.
eth0: Using transceiver found at address 1 as default
eth0: SiS 900 PCI Fast Ethernet at 0x8800, IRQ 3, 00:0c:6e:0d:04:28.
ip_tables: (C) 2000-2002 Netfilter core team
eth0: Media Link On 100mbps full-duplex=20
raid5: switching cache buffer size, 4096 --> 1024
raid5: switching cache buffer size, 1024 --> 4096
EXT2-fs error (device md(9,0)): ext2_check_descriptors: Block bitmap fo=
r
group 1920 not in group (block 0)!
EXT2-fs: group descriptors corrupted!
ip_tables: (C) 2000-2002 Netfilter core team
parport0: PC-style at 0x378 (0x778) [PCSPP,TRISTATE]
parport0: irq 7 detected
lp0: using parport0 (polling).
lp0: console ready





Chris Mason
Skype ID: netconcepts

--=20
No virus found in this outgoing message.
Checked by AVG Anti-Virus.
Version: 7.0.300 / Virus Database: 265.8.2 - Release Date: 1/28/2005
=20

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

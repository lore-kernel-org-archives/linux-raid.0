From: Daniel Brahneborg <daniel.com@wtnord.net>
Subject: BUG: Data corruption on Raid5 in Linux 2.6.0
Date: Sun, 28 Dec 2003 00:00:08 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031228000008.B2433@nettis.grimsta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: mingo@redhat.com, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a Raid5 system of four 160GB SATA disks. The drives
themselves work fine, but when large files (a few hundred
megs) are written to the raid disks they get corrupted after
a random amount of data.  The kernel is Linus 2.6.0.

Any hints you can give me to get this working is highly
appreciated.

The output from dmesg is appended.

/Basic

Linux version 2.6.0-2 (root@fw.grimsta) (gcc version 3.2 20020903 (Red Hat Linux 8.0 3.2-7)) #9 Sat Dec 27 11:45:29 CET 2003
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
 BIOS-e820: 000000000009d800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000001fef0000 (usable)
 BIOS-e820: 000000001fef0000 - 000000001fef3000 (ACPI NVS)
 BIOS-e820: 000000001fef3000 - 000000001ff00000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
510MB LOWMEM available.
On node 0 totalpages: 130800
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 126704 pages, LIFO batch:16
  HighMem zone: 0 pages, LIFO batch:1
DMI 2.2 present.
Building zonelist for node : 0
Kernel command line: ro root=/dev/hda3 ide0=0x1f0,0x3f6,14 ide1=0x170,0x376,15 ide2=0xb800,0xbc02,11 ide3=0xc000,0xc402,11
ide_setup: ide0=0x1f0,0x3f6,14

ide_setup: ide1=0x170,0x376,15

ide_setup: ide2=0xb800,0xbc02,11

ide_setup: ide3=0xc000,0xc402,11

Initializing CPU#0
PID hash table entries: 2048 (order 11: 16384 bytes)
Detected 819.607 MHz processor.
Console: colour VGA+ 80x25
Memory: 514316k/523200k available (1991k kernel code, 8116k reserved, 674k data, 112k init, 0k highmem)
Calibrating delay loop... 1613.82 BogoMIPS
Dentry cache hash table entries: 65536 (order: 6, 262144 bytes)
Inode-cache hash table entries: 32768 (order: 5, 131072 bytes)
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU:     After generic identify, caps: 0183fbff c1c7fbff 00000000 00000000
CPU:     After vendor identify, caps: 0183fbff c1c7fbff 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 64K (64 bytes/line)
CPU:     After all inits, caps: 0183fbff c1c7fbff 00000000 00000020
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: AMD Duron(tm) processor stepping 01
Enabling fast FPU save and restore... done.
Checking 'hlt' instruction... OK.
POSIX conformance testing by UNIFIX
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfaf40, last bus=1
PCI: Using configuration type 1
Linux Plug and Play Support v0.97 (c) Adam Belay
PnPBIOS: Scanning system for PnP BIOS support...
PnPBIOS: Found PnP BIOS installation structure at 0xc00fb990
PnPBIOS: PnP BIOS version 1.0, entry 0xf0000:0xb9c0, dseg 0xf0000
pnp: 00:0b: ioport range 0x3f0-0x3f1 has been reserved
PnPBIOS: 11 nodes reported by PnP BIOS; 11 recorded by driver
PCI: Probing PCI hardware
PCI: Probing PCI hardware (bus 00)
PCI: Using IRQ router VIA [1106/3227] at 0000:00:11.0
SGI XFS for Linux with ACLs, no debug enabled
pty: 256 Unix98 ptys configured
Real Time Clock Driver v1.12
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SiI3112 Serial ATA: IDE controller at PCI slot 0000:00:0b.0
PCI: Found IRQ 10 for device 0000:00:0b.0
SiI3112 Serial ATA: chipset revision 2
SiI3112 Serial ATA: 100% native mode on irq 10
    ide4: MMIO-DMA at 0xe0800000-0xe0800007, BIOS settings: hdi:pio, hdj:pio
    ide5: MMIO-DMA at 0xe0800008-0xe080000f, BIOS settings: hdk:pio, hdl:pio
hdi: SAMSUNG SP1614C, ATA DISK drive
Using anticipatory io scheduler
ide4 at 0xe0800080-0xe0800087,0xe080008a on irq 10
hdk: SAMSUNG SP1614C, ATA DISK drive
ide5 at 0xe08000c0-0xe08000c7,0xe08000ca on irq 10
VIA8237SATA: IDE controller at PCI slot 0000:00:0f.0
VIA8237SATA: chipset revision 128
VIA8237SATA: 100% native mode on irq 11
    ide2: BM-DMA at 0xc800-0xc807, BIOS settings: hde:pio, hdf:pio
    ide3: BM-DMA at 0xc808-0xc80f, BIOS settings: hdg:pio, hdh:pio
hde: SAMSUNG SP1614C, ATA DISK drive
ide2 at 0xb800-0xb807,0xbc02 on irq 11
hdg: SAMSUNG SP1614C, ATA DISK drive
ide3 at 0xc000-0xc007,0xc402 on irq 11
VP_IDE: IDE controller at PCI slot 0000:00:0f.1
VP_IDE: chipset revision 6
VP_IDE: not 100% native mode: will probe irqs later
VP_IDE: VIA vt8237 (rev 00) IDE UDMA133 controller on pci0000:00:0f.1
    ide0: BM-DMA at 0xd000-0xd007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xd008-0xd00f, BIOS settings: hdc:pio, hdd:DMA
hda: FUJITSU MHM2060AT, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
hdd: MATSHITA CD-RW CW-7586, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hdi: max request size: 7KiB
hdi: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
 hdi: hdi1 hdi2
hdk: max request size: 7KiB
hdk: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
 hdk: hdk1 hdk2
hde: max request size: 1024KiB
hde: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
 hde: hde1 hde2
hdg: max request size: 1024KiB
hdg: 312581808 sectors (160041 MB) w/8192KiB Cache, CHS=19457/255/63
 hdg: hdg1 hdg2
hda: max request size: 128KiB
hda: 11733120 sectors (6007 MB) w/2048KiB Cache, CHS=12416/15/63
 hda: hda1 hda2 hda3
hdd: ATAPI 32X CD-ROM CD-R/RW drive, 2048kB Cache
Uniform CD-ROM driver Revision: 3.12
mice: PS/2 mouse device common for all mice
irq 12: nobody cared!
Call Trace:
 [<c010adda>] __report_bad_irq+0x2a/0x90
 [<c010aed0>] note_interrupt+0x70/0xa0
 [<c010b17b>] do_IRQ+0x12b/0x140
 [<c01094c8>] common_interrupt+0x18/0x20
 [<c011bc40>] do_softirq+0x40/0xa0
 [<c010b157>] do_IRQ+0x107/0x140
 [<c01094c8>] common_interrupt+0x18/0x20
 [<c010b6ec>] setup_irq+0x9c/0xf0
 [<c02867c0>] i8042_interrupt+0x0/0x170
 [<c010b235>] request_irq+0xa5/0xe0
 [<c03ae5bd>] i8042_check_mux+0x3d/0x170
 [<c02867c0>] i8042_interrupt+0x0/0x170
 [<c03aeb25>] i8042_init+0x115/0x170
 [<c039e6ec>] do_initcalls+0x2c/0xa0
 [<c0127e6f>] init_workqueues+0xf/0x60
 [<c01050cd>] init+0x2d/0x160
 [<c01050a0>] init+0x0/0x160
 [<c0107189>] kernel_thread_helper+0x5/0xc

handlers:
[<c02867c0>] (i8042_interrupt+0x0/0x170)
Disabling IRQ #12
irq 12: nobody cared!
Call Trace:
 [<c010adda>] __report_bad_irq+0x2a/0x90
 [<c010aed0>] note_interrupt+0x70/0xa0
 [<c010b17b>] do_IRQ+0x12b/0x140
 [<c01094c8>] common_interrupt+0x18/0x20
 [<c011bc40>] do_softirq+0x40/0xa0
 [<c010b157>] do_IRQ+0x107/0x140
 [<c01094c8>] common_interrupt+0x18/0x20
 [<c010b6ec>] setup_irq+0x9c/0xf0
 [<c02867c0>] i8042_interrupt+0x0/0x170
 [<c010b235>] request_irq+0xa5/0xe0
 [<c03ae725>] i8042_check_aux+0x35/0x160
 [<c02867c0>] i8042_interrupt+0x0/0x170
 [<c03aeafc>] i8042_init+0xec/0x170
 [<c039e6ec>] do_initcalls+0x2c/0xa0
 [<c0127e6f>] init_workqueues+0xf/0x60
 [<c01050cd>] init+0x2d/0x160
 [<c01050a0>] init+0x0/0x160
 [<c0107189>] kernel_thread_helper+0x5/0xc

handlers:
[<c02867c0>] (i8042_interrupt+0x0/0x170)
Disabling IRQ #12
irq 12: nobody cared!
Call Trace:
 [<c010adda>] __report_bad_irq+0x2a/0x90
 [<c010aed0>] note_interrupt+0x70/0xa0
 [<c010b17b>] do_IRQ+0x12b/0x140
 [<c01094c8>] common_interrupt+0x18/0x20
 [<c011bc40>] do_softirq+0x40/0xa0
 [<c010b157>] do_IRQ+0x107/0x140
 [<c01094c8>] common_interrupt+0x18/0x20
 [<c010b6ec>] setup_irq+0x9c/0xf0
 [<c02867c0>] i8042_interrupt+0x0/0x170
 [<c010b235>] request_irq+0xa5/0xe0
 [<c0286699>] i8042_open+0x69/0x100
 [<c02867c0>] i8042_interrupt+0x0/0x170
 [<c0286308>] serio_open+0x18/0x40
 [<c0285b34>] atkbd_connect+0x134/0x380
 [<c0285dd4>] serio_find_dev+0x54/0x60
 [<c02860d0>] serio_register_port+0x40/0x60
 [<c03ae8a8>] i8042_port_register+0x58/0x90
 [<c03aeb14>] i8042_init+0x104/0x170
 [<c039e6ec>] do_initcalls+0x2c/0xa0
 [<c0127e6f>] init_workqueues+0xf/0x60
 [<c01050cd>] init+0x2d/0x160
 [<c01050a0>] init+0x0/0x160
 [<c0107189>] kernel_thread_helper+0x5/0xc

handlers:
[<c02867c0>] (i8042_interrupt+0x0/0x170)
Disabling IRQ #12
serio: i8042 AUX port at 0x60,0x64 irq 12
input: AT Translated Set 2 keyboard on isa0060/serio0
serio: i8042 KBD port at 0x60,0x64 irq 1
md: raid5 personality registered as nr 4
raid5: measuring checksumming speed
   8regs     :  1092.000 MB/sec
   8regs_prefetch:  1036.000 MB/sec
   32regs    :   912.000 MB/sec
   32regs_prefetch:   792.000 MB/sec
   pII_mmx   :  2172.000 MB/sec
   p5_mmx    :  2908.000 MB/sec
raid5: using function: p5_mmx (2908.000 MB/sec)
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
device-mapper: 1.0.6-ioctl (2002-10-15) initialised: dm@uk.sistina.com
NET: Registered protocol family 2
IP: routing cache hash table of 4096 buckets, 32Kbytes
TCP: Hash tables configured (established 32768 bind 65536)
NET: Registered protocol family 1
NET: Registered protocol family 17
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 112k freed
EXT3 FS on hda3, internal journal
Adding 522104k swap on /dev/hda2.  Priority:-1 extents:1
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
blk: queue dfd2b800, I/O limit 4095Mb (mask 0xffffffff)
blk: queue dfd2b000, I/O limit 4095Mb (mask 0xffffffff)


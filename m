From: Falk Hueffner <falk.hueffner@student.uni-tuebingen.de>
Subject: 2.5.39 raid0 on Alpha: bug: can't convert block across chunks or bigger than 32k
Date: 29 Sep 2002 03:33:43 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <87elbdwpe0.fsf@student.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've tried to mount a raid0 on an Alpha with kernel 2.5.39. It works
fine with a RedHat 2.4.18. On 2.5.39, I quickly get the following
messages, though:

raid0_make_request bug: can't convert block across chunks or bigger than 32k 138506232 48
raid0_make_request bug: can't convert block across chunks or bigger than 32k 138506232 8
[...]

which leads to an IO error

Many files read OK, though, enough to get a login. This is the dmesg
output:

Linux version 2.5.39 (falk@juist) (gcc version 3.3 20020926 (experimental)) #13 Sun Sep 29 02:02:17 CEST 2002
Booting on Nautilus using machine vector Nautilus from SRM
Command line: root=/dev/hda1
memcluster 0, usage 1, start        0, end      324
memcluster 1, usage 0, start      324, end    65527
memcluster 2, usage 1, start    65527, end    65536
freeing pages 324:1024
freeing pages 1327:65527
reserving pages 1327:1328
Iron stat_cmd 22100006
Iron ECC d00
On node 0 totalpages: 65527
  DMA zone: 2048 pages
  Normal zone: 63479 pages
  HighMem zone: 0 pages
Building zonelist for node : 0
Kernel command line: root=/dev/hda1
Using epoch = 2000
Console: colour VGA+ 80x25
Calibrating delay loop... 1586.36 BogoMIPS
Memory: 514056k/524216k available (1321k kernel code, 7568k reserved, 381k data, 80k init)
Security Scaffold v1.0.0 initialized
Dentry-cache hash table entries: 65536 (order: 7, 1048576 bytes)
Inode-cache hash table entries: 32768 (order: 6, 524288 bytes)
Mount-cache hash table entries: 512 (order: 0, 8192 bytes)
POSIX conformance testing by UNIFIX
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
PCI: region 00:00.0/0 too large: 0-ffffffff
PCI: Bus 1, bridge: Advanced Micro Devices [AMD] AMD-760 [IGD4-1P] AGP Bridge
  IO window: 8000-8fff
  MEM window: f0000000-f00fffff
  PREFETCH window: d0000000-efffffff
Starting kswapd
BIO: pool of 256 setup, 24Kb (96 bytes/bio)
biovec pool[0]:   1 bvecs: 256 entries (16 bytes)
biovec pool[1]:   4 bvecs: 256 entries (64 bytes)
biovec pool[2]:  16 bvecs: 256 entries (256 bytes)
biovec pool[3]:  64 bvecs: 256 entries (1024 bytes)
biovec pool[4]: 128 bvecs: 256 entries (2048 bytes)
biovec pool[5]: 256 bvecs: 256 entries (4096 bytes)
aio_setup: sizeof(struct page) = 80
Journalled Block Device driver loaded
Capability LSM initialized
pty: 256 Unix98 ptys configured
block request queues:
 128 requests per read queue
 128 requests per write queue
 8 requests per batch
 enter congestion at 31
 exit congestion at 33
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
hda: ST340823A, ATA DISK drive
hdb: ST340016A, ATA DISK drive
hdc: ST340823A, ATA DISK drive
hdd: SONY CD-ROM CDU5221, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: host protected area => 1
hda: 78165360 sectors (40021 MB) w/1024KiB Cache, CHS=77545/16/63
 hda: hda1 hda2 hda3 hda4
hdb: host protected area => 1
hdb: 78165360 sectors (40021 MB) w/2048KiB Cache, CHS=77545/16/63
 hdb: hdb1 hdb2 hdb3
hdc: host protected area => 1
hdc: 78165360 sectors (40021 MB) w/1024KiB Cache, CHS=77545/16/63
 hdc: hdc1 hdc3 hdc4
register interface 'event' with class 'input
input: ImPS/2 Logitech Wheel Mouse on isa0060/serio1
serio: i8042 AUX port at 0x60,0x64 irq 12
input: AT Set 2 keyboard on isa0060/serio0
serio: i8042 KBD port at 0x60,0x64 irq 1
md: raid0 personality registered as nr 2
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP
IP: routing cache hash table of 8192 buckets, 64Kbytes
TCP: Hash tables configured (established 65536 bind 65536)
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 80k freed
Adding 524648k swap on /dev/hda2.  Priority:-1 extents:1
EXT3 FS 2.4-0.9.16, 02 Dec 2001 on ide0(3,1), internal journal
 [events: 000004a2]
 [events: 000004a2]
md: autorun ...
md: considering hdc4 ...
md:  adding hdc4 ...
md:  adding hda4 ...
md: created md0
md: bind<hda4>
md: bind<hdc4>
md: running: <hdc4><hda4>
md: hdc4's event counter: 000004a2
md: hda4's event counter: 000004a2
md0: max total readahead window set to 480k
md0: 2 data-disks, max readahead per data-disk: 240k
raid0: looking at hdc4
raid0:   comparing hdc4(34885248) with hdc4(34885248)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at hda4
raid0:   comparing hda4(38452608) with hdc4(34885248)
raid0:   NOT EQUAL
raid0:   comparing hda4(38452608) with hda4(38452608)
raid0:   END
raid0:   ==> UNIQUE
raid0: 2 zones
raid0: FINAL 2 zones
raid0: zone 1
raid0: checking hda4 ... contained as device 0
  (38452608) is smallest!.
raid0: checking hdc4 ... nope.
raid0: zone->nb_dev: 1, size: 3567360
raid0: current zone offset: 38452608
raid0: done.
raid0 : md_size is 73337856 blocks.
raid0 : conf->smallest->size is 3567360 blocks.
raid0 : nb_zone is 21.
raid0 : Allocating 336 bytes for hash.
md: updating md0 RAID superblock on device
md: hdc4 [events: 000004a3]<6>(write) hdc4's sb offset: 34885248
md: hda4 [events: 000004a3]<6>(write) hda4's sb offset: 38452608
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.16, 02 Dec 2001 on ide1(22,1), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.16, 02 Dec 2001 on md(9,0), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
raid0_make_request bug: can't convert block across chunks or bigger than 32k 138506232 48
raid0_make_request bug: can't convert block across chunks or bigger than 32k 138506232 8

----------------------------------------------------------------------

This is dmesg with 2.4.18, where raid works:

Linux version 2.4.18-4.2nhd (root@dyna1) (gcc version 2.96 20000731 (Red Hat Linux 7.3 2.96-110)) #1 Sat Jun 15 21:17:26 MDT 2002
Booting GENERIC on Nautilus using machine vector Nautilus from SRM
Command line: root=/dev/hda1  console=tty0
memcluster 0, usage 1, start        0, end      324
memcluster 1, usage 0, start      324, end    65527
memcluster 2, usage 1, start    65527, end    65536
freeing pages 324:1024
freeing pages 1518:65527
reserving pages 1518:1519
Initial ramdisk at: 0xfffffc001ff56000 (615058 bytes)
Iron stat_cmd 22100006
Iron ECC f00
On node 0 totalpages: 65527
zone(0): 2048 pages.
zone(1): 63479 pages.
zone(2): 0 pages.
Kernel command line: root=/dev/hda1  console=tty0
Using epoch = 2000
Console: colour VGA+ 80x25
Calibrating delay loop... 1586.36 BogoMIPS
Memory: 510376k/524216k available (2156k kernel code, 11248k reserved, 757k data, 432k init)
Dentry cache hash table entries: 65536 (order: 7, 1048576 bytes)
Inode cache hash table entries: 32768 (order: 6, 524288 bytes)
Mount-cache hash table entries: 8192 (order: 4, 131072 bytes)
Buffer cache hash table entries: 32768 (order: 5, 262144 bytes)
Page-cache hash table entries: 65536 (order: 6, 524288 bytes)
POSIX conformance testing by UNIFIX
PCI: region 00:00.0/0 too large: 0-ffffffff
PCI: Bus 1, bridge: Advanced Micro Devices [AMD] AMD-760 [Irongate] AGP Bridge
  IO window: 8000-8fff
  MEM window: f0000000-f00fffff
  PREFETCH window: d0000000-efffffff
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Linux NET4.0 for Linux 2.4
Based upon Swansea University Computer Society NET3.039
Initializing RT netlink socket
Starting kswapd
VFS: Diskquotas version dquot_6.5.0 initialized
pty: 2048 Unix98 ptys configured
Serial driver version 5.05c (2001-07-08) with MANY_PORTS SHARE_IRQ SERIAL_PCI ISAPNP enabled
ttyS00 at 0x03f8 (irq = 4) is a 16550A
ttyS01 at 0x02f8 (irq = 3) is a 16550A
Redundant entry in serial pci_table.  Please send the output of
lspci -vv, this message (10b9,5457,10b9,5457)
and the manufacturer and name of serial board or modem board
to serial-pci-info@lists.sourceforge.net.
register_serial(): autoconfig failed
block: 976 slots per queue, batch=244
Uniform Multi-Platform E-IDE driver Revision: 6.31
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ALI15X3: IDE controller on PCI bus 00 dev 80
ALI15X3: chipset revision 196
ALI15X3: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x9ca0-0x9ca7, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x9ca8-0x9caf, BIOS settings: hdc:pio, hdd:pio
hda: ST340823A, ATA DISK drive
hdb: ST340016A, ATA DISK drive
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
hdc: ST340823A, ATA DISK drive
hdd: SONY CD-ROM CDU5221, ATAPI CD/DVD-ROM drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
ide1 at 0x170-0x177,0x376 on irq 15
hda: 78165360 sectors (40021 MB) w/1024KiB Cache, CHS=77545/16/63, UDMA(100)
hdb: 78165360 sectors (40021 MB) w/2048KiB Cache, CHS=77545/16/63, UDMA(100)
hdc: 78165360 sectors (40021 MB) w/1024KiB Cache, CHS=77545/16/63, UDMA(100)
Partition check:
 hda: hda1 hda2 hda3 hda4
 hdb: hdb1 hdb2 hdb3
 hdc: hdc1 hdc3 hdc4
Floppy drive(s): fd0 is 2.88M
FDC 0 is a post-1991 82077
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
SCSI subsystem driver Revision: 1.00
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
NET4: Linux TCP/IP 1.0 for NET4.0
IP Protocols: ICMP, UDP, TCP, IGMP
IP: routing cache hash table of 4096 buckets, 64Kbytes
TCP: Hash tables configured (established 32768 bind 32768)
Linux IP multicast router 0.06 plus PIM-SM
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
RAMDISK: Compressed image found at block 0
Freeing initrd memory: 600k freed
VFS: Mounted root (ext2 filesystem).
Journalled Block Device driver loaded
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Freeing unused kernel memory: 432k freed
Adding Swap: 524648k swap-space (priority -1)
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,1), internal journal
rtc: SRM (post-2000) epoch (2000) detected
Real Time Clock Driver v1.10e
eth0: DE500-BA at 0x9c00 (PCI bus 0, device 11), h/w address 00:00:f0:51:18:86,
      and requires IRQ11 (provided by PCI BIOS).
de4x5.c:V0.546 2001/02/22 davies@maniac.ultranet.com
8139too Fast Ethernet driver 0.9.24
eth1: RealTek RTL8139 Fast Ethernet at 0xfffffd00f0147000, 00:30:84:3b:78:1d, IRQ 5
eth1:  Identified 8139 chip type 'RTL-8139C'
Trident 4DWave/SiS 7018/ALi 5451,Tvia CyberPro 5050 PCI Audio, version 0.14.9d, 22:07:27 Jun 15 2002
trident: ALi Audio Accelerator found at IO 0x9400, IRQ 10
ac97_codec: AC97 Audio codec, id: 0x4144:0x5340 (Analog Devices AD1881)
ac97_codec: Secondary ac97 codec not present
trident: Running on Alpha system type Nautilus
 [events: 000004a4]
 [events: 000004a4]
md: autorun ...
md: considering hdc4 ...
md:  adding hdc4 ...
md:  adding hda4 ...
md: created md0
md: bind<hda4,1>
md: bind<hdc4,2>
md: running: <hdc4><hda4>
md: hdc4's event counter: 000004a4
md: hda4's event counter: 000004a4
md: raid0 personality registered as nr 2
md0: max total readahead window set to 480k
md0: 2 data-disks, max readahead per data-disk: 240k
raid0: looking at hda4
raid0:   comparing hda4(38452608) with hda4(38452608)
raid0:   END
raid0:   ==> UNIQUE
raid0: 1 zones
raid0: looking at hdc4
raid0:   comparing hdc4(34885248) with hda4(38452608)
raid0:   NOT EQUAL
raid0:   comparing hdc4(34885248) with hdc4(34885248)
raid0:   END
raid0:   ==> UNIQUE
raid0: 2 zones
raid0: FINAL 2 zones
raid0: zone 0
raid0: checking hda4 ... contained as device 0
  (38452608) is smallest!.
raid0: checking hdc4 ... contained as device 1
  (34885248) is smallest!.
raid0: zone->nb_dev: 2, size: 69770496
raid0: current zone offset: 34885248
raid0: zone 1
raid0: checking hda4 ... contained as device 0
  (38452608) is smallest!.
raid0: checking hdc4 ... nope.
raid0: zone->nb_dev: 1, size: 3567360
raid0: current zone offset: 38452608
raid0: done.
raid0 : md_size is 73337856 blocks.
raid0 : conf->smallest->size is 3567360 blocks.
raid0 : nb_zone is 21.
raid0 : Allocating 336 bytes for hash.
md: updating md0 RAID superblock on device
md: hdc4 [events: 000004a5]<6>(write) hdc4's sb offset: 34885248
md: hda4 [events: 000004a5]<6>(write) hda4's sb offset: 38452608
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide1(22,1), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on md(9,0), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
eth0: media is unconnected, link down or incompatible connection.
CSLIP: code copyright 1989 Regents of the University of California
PPP generic driver version 2.4.2
eth1: Setting half-duplex based on auto-negotiated partner ability 0000.
PPP BSD Compression module registered
PPP Deflate Compression module registered
ip_tables: (C) 2000-2002 Netfilter core team
ip_conntrack (2047 buckets, 16376 max)
[drm] Initialized radeon 1.1.1 20010405 on minor 0

----------------------------------------------------------------------

This is /etc/raidtab:

raiddev /dev/md0
	raid-level		0
	nr-raid-disks		2
	persistent-superblock	1
	chunk-size		32
	device			/dev/hda4
	raid-disk		0
	device			/dev/hdc4
	raid-disk		1

It would be great if anybody had an idea what I could try to narrow
down this bug...

-- 
	Falk

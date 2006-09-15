From: Reza Naima <reza@reza.net>
Subject: RAID5 Problem - $1000 reward for help
Date: Fri, 15 Sep 2006 02:08:56 -0700
Message-ID: <20060915090856.GD27597@boom.net>
Reply-To: Reza Naima <reza@reza.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Taner Halicioglu <taner@taner.net>
List-Id: linux-raid.ids

I had 1 of 4 200G disks fail (not sure when) - I noticed it yesterday after
doing a cat of /proc/mdstat.  I picked up a replacement drive, plugged
it in, and did a mdadm -add... however, before it finished, the kernel
puked/panicked, and a 2nd disk decided to go belly up.  After some time,
the system came back to life, only to find that I had two failed disks
and the system didn't work so well.  Lots of missing inodes.  I couldn't
shutdown from the command line, so I pulled the plug and yanked the
disks.

I've picked up two 500G disks, and am in the process of dd'ing the
contents of the raid partitions over.  The 2nd failed disk came up just
fine, and has been coping the data over without fault.  I expect it to
finish, but thought I would send this email now.  I will include some
data that I captured before the system failed.

I put the original failed disk back in and did a reboot, but it said it
couldn't find the superblock and had 2/4 failed disks.  

I'm guessing the 2nd failed disk was marked failed as a fluke and isn't
bad (doesn't seem to be so far).  I'm hoping that a few bits need to be
tweaked to mark it unfailed and have it somehow join with the two other
disks so I can mount it.

However, I (currently) lack the skillset, nor do I have the time to fix
it.  I've gotten some quotes for fixing it, but the lowest estimate so
far is from a company in Canada that doesn't sound reputable ($1200,
software only), and two companies here - both starting at $4000. 

I'm hoping that someone with some knowhow will be interested in helping
me out.  Easiest thing to do is have said person SSH into my machine
and try to fix the copies of the partitions (currently files on an ext3
filesystem).  I'm offering a $1000 cash reward to anyone that can
sucessfully fix my problem - or $1000 donated towards the charity of
your choice.  

Please email me directly if you are interested.  

I'm including some data from the "event".  Note, /dev/hdc1 first failed,
and was replaced.  It was being rebuilt when the 2nd drive failure
occured.  The second drive is /dev/hdg1  :

[root@onyx reza]# mdadm -E /dev/hdc1
/dev/hdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d445e6c5:061890a2:25bb0b70:cd047d03
  Creation Time : Wed Dec  8 16:40:03 2004
     Raid Level : raid5
    Device Size : 195358208 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Sep 13 23:21:18 2006
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 3
  Spare Devices : 1
       Checksum : dea2a69 - correct
         Events : 0.43756591

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     4      22        1        4      spare   /dev/hdc1
   0     0       3        3        0      active sync   /dev/hda3
   1     1       0        0        1      faulty removed
   2     2      33       65        2      active sync   /dev/hdf1
   3     3       0        0        3      faulty removed
   4     4      22        1        4      spare   /dev/hdc1



[root@onyx reza]# mdadm -E /dev/hdg1
mdadm: Cannot read superblock on /dev/hdg1

root@onyx reza]# mdadm -E /dev/hda3
/dev/hda3:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d445e6c5:061890a2:25bb0b70:cd047d03
  Creation Time : Wed Dec  8 16:40:03 2004
     Raid Level : raid5
    Device Size : 195358208 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Sep 13 23:21:18 2006
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 3
  Spare Devices : 1
       Checksum : dea2a56 - correct
         Events : 0.43756591

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     0       3        3        0      active sync   /dev/hda3
   0     0       3        3        0      active sync   /dev/hda3
   1     1       0        0        1      faulty removed
   2     2      33       65        2      active sync   /dev/hdf1
   3     3       0        0        3      faulty removed
   4     4      22        1        4      spare   /dev/hdc1

[root@onyx reza]# mdadm -E /dev/hdf1
/dev/hdf1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : d445e6c5:061890a2:25bb0b70:cd047d03
  Creation Time : Wed Dec  8 16:40:03 2004
     Raid Level : raid5
    Device Size : 195358208 (186.31 GiB 200.05 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Wed Sep 13 23:21:18 2006
          State : clean
 Active Devices : 2
Working Devices : 3
 Failed Devices : 3
  Spare Devices : 1
       Checksum : dea2ab6 - correct
         Events : 0.43756591

         Layout : left-symmetric
     Chunk Size : 256K

      Number   Major   Minor   RaidDevice State
this     2      33       65        2      active sync   /dev/hdf1
   0     0       3        3        0      active sync   /dev/hda3
   1     1       0        0        1      faulty removed
   2     2      33       65        2      active sync   /dev/hdf1
   3     3       0        0        3      faulty removed
   4     4      22        1        4      spare   /dev/hdc1

[root@onyx reza]# cat /proc/mdstat
Personalities : [raid5]
md0 : active raid5 hdc1[4] hdg1[5](F) hdf1[2] hda3[0]
      586074624 blocks level 5, 256k chunk, algorithm 2 [4/2] [U_U_]

unused devices: <none>
[root@onyx reza]#



[root@onyx log]# dmesg
Linux version 2.6.12-1.1381_FC3 (bhcompile@porky.build.redhat.com) (gcc version 3.4.4 20050721 (Red Hat 3.4.4-2)) #1 Fri Oct 21 03:46:55 EDT 2005
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e800 (usable)
 BIOS-e820: 000000000009e800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000002fff0000 (usable)
 BIOS-e820: 000000002fff0000 - 000000002fff3000 (ACPI NVS)
 BIOS-e820: 000000002fff3000 - 0000000030000000 (ACPI data)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ffff0000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
767MB LOWMEM available.
Using x86 segment limits to approximate NX protection
On node 0 totalpages: 196592
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 192496 pages, LIFO batch:31
  HighMem zone: 0 pages, LIFO batch:1
DMI 2.2 present.
ACPI: RSDP (v000 Nvidia                                ) @ 0x000f75e0
ACPI: RSDT (v001 Nvidia AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x2fff3000
ACPI: FADT (v001 Nvidia AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x2fff3040
ACPI: MADT (v001 Nvidia AWRDACPI 0x42302e31 AWRD 0x00000000) @ 0x2fff74c0
ACPI: DSDT (v001 NVIDIA AWRDACPI 0x00001000 MSFT 0x0100000e) @ 0x00000000
ACPI: PM-Timer IO Port: 0x4008
Allocating PCI resources starting at 30000000 (gap: 30000000:cec00000)
Built 1 zonelists
Kernel command line: ro root=/dev/md0 rhgb quiet
Initializing CPU#0
CPU 0 irqstacks, hard=c0447000 soft=c0446000
PID hash table entries: 4096 (order: 12, 65536 bytes)
Detected 1052.455 MHz processor.
Using pmtmr for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 774376k/786368k available (2451k kernel code, 11428k reserved, 693k data, 180k init, 0k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay loop... 2080.76 BogoMIPS (lpj=1040384)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 0183fbff c1c7fbff 00000000 00000000 00000000 00000000 00000000
CPU: After vendor identify, caps: 0183fbff c1c7fbff 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 256K (64 bytes/line)
CPU: After all inits, caps: 0183f3ff c1c7fbff 00000000 00000020 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU: AMD Athlon(tm) processor stepping 04
Enabling fast FPU save and restore... done.
Checking 'hlt' instruction... OK.
ACPI: setting ELCR to 0200 (from 1c20)
checking if image is initramfs... it is
Freeing initrd memory: 701k freed
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xfb490, last bus=3
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20050902
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: Assume root bridge [\_SB_.PCI0] segment is 0
PCI: nForce2 C1 Halt Disconnect fixup
Boot video device is 0000:01:0a.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGPB._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB1._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 6 7 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LMAC] (IRQs 3 4 5 6 7 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LAPU] (IRQs 3 4 5 6 7 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 6 7 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LFIR] (IRQs 3 4 5 6 7 10 *11 12 14 15)
ACPI: PCI Interrupt Link [L3CM] (IRQs 3 4 *5 6 7 10 11 12 14 15)
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs *17), disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs *18), disabled.
ACPI: PCI Interrupt Link [APC4] (IRQs *19), disabled.
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCI] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs *23), disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [AP3C] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 12 devices
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
pnp: 00:00: ioport range 0x4000-0x407f could not be reserved
pnp: 00:00: ioport range 0x4080-0x40ff has been reserved
pnp: 00:00: ioport range 0x4400-0x447f has been reserved
pnp: 00:00: ioport range 0x4480-0x44ff could not be reserved
pnp: 00:00: ioport range 0x4200-0x427f has been reserved
pnp: 00:00: ioport range 0x4280-0x42ff has been reserved
pnp: 00:01: ioport range 0x5000-0x503f has been reserved
pnp: 00:01: ioport range 0x5500-0x553f has been reserved
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: overridden by ACPI.
audit: initializing netlink socket (disabled)
audit(1158187349.663:1): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
Initializing Cryptographic API
ksign: Installing public key data
Loading keyring
- Added public key DA130D81657437A9
- User ID: Red Hat, Inc. (Kernel Module GPG key)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: CPU0 (power states: C1[C1])
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12
Linux agpgart interface v0.101 (c) Dave Jones
agpgart: Detected NVIDIA nForce2 chipset
agpgart: AGP aperture is 64M @ 0xd0000000
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 76 ports, IRQ sharing enabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
NFORCE2: IDE controller at PCI slot 0000:00:09.0
NFORCE2: chipset revision 162
NFORCE2: not 100% native mode: will probe irqs later
NFORCE2: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE2: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE2: 0000:00:09.0 (rev a2) UDMA133 controller
    ide0: BM-DMA at 0xf000-0xf007, BIOS settings: hda:DMA, hdb:DMA
    ide1: BM-DMA at 0xf008-0xf00f, BIOS settings: hdc:DMA, hdd:DMA
Probing IDE interface ide0...
hda: Maxtor 6B200P0, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: WDC WD2500JB-00REA0, ATA DISK drive
ide1 at 0x170-0x177,0x376 on irq 15
PDC20267: IDE controller at PCI slot 0000:01:06.0
ACPI: PCI Interrupt Link [LNK1] enabled at IRQ 10
PCI: setting IRQ 10 as level-triggered
ACPI: PCI Interrupt 0000:01:06.0[A] -> Link [LNK1] -> GSI 10 (level, low) -> IRQ 10
PDC20267: chipset revision 2
PDC20267: 100% native mode on irq 10
PDC20267: (U)DMA Burst Bit ENABLED Primary PCI Mode Secondary PCI Mode.
    ide2: BM-DMA at 0xb000-0xb007, BIOS settings: hde:pio, hdf:DMA
    ide3: BM-DMA at 0xb008-0xb00f, BIOS settings: hdg:pio, hdh:pio
Probing IDE interface ide2...
hde: Pioneer DVD-ROM ATAPIModel DVD-106S 012, ATAPI CD/DVD-ROM drive
hdf: WDC WD2000JB-00GVA0, ATA DISK drive
ide2 at 0xa000-0xa007,0xa402 on irq 10
Probing IDE interface ide3...
hdg: WDC WD2000JB-00GVA0, ATA DISK drive
ide3 at 0xa800-0xa807,0xac02 on irq 10
hda: max request size: 1024KiB
hda: 398297088 sectors (203928 MB) w/8192KiB Cache, CHS=24792/255/63, UDMA(133)
hda: cache flushes supported
 hda: hda1 hda2 hda3
hdc: max request size: 1024KiB
hdc: 488397168 sectors (250059 MB) w/8192KiB Cache, CHS=30401/255/63, UDMA(100)
hdc: cache flushes supported
 hdc: unknown partition table
hdf: max request size: 128KiB
hdf: 390721968 sectors (200049 MB) w/8192KiB Cache, CHS=24321/255/63, UDMA(100)
hdf: cache flushes supported
 hdf: hdf1
hdg: max request size: 128KiB
hdg: 390721968 sectors (200049 MB) w/8192KiB Cache, CHS=24321/255/63, UDMA(100)
hdg: cache flushes supported
 hdg: hdg1
hde: ATAPI 40X DVD-ROM drive, 256kB Cache
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.01:USB HID core driver
mice: PS/2 mouse device common for all mice
md: md driver 0.90.1 MAX_MD_DEVS=256, MD_SB_DISKS=27
NET: Registered protocol family 2
IP: routing cache hash table of 2048 buckets, 64Kbytes
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 8, 1835008 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
Initializing IPsec netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
ACPI wakeup devices:
HUB0 HUB1 USB0 USB1 USB2 F139 MMAC MMCI UAR1
ACPI: (supports S0 S1 S3 S4 S4bios S5)
Freeing unused kernel memory: 180k freed
SCSI subsystem initialized
libata version 1.11 loaded.
sata_sil version 0.9
ACPI: PCI Interrupt Link [LNK3] enabled at IRQ 11
PCI: setting IRQ 11 as level-triggered
ACPI: PCI Interrupt 0000:01:0b.0[A] -> Link [LNK3] -> GSI 11 (level, low) -> IRQ 11
ata1: SATA max UDMA/100 cmd 0xF081C080 ctl 0xF081C08A bmdma 0xF081C000 irq 11
ata2: SATA max UDMA/100 cmd 0xF081C0C0 ctl 0xF081C0CA bmdma 0xF081C008 irq 11
ata1: no device found (phy stat 00000000)
scsi0 : sata_sil
ata2: no device found (phy stat 00000000)
scsi1 : sata_sil
raid5: measuring checksumming speed
   8regs     :  1148.000 MB/sec
   8regs_prefetch:  1336.000 MB/sec
   32regs    :   888.000 MB/sec
   32regs_prefetch:  1064.000 MB/sec
   pII_mmx   :  2844.000 MB/sec
   p5_mmx    :  3780.000 MB/sec
raid5: using function: p5_mmx (3780.000 MB/sec)
md: raid5 personality registered as nr 4
md: Autodetecting RAID arrays.
md: autorun ...
md: considering hdg1 ...
md:  adding hdg1 ...
md:  adding hdf1 ...
md:  adding hda3 ...
md: created md0
md: bind<hda3>
md: bind<hdf1>
md: bind<hdg1>
md: running: <hdg1><hdf1><hda3>
raid5: device hdg1 operational as raid disk 3
raid5: device hdf1 operational as raid disk 2
raid5: device hda3 operational as raid disk 0
raid5: allocated 4212kB for md0
raid5: raid level 5 set md0 active with 3 out of 4 devices, algorithm 2
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, o:1, dev:hda3
 disk 2, o:1, dev:hdf1
 disk 3, o:1, dev:hdg1
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
Floppy drive(s): fd0 is 1.44M
FDC 0 is a post-1991 82077
ACPI: PCI Interrupt Link [L3CM] enabled at IRQ 5
PCI: setting IRQ 5 as level-triggered
ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [L3CM] -> GSI 5 (level, low) -> IRQ 5
3c59x: Donald Becker and others. www.scyld.com/network/vortex.html
0000:02:01.0: 3Com PCI 3c920 Tornado at 0xd000. Vers LK1.1.19
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.32.
ACPI: PCI Interrupt Link [LMAC] enabled at IRQ 12
PCI: setting IRQ 12 as level-triggered
ACPI: PCI Interrupt 0000:00:04.0[A] -> Link [LMAC] -> GSI 12 (level, low) -> IRQ 12
PCI: Setting latency timer of device 0000:00:04.0 to 64
eth1: forcedeth.c: subsystem: 01043:80a7 bound to 0000:00:04.0
ACPI: PCI Interrupt Link [LACI] enabled at IRQ 5
ACPI: PCI Interrupt 0000:00:06.0[A] -> Link [LACI] -> GSI 5 (level, low) -> IRQ 5
PCI: Setting latency timer of device 0000:00:06.0 to 64
intel8x0_measure_ac97_clock: measured 49592 usecs
intel8x0: clocking to 47450
i2c_adapter i2c-0: nForce2 SMBus adapter at 0x5000
i2c_adapter i2c-1: nForce2 SMBus adapter at 0x5500
Linux video capture interface: v1.00
bttv: driver version 0.9.15 loaded
bttv: using 8 buffers with 2080k (520 pages) each for capture
bttv: Bt8xx card found (0).
ACPI: PCI Interrupt Link [LNK2] enabled at IRQ 10
ACPI: PCI Interrupt 0000:01:09.0[A] -> Link [LNK2] -> GSI 10 (level, low) -> IRQ 10
bttv0: Bt878 (rev 17) at 0000:01:09.0, irq: 10, latency: 32, mmio: 0xd9001000
bttv0: detected: Grandtec Grand X-Guard [card=103], PCI subsystem ID is 0304:0102
bttv0: using: Grand X-Guard / Trust 814PCI [card=103,autodetected]
bttv0: gpio: en=00000000, out=00000000 in=00ffffff [init]
bttv0: using tuner=4
bttv0: i2c: checking for TDA9887 @ 0x86... not found
bttv0: registered device video0
bttv0: registered device vbi0
bttv0: PLL: 28636363 => 35468950 .. ok
bt878: AUDIO driver version 0.0.0 loaded
bt878: Bt878 AUDIO function found (0).
ACPI: PCI Interrupt 0000:01:09.1[A] -> Link [LNK2] -> GSI 10 (level, low) -> IRQ 10
bt878(0): Bt878 (rev 17) at 01:09.1, irq: 10, latency: 32, memory: 0xd9000000
ivtv: no version for "struct_module" found: kernel tainted.
ivtv: Unknown parameter `debug'
ivtv:  ==================== START INIT IVTV ====================
ivtv:  version 0.4.3 (tagged release) loading
ivtv:  Linux version: 2.6.12-1.1381_FC3 686 REGPARM 4KSTACKS gcc-3.4
ivtv:  In case of problems please include the debug info between
ivtv:  the START INIT IVTV and END INIT IVTV lines, along with
ivtv:  any module options, when mailing the ivtv-users mailinglist.
ivtv0: Autodetected WinTV PVR 250 card (cx23416 based)
ACPI: PCI Interrupt 0000:01:08.0[A] -> Link [LNK3] -> GSI 11 (level, low) -> IRQ 11
ivtv0: Unreasonably low latency timer, setting to 64 (was 32)
ivtv0: i2c attach to card #0 ok [client=tveeprom, addr=50]
ivtv0: i2c attach to card #0 ok [client=(tuner unset), addr=61]
tuner 3-0061: chip found @ 0xc2 (ivtv i2c driver #0)
tveeprom: Hauppauge: model = 32032, rev = B110, serial# = 6940993
tveeprom: tuner = Philips FI1236 MK2 (idx = 10, type = 2)
tveeprom: tuner fmt = NTSC(M) (eeprom = 0x08, v4l2 = 0x00001000)
tveeprom: audio_processor = MSP3440 (type = 11)
saa7115 3-0021: ivtv driver
saa7115 3-0021: saa7115 found @ 0x42 (ivtv i2c driver #0)
ivtv0: i2c attach to card #0 ok [client=saa7115, addr=21]
msp3400 3-0040: ivtv driver
msp3400 3-0040: chip=MSP4448G-A2 +nicam +simple +simpler +radio mode=simpler
ivtv0: i2c attach to card #0 ok [client=MSP4448G-A2, addr=40]
msp3400 3-0040: msp34xxg daemon started
ivtv0: loaded v4l-cx2341x-enc.fw firmware (262144 bytes)
ivtv0: Encoder revision: 0x02040024
ivtv0 warning: Encoder Firmware can be buggy, use version 0x02040011 or 0x02050032.
ivtv0: Allocate DMA encoder MPEG stream: 128 x 32768 buffers (4096KB total)
ivtv0: Allocate DMA encoder YUV stream: 194 x 10800 buffers (2048KB total)
ivtv0: Allocate DMA encoder VBI stream: 120 x 17472 buffers (2048KB total)
ivtv0: Allocate DMA encoder PCM audio stream: 455 x 4608 buffers (2048KB total)
ivtv0: Create encoder radio stream
tuner 3-0061: type set to 2 (Philips NTSC (FI1236,FM1236 and compatibles))
ivtv0: Initialized WinTV PVR 250, card #0
ivtv:  ====================  END INIT IVTV  ====================
cx2388x v4l2 driver version 0.0.4 loaded
ACPI: PCI Interrupt Link [LNK4] enabled at IRQ 11
ACPI: PCI Interrupt 0000:01:07.0[A] -> Link [LNK4] -> GSI 11 (level, low) -> IRQ 11
cx88[0]: subsystem: 7063:3000, board: pcHDTV HD3000 HDTV [card=22,autodetected]
tuner 4-0061: chip found @ 0xc2 (cx88[0])
tuner 4-0061: type set to 52 (Thomson DDT 7610 (ATSC/NTSC))
tda9885/6/7: chip found @ 0x86
cx88[0]/0: found at 0000:01:07.0, rev: 5, irq: 11, latency: 32, mmio: 0xdd000000
cx88[0]/0: registered device video2 [v4l2]
cx88[0]/0: registered device vbi2
cx88[0]/0: registered device radio1
cx2388x dvb driver version 0.0.4 loaded
ACPI: PCI Interrupt 0000:01:07.2[A] -> Link [LNK4] -> GSI 11 (level, low) -> IRQ 11
cx88[0]/2: found at 0000:01:07.2, rev: 5, irq: 11, latency: 32, mmio: 0xde000000
cx88[0]/2: cx2388x based dvb card
DVB: registering new adapter (cx88[0]).
DVB: registering frontend 0 (pcHDTV HD3000 HDTV)...
ACPI: PCI Interrupt Link [LUB2] enabled at IRQ 10
ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [LUB2] -> GSI 10 (level, low) -> IRQ 10
PCI: Setting latency timer of device 0000:00:02.2 to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: debug port 1
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.2: irq 10, io mem 0xe2083000
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: park 0
ehci_hcd 0000:00:02.2: USB 2.0 initialized, EHCI 1.00, driver 10 Dec 2004
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
ohci_hcd: 2004 Nov 08 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ACPI: PCI Interrupt Link [LUBA] enabled at IRQ 5
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUBA] -> GSI 5 (level, low) -> IRQ 5
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 5, io mem 0xe2080000
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 3 ports detected
ACPI: PCI Interrupt Link [LUBB] enabled at IRQ 12
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUBB] -> GSI 12 (level, low) -> IRQ 12
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:02.1: irq 12, io mem 0xe2082000
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
usb 2-1: new low speed USB device using ohci_hcd and address 2
ieee1394: Initialized config rom entry `ip1394'
ohci1394: $Rev: 1250 $ Ben Collins <bcollins@debian.org>
ACPI: PCI Interrupt Link [LFIR] enabled at IRQ 11
ACPI: PCI Interrupt 0000:00:0d.0[A] -> Link [LFIR] -> GSI 11 (level, low) -> IRQ 11
PCI: Setting latency timer of device 0000:00:0d.0 to 64
ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[11]  MMIO=[e2085000-e20857ff]  Max Packet=[2048]
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
input: eGalax Inc. on usb-0000:00:02.0-1
usbcore: registered new driver touchkitusb
ACPI: Power Button (FF) [PWRF]
ACPI: Power Button (CM) [PWRB]
ibm_acpi: ec object not found
EXT3 FS on md0, internal journal
device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SGI XFS with ACLs, security attributes, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
Adding 1052248k swap on /dev/hda2.  Priority:-1 extents:1
ip_tables: (C) 2000-2002 Netfilter core team
ip_tables: (C) 2000-2002 Netfilter core team
ACPI: PCI Interrupt 0000:02:01.0[A] -> Link [L3CM] -> GSI 5 (level, low) -> IRQ 5
ip_tables: (C) 2000-2002 Netfilter core team
NET: Registered protocol family 10
Disabled Privacy Extensions on device c03d6120(lo)
IPv6 over IPv4 tunneling driver
ip_tables: (C) 2000-2002 Netfilter core team
eth0: Setting promiscuous mode.
device eth0 entered promiscuous mode
NET: Registered protocol family 15
eth1: no IPv6 routers present
eth0: no IPv6 routers present
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
ip_tables: (C) 2000-2002 Netfilter core team
ip_conntrack version 2.1 (6143 buckets, 49144 max) - 272 bytes per conntrack
eth0: Setting promiscuous mode.
bttv0: PLL can sleep, using XTAL (28636363).
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=241 TOS=0x00 PREC=0x00 TTL=64 ID=1 DF PROTO=UDP SPT=138 DPT=138 LEN=221
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=241 TOS=0x00 PREC=0x00 TTL=64 ID=2 DF PROTO=UDP SPT=138 DPT=138 LEN=221
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=1 DF PROTO=UDP SPT=137 DPT=137 LEN=58
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=3 DF PROTO=UDP SPT=137 DPT=137 LEN=58
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=5 DF PROTO=UDP SPT=137 DPT=137 LEN=58
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=78 TOS=0x00 PREC=0x00 TTL=64 ID=7 DF PROTO=UDP SPT=137 DPT=137 LEN=58
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=215 TOS=0x00 PREC=0x00 TTL=64 ID=3 DF PROTO=UDP SPT=138 DPT=138 LEN=195
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=215 TOS=0x00 PREC=0x00 TTL=64 ID=4 DF PROTO=UDP SPT=138 DPT=138 LEN=195
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=215 TOS=0x00 PREC=0x00 TTL=64 ID=5 DF PROTO=UDP SPT=138 DPT=138 LEN=195
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=215 TOS=0x00 PREC=0x00 TTL=64 ID=6 DF PROTO=UDP SPT=138 DPT=138 LEN=195
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=215 TOS=0x00 PREC=0x00 TTL=64 ID=7 DF PROTO=UDP SPT=138 DPT=138 LEN=195
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=96 TOS=0x00 PREC=0x00 TTL=64 ID=20 DF PROTO=UDP SPT=137 DPT=137 LEN=76
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=96 TOS=0x00 PREC=0x00 TTL=64 ID=21 DF PROTO=UDP SPT=137 DPT=137 LEN=76
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=96 TOS=0x00 PREC=0x00 TTL=64 ID=22 DF PROTO=UDP SPT=137 DPT=137 LEN=76
 hdc: hdc1 hdc2 hdc3
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=96 TOS=0x00 PREC=0x00 TTL=64 ID=23 DF PROTO=UDP SPT=137 DPT=137 LEN=76
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=96 TOS=0x00 PREC=0x00 TTL=64 ID=24 DF PROTO=UDP SPT=137 DPT=137 LEN=76
 hdc: hdc1 hdc2 hdc3
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=96 TOS=0x00 PREC=0x00 TTL=64 ID=25 DF PROTO=UDP SPT=137 DPT=137 LEN=76
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=96 TOS=0x00 PREC=0x00 TTL=64 ID=26 DF PROTO=UDP SPT=137 DPT=137 LEN=76
hde: cdrom_pc_intr: The drive appears confused (ireason = 0x01)
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=96 TOS=0x00 PREC=0x00 TTL=64 ID=27 DF PROTO=UDP SPT=137 DPT=137 LEN=76
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=203 TOS=0x00 PREC=0x00 TTL=64 ID=8 DF PROTO=UDP SPT=138 DPT=138 LEN=183
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=241 TOS=0x00 PREC=0x00 TTL=64 ID=9 DF PROTO=UDP SPT=138 DPT=138 LEN=221
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=233 TOS=0x00 PREC=0x00 TTL=64 ID=10 DF PROTO=UDP SPT=138 DPT=138 LEN=213
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=241 TOS=0x00 PREC=0x00 TTL=64 ID=11 DF PROTO=UDP SPT=138 DPT=138 LEN=221
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=233 TOS=0x00 PREC=0x00 TTL=64 ID=12 DF PROTO=UDP SPT=138 DPT=138 LEN=213
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=241 TOS=0x00 PREC=0x00 TTL=64 ID=13 DF PROTO=UDP SPT=138 DPT=138 LEN=221
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=233 TOS=0x00 PREC=0x00 TTL=64 ID=14 DF PROTO=UDP SPT=138 DPT=138 LEN=213
md: bind<hdc1>
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, o:1, dev:hda3
 disk 1, o:1, dev:hdc1
 disk 2, o:1, dev:hdf1
 disk 3, o:1, dev:hdg1
.<6>md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 195358208 blocks.
raid5: Disk failure on hdc1, disabling device. Operation continuing on 3 devices
md: md0: sync done.
md: cannot remove active disk hdc1 from md0 ...
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, o:1, dev:hda3
 disk 1, o:0, dev:hdc1
 disk 2, o:1, dev:hdf1
 disk 3, o:1, dev:hdg1
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, o:1, dev:hda3
 disk 2, o:1, dev:hdf1
 disk 3, o:1, dev:hdg1
md: unbind<hdc1>
md: export_rdev(hdc1)
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=241 TOS=0x00 PREC=0x00 TTL=64 ID=15 DF PROTO=UDP SPT=138 DPT=138 LEN=221
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=233 TOS=0x00 PREC=0x00 TTL=64 ID=16 DF PROTO=UDP SPT=138 DPT=138 LEN=213
 hdc: hdc1 hdc2 hdc3
 hdc: hdc1 hdc2 hdc3
md: bind<hdc1>
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, o:1, dev:hda3
 disk 1, o:1, dev:hdc1
 disk 2, o:1, dev:hdf1
 disk 3, o:1, dev:hdg1
.<6>md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 195358208 blocks.
INC-DROP:IN=eth0 OUT= MAC=00:26:54:10:ed:5e:00:02:3b:01:ed:e6:08:00 SRC=69.12.242.2 DST=64.142.78.129 LEN=328 TOS=0x00 PREC=0x00 TTL=63 ID=0 DF PROTO=UDP SPT=67 DPT=68 LEN=308
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=241 TOS=0x00 PREC=0x00 TTL=64 ID=17 DF PROTO=UDP SPT=138 DPT=138 LEN=221
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=233 TOS=0x00 PREC=0x00 TTL=64 ID=18 DF PROTO=UDP SPT=138 DPT=138 LEN=213
hdg: status timeout: status=0x80 { Busy }

ide: failed opcode was: unknown
hdg: DMA disabled
PDC202XX: Secondary channel reset.
PDC202XX: Primary channel reset.
ide3: reset: master: error (0x00?)
hdg: drive not ready for command
hdf: dma_timer_expiry: dma status == 0x41
hdf: DMA timeout error
hdf: dma timeout error: status=0x59 { DriveReady SeekComplete DataRequest Error }
hdf: dma timeout error: error=0x00 { }
ide: failed opcode was: unknown
hde: status error: status=0x51 { DriveReady SeekComplete Error }
hde: status error: error=0x04 { AbortedCommand }
ide: failed opcode was: unknown
hde: status error: status=0x48 { DriveReady DataRequest }
ide: failed opcode was: unknown
hde: drive not ready for command
hdf: dma_timer_expiry: dma status == 0x41
hdf: DMA timeout error
hdf: dma timeout error: status=0x58 { DriveReady SeekComplete DataRequest }

ide: failed opcode was: unknown
hde: status timeout: status=0xd0 { Busy }
ide: failed opcode was: unknown
hde: drive not ready for command
hde: ATAPI reset timed-out, status=0xd0
PDC202XX: Primary channel reset.
PDC202XX: Secondary channel reset.
ide2: reset: success
hdf: dma_timer_expiry: dma status == 0x41
hdf: DMA timeout error
hdf: dma timeout error: status=0x58 { DriveReady SeekComplete DataRequest }

ide: failed opcode was: unknown
hde: status timeout: status=0xd0 { Busy }
ide: failed opcode was: unknown
hde: drive not ready for command
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=241 TOS=0x00 PREC=0x00 TTL=64 ID=19 DF PROTO=UDP SPT=138 DPT=138 LEN=221
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=233 TOS=0x00 PREC=0x00 TTL=64 ID=20 DF PROTO=UDP SPT=138 DPT=138 LEN=213
hde: ATAPI reset timed-out, status=0xd0
PDC202XX: Primary channel reset.
PDC202XX: Secondary channel reset.
ide2: reset: success
hdg: task_in_intr: status=0x51 { DriveReady SeekComplete Error }
hdg: task_in_intr: error=0x04 { DriveStatusError }
ide: failed opcode was: unknown
hdg: task_in_intr: status=0x51 { DriveReady SeekComplete Error }
hdg: task_in_intr: error=0x04 { DriveStatusError }
ide: failed opcode was: unknown
hdg: task_in_intr: status=0x51 { DriveReady SeekComplete Error }
hdg: task_in_intr: error=0x04 { DriveStatusError }
ide: failed opcode was: unknown
hdg: task_in_intr: status=0x51 { DriveReady SeekComplete Error }
hdg: task_in_intr: error=0x04 { DriveStatusError }
ide: failed opcode was: unknown
Badness in pdc202xx_reset_host at drivers/ide/pci/pdc202xx_old.c:504 (Tainted: GF    )
 [<c029bf88>] pdc202xx_reset_host+0x14c/0x151
 [<c029bf9f>] pdc202xx_reset+0x12/0x2a
 [<c02aa425>] do_reset1+0x2d0/0x3fe
 [<c02a720d>] ide_error+0x5b/0x7e
 [<c02adff9>] task_in_intr+0x3f/0xce
 [<c02a87a2>] ide_intr+0x275/0x559
 [<c0103b0a>] common_interrupt+0x1a/0x20
 [<c02adfba>] task_in_intr+0x0/0xce
 [<c014eae0>] handle_IRQ_event+0x31/0x62
 [<c014ebcf>] __do_IRQ+0xbe/0x2ff
 [<c010592b>] do_IRQ+0x4c/0x85
 =======================
 [<c0176831>] get_unused_fd+0x52/0x1d4
 [<c0103b0a>] common_interrupt+0x1a/0x20
 [<c0188abc>] get_write_access+0x3b/0x16d
 [<c0178489>] get_empty_filp+0x8d/0xeb
 [<c0176731>] dentry_open+0xf7/0x1a5
 [<c0176634>] filp_open+0x40/0x46
 [<c0176831>] get_unused_fd+0x52/0x1d4
 [<c0209486>] strncpy_from_user+0x39/0x5a
 [<c0176c87>] sys_open+0x31/0x5b
 [<c010394d>] syscall_call+0x7/0xb
Badness in pdc202xx_reset_host at drivers/ide/pci/pdc202xx_old.c:506 (Tainted: GF    )
 [<c029bf3b>] pdc202xx_reset_host+0xff/0x151
 [<c029bf9f>] pdc202xx_reset+0x12/0x2a
 [<c02aa425>] do_reset1+0x2d0/0x3fe
 [<c02a720d>] ide_error+0x5b/0x7e
 [<c02adff9>] task_in_intr+0x3f/0xce
 [<c02a87a2>] ide_intr+0x275/0x559
 [<c0103b0a>] common_interrupt+0x1a/0x20
 [<c02adfba>] task_in_intr+0x0/0xce
 [<c014eae0>] handle_IRQ_event+0x31/0x62
 [<c014ebcf>] __do_IRQ+0xbe/0x2ff
 [<c010592b>] do_IRQ+0x4c/0x85
 =======================
 [<c0176831>] get_unused_fd+0x52/0x1d4
 [<c0103b0a>] common_interrupt+0x1a/0x20
 [<c0188abc>] get_write_access+0x3b/0x16d
 [<c0178489>] get_empty_filp+0x8d/0xeb
 [<c0176731>] dentry_open+0xf7/0x1a5
 [<c0176634>] filp_open+0x40/0x46
 [<c0176831>] get_unused_fd+0x52/0x1d4
 [<c0209486>] strncpy_from_user+0x39/0x5a
 [<c0176c87>] sys_open+0x31/0x5b
 [<c010394d>] syscall_call+0x7/0xb
PDC202XX: Secondary channel reset.
PDC202XX: Primary channel reset.
ide3: reset: master: error (0x00?)
end_request: I/O error, dev hdg, sector 42105663
raid5: Disk failure on hdg1, disabling device. Operation continuing on 2 devices
end_request: I/O error, dev hdg, sector 42105671
end_request: I/O error, dev hdg, sector 42105679
end_request: I/O error, dev hdg, sector 42105687
end_request: I/O error, dev hdg, sector 42105695
end_request: I/O error, dev hdg, sector 42105703
end_request: I/O error, dev hdg, sector 42105711
end_request: I/O error, dev hdg, sector 42105719
end_request: I/O error, dev hdg, sector 42105727
end_request: I/O error, dev hdg, sector 42105735
end_request: I/O error, dev hdg, sector 42105743
end_request: I/O error, dev hdg, sector 42105751
end_request: I/O error, dev hdg, sector 42105759
end_request: I/O error, dev hdg, sector 42105767
end_request: I/O error, dev hdg, sector 42105775
end_request: I/O error, dev hdg, sector 42105783
end_request: I/O error, dev hdg, sector 42105791
end_request: I/O error, dev hdg, sector 42105799
end_request: I/O error, dev hdg, sector 42105807
end_request: I/O error, dev hdg, sector 42105815
end_request: I/O error, dev hdg, sector 42105823
end_request: I/O error, dev hdg, sector 42105831
end_request: I/O error, dev hdg, sector 42105839
end_request: I/O error, dev hdg, sector 42105847
end_request: I/O error, dev hdg, sector 42105855
end_request: I/O error, dev hdg, sector 42105863
end_request: I/O error, dev hdg, sector 42105871
end_request: I/O error, dev hdg, sector 42105879
end_request: I/O error, dev hdg, sector 42105887
end_request: I/O error, dev hdg, sector 42105895
end_request: I/O error, dev hdg, sector 42105903
end_request: I/O error, dev hdg, sector 42105911
end_request: I/O error, dev hdg, sector 42105919
end_request: I/O error, dev hdg, sector 42105927
end_request: I/O error, dev hdg, sector 42105935
end_request: I/O error, dev hdg, sector 42105943
end_request: I/O error, dev hdg, sector 42105951
end_request: I/O error, dev hdg, sector 42105959
end_request: I/O error, dev hdg, sector 42105967
end_request: I/O error, dev hdg, sector 42105975
end_request: I/O error, dev hdg, sector 42105983
end_request: I/O error, dev hdg, sector 42105991
end_request: I/O error, dev hdg, sector 42105999
end_request: I/O error, dev hdg, sector 42106007
end_request: I/O error, dev hdg, sector 42106015
end_request: I/O error, dev hdg, sector 42106023
end_request: I/O error, dev hdg, sector 42106031
end_request: I/O error, dev hdg, sector 42106039
end_request: I/O error, dev hdg, sector 42106047
end_request: I/O error, dev hdg, sector 42106055
end_request: I/O error, dev hdg, sector 42106063
end_request: I/O error, dev hdg, sector 42106071
end_request: I/O error, dev hdg, sector 42106079
end_request: I/O error, dev hdg, sector 42106087
end_request: I/O error, dev hdg, sector 42106095
end_request: I/O error, dev hdg, sector 42106103
end_request: I/O error, dev hdg, sector 42106111
end_request: I/O error, dev hdg, sector 42106119
end_request: I/O error, dev hdg, sector 42106127
end_request: I/O error, dev hdg, sector 42106135
end_request: I/O error, dev hdg, sector 42106143
end_request: I/O error, dev hdg, sector 42106151
end_request: I/O error, dev hdg, sector 42106159
end_request: I/O error, dev hdg, sector 42106167
end_request: I/O error, dev hdg, sector 42106175
end_request: I/O error, dev hdg, sector 42106183
end_request: I/O error, dev hdg, sector 42106191
end_request: I/O error, dev hdg, sector 42106199
end_request: I/O error, dev hdg, sector 42106207
end_request: I/O error, dev hdg, sector 42106215
end_request: I/O error, dev hdg, sector 42106223
end_request: I/O error, dev hdg, sector 42106231
end_request: I/O error, dev hdg, sector 42106239
end_request: I/O error, dev hdg, sector 42106247
end_request: I/O error, dev hdg, sector 42106255
end_request: I/O error, dev hdg, sector 42106263
end_request: I/O error, dev hdg, sector 42106271
end_request: I/O error, dev hdg, sector 42106279
end_request: I/O error, dev hdg, sector 42106287
end_request: I/O error, dev hdg, sector 42106295
end_request: I/O error, dev hdg, sector 42106303
end_request: I/O error, dev hdg, sector 42106311
end_request: I/O error, dev hdg, sector 42106319
end_request: I/O error, dev hdg, sector 42106327
end_request: I/O error, dev hdg, sector 42106335
end_request: I/O error, dev hdg, sector 42106343
end_request: I/O error, dev hdg, sector 42106351
end_request: I/O error, dev hdg, sector 42106359
end_request: I/O error, dev hdg, sector 42106367
end_request: I/O error, dev hdg, sector 42106375
end_request: I/O error, dev hdg, sector 42106383
end_request: I/O error, dev hdg, sector 42106391
end_request: I/O error, dev hdg, sector 42106399
end_request: I/O error, dev hdg, sector 42106407
ohci_hcd 0000:00:02.1: wakeup
usb 3-1: new low speed USB device using ohci_hcd and address 2
input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard] on usb-0000:00:02.1-1
hdf: dma_timer_expiry: dma status == 0x40
hdf: DMA timeout retry
PDC202XX: Primary channel reset.
PDC202XX: Secondary channel reset.
hdf: timeout waiting for DMA
md: md0: sync done.
Buffer I/O error on device md0, logical block 130883590
lost page write due to I/O error on md0
Aborting journal on device md0.
__journal_remove_journal_head: freeing b_committed_data
__journal_remove_journal_head: freeing b_committed_data
Buffer I/O error on device md0, logical block 87787912
lost page write due to I/O error on md0
__journal_remove_journal_head: freeing b_frozen_data
__journal_remove_journal_head: freeing b_frozen_data
ext3_abort called.
EXT3-fs error (device md0): ext3_journal_start_sb: Detected aborted journal
Remounting filesystem read-only
RAID5 conf printout:
 --- rd:4 wd:2 fd:2
 disk 0, o:1, dev:hda3
 disk 1, o:1, dev:hdc1
 disk 2, o:1, dev:hdf1
 disk 3, o:0, dev:hdg1
RAID5 conf printout:
 --- rd:4 wd:2 fd:2
 disk 0, o:1, dev:hda3
 disk 2, o:1, dev:hdf1
 disk 3, o:0, dev:hdg1
RAID5 conf printout:
 --- rd:4 wd:2 fd:2
 disk 0, o:1, dev:hda3
 disk 2, o:1, dev:hdf1
 disk 3, o:0, dev:hdg1
RAID5 conf printout:
 --- rd:4 wd:2 fd:2
 disk 0, o:1, dev:hda3
 disk 2, o:1, dev:hdf1
Buffer I/O error on device md0, logical block 0
lost page write due to I/O error on md0
Buffer I/O error on device md0, logical block 7
lost page write due to I/O error on md0
Buffer I/O error on device md0, logical block 9
lost page write due to I/O error on md0
Buffer I/O error on device md0, logical block 11
lost page write due to I/O error on md0
Buffer I/O error on device md0, logical block 7700502
lost page write due to I/O error on md0
Buffer I/O error on device md0, logical block 26214403
lost page write due to I/O error on md0
Buffer I/O error on device md0, logical block 26214405
lost page write due to I/O error on md0
Buffer I/O error on device md0, logical block 26214700
lost page write due to I/O error on md0
Buffer I/O error on device md0, logical block 26237371
lost page write due to I/O error on md0
Buffer I/O error on device md0, logical block 26247169
lost page write due to I/O error on md0
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=241 TOS=0x00 PREC=0x00 TTL=64 ID=21 DF PROTO=UDP SPT=138 DPT=138 LEN=221
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=233 TOS=0x00 PREC=0x00 TTL=64 ID=22 DF PROTO=UDP SPT=138 DPT=138 LEN=213
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677821, block=105349223
hde: cdrom_pc_intr: The drive appears confused (ireason = 0x01)
INC-DROP:IN=eth0 OUT= MAC=00:26:54:10:ed:5e:00:02:3b:01:ed:e6:08:00 SRC=69.12.242.2 DST=64.142.78.129 LEN=328 TOS=0x00 PREC=0x00 TTL=63 ID=0 DF PROTO=UDP SPT=67 DPT=68 LEN=308
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13109510, block=26214474
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13110142, block=26214493
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13117837, block=26214734
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13114962, block=26214644
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13109489, block=26214473
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13109342, block=26214468
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13110913, block=26214518
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13109825, block=26214484
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13111033, block=26214521
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13117471, block=26214722
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13110085, block=26214492
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13110911, block=26214517
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13122222, block=26214871
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13109776, block=26214482
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13118572, block=26214757
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13109412, block=26214471
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13109384, block=26214470
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13109779, block=26214482
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13118216, block=26214746
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13110546, block=26214506
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13119404, block=26214783
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13110143, block=26214493
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13113608, block=26214602
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13109652, block=26214478
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13109431, block=26214471
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=13109855, block=26214484
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682326, block=105349364
EXT3-fs error (device md0): ext3_find_entry: reading directory #52708744 offset 0
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=241 TOS=0x00 PREC=0x00 TTL=64 ID=23 DF PROTO=UDP SPT=138 DPT=138 LEN=221
INC-DROP:IN=eth0 OUT= MAC= SRC=64.142.78.129 DST=64.142.78.255 LEN=233 TOS=0x00 PREC=0x00 TTL=64 ID=24 DF PROTO=UDP SPT=138 DPT=138 LEN=213
printk: 71 messages suppressed.
Buffer I/O error on device md0, logical block 146518640
Buffer I/O error on device md0, logical block 146518640
end_request: I/O error, dev hdg, sector 390716735
Buffer I/O error on device hdg1, logical block 195358336
end_request: I/O error, dev hdg, sector 390716737
Buffer I/O error on device hdg1, logical block 195358337
end_request: I/O error, dev hdg, sector 390716739
Buffer I/O error on device hdg1, logical block 195358338
end_request: I/O error, dev hdg, sector 390716741
Buffer I/O error on device hdg1, logical block 195358339
end_request: I/O error, dev hdg, sector 390716735
Buffer I/O error on device hdg1, logical block 195358336
end_request: I/O error, dev hdg, sector 390716737
Buffer I/O error on device hdg1, logical block 195358337
end_request: I/O error, dev hdg, sector 390716739
Buffer I/O error on device hdg1, logical block 195358338
end_request: I/O error, dev hdg, sector 390716741
Buffer I/O error on device hdg1, logical block 195358339
EXT3-fs error (device md0): ext3_find_entry: reading directory #13140192 offset 0
EXT3-fs error (device md0): ext3_find_entry: reading directory #13140192 offset 0
hde: cdrom_pc_intr: The drive appears confused (ireason = 0x01)
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52759771, block=105513064
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682146, block=105349359
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=37801534, block=75595891
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52681978, block=105349353
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52689828, block=105349599
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52686189, block=105349485
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52689839, block=105349599
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685526, block=105349464
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52681630, block=105349342
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685035, block=105349449
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52681328, block=105349333
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690261, block=105349612
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682553, block=105349371
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677443, block=105349212
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690443, block=105349618
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682580, block=105349372
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52684950, block=105349446
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52686431, block=105349492
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677445, block=105349212
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52689733, block=105349596
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52689163, block=105349578
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52686265, block=105349487
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677091, block=105349201
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52686430, block=105349492
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52689861, block=105349600
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682275, block=105349363
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52676618, block=105349186
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677716, block=105349220
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677618, block=105349217
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677760, block=105349221
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685779, block=105349472
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690333, block=105349614
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52689814, block=105349598
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685378, block=105349460
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690323, block=105349614
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52681830, block=105349349
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677908, block=105349226
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52686154, block=105349484
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685130, block=105349452
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690213, block=105349611
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685151, block=105349452
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52676811, block=105349192
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690359, block=105349615
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690480, block=105349619
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52681764, block=105349347
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52678426, block=105349242
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677604, block=105349217
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677638, block=105349218
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682272, block=105349362
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677026, block=105349199
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677625, block=105349217
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682631, block=105349374
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52689160, block=105349578
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685622, block=105349467
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690128, block=105349608
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685525, block=105349464
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690667, block=105349625
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52689822, block=105349598
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690117, block=105349608
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690472, block=105349619
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685063, block=105349450
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52678496, block=105349244
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685325, block=105349458
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677021, block=105349198
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682589, block=105349372
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685494, block=105349463
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685524, block=105349464
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685167, block=105349453
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685545, block=105349465
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52681881, block=105349350
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682581, block=105349372
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682399, block=105349366
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685528, block=105349464
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52689784, block=105349597
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690335, block=105349614
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52681641, block=105349343
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690462, block=105349618
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690092, block=105349607
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52681371, block=105349334
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690444, block=105349618
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677871, block=105349225
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52689243, block=105349580
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677600, block=105349216
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52676823, block=105349192
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677719, block=105349220
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682079, block=105349356
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682365, block=105349365
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52678417, block=105349242
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677730, block=105349221
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690176, block=105349609
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52686122, block=105349483
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52689226, block=105349580
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677012, block=105349198
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52689815, block=105349598
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52686151, block=105349484
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52686266, block=105349487
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685319, block=105349458
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682317, block=105349364
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52678412, block=105349242
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52677583, block=105349216
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685851, block=105349474
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52690087, block=105349607
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52682179, block=105349360
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52681524, block=105349339
EXT3-fs error (device md0): ext3_get_inode_loc: unable to read inode block - inode=52685615, block=105349467


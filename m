From: Dexter Filmore <Dexter.Filmore@gmx.de>
Subject: degraded array after reboot *again*
Date: Mon, 28 Apr 2008 14:24:25 +0200
Message-ID: <200804281424.33558.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_BIcFIgDx/cwMd1s"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Boundary-00=_BIcFIgDx/cwMd1s
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

After migrating my file server from slackware to debian etch it has been=20
running flawlessly for weeks.

Now yesterday I moved from the 4x250-raid5 to 5x500.=20
The machine has two controller, *both* Silicon Image 3114, one onboard (Asu=
s=20
mobo), one on a PCI controller card.

The 4 drives sat on the onboard controller solely, for the 5 drive array I =
had=20
to use one of the PCI controller ports.

Synced the array, installed lvm2, some xfs, copied tha data, all seemed fin=
e.
Till I rebooted today.
Array degraded, one drive kicked. mdadm -E shows event count mismatch.

Now if anyone knows what to make of this, please replay. Since the onboard=
=20
controller and the card controller have the same chip they are handled by t=
he=20
same kernel module, so I wouldn't know how the external controller can be a=
n=20
issue.

Only thing I noticed: I use the 2.6.22 from etch-backports bcause 2.6.28=20
failed to see all partitions. The last message is about one disk not being=
=20
spun down properly and that I ought to update the shutdown utility.

Googling aroung I dug up this:

"As I said above, if you are very nervous, then the easiest complete fix is=
 to=20
downgrade your kernel (say to 2.6.18-5 from Etch). I'm not an expert on the=
=20
issue, but here's my rough understanding: the kernel (as of 2.6.22) issues =
a=20
shutdown sequence and the operating system also initiates a shutdown sequen=
ce=20
(as it always used to). The two overlapping sequences get f&*$%ed up (that'=
s=20
the technical term), and the system can (1) get told (by one side) to=20
spindown, (2) get a command (from the other side) that causes it to spin up=
=20
again and then (3) get a final command to shut down entirely (and=20
quickly?!?). The result is a hard change in direction that can cause a=20
noticeable clunk on some drives. You do that enough times and your drive is=
=20
f&*$%ed. However, a few people on a kernel irc channel said that "enough=20
times" means in the hundreds. "

=46rom=20
http://www.linuxquestions.org/questions/debian-26/disk-might-not-be-spun-do=
wn-properly.-update-shutdown-utility-583307/

Never was an issue tho with the 4-drive-array.


Attached: mdadm -E from before the resync and the current dmesg.



=2D-=20
=2D----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@=20
b++(+++) DI+++ D- G++ e* h>++ r* y?
=2D-----END GEEK CODE BLOCK------

http://www.vorratsdatenspeicherung.de

--Boundary-00=_BIcFIgDx/cwMd1s
Content-Type: text/plain;
  charset="us-ascii";
  name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg"

Linux version 2.6.22-4-k7 (Debian 2.6.22-6~bpo40+2) (nobse@debian.org) (gcc version 4.1.2 20061115 (prerelease) (Debian 4.1.1-21)) #1 SMP Tue Feb 12 17:54:42 UTC 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
 BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000003ffc0000 (usable)
 BIOS-e820: 000000003ffc0000 - 000000003ffd0000 (ACPI data)
 BIOS-e820: 000000003ffd0000 - 0000000040000000 (ACPI NVS)
 BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
 BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
 BIOS-e820: 00000000ff7c0000 - 0000000100000000 (reserved)
127MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
Entering add_active_range(0, 0, 262080) 0 entries of 256 used
Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   262080
early_node_map[1] active PFN ranges
    0:        0 ->   262080
On node 0 totalpages: 262080
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 255 pages used for memmap
  HighMem zone: 32449 pages, LIFO batch:7
DMI 2.3 present.
ACPI: RSDP 000F9CB0, 0014 (r0 ACPIAM)
ACPI: RSDT 3FFC0000, 0030 (r1 A M I  OEMRSDT   9000507 MSFT       97)
ACPI: FACP 3FFC0200, 0081 (r2 A M I  OEMFACP   9000507 MSFT       97)
ACPI: DSDT 3FFC0400, 4524 (r1  A0055 A0055003        3 INTL  2002026)
ACPI: FACS 3FFD0000, 0040
ACPI: APIC 3FFC0390, 0068 (r1 A M I  OEMAPIC   9000507 MSFT       97)
ACPI: OEMB 3FFD0040, 0041 (r1 A M I  OEMBIOS   9000507 MSFT       97)
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 16
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: BIOS IRQ0 pin2 override ignored.
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: INT_SRC_OVR (bus 0 bus_irq 14 global_irq 14 high edge)
ACPI: INT_SRC_OVR (bus 0 bus_irq 15 global_irq 15 high edge)
ACPI: IRQ9 used by override.
ACPI: IRQ14 used by override.
ACPI: IRQ15 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 50000000 (gap: 40000000:bec00000)
Built 1 zonelists.  Total pages: 260033
Kernel command line: root=/dev/hda6 ro 
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 2210.761 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 1030608k/1048320k available (1706k kernel code, 17004k reserved, 663k data, 244k init, 130816k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4e000 - 0xfffff000   ( 708 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0357000 - 0xc0394000   ( 244 kB)
      .data : 0xc02aa817 - 0xc0350784   ( 663 kB)
      .text : 0xc0100000 - 0xc02aa817   (1706 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 4424.32 BogoMIPS (lpj=8848644)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: 078bfbff e1d3fbff 00000000 00000000 00000000 00000000 00000000
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU: After all inits, caps: 078bfbff e1d3fbff 00000000 00000410 00000000 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
Freeing SMP alternatives: 11k freed
ACPI: Core revision 20070126
CPU0: AMD Athlon(tm) 64 Processor 3400+ stepping 08
Total of 1 processors activated (4424.32 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
Brought up 1 CPUs
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=2
PCI: Using configuration type 1
Setting up standard PCI resources
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LNKB] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LNKC] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LNKD] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LNKE] (IRQs 16 17 18 19) *11
ACPI: PCI Interrupt Link [LUS0] (IRQs 20 21 22) *11
ACPI: PCI Interrupt Link [LUS1] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LUS2] (IRQs 20 21 22) *10
ACPI: PCI Interrupt Link [LKLN] (IRQs 20 21 22) *9
ACPI: PCI Interrupt Link [LAUI] (IRQs 20 21 22) *10
ACPI: PCI Interrupt Link [LKMO] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LKSM] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LTID] (IRQs 20 21 22) *0
ACPI: PCI Interrupt Link [LTIE] (IRQs 20 21 22) *0, disabled.
ACPI: PCI Interrupt Link [LATA] (IRQs 20 21 22) *14
ACPI: Power Resource [ISAV] (on)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
ACPI: RTC can wake from S4
pnp: 00:09: iomem range 0xfec00000-0xfec00fff could not be reserved
pnp: 00:09: iomem range 0xfee00000-0xfeefffff could not be reserved
pnp: 00:09: iomem range 0xff780000-0xff7bffff has been reserved
pnp: 00:0b: ioport range 0x480-0x487 has been reserved
pnp: 00:0b: ioport range 0xd00-0xd07 has been reserved
pnp: 00:0e: iomem range 0x0-0x9ffff could not be reserved
pnp: 00:0e: iomem range 0xc0000-0xdffff could not be reserved
pnp: 00:0e: iomem range 0xe0000-0xfffff could not be reserved
pnp: 00:0e: iomem range 0x100000-0x3fffffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Bridge: 0000:00:0b.0
  IO window: disabled.
  MEM window: fd700000-fe7fffff
  PREFETCH window: f1600000-f55fffff
PCI: Bridge: 0000:00:0e.0
  IO window: 8000-bfff
  MEM window: fe800000-feafffff
  PREFETCH window: disabled.
PCI: Setting latency timer of device 0000:00:0e.0 to 64
NET: Registered protocol family 2
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 4985k freed
audit: initializing netlink socket (disabled)
audit(1209388237.180:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
Boot video device is 0000:01:00.0
isapnp: Scanning for PnP cards...
Switched to high resolution mode on CPU 0
isapnp: No Plug & Play device found
Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
00:0c: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:0d: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
Freeing unused kernel memory: 244k freed
input: AT Translated Set 2 keyboard as /class/input/input0
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [LUS0] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:02.0[A] -> Link [LUS0] -> GSI 22 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:02.0 to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:02.0: irq 16, io mem 0xfebfd000
forcedeth.c: Reverse Engineered nForce ethernet driver. Version 0.60.
SCSI subsystem initialized
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 4 ports detected
libata version 2.21 loaded.
ACPI: PCI Interrupt Link [LUS1] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:02.1[B] -> Link [LUS1] -> GSI 21 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:02.1 to 64
ohci_hcd 0000:00:02.1: OHCI Host Controller
ohci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.1: irq 17, io mem 0xfebfe000
8139too Fast Ethernet driver 0.9.28
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 4 ports detected
ACPI: PCI Interrupt Link [LUS2] enabled at IRQ 20
ACPI: PCI Interrupt 0000:00:02.2[C] -> Link [LUS2] -> GSI 20 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:02.2 to 64
ehci_hcd 0000:00:02.2: EHCI Host Controller
ehci_hcd 0000:00:02.2: new USB bus registered, assigned bus number 3
ehci_hcd 0000:00:02.2: debug port 1
PCI: cache line size of 64 is not supported by device 0000:00:02.2
ehci_hcd 0000:00:02.2: irq 18, io mem 0xfebffc00
ehci_hcd 0000:00:02.2: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 8 ports detected
ACPI: PCI Interrupt Link [LKLN] enabled at IRQ 22
ACPI: PCI Interrupt 0000:00:05.0[A] -> Link [LKLN] -> GSI 22 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:05.0 to 64
eth0: forcedeth.c: subsystem: 01043:80a7 bound to 0000:00:05.0
sata_nv 0000:00:0a.0: version 3.4
ACPI: PCI Interrupt Link [LTID] BIOS reported IRQ 0, using IRQ 21
ACPI: PCI Interrupt Link [LTID] enabled at IRQ 21
ACPI: PCI Interrupt 0000:00:0a.0[A] -> Link [LTID] -> GSI 21 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:0a.0 to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x000109f0 ctl 0x00010bf2 bmdma 0x0001c800 irq 17
ata2: SATA max UDMA/133 cmd 0x00010970 ctl 0x00010b72 bmdma 0x0001c808 irq 17
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ata1: SATA link down (SStatus 0 SControl 300)
ata2: SATA link down (SStatus 0 SControl 300)
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 19
ACPI: PCI Interrupt 0000:02:07.0[A] -> Link [LNKB] -> GSI 19 (level, low) -> IRQ 19
eth0: RealTek RTL8139 at 0xb800, 00:e0:7d:7d:53:b1, IRQ 19
eth0:  Identified 8139 chip type 'RTL-8139B'
sata_sil 0000:02:09.0: version 2.2
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 18
ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKD] -> GSI 18 (level, low) -> IRQ 20
scsi2 : sata_sil
scsi3 : sata_sil
scsi4 : sata_sil
scsi5 : sata_sil
ata3: SATA max UDMA/100 cmd 0xf8840880 ctl 0xf884088a bmdma 0xf8840800 irq 20
ata4: SATA max UDMA/100 cmd 0xf88408c0 ctl 0xf88408ca bmdma 0xf8840808 irq 20
ata5: SATA max UDMA/100 cmd 0xf8840a80 ctl 0xf8840a8a bmdma 0xf8840a00 irq 20
ata6: SATA max UDMA/100 cmd 0xf8840ac0 ctl 0xf8840aca bmdma 0xf8840a08 irq 20
8139cp: 10/100 PCI Ethernet driver v1.3 (Mar 22, 2004)
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata3.00: ATA-8: SAMSUNG HD501LJ, CR100-13, max UDMA7
ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/100
ata4: SATA link down (SStatus 0 SControl 310)
ata5: SATA link down (SStatus 0 SControl 310)
ata6: SATA link down (SStatus 0 SControl 310)
scsi 2:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 17
ACPI: PCI Interrupt 0000:02:0c.0[A] -> Link [LNKC] -> GSI 17 (level, low) -> IRQ 21
scsi6 : sata_sil
scsi7 : sata_sil
scsi8 : sata_sil
scsi9 : sata_sil
ata7: SATA max UDMA/100 cmd 0xf88fac80 ctl 0xf88fac8a bmdma 0xf88fac00 irq 21
ata8: SATA max UDMA/100 cmd 0xf88facc0 ctl 0xf88facca bmdma 0xf88fac08 irq 21
ata9: SATA max UDMA/100 cmd 0xf88fae80 ctl 0xf88fae8a bmdma 0xf88fae00 irq 21
ata10: SATA max UDMA/100 cmd 0xf88faec0 ctl 0xf88faeca bmdma 0xf88fae08 irq 21
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata7.00: ATA-8: SAMSUNG HD501LJ, CR100-13, max UDMA7
ata7.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata7.00: configured for UDMA/100
ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata8.00: ATA-8: SAMSUNG HD501LJ, CR100-13, max UDMA7
ata8.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata8.00: configured for UDMA/100
ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata9.00: ATA-8: SAMSUNG HD501LJ, CR100-13, max UDMA7
ata9.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata9.00: configured for UDMA/100
ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata10.00: ATA-8: SAMSUNG HD501LJ, CR100-13, max UDMA7
ata10.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata10.00: configured for UDMA/100
scsi 6:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
scsi 7:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
scsi 8:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
scsi 9:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
ACPI: PCI Interrupt 0000:02:0b.0[A] -> Link [LNKB] -> GSI 19 (level, low) -> IRQ 19
NFORCE3-250: IDE controller at PCI slot 0000:00:08.0
NFORCE3-250: chipset revision 162
NFORCE3-250: not 100% native mode: will probe irqs later
NFORCE3-250: BIOS didn't set cable bits correctly. Enabling workaround.
NFORCE3-250: 0000:00:08.0 (rev a2) UDMA133 controller
    ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:DMA
Probing IDE interface ide0...
sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 2:0:0:0: [sda] Attached SCSI disk
sd 6:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb:<5>firewire_ohci: Added fw-ohci device 0000:02:0b.0, OHCI version 1.0
 sdb1
sd 6:0:0:0: [sdb] Attached SCSI disk
sd 7:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 7:0:0:0: [sdc] Write Protect is off
sd 7:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 7:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 7:0:0:0: [sdc] Write Protect is off
sd 7:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 7:0:0:0: [sdc] Attached SCSI disk
sd 8:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 8:0:0:0: [sdd] Write Protect is off
sd 8:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 8:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 8:0:0:0: [sdd] Write Protect is off
sd 8:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1
sd 8:0:0:0: [sdd] Attached SCSI disk
sd 9:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 9:0:0:0: [sde] Write Protect is off
sd 9:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 9:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 9:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 9:0:0:0: [sde] Write Protect is off
sd 9:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 9:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1
sd 9:0:0:0: [sde] Attached SCSI disk
hda: SAMSUNG SP1604N, ATA DISK drive
firewire_core: created new fw device fw0 (0 config rom retries)
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdd: LITE-ON DVD SOHD-16P9S, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 512KiB
hda: 312581808 sectors (160041 MB) w/2048KiB Cache, CHS=19457/255/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda4 < hda5 hda6 hda7 >
hdd: ATAPI 48X DVD-ROM drive, 254kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  6635.000 MB/sec
raid5: using function: pIII_sse (6635.000 MB/sec)
raid6: int32x1    826 MB/s
raid6: int32x2    933 MB/s
raid6: int32x4    834 MB/s
raid6: int32x8    501 MB/s
raid6: mmxx1     1803 MB/s
raid6: mmxx2     3290 MB/s
raid6: sse1x1    1630 MB/s
raid6: sse1x2    2787 MB/s
raid6: sse2x1    2773 MB/s
raid6: sse2x2    3745 MB/s
raid6: using algorithm sse2x2 (3745 MB/s)
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
md: md0 stopped.
md: bind<sda1>
md: bind<sdd1>
md: bind<sdb1>
md: bind<sdc1>
md: kicking non-fresh sdb1 from array!
md: unbind<sdb1>
md: export_rdev(sdb1)
raid5: device sdc1 operational as raid disk 1
raid5: device sdd1 operational as raid disk 3
raid5: device sda1 operational as raid disk 2
raid5: not enough operational devices for md1 (2/5 failed)
RAID5 conf printout:
 --- rd:5 wd:3
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sda1
 disk 3, o:1, dev:sdd1
raid5: failed to run raid set md1
md: pers->run() failed ...
Attempting manual resume
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
Linux agpgart interface v0.102 (c) Dave Jones
agpgart: Detected AGP bridge 0
agpgart: Setting up Nforce3 AGP.
agpgart: aperture base > 4G
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x5000
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x5040
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
input: PC Speaker as /class/input/input1
FDC 0 is a post-1991 82077
parport_pc 00:06: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE,EPP]
Real Time Clock Driver v1.12ac
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 16
ACPI: PCI Interrupt 0000:02:0a.0[A] -> Link [LNKA] -> GSI 16 (level, low) -> IRQ 22
tmpfs: No value for mount option 'default'
Adding 996020k swap on /dev/hda2.  Priority:-1 extents:1 across:996020k
EXT3 FS on hda6, internal journal
loop: module loaded
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
fuse init (API version 7.8)
tmpfs: No value for mount option 'default'
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on hda5, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3-fs warning: maximal mount count reached, running e2fsck is recommended
EXT3 FS on hda7, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SGI XFS with ACLs, security attributes, realtime, large block numbers, no debug enabled
SGI XFS Quota Management subsystem
eth2: link up, 100Mbps, full-duplex, lpa 0x41E1
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: starting 90-second grace period
[drm] Initialized drm 1.1.0 20060810
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 19
ACPI: PCI Interrupt 0000:01:00.0[A] -> Link [LNKE] -> GSI 19 (level, low) -> IRQ 19
[drm] Initialized mga 3.2.1 20051102 on minor 0
[drm:mga_do_agp_dma_bootstrap] *ERROR* Unable to acquire AGP: -19
[drm] Initialized card for PCI DMA.
eth2: no IPv6 routers present
md: md1 stopped.
md: unbind<sdc1>
md: export_rdev(sdc1)
md: unbind<sdd1>
md: export_rdev(sdd1)
md: unbind<sda1>
md: export_rdev(sda1)
md: md1 stopped.
md: md0 stopped.
md: md0 stopped.
ata7.00: disabled
sd 6:0:0:0: [sdb] Synchronizing SCSI cache
sd 6:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
sd 6:0:0:0: [sdb] Stopping disk
sd 6:0:0:0: [sdb] START_STOP FAILED
sd 6:0:0:0: [sdb] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
ata8.00: disabled
sd 7:0:0:0: [sdc] Synchronizing SCSI cache
sd 7:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
sd 7:0:0:0: [sdc] Stopping disk
sd 7:0:0:0: [sdc] START_STOP FAILED
sd 7:0:0:0: [sdc] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
ata9.00: disabled
sd 8:0:0:0: [sdd] Synchronizing SCSI cache
sd 8:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
sd 8:0:0:0: [sdd] Stopping disk
sd 8:0:0:0: [sdd] START_STOP FAILED
sd 8:0:0:0: [sdd] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
ata10.00: disabled
sd 9:0:0:0: [sde] Synchronizing SCSI cache
sd 9:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
sd 9:0:0:0: [sde] Stopping disk
sd 9:0:0:0: [sde] START_STOP FAILED
sd 9:0:0:0: [sde] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
ACPI: PCI interrupt for device 0000:02:0c.0 disabled
ata3.00: disabled
sd 2:0:0:0: [sda] Synchronizing SCSI cache
sd 2:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
sd 2:0:0:0: [sda] Stopping disk
sd 2:0:0:0: [sda] START_STOP FAILED
sd 2:0:0:0: [sda] Result: hostbyte=DID_BAD_TARGET driverbyte=DRIVER_OK,SUGGEST_OK
ACPI: PCI interrupt for device 0000:02:09.0 disabled
sata_sil 0000:02:09.0: version 2.2
ACPI: PCI Interrupt 0000:02:09.0[A] -> Link [LNKD] -> GSI 18 (level, low) -> IRQ 20
scsi10 : sata_sil
scsi11 : sata_sil
scsi12 : sata_sil
scsi13 : sata_sil
ata11: SATA max UDMA/100 cmd 0xf88fa880 ctl 0xf88fa88a bmdma 0xf88fa800 irq 20
ata12: SATA max UDMA/100 cmd 0xf88fa8c0 ctl 0xf88fa8ca bmdma 0xf88fa808 irq 20
ata13: SATA max UDMA/100 cmd 0xf88faa80 ctl 0xf88faa8a bmdma 0xf88faa00 irq 20
ata14: SATA max UDMA/100 cmd 0xf88faac0 ctl 0xf88faaca bmdma 0xf88faa08 irq 20
ata11: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata11.00: ATA-8: SAMSUNG HD501LJ, CR100-13, max UDMA7
ata11.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata11.00: configured for UDMA/100
ata12: SATA link down (SStatus 0 SControl 310)
ata13: SATA link down (SStatus 0 SControl 310)
ata14: SATA link down (SStatus 0 SControl 310)
scsi 10:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 10:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 10:0:0:0: [sda] Write Protect is off
sd 10:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 10:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 10:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 10:0:0:0: [sda] Write Protect is off
sd 10:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 10:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1
sd 10:0:0:0: [sda] Attached SCSI disk
ACPI: PCI Interrupt 0000:02:0c.0[A] -> Link [LNKC] -> GSI 17 (level, low) -> IRQ 21
scsi14 : sata_sil
scsi15 : sata_sil
scsi16 : sata_sil
scsi17 : sata_sil
ata15: SATA max UDMA/100 cmd 0xf8a08c80 ctl 0xf8a08c8a bmdma 0xf8a08c00 irq 21
ata16: SATA max UDMA/100 cmd 0xf8a08cc0 ctl 0xf8a08cca bmdma 0xf8a08c08 irq 21
ata17: SATA max UDMA/100 cmd 0xf8a08e80 ctl 0xf8a08e8a bmdma 0xf8a08e00 irq 21
ata18: SATA max UDMA/100 cmd 0xf8a08ec0 ctl 0xf8a08eca bmdma 0xf8a08e08 irq 21
ata15: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata15.00: ATA-8: SAMSUNG HD501LJ, CR100-13, max UDMA7
ata15.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata15.00: configured for UDMA/100
ata16: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata16.00: ATA-8: SAMSUNG HD501LJ, CR100-13, max UDMA7
ata16.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata16.00: configured for UDMA/100
ata17: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata17.00: ATA-8: SAMSUNG HD501LJ, CR100-13, max UDMA7
ata17.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata17.00: configured for UDMA/100
ata18: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata18.00: ATA-8: SAMSUNG HD501LJ, CR100-13, max UDMA7
ata18.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata18.00: configured for UDMA/100
scsi 14:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 14:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 14:0:0:0: [sdb] Write Protect is off
sd 14:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 14:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 14:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 14:0:0:0: [sdb] Write Protect is off
sd 14:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 14:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1
sd 14:0:0:0: [sdb] Attached SCSI disk
scsi 15:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 15:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 15:0:0:0: [sdc] Write Protect is off
sd 15:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 15:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 15:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 15:0:0:0: [sdc] Write Protect is off
sd 15:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 15:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdc: sdc1
sd 15:0:0:0: [sdc] Attached SCSI disk
scsi 16:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 16:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 16:0:0:0: [sdd] Write Protect is off
sd 16:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 16:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 16:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 16:0:0:0: [sdd] Write Protect is off
sd 16:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 16:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdd: sdd1
sd 16:0:0:0: [sdd] Attached SCSI disk
scsi 17:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
sd 17:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 17:0:0:0: [sde] Write Protect is off
sd 17:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 17:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 17:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 17:0:0:0: [sde] Write Protect is off
sd 17:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 17:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sde: sde1
sd 17:0:0:0: [sde] Attached SCSI disk
md: md0 stopped.
md: md0 stopped.
md: bind<sdc1>
md: bind<sda1>
md: bind<sdd1>
md: bind<sdb1>
md: bind<sde1>
md: kicking non-fresh sdb1 from array!
md: unbind<sdb1>
md: export_rdev(sdb1)
raid5: device sde1 operational as raid disk 0
raid5: device sdd1 operational as raid disk 3
raid5: device sda1 operational as raid disk 2
raid5: device sdc1 operational as raid disk 1
raid5: allocated 5245kB for md0
raid5: raid level 5 set md0 active with 4 out of 5 devices, algorithm 2
RAID5 conf printout:
 --- rd:5 wd:4
 disk 0, o:1, dev:sde1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sda1
 disk 3, o:1, dev:sdd1
Filesystem "dm-3": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-3
Ending clean XFS mount for filesystem: dm-3
Filesystem "dm-0": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-0
Ending clean XFS mount for filesystem: dm-0
Filesystem "dm-1": Disabling barriers, not supported by the underlying device
XFS mounting filesystem dm-1
Ending clean XFS mount for filesystem: dm-1
md: bind<sdb1>
RAID5 conf printout:
 --- rd:5 wd:4
 disk 0, o:1, dev:sde1
 disk 1, o:1, dev:sdc1
 disk 2, o:1, dev:sda1
 disk 3, o:1, dev:sdd1
 disk 4, o:1, dev:sdb1
md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
md: using 128k window, over a total of 488375872 blocks.

--Boundary-00=_BIcFIgDx/cwMd1s
Content-Type: text/plain;
  charset="us-ascii";
  name="mdadmE_sdb1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mdadmE_sdb1"

/dev/sdb1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 0da5ab7c:9b3bed33:1a2f1fdb:e5d6e62a
  Creation Time : Sat Apr 26 16:56:06 2008
     Raid Level : raid5
    Device Size : 488375872 (465.75 GiB 500.10 GB)
     Array Size : 1953503488 (1863.01 GiB 2000.39 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 1

    Update Time : Mon Apr 28 12:22:54 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : ff58f515 - correct
         Events : 0.3048

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8       17        1      active sync   /dev/sdb1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       0        0        4      faulty removed

--Boundary-00=_BIcFIgDx/cwMd1s
Content-Type: text/plain;
  charset="us-ascii";
  name="mdadmE_sda1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mdadmE_sda1"

/dev/sda1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 0da5ab7c:9b3bed33:1a2f1fdb:e5d6e62a
  Creation Time : Sat Apr 26 16:56:06 2008
     Raid Level : raid5
    Device Size : 488375872 (465.75 GiB 500.10 GB)
     Array Size : 1953503488 (1863.01 GiB 2000.39 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 1

    Update Time : Mon Apr 28 12:22:54 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : ff58f503 - correct
         Events : 0.3048

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8        1        0      active sync   /dev/sda1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       0        0        4      faulty removed

--Boundary-00=_BIcFIgDx/cwMd1s
Content-Type: text/plain;
  charset="us-ascii";
  name="mdadmE_sdc1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mdadmE_sdc1"

/dev/sdc1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 0da5ab7c:9b3bed33:1a2f1fdb:e5d6e62a
  Creation Time : Sat Apr 26 16:56:06 2008
     Raid Level : raid5
    Device Size : 488375872 (465.75 GiB 500.10 GB)
     Array Size : 1953503488 (1863.01 GiB 2000.39 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 1

    Update Time : Mon Apr 28 12:22:54 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : ff58f527 - correct
         Events : 0.3048

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     2       8       33        2      active sync   /dev/sdc1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       0        0        4      faulty removed

--Boundary-00=_BIcFIgDx/cwMd1s
Content-Type: text/plain;
  charset="us-ascii";
  name="mdadmE_sde1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mdadmE_sde1"

/dev/sde1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 0da5ab7c:9b3bed33:1a2f1fdb:e5d6e62a
  Creation Time : Sat Apr 26 16:56:06 2008
     Raid Level : raid5
    Device Size : 488375872 (465.75 GiB 500.10 GB)
     Array Size : 1953503488 (1863.01 GiB 2000.39 GB)
   Raid Devices : 5
  Total Devices : 5
Preferred Minor : 1

    Update Time : Mon Apr 28 04:09:04 2008
          State : clean
 Active Devices : 5
Working Devices : 5
 Failed Devices : 0
  Spare Devices : 0
       Checksum : ff5881bd - correct
         Events : 0.3036

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       65        4      active sync   /dev/sde1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       8       65        4      active sync   /dev/sde1

--Boundary-00=_BIcFIgDx/cwMd1s
Content-Type: text/plain;
  charset="us-ascii";
  name="mdadmE_sdd1"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="mdadmE_sdd1"

/dev/sdd1:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 0da5ab7c:9b3bed33:1a2f1fdb:e5d6e62a
  Creation Time : Sat Apr 26 16:56:06 2008
     Raid Level : raid5
    Device Size : 488375872 (465.75 GiB 500.10 GB)
     Array Size : 1953503488 (1863.01 GiB 2000.39 GB)
   Raid Devices : 5
  Total Devices : 4
Preferred Minor : 1

    Update Time : Mon Apr 28 12:22:54 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 1
  Spare Devices : 0
       Checksum : ff58f539 - correct
         Events : 0.3048

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     3       8       49        3      active sync   /dev/sdd1

   0     0       8        1        0      active sync   /dev/sda1
   1     1       8       17        1      active sync   /dev/sdb1
   2     2       8       33        2      active sync   /dev/sdc1
   3     3       8       49        3      active sync   /dev/sdd1
   4     4       0        0        4      faulty removed

--Boundary-00=_BIcFIgDx/cwMd1s--

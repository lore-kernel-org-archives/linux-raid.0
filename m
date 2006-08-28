From: "Andreas Pelzner" <Andreas.Pelzner@aixvision.net>
Subject: RE: md: only binds to one mirror after reboot
Date: Mon, 28 Aug 2006 07:14:10 +0200
Message-ID: <C05CC316E92A964C9BDD81EE36AE05343C7071@x2k3.a-team.ihs>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Pls. find the kernel messages here.
Andreas Pelzner

Aug 23 22:44:48 isp kernel: Kernel logging (proc) stopped.
Aug 23 22:44:48 isp kernel: Kernel log daemon terminating.
Aug 23 22:45:55 isp kernel: klogd 1.4.1#17, log source = /proc/kmsg
started.
Aug 23 22:45:55 isp kernel: Inspecting /boot/System.map-2.6.17.8
Aug 23 22:45:55 isp kernel: Loaded 27046 symbols from
/boot/System.map-2.6.17.8.
Aug 23 22:45:55 isp kernel: Symbols match kernel version 2.6.17.
Aug 23 22:45:55 isp kernel: No module symbols loaded - kernel modules
not enabled. 
Aug 23 22:45:55 isp kernel: 0100000 - 000000001fef0000 (usable)
Aug 23 22:45:55 isp kernel:  BIOS-e820: 000000001fef0000 -
000000001fef8000 (ACPI data)
Aug 23 22:45:55 isp kernel:  BIOS-e820: 000000001fef8000 -
000000001ff00000 (ACPI NVS)
Aug 23 22:45:55 isp kernel:  BIOS-e820: 00000000fec00000 -
00000000fec01000 (reserved)
Aug 23 22:45:55 isp kernel:  BIOS-e820: 00000000fee00000 -
00000000fee01000 (reserved)
Aug 23 22:45:55 isp kernel:  BIOS-e820: 00000000ffb00000 -
00000000ffc00000 (reserved)
Aug 23 22:45:55 isp kernel:  BIOS-e820: 00000000fff00000 -
0000000100000000 (reserved)
Aug 23 22:45:55 isp kernel: 510MB LOWMEM available.
Aug 23 22:45:55 isp kernel: found SMP MP-table at 000fb820
Aug 23 22:45:55 isp kernel: DMI 2.3 present.
Aug 23 22:45:55 isp kernel: ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00]
enabled)
Aug 23 22:45:55 isp kernel: Processor #0 15:2 APIC version 20
Aug 23 22:45:55 isp kernel: ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01]
disabled)
Aug 23 22:45:55 isp kernel: ACPI: IOAPIC (id[0x02] address[0xfec00000]
gsi_base[0])
Aug 23 22:45:55 isp kernel: IOAPIC[0]: apic_id 2, version 32, address
0xfec00000, GSI 0-23
Aug 23 22:45:55 isp kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 0
global_irq 2 dfl dfl)
Aug 23 22:45:55 isp kernel: ACPI: INT_SRC_OVR (bus 0 bus_irq 9
global_irq 9 high level)
Aug 23 22:45:55 isp kernel: Enabling APIC mode:  Flat.  Using 1 I/O
APICs
Aug 23 22:45:55 isp kernel: Using ACPI (MADT) for SMP configuration
information
Aug 23 22:45:55 isp kernel: Allocating PCI resources starting at
20000000 (gap: 1ff00000:ded00000)
Aug 23 22:45:55 isp kernel: Built 1 zonelists
Aug 23 22:45:55 isp kernel: Kernel command line: root=/dev/md0
md=0,/dev/hda1,/dev/hdb1 ro 
Aug 23 22:45:55 isp kernel: Enabling fast FPU save and restore... done.
Aug 23 22:45:55 isp kernel: Enabling unmasked SIMD FPU exception
support... done.
Aug 23 22:45:55 isp kernel: Initializing CPU#0
Aug 23 22:45:55 isp kernel: PID hash table entries: 2048 (order: 11,
8192 bytes)
Aug 23 22:45:55 isp kernel: Detected 2261.423 MHz processor.
Aug 23 22:45:55 isp kernel: Using tsc for high-res timesource
Aug 23 22:45:55 isp kernel: Console: colour VGA+ 80x25
Aug 23 22:45:55 isp kernel: Dentry cache hash table entries: 65536
(order: 6, 262144 bytes)
Aug 23 22:45:55 isp kernel: Inode-cache hash table entries: 32768
(order: 5, 131072 bytes)
Aug 23 22:45:55 isp kernel: Memory: 510732k/523200k available (1958k
kernel code, 11864k reserved, 870k data, 404k init, 0k highmem)
Aug 23 22:45:55 isp kernel: Checking if this processor honours the WP
bit even in supervisor mode... Ok.
Aug 23 22:45:55 isp kernel: Calibrating delay using timer specific
routine.. 4528.58 BogoMIPS (lpj=9057178)
Aug 23 22:45:55 isp kernel: Security Framework v1.0.0 initialized
Aug 23 22:45:55 isp kernel: Mount-cache hash table entries: 512
Aug 23 22:45:55 isp kernel: CPU: Trace cache: 12K uops, L1 D cache: 8K
Aug 23 22:45:55 isp kernel: CPU: L2 cache: 512K
Aug 23 22:45:55 isp kernel: CPU: Intel(R) Pentium(R) 4 CPU 2.26GHz
stepping 09
Aug 23 22:45:55 isp kernel: Checking 'hlt' instruction... OK.
Aug 23 22:45:55 isp kernel: Checking for popad bug... OK.
Aug 23 22:45:55 isp kernel: SMP alternatives: switching to UP code
Aug 23 22:45:55 isp kernel: Freeing SMP alternatives: 0k freed
Aug 23 22:45:55 isp kernel:  tbxface-0109 [02] load_tables           :
ACPI Tables successfully acquired
Aug 23 22:45:55 isp kernel: Parsing all Control Methods:
Aug 23 22:45:55 isp kernel: Table [DSDT](id 0005) - 473 Objects with 44
Devices 153 Methods 14 Regions
Aug 23 22:45:55 isp kernel: ACPI Namespace successfully loaded at root
c0449990
Aug 23 22:45:55 isp kernel: evxfevnt-0091 [03] enable                :
Transition to ACPI mode successful
Aug 23 22:45:55 isp kernel: ENABLING IO-APIC IRQs
Aug 23 22:45:55 isp kernel: ..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1
pin2=-1
Aug 23 22:45:55 isp kernel: checking if image is initramfs...it isn't
(bad gzip magic numbers); looks like an initrd
Aug 23 22:45:55 isp kernel: Freeing initrd memory: 3916k freed
Aug 23 22:45:55 isp kernel: NET: Registered protocol family 16
Aug 23 22:45:55 isp kernel: EISA bus registered
Aug 23 22:45:55 isp kernel: ACPI: bus type pci registered
Aug 23 22:45:55 isp kernel: PCI: PCI BIOS revision 2.10 entry at
0xfdb51, last bus=3
Aug 23 22:45:55 isp kernel: Setting up standard PCI resources
Aug 23 22:45:55 isp kernel: ACPI: Subsystem revision 20060127
Aug 23 22:45:55 isp kernel: evgpeblk-0941 [06] ev_create_gpe_block   :
GPE 00 to 1F [_GPE] 4 regs on int 0x9
Aug 23 22:45:55 isp kernel: evgpeblk-1037 [05] ev_initialize_gpe_bloc:
Found 7 Wake, Enabled 0 Runtime GPEs in this block
Aug 23 22:45:55 isp kernel: Completing Region/Field/Buffer/Package
initialization:.........................................................
........................
Aug 23 22:45:55 isp kernel: Initialized 14/14 Regions 7/7 Fields 49/49
Buffers 11/18 Packages (482 nodes)
Aug 23 22:45:55 isp kernel: Executing all Device _STA and_INI
methods:................................................
Aug 23 22:45:55 isp kernel: 48 Devices found - executed 0 _STA, 1 _INI
methods
Aug 23 22:45:55 isp kernel: ACPI: Interpreter enabled
Aug 23 22:45:55 isp kernel: ACPI: Using IOAPIC for interrupt routing
Aug 23 22:45:55 isp kernel: ACPI: PCI Root Bridge [PCI0] (0000:00)
Aug 23 22:45:55 isp kernel: PCI quirk: region 0800-087f claimed by ICH4
ACPI/GPIO/TCO
Aug 23 22:45:55 isp kernel: PCI quirk: region 0400-043f claimed by ICH4
GPIO
Aug 23 22:45:55 isp kernel: PCI: Ignoring BAR0-3 of IDE controller
0000:00:1f.1
Aug 23 22:45:55 isp kernel: PCI: Transparent bridge - 0000:00:1e.0
Aug 23 22:45:55 isp kernel: ACPI: Power Resource [URP1] (off)
Aug 23 22:45:55 isp kernel: ACPI: Power Resource [URP2] (off)
Aug 23 22:45:55 isp kernel: ACPI: Power Resource [FDDP] (off)
Aug 23 22:45:55 isp kernel: ACPI: Power Resource [LPTP] (off)
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5
6 7 10 *11 12 14 15)
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5
6 7 10 11 12 14 15)
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5
6 7 10 11 *12 14 15)
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 *5
6 7 10 11 12 14 15)
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5
6 7 10 11 12 14 15) *0, disabled.
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5
6 7 10 11 12 14 15) *0, disabled.
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5
6 7 10 11 12 14 15) *0, disabled.
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5
6 7 *10 11 12 14 15)
Aug 23 22:45:55 isp kernel: Linux Plug and Play Support v0.97 (c) Adam
Belay
Aug 23 22:45:55 isp kernel: pnp: PnP ACPI init
Aug 23 22:45:55 isp kernel: pnp: PnP ACPI: found 11 devices
Aug 23 22:45:55 isp kernel: PnPBIOS: Disabled by ACPI PNP
Aug 23 22:45:55 isp kernel: PCI: Using ACPI for IRQ routing
Aug 23 22:45:55 isp kernel: PCI: If a device doesn't work, try
"pci=routeirq".  If it helps, post a report
Aug 23 22:45:55 isp kernel: PCI: Ignore bogus resource 6 [0:0] of
0000:00:02.0
Aug 23 22:45:55 isp kernel: PCI: Bridge: 0000:00:1e.0
Aug 23 22:45:55 isp kernel:   IO window: c000-cfff
Aug 23 22:45:55 isp kernel:   MEM window: dfd00000-dfdfffff
Aug 23 22:45:55 isp kernel:   PREFETCH window: disabled.
Aug 23 22:45:55 isp kernel: NET: Registered protocol family 2
Aug 23 22:45:55 isp kernel: IP route cache hash table entries: 4096
(order: 2, 16384 bytes)
Aug 23 22:45:55 isp kernel: TCP established hash table entries: 16384
(order: 4, 65536 bytes)
Aug 23 22:45:55 isp kernel: TCP bind hash table entries: 8192 (order: 3,
32768 bytes)
Aug 23 22:45:55 isp kernel: TCP: Hash tables configured (established
16384 bind 8192)
Aug 23 22:45:55 isp kernel: TCP reno registered
Aug 23 22:45:55 isp kernel: apm: BIOS version 1.2 Flags 0x03 (Driver
version 1.16ac)
Aug 23 22:45:55 isp kernel: apm: overridden by ACPI.
Aug 23 22:45:55 isp kernel: VFS: Disk quotas dquot_6.5.1
Aug 23 22:45:55 isp kernel: Dquot-cache hash table entries: 1024 (order
0, 4096 bytes)
Aug 23 22:45:55 isp kernel: Initializing Cryptographic API
Aug 23 22:45:55 isp kernel: io scheduler noop registered
Aug 23 22:45:55 isp kernel: io scheduler anticipatory registered
(default)
Aug 23 22:45:55 isp kernel: io scheduler deadline registered
Aug 23 22:45:55 isp kernel: io scheduler cfq registered
Aug 23 22:45:55 isp kernel: ACPI: Power Button (FF) [PWRF]
Aug 23 22:45:55 isp kernel: ACPI: Power Button (CM) [PWRB]
Aug 23 22:45:55 isp kernel: ACPI: Processor [CPU1] (supports 8
throttling states)
Aug 23 22:45:55 isp kernel: acpi_processor-0495 [06] processor_get_info
: Error getting cpuindex for acpiid 0x2
Aug 23 22:45:55 isp kernel: isapnp: Scanning for PnP cards...
Aug 23 22:45:55 isp kernel: isapnp: No Plug & Play device found
Aug 23 22:45:55 isp kernel: Serial: 8250/16550 driver $Revision: 1.90 $
4 ports, IRQ sharing enabled
Aug 23 22:45:55 isp kernel: serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is
a 16550A
Aug 23 22:45:55 isp kernel: serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is
a 16550A
Aug 23 22:45:55 isp kernel: 00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a
16550A
Aug 23 22:45:55 isp kernel: 00:08: ttyS1 at I/O 0x2f8 (irq = 3) is a
16550A
Aug 23 22:45:55 isp kernel: RAMDISK driver initialized: 16 RAM disks of
8192K size 1024 blocksize
Aug 23 22:45:55 isp kernel: dgrs: SW=$Id: dgrs.c,v 1.13 2000/06/06
04:07:00 rick Exp $ FW=Build 550 11/16/96 03:45:15
Aug 23 22:45:55 isp kernel: FW Version=$Version$
Aug 23 22:45:55 isp kernel: pcnet32.c:v1.32 18.Mar.2006
tsbogend@alpha.franken.de
Aug 23 22:45:55 isp kernel: e100: Intel(R) PRO/100 Network Driver,
3.5.10-k2-NAPI
Aug 23 22:45:55 isp kernel: e100: Copyright(c) 1999-2005 Intel
Corporation
Aug 23 22:45:55 isp kernel: ThunderLAN driver v1.15
Aug 23 22:45:55 isp kernel: TLAN: 0 devices installed, PCI: 0  EISA: 0
Aug 23 22:45:55 isp kernel: cs89x0:cs89x0_probe(0x0)
Aug 23 22:45:55 isp kernel: cs89x0: no cs8900 or cs8920 detected.  Be
sure to disable PnP with SETUP
Aug 23 22:45:55 isp kernel: Trying to free nonexistent resource
<00000000-00000010>
Aug 23 22:45:55 isp kernel: forcedeth.c: Reverse Engineered nForce
ethernet driver. Version 0.54.
Aug 23 22:45:55 isp kernel: 8139cp: 10/100 PCI Ethernet driver v1.2 (Mar
22, 2004)
Aug 23 22:45:55 isp kernel: 8139too Fast Ethernet driver 0.9.27
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt 0000:03:04.0[A] -> GSI
16 (level, low) -> IRQ 16
Aug 23 22:45:55 isp kernel: eth0: RealTek RTL8139 at 0xcc00,
00:e0:4c:eb:62:5d, IRQ 16
Aug 23 22:45:55 isp kernel: depca: probe of depca.0 failed with error
-16
Aug 23 22:45:55 isp kernel: eth%%d: i82596 initialization timed out
Aug 23 22:45:55 isp kernel: tun: Universal TUN/TAP device driver, 1.6
Aug 23 22:45:55 isp kernel: tun: (C) 1999-2004 Max Krasnyansky
<maxk@qualcomm.com>
Aug 23 22:45:55 isp kernel: dmfe: Davicom DM9xxx net driver, version
1.36.4 (2002-01-17)
Aug 23 22:45:55 isp kernel: winbond-840.c:v1.01-d (2.4 port) Nov-17-2001
Donald Becker <becker@scyld.com>
Aug 23 22:45:55 isp kernel:   http://www.scyld.com/network/drivers.html
Aug 23 22:45:55 isp kernel: PNP: No PS/2 controller found. Probing ports
directly.
Aug 23 22:45:55 isp kernel: serio: i8042 AUX port at 0x60,0x64 irq 12
Aug 23 22:45:55 isp kernel: serio: i8042 KBD port at 0x60,0x64 irq 1
Aug 23 22:45:55 isp kernel: EISA: Probing bus 0 at eisa.0
Aug 23 22:45:55 isp kernel: TCP bic registered
Aug 23 22:45:55 isp kernel: NET: Registered protocol family 8
Aug 23 22:45:55 isp kernel: NET: Registered protocol family 20
Aug 23 22:45:55 isp kernel: Using IPI Shortcut mode
Aug 23 22:45:55 isp kernel: ACPI wakeup devices: 
Aug 23 22:45:55 isp kernel: USB1 USB2 USB3 EHCI ICHB  MC9 
Aug 23 22:45:55 isp kernel: ACPI: (supports S0 S1 S4 S5)
Aug 23 22:45:55 isp kernel: RAMDISK: cramfs filesystem found at block 0
Aug 23 22:45:55 isp kernel: RAMDISK: Loading 3916KiB [1 disk] into ram
disk...
|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H
|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H
|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H
|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H
|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H
|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H
|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H
|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H
|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H
|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H|^H/^H-^H\^H
|^H/^H-^H\^H|^Hdone.
Aug 23 22:45:55 isp kernel: VFS: Mounted root (cramfs filesystem)
readonly.
Aug 23 22:45:55 isp kernel: Freeing unused kernel memory: 404k freed
Aug 23 22:45:55 isp kernel: NET: Registered protocol family 1
Aug 23 22:45:55 isp kernel: md: md driver 0.90.3 MAX_MD_DEVS=256,
MD_SB_DISKS=27
Aug 23 22:45:55 isp kernel: md: bitmap version 4.39
Aug 23 22:45:55 isp kernel: md: raid1 personality registered for level 1
Aug 23 22:45:55 isp kernel: Uniform Multi-Platform E-IDE driver
Revision: 7.00alpha2
Aug 23 22:45:55 isp kernel: ide: Assuming 33MHz system bus speed for PIO
modes; override with idebus=xx
Aug 23 22:45:55 isp kernel: ICH4: IDE controller at PCI slot
0000:00:1f.1
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI
18 (level, low) -> IRQ 17
Aug 23 22:45:55 isp kernel: ICH4: chipset revision 2
Aug 23 22:45:55 isp kernel: ICH4: not 100%% native mode: will probe irqs
later
Aug 23 22:45:55 isp kernel:     ide0: BM-DMA at 0xfc00-0xfc07, BIOS
settings: hda:DMA, hdb:DMA
Aug 23 22:45:55 isp kernel:     ide1: BM-DMA at 0xfc08-0xfc0f, BIOS
settings: hdc:DMA, hdd:pio
Aug 23 22:45:55 isp kernel: hda: Maxtor 6G160P0, ATA DISK drive
Aug 23 22:45:55 isp kernel: hdb: Maxtor 6G160P0, ATA DISK drive
Aug 23 22:45:55 isp kernel: ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Aug 23 22:45:55 isp kernel: hdc: SAMSUNG CD-ROM SH-152A, ATAPI
CD/DVD-ROM drive
Aug 23 22:45:55 isp kernel: ide1 at 0x170-0x177,0x376 on irq 15
Aug 23 22:45:55 isp kernel: hda: max request size: 512KiB
Aug 23 22:45:55 isp kernel: hda: 312581808 sectors (160041 MB) w/8192KiB
Cache, CHS=19457/255/63, UDMA(100)
Aug 23 22:45:55 isp kernel: hda: cache flushes supported
Aug 23 22:45:55 isp kernel:  hda: hda1 hda2 < hda5 >
Aug 23 22:45:55 isp kernel: hdb: max request size: 512KiB
Aug 23 22:45:55 isp kernel: hdb: 312581808 sectors (160041 MB) w/8192KiB
Cache, CHS=19457/255/63, UDMA(100)
Aug 23 22:45:55 isp kernel: hdb: cache flushes supported
Aug 23 22:45:55 isp kernel:  hdb: hdb1 hdb2 < hdb5 >
Aug 23 22:45:55 isp kernel: md: md0 stopped.
Aug 23 22:45:55 isp kernel: md: bind<hdb1>
Aug 23 22:45:55 isp kernel: raid1: raid set md0 active with 1 out of 2
mirrors
Aug 23 22:45:55 isp kernel: kjournald starting.  Commit interval 5
seconds
Aug 23 22:45:55 isp kernel: EXT3-fs: mounted filesystem with ordered
data mode.
Aug 23 22:45:55 isp kernel: Adding 1542200k swap on /dev/hda5.
Priority:1 extents:1 across:1542200k
Aug 23 22:45:55 isp kernel: Adding 1542200k swap on /dev/hdb5.
Priority:1 extents:1 across:1542200k
Aug 23 22:45:55 isp kernel: EXT3 FS on md0, internal journal
Aug 23 22:45:55 isp kernel: Generic RTC Driver v1.07
Aug 23 22:45:55 isp kernel: hdc: ATAPI 52X CD-ROM drive, 128kB Cache,
UDMA(33)
Aug 23 22:45:55 isp kernel: Uniform CD-ROM driver Revision: 3.20
Aug 23 22:45:55 isp kernel: Intel 810 + AC97 Audio, version 1.01,
23:18:52 Aug 11 2006
Aug 23 22:45:55 isp kernel: acpi_bus-0201 [01] bus_set_power         :
Device is not power manageable
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI
17 (level, low) -> IRQ 18
Aug 23 22:45:55 isp kernel: i810: Intel ICH4 found at IO 0xdc00 and
0xe000, MEM 0xdff7ba00 and 0xdff7b900, IRQ 18
Aug 23 22:45:55 isp kernel: i810: Intel ICH4 mmio at 0xe0856a00 and
0xe0858900
Aug 23 22:45:55 isp kernel: i810_audio: Primary codec has ID 2
Aug 23 22:45:55 isp kernel: i810_audio: Audio Controller supports 6
channels.
Aug 23 22:45:55 isp kernel: i810_audio: Defaulting to base 2 channel
mode.
Aug 23 22:45:55 isp kernel: i810_audio: Resetting connection 0
Aug 23 22:45:55 isp kernel: i810_audio: Connection 0 with codec id 2
Aug 23 22:45:55 isp kernel: ac97_codec: AC97 Audio codec, id: ALG64
(Unknown)
Aug 23 22:45:55 isp kernel: i810_audio: AC'97 codec 2 supports AMAP,
total channels = 2
Aug 23 22:45:55 isp kernel: usbcore: registered new driver usbfs
Aug 23 22:45:55 isp kernel: usbcore: registered new driver hub
Aug 23 22:45:55 isp kernel: USB Universal Host Controller Interface
driver v3.0
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI
16 (level, low) -> IRQ 16
Aug 23 22:45:55 isp kernel: uhci_hcd 0000:00:1d.0: UHCI Host Controller
Aug 23 22:45:55 isp kernel: uhci_hcd 0000:00:1d.0: new USB bus
registered, assigned bus number 1
Aug 23 22:45:55 isp kernel: uhci_hcd 0000:00:1d.0: irq 16, io base
0x0000e400
Aug 23 22:45:55 isp kernel: usb usb1: configuration #1 chosen from 1
choice
Aug 23 22:45:55 isp kernel: hub 1-0:1.0: USB hub found
Aug 23 22:45:55 isp kernel: hub 1-0:1.0: 2 ports detected
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI
19 (level, low) -> IRQ 19
Aug 23 22:45:55 isp kernel: uhci_hcd 0000:00:1d.1: UHCI Host Controller
Aug 23 22:45:55 isp kernel: uhci_hcd 0000:00:1d.1: new USB bus
registered, assigned bus number 2
Aug 23 22:45:55 isp kernel: uhci_hcd 0000:00:1d.1: irq 19, io base
0x0000e800
Aug 23 22:45:55 isp kernel: usb usb2: configuration #1 chosen from 1
choice
Aug 23 22:45:55 isp kernel: hub 2-0:1.0: USB hub found
Aug 23 22:45:55 isp kernel: hub 2-0:1.0: 2 ports detected
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI
18 (level, low) -> IRQ 17
Aug 23 22:45:55 isp kernel: uhci_hcd 0000:00:1d.2: UHCI Host Controller
Aug 23 22:45:55 isp kernel: uhci_hcd 0000:00:1d.2: new USB bus
registered, assigned bus number 3
Aug 23 22:45:55 isp kernel: uhci_hcd 0000:00:1d.2: irq 17, io base
0x0000ec00
Aug 23 22:45:55 isp kernel: usb usb3: configuration #1 chosen from 1
choice
Aug 23 22:45:55 isp kernel: hub 3-0:1.0: USB hub found
Aug 23 22:45:55 isp kernel: hub 3-0:1.0: 2 ports detected
Aug 23 22:45:55 isp kernel: acpi_bus-0201 [01] bus_set_power         :
Device is not power manageable
Aug 23 22:45:55 isp kernel: ACPI: PCI Interrupt 0000:00:1d.7[D] -> GSI
23 (level, low) -> IRQ 20
Aug 23 22:45:55 isp kernel: ehci_hcd 0000:00:1d.7: EHCI Host Controller
Aug 23 22:45:55 isp kernel: ehci_hcd 0000:00:1d.7: new USB bus
registered, assigned bus number 4
Aug 23 22:45:55 isp kernel: ehci_hcd 0000:00:1d.7: debug port 1
Aug 23 22:45:55 isp kernel: ehci_hcd 0000:00:1d.7: irq 20, io mem
0xdff7bc00
Aug 23 22:45:55 isp kernel: ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI
1.00, driver 10 Dec 2004
Aug 23 22:45:55 isp kernel: usb usb4: configuration #1 chosen from 1
choice
Aug 23 22:45:55 isp kernel: hub 4-0:1.0: USB hub found
Aug 23 22:45:55 isp kernel: hub 4-0:1.0: 6 ports detected
Aug 23 22:45:55 isp kernel: Linux agpgart interface v0.101 (c) Dave
Jones
Aug 23 22:45:55 isp kernel: agpgart: Detected an Intel 845G Chipset.
Aug 23 22:45:55 isp kernel: agpgart: Detected 892K stolen memory.
Aug 23 22:45:55 isp kernel: agpgart: AGP aperture is 128M @ 0xd0000000
Aug 23 22:45:55 isp kernel: pci_hotplug: PCI Hot Plug PCI Core version:
0.5
Aug 23 22:45:55 isp kernel: shpchp: Standard Hot Plug PCI Controller
Driver version: 0.4
Aug 23 22:45:55 isp kernel: input: PC Speaker as /class/input/input0
Aug 23 22:45:55 isp kernel: Floppy drive(s): fd0 is 1.44M
Aug 23 22:45:55 isp kernel: FDC 0 is a post-1991 82077
Aug 23 22:45:55 isp kernel: parport: PnPBIOS parport detected.
Aug 23 22:45:55 isp kernel: parport0: PC-style at 0x378 (0x778), irq 7,
dma 3 [PCSPP,TRISTATE,COMPAT,ECP,DMA]
Aug 23 22:45:55 isp kernel: eth0: link up, 100Mbps, full-duplex, lpa
0x41E1
Aug 23 22:45:55 isp kernel: NET: Registered protocol family 10
Aug 23 22:45:55 isp kernel: lo: Disabled Privacy Extensions
Aug 23 22:45:55 isp kernel: IPv6 over IPv4 tunneling driver
Aug 23 22:45:55 isp kernel: Capability LSM initialized




Aug 24 07:12:30 isp kernel: md: bind<hda1>
Aug 24 07:12:30 isp kernel: RAID1 conf printout:
Aug 24 07:12:30 isp kernel:  --- wd:1 rd:2
Aug 24 07:12:30 isp kernel:  disk 0, wo:1, o:1, dev:hda1
Aug 24 07:12:30 isp kernel:  disk 1, wo:0, o:1, dev:hdb1
Aug 24 07:12:30 isp kernel: md: syncing RAID array md0
Aug 24 07:12:30 isp kernel: md: minimum _guaranteed_ reconstruction
speed: 1000 KB/sec/disc.
Aug 24 07:12:30 isp kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for reconstruction.
Aug 24 07:12:30 isp kernel: md: using 128k window, over a total of
154191744 blocks.
Aug 24 08:28:05 isp kernel: md: md0: sync done.
Aug 24 08:28:05 isp kernel: RAID1 conf printout:
Aug 24 08:28:05 isp kernel:  --- wd:2 rd:2
Aug 24 08:28:05 isp kernel:  disk 0, wo:0, o:1, dev:hda1
Aug 24 08:28:05 isp kernel:  disk 1, wo:0, o:1, dev:hdb1
Aug 25 18:58:44 isp kernel: end_request: I/O error, dev fd0, sector 0
Aug 25 18:59:08 isp kernel: SCSI subsystem initialized






> -----Original Message-----
> From: Neil Brown [mailto:neilb@suse.de] 
> Sent: Montag, 28. August 2006 03:06
> To: Andreas Pelzner
> Cc: linux-raid@vger.kernel.org
> Subject: RE: md: only binds to one mirror after reboot
> 
> On Sunday August 27, Andreas.Pelzner@aixvision.net wrote:
> > > 
> > > Do you have the autodetect kernel messages from booting?
> > > 
> > 
> > I don't know where to find these messages. Can anyone tell me pls.?
> 
> Just post all the kernel messages
>   grep kernel /var/log/messages
> 
> NeilBrown
> 


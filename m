From: Mika Tiainen <mikat@iki.fi>
Subject: Kernel doesn't find root from new style partitionable array
Date: Sat, 10 Jan 2009 19:23:48 +0200
Message-ID: <871vvbulaz.fsf@divinity.mikat.iki.fi>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=iso-8859-1


Hi,

I'm using the new support for partitioning a normal md-array in 2.6.28
kernel. The devices are created and work just fine:

mika@aeon:~$ ll /dev/md0*
brw-rw---- 1 root disk   9, 0 2009-01-10 18:31 /dev/md0
brw-rw---- 1 root disk 259, 0 2009-01-10 18:31 /dev/md0p1
brw-rw---- 1 root disk 259, 1 2009-01-10 18:31 /dev/md0p2

Using /dev/md0p1 as root device for kernel however doesn't work.

Kernel autodetects the array just fine:

md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 1 and added 1 devices.
md: autorun ...
md: considering sda1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: running: <sda1>
raid1: raid set md0 active with 1 out of 2 mirrors
md: ... autorun DONE.

But not the partitions, root device is not found and the list of devices
shown only has md0, not the partitions below it.

When booting from another disk I can see that the md0 partitions are
only found later:

 md0: p1 p2

This line shows up after root is already mounted.

I tried booting with the rootwait parameter, but it didn't help.

Attached is dmesg from booting with another disk that shows the md
partitions being detected late.


--=-=-=
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename=dmesg

BIOS EBDA/lowmem at: 0009f800/0009f800
Linux version 2.6.28 (mika@divinity) (gcc version 4.3.2 (Debian 4.3.2-1.1) ) #1 SMP Sat Jan 10 03:31:22 EET 2009
Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.28 root=/dev/sdb1 ro
KERNEL supported cpus:
  Intel GenuineIntel
  AMD AuthenticAMD
  Centaur CentaurHauls
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 0000000077de0000 (usable)
 BIOS-e820: 0000000077de0000 - 0000000077de3000 (ACPI NVS)
 BIOS-e820: 0000000077de3000 - 0000000077df0000 (ACPI data)
 BIOS-e820: 0000000077df0000 - 0000000077e00000 (reserved)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x77de0 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping: 0000000000000000-0000000077de0000
 0000000000 - 0077c00000 page 2M
 0077c00000 - 0077de0000 page 4k
kernel direct mapping tables up to 77de0000 @ 8000-c000
last_map_addr: 77de0000 end: 77de0000
ACPI: RSDP 000F70E0, 0014 (r0 GBT   )
ACPI: RSDT 77DE3000, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: FACP 77DE3040, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: DSDT 77DE30C0, 4222 (r1 GBT    GBTUACPI     1000 MSFT  3000000)
ACPI: FACS 77DE0000, 0040
ACPI: SSDT 77DE73C0, 0157 (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: HPET 77DE7540, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
ACPI: MCFG 77DE7580, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: APIC 77DE7300, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: Local APIC address 0xfee00000
(5 early reservations) ==> bootmem [0000000000 - 0077de0000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 0000008000]
  #2 [0000200000 - 00005f0290]    TEXT DATA BSS ==> [0000200000 - 00005f0290]
  #3 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 0000100000]
  #4 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 000000a000]
 [ffffe20000000000-ffffe20001bfffff] PMD -> [ffff880001200000-ffff880002dfffff] on node 0
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  DMA32    0x00001000 -> 0x00100000
  Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009f
    0: 0x00000100 -> 0x00077de0
On node 0 totalpages: 490879
  DMA zone: 56 pages used for memmap
  DMA zone: 1109 pages reserved
  DMA zone: 2834 pages, LIFO batch:0
  DMA32 zone: 6657 pages used for memmap
  DMA32 zone: 480223 pages, LIFO batch:31
  Normal zone: 0 pages used for memmap
  Movable zone: 0 pages used for memmap
Detected use of extended apic ids on hypertransport bus
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] disabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
SMP: Allowing 2 CPUs, 1 hotplug CPUs
Allocating PCI resources starting at 78000000 (gap: 77e00000:68200000)
PERCPU: Allocating 45056 bytes of per cpu data
NR_CPUS: 2, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 483057
Kernel command line: BOOT_IMAGE=/boot/vmlinuz-2.6.28 root=/dev/sdb1 ro
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
Fast TSC calibration using PIT
Detected 2611.939 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Checking aperture...
No AGP bridge found
Node 0: aperture @ 7f6e000000 size 32 MB
Aperture beyond 4GB. Ignoring.
Memory: 1927060k/1963904k available (2265k kernel code, 388k absent, 36020k reserved, 992k data, 292k init)
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
hpet clockevent registered
HPET: 4 timers in total, 1 timers will be used for per-cpu timer
Calibrating delay loop (skipped), value calculated using timer frequency.. 5223.87 BogoMIPS (lpj=2611939)
Mount-cache hash table entries: 256
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
tseg: 0077e00000
using C1E aware idle routine
SMP alternatives: switching to UP code
ACPI: Core revision 20080926
Setting APIC routing to flat
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: AMD Athlon(tm) Processor LE-1640 stepping 03
Brought up 1 CPUs
Total of 1 processors activated (5223.87 BogoMIPS).
net_namespace: 1336 bytes
NET: Registered protocol family 16
node 0 link 0: io port [c000, ffff]
TOM: 0000000080000000 aka 2048M
node 0 link 0: mmio [a0000, bffff]
node 0 link 0: mmio [e0000000, fe02ffff]
node 0 link 0: mmio [80000000, d7ffffff]
node 0 link 0: mmio [d8000000, dfffffff]
node 0 link 0: mmio [e0000000, efffffff]
bus: [00,03] on node 0 link 0
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [a0000, bffff]
bus: 00 index 2 mmio: [d8000000, fcffffffff]
bus: 00 index 3 mmio: [80000000, d7ffffff]
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - efffffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: No dock devices found.
ACPI: PCI Root Bridge [PCI0] (0000:00)
pci 0000:00:06.0: PME# supported from D0 D3hot D3cold
pci 0000:00:06.0: PME# disabled
pci 0000:00:11.0: reg 10 io port: [0xff00-0xff07]
pci 0000:00:11.0: reg 14 io port: [0xfe00-0xfe03]
pci 0000:00:11.0: reg 18 io port: [0xfd00-0xfd07]
pci 0000:00:11.0: reg 1c io port: [0xfc00-0xfc03]
pci 0000:00:11.0: reg 20 io port: [0xfb00-0xfb0f]
pci 0000:00:11.0: reg 24 32bit mmio: [0xfe02f000-0xfe02f3ff]
pci 0000:00:12.0: reg 10 32bit mmio: [0xfe02e000-0xfe02efff]
pci 0000:00:12.1: reg 10 32bit mmio: [0xfe02d000-0xfe02dfff]
pci 0000:00:12.2: reg 10 32bit mmio: [0xfe02c000-0xfe02c0ff]
pci 0000:00:12.2: supports D1 D2
pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:12.2: PME# disabled
pci 0000:00:13.0: reg 10 32bit mmio: [0xfe02b000-0xfe02bfff]
pci 0000:00:13.1: reg 10 32bit mmio: [0xfe02a000-0xfe02afff]
pci 0000:00:13.2: reg 10 32bit mmio: [0xfe029000-0xfe0290ff]
pci 0000:00:13.2: supports D1 D2
pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
pci 0000:00:13.2: PME# disabled
pci 0000:00:14.1: reg 10 io port: [0x00-0x07]
pci 0000:00:14.1: reg 14 io port: [0x00-0x03]
pci 0000:00:14.1: reg 18 io port: [0x00-0x07]
pci 0000:00:14.1: reg 1c io port: [0x00-0x03]
pci 0000:00:14.1: reg 20 io port: [0xfa00-0xfa0f]
pci 0000:00:14.2: reg 10 64bit mmio: [0xfe024000-0xfe027fff]
pci 0000:00:14.2: PME# supported from D0 D3hot D3cold
pci 0000:00:14.2: PME# disabled
pci 0000:00:14.5: reg 10 32bit mmio: [0xfe028000-0xfe028fff]
pci 0000:01:05.0: reg 10 64bit mmio: [0xd8000000-0xdfffffff]
pci 0000:01:05.0: reg 18 64bit mmio: [0xfdfe0000-0xfdfeffff]
pci 0000:01:05.0: reg 20 io port: [0xee00-0xeeff]
pci 0000:01:05.0: reg 24 32bit mmio: [0xfde00000-0xfdefffff]
pci 0000:01:05.0: supports D1 D2
pci 0000:01:05.2: reg 10 64bit mmio: [0xfdffc000-0xfdffffff]
pci 0000:00:01.0: bridge io port: [0xe000-0xefff]
pci 0000:00:01.0: bridge 32bit mmio: [0xfde00000-0xfdffffff]
pci 0000:00:01.0: bridge 64bit mmio pref: [0xd8000000-0xdfffffff]
pci 0000:02:00.0: reg 10 io port: [0xde00-0xdeff]
pci 0000:02:00.0: reg 18 64bit mmio: [0xfdaff000-0xfdafffff]
pci 0000:02:00.0: reg 20 64bit mmio: [0xfdae0000-0xfdaeffff]
pci 0000:02:00.0: reg 30 32bit mmio: [0x000000-0x00ffff]
pci 0000:02:00.0: supports D1 D2
pci 0000:02:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:02:00.0: PME# disabled
pci 0000:00:06.0: bridge io port: [0xd000-0xdfff]
pci 0000:00:06.0: bridge 32bit mmio: [0xfdd00000-0xfddfffff]
pci 0000:00:06.0: bridge 64bit mmio pref: [0xfda00000-0xfdafffff]
pci 0000:00:14.4: transparent bridge
pci 0000:00:14.4: bridge io port: [0xc000-0xcfff]
pci 0000:00:14.4: bridge 32bit mmio: [0xfdc00000-0xfdcfffff]
pci 0000:00:14.4: bridge 32bit mmio pref: [0xfdb00000-0xfdbfffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P2P_._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.AGP_._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 10 11) *0, disabled.
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 6 7 10 11) *0, disabled.
SCSI subsystem initialized
libata version 3.00 loaded.
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 319, 0
hpet0: 4 comparators, 32-bit 14.318180 MHz counter
hpet: hpet2 irq 319 for MSI
Switched to high resolution mode on CPU 0
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 10 devices
ACPI: ACPI bus type pnp unregistered
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x220-0x225 has been reserved
system 00:01: ioport range 0x290-0x294 has been reserved
system 00:02: ioport range 0x4100-0x411f has been reserved
system 00:02: ioport range 0x228-0x22f has been reserved
system 00:02: ioport range 0x238-0x23f has been reserved
system 00:02: ioport range 0x40b-0x40b has been reserved
system 00:02: ioport range 0x4d6-0x4d6 has been reserved
system 00:02: ioport range 0xc00-0xc01 has been reserved
system 00:02: ioport range 0xc14-0xc14 has been reserved
system 00:02: ioport range 0xc50-0xc52 has been reserved
system 00:02: ioport range 0xc6c-0xc6d has been reserved
system 00:02: ioport range 0xc6f-0xc6f has been reserved
system 00:02: ioport range 0xcd0-0xcd1 has been reserved
system 00:02: ioport range 0xcd2-0xcd3 has been reserved
system 00:02: ioport range 0xcd4-0xcdf has been reserved
system 00:02: ioport range 0x4000-0x40fe has been reserved
system 00:02: ioport range 0x4210-0x4217 has been reserved
system 00:02: ioport range 0xb00-0xb0f has been reserved
system 00:02: ioport range 0xb10-0xb1f has been reserved
system 00:02: ioport range 0xb20-0xb3f has been reserved
system 00:08: iomem range 0xe0000000-0xefffffff has been reserved
system 00:09: iomem range 0xd1800-0xd3fff has been reserved
system 00:09: iomem range 0xf0000-0xf7fff could not be reserved
system 00:09: iomem range 0xf8000-0xfbfff could not be reserved
system 00:09: iomem range 0xfc000-0xfffff could not be reserved
system 00:09: iomem range 0x77de0000-0x77dfffff could not be reserved
system 00:09: iomem range 0xffff0000-0xffffffff has been reserved
system 00:09: iomem range 0x0-0x9ffff could not be reserved
system 00:09: iomem range 0x100000-0x77ddffff could not be reserved
system 00:09: iomem range 0x77ef0000-0x7feeffff has been reserved
system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
system 00:09: iomem range 0xfff80000-0xfffeffff has been reserved
pci 0000:00:01.0: PCI bridge, secondary bus 0000:01
pci 0000:00:01.0:   IO window: 0xe000-0xefff
pci 0000:00:01.0:   MEM window: 0xfde00000-0xfdffffff
pci 0000:00:01.0:   PREFETCH window: 0x000000d8000000-0x000000dfffffff
pci 0000:00:06.0: PCI bridge, secondary bus 0000:02
pci 0000:00:06.0:   IO window: 0xd000-0xdfff
pci 0000:00:06.0:   MEM window: 0xfdd00000-0xfddfffff
pci 0000:00:06.0:   PREFETCH window: 0x000000fda00000-0x000000fdafffff
pci 0000:00:14.4: PCI bridge, secondary bus 0000:03
pci 0000:00:14.4:   IO window: 0xc000-0xcfff
pci 0000:00:14.4:   MEM window: 0xfdc00000-0xfdcfffff
pci 0000:00:14.4:   PREFETCH window: 0x000000fdb00000-0x000000fdbfffff
pci 0000:00:06.0: setting latency timer to 64
bus: 00 index 0 io port: [0x00-0xffff]
bus: 00 index 1 mmio: [0x000000-0xffffffffffffffff]
bus: 01 index 0 io port: [0xe000-0xefff]
bus: 01 index 1 mmio: [0xfde00000-0xfdffffff]
bus: 01 index 2 mmio: [0xd8000000-0xdfffffff]
bus: 01 index 3 mmio: [0x0-0x0]
bus: 02 index 0 io port: [0xd000-0xdfff]
bus: 02 index 1 mmio: [0xfdd00000-0xfddfffff]
bus: 02 index 2 mmio: [0xfda00000-0xfdafffff]
bus: 02 index 3 mmio: [0x0-0x0]
bus: 03 index 0 io port: [0xc000-0xcfff]
bus: 03 index 1 mmio: [0xfdc00000-0xfdcfffff]
bus: 03 index 2 mmio: [0xfdb00000-0xfdbfffff]
bus: 03 index 3 io port: [0x00-0xffff]
bus: 03 index 4 mmio: [0x000000-0xffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
msgmni has been set to 3764
io scheduler noop registered
io scheduler cfq registered (default)
pci 0000:00:13.0: OHCI: BIOS handoff failed (BIOS bug?) 00000184
pci 0000:01:05.0: Boot video device
pcieport-driver 0000:00:06.0: setting latency timer to 64
pcieport-driver 0000:00:06.0: found MSI capability
pcieport-driver 0000:00:06.0: irq 318 for MSI/MSI-X
pci_express 0000:00:06.0:pcie00: allocate port service
pci_express 0000:00:06.0:pcie03: allocate port service
Linux agpgart interface v0.103
Driver 'sd' needs updating - please use bus_type methods
ahci 0000:00:11.0: version 3.0
ahci 0000:00:11.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
ahci 0000:00:11.0: irq 317 for MSI/MSI-X
ahci 0000:00:11.0: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
ata1: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f100 irq 317
ata2: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f180 irq 317
ata3: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f200 irq 317
ata4: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f280 irq 317
ata5: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f300 irq 317
ata6: SATA max UDMA/133 abar m1024@0xfe02f000 port 0xfe02f380 irq 317
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-8: WDC WD10EADS-00L5B1, 01.01A01, max UDMA/133
ata1.00: 1953525168 sectors, multi 0: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
ata2: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata4: SATA link down (SStatus 0 SControl 300)
ata5: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
scsi 0:0:0:0: Direct-Access     ATA      WDC WD10EADS-00L 01.0 PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sda: sda1 sda2
sd 0:0:0:0: [sda] Attached SCSI disk
pata_atiixp 0000:00:14.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
scsi6 : pata_atiixp
scsi7 : pata_atiixp
ata7: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xfa00 irq 14
ata8: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xfa08 irq 15
ata7.00: HPA detected: current 625140335, native 625142448
ata7.00: ATA-7: ST3320620A, 3.AAE, max UDMA/100
ata7.00: 625140335 sectors, multi 16: LBA48 
ata7.00: configured for UDMA/100
isa bounce pool size: 16 pages
scsi 6:0:0:0: Direct-Access     ATA      ST3320620A       3.AA PQ: 0 ANSI: 5
sd 6:0:0:0: [sdb] 625140335 512-byte hardware sectors: (320 GB/298 GiB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
sd 6:0:0:0: [sdb] 625140335 512-byte hardware sectors: (320 GB/298 GiB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
 sdb: sdb1 sdb2
sd 6:0:0:0: [sdb] Attached SCSI disk
PNP: No PS/2 controller found. Probing ports directly.
Failed to disable AUX port, but continuing anyway... Is this a SiS?
If AUX port is really absent please use the 'i8042.noaux' option.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
rtc_cmos 00:05: RTC can wake from S4
rtc_cmos 00:05: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, 242 bytes nvram, hpet irqs
md: raid1 personality registered for level 1
cpuidle: using governor ladder
cpuidle: using governor menu
Advanced Linux Sound Architecture Driver Version 1.0.18rc3.
ALSA device list:
  No soundcards found.
TCP cubic registered
NET: Registered protocol family 10
NET: Registered protocol family 17
powernow-k8: Found 1 AMD Athlon(tm) Processor LE-1640 processors (1 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x2 (1000 MHz), vid 0x12
powernow-k8:    1 : fid 0xa (1800 MHz), vid 0x10
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0x10
powernow-k8:    3 : fid 0xe (2200 MHz), vid 0x10
powernow-k8:    4 : fid 0x10 (2400 MHz), vid 0xe
powernow-k8:    5 : fid 0x12 (2600 MHz), vid 0xc
rtc_cmos 00:05: setting system clock to 2009-01-10 16:31:01 UTC (1231605061)
BIOS EDD facility v0.16 2004-Jun-25, 2 devices found
md: Waiting for all devices to be available before autodetect
md: If you don't use raid, use raid=noautodetect
md: Autodetecting RAID arrays.
md: Scanned 1 and added 1 devices.
md: autorun ...
md: considering sda1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: running: <sda1>
raid1: raid set md0 active with 1 out of 2 mirrors
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
VFS: Mounted root (ext3 filesystem) readonly.
Freeing unused kernel memory: 292k freed
Write protecting the kernel read-only data: 3008k
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
processor ACPI_CPU:00: registered as cooling_device0
ACPI: Power Button (CM) [PWRB]
ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
ohci_hcd 0000:00:12.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:12.0: OHCI Host Controller
ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 1
ohci_hcd 0000:00:12.0: irq 16, io mem 0xfe02e000
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
r8169 0000:02:00.0: setting latency timer to 64
r8169 0000:02:00.0: irq 316 for MSI/MSI-X
eth0: RTL8168c/8111c at 0xffffc200100b2000, 00:1f:d0:95:62:ee, XID 3c4000c0 IRQ 316
ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
Warning! ehci_hcd should always be loaded before uhci_hcd and ohci_hcd, not after
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 3 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0001
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: OHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.28 ohci_hcd
usb usb1: SerialNumber: 0000:00:12.0
HDA Intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
HDA Intel 0000:01:05.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
ehci_hcd 0000:00:12.2: EHCI Host Controller
ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:12.2: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:12.2: debug port 1
ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe02c000
ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.28 ehci_hcd
usb usb2: SerialNumber: 0000:00:12.2
piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
ohci_hcd 0000:00:12.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
ohci_hcd 0000:00:12.1: OHCI Host Controller
ohci_hcd 0000:00:12.1: new USB bus registered, assigned bus number 3
ohci_hcd 0000:00:12.1: irq 16, io mem 0xfe02d000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 3 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: OHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.28 ohci_hcd
usb usb3: SerialNumber: 0000:00:12.1
ehci_hcd 0000:00:13.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ehci_hcd 0000:00:13.2: EHCI Host Controller
ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
ehci_hcd 0000:00:13.2: applying AMD SB600/SB700 USB freeze workaround
ehci_hcd 0000:00:13.2: debug port 1
ehci_hcd 0000:00:13.2: irq 19, io mem 0xfe029000
ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 6 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: EHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.28 ehci_hcd
usb usb4: SerialNumber: 0000:00:13.2
ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.0: OHCI Host Controller
ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 5
ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe02b000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 3 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: OHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.28 ohci_hcd
usb usb5: SerialNumber: 0000:00:13.0
ohci_hcd 0000:00:13.1: PCI INT A -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:13.1: OHCI Host Controller
ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 6
ohci_hcd 0000:00:13.1: irq 18, io mem 0xfe02a000
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 3 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: OHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.28 ohci_hcd
usb usb6: SerialNumber: 0000:00:13.1
ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ohci_hcd 0000:00:14.5: OHCI Host Controller
ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 7
ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe028000
input: PC Speaker as /devices/platform/pcspkr/input/input2
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: OHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.28 ohci_hcd
usb usb7: SerialNumber: 0000:00:14.5
usb 3-2: new low speed USB device using ohci_hcd and address 2
 md0: p1 p2
usb 3-2: configuration #1 chosen from 1 choice
usb 3-2: New USB device found, idVendor=046d, idProduct=c505
usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 3-2: Product: USB Receiver
usb 3-2: Manufacturer: Logitech
usbcore: registered new interface driver hiddev
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb3/3-2/3-2:1.0/input/input3
generic-usb 0003:046D:C505.0001: input,hidraw0: USB HID v1.10 Keyboard [Logitech USB Receiver] on usb-0000:00:12.1-2/input0
input: Logitech USB Receiver as /devices/pci0000:00/0000:00:12.1/usb3/3-2/3-2:1.1/input/input4
generic-usb 0003:046D:C505.0002: input,hidraw1: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:12.1-2/input1
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
ata1.00: configured for UDMA/133
ata1: EH complete
sd 0:0:0:0: [sda] 1953525168 512-byte hardware sectors: (1.00 TB/931 GiB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
EXT3 FS on sdb1, internal journal
it87: Found IT8718F chip at 0x228, revision 5
it87: in3 is VCC (+5V)
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on dm-3, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SGI XFS with ACLs, security attributes, large block/inode numbers, no debug enabled
Filesystem "dm-1": Disabling barriers, trial barrier write failed
XFS mounting filesystem dm-1
Ending clean XFS mount for filesystem: dm-1
Filesystem "dm-5": Disabling barriers, trial barrier write failed
XFS mounting filesystem dm-5
Ending clean XFS mount for filesystem: dm-5
Adding 1048568k swap on /dev/mapper/vg0-swap.  Priority:-1 extents:1 across:1048568k
r8169: eth0: link up
r8169: eth0: link up
IPv6 over IPv4 tunneling driver
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).

--=-=-=
Content-Type: text/plain; charset=iso-8859-1


-- 
Mika Tiainen		Always be wary of any helpful item that
mikat@iki.fi		weighs less than its operating manual.
http://mikat.iki.fi	-- (Terry Pratchett, Jingo)

--=-=-=--

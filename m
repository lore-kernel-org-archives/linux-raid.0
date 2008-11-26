From: "Greg Cormier" <gcormier@gmail.com>
Subject: Updated MDADM, array dies.
Date: Wed, 26 Nov 2008 11:40:52 -0500
Message-ID: <29a863790811260840w2533f6dcy244ce58d81bbc27e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a RAID5 array of 4 disks. Was working well. I did a "yum
update" and noticed it updated mdadm to mdadm 2.6.7.1, amongst other
things (new kernel 2.2.27 instead of .26) , and now my array won't
mount.

mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: /dev/sdb1 has no superblock - assembly aborted

[root@zeus ~]# cat /proc/mdstat
Personalities :
md_d0 : inactive sdb1[0](S) sdd1[2](S)
      976766976 blocks

unused devices: <none>


Yet, if I examine, it looks okay?

[root@zeus ~]# mdadm --examine /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 0.90.00
           UUID : 28f0045b:2d4d2d6d:375d11e3:8e73d7bc
  Creation Time : Fri Jan 18 18:31:52 2008
     Raid Level : raid5
  Used Dev Size : 488383488 (465.76 GiB 500.10 GB)
     Array Size : 1465150464 (1397.28 GiB 1500.31 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0

    Update Time : Sun Nov 23 22:38:09 2008
          State : clean
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 7318e88b - correct
         Events : 18

         Layout : left-symmetric
     Chunk Size : 512K

      Number   Major   Minor   RaidDevice State
this     0       8       17        0      active sync   /dev/sdb1

   0     0       8       17        0      active sync   /dev/sdb1
   1     1       8       33        1      active sync   /dev/sdc1
   2     2       8       49        2      active sync   /dev/sdd1
   3     3       8       65        3      active sync   /dev/sde1


All other devices are in the same state, active sync, nothing failed,
and clean state.

dmesg log at the bottom. I'm stumped? And desperate :-)

Thanks,
Greg





Initializing cgroup subsys cpuset
Linux version 2.6.27.5-41.fc9.i686 (mockbuild@) (gcc version 4.3.0
20080428 (Red Hat 4.3.0-8) (GCC) ) #1 SMP Thu Nov 13 20:52:14 EST 2008
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009e000 (usable)
 BIOS-e820: 000000000009e000 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
 BIOS-e820: 000000007fff0000 - 000000007fff3000 (ACPI NVS)
 BIOS-e820: 000000007fff3000 - 0000000080000000 (ACPI data)
 BIOS-e820: 00000000e0000000 - 00000000f0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
last_pfn = 0x7fff0 max_arch_pfn = 0x100000
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
kernel direct mapping tables up to 38000000 @ 7000-c000
Using x86 segment limits to approximate NX protection
RAMDISK: 37d55000 - 37fef675
DMI 2.3 present.
ACPI: RSDP 000F7C60, 0014 (r0 Nvidia)
ACPI: RSDT 7FFF3040, 0034 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: FACP 7FFF30C0, 0074 (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: DSDT 7FFF3180, 6A16 (r1 NVIDIA AWRDACPI     1000 MSFT  100000E)
ACPI: FACS 7FFF0000, 0040
ACPI: SSDT 7FFF9CC0, 020C (r1 PTLTD  POWERNOW        1  LTP        1)
ACPI: MCFG 7FFF9F40, 003C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
ACPI: APIC 7FFF9C00, 007C (r1 Nvidia AWRDACPI 42302E31 AWRD        0)
1151MB HIGHMEM available.
896MB LOWMEM available.
  mapped low ram: 0 - 38000000
  low ram: 00000000 - 38000000
  bootmap 00008000 - 0000f000
(9 early reservations) ==> bootmem [0000000000 - 0038000000]
  #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 0000001000]
  #1 [0000001000 - 0000002000]    EX TRAMPOLINE ==> [0000001000 - 0000002000]
  #2 [0000006000 - 0000007000]       TRAMPOLINE ==> [0000006000 - 0000007000]
  #3 [0000400000 - 00008d44d4]    TEXT DATA BSS ==> [0000400000 - 00008d44d4]
  #4 [0037d55000 - 0037fef675]          RAMDISK ==> [0037d55000 - 0037fef675]
  #5 [00008d5000 - 00008d9000]    INIT_PG_TABLE ==> [00008d5000 - 00008d9000]
  #6 [000009e000 - 0000100000]    BIOS reserved ==> [000009e000 - 0000100000]
  #7 [0000007000 - 0000008000]          PGTABLE ==> [0000007000 - 0000008000]
  #8 [0000008000 - 000000f000]          BOOTMAP ==> [0000008000 - 000000f000]
found SMP MP-table at [c00f5880] 000f5880
Zone PFN ranges:
  DMA      0x00000000 -> 0x00001000
  Normal   0x00001000 -> 0x00038000
  HighMem  0x00038000 -> 0x0007fff0
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
    0: 0x00000000 -> 0x0000009e
    0: 0x00000100 -> 0x0007fff0
On node 0 totalpages: 524174
free_area_init_node: node 0, pgdat c075da80, node_mem_map c1000000
  DMA zone: 3966 pages, LIFO batch:0
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 292592 pages, LIFO batch:31
Using APIC driver default
Nvidia board detected. Ignoring ACPI timer override.
If you got timer trouble try acpi_use_timer_override
ACPI: PM-Timer IO Port: 0x4008
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 17, address 0xfec00000, GSI 0-23
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
SMP: Allowing 2 CPUs, 0 hotplug CPUs
mapped APIC to ffffb000 (fee00000)
mapped IOAPIC to ffffa000 (fec00000)
PM: Registered nosave memory: 000000000009e000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 88000000 (gap: 80000000:60000000)
PERCPU: Allocating 41116 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 2, nr_node_ids 1
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 520078
Kernel command line: ro root=UUID=11068244-9ac9-4d0f-9995-8c0b98cd4396
rhgb quiet
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
CPU 0 irqstacks, hard=c0803000 soft=c07e3000
PID hash table entries: 4096 (order: 12, 16384 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PIT calibration value
Detected 2412.311 MHz processor.
spurious 8259A interrupt: IRQ7.
Console: colour VGA+ 80x25
console [tty0] enabled
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2070756k/2097088k available (2341k kernel code, 25028k
reserved, 1213k data, 392k init, 1179584k highmem)
virtual kernel memory layout:
    fixmap  : 0xffc57000 - 0xfffff000   (3744 kB)
    pkmap   : 0xff400000 - 0xff800000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff3fe000   ( 107 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc077e000 - 0xc07e0000   ( 392 kB)
      .data : 0xc0649678 - 0xc0778ae8   (1213 kB)
      .text : 0xc0400000 - 0xc0649678   (2341 kB)
Checking if this processor honours the WP bit even in supervisor mode...Ok.
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=12, HWalign=64, Order=0-3, MinObjects=0, CPUs=2, Nodes=1
Calibrating delay loop (skipped), value calculated using timer
frequency.. 4824.62 BogoMIPS (lpj=2412311)
Security Framework initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
Mount-cache hash table entries: 512
Initializing cgroup subsys ns
Initializing cgroup subsys cpuacct
Initializing cgroup subsys devices
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 0(2) -> Core 0
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
Checking 'hlt' instruction... OK.
ACPI: Core revision 20080609
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=0 apic2=-1 pin2=-1
..MP-BIOS bug: 8254 timer not connected to IO-APIC
...trying to set up timer (IRQ0) through the 8259A ...
..... (found apic 0 pin 0) ...
....... failed.
...trying to set up timer as Virtual Wire IRQ...
..... failed.
...trying to set up timer as ExtINT IRQ...
..... works.
CPU0: AMD Athlon(tm) 64 X2 Dual Core Processor 4800+ stepping 02
CPU 1 irqstacks, hard=c0804000 soft=c07e4000
Booting processor 1/1 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4823.88 BogoMIPS (lpj=2411940)
CPU: L1 I Cache: 64K (64 bytes/line), D cache 64K (64 bytes/line)
CPU: L2 Cache: 1024K (64 bytes/line)
CPU 1(2) -> Core 1
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: AMD Athlon(tm) 64 X2 Dual Core Processor 4800+ stepping 02
Brought up 2 CPUs
Total of 2 processors activated (9648.50 BogoMIPS).
sizeof(vma)=84 bytes
sizeof(page)=32 bytes
sizeof(inode)=340 bytes
sizeof(dentry)=132 bytes
sizeof(ext3inode)=492 bytes
sizeof(buffer_head)=56 bytes
sizeof(skbuff)=184 bytes
sizeof(task_struct)=3244 bytes
CPU0 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 0 1
CPU1 attaching sched-domain:
 domain 0: span 0-1 level CPU
  groups: 1 0
net_namespace: 840 bytes
Booting paravirtualized kernel on bare hardware
Time: 13:43:21  Date: 11/26/08
NET: Registered protocol family 16
No dock devices found.
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG for extended config space
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S1 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
HPET not enabled in BIOS. You might try hpet=force boot option
PCI: 0000:00:01.1 reg 10 io port: [e400, e41f]
PCI: 0000:00:01.1 reg 20 io port: [4c00, 4c3f]
PCI: 0000:00:01.1 reg 24 io port: [4c40, 4c7f]
pci 0000:00:01.1: PME# supported from D3hot D3cold
pci 0000:00:01.1: PME# disabled
PCI: 0000:00:02.0 reg 10 32bit mmio: [d5004000, d5004fff]
pci 0000:00:02.0: supports D1
pci 0000:00:02.0: supports D2
pci 0000:00:02.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.0: PME# disabled
PCI: 0000:00:02.1 reg 10 32bit mmio: [feb00000, feb000ff]
pci 0000:00:02.1: supports D1
pci 0000:00:02.1: supports D2
pci 0000:00:02.1: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:02.1: PME# disabled
PCI: 0000:00:04.0 reg 10 io port: [dc00, dcff]
PCI: 0000:00:04.0 reg 14 io port: [e000, e0ff]
PCI: 0000:00:04.0 reg 18 32bit mmio: [d5003000, d5003fff]
pci 0000:00:04.0: supports D1
pci 0000:00:04.0: supports D2
PCI: 0000:00:06.0 reg 20 io port: [f000, f00f]
PCI: 0000:00:07.0 reg 10 io port: [9f0, 9f7]
PCI: 0000:00:07.0 reg 14 io port: [bf0, bf3]
PCI: 0000:00:07.0 reg 18 io port: [970, 977]
PCI: 0000:00:07.0 reg 1c io port: [b70, b73]
PCI: 0000:00:07.0 reg 20 io port: [d800, d80f]
PCI: 0000:00:07.0 reg 24 32bit mmio: [d5002000, d5002fff]
PCI: 0000:00:08.0 reg 10 io port: [9e0, 9e7]
PCI: 0000:00:08.0 reg 14 io port: [be0, be3]
PCI: 0000:00:08.0 reg 18 io port: [960, 967]
PCI: 0000:00:08.0 reg 1c io port: [b60, b63]
PCI: 0000:00:08.0 reg 20 io port: [c400, c40f]
PCI: 0000:00:08.0 reg 24 32bit mmio: [d5001000, d5001fff]
PCI: 0000:00:0a.0 reg 10 32bit mmio: [d5000000, d5000fff]
PCI: 0000:00:0a.0 reg 14 io port: [b000, b007]
pci 0000:00:0a.0: supports D1
pci 0000:00:0a.0: supports D2
pci 0000:00:0a.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0a.0: PME# disabled
pci 0000:00:0b.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0b.0: PME# disabled
pci 0000:00:0c.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0c.0: PME# disabled
pci 0000:00:0d.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0d.0: PME# disabled
pci 0000:00:0e.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:00:0e.0: PME# disabled
PCI: 0000:05:0a.0 reg 10 io port: [9000, 9007]
PCI: 0000:05:0a.0 reg 14 io port: [9400, 9403]
PCI: 0000:05:0a.0 reg 18 io port: [9800, 9807]
PCI: 0000:05:0a.0 reg 1c io port: [9c00, 9c03]
PCI: 0000:05:0a.0 reg 20 io port: [a000, a00f]
PCI: 0000:05:0a.0 reg 24 32bit mmio: [d4000000, d40003ff]
PCI: 0000:05:0a.0 reg 30 32bit mmio: [d3000000, d307ffff]
pci 0000:05:0a.0: supports D1
pci 0000:05:0a.0: supports D2
pci 0000:00:09.0: transparent bridge
PCI: bridge 0000:00:09.0 io port: [9000, afff]
PCI: bridge 0000:00:09.0 32bit mmio: [d3000000, d4ffffff]
PCI: 0000:01:00.0 reg 10 32bit mmio: [d0000000, d0ffffff]
PCI: 0000:01:00.0 reg 14 64bit mmio: [c0000000, cfffffff]
PCI: 0000:01:00.0 reg 1c 64bit mmio: [d1000000, d1ffffff]
PCI: 0000:01:00.0 reg 30 32bit mmio: [d2000000, d201ffff]
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:0e.0. It can be
enabled forcedly with 'pcie_aspm=force'
PCI: bridge 0000:00:0e.0 32bit mmio: [d0000000, d2ffffff]
PCI: bridge 0000:00:0e.0 64bit mmio pref: [c0000000, cfffffff]
bus 00 -> node 0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNK3] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK4] (IRQs 3 4 5 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNK5] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUBB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LMAC] (IRQs *3 4 5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LACI] (IRQs 3 4 5 *7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LMCI] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSMB] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LUB2] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LIDE] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LSID] (IRQs 3 4 5 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LFID] (IRQs 3 4 *5 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LPCA] (IRQs 3 4 5 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [APC1] (IRQs 16) *0, disabled.
ACPI: PCI Interrupt Link [APC2] (IRQs 17) *0, disabled.
ACPI: PCI Interrupt Link [APC3] (IRQs 18) *0
ACPI: PCI Interrupt Link [APC4] (IRQs 19) *0
ACPI: PCI Interrupt Link [APC5] (IRQs *16), disabled.
ACPI: PCI Interrupt Link [APCF] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCG] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCH] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCK] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCS] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCL] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APCZ] (IRQs 20 21 22 23) *0, disabled.
ACPI: PCI Interrupt Link [APSI] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APSJ] (IRQs 20 21 22 23) *0
ACPI: PCI Interrupt Link [APCP] (IRQs 20 21 22 23) *0, disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 9 devices
ACPI: ACPI bus type pnp unregistered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
tracer: 772 pages allocated for 65536 entries of 48 bytes
   actual entries 65620
ACPI: RTC can wake from S4
system 00:01: ioport range 0x4000-0x407f has been reserved
system 00:01: ioport range 0x4080-0x40ff has been reserved
system 00:01: ioport range 0x4400-0x447f has been reserved
system 00:01: ioport range 0x4480-0x44ff has been reserved
system 00:01: ioport range 0x4800-0x487f has been reserved
system 00:01: ioport range 0x4880-0x48ff has been reserved
system 00:02: ioport range 0x4d0-0x4d1 has been reserved
system 00:02: ioport range 0x800-0x87f has been reserved
system 00:02: ioport range 0x290-0x297 has been reserved
system 00:07: iomem range 0xe0000000-0xefffffff could not be reserved
system 00:08: iomem range 0xf0000-0xf3fff could not be reserved
system 00:08: iomem range 0xf4000-0xf7fff could not be reserved
system 00:08: iomem range 0xf8000-0xfbfff could not be reserved
system 00:08: iomem range 0xfc000-0xfffff could not be reserved
system 00:08: iomem range 0x7fff0000-0x7fffffff could not be reserved
system 00:08: iomem range 0xffff0000-0xffffffff could not be reserved
system 00:08: iomem range 0x0-0x9ffff could not be reserved
system 00:08: iomem range 0x100000-0x7ffeffff could not be reserved
system 00:08: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:08: iomem range 0xfee00000-0xfeefffff could not be reserved
system 00:08: iomem range 0xfefff000-0xfeffffff could not be reserved
system 00:08: iomem range 0xfff80000-0xfff80fff could not be reserved
system 00:08: iomem range 0xfff90000-0xfffbffff could not be reserved
system 00:08: iomem range 0xfffed000-0xfffeffff could not be reserved
pci 0000:00:09.0: PCI bridge, secondary bus 0000:05
pci 0000:00:09.0:   IO window: 0x9000-0xafff
pci 0000:00:09.0:   MEM window: 0xd3000000-0xd4ffffff
pci 0000:00:09.0:   PREFETCH window: 0x00000088000000-0x000000880fffff
pci 0000:00:0b.0: PCI bridge, secondary bus 0000:04
pci 0000:00:0b.0:   IO window: disabled
pci 0000:00:0b.0:   MEM window: disabled
pci 0000:00:0b.0:   PREFETCH window: disabled
pci 0000:00:0c.0: PCI bridge, secondary bus 0000:03
pci 0000:00:0c.0:   IO window: disabled
pci 0000:00:0c.0:   MEM window: disabled
pci 0000:00:0c.0:   PREFETCH window: disabled
pci 0000:00:0d.0: PCI bridge, secondary bus 0000:02
pci 0000:00:0d.0:   IO window: disabled
pci 0000:00:0d.0:   MEM window: disabled
pci 0000:00:0d.0:   PREFETCH window: disabled
pci 0000:00:0e.0: PCI bridge, secondary bus 0000:01
pci 0000:00:0e.0:   IO window: disabled
pci 0000:00:0e.0:   MEM window: 0xd0000000-0xd2ffffff
pci 0000:00:0e.0:   PREFETCH window: 0x000000c0000000-0x000000cfffffff
pci 0000:00:09.0: setting latency timer to 64
pci 0000:00:0b.0: setting latency timer to 64
pci 0000:00:0c.0: setting latency timer to 64
pci 0000:00:0d.0: setting latency timer to 64
pci 0000:00:0e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 05 index 0 io port: [9000, afff]
bus: 05 index 1 mmio: [d3000000, d4ffffff]
bus: 05 index 2 mmio: [88000000, 880fffff]
bus: 05 index 3 io port: [0, ffff]
bus: 05 index 4 mmio: [0, ffffffffffffffff]
bus: 04 index 0 mmio: [0, 0]
bus: 04 index 1 mmio: [0, 0]
bus: 04 index 2 mmio: [0, 0]
bus: 04 index 3 mmio: [0, 0]
bus: 03 index 0 mmio: [0, 0]
bus: 03 index 1 mmio: [0, 0]
bus: 03 index 2 mmio: [0, 0]
bus: 03 index 3 mmio: [0, 0]
bus: 02 index 0 mmio: [0, 0]
bus: 02 index 1 mmio: [0, 0]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 01 index 0 mmio: [0, 0]
bus: 01 index 1 mmio: [d0000000, d2ffffff]
bus: 01 index 2 mmio: [c0000000, cfffffff]
bus: 01 index 3 mmio: [0, 0]
NET: Registered protocol family 2
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Freeing initrd memory: 2665k freed
apm: BIOS version 1.2 Flags 0x07 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
type=2000 audit(1227707000.405:1): initialized
highmem bounce pool size: 64 pages
HugeTLB registered 4 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
msgmni has been set to 1747
SELinux:  Registering netfilter hooks
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:00:00.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Enabling HT MSI Mapping
pci 0000:00:0b.0: Found enabled HT MSI Mapping
pci 0000:00:0b.0: Linking AER extended capability
pci 0000:00:0c.0: Enabling HT MSI Mapping
pci 0000:00:0c.0: Found enabled HT MSI Mapping
pci 0000:00:0c.0: Linking AER extended capability
pci 0000:00:0d.0: Enabling HT MSI Mapping
pci 0000:00:0d.0: Found enabled HT MSI Mapping
pci 0000:00:0d.0: Linking AER extended capability
pci 0000:00:0e.0: Enabling HT MSI Mapping
pci 0000:00:0e.0: Found enabled HT MSI Mapping
pci 0000:00:0e.0: Linking AER extended capability
pci 0000:01:00.0: Boot video device
pcieport-driver 0000:00:0b.0: setting latency timer to 64
pcieport-driver 0000:00:0b.0: found MSI capability
pci_express 0000:00:0b.0:pcie00: allocate port service
pci_express 0000:00:0b.0:pcie03: allocate port service
pcieport-driver 0000:00:0c.0: setting latency timer to 64
pcieport-driver 0000:00:0c.0: found MSI capability
pci_express 0000:00:0c.0:pcie00: allocate port service
pci_express 0000:00:0c.0:pcie03: allocate port service
pcieport-driver 0000:00:0d.0: setting latency timer to 64
pcieport-driver 0000:00:0d.0: found MSI capability
pci_express 0000:00:0d.0:pcie00: allocate port service
pci_express 0000:00:0d.0:pcie03: allocate port service
pcieport-driver 0000:00:0e.0: setting latency timer to 64
pcieport-driver 0000:00:0e.0: found MSI capability
pci_express 0000:00:0e.0:pcie00: allocate port service
pci_express 0000:00:0e.0:pcie03: allocate port service
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as
/devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
ACPI: Power Button (CM) [PWRB]
fan PNP0C0B:00: registered as cooling_device0
ACPI: Fan [FAN] (on)
processor ACPI0007:00: registered as cooling_device1
processor ACPI0007:01: registered as cooling_device2
thermal LNXTHERM:01: registered as thermal_zone0
ACPI: Thermal Zone [THRM] (40 C)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Non-volatile memory driver v1.2
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
brd: module loaded
loop: module loaded
input: Macintosh mouse button emulation as /devices/virtual/input/input2
PNP: No PS/2 controller found. Probing ports directly.
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one year, y3k
cpuidle: using governor ladder
cpuidle: using governor menu
usbcore: registered new interface driver hiddev
usbcore: registered new interface driver usbhid
usbhid: v2.6:USB HID core driver
TCP cubic registered
Initializing XFRM netlink socket
NET: Registered protocol family 17
Using IPI No-Shortcut mode
registered taskstats version 1
  Magic number: 0:49:737
Freeing unused kernel memory: 392k freed
Write protecting the kernel text: 2344k
Write protecting the kernel read-only data: 980k
ACPI: PCI Interrupt Link [APCL] enabled at IRQ 23
ehci_hcd 0000:00:02.1: PCI INT B -> Link[APCL] -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:02.1: setting latency timer to 64
ehci_hcd 0000:00:02.1: EHCI Host Controller
ehci_hcd 0000:00:02.1: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:02.1: debug port 1
ehci_hcd 0000:00:02.1: cache line size of 64 is not supported
ehci_hcd 0000:00:02.1: irq 23, io mem 0xfeb00000
ehci_hcd 0000:00:02.1: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 10 ports detected
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27.5-41.fc9.i686 ehci_hcd
usb usb1: SerialNumber: 0000:00:02.1
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
ACPI: PCI Interrupt Link [APCF] enabled at IRQ 22
ohci_hcd 0000:00:02.0: PCI INT A -> Link[APCF] -> GSI 22 (level, low) -> IRQ 22
ohci_hcd 0000:00:02.0: setting latency timer to 64
ohci_hcd 0000:00:02.0: OHCI Host Controller
ohci_hcd 0000:00:02.0: new USB bus registered, assigned bus number 2
ohci_hcd 0000:00:02.0: irq 22, io mem 0xd5004000
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 10 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0001
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: OHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27.5-41.fc9.i686 ohci_hcd
usb usb2: SerialNumber: 0000:00:02.0
USB Universal Host Controller Interface driver v3.0
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
usb 2-1: new full speed USB device using ohci_hcd and address 2
libata version 3.00 loaded.
sata_nv 0000:00:07.0: version 3.5
ACPI: PCI Interrupt Link [APSI] enabled at IRQ 21
sata_nv 0000:00:07.0: PCI INT A -> Link[APSI] -> GSI 21 (level, low) -> IRQ 21
sata_nv 0000:00:07.0: setting latency timer to 64
scsi0 : sata_nv
scsi1 : sata_nv
ata1: SATA max UDMA/133 cmd 0x9f0 ctl 0xbf0 bmdma 0xd800 irq 21
ata2: SATA max UDMA/133 cmd 0x970 ctl 0xb70 bmdma 0xd808 irq 21
usb 2-1: configuration #1 chosen from 1 choice
hub 2-1:1.0: USB hub found
hub 2-1:1.0: 3 ports detected
ata1: SATA link down (SStatus 0 SControl 300)
usb 2-1: New USB device found, idVendor=046d, idProduct=0b04
usb 2-1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
usb 2-1: Product: Logitech BT Mini-Receiver
usb 2-1: Manufacturer: Logitech
usb 2-1.2: new full speed USB device using ohci_hcd and address 3
usb 2-1.2: configuration #1 chosen from 1 choice
input: Logitech Logitech BT Mini-Receiver as
/devices/pci0000:00/0000:00:02.0/usb2/2-1/2-1.2/2-1.2:1.0/input/input3
input,hidraw0: USB HID v1.11 Keyboard [Logitech Logitech BT
Mini-Receiver] on usb-0000:00:02.0-1.2
usb 2-1.2: New USB device found, idVendor=046d, idProduct=c713
usb 2-1.2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1.2: Product: Logitech BT Mini-Receiver
usb 2-1.2: Manufacturer: Logitech
usb 2-1.2: SerialNumber: 0007617BDD84
ata2: SATA link down (SStatus 0 SControl 300)
ACPI: PCI Interrupt Link [APSJ] enabled at IRQ 20
sata_nv 0000:00:08.0: PCI INT A -> Link[APSJ] -> GSI 20 (level, low) -> IRQ 20
sata_nv 0000:00:08.0: setting latency timer to 64
scsi2 : sata_nv
scsi3 : sata_nv
ata3: SATA max UDMA/133 cmd 0x9e0 ctl 0xbe0 bmdma 0xc400 irq 20
ata4: SATA max UDMA/133 cmd 0x960 ctl 0xb60 bmdma 0xc408 irq 20
usb 2-1.3: new full speed USB device using ohci_hcd and address 4
usb 2-1.3: configuration #1 chosen from 1 choice
input: Logitech Logitech BT Mini-Receiver as
/devices/pci0000:00/0000:00:02.0/usb2/2-1/2-1.3/2-1.3:1.0/input/input4
input,hiddev96,hidraw1: USB HID v1.11 Mouse [Logitech Logitech BT
Mini-Receiver] on usb-0000:00:02.0-1.3
usb 2-1.3: New USB device found, idVendor=046d, idProduct=c714
usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 2-1.3: Product: Logitech BT Mini-Receiver
usb 2-1.3: Manufacturer: Logitech
usb 2-1.3: SerialNumber: 0007617BDD84
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: ATA-8: WDC WD5000AAKS-00A7B0, 01.03B01, max UDMA/133
ata3.00: 976773168 sectors, multi 1: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      WDC WD5000AAKS-0 01.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 2:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
sd 2:0:0:0: [sda] Write Protect is off
sd 2:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda: sda1 sda2 sda3 sda4
sd 2:0:0:0: [sda] Attached SCSI disk
pata_acpi 0000:00:06.0: setting latency timer to 64
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
type=1404 audit(1227707008.820:2): selinux=0 auid=4294967295 ses=4294967295
sd 2:0:0:0: Attached scsi generic sg0 type 0
pata_amd 0000:00:06.0: version 0.3.10
pata_amd 0000:00:06.0: setting latency timer to 64
scsi4 : pata_amd
scsi5 : pata_amd
ata5: PATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata6: PATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
input: PC Speaker as /devices/platform/pcspkr/input/input5
ata5.01: ATAPI: BENQ    DVD LS DW1655, BCIB, max UDMA/33
ata5: nv_mode_filter: 0x739f&0x701f->0x701f, BIOS=0x7000 (0xc00000)
ACPI=0x701f (600:60:0x1c)
ata5.01: configured for UDMA/33
ata6: port disabled. ignoring.
scsi 4:0:1:0: CD-ROM            BENQ     DVD LS DW1655    BCIB PQ: 0 ANSI: 5
scsi 4:0:1:0: Attached scsi generic sg1 type 5
i2c-adapter i2c-0: nForce2 SMBus adapter at 0x4c00
i2c-adapter i2c-1: nForce2 SMBus adapter at 0x4c40
forcedeth: Reverse Engineered nForce ethernet driver. Version 0.61.
ACPI: PCI Interrupt Link [APCH] enabled at IRQ 23
forcedeth 0000:00:0a.0: PCI INT A -> Link[APCH] -> GSI 23 (level, low) -> IRQ 23
forcedeth 0000:00:0a.0: setting latency timer to 64
nv_probe: set workaround bit for reversed mac addr
nvidia: module license 'NVIDIA' taints kernel.
forcedeth 0000:00:0a.0: ifname eth0, PHY OUI 0x5043 @ 9, addr 00:15:f2:06:b5:70
forcedeth 0000:00:0a.0: highdma csum timirq gbit lnktim desc-v3
sata_sil 0000:05:0a.0: version 2.3
ACPI: PCI Interrupt Link [APC4] enabled at IRQ 19
sata_sil 0000:05:0a.0: PCI INT A -> Link[APC4] -> GSI 19 (level, low) -> IRQ 19
sata_sil 0000:05:0a.0: Applying R_ERR on DMA activate FIS errata fix
scsi6 : sata_sil
scsi7 : sata_sil
scsi8 : sata_sil
scsi9 : sata_sil
ata7: SATA max UDMA/100 mmio m1024@0xd4000000 tf 0xd4000080 irq 19
ata8: SATA max UDMA/100 mmio m1024@0xd4000000 tf 0xd40000c0 irq 19
ata9: SATA max UDMA/100 mmio m1024@0xd4000000 tf 0xd4000280 irq 19
ata10: SATA max UDMA/100 mmio m1024@0xd4000000 tf 0xd40002c0 irq 19
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:1:0: Attached scsi CD-ROM sr0
ACPI: PCI Interrupt Link [APCJ] enabled at IRQ 22
Intel ICH 0000:00:04.0: PCI INT A -> Link[APCJ] -> GSI 22 (level, low) -> IRQ 22
Intel ICH 0000:00:04.0: setting latency timer to 64
ata7: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata7.00: ATA-7: WDC WD5000ABYS-01TNA0, 12.01C01, max UDMA/133
ata7.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata7.00: configured for UDMA/100
intel8x0_measure_ac97_clock: measured 50457 usecs
intel8x0: clocking to 46876
ata8: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata8.00: ATA-7: WDC WD5000ABYS-01TNA0, 12.01C01, max UDMA/133
ata8.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata8.00: configured for UDMA/100
ata9: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata9.00: ATA-8: WDC WD5001ABYS-01YNA0, 59.01D01, max UDMA/133
ata9.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata9.00: configured for UDMA/100
ata10: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata10.00: ATA-7: WDC WD5000YS-01MPB1, 09.02E09, max UDMA/133
ata10.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata10.00: configured for UDMA/100
scsi 6:0:0:0: Direct-Access     ATA      WDC WD5000ABYS-0 12.0 PQ: 0 ANSI: 5
sd 6:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 6:0:0:0: [sdb] 976773168 512-byte hardware sectors (500108 MB)
sd 6:0:0:0: [sdb] Write Protect is off
sd 6:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb: sdb1
sd 6:0:0:0: [sdb] Attached SCSI disk
sd 6:0:0:0: Attached scsi generic sg2 type 0
scsi 7:0:0:0: Direct-Access     ATA      WDC WD5000ABYS-0 12.0 PQ: 0 ANSI: 5
sd 7:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 7:0:0:0: [sdc] Write Protect is off
sd 7:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 7:0:0:0: [sdc] 976773168 512-byte hardware sectors (500108 MB)
sd 7:0:0:0: [sdc] Write Protect is off
sd 7:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdc: sdc1
sd 7:0:0:0: [sdc] Attached SCSI disk
sd 7:0:0:0: Attached scsi generic sg3 type 0
scsi 8:0:0:0: Direct-Access     ATA      WDC WD5001ABYS-0 59.0 PQ: 0 ANSI: 5
sd 8:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 8:0:0:0: [sdd] Write Protect is off
sd 8:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 8:0:0:0: [sdd] 976773168 512-byte hardware sectors (500108 MB)
sd 8:0:0:0: [sdd] Write Protect is off
sd 8:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 8:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdd: sdd1
sd 8:0:0:0: [sdd] Attached SCSI disk
sd 8:0:0:0: Attached scsi generic sg4 type 0
scsi 9:0:0:0: Direct-Access     ATA      WDC WD5000YS-01M 09.0 PQ: 0 ANSI: 5
sd 9:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 9:0:0:0: [sde] Write Protect is off
sd 9:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 9:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
sd 9:0:0:0: [sde] 976773168 512-byte hardware sectors (500108 MB)
sd 9:0:0:0: [sde] Write Protect is off
sd 9:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 9:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sde: sde1
sd 9:0:0:0: [sde] Attached SCSI disk
sd 9:0:0:0: Attached scsi generic sg5 type 0
ACPI: PCI Interrupt Link [APC3] enabled at IRQ 18
nvidia 0000:01:00.0: PCI INT A -> Link[APC3] -> GSI 18 (level, low) -> IRQ 18
nvidia 0000:01:00.0: setting latency timer to 64
NVRM: loading NVIDIA UNIX x86 Kernel Module  177.80  Wed Oct  1
14:38:10 PDT 2008
md: bind<sdd1>
md: bind<sdb1>
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: dm-devel@redhat.com
device-mapper: multipath: version 1.0.5 loaded
EXT3 FS on sda1, internal journal
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda4, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
Adding 1052248k swap on /dev/sda3.  Priority:-1 extents:1 across:1052248k
powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 4800+
processors (2 cpu cores) (version 2.20.00)
powernow-k8:    0 : fid 0x10 (2400 MHz), vid 0x8
powernow-k8:    1 : fid 0xe (2200 MHz), vid 0xa
powernow-k8:    2 : fid 0xc (2000 MHz), vid 0xc
powernow-k8:    3 : fid 0xa (1800 MHz), vid 0xe
powernow-k8:    4 : fid 0x2 (1000 MHz), vid 0x12
RPC: Registered udp transport module.
RPC: Registered tcp transport module.
Clocksource tsc unstable (delta = -63090927 ns)
warning: `dbus-daemon' uses deprecated v2 capabilities in a way that
may be insecure.
fuse init (API version 7.9)
it87: Found IT8712F chip at 0x290, revision 7
it87: in3 is VCC (+5V)
it87: in7 is VCCH (+5V Stand-By)
ip_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Plase use
nf_conntrack.acct=1 kernel paramater, acct=1 nf_conntrack module option or
sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
md: md0 stopped.
eth0: no IPv6 routers present
md: md0 stopped.
md: md0 stopped.
md: md0 stopped.
[root@zeus ~]#

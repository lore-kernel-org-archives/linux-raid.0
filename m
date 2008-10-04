From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: exception Emask 0x0 SAct 0x1 / SErr 0x0 action 0x2 frozen
Date: Sat, 4 Oct 2008 04:11:37 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0810040410170.14969@p34.internal.lan>
References: <3E6D0C24877245C3A5A327129A7B4CA7@909927SOSLA>  <alpine.DEB.1.10.0809220828490.23159@p34.internal.lan>  <5419A02543384E69AF2BA82FF6E66C14@909927SOSLA>  <alpine.DEB.1.10.0809220903400.23159@p34.internal.lan>  <4B1ABD0393EF40FFB0A12242FE8356AF@909927SOSLA>
  <alpine.DEB.1.10.0809220915470.23159@p34.internal.lan>  <alpine.DEB.1.10.0809220926240.23159@p34.internal.lan>  <e7510f760809231114y6cbaf13aqf7c63bd48a73c978@mail.gmail.com>  <48DBAB81.8050900@tmr.com> <48E08E2D.6050905@kernel.org>
 <a52a95e30809301347s70b57ebfh280a6871329afd72@mail.gmail.com> <alpine.DEB.1.10.0809301715280.14600@p34.internal.lan> <alpine.LNX.2.00.0809301946020.16014@filesrv1.baby-dragons.com> <alpine.DEB.1.10.0810010403500.16900@p34.internal.lan>
 <alpine.DEB.1.10.0810010710520.22435@p34.internal.lan> <48E6D481.7050407@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <48E6D481.7050407@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, Tom Mortensen <tmmlkml@gmail.com>, Bill Davidsen <davidsen@tmr.com>, Gwendal Grignou <gwendal@google.com>, Brian Rademacher <rad@radfiles.net>, linux-ide@vger.kernel.org, linux-raid maillist <linux-raid@vger.kernel.org>, Linux Kernel Maillist <linux-kernel@vger.kernel.org>, Bruce Allen <ballen@gravity.phys.uwm.edu>
List-Id: linux-raid.ids



On Sat, 4 Oct 2008, Tejun Heo wrote:

> Justin Piszcz wrote:
>
> You're leaving the good part out.  Please always attach full kernel
> log.
>
> Thanks.

Full log below:

[    0.000000] Linux version 2.6.26.5 (root@p34.internal.lan) (gcc version 4.3.1 (Debian 4.3.1-2) ) #1 SMP Tue Sep 9 04:07:56 EDT 2008
[    0.000000] Command line: auto BOOT_IMAGE=2.6.26.5-1 ro root=902
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000008f000 (usable)
[    0.000000]  BIOS-e820: 000000000008f000 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cf58f000 (usable)
[    0.000000]  BIOS-e820: 00000000cf58f000 - 00000000cf59c000 (reserved)
[    0.000000]  BIOS-e820: 00000000cf59c000 - 00000000cf639000 (usable)
[    0.000000]  BIOS-e820: 00000000cf639000 - 00000000cf694000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf694000 - 00000000cf697000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf697000 - 00000000cf6ef000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cf6ef000 - 00000000cf6f1000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf6f1000 - 00000000cf6f2000 (usable)
[    0.000000]  BIOS-e820: 00000000cf6f2000 - 00000000cf6ff000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cf6ff000 - 00000000cf700000 (usable)
[    0.000000]  BIOS-e820: 00000000cf700000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000f0000000 - 00000000f8000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 000000022c000000 (usable)
[    0.000000] Entering add_active_range(0, 0, 143) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 849295) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 849308, 849465) 2 entries of 256 used
[    0.000000] Entering add_active_range(0, 849649, 849650) 3 entries of 256 used
[    0.000000] Entering add_active_range(0, 849663, 849664) 4 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 2277376) 5 entries of 256 used
[    0.000000] max_pfn_mapped = 2277376
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] init_memory_mapping
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT CF6FD038, 0050 (r1 INTEL  DG965WH       6D7       1000013)
[    0.000000] ACPI: FACP CF6FC000, 0074 (r1 INTEL  DG965WH       6D7 MSFT  1000013)
[    0.000000] ACPI: DSDT CF6F7000, 41E6 (r1 INTEL  DG965WH       6D7 MSFT  1000013)
[    0.000000] ACPI: FACS CF697000, 0040
[    0.000000] ACPI: APIC CF6F6000, 0078 (r1 INTEL  DG965WH       6D7 MSFT  1000013)
[    0.000000] ACPI: WDDT CF6F5000, 0040 (r1 INTEL  DG965WH       6D7 MSFT  1000013)
[    0.000000] ACPI: MCFG CF6F4000, 003C (r1 INTEL  DG965WH       6D7 MSFT  1000013)
[    0.000000] ACPI: ASF! CF6F3000, 00A6 (r32 INTEL  DG965WH       6D7 MSFT  1000013)
[    0.000000] ACPI: HPET CF6F2000, 0038 (r1 INTEL  DG965WH       6D7 MSFT  1000013)
[    0.000000] ACPI: SSDT CF6F0000, 020C (r1 INTEL     CpuPm      6D7 MSFT  1000013)
[    0.000000] ACPI: SSDT CF6EF000, 0175 (r1 INTEL   Cpu0Ist      6D7 MSFT  1000013)
[    0.000000] ACPI: SSDT CF696000, 0175 (r1 INTEL   Cpu1Ist      6D7 MSFT  1000013)
[    0.000000] ACPI: SSDT CF695000, 0175 (r1 INTEL   Cpu2Ist      6D7 MSFT  1000013)
[    0.000000] ACPI: SSDT CF694000, 0175 (r1 INTEL   Cpu3Ist      6D7 MSFT  1000013)
[    0.000000] Entering add_active_range(0, 0, 143) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 849295) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 849308, 849465) 2 entries of 256 used
[    0.000000] Entering add_active_range(0, 849649, 849650) 3 entries of 256 used
[    0.000000] Entering add_active_range(0, 849663, 849664) 4 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 2277376) 5 entries of 256 used
[    0.000000]   early res: 0 [0-fff] BIOS data page
[    0.000000]   early res: 1 [6000-7fff] TRAMPOLINE
[    0.000000]   early res: 2 [200000-7e1487] TEXT DATA BSS
[    0.000000]   early res: 3 [9b800-fffff] BIOS reserved
[    0.000000]   early res: 4 [8000-11fff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe20007bfffff] PMD -> [ffff81000c200000-ffff810013dfffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA             0 ->     4096
[    0.000000]   DMA32        4096 ->  1048576
[    0.000000]   Normal    1048576 ->  2277376
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[6] active PFN ranges
[    0.000000]     0:        0 ->      143
[    0.000000]     0:      256 ->   849295
[    0.000000]     0:   849308 ->   849465
[    0.000000]     0:   849649 ->   849650
[    0.000000]     0:   849663 ->   849664
[    0.000000]     0:  1048576 ->  2277376
[    0.000000] On node 0 totalpages: 2078141
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 1620 pages reserved
[    0.000000]   DMA zone: 2307 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 831078 pages, LIFO batch:31
[    0.000000]   Normal zone: 16800 pages used for memmap
[    0.000000]   Normal zone: 1212000 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at d2000000 (gap: d0000000:20000000)
[    0.000000] PERCPU: Allocating 22512 bytes of per cpu data
[    0.000000] NR_CPUS: 4, nr_cpu_ids: 4
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2045385
[    0.000000] Kernel command line: auto BOOT_IMAGE=2.6.26.5-1 ro root=902
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000000] time.c: Detected 2397.602 MHz processor.
[    0.000999] Console: colour dummy device 80x25
[    0.000999] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000999] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000999] Checking aperture...
[    0.000999] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000999] Placing software IO TLB between 0x1c23000 - 0x5c23000
[    0.000999] Memory: 8100176k/9109504k available (4046k kernel code, 211664k reserved, 1275k data, 260k init)
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] hpet clockevent registered
[    0.060982] Calibrating delay using timer specific routine.. 4797.88 BogoMIPS (lpj=2398942)
[    0.060999] Mount-cache hash table entries: 256
[    0.060999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.060999] CPU: L2 cache: 4096K
[    0.060999] CPU: Physical Processor ID: 0
[    0.060999] CPU: Processor Core ID: 0
[    0.060999] CPU0: Thermal monitoring enabled (TM2)
[    0.060999] using mwait in idle threads.
[    0.060999] Freeing SMP alternatives: 33k freed
[    0.060999] ACPI: Core revision 20080321
[    0.077331] CPU0: Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.077336] Using local APIC timer interrupts.
[    0.078999] APIC timer calibration result 16650012
[    0.078999] Detected 16.650 MHz APIC timer.
[    0.078999] Booting processor 1/2 ip 6000
[    0.088986] Initializing CPU#1
[    0.088986] Calibrating delay using timer specific routine.. 4891.18 BogoMIPS (lpj=2445590)
[    0.088986] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.088986] CPU: L2 cache: 4096K
[    0.088986] CPU: Physical Processor ID: 0
[    0.088986] CPU: Processor Core ID: 2
[    0.088986] CPU1: Thermal monitoring enabled (TM2)
[    0.088986] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.150357] CPU1: Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.150387] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.151999] Booting processor 2/1 ip 6000
[    0.162975] Initializing CPU#2
[    0.162975] Calibrating delay using timer specific routine.. 4796.08 BogoMIPS (lpj=2398042)
[    0.162975] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.162975] CPU: L2 cache: 4096K
[    0.162975] CPU: Physical Processor ID: 0
[    0.162975] CPU: Processor Core ID: 1
[    0.162975] CPU2: Thermal monitoring enabled (TM2)
[    0.162975] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.223889] CPU2: Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.223919] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.224999] Booting processor 3/3 ip 6000
[    0.234964] Initializing CPU#3
[    0.234964] Calibrating delay using timer specific routine.. 4795.27 BogoMIPS (lpj=2397638)
[    0.234964] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.234964] CPU: L2 cache: 4096K
[    0.234964] CPU: Physical Processor ID: 0
[    0.234964] CPU: Processor Core ID: 3
[    0.234964] CPU3: Thermal monitoring enabled (TM2)
[    0.234964] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.296790] CPU3: Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.296818] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.297999] Brought up 4 CPUs
[    0.297999] Total of 4 processors activated (19280.42 BogoMIPS).
[    0.297999] net_namespace: 944 bytes
[    0.297999] xor: automatically using best checksumming function: generic_sse
[    0.302336]    generic_sse:  8544.000 MB/sec
[    0.302338] xor: using function: generic_sse (8544.000 MB/sec)
[    0.302393] NET: Registered protocol family 16
[    0.302999] No dock devices found.
[    0.302999] ACPI: bus type pci registered
[    0.302999] PCI: MCFG configuration 0: base f0000000 segment 0 buses 0 - 127
[    0.302999] PCI: MCFG area at f0000000 reserved in E820
[    0.306950] PCI: Using MMCONFIG at f0000000 - f7ffffff
[    0.306953] PCI: Using configuration type 1 for base access
[    0.309410] ACPI: EC: Look up EC in DSDT
[    0.312464] ACPI: Interpreter enabled
[    0.312467] ACPI: (supports S0 S5)
[    0.312483] ACPI: Using IOAPIC for interrupt routing
[    0.316999] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.317819] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.317825] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.318802] PCI: Transparent bridge - 0000:00:1e.0
[    0.318835] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.318999] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.319233] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.319337] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.319429] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.319522] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.319614] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.324999] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.324999] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[    0.324999] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.324999] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.324999] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
[    0.324999] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[    0.325090] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[    0.325177] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.325999] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.325999] pnp: PnP ACPI init
[    0.325999] ACPI: bus type pnp registered
[    0.328999] pnp: PnP ACPI: found 11 devices
[    0.328999] ACPI: ACPI bus type pnp unregistered
[    0.328999] SCSI subsystem initialized
[    0.328999] libata version 3.00 loaded.
[    0.328999] usbcore: registered new interface driver usbfs
[    0.328999] usbcore: registered new interface driver hub
[    0.328999] usbcore: registered new device driver usb
[    0.328999] PCI: Using ACPI for IRQ routing
[    0.333945] PCI-GART: No AMD northbridge found.
[    0.333952] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.333959] hpet0: 3 64-bit timers, 14318180 Hz
[    0.340041] system 00:01: iomem range 0xf0000000-0xf7ffffff could not be reserved
[    0.340048] system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
[    0.340053] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.340057] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.340062] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.340066] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.340071] system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.340075] system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
[    0.340080] system 00:01: iomem range 0xc0000-0xdffff has been reserved
[    0.340080] system 00:01: iomem range 0xe0000-0xfffff could not be reserved
[    0.340080] system 00:06: ioport range 0x500-0x53f has been reserved
[    0.340080] system 00:06: ioport range 0x400-0x47f has been reserved
[    0.340080] system 00:06: ioport range 0x360-0x361 has been reserved
[    0.340080] system 00:06: ioport range 0x680-0x6ff has been reserved
[    0.340080] PCI: Bridge: 0000:00:01.0
[    0.340080]   IO window: 6000-6fff
[    0.340080]   MEM window: 0xe0600000-0xe06fffff
[    0.340080]   PREFETCH window: disabled.
[    0.340080] PCI: Bridge: 0000:00:1c.0
[    0.340080]   IO window: disabled.
[    0.340080]   MEM window: disabled.
[    0.340080]   PREFETCH window: disabled.
[    0.340080] PCI: Bridge: 0000:00:1c.1
[    0.340080]   IO window: 5000-5fff
[    0.340080]   MEM window: 0xe0400000-0xe04fffff
[    0.340080]   PREFETCH window: disabled.
[    0.340080] PCI: Bridge: 0000:00:1c.2
[    0.340080]   IO window: 4000-4fff
[    0.340080]   MEM window: 0xe0300000-0xe03fffff
[    0.340080]   PREFETCH window: 0x00000000e0800000-0x00000000e08fffff
[    0.340080] PCI: Bridge: 0000:00:1c.3
[    0.340080]   IO window: 3000-3fff
[    0.340080]   MEM window: 0xe0200000-0xe02fffff
[    0.340080]   PREFETCH window: 0x00000000e0900000-0x00000000e09fffff
[    0.340080] PCI: Bridge: 0000:00:1c.4
[    0.340080]   IO window: 2000-2fff
[    0.340080]   MEM window: 0xe0100000-0xe01fffff
[    0.340080]   PREFETCH window: 0x00000000e0a00000-0x00000000e0afffff
[    0.340080] PCI: Bridge: 0000:00:1e.0
[    0.340080]   IO window: 1000-1fff
[    0.340080]   MEM window: 0xe0000000-0xe00fffff
[    0.340080]   PREFETCH window: 0x00000000e0b00000-0x00000000e0bfffff
[    0.340080] ACPI: PCI Interrupt 0000:00:01.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.340080] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.340080] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.340080] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.340080] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
[    0.340080] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.340080] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[    0.340080] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.340080] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[    0.340080] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.340080] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17
[    0.340080] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    0.340080] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.340080] NET: Registered protocol family 2
[    0.351409] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.352023] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.353612] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.354200] TCP: Hash tables configured (established 262144 bind 65536)
[    0.354204] TCP reno registered
[    0.356515] NET: Registered protocol family 1
[    0.359536] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.359536] SGI XFS with security attributes, large block/inode numbers, no debug enabled
[    0.360443] msgmni has been set to 15822
[    0.360443] async_tx: api initialized (sync-only)
[    0.360443] io scheduler noop registered
[    0.360443] io scheduler cfq registered (default)
[    0.360443] pci 0000:00:02.0: Boot video device
[    0.360443] PCI: Setting latency timer of device 0000:00:01.0 to 64
[    0.360443] assign_interrupt_mode Found MSI capability
[    0.360443] Allocate Port Service[0000:00:01.0:pcie00]
[    0.360443] Allocate Port Service[0000:00:01.0:pcie03]
[    0.360443] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.360443] assign_interrupt_mode Found MSI capability
[    0.360453] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.361415] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.361415] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.361415] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.361415] assign_interrupt_mode Found MSI capability
[    0.361452] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.361452] Allocate Port Service[0000:00:1c.1:pcie02]
[    0.361452] Allocate Port Service[0000:00:1c.1:pcie03]
[    0.361452] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.361452] assign_interrupt_mode Found MSI capability
[    0.361452] Allocate Port Service[0000:00:1c.2:pcie00]
[    0.361452] Allocate Port Service[0000:00:1c.2:pcie02]
[    0.361452] Allocate Port Service[0000:00:1c.2:pcie03]
[    0.361452] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.361452] assign_interrupt_mode Found MSI capability
[    0.361452] Allocate Port Service[0000:00:1c.3:pcie00]
[    0.361452] Allocate Port Service[0000:00:1c.3:pcie02]
[    0.361452] Allocate Port Service[0000:00:1c.3:pcie03]
[    0.361452] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    0.361452] assign_interrupt_mode Found MSI capability
[    0.361452] Allocate Port Service[0000:00:1c.4:pcie00]
[    0.361452] Allocate Port Service[0000:00:1c.4:pcie02]
[    0.361452] Allocate Port Service[0000:00:1c.4:pcie03]
[    0.363436] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20008100000, using 2560k, total 7616k
[    0.363436] vesafb: mode is 1280x1024x8, linelength=1280, pages=4
[    0.363436] vesafb: scrolling: redraw
[    0.363436] vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
[    0.372701] Console: switching to colour frame buffer device 160x64
[    0.383379] fb0: VESA VGA frame buffer device
[    0.384516] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.384633] ACPI: Power Button (FF) [PWRF]
[    0.384633] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.384633] ACPI: Sleep Button (CM) [SLPB]
[    0.395819] Real Time Clock Driver v1.12ac
[    0.395819] hpet_resources: 0xfed00000 is busy
[    0.395819] Linux agpgart interface v0.103
[    0.395819] agpgart: Detected an Intel 965G Chipset.
[    0.396883] agpgart: Detected 7676K stolen memory.
[    0.409896] agpgart: AGP aperture is 256M @ 0xd0000000
[    0.410086] [drm] Initialized drm 1.1.0 20060810
[    0.410086] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.410086] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.410086] [drm] Initialized i915 1.6.0 20060119 on minor 0
[    0.410914] loop: module loaded
[    0.410914] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[    0.410914] Copyright (c) 1999-2006 Intel Corporation.
[    0.410947] ACPI: PCI Interrupt 0000:07:00.0[A] -> GSI 21 (level, low) -> IRQ 21
[    0.506018] Switched to high resolution mode on CPU 2
[    0.506173] Switched to high resolution mode on CPU 1
[    0.506276] Switched to high resolution mode on CPU 3
[    0.507166] Switched to high resolution mode on CPU 0
[    0.658662] e1000: 0000:07:00.0: e1000_probe: (PCI:33MHz:32-bit) 00:07:e9:29:37:db
[    0.684853] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[    0.684962] ACPI: PCI Interrupt 0000:07:01.0[A] -> GSI 22 (level, low) -> IRQ 22
[    0.947375] e1000: 0000:07:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:0e:0c:00:cd:b1
[    1.094777] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
[    1.095074] e1000e: Intel(R) PRO/1000 Network Driver - 0.3.3.3-k2
[    1.095156] e1000e: Copyright (c) 1999-2008 Intel Corporation.
[    1.095261] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[    1.095375] PCI: Setting latency timer of device 0000:00:19.0 to 64
[    1.280985] eth2: (PCI Express:2.5GB/s:Width x1) 00:19:d1:6e:9d:43
[    1.281070] eth2: Intel(R) PRO/1000 Network Connection
[    1.281159] eth2: MAC: 4, PHY: 6, PBA No: ffffff-0ff
[    1.281375] console [netcon0] enabled
[    1.281375] netconsole: network logging started
[    1.281375] Driver 'sd' needs updating - please use bus_type methods
[    1.281375] Driver 'sr' needs updating - please use bus_type methods
[    1.281840] ahci 0000:00:1f.2: version 3.0
[    1.281854] ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
[    2.282542] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    2.282652] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part 
[    2.282747] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    2.283416] scsi0 : ahci
[    2.283424] scsi1 : ahci
[    2.283424] scsi2 : ahci
[    2.283424] scsi3 : ahci
[    2.286695] scsi4 : ahci
[    2.289136] scsi5 : ahci
[    2.291581] ata1: SATA max UDMA/133 abar m2048@0xe0725000 port 0xe0725100 irq 377
[    2.294009] ata2: SATA max UDMA/133 abar m2048@0xe0725000 port 0xe0725180 irq 377
[    2.296206] ata3: SATA max UDMA/133 abar m2048@0xe0725000 port 0xe0725200 irq 377
[    2.298588] ata4: SATA max UDMA/133 abar m2048@0xe0725000 port 0xe0725280 irq 377
[    2.301013] ata5: SATA max UDMA/133 abar m2048@0xe0725000 port 0xe0725300 irq 377
[    2.303411] ata6: SATA max UDMA/133 abar m2048@0xe0725000 port 0xe0725380 irq 377
[    2.610959] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.626983] ata1.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    2.629581] ata1.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.636021] ata1.00: configured for UDMA/133
[    2.944360] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.960154] ata2.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    2.962987] ata2.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.967872] ata2.00: configured for UDMA/133
[    3.276360] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.292021] ata3.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    3.295022] ata3.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.302624] ata3.00: configured for UDMA/133
[    3.611360] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.627859] ata4.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    3.631023] ata4.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.638555] ata4.00: configured for UDMA/133
[    3.947214] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.961021] ata5.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    3.964257] ata5.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.971913] ata5.00: configured for UDMA/133
[    4.280211] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.296021] ata6.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    4.299022] ata6.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.306724] ata6.00: configured for UDMA/133
[    4.312416] scsi 0:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    4.314287] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
[    4.317386] sd 0:0:0:0: [sda] Write Protect is off
[    4.320889] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.320906] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.324230] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
[    4.327547] sd 0:0:0:0: [sda] Write Protect is off
[    4.330901] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.330918] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.334218]  sda: sda1
[    4.340378] sd 0:0:0:0: [sda] Attached SCSI disk
[    4.344018] scsi 1:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    4.347439] sd 1:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
[    4.350461] sd 1:0:0:0: [sdb] Write Protect is off
[    4.353976] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.353994] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.357298] sd 1:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
[    4.360581] sd 1:0:0:0: [sdb] Write Protect is off
[    4.363899] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    4.363925] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.367147]  sdb: sdb1
[    4.373624] sd 1:0:0:0: [sdb] Attached SCSI disk
[    4.377076] scsi 2:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    4.380509] sd 2:0:0:0: [sdc] 586072368 512-byte hardware sectors (300069 MB)
[    4.383808] sd 2:0:0:0: [sdc] Write Protect is off
[    4.387017] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.387035] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.390343] sd 2:0:0:0: [sdc] 586072368 512-byte hardware sectors (300069 MB)
[    4.393703] sd 2:0:0:0: [sdc] Write Protect is off
[    4.397063] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    4.397081] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.400473]  sdc: sdc1 sdc2 sdc3
[    4.411576] sd 2:0:0:0: [sdc] Attached SCSI disk
[    4.415229] scsi 3:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    4.418753] sd 3:0:0:0: [sdd] 586072368 512-byte hardware sectors (300069 MB)
[    4.422245] sd 3:0:0:0: [sdd] Write Protect is off
[    4.425442] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    4.425459] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.429087] sd 3:0:0:0: [sdd] 586072368 512-byte hardware sectors (300069 MB)
[    4.432696] sd 3:0:0:0: [sdd] Write Protect is off
[    4.436152] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    4.436169] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.439867]  sdd: unknown partition table
[    4.446957] sd 3:0:0:0: [sdd] Attached SCSI disk
[    4.451304] scsi 4:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    4.455265] sd 4:0:0:0: [sde] 586072368 512-byte hardware sectors (300069 MB)
[    4.459151] sd 4:0:0:0: [sde] Write Protect is off
[    4.463052] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    4.463069] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.467046] sd 4:0:0:0: [sde] 586072368 512-byte hardware sectors (300069 MB)
[    4.470993] sd 4:0:0:0: [sde] Write Protect is off
[    4.474878] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    4.474895] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.478857]  sde: sde1
[    4.486850] sd 4:0:0:0: [sde] Attached SCSI disk
[    4.491012] scsi 5:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    4.495045] sd 5:0:0:0: [sdf] 586072368 512-byte hardware sectors (300069 MB)
[    4.499023] sd 5:0:0:0: [sdf] Write Protect is off
[    4.502928] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    4.502945] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.506946] sd 5:0:0:0: [sdf] 586072368 512-byte hardware sectors (300069 MB)
[    4.510920] sd 5:0:0:0: [sdf] Write Protect is off
[    4.514856] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    4.514873] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.518863]  sdf: sdf1 sdf2 sdf3
[    4.528012] sd 5:0:0:0: [sdf] Attached SCSI disk
[    4.532023] sata_sil24 0000:04:00.0: version 1.1
[    4.532023] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[    4.536052] PCI: Setting latency timer of device 0000:04:00.0 to 64
[    4.536189] scsi6 : sata_sil24
[    4.540312] scsi7 : sata_sil24
[    4.544335] ata7: SATA max UDMA/100 host m128@0xe0304000 port 0xe0300000 irq 18
[    4.548292] ata8: SATA max UDMA/100 host m128@0xe0304000 port 0xe0302000 irq 18
[    6.683965] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    6.703930] ata7.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    6.707903] ata7.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    6.715912] ata7.00: configured for UDMA/100
[    8.739852] ata8: SATA link down (SStatus 0 SControl 0)
[    8.743388] scsi 6:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    8.748095] sd 6:0:0:0: [sdg] 586072368 512-byte hardware sectors (300069 MB)
[    8.752008] sd 6:0:0:0: [sdg] Write Protect is off
[    8.755855] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    8.755872] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.759808] sd 6:0:0:0: [sdg] 586072368 512-byte hardware sectors (300069 MB)
[    8.763011] sd 6:0:0:0: [sdg] Write Protect is off
[    8.766936] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    8.766954] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.770864]  sdg: sdg1
[    8.789812] sd 6:0:0:0: [sdg] Attached SCSI disk
[    8.793886] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[    8.797079] PCI: Setting latency timer of device 0000:05:00.0 to 64
[    8.798001] scsi8 : sata_sil24
[    8.802022] scsi9 : sata_sil24
[    8.805888] ata9: SATA max UDMA/100 host m128@0xe0204000 port 0xe0200000 irq 19
[    8.809764] ata10: SATA max UDMA/100 host m128@0xe0204000 port 0xe0202000 irq 19
[   10.832991] ata9: SATA link down (SStatus 0 SControl 0)
[   12.856945] ata10: SATA link down (SStatus 0 SControl 0)
[   12.860802] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   12.864730] PCI: Setting latency timer of device 0000:06:00.0 to 64
[   12.865223] scsi10 : sata_sil24
[   12.869222] scsi11 : sata_sil24
[   12.873127] ata11: SATA max UDMA/100 host m128@0xe0104000 port 0xe0100000 irq 16
[   12.876958] ata12: SATA max UDMA/100 host m128@0xe0104000 port 0xe0102000 irq 16
[   15.011955] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   15.028865] ata11.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   15.032708] ata11.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   15.041812] ata11.00: configured for UDMA/100
[   17.065992] ata12: SATA link down (SStatus 0 SControl 0)
[   17.069441] scsi 10:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   17.074050] sd 10:0:0:0: [sdh] 586072368 512-byte hardware sectors (300069 MB)
[   17.077799] sd 10:0:0:0: [sdh] Write Protect is off
[   17.081013] sd 10:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[   17.081031] sd 10:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   17.084843] sd 10:0:0:0: [sdh] 586072368 512-byte hardware sectors (300069 MB)
[   17.088592] sd 10:0:0:0: [sdh] Write Protect is off
[   17.092327] sd 10:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[   17.092344] sd 10:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   17.096050]  sdh: sdh1
[   17.115021] sd 10:0:0:0: [sdh] Attached SCSI disk
[   17.118854] sata_mv 0000:01:00.0: version 1.24
[   17.122649] ACPI: PCI Interrupt 0000:01:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   17.126462] sata_mv 0000:01:00.0: Gen-IIE 32 slots 4 ports SCSI mode IRQ via INTx
[   17.130210] PCI: Setting latency timer of device 0000:01:00.0 to 64
[   17.130333] scsi12 : sata_mv
[   17.134293] scsi13 : sata_mv
[   17.138075] scsi14 : sata_mv
[   17.141823] scsi15 : sata_mv
[   17.145539] ata13: SATA max UDMA/133 mmio m1048576@0xe0600000 port 0xe0622000 irq 16
[   17.149149] ata14: SATA max UDMA/133 mmio m1048576@0xe0600000 port 0xe0624000 irq 16
[   17.152267] ata15: SATA max UDMA/133 mmio m1048576@0xe0600000 port 0xe0626000 irq 16
[   17.155828] ata16: SATA max UDMA/133 mmio m1048576@0xe0600000 port 0xe0628000 irq 16
[   17.616315] ata13: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   17.657985] ata13.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   17.661417] ata13.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   17.689988] ata13.00: configured for UDMA/133
[   18.150291] ata14: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   18.190959] ata14.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   18.194410] ata14.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   18.222990] ata14.00: configured for UDMA/133
[   18.682577] ata15: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   18.723782] ata15.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   18.727265] ata15.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   18.755859] ata15.00: configured for UDMA/133
[   19.215794] ata16: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[   19.258032] ata16.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   19.261417] ata16.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[   19.289922] ata16.00: configured for UDMA/133
[   19.293042] scsi 12:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   19.297619] sd 12:0:0:0: [sdi] 586072368 512-byte hardware sectors (300069 MB)
[   19.301160] sd 12:0:0:0: [sdi] Write Protect is off
[   19.304373] sd 12:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[   19.304390] sd 12:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   19.307985] sd 12:0:0:0: [sdi] 586072368 512-byte hardware sectors (300069 MB)
[   19.312000] sd 12:0:0:0: [sdi] Write Protect is off
[   19.315002] sd 12:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[   19.315019] sd 12:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   19.318543]  sdi: sdi1
[   19.328118] sd 12:0:0:0: [sdi] Attached SCSI disk
[   19.331845] scsi 13:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   19.335529] sd 13:0:0:0: [sdj] 586072368 512-byte hardware sectors (300069 MB)
[   19.339072] sd 13:0:0:0: [sdj] Write Protect is off
[   19.342280] sd 13:0:0:0: [sdj] Mode Sense: 00 3a 00 00
[   19.342297] sd 13:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   19.345921] sd 13:0:0:0: [sdj] 586072368 512-byte hardware sectors (300069 MB)
[   19.349401] sd 13:0:0:0: [sdj] Write Protect is off
[   19.352990] sd 13:0:0:0: [sdj] Mode Sense: 00 3a 00 00
[   19.353007] sd 13:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   19.356560]  sdj: sdj1
[   19.368022] sd 13:0:0:0: [sdj] Attached SCSI disk
[   19.371816] scsi 14:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   19.375532] sd 14:0:0:0: [sdk] 586072368 512-byte hardware sectors (300069 MB)
[   19.379174] sd 14:0:0:0: [sdk] Write Protect is off
[   19.382371] sd 14:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[   19.382388] sd 14:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   19.386117] sd 14:0:0:0: [sdk] 586072368 512-byte hardware sectors (300069 MB)
[   19.389794] sd 14:0:0:0: [sdk] Write Protect is off
[   19.393428] sd 14:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[   19.393445] sd 14:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   19.397018]  sdk: sdk1
[   19.407848] sd 14:0:0:0: [sdk] Attached SCSI disk
[   19.411732] scsi 15:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   19.415561] sd 15:0:0:0: [sdl] 586072368 512-byte hardware sectors (300069 MB)
[   19.419278] sd 15:0:0:0: [sdl] Write Protect is off
[   19.422907] sd 15:0:0:0: [sdl] Mode Sense: 00 3a 00 00
[   19.422924] sd 15:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   19.426143] sd 15:0:0:0: [sdl] 586072368 512-byte hardware sectors (300069 MB)
[   19.429858] sd 15:0:0:0: [sdl] Write Protect is off
[   19.433577] sd 15:0:0:0: [sdl] Mode Sense: 00 3a 00 00
[   19.433594] sd 15:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   19.437234]  sdl: sdl1
[   19.445012] sd 15:0:0:0: [sdl] Attached SCSI disk
[   19.448730] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   19.452531] PCI: Setting latency timer of device 0000:03:00.0 to 64
[   19.452676] scsi16 : pata_marvell
[   19.456470] scsi17 : pata_marvell
[   19.460215] ata17: PATA max UDMA/100 cmd 0x5018 ctl 0x5024 bmdma 0x5000 irq 17
[   19.463216] ata18: DUMMY
[   19.470416] BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:01 0D:00 0E:00 0F:00 
[   19.625416] ata17.00: ATAPI: _NEC DVD_RW ND-3520A, 1.04, max UDMA/33
[   19.635416] ata17.00: configured for UDMA/33
[   19.640033] scsi 16:0:0:0: CD-ROM            _NEC     DVD_RW ND-3520A  1.04 PQ: 0 ANSI: 5
[   19.646578] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   19.650570] Uniform CD-ROM driver Revision: 3.20
[   19.654753] sr 16:0:0:0: Attached scsi CD-ROM sr0
[   19.655362] ACPI: PCI Interrupt 0000:07:03.0[A] -> GSI 19 (level, low) -> IRQ 19
[   19.710000] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0084000-e00847ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   19.714322] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[   19.718330] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[   19.718333] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   19.722741] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   19.730000] ehci_hcd 0000:00:1a.7: debug port 1
[   19.734004] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[   19.734008] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0725c00
[   19.747119] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   19.752145] usb usb1: configuration #1 chosen from 1 choice
[   19.756348] hub 1-0:1.0: USB hub found
[   19.760353] hub 1-0:1.0: 4 ports detected
[   19.865021] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[   19.869027] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   19.869030] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   19.873146] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   19.881000] ehci_hcd 0000:00:1d.7: debug port 1
[   19.885004] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   19.885011] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0725800
[   19.898569] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   19.903058] usb usb2: configuration #1 chosen from 1 choice
[   19.907144] hub 2-0:1.0: USB hub found
[   19.911104] hub 2-0:1.0: 6 ports detected
[   20.016021] USB Universal Host Controller Interface driver v3.0
[   20.020011] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[   20.023988] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[   20.023990] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   20.028111] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   20.032054] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000070c0
[   20.036044] usb usb3: configuration #1 chosen from 1 choice
[   20.040062] hub 3-0:1.0: USB hub found
[   20.043938] hub 3-0:1.0: 2 ports detected
[   20.148021] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[   20.151921] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[   20.151924] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   20.155969] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   20.159036] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000070a0
[   20.163704] usb usb4: configuration #1 chosen from 1 choice
[   20.167686] hub 4-0:1.0: USB hub found
[   20.171493] hub 4-0:1.0: 2 ports detected
[   20.276021] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[   20.279833] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   20.279836] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   20.283788] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   20.287611] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00007080
[   20.291421] usb usb5: configuration #1 chosen from 1 choice
[   20.295279] hub 5-0:1.0: USB hub found
[   20.298988] hub 5-0:1.0: 2 ports detected
[   20.403021] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   20.406025] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   20.406027] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   20.410457] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   20.414187] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00007060
[   20.418076] usb usb6: configuration #1 chosen from 1 choice
[   20.421832] hub 6-0:1.0: USB hub found
[   20.425470] hub 6-0:1.0: 2 ports detected
[   20.530021] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[   20.533025] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   20.533027] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   20.536991] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   20.540611] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00007040
[   20.544733] usb usb7: configuration #1 chosen from 1 choice
[   20.548376] hub 7-0:1.0: USB hub found
[   20.551945] hub 7-0:1.0: 2 ports detected
[   20.609389] usb 5-1: new full speed USB device using uhci_hcd and address 2
[   20.656021] Initializing USB Mass Storage driver...
[   20.771021] usb 5-1: configuration #1 chosen from 1 choice
[   20.780021] hub 5-1:1.0: USB hub found
[   20.783971] hub 5-1:1.0: 3 ports detected
[   20.970021] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0090270001c5be9f]
[   21.100819] usb 6-2: new low speed USB device using uhci_hcd and address 2
[   21.334021] usb 6-2: configuration #1 chosen from 1 choice
[   21.515963] usb 5-1.1: new full speed USB device using uhci_hcd and address 3
[   21.645021] usb 5-1.1: configuration #1 chosen from 1 choice
[   21.833876] usb 5-1.2: new low speed USB device using uhci_hcd and address 4
[   21.957021] usb 5-1.2: configuration #1 chosen from 1 choice
[   21.966021] usbcore: registered new interface driver usb-storage
[   21.969027] USB Mass Storage support registered.
[   21.973203] PNP: No PS/2 controller found. Probing ports directly.
[   21.979084] serio: i8042 KBD port at 0x60,0x64 irq 1
[   21.982396] serio: i8042 AUX port at 0x60,0x64 irq 12
[   21.985761] mice: PS/2 mouse device common for all mice
[   22.320021] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   22.403022] coretemp coretemp.0: Using relative temperature scale!
[   22.406400] coretemp coretemp.1: Using relative temperature scale!
[   22.410012] coretemp coretemp.2: Using relative temperature scale!
[   22.413285] coretemp coretemp.3: Using relative temperature scale!
[   22.416640] md: raid0 personality registered for level 0
[   22.419642] md: raid1 personality registered for level 1
[   22.439856] raid6: int64x1   2273 MB/s
[   22.459869] raid6: int64x2   2988 MB/s
[   22.479863] raid6: int64x4   2781 MB/s
[   22.499858] raid6: int64x8   2113 MB/s
[   22.519842] raid6: sse2x1    3710 MB/s
[   22.538963] raid6: sse2x2    4308 MB/s
[   22.557910] raid6: sse2x4    6652 MB/s
[   22.560002] raid6: using algorithm sse2x4 (6652 MB/s)
[   22.562873] md: raid6 personality registered for level 6
[   22.565744] md: raid5 personality registered for level 5
[   22.568614] md: raid4 personality registered for level 4
[   22.572244] usbcore: registered new interface driver hiddev
[   23.746021] hiddev96: USB HID v1.10 Device [American Power Conversion Back-UPS RS 1500 LCD FW:839.H7 .D USB FW:H7 ] on usb-0000:00:1d.1-2
[   23.751021] input: Dell Dell USB Keyboard Hub as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.0/input/input3
[   23.757912] input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard Hub] on usb-0000:00:1d.0-1.1
[   23.766021] input: Dell Dell USB Keyboard Hub as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.1/5-1.1:1.1/input/input4
[   23.772576] input: USB HID v1.10 Device [Dell Dell USB Keyboard Hub] on usb-0000:00:1d.0-1.1
[   23.788021] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.0/usb5/5-1/5-1.2/5-1.2:1.0/input/input5
[   23.795021] input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.0-1.2
[   23.798320] usbcore: registered new interface driver usbhid
[   23.801322] usbhid: v2.6:USB HID core driver
[   23.804759] Advanced Linux Sound Architecture Driver Version 1.0.16.
[   23.808046] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[   23.811062] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   23.848021] ALSA device list:
[   23.851022]   #0: HDA Intel at 0xe0720000 irq 22
[   23.854865] u32 classifier
[   23.858065]     Actions configured 
[   23.861269] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   23.864963] ip_tables: (C) 2000-2006 Netfilter Core Team
[   23.868043] TCP cubic registered
[   23.871201] NET: Registered protocol family 17
[   23.874761] RPC: Registered udp transport module.
[   23.877943] RPC: Registered tcp transport module.
[   23.881287] md: Autodetecting RAID arrays.
[   24.018457] md: Scanned 15 and added 15 devices.
[   24.021608] md: autorun ...
[   24.024658] md: considering sdl1 ...
[   24.027691] md:  adding sdl1 ...
[   24.030694] md:  adding sdk1 ...
[   24.033694] md:  adding sdj1 ...
[   24.036682] md:  adding sdi1 ...
[   24.039615] md:  adding sdh1 ...
[   24.042490] md:  adding sdg1 ...
[   24.045299] md: sdf3 has different UUID to sdl1
[   24.048077] md: sdf2 has different UUID to sdl1
[   24.050901] md: sdf1 has different UUID to sdl1
[   24.053673] md:  adding sde1 ...
[   24.056376] md: sdc3 has different UUID to sdl1
[   24.059038] md: sdc2 has different UUID to sdl1
[   24.061708] md: sdc1 has different UUID to sdl1
[   24.064265] md:  adding sdb1 ...
[   24.066868] md:  adding sda1 ...
[   24.069867] md: created md3
[   24.072364] md: bind<sda1>
[   24.074494] md: bind<sdb1>
[   24.076888] md: bind<sde1>
[   24.079245] md: bind<sdg1>
[   24.081521] md: bind<sdh1>
[   24.083897] md: bind<sdi1>
[   24.086126] md: bind<sdj1>
[   24.088373] md: bind<sdk1>
[   24.090599] md: bind<sdl1>
[   24.092848] md: running: <sdl1><sdk1><sdj1><sdi1><sdh1><sdg1><sde1><sdb1><sda1>
[   24.095043] raid5: device sdl1 operational as raid disk 9
[   24.097348] raid5: device sdk1 operational as raid disk 6
[   24.099629] raid5: device sdj1 operational as raid disk 7
[   24.101970] raid5: device sdi1 operational as raid disk 5
[   24.104273] raid5: device sdh1 operational as raid disk 8
[   24.106547] raid5: device sdg1 operational as raid disk 4
[   24.108851] raid5: device sde1 operational as raid disk 0
[   24.111122] raid5: device sdb1 operational as raid disk 2
[   24.113371] raid5: device sda1 operational as raid disk 3
[   24.116022] raid5: allocated 10574kB for md3
[   24.118023] raid5: raid level 5 set md3 active with 9 out of 10 devices, algorithm 2
[   24.120750] RAID5 conf printout:
[   24.123047]  --- rd:10 wd:9
[   24.125246]  disk 0, o:1, dev:sde1
[   24.127331]  disk 2, o:1, dev:sdb1
[   24.129332]  disk 3, o:1, dev:sda1
[   24.131245]  disk 4, o:1, dev:sdg1
[   24.133046]  disk 5, o:1, dev:sdi1
[   24.134765]  disk 6, o:1, dev:sdk1
[   24.136079]  disk 7, o:1, dev:sdj1
[   24.137740]  disk 8, o:1, dev:sdh1
[   24.139276]  disk 9, o:1, dev:sdl1
[   24.141339] md: considering sdf3 ...
[   24.142344] md:  adding sdf3 ...
[   24.143870] md: sdf2 has different UUID to sdf3
[   24.145283] md: sdf1 has different UUID to sdf3
[   24.146704] md:  adding sdc3 ...
[   24.148071] md: sdc2 has different UUID to sdf3
[   24.149426] md: sdc1 has different UUID to sdf3
[   24.151136] md: created md2
[   24.152138] md: bind<sdc3>
[   24.153394] md: bind<sdf3>
[   24.154872] md: running: <sdf3><sdc3>
[   24.156226] raid1: raid set md2 active with 2 out of 2 mirrors
[   24.157803] md: considering sdf2 ...
[   24.159104] md:  adding sdf2 ...
[   24.160174] md: sdf1 has different UUID to sdf2
[   24.161460] md:  adding sdc2 ...
[   24.162751] md: sdc1 has different UUID to sdf2
[   24.164266] md: created md1
[   24.165374] md: bind<sdc2>
[   24.166867] md: bind<sdf2>
[   24.168225] md: running: <sdf2><sdc2>
[   24.170000] raid1: raid set md1 active with 2 out of 2 mirrors
[   24.171266] md: considering sdf1 ...
[   24.172709] md:  adding sdf1 ...
[   24.174028] md:  adding sdc1 ...
[   24.175440] md: created md0
[   24.176921] md: bind<sdc1>
[   24.178344] md: bind<sdf1>
[   24.179783] md: running: <sdf1><sdc1>
[   24.181652] raid1: raid set md0 active with 2 out of 2 mirrors
[   24.183243] md: ... autorun DONE.
[   24.224540] UDF-fs: No VRS found
[   24.227058] Filesystem "md2": Disabling barriers, not supported by the underlying device
[   24.228734] XFS: correcting sb_features alignment problem
[   24.238882] XFS mounting filesystem md2
[   24.343494] Ending clean XFS mount for filesystem: md2
[   24.344021] VFS: Mounted root (xfs filesystem) readonly.
[   24.345858] Freeing unused kernel memory: 260k freed
[   26.957088] Adding 16787768k swap on /dev/md0.  Priority:-1 extents:1 across:16787768k
[   27.112583] Filesystem "md2": Disabling barriers, not supported by the underlying device
[   28.401416] kjournald starting.  Commit interval 5 seconds
[   28.401416] EXT3 FS on md1, internal journal
[   28.401416] EXT3-fs: mounted filesystem with ordered data mode.
[   28.402446] Filesystem "md3": Disabling barriers, not supported by the underlying device
[   28.425416] XFS mounting filesystem md3
[   28.584071] Ending clean XFS mount for filesystem: md3
[   30.882894] e1000: eth1: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
[   31.088851] e1000: eth2: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
[   32.547993] eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   45.385166] warning: `pure-ftpd' uses 32-bit capabilities (legacy support in use)
[   97.974969] sd 3:0:0:0: [sdd] 586072368 512-byte hardware sectors (300069 MB)
[   97.974984] sd 3:0:0:0: [sdd] Write Protect is off
[   97.974986] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[   97.975004] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   97.975007]  sdd: sdd1
[  100.030125] sd 3:0:0:0: [sdd] 586072368 512-byte hardware sectors (300069 MB)
[  100.030125] sd 3:0:0:0: [sdd] Write Protect is off
[  100.030125] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[  100.030125] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[  100.030125]  sdd: sdd1
[  114.850357] md: bind<sdd1>
[  114.881762] RAID5 conf printout:
[  114.881771]  --- rd:10 wd:9
[  114.882061]  disk 0, o:1, dev:sde1
[  114.882065]  disk 1, o:1, dev:sdd1
[  114.882067]  disk 2, o:1, dev:sdb1
[  114.882069]  disk 3, o:1, dev:sda1
[  114.882072]  disk 4, o:1, dev:sdg1
[  114.882075]  disk 5, o:1, dev:sdi1
[  114.882099]  disk 6, o:1, dev:sdk1
[  114.882101]  disk 7, o:1, dev:sdj1
[  114.882103]  disk 8, o:1, dev:sdh1
[  114.882105]  disk 9, o:1, dev:sdl1
[  114.882261] md: recovery of RAID array md3
[  114.882261] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  114.882261] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[  114.882261] md: using 128k window, over a total of 293032960 blocks.
[ 3120.630400] md: md3: recovery done.
[ 3121.493166] RAID5 conf printout:
[ 3121.493166]  --- rd:10 wd:10
[ 3121.493166]  disk 0, o:1, dev:sde1
[ 3121.493166]  disk 1, o:1, dev:sdd1
[ 3121.493166]  disk 2, o:1, dev:sdb1
[ 3121.493166]  disk 3, o:1, dev:sda1
[ 3121.493166]  disk 4, o:1, dev:sdg1
[ 3121.493166]  disk 5, o:1, dev:sdi1
[ 3121.493166]  disk 6, o:1, dev:sdk1
[ 3121.493166]  disk 7, o:1, dev:sdj1
[ 3121.493166]  disk 8, o:1, dev:sdh1
[ 3121.493166]  disk 9, o:1, dev:sdl1
[89876.325250] md: data-check of RAID array md0
[89876.325250] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[89876.325250] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[89876.325250] md: using 128k window, over a total of 16787776 blocks.
[89877.425416] md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
[89878.428312] md: delaying data-check of md2 until md0 has finished (they share one or more physical units)
[89878.428437] md: delaying data-check of md1 until md2 has finished (they share one or more physical units)
[89879.431340] md: data-check of RAID array md3
[89879.431340] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[89879.431340] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[89879.431340] md: using 128k window, over a total of 293032960 blocks.
[90026.076538] md: md0: data-check done.
[90026.092187] md: delaying data-check of md1 until md2 has finished (they share one or more physical units)
[90026.094167] md: data-check of RAID array md2
[90026.094167] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[90026.094167] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[90026.094167] md: using 128k window, over a total of 276109056 blocks.
[90026.114748] RAID1 conf printout:
[90026.114748]  --- wd:2 rd:2
[90026.114748]  disk 0, wo:0, o:1, dev:sdf1
[90026.114748]  disk 1, wo:0, o:1, dev:sdc1
[93252.653148] md: md2: data-check done.
[93252.678447] md: data-check of RAID array md1
[93252.678447] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[93252.678447] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[93252.678447] md: using 128k window, over a total of 136448 blocks.
[93252.706377] RAID1 conf printout:
[93252.706377]  --- wd:2 rd:2
[93252.706377]  disk 0, wo:0, o:1, dev:sdf3
[93252.706377]  disk 1, wo:0, o:1, dev:sdc3
[93253.954622] md: md1: data-check done.
[93253.981656] RAID1 conf printout:
[93253.981656]  --- wd:2 rd:2
[93253.981656]  disk 0, wo:0, o:1, dev:sdf2
[93253.981656]  disk 1, wo:0, o:1, dev:sdc2
[93469.215876] md: md3: data-check done.
[93470.121416] RAID5 conf printout:
[93470.121416]  --- rd:10 wd:10
[93470.121416]  disk 0, o:1, dev:sde1
[93470.121416]  disk 1, o:1, dev:sdd1
[93470.121416]  disk 2, o:1, dev:sdb1
[93470.121416]  disk 3, o:1, dev:sda1
[93470.121416]  disk 4, o:1, dev:sdg1
[93470.121416]  disk 5, o:1, dev:sdi1
[93470.121416]  disk 6, o:1, dev:sdk1
[93470.121416]  disk 7, o:1, dev:sdj1
[93470.121416]  disk 8, o:1, dev:sdh1
[93470.121416]  disk 9, o:1, dev:sdl1
[420781.333179] ata6.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[420781.333189] ata6.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[420781.333190]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[420781.333194] ata6.00: status: { DRDY }
[420781.333200] ata6: hard resetting link
[420781.638589] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[420781.662166] ata6.00: configured for UDMA/133
[420781.662166] ata6: EH complete
[420781.662989] sd 5:0:0:0: [sdf] 586072368 512-byte hardware sectors (300069 MB)
[420781.669416] sd 5:0:0:0: [sdf] Write Protect is off
[420781.669416] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[420781.669416] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[469680.004637] ata2.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
[469680.004648] ata2.00: cmd b0/d8:00:00:4f:c2/00:00:00:00:00/00 tag 0
[469680.004649]          res 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
[469680.004654] ata2.00: status: { DRDY }
[469680.004660] ata2: hard resetting link
[469680.309567] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[469680.333461] ata2.00: configured for UDMA/133
[469680.333477] ata2: EH complete
[469680.333461] sd 1:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
[469680.340461] sd 1:0:0:0: [sdb] Write Protect is off
[469680.340461] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[469680.345461] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[694676.574060] md: data-check of RAID array md0
[694676.574069] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[694676.574071] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[694676.574075] md: using 128k window, over a total of 16787776 blocks.
[694677.672251] md: delaying data-check of md1 until md0 has finished (they share one or more physical units)
[694678.676482] md: delaying data-check of md2 until md0 has finished (they share one or more physical units)
[694678.676482] md: delaying data-check of md1 until md2 has finished (they share one or more physical units)
[694679.679039] md: data-check of RAID array md3
[694679.679047] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[694679.679049] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[694679.679060] md: using 128k window, over a total of 293032960 blocks.
[694826.272295] md: md0: data-check done.
[694826.286881] md: delaying data-check of md1 until md2 has finished (they share one or more physical units)
[694826.287070] md: data-check of RAID array md2
[694826.287073] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[694826.287075] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[694826.287410] md: using 128k window, over a total of 276109056 blocks.
[694826.317230] RAID1 conf printout:
[694826.317234]  --- wd:2 rd:2
[694826.317245]  disk 0, wo:0, o:1, dev:sdf1
[694826.317246]  disk 1, wo:0, o:1, dev:sdc1
[698158.318441] md: md2: data-check done.
[698158.342697] md: data-check of RAID array md1
[698158.342706] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[698158.342707] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[698158.342710] md: using 128k window, over a total of 136448 blocks.
[698158.393395] RAID1 conf printout:
[698158.393395]  --- wd:2 rd:2
[698158.393395]  disk 0, wo:0, o:1, dev:sdf3
[698158.393395]  disk 1, wo:0, o:1, dev:sdc3
[698159.646421] md: md1: data-check done.
[698159.683206] RAID1 conf printout:
[698159.683206]  --- wd:2 rd:2
[698159.683206]  disk 0, wo:0, o:1, dev:sdf2
[698159.683206]  disk 1, wo:0, o:1, dev:sdc2
[698397.087412] md: md3: data-check done.
[698397.981384] RAID5 conf printout:
[698397.981393]  --- rd:10 wd:10
[698397.981395]  disk 0, o:1, dev:sde1
[698397.981396]  disk 1, o:1, dev:sdd1
[698397.981398]  disk 2, o:1, dev:sdb1
[698397.981400]  disk 3, o:1, dev:sda1
[698397.981401]  disk 4, o:1, dev:sdg1
[698397.981403]  disk 5, o:1, dev:sdi1
[698397.981405]  disk 6, o:1, dev:sdk1
[698397.981408]  disk 7, o:1, dev:sdj1
[698397.981410]  disk 8, o:1, dev:sdh1
[698397.981413]  disk 9, o:1, dev:sdl1

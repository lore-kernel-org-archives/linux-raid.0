From: Karl Hiramoto <karl@hiramoto.org>
Subject: regression:  hung boot upgrading to 2.6.34.1 from 2.6.32.11
Date: Fri, 16 Jul 2010 11:26:56 +0200
Message-ID: <4C4025E0.8060701@hiramoto.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

 Hi,

I just upgraded my kernel from 2.6.32.11 to 2.6.34.1   There were some kconfig changes, but i left most stuff to the default values.
I'm willing to try any patches or ideas anyone has.     It looks like two  md kthreads are stuck calling  _raw_spin_unlock_irqrestore,

I can still boot 2.6.32.11


I'll start compiling a git bisect to see if i can find the commit.



Jul 16 10:54:33 smoke    0.000000] Linux version 2.6.34.1 (root@smoke) (gcc version 4.4.3 (Gentoo 4.4.3-r2 p1.2) ) #7 SMP PREEMPT Fri Jul 16 10:05:44 CEST 2010
Jul 16 10:54:33 smoke    0.000000] Command line: netconsole=4444@192.168.69.3/eth0,514@192.168.69.51/ root=/dev/md2 panic=30 raid=noautodetect md=0,/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1 md=1,/dev/sda3,/dev/sdb3 md=2,/dev/sdc3,/dev/sdd3,/dev/md1 rootwait
Jul 16 10:54:33 smoke    0.000000] BIOS-provided physical RAM map:
Jul 16 10:54:33 smoke    0.000000]  BIOS-e820: 0000000000000000 - 000000000009fc00 (usable)
Jul 16 10:54:33 smoke    0.000000]  BIOS-e820: 000000000009fc00 - 00000000000a0000 (reserved)
Jul 16 10:54:33 smoke    0.000000]  BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
Jul 16 10:54:33 smoke    0.000000]  BIOS-e820: 0000000000100000 - 000000007ff90000 (usable)
Jul 16 10:54:33 smoke    0.000000]  BIOS-e820: 000000007ff90000 - 000000007ff9e000 (ACPI data)
Jul 16 10:54:33 smoke    0.000000]  BIOS-e820: 000000007ff9e000 - 000000007ffe0000 (ACPI NVS)
Jul 16 10:54:33 smoke    0.000000]  BIOS-e820: 000000007ffe0000 - 0000000080000000 (reserved)
Jul 16 10:54:33 smoke    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
Jul 16 10:54:33 smoke    0.000000]  BIOS-e820: 00000000ffb00000 - 0000000100000000 (reserved)
Jul 16 10:54:33 smoke    0.000000]  BIOS-e820: 0000000100000000 - 0000000180000000 (usable)
Jul 16 10:54:33 smoke    0.000000] NX (Execute Disable) protection: active
Jul 16 10:54:33 smoke    0.000000] DMI 2.4 present.
Jul 16 10:54:33 smoke    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working around it.
Jul 16 10:54:33 smoke    0.000000] No AGP bridge found
Jul 16 10:54:33 smoke    0.000000] last_pfn = 0x180000 max_arch_pfn = 0x400000000
Jul 16 10:54:33 smoke    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
Jul 16 10:54:33 smoke    0.000000] last_pfn = 0x7ff90 max_arch_pfn = 0x400000000
Jul 16 10:54:33 smoke    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
Jul 16 10:54:33 smoke    0.000000] init_memory_mapping: 0000000000000000-000000007ff90000
Jul 16 10:54:33 smoke    0.000000] init_memory_mapping: 0000000100000000-0000000180000000
Jul 16 10:54:33 smoke    0.000000] ACPI: RSDP 00000000000fa9b0 00024 (v02 ACPIAM)
Jul 16 10:54:33 smoke    0.000000] ACPI: XSDT 000000007ff90100 0004C (v01 MSTEST OEMXSDT  11000726 MSFT 00000097)
Jul 16 10:54:33 smoke    0.000000] ACPI: FACP 000000007ff90290 000F4 (v03 MSTEST OEMFACP  11000726 MSFT 00000097)
Jul 16 10:54:33 smoke    0.000000] ACPI: DSDT 000000007ff905c0 0928C (v01  A0545 A0545000 00000000 INTL 20060113)
Jul 16 10:54:33 smoke    0.000000] ACPI: FACS 000000007ff9e000 00040
Jul 16 10:54:33 smoke    0.000000] ACPI: APIC 000000007ff90390 0006C (v01 MSTEST OEMAPIC  11000726 MSFT 00000097)
Jul 16 10:54:33 smoke    0.000000] ACPI: MCFG 000000007ff90400 0003C (v01 MSTEST OEMMCFG  11000726 MSFT 00000097)
Jul 16 10:54:33 smoke    0.000000] ACPI: OEMB 000000007ff9e040 0007B (v01 MSTEST AMI_OEM  11000726 MSFT 00000097)
Jul 16 10:54:33 smoke    0.000000] ACPI: HPET 000000007ff99850 00038 (v01 MSTEST OEMHPET  11000726 MSFT 00000097)
Jul 16 10:54:33 smoke    0.000000] No NUMA configuration found
Jul 16 10:54:33 smoke    0.000000] Faking a node at 0000000000000000-0000000180000000
Jul 16 10:54:33 smoke    0.000000] Initmem setup node 0 0000000000000000-0000000180000000
Jul 16 10:54:33 smoke    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
Jul 16 10:54:33 smoke    0.000000] Zone PFN ranges:
Jul 16 10:54:33 smoke    0.000000]   DMA      0x00000010 -> 0x00001000
Jul 16 10:54:33 smoke    0.000000]   DMA32    0x00001000 -> 0x00100000
Jul 16 10:54:33 smoke    0.000000]   Normal   0x00100000 -> 0x00180000
Jul 16 10:54:33 smoke    0.000000] Movable zone start PFN for each node
Jul 16 10:54:33 smoke    0.000000] early_node_map[3] active PFN ranges
Jul 16 10:54:33 smoke    0.000000]     0: 0x00000010 -> 0x0000009f
Jul 16 10:54:33 smoke    0.000000]     0: 0x00000100 -> 0x0007ff90
Jul 16 10:54:33 smoke    0.000000]     0: 0x00100000 -> 0x00180000
Jul 16 10:54:33 smoke    0.000000] ACPI: PM-Timer IO Port: 0x808
Jul 16 10:54:33 smoke    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Jul 16 10:54:33 smoke    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
Jul 16 10:54:33 smoke    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
Jul 16 10:54:33 smoke    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
Jul 16 10:54:33 smoke    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
Jul 16 10:54:33 smoke    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
Jul 16 10:54:33 smoke    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
Jul 16 10:54:33 smoke    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
Jul 16 10:54:33 smoke    0.000000] Using ACPI (MADT) for SMP configuration information
Jul 16 10:54:33 smoke    0.000000] ACPI: HPET id: 0x8086a202 base: 0xfed00000
Jul 16 10:54:33 smoke    0.000000] SMP: Allowing 4 CPUs, 2 hotplug CPUs
Jul 16 10:54:33 smoke    0.000000] PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
Jul 16 10:54:33 smoke    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e4000
Jul 16 10:54:33 smoke    0.000000] PM: Registered nosave memory: 00000000000e4000 - 0000000000100000
Jul 16 10:54:33 smoke    0.000000] PM: Registered nosave memory: 000000007ff90000 - 000000007ff9e000
Jul 16 10:54:33 smoke    0.000000] PM: Registered nosave memory: 000000007ff9e000 - 000000007ffe0000
Jul 16 10:54:33 smoke    0.000000] PM: Registered nosave memory: 000000007ffe0000 - 0000000080000000
Jul 16 10:54:33 smoke    0.000000] PM: Registered nosave memory: 0000000080000000 - 00000000fee00000
Jul 16 10:54:33 smoke    0.000000] PM: Registered nosave memory: 00000000fee00000 - 00000000fee01000
Jul 16 10:54:33 smoke    0.000000] PM: Registered nosave memory: 00000000fee01000 - 00000000ffb00000
Jul 16 10:54:33 smoke    0.000000] PM: Registered nosave memory: 00000000ffb00000 - 0000000100000000
Jul 16 10:54:33 smoke    0.000000] Allocating PCI resources starting at 80000000 (gap: 80000000:7ee00000)
Jul 16 10:54:33 smoke    0.000000] setup_percpu: NR_CPUS:4 nr_cpumask_bits:4 nr_cpu_ids:4 nr_node_ids:1
Jul 16 10:54:33 smoke    0.000000] PERCPU: Embedded 27 pages/cpu @ffff880001a00000 s81896 r8192 d20504 u524288
Jul 16 10:54:33 smoke    0.000000] pcpu-alloc: s81896 r8192 d20504 u524288 alloc=1*2097152
Jul 16 10:54:33 smoke    0.000000] pcpu-alloc: [0] 0 1 2 3
Jul 16 10:54:33 smoke    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 1026847
Jul 16 10:54:33 smoke    0.000000] Policy zone: Normal
Jul 16 10:54:33 smoke    0.000000] Kernel command line: netconsole=4444@192.168.69.3/eth0,514@192.168.69.51/ root=/dev/md2 panic=30 raid=noautodetect md=0,/dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1 md=1,/dev/sda3,/dev/sdb3 md=2,/dev/sdc3,/dev/sdd3,/dev/md1 rootwait
Jul 16 10:54:33 smoke    0.000000] md: Will configure md0 (super-block) from /dev/sda1,/dev/sdb1,/dev/sdc1,/dev/sdd1, below.
Jul 16 10:54:33 smoke    0.000000] md: Will configure md1 (super-block) from /dev/sda3,/dev/sdb3, below.
Jul 16 10:54:33 smoke    0.000000] md: Will configure md2 (super-block) from /dev/sdc3,/dev/sdd3,/dev/md1, below.
Jul 16 10:54:33 smoke    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
Jul 16 10:54:33 smoke    0.000000] Checking aperture...
Jul 16 10:54:33 smoke    0.000000] No AGP bridge found
Jul 16 10:54:33 smoke    0.000000] Subtract (55 early reservations)
Jul 16 10:54:33 smoke    0.000000]   #1 [0001000000 - 0001882274]   TEXT DATA BSS
Jul 16 10:54:33 smoke    0.000000]   #2 [0001883000 - 0001883288]             BRK
Jul 16 10:54:33 smoke    0.000000]   #3 [00000ff790 - 0000100000]   BIOS reserved
Jul 16 10:54:33 smoke    0.000000]   #4 [00000ff780 - 00000ff790]    MP-table mpf
Jul 16 10:54:33 smoke    0.000000]   #5 [000009fc00 - 00000e3bb0]   BIOS reserved
Jul 16 10:54:33 smoke    0.000000]   #6 [00000e3d34 - 00000ff780]   BIOS reserved
Jul 16 10:54:33 smoke    0.000000]   #7 [00000e3bb0 - 00000e3d34]    MP-table mpc
Jul 16 10:54:33 smoke    0.000000]   #8 [0000010000 - 0000012000]      TRAMPOLINE
Jul 16 10:54:33 smoke    0.000000]   #9 [0000012000 - 0000016000]     ACPI WAKEUP
Jul 16 10:54:33 smoke    0.000000]   #10 [0000016000 - 0000018000]         PGTABLE
Jul 16 10:54:33 smoke    0.000000]   #11 [0000018000 - 000001a000]         PGTABLE
Jul 16 10:54:33 smoke    0.000000]   #12 [0100000000 - 0100005000]       NODE_DATA
Jul 16 10:54:33 smoke    0.000000]   #13 [00018832c0 - 00018842c0]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #14 [0001882280 - 0001882580]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #15 [0100005000 - 0100006000]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #16 [0100006000 - 0100007000]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #17 [0100200000 - 0103a00000]        MEMMAP 0
Jul 16 10:54:33 smoke    0.000000]   #18 [0001882580 - 0001882700]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #19 [00018842c0 - 000189c2c0]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #20 [000189c2c0 - 00018a82c0]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #21 [00018a9000 - 00018aa000]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #22 [0001882700 - 0001882741]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #23 [0001882780 - 00018827c3]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #24 [0001882800 - 0001882a68]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #25 [0001882a80 - 0001882ae8]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #26 [0001882b00 - 0001882b68]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #27 [0001882b80 - 0001882be8]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #28 [0001882c00 - 0001882c68]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #29 [0001882c80 - 0001882ce8]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #30 [0001882d00 - 0001882d68]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #31 [0001882d80 - 0001882de8]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #32 [0001882e00 - 0001882e68]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #33 [0001882e80 - 0001882ee8]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #34 [0001882f00 - 0001882f68]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #35 [0001882f80 - 0001882fa0]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #36 [0001882fc0 - 0001882fe0]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #37 [00018a82c0 - 00018a838f]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #38 [00018a83c0 - 00018a848f]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #39 [0001a00000 - 0001a1b000]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #40 [0001a80000 - 0001a9b000]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #41 [0001b00000 - 0001b1b000]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #42 [0001b80000 - 0001b9b000]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #43 [00018a84c0 - 00018a84c8]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #44 [00018a8500 - 00018a8508]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #45 [00018a8540 - 00018a8550]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #46 [00018a8580 - 00018a85a0]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #47 [00018a85c0 - 00018a86f0]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #48 [00018a8700 - 00018a8750]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #49 [00018a8780 - 00018a87d0]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #50 [00018aa000 - 00018b2000]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #51 [0001b9b000 - 0005b9b000]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #52 [00018b2000 - 00018d2000]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #53 [00018d2000 - 0001912000]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000]   #54 [000001a800 - 0000022800]         BOOTMEM
Jul 16 10:54:33 smoke    0.000000] Memory: 4060700k/6291456k available (4599k kernel code, 2098052k absent, 132704k reserved, 2699k data, 556k init)
Jul 16 10:54:33 smoke    0.000000] Hierarchical RCU implementation.
Jul 16 10:54:33 smoke    0.000000] NR_IRQS:384
Jul 16 10:54:33 smoke    0.000000] Extended CMOS year: 2000
Jul 16 10:54:33 smoke    0.000000] Console: colour VGA+ 80x25
Jul 16 10:54:33 smoke    0.000000] console [tty0] enabled
Jul 16 10:54:33 smoke    0.000000] Fast TSC calibration using PIT
Jul 16 10:54:33 smoke    0.000000] Detected 2329.646 MHz processor.
Jul 16 10:54:33 smoke    0.001005] Calibrating delay loop (skipped), value calculated using timer frequency.. 4659.29 BogoMIPS (lpj=2329646)
Jul 16 10:54:33 smoke    0.002208] Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes)
Jul 16 10:54:33 smoke    0.004668] Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes)
Jul 16 10:54:33 smoke    0.005939] Mount-cache hash table entries: 256
Jul 16 10:54:33 smoke    0.006145] CPU: Physical Processor ID: 0
Jul 16 10:54:33 smoke    0.006370] CPU: Processor Core ID: 0
Jul 16 10:54:33 smoke    0.006596] mce: CPU supports 6 MCE banks
Jul 16 10:54:33 smoke    0.007008] CPU0: Thermal monitoring enabled (TM2)
Jul 16 10:54:33 smoke    0.007236] using mwait in idle threads.
Jul 16 10:54:33 smoke    0.007460] Performance Events: Core2 events, Intel PMU driver.
Jul 16 10:54:33 smoke    0.007743] ... version:                2
Jul 16 10:54:33 smoke    0.007968] ... bit width:              40
Jul 16 10:54:33 smoke    0.008002] ... generic registers:      2
Jul 16 10:54:33 smoke    0.008228] ... value mask:             000000ffffffffff
Jul 16 10:54:33 smoke    0.008454] ... max period:             000000007fffffff
Jul 16 10:54:33 smoke    0.008681] ... fixed-purpose events:   3
Jul 16 10:54:33 smoke    0.009002] ... event mask:             0000000700000003
Jul 16 10:54:33 smoke    0.009266] ACPI: Core revision 20100121
Jul 16 10:54:33 smoke    0.021062] Setting APIC routing to flat
Jul 16 10:54:33 smoke    0.021605] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
Jul 16 10:54:33 smoke    0.032128] CPU0: Intel(R) Core(TM)2 Duo CPU     E6550  @ 2.33GHz stepping 0b
Jul 16 10:54:33 smoke    0.038027] Booting Node   0, Processors  #1
Jul 16 10:54:33 smoke    0.110018] Brought up 2 CPUs
Jul 16 10:54:33 smoke    0.110463] Total of 2 processors activated (9318.30 BogoMIPS).
Jul 16 10:54:33 smoke    0.112448] xor: automatically using best checksumming function: generic_sse
Jul 16 10:54:33 smoke    0.117002]    generic_sse:  8228.000 MB/sec
Jul 16 10:54:33 smoke    0.117227] xor: using function: generic_sse (8228.000 MB/sec)
Jul 16 10:54:33 smoke    0.117456] regulator: core version 0.5
Jul 16 10:54:33 smoke    0.117749] NET: Registered protocol family 16
Jul 16 10:54:33 smoke    0.118348] ACPI: bus type pci registered
Jul 16 10:54:33 smoke    0.118669] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Jul 16 10:54:33 smoke    0.119005] PCI: not using MMCONFIG
Jul 16 10:54:33 smoke    0.119230] PCI: Using configuration type 1 for base access
Jul 16 10:54:33 smoke    0.122601] bio: create slab <bio-0> at 0
Jul 16 10:54:33 smoke    0.126060] ACPI: Executed 1 blocks of module-level executable AML code
Jul 16 10:54:33 smoke    0.135890] ACPI: SSDT 000000007ff9e0c0 001C6 (v01    AMI   CPU1PM 00000001 INTL 20060113)
Jul 16 10:54:33 smoke    0.137033] ACPI: SSDT 000000007ff9e290 0013A (v01    AMI   CPU2PM 00000001 INTL 20060113)
Jul 16 10:54:33 smoke    0.137922] ACPI: Interpreter enabled
Jul 16 10:54:33 smoke    0.138004] ACPI: (supports S0 S1 S4 S5)
Jul 16 10:54:33 smoke    0.138351] ACPI: Using IOAPIC for interrupt routing
Jul 16 10:54:33 smoke    0.138623] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
Jul 16 10:54:33 smoke    0.140464] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
Jul 16 10:54:33 smoke    0.177044] ACPI: No dock devices found.
Jul 16 10:54:33 smoke    0.177271] PCI: Ignoring host bridge windows from ACPI; if necessary, use "pci=use_crs" and report a bug
Jul 16 10:54:33 smoke    0.177805] ACPI: PCI Root Bridge [PCI0] (0000:00)
Jul 16 10:54:33 smoke    0.179109] pci 0000:00:1f.0: quirk: [io  0x0800-0x087f] claimed by ICH6 ACPI/GPIO/TCO
Jul 16 10:54:33 smoke    0.179533] pci 0000:00:1f.0: quirk: [io  0x0480-0x04bf] claimed by ICH6 GPIO
Jul 16 10:54:33 smoke    0.179763] pci 0000:00:1f.0: ICH7 LPC Generic IO decode 1 PIO at 0294 (mask 0003)
Jul 16 10:54:33 smoke    0.180287] pci 0000:00:01.0: PCI bridge to [bus 01-01]
Jul 16 10:54:33 smoke    0.180557] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
Jul 16 10:54:33 smoke    0.181162] pci 0000:00:1c.3: PCI bridge to [bus 03-03]
Jul 16 10:54:33 smoke    0.181678] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
Jul 16 10:54:33 smoke    0.182106] pci 0000:00:1e.0: PCI bridge to [bus 05-05] (subtractive decode)
Jul 16 10:54:33 smoke    0.188378] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
Jul 16 10:54:33 smoke    0.189031] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
Jul 16 10:54:33 smoke    0.189678] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 10 11 12 14 *15)
Jul 16 10:54:33 smoke    0.190324] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 *10 11 12 14 15)
Jul 16 10:54:33 smoke    0.190969] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Jul 16 10:54:33 smoke    0.191860] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0, disabled.
Jul 16 10:54:33 smoke    0.192754] ACPI: PCI Interrupt Link [LNKG] (IRQs *3 4 5 6 7 10 11 12 14 15)
Jul 16 10:54:33 smoke    0.193401] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 10 11 12 *14 15)
Jul 16 10:54:33 smoke    0.194172] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
Jul 16 10:54:33 smoke    0.194548] vgaarb: loaded
Jul 16 10:54:33 smoke    0.195006] SCSI subsystem initialized
Jul 16 10:54:33 smoke    0.197161] usbcore: registered new interface driver usbfs
Jul 16 10:54:33 smoke    0.197426] usbcore: registered new interface driver hub
Jul 16 10:54:33 smoke    0.197690] usbcore: registered new device driver usb
Jul 16 10:54:33 smoke    0.214937] raid6: int64x1   1960 MB/s
Jul 16 10:54:33 smoke    0.231932] raid6: int64x2   2113 MB/s
Jul 16 10:54:33 smoke    0.248932] raid6: int64x4   1843 MB/s
Jul 16 10:54:33 smoke    0.265954] raid6: int64x8   1417 MB/s
Jul 16 10:54:33 smoke    0.282941] raid6: sse2x1    4328 MB/s
Jul 16 10:54:33 smoke    0.299935] raid6: sse2x2    4753 MB/s
Jul 16 10:54:33 smoke    0.316935] raid6: sse2x4    6953 MB/s
Jul 16 10:54:33 smoke    0.317001] raid6: using algorithm sse2x4 (6953 MB/s)
Jul 16 10:54:33 smoke    0.317488] Advanced Linux Sound Architecture Driver Version 1.0.22.1.
Jul 16 10:54:33 smoke    0.317503] PCI: Using ACPI for IRQ routing
Jul 16 10:54:33 smoke    0.317774] pci 0000:05:01.0: address space collision: [mem 0xfe2ffc00-0xfe2ffc7f] conflicts with PCI Bus 0000:01 [mem 0xfa700000-0xfe7fffff]
Jul 16 10:54:33 smoke    0.318571] HPET: 3 timers in total, 0 timers will be used for per-cpu timer
Jul 16 10:54:33 smoke    0.318571] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
Jul 16 10:54:33 smoke    0.319002] hpet0: 3 comparators, 64-bit 14.318180 MHz counter
Jul 16 10:54:33 smoke    0.322026] Switching to clocksource tsc
Jul 16 10:54:33 smoke    0.328618] pnp: PnP ACPI init
Jul 16 10:54:33 smoke    0.328852] ACPI: bus type pnp registered
Jul 16 10:54:33 smoke    0.333115] pnp: PnP ACPI: found 14 devices
Jul 16 10:54:33 smoke    0.333340] ACPI: ACPI bus type pnp unregistered
Jul 16 10:54:33 smoke    0.333575] system 00:01: [mem 0xfed14000-0xfed19fff] has been reserved
Jul 16 10:54:33 smoke    0.333808] system 00:07: [io  0x0290-0x0297] has been reserved
Jul 16 10:54:33 smoke    0.334043] system 00:08: [io  0x04d0-0x04d1] has been reserved
Jul 16 10:54:33 smoke    0.334271] system 00:08: [io  0x0800-0x087f] has been reserved
Jul 16 10:54:33 smoke    0.334498] system 00:08: [io  0x0480-0x04bf] has been reserved
Jul 16 10:54:33 smoke    0.334726] system 00:08: [mem 0xffafe000-0xffb0cbff] could not be reserved
Jul 16 10:54:33 smoke    0.334955] system 00:08: [mem 0xffb00000-0xffbfffff] has been reserved
Jul 16 10:54:33 smoke    0.335187] system 00:08: [mem 0xfed1c000-0xfed1ffff] has been reserved
Jul 16 10:54:33 smoke    0.335415] system 00:08: [mem 0xfed20000-0xfed8ffff] has been reserved
Jul 16 10:54:33 smoke    0.335645] system 00:08: [mem 0xfff00000-0xfffffffe] has been reserved
Jul 16 10:54:33 smoke    0.335873] system 00:08: [mem 0xfebfe000-0xfebfec00] has been reserved
Jul 16 10:54:33 smoke    0.336109] system 00:0b: [mem 0xfec00000-0xfec00fff] could not be reserved
Jul 16 10:54:33 smoke    0.336338] system 00:0b: [mem 0xfee00000-0xfee00fff] has been reserved
Jul 16 10:54:33 smoke    0.336570] system 00:0c: [mem 0xe0000000-0xefffffff] has been reserved
Jul 16 10:54:33 smoke    0.336800] system 00:0d: [mem 0x00000000-0x0009ffff] could not be reserved
Jul 16 10:54:33 smoke    0.337034] system 00:0d: [mem 0x000c0000-0x000cffff] has been reserved
Jul 16 10:54:33 smoke    0.337263] system 00:0d: [mem 0x000e0000-0x000fffff] could not be reserved
Jul 16 10:54:33 smoke    0.337492] system 00:0d: [mem 0x00100000-0x7fffffff] could not be reserved
Jul 16 10:54:33 smoke    0.344584] pci 0000:00:1c.0: BAR 8: assigned [mem 0x80000000-0x803fffff]
Jul 16 10:54:33 smoke    0.344814] pci 0000:00:1c.3: BAR 9: assigned [mem 0x80400000-0x805fffff 64bit pref]
Jul 16 10:54:33 smoke    0.345241] pci 0000:00:1c.4: BAR 9: assigned [mem 0x80600000-0x807fffff 64bit pref]
Jul 16 10:54:33 smoke    0.345664] pci 0000:00:1c.0: BAR 7: assigned [io  0x1000-0x1fff]
Jul 16 10:54:33 smoke    0.345892] pci 0000:00:1f.3: BAR 0: assigned [mem 0x80800000-0x808000ff]
Jul 16 10:54:33 smoke    0.346125] pci 0000:00:1f.3: BAR 0: set to [mem 0x80800000-0x808000ff] (PCI address [0x80800000-0x808000ff]
Jul 16 10:54:33 smoke    0.346551] pci 0000:00:01.0: PCI bridge to [bus 01-01]
Jul 16 10:54:33 smoke    0.346777] pci 0000:00:01.0:   bridge window [io  disabled]
Jul 16 10:54:33 smoke    0.347005] pci 0000:00:01.0:   bridge window [mem 0xfa700000-0xfe7fffff]
Jul 16 10:54:33 smoke    0.347238] pci 0000:00:01.0:   bridge window [mem 0xbfe00000-0xdfdfffff 64bit pref]
Jul 16 10:54:33 smoke    0.347662] pci 0000:00:1c.0: PCI bridge to [bus 04-04]
Jul 16 10:54:33 smoke    0.347889] pci 0000:00:1c.0:   bridge window [io  0x1000-0x1fff]
Jul 16 10:54:33 smoke    0.348121] pci 0000:00:1c.0:   bridge window [mem 0x80000000-0x803fffff]
Jul 16 10:54:33 smoke    0.348351] pci 0000:00:1c.0:   bridge window [mem 0xdfe00000-0xdfefffff 64bit pref]
Jul 16 10:54:33 smoke    0.348776] pci 0000:00:1c.3: PCI bridge to [bus 03-03]
Jul 16 10:54:33 smoke    0.349003] pci 0000:00:1c.3:   bridge window [io  0xa000-0xafff]
Jul 16 10:54:33 smoke    0.349235] pci 0000:00:1c.3:   bridge window [mem 0xfe900000-0xfe9fffff]
Jul 16 10:54:33 smoke    0.349465] pci 0000:00:1c.3:   bridge window [mem 0x80400000-0x805fffff 64bit pref]
Jul 16 10:54:33 smoke    0.349891] pci 0000:00:1c.4: PCI bridge to [bus 02-02]
Jul 16 10:54:33 smoke    0.350121] pci 0000:00:1c.4:   bridge window [io  0x9000-0x9fff]
Jul 16 10:54:33 smoke    0.350352] pci 0000:00:1c.4:   bridge window [mem 0xfe800000-0xfe8fffff]
Jul 16 10:54:33 smoke    0.350581] pci 0000:00:1c.4:   bridge window [mem 0x80600000-0x807fffff 64bit pref]
Jul 16 10:54:33 smoke    0.351008] pci 0000:05:01.0: BAR 0: assigned [mem 0xfea00000-0xfea0007f]
Jul 16 10:54:33 smoke    0.351242] pci 0000:05:01.0: BAR 0: error updating (0xfea00000 != 0xffffffff)
Jul 16 10:54:33 smoke    0.351664] pci 0000:05:01.0: BAR 0: set to [mem 0xfea00000-0xfea0007f] (PCI address [0xfea00000-0xfea0007f]
Jul 16 10:54:33 smoke    0.352092] pci 0000:00:1e.0: PCI bridge to [bus 05-05]
Jul 16 10:54:33 smoke    0.352319] pci 0000:00:1e.0:   bridge window [io  0xb000-0xbfff]
Jul 16 10:54:33 smoke    0.352549] pci 0000:00:1e.0:   bridge window [mem 0xfea00000-0xfeafffff]
Jul 16 10:54:33 smoke    0.352779] pci 0000:00:1e.0:   bridge window [mem pref disabled]
Jul 16 10:54:33 smoke    0.353021] pci 0000:00:01.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jul 16 10:54:33 smoke    0.353256] pci 0000:00:1c.0: enabling device (0106 -> 0107)
Jul 16 10:54:33 smoke    0.353485] pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jul 16 10:54:33 smoke    0.353723] pci 0000:00:1c.3: PCI INT D -> GSI 19 (level, low) -> IRQ 19
Jul 16 10:54:33 smoke    0.353961] pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Jul 16 10:54:33 smoke    0.354286] NET: Registered protocol family 2
Jul 16 10:54:33 smoke    0.354664] IP route cache hash table entries: 131072 (order: 8, 1048576 bytes)
Jul 16 10:54:33 smoke    0.356186] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
Jul 16 10:54:33 smoke    0.360401] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
Jul 16 10:54:33 smoke    0.361170] TCP: Hash tables configured (established 524288 bind 65536)
Jul 16 10:54:33 smoke    0.361399] TCP reno registered
Jul 16 10:54:33 smoke    0.361632] UDP hash table entries: 2048 (order: 4, 65536 bytes)
Jul 16 10:54:33 smoke    0.361898] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes)
Jul 16 10:54:33 smoke    0.362295] NET: Registered protocol family 1
Jul 16 10:54:33 smoke    0.363078] RPC: Registered udp transport module.
Jul 16 10:54:33 smoke    0.363310] RPC: Registered tcp transport module.
Jul 16 10:54:33 smoke    0.363536] RPC: Registered tcp NFSv4.1 backchannel transport module.
Jul 16 10:54:33 smoke    1.455306] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
Jul 16 10:54:33 smoke    1.455542] Placing 64MB software IO TLB between ffff880001b9b000 - ffff880005b9b000
Jul 16 10:54:33 smoke    1.455964] software IO TLB at phys 0x1b9b000 - 0x5b9b000
Jul 16 10:54:33 smoke    1.475715] HugeTLB registered 2 MB page size, pre-allocated 0 pages
Jul 16 10:54:33 smoke    1.477532] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
Jul 16 10:54:33 smoke    1.477947] Slow work thread pool: Starting up
Jul 16 10:54:33 smoke    1.478194] Slow work thread pool: Ready
Jul 16 10:54:33 smoke    1.478419] NTFS driver 2.1.29 [Flags: R/W].
Jul 16 10:54:33 smoke    1.478719] fuse init (API version 7.13)
Jul 16 10:54:33 smoke    1.478995] SGI XFS with security attributes, large block/inode numbers, no debug enabled
Jul 16 10:54:33 smoke    1.485278] msgmni has been set to 7931
Jul 16 10:54:33 smoke    1.485560] io scheduler noop registered
Jul 16 10:54:33 smoke    1.485799] io scheduler cfq registered (default)
Jul 16 10:54:33 smoke    1.513728] Linux agpgart interface v0.103
Jul 16 10:54:33 smoke    1.514040] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
Jul 16 10:54:33 smoke    1.514374] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul 16 10:54:33 smoke    1.515114] 00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
Jul 16 10:54:33 smoke    3.555145] floppy0: no floppy controllers found
Jul 16 10:54:33 smoke    3.556851] brd: module loaded
Jul 16 10:54:33 smoke    3.557800] loop: module loaded
Jul 16 10:54:33 smoke    3.560454] ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Jul 16 10:54:33 smoke    3.560684] ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
Jul 16 10:54:33 smoke    3.712203] scsi0 : ata_piix
Jul 16 10:54:33 smoke    3.712534] scsi1 : ata_piix
Jul 16 10:54:33 smoke    3.715034] ata1: SATA max UDMA/133 cmd 0xec00 ctl 0xe880 bmdma 0xe400 irq 19
Jul 16 10:54:33 smoke    3.715271] ata2: SATA max UDMA/133 cmd 0xe800 ctl 0xe480 bmdma 0xe408 irq 19
Jul 16 10:54:33 smoke    3.715514] ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
Jul 16 10:54:33 smoke    3.715745] ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
Jul 16 10:54:33 smoke    3.716160] scsi2 : ata_piix
Jul 16 10:54:33 smoke    3.721564] scsi3 : ata_piix
Jul 16 10:54:33 smoke    3.723432] ata3: SATA max UDMA/133 cmd 0xd400 ctl 0xd080 bmdma 0xc880 irq 19
Jul 16 10:54:33 smoke    3.723662] ata4: SATA max UDMA/133 cmd 0xd000 ctl 0xcc00 bmdma 0xc888 irq 19
Jul 16 10:54:33 smoke    3.723959] pata_jmicron 0000:02:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
Jul 16 10:54:33 smoke    3.724451] scsi4 : pata_jmicron
Jul 16 10:54:33 smoke    3.724773] scsi5 : pata_jmicron
Jul 16 10:54:33 smoke    3.725835] ata5: PATA max UDMA/100 cmd 0x9c00 ctl 0x9880 bmdma 0x9400 irq 17
Jul 16 10:54:33 smoke    3.726075] ata6: PATA max UDMA/100 cmd 0x9800 ctl 0x9480 bmdma 0x9408 irq 17
Jul 16 10:54:33 smoke    3.726512] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
Jul 16 10:54:33 smoke    3.726751] r8169 0000:03:00.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
Jul 16 10:54:33 smoke    3.727300] r8169 0000:03:00.0: eth0: RTL8168b/8111b at 0xffffc90000674000, 00:1b:fc:f5:78:1a, XID 18000000 IRQ 28
Jul 16 10:54:33 smoke    3.729181] netconsole: local port 4444
Jul 16 10:54:33 smoke    3.729407] netconsole: local IP 192.168.69.3
Jul 16 10:54:33 smoke    3.729632] netconsole: interface 'eth0'
Jul 16 10:54:33 smoke    3.729856] netconsole: remote port 514
Jul 16 10:54:33 smoke    3.730087] netconsole: remote IP 192.168.69.51
Jul 16 10:54:33 smoke    3.730312] netconsole: remote ethernet address ff:ff:ff:ff:ff:ff
Jul 16 10:54:33 smoke    3.730540] netconsole: device eth0 not up yet, forcing it
Jul 16 10:54:33 smoke    3.731105] r8169 0000:03:00.0: eth0: link down
Jul 16 10:54:33 smoke    3.731335] r8169 0000:03:00.0: eth0: link down
Jul 16 10:54:33 smoke    3.880676] ata5.00: ATAPI: MAD DOG MD-16XDVD9A2, 1.F0, max UDMA/33
Jul 16 10:54:33 smoke    3.887692] ata5.00: configured for UDMA/33
Jul 16 10:54:33 smoke    4.179048] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jul 16 10:54:33 smoke    4.180172] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jul 16 10:54:33 smoke    4.209555] ata3.00: HPA detected: current 2930275055, native 2930277168
Jul 16 10:54:33 smoke    4.209788] ata3.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
Jul 16 10:54:33 smoke    4.210021] ata3.00: 2930275055 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jul 16 10:54:33 smoke    4.210718] ata4.00: ATA-8: ST31500341AS, CC1H, max UDMA/133
Jul 16 10:54:33 smoke    4.210950] ata4.00: 2930277168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jul 16 10:54:33 smoke    4.259545] ata3.00: configured for UDMA/133
Jul 16 10:54:33 smoke    4.260709] ata4.00: configured for UDMA/133
Jul 16 10:54:33 smoke    4.477063] ata2.00: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Jul 16 10:54:33 smoke    4.477247] ata1.00: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
Jul 16 10:54:33 smoke    4.477269] ata1.01: SATA link down (SStatus 4 SControl 300)
Jul 16 10:54:33 smoke    4.477800] ata2.01: SATA link down (SStatus 4 SControl 300)
Jul 16 10:54:33 smoke    4.491264] ata2.00: ATA-7: WDC WD7500AAKS-00RBA0, 30.04G30, max UDMA/133
Jul 16 10:54:33 smoke    4.491494] ata2.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jul 16 10:54:33 smoke    4.497994] ata2.00: configured for UDMA/133
Jul 16 10:54:33 smoke    4.526583] ata1.00: ATA-7: ST3750640AS, 3.AAE, max UDMA/133
Jul 16 10:54:33 smoke    4.526818] ata1.00: 1465149168 sectors, multi 16: LBA48 NCQ (depth 0/32)
Jul 16 10:54:33 smoke    4.601556] ata1.00: configured for UDMA/133
Jul 16 10:54:33 smoke    4.601880] scsi 0:0:0:0: Direct-Access     ATA      ST3750640AS      3.AA PQ: 0 ANSI: 5
Jul 16 10:54:33 smoke    4.602521] sd 0:0:0:0: [sda] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
Jul 16 10:54:33 smoke    4.602967] sd 0:0:0:0: Attached scsi generic sg0 type 0
Jul 16 10:54:33 smoke    4.603009] sd 0:0:0:0: [sda] Write Protect is off
Jul 16 10:54:33 smoke    4.603032] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 16 10:54:33 smoke    4.603158]  sda:
Jul 16 10:54:33 smoke    4.603955] scsi 1:0:0:0: Direct-Access     ATA      WDC WD7500AAKS-0 30.0 PQ: 0 ANSI: 5
Jul 16 10:54:33 smoke    4.604764] sd 1:0:0:0: [sdb] 1465149168 512-byte logical blocks: (750 GB/698 GiB)
Jul 16 10:54:33 smoke    4.605269] sd 1:0:0:0: Attached scsi generic sg1 type 0
Jul 16 10:54:33 smoke    4.605527] sd 1:0:0:0: [sdb] Write Protect is off
Jul 16 10:54:33 smoke    4.605558] scsi 2:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
Jul 16 10:54:33 smoke    4.605777] sd 2:0:0:0: Attached scsi generic sg2 type 0
Jul 16 10:54:33 smoke    4.605833] sd 2:0:0:0: [sdc] 2930275055 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jul 16 10:54:33 smoke    4.605880] scsi 3:0:0:0: Direct-Access     ATA      ST31500341AS     CC1H PQ: 0 ANSI: 5
Jul 16 10:54:33 smoke    4.605934] sd 2:0:0:0: [sdc] Write Protect is off
Jul 16 10:54:33 smoke    4.605957] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 16 10:54:33 smoke    4.606076]  sdc:
Jul 16 10:54:33 smoke    4.606360] sd 3:0:0:0: Attached scsi generic sg3 type 0
Jul 16 10:54:33 smoke    4.606387] sd 3:0:0:0: [sdd] 2930277168 512-byte logical blocks: (1.50 TB/1.36 TiB)
Jul 16 10:54:33 smoke    4.606436] sd 3:0:0:0: [sdd] Write Protect is off
Jul 16 10:54:33 smoke    4.606459] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 16 10:54:33 smoke    4.606569]  sdd:
Jul 16 10:54:33 smoke    4.609381] scsi 4:0:0:0: CD-ROM            MAD DOG  MD-16XDVD9A2     1.F0 PQ: 0 ANSI: 5
Jul 16 10:54:33 smoke    4.610453] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
Jul 16 10:54:33 smoke    4.611094]  sdb: sdc1 sdc2 sdc3
Jul 16 10:54:33 smoke    4.612177] sd 2:0:0:0: [sdc] Attached SCSI disk
Jul 16 10:54:33 smoke    4.612515] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Jul 16 10:54:33 smoke    4.612746] Uniform CD-ROM driver Revision: 3.20
Jul 16 10:54:33 smoke    4.613194] sr 4:0:0:0: Attached scsi generic sg4 type 5
Jul 16 10:54:33 smoke    4.613436]  sdb1 sdb2 sdb3
Jul 16 10:54:33 smoke    4.614105] sd 1:0:0:0: [sdb] Attached SCSI disk
Jul 16 10:54:33 smoke    4.624099]  sdd1 sdd2 sdd3
Jul 16 10:54:33 smoke    4.624688] sd 3:0:0:0: [sdd] Attached SCSI disk
Jul 16 10:54:33 smoke    4.649509]  sda1 sda2 sda3
Jul 16 10:54:33 smoke    4.650103] sd 0:0:0:0: [sda] Attached SCSI disk
Jul 16 10:54:33 smoke    5.427356] r8169 0000:03:00.0: eth0: link up
Jul 16 10:54:33 smoke    5.548554] console [netcon0] enabled
Jul 16 10:54:33 smoke    5.548780] netconsole: network logging started
Jul 16 10:54:33 smoke    5.549014] Fusion MPT base driver 3.04.14
Jul 16 10:54:33 smoke    5.549240] Copyright (c) 1999-2008 LSI Corporation
Jul 16 10:54:33 smoke    5.549483] Fusion MPT SPI Host driver 3.04.14
Jul 16 10:54:33 smoke    5.549984] PNP: No PS/2 controller found. Probing ports directly.
Jul 16 10:54:33 smoke    5.552767] serio: i8042 KBD port at 0x60,0x64 irq 1
Jul 16 10:54:33 smoke    5.552999] serio: i8042 AUX port at 0x60,0x64 irq 12
Jul 16 10:54:33 smoke    5.553360] mice: PS/2 mouse device common for all mice
Jul 16 10:54:33 smoke    5.553694] rtc_cmos 00:03: RTC can wake from S4
Jul 16 10:54:33 smoke    5.553984] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
Jul 16 10:54:33 smoke    5.554242] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
Jul 16 10:54:33 smoke    5.554506] i2c /dev entries driver
Jul 16 10:54:33 smoke    5.554790] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.05
Jul 16 10:54:33 smoke    5.555123] iTCO_wdt: Found a ICH8 or ICH8R TCO device (Version=2, TCOBASE=0x0860)
Jul 16 10:54:33 smoke    5.555607] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
Jul 16 10:54:33 smoke    5.555836] iTCO_vendor_support: vendor-support=0
Jul 16 10:54:33 smoke    5.556072] md: raid0 personality registered for level 0
Jul 16 10:54:33 smoke    5.556299] md: raid1 personality registered for level 1
Jul 16 10:54:33 smoke    5.556531] md: raid10 personality registered for level 10
Jul 16 10:54:33 smoke    5.556763] md: raid6 personality registered for level 6
Jul 16 10:54:33 smoke    5.556995] md: raid5 personality registered for level 5
Jul 16 10:54:33 smoke    5.557239] md: raid4 personality registered for level 4
Jul 16 10:54:33 smoke    5.557582] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05) initialised: dm-devel@redhat.com
Jul 16 10:54:33 smoke    5.558024] cpuidle: using governor ladder
Jul 16 10:54:33 smoke    5.559096] usbcore: registered new interface driver usbhid
Jul 16 10:54:33 smoke    5.559324] usbhid: USB HID core driver
Jul 16 10:54:33 smoke    5.559555] ALSA device list:
Jul 16 10:54:33 smoke    5.559783]   No soundcards found.
Jul 16 10:54:33 smoke    5.560279] TCP cubic registered
Jul 16 10:54:33 smoke    5.560506] NET: Registered protocol family 17
Jul 16 10:54:33 smoke    5.568622] registered taskstats version 1
Jul 16 10:54:33 smoke    5.568896] raid6test: testing the 4-disk case...
Jul 16 10:54:33 smoke    5.569189] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
Jul 16 10:54:33 smoke    5.569469] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(P)  OK
Jul 16 10:54:33 smoke    5.569734] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(Q)  OK
Jul 16 10:54:33 smoke    5.570019] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(P)  OK
Jul 16 10:54:33 smoke    5.570282] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(Q)  OK
Jul 16 10:54:33 smoke    5.570544] raid6test: test_disks(2, 3): faila=  2(P)  failb=  3(Q)  OK
Jul 16 10:54:33 smoke    5.570811] raid6test: testing the 5-disk case...
Jul 16 10:54:33 smoke    5.571096] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
Jul 16 10:54:33 smoke    5.571380] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
Jul 16 10:54:33 smoke    5.571660] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(P)  OK
Jul 16 10:54:33 smoke    5.571922] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(Q)  OK
Jul 16 10:54:33 smoke    5.572211] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
Jul 16 10:54:33 smoke    5.572491] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(P)  OK
Jul 16 10:54:33 smoke    5.572755] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(Q)  OK
Jul 16 10:54:33 smoke    5.573040] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(P)  OK
Jul 16 10:54:33 smoke    5.573304] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(Q)  OK
Jul 16 10:54:33 smoke    5.573566] raid6test: test_disks(3, 4): faila=  3(P)  failb=  4(Q)  OK
Jul 16 10:54:33 smoke    5.573879] raid6test: testing the 11-disk case...
Jul 16 10:54:33 smoke    5.574172] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
Jul 16 10:54:33 smoke    5.574463] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
Jul 16 10:54:33 smoke    5.574753] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
Jul 16 10:54:33 smoke    5.575055] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
Jul 16 10:54:33 smoke    5.575355] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.575653] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.575943] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.576238] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.576524] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(P)  OK
Jul 16 10:54:33 smoke    5.576796] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(Q)  OK
Jul 16 10:54:33 smoke    5.577090] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
Jul 16 10:54:33 smoke    5.577382] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
Jul 16 10:54:33 smoke    5.577672] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
Jul 16 10:54:33 smoke    5.577962] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.578257] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.578548] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.578838] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.579128] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(P)  OK
Jul 16 10:54:33 smoke    5.579401] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(Q)  OK
Jul 16 10:54:33 smoke    5.579691] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
Jul 16 10:54:33 smoke    5.579981] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
Jul 16 10:54:33 smoke    5.580276] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.580567] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.580857] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.581151] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.581439] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(P)  OK
Jul 16 10:54:33 smoke    5.581711] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(Q)  OK
Jul 16 10:54:33 smoke    5.582006] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
Jul 16 10:54:33 smoke    5.582296] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.582588] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.582878] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.583172] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.583458] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(P)  OK
Jul 16 10:54:33 smoke    5.583731] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(Q)  OK
Jul 16 10:54:33 smoke    5.584026] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.584316] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.584608] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.584897] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.585188] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(P)  OK
Jul 16 10:54:33 smoke    5.585460] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(Q)  OK
Jul 16 10:54:33 smoke    5.585751] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.586052] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.586345] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.586632] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(P)  OK
Jul 16 10:54:33 smoke    5.586904] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(Q)  OK
Jul 16 10:54:33 smoke    5.587199] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.587489] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.587775] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(P)  OK
Jul 16 10:54:33 smoke    5.588052] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(Q)  OK
Jul 16 10:54:33 smoke    5.588343] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.588630] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(P)  OK
Jul 16 10:54:33 smoke    5.588901] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(Q)  OK
Jul 16 10:54:33 smoke    5.589193] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(P)  OK
Jul 16 10:54:33 smoke    5.589464] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(Q)  OK
Jul 16 10:54:33 smoke    5.589734] raid6test: test_disks(9, 10): faila=  9(P)  failb= 10(Q)  OK
Jul 16 10:54:33 smoke    5.590057] raid6test: testing the 12-disk case...
Jul 16 10:54:33 smoke    5.590346] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
Jul 16 10:54:33 smoke    5.590638] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
Jul 16 10:54:33 smoke    5.590929] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
Jul 16 10:54:33 smoke    5.591226] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
Jul 16 10:54:33 smoke    5.591517] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.591808] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.592103] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.592394] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.592686] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.592974] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(P)  OK
Jul 16 10:54:33 smoke    5.593252] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(Q)  OK
Jul 16 10:54:33 smoke    5.593544] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
Jul 16 10:54:33 smoke    5.593835] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
Jul 16 10:54:33 smoke    5.594129] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
Jul 16 10:54:33 smoke    5.594420] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.594711] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.595006] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.595300] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.595591] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.595881] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(P)  OK
Jul 16 10:54:33 smoke    5.596159] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(Q)  OK
Jul 16 10:54:33 smoke    5.596450] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
Jul 16 10:54:33 smoke    5.596750] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
Jul 16 10:54:33 smoke    5.597059] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.597352] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.597643] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.597934] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.598231] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.598519] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(P)  OK
Jul 16 10:54:33 smoke    5.598793] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(Q)  OK
Jul 16 10:54:33 smoke    5.599088] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
Jul 16 10:54:33 smoke    5.599380] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.599671] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.599962] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.600259] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.600551] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.600839] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(P)  OK
Jul 16 10:54:33 smoke    5.601117] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(Q)  OK
Jul 16 10:54:33 smoke    5.601410] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.601701] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.601992] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.602287] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.602579] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.602867] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(P)  OK
Jul 16 10:54:33 smoke    5.603145] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(Q)  OK
Jul 16 10:54:33 smoke    5.603437] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.603728] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.604024] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.604315] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.604603] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(P)  OK
Jul 16 10:54:33 smoke    5.604878] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(Q)  OK
Jul 16 10:54:33 smoke    5.605173] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.605465] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.605756] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.606048] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(P)  OK
Jul 16 10:54:33 smoke    5.606323] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(Q)  OK
Jul 16 10:54:33 smoke    5.611694] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.611996] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.612289] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(P)  OK
Jul 16 10:54:33 smoke    5.612563] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(Q)  OK
Jul 16 10:54:33 smoke    5.612855] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.613149] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(P)  OK
Jul 16 10:54:33 smoke    5.613423] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(Q)  OK
Jul 16 10:54:33 smoke    5.613711] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(P)  OK
Jul 16 10:54:33 smoke    5.613986] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(Q)  OK
Jul 16 10:54:33 smoke    5.614261] raid6test: test_disks(10, 11): faila= 10(P)  failb= 11(Q)  OK
Jul 16 10:54:33 smoke    5.614610] raid6test: testing the 16-disk case...
Jul 16 10:54:33 smoke    5.614907] raid6test: test_disks(0, 1): faila=  0(D)  failb=  1(D)  OK
Jul 16 10:54:33 smoke    5.615212] raid6test: test_disks(0, 2): faila=  0(D)  failb=  2(D)  OK
Jul 16 10:54:33 smoke    5.615509] raid6test: test_disks(0, 3): faila=  0(D)  failb=  3(D)  OK
Jul 16 10:54:33 smoke    5.615806] raid6test: test_disks(0, 4): faila=  0(D)  failb=  4(D)  OK
Jul 16 10:54:33 smoke    5.616108] raid6test: test_disks(0, 5): faila=  0(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.616406] raid6test: test_disks(0, 6): faila=  0(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.616704] raid6test: test_disks(0, 7): faila=  0(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.617005] raid6test: test_disks(0, 8): faila=  0(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.617302] raid6test: test_disks(0, 9): faila=  0(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.617599] raid6test: test_disks(0, 10): faila=  0(D)  failb= 10(D)  OK
Jul 16 10:54:33 smoke    5.617896] raid6test: test_disks(0, 11): faila=  0(D)  failb= 11(D)  OK
Jul 16 10:54:33 smoke    5.618197] raid6test: test_disks(0, 12): faila=  0(D)  failb= 12(D)  OK
Jul 16 10:54:33 smoke    5.618495] raid6test: test_disks(0, 13): faila=  0(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.618789] raid6test: test_disks(0, 14): faila=  0(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.619075] raid6test: test_disks(0, 15): faila=  0(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.619373] raid6test: test_disks(1, 2): faila=  1(D)  failb=  2(D)  OK
Jul 16 10:54:33 smoke    5.619671] raid6test: test_disks(1, 3): faila=  1(D)  failb=  3(D)  OK
Jul 16 10:54:33 smoke    5.619968] raid6test: test_disks(1, 4): faila=  1(D)  failb=  4(D)  OK
Jul 16 10:54:33 smoke    5.620270] raid6test: test_disks(1, 5): faila=  1(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.620568] raid6test: test_disks(1, 6): faila=  1(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.620866] raid6test: test_disks(1, 7): faila=  1(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.621168] raid6test: test_disks(1, 8): faila=  1(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.621466] raid6test: test_disks(1, 9): faila=  1(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.621764] raid6test: test_disks(1, 10): faila=  1(D)  failb= 10(D)  OK
Jul 16 10:54:33 smoke    5.622065] raid6test: test_disks(1, 11): faila=  1(D)  failb= 11(D)  OK
Jul 16 10:54:33 smoke    5.622364] raid6test: test_disks(1, 12): faila=  1(D)  failb= 12(D)  OK
Jul 16 10:54:33 smoke    5.622662] raid6test: test_disks(1, 13): faila=  1(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.622956] raid6test: test_disks(1, 14): faila=  1(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.623242] raid6test: test_disks(1, 15): faila=  1(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.623540] raid6test: test_disks(2, 3): faila=  2(D)  failb=  3(D)  OK
Jul 16 10:54:33 smoke    5.623839] raid6test: test_disks(2, 4): faila=  2(D)  failb=  4(D)  OK
Jul 16 10:54:33 smoke    5.624142] raid6test: test_disks(2, 5): faila=  2(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.624440] raid6test: test_disks(2, 6): faila=  2(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.624738] raid6test: test_disks(2, 7): faila=  2(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.625040] raid6test: test_disks(2, 8): faila=  2(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.625338] raid6test: test_disks(2, 9): faila=  2(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.625636] raid6test: test_disks(2, 10): faila=  2(D)  failb= 10(D)  OK
Jul 16 10:54:33 smoke    5.625934] raid6test: test_disks(2, 11): faila=  2(D)  failb= 11(D)  OK
Jul 16 10:54:33 smoke    5.626237] raid6test: test_disks(2, 12): faila=  2(D)  failb= 12(D)  OK
Jul 16 10:54:33 smoke    5.626535] raid6test: test_disks(2, 13): faila=  2(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.626830] raid6test: test_disks(2, 14): faila=  2(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.627116] raid6test: test_disks(2, 15): faila=  2(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.627414] raid6test: test_disks(3, 4): faila=  3(D)  failb=  4(D)  OK
Jul 16 10:54:33 smoke    5.627713] raid6test: test_disks(3, 5): faila=  3(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.628014] raid6test: test_disks(3, 6): faila=  3(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.628313] raid6test: test_disks(3, 7): faila=  3(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.628611] raid6test: test_disks(3, 8): faila=  3(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.628910] raid6test: test_disks(3, 9): faila=  3(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.629211] raid6test: test_disks(3, 10): faila=  3(D)  failb= 10(D)  OK
Jul 16 10:54:33 smoke    5.629509] raid6test: test_disks(3, 11): faila=  3(D)  failb= 11(D)  OK
Jul 16 10:54:33 smoke    5.629808] raid6test: test_disks(3, 12): faila=  3(D)  failb= 12(D)  OK
Jul 16 10:54:33 smoke    5.630109] raid6test: test_disks(3, 13): faila=  3(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.630403] raid6test: test_disks(3, 14): faila=  3(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.630684] raid6test: test_disks(3, 15): faila=  3(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.630983] raid6test: test_disks(4, 5): faila=  4(D)  failb=  5(D)  OK
Jul 16 10:54:33 smoke    5.631285] raid6test: test_disks(4, 6): faila=  4(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.631582] raid6test: test_disks(4, 7): faila=  4(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.631881] raid6test: test_disks(4, 8): faila=  4(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.632182] raid6test: test_disks(4, 9): faila=  4(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.632479] raid6test: test_disks(4, 10): faila=  4(D)  failb= 10(D)  OK
Jul 16 10:54:33 smoke    5.632776] raid6test: test_disks(4, 11): faila=  4(D)  failb= 11(D)  OK
Jul 16 10:54:33 smoke    5.633077] raid6test: test_disks(4, 12): faila=  4(D)  failb= 12(D)  OK
Jul 16 10:54:33 smoke    5.633375] raid6test: test_disks(4, 13): faila=  4(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.633669] raid6test: test_disks(4, 14): faila=  4(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.633951] raid6test: test_disks(4, 15): faila=  4(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.634252] raid6test: test_disks(5, 6): faila=  5(D)  failb=  6(D)  OK
Jul 16 10:54:33 smoke    5.634550] raid6test: test_disks(5, 7): faila=  5(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.634848] raid6test: test_disks(5, 8): faila=  5(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.635149] raid6test: test_disks(5, 9): faila=  5(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.635447] raid6test: test_disks(5, 10): faila=  5(D)  failb= 10(D)  OK
Jul 16 10:54:33 smoke    5.635744] raid6test: test_disks(5, 11): faila=  5(D)  failb= 11(D)  OK
Jul 16 10:54:33 smoke    5.636045] raid6test: test_disks(5, 12): faila=  5(D)  failb= 12(D)  OK
Jul 16 10:54:33 smoke    5.636342] raid6test: test_disks(5, 13): faila=  5(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.636636] raid6test: test_disks(5, 14): faila=  5(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.636917] raid6test: test_disks(5, 15): faila=  5(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.637220] raid6test: test_disks(6, 7): faila=  6(D)  failb=  7(D)  OK
Jul 16 10:54:33 smoke    5.637517] raid6test: test_disks(6, 8): faila=  6(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.637814] raid6test: test_disks(6, 9): faila=  6(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.638118] raid6test: test_disks(6, 10): faila=  6(D)  failb= 10(D)  OK
Jul 16 10:54:33 smoke    5.638415] raid6test: test_disks(6, 11): faila=  6(D)  failb= 11(D)  OK
Jul 16 10:54:33 smoke    5.638712] raid6test: test_disks(6, 12): faila=  6(D)  failb= 12(D)  OK
Jul 16 10:54:33 smoke    5.639014] raid6test: test_disks(6, 13): faila=  6(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.639308] raid6test: test_disks(6, 14): faila=  6(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.639591] raid6test: test_disks(6, 15): faila=  6(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.639889] raid6test: test_disks(7, 8): faila=  7(D)  failb=  8(D)  OK
Jul 16 10:54:33 smoke    5.640190] raid6test: test_disks(7, 9): faila=  7(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.640489] raid6test: test_disks(7, 10): faila=  7(D)  failb= 10(D)  OK
Jul 16 10:54:33 smoke    5.640786] raid6test: test_disks(7, 11): faila=  7(D)  failb= 11(D)  OK
Jul 16 10:54:33 smoke    5.641088] raid6test: test_disks(7, 12): faila=  7(D)  failb= 12(D)  OK
Jul 16 10:54:33 smoke    5.641385] raid6test: test_disks(7, 13): faila=  7(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.641680] raid6test: test_disks(7, 14): faila=  7(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.641962] raid6test: test_disks(7, 15): faila=  7(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.642264] raid6test: test_disks(8, 9): faila=  8(D)  failb=  9(D)  OK
Jul 16 10:54:33 smoke    5.642562] raid6test: test_disks(8, 10): faila=  8(D)  failb= 10(D)  OK
Jul 16 10:54:33 smoke    5.642859] raid6test: test_disks(8, 11): faila=  8(D)  failb= 11(D)  OK
Jul 16 10:54:33 smoke    5.643162] raid6test: test_disks(8, 12): faila=  8(D)  failb= 12(D)  OK
Jul 16 10:54:33 smoke    5.643459] raid6test: test_disks(8, 13): faila=  8(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.643753] raid6test: test_disks(8, 14): faila=  8(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.644039] raid6test: test_disks(8, 15): faila=  8(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.644336] raid6test: test_disks(9, 10): faila=  9(D)  failb= 10(D)  OK
Jul 16 10:54:33 smoke    5.644635] raid6test: test_disks(9, 11): faila=  9(D)  failb= 11(D)  OK
Jul 16 10:54:33 smoke    5.644932] raid6test: test_disks(9, 12): faila=  9(D)  failb= 12(D)  OK
Jul 16 10:54:33 smoke    5.645235] raid6test: test_disks(9, 13): faila=  9(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.645529] raid6test: test_disks(9, 14): faila=  9(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.645811] raid6test: test_disks(9, 15): faila=  9(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.646113] raid6test: test_disks(10, 11): faila= 10(D)  failb= 11(D)  OK
Jul 16 10:54:33 smoke    5.646411] raid6test: test_disks(10, 12): faila= 10(D)  failb= 12(D)  OK
Jul 16 10:54:33 smoke    5.646709] raid6test: test_disks(10, 13): faila= 10(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.647008] raid6test: test_disks(10, 14): faila= 10(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.647290] raid6test: test_disks(10, 15): faila= 10(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.647587] raid6test: test_disks(11, 12): faila= 11(D)  failb= 12(D)  OK
Jul 16 10:54:33 smoke    5.647884] raid6test: test_disks(11, 13): faila= 11(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.648184] raid6test: test_disks(11, 14): faila= 11(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.648466] raid6test: test_disks(11, 15): faila= 11(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.648764] raid6test: test_disks(12, 13): faila= 12(D)  failb= 13(D)  OK
Jul 16 10:54:33 smoke    5.649062] raid6test: test_disks(12, 14): faila= 12(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.649344] raid6test: test_disks(12, 15): faila= 12(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.649639] raid6test: test_disks(13, 14): faila= 13(D)  failb= 14(P)  OK
Jul 16 10:54:33 smoke    5.649920] raid6test: test_disks(13, 15): faila= 13(D)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.650203] raid6test: test_disks(14, 15): faila= 14(P)  failb= 15(Q)  OK
Jul 16 10:54:33 smoke    5.650432] raid6test:
Jul 16 10:54:33 smoke    5.650660] raid6test: complete (257 tests, 0 failures)
Jul 16 10:54:33 smoke    5.651191] rtc_cmos 00:03: setting system clock to 2010-07-16 10:53:46 UTC (1279277626)
Jul 16 10:54:33 smoke    5.651678] md: Skipping autodetection of RAID arrays. (raid=autodetect will force)
Jul 16 10:54:33 smoke    5.652156] md: Loading md0: /dev/sda1
Jul 16 10:54:33 smoke    5.659468] md: bind<sda1>
Jul 16 10:54:33 smoke    5.665738] md: bind<sdb1>
Jul 16 10:54:33 smoke    5.672715] md: bind<sdc1>
Jul 16 10:54:33 smoke    5.682976] md: bind<sdd1>
Jul 16 10:54:33 smoke    5.683330] raid1: raid set md0 active with 4 out of 4 mirrors
Jul 16 10:54:33 smoke    5.684892] md0: bitmap initialized from disk: read 2/2 pages, set 2 bits
Jul 16 10:54:33 smoke    5.685136] created bitmap (17 pages) for device md0
Jul 16 10:54:33 smoke    5.701247] md0: detected capacity change from 0 to 139722752
Jul 16 10:54:33 smoke    5.701515]  md0:
Jul 16 10:54:33 smoke unknown: partition table
Jul 16 10:54:33 smoke    5.701979]  md0:
Jul 16 10:54:33 smoke unknown: partition table
Jul 16 10:54:33 smoke    5.702284] md: Loading md1: /dev/sda3
Jul 16 10:54:33 smoke    5.727158] md: bind<sda3>
Jul 16 10:54:33 smoke    5.747680] md: bind<sdb3>
Jul 16 10:54:33 smoke    5.747962] raid0: looking at sdb3
Jul 16 10:54:33 smoke    5.748193] raid0:   comparing sdb3(1462894720)
Jul 16 10:54:33 smoke
Jul 16 10:54:33 smoke    5.748232]  with sdb3(1462894720)
Jul 16 10:54:33 smoke    5.748681] raid0:   END
Jul 16 10:54:33 smoke    5.748909] raid0:   ==> UNIQUE
Jul 16 10:54:33 smoke    5.749142] raid0: 1 zones
Jul 16 10:54:33 smoke    5.749367] raid0: looking at sda3
Jul 16 10:54:33 smoke    5.749595] raid0:   comparing sda3(1462894720)
Jul 16 10:54:33 smoke
Jul 16 10:54:33 smoke    5.749633]  with sdb3(1462894720)
Jul 16 10:54:33 smoke    5.750085] raid0:   EQUAL
Jul 16 10:54:33 smoke    5.750309] raid0: FINAL 1 zones
Jul 16 10:54:33 smoke    5.750538] raid0: done.
Jul 16 10:54:33 smoke    5.750765] raid0 : md_size is 2925789440 sectors.
Jul 16 10:54:33 smoke    5.750995] ******* md1 configuration *********
Jul 16 10:54:33 smoke    5.751230] zone0=[
Jul 16 10:54:33 smoke sda3/:
Jul 16 10:54:33 smoke sdb3/:
Jul 16 10:54:33 smoke ]:
Jul 16 10:54:33 smoke    5.751549]         zone offset=0kb device offset=0kb size=1462894720kb
Jul 16 10:54:33 smoke    5.751781] **********************************
Jul 16 10:54:33 smoke    5.751782]
Jul 16 10:54:33 smoke    5.752243] md1: detected capacity change from 0 to 1498004193280
Jul 16 10:54:33 smoke    5.752507]  md1:
Jul 16 10:54:33 smoke unknown: partition table
Jul 16 10:54:33 smoke    5.772125]  md1:
Jul 16 10:54:33 smoke unknown: partition table
Jul 16 10:54:33 smoke    5.772423] md: Loading md2: /dev/sdc3
Jul 16 10:54:33 smoke    5.804405] md: bind<sdc3>
Jul 16 10:54:33 smoke    5.826223] md: bind<sdd3>
Jul 16 10:54:33 smoke    5.829411] md: bind<md1>
Jul 16 10:54:33 smoke    5.829702] raid5: device md1 operational as raid disk 0
Jul 16 10:54:33 smoke    5.829936] raid5: device sdd3 operational as raid disk 2
Jul 16 10:54:33 smoke    5.830173] raid5: device sdc3 operational as raid disk 1
Jul 16 10:54:33 smoke    5.830740] raid5: allocated 3222kB for md2
Jul 16 10:54:33 smoke    5.836064] 0: w=1 pa=0 pr=3 m=1 a=2 r=3 op1=0 op2=0
Jul 16 10:54:33 smoke    5.836292] 2: w=2 pa=0 pr=3 m=1 a=2 r=3 op1=0 op2=0
Jul 16 10:54:33 smoke    5.836523] 1: w=3 pa=0 pr=3 m=1 a=2 r=3 op1=0 op2=0
Jul 16 10:54:33 smoke    5.836754] raid5: raid level 5 set md2 active with 3 out of 3 devices, algorithm 2
Jul 16 10:54:33 smoke    5.837186] RAID5 conf printout:
Jul 16 10:54:33 smoke    5.837413]  --- rd:3 wd:3
Jul 16 10:54:33 smoke    5.837641]  disk 0, o:1, dev:md1
Jul 16 10:54:33 smoke    5.837869]  disk 1, o:1, dev:sdc3
Jul 16 10:54:33 smoke    5.838104]  disk 2, o:1, dev:sdd3
Jul 16 10:54:33 smoke    5.847551] md2: bitmap initialized from disk: read 11/11 pages, set 124 bits
Jul 16 10:54:33 smoke    5.847782] created bitmap (175 pages) for device md2
Jul 16 10:54:33 smoke    5.901557] md2: detected capacity change from 0 to 2991715123200
Jul 16 10:54:33 smoke    5.901837]  md2:
Jul 16 10:54:33 smoke unknown: partition table
Jul 16 10:54:33 smoke    5.905401]  md2:
Jul 16 10:54:33 smoke unknown: partition table
Jul 16 10:58:28 smoke  240.504141] INFO: task swapper:1 blocked for more than 120 seconds.
Jul 16 10:58:28 smoke  240.504381] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.                                                              
Jul 16 10:58:28 smoke  240.504808] swapper       D                                                                                                                        
Jul 16 10:58:28 smoke ffff88017fac6040:
Jul 16 10:58:28 smoke 0:     1      0 0x00000000
Jul 16 10:58:28 smoke  240.505101]  ffff88017fac9a50
Jul 16 10:58:28 smoke 0000000000000046:
Jul 16 10:58:28 smoke ffff88017fac99e0:
Jul 16 10:58:28 smoke ffffffff8102eae0:
Jul 16 10:58:28 smoke
Jul 16 10:58:28 smoke  240.505653]  ffff88017fac9fd8
Jul 16 10:58:28 smoke ffff88017fac6040:
Jul 16 10:58:28 smoke ffff88017fac9fd8:
Jul 16 10:58:28 smoke ffff88017fac8000:
Jul 16 10:58:28 smoke
Jul 16 10:58:28 smoke  240.506202]  ffff88017fac8000
Jul 16 10:58:28 smoke ffff88017fac9fd8:
Jul 16 10:58:28 smoke 0000000000004000:
Jul 16 10:58:28 smoke 00000000000135c0:
Jul 16 10:58:28 smoke
Jul 16 10:58:28 smoke  240.506748] Call Trace:
Jul 16 10:58:28 smoke  240.506981]  [<ffffffff8102eae0>] ? check_preempt_wakeup+0x11e/0x197
Jul 16 10:58:28 smoke  240.507217]  [<ffffffff8147486b>] schedule_timeout+0x28/0x27a
Jul 16 10:58:28 smoke  240.507447]  [<ffffffff8138e0e3>] ? raid0_unplug+0x41/0x53
Jul 16 10:58:28 smoke  240.507678]  [<ffffffff8126760e>] ? blk_unplug+0x71/0x76
Jul 16 10:58:28 smoke  240.507909]  [<ffffffff8139a4be>] ? unplug_slaves+0x100/0x128
Jul 16 10:58:28 smoke  240.508145]  [<ffffffff81473bce>] wait_for_common+0xc2/0x13c
Jul 16 10:58:28 smoke  240.508377]  [<ffffffff8102d66d>] ? default_wake_function+0x0/0xf
Jul 16 10:58:28 smoke  240.508609]  [<ffffffff81251e52>] ? xfs_barrier_test+0x43/0x7d
Jul 16 10:58:28 smoke  240.508840]  [<ffffffff81251e52>] ? xfs_barrier_test+0x43/0x7d
Jul 16 10:58:28 smoke  240.509072]  [<ffffffff81473cd2>] wait_for_completion+0x18/0x1a
Jul 16 10:58:28 smoke  240.509309]  [<ffffffff81249cca>] xfs_buf_iowait+0xa5/0x110
Jul 16 10:58:28 smoke  240.509539]  [<ffffffff81251e52>] xfs_barrier_test+0x43/0x7d
Jul 16 10:58:28 smoke  240.509771]  [<ffffffff81251ecb>] xfs_mountfs_check_barriers+0x3f/0x69
Jul 16 10:58:28 smoke  240.510003]  [<ffffffff812520fa>] xfs_fs_fill_super+0x205/0x38f
Jul 16 10:58:28 smoke  240.510239]  [<ffffffff810cb03d>] get_sb_bdev+0x125/0x174
Jul 16 10:58:28 smoke  240.510469]  [<ffffffff81251ef5>] ? xfs_fs_fill_super+0x0/0x38f
Jul 16 10:58:28 smoke  240.510701]  [<ffffffff81250538>] xfs_fs_get_sb+0x13/0x15
Jul 16 10:58:28 smoke  240.510932]  [<ffffffff810c9e00>] vfs_kern_mount+0x6a/0xf8
Jul 16 10:58:28 smoke  240.511168]  [<ffffffff810c9eec>] do_kern_mount+0x48/0xe8
Jul 16 10:58:28 smoke  240.511399]  [<ffffffff810e028d>] do_mount+0x761/0x7d8
Jul 16 10:58:28 smoke  240.511631]  [<ffffffff810a31ae>] ? strndup_user+0x58/0x80
Jul 16 10:58:28 smoke  240.511862]  [<ffffffff810e038b>] sys_mount+0x87/0xc8
Jul 16 10:58:28 smoke  240.512095]  [<ffffffff81736f4d>] mount_block_root+0xe0/0x275
Jul 16 10:58:28 smoke  240.512329]  [<ffffffff81737182>] mount_root+0xa0/0xa4
Jul 16 10:58:28 smoke  240.512560]  [<ffffffff817372eb>] prepare_namespace+0x165/0x192
Jul 16 10:58:28 smoke  240.512792]  [<ffffffff817366d7>] kernel_init+0x1c7/0x1d7
Jul 16 10:58:28 smoke  240.513024]  [<ffffffff81002cd4>] kernel_thread_helper+0x4/0x10
Jul 16 10:58:28 smoke  240.513259]  [<ffffffff81736510>] ? kernel_init+0x0/0x1d7
Jul 16 10:58:28 smoke  240.513489]  [<ffffffff81002cd0>] ? kernel_thread_helper+0x0/0x10
Jul 16 10:58:28 smoke  240.513721] INFO: task events/0:9 blocked for more than 120 seconds.
Jul 16 10:58:28 smoke  240.513952] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 16 10:58:28 smoke  240.514382] events/0      D
Jul 16 10:58:28 smoke ffff88017fb18000:
Jul 16 10:58:28 smoke 0:     9      2 0x00000000
Jul 16 10:58:28 smoke  240.514675]  ffff88017fb19cd0
Jul 16 10:58:28 smoke 0000000000000046:
Jul 16 10:58:28 smoke 0000000057545194:
Jul 16 10:58:28 smoke 0000000000000001:
Jul 16 10:58:28 smoke
Jul 16 10:58:28 smoke  240.515222]  ffff88017fb19fd8
Jul 16 10:58:28 smoke ffff88017fb16280:
Jul 16 10:58:28 smoke ffff88017fb19fd8:
Jul 16 10:58:28 smoke ffff88017fb18000:
Jul 16 10:58:28 smoke
Jul 16 10:58:28 smoke  240.515768]  ffff88017fb18000
Jul 16 10:58:28 smoke ffff88017fb19fd8:
Jul 16 10:58:28 smoke 0000000000004000:
Jul 16 10:58:28 smoke 00000000000135c0:
Jul 16 10:58:28 smoke
Jul 16 10:58:28 smoke  240.516317] Call Trace:
Jul 16 10:58:28 smoke  240.516546]  [<ffffffff8147641f>] ? _raw_spin_unlock_irqrestore+0x12/0x2d
Jul 16 10:58:28 smoke  240.516780]  [<ffffffff81050f39>] ? prepare_to_wait+0x71/0x7c
Jul 16 10:58:28 smoke  240.517012]  [<ffffffff813a406a>] md_write_start+0x133/0x14b
Jul 16 10:58:28 smoke  240.517247]  [<ffffffff81050cf7>] ? autoremove_wake_function+0x0/0x34
Jul 16 10:58:28 smoke  240.517480]  [<ffffffff8139edb6>] make_request+0x6b/0x53c
Jul 16 10:58:28 smoke  240.517712]  [<ffffffff81092edb>] ? mempool_free_slab+0x12/0x14
Jul 16 10:58:28 smoke  240.517943]  [<ffffffff81092f60>] ? mempool_free+0x71/0x76
Jul 16 10:58:28 smoke  240.518178]  [<ffffffff8147641f>] ? _raw_spin_unlock_irqrestore+0x12/0x2d
Jul 16 10:58:28 smoke  240.518410]  [<ffffffff81027752>] ? __wake_up+0x3f/0x48
Jul 16 10:58:28 smoke  240.518640]  [<ffffffff813a8a6d>] md_submit_barrier+0x58/0xad
Jul 16 10:58:28 smoke  240.518872]  [<ffffffff8104cb89>] worker_thread+0x1f8/0x29f
Jul 16 10:58:28 smoke  240.519103]  [<ffffffff813a8a15>] ? md_submit_barrier+0x0/0xad
Jul 16 10:58:28 smoke  240.519338]  [<ffffffff81050cf7>] ? autoremove_wake_function+0x0/0x34
Jul 16 10:58:28 smoke  240.519570]  [<ffffffff8104c991>] ? worker_thread+0x0/0x29f
Jul 16 10:58:28 smoke  240.519802]  [<ffffffff8105085b>] kthread+0x7a/0x82
Jul 16 10:58:28 smoke  240.520032]  [<ffffffff81002cd4>] kernel_thread_helper+0x4/0x10
Jul 16 10:58:28 smoke  240.520267]  [<ffffffff810507e1>] ? kthread+0x0/0x82
Jul 16 10:58:28 smoke  240.520497]  [<ffffffff81002cd0>] ? kernel_thread_helper+0x0/0x10
Jul 16 10:58:28 smoke  240.520730] INFO: task md2_raid5:1203 blocked for more than 120 seconds.
Jul 16 10:58:28 smoke  240.520961] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 16 10:58:28 smoke  240.521392] md2_raid5     D
Jul 16 10:58:28 smoke 00000000fffb8359:
Jul 16 10:58:28 smoke 0:  1203      2 0x00000000
Jul 16 10:58:28 smoke  240.521683]  ffff88017db1dbe0
Jul 16 10:58:28 smoke 0000000000000046:
Jul 16 10:58:28 smoke ffff88017db1c000:
Jul 16 10:58:28 smoke 0000000800000000:
Jul 16 10:58:28 smoke
Jul 16 10:58:28 smoke  240.522230]  ffff88017db1dfd8
Jul 16 10:58:28 smoke ffff88017e65c040:
Jul 16 10:58:28 smoke ffff88017db1dfd8:
Jul 16 10:58:28 smoke ffff88017db1c000:
Jul 16 10:58:28 smoke
Jul 16 10:58:28 smoke  240.522773]  ffff88017db1c000
Jul 16 10:58:28 smoke ffff88017db1dfd8:
Jul 16 10:58:28 smoke 0000000000004000:
Jul 16 10:58:28 smoke 00000000000135c0:
Jul 16 10:58:28 smoke
Jul 16 10:58:28 smoke  240.523319] Call Trace:
Jul 16 10:58:28 smoke  240.523548]  [<ffffffff8147641f>] ? _raw_spin_unlock_irqrestore+0x12/0x2d
Jul 16 10:58:28 smoke  240.523780]  [<ffffffff813a6359>] md_super_wait+0xb5/0xd1
Jul 16 10:58:28 smoke  240.524011]  [<ffffffff81050cf7>] ? autoremove_wake_function+0x0/0x34
Jul 16 10:58:28 smoke  240.524247]  [<ffffffff813ac3e2>] write_page+0x24c/0x33c
Jul 16 10:58:28 smoke  240.524478]  [<ffffffff8108b44f>] ? perf_event_task_sched_in+0x16/0x86
Jul 16 10:58:28 smoke  240.524710]  [<ffffffff814763f2>] ? _raw_spin_unlock_irq+0x11/0x2c
Jul 16 10:58:28 smoke  240.524943]  [<ffffffff813ac5eb>] bitmap_update_sb+0x119/0x11e
Jul 16 10:58:28 smoke  240.525178]  [<ffffffff813a68e0>] md_update_sb+0x237/0x306
Jul 16 10:58:28 smoke  240.525409]  [<ffffffff813a828a>] md_check_recovery+0x1d1/0x472
Jul 16 10:58:28 smoke  240.525640]  [<ffffffff8139c43b>] raid5d+0x1f/0x400
Jul 16 10:58:28 smoke  240.525872]  [<ffffffff81474a9b>] ? schedule_timeout+0x258/0x27a
Jul 16 10:58:28 smoke  240.526104]  [<ffffffff8104324d>] ? process_timeout+0x0/0xb
Jul 16 10:58:28 smoke  240.526341]  [<ffffffff814766f6>] ? _raw_spin_lock_irqsave+0x18/0x34
Jul 16 10:58:28 smoke  240.526572]  [<ffffffff814766f6>] ? _raw_spin_lock_irqsave+0x18/0x34
Jul 16 10:58:28 smoke  240.526804]  [<ffffffff8147641f>] ? _raw_spin_unlock_irqrestore+0x12/0x2d
Jul 16 10:58:28 smoke  240.527036]  [<ffffffff813a6286>] md_thread+0xf1/0x10f
Jul 16 10:58:28 smoke  240.527271]  [<ffffffff81050cf7>] ? autoremove_wake_function+0x0/0x34
Jul 16 10:58:28 smoke  240.527503]  [<ffffffff81476438>] ? _raw_spin_unlock_irqrestore+0x2b/0x2d
Jul 16 10:58:28 smoke  240.527734]  [<ffffffff813a6195>] ? md_thread+0x0/0x10f
Jul 16 10:58:28 smoke  240.527966]  [<ffffffff8105085b>] kthread+0x7a/0x82
Jul 16 10:58:28 smoke  240.528200]  [<ffffffff81002cd4>] kernel_thread_helper+0x4/0x10
Jul 16 10:58:28 smoke  240.528432]  [<ffffffff810507e1>] ? kthread+0x0/0x82
Jul 16 10:58:28 smoke  240.528662]  [<ffffffff81002cd0>] ? kernel_thread_helper+0x0/0x10

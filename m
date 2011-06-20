From: "Sandra Escandor" <sescandor@evertz.com>
Subject: RE: Issues with auto assembling or RAID10 (imsm) on boot
Date: Mon, 20 Jun 2011 16:19:27 -0400
Message-ID: <C70A636B101FD44999B82525C3E92AFAD36F83@otis.burlington.evertz.tv>
References: <C70A636B101FD44999B82525C3E92AFAD36F3E@otis.burlington.evertz.tv> <4DFF9C19.1080801@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <4DFF9C19.1080801@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I just want to make sure I mention this if this is important: I built
this from source and then I ran make install. I couldn't see any
documentation that would suggest that I had to do anything else in /etc/
(such as an init script - maybe this is what I need? I don't know enough
about the inner workings of Linux just yet).

The following is the complete dmesg that I've got - the last part is
where I manually assemble after boot:

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.35-28-generic (buildd@allspice) (gcc
version 4.4.5 (Ubuntu/Linaro 4.4.4-14ubuntu5) ) #50-Ubuntu SMP Fri Mar
18 18:42:20 UTC 2011 (Ubuntu 2.6.35-28.50-generic 2.6.35.11)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-2.6.35-28-generic
root=UUID=4029f80d-37ec-41dd-96dd-0a647ee240be ro quiet splash
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000090400 (usable)
[    0.000000]  BIOS-e820: 0000000000090400 - 00000000000a0000
(reserved)
[    0.000000]  BIOS-e820: 00000000000e0000 - 0000000000100000
(reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bf780000 (usable)
[    0.000000]  BIOS-e820: 00000000bf78e000 - 00000000bf790000
(reserved)
[    0.000000]  BIOS-e820: 00000000bf790000 - 00000000bf79e000 (ACPI
data)
[    0.000000]  BIOS-e820: 00000000bf79e000 - 00000000bf7d0000 (ACPI
NVS)
[    0.000000]  BIOS-e820: 00000000bf7d0000 - 00000000bf7e0000
(reserved)
[    0.000000]  BIOS-e820: 00000000bf7ec000 - 00000000c0000000
(reserved)
[    0.000000]  BIOS-e820: 00000000e0000000 - 00000000f0000000
(reserved)
[    0.000000]  BIOS-e820: 00000000fed20000 - 00000000fed40000
(reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000
(reserved)
[    0.000000]  BIOS-e820: 00000000ffc00000 - 0000000100000000
(reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 00000002c0000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] AMI BIOS detected: BIOS may corrupt low RAM, working
around it.
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) ==> (reserved)
[    0.000000] e820 update range: 0000000000000000 - 0000000000001000
(usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000
(usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x2c0000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-DFFFF uncachable
[    0.000000]   E0000-E3FFF write-protect
[    0.000000]   E4000-EFFFF write-through
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0000000000 mask FE00000000 write-back
[    0.000000]   1 base 0200000000 mask FF80000000 write-back
[    0.000000]   2 base 0280000000 mask FFC0000000 write-back
[    0.000000]   3 base 00C0000000 mask FFC0000000 uncachable
[    0.000000]   4 base 00BF800000 mask FFFF800000 uncachable
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[    0.000000] e820 update range: 00000000bf800000 - 0000000100000000
(usable) ==> (reserved)
[    0.000000] last_pfn = 0xbf780 max_arch_pfn = 0x400000000
[    0.000000] Scanning 0 areas for low memory corruption
[    0.000000] modified physical RAM map:
[    0.000000]  modified: 0000000000000000 - 0000000000010000 (reserved)
[    0.000000]  modified: 0000000000010000 - 0000000000090400 (usable)
[    0.000000]  modified: 0000000000090400 - 00000000000a0000 (reserved)
[    0.000000]  modified: 00000000000e0000 - 0000000000100000 (reserved)
[    0.000000]  modified: 0000000000100000 - 00000000bf780000 (usable)
[    0.000000]  modified: 00000000bf78e000 - 00000000bf790000 (reserved)
[    0.000000]  modified: 00000000bf790000 - 00000000bf79e000 (ACPI
data)
[    0.000000]  modified: 00000000bf79e000 - 00000000bf7d0000 (ACPI NVS)
[    0.000000]  modified: 00000000bf7d0000 - 00000000bf7e0000 (reserved)
[    0.000000]  modified: 00000000bf7ec000 - 00000000c0000000 (reserved)
[    0.000000]  modified: 00000000e0000000 - 00000000f0000000 (reserved)
[    0.000000]  modified: 00000000fed20000 - 00000000fed40000 (reserved)
[    0.000000]  modified: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  modified: 00000000ffc00000 - 0000000100000000 (reserved)
[    0.000000]  modified: 0000000100000000 - 00000002c0000000 (usable)
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000bf780000
[    0.000000]  0000000000 - 0080000000 page 1G
[    0.000000]  0080000000 - 00bf600000 page 2M
[    0.000000]  00bf600000 - 00bf780000 page 4k
[    0.000000] kernel direct mapping tables up to bf780000 @ 16000-19000
[    0.000000] init_memory_mapping: 0000000100000000-00000002c0000000
[    0.000000]  0100000000 - 02c0000000 page 1G
[    0.000000] kernel direct mapping tables up to 2c0000000 @
18000-19000
[    0.000000] RAMDISK: 374a8000 - 37ff0000
[    0.000000] ACPI: RSDP 00000000000fac10 00024 (v02 ACPIAM)
[    0.000000] ACPI: XSDT 00000000bf790100 0008C (v01 SMCI
20110209 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000bf790290 000F4 (v03 SUPERM FACP1427
20110209 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000bf7906f0 06A2C (v01  1060C 1060C000
00000000 INTL 20051117)
[    0.000000] ACPI: FACS 00000000bf79e000 00040
[    0.000000] ACPI: APIC 00000000bf790390 0011E (v01 SUPERM APIC1427
20110209 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000bf7904b0 0003C (v01 SUPERM OEMMCFG
20110209 MSFT 00000097)
[    0.000000] ACPI: SLIT 00000000bf7904f0 00030 (v01 SUPERM OEMSLIT
20110209 MSFT 00000097)
[    0.000000] ACPI: SPMI 00000000bf790520 00041 (v05 SUPERM OEMSPMI
20110209 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000bf79e040 00085 (v01 SUPERM OEMB1427
20110209 MSFT 00000097)
[    0.000000] ACPI: SRAT 00000000bf79a6f0 00250 (v01 SUPERM OEMSRAT
00000001 INTL 00000001)
[    0.000000] ACPI: HPET 00000000bf79a940 00038 (v01 SUPERM OEMHPET
20110209 MSFT 00000097)
[    0.000000] ACPI: SSDT 00000000bf7a6010 00363 (v01 DpgPmm    CpuPm
00000012 INTL 20051117)
[    0.000000] ACPI: EINJ 00000000bf79a980 00130 (v01  AMIER AMI_EINJ
20110209 MSFT 00000097)
[    0.000000] ACPI: BERT 00000000bf79ab10 00030 (v01  AMIER AMI_BERT
20110209 MSFT 00000097)
[    0.000000] ACPI: ERST 00000000bf79ab40 001B0 (v01  AMIER AMI_ERST
20110209 MSFT 00000097)
[    0.000000] ACPI: HEST 00000000bf79acf0 000A8 (v01  AMIER ABC_HEST
20110209 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] NUMA: Using 30 for the hash shift.
[    0.000000] Initmem setup node 0 0000000000000000-0000000140000000
[    0.000000]   NODE_DATA [0000000100000000 - 0000000100004fff]
[    0.000000] Initmem setup node 1 0000000140000000-00000002c0000000
[    0.000000]   NODE_DATA [0000000140000000 - 0000000140004fff]
[    0.000000]  [ffffea0000000000-ffffea00045fffff] PMD ->
[ffff880100200000-ffff8801039fffff] on node 0
[    0.000000]  [ffffea0004600000-ffffea00099fffff] PMD ->
[ffff880140200000-ffff8801455fffff] on node 1
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x002c0000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[4] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000090
[    0.000000]     0: 0x00000100 -> 0x000bf780
[    0.000000]     0: 0x00100000 -> 0x00140000
[    0.000000]     1: 0x00140000 -> 0x002c0000
[    0.000000] On node 0 totalpages: 1046272
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 0 pages reserved
[    0.000000]   DMA zone: 3912 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 765880 pages, LIFO batch:31
[    0.000000]   Normal zone: 3584 pages used for memmap
[    0.000000]   Normal zone: 258560 pages, LIFO batch:31
[    0.000000] On node 1 totalpages: 1572864
[    0.000000]   Normal zone: 21504 pages used for memmap
[    0.000000]   Normal zone: 1551360 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: IOAPIC (id[0x06] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 6, version 32, address 0xfec00000, GSI
0-23
[    0.000000] ACPI: IOAPIC (id[0x07] address[0xfec8a000] gsi_base[24])
[    0.000000] IOAPIC[1]: apic_id 7, version 32, address 0xfec8a000, GSI
24-47
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high
level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a301 base: 0xfed00000
[    0.000000] SMP: Allowing 24 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 64
[    0.000000] early_res array is doubled to 64 at [18040 - 1883f]
[    0.000000] Allocating PCI resources starting at c0000000 (gap:
c0000000:20000000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:64 nr_cpumask_bits:64 nr_cpu_ids:24
nr_node_ids:2
[    0.000000] early_res array is doubled to 128 at [18840 - 1983f]
[    0.000000] PERCPU: Embedded 30 pages/cpu @ffff880001e00000 s91520
r8192 d23168 u131072
[    0.000000] pcpu-alloc: s91520 r8192 d23168 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 12 13 14 15 16 17 -- --
-- -- 
[    0.000000] pcpu-alloc: [1] 06 07 08 09 10 11 18 19 20 21 22 23 -- --
-- -- 
[    0.000000] Built 2 zonelists in Node order, mobility grouping on.
Total pages: 2579712
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line:
BOOT_IMAGE=/boot/vmlinuz-2.6.35-28-generic
root=UUID=4029f80d-37ec-41dd-96dd-0a647ee240be ro quiet splash
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA -
bailing!
[    0.000000] Subtract (84 early reservations)
[    0.000000]   #1 [0001000000 - 0001d18114]   TEXT DATA BSS
[    0.000000]   #2 [00374a8000 - 0037ff0000]         RAMDISK
[    0.000000]   #3 [0001d19000 - 0001d19267]             BRK
[    0.000000]   #4 [00000ff790 - 0000100000]   BIOS reserved
[    0.000000]   #5 [00000ff780 - 00000ff790]    MP-table mpf
[    0.000000]   #6 [0000090400 - 00000fd4d0]   BIOS reserved
[    0.000000]   #7 [00000fd744 - 00000ff780]   BIOS reserved
[    0.000000]   #8 [00000fd4d0 - 00000fd744]    MP-table mpc
[    0.000000]   #9 [0000010000 - 0000012000]      TRAMPOLINE
[    0.000000]   #10 [0000012000 - 0000016000]     ACPI WAKEUP
[    0.000000]   #11 [0000016000 - 0000018000]         PGTABLE
[    0.000000]   #12 [0000018000 - 0000018030]       ACPI SLIT
[    0.000000]   #13 [0100000000 - 0100005000]       NODE_DATA
[    0.000000]   #14 [0140000000 - 0140005000]       NODE_DATA
[    0.000000]   #15 [0001d19280 - 0001d1a280]         BOOTMEM
[    0.000000]   #16 [0001d18140 - 0001d18440]         BOOTMEM
[    0.000000]   #17 [0140005000 - 0140005480]         BOOTMEM
[    0.000000]   #18 [0100005000 - 0100006000]         BOOTMEM
[    0.000000]   #19 [0100006000 - 0100007000]         BOOTMEM
[    0.000000]   #20 [0100200000 - 0103a00000]        MEMMAP 0
[    0.000000]   #21 [0140200000 - 0145600000]        MEMMAP 1
[    0.000000] Memory: 10239036k/11534336k available (5716k kernel code,
1057792k absent, 237508k reserved, 5375k data, 912k init)
[    0.000000] SLUB: Genslabs=14, HWalign=64, Order=0-3, MinObjects=0,
CPUs=24, Nodes=2
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU-based detection of stalled CPUs is disabled.
[    0.000000] 	Verbose stalled-CPUs detection is disabled.
[    0.000000] NR_IRQS:4352 nr_irqs:1280
[    0.000000] Extended CMOS year: 2000
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 104857600 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.010000] Detected 3333.489 MHz processor.
[    0.000009] Calibrating delay loop (skipped), value calculated using
timer frequency.. 6666.97 BogoMIPS (lpj=33334890)
[    0.000012] pid_max: default: 32768 minimum: 301
[    0.000037] Security Framework initialized
[    0.000048] AppArmor: AppArmor initialized
[    0.000048] Yama: becoming mindful.
[    0.001111] Dentry cache hash table entries: 2097152 (order: 12,
16777216 bytes)
[    0.004560] Inode-cache hash table entries: 1048576 (order: 11,
8388608 bytes)
[    0.005914] Mount-cache hash table entries: 256
[    0.006026] Initializing cgroup subsys ns
[    0.006028] Initializing cgroup subsys cpuacct
[    0.006032] Initializing cgroup subsys memory
[    0.006051] Initializing cgroup subsys devices
[    0.006053] Initializing cgroup subsys freezer
[    0.006054] Initializing cgroup subsys net_cls
[    0.006076] CPU: Physical Processor ID: 0
[    0.006077] CPU: Processor Core ID: 0
[    0.006081] mce: CPU supports 9 MCE banks
[    0.006088] CPU0: Thermal monitoring enabled (TM1)
[    0.006094] using mwait in idle threads.
[    0.006095] Performance Events: PEBS fmt1+, Westmere events, Intel
PMU driver.
[    0.006100] ... version:                3
[    0.006101] ... bit width:              48
[    0.006101] ... generic registers:      4
[    0.006103] ... value mask:             0000ffffffffffff
[    0.006104] ... max period:             000000007fffffff
[    0.006105] ... fixed-purpose events:   3
[    0.006105] ... event mask:             000000070000000f
[    0.007525] ACPI: Core revision 20100428
[    0.036353] ftrace: converting mcount calls to 0f 1f 44 00 00
[    0.036356] ftrace: allocating 22687 entries in 89 pages
[    0.041403] Setting APIC routing to physical flat
[    0.041828] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.162577] CPU0: Intel(R) Xeon(R) CPU           X5680  @ 3.33GHz
stepping 02
[    0.279168] Booting Node   0, Processors  #1 #2 #3 #4 #5 Ok.
[    1.178682] Booting Node   1, Processors  #6 #7 #8 #9 #10 #11 Ok.
[    2.257959] Booting Node   0, Processors  #12 #13 #14 #15 #16 #17 Ok.
[    3.337333] Booting Node   1, Processors  #18 #19 #20 #21 #22 #23 Ok.
[    4.416570] Brought up 24 CPUs
[    4.416573] Total of 24 processors activated (160005.10 BogoMIPS).
[    4.434511] devtmpfs: initialized
[    4.435232] regulator: core version 0.5
[    4.435253] Time: 19:33:21  Date: 06/20/11
[    4.435281] NET: Registered protocol family 16
[    4.435360] ACPI: bus type pci registered
[    4.435388] Trying to unpack rootfs image as initramfs...
[    4.435408] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem
0xe0000000-0xefffffff] (base 0xe0000000)
[    4.435411] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in
E820
[    4.457438] PCI: Using configuration type 1 for base access
[    4.458233] bio: create slab <bio-0> at 0
[    4.459361] ACPI: EC: Look up EC in DSDT
[    4.459521] \_SB_:_OSC evaluation returned wrong type
[    4.459522] _OSC request data:1 7 
[    4.460250] ACPI: Executed 1 blocks of module-level executable AML
code
[    4.470539] ACPI: SSDT 00000000bf79e0d0 072CC (v01 DpgPmm  P001Ist
00000011 INTL 20051117)
[    4.471019] ACPI: Dynamic OEM Table Load:
[    4.471021] ACPI: SSDT (null) 072CC (v01 DpgPmm  P001Ist 00000011
INTL 20051117)
[    4.471359] ACPI: SSDT 00000000bf7a53a0 00C69 (v01  PmRef  P001Cst
00003001 INTL 20051117)
[    4.471651] ACPI: Dynamic OEM Table Load:
[    4.471653] ACPI: SSDT (null) 00C69 (v01  PmRef  P001Cst 00003001
INTL 20051117)
[    4.472062] ACPI: Interpreter enabled
[    4.472064] ACPI: (supports S0 S1 S4 S5)
[    4.472076] ACPI: Using IOAPIC for interrupt routing
[    4.480287] ACPI: No dock devices found.
[    4.480289] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    4.480427] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    4.582203] SCSI subsystem initialized
[    4.582484] libata version 3.00 loaded.
[    4.582516] usbcore: registered new interface driver usbfs
[    4.582522] usbcore: registered new interface driver hub
[    4.582543] usbcore: registered new device driver usb
[    4.582621] ACPI: WMI: Mapper loaded
[    4.582622] PCI: Using ACPI for IRQ routing
[    4.582623] PCI: pci_cache_line_size set to 64 bytes
[    4.582714] reserve RAM buffer: 0000000000090400 - 000000000009ffff 
[    4.582715] reserve RAM buffer: 00000000bf780000 - 00000000bfffffff 
[    4.582778] NetLabel: Initializing
[    4.582779] NetLabel:  domain hash size = 128
[    4.582779] NetLabel:  protocols = UNLABELED CIPSOv4
[    4.582787] NetLabel:  unlabeled traffic allowed by default
[    4.582807] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[    4.582810] hpet0: 4 comparators, 64-bit 14.318180 MHz counter
[    4.584824] Switching to clocksource tsc
[    4.590692] AppArmor: AppArmor Filesystem Enabled
[    4.590698] pnp: PnP ACPI init
[    4.590707] ACPI: bus type pnp registered
[    4.593187] pnp: PnP ACPI: found 15 devices
[    4.593188] ACPI: ACPI bus type pnp unregistered
[    4.599131]   alloc irq_desc for 16 on node 0
[    4.599134]   alloc kstat_irqs on node 0
[    4.599224] NET: Registered protocol family 2
[    4.599522] IP route cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    4.600660] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    4.602085] TCP bind hash table entries: 65536 (order: 8, 1048576
bytes)
[    4.602266] TCP: Hash tables configured (established 524288 bind
65536)
[    4.602268] TCP reno registered
[    4.602288] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    4.602351] UDP-Lite hash table entries: 8192 (order: 6, 262144
bytes)
[    4.602530] NET: Registered protocol family 1
[    4.602712] pci 0000:04:00.0: Boot video device
[    4.602724] PCI: CLS 256 bytes, default 64
[    4.602725] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    4.602727] Placing 64MB software IO TLB between ffff880001f7e000 -
ffff880005f7e000
[    4.602728] software IO TLB at phys 0x1f7e000 - 0x5f7e000
[    4.602980] Freeing initrd memory: 11552k freed
[    4.603625] Scanning for low memory corruption every 60 seconds
[    4.603719] audit: initializing netlink socket (disabled)
[    4.603729] type=2000 audit(1308598401.220:1): initialized
[    4.613891] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    4.615220] VFS: Disk quotas dquot_6.5.2
[    4.615263] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    4.615667] fuse init (API version 7.14)
[    4.615721] msgmni has been set to 20020
[    4.617706] Block layer SCSI generic (bsg) driver version 0.4 loaded
(major 253)
[    4.617709] io scheduler noop registered
[    4.617710] io scheduler deadline registered
[    4.617735] io scheduler cfq registered (default)
[    4.617835] pcieport 0000:00:01.0: setting latency timer to 64
[    4.617857]   alloc irq_desc for 64 on node 0
[    4.617858]   alloc kstat_irqs on node 0
[    4.617865] pcieport 0000:00:01.0: irq 64 for MSI/MSI-X
[    4.617938] pcieport 0000:00:03.0: setting latency timer to 64
[    4.617958]   alloc irq_desc for 65 on node 0
[    4.617959]   alloc kstat_irqs on node 0
[    4.617963] pcieport 0000:00:03.0: irq 65 for MSI/MSI-X
[    4.618029] pcieport 0000:00:05.0: setting latency timer to 64
[    4.618049]   alloc irq_desc for 66 on node 0
[    4.618050]   alloc kstat_irqs on node 0
[    4.618054] pcieport 0000:00:05.0: irq 66 for MSI/MSI-X
[    4.618117] pcieport 0000:00:07.0: setting latency timer to 64
[    4.618137]   alloc irq_desc for 67 on node 0
[    4.618138]   alloc kstat_irqs on node 0
[    4.618143] pcieport 0000:00:07.0: irq 67 for MSI/MSI-X
[    4.618210] pcieport 0000:00:1c.0: setting latency timer to 64
[    4.618235]   alloc irq_desc for 68 on node 0
[    4.618236]   alloc kstat_irqs on node 0
[    4.618241] pcieport 0000:00:1c.0: irq 68 for MSI/MSI-X
[    4.618316] pcieport 0000:00:1c.4: setting latency timer to 64
[    4.618340]   alloc irq_desc for 69 on node 0
[    4.618342]   alloc kstat_irqs on node 0
[    4.618346] pcieport 0000:00:1c.4: irq 69 for MSI/MSI-X
[    4.618417] aer 0000:00:01.0:pcie02: AER service couldn't init
device: no _OSC support
[    4.618422] aer 0000:00:03.0:pcie02: AER service couldn't init
device: no _OSC support
[    4.618426] aer 0000:00:05.0:pcie02: AER service couldn't init
device: no _OSC support
[    4.618429] aer 0000:00:07.0:pcie02: AER service couldn't init
device: no _OSC support
[    4.618440] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    4.618487] pciehp: PCI Express Hot Plug Controller Driver version:
0.4
[    4.618530] intel_idle: MWAIT substates: 0x1120
[    4.618531] intel_idle: v0.4 model 0x2C
[    4.618532] intel_idle: lapic_timer_reliable_states 0xffffffff
[    4.618662] input: Power Button as
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
[    4.618670] ACPI: Power Button [PWRB]
[    4.618695] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
[    4.618697] ACPI: Power Button [PWRF]
[    4.618950] ACPI: acpi_idle yielding to intel_idle
[    4.621513] [Firmware Bug]: ERST: ERST table is invalid
[    4.621640] Linux agpgart interface v0.103
[    4.621652] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    4.621741] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.621830] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.622043] 00:0a: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
[    4.622143] 00:0b: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
[    4.622905] brd: module loaded
[    4.623230] loop: module loaded
[    4.623477] Fixed MDIO Bus: probed
[    4.623494] PPP generic driver version 2.4.2
[    4.623515] tun: Universal TUN/TAP device driver, 1.6
[    4.623517] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    4.623555] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI)
Driver
[    4.623591]   alloc irq_desc for 18 on node 0
[    4.623593]   alloc kstat_irqs on node 0
[    4.623596] ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low)
-> IRQ 18
[    4.623615] ehci_hcd 0000:00:1a.7: setting latency timer to 64
[    4.623617] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[    4.623644] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned
bus number 1
[    4.623666] ehci_hcd 0000:00:1a.7: debug port 1
[    4.627561] ehci_hcd 0000:00:1a.7: cache line size of 256 is not
supported
[    4.627573] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xf7fde000
[    4.644833] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00
[    4.644936] hub 1-0:1.0: USB hub found
[    4.644940] hub 1-0:1.0: 6 ports detected
[    4.645020]   alloc irq_desc for 23 on node 0
[    4.645021]   alloc kstat_irqs on node 0
[    4.645025] ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low)
-> IRQ 23
[    4.645034] ehci_hcd 0000:00:1d.7: setting latency timer to 64
[    4.645036] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[    4.645065] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned
bus number 2
[    4.645083] ehci_hcd 0000:00:1d.7: debug port 1
[    4.648971] ehci_hcd 0000:00:1d.7: cache line size of 256 is not
supported
[    4.648984] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xf7fdc000
[    4.664834] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00
[    4.664925] hub 2-0:1.0: USB hub found
[    4.664927] hub 2-0:1.0: 6 ports detected
[    4.664974] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    4.664984] uhci_hcd: USB Universal Host Controller Interface driver
[    4.665037] uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low)
-> IRQ 16
[    4.665043] uhci_hcd 0000:00:1a.0: setting latency timer to 64
[    4.665045] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[    4.665070] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned
bus number 3
[    4.665096] uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000bf80
[    4.665163] hub 3-0:1.0: USB hub found
[    4.665165] hub 3-0:1.0: 2 ports detected
[    4.665229]   alloc irq_desc for 21 on node 0
[    4.665230]   alloc kstat_irqs on node 0
[    4.665233] uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low)
-> IRQ 21
[    4.665237] uhci_hcd 0000:00:1a.1: setting latency timer to 64
[    4.665239] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[    4.665262] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned
bus number 4
[    4.665287] uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000bf40
[    4.665354] hub 4-0:1.0: USB hub found
[    4.665356] hub 4-0:1.0: 2 ports detected
[    4.665418]   alloc irq_desc for 19 on node 0
[    4.665419]   alloc kstat_irqs on node 0
[    4.665422] uhci_hcd 0000:00:1a.2: PCI INT D -> GSI 19 (level, low)
-> IRQ 19
[    4.665426] uhci_hcd 0000:00:1a.2: setting latency timer to 64
[    4.665428] uhci_hcd 0000:00:1a.2: UHCI Host Controller
[    4.665451] uhci_hcd 0000:00:1a.2: new USB bus registered, assigned
bus number 5
[    4.665477] uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000bf20
[    4.665542] hub 5-0:1.0: USB hub found
[    4.665545] hub 5-0:1.0: 2 ports detected
[    4.665609] uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low)
-> IRQ 23
[    4.665613] uhci_hcd 0000:00:1d.0: setting latency timer to 64
[    4.665615] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[    4.665642] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned
bus number 6
[    4.665661] uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000bf00
[    4.665730] hub 6-0:1.0: USB hub found
[    4.665733] hub 6-0:1.0: 2 ports detected
[    4.665796] uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low)
-> IRQ 19
[    4.665800] uhci_hcd 0000:00:1d.1: setting latency timer to 64
[    4.665802] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[    4.665829] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned
bus number 7
[    4.665849] uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000bec0
[    4.665916] hub 7-0:1.0: USB hub found
[    4.665919] hub 7-0:1.0: 2 ports detected
[    4.665982] uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low)
-> IRQ 18
[    4.665986] uhci_hcd 0000:00:1d.2: setting latency timer to 64
[    4.665988] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[    4.666014] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned
bus number 8
[    4.666033] uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000bea0
[    4.666100] hub 8-0:1.0: USB hub found
[    4.666103] hub 8-0:1.0: 2 ports detected
[    4.666176] PNP: No PS/2 controller found. Probing ports directly.
[    4.668702] serio: i8042 KBD port at 0x60,0x64 irq 1
[    4.668705] serio: i8042 AUX port at 0x60,0x64 irq 12
[    4.668745] mice: PS/2 mouse device common for all mice
[    4.668805] rtc_cmos 00:03: RTC can wake from S4
[    4.668827] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    4.668848] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet
irqs
[    4.668907] device-mapper: uevent: version 1.0.3
[    4.668958] device-mapper: ioctl: 4.17.0-ioctl (2010-03-05)
initialised: dm-devel@redhat.com
[    4.669487] device-mapper: multipath: version 1.1.1 loaded
[    4.669489] device-mapper: multipath round-robin: version 1.0.0
loaded
[    4.670885] cpuidle: using governor ladder
[    4.671437] cpuidle: using governor menu
[    4.671623] TCP cubic registered
[    4.671699] NET: Registered protocol family 10
[    4.672026] lo: Disabled Privacy Extensions
[    4.672144] NET: Registered protocol family 17
[    4.681012] PM: Resume from disk failed.
[    4.681018] registered taskstats version 1
[    4.681350]   Magic number: 15:547:597
[    4.682151] rtc_cmos 00:03: setting system clock to 2011-06-20
19:33:22 UTC (1308598402)
[    4.682152] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    4.682153] EDD information not available.
[    4.682200] Freeing unused kernel memory: 912k freed
[    4.682347] Write protecting the kernel read-only data: 10240k
[    4.685390] Freeing unused kernel memory: 408k freed
[    4.686794] Freeing unused kernel memory: 1640k freed
[    4.700454] udev[353]: starting version 163
[    4.717782] dca service started, version 1.12.1
[    4.726167] Intel(R) Gigabit Ethernet Network Driver - version
2.1.0-k2
[    4.726169] Copyright (c) 2007-2009 Intel Corporation.
[    4.726385] igb 0000:05:00.0: power state changed by ACPI to D0
[    4.726476] igb 0000:05:00.0: power state changed by ACPI to D0
[    4.726484] igb 0000:05:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ
16
[    4.726498] igb 0000:05:00.0: setting latency timer to 64
[    4.727107]   alloc irq_desc for 70 on node 0
[    4.727111]   alloc kstat_irqs on node 0
[    4.727116] igb 0000:05:00.0: irq 70 for MSI/MSI-X
[    4.727117]   alloc irq_desc for 71 on node 0
[    4.727118]   alloc kstat_irqs on node 0
[    4.727119] igb 0000:05:00.0: irq 71 for MSI/MSI-X
[    4.727120]   alloc irq_desc for 72 on node 0
[    4.727121]   alloc kstat_irqs on node 0
[    4.727123] igb 0000:05:00.0: irq 72 for MSI/MSI-X
[    4.727124]   alloc irq_desc for 73 on node 0
[    4.727125]   alloc kstat_irqs on node 0
[    4.727127] igb 0000:05:00.0: irq 73 for MSI/MSI-X
[    4.727127]   alloc irq_desc for 74 on node 0
[    4.727128]   alloc kstat_irqs on node 0
[    4.727130] igb 0000:05:00.0: irq 74 for MSI/MSI-X
[    4.727131]   alloc irq_desc for 75 on node 0
[    4.727132]   alloc kstat_irqs on node 0
[    4.727133] igb 0000:05:00.0: irq 75 for MSI/MSI-X
[    4.727135]   alloc irq_desc for 76 on node 0
[    4.727135]   alloc kstat_irqs on node 0
[    4.727137] igb 0000:05:00.0: irq 76 for MSI/MSI-X
[    4.727138]   alloc irq_desc for 77 on node 0
[    4.727139]   alloc kstat_irqs on node 0
[    4.727140] igb 0000:05:00.0: irq 77 for MSI/MSI-X
[    4.727141]   alloc irq_desc for 78 on node 0
[    4.727142]   alloc kstat_irqs on node 0
[    4.727144] igb 0000:05:00.0: irq 78 for MSI/MSI-X
[    4.727194] igb 0000:05:00.0: 0 vfs allocated
[    4.727351] ahci 0000:00:1f.2: version 3.0
[    4.727358] ahci 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) ->
IRQ 19
[    4.727378]   alloc irq_desc for 79 on node 0
[    4.727379]   alloc kstat_irqs on node 0
[    4.727384] ahci 0000:00:1f.2: irq 79 for MSI/MSI-X
[    4.727390] ahci 0000:00:1f.2: controller can't do SNTF, turning off
CAP_SNTF
[    4.727411] ahci: SSS flag set, parallel bus scan disabled
[    4.727443] ahci 0000:00:1f.2: AHCI 0001.0200 32 slots 6 ports 3 Gbps
0x3f impl RAID mode
[    4.727445] ahci 0000:00:1f.2: flags: 64bit ncq stag pm led clo pio
slum part ccc ems sxs 
[    4.727448] ahci 0000:00:1f.2: setting latency timer to 64
[    4.824917] scsi0 : ahci
[    4.825114] scsi1 : ahci
[    4.825265] scsi2 : ahci
[    4.825419] scsi3 : ahci
[    4.825513] scsi4 : ahci
[    4.825603] scsi5 : ahci
[    4.825745] ata1: SATA max UDMA/133 abar m2048@0xf7fda000 port
0xf7fda100 irq 79
[    4.825747] ata2: SATA max UDMA/133 abar m2048@0xf7fda000 port
0xf7fda180 irq 79
[    4.825749] ata3: SATA max UDMA/133 abar m2048@0xf7fda000 port
0xf7fda200 irq 79
[    4.825750] ata4: SATA max UDMA/133 abar m2048@0xf7fda000 port
0xf7fda280 irq 79
[    4.825752] ata5: SATA max UDMA/133 abar m2048@0xf7fda000 port
0xf7fda300 irq 79
[    4.825754] ata6: SATA max UDMA/133 abar m2048@0xf7fda000 port
0xf7fda380 irq 79
[    4.975158] igb 0000:05:00.0: Intel(R) Gigabit Ethernet Network
Connection
[    4.975160] igb 0000:05:00.0: eth0: (PCIe:2.5Gb/s:Width x4)
00:25:90:20:f8:0a
[    4.975242] igb 0000:05:00.0: eth0: PBA No: ffffff-0ff
[    4.975243] igb 0000:05:00.0: Using MSI-X interrupts. 8 rx queue(s),
8 tx queue(s)
[    4.975644] igb 0000:05:00.1: power state changed by ACPI to D0
[    4.975733] igb 0000:05:00.1: power state changed by ACPI to D0
[    4.975739]   alloc irq_desc for 17 on node 0
[    4.975740]   alloc kstat_irqs on node 0
[    4.975743] igb 0000:05:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ
17
[    4.975753] igb 0000:05:00.1: setting latency timer to 64
[    4.976819]   alloc irq_desc for 80 on node 0
[    4.976820]   alloc kstat_irqs on node 0
[    4.976822] igb 0000:05:00.1: irq 80 for MSI/MSI-X
[    4.976823]   alloc irq_desc for 81 on node 0
[    4.976824]   alloc kstat_irqs on node 0
[    4.976826] igb 0000:05:00.1: irq 81 for MSI/MSI-X
[    4.976827]   alloc irq_desc for 82 on node 0
[    4.976828]   alloc kstat_irqs on node 0
[    4.976829] igb 0000:05:00.1: irq 82 for MSI/MSI-X
[    4.976830]   alloc irq_desc for 83 on node 0
[    4.976831]   alloc kstat_irqs on node 0
[    4.976833] igb 0000:05:00.1: irq 83 for MSI/MSI-X
[    4.976834]   alloc irq_desc for 84 on node 0
[    4.976834]   alloc kstat_irqs on node 0
[    4.976836] igb 0000:05:00.1: irq 84 for MSI/MSI-X
[    4.976837]   alloc irq_desc for 85 on node 0
[    4.976838]   alloc kstat_irqs on node 0
[    4.976839] igb 0000:05:00.1: irq 85 for MSI/MSI-X
[    4.976840]   alloc irq_desc for 86 on node 0
[    4.976841]   alloc kstat_irqs on node 0
[    4.976843] igb 0000:05:00.1: irq 86 for MSI/MSI-X
[    4.976844]   alloc irq_desc for 87 on node 0
[    4.976844]   alloc kstat_irqs on node 0
[    4.976846] igb 0000:05:00.1: irq 87 for MSI/MSI-X
[    4.976847]   alloc irq_desc for 88 on node 0
[    4.976848]   alloc kstat_irqs on node 0
[    4.976849] igb 0000:05:00.1: irq 88 for MSI/MSI-X
[    4.976898] igb 0000:05:00.1: 0 vfs allocated
[    5.084624] usb 2-2: new high speed USB device using ehci_hcd and
address 2
[    5.174568] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.174783] ata1.00: ATA-8: STT_FTM64GX25H, 2030, max UDMA/133
[    5.174787] ata1.00: 125045424 sectors, multi 1: LBA48 NCQ (depth
31/32), AA
[    5.176287] ata1.00: configured for UDMA/133
[    5.194716] scsi 0:0:0:0: Direct-Access     ATA      STT_FTM64GX25H
2030 PQ: 0 ANSI: 5
[    5.194883] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.194981] sd 0:0:0:0: [sda] 125045424 512-byte logical blocks:
(64.0 GB/59.6 GiB)
[    5.195034] sd 0:0:0:0: [sda] Write Protect is off
[    5.195037] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    5.195057] sd 0:0:0:0: [sda] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    5.195155]  sda: sda1 sda2 < sda5 >
[    5.196627] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.239143] hub 2-2:1.0: USB hub found
[    5.239463] hub 2-2:1.0: 4 ports detected
[    5.514360] usb 4-1: new full speed USB device using uhci_hcd and
address 2
[    5.514877] igb 0000:06:00.0: Intel(R) Gigabit Ethernet Network
Connection
[    5.514879] igb 0000:06:00.0: eth2: (PCIe:2.5Gb/s:Width x2)
00:25:90:20:f8:0c
[    5.514952] igb 0000:06:00.0: eth2: PBA No: ffffff-0ff
[    5.514954] igb 0000:06:00.0: Using MSI-X interrupts. 8 rx queue(s),
8 tx queue(s)
[    5.515394] igb 0000:06:00.1: power state changed by ACPI to D0
[    5.515485] igb 0000:06:00.1: power state changed by ACPI to D0
[    5.515491] igb 0000:06:00.1: PCI INT B -> GSI 17 (level, low) -> IRQ
17
[    5.515502] igb 0000:06:00.1: setting latency timer to 64
[    5.515786]   alloc irq_desc for 98 on node 0
[    5.515786]   alloc kstat_irqs on node 0
[    5.754537] usb 2-2.1: new low speed USB device using ehci_hcd and
address 3
[    5.759592] usbcore: registered new interface driver hiddev
[    5.762809] input: Winbond Electronics Corp Hermon USB hidmouse
Device as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.0/input/input2
[    5.762878] generic-usb 0003:0557:2221.0001: input,hidraw0: USB HID
v1.00 Mouse [Winbond Electronics Corp Hermon USB hidmouse Device] on
usb-0000:00:1a.1-1/input0
[    5.764812] input: Winbond Electronics Corp Hermon USB hidmouse
Device as /devices/pci0000:00/0000:00:1a.1/usb4/4-1/4-1:1.1/input/input3
[    5.764860] generic-usb 0003:0557:2221.0002: input,hidraw1: USB HID
v1.00 Keyboard [Winbond Electronics Corp Hermon USB hidmouse Device] on
usb-0000:00:1a.1-1/input1
[    5.764871] usbcore: registered new interface driver usbhid
[    5.764873] usbhid: USB HID core driver
[    5.814712] igb 0000:06:00.1: Intel(R) Gigabit Ethernet Network
Connection
[    5.814714] igb 0000:06:00.1: eth3: (PCIe:2.5Gb/s:Width x2)
00:25:90:20:f8:0d
[    5.814788] igb 0000:06:00.1: eth3: PBA No: ffffff-0ff
[    5.814789] igb 0000:06:00.1: Using MSI-X interrupts. 8 rx queue(s),
8 tx queue(s)
[    5.882459] input: NOVATEK USB Keyboard as
/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.1/2-2.1:1.0/input/input4
[    5.882520] generic-usb 0003:0603:00F1.0003: input,hidraw2: USB HID
v1.10 Keyboard [NOVATEK USB Keyboard] on usb-0000:00:1d.7-2.1/input0
[    5.888998] input: NOVATEK USB Keyboard as
/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.1/2-2.1:1.1/input/input5
[    5.889125] generic-usb 0003:0603:00F1.0004: input,hiddev96,hidraw3:
USB HID v1.10 Mouse [NOVATEK USB Keyboard] on
usb-0000:00:1d.7-2.1/input1
[    5.944103] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.946449] ata2.00: ATA-8: WDC WD7500BPKT-00PK4T0, 01.01A01, max
UDMA/133
[    5.946453] ata2.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth
31/32), AA
[    5.949444] ata2.00: configured for UDMA/133
[    5.974219] scsi 1:0:0:0: Direct-Access     ATA      WDC WD7500BPKT-0
01.0 PQ: 0 ANSI: 5
[    5.974338] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    5.974382] usb 2-2.2: new low speed USB device using ehci_hcd and
address 4
[    5.974392] sd 1:0:0:0: [sdb] 1465149168 512-byte logical blocks:
(750 GB/698 GiB)
[    5.974393] sd 1:0:0:0: [sdb] 4096-byte physical blocks
[    5.974418] sd 1:0:0:0: [sdb] Write Protect is off
[    5.974420] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.974430] sd 1:0:0:0: [sdb] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    5.974529]  sdb: unknown partition table
[    6.024060] sd 1:0:0:0: [sdb] Attached SCSI disk
[    6.102176] input: Dynex 5-Button Wired Optical Mouse as
/devices/pci0000:00/0000:00:1d.7/usb2/2-2/2-2.2/2-2.2:1.0/input/input6
[    6.102219] generic-usb 0003:0461:4D42.0005: input,hidraw4: USB HID
v1.11 Mouse [Dynex 5-Button Wired Optical Mouse] on
usb-0000:00:1d.7-2.2/input0
[    6.723635] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    6.726039] ata3.00: ATA-8: WDC WD7500BPKT-00PK4T0, 01.01A01, max
UDMA/133
[    6.726043] ata3.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth
31/32), AA
[    6.729506] ata3.00: configured for UDMA/133
[    6.743783] scsi 2:0:0:0: Direct-Access     ATA      WDC WD7500BPKT-0
01.0 PQ: 0 ANSI: 5
[    6.743892] sd 2:0:0:0: Attached scsi generic sg2 type 0
[    6.743928] sd 2:0:0:0: [sdc] 1465149168 512-byte logical blocks:
(750 GB/698 GiB)
[    6.743935] sd 2:0:0:0: [sdc] 4096-byte physical blocks
[    6.744024] sd 2:0:0:0: [sdc] Write Protect is off
[    6.744028] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    6.744070] sd 2:0:0:0: [sdc] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    6.744308]  sdc: unknown partition table
[    6.792408] sd 2:0:0:0: [sdc] Attached SCSI disk
[    7.493169] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    7.495560] ata4.00: ATA-8: WDC WD7500BPKT-00PK4T0, 01.01A01, max
UDMA/133
[    7.495565] ata4.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth
31/32), AA
[    7.499027] ata4.00: configured for UDMA/133
[    7.513296] scsi 3:0:0:0: Direct-Access     ATA      WDC WD7500BPKT-0
01.0 PQ: 0 ANSI: 5
[    7.513413] sd 3:0:0:0: [sdd] 1465149168 512-byte logical blocks:
(750 GB/698 GiB)
[    7.513415] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    7.513428] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    7.513465] sd 3:0:0:0: [sdd] Write Protect is off
[    7.513467] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    7.513491] sd 3:0:0:0: [sdd] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    7.513667]  sdd: unknown partition table
[    7.566317] sd 3:0:0:0: [sdd] Attached SCSI disk
[    8.262708] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    8.265144] ata5.00: ATA-8: WDC WD7500BPKT-00PK4T0, 01.01A01, max
UDMA/133
[    8.265149] ata5.00: 1465149168 sectors, multi 0: LBA48 NCQ (depth
31/32), AA
[    8.267791] ata5.00: configured for UDMA/133
[    8.282794] scsi 4:0:0:0: Direct-Access     ATA      WDC WD7500BPKT-0
01.0 PQ: 0 ANSI: 5
[    8.282923] sd 4:0:0:0: [sde] 1465149168 512-byte logical blocks:
(750 GB/698 GiB)
[    8.282925] sd 4:0:0:0: [sde] 4096-byte physical blocks
[    8.282951] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    8.282965] sd 4:0:0:0: [sde] Write Protect is off
[    8.282967] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    8.282985] sd 4:0:0:0: [sde] Write cache: enabled, read cache:
enabled, doesn't support DPO or FUA
[    8.283112]  sde: unknown partition table
[    8.331755] sd 4:0:0:0: [sde] Attached SCSI disk
[    8.632483] ata6: SATA link down (SStatus 0 SControl 300)
[    8.676751] EXT4-fs (sda1): INFO: recovery required on readonly
filesystem
[    8.676753] EXT4-fs (sda1): write access will be enabled during
recovery
[    8.768299] EXT4-fs (sda1): recovery complete
[    8.768405] EXT4-fs (sda1): mounted filesystem with ordered data
mode. Opts: (null)
[    9.128843] udev[683]: starting version 163
[    9.136536] Adding 2595836k swap on /dev/sda5.  Priority:-1 extents:1
across:2595836k SS
[    9.203616] lp: driver loaded but no devices found
[    9.204827] EDAC MC: Ver: 2.1.0 Mar 18 2011
[    9.205902] PCI: Discovered peer bus ff
[    9.206746] PCI: Discovered peer bus fe
[    9.210084] EDAC MC0: Giving out device to 'i7core_edac.c' 'i7 core
#0': DEV 0000:ff:03.0
[    9.210377] EDAC PCI0: Giving out device to module 'i7core_edac'
controller 'EDAC PCI controller': DEV '0000:ff:03.0' (POLLED)
[    9.211870] EDAC MC1: Giving out device to 'i7core_edac.c' 'i7 core
#1': DEV 0000:fe:03.0
[    9.211900] EDAC PCI1: Giving out device to module 'i7core_edac'
controller 'EDAC PCI controller': DEV '0000:fe:03.0' (POLLED)
[    9.211903] EDAC i7core: Driver loaded.
[    9.216415] ioatdma: Intel(R) QuickData Technology Driver 4.00
[    9.217182]   alloc irq_desc for 43 on node 0
[    9.217184]   alloc kstat_irqs on node 0
[    9.217192] ioatdma 0000:00:16.0: PCI INT A -> GSI 43 (level, low) ->
IRQ 43
[    9.217245] ioatdma 0000:00:16.0: setting latency timer to 64
[    9.217344]   alloc irq_desc for 107 on node 0
[    9.217346]   alloc kstat_irqs on node 0
[    9.217351] ioatdma 0000:00:16.0: irq 107 for MSI/MSI-X
[    9.217760] igb 0000:05:00.0: DCA enabled
[    9.217801] igb 0000:05:00.1: DCA enabled
[    9.217866]   alloc irq_desc for 44 on node 0
[    9.217867]   alloc kstat_irqs on node 0
[    9.217872] ioatdma 0000:00:16.1: PCI INT B -> GSI 44 (level, low) ->
IRQ 44
[    9.217888] ioatdma 0000:00:16.1: setting latency timer to 64
[    9.217952]   alloc irq_desc for 108 on node 0
[    9.217953]   alloc kstat_irqs on node 0
[    9.217957] ioatdma 0000:00:16.1: irq 108 for MSI/MSI-X
[    9.218739] igb 0000:06:00.0: DCA enabled
[    9.219113] igb 0000:06:00.1: DCA enabled
[    9.219199]   alloc irq_desc for 45 on node 0
[    9.219201]   alloc kstat_irqs on node 0
[    9.219206] ioatdma 0000:00:16.2: PCI INT C -> GSI 45 (level, low) ->
IRQ 45
[    9.219223] ioatdma 0000:00:16.2: setting latency timer to 64
[    9.219302]   alloc irq_desc for 109 on node 0
[    9.219304]   alloc kstat_irqs on node 0
[    9.219308] ioatdma 0000:00:16.2: irq 109 for MSI/MSI-X
[    9.220094]   alloc irq_desc for 46 on node 0
[    9.220095]   alloc kstat_irqs on node 0
[    9.220101] ioatdma 0000:00:16.3: PCI INT D -> GSI 46 (level, low) ->
IRQ 46
[    9.220115] ioatdma 0000:00:16.3: setting latency timer to 64
[    9.220161]   alloc irq_desc for 110 on node 0
[    9.220161]   alloc kstat_irqs on node 0
[    9.220165] ioatdma 0000:00:16.3: irq 110 for MSI/MSI-X
[    9.220960] ioatdma 0000:00:16.4: PCI INT A -> GSI 43 (level, low) ->
IRQ 43
[    9.220979] ioatdma 0000:00:16.4: setting latency timer to 64
[    9.221058]   alloc irq_desc for 111 on node 0
[    9.221060]   alloc kstat_irqs on node 0
[    9.221065] ioatdma 0000:00:16.4: irq 111 for MSI/MSI-X
[    9.222460] ioatdma 0000:00:16.5: PCI INT B -> GSI 44 (level, low) ->
IRQ 44
[    9.222479] ioatdma 0000:00:16.5: setting latency timer to 64
[    9.222551]   alloc irq_desc for 112 on node 0
[    9.222553]   alloc kstat_irqs on node 0
[    9.222558] ioatdma 0000:00:16.5: irq 112 for MSI/MSI-X
[    9.223254] ioatdma 0000:00:16.6: PCI INT C -> GSI 45 (level, low) ->
IRQ 45
[    9.223270] ioatdma 0000:00:16.6: setting latency timer to 64
[    9.223318]   alloc irq_desc for 113 on node 0
[    9.223319]   alloc kstat_irqs on node 0
[    9.223323] ioatdma 0000:00:16.6: irq 113 for MSI/MSI-X
[    9.223959] ioatdma 0000:00:16.7: PCI INT D -> GSI 46 (level, low) ->
IRQ 46
[    9.223976] ioatdma 0000:00:16.7: setting latency timer to 64
[    9.224117]   alloc irq_desc for 114 on node 0
[    9.224119]   alloc kstat_irqs on node 0
[    9.224123] ioatdma 0000:00:16.7: irq 114 for MSI/MSI-X
[    9.300974] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[    9.332216] type=1400 audit(1308598407.139:2): apparmor="STATUS"
operation="profile_load" name="/sbin/dhclient3" pid=1054
comm="apparmor_parser"
[    9.332329] type=1400 audit(1308598407.139:3): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient3" pid=1051
comm="apparmor_parser"
[    9.332346] type=1400 audit(1308598407.139:4): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient3" pid=1050
comm="apparmor_parser"
[    9.332353] type=1400 audit(1308598407.139:5): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient3" pid=1068
comm="apparmor_parser"
[    9.332360] type=1400 audit(1308598407.139:6): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient3" pid=1023
comm="apparmor_parser"
[    9.332536] type=1400 audit(1308598407.139:7): apparmor="STATUS"
operation="profile_load"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1054
comm="apparmor_parser"
[    9.332702] type=1400 audit(1308598407.139:8): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1051
comm="apparmor_parser"
[    9.332710] type=1400 audit(1308598407.139:9): apparmor="STATUS"
operation="profile_load" name="/usr/lib/connman/scripts/dhclient-script"
pid=1054 comm="apparmor_parser"
[    9.332721] type=1400 audit(1308598407.139:10): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1050
comm="apparmor_parser"
[    9.420963] ADDRCONF(NETDEV_UP): eth0: link is not ready
[    9.551574]   alloc irq_desc for 30 on node 0
[    9.551576]   alloc kstat_irqs on node 0
[    9.551591] vgaarb: device changed decodes:
PCI:0000:04:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[   12.310754] igb: eth0 NIC Link is Up 100 Mbps Full Duplex, Flow
Control: RX/TX
[   12.311707] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   13.110407] RPC: Registered udp transport module.
[   13.110408] RPC: Registered tcp transport module.
[   13.110409] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   13.110756] audit_printk_skb: 18 callbacks suppressed
[   13.110758] type=1400 audit(1308598410.929:17): apparmor="STATUS"
operation="profile_load" name="/usr/lib/cups/backend/cups-pdf" pid=1438
comm="apparmor_parser"
[   13.111153] type=1400 audit(1308598410.929:18): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/cupsd" pid=1438
comm="apparmor_parser"
[   13.112977] type=1400 audit(1308598410.929:19): apparmor="STATUS"
operation="profile_replace" name="/sbin/dhclient3" pid=1480
comm="apparmor_parser"
[   13.112985] type=1400 audit(1308598410.929:20): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/mysqld" pid=1484
comm="apparmor_parser"
[   13.112992] type=1400 audit(1308598410.929:21): apparmor="STATUS"
operation="profile_load" name="/usr/sbin/tcpdump" pid=1485
comm="apparmor_parser"
[   13.113298] type=1400 audit(1308598410.929:22): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/NetworkManager/nm-dhcp-client.action" pid=1480
comm="apparmor_parser"
[   13.113364] type=1400 audit(1308598410.929:23): apparmor="STATUS"
operation="profile_replace" name="/usr/lib/cups/backend/cups-pdf"
pid=1483 comm="apparmor_parser"
[   13.113475] type=1400 audit(1308598410.929:24): apparmor="STATUS"
operation="profile_replace"
name="/usr/lib/connman/scripts/dhclient-script" pid=1480
comm="apparmor_parser"
[   13.113762] type=1400 audit(1308598410.929:25): apparmor="STATUS"
operation="profile_replace" name="/usr/sbin/cupsd" pid=1483
comm="apparmor_parser"
[   13.113874] type=1400 audit(1308598410.929:26): apparmor="STATUS"
operation="profile_load" name="/usr/share/gdm/guest-session/Xsession"
pid=1478 comm="apparmor_parser"
[   13.120169] Slow work thread pool: Starting up
[   13.120230] Slow work thread pool: Ready
[   13.120285] FS-Cache: Loaded
[   13.120897] ppdev: user-space parallel port driver
[   13.133172] FS-Cache: Netfs 'nfs' registered for caching
[   13.142353] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   13.148906] evadd.c: Initializing Evertz PCI device driver
[   13.148907] evadd.c: Debugging mode disabled
[   13.213539] evadd.c: predef_cfg=0
[   13.213540] evadd.c: probing ALTERA_EVS board at pci slot
0000:02:00.0
[   13.213553]   alloc irq_desc for 24 on node 0
[   13.213554]   alloc kstat_irqs on node 0
[   13.213560] evadd 0000:02:00.0: PCI INT A -> GSI 24 (level, low) ->
IRQ 24
[   13.213592] evadd.c: Probe: initializing device ALTERA_EVS
[   13.213594] evadd.c: init_cfgparams(): dma_mode=1, channel_total=8
[   13.213595] evadd.c: sum size=03607800
[   13.213596] evadd.c: rounded sum=03700000
[   13.213597] evadd.c: sum=03700000
[   13.215012] ADDRCONF(NETDEV_UP): eth1: link is not ready
[   13.303265] evadd.c: evadd_init_board_parameters(): irq_mask=f
[   13.388746] ADDRCONF(NETDEV_UP): eth3: link is not ready
[   15.197464] EXT4-fs (sda1): re-mounted. Opts:
errors=remount-ro,commit=0
[   16.616804] EXT4-fs (sda1): re-mounted. Opts:
errors=remount-ro,commit=0
[   19.678837] evadd.c: evadd_open(): pboard=0xffff880135f00000,
major=250, minor=0, name=evadd0 opencnt=0
[   19.678841] evadd.c: evadd_init_board_parameters(): irq_mask=f
[   22.693961] eth0: no IPv6 routers present
[  122.916504] md: md127 stopped.
[  122.922075] md: bind<sdd>
[  122.922112] md: bind<sdc>
[  122.922146] md: bind<sdb>
[  122.922186] md: bind<sde>
[  123.139878] md: md126 stopped.
[  123.140081] md: bind<sde>
[  123.140258] md: bind<sdd>
[  123.140419] md: bind<sdc>
[  123.140590] md: bind<sdb>
[  123.142612] md126: detected capacity change from 0 to 1500307783680
[  123.142621]  md126:
[  123.142629] quiet_error: 12 callbacks suppressed
[  123.142632] Buffer I/O error on device md126, logical block 0
[  123.142636] Buffer I/O error on device md126, logical block 0
[  123.142642] Buffer I/O error on device md126, logical block 0
[  123.142646] Buffer I/O error on device md126, logical block 0
[  123.142649] Buffer I/O error on device md126, logical block 0
[  123.142653] ldm_validate_partition_table(): Disk read failed.
[  123.142656] Buffer I/O error on device md126, logical block 0
[  123.142660] Buffer I/O error on device md126, logical block 0
[  123.142663] Buffer I/O error on device md126, logical block 0
[  123.142667] Buffer I/O error on device md126, logical block 0
[  123.142670] Dev md126: unable to read RDB block 0
[  123.142673] Buffer I/O error on device md126, logical block 0
[  123.142683]  unable to read partition table
[  123.147023] md: raid10 personality registered for level 10
[  123.151082] md/raid10:md126: active with 4 out of 4 devices
[  123.173323] md: md126 switched to read-write mode.

-----Original Message-----
From: Phil Turmel [mailto:philip@turmel.org] 
Sent: Monday, June 20, 2011 3:15 PM
To: Sandra Escandor
Cc: linux-raid@vger.kernel.org
Subject: Re: Issues with auto assembling or RAID10 (imsm) on boot

Hi Sandra,

On 06/20/2011 03:02 PM, Sandra Escandor wrote:

[...]

> in order for the RAID to initialize. I read that you are supposed to
run
> that update-initramfs command if you change your mdadm.conf, but it
> appears that it didn't really do anything. What am I missing?

You appear to be doing the right things as a far as mdadm is concerned.
The difference is initramfs vs. full root fs.  That suggests that some
kernel module or other piece of the imsm infrastructure isn't getting
installed in your initramfs.

Can you share your complete dmesg?  (at least up through the point where
you manually assembly after boot)

Phil

From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: How to stress test an RAID 6 array?
Date: Mon, 03 Oct 2011 17:40:58 +0200
Message-ID: <4E89D78A.3090508@yazzy.org>
References: <4E89B81D.5000800@yazzy.org> <4E89C580.8050603@gmail.com>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090408050409040807000805"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E89C580.8050603@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------090408050409040807000805
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/3/11 4:24 PM, Joe Landman wrote:
> On 10/03/2011 09:26 AM, Marcin M. Jessa wrote:
>
>> The load seemed to have stressed my array/the HDs to the point when 3 of
>> the drives were kicked off the array resulting in loss of data.
>
> Hmmm .... this sounds like hardware failure.

Possibly. According to the logs it happened with a couple of hours gap 
between the failures. It's really hard to pin point which part is to 
blame without installing a different O.S and see if I would trigger the 
same behavior.


>> It's hard to find a cause of it - some forum threads on the Interner
>> suggest it may be the kernel, some say it could be the SATA controller,
>> the SATA cables and most of them suggest it's because of the hard drives.
>
> What SATA controller? If its a Marvell, you have your answer.

AMD's SB850 with Native 6Gbps SATA

>What CPU,

AMD Athlon II X2 250

> etc. , how much ram,

16G (4x4G) DIMM DDR3 1333MHZ CL9

>what motherboard,
The motherboard: http://www.msi.com/product/mb/870A-G54.html

>bios revs, etc. ?
Version	17.D
Release Date	2011-06-29

>Is this a motherboard SATA,  or a PCI card SATA?

Built in 6x SATA3

> Could you send dmidecode output,
> and possibly dmesg output (or post them on pastebin)?
Both attached.


> Assume that you have one (or more) possibly broken (irreparably so)
> hardware devices in your path that "high" loads tickle in just the right
> manner ... substandard or broken hardware will in fact behave exactly
> the way you describe.
>
> Note: could be IRQ routing, or PCI silliness, or other joyous things
> (we've run into many such problems). But as often as not, this is a
> symptom of one hardware element that is beyond hope.
>
>>
>> Now I would like to stress test the array and see whether it would fail
>> again or not. What would be the best way to do that?
>
> We built a simple looping checkout code atop fio
> (http://git.kernel.dk/?p=fio.git;a=summary if you are not using fio, you
> should be, Jens Axboe has done an absolutely wonderful job with it).
>
> Our perl driver and input deck are here:
>
> http://download.scalableinformatics.com/disk_stress_tests/fio/
>
> To use them, pull both down, make the loop_check.pl executable, and make
> sure fio is in your path. Edit the sw_check.fio to change the
> directory=/data to point to your raid mount point (assuming its mounted
> with a file system atop it). Run it like this
>
> nohup ./loop_check.pl 10 > out 2>&1 &
>
> which will execute the fio against sw_check.fio 10 times. Each
> sw_check.fio run will write and check 512GB of data (4 jobs, each
> writing and checking 128 GB data). Go ahead and change that if you want.
> We use a test just like this in our system checkout pipeline.
>
> This *will* stress all aspects of your units very hard. If you have an
> error in your paths, you will see crc errors in the output. If you have
> a marginal RAID system, this will probably kill it. Which is good, as
> you'd much rather it die on a hard test like this than in production.
>
> You can ramp up the intensity by increasing the number of jobs, or the
> size of the io, etc. We can (and do) crash machines with horrific loads
> generated from similar tests, just to see where the limits of the
> machines are at, and to help us tweak/tune our kernels for best
> stability under these horrific loads. The base test is used to convince
> us that the RAID is stable though.

Thanks a lot. I will definitely give it a shot.


-- 

Marcin M. Jessa

--------------090408050409040807000805
Content-Type: text/plain; x-mac-type="0"; x-mac-creator="0";
 name="dmesg"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmesg"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 3.0.0-1-amd64 (Debian 3.0.0-3) (ben@decadent.org.uk) (gcc version 4.5.3 (Debian 4.5.3-8) ) #1 SMP Sat Aug 27 16:21:11 UTC 2011
[    0.000000] Command line: BOOT_IMAGE=/vmlinuz-3.0.0-1-amd64 root=/dev/md1p4 ro quiet elevator=noop
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 0000000000093800 (usable)
[    0.000000]  BIOS-e820: 0000000000093800 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e1000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000cff90000 (usable)
[    0.000000]  BIOS-e820: 00000000cff90000 - 00000000cff9e000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000cff9e000 - 00000000cffe0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000cffe0000 - 00000000d0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000000430000000 (usable)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI present.
[    0.000000] DMI: MSI MS-7599/870A-G54 (MS-7599), BIOS V17.13 06/29/2011
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000 (usable) ==> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn = 0x430000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-EFFFF uncachable
[    0.000000]   F0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000000 mask FFFF80000000 write-back
[    0.000000]   1 base 000080000000 mask FFFFC0000000 write-back
[    0.000000]   2 base 0000C0000000 mask FFFFF0000000 write-back
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] TOM2: 0000000430000000 aka 17152M
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820 update range: 00000000d0000000 - 0000000100000000 (usable) ==> (reserved)
[    0.000000] last_pfn = 0xcff90 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [ffff8800000ff780] ff780
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] Base memory trampoline at [ffff88000008e000] 8e000 size 20480
[    0.000000] Using GB pages for direct mapping
[    0.000000] init_memory_mapping: 0000000000000000-00000000cff90000
[    0.000000]  0000000000 - 00c0000000 page 1G
[    0.000000]  00c0000000 - 00cfe00000 page 2M
[    0.000000]  00cfe00000 - 00cff90000 page 4k
[    0.000000] kernel direct mapping tables up to cff90000 @ cff8d000-cff90000
[    0.000000] init_memory_mapping: 0000000100000000-0000000430000000
[    0.000000]  0100000000 - 0400000000 page 1G
[    0.000000]  0400000000 - 0430000000 page 2M
[    0.000000] kernel direct mapping tables up to 430000000 @ 42fffe000-430000000
[    0.000000] RAMDISK: 3698a000 - 374bd000
[    0.000000] ACPI: RSDP 00000000000f8c10 00014 (v00 ACPIAM)
[    0.000000] ACPI: RSDT 00000000cff90000 00038 (v01 7599MS A7599300 20110629 MSFT 00000097)
[    0.000000] ACPI: FACP 00000000cff90200 00084 (v01 7599MS A7599300 20110629 MSFT 00000097)
[    0.000000] ACPI: DSDT 00000000cff90660 05A15 (v01  A7599 A7599300 00000300 INTL 20051117)
[    0.000000] ACPI: FACS 00000000cff9e000 00040
[    0.000000] ACPI: APIC 00000000cff90390 0010C (v01 7599MS A7599300 20110629 MSFT 00000097)
[    0.000000] ACPI: MCFG 00000000cff904a0 0003C (v01 7599MS OEMMCFG  20110629 MSFT 00000097)
[    0.000000] ACPI: OEMB 00000000cff9e040 00072 (v01 7599MS A7599300 20110629 MSFT 00000097)
[    0.000000] ACPI: HPET 00000000cff9a660 00038 (v01 7599MS OEMHPET  20110629 MSFT 00000097)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] Scanning NUMA topology in Northbridge 24
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-0000000430000000
[    0.000000] Initmem setup node 0 0000000000000000-0000000430000000
[    0.000000]   NODE_DATA [000000042fff9000 - 000000042fffdfff]
[    0.000000]  [ffffea0000000000-ffffea000ebfffff] PMD -> [ffff88041f600000-ffff88042d7fffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   0x00100000 -> 0x00430000
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[3] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x00000093
[    0.000000]     0: 0x00000100 -> 0x000cff90
[    0.000000]     0: 0x00100000 -> 0x00430000
[    0.000000] On node 0 totalpages: 4194067
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 5 pages reserved
[    0.000000]   DMA zone: 3910 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 833480 pages, LIFO batch:31
[    0.000000]   Normal zone: 45696 pages used for memmap
[    0.000000]   Normal zone: 3296640 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x82] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x83] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x05] lapic_id[0x84] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x06] lapic_id[0x85] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x07] lapic_id[0x86] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x08] lapic_id[0x87] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x09] lapic_id[0x88] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0a] lapic_id[0x89] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0b] lapic_id[0x8a] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0c] lapic_id[0x8b] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0d] lapic_id[0x8c] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0e] lapic_id[0x8d] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x0f] lapic_id[0x8e] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x10] lapic_id[0x8f] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x11] lapic_id[0x90] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x12] lapic_id[0x91] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x13] lapic_id[0x92] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x14] lapic_id[0x93] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x15] lapic_id[0x94] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x16] lapic_id[0x95] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x17] lapic_id[0x96] disabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x18] lapic_id[0x97] disabled)
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, version 33, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 low level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8300 base: 0xfed00000
[    0.000000] SMP: Allowing 24 CPUs, 22 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 0000000000093000 - 0000000000094000
[    0.000000] PM: Registered nosave memory: 0000000000094000 - 00000000000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 00000000000e1000
[    0.000000] PM: Registered nosave memory: 00000000000e1000 - 0000000000100000
[    0.000000] PM: Registered nosave memory: 00000000cff90000 - 00000000cff9e000
[    0.000000] PM: Registered nosave memory: 00000000cff9e000 - 00000000cffe0000
[    0.000000] PM: Registered nosave memory: 00000000cffe0000 - 00000000d0000000
[    0.000000] PM: Registered nosave memory: 00000000d0000000 - 00000000fff00000
[    0.000000] PM: Registered nosave memory: 00000000fff00000 - 0000000100000000
[    0.000000] Allocating PCI resources starting at d0000000 (gap: d0000000:2ff00000)
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:24 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88042f200000 s78912 r8192 d23488 u131072
[    0.000000] pcpu-alloc: s78912 r8192 d23488 u131072 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 
[    0.000000] pcpu-alloc: [0] 16 17 18 19 20 21 22 23 -- -- -- -- -- -- -- -- 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4134030
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/vmlinuz-3.0.0-1-amd64 root=/dev/md1p4 ro quiet elevator=noop
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Node 0: aperture @ ffce000000 size 32 MB
[    0.000000] Aperture beyond 4GB. Ignoring.
[    0.000000] Your BIOS doesn't leave a aperture memory hole
[    0.000000] Please enable the IOMMU option in the BIOS setup
[    0.000000] This costs you 64 MB of RAM
[    0.000000] Mapping aperture over 65536 KB of RAM @ c4000000
[    0.000000] PM: Registered nosave memory: 00000000c4000000 - 00000000c8000000
[    0.000000] Memory: 16390732k/17563648k available (3325k kernel code, 787380k absent, 385536k reserved, 3370k data, 560k init)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] NR_IRQS:33024 nr_irqs:872 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 3405.486 MHz processor.
[    0.004006] Calibrating delay loop (skipped), value calculated using timer frequency.. 6810.97 BogoMIPS (lpj=13621944)
[    0.004010] pid_max: default: 32768 minimum: 301
[    0.004066] Security Framework initialized
[    0.004069] SELinux:  Disabled at boot.
[    0.005063] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.010794] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.012632] Mount-cache hash table entries: 256
[    0.012785] Initializing cgroup subsys cpuacct
[    0.012793] Initializing cgroup subsys memory
[    0.012807] Initializing cgroup subsys devices
[    0.012809] Initializing cgroup subsys freezer
[    0.012811] Initializing cgroup subsys net_cls
[    0.012813] Initializing cgroup subsys blkio
[    0.012842] tseg: 0000000000
[    0.012859] CPU: Physical Processor ID: 0
[    0.012860] CPU: Processor Core ID: 0
[    0.012861] mce: CPU supports 6 MCE banks
[    0.013067] ACPI: Core revision 20110413
[    0.016056] Switched APIC routing to physical flat.
[    0.016324] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.057171] CPU0: AMD Athlon(tm) II X2 250 Processor stepping 03
[    0.060003] Performance Events: AMD PMU driver.
[    0.060003] ... version:                0
[    0.060003] ... bit width:              48
[    0.060003] ... generic registers:      4
[    0.060003] ... value mask:             0000ffffffffffff
[    0.060003] ... max period:             00007fffffffffff
[    0.060003] ... fixed-purpose events:   0
[    0.060003] ... event mask:             000000000000000f
[    0.060003] NMI watchdog enabled, takes one hw-pmu counter.
[    0.060003] Booting Node   0, Processors  #1
[    0.060003] smpboot cpu 1: start_ip = 8e000
[    0.148020] NMI watchdog enabled, takes one hw-pmu counter.
[    0.148036] Brought up 2 CPUs
[    0.148037] Total of 2 processors activated (13621.12 BogoMIPS).
[    0.148411] devtmpfs: initialized
[    0.153318] PM: Registering ACPI NVS region at cff9e000 (270336 bytes)
[    0.153318] print_constraints: dummy: 
[    0.153318] NET: Registered protocol family 16
[    0.153318] node 0 link 0: io port [1000, ffffff]
[    0.153318] TOM: 00000000d0000000 aka 3328M
[    0.153318] Fam 10h mmconf [e0000000, efffffff]
[    0.153318] node 0 link 0: mmio [e0000000, efffffff] ==> none
[    0.153318] node 0 link 0: mmio [f0000000, ffffffff]
[    0.153318] node 0 link 0: mmio [a0000, bffff]
[    0.153318] node 0 link 0: mmio [d0000000, dfffffff]
[    0.153318] TOM2: 0000000430000000 aka 17152M
[    0.153318] bus: [00, 1f] on node 0 link 0
[    0.153318] bus: 00 index 0 [io  0x0000-0xffff]
[    0.153318] bus: 00 index 1 [mem 0xf0000000-0xffffffff]
[    0.153318] bus: 00 index 2 [mem 0x000a0000-0x000bffff]
[    0.153318] bus: 00 index 3 [mem 0xd0000000-0xdfffffff]
[    0.153318] bus: 00 index 4 [mem 0x430000000-0xfcffffffff]
[    0.153318] Extended Config Space enabled on 1 nodes
[    0.153318] ACPI: bus type pci registered
[    0.153318] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.153318] PCI: not using MMCONFIG
[    0.153318] PCI: Using configuration type 1 for base access
[    0.153318] PCI: Using configuration type 1 for extended access
[    0.153318] bio: create slab <bio-0> at 0
[    0.153318] ACPI: EC: Look up EC in DSDT
[    0.153318] ACPI: Executed 3 blocks of module-level executable AML code
[    0.168252] ACPI: Interpreter enabled
[    0.168255] ACPI: (supports S0 S1 S4 S5)
[    0.168273] ACPI: Using IOAPIC for interrupt routing
[    0.168299] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 0xe0000000-0xefffffff] (base 0xe0000000)
[    0.168846] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in ACPI motherboard resources
[    0.189542] ACPI: No dock devices found.
[    0.189544] HEST: Table not found.
[    0.189547] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.189615] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.189749] pci_root PNP0A03:00: host bridge window [io  0x0000-0x0cf7]
[    0.189751] pci_root PNP0A03:00: host bridge window [io  0x0d00-0xffff]
[    0.189753] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    0.189754] pci_root PNP0A03:00: host bridge window [mem 0x000d0000-0x000dffff]
[    0.189756] pci_root PNP0A03:00: host bridge window [mem 0xd0000000-0xdfffffff]
[    0.189758] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfebfffff]
[    0.189769] pci 0000:00:00.0: [1002:5957] type 0 class 0x000600
[    0.189777] pci 0000:00:00.0: reg 1c: [mem 0xe0000000-0xffffffff 64bit]
[    0.189801] pci 0000:00:02.0: [1002:5978] type 1 class 0x000604
[    0.189820] pci 0000:00:02.0: PME# supported from D0 D3hot D3cold
[    0.189822] pci 0000:00:02.0: PME# disabled
[    0.189839] pci 0000:00:0a.0: [1002:597f] type 1 class 0x000604
[    0.189856] pci 0000:00:0a.0: PME# supported from D0 D3hot D3cold
[    0.189858] pci 0000:00:0a.0: PME# disabled
[    0.189881] pci 0000:00:11.0: [1002:4391] type 0 class 0x000106
[    0.189898] pci 0000:00:11.0: reg 10: [io  0x8000-0x8007]
[    0.189906] pci 0000:00:11.0: reg 14: [io  0x7000-0x7003]
[    0.189914] pci 0000:00:11.0: reg 18: [io  0x6000-0x6007]
[    0.189922] pci 0000:00:11.0: reg 1c: [io  0x5000-0x5003]
[    0.189930] pci 0000:00:11.0: reg 20: [io  0x3000-0x300f]
[    0.189938] pci 0000:00:11.0: reg 24: [mem 0xfe5ffc00-0xfe5fffff]
[    0.189983] pci 0000:00:12.0: [1002:4397] type 0 class 0x000c03
[    0.189994] pci 0000:00:12.0: reg 10: [mem 0xfe5fe000-0xfe5fefff]
[    0.190051] pci 0000:00:12.2: [1002:4396] type 0 class 0x000c03
[    0.190067] pci 0000:00:12.2: reg 10: [mem 0xfe5ff800-0xfe5ff8ff]
[    0.190123] pci 0000:00:12.2: supports D1 D2
[    0.190125] pci 0000:00:12.2: PME# supported from D0 D1 D2 D3hot
[    0.190128] pci 0000:00:12.2: PME# disabled
[    0.190145] pci 0000:00:13.0: [1002:4397] type 0 class 0x000c03
[    0.190156] pci 0000:00:13.0: reg 10: [mem 0xfe5fd000-0xfe5fdfff]
[    0.190213] pci 0000:00:13.2: [1002:4396] type 0 class 0x000c03
[    0.190228] pci 0000:00:13.2: reg 10: [mem 0xfe5ff400-0xfe5ff4ff]
[    0.190285] pci 0000:00:13.2: supports D1 D2
[    0.190286] pci 0000:00:13.2: PME# supported from D0 D1 D2 D3hot
[    0.190290] pci 0000:00:13.2: PME# disabled
[    0.190308] pci 0000:00:14.0: [1002:4385] type 0 class 0x000c05
[    0.190369] pci 0000:00:14.3: [1002:439d] type 0 class 0x000601
[    0.190430] pci 0000:00:14.4: [1002:4384] type 1 class 0x000604
[    0.190463] pci 0000:00:14.5: [1002:4399] type 0 class 0x000c03
[    0.190474] pci 0000:00:14.5: reg 10: [mem 0xfe5fc000-0xfe5fcfff]
[    0.190530] pci 0000:00:15.0: [1002:43a0] type 1 class 0x000604
[    0.190576] pci 0000:00:15.0: supports D1 D2
[    0.190596] pci 0000:00:15.1: [1002:43a1] type 1 class 0x000604
[    0.190641] pci 0000:00:15.1: supports D1 D2
[    0.190664] pci 0000:00:16.0: [1002:4397] type 0 class 0x000c03
[    0.190675] pci 0000:00:16.0: reg 10: [mem 0xfe5f7000-0xfe5f7fff]
[    0.190732] pci 0000:00:16.2: [1002:4396] type 0 class 0x000c03
[    0.190748] pci 0000:00:16.2: reg 10: [mem 0xfe5ff000-0xfe5ff0ff]
[    0.190804] pci 0000:00:16.2: supports D1 D2
[    0.190805] pci 0000:00:16.2: PME# supported from D0 D1 D2 D3hot
[    0.190809] pci 0000:00:16.2: PME# disabled
[    0.190824] pci 0000:00:18.0: [1022:1200] type 0 class 0x000600
[    0.190836] pci 0000:00:18.1: [1022:1201] type 0 class 0x000600
[    0.190846] pci 0000:00:18.2: [1022:1202] type 0 class 0x000600
[    0.190856] pci 0000:00:18.3: [1022:1203] type 0 class 0x000600
[    0.190867] pci 0000:00:18.4: [1022:1204] type 0 class 0x000600
[    0.190904] pci 0000:01:00.0: [1002:7183] type 0 class 0x000300
[    0.190914] pci 0000:01:00.0: reg 10: [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.190922] pci 0000:01:00.0: reg 18: [mem 0xfe6f0000-0xfe6fffff 64bit]
[    0.190928] pci 0000:01:00.0: reg 20: [io  0x9000-0x90ff]
[    0.190937] pci 0000:01:00.0: reg 30: [mem 0xfe6c0000-0xfe6dffff pref]
[    0.190950] pci 0000:01:00.0: supports D1 D2
[    0.190965] pci 0000:01:00.1: [1002:71a3] type 0 class 0x000380
[    0.190974] pci 0000:01:00.1: reg 10: [mem 0xfe6e0000-0xfe6effff 64bit]
[    0.191006] pci 0000:01:00.1: supports D1 D2
[    0.191016] pci 0000:01:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.191023] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.191025] pci 0000:00:02.0:   bridge window [io  0x9000-0x9fff]
[    0.191028] pci 0000:00:02.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.191031] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.191059] pci 0000:02:00.0: [1033:0194] type 0 class 0x000c03
[    0.191071] pci 0000:02:00.0: reg 10: [mem 0xfe7fe000-0xfe7fffff 64bit]
[    0.191120] pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
[    0.191123] pci 0000:02:00.0: PME# disabled
[    0.196035] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.196040] pci 0000:00:0a.0:   bridge window [io  0xf000-0x0000] (disabled)
[    0.196043] pci 0000:00:0a.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.196046] pci 0000:00:0a.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.196081] pci 0000:03:05.0: [1095:3114] type 0 class 0x000180
[    0.196100] pci 0000:03:05.0: reg 10: [io  0xb800-0xb807]
[    0.196110] pci 0000:03:05.0: reg 14: [io  0xb400-0xb403]
[    0.196120] pci 0000:03:05.0: reg 18: [io  0xb000-0xb007]
[    0.196130] pci 0000:03:05.0: reg 1c: [io  0xa800-0xa803]
[    0.196140] pci 0000:03:05.0: reg 20: [io  0xa400-0xa40f]
[    0.196151] pci 0000:03:05.0: reg 24: [mem 0xfe8fbc00-0xfe8fbfff]
[    0.196161] pci 0000:03:05.0: reg 30: [mem 0xfe800000-0xfe87ffff pref]
[    0.196183] pci 0000:03:05.0: supports D1 D2
[    0.196202] pci 0000:03:07.0: [100b:0022] type 0 class 0x000200
[    0.196221] pci 0000:03:07.0: reg 10: [io  0xa000-0xa0ff]
[    0.196231] pci 0000:03:07.0: reg 14: [mem 0xfe8fa000-0xfe8fafff]
[    0.196277] pci 0000:03:07.0: reg 30: [mem 0xfe8e0000-0xfe8effff pref]
[    0.196298] pci 0000:03:07.0: supports D1 D2
[    0.196299] pci 0000:03:07.0: PME# supported from D0 D1 D2 D3hot
[    0.196303] pci 0000:03:07.0: PME# disabled
[    0.196340] pci 0000:00:14.4: PCI bridge to [bus 03-03] (subtractive decode)
[    0.196344] pci 0000:00:14.4:   bridge window [io  0xa000-0xbfff]
[    0.196347] pci 0000:00:14.4:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.196351] pci 0000:00:14.4:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.196353] pci 0000:00:14.4:   bridge window [io  0x0000-0x0cf7] (subtractive decode)
[    0.196355] pci 0000:00:14.4:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.196357] pci 0000:00:14.4:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.196359] pci 0000:00:14.4:   bridge window [mem 0x000d0000-0x000dffff] (subtractive decode)
[    0.196361] pci 0000:00:14.4:   bridge window [mem 0xd0000000-0xdfffffff] (subtractive decode)
[    0.196363] pci 0000:00:14.4:   bridge window [mem 0xf0000000-0xfebfffff] (subtractive decode)
[    0.196419] pci 0000:04:00.0: [197b:2368] type 0 class 0x000101
[    0.196448] pci 0000:04:00.0: reg 10: [io  0xd800-0xd807]
[    0.196462] pci 0000:04:00.0: reg 14: [io  0xd400-0xd403]
[    0.196475] pci 0000:04:00.0: reg 18: [io  0xd000-0xd007]
[    0.196488] pci 0000:04:00.0: reg 1c: [io  0xc800-0xc803]
[    0.196501] pci 0000:04:00.0: reg 20: [io  0xc400-0xc40f]
[    0.196572] pci 0000:04:00.0: disabling ASPM on pre-1.1 PCIe device.  You can enable it with 'pcie_aspm=force'
[    0.196582] pci 0000:00:15.0: PCI bridge to [bus 04-04]
[    0.196586] pci 0000:00:15.0:   bridge window [io  0xc000-0xdfff]
[    0.196589] pci 0000:00:15.0:   bridge window [mem 0xfff00000-0x000fffff] (disabled)
[    0.196594] pci 0000:00:15.0:   bridge window [mem 0xfff00000-0x000fffff pref] (disabled)
[    0.196651] pci 0000:05:00.0: [10ec:8168] type 0 class 0x000200
[    0.196667] pci 0000:05:00.0: reg 10: [io  0xe800-0xe8ff]
[    0.196694] pci 0000:05:00.0: reg 18: [mem 0xfdfff000-0xfdffffff 64bit pref]
[    0.196711] pci 0000:05:00.0: reg 20: [mem 0xfdff8000-0xfdffbfff 64bit pref]
[    0.196723] pci 0000:05:00.0: reg 30: [mem 0xfe9e0000-0xfe9fffff pref]
[    0.196760] pci 0000:05:00.0: supports D1 D2
[    0.196761] pci 0000:05:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.196765] pci 0000:05:00.0: PME# disabled
[    0.204040] pci 0000:00:15.1: PCI bridge to [bus 05-05]
[    0.204047] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.204050] pci 0000:00:15.1:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.204055] pci 0000:00:15.1:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.204077] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.204302] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE2._PRT]
[    0.204338] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCEA._PRT]
[    0.204372] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[    0.204442] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE20._PRT]
[    0.204475] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PE21._PRT]
[    0.204506]  pci0000:00: Requesting ACPI _OSC control (0x1d)
[    0.204508]  pci0000:00: ACPI _OSC request failed (AE_NOT_FOUND), returned control mask: 0x1d
[    0.204510] ACPI _OSC control for PCIe not granted, disabling ASPM
[    0.209255] ACPI: PCI Interrupt Link [LNKA] (IRQs 4 7 10 *11 14 15)
[    0.209307] ACPI: PCI Interrupt Link [LNKB] (IRQs 4 *7 10 11 14 15)
[    0.209358] ACPI: PCI Interrupt Link [LNKC] (IRQs 4 7 *10 11 14 15)
[    0.209408] ACPI: PCI Interrupt Link [LNKD] (IRQs 4 7 10 *11 14 15)
[    0.209446] ACPI: PCI Interrupt Link [LNKE] (IRQs *4 7 10 11 14 15)
[    0.209475] ACPI: PCI Interrupt Link [LNKF] (IRQs 4 7 10 11 14 15) *0
[    0.209504] ACPI: PCI Interrupt Link [LNKG] (IRQs 4 7 *10 11 14 15)
[    0.209533] ACPI: PCI Interrupt Link [LNKH] (IRQs 4 7 10 11 14 15) *0
[    0.209614] vgaarb: device added: PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.209617] vgaarb: loaded
[    0.209618] vgaarb: bridge control possible 0000:01:00.0
[    0.209644] PCI: Using ACPI for IRQ routing
[    0.216678] PCI: pci_cache_line_size set to 64 bytes
[    0.216683] pci 0000:00:00.0: no compatible bridge window for [mem 0xe0000000-0xffffffff 64bit]
[    0.216756] reserve RAM buffer: 0000000000093800 - 000000000009ffff 
[    0.216757] reserve RAM buffer: 00000000cff90000 - 00000000cfffffff 
[    0.216843] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.216846] hpet0: 3 comparators, 32-bit 14.318180 MHz counter
[    0.218876] Switching to clocksource hpet
[    0.218878] Switched to NOHz mode on CPU #0
[    0.218895] Switched to NOHz mode on CPU #1
[    0.218895] pnp: PnP ACPI init
[    0.218895] ACPI: bus type pnp registered
[    0.218895] pnp 00:00: [bus 00-ff]
[    0.218895] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.218895] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.218895] pnp 00:00: [io  0x0d00-0xffff window]
[    0.218895] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.218895] pnp 00:00: [mem 0x000d0000-0x000dffff window]
[    0.218895] pnp 00:00: [mem 0xd0000000-0xdfffffff window]
[    0.218895] pnp 00:00: [mem 0xf0000000-0xfebfffff window]
[    0.218895] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (active)
[    0.218895] pnp 00:01: [dma 4]
[    0.218895] pnp 00:01: [io  0x0000-0x000f]
[    0.218895] pnp 00:01: [io  0x0081-0x0083]
[    0.218895] pnp 00:01: [io  0x0087]
[    0.218895] pnp 00:01: [io  0x0089-0x008b]
[    0.218895] pnp 00:01: [io  0x008f]
[    0.218895] pnp 00:01: [io  0x00c0-0x00df]
[    0.218895] pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
[    0.218895] pnp 00:02: [io  0x0070-0x0071]
[    0.218895] pnp 00:02: [irq 8]
[    0.218895] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.218895] pnp 00:03: [io  0x0061]
[    0.218895] pnp 00:03: Plug and Play ACPI device, IDs PNP0800 (active)
[    0.218895] pnp 00:04: [io  0x00f0-0x00ff]
[    0.218895] pnp 00:04: [irq 13]
[    0.218895] pnp 00:04: Plug and Play ACPI device, IDs PNP0c04 (active)
[    0.218895] pnp 00:05: [mem 0xfed00000-0xfed003ff]
[    0.218895] pnp 00:05: Plug and Play ACPI device, IDs PNP0103 (active)
[    0.218895] pnp 00:06: [mem 0xfec00000-0xfec00fff]
[    0.218895] pnp 00:06: [mem 0xfee00000-0xfee00fff]
[    0.218895] system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
[    0.218895] system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
[    0.218895] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.218895] pnp 00:07: [io  0x0010-0x001f]
[    0.218895] pnp 00:07: [io  0x0022-0x003f]
[    0.218895] pnp 00:07: [io  0x0062-0x0063]
[    0.218895] pnp 00:07: [io  0x0065-0x006f]
[    0.218895] pnp 00:07: [io  0x0072-0x007f]
[    0.218895] pnp 00:07: [io  0x0080]
[    0.218895] pnp 00:07: [io  0x0084-0x0086]
[    0.218895] pnp 00:07: [io  0x0088]
[    0.218895] pnp 00:07: [io  0x008c-0x008e]
[    0.218895] pnp 00:07: [io  0x0090-0x009f]
[    0.218895] pnp 00:07: [io  0x00a2-0x00bf]
[    0.218895] pnp 00:07: [io  0x00b1]
[    0.218895] pnp 00:07: [io  0x00e0-0x00ef]
[    0.218895] pnp 00:07: [io  0x04d0-0x04d1]
[    0.218895] pnp 00:07: [io  0x040b]
[    0.218895] pnp 00:07: [io  0x04d6]
[    0.218895] pnp 00:07: [io  0x0c00-0x0c01]
[    0.218895] pnp 00:07: [io  0x0c14]
[    0.218895] pnp 00:07: [io  0x0c50-0x0c51]
[    0.218895] pnp 00:07: [io  0x0c52]
[    0.218895] pnp 00:07: [io  0x0c6c]
[    0.218895] pnp 00:07: [io  0x0c6f]
[    0.218895] pnp 00:07: [io  0x0cd0-0x0cd1]
[    0.218895] pnp 00:07: [io  0x0cd2-0x0cd3]
[    0.218895] pnp 00:07: [io  0x0cd4-0x0cd5]
[    0.218895] pnp 00:07: [io  0x0cd6-0x0cd7]
[    0.218895] pnp 00:07: [io  0x0cd8-0x0cdf]
[    0.218895] pnp 00:07: [io  0x0800-0x089f]
[    0.218895] pnp 00:07: [io  0x0000-0xffffffffffffffff disabled]
[    0.218895] pnp 00:07: [io  0x0b00-0x0b1f]
[    0.218895] pnp 00:07: [io  0x0b20-0x0b3f]
[    0.218895] pnp 00:07: [io  0x0900-0x090f]
[    0.218895] pnp 00:07: [io  0x0910-0x091f]
[    0.218895] pnp 00:07: [io  0xfe00-0xfefe]
[    0.218895] pnp 00:07: [io  0x0060-0x005f disabled]
[    0.218895] pnp 00:07: [io  0x0064-0x0063 disabled]
[    0.218895] pnp 00:07: [mem 0xffb80000-0xffbfffff]
[    0.218895] pnp 00:07: [mem 0xfec10000-0xfec1001f]
[    0.218895] pnp 00:07: [mem 0xfed80000-0xfed80fff]
[    0.218895] pnp 00:07: [mem 0x00000000-0xffffffffffffffff disabled]
[    0.218895] system 00:07: [io  0x04d0-0x04d1] has been reserved
[    0.218895] system 00:07: [io  0x040b] has been reserved
[    0.218895] system 00:07: [io  0x04d6] has been reserved
[    0.218895] system 00:07: [io  0x0c00-0x0c01] has been reserved
[    0.218895] system 00:07: [io  0x0c14] has been reserved
[    0.218895] system 00:07: [io  0x0c50-0x0c51] has been reserved
[    0.218895] system 00:07: [io  0x0c52] has been reserved
[    0.218895] system 00:07: [io  0x0c6c] has been reserved
[    0.218895] system 00:07: [io  0x0c6f] has been reserved
[    0.218895] system 00:07: [io  0x0cd0-0x0cd1] has been reserved
[    0.218895] system 00:07: [io  0x0cd2-0x0cd3] has been reserved
[    0.218895] system 00:07: [io  0x0cd4-0x0cd5] has been reserved
[    0.218895] system 00:07: [io  0x0cd6-0x0cd7] has been reserved
[    0.218895] system 00:07: [io  0x0cd8-0x0cdf] has been reserved
[    0.218895] system 00:07: [io  0x0800-0x089f] has been reserved
[    0.218895] system 00:07: [io  0x0b00-0x0b1f] has been reserved
[    0.218895] system 00:07: [io  0x0b20-0x0b3f] has been reserved
[    0.218895] system 00:07: [io  0x0900-0x090f] has been reserved
[    0.218895] system 00:07: [io  0x0910-0x091f] has been reserved
[    0.218895] system 00:07: [io  0xfe00-0xfefe] has been reserved
[    0.218895] system 00:07: [mem 0xffb80000-0xffbfffff] has been reserved
[    0.218895] system 00:07: [mem 0xfec10000-0xfec1001f] has been reserved
[    0.218895] system 00:07: [mem 0xfed80000-0xfed80fff] has been reserved
[    0.218895] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.218895] pnp 00:08: [io  0x0060]
[    0.218895] pnp 00:08: [io  0x0064]
[    0.218895] pnp 00:08: [irq 1]
[    0.218895] pnp 00:08: Plug and Play ACPI device, IDs PNP0303 PNP030b (active)
[    0.218895] pnp 00:09: [io  0x0000-0xffffffffffffffff disabled]
[    0.218895] pnp 00:09: [io  0x0600-0x06df]
[    0.218895] pnp 00:09: [io  0x0ae0-0x0aef]
[    0.218895] system 00:09: [io  0x0600-0x06df] has been reserved
[    0.218895] system 00:09: [io  0x0ae0-0x0aef] has been reserved
[    0.218895] system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.218895] pnp 00:0a: [mem 0xe0000000-0xefffffff]
[    0.218895] system 00:0a: [mem 0xe0000000-0xefffffff] has been reserved
[    0.218895] system 00:0a: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.218895] pnp 00:0b: [mem 0x00000000-0x0009ffff]
[    0.218895] pnp 00:0b: [mem 0x000c0000-0x000cffff]
[    0.218895] pnp 00:0b: [mem 0x000e0000-0x000fffff]
[    0.218895] pnp 00:0b: [mem 0x00100000-0xcfffffff]
[    0.218895] pnp 00:0b: [mem 0xfec00000-0xffffffff]
[    0.218895] pnp 00:0b: disabling [mem 0x00000000-0x0009ffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.218895] pnp 00:0b: disabling [mem 0x000c0000-0x000cffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.218895] pnp 00:0b: disabling [mem 0x000e0000-0x000fffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.218895] pnp 00:0b: disabling [mem 0x00100000-0xcfffffff] because it overlaps 0000:00:00.0 BAR 3 [mem 0x00000000-0x1fffffff 64bit]
[    0.218895] system 00:0b: [mem 0xfec00000-0xffffffff] could not be reserved
[    0.218895] system 00:0b: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.218895] pnp: PnP ACPI: found 12 devices
[    0.218895] ACPI: ACPI bus type pnp unregistered
[    0.224441] PCI: max bus depth: 1 pci_try_num: 2
[    0.224463] pci 0000:00:02.0: PCI bridge to [bus 01-01]
[    0.224465] pci 0000:00:02.0:   bridge window [io  0x9000-0x9fff]
[    0.224467] pci 0000:00:02.0:   bridge window [mem 0xfe600000-0xfe6fffff]
[    0.224470] pci 0000:00:02.0:   bridge window [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.224473] pci 0000:00:0a.0: PCI bridge to [bus 02-02]
[    0.224474] pci 0000:00:0a.0:   bridge window [io  disabled]
[    0.224476] pci 0000:00:0a.0:   bridge window [mem 0xfe700000-0xfe7fffff]
[    0.224478] pci 0000:00:0a.0:   bridge window [mem pref disabled]
[    0.224481] pci 0000:00:14.4: PCI bridge to [bus 03-03]
[    0.224484] pci 0000:00:14.4:   bridge window [io  0xa000-0xbfff]
[    0.224488] pci 0000:00:14.4:   bridge window [mem 0xfe800000-0xfe8fffff]
[    0.224491] pci 0000:00:14.4:   bridge window [mem pref disabled]
[    0.224496] pci 0000:00:15.0: PCI bridge to [bus 04-04]
[    0.224499] pci 0000:00:15.0:   bridge window [io  0xc000-0xdfff]
[    0.224502] pci 0000:00:15.0:   bridge window [mem disabled]
[    0.224505] pci 0000:00:15.0:   bridge window [mem pref disabled]
[    0.224509] pci 0000:00:15.1: PCI bridge to [bus 05-05]
[    0.224512] pci 0000:00:15.1:   bridge window [io  0xe000-0xefff]
[    0.224516] pci 0000:00:15.1:   bridge window [mem 0xfe900000-0xfe9fffff]
[    0.224519] pci 0000:00:15.1:   bridge window [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.224534] pci 0000:00:02.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.224537] pci 0000:00:02.0: setting latency timer to 64
[    0.224541] pci 0000:00:0a.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.224543] pci 0000:00:0a.0: setting latency timer to 64
[    0.224558] pci 0000:00:15.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.224561] pci 0000:00:15.0: setting latency timer to 64
[    0.224566] pci 0000:00:15.1: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.224569] pci 0000:00:15.1: setting latency timer to 64
[    0.224571] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7]
[    0.224573] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff]
[    0.224575] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff]
[    0.224577] pci_bus 0000:00: resource 7 [mem 0x000d0000-0x000dffff]
[    0.224578] pci_bus 0000:00: resource 8 [mem 0xd0000000-0xdfffffff]
[    0.224580] pci_bus 0000:00: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.224582] pci_bus 0000:01: resource 0 [io  0x9000-0x9fff]
[    0.224584] pci_bus 0000:01: resource 1 [mem 0xfe600000-0xfe6fffff]
[    0.224585] pci_bus 0000:01: resource 2 [mem 0xd0000000-0xdfffffff 64bit pref]
[    0.224587] pci_bus 0000:02: resource 1 [mem 0xfe700000-0xfe7fffff]
[    0.224589] pci_bus 0000:03: resource 0 [io  0xa000-0xbfff]
[    0.224591] pci_bus 0000:03: resource 1 [mem 0xfe800000-0xfe8fffff]
[    0.224593] pci_bus 0000:03: resource 4 [io  0x0000-0x0cf7]
[    0.224594] pci_bus 0000:03: resource 5 [io  0x0d00-0xffff]
[    0.224596] pci_bus 0000:03: resource 6 [mem 0x000a0000-0x000bffff]
[    0.224598] pci_bus 0000:03: resource 7 [mem 0x000d0000-0x000dffff]
[    0.224599] pci_bus 0000:03: resource 8 [mem 0xd0000000-0xdfffffff]
[    0.224601] pci_bus 0000:03: resource 9 [mem 0xf0000000-0xfebfffff]
[    0.224603] pci_bus 0000:04: resource 0 [io  0xc000-0xdfff]
[    0.224605] pci_bus 0000:05: resource 0 [io  0xe000-0xefff]
[    0.224606] pci_bus 0000:05: resource 1 [mem 0xfe900000-0xfe9fffff]
[    0.224608] pci_bus 0000:05: resource 2 [mem 0xfdf00000-0xfdffffff 64bit pref]
[    0.224674] NET: Registered protocol family 2
[    0.225004] IP route cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.226528] TCP established hash table entries: 524288 (order: 11, 8388608 bytes)
[    0.228447] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.228682] TCP: Hash tables configured (established 524288 bind 65536)
[    0.228684] TCP reno registered
[    0.228703] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.228793] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.229083] NET: Registered protocol family 1
[    0.344098] pci 0000:01:00.0: Boot video device
[    0.344130] PCI: CLS 64 bytes, default 64
[    0.344165] Unpacking initramfs...
[    0.523879] Freeing initrd memory: 11468k freed
[    0.527522] PCI-DMA: Disabling AGP.
[    0.527599] PCI-DMA: aperture base @ c4000000 size 65536 KB
[    0.527600] PCI-DMA: using GART IOMMU.
[    0.527603] PCI-DMA: Reserving 64MB of IOMMU area in the AGP aperture
[    0.530255] audit: initializing netlink socket (disabled)
[    0.530264] type=2000 audit(1317485788.524:1): initialized
[    0.566401] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.619749] VFS: Disk quotas dquot_6.5.2
[    0.619802] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.619878] msgmni has been set to 32164
[    0.620076] alg: No test for stdrng (krng)
[    0.620106] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.620109] io scheduler noop registered (default)
[    0.620110] io scheduler deadline registered
[    0.620125] io scheduler cfq registered
[    0.620253] pcieport 0000:00:02.0: setting latency timer to 64
[    0.620277] pcieport 0000:00:02.0: irq 40 for MSI/MSI-X
[    0.620358] pcieport 0000:00:0a.0: setting latency timer to 64
[    0.620378] pcieport 0000:00:0a.0: irq 41 for MSI/MSI-X
[    0.620681] ERST: Table is not found!
[    0.620740] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.660400] Linux agpgart interface v0.103
[    0.660473] i8042: PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
[    0.660474] i8042: PNP: PS/2 appears to have AUX port disabled, if this is incorrect please boot with i8042.nopnp
[    0.660643] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.660715] mousedev: PS/2 mouse device common for all mice
[    0.660747] rtc_cmos 00:02: RTC can wake from S4
[    0.660821] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.660841] rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.660848] cpuidle: using governor ladder
[    0.660849] cpuidle: using governor menu
[    0.661014] TCP cubic registered
[    0.661070] NET: Registered protocol family 10
[    0.661555] Mobile IPv6
[    0.661557] NET: Registered protocol family 17
[    0.661560] Registering the dns_resolver key type
[    0.661635] PM: Hibernation image not present or could not be loaded.
[    0.661644] registered taskstats version 1
[    0.688550] rtc_cmos 00:02: setting system clock to 2011-10-01 16:16:29 UTC (1317485789)
[    0.688578] Initializing network drop monitor service
[    0.689374] Freeing unused kernel memory: 560k freed
[    0.689462] Write protecting the kernel read-only data: 6144k
[    0.691496] Freeing unused kernel memory: 752k freed
[    0.693626] Freeing unused kernel memory: 720k freed
[    0.711661] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input0
[    0.755123] udevd[83]: starting version 172
[    0.769706] usbcore: registered new interface driver usbfs
[    0.769723] usbcore: registered new interface driver hub
[    0.786636] usbcore: registered new device driver usb
[    0.786973] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.790046] SCSI subsystem initialized
[    0.792872] ns83820.c: National Semiconductor DP83820 10/100/1000 driver.
[    0.793255] libata version 3.00 loaded.
[    0.793736] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
[    0.793769] r8169 0000:05:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.793807] r8169 0000:05:00.0: setting latency timer to 64
[    0.793862] r8169 0000:05:00.0: irq 42 for MSI/MSI-X
[    0.794624] ns83820 0000:03:07.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
[    0.794675] ehci_hcd 0000:00:12.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.794688] ehci_hcd 0000:00:12.2: EHCI Host Controller
[    0.794883] ehci_hcd 0000:00:12.2: new USB bus registered, assigned bus number 1
[    0.794894] ehci_hcd 0000:00:12.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    0.794915] QUIRK: Enable AMD PLL fix
[    0.794924] ehci_hcd 0000:00:12.2: debug port 1
[    0.794940] ehci_hcd 0000:00:12.2: irq 17, io mem 0xfe5ff800
[    0.795388] r8169 0000:05:00.0: eth0: RTL8168d/8111d at 0xffffc9000186c000, 6c:62:6d:e4:c8:3a, XID 081000c0 IRQ 42
[    0.795417] eth1: ns83820.c: 0x22c: 10641737, subsystem: 1737:1064
[    0.804028] ehci_hcd 0000:00:12.2: USB 2.0 started, EHCI 1.00
[    0.804049] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.804052] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.804053] usb usb1: Product: EHCI Host Controller
[    0.804055] usb usb1: Manufacturer: Linux 3.0.0-1-amd64 ehci_hcd
[    0.804056] usb usb1: SerialNumber: 0000:00:12.2
[    0.804154] hub 1-0:1.0: USB hub found
[    0.804157] hub 1-0:1.0: 5 ports detected
[    0.804260] eth1: using 64 bit addressing.
[    0.804264] eth1: ns83820 v0.23: DP83820 v1.2: 00:04:5a:76:c5:7a io=0xfe8fa000 irq=22 f=h,sg
[    0.807157] xhci_hcd 0000:02:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.807186] xhci_hcd 0000:02:00.0: setting latency timer to 64
[    0.807189] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    0.807202] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 2
[    0.807322] xhci_hcd 0000:02:00.0: irq 18, io mem 0xfe7fe000
[    0.807366] xhci_hcd 0000:02:00.0: irq 43 for MSI/MSI-X
[    0.807373] xhci_hcd 0000:02:00.0: irq 44 for MSI/MSI-X
[    0.807381] xhci_hcd 0000:02:00.0: irq 45 for MSI/MSI-X
[    0.807430] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.807432] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.807434] usb usb2: Product: xHCI Host Controller
[    0.807435] usb usb2: Manufacturer: Linux 3.0.0-1-amd64 xhci_hcd
[    0.807436] usb usb2: SerialNumber: 0000:02:00.0
[    0.807514] xHCI xhci_add_endpoint called for root hub
[    0.807516] xHCI xhci_check_bandwidth called for root hub
[    0.807535] hub 2-0:1.0: USB hub found
[    0.807540] hub 2-0:1.0: 2 ports detected
[    0.807585] xhci_hcd 0000:02:00.0: xHCI Host Controller
[    0.807590] xhci_hcd 0000:02:00.0: new USB bus registered, assigned bus number 3
[    0.810757] usb usb3: New USB device found, idVendor=1d6b, idProduct=0003
[    0.810759] usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.810760] usb usb3: Product: xHCI Host Controller
[    0.810761] usb usb3: Manufacturer: Linux 3.0.0-1-amd64 xhci_hcd
[    0.810763] usb usb3: SerialNumber: 0000:02:00.0
[    0.810815] xHCI xhci_add_endpoint called for root hub
[    0.810817] xHCI xhci_check_bandwidth called for root hub
[    0.810833] hub 3-0:1.0: USB hub found
[    0.810840] hub 3-0:1.0: 2 ports detected
[    0.810957] pata_jmicron 0000:04:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    0.810981] pata_jmicron 0000:04:00.0: setting latency timer to 64
[    0.815258] ehci_hcd 0000:00:13.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.815291] ehci_hcd 0000:00:13.2: EHCI Host Controller
[    0.815303] ehci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[    0.815314] ehci_hcd 0000:00:13.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    0.815335] ehci_hcd 0000:00:13.2: debug port 1
[    0.815349] ehci_hcd 0000:00:13.2: irq 17, io mem 0xfe5ff400
[    0.815359] sata_sil 0000:03:05.0: version 2.4
[    0.815396] sata_sil 0000:03:05.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    0.815414] sata_sil 0000:03:05.0: Applying R_ERR on DMA activate FIS errata fix
[    0.820779] scsi0 : pata_jmicron
[    0.822941] scsi1 : sata_sil
[    0.823009] scsi2 : pata_jmicron
[    0.823412] ata1: PATA max UDMA/100 cmd 0xd800 ctl 0xd400 bmdma 0xc400 irq 16
[    0.823414] ata2: PATA max UDMA/100 cmd 0xd000 ctl 0xc800 bmdma 0xc408 irq 16
[    0.824049] ehci_hcd 0000:00:13.2: USB 2.0 started, EHCI 1.00
[    0.824102] usb usb4: New USB device found, idVendor=1d6b, idProduct=0002
[    0.824104] usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.824106] usb usb4: Product: EHCI Host Controller
[    0.824107] usb usb4: Manufacturer: Linux 3.0.0-1-amd64 ehci_hcd
[    0.824109] usb usb4: SerialNumber: 0000:00:13.2
[    0.824203] hub 4-0:1.0: USB hub found
[    0.824206] hub 4-0:1.0: 5 ports detected
[    0.824670] ehci_hcd 0000:00:16.2: PCI INT B -> GSI 17 (level, low) -> IRQ 17
[    0.824696] ehci_hcd 0000:00:16.2: EHCI Host Controller
[    0.824703] ehci_hcd 0000:00:16.2: new USB bus registered, assigned bus number 5
[    0.824711] ehci_hcd 0000:00:16.2: applying AMD SB700/SB800/Hudson-2/3 EHCI dummy qh workaround
[    0.824730] ehci_hcd 0000:00:16.2: debug port 1
[    0.824742] ehci_hcd 0000:00:16.2: irq 17, io mem 0xfe5ff000
[    0.824758] scsi3 : sata_sil
[    0.824807] scsi4 : sata_sil
[    0.824844] scsi5 : sata_sil
[    0.824870] ata3: SATA max UDMA/100 mmio m1024@0xfe8fbc00 tf 0xfe8fbc80 irq 20
[    0.824874] ata4: SATA max UDMA/100 mmio m1024@0xfe8fbc00 tf 0xfe8fbcc0 irq 20
[    0.824877] ata5: SATA max UDMA/100 mmio m1024@0xfe8fbc00 tf 0xfe8fbe80 irq 20
[    0.824880] ata6: SATA max UDMA/100 mmio m1024@0xfe8fbc00 tf 0xfe8fbec0 irq 20
[    0.836048] ehci_hcd 0000:00:16.2: USB 2.0 started, EHCI 1.00
[    0.836072] usb usb5: New USB device found, idVendor=1d6b, idProduct=0002
[    0.836074] usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.836076] usb usb5: Product: EHCI Host Controller
[    0.836077] usb usb5: Manufacturer: Linux 3.0.0-1-amd64 ehci_hcd
[    0.836079] usb usb5: SerialNumber: 0000:00:16.2
[    0.836190] hub 5-0:1.0: USB hub found
[    0.836194] hub 5-0:1.0: 4 ports detected
[    0.836289] ahci 0000:00:11.0: version 3.0
[    0.836310] ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
[    0.836361] ahci 0000:00:11.0: irq 46 for MSI/MSI-X
[    0.836448] ahci 0000:00:11.0: AHCI 0001.0200 32 slots 6 ports 6 Gbps 0x3f impl SATA mode
[    0.836450] ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum part 
[    0.837058] scsi6 : ahci
[    0.837113] scsi7 : ahci
[    0.837160] scsi8 : ahci
[    0.837206] scsi9 : ahci
[    0.837252] scsi10 : ahci
[    0.837303] scsi11 : ahci
[    0.837337] ata7: SATA max UDMA/133 abar m1024@0xfe5ffc00 port 0xfe5ffd00 irq 46
[    0.837340] ata8: SATA max UDMA/133 abar m1024@0xfe5ffc00 port 0xfe5ffd80 irq 46
[    0.837343] ata9: SATA max UDMA/133 abar m1024@0xfe5ffc00 port 0xfe5ffe00 irq 46
[    0.837345] ata10: SATA max UDMA/133 abar m1024@0xfe5ffc00 port 0xfe5ffe80 irq 46
[    0.837348] ata11: SATA max UDMA/133 abar m1024@0xfe5ffc00 port 0xfe5fff00 irq 46
[    0.837351] ata12: SATA max UDMA/133 abar m1024@0xfe5ffc00 port 0xfe5fff80 irq 46
[    0.872731] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.872825] ohci_hcd 0000:00:12.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.872856] ohci_hcd 0000:00:12.0: OHCI Host Controller
[    0.872867] ohci_hcd 0000:00:12.0: new USB bus registered, assigned bus number 6
[    0.872904] ohci_hcd 0000:00:12.0: irq 18, io mem 0xfe5fe000
[    0.932062] usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
[    0.932065] usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.932067] usb usb6: Product: OHCI Host Controller
[    0.932068] usb usb6: Manufacturer: Linux 3.0.0-1-amd64 ohci_hcd
[    0.932069] usb usb6: SerialNumber: 0000:00:12.0
[    0.932184] hub 6-0:1.0: USB hub found
[    0.932191] hub 6-0:1.0: 5 ports detected
[    0.932314] ohci_hcd 0000:00:13.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    0.932340] ohci_hcd 0000:00:13.0: OHCI Host Controller
[    0.932348] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 7
[    0.932364] ohci_hcd 0000:00:13.0: irq 18, io mem 0xfe5fd000
[    0.992622] usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
[    0.992625] usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.992627] usb usb7: Product: OHCI Host Controller
[    0.992628] usb usb7: Manufacturer: Linux 3.0.0-1-amd64 ohci_hcd
[    0.992629] usb usb7: SerialNumber: 0000:00:13.0
[    0.992737] hub 7-0:1.0: USB hub found
[    0.992742] hub 7-0:1.0: 5 ports detected
[    0.992890] ata1.00: ATA-8: WDC WD5000AAKB-00H8A0, 05.04E05, max UDMA/133
[    0.992893] ohci_hcd 0000:00:14.5: PCI INT C -> GSI 18 (level, low) -> IRQ 18
[    0.992897] ata1.00: 976773168 sectors, multi 16: LBA48 
[    0.992919] ohci_hcd 0000:00:14.5: OHCI Host Controller
[    0.992927] ohci_hcd 0000:00:14.5: new USB bus registered, assigned bus number 8
[    0.992943] ohci_hcd 0000:00:14.5: irq 18, io mem 0xfe5fc000
[    0.993248] ata1.01: ATA-8: WDC WD5000AAKB-00H8A0, 05.04E05, max UDMA/133
[    0.993251] ata1.01: 976773168 sectors, multi 16: LBA48 
[    1.008911] ata1.00: configured for UDMA/100
[    1.025255] ata1.01: configured for UDMA/100
[    1.025370] scsi 0:0:0:0: Direct-Access     ATA      WDC WD5000AAKB-0 05.0 PQ: 0 ANSI: 5
[    1.025523] scsi 0:0:1:0: Direct-Access     ATA      WDC WD5000AAKB-0 05.0 PQ: 0 ANSI: 5
[    1.052079] usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
[    1.052081] usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.052083] usb usb8: Product: OHCI Host Controller
[    1.052084] usb usb8: Manufacturer: Linux 3.0.0-1-amd64 ohci_hcd
[    1.052086] usb usb8: SerialNumber: 0000:00:14.5
[    1.052198] hub 8-0:1.0: USB hub found
[    1.052203] hub 8-0:1.0: 2 ports detected
[    1.052314] ohci_hcd 0000:00:16.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[    1.052339] ohci_hcd 0000:00:16.0: OHCI Host Controller
[    1.052347] ohci_hcd 0000:00:16.0: new USB bus registered, assigned bus number 9
[    1.052365] ohci_hcd 0000:00:16.0: irq 18, io mem 0xfe5f7000
[    1.080060] hub 4-0:1.0: unable to enumerate USB device on port 2
[    1.112086] usb usb9: New USB device found, idVendor=1d6b, idProduct=0001
[    1.112088] usb usb9: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    1.112091] usb usb9: Product: OHCI Host Controller
[    1.112092] usb usb9: Manufacturer: Linux 3.0.0-1-amd64 ohci_hcd
[    1.112093] usb usb9: SerialNumber: 0000:00:16.0
[    1.112209] hub 9-0:1.0: USB hub found
[    1.112215] hub 9-0:1.0: 4 ports detected
[    1.144096] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    1.168428] ata3.00: ATA-8: SAMSUNG HD321KJ, CP100-10, max UDMA7
[    1.168431] ata3.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    1.176430] ata3.00: configured for UDMA/100
[    1.180205] scsi 1:0:0:0: Direct-Access     ATA      SAMSUNG HD321KJ  CP10 PQ: 0 ANSI: 5
[    1.192076] usb 4-3: new high speed USB device number 3 using ehci_hcd
[    1.328054] ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.328079] ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.328100] ata9: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.328116] ata11: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.328132] ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.328148] ata12: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.328770] ata8.00: ATA-8: ST2000DL003-9VT166, CC32, max UDMA/133
[    1.328773] ata8.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.328810] ata9.00: ATA-8: ST2000DL003-9VT166, CC32, max UDMA/133
[    1.328813] ata9.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.328825] ata11.00: ATA-8: ST2000DL003-9VT166, CC32, max UDMA/133
[    1.328827] ata11.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.328837] ata7.00: ATA-8: ST2000DL003-9VT166, CC32, max UDMA/133
[    1.328838] ata7.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.328847] ata10.00: ATA-8: ST2000DL003-9VT166, CC32, max UDMA/133
[    1.328849] ata10.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    1.329430] usb 4-3: New USB device found, idVendor=1058, idProduct=0901
[    1.329433] usb 4-3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    1.329434] usb 4-3: Product: External HDD
[    1.329436] usb 4-3: Manufacturer: Western Digital
[    1.329437] usb 4-3: SerialNumber: 57442D5743414E4B36343035313533
[    1.329590] ata7.00: configured for UDMA/133
[    1.329608] ata8.00: configured for UDMA/133
[    1.329618] ata10.00: configured for UDMA/133
[    1.329633] ata11.00: configured for UDMA/133
[    1.329643] ata9.00: configured for UDMA/133
[    1.343450] ata12.00: ATA-8: WDC WD20EARS-00MVWB0, 51.0AB51, max UDMA/133
[    1.343454] ata12.00: 3907029168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    1.347283] ata12.00: configured for UDMA/133
[    1.500072] ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    1.508504] ata4.00: ATA-8: Hitachi HDS723030ALA640, MKAOA5C0, max UDMA/133
[    1.508507] ata4.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    1.524496] ata4.00: configured for UDMA/100
[    1.524658] scsi 3:0:0:0: Direct-Access     ATA      Hitachi HDS72303 MKAO PQ: 0 ANSI: 5
[    1.528044] Refined TSC clocksource calibration: 3405.092 MHz.
[    1.528050] Switching to clocksource tsc
[    1.844066] ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    1.868437] ata5.00: ATA-8: SAMSUNG HD321KJ, CP100-10, max UDMA7
[    1.868439] ata5.00: 625142448 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    1.876423] ata5.00: configured for UDMA/100
[    1.876569] scsi 4:0:0:0: Direct-Access     ATA      SAMSUNG HD321KJ  CP10 PQ: 0 ANSI: 5
[    2.196066] ata6: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
[    2.204492] ata6.00: ATA-8: Hitachi HDS723030ALA640, MKAOA5C0, max UDMA/133
[    2.204495] ata6.00: 5860533168 sectors, multi 0: LBA48 NCQ (depth 0/32)
[    2.220488] ata6.00: configured for UDMA/100
[    2.220636] scsi 5:0:0:0: Direct-Access     ATA      Hitachi HDS72303 MKAO PQ: 0 ANSI: 5
[    2.220828] scsi 6:0:0:0: Direct-Access     ATA      ST2000DL003-9VT1 CC32 PQ: 0 ANSI: 5
[    2.220960] scsi 7:0:0:0: Direct-Access     ATA      ST2000DL003-9VT1 CC32 PQ: 0 ANSI: 5
[    2.221131] scsi 8:0:0:0: Direct-Access     ATA      ST2000DL003-9VT1 CC32 PQ: 0 ANSI: 5
[    2.221244] scsi 9:0:0:0: Direct-Access     ATA      ST2000DL003-9VT1 CC32 PQ: 0 ANSI: 5
[    2.221366] scsi 10:0:0:0: Direct-Access     ATA      ST2000DL003-9VT1 CC32 PQ: 0 ANSI: 5
[    2.221491] scsi 11:0:0:0: Direct-Access     ATA      WDC WD20EARS-00M 51.0 PQ: 0 ANSI: 5
[    2.228092] sd 1:0:0:0: [sdc] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.228107] sd 0:0:1:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.228116] sd 0:0:0:0: [sda] 976773168 512-byte logical blocks: (500 GB/465 GiB)
[    2.228124] sd 1:0:0:0: [sdc] Write Protect is off
[    2.228127] sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.228141] sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.228163] sd 0:0:0:0: [sda] Write Protect is off
[    2.228166] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.228170] sd 0:0:1:0: [sdb] Write Protect is off
[    2.228172] sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
[    2.228188] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.228265] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.228356] sd 3:0:0:0: [sdd] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.228381] sd 3:0:0:0: [sdd] Write Protect is off
[    2.228383] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.228394] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.228573] sd 4:0:0:0: [sde] 625142448 512-byte logical blocks: (320 GB/298 GiB)
[    2.228598] sd 4:0:0:0: [sde] Write Protect is off
[    2.228599] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    2.228610] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.228891] sd 5:0:0:0: [sdf] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB)
[    2.228922] sd 6:0:0:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.228949] sd 7:0:0:0: [sdh] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.228953] sd 8:0:0:0: [sdi] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.228971] sd 5:0:0:0: [sdf] Write Protect is off
[    2.228973] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    2.228982] sd 8:0:0:0: [sdi] Write Protect is off
[    2.228984] sd 8:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[    2.228997] sd 8:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.229001] sd 6:0:0:0: [sdg] Write Protect is off
[    2.229003] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    2.229007] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.229074] sd 7:0:0:0: [sdh] Write Protect is off
[    2.229076] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    2.229082] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.229145] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.229150] sd 9:0:0:0: [sdj] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.229174] sd 9:0:0:0: [sdj] Write Protect is off
[    2.229176] sd 9:0:0:0: [sdj] Mode Sense: 00 3a 00 00
[    2.229187] sd 9:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.229329] sd 10:0:0:0: [sdk] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.229354] sd 10:0:0:0: [sdk] Write Protect is off
[    2.229355] sd 10:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[    2.229368] sd 10:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.229499] sd 11:0:0:0: [sdl] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    2.229524] sd 11:0:0:0: [sdl] Write Protect is off
[    2.229526] sd 11:0:0:0: [sdl] Mode Sense: 00 3a 00 00
[    2.229537] sd 11:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.233220]  sdi: sdi1
[    2.233242]  sda: sda1
[    2.233521] sd 8:0:0:0: [sdi] Attached SCSI disk
[    2.235054] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.235108] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    2.235155] sd 1:0:0:0: Attached scsi generic sg2 type 0
[    2.235200] sd 3:0:0:0: Attached scsi generic sg3 type 0
[    2.235242] sd 4:0:0:0: Attached scsi generic sg4 type 0
[    2.235286] sd 5:0:0:0: Attached scsi generic sg5 type 0
[    2.235347] sd 6:0:0:0: Attached scsi generic sg6 type 0
[    2.235391] sd 7:0:0:0: Attached scsi generic sg7 type 0
[    2.235446] sd 8:0:0:0: Attached scsi generic sg8 type 0
[    2.235486] sd 9:0:0:0: Attached scsi generic sg9 type 0
[    2.235530] sd 10:0:0:0: Attached scsi generic sg10 type 0
[    2.235571] sd 11:0:0:0: Attached scsi generic sg11 type 0
[    2.236814]  sdc: sdc1
[    2.237289] sd 1:0:0:0: [sdc] Attached SCSI disk
[    2.238987]  sdh: sdh1
[    2.239501] sd 7:0:0:0: [sdh] Attached SCSI disk
[    2.240894]  sdb: sdb1
[    2.241045] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.241089] sd 0:0:1:0: [sdb] Attached SCSI disk
[    2.248589]  sdl: sdl1
[    2.248754] sd 11:0:0:0: [sdl] Attached SCSI disk
[    2.249147] usbcore: registered new interface driver uas
[    2.252753]  sdk: sdk1
[    2.253265] sd 10:0:0:0: [sdk] Attached SCSI disk
[    2.254040]  sdj: sdj1
[    2.254609] sd 9:0:0:0: [sdj] Attached SCSI disk
[    2.258453]  sdg: sdg1
[    2.258958] sd 6:0:0:0: [sdg] Attached SCSI disk
[    2.263256]  sdd: sdd1
[    2.263511] sd 3:0:0:0: [sdd] Attached SCSI disk
[    2.264932]  sdf: sdf1
[    2.265379] sd 5:0:0:0: [sdf] Attached SCSI disk
[    2.273894]  sde: sde1
[    2.274081] sd 4:0:0:0: [sde] Attached SCSI disk
[    2.274830] Initializing USB Mass Storage driver...
[    2.275906] scsi12 : usb-storage 4-3:1.0
[    2.276047] usbcore: registered new interface driver usb-storage
[    2.276049] USB Mass Storage support registered.
[    2.518535] md: raid1 personality registered for level 1
[    2.519491] async_tx: api initialized (async)
[    2.519802] xor: automatically using best checksumming function: generic_sse
[    2.536011]    generic_sse: 13615.000 MB/sec
[    2.536012] xor: using function: generic_sse (13615.000 MB/sec)
[    2.604026] raid6: int64x1   3321 MB/s
[    2.672019] raid6: int64x2   3312 MB/s
[    2.740028] raid6: int64x4   2799 MB/s
[    2.808013] raid6: int64x8   2323 MB/s
[    2.876025] raid6: sse2x1    4650 MB/s
[    2.944018] raid6: sse2x2    7536 MB/s
[    3.012014] raid6: sse2x4    9071 MB/s
[    3.012015] raid6: using algorithm sse2x4 (9071 MB/s)
[    3.012869] md: raid6 personality registered for level 6
[    3.012871] md: raid5 personality registered for level 5
[    3.012873] md: raid4 personality registered for level 4
[    3.023073] md: md1 stopped.
[    3.024745] md: bind<sdb1>
[    3.025153] md: bind<sda1>
[    3.026964] bio: create slab <bio-1> at 1
[    3.027053] md/raid1:md1: active with 2 out of 2 mirrors
[    3.027072] md1: detected capacity change from 0 to 500107706368
[    3.031853]  md1: p1 p2 p3 p4
[    3.036811] md: md0 stopped.
[    3.086351] md: md0 stopped.
[    3.089802] device-mapper: uevent: version 1.0.3
[    3.090003] device-mapper: ioctl: 4.20.0-ioctl (2011-02-02) initialised: dm-devel@redhat.com
[    3.311666] scsi 12:0:0:0: Direct-Access     WD       2500JB External  0107 PQ: 0 ANSI: 0
[    3.312169] sd 12:0:0:0: Attached scsi generic sg12 type 0
[    3.313867] sd 12:0:0:0: [sdm] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    3.315407] sd 12:0:0:0: [sdm] Write Protect is off
[    3.315410] sd 12:0:0:0: [sdm] Mode Sense: 03 00 00 00
[    3.316407] sd 12:0:0:0: [sdm] No Caching mode page present
[    3.316442] sd 12:0:0:0: [sdm] Assuming drive cache: write through
[    3.319156] sd 12:0:0:0: [sdm] No Caching mode page present
[    3.319192] sd 12:0:0:0: [sdm] Assuming drive cache: write through
[    3.319916]  sdm: sdm1
[    3.326464] sd 12:0:0:0: [sdm] No Caching mode page present
[    3.326500] sd 12:0:0:0: [sdm] Assuming drive cache: write through
[    3.326534] sd 12:0:0:0: [sdm] Attached SCSI disk
[    3.556043] usb 7-2: new low speed USB device number 2 using ohci_hcd
[    3.729132] usb 7-2: New USB device found, idVendor=0764, idProduct=0501
[    3.729135] usb 7-2: New USB device strings: Mfr=3, Product=1, SerialNumber=0
[    3.729137] usb 7-2: Product: UPS VALUE
[    3.729138] usb 7-2: Manufacturer: CPS
[    3.785260] generic-usb 0003:0764:0501.0001: hiddev0,hidraw0: USB HID v1.10 Device [CPS UPS VALUE] on usb-0000:00:13.0-2/input0
[    3.785275] usbcore: registered new interface driver usbhid
[    3.785276] usbhid: USB HID core driver
[   10.216189] usb 7-2: USB disconnect, device number 2
[   10.928040] usb 4-3: reset high speed USB device number 3 using ehci_hcd
[   11.331660] Btrfs loaded
[   12.006824] EXT4-fs (md1p4): INFO: recovery required on readonly filesystem
[   12.006827] EXT4-fs (md1p4): write access will be enabled during recovery
[   12.692043] usb 7-2: new low speed USB device number 3 using ohci_hcd
[   12.767628] EXT4-fs (md1p4): orphan cleanup on readonly fs
[   12.781186] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 5506981
[   12.828892] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 5507066
[   12.830921] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 5507155
[   12.854745] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141539
[   12.862461] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141557
[   12.862477] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141504
[   12.862486] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141537
[   12.862496] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141559
[   12.862507] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141550
[   12.862515] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141515
[   12.862524] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141540
[   12.862615] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141553
[   12.862631] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141561
[   12.862639] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141563
[   12.862648] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141501
[   12.862657] EXT4-fs (md1p4): ext4_orphan_cleanup: deleting unreferenced inode 11141617
[   12.862684] EXT4-fs (md1p4): 16 orphan inodes deleted
[   12.862685] EXT4-fs (md1p4): recovery complete
[   12.865191] usb 7-2: New USB device found, idVendor=0764, idProduct=0501
[   12.865194] usb 7-2: New USB device strings: Mfr=3, Product=1, SerialNumber=0
[   12.865196] usb 7-2: Product: UPS VALUE
[   12.865197] usb 7-2: Manufacturer: CPS
[   12.918310] generic-usb 0003:0764:0501.0002: hiddev0,hidraw0: USB HID v1.10 Device [CPS UPS VALUE] on usb-0000:00:13.0-2/input0
[   13.186275] EXT4-fs (md1p4): mounted filesystem with ordered data mode. Opts: (null)
[   14.645028] udevd[510]: starting version 172
[   15.054181] input: Power Button as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[   15.054187] ACPI: Power Button [PWRB]
[   15.054226] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input2
[   15.054229] ACPI: Power Button [PWRF]
[   15.069734] ACPI: acpi_idle registered with cpuidle
[   15.109573] input: PC Speaker as /devices/platform/pcspkr/input/input3
[   15.187534] MCE: In-kernel MCE decoding enabled.
[   15.210273] EDAC MC: Ver: 2.1.0
[   15.234131] AMD64 EDAC driver v3.4.0
[   15.234348] EDAC amd64: DRAM ECC disabled.
[   15.234353] EDAC amd64: ECC disabled in the BIOS or no ECC capability, module will not load.
[   15.234354]  Either enable ECC checking or force module loading by setting 'ecc_enable_override'.
[   15.234355]  (Note that use of the override may cause unknown side effects.)
[   15.340389] piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
[   15.494686] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
[   15.494747] SP5100 TCO timer: mmio address 0xb8fe00 already in use
[   15.543280] [drm] Initialized drm 1.1.0 20060810
[   15.622096] Error: Driver 'pcspkr' is already registered, aborting...
[   15.654117] [drm] radeon defaulting to kernel modesetting.
[   15.654119] [drm] radeon kernel modesetting enabled.
[   15.654309] radeon 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
[   15.654313] radeon 0000:01:00.0: setting latency timer to 64
[   15.654540] [drm] initializing kernel modesetting (RV515 0x1002:0x7183 0x1028:0x0302).
[   15.654561] [drm] register mmio base: 0xFE6F0000
[   15.654562] [drm] register mmio size: 65536
[   15.658866] ATOM BIOS: 113
[   15.658880] [drm] Generation 2 PCI interface, using max accessible memory
[   15.658884] radeon 0000:01:00.0: VRAM: 256M 0x0000000000000000 - 0x000000000FFFFFFF (256M used)
[   15.658886] radeon 0000:01:00.0: GTT: 512M 0x0000000010000000 - 0x000000002FFFFFFF
[   15.658898] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[   15.658900] [drm] Driver supports precise vblank timestamp query.
[   15.658929] radeon 0000:01:00.0: irq 47 for MSI/MSI-X
[   15.658933] radeon 0000:01:00.0: radeon: using MSI.
[   15.658951] [drm] radeon: irq initialized.
[   15.659116] [drm] Detected VRAM RAM=256M, BAR=256M
[   15.659118] [drm] RAM width 128bits DDR
[   15.659187] [TTM] Zone  kernel: Available graphics memory: 8235092 kiB.
[   15.659189] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB.
[   15.659190] [TTM] Initializing pool allocator.
[   15.659213] [drm] radeon: 256M of VRAM memory ready
[   15.659214] [drm] radeon: 512M of GTT memory ready.
[   15.659230] [drm] GART: num cpu pages 131072, num gpu pages 131072
[   15.660897] [drm] radeon: 1 quad pipes, 1 z pipes initialized.
[   15.661501] [drm] PCIE GART of 512M enabled (table at 0x00040000).
[   15.661525] radeon 0000:01:00.0: WB enabled
[   15.661576] [drm] Loading R500 Microcode
[   15.711469] radeon_cp: Failed to load firmware "radeon/R520_cp.bin"
[   15.711590] [drm:r100_cp_init] *ERROR* Failed to load firmware!
[   15.711625] radeon 0000:01:00.0: failed initializing CP (-2).
[   15.711660] radeon 0000:01:00.0: Disabling GPU acceleration
[   15.711698] [drm] radeon: cp finalized
[   15.712306] radeon 0000:01:00.0: ffff88041b9cd000 unpin not necessary
[   15.712403] failed to evaluate ATIF got AE_BAD_PARAMETER
[   15.712644] [drm] Radeon Display Connectors
[   15.712645] [drm] Connector 0:
[   15.712646] [drm]   DVI-I
[   15.712647] [drm]   HPD1
[   15.712649] [drm]   DDC: 0x7e40 0x7e40 0x7e44 0x7e44 0x7e48 0x7e48 0x7e4c 0x7e4c
[   15.712650] [drm]   Encoders:
[   15.712651] [drm]     CRT1: INTERNAL_KLDSCP_DAC1
[   15.712652] [drm]     DFP1: INTERNAL_KLDSCP_TMDS1
[   15.712653] [drm] Connector 1:
[   15.712654] [drm]   S-video
[   15.712655] [drm]   Encoders:
[   15.712656] [drm]     TV1: INTERNAL_KLDSCP_DAC2
[   15.712657] [drm] Connector 2:
[   15.712658] [drm]   VGA
[   15.712659] [drm]   DDC: 0x7e50 0x7e50 0x7e54 0x7e54 0x7e58 0x7e58 0x7e5c 0x7e5c
[   15.712660] [drm]   Encoders:
[   15.712661] [drm]     CRT2: INTERNAL_KLDSCP_DAC2
[   15.724443] [drm] Radeon display connector DVI-I-1: No monitor connected or invalid EDID
[   15.784636] [drm] Radeon display connector VGA-1: Found valid EDID
[   15.904447] [drm] fb mappable at 0xD0040000
[   15.904449] [drm] vram apper at 0xD0000000
[   15.904451] [drm] size 3145728
[   15.904452] [drm] fb depth is 24
[   15.904453] [drm]    pitch is 4096
[   15.904523] fbcon: radeondrmfb (fb0) is primary device
[   15.922837] Console: switching to colour frame buffer device 128x48
[   15.924643] fb0: radeondrmfb frame buffer device
[   15.924644] drm: registered panic notifier
[   15.924651] [drm] Initialized radeon 2.10.0 20080528 for 0000:01:00.0 on minor 0
[   19.358043] usb 7-2: USB disconnect, device number 3
[   21.836038] usb 7-2: new low speed USB device number 4 using ohci_hcd
[   22.010121] usb 7-2: New USB device found, idVendor=0764, idProduct=0501
[   22.010124] usb 7-2: New USB device strings: Mfr=3, Product=1, SerialNumber=0
[   22.010126] usb 7-2: Product: UPS VALUE
[   22.010127] usb 7-2: Manufacturer: CPS
[   22.062341] generic-usb 0003:0764:0501.0003: hiddev0,hidraw0: USB HID v1.10 Device [CPS UPS VALUE] on usb-0000:00:13.0-2/input0
[   22.944040] usb 4-3: reset high speed USB device number 3 using ehci_hcd
[   23.373738] kvm: Nested Virtualization enabled
[   23.373749] kvm: Nested Paging enabled
[   23.387795] md: md0 stopped.
[   23.391260] md: bind<sdh1>
[   23.391415] md: bind<sdi1>
[   23.391568] md: bind<sdk1>
[   23.391792] md: bind<sdg1>
[   23.395380] md/raid:md0: device sdg1 operational as raid disk 0
[   23.395383] md/raid:md0: device sdk1 operational as raid disk 3
[   23.395385] md/raid:md0: device sdi1 operational as raid disk 2
[   23.395387] md/raid:md0: device sdh1 operational as raid disk 1
[   23.395781] md/raid:md0: allocated 5334kB
[   23.395812] md/raid:md0: raid level 6 active with 4 out of 5 devices, algorithm 2
[   23.395845] RAID conf printout:
[   23.395847]  --- level:6 rd:5 wd:4
[   23.395848]  disk 0, o:1, dev:sdg1
[   23.395849]  disk 1, o:1, dev:sdh1
[   23.395850]  disk 2, o:1, dev:sdi1
[   23.395851]  disk 3, o:1, dev:sdk1
[   23.395876] md0: detected capacity change from 0 to 6001183948800
[   23.396489]  md0: unknown partition table
[   23.400558] md: md2 stopped.
[   23.401709] md: bind<sdf1>
[   23.401833] md: bind<sdd1>
[   23.458526] md: raid0 personality registered for level 0
[   23.459107] md/raid0:md2: looking at sdd1
[   23.459109] md/raid0:md2:   comparing sdd1(5860530176) with sdd1(5860530176)
[   23.459111] md/raid0:md2:   END
[   23.459112] md/raid0:md2:   ==> UNIQUE
[   23.459113] md/raid0:md2: 1 zones
[   23.459115] md/raid0:md2: looking at sdf1
[   23.459116] md/raid0:md2:   comparing sdf1(5860530176) with sdd1(5860530176)
[   23.459118] md/raid0:md2:   EQUAL
[   23.459119] md/raid0:md2: FINAL 1 zones
[   23.459121] md/raid0:md2: done.
[   23.459123] md/raid0:md2: md_size is 11721060352 sectors.
[   23.459124] ******* md2 configuration *********
[   23.459125] zone0=[sdd1/sdf1/]
[   23.459127]         zone offset=0kb device offset=0kb size=5860530176kb
[   23.459129] **********************************
[   23.459129] 
[   23.459138] md2: detected capacity change from 0 to 6001182900224
[   23.459699]  md2: unknown partition table
[   23.727796] Adding 4882808k swap on /dev/md1p2.  Priority:-1 extents:1 across:4882808k 
[   23.730492] EXT4-fs (md1p4): warning: maximal mount count reached, running e2fsck is recommended
[   23.785128] EXT4-fs (md1p4): re-mounted. Opts: (null)
[   23.966052] loop: module loaded
[   25.810662] EXT4-fs (md1p1): warning: maximal mount count reached, running e2fsck is recommended
[   25.811462] EXT4-fs (md1p1): recovery complete
[   25.811994] EXT4-fs (md1p1): mounted filesystem with ordered data mode. Opts: (null)
[   26.673853] EXT4-fs (md1p3): warning: maximal mount count reached, running e2fsck is recommended
[   26.674710] EXT4-fs (md1p3): recovery complete
[   26.675317] EXT4-fs (md1p3): mounted filesystem with ordered data mode. Opts: (null)
[   28.499496] usb 7-2: USB disconnect, device number 4
[   30.976034] usb 7-2: new low speed USB device number 5 using ohci_hcd
[   31.149120] usb 7-2: New USB device found, idVendor=0764, idProduct=0501
[   31.149123] usb 7-2: New USB device strings: Mfr=3, Product=1, SerialNumber=0
[   31.149125] usb 7-2: Product: UPS VALUE
[   31.149127] usb 7-2: Manufacturer: CPS
[   31.201245] generic-usb 0003:0764:0501.0004: hiddev0,hidraw0: USB HID v1.10 Device [CPS UPS VALUE] on usb-0000:00:13.0-2/input0
[   33.910770] EXT4-fs (sdl1): warning: maximal mount count reached, running e2fsck is recommended
[   34.017763] EXT4-fs (sdl1): recovery complete
[   34.018025] EXT4-fs (sdl1): mounted filesystem with ordered data mode. Opts: (null)
[   34.131195] EXT4-fs (sdm1): recovery complete
[   34.131908] EXT4-fs (sdm1): mounted filesystem with ordered data mode. Opts: (null)
[   34.750575] ip_tables: (C) 2000-2006 Netfilter Core Team
[   34.765038] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   34.845762] ip6_tables: (C) 2000-2006 Netfilter Core Team
[   35.524819] Bridge firewalling registered
[   35.527717] device eth0 entered promiscuous mode
[   35.604155] r8169 0000:05:00.0: eth0: link down
[   35.604162] r8169 0000:05:00.0: eth0: link down
[   35.605548] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   35.606343] device eth1 entered promiscuous mode
[   35.608629] eth1: link now 100 mbps, full duplex and up.
[   35.612669] br0: topology change detected, propagating
[   35.612673] br0: port 2(eth1) entering forwarding state
[   35.612675] br0: port 2(eth1) entering forwarding state
[   36.710236] RPC: Registered named UNIX socket transport module.
[   36.710238] RPC: Registered udp transport module.
[   36.710239] RPC: Registered tcp transport module.
[   36.710240] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   36.780891] FS-Cache: Loaded
[   36.806219] FS-Cache: Netfs 'nfs' registered for caching
[   36.814676] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   36.992467] fuse init (API version 7.16)
[   37.641193] usb 7-2: USB disconnect, device number 5
[   37.694020] zfs-fuse (1750): /proc/1762/oom_adj is deprecated, please use /proc/1762/oom_score_adj instead.

--------------090408050409040807000805
Content-Type: text/plain;
 name="dmidecode.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="dmidecode.txt"

# dmidecode 2.9
SMBIOS 2.6 present.
57 structures occupying 1945 bytes.
Table at 0x0009F400.

Handle 0x0000, DMI type 0, 24 bytes
BIOS Information
	Vendor: American Megatrends Inc.
	Version: V17.13
	Release Date: 06/29/2011
	Address: 0xF0000
	Runtime Size: 64 kB
	ROM Size: 1024 kB
	Characteristics:
		ISA is supported
		PCI is supported
		PNP is supported
		BIOS is upgradeable
		BIOS shadowing is allowed
		ESCD support is available
		Boot from CD is supported
		Selectable boot is supported
		BIOS ROM is socketed
		EDD is supported
		5.25"/1.2 MB floppy services are supported (int 13h)
		3.5"/720 KB floppy services are supported (int 13h)
		3.5"/2.88 MB floppy services are supported (int 13h)
		Print screen service is supported (int 5h)
		8042 keyboard services are supported (int 9h)
		Serial services are supported (int 14h)
		Printer services are supported (int 17h)
		CGA/mono video services are supported (int 10h)
		ACPI is supported
		USB legacy is supported
		LS-120 boot is supported
		ATAPI Zip drive boot is supported
		BIOS boot specification is supported
		Targeted content distribution is supported
	BIOS Revision: 8.15

Handle 0x0001, DMI type 1, 27 bytes
System Information
	Manufacturer: MSI
	Product Name: MS-7599
	Version: 3.0
	Serial Number: To Be Filled By O.E.M.
	UUID: 00000000-0000-0000-0000-6C626DE4C83A
	Wake-up Type: Power Switch
	SKU Number: To Be Filled By O.E.M.
	Family: To Be Filled By O.E.M.

Handle 0x0002, DMI type 2, 15 bytes
Base Board Information
	Manufacturer: MSI
	Product Name: 870A-G54 (MS-7599)
	Version: 3.0
	Serial Number: To be filled by O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Features:
		Board is a hosting board
		Board is replaceable
	Location In Chassis: To Be Filled By O.E.M.
	Chassis Handle: 0x0003
	Type: Motherboard
	Contained Object Handles: 0

Handle 0x0003, DMI type 3, 21 bytes
Chassis Information
	Manufacturer: MSI
	Type: Desktop
	Lock: Not Present
	Version: 3.0
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Boot-up State: Safe
	Power Supply State: Safe
	Thermal State: Safe
	Security Status: None
	OEM Information: 0x00000000
	Height: Unspecified
	Number Of Power Cords: 1
	Contained Elements: 0

Handle 0x0004, DMI type 4, 42 bytes
Processor Information
	Socket Designation: CPU1
	Type: Central Processor
	Family: <OUT OF SPEC>
	Manufacturer: AMD              
	ID: 63 0F 10 00 FF FB 8B 17
	Version: AMD Athlon(tm) II X2 250 Processor                  
	Voltage: 1.4 V
	External Clock: 200 MHz
	Max Speed: 3000 MHz
	Current Speed: 3000 MHz
	Status: Populated, Disabled By BIOS
	Upgrade: <OUT OF SPEC>
	L1 Cache Handle: 0x0005
	L2 Cache Handle: 0x0006
	L3 Cache Handle: 0x0007
	Serial Number: To Be Filled By O.E.M.
	Asset Tag: To Be Filled By O.E.M.
	Part Number: To Be Filled By O.E.M.
	Core Count: 2
	Core Enabled: 2
	Thread Count: 2
	Characteristics:
		64-bit capable

Handle 0x0005, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L1-Cache
	Configuration: Enabled, Not Socketed, Level 1
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 256 KB
	Maximum Size: 256 KB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: 1 ns
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 2-way Set-associative

Handle 0x0006, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L2-Cache
	Configuration: Enabled, Not Socketed, Level 2
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 2048 KB
	Maximum Size: 2048 KB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: 1 ns
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: 16-way Set-associative

Handle 0x0007, DMI type 7, 19 bytes
Cache Information
	Socket Designation: L3-Cache
	Configuration: Enabled, Not Socketed, Level 3
	Operational Mode: Write Back
	Location: Internal
	Installed Size: 0 KB
	Maximum Size: 0 KB
	Supported SRAM Types:
		Pipeline Burst
	Installed SRAM Type: Pipeline Burst
	Speed: 1 ns
	Error Correction Type: Multi-bit ECC
	System Type: Unified
	Associativity: Other

Handle 0x0008, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PS1
	Internal Connector Type: None
	External Reference Designator: PS2 Mouse
	External Connector Type: PS/2
	Port Type: Mouse Port

Handle 0x0009, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: PS1
	Internal Connector Type: None
	External Reference Designator: PS2 Keyboard
	External Connector Type: PS/2
	Port Type: Keyboard Port

Handle 0x000A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: COM1
	Internal Connector Type: None
	External Reference Designator: COM
	External Connector Type: DB-9 male
	Port Type: Serial Port 16550A Compatible

Handle 0x000B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: JACK1
	Internal Connector Type: None
	External Reference Designator: Audio Mic In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x000C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: JACK1
	Internal Connector Type: None
	External Reference Designator: Audio Line In
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x000D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: JACK1
	Internal Connector Type: None
	External Reference Designator: Audio Line Out
	External Connector Type: Mini Jack (headphones)
	Port Type: Audio Port

Handle 0x000E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1
	Internal Connector Type: None
	External Reference Designator: USB1
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x000F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1
	Internal Connector Type: None
	External Reference Designator: USB2
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0010, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1
	Internal Connector Type: None
	External Reference Designator: USB3
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0011, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1
	Internal Connector Type: None
	External Reference Designator: USB4
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0012, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1
	Internal Connector Type: None
	External Reference Designator: USB5
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0013, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: USB1
	Internal Connector Type: None
	External Reference Designator: USB6
	External Connector Type: Access Bus (USB)
	Port Type: USB

Handle 0x0014, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: LAN
	Internal Connector Type: None
	External Reference Designator: LAN
	External Connector Type: RJ-45
	Port Type: Network Port

Handle 0x0015, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: JBAT1
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0016, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: CD_IN1
	Internal Connector Type: On Board Sound Input From CD-ROM
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Audio Port

Handle 0x0017, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: JCI1
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x0018, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: JUSB1
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x0019, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: JUSB2
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001A, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: JUSB3
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: USB

Handle 0x001B, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: JFP1
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001C, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: JFP2
	Internal Connector Type: Other
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001D, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: FDD1
	Internal Connector Type: On Board Floppy
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001E, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: IDE1
	Internal Connector Type: On Board IDE
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: Other

Handle 0x001F, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA1
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0020, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA2
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0021, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA3
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0022, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA4
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0023, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA5
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0024, DMI type 8, 9 bytes
Port Connector Information
	Internal Reference Designator: SATA6
	Internal Connector Type: SAS/SATA Plug Receptacle
	External Reference Designator: Not Specified
	External Connector Type: None
	Port Type: SATA

Handle 0x0025, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI1
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Short
	ID: 1
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0026, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI2
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Short
	ID: 2
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0027, DMI type 9, 17 bytes
System Slot Information
	Designation: PCI3
	Type: 32-bit PCI
	Current Usage: In Use
	Length: Short
	ID: 3
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0028, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIE1
	Type: 32-bit PCI Express
	Current Usage: Available
	Length: Short
	ID: 4
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x0029, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIE2
	Type: 32-bit PCI Express
	Current Usage: Available
	Length: Short
	ID: 4
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x002A, DMI type 9, 17 bytes
System Slot Information
	Designation: PCIE3
	Type: 32-bit PCI Express
	Current Usage: Available
	Length: Short
	ID: 4
	Characteristics:
		3.3 V is provided
		Opening is shared
		PME signal is supported

Handle 0x002B, DMI type 13, 22 bytes
BIOS Language Information
	Installable Languages: 1
		en|US|iso8859-1
	Currently Installed Language: en|US|iso8859-1

Handle 0x002C, DMI type 16, 15 bytes
Physical Memory Array
	Location: System Board Or Motherboard
	Use: System Memory
	Error Correction Type: None
	Maximum Capacity: 8 GB
	Error Information Handle: Not Provided
	Number Of Devices: 4

Handle 0x002D, DMI type 19, 15 bytes
Memory Array Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x0042FFFFFFF
	Range Size: 17152 MB
	Physical Array Handle: 0x002C
	Partition Width: 0

Handle 0x002E, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM1
	Bank Locator: BANK0
	Type: Other
	Type Detail: Synchronous
	Speed: 1211 MHz (0.8 ns)
	Manufacturer: Kingston      
	Serial Number: 3A783530
	Asset Tag: AssetTagNum0
	Part Number: 99U5403-034.A00LF 

Handle 0x002F, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00000000000
	Ending Address: 0x000FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x002E
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1

Handle 0x0030, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM2
	Bank Locator: BANK1
	Type: Other
	Type Detail: Synchronous
	Speed: 1211 MHz (0.8 ns)
	Manufacturer: Kingston      
	Serial Number: 54873568
	Asset Tag: AssetTagNum1
	Part Number: 99U5403-034.A00LF 

Handle 0x0031, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00100000000
	Ending Address: 0x001FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0030
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1

Handle 0x0032, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM3
	Bank Locator: BANK2
	Type: Other
	Type Detail: Synchronous
	Speed: 1211 MHz (0.8 ns)
	Manufacturer: Kingston      
	Serial Number: 13993666
	Asset Tag: AssetTagNum2
	Part Number: 99U5403-034.A00LF 

Handle 0x0033, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00200000000
	Ending Address: 0x002FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0032
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1

Handle 0x0034, DMI type 17, 28 bytes
Memory Device
	Array Handle: 0x002C
	Error Information Handle: Not Provided
	Total Width: 64 bits
	Data Width: 64 bits
	Size: 4096 MB
	Form Factor: DIMM
	Set: None
	Locator: DIMM4
	Bank Locator: BANK3
	Type: Other
	Type Detail: Synchronous
	Speed: 1211 MHz (0.8 ns)
	Manufacturer: Kingston      
	Serial Number: 47FE3666
	Asset Tag: AssetTagNum3
	Part Number: 99U5403-034.A00LF 

Handle 0x0035, DMI type 20, 19 bytes
Memory Device Mapped Address
	Starting Address: 0x00300000000
	Ending Address: 0x003FFFFFFFF
	Range Size: 4 GB
	Physical Device Handle: 0x0034
	Memory Array Mapped Address Handle: 0x002D
	Partition Row Position: 1

Handle 0x0036, DMI type 32, 20 bytes
System Boot Information
	Status: No errors detected

Handle 0x0037, DMI type 41, 11 bytes
Unknown Type
	Header and Data:
		29 0B 37 00 01 83 00 FF FF FF FF
	Strings:
		  To Be Filled By O.E.M.

Handle 0x0038, DMI type 127, 4 bytes
End Of Table


--------------090408050409040807000805--

From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Re-add not selecting drive for correct slot?
Date: Sat, 08 Aug 2015 10:17:34 +0800
Message-ID: <14110213.gd3e4izigE@nell>
References: <1817382.9YhZ7ff5Yl@balsa> <alpine.DEB.2.02.1508071435340.11810@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart5105205.ZJp99HT058"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1508071435340.11810@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.

--nextPart5105205.ZJp99HT058
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On August 7, 2015 02:38:22 PM Mikael Abrahamsson wrote:
> On Thu, 6 Aug 2015, Thomas Fjellstrom wrote:
> > Also, sdc has a much lower event count than the other drives, is that
> > normal?
> > 
> > /dev/sdc is the first drive that failed
> > /dev/sdb is the one that was kicked after
> 
> Can you please post dmesg output from when you unplugged the drive and
> what happened to the array then? I guess you do not have "cat
> /proc/mdstat" from then? It's weird that sdb was busy. Please post mdadm
> version and kernel version.

I posted both after the logs in the previous message, but I'll repeat here:

Distro: OpenMediaVault / Debian wheezy
Kernel: 3.16.7-ckt4-3~bpo70+1
Mdadm: v3.2.5 (from debian) and v3.3.4-22-gccc93b3 - 05th August 2015

dmesg is attached. and sadly I don't have a copy of mdstat from then. I might 
have, had my laptop not been acting up. It was pretty normal for a degraded 
array, though it said it was active with two failed devices ( (F) after the 
member names), and the "pattern" was something like [__UUUUU]

Theres a lot of noise at the end of the dmesg from me messing with the array 
and filesystem. But the first failure starts at 1204733, and the second starts 
at 1729472. The first caused the device to be completely missing, where as the 
second still appeared in dev and mdraid claimed it was in use when I tried a 
re-add /before/ I tried a remove.

> The event count is increased when writes occur to the array, so that sdc
> would have a much lower event count is normal because it was out of the
> array for much longer time than sdb was.

The array had been used a fair bit after it was created, the super low event 
count on sdc makes me wonder.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
--nextPart5105205.ZJp99HT058
Content-Disposition: attachment; filename="dmesg.log"
Content-Transfer-Encoding: 7Bit
Content-Type: text/x-log; charset="UTF-8"; name="dmesg.log"

[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Initializing cgroup subsys cpuacct
[    0.000000] Linux version 3.16.0-0.bpo.4-amd64 (debian-kernel@lists.debian.org) (gcc version 4.6.3 (Debian 4.6.3-14) ) #1 SMP Debian 3.16.7-ckt4-3~bpo70+1 (2015-02-12)
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-3.16.0-0.bpo.4-amd64 root=UUID=b68b037e-e98c-484a-9490-c43e2a91178f ro quiet
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x000000000009d7ff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009d800-0x000000000009ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000000e0000-0x00000000000fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000001fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000020000000-0x00000000201fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000020200000-0x000000003fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000040000000-0x00000000401fffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000040200000-0x00000000da96dfff] usable
[    0.000000] BIOS-e820: [mem 0x00000000da96e000-0x00000000da9b7fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000da9b8000-0x00000000da9bffff] ACPI data
[    0.000000] BIOS-e820: [mem 0x00000000da9c0000-0x00000000dabaefff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dabaf000-0x00000000dabaffff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dabb0000-0x00000000dabc0fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dabc1000-0x00000000dabc3fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dabc4000-0x00000000dabd7fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dabd8000-0x00000000dabd8fff] usable
[    0.000000] BIOS-e820: [mem 0x00000000dabd9000-0x00000000dabe8fff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dabe9000-0x00000000dabf6fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dabf7000-0x00000000dac1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dac20000-0x00000000dac62fff] ACPI NVS
[    0.000000] BIOS-e820: [mem 0x00000000dac63000-0x00000000dae8dfff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000dae8e000-0x00000000daffffff] usable
[    0.000000] BIOS-e820: [mem 0x00000000db800000-0x00000000df9fffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000fed1c000-0x00000000fed1ffff] reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x000000041fdfffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] SMBIOS 2.7 present.
[    0.000000] DMI:                  /S1200KP, BIOS KPC2060H.86B.0026.2013.0103.1403 01/03/2013
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] AGP: No AGP bridge found
[    0.000000] e820: last_pfn = 0x41fe00 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: uncachable
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-D3FFF write-protect
[    0.000000]   D4000-E7FFF uncachable
[    0.000000]   E8000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 000000000 mask C00000000 write-back
[    0.000000]   1 base 400000000 mask FE0000000 write-back
[    0.000000]   2 base 0DB800000 mask FFF800000 uncachable
[    0.000000]   3 base 0DC000000 mask FFC000000 uncachable
[    0.000000]   4 base 0E0000000 mask FE0000000 uncachable
[    0.000000]   5 base 41FE00000 mask FFFE00000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000000] e820: update [mem 0xdb800000-0xffffffff] usable ==> reserved
[    0.000000] e820: last_pfn = 0xdb000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fce20-0x000fce2f] mapped at [ffff8800000fce20]
[    0.000000] Base memory trampoline at [ffff880000097000] 97000 size 24576
[    0.000000] reserving inaccessible SNB gfx pages
[    0.000000] init_memory_mapping: [mem 0x00000000-0x000fffff]
[    0.000000]  [mem 0x00000000-0x000fffff] page 4k
[    0.000000] BRK [0x01af2000, 0x01af2fff] PGTABLE
[    0.000000] BRK [0x01af3000, 0x01af3fff] PGTABLE
[    0.000000] BRK [0x01af4000, 0x01af4fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41fc00000-0x41fdfffff]
[    0.000000]  [mem 0x41fc00000-0x41fdfffff] page 2M
[    0.000000] BRK [0x01af5000, 0x01af5fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0x41c000000-0x41fbfffff]
[    0.000000]  [mem 0x41c000000-0x41fbfffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x400000000-0x41bffffff]
[    0.000000]  [mem 0x400000000-0x41bffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x00100000-0x1fffffff]
[    0.000000]  [mem 0x00100000-0x001fffff] page 4k
[    0.000000]  [mem 0x00200000-0x1fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x20200000-0x3fffffff]
[    0.000000]  [mem 0x20200000-0x3fffffff] page 2M
[    0.000000] init_memory_mapping: [mem 0x40200000-0xda96dfff]
[    0.000000]  [mem 0x40200000-0xda7fffff] page 2M
[    0.000000]  [mem 0xda800000-0xda96dfff] page 4k
[    0.000000] BRK [0x01af6000, 0x01af6fff] PGTABLE
[    0.000000] BRK [0x01af7000, 0x01af7fff] PGTABLE
[    0.000000] init_memory_mapping: [mem 0xdabd8000-0xdabd8fff]
[    0.000000]  [mem 0xdabd8000-0xdabd8fff] page 4k
[    0.000000] init_memory_mapping: [mem 0xdae8e000-0xdaffffff]
[    0.000000]  [mem 0xdae8e000-0xdaffffff] page 4k
[    0.000000] init_memory_mapping: [mem 0x100000000-0x3ffffffff]
[    0.000000]  [mem 0x100000000-0x3ffffffff] page 2M
[    0.000000] RAMDISK: [mem 0x35c54000-0x36e21fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x00000000000F0450 000024 (v02 INTEL )
[    0.000000] ACPI: XSDT 0x00000000DA9B8078 00006C (v01 INTEL  S1200KP  00000026 AMI  00010013)
[    0.000000] ACPI: FACP 0x00000000DA9BF4E8 0000F4 (v04 INTEL  S1200KP  00000026 AMI  00010013)
[    0.000000] ACPI: DSDT 0x00000000DA9B8170 007373 (v02 INTEL  S1200KP  00000026 INTL 20051117)
[    0.000000] ACPI: FACS 0x00000000DABEEF80 000040
[    0.000000] ACPI: APIC 0x00000000DA9BF5E0 000072 (v03 INTEL  S1200KP  00000026 AMI  00010013)
[    0.000000] ACPI: SSDT 0x00000000DA9BF658 000102 (v01 INTEL  S1200KP  00000026 MSFT 03000001)
[    0.000000] ACPI: MCFG 0x00000000DA9BF760 00003C (v01 INTEL  S1200KP  00000026 MSFT 00000097)
[    0.000000] ACPI: HPET 0x00000000DA9BF7A0 000038 (v01 INTEL  S1200KP  00000026 AMI. 00000004)
[    0.000000] ACPI: EINJ 0x00000000DA9BF7D8 000130 (v01 INTEL  S1200KP  00000026      00000000)
[    0.000000] ACPI: ERST 0x00000000DA9BF908 000210 (v01 INTEL  S1200KP  00000026      00000000)
[    0.000000] ACPI: HEST 0x00000000DA9BFB18 0000A8 (v01 INTEL  S1200KP  00000026      00000000)
[    0.000000] ACPI: BERT 0x00000000DA9BFBC0 000030 (v01 INTEL  S1200KP  00000026      00000000)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x000000041fdfffff]
[    0.000000] Initmem setup node 0 [mem 0x00000000-0x41fdfffff]
[    0.000000]   NODE_DATA [mem 0x41fdeb000-0x41fdeffff]
[    0.000000]  [ffffea0000000000-ffffea000e7fffff] PMD -> [ffff88040f400000-ffff88041d5fffff] on node 0
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x00001000-0x00ffffff]
[    0.000000]   DMA32    [mem 0x01000000-0xffffffff]
[    0.000000]   Normal   [mem 0x100000000-0x41fdfffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x00001000-0x0009cfff]
[    0.000000]   node   0: [mem 0x00100000-0x1fffffff]
[    0.000000]   node   0: [mem 0x20200000-0x3fffffff]
[    0.000000]   node   0: [mem 0x40200000-0xda96dfff]
[    0.000000]   node   0: [mem 0xdabd8000-0xdabd8fff]
[    0.000000]   node   0: [mem 0xdae8e000-0xdaffffff]
[    0.000000]   node   0: [mem 0x100000000-0x41fdfffff]
[    0.000000] On node 0 totalpages: 4170877
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 156 pages reserved
[    0.000000]   DMA zone: 3996 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 12177 pages used for memmap
[    0.000000]   DMA32 zone: 890593 pages, LIFO batch:31
[    0.000000]   Normal zone: 44793 pages used for memmap
[    0.000000]   Normal zone: 3276288 pages, LIFO batch:31
[    0.000000] Reserving Intel graphics stolen memory at 0xdba00000-0xdf9fffff
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] enabled)
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0xff] high edge lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x00] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 0, version 32, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 4 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: [mem 0x0009d000-0x0009dfff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009e000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000dffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000e0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x20000000-0x201fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x40000000-0x401fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xda96e000-0xda9b7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xda9b8000-0xda9bffff]
[    0.000000] PM: Registered nosave memory: [mem 0xda9c0000-0xdabaefff]
[    0.000000] PM: Registered nosave memory: [mem 0xdabaf000-0xdabaffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdabb0000-0xdabc0fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdabc1000-0xdabc3fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdabc4000-0xdabd7fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdabd9000-0xdabe8fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdabe9000-0xdabf6fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdabf7000-0xdac1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdac20000-0xdac62fff]
[    0.000000] PM: Registered nosave memory: [mem 0xdac63000-0xdae8dfff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb000000-0xdb7fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdb800000-0xdf9fffff]
[    0.000000] PM: Registered nosave memory: [mem 0xdfa00000-0xfed1bfff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed1c000-0xfed1ffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfed20000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0xdfa00000-0xfed1bfff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] setup_percpu: NR_CPUS:512 nr_cpumask_bits:512 nr_cpu_ids:4 nr_node_ids:1
[    0.000000] PERCPU: Embedded 27 pages/cpu @ffff88041fa00000 s81664 r8192 d20736 u524288
[    0.000000] pcpu-alloc: s81664 r8192 d20736 u524288 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 4113695
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-3.16.0-0.bpo.4-amd64 root=UUID=b68b037e-e98c-484a-9490-c43e2a91178f ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] xsave: enabled xstate_bv 0x7, cntxt size 0x340
[    0.000000] AGP: Checking aperture...
[    0.000000] AGP: No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 16355172K/16683508K available (5434K kernel code, 937K rwdata, 1828K rodata, 1204K init, 840K bss, 328336K reserved)
[    0.000000] Hierarchical RCU implementation.
[    0.000000] 	RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000] 	RCU restricting CPUs from NR_CPUS=512 to nr_cpu_ids=4.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=16, nr_cpu_ids=4
[    0.000000] NR_IRQS:33024 nr_irqs:712 16
[    0.000000] Console: colour VGA+ 80x25
[    0.000000] console [tty0] enabled
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Fast TSC calibration using PIT
[    0.000000] tsc: Detected 3292.517 MHz processor
[    0.000026] Calibrating delay loop (skipped), value calculated using timer frequency.. 6585.03 BogoMIPS (lpj=13170068)
[    0.000027] pid_max: default: 32768 minimum: 301
[    0.000033] ACPI: Core revision 20140424
[    0.003170] ACPI: All ACPI Tables successfully acquired
[    0.227619] Security Framework initialized
[    0.227625] AppArmor: AppArmor disabled by boot time parameter
[    0.227626] Yama: disabled by default; enable with sysctl kernel.yama.*
[    0.228364] Dentry cache hash table entries: 2097152 (order: 12, 16777216 bytes)
[    0.230839] Inode-cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.231901] Mount-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.231915] Mountpoint-cache hash table entries: 32768 (order: 6, 262144 bytes)
[    0.232122] Initializing cgroup subsys memory
[    0.232126] Initializing cgroup subsys devices
[    0.232131] Initializing cgroup subsys freezer
[    0.232133] Initializing cgroup subsys net_cls
[    0.232136] Initializing cgroup subsys blkio
[    0.232138] Initializing cgroup subsys perf_event
[    0.232140] Initializing cgroup subsys net_prio
[    0.232159] CPU: Physical Processor ID: 0
[    0.232159] CPU: Processor Core ID: 0
[    0.232163] ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
[    0.232163] ENERGY_PERF_BIAS: View and update with x86_energy_perf_policy(8)
[    0.232165] mce: CPU supports 7 MCE banks
[    0.232174] CPU0: Thermal monitoring enabled (TM1)
[    0.232181] Last level iTLB entries: 4KB 512, 2MB 8, 4MB 8
[    0.232181] Last level dTLB entries: 4KB 512, 2MB 32, 4MB 32, 1GB 0
[    0.232181] tlb_flushall_shift: 6
[    0.232257] Freeing SMP alternatives memory: 20K (ffffffff81a19000 - ffffffff81a1e000)
[    0.233250] ftrace: allocating 21585 entries in 85 pages
[    0.240828] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.280511] smpboot: CPU0: Intel(R) Core(TM) i3-2120 CPU @ 3.30GHz (fam: 06, model: 2a, stepping: 07)
[    0.280518] TSC deadline timer enabled
[    0.280539] Performance Events: PEBS fmt1+, 16-deep LBR, SandyBridge events, full-width counters, Intel PMU driver.
[    0.280554] ... version:                3
[    0.280555] ... bit width:              48
[    0.280556] ... generic registers:      4
[    0.280556] ... value mask:             0000ffffffffffff
[    0.280557] ... max period:             0000ffffffffffff
[    0.280558] ... fixed-purpose events:   3
[    0.280559] ... event mask:             000000070000000f
[    0.281580] x86: Booting SMP configuration:
[    0.281582] .... node  #0, CPUs:      #1
[    0.294753] NMI watchdog: enabled on all CPUs, permanently consumes one hw-PMU counter.
[    0.294836]  #2 #3
[    0.321207] x86: Booted up 1 node, 4 CPUs
[    0.321210] smpboot: Total of 4 processors activated (26340.13 BogoMIPS)
[    0.323625] devtmpfs: initialized
[    0.326381] PM: Registering ACPI NVS region [mem 0xda96e000-0xda9b7fff] (303104 bytes)
[    0.326387] PM: Registering ACPI NVS region [mem 0xdabaf000-0xdabaffff] (4096 bytes)
[    0.326388] PM: Registering ACPI NVS region [mem 0xdabc1000-0xdabc3fff] (12288 bytes)
[    0.326390] PM: Registering ACPI NVS region [mem 0xdabe9000-0xdabf6fff] (57344 bytes)
[    0.326391] PM: Registering ACPI NVS region [mem 0xdac20000-0xdac62fff] (274432 bytes)
[    0.327040] pinctrl core: initialized pinctrl subsystem
[    0.327100] NET: Registered protocol family 16
[    0.327189] cpuidle: using governor ladder
[    0.327190] cpuidle: using governor menu
[    0.327223] ACPI: bus type PCI registered
[    0.327224] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.327293] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.327295] PCI: not using MMCONFIG
[    0.327296] PCI: Using configuration type 1 for base access
[    0.337564] ACPI: Added _OSI(Module Device)
[    0.337565] ACPI: Added _OSI(Processor Device)
[    0.337566] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.337567] ACPI: Added _OSI(Processor Aggregator Device)
[    0.338894] ACPI: Executed 1 blocks of module-level executable AML code
[    0.340729] ACPI: Dynamic OEM Table Load:
[    0.340733] ACPI: SSDT 0xFFFF88040ECFCC00 0003E0 (v01 AMI    IST      00000001 MSFT 03000001)
[    0.340985] ACPI: Dynamic OEM Table Load:
[    0.340988] ACPI: SSDT 0xFFFF88040ECF4C00 000120 (v01 AMI    CST      00000001 MSFT 03000001)
[    0.341494] ACPI: Interpreter enabled
[    0.341498] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] (20140424/hwxface-580)
[    0.341501] ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] (20140424/hwxface-580)
[    0.341509] ACPI: (supports S0 S3 S4 S5)
[    0.341510] ACPI: Using IOAPIC for interrupt routing
[    0.341524] PCI: MMCONFIG for domain 0000 [bus 00-3f] at [mem 0xf8000000-0xfbffffff] (base 0xf8000000)
[    0.341563] PCI: MMCONFIG at [mem 0xf8000000-0xfbffffff] reserved in ACPI motherboard resources
[    0.341657] HEST: Table parsing has been initialized.
[    0.341659] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    0.341761] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    0.345525] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.345529] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM ClockPM Segments MSI]
[    0.345670] acpi PNP0A08:00: _OSC: OS now controls [PCIeHotplug PME AER PCIeCapability]
[    0.345817] acpi PNP0A08:00: [Firmware Info]: MMCONFIG for domain 0000 [bus 00-3f] only partially covers this bridge
[    0.345945] PCI host bridge to bus 0000:00
[    0.345947] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.345948] pci_bus 0000:00: root bus resource [io  0x0000-0x03af]
[    0.345950] pci_bus 0000:00: root bus resource [io  0x03e0-0x0cf7]
[    0.345951] pci_bus 0000:00: root bus resource [io  0x03b0-0x03df]
[    0.345952] pci_bus 0000:00: root bus resource [io  0x0d00-0xffff]
[    0.345953] pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff]
[    0.345954] pci_bus 0000:00: root bus resource [mem 0x000c0000-0x000dffff]
[    0.345956] pci_bus 0000:00: root bus resource [mem 0xdfa00000-0xffffffff]
[    0.345962] pci 0000:00:00.0: [8086:0100] type 00 class 0x060000
[    0.346029] pci 0000:00:01.0: [8086:0101] type 01 class 0x060400
[    0.346053] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.346080] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.346115] pci 0000:00:02.0: [8086:0102] type 00 class 0x030000
[    0.346123] pci 0000:00:02.0: reg 0x10: [mem 0xfe000000-0xfe3fffff 64bit]
[    0.346127] pci 0000:00:02.0: reg 0x18: [mem 0xe0000000-0xefffffff 64bit pref]
[    0.346131] pci 0000:00:02.0: reg 0x20: [io  0xf000-0xf03f]
[    0.346213] pci 0000:00:16.0: [8086:1c3a] type 00 class 0x078000
[    0.346234] pci 0000:00:16.0: reg 0x10: [mem 0xfe625000-0xfe62500f 64bit]
[    0.346305] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.346375] pci 0000:00:19.0: [8086:1502] type 00 class 0x020000
[    0.346392] pci 0000:00:19.0: reg 0x10: [mem 0xfe600000-0xfe61ffff]
[    0.346400] pci 0000:00:19.0: reg 0x14: [mem 0xfe624000-0xfe624fff]
[    0.346407] pci 0000:00:19.0: reg 0x18: [io  0xf080-0xf09f]
[    0.346466] pci 0000:00:19.0: PME# supported from D0 D3hot D3cold
[    0.346497] pci 0000:00:19.0: System wakeup disabled by ACPI
[    0.346535] pci 0000:00:1a.0: [8086:1c2d] type 00 class 0x0c0320
[    0.346554] pci 0000:00:1a.0: reg 0x10: [mem 0xfe623000-0xfe6233ff]
[    0.346639] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.346672] pci 0000:00:1a.0: System wakeup disabled by ACPI
[    0.346706] pci 0000:00:1c.0: [8086:1c10] type 01 class 0x060400
[    0.346784] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.346818] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.346852] pci 0000:00:1c.1: [8086:1c12] type 01 class 0x060400
[    0.346929] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.346964] pci 0000:00:1c.1: System wakeup disabled by ACPI
[    0.347006] pci 0000:00:1d.0: [8086:1c26] type 00 class 0x0c0320
[    0.347026] pci 0000:00:1d.0: reg 0x10: [mem 0xfe622000-0xfe6223ff]
[    0.347111] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.347143] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.347176] pci 0000:00:1e.0: [8086:244e] type 01 class 0x060401
[    0.347245] pci 0000:00:1e.0: System wakeup disabled by ACPI
[    0.347279] pci 0000:00:1f.0: [8086:1c56] type 00 class 0x060100
[    0.347435] pci 0000:00:1f.2: [8086:1c02] type 00 class 0x010601
[    0.347452] pci 0000:00:1f.2: reg 0x10: [io  0xf0d0-0xf0d7]
[    0.347459] pci 0000:00:1f.2: reg 0x14: [io  0xf0c0-0xf0c3]
[    0.347467] pci 0000:00:1f.2: reg 0x18: [io  0xf0b0-0xf0b7]
[    0.347478] pci 0000:00:1f.2: reg 0x1c: [io  0xf0a0-0xf0a3]
[    0.347485] pci 0000:00:1f.2: reg 0x20: [io  0xf060-0xf07f]
[    0.347493] pci 0000:00:1f.2: reg 0x24: [mem 0xfe621000-0xfe6217ff]
[    0.347534] pci 0000:00:1f.2: PME# supported from D3hot
[    0.347598] pci 0000:00:1f.3: [8086:1c22] type 00 class 0x0c0500
[    0.347612] pci 0000:00:1f.3: reg 0x10: [mem 0xfe620000-0xfe6200ff 64bit]
[    0.347631] pci 0000:00:1f.3: reg 0x20: [io  0xf040-0xf05f]
[    0.347727] pci 0000:01:00.0: [1000:0072] type 00 class 0x010700
[    0.347735] pci 0000:01:00.0: reg 0x10: [io  0xe000-0xe0ff]
[    0.347742] pci 0000:01:00.0: reg 0x14: [mem 0xfe5c0000-0xfe5c3fff 64bit]
[    0.347749] pci 0000:01:00.0: reg 0x1c: [mem 0xfe580000-0xfe5bffff 64bit]
[    0.347759] pci 0000:01:00.0: reg 0x30: [mem 0xfe500000-0xfe57ffff pref]
[    0.347791] pci 0000:01:00.0: supports D1 D2
[    0.347806] pci 0000:01:00.0: reg 0x174: [mem 0x00000000-0x00003fff 64bit]
[    0.347812] pci 0000:01:00.0: reg 0x17c: [mem 0x00000000-0x0003ffff 64bit]
[    0.355490] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.355494] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.355497] pci 0000:00:01.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.355594] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.355690] pci 0000:03:00.0: [8086:10d3] type 00 class 0x020000
[    0.355727] pci 0000:03:00.0: reg 0x10: [mem 0xfe400000-0xfe41ffff]
[    0.355770] pci 0000:03:00.0: reg 0x18: [io  0xd000-0xd01f]
[    0.355793] pci 0000:03:00.0: reg 0x1c: [mem 0xfe420000-0xfe423fff]
[    0.355998] pci 0000:03:00.0: PME# supported from D0 D3hot D3cold
[    0.363504] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.363510] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.363515] pci 0000:00:1c.1:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.363617] pci 0000:00:1e.0: PCI bridge to [bus 04] (subtractive decode)
[    0.363626] pci 0000:00:1e.0:   bridge window [io  0x0000-0x03af] (subtractive decode)
[    0.363627] pci 0000:00:1e.0:   bridge window [io  0x03e0-0x0cf7] (subtractive decode)
[    0.363628] pci 0000:00:1e.0:   bridge window [io  0x03b0-0x03df] (subtractive decode)
[    0.363629] pci 0000:00:1e.0:   bridge window [io  0x0d00-0xffff] (subtractive decode)
[    0.363631] pci 0000:00:1e.0:   bridge window [mem 0x000a0000-0x000bffff] (subtractive decode)
[    0.363632] pci 0000:00:1e.0:   bridge window [mem 0x000c0000-0x000dffff] (subtractive decode)
[    0.363633] pci 0000:00:1e.0:   bridge window [mem 0xdfa00000-0xffffffff] (subtractive decode)
[    0.364049] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 10 *11 12 14 15)
[    0.364086] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 10 11 12 14 15)
[    0.364122] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 *11 12 14 15)
[    0.364157] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 *4 5 6 10 11 12 14 15)
[    0.364192] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 *10 11 12 14 15)
[    0.364227] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.364263] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 10 11 12 14 15) *0
[    0.364298] ACPI: PCI Interrupt Link [LNKH] (IRQs *3 4 5 6 7 10 11 12 14 15)
[    0.364363] ACPI: Enabled 3 GPEs in block 00 to 3F
[    0.364452] vgaarb: setting as boot device: PCI:0000:00:02.0
[    0.364453] vgaarb: device added: PCI:0000:00:02.0,decodes=io+mem,owns=io+mem,locks=none
[    0.364455] vgaarb: loaded
[    0.364456] vgaarb: bridge control possible 0000:00:02.0
[    0.364498] PCI: Using ACPI for IRQ routing
[    0.365941] PCI: pci_cache_line_size set to 64 bytes
[    0.365979] e820: reserve RAM buffer [mem 0x0009d800-0x0009ffff]
[    0.365980] e820: reserve RAM buffer [mem 0xda96e000-0xdbffffff]
[    0.365982] e820: reserve RAM buffer [mem 0xdabd9000-0xdbffffff]
[    0.365983] e820: reserve RAM buffer [mem 0xdb000000-0xdbffffff]
[    0.365984] e820: reserve RAM buffer [mem 0x41fe00000-0x41fffffff]
[    0.366099] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.366103] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.368126] Switched to clocksource hpet
[    0.371887] pnp: PnP ACPI init
[    0.371904] ACPI: bus type PNP registered
[    0.372006] system 00:00: [mem 0xfed10000-0xfed19fff] has been reserved
[    0.372008] system 00:00: [mem 0xf8000000-0xfbffffff] has been reserved
[    0.372009] system 00:00: [mem 0xfed90000-0xfed93fff] has been reserved
[    0.372010] system 00:00: [mem 0xfed20000-0xfed3ffff] has been reserved
[    0.372012] system 00:00: [mem 0xfee00000-0xfee0ffff] has been reserved
[    0.372014] system 00:00: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.372132] system 00:01: [io  0x0290-0x029f] has been reserved
[    0.372133] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.372344] pnp 00:02: Plug and Play ACPI device, IDs PNP0b00 (active)
[    0.372385] system 00:03: [io  0x04d0-0x04d1] has been reserved
[    0.372387] system 00:03: Plug and Play ACPI device, IDs PNP0c02 (active)
[    0.372513] system 00:04: [io  0x0400-0x0453] could not be reserved
[    0.372515] system 00:04: [io  0x0458-0x047f] has been reserved
[    0.372516] system 00:04: [io  0x1180-0x119f] has been reserved
[    0.372518] system 00:04: [io  0x0500-0x057f] has been reserved
[    0.372519] system 00:04: [mem 0xfed1c000-0xfed1ffff] has been reserved
[    0.372521] system 00:04: [mem 0xfec00000-0xfecfffff] could not be reserved
[    0.372522] system 00:04: [mem 0xfed08000-0xfed08fff] has been reserved
[    0.372524] system 00:04: [mem 0xff000000-0xffffffff] has been reserved
[    0.372525] system 00:04: Plug and Play ACPI device, IDs PNP0c01 (active)
[    0.372568] system 00:05: [io  0x0454-0x0457] has been reserved
[    0.372570] system 00:05: Plug and Play ACPI device, IDs INT3f0d PNP0c02 (active)
[    0.372710] pnp: PnP ACPI: found 6 devices
[    0.372711] ACPI: bus type PNP unregistered
[    0.379103] pci_bus 0000:00: max bus depth: 1 pci_try_num: 2
[    0.379135] pci 0000:01:00.0: reg 0x174: [mem 0x00000000-0x00003fff 64bit]
[    0.379142] pci 0000:01:00.0: reg 0x17c: [mem 0x00000000-0x0003ffff 64bit]
[    0.379148] pci 0000:01:00.0: reg 0x174: [mem 0x00000000-0x00003fff 64bit]
[    0.379154] pci 0000:01:00.0: reg 0x17c: [mem 0x00000000-0x0003ffff 64bit]
[    0.379157] pci 0000:01:00.0: BAR 9: can't assign mem (size 0x400000)
[    0.379164] pci 0000:01:00.0: reg 0x174: [mem 0x00000000-0x00003fff 64bit]
[    0.379166] pci 0000:01:00.0: BAR 7: can't assign mem (size 0x40000)
[    0.379167] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.379169] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.379171] pci 0000:00:01.0:   bridge window [mem 0xfe500000-0xfe5fffff]
[    0.379174] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.379185] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.379188] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.379192] pci 0000:00:1c.1:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.379200] pci 0000:00:1e.0: PCI bridge to [bus 04]
[    0.379210] pci_bus 0000:00: No. 2 try to assign unassigned res
[    0.379211] release child resource [mem 0xfe500000-0xfe57ffff pref]
[    0.379212] release child resource [mem 0xfe580000-0xfe5bffff 64bit]
[    0.379212] release child resource [mem 0xfe5c0000-0xfe5c3fff 64bit]
[    0.379214] pci 0000:00:01.0: resource 14 [mem 0xfe500000-0xfe5fffff] released
[    0.379215] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.379220] pci 0000:00:01.0: bridge window [mem 0x00100000-0x001fffff] to [bus 01] add_size 500000
[    0.379240] pci 0000:00:01.0: res[14]=[mem 0x00100000-0x001fffff] get_res_add_size add_size 500000
[    0.379242] pci 0000:00:01.0: BAR 14: assigned [mem 0xdfa00000-0xdfffffff]
[    0.379249] pci 0000:01:00.0: reg 0x174: [mem 0x00000000-0x00003fff 64bit]
[    0.379255] pci 0000:01:00.0: reg 0x17c: [mem 0x00000000-0x0003ffff 64bit]
[    0.379257] pci 0000:01:00.0: res[9]=[mem size 0x00000000 64bit] get_res_add_size add_size 400000
[    0.379258] pci 0000:01:00.0: res[7]=[mem size 0x00000000 64bit] get_res_add_size add_size 40000
[    0.379260] pci 0000:01:00.0: BAR 6: assigned [mem 0xdfa00000-0xdfa7ffff pref]
[    0.379262] pci 0000:01:00.0: BAR 3: assigned [mem 0xdfa80000-0xdfabffff 64bit]
[    0.379272] pci 0000:01:00.0: reg 0x17c: [mem 0x00000000-0x0003ffff 64bit]
[    0.379273] pci 0000:01:00.0: BAR 9: assigned [mem 0xdfac0000-0xdfebffff 64bit]
[    0.379278] pci 0000:01:00.0: BAR 1: assigned [mem 0xdfec0000-0xdfec3fff 64bit]
[    0.379288] pci 0000:01:00.0: reg 0x174: [mem 0x00000000-0x00003fff 64bit]
[    0.379290] pci 0000:01:00.0: BAR 7: assigned [mem 0xdfec4000-0xdff03fff 64bit]
[    0.379295] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.379296] pci 0000:00:01.0:   bridge window [io  0xe000-0xefff]
[    0.379298] pci 0000:00:01.0:   bridge window [mem 0xdfa00000-0xdfffffff]
[    0.379301] pci 0000:00:1c.0: PCI bridge to [bus 02]
[    0.379311] pci 0000:00:1c.1: PCI bridge to [bus 03]
[    0.379314] pci 0000:00:1c.1:   bridge window [io  0xd000-0xdfff]
[    0.379319] pci 0000:00:1c.1:   bridge window [mem 0xfe400000-0xfe4fffff]
[    0.379326] pci 0000:00:1e.0: PCI bridge to [bus 04]
[    0.379336] pci_bus 0000:00: resource 4 [io  0x0000-0x03af]
[    0.379337] pci_bus 0000:00: resource 5 [io  0x03e0-0x0cf7]
[    0.379338] pci_bus 0000:00: resource 6 [io  0x03b0-0x03df]
[    0.379339] pci_bus 0000:00: resource 7 [io  0x0d00-0xffff]
[    0.379341] pci_bus 0000:00: resource 8 [mem 0x000a0000-0x000bffff]
[    0.379342] pci_bus 0000:00: resource 9 [mem 0x000c0000-0x000dffff]
[    0.379343] pci_bus 0000:00: resource 10 [mem 0xdfa00000-0xffffffff]
[    0.379344] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    0.379346] pci_bus 0000:01: resource 1 [mem 0xdfa00000-0xdfffffff]
[    0.379347] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    0.379348] pci_bus 0000:03: resource 1 [mem 0xfe400000-0xfe4fffff]
[    0.379350] pci_bus 0000:04: resource 4 [io  0x0000-0x03af]
[    0.379351] pci_bus 0000:04: resource 5 [io  0x03e0-0x0cf7]
[    0.379352] pci_bus 0000:04: resource 6 [io  0x03b0-0x03df]
[    0.379353] pci_bus 0000:04: resource 7 [io  0x0d00-0xffff]
[    0.379354] pci_bus 0000:04: resource 8 [mem 0x000a0000-0x000bffff]
[    0.379355] pci_bus 0000:04: resource 9 [mem 0x000c0000-0x000dffff]
[    0.379356] pci_bus 0000:04: resource 10 [mem 0xdfa00000-0xffffffff]
[    0.379406] NET: Registered protocol family 2
[    0.379617] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.379807] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.379911] TCP: Hash tables configured (established 131072 bind 65536)
[    0.379929] TCP: reno registered
[    0.379943] UDP hash table entries: 8192 (order: 6, 262144 bytes)
[    0.379989] UDP-Lite hash table entries: 8192 (order: 6, 262144 bytes)
[    0.380084] NET: Registered protocol family 1
[    0.380108] pci 0000:00:02.0: BIOS left Intel GPU interrupts enabled; disabling
[    0.380118] pci 0000:00:02.0: Video device with shadowed ROM
[    0.380345] PCI: CLS 64 bytes, default 64
[    0.380383] Unpacking initramfs...
[    0.606196] Freeing initrd memory: 18232K (ffff880035c54000 - ffff880036e22000)
[    0.606207] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.606209] software IO TLB [mem 0xd696e000-0xda96e000] (64MB) mapped at [ffff8800d696e000-ffff8800da96dfff]
[    0.606432] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.606469] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x28
[    0.606472] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x28
[    0.606478] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x28
[    0.606484] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x28
[    0.606538] microcode: Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    0.606760] futex hash table entries: 1024 (order: 4, 65536 bytes)
[    0.606785] audit: initializing netlink subsys (disabled)
[    0.606799] audit: type=2000 audit(1437188882.384:1): initialized
[    0.607078] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.607092] zbud: loaded
[    0.607241] VFS: Disk quotas dquot_6.5.2
[    0.607254] Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
[    0.607297] msgmni has been set to 31979
[    0.607548] alg: No test for stdrng (krng)
[    0.607571] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
[    0.607616] io scheduler noop registered
[    0.607618] io scheduler deadline registered
[    0.607649] io scheduler cfq registered (default)
[    0.607768] pcieport 0000:00:01.0: irq 40 for MSI/MSI-X
[    0.607867] pcieport 0000:00:1c.0: irq 41 for MSI/MSI-X
[    0.607977] pcieport 0000:00:1c.1: irq 42 for MSI/MSI-X
[    0.608052] pcieport 0000:00:01.0: Signaling PME through PCIe PME interrupt
[    0.608054] pci 0000:01:00.0: Signaling PME through PCIe PME interrupt
[    0.608055] pcie_pme 0000:00:01.0:pcie01: service driver pcie_pme loaded
[    0.608072] pcieport 0000:00:1c.0: Signaling PME through PCIe PME interrupt
[    0.608076] pcie_pme 0000:00:1c.0:pcie01: service driver pcie_pme loaded
[    0.608092] pcieport 0000:00:1c.1: Signaling PME through PCIe PME interrupt
[    0.608093] pci 0000:03:00.0: Signaling PME through PCIe PME interrupt
[    0.608097] pcie_pme 0000:00:1c.1:pcie01: service driver pcie_pme loaded
[    0.608108] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.608137] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    0.608170] intel_idle: MWAIT substates: 0x1120
[    0.608171] intel_idle: v0.4 model 0x2A
[    0.608172] intel_idle: lapic_timer_reliable_states 0xffffffff
[    0.608322] ERST: Can not request [mem 0xdabc103f-0xdabc303e] for ERST.
[    0.636172] [Firmware Warn]: GHES: Poll interval is 0 for generic hardware error source: 1, disabled.
[    0.636218] GHES: APEI firmware first mode is enabled by WHEA _OSC.
[    0.636280] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    0.636589] Linux agpgart interface v0.103
[    0.636668] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    0.639738] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.639741] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.639837] mousedev: PS/2 mouse device common for all mice
[    0.639862] rtc_cmos 00:02: RTC can wake from S4
[    0.639984] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[    0.640011] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvram, hpet irqs
[    0.640019] Intel P-state driver initializing.
[    0.640031] Intel pstate controlling: cpu 0
[    0.640046] Intel pstate controlling: cpu 1
[    0.640061] Intel pstate controlling: cpu 2
[    0.640084] Intel pstate controlling: cpu 3
[    0.640142] ledtrig-cpu: registered to indicate activity on CPUs
[    0.640539] AMD IOMMUv2 driver by Joerg Roedel <joerg.roedel@amd.com>
[    0.640540] AMD IOMMUv2 functionality not available on this system
[    0.640660] TCP: cubic registered
[    0.640750] NET: Registered protocol family 10
[    0.641010] mip6: Mobile IPv6
[    0.641015] NET: Registered protocol family 17
[    0.641022] mpls_gso: MPLS GSO support
[    0.641460] registered taskstats version 1
[    0.642013] rtc_cmos 00:02: setting system clock to 2015-07-18 03:08:03 UTC (1437188883)
[    0.642152] PM: Hibernation image not present or could not be loaded.
[    0.643516] Freeing unused kernel memory: 1204K (ffffffff818ec000 - ffffffff81a19000)
[    0.643518] Write protecting the kernel read-only data: 8192k
[    0.645771] Freeing unused kernel memory: 700K (ffff880001551000 - ffff880001600000)
[    0.646465] Freeing unused kernel memory: 220K (ffff8800017c9000 - ffff880001800000)
[    0.655179] udevd[69]: starting version 175
[    0.667251] pps_core: LinuxPPS API ver. 1 registered
[    0.667254] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
[    0.667281] SCSI subsystem initialized
[    0.667473] PTP clock support registered
[    0.668260] e1000e: Intel(R) PRO/1000 Network Driver - 2.3.2-k
[    0.668263] e1000e: Copyright(c) 1999 - 2014 Intel Corporation.
[    0.668416] e1000e 0000:00:19.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.668438] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[    0.670913] ACPI: bus type USB registered
[    0.670945] usbcore: registered new interface driver usbfs
[    0.670958] usbcore: registered new interface driver hub
[    0.677223] mpt2sas version 16.100.00.00 loaded
[    0.678835] usbcore: registered new device driver usb
[    0.679248] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.679390] ehci-pci: EHCI PCI platform driver
[    0.688534] scsi0 : Fusion MPT SAS Host
[    0.692963] mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (16375548 kB)
[    0.693000] mpt2sas 0000:01:00.0: irq 44 for MSI/MSI-X
[    0.693023] mpt2sas0-msix0: PCI-MSI-X enabled: IRQ 44
[    0.693025] mpt2sas0: iomem(0x00000000dfec0000), mapped(0xffffc90005b60000), size(16384)
[    0.693027] mpt2sas0: ioport(0x000000000000e000), size(256)
[    0.697044] libata version 3.00 loaded.
[    0.946323] e1000e 0000:00:19.0 eth0: registered PHC clock
[    0.946331] e1000e 0000:00:19.0 eth0: (PCI Express:2.5GT/s:Width x1) 38:60:77:9c:29:d7
[    0.946335] e1000e 0000:00:19.0 eth0: Intel(R) PRO/1000 Network Connection
[    0.946373] e1000e 0000:00:19.0 eth0: MAC: 10, PHY: 11, PBA No: FFFFFF-0FF
[    0.946599] ehci-pci 0000:00:1a.0: EHCI Host Controller
[    0.946609] ehci-pci 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    0.946635] ehci-pci 0000:00:1a.0: debug port 2
[    0.946644] e1000e 0000:03:00.0: Interrupt Throttling Rate (ints/sec) set to dynamic conservative mode
[    0.946678] e1000e 0000:03:00.0: irq 45 for MSI/MSI-X
[    0.946682] e1000e 0000:03:00.0: irq 46 for MSI/MSI-X
[    0.946686] e1000e 0000:03:00.0: irq 47 for MSI/MSI-X
[    0.950553] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
[    0.950575] ehci-pci 0000:00:1a.0: irq 16, io mem 0xfe623000
[    0.960183] ehci-pci 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    0.960252] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    0.960255] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.960257] usb usb1: Product: EHCI Host Controller
[    0.960268] usb usb1: Manufacturer: Linux 3.16.0-0.bpo.4-amd64 ehci_hcd
[    0.960270] usb usb1: SerialNumber: 0000:00:1a.0
[    0.960543] hub 1-0:1.0: USB hub found
[    0.960552] hub 1-0:1.0: 2 ports detected
[    0.960812] ehci-pci 0000:00:1d.0: EHCI Host Controller
[    0.960819] ehci-pci 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    0.960835] ehci-pci 0000:00:1d.0: debug port 2
[    0.964740] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
[    0.964760] ehci-pci 0000:00:1d.0: irq 23, io mem 0xfe622000
[    0.976190] ehci-pci 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    0.976242] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    0.976245] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    0.976247] usb usb2: Product: EHCI Host Controller
[    0.976249] usb usb2: Manufacturer: Linux 3.16.0-0.bpo.4-amd64 ehci_hcd
[    0.976251] usb usb2: SerialNumber: 0000:00:1d.0
[    0.976489] hub 2-0:1.0: USB hub found
[    0.976499] hub 2-0:1.0: 2 ports detected
[    0.976653] ahci 0000:00:1f.2: version 3.0
[    0.976799] ahci 0000:00:1f.2: irq 48 for MSI/MSI-X
[    0.992166] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 6 Gbps 0xf impl SATA mode
[    0.992181] ahci 0000:00:1f.2: flags: 64bit ncq sntf pm led clo pio slum part ems apst 
[    1.016977] scsi1 : ahci
[    1.017140] scsi2 : ahci
[    1.017290] scsi3 : ahci
[    1.017450] scsi4 : ahci
[    1.017608] scsi5 : ahci
[    1.017766] scsi6 : ahci
[    1.017836] ata1: SATA max UDMA/133 abar m2048@0xfe621000 port 0xfe621100 irq 48
[    1.017840] ata2: SATA max UDMA/133 abar m2048@0xfe621000 port 0xfe621180 irq 48
[    1.017843] ata3: SATA max UDMA/133 abar m2048@0xfe621000 port 0xfe621200 irq 48
[    1.017847] ata4: SATA max UDMA/133 abar m2048@0xfe621000 port 0xfe621280 irq 48
[    1.017848] ata5: DUMMY
[    1.017849] ata6: DUMMY
[    1.063838] e1000e 0000:03:00.0 eth1: registered PHC clock
[    1.063842] e1000e 0000:03:00.0 eth1: (PCI Express:2.5GT/s:Width x1) 38:60:77:9c:29:d8
[    1.063844] e1000e 0000:03:00.0 eth1: Intel(R) PRO/1000 Network Connection
[    1.063930] e1000e 0000:03:00.0 eth1: MAC: 3, PHY: 8, PBA No: FFFFFF-0FF
[    1.129177] mpt2sas0: Allocated physical memory: size(7445 kB)
[    1.129181] mpt2sas0: Current Controller Queue Depth(3307), Max Controller Queue Depth(3432)
[    1.129182] mpt2sas0: Scatter Gather Elements per IO(128)
[    1.272194] usb 1-1: new high-speed USB device number 2 using ehci-pci
[    1.336192] ata2: SATA link down (SStatus 0 SControl 300)
[    1.336219] ata4: SATA link down (SStatus 0 SControl 300)
[    1.336245] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    1.336270] ata3: SATA link down (SStatus 0 SControl 300)
[    1.336513] ata1.00: ATA-8: OCZ-VERTEX, 1.7, max UDMA/133
[    1.336517] ata1.00: 62533296 sectors, multi 1: LBA48 NCQ (depth 31/32), AA
[    1.338289] ata1.00: configured for UDMA/133
[    1.338543] scsi 1:0:0:0: Direct-Access     ATA      OCZ-VERTEX       1.7  PQ: 0 ANSI: 5
[    1.344538] mpt2sas0: LSISAS2008: FWVersion(15.00.00.00), ChipRevision(0x03), BiosVersion(00.00.00.00)
[    1.344542] mpt2sas0: Protocol=(Initiator,Target), Capabilities=(TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[    1.344624] mpt2sas0: sending port enable !!
[    1.345132] sd 1:0:0:0: [sda] 62533296 512-byte logical blocks: (32.0 GB/29.8 GiB)
[    1.345211] sd 1:0:0:0: [sda] Write Protect is off
[    1.345214] sd 1:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    1.345231] sd 1:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    1.345746]  sda: sda1 sda2 < sda5 >
[    1.346156] sd 1:0:0:0: [sda] Attached SCSI disk
[    1.404562] usb 1-1: New USB device found, idVendor=8087, idProduct=0024
[    1.404566] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.404960] hub 1-1:1.0: USB hub found
[    1.405153] hub 1-1:1.0: 6 ports detected
[    1.516190] usb 2-1: new high-speed USB device number 2 using ehci-pci
[    1.604132] tsc: Refined TSC clocksource calibration: 3292.521 MHz
[    1.648530] usb 2-1: New USB device found, idVendor=8087, idProduct=0024
[    1.648534] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    1.648992] hub 2-1:1.0: USB hub found
[    1.649149] hub 2-1:1.0: 8 ports detected
[    1.956267] usb 2-1-port5: over-current condition
[    2.164257] usb 2-1-port6: over-current condition
[    2.604299] Switched to clocksource tsc
[    2.950092] mpt2sas0: host_add: handle(0x0001), sas_addr(0x5000000080000000), phys(8)
[    3.448362] scsi 0:0:0:0: Direct-Access     ATA      WDC WD20EFRX-68E 0A82 PQ: 0 ANSI: 6
[    3.448370] scsi 0:0:0:0: SATA: handle(0x0009), sas_addr(0x4433221100000000), phy(0), device_name(0x0000000000000000)
[    3.448373] scsi 0:0:0:0: SATA: enclosure_logical_id(0x5000000080000000), slot(3)
[    3.448543] scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    3.448557] scsi 0:0:0:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[    3.698096] scsi 0:0:1:0: Direct-Access     ATA      ST2000DM001-9YN1 CC4H PQ: 0 ANSI: 6
[    3.698104] scsi 0:0:1:0: SATA: handle(0x000a), sas_addr(0x4433221102000000), phy(2), device_name(0x0000000000000000)
[    3.698106] scsi 0:0:1:0: SATA: enclosure_logical_id(0x5000000080000000), slot(1)
[    3.698202] scsi 0:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    3.698206] scsi 0:0:1:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[    3.716082] floppy0: no floppy controllers found
[    3.948284] scsi 0:0:2:0: Direct-Access     ATA      ST2000DM001-1CH1 CC29 PQ: 0 ANSI: 6
[    3.948291] scsi 0:0:2:0: SATA: handle(0x000b), sas_addr(0x4433221101000000), phy(1), device_name(0x0000000000000000)
[    3.948294] scsi 0:0:2:0: SATA: enclosure_logical_id(0x5000000080000000), slot(2)
[    3.948464] scsi 0:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    3.948478] scsi 0:0:2:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[    4.198275] scsi 0:0:3:0: Direct-Access     ATA      ST2000DM001-9YN1 CC4H PQ: 0 ANSI: 6
[    4.198283] scsi 0:0:3:0: SATA: handle(0x000c), sas_addr(0x4433221103000000), phy(3), device_name(0x0000000000000000)
[    4.198286] scsi 0:0:3:0: SATA: enclosure_logical_id(0x5000000080000000), slot(0)
[    4.198376] scsi 0:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    4.198380] scsi 0:0:3:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[    4.448111] scsi 0:0:4:0: Direct-Access     ATA      WDC WD20EFRX-68E 0A82 PQ: 0 ANSI: 6
[    4.448118] scsi 0:0:4:0: SATA: handle(0x000d), sas_addr(0x4433221104000000), phy(4), device_name(0x0000000000000000)
[    4.448121] scsi 0:0:4:0: SATA: enclosure_logical_id(0x5000000080000000), slot(7)
[    4.448298] scsi 0:0:4:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    4.448304] scsi 0:0:4:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[    4.698037] scsi 0:0:5:0: Direct-Access     ATA      ST2000DM001-1CH1 CC29 PQ: 0 ANSI: 6
[    4.698045] scsi 0:0:5:0: SATA: handle(0x000e), sas_addr(0x4433221105000000), phy(5), device_name(0x0000000000000000)
[    4.698048] scsi 0:0:5:0: SATA: enclosure_logical_id(0x5000000080000000), slot(6)
[    4.698226] scsi 0:0:5:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    4.698232] scsi 0:0:5:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[    4.948008] scsi 0:0:6:0: Direct-Access     ATA      ST2000DM001-1CH1 CC29 PQ: 0 ANSI: 6
[    4.948025] scsi 0:0:6:0: SATA: handle(0x000f), sas_addr(0x4433221106000000), phy(6), device_name(0x0000000000000000)
[    4.948028] scsi 0:0:6:0: SATA: enclosure_logical_id(0x5000000080000000), slot(5)
[    4.948116] scsi 0:0:6:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[    4.948120] scsi 0:0:6:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[    8.831968] mpt2sas0: port enable: SUCCESS
[    8.832742] sd 0:0:0:0: [sdb] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    8.832748] sd 0:0:0:0: [sdb] 4096-byte physical blocks
[    8.832969] sd 0:0:1:0: [sdc] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    8.832975] sd 0:0:1:0: [sdc] 4096-byte physical blocks
[    8.833460] sd 0:0:3:0: [sde] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    8.833463] sd 0:0:3:0: [sde] 4096-byte physical blocks
[    8.833606] sd 0:0:2:0: [sdd] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    8.833608] sd 0:0:2:0: [sdd] 4096-byte physical blocks
[    8.833640] sd 0:0:4:0: [sdf] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    8.833644] sd 0:0:4:0: [sdf] 4096-byte physical blocks
[    8.834450] sd 0:0:6:0: [sdh] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    8.834452] sd 0:0:6:0: [sdh] 4096-byte physical blocks
[    8.834963] sd 0:0:5:0: [sdg] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[    8.834965] sd 0:0:5:0: [sdg] 4096-byte physical blocks
[    8.837665] sd 0:0:0:0: [sdb] Write Protect is off
[    8.837668] sd 0:0:0:0: [sdb] Mode Sense: 7f 00 10 08
[    8.838450] sd 0:0:0:0: [sdb] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    8.838502] sd 0:0:4:0: [sdf] Write Protect is off
[    8.838504] sd 0:0:4:0: [sdf] Mode Sense: 7f 00 10 08
[    8.839290] sd 0:0:4:0: [sdf] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    8.853276]  sdf: unknown partition table
[    8.855634]  sdb: unknown partition table
[    8.862249] sd 0:0:4:0: [sdf] Attached SCSI disk
[    8.864563] sd 0:0:0:0: [sdb] Attached SCSI disk
[    8.894036] sd 0:0:1:0: [sdc] Write Protect is off
[    8.894039] sd 0:0:1:0: [sdc] Mode Sense: 7f 00 10 08
[    8.894687] sd 0:0:1:0: [sdc] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    8.896120] sd 0:0:6:0: [sdh] Write Protect is off
[    8.896123] sd 0:0:6:0: [sdh] Mode Sense: 7f 00 10 08
[    8.896969] sd 0:0:6:0: [sdh] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    8.900814] sd 0:0:3:0: [sde] Write Protect is off
[    8.900817] sd 0:0:3:0: [sde] Mode Sense: 7f 00 10 08
[    8.901439] sd 0:0:2:0: [sdd] Write Protect is off
[    8.901441] sd 0:0:2:0: [sdd] Mode Sense: 7f 00 10 08
[    8.901469] sd 0:0:3:0: [sde] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    8.902266] sd 0:0:2:0: [sdd] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    8.903275] sd 0:0:5:0: [sdg] Write Protect is off
[    8.903278] sd 0:0:5:0: [sdg] Mode Sense: 7f 00 10 08
[    8.904103] sd 0:0:5:0: [sdg] Write cache: enabled, read cache: enabled, supports DPO and FUA
[    8.969109]  sdc: unknown partition table
[    8.970216]  sde: unknown partition table
[    8.978705]  sdh: unknown partition table
[    8.979031]  sdd: unknown partition table
[    8.980143]  sdg: unknown partition table
[    9.035532] sd 0:0:3:0: [sde] Attached SCSI disk
[    9.036932] sd 0:0:1:0: [sdc] Attached SCSI disk
[    9.056125] sd 0:0:6:0: [sdh] Attached SCSI disk
[    9.061367] sd 0:0:2:0: [sdd] Attached SCSI disk
[    9.063138] sd 0:0:5:0: [sdg] Attached SCSI disk
[    9.065485] sd 1:0:0:0: Attached scsi generic sg0 type 0
[    9.065572] sd 0:0:0:0: Attached scsi generic sg1 type 0
[    9.065647] sd 0:0:1:0: Attached scsi generic sg2 type 0
[    9.065725] sd 0:0:2:0: Attached scsi generic sg3 type 0
[    9.065791] sd 0:0:3:0: Attached scsi generic sg4 type 0
[    9.065870] sd 0:0:4:0: Attached scsi generic sg5 type 0
[    9.065934] sd 0:0:5:0: Attached scsi generic sg6 type 0
[    9.065999] sd 0:0:6:0: Attached scsi generic sg7 type 0
[    9.077012] random: nonblocking pool is initialized
[    9.151208] platform microcode: firmware: direct-loading firmware intel-ucode/06-2a-07
[    9.151229] microcode: CPU0 sig=0x206a7, pf=0x2, revision=0x28
[    9.151925] microcode: CPU0 updated to revision 0x29, date = 2013-06-12
[    9.151957] platform microcode: firmware: direct-loading firmware intel-ucode/06-2a-07
[    9.152002] microcode: CPU1 sig=0x206a7, pf=0x2, revision=0x28
[    9.152398] microcode: CPU1 updated to revision 0x29, date = 2013-06-12
[    9.152410] platform microcode: firmware: direct-loading firmware intel-ucode/06-2a-07
[    9.152420] microcode: CPU2 sig=0x206a7, pf=0x2, revision=0x28
[    9.152784] microcode: CPU2 updated to revision 0x29, date = 2013-06-12
[    9.152804] platform microcode: firmware: direct-loading firmware intel-ucode/06-2a-07
[    9.152843] microcode: CPU3 sig=0x206a7, pf=0x2, revision=0x28
[    9.153239] microcode: CPU3 updated to revision 0x29, date = 2013-06-12
[    9.165028] device-mapper: uevent: version 1.0.3
[    9.165127] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[    9.171516] PM: Starting manual resume from disk
[    9.171521] PM: Hibernation image partition 8:5 present
[    9.171523] PM: Looking for hibernation image.
[    9.171731] PM: Image not found (code -22)
[    9.171733] PM: Hibernation image not present or could not be loaded.
[    9.181244] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
[    9.405923] udevd[453]: starting version 175
[    9.435306] input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input2
[    9.435314] ACPI: Power Button [PWRB]
[    9.435401] input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input3
[    9.435406] ACPI: Power Button [PWRF]
[    9.482306] mei_me 0000:00:16.0: irq 49 for MSI/MSI-X
[    9.486212] mei_me 0000:00:16.0: FW not ready: resetting.
[    9.486226] mei_me 0000:00:16.0: unexpected reset: dev_state = INIT_CLIENTS 1E000245 60000006
[    9.492017] [drm] Initialized drm 1.1.0 20060810
[    9.500807] input: PC Speaker as /devices/platform/pcspkr/input/input4
[    9.510184] i801_smbus 0000:00:1f.3: SMBus using PCI Interrupt
[    9.512307] alg: No test for crc32 (crc32-pclmul)
[    9.516054] [drm] Memory usable by graphics device = 2048M
[    9.516058] [drm] Replacing VGA console driver
[    9.521321] Console: switching to colour dummy device 80x25
[    9.527317] iTCO_vendor_support: vendor-support=0
[    9.528467] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    9.528506] iTCO_wdt: Found a Cougar Point TCO device (Version=2, TCOBASE=0x0460)
[    9.528692] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    9.543944] i915 0000:00:02.0: irq 50 for MSI/MSI-X
[    9.543957] [drm] Supports vblank timestamp caching Rev 2 (21.10.2013).
[    9.543958] [drm] Driver supports precise vblank timestamp query.
[    9.544030] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[    9.545049] intel_rapl: RAPL domain dram detection failed
[    9.547926] [drm] Wrong MCH_SSKPD value: 0x16040307
[    9.547929] [drm] This can cause pipe underruns and display issues.
[    9.547930] [drm] Please upgrade your BIOS to fix this.
[    9.564617] i915 0000:00:02.0: No connectors reported connected with modes
[    9.564624] [drm] Cannot find any crtc or sizes - going 1024x768
[    9.565134] fbcon: inteldrmfb (fb0) is primary device
[    9.588352] Console: switching to colour frame buffer device 128x48
[    9.589954] i915 0000:00:02.0: fb0: inteldrmfb frame buffer device
[    9.589955] i915 0000:00:02.0: registered panic notifier
[    9.627969] i915: No ACPI video bus found
[    9.628021] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   11.040333] [drm] Enabling RC6 states: RC6 on, RC6p off, RC6pp off
[   12.491945] floppy0: no floppy controllers found
[   12.491960] work still pending
[   12.704731] Adding 1316860k swap on /dev/sda5.  Priority:-1 extents:1 across:1316860k SSFS
[   12.708775] EXT4-fs (sda1): re-mounted. Opts: (null)
[   12.751210] EXT4-fs (sda1): re-mounted. Opts: errors=remount-ro
[   12.769221] loop: module loaded
[   12.781989] md: md0 stopped.
[   12.784376] md: bind<sdc>
[   12.784720] md: bind<sdd>
[   12.784889] md: bind<sde>
[   12.785004] md: bind<sdf>
[   12.785182] md: bind<sdg>
[   12.785363] md: bind<sdh>
[   12.785490] md: bind<sdb>
[   12.804501] w83627ehf: Found NCT6775F chip at 0x290
[   12.875817] raid6: sse2x1    6687 MB/s
[   12.943819] raid6: sse2x2    8760 MB/s
[   13.011810] raid6: sse2x4   11129 MB/s
[   13.011813] raid6: using algorithm sse2x4 (11129 MB/s)
[   13.011814] raid6: using ssse3x2 recovery algorithm
[   13.012364] async_tx: api initialized (async)
[   13.012807] xor: automatically using best checksumming function:
[   13.051805]    avx       : 24384.000 MB/sec
[   13.054992] md: raid6 personality registered for level 6
[   13.054995] md: raid5 personality registered for level 5
[   13.054996] md: raid4 personality registered for level 4
[   13.055198] md/raid:md0: device sdb operational as raid disk 0
[   13.055201] md/raid:md0: device sdh operational as raid disk 6
[   13.055202] md/raid:md0: device sdg operational as raid disk 5
[   13.055203] md/raid:md0: device sdf operational as raid disk 4
[   13.055203] md/raid:md0: device sde operational as raid disk 3
[   13.055204] md/raid:md0: device sdd operational as raid disk 2
[   13.055205] md/raid:md0: device sdc operational as raid disk 1
[   13.055504] md/raid:md0: allocated 0kB
[   13.055523] md/raid:md0: raid level 5 active with 7 out of 7 devices, algorithm 2
[   13.055524] RAID conf printout:
[   13.055525]  --- level:5 rd:7 wd:7
[   13.055526]  disk 0, o:1, dev:sdb
[   13.055527]  disk 1, o:1, dev:sdc
[   13.055528]  disk 2, o:1, dev:sdd
[   13.055528]  disk 3, o:1, dev:sde
[   13.055529]  disk 4, o:1, dev:sdf
[   13.055530]  disk 5, o:1, dev:sdg
[   13.055531]  disk 6, o:1, dev:sdh
[   13.055631] created bitmap (15 pages) for device md0
[   13.055900] md0: bitmap initialized from disk: read 1 pages, set 0 of 29807 bits
[   13.097313] md0: detected capacity change from 0 to 12001584611328
[   13.104977]  md0: unknown partition table
[   13.334504] SGI XFS with ACLs, security attributes, realtime, large block/inode numbers, no debug enabled
[   13.342755] XFS (md0): Mounting V4 Filesystem
[   13.745803] XFS (md0): Ending clean mount
[   13.830132] IPv6: ADDRCONF(NETDEV_UP): lo: link is not ready
[   13.996696] RPC: Registered named UNIX socket transport module.
[   13.996700] RPC: Registered udp transport module.
[   13.996701] RPC: Registered tcp transport module.
[   13.996703] RPC: Registered tcp NFSv4.1 backchannel transport module.
[   13.999727] FS-Cache: Loaded
[   14.007116] FS-Cache: Netfs 'nfs' registered for caching
[   14.015456] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[   14.220028] softdog: Software Watchdog Timer: 0.08 initialized. soft_noboot=0 soft_margin=60 sec soft_panic=0 (nowayout=0)
[   14.268216] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
[   14.269889] NFSD: starting 90-second grace period (net ffffffff818b7bc0)
[   14.764569] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   14.867812] e1000e 0000:00:19.0: irq 43 for MSI/MSI-X
[   14.867933] IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
[   17.764724] e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: None
[   17.764760] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[30088.759829] perf interrupt took too long (2513 > 2500), lowering kernel.perf_event_max_sample_rate to 50000
[64394.668363] Peer 122.58.221.34:52443/56000 unexpectedly shrunk window 3492829916:3492831594 (repaired)
[64396.136268] Peer 122.58.221.34:52443/56000 unexpectedly shrunk window 3492829916:3492831594 (repaired)
[88276.246956] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1987884131:1987885543 (repaired)
[88278.466813] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1987884131:1987885543 (repaired)
[88322.172035] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1987933039:1987935323 (repaired)
[88323.327983] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1987933039:1987935323 (repaired)
[88337.687049] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1987949983:1987951720 (repaired)
[88338.670985] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1987949983:1987951720 (repaired)
[88353.738031] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1987966927:1987968117 (repaired)
[88354.673978] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1987966927:1987968117 (repaired)
[88369.901005] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1987983871:1987985342 (repaired)
[88371.088928] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1987983871:1987985342 (repaired)
[88384.652103] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1988000815:1988001739 (repaired)
[88385.768002] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1988000815:1988001739 (repaired)
[88400.403073] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1988017759:1988018136 (repaired)
[88401.455008] Peer 189.165.165.85:65192/56000 unexpectedly shrunk window 1988017759:1988018136 (repaired)
[690721.822696] usb 1-1.1: new high-speed USB device number 3 using ehci-pci
[690721.976596] usb 1-1.1: New USB device found, idVendor=174c, idProduct=55aa
[690721.976610] usb 1-1.1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
[690721.976613] usb 1-1.1: Product: stockplop
[690721.976615] usb 1-1.1: Manufacturer:  
[690721.976618] usb 1-1.1: SerialNumber: 123456789188
[690722.006675] usb-storage 1-1.1:1.0: USB Mass Storage device detected
[690722.006878] usb-storage 1-1.1:1.0: Quirks match for vid 174c pid 55aa: 400000
[690722.006900] scsi7 : usb-storage 1-1.1:1.0
[690722.006996] usbcore: registered new interface driver usb-storage
[690723.007180] scsi 7:0:0:0: Direct-Access              stockplop        0    PQ: 0 ANSI: 6
[690723.007580] sd 7:0:0:0: Attached scsi generic sg8 type 0
[690723.011537] sd 7:0:0:0: [sdi] Spinning up disk...
[690724.014426] ....ready
[690727.032724] sd 7:0:0:0: [sdi] 250069680 512-byte logical blocks: (128 GB/119 GiB)
[690727.033805] sd 7:0:0:0: [sdi] Write Protect is off
[690727.033809] sd 7:0:0:0: [sdi] Mode Sense: 43 00 00 00
[690727.034894] sd 7:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[690727.038199]  sdi: sdi1
[690727.041530] sd 7:0:0:0: [sdi] Attached SCSI disk
[691228.770132] usb 1-1.1: USB disconnect, device number 3
[691228.770769] sd 7:0:0:0: [sdi] Synchronizing SCSI cache
[691228.770834] sd 7:0:0:0: [sdi]  
[691228.770837] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[717697.836335] TCP: TCP: Possible SYN flooding on port 56000. Sending cookies.  Check SNMP counters.
[878085.901828] Peer 184.45.34.24:57342/56000 unexpectedly shrunk window 1684310192:1684313072 (repaired)
[969471.368189] Peer 94.99.124.69:61740/56000 unexpectedly shrunk window 3771473659:3771473755 (repaired)
[969498.754467] Peer 94.99.124.69:61740/56000 unexpectedly shrunk window 3772038583:3772039943 (repaired)
[969523.608872] Peer 94.99.124.69:61740/56000 unexpectedly shrunk window 3772675907:3772678915 (repaired)
[1003487.804432] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2991997064:2992005016 (repaired)
[1003489.232340] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2991997064:2992005016 (repaired)
[1003496.043908] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992000536:2992010776 (repaired)
[1003499.011724] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992000536:2992010776 (repaired)
[1003504.947327] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992000536:2992010776 (repaired)
[1003516.802602] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992000536:2992010776 (repaired)
[1003540.513106] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992000536:2992010776 (repaired)
[1003587.998115] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992000536:2992010776 (repaired)
[1003682.840100] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992000536:2992010776 (repaired)
[1003802.896529] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992000536:2992010776 (repaired)
[1003963.158408] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992062564:2992077016 (repaired)
[1003969.973983] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992062564:2992077016 (repaired)
[1003983.621126] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992062564:2992077016 (repaired)
[1004010.883397] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992062564:2992077016 (repaired)
[1004065.407945] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992062564:2992077016 (repaired)
[1004174.585011] Peer 184.45.96.186:63587/56000 unexpectedly shrunk window 2992062564:2992077016 (repaired)
[1198241.669743] Clock: inserting leap second 23:59:60 UTC
[1204733.309520] sd 0:0:1:0: attempting task abort! scmd(ffff88003d59fe40)
[1204733.309527] sd 0:0:1:0: [sdc] CDB: 
[1204733.309529] Read(10): 28 00 c5 33 48 00 00 01 40 00
[1204733.309540] scsi target0:0:1: handle(0x000a), sas_address(0x4433221102000000), phy(2)
[1204733.309543] scsi target0:0:1: enclosure_logical_id(0x5000000080000000), slot(1)
[1204737.231927] sd 0:0:1:0: task abort: SUCCESS scmd(ffff88003d59fe40)
[1204737.237343] sd 0:0:1:0: [sdc] Device not ready
[1204737.237352] sd 0:0:1:0: [sdc]  
[1204737.237354] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[1204737.237357] sd 0:0:1:0: [sdc]  
[1204737.237359] Sense Key : Not Ready [current] 
[1204737.237362] sd 0:0:1:0: [sdc]  
[1204737.237365] Add. Sense: Logical unit not ready, cause not reportable
[1204737.237367] sd 0:0:1:0: [sdc] CDB: 
[1204737.237368] Read(10): 28 00 c5 33 48 00 00 01 40 00
[1204737.237377] end_request: I/O error, dev sdc, sector 3308472320
[1204737.237928] sd 0:0:1:0: [sdc] Device not ready
[1204737.237937] sd 0:0:1:0: [sdc]  
[1204737.237939] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[1204737.237942] sd 0:0:1:0: [sdc]  
[1204737.237943] Sense Key : Not Ready [current] 
[1204737.237947] sd 0:0:1:0: [sdc]  
[1204737.237949] Add. Sense: Logical unit not ready, cause not reportable
[1204737.237951] sd 0:0:1:0: [sdc] CDB: 
[1204737.237952] Read(10): 28 00 c5 33 48 00 00 00 08 00
[1204737.237961] end_request: I/O error, dev sdc, sector 3308472320
[1204737.238020] sd 0:0:1:0: [sdc] Device not ready
[1204737.238025] sd 0:0:1:0: [sdc]  
[1204737.238027] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[1204737.238028] sd 0:0:1:0: [sdc]  
[1204737.238030] Sense Key : Not Ready [current] 
[1204737.238032] sd 0:0:1:0: [sdc]  
[1204737.238034] Add. Sense: Logical unit not ready, cause not reportable
[1204737.238036] sd 0:0:1:0: [sdc] CDB: 
[1204737.238037] Read(10): 28 00 c5 33 48 08 00 00 78 00
[1204737.238044] end_request: I/O error, dev sdc, sector 3308472328
[1204737.238098] sd 0:0:1:0: [sdc] Device not ready
[1204737.238100] sd 0:0:1:0: [sdc]  
[1204737.238101] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[1204737.238103] sd 0:0:1:0: [sdc]  
[1204737.238104] Sense Key : Not Ready [current] 
[1204737.238107] sd 0:0:1:0: [sdc]  
[1204737.238108] Add. Sense: Logical unit not ready, cause not reportable
[1204737.238110] sd 0:0:1:0: [sdc] CDB: 
[1204737.238111] Read(10): 28 00 c5 33 48 80 00 00 80 00
[1204737.238120] end_request: I/O error, dev sdc, sector 3308472448
[1204737.238164] sd 0:0:1:0: [sdc] Device not ready
[1204737.238165] sd 0:0:1:0: [sdc]  
[1204737.238167] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[1204737.238169] sd 0:0:1:0: [sdc]  
[1204737.238170] Sense Key : Not Ready [current] 
[1204737.238172] sd 0:0:1:0: [sdc]  
[1204737.238174] Add. Sense: Logical unit not ready, cause not reportable
[1204737.238176] sd 0:0:1:0: [sdc] CDB: 
[1204737.238177] Read(10): 28 00 c5 33 49 00 00 00 40 00
[1204737.238184] end_request: I/O error, dev sdc, sector 3308472576
[1204737.238643] sd 0:0:1:0: [sdc] Device not ready
[1204737.238654] sd 0:0:1:0: [sdc]  
[1204737.238656] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[1204737.238660] sd 0:0:1:0: [sdc]  
[1204737.238662] Sense Key : Not Ready [current] 
[1204737.238667] sd 0:0:1:0: [sdc]  
[1204737.238670] Add. Sense: Logical unit not ready, cause not reportable
[1204737.238673] sd 0:0:1:0: [sdc] CDB: 
[1204737.238675] Write(10): 2a 00 c5 33 48 00 00 00 08 00
[1204737.238689] end_request: I/O error, dev sdc, sector 3308472320
[1204737.238793] md/raid:md0: Disk failure on sdc, disabling device.
[1204737.238793] md/raid:md0: Operation continuing on 6 devices.
[1204737.642563] RAID conf printout:
[1204737.642569]  --- level:5 rd:7 wd:6
[1204737.642572]  disk 0, o:1, dev:sdb
[1204737.642574]  disk 1, o:0, dev:sdc
[1204737.642575]  disk 2, o:1, dev:sdd
[1204737.642577]  disk 3, o:1, dev:sde
[1204737.642579]  disk 4, o:1, dev:sdf
[1204737.642581]  disk 5, o:1, dev:sdg
[1204737.642582]  disk 6, o:1, dev:sdh
[1204737.669269] RAID conf printout:
[1204737.669273]  --- level:5 rd:7 wd:6
[1204737.669276]  disk 0, o:1, dev:sdb
[1204737.669286]  disk 2, o:1, dev:sdd
[1204737.669288]  disk 3, o:1, dev:sde
[1204737.669289]  disk 4, o:1, dev:sdf
[1204737.669291]  disk 5, o:1, dev:sdg
[1204737.669293]  disk 6, o:1, dev:sdh
[1204775.482279] sd 0:0:1:0: [sdc] Synchronizing SCSI cache
[1204775.482376] sd 0:0:1:0: [sdc]  
[1204775.482381] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
[1204775.482583] mpt2sas0: removing handle(0x000a), sas_addr(0x4433221102000000)
[1309656.015768] md: data-check of RAID array md0
[1309656.015774] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[1309656.015777] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[1309656.015785] md: using 128k window, over a total of 1953382912k.
[1309656.015792] md: md0: data-check done.
[1367875.554471] Peer 82.72.187.108:53669/56000 unexpectedly shrunk window 1827574689:1827574859 (repaired)
[1367876.538410] Peer 82.72.187.108:53669/56000 unexpectedly shrunk window 1827574689:1827574859 (repaired)
[1633948.784679] Peer 184.45.98.72:63686/56000 unexpectedly shrunk window 3031770608:3031770736 (repaired)
[1729472.124794] sd 0:0:0:0: [sdb] Device not ready
[1729472.124811] sd 0:0:0:0: [sdb]  
[1729472.124814] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[1729472.124816] sd 0:0:0:0: [sdb]  
[1729472.124817] Sense Key : Not Ready [current] 
[1729472.124821] sd 0:0:0:0: [sdb]  
[1729472.124823] Add. Sense: Logical unit not ready, cause not reportable
[1729472.124825] sd 0:0:0:0: [sdb] CDB: 
[1729472.124827] Read(10): 28 00 2a cf 94 00 00 03 20 00
[1729472.124835] end_request: I/O error, dev sdb, sector 718246912
[1729472.125097] sd 0:0:0:0: [sdb] Device not ready
[1729472.125116] sd 0:0:0:0: [sdb]  
[1729472.125119] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[1729472.125122] sd 0:0:0:0: [sdb]  
[1729472.125124] Sense Key : Not Ready [current] 
[1729472.125128] sd 0:0:0:0: [sdb]  
[1729472.125130] Add. Sense: Logical unit not ready, cause not reportable
[1729472.125133] sd 0:0:0:0: [sdb] CDB: 
[1729472.125135] Read(10): 28 00 2a cf 94 00 00 00 08 00
[1729472.125144] end_request: I/O error, dev sdb, sector 718246912
[1729472.125190] md/raid:md0: read error not correctable (sector 718246912 on sdb).
[1729472.125193] md/raid:md0: Disk failure on sdb, disabling device.
[1729472.125193] md/raid:md0: Operation continuing on 5 devices.
[1729472.125279] sd 0:0:0:0: [sdb] Device not ready
[1729472.125282] sd 0:0:0:0: [sdb]  
[1729472.125284] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[1729472.125287] sd 0:0:0:0: [sdb]  
[1729472.125289] Sense Key : Not Ready [current] 
[1729472.125302] sd 0:0:0:0: [sdb]  
[1729472.125304] Add. Sense: Logical unit not ready, cause not reportable
[1729472.125307] sd 0:0:0:0: [sdb] CDB: 
[1729472.125308] Read(10): 28 00 2a cf 94 08 00 00 78 00
[1729472.125318] end_request: I/O error, dev sdb, sector 718246920
[1729472.125367] md/raid:md0: read error not correctable (sector 718246920 on sdb).
[1729472.125370] md/raid:md0: read error not correctable (sector 718246928 on sdb).
[1729472.125374] md/raid:md0: read error not correctable (sector 718246936 on sdb).
[1729472.125377] md/raid:md0: read error not correctable (sector 718246944 on sdb).
[1729472.125379] md/raid:md0: read error not correctable (sector 718246952 on sdb).
[1729472.125382] md/raid:md0: read error not correctable (sector 718246960 on sdb).
[1729472.125384] md/raid:md0: read error not correctable (sector 718246968 on sdb).
[1729472.125387] md/raid:md0: read error not correctable (sector 718246976 on sdb).
[1729472.125390] md/raid:md0: read error not correctable (sector 718246984 on sdb).
[1729472.125405] sd 0:0:0:0: [sdb] Device not ready
[1729472.125408] sd 0:0:0:0: [sdb]  
[1729472.125410] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[1729472.125413] sd 0:0:0:0: [sdb]  
[1729472.125414] Sense Key : Not Ready [current] 
[1729472.125418] sd 0:0:0:0: [sdb]  
[1729472.125420] Add. Sense: Logical unit not ready, cause not reportable
[1729472.125423] sd 0:0:0:0: [sdb] CDB: 
[1729472.125424] Read(10): 28 00 2a cf 94 80 00 00 80 00
[1729472.125434] end_request: I/O error, dev sdb, sector 718247040
[1729472.125654] sd 0:0:0:0: [sdb] Device not ready
[1729472.125658] sd 0:0:0:0: [sdb]  
[1729472.125660] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[1729472.125663] sd 0:0:0:0: [sdb]  
[1729472.125665] Sense Key : Not Ready [current] 
[1729472.125668] sd 0:0:0:0: [sdb]  
[1729472.125671] Add. Sense: Logical unit not ready, cause not reportable
[1729472.125674] sd 0:0:0:0: [sdb] CDB: 
[1729472.125676] Read(10): 28 00 2a cf 95 00 00 00 08 00
[1729472.125684] end_request: I/O error, dev sdb, sector 718247168
[1729472.230609] RAID conf printout:
[1729472.230614]  --- level:5 rd:7 wd:5
[1729472.230617]  disk 0, o:0, dev:sdb
[1729472.230619]  disk 2, o:1, dev:sdd
[1729472.230620]  disk 3, o:1, dev:sde
[1729472.230622]  disk 4, o:1, dev:sdf
[1729472.230623]  disk 5, o:1, dev:sdg
[1729472.230625]  disk 6, o:1, dev:sdh
[1729472.242617] RAID conf printout:
[1729472.242622]  --- level:5 rd:7 wd:5
[1729472.242625]  disk 2, o:1, dev:sdd
[1729472.242628]  disk 3, o:1, dev:sde
[1729472.242630]  disk 4, o:1, dev:sdf
[1729472.242632]  disk 5, o:1, dev:sdg
[1729472.242635]  disk 6, o:1, dev:sdh
[1729478.130207] scsi 0:0:7:0: Direct-Access     ATA      ST2000DM001-1CH1 CC29 PQ: 0 ANSI: 6
[1729478.130218] scsi 0:0:7:0: SATA: handle(0x000a), sas_addr(0x4433221102000000), phy(2), device_name(0x0000000000000000)
[1729478.130221] scsi 0:0:7:0: SATA: enclosure_logical_id(0x5000000080000000), slot(1)
[1729478.130315] scsi 0:0:7:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[1729478.130319] scsi 0:0:7:0: qdepth(32), tagged(1), simple(0), ordered(0), scsi_level(7), cmd_que(1)
[1729478.131781] sd 0:0:7:0: Attached scsi generic sg2 type 0
[1729478.132102] sd 0:0:7:0: [sdi] 3907029168 512-byte logical blocks: (2.00 TB/1.81 TiB)
[1729478.132106] sd 0:0:7:0: [sdi] 4096-byte physical blocks
[1729478.201670] sd 0:0:7:0: [sdi] Write Protect is off
[1729478.201676] sd 0:0:7:0: [sdi] Mode Sense: 7f 00 10 08
[1729478.202431] sd 0:0:7:0: [sdi] Write cache: enabled, read cache: enabled, supports DPO and FUA
[1729478.315143]  sdi: sdi1
[1729478.387053] sd 0:0:7:0: [sdi] Attached SCSI disk
[1731688.936253] XFS (md0): metadata I/O error: block 0x20c00dbe8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1731688.941985] XFS (md0): metadata I/O error: block 0x1e75b1410 ("xfs_trans_read_buf_map") error 5 numblks 16
[1731688.942045] XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[1731688.945028] XFS (md0): metadata I/O error: block 0x20c01b7f0 ("xfs_trans_read_buf_map") error 5 numblks 8
[1731690.999053] XFS (md0): metadata I/O error: block 0x82fc17f0 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732371.949907] XFS (md0): metadata I/O error: block 0x82fc17f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732372.178664] XFS (md0): metadata I/O error: block 0x82fc17f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732375.177217] XFS (md0): metadata I/O error: block 0x82fc17f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732375.342550] XFS (md0): metadata I/O error: block 0x82fc17f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732375.659020] XFS (md0): metadata I/O error: block 0x82fc17f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732378.633024] XFS (md0): metadata I/O error: block 0x216a40c10 ("xfs_trans_read_buf_map") error 5 numblks 16
[1732378.633088] XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[1732378.884396] XFS (md0): metadata I/O error: block 0x26a6cd430 ("xfs_trans_read_buf_map") error 5 numblks 16
[1732378.884456] XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[1732378.884553] XFS (md0): metadata I/O error: block 0x2968a8c10 ("xfs_trans_read_buf_map") error 5 numblks 16
[1732378.884613] XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[1732380.546075] XFS (md0): metadata I/O error: block 0x216a40c10 ("xfs_trans_read_buf_map") error 5 numblks 16
[1732380.546138] XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[1732380.546480] XFS (md0): metadata I/O error: block 0x216a40c10 ("xfs_trans_read_buf_map") error 5 numblks 16
[1732380.546550] XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[1732380.546987] XFS (md0): metadata I/O error: block 0x26a6cd430 ("xfs_trans_read_buf_map") error 5 numblks 16
[1732380.547897] XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[1732380.548379] XFS (md0): metadata I/O error: block 0x26a6cd430 ("xfs_trans_read_buf_map") error 5 numblks 16
[1732380.549276] XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[1732380.549866] XFS (md0): metadata I/O error: block 0x2968a8c10 ("xfs_trans_read_buf_map") error 5 numblks 16
[1732380.550739] XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[1732380.551188] XFS (md0): metadata I/O error: block 0x2968a8c10 ("xfs_trans_read_buf_map") error 5 numblks 16
[1732380.552036] XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[1732386.820523] XFS (md0): metadata I/O error: block 0x82fc17f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732386.985712] XFS (md0): metadata I/O error: block 0x82fc17f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732387.254731] XFS (md0): metadata I/O error: block 0x82fc17f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732390.069802] XFS (md0): metadata I/O error: block 0x26a6cd430 ("xfs_trans_read_buf_map") error 5 numblks 16
[1732390.070652] XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[1732390.071013] XFS (md0): metadata I/O error: block 0x26a6cd430 ("xfs_trans_read_buf_map") error 5 numblks 16
[1732390.071851] XFS (md0): xfs_imap_to_bp: xfs_trans_read_buf() returned error 5.
[1732394.274404] XFS (md0): metadata I/O error: block 0x13bcb77f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732394.439462] XFS (md0): metadata I/O error: block 0x13bcb77f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732394.732064] XFS (md0): metadata I/O error: block 0x13bcb77f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732400.286287] XFS (md0): metadata I/O error: block 0x13bcb77f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1732414.233726] XFS (md0): metadata I/O error: block 0x82fc17f8 ("xfs_trans_read_buf_map") error 5 numblks 8
[1733014.875881] md: unbind<sdb>
[1733014.893932] md: export_rdev(sdb)
[1733020.009115] md: bind<sdb>
[1733020.660576] RAID conf printout:
[1733020.660582]  --- level:5 rd:7 wd:5
[1733020.660585]  disk 0, o:1, dev:sdb
[1733020.660587]  disk 2, o:1, dev:sdd
[1733020.660590]  disk 3, o:1, dev:sde
[1733020.660592]  disk 4, o:1, dev:sdf
[1733020.660594]  disk 5, o:1, dev:sdg
[1733020.660596]  disk 6, o:1, dev:sdh
[1733020.660725] md: recovery of RAID array md0
[1733020.660728] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[1733020.660730] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
[1733020.660736] md: using 128k window, over a total of 1953382912k.
[1733020.749525] md: md0: recovery interrupted.
[1733021.036583] RAID conf printout:
[1733021.036589]  --- level:5 rd:7 wd:5
[1733021.036591]  disk 0, o:1, dev:sdb
[1733021.036593]  disk 2, o:1, dev:sdd
[1733021.036595]  disk 3, o:1, dev:sde
[1733021.036597]  disk 4, o:1, dev:sdf
[1733021.036599]  disk 5, o:1, dev:sdg
[1733021.036601]  disk 6, o:1, dev:sdh
[1733021.053523] RAID conf printout:
[1733021.053529]  --- level:5 rd:7 wd:5
[1733021.053541]  disk 2, o:1, dev:sdd
[1733021.053544]  disk 3, o:1, dev:sde
[1733021.053545]  disk 4, o:1, dev:sdf
[1733021.053547]  disk 5, o:1, dev:sdg
[1733021.053549]  disk 6, o:1, dev:sdh
[1733400.473919] nfsd: last server has exited, flushing export cache
[1733514.783196] XFS (md0): metadata I/O error: block 0x2bab530c0 ("xlog_iodone") error 5 numblks 64
[1733514.783620] XFS (md0): xfs_do_force_shutdown(0x2) called from line 1172 of file /build/linux-50mAO0/linux-3.16.7-ckt4/fs/xfs/xfs_log.c.  Return address = 0xffffffffa06038fe
[1733514.783630] XFS (md0): Log I/O Error Detected.  Shutting down filesystem
[1733514.783659] XFS (md0): Unable to update superblock counters. Freespace may not be correct on next mount.
[1733514.783661] XFS (md0): xfs_log_force: error 5 returned.
[1733514.784042] XFS (md0): Please umount the filesystem and rectify the problem(s)
[1733517.592758] Buffer I/O error on device md0, logical block 0
[1733517.593548] Buffer I/O error on device md0, logical block 0
[1733517.594338] Buffer I/O error on device md0, logical block 2930074352
[1733517.595123] Buffer I/O error on device md0, logical block 2930074352
[1733517.595908] Buffer I/O error on device md0, logical block 2930074366
[1733517.596605] Buffer I/O error on device md0, logical block 2930074366
[1733517.597303] Buffer I/O error on device md0, logical block 0
[1733517.598006] Buffer I/O error on device md0, logical block 1
[1733517.598722] Buffer I/O error on device md0, logical block 1
[1733517.599446] Buffer I/O error on device md0, logical block 2930074367
[1733527.606576] quiet_error: 1328 callbacks suppressed
[1733527.606582] Buffer I/O error on device md0, logical block 2930074352
[1733527.607312] Buffer I/O error on device md0, logical block 2930074352
[1733527.607989] Buffer I/O error on device md0, logical block 2930074366
[1733527.608671] Buffer I/O error on device md0, logical block 2930074366
[1733527.609330] Buffer I/O error on device md0, logical block 0
[1733527.610040] Buffer I/O error on device md0, logical block 0
[1733527.610671] Buffer I/O error on device md0, logical block 1
[1733527.611241] Buffer I/O error on device md0, logical block 1
[1733527.611814] Buffer I/O error on device md0, logical block 2930074367
[1733527.612380] Buffer I/O error on device md0, logical block 2930074367
[1733537.593005] quiet_error: 921 callbacks suppressed
[1733537.593010] Buffer I/O error on device md0, logical block 2930074352
[1733537.593593] Buffer I/O error on device md0, logical block 2930074352
[1733537.594150] Buffer I/O error on device md0, logical block 2930074366
[1733537.594691] Buffer I/O error on device md0, logical block 2930074366
[1733537.595253] Buffer I/O error on device md0, logical block 0
[1733537.595805] Buffer I/O error on device md0, logical block 0
[1733537.596343] Buffer I/O error on device md0, logical block 1
[1733537.596867] Buffer I/O error on device md0, logical block 1
[1733537.597414] Buffer I/O error on device md0, logical block 2930074367
[1733537.597937] Buffer I/O error on device md0, logical block 2930074367
[1733547.595682] quiet_error: 921 callbacks suppressed
[1733547.595688] Buffer I/O error on device md0, logical block 2930074352
[1733547.596244] Buffer I/O error on device md0, logical block 2930074352
[1733547.596796] Buffer I/O error on device md0, logical block 2930074366
[1733547.597319] Buffer I/O error on device md0, logical block 2930074366
[1733547.597846] Buffer I/O error on device md0, logical block 0
[1733547.598339] Buffer I/O error on device md0, logical block 0
[1733547.598839] Buffer I/O error on device md0, logical block 1
[1733547.599330] Buffer I/O error on device md0, logical block 1
[1733547.599804] Buffer I/O error on device md0, logical block 2930074367
[1733547.600279] Buffer I/O error on device md0, logical block 2930074367
[1733552.390524] md0: detected capacity change from 12001584611328 to 0
[1733552.390533] md: md0 stopped.
[1733552.390543] md: unbind<sdb>
[1733552.412281] md: export_rdev(sdb)
[1733552.412397] md: unbind<sdh>
[1733552.444299] md: export_rdev(sdh)
[1733552.444360] md: unbind<sdg>
[1733552.461962] md: export_rdev(sdg)
[1733552.462035] md: unbind<sdf>
[1733552.492294] md: export_rdev(sdf)
[1733552.492378] md: unbind<sde>
[1733552.508275] md: export_rdev(sde)
[1733552.508349] md: unbind<sdd>
[1733552.540297] md: export_rdev(sdd)
[1733552.540357] md: unbind<sdc>
[1733552.572295] md: export_rdev(sdc)
[1733560.423340] md: md0 stopped.
[1733560.427502] md: bind<sde>
[1733560.427697] md: bind<sdf>
[1733560.427957] md: bind<sdg>
[1733560.428166] md: bind<sdh>
[1733560.428337] md: bind<sdb>
[1733560.428541] md: bind<sdd>
[1733584.903928] md: md0 stopped.
[1733584.903939] md: unbind<sdd>
[1733584.922262] md: export_rdev(sdd)
[1733584.922315] md: unbind<sdb>
[1733584.942271] md: export_rdev(sdb)
[1733584.942318] md: unbind<sdh>
[1733584.970263] md: export_rdev(sdh)
[1733584.970310] md: unbind<sdg>
[1733584.987098] md: export_rdev(sdg)
[1733584.987144] md: unbind<sdf>
[1733585.018274] md: export_rdev(sdf)
[1733585.018314] md: unbind<sde>
[1733585.033321] md: export_rdev(sde)
[1733586.307839] md: md0 stopped.
[1733586.310413] md: bind<sde>
[1733586.310607] md: bind<sdf>
[1733586.310860] md: bind<sdg>
[1733586.311072] md: bind<sdh>
[1733586.311226] md: bind<sdb>
[1733586.311779] md: bind<sdd>
[1733589.745206] md: md0 stopped.
[1733589.745216] md: unbind<sdd>
[1733589.769957] md: export_rdev(sdd)
[1733589.770074] md: unbind<sdb>
[1733589.797459] md: export_rdev(sdb)
[1733589.797512] md: unbind<sdh>
[1733589.817960] md: export_rdev(sdh)
[1733589.818047] md: unbind<sdg>
[1733589.827152] md: export_rdev(sdg)
[1733589.827216] md: unbind<sdf>
[1733589.849963] md: export_rdev(sdf)
[1733589.850060] md: unbind<sde>
[1733589.860244] md: export_rdev(sde)
[1733836.810758] md: md0 stopped.
[1733837.023979] md: bind<sde>
[1733837.024181] md: bind<sdf>
[1733837.024441] md: bind<sdg>
[1733837.024665] md: bind<sdh>
[1733837.024855] md: bind<sdb>
[1733837.025086] md: bind<sdd>
[1733837.025149] md: md0 stopped.
[1733837.025157] md: unbind<sdd>
[1733837.034535] md: export_rdev(sdd)
[1733837.034550] md: unbind<sdb>
[1733837.066503] md: export_rdev(sdb)
[1733837.066556] md: unbind<sdh>
[1733837.082517] md: export_rdev(sdh)
[1733837.082591] md: unbind<sdg>
[1733837.114479] md: export_rdev(sdg)
[1733837.114515] md: unbind<sdf>
[1733837.146499] md: export_rdev(sdf)
[1733837.146525] md: unbind<sde>
[1733837.172909] md: export_rdev(sde)
[1733905.179453] md: md0 stopped.
[1733905.393226] md: bind<sde>
[1733905.393371] md: bind<sdf>
[1733905.393598] md: bind<sdg>
[1733905.393803] md: bind<sdh>
[1733905.393952] md: bind<sdb>
[1733905.394177] md: bind<sdd>
[1733905.394223] md: md0 stopped.
[1733905.394229] md: unbind<sdd>
[1733905.430175] md: export_rdev(sdd)
[1733905.430209] md: unbind<sdb>
[1733905.444594] md: export_rdev(sdb)
[1733905.444635] md: unbind<sdh>
[1733905.462215] md: export_rdev(sdh)
[1733905.462241] md: unbind<sdg>
[1733905.494213] md: export_rdev(sdg)
[1733905.494247] md: unbind<sdf>
[1733905.510207] md: export_rdev(sdf)
[1733905.510232] md: unbind<sde>
[1733905.542207] md: export_rdev(sde)
[1733994.300356] md: md0 stopped.
[1733994.512443] md: bind<sde>
[1733994.512753] md: bind<sdf>
[1733994.513125] md: bind<sdg>
[1733994.513889] md: bind<sdh>
[1733994.514291] md: bind<sdb>
[1733994.514536] md: bind<sdd>
[1733994.514589] md: md0 stopped.
[1733994.514595] md: unbind<sdd>
[1733994.544600] md: export_rdev(sdd)
[1733994.544632] md: unbind<sdb>
[1733994.576625] md: export_rdev(sdb)
[1733994.576665] md: unbind<sdh>
[1733994.608622] md: export_rdev(sdh)
[1733994.608651] md: unbind<sdg>
[1733994.620628] md: export_rdev(sdg)
[1733994.620683] md: unbind<sdf>
[1733994.640611] md: export_rdev(sdf)
[1733994.640643] md: unbind<sde>
[1733994.652646] md: export_rdev(sde)
[1734018.673832] md: md0 stopped.
[1734019.650329] md: md0 stopped.
[1734021.521778] md: md0 stopped.
[1734021.543949] md: bind<sde>
[1734021.544166] md: bind<sdf>
[1734021.544628] md: bind<sdg>
[1734021.544858] md: bind<sdh>
[1734021.545036] md: bind<sdb>
[1734021.545250] md: bind<sdd>
[1734021.545302] md: md0 stopped.
[1734021.545325] md: unbind<sdd>
[1734021.563960] md: export_rdev(sdd)
[1734021.564010] md: unbind<sdb>
[1734021.582928] md: export_rdev(sdb)
[1734021.582958] md: unbind<sdh>
[1734021.598991] md: export_rdev(sdh)
[1734021.599053] md: unbind<sdg>
[1734021.630949] md: export_rdev(sdg)
[1734021.631003] md: unbind<sdf>
[1734021.662923] md: export_rdev(sdf)
[1734021.662953] md: unbind<sde>
[1734021.694961] md: export_rdev(sde)
[1734077.888347] md: md0 stopped.
[1734089.756221] md: md0 stopped.
[1734089.758972] md: bind<sde>
[1734089.759151] md: bind<sdf>
[1734089.759380] md: bind<sdg>
[1734089.759602] md: bind<sdh>
[1734089.759892] md: bind<sdd>
[1734089.759946] md: md0 stopped.
[1734089.759954] md: unbind<sdd>
[1734089.766753] md: export_rdev(sdd)
[1734089.766792] md: unbind<sdh>
[1734089.786671] md: export_rdev(sdh)
[1734089.786706] md: unbind<sdg>
[1734089.802727] md: export_rdev(sdg)
[1734089.802782] md: unbind<sdf>
[1734089.834678] md: export_rdev(sdf)
[1734089.834708] md: unbind<sde>
[1734089.866678] md: export_rdev(sde)
[1734223.073968] md: md0 stopped.

--nextPart5105205.ZJp99HT058--


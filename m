From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID5: failing an active component during spare rebuild - arrays hangs
Date: Sun, 17 Jul 2011 11:29:07 +0300
Message-ID: <CAGRgLy5uK5As96j2Tprfrx+qNhYqvFiVUEnOJ+3AAwpPMHCDYg@mail.gmail.com>
References: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
	<BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
	<20110622125409.14428883@notabene.brown>
	<BANLkTinijekK8Y6TTk6TYtYhv4Dn2YGQbA@mail.gmail.com>
	<20110628122921.42480f72@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110628122921.42480f72@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,
I am sorry for such a late response. I still hope we will be able to
get to the bottom of this. (I also have several other issues &
questions, but meanwhile I am managing by digging through mdadm code).

Here are the stacks of the relevant processes:

md1123_raid5:

[<ffffffff8105f08a>] __cond_resched+0x2a/0x40
[<ffffffffa006a17d>] raid5d+0x17d/0x1f0 [raid456]
[<ffffffff8148c516>] md_thread+0x116/0x150
[<ffffffff810871f6>] kthread+0x96/0xa0
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff

md1123_resync:

[<ffffffff8148c4f7>] md_thread+0xf7/0x150
[<ffffffff810871f6>] kthread+0x96/0xa0
[<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
[<ffffffffffffffff>] 0xffffffffffffffff

Another suspicious process:
/sbin/blkid -o udev -p /dev/md1123

[<ffffffff8110b470>] sync_page+0x40/0x50
[<ffffffff8110b48e>] sync_page_killable+0xe/0x40
[<ffffffff8110b397>] __lock_page_killable+0x67/0x70
[<ffffffff8110c547>] do_generic_file_read.clone.23+0x297/0x450
[<ffffffff8110d1ba>] generic_file_aio_read+0x1ca/0x240
[<ffffffff81164c82>] do_sync_read+0xd2/0x110
[<ffffffff81165463>] vfs_read+0xc3/0x180
[<ffffffff81165571>] sys_read+0x51/0x90
[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

And here is the output of sysrq-trigger (long):
root@c-11:~# echo w > /proc/sysrq-trigger
root@c-11:~# dmesg
[    0.000000] Initializing cgroup subsys cpuset
[    0.000000] Initializing cgroup subsys cpu
[    0.000000] Linux version 2.6.38-8-server (buildd@allspice) (gcc
version 4.5.2 (Ubuntu/Linaro 4.5.2-8ubuntu3) ) #42-Ubuntu SMP Mon Apr
11 03:49:04 UTC 2011 (Ubuntu 2.6.38-8.42-server 2.6.38.2)
[    0.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.38-8-server
root=3DUUID=3D01671ce6-dddb-481b-a8e5-818bbb7f83f3 ro quiet
[    0.000000] BIOS-provided physical RAM map:
[    0.000000]  BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
[    0.000000]  BIOS-e820: 000000000009f400 - 00000000000a0000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserve=
d)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000bfffd000 (usable)
[    0.000000]  BIOS-e820: 00000000bfffd000 - 00000000c0000000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000feffc000 - 00000000ff000000 (reserve=
d)
[    0.000000]  BIOS-e820: 00000000fffc0000 - 0000000100000000 (reserve=
d)
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] DMI 2.4 present.
[    0.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
[    0.000000] e820 update range: 0000000000000000 - 0000000000010000
(usable) =3D=3D> (reserved)
[    0.000000] e820 remove range: 00000000000a0000 - 0000000000100000 (=
usable)
[    0.000000] No AGP bridge found
[    0.000000] last_pfn =3D 0xbfffd max_arch_pfn =3D 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 00E0000000 mask FFE0000000 uncachable
[    0.000000]   1 disabled
[    0.000000]   2 disabled
[    0.000000]   3 disabled
[    0.000000]   4 disabled
[    0.000000]   5 disabled
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000] PAT not supported by CPU.
[    0.000000] found SMP MP-table at [ffff8800000fd790] fd790
[    0.000000] initial memory mapped : 0 - 20000000
[    0.000000] init_memory_mapping: 0000000000000000-00000000bfffd000
[    0.000000]  0000000000 - 00bfe00000 page 2M
[    0.000000]  00bfe00000 - 00bfffd000 page 4k
[    0.000000] kernel direct mapping tables up to bfffd000 @ 1fffb000-2=
0000000
[    0.000000] RAMDISK: 364ac000 - 3724e000
[    0.000000] ACPI: RSDP 00000000000fd740 00014 (v00 BOCHS )
[    0.000000] ACPI: RSDT 00000000bfffdc40 00034 (v01 BOCHS  BXPCRSDT
00000001 BXPC 00000001)
[    0.000000] ACPI: FACP 00000000bffffe70 00074 (v01 BOCHS  BXPCFACP
00000001 BXPC 00000001)
[    0.000000] ACPI: DSDT 00000000bfffde40 01FB7 (v01   BXPC   BXDSDT
00000001 INTL 20090123)
[    0.000000] ACPI: FACS 00000000bffffe00 00040
[    0.000000] ACPI: SSDT 00000000bfffdda0 0009E (v01 BOCHS  BXPCSSDT
00000001 BXPC 00000001)
[    0.000000] ACPI: APIC 00000000bfffdcc0 00072 (v01 BOCHS  BXPCAPIC
00000001 BXPC 00000001)
[    0.000000] ACPI: HPET 00000000bfffdc80 00038 (v01 BOCHS  BXPCHPET
00000001 BXPC 00000001)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at 0000000000000000-00000000bfffd000
[    0.000000] Initmem setup node 0 0000000000000000-00000000bfffd000
[    0.000000]   NODE_DATA [00000000bfff8000 - 00000000bfffcfff]
[    0.000000] kvm-clock: Using msrs 12 and 11
[    0.000000] kvm-clock: cpu 0, msr 0:1adfc81, boot clock
[    0.000000]  [ffffea0000000000-ffffea00029fffff] PMD ->
[ffff8800bc600000-ffff8800beffffff] on node 0
[    0.000000] Zone PFN ranges:
[    0.000000]   DMA      0x00000010 -> 0x00001000
[    0.000000]   DMA32    0x00001000 -> 0x00100000
[    0.000000]   Normal   empty
[    0.000000] Movable zone start PFN for each node
[    0.000000] early_node_map[2] active PFN ranges
[    0.000000]     0: 0x00000010 -> 0x0000009f
[    0.000000]     0: 0x00000100 -> 0x000bfffd
[    0.000000] On node 0 totalpages: 786316
[    0.000000]   DMA zone: 56 pages used for memmap
[    0.000000]   DMA zone: 6 pages reserved
[    0.000000]   DMA zone: 3921 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 10696 pages used for memmap
[    0.000000]   DMA32 zone: 771637 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0xb008
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
[    0.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec00000, GS=
I 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 high lev=
el)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high lev=
el)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 high l=
evel)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 high l=
evel)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ5 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] ACPI: IRQ10 used by override.
[    0.000000] ACPI: IRQ11 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
[    0.000000] nr_irqs_gsi: 40
[    0.000000] PM: Registered nosave memory: 000000000009f000 - 0000000=
0000a0000
[    0.000000] PM: Registered nosave memory: 00000000000a0000 - 0000000=
0000f0000
[    0.000000] PM: Registered nosave memory: 00000000000f0000 - 0000000=
000100000
[    0.000000] Allocating PCI resources starting at c0000000 (gap:
c0000000:3effc000)
[    0.000000] Booting paravirtualized kernel on KVM
[    0.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256
nr_cpu_ids:1 nr_node_ids:1
[    0.000000] PERCPU: Embedded 28 pages/cpu @ffff8800bfc00000 s84416
r8192 d22080 u2097152
[    0.000000] pcpu-alloc: s84416 r8192 d22080 u2097152 alloc=3D1*20971=
52
[    0.000000] pcpu-alloc: [0] 0
[    0.000000] kvm-clock: cpu 0, msr 0:bfc13c81, primary cpu clock
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.
Total pages: 775558
[    0.000000] Policy zone: DMA32
[    0.000000] Kernel command line:
BOOT_IMAGE=3D/boot/vmlinuz-2.6.38-8-server
root=3DUUID=3D01671ce6-dddb-481b-a8e5-818bbb7f83f3 ro quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Checking aperture...
[    0.000000] No AGP bridge found
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bai=
ling!
[    0.000000] Memory: 3074544k/3145716k available (6023k kernel code,
452k absent, 70720k reserved, 5025k data, 880k init)
[    0.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, MinObjec=
ts=3D0,
CPUs=3D1, Nodes=3D1
[    0.000000] Hierarchical RCU implementation.
[    0.000000]  RCU dyntick-idle grace-period acceleration is enabled.
[    0.000000]  RCU-based detection of stalled CPUs is disabled.
[    0.000000] NR_IRQS:16640 nr_irqs:256 16
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] allocated 31457280 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=3Dmemory' option if you don't
want memory cgroups
[    0.000000] hpet clockevent registered
[    0.000000] Detected 2400.084 MHz processor.
[    0.010000] Calibrating delay loop (skipped) preset value.. 4800.16
BogoMIPS (lpj=3D24000840)
[    0.010000] pid_max: default: 32768 minimum: 301
[    0.010000] Security Framework initialized
[    0.010000] AppArmor: AppArmor initialized
[    0.010000] Yama: becoming mindful.
[    0.010000] Dentry cache hash table entries: 524288 (order: 10,
4194304 bytes)
[    0.010000] Inode-cache hash table entries: 262144 (order: 9, 209715=
2 bytes)
[    0.010000] Mount-cache hash table entries: 256
[    0.010000] Initializing cgroup subsys ns
[    0.010000] ns_cgroup deprecated: consider using the
'clone_children' flag without the ns_cgroup.
[    0.010000] Initializing cgroup subsys cpuacct
[    0.010000] Initializing cgroup subsys memory
[    0.010000] Initializing cgroup subsys devices
[    0.010000] Initializing cgroup subsys freezer
[    0.010000] Initializing cgroup subsys net_cls
[    0.010000] Initializing cgroup subsys blkio
[    0.010014] mce: CPU supports 10 MCE banks
[    0.010215] SMP alternatives: switching to UP code
[    0.043346] Freeing SMP alternatives: 20k freed
[    0.043368] ACPI: Core revision 20110112
[    0.044515] ftrace: allocating 24611 entries in 97 pages
[    0.050203] Setting APIC routing to flat
[    0.060204] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin=
2=3D-1
[    0.060207] CPU0: Intel QEMU Virtual CPU version 0.14.0 stepping 03
[    0.070000] Performance Events: unsupported p6 CPU model 2 no PMU
driver, software events only.
[    0.070000] Brought up 1 CPUs
[    0.070000] Total of 1 processors activated (4800.16 BogoMIPS).
[    0.070000] devtmpfs: initialized
[    0.070000] print_constraints: dummy:
[    0.070000] Time:  8:12:59  Date: 07/17/11
[    0.070000] NET: Registered protocol family 16
[    0.070000] ACPI: bus type pci registered
[    0.070000] PCI: Using configuration type 1 for base access
[    0.070000] bio: create slab <bio-0> at 0
[    0.070000] ACPI: EC: Look up EC in DSDT
[    0.070000] ACPI: Interpreter enabled
[    0.070000] ACPI: (supports S0 S3 S4 S5)
[    0.070000] ACPI: Using IOAPIC for interrupt routing
[    0.072133] ACPI: No dock devices found.
[    0.072136] HEST: Table not found.
[    0.072139] PCI: Ignoring host bridge windows from ACPI; if
necessary, use "pci=3Duse_crs" and report a bug
[    0.072159] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
[    0.072227] pci_root PNP0A03:00: host bridge window [io
0x0000-0x0cf7] (ignored)
[    0.072230] pci_root PNP0A03:00: host bridge window [io
0x0d00-0xffff] (ignored)
[    0.072233] pci_root PNP0A03:00: host bridge window [mem
0x000a0000-0x000bffff] (ignored)
[    0.072236] pci_root PNP0A03:00: host bridge window [mem
0xe0000000-0xfebfffff] (ignored)
[    0.072281] pci 0000:00:00.0: [8086:1237] type 0 class 0x000600
[    0.072576] pci 0000:00:01.0: [8086:7000] type 0 class 0x000601
[    0.072946] pci 0000:00:01.1: [8086:7010] type 0 class 0x000101
[    0.073172] pci 0000:00:01.1: reg 20: [io  0xc000-0xc00f]
[    0.073360] pci 0000:00:01.3: [8086:7113] type 0 class 0x000680
[    0.073690] pci 0000:00:01.3: quirk: [io  0xb000-0xb03f] claimed by
PIIX4 ACPI
[    0.073702] pci 0000:00:01.3: quirk: [io  0xb100-0xb10f] claimed by =
PIIX4 SMB
[    0.073832] pci 0000:00:02.0: [1013:00b8] type 0 class 0x000300
[    0.100094] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffffff pre=
f]
[    0.127422] pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000fff]
[    0.250107] pci 0000:00:02.0: reg 30: [mem 0xf2010000-0xf201ffff pre=
f]
[    0.250340] pci 0000:00:03.0: [1af4:1000] type 0 class 0x000200
[    0.250464] pci 0000:00:03.0: reg 10: [io  0xc020-0xc03f]
[    0.250529] pci 0000:00:03.0: reg 14: [mem 0xf2020000-0xf2020fff]
[    0.251074] pci 0000:00:04.0: [1af4:1000] type 0 class 0x000200
[    0.251186] pci 0000:00:04.0: reg 10: [io  0xc040-0xc05f]
[    0.251251] pci 0000:00:04.0: reg 14: [mem 0xf2021000-0xf2021fff]
[    0.251786] pci 0000:00:05.0: [1000:0012] type 0 class 0x000100
[    0.251910] pci 0000:00:05.0: reg 10: [io  0xc100-0xc1ff]
[    0.252007] pci 0000:00:05.0: reg 14: [mem 0xf2022000-0xf20223ff]
[    0.252102] pci 0000:00:05.0: reg 18: [mem 0xf2024000-0xf2025fff]
[    0.252557] pci 0000:00:06.0: [1000:0012] type 0 class 0x000100
[    0.252679] pci 0000:00:06.0: reg 10: [io  0xc200-0xc2ff]
[    0.252776] pci 0000:00:06.0: reg 14: [mem 0xf2026000-0xf20263ff]
[    0.252873] pci 0000:00:06.0: reg 18: [mem 0xf2028000-0xf2029fff]
[    0.253536] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.260690] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
[    0.260801] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
[    0.260899] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
[    0.260994] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
[    0.261096] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
[    0.261475] vgaarb: device added:
PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
[    0.261481] vgaarb: loaded
[    0.261891] SCSI subsystem initialized
[    0.262155] libata version 3.00 loaded.
[    0.262284] usbcore: registered new interface driver usbfs
[    0.262304] usbcore: registered new interface driver hub
[    0.262363] usbcore: registered new device driver usb
[    0.262596] wmi: Mapper loaded
[    0.262603] PCI: Using ACPI for IRQ routing
[    0.262613] PCI: pci_cache_line_size set to 64 bytes
[    0.262807] reserve RAM buffer: 000000000009f400 - 000000000009ffff
[    0.262813] reserve RAM buffer: 00000000bfffd000 - 00000000bfffffff
[    0.263061] NetLabel: Initializing
[    0.263066] NetLabel:  domain hash size =3D 128
[    0.263068] NetLabel:  protocols =3D UNLABELED CIPSOv4
[    0.263094] NetLabel:  unlabeled traffic allowed by default
[    0.263195] HPET: 3 timers in total, 0 timers will be used for per-c=
pu timer
[    0.263227] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.263232] hpet0: 3 comparators, 64-bit 100.000000 MHz counter
[    0.270100] Switching to clocksource kvm-clock
[    0.279933] Switched to NOHz mode on CPU #0
[    0.285977] AppArmor: AppArmor Filesystem Enabled
[    0.286009] pnp: PnP ACPI init
[    0.286029] ACPI: bus type pnp registered
[    0.286070] pnp 00:00: [bus 00-ff]
[    0.286074] pnp 00:00: [io  0x0cf8-0x0cff]
[    0.286077] pnp 00:00: [io  0x0000-0x0cf7 window]
[    0.286079] pnp 00:00: [io  0x0d00-0xffff window]
[    0.286082] pnp 00:00: [mem 0x000a0000-0x000bffff window]
[    0.286085] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
[    0.286131] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 (activ=
e)
[    0.286214] pnp 00:01: [io  0x0070-0x0071]
[    0.286268] pnp 00:01: [irq 8]
[    0.286271] pnp 00:01: [io  0x0072-0x0077]
[    0.286321] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 (activ=
e)
[    0.286366] pnp 00:02: [io  0x0060]
[    0.286368] pnp 00:02: [io  0x0064]
[    0.286399] pnp 00:02: [irq 1]
[    0.286438] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 (activ=
e)
[    0.286496] pnp 00:03: [irq 12]
[    0.286549] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 (activ=
e)
[    0.286594] pnp 00:04: [io  0x03f2-0x03f5]
[    0.286596] pnp 00:04: [io  0x03f7]
[    0.286626] pnp 00:04: [irq 6]
[    0.286628] pnp 00:04: [dma 2]
[    0.286667] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 (activ=
e)
[    0.286741] pnp 00:05: [io  0x0378-0x037f]
[    0.286771] pnp 00:05: [irq 7]
[    0.286825] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 (activ=
e)
[    0.286931] pnp 00:06: [io  0x03f8-0x03ff]
[    0.286962] pnp 00:06: [irq 4]
[    0.287003] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 (activ=
e)
[    0.287071] pnp 00:07: [mem 0xfed00000-0xfed003ff]
[    0.287111] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 (activ=
e)
[    0.287321] pnp: PnP ACPI: found 8 devices
[    0.287323] ACPI: ACPI bus type pnp unregistered
[    0.294697] pci_bus 0000:00: resource 0 [io  0x0000-0xffff]
[    0.294701] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffffffffff=
]
[    0.294761] NET: Registered protocol family 2
[    0.295003] IP route cache hash table entries: 131072 (order: 8,
1048576 bytes)
[    0.297429] TCP established hash table entries: 524288 (order: 11,
8388608 bytes)
[    0.308286] TCP bind hash table entries: 65536 (order: 8, 1048576 by=
tes)
[    0.309607] TCP: Hash tables configured (established 524288 bind 655=
36)
[    0.309613] TCP reno registered
[    0.309624] UDP hash table entries: 2048 (order: 4, 65536 bytes)
[    0.309732] UDP-Lite hash table entries: 2048 (order: 4, 65536 bytes=
)
[    0.309950] NET: Registered protocol family 1
[    0.309979] pci 0000:00:00.0: Limiting direct PCI/PCI transfers
[    0.310039] pci 0000:00:01.0: PIIX3: Enabling Passive Release
[    0.310070] pci 0000:00:01.0: Activating ISA DMA hang workarounds
[    0.310114] pci 0000:00:02.0: Boot video device
[    0.310164] PCI: CLS 0 bytes, default 64
[    0.310648] audit: initializing netlink socket (disabled)
[    0.310665] type=3D2000 audit(1310890380.310:1): initialized
[    0.329649] Trying to unpack rootfs image as initramfs...
[    0.343100] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.345720] VFS: Disk quotas dquot_6.5.2
[    0.345818] Dquot-cache hash table entries: 512 (order 0, 4096 bytes=
)
[    0.350221] fuse init (API version 7.16)
[    0.350363] msgmni has been set to 6005
[    0.360437] Block layer SCSI generic (bsg) driver version 0.4
loaded (major 253)
[    0.360489] io scheduler noop registered
[    0.360491] io scheduler deadline registered (default)
[    0.360558] io scheduler cfq registered
[    0.360691] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.360729] pciehp: PCI Express Hot Plug Controller Driver version: =
0.4
[    0.360835] efifb: probing for efifb
[    0.360960] efifb: framebuffer at 0xf0000000, mapped to
0xffffc90001080000, using 1408k, total 1408k
[    0.360963] efifb: mode is 800x600x24, linelength=3D2400, pages=3D1
[    0.360965] efifb: scrolling: redraw
[    0.360970] efifb: Truecolor: size=3D0:8:8:8, shift=3D0:16:8:0
[    0.364483] Console: switching to colour frame buffer device 100x37
[    0.367114] fb0: EFI VGA frame buffer device
[    0.367280] input: Power Button as
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.367298] ACPI: Power Button [PWRF]
[    0.367787] ACPI: acpi_idle registered with cpuidle
[    0.368885] ERST: Table is not found!
[    0.369113] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
[    0.369154] virtio-pci 0000:00:03.0: PCI INT A -> Link[LNKC] -> GSI
11 (level, high) -> IRQ 11
[    0.369195] virtio-pci 0000:00:03.0: setting latency timer to 64
[    0.369468] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
[    0.369501] virtio-pci 0000:00:04.0: PCI INT A -> Link[LNKD] -> GSI
10 (level, high) -> IRQ 10
[    0.369532] virtio-pci 0000:00:04.0: setting latency timer to 64
[    0.369692] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
[    0.391693] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.415046] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
[    0.415314] Linux agpgart interface v0.103
[    0.417096] brd: module loaded
[    0.417940] loop: module loaded
[    0.418050] i2c-core: driver [adp5520] using legacy suspend method
[    0.418053] i2c-core: driver [adp5520] using legacy resume method
[    0.470377] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
[    0.470385] sym53c8xx 0000:00:05.0: PCI INT A -> Link[LNKA] -> GSI
10 (level, high) -> IRQ 10
[    0.471958] sym0: <895a> rev 0x0 at pci 0000:00:05.0 irq 10
[    0.482464] sym0: No NVRAM, ID 7, Fast-40, LVD, parity checking
[    0.490019] sym0: SCSI BUS has been reset.
[    0.492876] scsi0 : sym-2.2.3
[    0.500347] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
[    0.500353] sym53c8xx 0000:00:06.0: PCI INT A -> Link[LNKB] -> GSI
11 (level, high) -> IRQ 11
[    0.501884] sym1: <895a> rev 0x0 at pci 0000:00:06.0 irq 11
[    0.512272] sym1: No NVRAM, ID 7, Fast-40, LVD, parity checking
[    0.520021] sym1: SCSI BUS has been reset.
[    0.522707] scsi1 : sym-2.2.3
[    0.530183] ata_piix 0000:00:01.1: version 2.13
[    0.530331] ata_piix 0000:00:01.1: setting latency timer to 64
[    0.530964] scsi2 : ata_piix
[    0.540221] scsi3 : ata_piix
[    0.540303] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0xc000 i=
rq 14
[    0.540307] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0xc008 i=
rq 15
[    0.540768] Fixed MDIO Bus: probed
[    0.540818] PPP generic driver version 2.4.2
[    0.540908] tun: Universal TUN/TAP device driver, 1.6
[    0.540910] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[    0.541189] virtio-pci 0000:00:03.0: irq 40 for MSI/MSI-X
[    0.541215] virtio-pci 0000:00:03.0: irq 41 for MSI/MSI-X
[    0.541241] virtio-pci 0000:00:03.0: irq 42 for MSI/MSI-X
[    0.544222] virtio-pci 0000:00:04.0: irq 43 for MSI/MSI-X
[    0.544251] virtio-pci 0000:00:04.0: irq 44 for MSI/MSI-X
[    0.544277] virtio-pci 0000:00:04.0: irq 45 for MSI/MSI-X
[    0.546511] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driv=
er
[    0.546548] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.546562] uhci_hcd: USB Universal Host Controller Interface driver
[    0.546700] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:MOU]
at 0x60,0x64 irq 1,12
[    0.547490] serio: i8042 KBD port at 0x60,0x64 irq 1
[    0.547501] serio: i8042 AUX port at 0x60,0x64 irq 12
[    0.547623] mousedev: PS/2 mouse device common for all mice
[    0.547865] rtc_cmos 00:01: rtc core: registered rtc_cmos as rtc0
[    0.548007] rtc0: alarms up to one day, 114 bytes nvram, hpet irqs
[    0.548160] device-mapper: uevent: version 1.0.3
[    0.548315] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07)
initialised: dm-devel@redhat.com
[    0.548739] input: AT Translated Set 2 keyboard as
/devices/platform/i8042/serio0/input/input1
[    0.549555] device-mapper: multipath: version 1.2.0 loaded
[    0.549566] device-mapper: multipath round-robin: version 1.0.0 load=
ed
[    0.550074] cpuidle: using governor ladder
[    0.550080] cpuidle: using governor menu
[    0.550421] TCP cubic registered
[    0.550617] NET: Registered protocol family 10
[    0.551795] NET: Registered protocol family 17
[    0.551834] Registering the dns_resolver key type
[    0.552039] PM: Hibernation image not present or could not be loaded=
=2E
[    0.552060] registered taskstats version 1
[    0.552295]   Magic number: 3:298:220
[    0.552356] dmi id: hash matches
[    0.552362] scsi: waiting for bus probes to complete ...
[    0.700853] ata2.01: NODEV after polling detection
[    0.701237] ata1.01: NODEV after polling detection
[    0.701613] ata2.00: ATAPI: QEMU DVD-ROM, 0.14.0, max UDMA/100
[    0.701842] ata1.00: ATA-7: QEMU HARDDISK, 0.14.0, max UDMA/100
[    0.701846] ata1.00: 6291456 sectors, multi 16: LBA48
[    0.702483] ata2.00: configured for MWDMA2
[    0.702902] ata1.00: configured for MWDMA2
[    0.702941] scsi: waiting for bus probes to complete ...
[    0.865171] Freeing initrd memory: 13960k freed
[    1.320192] Refined TSC clocksource calibration: 2400.078 MHz.
[    3.500279] sym0: unknown interrupt(s) ignored, ISTAT=3D0x5 DSTAT=3D=
0x80 SIST=3D0x0
[    3.500350] scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK
  0.14 PQ: 0 ANSI: 5
[    3.500359] scsi target0:0:0: tagged command queuing enabled,
command queue depth 16.
[    3.500378] scsi target0:0:0: Beginning Domain Validation
[    3.500866] scsi target0:0:0: Domain Validation skipping write tests
[    3.500869] scsi target0:0:0: Ending Domain Validation
[    3.501073] scsi 0:0:1:0: Direct-Access     QEMU     QEMU HARDDISK
  0.14 PQ: 0 ANSI: 5
[    3.501079] scsi target0:0:1: tagged command queuing enabled,
command queue depth 16.
[    3.501084] scsi target0:0:1: Beginning Domain Validation
[    3.501553] scsi target0:0:1: Domain Validation skipping write tests
[    3.501556] scsi target0:0:1: Ending Domain Validation
[    3.501792] scsi 0:0:2:0: Direct-Access     QEMU     QEMU HARDDISK
  0.14 PQ: 0 ANSI: 5
[    3.501797] scsi target0:0:2: tagged command queuing enabled,
command queue depth 16.
[    3.501802] scsi target0:0:2: Beginning Domain Validation
[    3.502269] scsi target0:0:2: Domain Validation skipping write tests
[    3.502273] scsi target0:0:2: Ending Domain Validation
[    3.502448] scsi 0:0:3:0: Direct-Access     QEMU     QEMU HARDDISK
  0.14 PQ: 0 ANSI: 5
[    3.502454] scsi target0:0:3: tagged command queuing enabled,
command queue depth 16.
[    3.502458] scsi target0:0:3: Beginning Domain Validation
[    3.502928] scsi target0:0:3: Domain Validation skipping write tests
[    3.502931] scsi target0:0:3: Ending Domain Validation
[    3.503145] scsi 0:0:4:0: Direct-Access     QEMU     QEMU HARDDISK
  0.14 PQ: 0 ANSI: 5
[    3.503150] scsi target0:0:4: tagged command queuing enabled,
command queue depth 16.
[    3.503155] scsi target0:0:4: Beginning Domain Validation
[    3.503679] scsi target0:0:4: Domain Validation skipping write tests
[    3.503683] scsi target0:0:4: Ending Domain Validation
[    3.503887] scsi 0:0:5:0: Direct-Access     QEMU     QEMU HARDDISK
  0.14 PQ: 0 ANSI: 5
[    3.503893] scsi target0:0:5: tagged command queuing enabled,
command queue depth 16.
[    3.503898] scsi target0:0:5: Beginning Domain Validation
[    3.504365] scsi target0:0:5: Domain Validation skipping write tests
[    3.504368] scsi target0:0:5: Ending Domain Validation
[    3.504560] scsi 0:0:6:0: Direct-Access     QEMU     QEMU HARDDISK
  0.14 PQ: 0 ANSI: 5
[    3.504566] scsi target0:0:6: tagged command queuing enabled,
command queue depth 16.
[    3.504571] scsi target0:0:6: Beginning Domain Validation
[    3.505035] scsi target0:0:6: Domain Validation skipping write tests
[    3.505039] scsi target0:0:6: Ending Domain Validation
[    3.507100] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    3.507330] sd 0:0:1:0: Attached scsi generic sg1 type 0
[    3.507568] sd 0:0:2:0: Attached scsi generic sg2 type 0
[    3.507795] sd 0:0:3:0: Attached scsi generic sg3 type 0
[    3.507990] sd 0:0:4:0: Attached scsi generic sg4 type 0
[    3.508233] sd 0:0:5:0: Attached scsi generic sg5 type 0
[    3.508494] sd 0:0:6:0: Attached scsi generic sg6 type 0
[    3.508754] sd 0:0:0:0: [sda] 41943040 512-byte logical blocks:
(21.4 GB/20.0 GiB)
[    3.509042] sd 0:0:0:0: [sda] Write Protect is off
[    3.509046] sd 0:0:0:0: [sda] Mode Sense: 1f 00 00 08
[    3.509185] sd 0:0:0:0: [sda] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.510419] sd 0:0:1:0: [sdb] 41943040 512-byte logical blocks:
(21.4 GB/20.0 GiB)
[    3.510716] sd 0:0:1:0: [sdb] Write Protect is off
[    3.510721] sd 0:0:1:0: [sdb] Mode Sense: 1f 00 00 08
[    3.510860] sd 0:0:1:0: [sdb] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.512051] sd 0:0:2:0: [sdc] 41943040 512-byte logical blocks:
(21.4 GB/20.0 GiB)
[    3.512330] sd 0:0:2:0: [sdc] Write Protect is off
[    3.512334] sd 0:0:2:0: [sdc] Mode Sense: 1f 00 00 08
[    3.512474] sd 0:0:2:0: [sdc] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.513724]  sda: unknown partition table
[    3.514364] sd 0:0:0:0: [sda] Attached SCSI disk
[    3.514513] sd 0:0:3:0: [sdd] 41943040 512-byte logical blocks:
(21.4 GB/20.0 GiB)
[    3.514787] sd 0:0:3:0: [sdd] Write Protect is off
[    3.514791] sd 0:0:3:0: [sdd] Mode Sense: 1f 00 00 08
[    3.514929] sd 0:0:3:0: [sdd] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.516114] sd 0:0:4:0: [sde] 41943040 512-byte logical blocks:
(21.4 GB/20.0 GiB)
[    3.516392] sd 0:0:4:0: [sde] Write Protect is off
[    3.516396] sd 0:0:4:0: [sde] Mode Sense: 1f 00 00 08
[    3.516534] sd 0:0:4:0: [sde] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.517298]  sdb: unknown partition table
[    3.517982] sd 0:0:1:0: [sdb] Attached SCSI disk
[    3.518130] sd 0:0:5:0: [sdf] 2097152 512-byte logical blocks:
(1.07 GB/1.00 GiB)
[    3.518407] sd 0:0:5:0: [sdf] Write Protect is off
[    3.518410] sd 0:0:5:0: [sdf] Mode Sense: 1f 00 00 08
[    3.518549] sd 0:0:5:0: [sdf] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.519661]  sdc: unknown partition table
[    3.520315] sd 0:0:2:0: [sdc] Attached SCSI disk
[    3.520462] sd 0:0:6:0: [sdg] 2097152 512-byte logical blocks:
(1.07 GB/1.00 GiB)
[    3.520737] sd 0:0:6:0: [sdg] Write Protect is off
[    3.520741] sd 0:0:6:0: [sdg] Mode Sense: 1f 00 00 08
[    3.520880] sd 0:0:6:0: [sdg] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.521927]  sdd: unknown partition table
[    3.522571] sd 0:0:3:0: [sdd] Attached SCSI disk
[    3.522593]  sde: unknown partition table
[    3.523198] sd 0:0:4:0: [sde] Attached SCSI disk
[    3.524137]  sdf: unknown partition table
[    3.524759] sd 0:0:5:0: [sdf] Attached SCSI disk
[    3.524782]  sdg: unknown partition table
[    3.525387] sd 0:0:6:0: [sdg] Attached SCSI disk
[    3.530161] sym1: unknown interrupt(s) ignored, ISTAT=3D0x5 DSTAT=3D=
0x80 SIST=3D0x0
[    3.530202] scsi 1:0:0:0: Direct-Access     QEMU     QEMU HARDDISK
  0.14 PQ: 0 ANSI: 5
[    3.530208] scsi target1:0:0: tagged command queuing enabled,
command queue depth 16.
[    3.530213] scsi target1:0:0: Beginning Domain Validation
[    3.530686] scsi target1:0:0: Domain Validation skipping write tests
[    3.530690] scsi target1:0:0: Ending Domain Validation
[    3.530870] scsi 1:0:1:0: Direct-Access     QEMU     QEMU HARDDISK
  0.14 PQ: 0 ANSI: 5
[    3.530875] scsi target1:0:1: tagged command queuing enabled,
command queue depth 16.
[    3.530880] scsi target1:0:1: Beginning Domain Validation
[    3.531346] scsi target1:0:1: Domain Validation skipping write tests
[    3.531349] scsi target1:0:1: Ending Domain Validation
[    3.531526] scsi 1:0:2:0: Direct-Access     QEMU     QEMU HARDDISK
  0.14 PQ: 0 ANSI: 5
[    3.531537] scsi target1:0:2: tagged command queuing enabled,
command queue depth 16.
[    3.531542] scsi target1:0:2: Beginning Domain Validation
[    3.532008] scsi target1:0:2: Domain Validation skipping write tests
[    3.532011] scsi target1:0:2: Ending Domain Validation
[    3.534793] sd 1:0:0:0: Attached scsi generic sg7 type 0
[    3.534998] sd 1:0:1:0: Attached scsi generic sg8 type 0
[    3.535201] sd 1:0:2:0: Attached scsi generic sg9 type 0
[    3.535344] rtc_cmos 00:01: setting system clock to 2011-07-17
08:13:02 UTC (1310890382)
[    3.535349] BIOS EDD facility v0.16 2004-Jun-25, 0 devices found
[    3.535351] EDD information not available.
[    3.535519] scsi 2:0:0:0: Direct-Access     ATA      QEMU HARDDISK
  0.14 PQ: 0 ANSI: 5
[    3.535697] sd 2:0:0:0: Attached scsi generic sg10 type 0
[    3.535918] sd 1:0:0:0: [sdh] 2097152 512-byte logical blocks:
(1.07 GB/1.00 GiB)
[    3.536196] sd 1:0:0:0: [sdh] Write Protect is off
[    3.536200] sd 1:0:0:0: [sdh] Mode Sense: 1f 00 00 08
[    3.536339] sd 1:0:0:0: [sdh] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.537563] scsi 3:0:0:0: CD-ROM            QEMU     QEMU DVD-ROM
  0.14 PQ: 0 ANSI: 5
[    3.538417] sr0: scsi3-mmc drive: 4x/4x xa/form2 tray
[    3.538429] cdrom: Uniform CD-ROM driver Revision: 3.20
[    3.538568] sr 3:0:0:0: Attached scsi CD-ROM sr0
[    3.538649] sr 3:0:0:0: Attached scsi generic sg11 type 5
[    3.538861] sd 1:0:1:0: [sdi] 2097152 512-byte logical blocks:
(1.07 GB/1.00 GiB)
[    3.539141] sd 1:0:1:0: [sdi] Write Protect is off
[    3.539145] sd 1:0:1:0: [sdi] Mode Sense: 1f 00 00 08
[    3.539284] sd 1:0:1:0: [sdi] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.540394] sd 1:0:2:0: [sdj] 2097152 512-byte logical blocks:
(1.07 GB/1.00 GiB)
[    3.540670] sd 1:0:2:0: [sdj] Write Protect is off
[    3.540674] sd 1:0:2:0: [sdj] Mode Sense: 1f 00 00 08
[    3.540812] sd 1:0:2:0: [sdj] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.541627] sd 2:0:0:0: [sdk] 6291456 512-byte logical blocks:
(3.22 GB/3.00 GiB)
[    3.541686] sd 2:0:0:0: [sdk] Write Protect is off
[    3.541689] sd 2:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[    3.541715] sd 2:0:0:0: [sdk] Write cache: disabled, read cache:
enabled, doesn't support DPO or FUA
[    3.542886]  sdh: unknown partition table
[    3.543573] sd 1:0:0:0: [sdh] Attached SCSI disk
[    3.543593]  sdk: sdk1 sdk2 < sdk5 >
[    3.543971] sd 2:0:0:0: [sdk] Attached SCSI disk
[    3.544235]  sdi: unknown partition table
[    3.544904] sd 1:0:1:0: [sdi] Attached SCSI disk
[    3.544927]  sdj: unknown partition table
[    3.545527] sd 1:0:2:0: [sdj] Attached SCSI disk
[    3.547939] Freeing unused kernel memory: 880k freed
[    3.548487] Write protecting the kernel read-only data: 10240k
[    3.549192] Freeing unused kernel memory: 104k freed
[    3.556492] Freeing unused kernel memory: 1416k freed
[    3.585709] <30>udev[70]: starting version 167
[    3.622636] md: linear personality registered for level -1
[    3.625882] md: multipath personality registered for level -4
[    3.634679] md: raid0 personality registered for level 0
[    3.647068] md: raid1 personality registered for level 1
[    3.654145] async_tx: api initialized (async)
[    3.820061] raid6: int64x1   1469 MB/s
[    3.990046] raid6: int64x2   1892 MB/s
[    4.160050] raid6: int64x4   1278 MB/s
[    4.330042] raid6: int64x8   1346 MB/s
[    4.500019] raid6: sse2x1    6524 MB/s
[    4.670017] raid6: sse2x2    7954 MB/s
[    4.840018] raid6: sse2x4    8808 MB/s
[    4.840020] raid6: using algorithm sse2x4 (8808 MB/s)
[    4.849194] xor: automatically using best checksumming function: gen=
eric_sse
[    4.890032]    generic_sse:   184.000 MB/sec
[    4.890034] xor: using function: generic_sse (184.000 MB/sec)
[    4.938302] md: raid6 personality registered for level 6
[    4.938308] md: raid5 personality registered for level 5
[    4.938309] md: raid4 personality registered for level 4
[    4.953743] md: raid10 personality registered for level 10
[    5.050518] FDC 0 is a S82078B
[    5.073900] EXT4-fs (sdk1): mounted filesystem with ordered data
mode. Opts: (null)
[    5.564195] <30>udev[318]: starting version 167
[    5.580600] Adding 313340k swap on /dev/sdk5.  Priority:-1
extents:1 across:313340k
[    5.628302] lp: driver loaded but no devices found
[    5.694797] EXT4-fs (sdk1): re-mounted. Opts: errors=3Dremount-ro
[    5.775888] piix4_smbus 0000:00:01.3: SMBus Host Controller at
0xb100, revision 0
[    6.049026] RPC: Registered udp transport module.
[    6.049030] RPC: Registered tcp transport module.
[    6.049032] RPC: Registered tcp NFSv4.1 backchannel transport module=
=2E
[    6.126806] FS-Cache: Loaded
[    6.155722] parport_pc 00:05: reported by Plug and Play ACPI
[    6.155855] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
[    6.201241] FS-Cache: Netfs 'nfs' registered for caching
[    6.242319] type=3D1400 audit(1310890385.202:2): apparmor=3D"STATUS"
operation=3D"profile_load" name=3D"/sbin/dhclient" pid=3D466
comm=3D"apparmor_parser"
[    6.243477] type=3D1400 audit(1310890385.202:3): apparmor=3D"STATUS"
operation=3D"profile_load"
name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D466
comm=3D"apparmor_parser"
[    6.244050] type=3D1400 audit(1310890385.202:4): apparmor=3D"STATUS"
operation=3D"profile_load"
name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D466
comm=3D"apparmor_parser"
[    6.315981] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    6.431932] Loading iSCSI transport class v2.0-870.
[    6.483340] iscsi: registered transport (tcp)
[    6.588133] iscsi: registered transport (iser)
[    6.617974] iscsid (585): /proc/585/oom_adj is deprecated, please
use /proc/585/oom_score_adj instead.
[    6.984170] type=3D1400 audit(1310890385.942:5): apparmor=3D"STATUS"
operation=3D"profile_replace" name=3D"/sbin/dhclient" pid=3D781
comm=3D"apparmor_parser"
[    6.992532] lp0: using parport0 (interrupt-driven).
[    6.996255] type=3D1400 audit(1310890385.952:6): apparmor=3D"STATUS"
operation=3D"profile_replace"
name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D781
comm=3D"apparmor_parser"
[    6.998575] type=3D1400 audit(1310890385.952:7): apparmor=3D"STATUS"
operation=3D"profile_replace"
name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D781
comm=3D"apparmor_parser"
[    7.002830] type=3D1400 audit(1310890385.962:8): apparmor=3D"STATUS"
operation=3D"profile_load" name=3D"/usr/sbin/mysqld" pid=3D792
comm=3D"apparmor_parser"
[    7.012676] type=3D1400 audit(1310890385.972:9): apparmor=3D"STATUS"
operation=3D"profile_load" name=3D"/usr/sbin/tcpdump" pid=3D798
comm=3D"apparmor_parser"
[    7.193731] ppdev: user-space parallel port driver
[    7.270891] input: ImExPS/2 Generic Explorer Mouse as
/devices/platform/i8042/serio1/input/input2
[    7.708155] [1010]: scst: scst_register_device:962:Attached to
scsi0, channel 0, id 0, lun 0, type 0
[    7.708164] [1010]: scst: scst_register_device:962:Attached to
scsi0, channel 0, id 1, lun 0, type 0
[    7.708172] [1010]: scst: scst_register_device:962:Attached to
scsi0, channel 0, id 2, lun 0, type 0
[    7.708179] [1010]: scst: scst_register_device:962:Attached to
scsi0, channel 0, id 3, lun 0, type 0
[    7.708186] [1010]: scst: scst_register_device:962:Attached to
scsi0, channel 0, id 4, lun 0, type 0
[    7.708193] [1010]: scst: scst_register_device:962:Attached to
scsi0, channel 0, id 5, lun 0, type 0
[    7.708200] [1010]: scst: scst_register_device:962:Attached to
scsi0, channel 0, id 6, lun 0, type 0
[    7.708207] [1010]: scst: scst_register_device:962:Attached to
scsi1, channel 0, id 0, lun 0, type 0
[    7.708214] [1010]: scst: scst_register_device:962:Attached to
scsi1, channel 0, id 1, lun 0, type 0
[    7.708221] [1010]: scst: scst_register_device:962:Attached to
scsi1, channel 0, id 2, lun 0, type 0
[    7.708229] [1010]: scst: scst_register_device:962:Attached to
scsi2, channel 0, id 0, lun 0, type 0
[    7.708245] [1010]: scst: scst_register_device:962:Attached to
scsi3, channel 0, id 0, lun 0, type 5
[    7.708256] [1011]: scst: sysfs_work_thread_fn:518:User interface
thread started, PID 1011
[    7.711605] [1015]: scst: scst_cmd_thread:4288:Processing thread
scstd0 (PID 1015) started
[    7.711621] [1016]: scst: scst_init_thread:4032:Init thread started,=
 PID 1016
[    7.711634] [1017]: scst: scst_tm_thread:5804:Task management
thread started, PID 1017
[    7.711640] [1010]: scst: init_scst:2349:SCST version 2.1.0-rc1
loaded successfully (max mem for commands 754MB, per device 301MB)
[    7.711644] [1010]: scst: scst_print_config:2144:Enabled features:
EXTRACHECKS, DEBUG
[    7.717828] [1019]: scst:
__scst_register_virtual_dev_driver:1520:Virtual device handler
vdisk_fileio for type 0 registered successfully
[    7.717835] [1019]: scst:
__scst_register_virtual_dev_driver:1520:Virtual device handler
vdisk_blockio for type 0 registered successfully
[    7.717840] [1019]: scst:
__scst_register_virtual_dev_driver:1520:Virtual device handler
vdisk_nullio for type 0 registered successfully
[    7.717845] [1019]: scst:
__scst_register_virtual_dev_driver:1520:Virtual device handler vcdrom
for type 5 registered successfully
[    7.718208] [1018]: scst: scst_global_mgmt_thread:6584:Management
thread started, PID 1018
[    7.741409] [1027]: iscsi-scst: iscsi_init:4026:iSCSI SCST Target -
version 2.1.0-rc1
[    7.741559] [1027]: iscsi-scst: iscsi_init:4056:***WARNING***:
CONFIG_TCP_ZERO_COPY_TRANSFER_COMPLETION_NOTIFICATION not enabled in
your kernel. ISCSI-SCST will be working with not the best performance.
Refer README file for details.
[    7.741604] [1027]: scst:
__scst_register_target_template:318:Target template iscsi registered
successfully
[    7.742165] [1028]: iscsi-scst: istrd:1085:Read thread for pool
ffff8800b7cb99c0 started, PID 1028
[    7.742180] [1029]: iscsi-scst: istrd:1085:Read thread for pool
ffff8800b7cb99c0 started, PID 1029
[    7.742194] [1030]: iscsi-scst: istwr:1856:Write thread for pool
ffff8800b7cb99c0 started, PID 1030
[    7.745931] [1031]: iscsi-scst: istwr:1856:Write thread for pool
ffff8800b7cb99c0 started, PID 1031
[   16.560135] eth0: no IPv6 routers present
[  170.648177] md: bind<sda>
[  170.648521] md: bind<sdb>
[  170.648740] md: bind<sdc>
[  170.656510] bio: create slab <bio-1> at 1
[  170.656540] md/raid:md1123: device sdb operational as raid disk 1
[  170.656543] md/raid:md1123: device sda operational as raid disk 0
[  170.657080] md/raid:md1123: allocated 3230kB
[  170.659433] md/raid:md1123: raid level 5 active with 2 out of 3
devices, algorithm 2
[  170.659608] RAID conf printout:
[  170.659611]  --- level:5 rd:3 wd:2
[  170.659614]  disk 0, o:1, dev:sda
[  170.659616]  disk 1, o:1, dev:sdb
[  170.659893] created bitmap (1 pages) for device md1123
[  170.660415] md1123: bitmap initialized from disk: read 1/1 pages,
set 320 bits
[  170.674166] md1123: detected capacity change from 0 to 42946527232
[  170.676006] RAID conf printout:
[  170.676010]  --- level:5 rd:3 wd:2
[  170.676013]  disk 0, o:1, dev:sda
[  170.676015]  disk 1, o:1, dev:sdb
[  170.676017]  disk 2, o:1, dev:sdc
[  170.676175]  md1123: unknown partition table
[  170.676597] md: recovery of RAID array md1123
[  170.676601] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  170.676603] md: using maximum available idle IO bandwidth (but not
more than 200000 KB/sec) for recovery.
[  170.676607] md: using 128k window, over a total of 20969984 blocks.
[  176.678537] md/raid:md1123: Disk failure on sda, disabling device.
[  176.678539] md/raid:md1123: Operation continuing on 1 devices.
[  176.740093] md: md1123: recovery done.
[  177.691653] md: md1123 still in use.
[  216.311462] md: md1123 still in use.
[  228.591860] md: cannot remove active disk sda from md1123 ...
[  230.141428] md: cannot remove active disk sdb from md1123 ...
[  231.221410] md: cannot remove active disk sdc from md1123 ...
[  504.910634] SysRq : Show Blocked State
[  504.910729]   task                        PC stack   pid father
[  504.910749] blkid           D 0000000000000000     0  1337      1 0x=
00000000
[  504.910753]  ffff8800b509bbf8 0000000000000086 ffff8800b509bfd8
ffff8800b509a000
[  504.910756]  0000000000013d00 ffff8800b796b178 ffff8800b509bfd8
0000000000013d00
[  504.910758]  ffff8800b5bf96e0 ffff8800b796adc0 ffff8800bffcb248
ffff8800bfc13d00
[  504.910761] Call Trace:
[  504.910770]  [<ffffffff8110b480>] ? sync_page_killable+0x0/0x40
[  504.910774]  [<ffffffff815d5720>] io_schedule+0x70/0xc0
[  504.910776]  [<ffffffff8110b470>] sync_page+0x40/0x50
[  504.910778]  [<ffffffff8110b48e>] sync_page_killable+0xe/0x40
[  504.910780]  [<ffffffff815d5cea>] __wait_on_bit_lock+0x5a/0xc0
[  504.910783]  [<ffffffff8110b397>] __lock_page_killable+0x67/0x70
[  504.910787]  [<ffffffff81087980>] ? wake_bit_function+0x0/0x50
[  504.910789]  [<ffffffff8110c547>] do_generic_file_read.clone.23+0x29=
7/0x450
[  504.910792]  [<ffffffff8110d1ba>] generic_file_aio_read+0x1ca/0x240
[  504.910796]  [<ffffffff81164c82>] do_sync_read+0xd2/0x110
[  504.910807]  [<ffffffff81279083>] ? security_file_permission+0x93/0x=
b0
[  504.910809]  [<ffffffff81164fa1>] ? rw_verify_area+0x61/0xf0
[  504.910811]  [<ffffffff81165463>] vfs_read+0xc3/0x180
[  504.910813]  [<ffffffff81165571>] sys_read+0x51/0x90
[  504.910816]  [<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
[  504.910821] Sched Debug Version: v0.10, 2.6.38-8-server #42-Ubuntu
[  504.910823] ktime                                   : 504910.820117
[  504.910824] sched_clk                               : 953864697.5973=
71
[  504.910826] cpu_clk                                 : 504910.820189
[  504.910827] jiffies                                 : 4294987787
[  504.910828] sched_clock_stable                      : 0
[  504.910829]
[  504.910830] sysctl_sched
[  504.910831]   .sysctl_sched_latency                    : 6.000000
[  504.910832]   .sysctl_sched_min_granularity            : 0.750000
[  504.910834]   .sysctl_sched_wakeup_granularity         : 1.000000
[  504.910835]   .sysctl_sched_child_runs_first           : 0
[  504.910836]   .sysctl_sched_features                   : 7279
[  504.910838]   .sysctl_sched_tunable_scaling            : 1 (logaritm=
ic)
[  504.910841]
[  504.910842] cpu#0, 2400.084 MHz
[  504.910843]   .nr_running                    : 2
[  504.910844]   .load                          : 2048
[  504.910845]   .nr_switches                   : 44013
[  504.910846]   .nr_load_updates               : 36769
[  504.910848]   .nr_uninterruptible            : 1
[  504.910849]   .next_balance                  : 4294.955008
[  504.910850]   .curr->pid                     : 1390
[  504.910851]   .clock                         : 504910.025729
[  504.910852]   .cpu_load[0]                   : 1024
[  504.910854]   .cpu_load[1]                   : 1024
[  504.910855]   .cpu_load[2]                   : 1024
[  504.910856]   .cpu_load[3]                   : 1024
[  504.910857]   .cpu_load[4]                   : 1024
[  504.910858]   .yld_count                     : 0
[  504.910859]   .sched_switch                  : 0
[  504.910860]   .sched_count                   : 44317
[  504.910861]   .sched_goidle                  : 4441
[  504.910862]   .avg_idle                      : 1000000
[  504.910863]   .ttwu_count                    : 24587
[  504.910864]   .ttwu_local                    : 24587
[  504.910865]   .bkl_count                     : 0
[  504.910869]
[  504.910869] cfs_rq[0]:/autogroup-55
[  504.910870]   .exec_clock                    : 0.577353
[  504.910872]   .MIN_vruntime                  : 0.000001
[  504.910873]   .min_vruntime                  : 0.471223
[  504.910874]   .max_vruntime                  : 0.000001
[  504.910885]   .spread                        : 0.000000
[  504.910886]   .spread0                       : -332282.124910
[  504.910887]   .nr_spread_over                : 0
[  504.910888]   .nr_running                    : 0
[  504.910889]   .load                          : 0
[  504.910891]   .load_avg                      : 65.955840
[  504.910892]   .load_period                   : 0.064410
[  504.910893]   .load_contrib                  : 0
[  504.910894]   .load_tg                       : 0
[  504.910896]   .se->exec_start                : 307680.101709
[  504.910898]   .se->vruntime                  : 135197.882765
[  504.910899]   .se->sum_exec_runtime          : 0.577353
[  504.910900]   .se->statistics.wait_start     : 0.000000
[  504.910901]   .se->statistics.sleep_start    : 0.000000
[  504.910903]   .se->statistics.block_start    : 0.000000
[  504.910904]   .se->statistics.sleep_max      : 0.000000
[  504.910905]   .se->statistics.block_max      : 0.000000
[  504.910906]   .se->statistics.exec_max       : 0.301475
[  504.910908]   .se->statistics.slice_max      : 0.302127
[  504.910909]   .se->statistics.wait_max       : 0.027890
[  504.910910]   .se->statistics.wait_sum       : 0.049731
[  504.910911]   .se->statistics.wait_count     : 8
[  504.910912]   .se->load.weight               : 2
[  504.910914]
[  504.910914] cfs_rq[0]:/autogroup-98
[  504.910916]   .exec_clock                    : 436.471565
[  504.910917]   .MIN_vruntime                  : 0.000001
[  504.910918]   .min_vruntime                  : 476.072780
[  504.910919]   .max_vruntime                  : 0.000001
[  504.910921]   .spread                        : 0.000000
[  504.910922]   .spread0                       : -331805.580907
[  504.910923]   .nr_spread_over                : 158
[  504.910924]   .nr_running                    : 1
[  504.910925]   .load                          : 1024
[  504.910927]   .load_avg                      : 0.414715
[  504.910928]   .load_period                   : 6.987305
[  504.910929]   .load_contrib                  : 0
[  504.910930]   .load_tg                       : 0
[  504.910931]   .se->exec_start                : 504910.025729
[  504.910933]   .se->vruntime                  : 332278.653687
[  504.910934]   .se->sum_exec_runtime          : 436.471565
[  504.910935]   .se->statistics.wait_start     : 0.000000
[  504.910937]   .se->statistics.sleep_start    : 0.000000
[  504.910938]   .se->statistics.block_start    : 0.000000
[  504.910939]   .se->statistics.sleep_max      : 0.000000
[  504.910940]   .se->statistics.block_max      : 0.000000
[  504.910941]   .se->statistics.exec_max       : 10.000809
[  504.910943]   .se->statistics.slice_max      : 10.009682
[  504.910944]   .se->statistics.wait_max       : 12.419031
[  504.910945]   .se->statistics.wait_sum       : 361.577832
[  504.910946]   .se->statistics.wait_count     : 2110
[  504.910948]   .se->load.weight               : 1024
[  504.910949]
[  504.910950] cfs_rq[0]:/autogroup-97
[  504.910951]   .exec_clock                    : 81.190946
[  504.910952]   .MIN_vruntime                  : 0.000001
[  504.910953]   .min_vruntime                  : 96.462908
[  504.910954]   .max_vruntime                  : 0.000001
[  504.910956]   .spread                        : 0.000000
[  504.910957]   .spread0                       : -332185.190779
[  504.910958]   .nr_spread_over                : 22
[  504.910959]   .nr_running                    : 0
[  504.910960]   .load                          : 0
[  504.910961]   .load_avg                      : 69.058560
[  504.910963]   .load_period                   : 0.067440
[  504.910964]   .load_contrib                  : 0
[  504.910965]   .load_tg                       : 0
[  504.910966]   .se->exec_start                : 504908.418721
[  504.910967]   .se->vruntime                  : 332277.122511
[  504.910974]   .se->sum_exec_runtime          : 81.190946
[  504.910976]   .se->statistics.wait_start     : 0.000000
[  504.910977]   .se->statistics.sleep_start    : 0.000000
[  504.910978]   .se->statistics.block_start    : 0.000000
[  504.910979]   .se->statistics.sleep_max      : 0.000000
[  504.910980]   .se->statistics.block_max      : 0.000000
[  504.910982]   .se->statistics.exec_max       : 9.994761
[  504.910983]   .se->statistics.slice_max      : 11.408766
[  504.910984]   .se->statistics.wait_max       : 20.014296
[  504.910985]   .se->statistics.wait_sum       : 70.643475
[  504.910986]   .se->statistics.wait_count     : 652
[  504.910988]   .se->load.weight               : 2
[  504.910989]
[  504.910990] cfs_rq[0]:/autogroup-47
[  504.910991]   .exec_clock                    : 5.490044
[  504.910992]   .MIN_vruntime                  : 0.000001
[  504.910993]   .min_vruntime                  : 8.397206
[  504.910995]   .max_vruntime                  : 0.000001
[  504.910996]   .spread                        : 0.000000
[  504.910997]   .spread0                       : -332273.256481
[  504.910998]   .nr_spread_over                : 0
[  504.910999]   .nr_running                    : 0
[  504.911000]   .load                          : 0
[  504.911002]   .load_avg                      : 11.317248
[  504.911003]   .load_period                   : 0.011052
[  504.911004]   .load_contrib                  : 1
[  504.911005]   .load_tg                       : 1
[  504.911007]   .se->exec_start                : 237475.374787
[  504.911008]   .se->vruntime                  : 65372.863188
[  504.911010]   .se->sum_exec_runtime          : 5.490044
[  504.911011]   .se->statistics.wait_start     : 0.000000
[  504.911012]   .se->statistics.sleep_start    : 0.000000
[  504.911014]   .se->statistics.block_start    : 0.000000
[  504.911015]   .se->statistics.sleep_max      : 0.000000
[  504.911016]   .se->statistics.block_max      : 0.000000
[  504.911017]   .se->statistics.exec_max       : 4.204008
[  504.911018]   .se->statistics.slice_max      : 4.295892
[  504.911020]   .se->statistics.wait_max       : 5.792169
[  504.911021]   .se->statistics.wait_sum       : 5.833235
[  504.911022]   .se->statistics.wait_count     : 8
[  504.911023]   .se->load.weight               : 2
[  504.911025]
[  504.911025] cfs_rq[0]:/autogroup-77
[  504.911027]   .exec_clock                    : 4.001773
[  504.911028]   .MIN_vruntime                  : 0.000001
[  504.911029]   .min_vruntime                  : 5.193779
[  504.911030]   .max_vruntime                  : 0.000001
[  504.911031]   .spread                        : 0.000000
[  504.911033]   .spread0                       : -332276.459908
[  504.911034]   .nr_spread_over                : 0
[  504.911035]   .nr_running                    : 0
[  504.911036]   .load                          : 0
[  504.911037]   .load_avg                      : 57.104384
[  504.911039]   .load_period                   : 0.055766
[  504.911040]   .load_contrib                  : 0
[  504.911041]   .load_tg                       : 0
[  504.911042]   .se->exec_start                : 476113.271119
[  504.911044]   .se->vruntime                  : 303489.323396
[  504.911045]   .se->sum_exec_runtime          : 4.001773
[  504.911046]   .se->statistics.wait_start     : 0.000000
[  504.911048]   .se->statistics.sleep_start    : 0.000000
[  504.911049]   .se->statistics.block_start    : 0.000000
[  504.911050]   .se->statistics.sleep_max      : 0.000000
[  504.911051]   .se->statistics.block_max      : 0.000000
[  504.911052]   .se->statistics.exec_max       : 0.870429
[  504.911054]   .se->statistics.slice_max      : 0.871374
[  504.911055]   .se->statistics.wait_max       : 0.086869
[  504.911056]   .se->statistics.wait_sum       : 0.206565
[  504.911057]   .se->statistics.wait_count     : 18
[  504.911064]   .se->load.weight               : 2
[  504.911067]
[  504.911067] cfs_rq[0]:/autogroup-94
[  504.911068]   .exec_clock                    : 377.195414
[  504.911069]   .MIN_vruntime                  : 0.000001
[  504.911071]   .min_vruntime                  : 419.366155
[  504.911072]   .max_vruntime                  : 0.000001
[  504.911073]   .spread                        : 0.000000
[  504.911074]   .spread0                       : -331862.287532
[  504.911076]   .nr_spread_over                : 26
[  504.911077]   .nr_running                    : 0
[  504.911078]   .load                          : 0
[  504.911079]   .load_avg                      : 65.437184
[  504.911080]   .load_period                   : 5.752241
[  504.911081]   .load_contrib                  : 2
[  504.911083]   .load_tg                       : 2
[  504.911084]   .se->exec_start                : 231230.096233
[  504.911086]   .se->vruntime                  : 59182.405376
[  504.911087]   .se->sum_exec_runtime          : 377.195414
[  504.911088]   .se->statistics.wait_start     : 0.000000
[  504.911089]   .se->statistics.sleep_start    : 0.000000
[  504.911091]   .se->statistics.block_start    : 0.000000
[  504.911092]   .se->statistics.sleep_max      : 0.000000
[  504.911093]   .se->statistics.block_max      : 0.000000
[  504.911094]   .se->statistics.exec_max       : 10.002204
[  504.911096]   .se->statistics.slice_max      : 0.275035
[  504.911097]   .se->statistics.wait_max       : 0.106017
[  504.911098]   .se->statistics.wait_sum       : 1.724216
[  504.911099]   .se->statistics.wait_count     : 1114
[  504.911100]   .se->load.weight               : 2
[  504.911102]
[  504.911103] cfs_rq[0]:/autogroup-95
[  504.911104]   .exec_clock                    : 760.249147
[  504.911105]   .MIN_vruntime                  : 0.000001
[  504.911106]   .min_vruntime                  : 862.141448
[  504.911108]   .max_vruntime                  : 0.000001
[  504.911109]   .spread                        : 0.000000
[  504.911110]   .spread0                       : -331419.512239
[  504.911111]   .nr_spread_over                : 126
[  504.911112]   .nr_running                    : 0
[  504.911113]   .load                          : 0
[  504.911115]   .load_avg                      : 1974.212608
[  504.911116]   .load_period                   : 1.812061
[  504.911117]   .load_contrib                  : 0
[  504.911118]   .load_tg                       : 0
[  504.911120]   .se->exec_start                : 231221.831659
[  504.911121]   .se->vruntime                  : 59175.982390
[  504.911123]   .se->sum_exec_runtime          : 760.249147
[  504.911124]   .se->statistics.wait_start     : 0.000000
[  504.911125]   .se->statistics.sleep_start    : 0.000000
[  504.911126]   .se->statistics.block_start    : 0.000000
[  504.911128]   .se->statistics.sleep_max      : 0.000000
[  504.911129]   .se->statistics.block_max      : 0.000000
[  504.911130]   .se->statistics.exec_max       : 10.001120
[  504.911131]   .se->statistics.slice_max      : 2.801075
[  504.911133]   .se->statistics.wait_max       : 6.775995
[  504.911134]   .se->statistics.wait_sum       : 56.108541
[  504.911135]   .se->statistics.wait_count     : 1394
[  504.911136]   .se->load.weight               : 2
[  504.911138]
[  504.911138] cfs_rq[0]:/autogroup-44
[  504.911139]   .exec_clock                    : 7.551274
[  504.911141]   .MIN_vruntime                  : 0.000001
[  504.911142]   .min_vruntime                  : 6.502698
[  504.911143]   .max_vruntime                  : 0.000001
[  504.911144]   .spread                        : 0.000000
[  504.911145]   .spread0                       : -332275.150989
[  504.911147]   .nr_spread_over                : 0
[  504.911148]   .nr_running                    : 0
[  504.911149]   .load                          : 0
[  504.911155]   .load_avg                      : 11.603968
[  504.911157]   .load_period                   : 0.011332
[  504.911158]   .load_contrib                  : 0
[  504.911159]   .load_tg                       : 0
[  504.911160]   .se->exec_start                : 504670.285294
[  504.911161]   .se->vruntime                  : 332039.418792
[  504.911163]   .se->sum_exec_runtime          : 7.551274
[  504.911164]   .se->statistics.wait_start     : 0.000000
[  504.911165]   .se->statistics.sleep_start    : 0.000000
[  504.911166]   .se->statistics.block_start    : 0.000000
[  504.911168]   .se->statistics.sleep_max      : 0.000000
[  504.911169]   .se->statistics.block_max      : 0.000000
[  504.911170]   .se->statistics.exec_max       : 0.164354
[  504.911171]   .se->statistics.slice_max      : 0.031752
[  504.911172]   .se->statistics.wait_max       : 0.012799
[  504.911174]   .se->statistics.wait_sum       : 0.012799
[  504.911175]   .se->statistics.wait_count     : 498
[  504.911176]   .se->load.weight               : 2
[  504.911177]
[  504.911178] cfs_rq[0]:/autogroup-45
[  504.911179]   .exec_clock                    : 33.642079
[  504.911180]   .MIN_vruntime                  : 0.000001
[  504.911181]   .min_vruntime                  : 2.665989
[  504.911183]   .max_vruntime                  : 0.000001
[  504.911184]   .spread                        : 0.000000
[  504.911185]   .spread0                       : -332278.987698
[  504.911186]   .nr_spread_over                : 0
[  504.911187]   .nr_running                    : 0
[  504.911188]   .load                          : 0
[  504.911189]   .load_avg                      : 80.413256
[  504.911191]   .load_period                   : 0.008422
[  504.911192]   .load_contrib                  : 0
[  504.911193]   .load_tg                       : 0
[  504.911194]   .se->exec_start                : 504722.413919
[  504.911196]   .se->vruntime                  : 332091.536085
[  504.911197]   .se->sum_exec_runtime          : 33.642079
[  504.911198]   .se->statistics.wait_start     : 0.000000
[  504.911199]   .se->statistics.sleep_start    : 0.000000
[  504.911201]   .se->statistics.block_start    : 0.000000
[  504.911202]   .se->statistics.sleep_max      : 0.000000
[  504.911203]   .se->statistics.block_max      : 0.000000
[  504.911204]   .se->statistics.exec_max       : 1.638176
[  504.911206]   .se->statistics.slice_max      : 1.638176
[  504.911207]   .se->statistics.wait_max       : 0.615461
[  504.911208]   .se->statistics.wait_sum       : 0.712627
[  504.911209]   .se->statistics.wait_count     : 1993
[  504.911210]   .se->load.weight               : 2
[  504.911212]
[  504.911212] cfs_rq[0]:/autogroup-93
[  504.911213]   .exec_clock                    : 32.063014
[  504.911215]   .MIN_vruntime                  : 0.000001
[  504.911216]   .min_vruntime                  : 31.799141
[  504.911217]   .max_vruntime                  : 0.000001
[  504.911218]   .spread                        : 0.000000
[  504.911219]   .spread0                       : -332249.854546
[  504.911221]   .nr_spread_over                : 0
[  504.911222]   .nr_running                    : 0
[  504.911223]   .load                          : 0
[  504.911224]   .load_avg                      : 402.524160
[  504.911225]   .load_period                   : 5.541945
[  504.911226]   .load_contrib                  : 0
[  504.911227]   .load_tg                       : 0
[  504.911229]   .se->exec_start                : 504866.521510
[  504.911230]   .se->vruntime                  : 332235.589069
[  504.911231]   .se->sum_exec_runtime          : 32.063014
[  504.911232]   .se->statistics.wait_start     : 0.000000
[  504.911234]   .se->statistics.sleep_start    : 0.000000
[  504.911235]   .se->statistics.block_start    : 0.000000
[  504.911236]   .se->statistics.sleep_max      : 0.000000
[  504.911243]   .se->statistics.block_max      : 0.000000
[  504.911244]   .se->statistics.exec_max       : 2.406006
[  504.911245]   .se->statistics.slice_max      : 0.535484
[  504.911246]   .se->statistics.wait_max       : 0.454589
[  504.911248]   .se->statistics.wait_sum       : 0.583201
[  504.911249]   .se->statistics.wait_count     : 302
[  504.911250]   .se->load.weight               : 2
[  504.911252]
[  504.911253] cfs_rq[0]:/autogroup-26
[  504.911254]   .exec_clock                    : 25.677149
[  504.911255]   .MIN_vruntime                  : 0.000001
[  504.911256]   .min_vruntime                  : 20.872061
[  504.911258]   .max_vruntime                  : 0.000001
[  504.911259]   .spread                        : 0.000000
[  504.911260]   .spread0                       : -332260.781626
[  504.911261]   .nr_spread_over                : 2
[  504.911262]   .nr_running                    : 0
[  504.911263]   .load                          : 0
[  504.911265]   .load_avg                      : 25.005056
[  504.911266]   .load_period                   : 0.024419
[  504.911267]   .load_contrib                  : 0
[  504.911268]   .load_tg                       : 0
[  504.911270]   .se->exec_start                : 486500.033508
[  504.911271]   .se->vruntime                  : 313872.401958
[  504.911273]   .se->sum_exec_runtime          : 25.677149
[  504.911274]   .se->statistics.wait_start     : 0.000000
[  504.911275]   .se->statistics.sleep_start    : 0.000000
[  504.911276]   .se->statistics.block_start    : 0.000000
[  504.911278]   .se->statistics.sleep_max      : 0.000000
[  504.911279]   .se->statistics.block_max      : 0.000000
[  504.911280]   .se->statistics.exec_max       : 4.001458
[  504.911281]   .se->statistics.slice_max      : 4.001458
[  504.911283]   .se->statistics.wait_max       : 23.210683
[  504.911284]   .se->statistics.wait_sum       : 73.089978
[  504.911285]   .se->statistics.wait_count     : 190
[  504.911286]   .se->load.weight               : 2
[  504.911288]
[  504.911288] cfs_rq[0]:/autogroup-22
[  504.911290]   .exec_clock                    : 527.961931
[  504.911291]   .MIN_vruntime                  : 0.000001
[  504.911292]   .min_vruntime                  : 151.311694
[  504.911294]   .max_vruntime                  : 0.000001
[  504.911295]   .spread                        : 0.000000
[  504.911296]   .spread0                       : -332130.341993
[  504.911297]   .nr_spread_over                : 121
[  504.911298]   .nr_running                    : 0
[  504.911299]   .load                          : 0
[  504.911301]   .load_avg                      : 1111.549442
[  504.911302]   .load_period                   : 0.532895
[  504.911303]   .load_contrib                  : 0
[  504.911304]   .load_tg                       : 0
[  504.911306]   .se->exec_start                : 356684.107482
[  504.911307]   .se->vruntime                  : 184169.472319
[  504.911308]   .se->sum_exec_runtime          : 527.961931
[  504.911310]   .se->statistics.wait_start     : 0.000000
[  504.911311]   .se->statistics.sleep_start    : 0.000000
[  504.911312]   .se->statistics.block_start    : 0.000000
[  504.911313]   .se->statistics.sleep_max      : 0.000000
[  504.911314]   .se->statistics.block_max      : 0.000000
[  504.911316]   .se->statistics.exec_max       : 13.423428
[  504.911317]   .se->statistics.slice_max      : 13.444230
[  504.911318]   .se->statistics.wait_max       : 31.119278
[  504.911319]   .se->statistics.wait_sum       : 1280.604518
[  504.911321]   .se->statistics.wait_count     : 3048
[  504.911322]   .se->load.weight               : 2
[  504.911324]
[  504.911324] cfs_rq[0]:/autogroup-81
[  504.911325]   .exec_clock                    : 12.556567
[  504.911327]   .MIN_vruntime                  : 0.000001
[  504.911328]   .min_vruntime                  : 12.143997
[  504.911335]   .max_vruntime                  : 0.000001
[  504.911336]   .spread                        : 0.000000
[  504.911337]   .spread0                       : -332269.509690
[  504.911338]   .nr_spread_over                : 0
[  504.911339]   .nr_running                    : 0
[  504.911340]   .load                          : 0
[  504.911342]   .load_avg                      : 797.444800
[  504.911343]   .load_period                   : 5.529441
[  504.911344]   .load_contrib                  : 144
[  504.911345]   .load_tg                       : 144
[  504.911347]   .se->exec_start                : 176690.782872
[  504.911348]   .se->vruntime                  : 4768.148996
[  504.911349]   .se->sum_exec_runtime          : 12.556567
[  504.911351]   .se->statistics.wait_start     : 0.000000
[  504.911352]   .se->statistics.sleep_start    : 0.000000
[  504.911353]   .se->statistics.block_start    : 0.000000
[  504.911354]   .se->statistics.sleep_max      : 0.000000
[  504.911356]   .se->statistics.block_max      : 0.000000
[  504.911357]   .se->statistics.exec_max       : 2.983240
[  504.911358]   .se->statistics.slice_max      : 2.983240
[  504.911359]   .se->statistics.wait_max       : 7.305608
[  504.911361]   .se->statistics.wait_sum       : 15.575225
[  504.911362]   .se->statistics.wait_count     : 30
[  504.911363]   .se->load.weight               : 2
[  504.911364]
[  504.911365] cfs_rq[0]:/autogroup-0
[  504.911366]   .exec_clock                    : 335096.149477
[  504.911367]   .MIN_vruntime                  : 332281.653687
[  504.911369]   .min_vruntime                  : 332281.653687
[  504.911370]   .max_vruntime                  : 332281.653687
[  504.911371]   .spread                        : 0.000000
[  504.911372]   .spread0                       : 0.000000
[  504.911374]   .nr_spread_over                : 103
[  504.911375]   .nr_running                    : 2
[  504.911376]   .load                          : 2048
[  504.911377]   .load_avg                      : 0.000000
[  504.911378]   .load_period                   : 0.000000
[  504.911379]   .load_contrib                  : 0
[  504.911380]   .load_tg                       : 0
[  504.911382]
[  504.911382] runnable tasks:
[  504.911383]             task   PID         tree-key  switches  prio
    exec-runtime         sum-exec        sum-sleep
[  504.911384] --------------------------------------------------------=
--------------------------------------------------
[  504.911389]     md1123_raid5  1310    332281.653687      8767   120
   332281.653687    327572.546291      5960.052537 /autogroup-0
[  504.911394] R           bash  1390       473.290911      1098   120
      473.290911       226.301682    267038.335128 /autogroup-98
[  504.911398]

Thanks,
  Alex.




On Tue, Jun 28, 2011 at 5:29 AM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 26 Jun 2011 21:13:17 +0300 Alexander Lyakas <alex.bolshoy@gma=
il.com>
> wrote:
>
>> Hello Neil,
>> thank you for your response. Meanwhile I have moved to stock ubuntu
>> natty 11.04, but it still happens. I have a simple script that
>> reproduces the issue for me in less than 1 minute.
>> System details:
>> Linux ubuntu 2.6.38-8-server #42-Ubuntu SMP Mon Apr 11 03:49:04 UTC
>> 2011 x86_64 x86_64 x86_64 GNU/Linux
>>
>> Here is the script:
>> ##################################
>> #!/bin/bash
>>
>> while true
>> do
>> =A0 =A0 =A0 mdadm --create /dev/md1123 --raid-devices=3D3 --level=3D=
5
>> --bitmap=3Dinternal --name=3D1123 --run --auto=3Dmd --metadata=3D1.2
>> --homehost=3Dalex --verbose /dev/sda /dev/sdb /dev/sdc
>> =A0 =A0 =A0 sleep 6
>> =A0 =A0 =A0 mdadm --manage /dev/md1123 --fail /dev/sda
>> =A0 =A0 =A0 sleep 1
>> =A0 =A0 =A0 if mdadm --stop /dev/md1123
>> =A0 =A0 =A0 then
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 true
>> =A0 =A0 =A0 else
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 break
>> =A0 =A0 =A0 fi
>> done
>> #####################################
>
> Thanks for the script. =A0Unfortunately I still cannot reproduce.
> I suspect there is some subtle race issue that is heavily dependant o=
n the
> particular hardware you have.
>
> It might help if I could get stack traces of the relevant processes. =
i.e.
> md1123_raid5 and md1123_resync.
>
> A previous post contained a trace of _resync, but it wouldn't hurt to=
 get
> another one. =A0You can get them by
>
> =A0cat /proc/PROCESS-ID/stack
>
> or possibly
>
> =A0echo w > /proc/sysrq-trigger
>
> then look in the output of 'dmesg'.
>
> Thanks,
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID5: failing an active component during spare rebuild - arrays hangs
Date: Thu, 25 Aug 2011 11:59:27 +0300
Message-ID: <CAGRgLy5huVzdA8q6V887Ay384kJ4ywgst6dEGgYuRg9+SxHB0A@mail.gmail.com>
References: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
	<BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
	<20110622125409.14428883@notabene.brown>
	<BANLkTinijekK8Y6TTk6TYtYhv4Dn2YGQbA@mail.gmail.com>
	<20110628122921.42480f72@notabene.brown>
	<CAGRgLy5uK5As96j2Tprfrx+qNhYqvFiVUEnOJ+3AAwpPMHCDYg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5uK5As96j2Tprfrx+qNhYqvFiVUEnOJ+3AAwpPMHCDYg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neal,
how can we further check this issue?
Additional piece of information is that the  md1123_raid5 is at 100%
CPU in top output. And I do this test on a virtual machine with KVM.

Thanks,
  Alex.


On Sun, Jul 17, 2011 at 11:29 AM, Alexander Lyakas
<alex.bolshoy@gmail.com> wrote:
> Hello Neil,
> I am sorry for such a late response. I still hope we will be able to
> get to the bottom of this. (I also have several other issues &
> questions, but meanwhile I am managing by digging through mdadm code)=
=2E
>
> Here are the stacks of the relevant processes:
>
> md1123_raid5:
>
> [<ffffffff8105f08a>] __cond_resched+0x2a/0x40
> [<ffffffffa006a17d>] raid5d+0x17d/0x1f0 [raid456]
> [<ffffffff8148c516>] md_thread+0x116/0x150
> [<ffffffff810871f6>] kthread+0x96/0xa0
> [<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> md1123_resync:
>
> [<ffffffff8148c4f7>] md_thread+0xf7/0x150
> [<ffffffff810871f6>] kthread+0x96/0xa0
> [<ffffffff8100cde4>] kernel_thread_helper+0x4/0x10
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> Another suspicious process:
> /sbin/blkid -o udev -p /dev/md1123
>
> [<ffffffff8110b470>] sync_page+0x40/0x50
> [<ffffffff8110b48e>] sync_page_killable+0xe/0x40
> [<ffffffff8110b397>] __lock_page_killable+0x67/0x70
> [<ffffffff8110c547>] do_generic_file_read.clone.23+0x297/0x450
> [<ffffffff8110d1ba>] generic_file_aio_read+0x1ca/0x240
> [<ffffffff81164c82>] do_sync_read+0xd2/0x110
> [<ffffffff81165463>] vfs_read+0xc3/0x180
> [<ffffffff81165571>] sys_read+0x51/0x90
> [<ffffffff8100bfc2>] system_call_fastpath+0x16/0x1b
> [<ffffffffffffffff>] 0xffffffffffffffff
>
> And here is the output of sysrq-trigger (long):
> root@c-11:~# echo w > /proc/sysrq-trigger
> root@c-11:~# dmesg
> [ =A0 =A00.000000] Initializing cgroup subsys cpuset
> [ =A0 =A00.000000] Initializing cgroup subsys cpu
> [ =A0 =A00.000000] Linux version 2.6.38-8-server (buildd@allspice) (g=
cc
> version 4.5.2 (Ubuntu/Linaro 4.5.2-8ubuntu3) ) #42-Ubuntu SMP Mon Apr
> 11 03:49:04 UTC 2011 (Ubuntu 2.6.38-8.42-server 2.6.38.2)
> [ =A0 =A00.000000] Command line: BOOT_IMAGE=3D/boot/vmlinuz-2.6.38-8-=
server
> root=3DUUID=3D01671ce6-dddb-481b-a8e5-818bbb7f83f3 ro quiet
> [ =A0 =A00.000000] BIOS-provided physical RAM map:
> [ =A0 =A00.000000] =A0BIOS-e820: 0000000000000000 - 000000000009f400 =
(usable)
> [ =A0 =A00.000000] =A0BIOS-e820: 000000000009f400 - 00000000000a0000 =
(reserved)
> [ =A0 =A00.000000] =A0BIOS-e820: 00000000000f0000 - 0000000000100000 =
(reserved)
> [ =A0 =A00.000000] =A0BIOS-e820: 0000000000100000 - 00000000bfffd000 =
(usable)
> [ =A0 =A00.000000] =A0BIOS-e820: 00000000bfffd000 - 00000000c0000000 =
(reserved)
> [ =A0 =A00.000000] =A0BIOS-e820: 00000000feffc000 - 00000000ff000000 =
(reserved)
> [ =A0 =A00.000000] =A0BIOS-e820: 00000000fffc0000 - 0000000100000000 =
(reserved)
> [ =A0 =A00.000000] NX (Execute Disable) protection: active
> [ =A0 =A00.000000] DMI 2.4 present.
> [ =A0 =A00.000000] DMI: Bochs Bochs, BIOS Bochs 01/01/2007
> [ =A0 =A00.000000] e820 update range: 0000000000000000 - 000000000001=
0000
> (usable) =3D=3D> (reserved)
> [ =A0 =A00.000000] e820 remove range: 00000000000a0000 - 000000000010=
0000 (usable)
> [ =A0 =A00.000000] No AGP bridge found
> [ =A0 =A00.000000] last_pfn =3D 0xbfffd max_arch_pfn =3D 0x400000000
> [ =A0 =A00.000000] MTRR default type: write-back
> [ =A0 =A00.000000] MTRR fixed ranges enabled:
> [ =A0 =A00.000000] =A0 00000-9FFFF write-back
> [ =A0 =A00.000000] =A0 A0000-BFFFF uncachable
> [ =A0 =A00.000000] =A0 C0000-FFFFF write-protect
> [ =A0 =A00.000000] MTRR variable ranges enabled:
> [ =A0 =A00.000000] =A0 0 base 00E0000000 mask FFE0000000 uncachable
> [ =A0 =A00.000000] =A0 1 disabled
> [ =A0 =A00.000000] =A0 2 disabled
> [ =A0 =A00.000000] =A0 3 disabled
> [ =A0 =A00.000000] =A0 4 disabled
> [ =A0 =A00.000000] =A0 5 disabled
> [ =A0 =A00.000000] =A0 6 disabled
> [ =A0 =A00.000000] =A0 7 disabled
> [ =A0 =A00.000000] PAT not supported by CPU.
> [ =A0 =A00.000000] found SMP MP-table at [ffff8800000fd790] fd790
> [ =A0 =A00.000000] initial memory mapped : 0 - 20000000
> [ =A0 =A00.000000] init_memory_mapping: 0000000000000000-00000000bfff=
d000
> [ =A0 =A00.000000] =A00000000000 - 00bfe00000 page 2M
> [ =A0 =A00.000000] =A000bfe00000 - 00bfffd000 page 4k
> [ =A0 =A00.000000] kernel direct mapping tables up to bfffd000 @ 1fff=
b000-20000000
> [ =A0 =A00.000000] RAMDISK: 364ac000 - 3724e000
> [ =A0 =A00.000000] ACPI: RSDP 00000000000fd740 00014 (v00 BOCHS )
> [ =A0 =A00.000000] ACPI: RSDT 00000000bfffdc40 00034 (v01 BOCHS =A0BX=
PCRSDT
> 00000001 BXPC 00000001)
> [ =A0 =A00.000000] ACPI: FACP 00000000bffffe70 00074 (v01 BOCHS =A0BX=
PCFACP
> 00000001 BXPC 00000001)
> [ =A0 =A00.000000] ACPI: DSDT 00000000bfffde40 01FB7 (v01 =A0 BXPC =A0=
 BXDSDT
> 00000001 INTL 20090123)
> [ =A0 =A00.000000] ACPI: FACS 00000000bffffe00 00040
> [ =A0 =A00.000000] ACPI: SSDT 00000000bfffdda0 0009E (v01 BOCHS =A0BX=
PCSSDT
> 00000001 BXPC 00000001)
> [ =A0 =A00.000000] ACPI: APIC 00000000bfffdcc0 00072 (v01 BOCHS =A0BX=
PCAPIC
> 00000001 BXPC 00000001)
> [ =A0 =A00.000000] ACPI: HPET 00000000bfffdc80 00038 (v01 BOCHS =A0BX=
PCHPET
> 00000001 BXPC 00000001)
> [ =A0 =A00.000000] ACPI: Local APIC address 0xfee00000
> [ =A0 =A00.000000] No NUMA configuration found
> [ =A0 =A00.000000] Faking a node at 0000000000000000-00000000bfffd000
> [ =A0 =A00.000000] Initmem setup node 0 0000000000000000-00000000bfff=
d000
> [ =A0 =A00.000000] =A0 NODE_DATA [00000000bfff8000 - 00000000bfffcfff=
]
> [ =A0 =A00.000000] kvm-clock: Using msrs 12 and 11
> [ =A0 =A00.000000] kvm-clock: cpu 0, msr 0:1adfc81, boot clock
> [ =A0 =A00.000000] =A0[ffffea0000000000-ffffea00029fffff] PMD ->
> [ffff8800bc600000-ffff8800beffffff] on node 0
> [ =A0 =A00.000000] Zone PFN ranges:
> [ =A0 =A00.000000] =A0 DMA =A0 =A0 =A00x00000010 -> 0x00001000
> [ =A0 =A00.000000] =A0 DMA32 =A0 =A00x00001000 -> 0x00100000
> [ =A0 =A00.000000] =A0 Normal =A0 empty
> [ =A0 =A00.000000] Movable zone start PFN for each node
> [ =A0 =A00.000000] early_node_map[2] active PFN ranges
> [ =A0 =A00.000000] =A0 =A0 0: 0x00000010 -> 0x0000009f
> [ =A0 =A00.000000] =A0 =A0 0: 0x00000100 -> 0x000bfffd
> [ =A0 =A00.000000] On node 0 totalpages: 786316
> [ =A0 =A00.000000] =A0 DMA zone: 56 pages used for memmap
> [ =A0 =A00.000000] =A0 DMA zone: 6 pages reserved
> [ =A0 =A00.000000] =A0 DMA zone: 3921 pages, LIFO batch:0
> [ =A0 =A00.000000] =A0 DMA32 zone: 10696 pages used for memmap
> [ =A0 =A00.000000] =A0 DMA32 zone: 771637 pages, LIFO batch:31
> [ =A0 =A00.000000] ACPI: PM-Timer IO Port: 0xb008
> [ =A0 =A00.000000] ACPI: Local APIC address 0xfee00000
> [ =A0 =A00.000000] ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
> [ =A0 =A00.000000] ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_bas=
e[0])
> [ =A0 =A00.000000] IOAPIC[0]: apic_id 1, version 17, address 0xfec000=
00, GSI 0-23
> [ =A0 =A00.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 df=
l dfl)
> [ =A0 =A00.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 5 global_irq 5 hi=
gh level)
> [ =A0 =A00.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 hi=
gh level)
> [ =A0 =A00.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 10 global_irq 10 =
high level)
> [ =A0 =A00.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 11 global_irq 11 =
high level)
> [ =A0 =A00.000000] ACPI: IRQ0 used by override.
> [ =A0 =A00.000000] ACPI: IRQ2 used by override.
> [ =A0 =A00.000000] ACPI: IRQ5 used by override.
> [ =A0 =A00.000000] ACPI: IRQ9 used by override.
> [ =A0 =A00.000000] ACPI: IRQ10 used by override.
> [ =A0 =A00.000000] ACPI: IRQ11 used by override.
> [ =A0 =A00.000000] Using ACPI (MADT) for SMP configuration informatio=
n
> [ =A0 =A00.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [ =A0 =A00.000000] SMP: Allowing 1 CPUs, 0 hotplug CPUs
> [ =A0 =A00.000000] nr_irqs_gsi: 40
> [ =A0 =A00.000000] PM: Registered nosave memory: 000000000009f000 - 0=
0000000000a0000
> [ =A0 =A00.000000] PM: Registered nosave memory: 00000000000a0000 - 0=
0000000000f0000
> [ =A0 =A00.000000] PM: Registered nosave memory: 00000000000f0000 - 0=
000000000100000
> [ =A0 =A00.000000] Allocating PCI resources starting at c0000000 (gap=
:
> c0000000:3effc000)
> [ =A0 =A00.000000] Booting paravirtualized kernel on KVM
> [ =A0 =A00.000000] setup_percpu: NR_CPUS:256 nr_cpumask_bits:256
> nr_cpu_ids:1 nr_node_ids:1
> [ =A0 =A00.000000] PERCPU: Embedded 28 pages/cpu @ffff8800bfc00000 s8=
4416
> r8192 d22080 u2097152
> [ =A0 =A00.000000] pcpu-alloc: s84416 r8192 d22080 u2097152 alloc=3D1=
*2097152
> [ =A0 =A00.000000] pcpu-alloc: [0] 0
> [ =A0 =A00.000000] kvm-clock: cpu 0, msr 0:bfc13c81, primary cpu cloc=
k
> [ =A0 =A00.000000] Built 1 zonelists in Node order, mobility grouping=
 on.
> Total pages: 775558
> [ =A0 =A00.000000] Policy zone: DMA32
> [ =A0 =A00.000000] Kernel command line:
> BOOT_IMAGE=3D/boot/vmlinuz-2.6.38-8-server
> root=3DUUID=3D01671ce6-dddb-481b-a8e5-818bbb7f83f3 ro quiet
> [ =A0 =A00.000000] PID hash table entries: 4096 (order: 3, 32768 byte=
s)
> [ =A0 =A00.000000] Checking aperture...
> [ =A0 =A00.000000] No AGP bridge found
> [ =A0 =A00.000000] Calgary: detecting Calgary via BIOS EBDA area
> [ =A0 =A00.000000] Calgary: Unable to locate Rio Grande table in EBDA=
 - bailing!
> [ =A0 =A00.000000] Memory: 3074544k/3145716k available (6023k kernel =
code,
> 452k absent, 70720k reserved, 5025k data, 880k init)
> [ =A0 =A00.000000] SLUB: Genslabs=3D15, HWalign=3D64, Order=3D0-3, Mi=
nObjects=3D0,
> CPUs=3D1, Nodes=3D1
> [ =A0 =A00.000000] Hierarchical RCU implementation.
> [ =A0 =A00.000000] =A0RCU dyntick-idle grace-period acceleration is e=
nabled.
> [ =A0 =A00.000000] =A0RCU-based detection of stalled CPUs is disabled=
=2E
> [ =A0 =A00.000000] NR_IRQS:16640 nr_irqs:256 16
> [ =A0 =A00.000000] Console: colour dummy device 80x25
> [ =A0 =A00.000000] console [tty0] enabled
> [ =A0 =A00.000000] allocated 31457280 bytes of page_cgroup
> [ =A0 =A00.000000] please try 'cgroup_disable=3Dmemory' option if you=
 don't
> want memory cgroups
> [ =A0 =A00.000000] hpet clockevent registered
> [ =A0 =A00.000000] Detected 2400.084 MHz processor.
> [ =A0 =A00.010000] Calibrating delay loop (skipped) preset value.. 48=
00.16
> BogoMIPS (lpj=3D24000840)
> [ =A0 =A00.010000] pid_max: default: 32768 minimum: 301
> [ =A0 =A00.010000] Security Framework initialized
> [ =A0 =A00.010000] AppArmor: AppArmor initialized
> [ =A0 =A00.010000] Yama: becoming mindful.
> [ =A0 =A00.010000] Dentry cache hash table entries: 524288 (order: 10=
,
> 4194304 bytes)
> [ =A0 =A00.010000] Inode-cache hash table entries: 262144 (order: 9, =
2097152 bytes)
> [ =A0 =A00.010000] Mount-cache hash table entries: 256
> [ =A0 =A00.010000] Initializing cgroup subsys ns
> [ =A0 =A00.010000] ns_cgroup deprecated: consider using the
> 'clone_children' flag without the ns_cgroup.
> [ =A0 =A00.010000] Initializing cgroup subsys cpuacct
> [ =A0 =A00.010000] Initializing cgroup subsys memory
> [ =A0 =A00.010000] Initializing cgroup subsys devices
> [ =A0 =A00.010000] Initializing cgroup subsys freezer
> [ =A0 =A00.010000] Initializing cgroup subsys net_cls
> [ =A0 =A00.010000] Initializing cgroup subsys blkio
> [ =A0 =A00.010014] mce: CPU supports 10 MCE banks
> [ =A0 =A00.010215] SMP alternatives: switching to UP code
> [ =A0 =A00.043346] Freeing SMP alternatives: 20k freed
> [ =A0 =A00.043368] ACPI: Core revision 20110112
> [ =A0 =A00.044515] ftrace: allocating 24611 entries in 97 pages
> [ =A0 =A00.050203] Setting APIC routing to flat
> [ =A0 =A00.060204] ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D=
-1 pin2=3D-1
> [ =A0 =A00.060207] CPU0: Intel QEMU Virtual CPU version 0.14.0 steppi=
ng 03
> [ =A0 =A00.070000] Performance Events: unsupported p6 CPU model 2 no =
PMU
> driver, software events only.
> [ =A0 =A00.070000] Brought up 1 CPUs
> [ =A0 =A00.070000] Total of 1 processors activated (4800.16 BogoMIPS)=
=2E
> [ =A0 =A00.070000] devtmpfs: initialized
> [ =A0 =A00.070000] print_constraints: dummy:
> [ =A0 =A00.070000] Time: =A08:12:59 =A0Date: 07/17/11
> [ =A0 =A00.070000] NET: Registered protocol family 16
> [ =A0 =A00.070000] ACPI: bus type pci registered
> [ =A0 =A00.070000] PCI: Using configuration type 1 for base access
> [ =A0 =A00.070000] bio: create slab <bio-0> at 0
> [ =A0 =A00.070000] ACPI: EC: Look up EC in DSDT
> [ =A0 =A00.070000] ACPI: Interpreter enabled
> [ =A0 =A00.070000] ACPI: (supports S0 S3 S4 S5)
> [ =A0 =A00.070000] ACPI: Using IOAPIC for interrupt routing
> [ =A0 =A00.072133] ACPI: No dock devices found.
> [ =A0 =A00.072136] HEST: Table not found.
> [ =A0 =A00.072139] PCI: Ignoring host bridge windows from ACPI; if
> necessary, use "pci=3Duse_crs" and report a bug
> [ =A0 =A00.072159] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-=
ff])
> [ =A0 =A00.072227] pci_root PNP0A03:00: host bridge window [io
> 0x0000-0x0cf7] (ignored)
> [ =A0 =A00.072230] pci_root PNP0A03:00: host bridge window [io
> 0x0d00-0xffff] (ignored)
> [ =A0 =A00.072233] pci_root PNP0A03:00: host bridge window [mem
> 0x000a0000-0x000bffff] (ignored)
> [ =A0 =A00.072236] pci_root PNP0A03:00: host bridge window [mem
> 0xe0000000-0xfebfffff] (ignored)
> [ =A0 =A00.072281] pci 0000:00:00.0: [8086:1237] type 0 class 0x00060=
0
> [ =A0 =A00.072576] pci 0000:00:01.0: [8086:7000] type 0 class 0x00060=
1
> [ =A0 =A00.072946] pci 0000:00:01.1: [8086:7010] type 0 class 0x00010=
1
> [ =A0 =A00.073172] pci 0000:00:01.1: reg 20: [io =A00xc000-0xc00f]
> [ =A0 =A00.073360] pci 0000:00:01.3: [8086:7113] type 0 class 0x00068=
0
> [ =A0 =A00.073690] pci 0000:00:01.3: quirk: [io =A00xb000-0xb03f] cla=
imed by
> PIIX4 ACPI
> [ =A0 =A00.073702] pci 0000:00:01.3: quirk: [io =A00xb100-0xb10f] cla=
imed by PIIX4 SMB
> [ =A0 =A00.073832] pci 0000:00:02.0: [1013:00b8] type 0 class 0x00030=
0
> [ =A0 =A00.100094] pci 0000:00:02.0: reg 10: [mem 0xf0000000-0xf1ffff=
ff pref]
> [ =A0 =A00.127422] pci 0000:00:02.0: reg 14: [mem 0xf2000000-0xf2000f=
ff]
> [ =A0 =A00.250107] pci 0000:00:02.0: reg 30: [mem 0xf2010000-0xf201ff=
ff pref]
> [ =A0 =A00.250340] pci 0000:00:03.0: [1af4:1000] type 0 class 0x00020=
0
> [ =A0 =A00.250464] pci 0000:00:03.0: reg 10: [io =A00xc020-0xc03f]
> [ =A0 =A00.250529] pci 0000:00:03.0: reg 14: [mem 0xf2020000-0xf2020f=
ff]
> [ =A0 =A00.251074] pci 0000:00:04.0: [1af4:1000] type 0 class 0x00020=
0
> [ =A0 =A00.251186] pci 0000:00:04.0: reg 10: [io =A00xc040-0xc05f]
> [ =A0 =A00.251251] pci 0000:00:04.0: reg 14: [mem 0xf2021000-0xf2021f=
ff]
> [ =A0 =A00.251786] pci 0000:00:05.0: [1000:0012] type 0 class 0x00010=
0
> [ =A0 =A00.251910] pci 0000:00:05.0: reg 10: [io =A00xc100-0xc1ff]
> [ =A0 =A00.252007] pci 0000:00:05.0: reg 14: [mem 0xf2022000-0xf20223=
ff]
> [ =A0 =A00.252102] pci 0000:00:05.0: reg 18: [mem 0xf2024000-0xf2025f=
ff]
> [ =A0 =A00.252557] pci 0000:00:06.0: [1000:0012] type 0 class 0x00010=
0
> [ =A0 =A00.252679] pci 0000:00:06.0: reg 10: [io =A00xc200-0xc2ff]
> [ =A0 =A00.252776] pci 0000:00:06.0: reg 14: [mem 0xf2026000-0xf20263=
ff]
> [ =A0 =A00.252873] pci 0000:00:06.0: reg 18: [mem 0xf2028000-0xf2029f=
ff]
> [ =A0 =A00.253536] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT=
]
> [ =A0 =A00.260690] ACPI: PCI Interrupt Link [LNKA] (IRQs 5 *10 11)
> [ =A0 =A00.260801] ACPI: PCI Interrupt Link [LNKB] (IRQs 5 *10 11)
> [ =A0 =A00.260899] ACPI: PCI Interrupt Link [LNKC] (IRQs 5 10 *11)
> [ =A0 =A00.260994] ACPI: PCI Interrupt Link [LNKD] (IRQs 5 10 *11)
> [ =A0 =A00.261096] ACPI: PCI Interrupt Link [LNKS] (IRQs 9) *0
> [ =A0 =A00.261475] vgaarb: device added:
> PCI:0000:00:02.0,decodes=3Dio+mem,owns=3Dio+mem,locks=3Dnone
> [ =A0 =A00.261481] vgaarb: loaded
> [ =A0 =A00.261891] SCSI subsystem initialized
> [ =A0 =A00.262155] libata version 3.00 loaded.
> [ =A0 =A00.262284] usbcore: registered new interface driver usbfs
> [ =A0 =A00.262304] usbcore: registered new interface driver hub
> [ =A0 =A00.262363] usbcore: registered new device driver usb
> [ =A0 =A00.262596] wmi: Mapper loaded
> [ =A0 =A00.262603] PCI: Using ACPI for IRQ routing
> [ =A0 =A00.262613] PCI: pci_cache_line_size set to 64 bytes
> [ =A0 =A00.262807] reserve RAM buffer: 000000000009f400 - 00000000000=
9ffff
> [ =A0 =A00.262813] reserve RAM buffer: 00000000bfffd000 - 00000000bff=
fffff
> [ =A0 =A00.263061] NetLabel: Initializing
> [ =A0 =A00.263066] NetLabel: =A0domain hash size =3D 128
> [ =A0 =A00.263068] NetLabel: =A0protocols =3D UNLABELED CIPSOv4
> [ =A0 =A00.263094] NetLabel: =A0unlabeled traffic allowed by default
> [ =A0 =A00.263195] HPET: 3 timers in total, 0 timers will be used for=
 per-cpu timer
> [ =A0 =A00.263227] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
> [ =A0 =A00.263232] hpet0: 3 comparators, 64-bit 100.000000 MHz counte=
r
> [ =A0 =A00.270100] Switching to clocksource kvm-clock
> [ =A0 =A00.279933] Switched to NOHz mode on CPU #0
> [ =A0 =A00.285977] AppArmor: AppArmor Filesystem Enabled
> [ =A0 =A00.286009] pnp: PnP ACPI init
> [ =A0 =A00.286029] ACPI: bus type pnp registered
> [ =A0 =A00.286070] pnp 00:00: [bus 00-ff]
> [ =A0 =A00.286074] pnp 00:00: [io =A00x0cf8-0x0cff]
> [ =A0 =A00.286077] pnp 00:00: [io =A00x0000-0x0cf7 window]
> [ =A0 =A00.286079] pnp 00:00: [io =A00x0d00-0xffff window]
> [ =A0 =A00.286082] pnp 00:00: [mem 0x000a0000-0x000bffff window]
> [ =A0 =A00.286085] pnp 00:00: [mem 0xe0000000-0xfebfffff window]
> [ =A0 =A00.286131] pnp 00:00: Plug and Play ACPI device, IDs PNP0a03 =
(active)
> [ =A0 =A00.286214] pnp 00:01: [io =A00x0070-0x0071]
> [ =A0 =A00.286268] pnp 00:01: [irq 8]
> [ =A0 =A00.286271] pnp 00:01: [io =A00x0072-0x0077]
> [ =A0 =A00.286321] pnp 00:01: Plug and Play ACPI device, IDs PNP0b00 =
(active)
> [ =A0 =A00.286366] pnp 00:02: [io =A00x0060]
> [ =A0 =A00.286368] pnp 00:02: [io =A00x0064]
> [ =A0 =A00.286399] pnp 00:02: [irq 1]
> [ =A0 =A00.286438] pnp 00:02: Plug and Play ACPI device, IDs PNP0303 =
(active)
> [ =A0 =A00.286496] pnp 00:03: [irq 12]
> [ =A0 =A00.286549] pnp 00:03: Plug and Play ACPI device, IDs PNP0f13 =
(active)
> [ =A0 =A00.286594] pnp 00:04: [io =A00x03f2-0x03f5]
> [ =A0 =A00.286596] pnp 00:04: [io =A00x03f7]
> [ =A0 =A00.286626] pnp 00:04: [irq 6]
> [ =A0 =A00.286628] pnp 00:04: [dma 2]
> [ =A0 =A00.286667] pnp 00:04: Plug and Play ACPI device, IDs PNP0700 =
(active)
> [ =A0 =A00.286741] pnp 00:05: [io =A00x0378-0x037f]
> [ =A0 =A00.286771] pnp 00:05: [irq 7]
> [ =A0 =A00.286825] pnp 00:05: Plug and Play ACPI device, IDs PNP0400 =
(active)
> [ =A0 =A00.286931] pnp 00:06: [io =A00x03f8-0x03ff]
> [ =A0 =A00.286962] pnp 00:06: [irq 4]
> [ =A0 =A00.287003] pnp 00:06: Plug and Play ACPI device, IDs PNP0501 =
(active)
> [ =A0 =A00.287071] pnp 00:07: [mem 0xfed00000-0xfed003ff]
> [ =A0 =A00.287111] pnp 00:07: Plug and Play ACPI device, IDs PNP0103 =
(active)
> [ =A0 =A00.287321] pnp: PnP ACPI: found 8 devices
> [ =A0 =A00.287323] ACPI: ACPI bus type pnp unregistered
> [ =A0 =A00.294697] pci_bus 0000:00: resource 0 [io =A00x0000-0xffff]
> [ =A0 =A00.294701] pci_bus 0000:00: resource 1 [mem 0x00000000-0xffff=
ffffff]
> [ =A0 =A00.294761] NET: Registered protocol family 2
> [ =A0 =A00.295003] IP route cache hash table entries: 131072 (order: =
8,
> 1048576 bytes)
> [ =A0 =A00.297429] TCP established hash table entries: 524288 (order:=
 11,
> 8388608 bytes)
> [ =A0 =A00.308286] TCP bind hash table entries: 65536 (order: 8, 1048=
576 bytes)
> [ =A0 =A00.309607] TCP: Hash tables configured (established 524288 bi=
nd 65536)
> [ =A0 =A00.309613] TCP reno registered
> [ =A0 =A00.309624] UDP hash table entries: 2048 (order: 4, 65536 byte=
s)
> [ =A0 =A00.309732] UDP-Lite hash table entries: 2048 (order: 4, 65536=
 bytes)
> [ =A0 =A00.309950] NET: Registered protocol family 1
> [ =A0 =A00.309979] pci 0000:00:00.0: Limiting direct PCI/PCI transfer=
s
> [ =A0 =A00.310039] pci 0000:00:01.0: PIIX3: Enabling Passive Release
> [ =A0 =A00.310070] pci 0000:00:01.0: Activating ISA DMA hang workarou=
nds
> [ =A0 =A00.310114] pci 0000:00:02.0: Boot video device
> [ =A0 =A00.310164] PCI: CLS 0 bytes, default 64
> [ =A0 =A00.310648] audit: initializing netlink socket (disabled)
> [ =A0 =A00.310665] type=3D2000 audit(1310890380.310:1): initialized
> [ =A0 =A00.329649] Trying to unpack rootfs image as initramfs...
> [ =A0 =A00.343100] HugeTLB registered 2 MB page size, pre-allocated 0=
 pages
> [ =A0 =A00.345720] VFS: Disk quotas dquot_6.5.2
> [ =A0 =A00.345818] Dquot-cache hash table entries: 512 (order 0, 4096=
 bytes)
> [ =A0 =A00.350221] fuse init (API version 7.16)
> [ =A0 =A00.350363] msgmni has been set to 6005
> [ =A0 =A00.360437] Block layer SCSI generic (bsg) driver version 0.4
> loaded (major 253)
> [ =A0 =A00.360489] io scheduler noop registered
> [ =A0 =A00.360491] io scheduler deadline registered (default)
> [ =A0 =A00.360558] io scheduler cfq registered
> [ =A0 =A00.360691] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> [ =A0 =A00.360729] pciehp: PCI Express Hot Plug Controller Driver ver=
sion: 0.4
> [ =A0 =A00.360835] efifb: probing for efifb
> [ =A0 =A00.360960] efifb: framebuffer at 0xf0000000, mapped to
> 0xffffc90001080000, using 1408k, total 1408k
> [ =A0 =A00.360963] efifb: mode is 800x600x24, linelength=3D2400, page=
s=3D1
> [ =A0 =A00.360965] efifb: scrolling: redraw
> [ =A0 =A00.360970] efifb: Truecolor: size=3D0:8:8:8, shift=3D0:16:8:0
> [ =A0 =A00.364483] Console: switching to colour frame buffer device 1=
00x37
> [ =A0 =A00.367114] fb0: EFI VGA frame buffer device
> [ =A0 =A00.367280] input: Power Button as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
> [ =A0 =A00.367298] ACPI: Power Button [PWRF]
> [ =A0 =A00.367787] ACPI: acpi_idle registered with cpuidle
> [ =A0 =A00.368885] ERST: Table is not found!
> [ =A0 =A00.369113] ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 11
> [ =A0 =A00.369154] virtio-pci 0000:00:03.0: PCI INT A -> Link[LNKC] -=
> GSI
> 11 (level, high) -> IRQ 11
> [ =A0 =A00.369195] virtio-pci 0000:00:03.0: setting latency timer to =
64
> [ =A0 =A00.369468] ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 10
> [ =A0 =A00.369501] virtio-pci 0000:00:04.0: PCI INT A -> Link[LNKD] -=
> GSI
> 10 (level, high) -> IRQ 10
> [ =A0 =A00.369532] virtio-pci 0000:00:04.0: setting latency timer to =
64
> [ =A0 =A00.369692] Serial: 8250/16550 driver, 32 ports, IRQ sharing e=
nabled
> [ =A0 =A00.391693] serial8250: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16=
550A
> [ =A0 =A00.415046] 00:06: ttyS0 at I/O 0x3f8 (irq =3D 4) is a 16550A
> [ =A0 =A00.415314] Linux agpgart interface v0.103
> [ =A0 =A00.417096] brd: module loaded
> [ =A0 =A00.417940] loop: module loaded
> [ =A0 =A00.418050] i2c-core: driver [adp5520] using legacy suspend me=
thod
> [ =A0 =A00.418053] i2c-core: driver [adp5520] using legacy resume met=
hod
> [ =A0 =A00.470377] ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
> [ =A0 =A00.470385] sym53c8xx 0000:00:05.0: PCI INT A -> Link[LNKA] ->=
 GSI
> 10 (level, high) -> IRQ 10
> [ =A0 =A00.471958] sym0: <895a> rev 0x0 at pci 0000:00:05.0 irq 10
> [ =A0 =A00.482464] sym0: No NVRAM, ID 7, Fast-40, LVD, parity checkin=
g
> [ =A0 =A00.490019] sym0: SCSI BUS has been reset.
> [ =A0 =A00.492876] scsi0 : sym-2.2.3
> [ =A0 =A00.500347] ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 11
> [ =A0 =A00.500353] sym53c8xx 0000:00:06.0: PCI INT A -> Link[LNKB] ->=
 GSI
> 11 (level, high) -> IRQ 11
> [ =A0 =A00.501884] sym1: <895a> rev 0x0 at pci 0000:00:06.0 irq 11
> [ =A0 =A00.512272] sym1: No NVRAM, ID 7, Fast-40, LVD, parity checkin=
g
> [ =A0 =A00.520021] sym1: SCSI BUS has been reset.
> [ =A0 =A00.522707] scsi1 : sym-2.2.3
> [ =A0 =A00.530183] ata_piix 0000:00:01.1: version 2.13
> [ =A0 =A00.530331] ata_piix 0000:00:01.1: setting latency timer to 64
> [ =A0 =A00.530964] scsi2 : ata_piix
> [ =A0 =A00.540221] scsi3 : ata_piix
> [ =A0 =A00.540303] ata1: PATA max MWDMA2 cmd 0x1f0 ctl 0x3f6 bmdma 0x=
c000 irq 14
> [ =A0 =A00.540307] ata2: PATA max MWDMA2 cmd 0x170 ctl 0x376 bmdma 0x=
c008 irq 15
> [ =A0 =A00.540768] Fixed MDIO Bus: probed
> [ =A0 =A00.540818] PPP generic driver version 2.4.2
> [ =A0 =A00.540908] tun: Universal TUN/TAP device driver, 1.6
> [ =A0 =A00.540910] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.=
com>
> [ =A0 =A00.541189] virtio-pci 0000:00:03.0: irq 40 for MSI/MSI-X
> [ =A0 =A00.541215] virtio-pci 0000:00:03.0: irq 41 for MSI/MSI-X
> [ =A0 =A00.541241] virtio-pci 0000:00:03.0: irq 42 for MSI/MSI-X
> [ =A0 =A00.544222] virtio-pci 0000:00:04.0: irq 43 for MSI/MSI-X
> [ =A0 =A00.544251] virtio-pci 0000:00:04.0: irq 44 for MSI/MSI-X
> [ =A0 =A00.544277] virtio-pci 0000:00:04.0: irq 45 for MSI/MSI-X
> [ =A0 =A00.546511] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI=
) Driver
> [ =A0 =A00.546548] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Dr=
iver
> [ =A0 =A00.546562] uhci_hcd: USB Universal Host Controller Interface =
driver
> [ =A0 =A00.546700] i8042: PNP: PS/2 Controller [PNP0303:KBD,PNP0f13:M=
OU]
> at 0x60,0x64 irq 1,12
> [ =A0 =A00.547490] serio: i8042 KBD port at 0x60,0x64 irq 1
> [ =A0 =A00.547501] serio: i8042 AUX port at 0x60,0x64 irq 12
> [ =A0 =A00.547623] mousedev: PS/2 mouse device common for all mice
> [ =A0 =A00.547865] rtc_cmos 00:01: rtc core: registered rtc_cmos as r=
tc0
> [ =A0 =A00.548007] rtc0: alarms up to one day, 114 bytes nvram, hpet =
irqs
> [ =A0 =A00.548160] device-mapper: uevent: version 1.0.3
> [ =A0 =A00.548315] device-mapper: ioctl: 4.19.1-ioctl (2011-01-07)
> initialised: dm-devel@redhat.com
> [ =A0 =A00.548739] input: AT Translated Set 2 keyboard as
> /devices/platform/i8042/serio0/input/input1
> [ =A0 =A00.549555] device-mapper: multipath: version 1.2.0 loaded
> [ =A0 =A00.549566] device-mapper: multipath round-robin: version 1.0.=
0 loaded
> [ =A0 =A00.550074] cpuidle: using governor ladder
> [ =A0 =A00.550080] cpuidle: using governor menu
> [ =A0 =A00.550421] TCP cubic registered
> [ =A0 =A00.550617] NET: Registered protocol family 10
> [ =A0 =A00.551795] NET: Registered protocol family 17
> [ =A0 =A00.551834] Registering the dns_resolver key type
> [ =A0 =A00.552039] PM: Hibernation image not present or could not be =
loaded.
> [ =A0 =A00.552060] registered taskstats version 1
> [ =A0 =A00.552295] =A0 Magic number: 3:298:220
> [ =A0 =A00.552356] dmi id: hash matches
> [ =A0 =A00.552362] scsi: waiting for bus probes to complete ...
> [ =A0 =A00.700853] ata2.01: NODEV after polling detection
> [ =A0 =A00.701237] ata1.01: NODEV after polling detection
> [ =A0 =A00.701613] ata2.00: ATAPI: QEMU DVD-ROM, 0.14.0, max UDMA/100
> [ =A0 =A00.701842] ata1.00: ATA-7: QEMU HARDDISK, 0.14.0, max UDMA/10=
0
> [ =A0 =A00.701846] ata1.00: 6291456 sectors, multi 16: LBA48
> [ =A0 =A00.702483] ata2.00: configured for MWDMA2
> [ =A0 =A00.702902] ata1.00: configured for MWDMA2
> [ =A0 =A00.702941] scsi: waiting for bus probes to complete ...
> [ =A0 =A00.865171] Freeing initrd memory: 13960k freed
> [ =A0 =A01.320192] Refined TSC clocksource calibration: 2400.078 MHz.
> [ =A0 =A03.500279] sym0: unknown interrupt(s) ignored, ISTAT=3D0x5 DS=
TAT=3D0x80 SIST=3D0x0
> [ =A0 =A03.500350] scsi 0:0:0:0: Direct-Access =A0 =A0 QEMU =A0 =A0 Q=
EMU HARDDISK
> =A00.14 PQ: 0 ANSI: 5
> [ =A0 =A03.500359] scsi target0:0:0: tagged command queuing enabled,
> command queue depth 16.
> [ =A0 =A03.500378] scsi target0:0:0: Beginning Domain Validation
> [ =A0 =A03.500866] scsi target0:0:0: Domain Validation skipping write=
 tests
> [ =A0 =A03.500869] scsi target0:0:0: Ending Domain Validation
> [ =A0 =A03.501073] scsi 0:0:1:0: Direct-Access =A0 =A0 QEMU =A0 =A0 Q=
EMU HARDDISK
> =A00.14 PQ: 0 ANSI: 5
> [ =A0 =A03.501079] scsi target0:0:1: tagged command queuing enabled,
> command queue depth 16.
> [ =A0 =A03.501084] scsi target0:0:1: Beginning Domain Validation
> [ =A0 =A03.501553] scsi target0:0:1: Domain Validation skipping write=
 tests
> [ =A0 =A03.501556] scsi target0:0:1: Ending Domain Validation
> [ =A0 =A03.501792] scsi 0:0:2:0: Direct-Access =A0 =A0 QEMU =A0 =A0 Q=
EMU HARDDISK
> =A00.14 PQ: 0 ANSI: 5
> [ =A0 =A03.501797] scsi target0:0:2: tagged command queuing enabled,
> command queue depth 16.
> [ =A0 =A03.501802] scsi target0:0:2: Beginning Domain Validation
> [ =A0 =A03.502269] scsi target0:0:2: Domain Validation skipping write=
 tests
> [ =A0 =A03.502273] scsi target0:0:2: Ending Domain Validation
> [ =A0 =A03.502448] scsi 0:0:3:0: Direct-Access =A0 =A0 QEMU =A0 =A0 Q=
EMU HARDDISK
> =A00.14 PQ: 0 ANSI: 5
> [ =A0 =A03.502454] scsi target0:0:3: tagged command queuing enabled,
> command queue depth 16.
> [ =A0 =A03.502458] scsi target0:0:3: Beginning Domain Validation
> [ =A0 =A03.502928] scsi target0:0:3: Domain Validation skipping write=
 tests
> [ =A0 =A03.502931] scsi target0:0:3: Ending Domain Validation
> [ =A0 =A03.503145] scsi 0:0:4:0: Direct-Access =A0 =A0 QEMU =A0 =A0 Q=
EMU HARDDISK
> =A00.14 PQ: 0 ANSI: 5
> [ =A0 =A03.503150] scsi target0:0:4: tagged command queuing enabled,
> command queue depth 16.
> [ =A0 =A03.503155] scsi target0:0:4: Beginning Domain Validation
> [ =A0 =A03.503679] scsi target0:0:4: Domain Validation skipping write=
 tests
> [ =A0 =A03.503683] scsi target0:0:4: Ending Domain Validation
> [ =A0 =A03.503887] scsi 0:0:5:0: Direct-Access =A0 =A0 QEMU =A0 =A0 Q=
EMU HARDDISK
> =A00.14 PQ: 0 ANSI: 5
> [ =A0 =A03.503893] scsi target0:0:5: tagged command queuing enabled,
> command queue depth 16.
> [ =A0 =A03.503898] scsi target0:0:5: Beginning Domain Validation
> [ =A0 =A03.504365] scsi target0:0:5: Domain Validation skipping write=
 tests
> [ =A0 =A03.504368] scsi target0:0:5: Ending Domain Validation
> [ =A0 =A03.504560] scsi 0:0:6:0: Direct-Access =A0 =A0 QEMU =A0 =A0 Q=
EMU HARDDISK
> =A00.14 PQ: 0 ANSI: 5
> [ =A0 =A03.504566] scsi target0:0:6: tagged command queuing enabled,
> command queue depth 16.
> [ =A0 =A03.504571] scsi target0:0:6: Beginning Domain Validation
> [ =A0 =A03.505035] scsi target0:0:6: Domain Validation skipping write=
 tests
> [ =A0 =A03.505039] scsi target0:0:6: Ending Domain Validation
> [ =A0 =A03.507100] sd 0:0:0:0: Attached scsi generic sg0 type 0
> [ =A0 =A03.507330] sd 0:0:1:0: Attached scsi generic sg1 type 0
> [ =A0 =A03.507568] sd 0:0:2:0: Attached scsi generic sg2 type 0
> [ =A0 =A03.507795] sd 0:0:3:0: Attached scsi generic sg3 type 0
> [ =A0 =A03.507990] sd 0:0:4:0: Attached scsi generic sg4 type 0
> [ =A0 =A03.508233] sd 0:0:5:0: Attached scsi generic sg5 type 0
> [ =A0 =A03.508494] sd 0:0:6:0: Attached scsi generic sg6 type 0
> [ =A0 =A03.508754] sd 0:0:0:0: [sda] 41943040 512-byte logical blocks=
:
> (21.4 GB/20.0 GiB)
> [ =A0 =A03.509042] sd 0:0:0:0: [sda] Write Protect is off
> [ =A0 =A03.509046] sd 0:0:0:0: [sda] Mode Sense: 1f 00 00 08
> [ =A0 =A03.509185] sd 0:0:0:0: [sda] Write cache: disabled, read cach=
e:
> enabled, doesn't support DPO or FUA
> [ =A0 =A03.510419] sd 0:0:1:0: [sdb] 41943040 512-byte logical blocks=
:
> (21.4 GB/20.0 GiB)
> [ =A0 =A03.510716] sd 0:0:1:0: [sdb] Write Protect is off
> [ =A0 =A03.510721] sd 0:0:1:0: [sdb] Mode Sense: 1f 00 00 08
> [ =A0 =A03.510860] sd 0:0:1:0: [sdb] Write cache: disabled, read cach=
e:
> enabled, doesn't support DPO or FUA
> [ =A0 =A03.512051] sd 0:0:2:0: [sdc] 41943040 512-byte logical blocks=
:
> (21.4 GB/20.0 GiB)
> [ =A0 =A03.512330] sd 0:0:2:0: [sdc] Write Protect is off
> [ =A0 =A03.512334] sd 0:0:2:0: [sdc] Mode Sense: 1f 00 00 08
> [ =A0 =A03.512474] sd 0:0:2:0: [sdc] Write cache: disabled, read cach=
e:
> enabled, doesn't support DPO or FUA
> [ =A0 =A03.513724] =A0sda: unknown partition table
> [ =A0 =A03.514364] sd 0:0:0:0: [sda] Attached SCSI disk
> [ =A0 =A03.514513] sd 0:0:3:0: [sdd] 41943040 512-byte logical blocks=
:
> (21.4 GB/20.0 GiB)
> [ =A0 =A03.514787] sd 0:0:3:0: [sdd] Write Protect is off
> [ =A0 =A03.514791] sd 0:0:3:0: [sdd] Mode Sense: 1f 00 00 08
> [ =A0 =A03.514929] sd 0:0:3:0: [sdd] Write cache: disabled, read cach=
e:
> enabled, doesn't support DPO or FUA
> [ =A0 =A03.516114] sd 0:0:4:0: [sde] 41943040 512-byte logical blocks=
:
> (21.4 GB/20.0 GiB)
> [ =A0 =A03.516392] sd 0:0:4:0: [sde] Write Protect is off
> [ =A0 =A03.516396] sd 0:0:4:0: [sde] Mode Sense: 1f 00 00 08
> [ =A0 =A03.516534] sd 0:0:4:0: [sde] Write cache: disabled, read cach=
e:
> enabled, doesn't support DPO or FUA
> [ =A0 =A03.517298] =A0sdb: unknown partition table
> [ =A0 =A03.517982] sd 0:0:1:0: [sdb] Attached SCSI disk
> [ =A0 =A03.518130] sd 0:0:5:0: [sdf] 2097152 512-byte logical blocks:
> (1.07 GB/1.00 GiB)
> [ =A0 =A03.518407] sd 0:0:5:0: [sdf] Write Protect is off
> [ =A0 =A03.518410] sd 0:0:5:0: [sdf] Mode Sense: 1f 00 00 08
> [ =A0 =A03.518549] sd 0:0:5:0: [sdf] Write cache: disabled, read cach=
e:
> enabled, doesn't support DPO or FUA
> [ =A0 =A03.519661] =A0sdc: unknown partition table
> [ =A0 =A03.520315] sd 0:0:2:0: [sdc] Attached SCSI disk
> [ =A0 =A03.520462] sd 0:0:6:0: [sdg] 2097152 512-byte logical blocks:
> (1.07 GB/1.00 GiB)
> [ =A0 =A03.520737] sd 0:0:6:0: [sdg] Write Protect is off
> [ =A0 =A03.520741] sd 0:0:6:0: [sdg] Mode Sense: 1f 00 00 08
> [ =A0 =A03.520880] sd 0:0:6:0: [sdg] Write cache: disabled, read cach=
e:
> enabled, doesn't support DPO or FUA
> [ =A0 =A03.521927] =A0sdd: unknown partition table
> [ =A0 =A03.522571] sd 0:0:3:0: [sdd] Attached SCSI disk
> [ =A0 =A03.522593] =A0sde: unknown partition table
> [ =A0 =A03.523198] sd 0:0:4:0: [sde] Attached SCSI disk
> [ =A0 =A03.524137] =A0sdf: unknown partition table
> [ =A0 =A03.524759] sd 0:0:5:0: [sdf] Attached SCSI disk
> [ =A0 =A03.524782] =A0sdg: unknown partition table
> [ =A0 =A03.525387] sd 0:0:6:0: [sdg] Attached SCSI disk
> [ =A0 =A03.530161] sym1: unknown interrupt(s) ignored, ISTAT=3D0x5 DS=
TAT=3D0x80 SIST=3D0x0
> [ =A0 =A03.530202] scsi 1:0:0:0: Direct-Access =A0 =A0 QEMU =A0 =A0 Q=
EMU HARDDISK
> =A00.14 PQ: 0 ANSI: 5
> [ =A0 =A03.530208] scsi target1:0:0: tagged command queuing enabled,
> command queue depth 16.
> [ =A0 =A03.530213] scsi target1:0:0: Beginning Domain Validation
> [ =A0 =A03.530686] scsi target1:0:0: Domain Validation skipping write=
 tests
> [ =A0 =A03.530690] scsi target1:0:0: Ending Domain Validation
> [ =A0 =A03.530870] scsi 1:0:1:0: Direct-Access =A0 =A0 QEMU =A0 =A0 Q=
EMU HARDDISK
> =A00.14 PQ: 0 ANSI: 5
> [ =A0 =A03.530875] scsi target1:0:1: tagged command queuing enabled,
> command queue depth 16.
> [ =A0 =A03.530880] scsi target1:0:1: Beginning Domain Validation
> [ =A0 =A03.531346] scsi target1:0:1: Domain Validation skipping write=
 tests
> [ =A0 =A03.531349] scsi target1:0:1: Ending Domain Validation
> [ =A0 =A03.531526] scsi 1:0:2:0: Direct-Access =A0 =A0 QEMU =A0 =A0 Q=
EMU HARDDISK
> =A00.14 PQ: 0 ANSI: 5
> [ =A0 =A03.531537] scsi target1:0:2: tagged command queuing enabled,
> command queue depth 16.
> [ =A0 =A03.531542] scsi target1:0:2: Beginning Domain Validation
> [ =A0 =A03.532008] scsi target1:0:2: Domain Validation skipping write=
 tests
> [ =A0 =A03.532011] scsi target1:0:2: Ending Domain Validation
> [ =A0 =A03.534793] sd 1:0:0:0: Attached scsi generic sg7 type 0
> [ =A0 =A03.534998] sd 1:0:1:0: Attached scsi generic sg8 type 0
> [ =A0 =A03.535201] sd 1:0:2:0: Attached scsi generic sg9 type 0
> [ =A0 =A03.535344] rtc_cmos 00:01: setting system clock to 2011-07-17
> 08:13:02 UTC (1310890382)
> [ =A0 =A03.535349] BIOS EDD facility v0.16 2004-Jun-25, 0 devices fou=
nd
> [ =A0 =A03.535351] EDD information not available.
> [ =A0 =A03.535519] scsi 2:0:0:0: Direct-Access =A0 =A0 ATA =A0 =A0 =A0=
QEMU HARDDISK
> =A00.14 PQ: 0 ANSI: 5
> [ =A0 =A03.535697] sd 2:0:0:0: Attached scsi generic sg10 type 0
> [ =A0 =A03.535918] sd 1:0:0:0: [sdh] 2097152 512-byte logical blocks:
> (1.07 GB/1.00 GiB)
> [ =A0 =A03.536196] sd 1:0:0:0: [sdh] Write Protect is off
> [ =A0 =A03.536200] sd 1:0:0:0: [sdh] Mode Sense: 1f 00 00 08
> [ =A0 =A03.536339] sd 1:0:0:0: [sdh] Write cache: disabled, read cach=
e:
> enabled, doesn't support DPO or FUA
> [ =A0 =A03.537563] scsi 3:0:0:0: CD-ROM =A0 =A0 =A0 =A0 =A0 =A0QEMU =A0=
 =A0 QEMU DVD-ROM
> =A00.14 PQ: 0 ANSI: 5
> [ =A0 =A03.538417] sr0: scsi3-mmc drive: 4x/4x xa/form2 tray
> [ =A0 =A03.538429] cdrom: Uniform CD-ROM driver Revision: 3.20
> [ =A0 =A03.538568] sr 3:0:0:0: Attached scsi CD-ROM sr0
> [ =A0 =A03.538649] sr 3:0:0:0: Attached scsi generic sg11 type 5
> [ =A0 =A03.538861] sd 1:0:1:0: [sdi] 2097152 512-byte logical blocks:
> (1.07 GB/1.00 GiB)
> [ =A0 =A03.539141] sd 1:0:1:0: [sdi] Write Protect is off
> [ =A0 =A03.539145] sd 1:0:1:0: [sdi] Mode Sense: 1f 00 00 08
> [ =A0 =A03.539284] sd 1:0:1:0: [sdi] Write cache: disabled, read cach=
e:
> enabled, doesn't support DPO or FUA
> [ =A0 =A03.540394] sd 1:0:2:0: [sdj] 2097152 512-byte logical blocks:
> (1.07 GB/1.00 GiB)
> [ =A0 =A03.540670] sd 1:0:2:0: [sdj] Write Protect is off
> [ =A0 =A03.540674] sd 1:0:2:0: [sdj] Mode Sense: 1f 00 00 08
> [ =A0 =A03.540812] sd 1:0:2:0: [sdj] Write cache: disabled, read cach=
e:
> enabled, doesn't support DPO or FUA
> [ =A0 =A03.541627] sd 2:0:0:0: [sdk] 6291456 512-byte logical blocks:
> (3.22 GB/3.00 GiB)
> [ =A0 =A03.541686] sd 2:0:0:0: [sdk] Write Protect is off
> [ =A0 =A03.541689] sd 2:0:0:0: [sdk] Mode Sense: 00 3a 00 00
> [ =A0 =A03.541715] sd 2:0:0:0: [sdk] Write cache: disabled, read cach=
e:
> enabled, doesn't support DPO or FUA
> [ =A0 =A03.542886] =A0sdh: unknown partition table
> [ =A0 =A03.543573] sd 1:0:0:0: [sdh] Attached SCSI disk
> [ =A0 =A03.543593] =A0sdk: sdk1 sdk2 < sdk5 >
> [ =A0 =A03.543971] sd 2:0:0:0: [sdk] Attached SCSI disk
> [ =A0 =A03.544235] =A0sdi: unknown partition table
> [ =A0 =A03.544904] sd 1:0:1:0: [sdi] Attached SCSI disk
> [ =A0 =A03.544927] =A0sdj: unknown partition table
> [ =A0 =A03.545527] sd 1:0:2:0: [sdj] Attached SCSI disk
> [ =A0 =A03.547939] Freeing unused kernel memory: 880k freed
> [ =A0 =A03.548487] Write protecting the kernel read-only data: 10240k
> [ =A0 =A03.549192] Freeing unused kernel memory: 104k freed
> [ =A0 =A03.556492] Freeing unused kernel memory: 1416k freed
> [ =A0 =A03.585709] <30>udev[70]: starting version 167
> [ =A0 =A03.622636] md: linear personality registered for level -1
> [ =A0 =A03.625882] md: multipath personality registered for level -4
> [ =A0 =A03.634679] md: raid0 personality registered for level 0
> [ =A0 =A03.647068] md: raid1 personality registered for level 1
> [ =A0 =A03.654145] async_tx: api initialized (async)
> [ =A0 =A03.820061] raid6: int64x1 =A0 1469 MB/s
> [ =A0 =A03.990046] raid6: int64x2 =A0 1892 MB/s
> [ =A0 =A04.160050] raid6: int64x4 =A0 1278 MB/s
> [ =A0 =A04.330042] raid6: int64x8 =A0 1346 MB/s
> [ =A0 =A04.500019] raid6: sse2x1 =A0 =A06524 MB/s
> [ =A0 =A04.670017] raid6: sse2x2 =A0 =A07954 MB/s
> [ =A0 =A04.840018] raid6: sse2x4 =A0 =A08808 MB/s
> [ =A0 =A04.840020] raid6: using algorithm sse2x4 (8808 MB/s)
> [ =A0 =A04.849194] xor: automatically using best checksumming functio=
n: generic_sse
> [ =A0 =A04.890032] =A0 =A0generic_sse: =A0 184.000 MB/sec
> [ =A0 =A04.890034] xor: using function: generic_sse (184.000 MB/sec)
> [ =A0 =A04.938302] md: raid6 personality registered for level 6
> [ =A0 =A04.938308] md: raid5 personality registered for level 5
> [ =A0 =A04.938309] md: raid4 personality registered for level 4
> [ =A0 =A04.953743] md: raid10 personality registered for level 10
> [ =A0 =A05.050518] FDC 0 is a S82078B
> [ =A0 =A05.073900] EXT4-fs (sdk1): mounted filesystem with ordered da=
ta
> mode. Opts: (null)
> [ =A0 =A05.564195] <30>udev[318]: starting version 167
> [ =A0 =A05.580600] Adding 313340k swap on /dev/sdk5. =A0Priority:-1
> extents:1 across:313340k
> [ =A0 =A05.628302] lp: driver loaded but no devices found
> [ =A0 =A05.694797] EXT4-fs (sdk1): re-mounted. Opts: errors=3Dremount=
-ro
> [ =A0 =A05.775888] piix4_smbus 0000:00:01.3: SMBus Host Controller at
> 0xb100, revision 0
> [ =A0 =A06.049026] RPC: Registered udp transport module.
> [ =A0 =A06.049030] RPC: Registered tcp transport module.
> [ =A0 =A06.049032] RPC: Registered tcp NFSv4.1 backchannel transport =
module.
> [ =A0 =A06.126806] FS-Cache: Loaded
> [ =A0 =A06.155722] parport_pc 00:05: reported by Plug and Play ACPI
> [ =A0 =A06.155855] parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE=
]
> [ =A0 =A06.201241] FS-Cache: Netfs 'nfs' registered for caching
> [ =A0 =A06.242319] type=3D1400 audit(1310890385.202:2): apparmor=3D"S=
TATUS"
> operation=3D"profile_load" name=3D"/sbin/dhclient" pid=3D466
> comm=3D"apparmor_parser"
> [ =A0 =A06.243477] type=3D1400 audit(1310890385.202:3): apparmor=3D"S=
TATUS"
> operation=3D"profile_load"
> name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D466
> comm=3D"apparmor_parser"
> [ =A0 =A06.244050] type=3D1400 audit(1310890385.202:4): apparmor=3D"S=
TATUS"
> operation=3D"profile_load"
> name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D466
> comm=3D"apparmor_parser"
> [ =A0 =A06.315981] Installing knfsd (copyright (C) 1996 okir@monad.sw=
b.de).
> [ =A0 =A06.431932] Loading iSCSI transport class v2.0-870.
> [ =A0 =A06.483340] iscsi: registered transport (tcp)
> [ =A0 =A06.588133] iscsi: registered transport (iser)
> [ =A0 =A06.617974] iscsid (585): /proc/585/oom_adj is deprecated, ple=
ase
> use /proc/585/oom_score_adj instead.
> [ =A0 =A06.984170] type=3D1400 audit(1310890385.942:5): apparmor=3D"S=
TATUS"
> operation=3D"profile_replace" name=3D"/sbin/dhclient" pid=3D781
> comm=3D"apparmor_parser"
> [ =A0 =A06.992532] lp0: using parport0 (interrupt-driven).
> [ =A0 =A06.996255] type=3D1400 audit(1310890385.952:6): apparmor=3D"S=
TATUS"
> operation=3D"profile_replace"
> name=3D"/usr/lib/NetworkManager/nm-dhcp-client.action" pid=3D781
> comm=3D"apparmor_parser"
> [ =A0 =A06.998575] type=3D1400 audit(1310890385.952:7): apparmor=3D"S=
TATUS"
> operation=3D"profile_replace"
> name=3D"/usr/lib/connman/scripts/dhclient-script" pid=3D781
> comm=3D"apparmor_parser"
> [ =A0 =A07.002830] type=3D1400 audit(1310890385.962:8): apparmor=3D"S=
TATUS"
> operation=3D"profile_load" name=3D"/usr/sbin/mysqld" pid=3D792
> comm=3D"apparmor_parser"
> [ =A0 =A07.012676] type=3D1400 audit(1310890385.972:9): apparmor=3D"S=
TATUS"
> operation=3D"profile_load" name=3D"/usr/sbin/tcpdump" pid=3D798
> comm=3D"apparmor_parser"
> [ =A0 =A07.193731] ppdev: user-space parallel port driver
> [ =A0 =A07.270891] input: ImExPS/2 Generic Explorer Mouse as
> /devices/platform/i8042/serio1/input/input2
> [ =A0 =A07.708155] [1010]: scst: scst_register_device:962:Attached to
> scsi0, channel 0, id 0, lun 0, type 0
> [ =A0 =A07.708164] [1010]: scst: scst_register_device:962:Attached to
> scsi0, channel 0, id 1, lun 0, type 0
> [ =A0 =A07.708172] [1010]: scst: scst_register_device:962:Attached to
> scsi0, channel 0, id 2, lun 0, type 0
> [ =A0 =A07.708179] [1010]: scst: scst_register_device:962:Attached to
> scsi0, channel 0, id 3, lun 0, type 0
> [ =A0 =A07.708186] [1010]: scst: scst_register_device:962:Attached to
> scsi0, channel 0, id 4, lun 0, type 0
> [ =A0 =A07.708193] [1010]: scst: scst_register_device:962:Attached to
> scsi0, channel 0, id 5, lun 0, type 0
> [ =A0 =A07.708200] [1010]: scst: scst_register_device:962:Attached to
> scsi0, channel 0, id 6, lun 0, type 0
> [ =A0 =A07.708207] [1010]: scst: scst_register_device:962:Attached to
> scsi1, channel 0, id 0, lun 0, type 0
> [ =A0 =A07.708214] [1010]: scst: scst_register_device:962:Attached to
> scsi1, channel 0, id 1, lun 0, type 0
> [ =A0 =A07.708221] [1010]: scst: scst_register_device:962:Attached to
> scsi1, channel 0, id 2, lun 0, type 0
> [ =A0 =A07.708229] [1010]: scst: scst_register_device:962:Attached to
> scsi2, channel 0, id 0, lun 0, type 0
> [ =A0 =A07.708245] [1010]: scst: scst_register_device:962:Attached to
> scsi3, channel 0, id 0, lun 0, type 5
> [ =A0 =A07.708256] [1011]: scst: sysfs_work_thread_fn:518:User interf=
ace
> thread started, PID 1011
> [ =A0 =A07.711605] [1015]: scst: scst_cmd_thread:4288:Processing thre=
ad
> scstd0 (PID 1015) started
> [ =A0 =A07.711621] [1016]: scst: scst_init_thread:4032:Init thread st=
arted, PID 1016
> [ =A0 =A07.711634] [1017]: scst: scst_tm_thread:5804:Task management
> thread started, PID 1017
> [ =A0 =A07.711640] [1010]: scst: init_scst:2349:SCST version 2.1.0-rc=
1
> loaded successfully (max mem for commands 754MB, per device 301MB)
> [ =A0 =A07.711644] [1010]: scst: scst_print_config:2144:Enabled featu=
res:
> EXTRACHECKS, DEBUG
> [ =A0 =A07.717828] [1019]: scst:
> __scst_register_virtual_dev_driver:1520:Virtual device handler
> vdisk_fileio for type 0 registered successfully
> [ =A0 =A07.717835] [1019]: scst:
> __scst_register_virtual_dev_driver:1520:Virtual device handler
> vdisk_blockio for type 0 registered successfully
> [ =A0 =A07.717840] [1019]: scst:
> __scst_register_virtual_dev_driver:1520:Virtual device handler
> vdisk_nullio for type 0 registered successfully
> [ =A0 =A07.717845] [1019]: scst:
> __scst_register_virtual_dev_driver:1520:Virtual device handler vcdrom
> for type 5 registered successfully
> [ =A0 =A07.718208] [1018]: scst: scst_global_mgmt_thread:6584:Managem=
ent
> thread started, PID 1018
> [ =A0 =A07.741409] [1027]: iscsi-scst: iscsi_init:4026:iSCSI SCST Tar=
get -
> version 2.1.0-rc1
> [ =A0 =A07.741559] [1027]: iscsi-scst: iscsi_init:4056:***WARNING***:
> CONFIG_TCP_ZERO_COPY_TRANSFER_COMPLETION_NOTIFICATION not enabled in
> your kernel. ISCSI-SCST will be working with not the best performance=
=2E
> Refer README file for details.
> [ =A0 =A07.741604] [1027]: scst:
> __scst_register_target_template:318:Target template iscsi registered
> successfully
> [ =A0 =A07.742165] [1028]: iscsi-scst: istrd:1085:Read thread for poo=
l
> ffff8800b7cb99c0 started, PID 1028
> [ =A0 =A07.742180] [1029]: iscsi-scst: istrd:1085:Read thread for poo=
l
> ffff8800b7cb99c0 started, PID 1029
> [ =A0 =A07.742194] [1030]: iscsi-scst: istwr:1856:Write thread for po=
ol
> ffff8800b7cb99c0 started, PID 1030
> [ =A0 =A07.745931] [1031]: iscsi-scst: istwr:1856:Write thread for po=
ol
> ffff8800b7cb99c0 started, PID 1031
> [ =A0 16.560135] eth0: no IPv6 routers present
> [ =A0170.648177] md: bind<sda>
> [ =A0170.648521] md: bind<sdb>
> [ =A0170.648740] md: bind<sdc>
> [ =A0170.656510] bio: create slab <bio-1> at 1
> [ =A0170.656540] md/raid:md1123: device sdb operational as raid disk =
1
> [ =A0170.656543] md/raid:md1123: device sda operational as raid disk =
0
> [ =A0170.657080] md/raid:md1123: allocated 3230kB
> [ =A0170.659433] md/raid:md1123: raid level 5 active with 2 out of 3
> devices, algorithm 2
> [ =A0170.659608] RAID conf printout:
> [ =A0170.659611] =A0--- level:5 rd:3 wd:2
> [ =A0170.659614] =A0disk 0, o:1, dev:sda
> [ =A0170.659616] =A0disk 1, o:1, dev:sdb
> [ =A0170.659893] created bitmap (1 pages) for device md1123
> [ =A0170.660415] md1123: bitmap initialized from disk: read 1/1 pages=
,
> set 320 bits
> [ =A0170.674166] md1123: detected capacity change from 0 to 429465272=
32
> [ =A0170.676006] RAID conf printout:
> [ =A0170.676010] =A0--- level:5 rd:3 wd:2
> [ =A0170.676013] =A0disk 0, o:1, dev:sda
> [ =A0170.676015] =A0disk 1, o:1, dev:sdb
> [ =A0170.676017] =A0disk 2, o:1, dev:sdc
> [ =A0170.676175] =A0md1123: unknown partition table
> [ =A0170.676597] md: recovery of RAID array md1123
> [ =A0170.676601] md: minimum _guaranteed_ =A0speed: 1000 KB/sec/disk.
> [ =A0170.676603] md: using maximum available idle IO bandwidth (but n=
ot
> more than 200000 KB/sec) for recovery.
> [ =A0170.676607] md: using 128k window, over a total of 20969984 bloc=
ks.
> [ =A0176.678537] md/raid:md1123: Disk failure on sda, disabling devic=
e.
> [ =A0176.678539] md/raid:md1123: Operation continuing on 1 devices.
> [ =A0176.740093] md: md1123: recovery done.
> [ =A0177.691653] md: md1123 still in use.
> [ =A0216.311462] md: md1123 still in use.
> [ =A0228.591860] md: cannot remove active disk sda from md1123 ...
> [ =A0230.141428] md: cannot remove active disk sdb from md1123 ...
> [ =A0231.221410] md: cannot remove active disk sdc from md1123 ...
> [ =A0504.910634] SysRq : Show Blocked State
> [ =A0504.910729] =A0 task =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0PC stack =A0 pid father
> [ =A0504.910749] blkid =A0 =A0 =A0 =A0 =A0 D 0000000000000000 =A0 =A0=
 0 =A01337 =A0 =A0 =A01 0x00000000
> [ =A0504.910753] =A0ffff8800b509bbf8 0000000000000086 ffff8800b509bfd=
8
> ffff8800b509a000
> [ =A0504.910756] =A00000000000013d00 ffff8800b796b178 ffff8800b509bfd=
8
> 0000000000013d00
> [ =A0504.910758] =A0ffff8800b5bf96e0 ffff8800b796adc0 ffff8800bffcb24=
8
> ffff8800bfc13d00
> [ =A0504.910761] Call Trace:
> [ =A0504.910770] =A0[<ffffffff8110b480>] ? sync_page_killable+0x0/0x4=
0
> [ =A0504.910774] =A0[<ffffffff815d5720>] io_schedule+0x70/0xc0
> [ =A0504.910776] =A0[<ffffffff8110b470>] sync_page+0x40/0x50
> [ =A0504.910778] =A0[<ffffffff8110b48e>] sync_page_killable+0xe/0x40
> [ =A0504.910780] =A0[<ffffffff815d5cea>] __wait_on_bit_lock+0x5a/0xc0
> [ =A0504.910783] =A0[<ffffffff8110b397>] __lock_page_killable+0x67/0x=
70
> [ =A0504.910787] =A0[<ffffffff81087980>] ? wake_bit_function+0x0/0x50
> [ =A0504.910789] =A0[<ffffffff8110c547>] do_generic_file_read.clone.2=
3+0x297/0x450
> [ =A0504.910792] =A0[<ffffffff8110d1ba>] generic_file_aio_read+0x1ca/=
0x240
> [ =A0504.910796] =A0[<ffffffff81164c82>] do_sync_read+0xd2/0x110
> [ =A0504.910807] =A0[<ffffffff81279083>] ? security_file_permission+0=
x93/0xb0
> [ =A0504.910809] =A0[<ffffffff81164fa1>] ? rw_verify_area+0x61/0xf0
> [ =A0504.910811] =A0[<ffffffff81165463>] vfs_read+0xc3/0x180
> [ =A0504.910813] =A0[<ffffffff81165571>] sys_read+0x51/0x90
> [ =A0504.910816] =A0[<ffffffff8100bfc2>] system_call_fastpath+0x16/0x=
1b
> [ =A0504.910821] Sched Debug Version: v0.10, 2.6.38-8-server #42-Ubun=
tu
> [ =A0504.910823] ktime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 : 504910.820117
> [ =A0504.910824] sched_clk =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 : 953864697.597371
> [ =A0504.910826] cpu_clk =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 : 504910.820189
> [ =A0504.910827] jiffies =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 : 4294987787
> [ =A0504.910828] sched_clock_stable =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.910829]
> [ =A0504.910830] sysctl_sched
> [ =A0504.910831] =A0 .sysctl_sched_latency =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0: 6.000000
> [ =A0504.910832] =A0 .sysctl_sched_min_granularity =A0 =A0 =A0 =A0 =A0=
 =A0: 0.750000
> [ =A0504.910834] =A0 .sysctl_sched_wakeup_granularity =A0 =A0 =A0 =A0=
 : 1.000000
> [ =A0504.910835] =A0 .sysctl_sched_child_runs_first =A0 =A0 =A0 =A0 =A0=
 : 0
> [ =A0504.910836] =A0 .sysctl_sched_features =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 : 7279
> [ =A0504.910838] =A0 .sysctl_sched_tunable_scaling =A0 =A0 =A0 =A0 =A0=
 =A0: 1 (logaritmic)
> [ =A0504.910841]
> [ =A0504.910842] cpu#0, 2400.084 MHz
> [ =A0504.910843] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 2
> [ =A0504.910844] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 2048
> [ =A0504.910845] =A0 .nr_switches =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 44013
> [ =A0504.910846] =A0 .nr_load_updates =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 3=
6769
> [ =A0504.910848] =A0 .nr_uninterruptible =A0 =A0 =A0 =A0 =A0 =A0: 1
> [ =A0504.910849] =A0 .next_balance =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 4294.955008
> [ =A0504.910850] =A0 .curr->pid =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 1390
> [ =A0504.910851] =A0 .clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 504910.025729
> [ =A0504.910852] =A0 .cpu_load[0] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 1024
> [ =A0504.910854] =A0 .cpu_load[1] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 1024
> [ =A0504.910855] =A0 .cpu_load[2] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 1024
> [ =A0504.910856] =A0 .cpu_load[3] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 1024
> [ =A0504.910857] =A0 .cpu_load[4] =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 1024
> [ =A0504.910858] =A0 .yld_count =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0
> [ =A0504.910859] =A0 .sched_switch =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0
> [ =A0504.910860] =A0 .sched_count =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 44317
> [ =A0504.910861] =A0 .sched_goidle =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 4441
> [ =A0504.910862] =A0 .avg_idle =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 1000000
> [ =A0504.910863] =A0 .ttwu_count =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 24587
> [ =A0504.910864] =A0 .ttwu_local =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 24587
> [ =A0504.910865] =A0 .bkl_count =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0
> [ =A0504.910869]
> [ =A0504.910869] cfs_rq[0]:/autogroup-55
> [ =A0504.910870] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0.577353
> [ =A0504.910872] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.910873] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.471223
> [ =A0504.910874] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.910885] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.910886] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -332282.124910
> [ =A0504.910887] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 0
> [ =A0504.910888] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0
> [ =A0504.910889] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.910891] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 65.955840
> [ =A0504.910892] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0.064410
> [ =A0504.910893] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0
> [ =A0504.910894] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 0
> [ =A0504.910896] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 307680.101709
> [ =A0504.910898] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 135197.882765
> [ =A0504.910899] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 0.577=
353
> [ =A0504.910900] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.910901] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.910903] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.910904] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.910905] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.910906] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 0.301475
> [ =A0504.910908] =A0 .se->statistics.slice_max =A0 =A0 =A0: 0.302127
> [ =A0504.910909] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 0.027890
> [ =A0504.910910] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 0.049731
> [ =A0504.910911] =A0 .se->statistics.wait_count =A0 =A0 : 8
> [ =A0504.910912] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 2
> [ =A0504.910914]
> [ =A0504.910914] cfs_rq[0]:/autogroup-98
> [ =A0504.910916] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 436.471565
> [ =A0504.910917] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.910918] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 476.072780
> [ =A0504.910919] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.910921] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.910922] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -331805.580907
> [ =A0504.910923] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 158
> [ =A0504.910924] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 1
> [ =A0504.910925] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 1024
> [ =A0504.910927] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 0.414715
> [ =A0504.910928] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 6.987305
> [ =A0504.910929] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0
> [ =A0504.910930] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 0
> [ =A0504.910931] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 504910.025729
> [ =A0504.910933] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 332278.653687
> [ =A0504.910934] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 436.4=
71565
> [ =A0504.910935] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.910937] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.910938] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.910939] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.910940] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.910941] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 10.000809
> [ =A0504.910943] =A0 .se->statistics.slice_max =A0 =A0 =A0: 10.009682
> [ =A0504.910944] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 12.419031
> [ =A0504.910945] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 361.57783=
2
> [ =A0504.910946] =A0 .se->statistics.wait_count =A0 =A0 : 2110
> [ =A0504.910948] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 1=
024
> [ =A0504.910949]
> [ =A0504.910950] cfs_rq[0]:/autogroup-97
> [ =A0504.910951] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 81.190946
> [ =A0504.910952] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.910953] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 96.462908
> [ =A0504.910954] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.910956] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.910957] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -332185.190779
> [ =A0504.910958] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 22
> [ =A0504.910959] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0
> [ =A0504.910960] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.910961] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 69.058560
> [ =A0504.910963] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0.067440
> [ =A0504.910964] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0
> [ =A0504.910965] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 0
> [ =A0504.910966] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 504908.418721
> [ =A0504.910967] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 332277.122511
> [ =A0504.910974] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 81.19=
0946
> [ =A0504.910976] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.910977] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.910978] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.910979] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.910980] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.910982] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 9.994761
> [ =A0504.910983] =A0 .se->statistics.slice_max =A0 =A0 =A0: 11.408766
> [ =A0504.910984] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 20.014296
> [ =A0504.910985] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 70.643475
> [ =A0504.910986] =A0 .se->statistics.wait_count =A0 =A0 : 652
> [ =A0504.910988] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 2
> [ =A0504.910989]
> [ =A0504.910990] cfs_rq[0]:/autogroup-47
> [ =A0504.910991] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 5.490044
> [ =A0504.910992] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.910993] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 8.397206
> [ =A0504.910995] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.910996] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.910997] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -332273.256481
> [ =A0504.910998] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 0
> [ =A0504.910999] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0
> [ =A0504.911000] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.911002] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 11.317248
> [ =A0504.911003] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0.011052
> [ =A0504.911004] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 1
> [ =A0504.911005] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 1
> [ =A0504.911007] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 237475.374787
> [ =A0504.911008] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 65372.863188
> [ =A0504.911010] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 5.490=
044
> [ =A0504.911011] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.911012] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.911014] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.911015] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.911016] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.911017] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 4.204008
> [ =A0504.911018] =A0 .se->statistics.slice_max =A0 =A0 =A0: 4.295892
> [ =A0504.911020] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 5.792169
> [ =A0504.911021] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 5.833235
> [ =A0504.911022] =A0 .se->statistics.wait_count =A0 =A0 : 8
> [ =A0504.911023] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 2
> [ =A0504.911025]
> [ =A0504.911025] cfs_rq[0]:/autogroup-77
> [ =A0504.911027] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 4.001773
> [ =A0504.911028] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911029] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 5.193779
> [ =A0504.911030] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911031] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.911033] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -332276.459908
> [ =A0504.911034] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 0
> [ =A0504.911035] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0
> [ =A0504.911036] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.911037] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 57.104384
> [ =A0504.911039] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0.055766
> [ =A0504.911040] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0
> [ =A0504.911041] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 0
> [ =A0504.911042] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 476113.271119
> [ =A0504.911044] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 303489.323396
> [ =A0504.911045] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 4.001=
773
> [ =A0504.911046] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.911048] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.911049] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.911050] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.911051] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.911052] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 0.870429
> [ =A0504.911054] =A0 .se->statistics.slice_max =A0 =A0 =A0: 0.871374
> [ =A0504.911055] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 0.086869
> [ =A0504.911056] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 0.206565
> [ =A0504.911057] =A0 .se->statistics.wait_count =A0 =A0 : 18
> [ =A0504.911064] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 2
> [ =A0504.911067]
> [ =A0504.911067] cfs_rq[0]:/autogroup-94
> [ =A0504.911068] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 377.195414
> [ =A0504.911069] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911071] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 419.366155
> [ =A0504.911072] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911073] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.911074] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -331862.287532
> [ =A0504.911076] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 26
> [ =A0504.911077] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0
> [ =A0504.911078] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.911079] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 65.437184
> [ =A0504.911080] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 5.752241
> [ =A0504.911081] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 2
> [ =A0504.911083] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 2
> [ =A0504.911084] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 231230.096233
> [ =A0504.911086] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 59182.405376
> [ =A0504.911087] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 377.1=
95414
> [ =A0504.911088] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.911089] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.911091] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.911092] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.911093] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.911094] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 10.002204
> [ =A0504.911096] =A0 .se->statistics.slice_max =A0 =A0 =A0: 0.275035
> [ =A0504.911097] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 0.106017
> [ =A0504.911098] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 1.724216
> [ =A0504.911099] =A0 .se->statistics.wait_count =A0 =A0 : 1114
> [ =A0504.911100] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 2
> [ =A0504.911102]
> [ =A0504.911103] cfs_rq[0]:/autogroup-95
> [ =A0504.911104] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 760.249147
> [ =A0504.911105] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911106] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 862.141448
> [ =A0504.911108] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911109] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.911110] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -331419.512239
> [ =A0504.911111] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 126
> [ =A0504.911112] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0
> [ =A0504.911113] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.911115] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 1974.212608
> [ =A0504.911116] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 1.812061
> [ =A0504.911117] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0
> [ =A0504.911118] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 0
> [ =A0504.911120] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 231221.831659
> [ =A0504.911121] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 59175.982390
> [ =A0504.911123] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 760.2=
49147
> [ =A0504.911124] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.911125] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.911126] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.911128] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.911129] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.911130] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 10.001120
> [ =A0504.911131] =A0 .se->statistics.slice_max =A0 =A0 =A0: 2.801075
> [ =A0504.911133] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 6.775995
> [ =A0504.911134] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 56.108541
> [ =A0504.911135] =A0 .se->statistics.wait_count =A0 =A0 : 1394
> [ =A0504.911136] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 2
> [ =A0504.911138]
> [ =A0504.911138] cfs_rq[0]:/autogroup-44
> [ =A0504.911139] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 7.551274
> [ =A0504.911141] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911142] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 6.502698
> [ =A0504.911143] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911144] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.911145] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -332275.150989
> [ =A0504.911147] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 0
> [ =A0504.911148] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0
> [ =A0504.911149] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.911155] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 11.603968
> [ =A0504.911157] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0.011332
> [ =A0504.911158] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0
> [ =A0504.911159] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 0
> [ =A0504.911160] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 504670.285294
> [ =A0504.911161] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 332039.418792
> [ =A0504.911163] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 7.551=
274
> [ =A0504.911164] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.911165] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.911166] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.911168] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.911169] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.911170] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 0.164354
> [ =A0504.911171] =A0 .se->statistics.slice_max =A0 =A0 =A0: 0.031752
> [ =A0504.911172] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 0.012799
> [ =A0504.911174] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 0.012799
> [ =A0504.911175] =A0 .se->statistics.wait_count =A0 =A0 : 498
> [ =A0504.911176] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 2
> [ =A0504.911177]
> [ =A0504.911178] cfs_rq[0]:/autogroup-45
> [ =A0504.911179] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 33.642079
> [ =A0504.911180] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911181] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 2.665989
> [ =A0504.911183] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911184] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.911185] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -332278.987698
> [ =A0504.911186] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 0
> [ =A0504.911187] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0
> [ =A0504.911188] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.911189] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 80.413256
> [ =A0504.911191] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0.008422
> [ =A0504.911192] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0
> [ =A0504.911193] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 0
> [ =A0504.911194] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 504722.413919
> [ =A0504.911196] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 332091.536085
> [ =A0504.911197] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 33.64=
2079
> [ =A0504.911198] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.911199] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.911201] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.911202] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.911203] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.911204] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 1.638176
> [ =A0504.911206] =A0 .se->statistics.slice_max =A0 =A0 =A0: 1.638176
> [ =A0504.911207] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 0.615461
> [ =A0504.911208] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 0.712627
> [ =A0504.911209] =A0 .se->statistics.wait_count =A0 =A0 : 1993
> [ =A0504.911210] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 2
> [ =A0504.911212]
> [ =A0504.911212] cfs_rq[0]:/autogroup-93
> [ =A0504.911213] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 32.063014
> [ =A0504.911215] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911216] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 31.799141
> [ =A0504.911217] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911218] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.911219] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -332249.854546
> [ =A0504.911221] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 0
> [ =A0504.911222] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0
> [ =A0504.911223] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.911224] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 402.524160
> [ =A0504.911225] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 5.541945
> [ =A0504.911226] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0
> [ =A0504.911227] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 0
> [ =A0504.911229] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 504866.521510
> [ =A0504.911230] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 332235.589069
> [ =A0504.911231] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 32.06=
3014
> [ =A0504.911232] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.911234] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.911235] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.911236] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.911243] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.911244] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 2.406006
> [ =A0504.911245] =A0 .se->statistics.slice_max =A0 =A0 =A0: 0.535484
> [ =A0504.911246] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 0.454589
> [ =A0504.911248] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 0.583201
> [ =A0504.911249] =A0 .se->statistics.wait_count =A0 =A0 : 302
> [ =A0504.911250] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 2
> [ =A0504.911252]
> [ =A0504.911253] cfs_rq[0]:/autogroup-26
> [ =A0504.911254] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 25.677149
> [ =A0504.911255] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911256] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 20.872061
> [ =A0504.911258] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911259] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.911260] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -332260.781626
> [ =A0504.911261] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 2
> [ =A0504.911262] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0
> [ =A0504.911263] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.911265] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 25.005056
> [ =A0504.911266] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0.024419
> [ =A0504.911267] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0
> [ =A0504.911268] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 0
> [ =A0504.911270] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 486500.033508
> [ =A0504.911271] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 313872.401958
> [ =A0504.911273] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 25.67=
7149
> [ =A0504.911274] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.911275] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.911276] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.911278] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.911279] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.911280] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 4.001458
> [ =A0504.911281] =A0 .se->statistics.slice_max =A0 =A0 =A0: 4.001458
> [ =A0504.911283] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 23.210683
> [ =A0504.911284] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 73.089978
> [ =A0504.911285] =A0 .se->statistics.wait_count =A0 =A0 : 190
> [ =A0504.911286] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 2
> [ =A0504.911288]
> [ =A0504.911288] cfs_rq[0]:/autogroup-22
> [ =A0504.911290] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 527.961931
> [ =A0504.911291] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911292] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 151.311694
> [ =A0504.911294] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911295] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.911296] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -332130.341993
> [ =A0504.911297] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 121
> [ =A0504.911298] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0
> [ =A0504.911299] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.911301] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 1111.549442
> [ =A0504.911302] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0.532895
> [ =A0504.911303] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0
> [ =A0504.911304] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 0
> [ =A0504.911306] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 356684.107482
> [ =A0504.911307] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 184169.472319
> [ =A0504.911308] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 527.9=
61931
> [ =A0504.911310] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.911311] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.911312] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.911313] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.911314] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.911316] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 13.423428
> [ =A0504.911317] =A0 .se->statistics.slice_max =A0 =A0 =A0: 13.444230
> [ =A0504.911318] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 31.119278
> [ =A0504.911319] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 1280.6045=
18
> [ =A0504.911321] =A0 .se->statistics.wait_count =A0 =A0 : 3048
> [ =A0504.911322] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 2
> [ =A0504.911324]
> [ =A0504.911324] cfs_rq[0]:/autogroup-81
> [ =A0504.911325] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 12.556567
> [ =A0504.911327] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911328] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 12.143997
> [ =A0504.911335] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0.000001
> [ =A0504.911336] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.911337] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : -332269.509690
> [ =A0504.911338] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 0
> [ =A0504.911339] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 0
> [ =A0504.911340] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 0
> [ =A0504.911342] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 797.444800
> [ =A0504.911343] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 5.529441
> [ =A0504.911344] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 144
> [ =A0504.911345] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 144
> [ =A0504.911347] =A0 .se->exec_start =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 176690.782872
> [ =A0504.911348] =A0 .se->vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 4768.148996
> [ =A0504.911349] =A0 .se->sum_exec_runtime =A0 =A0 =A0 =A0 =A0: 12.55=
6567
> [ =A0504.911351] =A0 .se->statistics.wait_start =A0 =A0 : 0.000000
> [ =A0504.911352] =A0 .se->statistics.sleep_start =A0 =A0: 0.000000
> [ =A0504.911353] =A0 .se->statistics.block_start =A0 =A0: 0.000000
> [ =A0504.911354] =A0 .se->statistics.sleep_max =A0 =A0 =A0: 0.000000
> [ =A0504.911356] =A0 .se->statistics.block_max =A0 =A0 =A0: 0.000000
> [ =A0504.911357] =A0 .se->statistics.exec_max =A0 =A0 =A0 : 2.983240
> [ =A0504.911358] =A0 .se->statistics.slice_max =A0 =A0 =A0: 2.983240
> [ =A0504.911359] =A0 .se->statistics.wait_max =A0 =A0 =A0 : 7.305608
> [ =A0504.911361] =A0 .se->statistics.wait_sum =A0 =A0 =A0 : 15.575225
> [ =A0504.911362] =A0 .se->statistics.wait_count =A0 =A0 : 30
> [ =A0504.911363] =A0 .se->load.weight =A0 =A0 =A0 =A0 =A0 =A0 =A0 : 2
> [ =A0504.911364]
> [ =A0504.911365] cfs_rq[0]:/autogroup-0
> [ =A0504.911366] =A0 .exec_clock =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 335096.149477
> [ =A0504.911367] =A0 .MIN_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 332281.653687
> [ =A0504.911369] =A0 .min_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 332281.653687
> [ =A0504.911370] =A0 .max_vruntime =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 332281.653687
> [ =A0504.911371] =A0 .spread =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0: 0.000000
> [ =A0504.911372] =A0 .spread0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 0.000000
> [ =A0504.911374] =A0 .nr_spread_over =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0:=
 103
> [ =A0504.911375] =A0 .nr_running =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0: 2
> [ =A0504.911376] =A0 .load =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0: 2048
> [ =A0504.911377] =A0 .load_avg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0: 0.000000
> [ =A0504.911378] =A0 .load_period =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 : 0.000000
> [ =A0504.911379] =A0 .load_contrib =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
: 0
> [ =A0504.911380] =A0 .load_tg =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 : 0
> [ =A0504.911382]
> [ =A0504.911382] runnable tasks:
> [ =A0504.911383] =A0 =A0 =A0 =A0 =A0 =A0 task =A0 PID =A0 =A0 =A0 =A0=
 tree-key =A0switches =A0prio
> =A0 =A0exec-runtime =A0 =A0 =A0 =A0 sum-exec =A0 =A0 =A0 =A0sum-sleep
> [ =A0504.911384] ----------------------------------------------------=
------------------------------------------------------
> [ =A0504.911389] =A0 =A0 md1123_raid5 =A01310 =A0 =A0332281.653687 =A0=
 =A0 =A08767 =A0 120
> =A0 332281.653687 =A0 =A0327572.546291 =A0 =A0 =A05960.052537 /autogr=
oup-0
> [ =A0504.911394] R =A0 =A0 =A0 =A0 =A0 bash =A01390 =A0 =A0 =A0 473.2=
90911 =A0 =A0 =A01098 =A0 120
> =A0 =A0 =A0473.290911 =A0 =A0 =A0 226.301682 =A0 =A0267038.335128 /au=
togroup-98
> [ =A0504.911398]
>
> Thanks,
> =A0Alex.
>
>
>
>
> On Tue, Jun 28, 2011 at 5:29 AM, NeilBrown <neilb@suse.de> wrote:
>> On Sun, 26 Jun 2011 21:13:17 +0300 Alexander Lyakas <alex.bolshoy@gm=
ail.com>
>> wrote:
>>
>>> Hello Neil,
>>> thank you for your response. Meanwhile I have moved to stock ubuntu
>>> natty 11.04, but it still happens. I have a simple script that
>>> reproduces the issue for me in less than 1 minute.
>>> System details:
>>> Linux ubuntu 2.6.38-8-server #42-Ubuntu SMP Mon Apr 11 03:49:04 UTC
>>> 2011 x86_64 x86_64 x86_64 GNU/Linux
>>>
>>> Here is the script:
>>> ##################################
>>> #!/bin/bash
>>>
>>> while true
>>> do
>>> =A0 =A0 =A0 mdadm --create /dev/md1123 --raid-devices=3D3 --level=3D=
5
>>> --bitmap=3Dinternal --name=3D1123 --run --auto=3Dmd --metadata=3D1.=
2
>>> --homehost=3Dalex --verbose /dev/sda /dev/sdb /dev/sdc
>>> =A0 =A0 =A0 sleep 6
>>> =A0 =A0 =A0 mdadm --manage /dev/md1123 --fail /dev/sda
>>> =A0 =A0 =A0 sleep 1
>>> =A0 =A0 =A0 if mdadm --stop /dev/md1123
>>> =A0 =A0 =A0 then
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 true
>>> =A0 =A0 =A0 else
>>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 break
>>> =A0 =A0 =A0 fi
>>> done
>>> #####################################
>>
>> Thanks for the script. =A0Unfortunately I still cannot reproduce.
>> I suspect there is some subtle race issue that is heavily dependant =
on the
>> particular hardware you have.
>>
>> It might help if I could get stack traces of the relevant processes.=
 i.e.
>> md1123_raid5 and md1123_resync.
>>
>> A previous post contained a trace of _resync, but it wouldn't hurt t=
o get
>> another one. =A0You can get them by
>>
>> =A0cat /proc/PROCESS-ID/stack
>>
>> or possibly
>>
>> =A0echo w > /proc/sysrq-trigger
>>
>> then look in the output of 'dmesg'.
>>
>> Thanks,
>> NeilBrown
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

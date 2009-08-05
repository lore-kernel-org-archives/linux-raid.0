From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: 2.6.31-rc5-git2 crash on a idle system.
Date: Wed, 05 Aug 2009 19:52:14 +1000
Message-ID: <1249465934.18245.54.camel@pasglop>
References: <4A78292A.5000607@in.ibm.com>
	 <1249421223.18245.36.camel@pasglop>  <4A794E26.8080207@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A794E26.8080207@in.ibm.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sachin Sant <sachinp@in.ibm.com>
Cc: linuxppc-dev@ozlabs.org, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 2.6.31-rc5-git1 (4905f92ed752d49ebe9cce4fe78a4bc39e710523) works fine
> on this box without any problem. So the problem was introduced between
> 2.6.31-rc5-git1 (4905f92ed752d49ebe9cce4fe78a4bc39e710523) and
> 2.6.31-rc5-git2 (a33a052f19a21d727847391c8c1aff3fb221c472).
> 
> Looking at the changelog all the changes are confined to
> drivers/md/ directory ( probably following five commits ). I do have
> all the CONFIG_MD* options enabled in my kernel.
> 
> 449aad3e25358812c43afc60918c5ad3819488e7
> 70471dafe3390243c598a3165dfb86b8b8b3f4fe
> 3673f305faf1bc66ead751344f8262ace851ff44
> 3a981b03f38dc3b8a69b77cbc679e66c1318a44a
> ac5e7113e74872928844d00085bd47c988f12728
> 
> I will try to find out the exact commit.

Thanks. Since it's a memory corruption (or seems to be) however, it's
possible that the bisection will mislead you. IE. The culprit could be
somewhere else, and the commit you'll find via bisection just happens to
move things around in the kernel in such a way that the corruption hits
that code path instead of another rarely used one.

I would suggest using printk to print out the content of memory where
the code appears to have been smashed at different stages during boot
(maybe even in the initcalls loop in init/main.c) to try to point out
what appears to be causing the corruption.

Cheers,
Ben.

> Thanks
> -Sachin
> 
> 
> plain text document attachment (rc5-git2-log)
> [root@mjs22lp1 home]# cpu 0x0: Vector: 700 (Program Check) at [c00000000ffffa90]
>     pc: c000000000600000: .flow_cache_new_hashrnd+0x3c/0xcc
>     lr: c0000000000c6038: .run_timer_softirq+0x20c/0x2f4
>     sp: c00000000ffffd10
>    msr: 8000000000089032
>   current = 0xc000000000f58b70
>   paca    = 0xc0000000010b2400
>     pid   = 0, comm = swapper
> enter ? for help
> [c00000000ffffda0] c0000000000c6038 .run_timer_softirq+0x20c/0x2f4
> [c00000000ffffea0] c0000000000be8a0 .__do_softirq+0x174/0x2c8
> [c00000000fffff90] c0000000000307b0 .call_do_softirq+0x14/0x24
> [c000000001013870] c00000000000ecf8 .do_softirq+0xa0/0x104
> [c000000001013910] c0000000000be1d0 .irq_exit+0x74/0xd4
> [c000000001013990] c00000000002ce20 .timer_interrupt+0x1cc/0x200
> [c000000001013a30] c000000000003728 decrementer_common+0x128/0x180
> --- Exception: 901 (Decrementer) at c00000000000ec3c .raw_local_irq_restore+0xc0/0xdc
> [c000000001013dc0] c000000000015824 .cpu_idle+0x13c/0x1e0
> [c000000001013e60] c000000000009fe8 .rest_init+0x94/0xcc
> [c000000001013ee0] c000000000990cf4 .start_kernel+0x484/0x4a8
> [c000000001013f90] c000000000008408 .start_here_common+0x2c/0xa4
> 0:mon> e
> cpu 0x0: Vector: 700 (Program Check) at [c00000000ffffa90]
>     pc: c000000000600000: .flow_cache_new_hashrnd+0x3c/0xcc
>     lr: c0000000000c6038: .run_timer_softirq+0x20c/0x2f4
>     sp: c00000000ffffd10
>    msr: 8000000000089032
>   current = 0xc000000000f58b70
>   paca    = 0xc0000000010b2400
>     pid   = 0, comm = swapper
> 0:mon> di c000000000600000 
> c000000000600000  00001010      .long 0x1010
> c000000000600004  00000008      .long 0x8
> c000000000600008  00001013      .long 0x1013
> c00000000060000c  0000000f      .long 0xf
> c000000000600010  7961626f      rldimi. r1,r11,44,41
> c000000000600014  6f740000      xoris   r20,r27,0
> c000000000600018  00101600      .long 0x101600
> c00000000060001c  00000c00      .long 0xc00
> c000000000600020  00000400      .long 0x400
> c000000000600024  00101100      .long 0x101100
> c000000000600028  000008e9      .long 0x8e9
> c00000000060002c  60000000      nop
> c000000000600030  e93e8050      ld      r9,-32688(r30)
> c000000000600034  7c6507b4      extsw   r5,r3
> c000000000600038  78ab4da4      rldicr  r11,r5,9,54
> c00000000060003c  396b0040      addi    r11,r11,64
> 0:mon> r
> R00 = c0000000000c6038   R16 = 0000000000000000
> R01 = c00000000ffffd10   R17 = 0000000000000100
> R02 = c000000001011110   R18 = c000000001059300
> R03 = 0000000000000000   R19 = c000000001102f98
> R04 = c00000000ffffd60   R20 = c000000001103398
> R05 = ffffffffffffffff   R21 = c000000001103798
> R06 = 0000000000000700   R22 = c000000001103b98
> R07 = 0000000000000001   R23 = 0000000000000000
> R08 = 0000000000830000   R24 = c00000000fffc000
> R09 = c00000000072f890   R25 = 0000000000000000
> R10 = c00000000120fbf8   R26 = 0000000000200200
> R11 = c000000000600090   R27 = c00000000ffffe10
> R12 = 0000000028000022   R28 = 0000000000000001
> R13 = c0000000010b2400   R29 = c0000000010805e8
> R14 = 0000000000382800   R30 = c000000000fb4f78
> R15 = 0000000000000000   R31 = c00000000ffffd10
> pc  = c000000000600000 .flow_cache_new_hashrnd+0x3c/0xcc
> lr  = c0000000000c6038 .run_timer_softirq+0x20c/0x2f4
> msr = 8000000000089032   cr  = 28000024
> ctr = c0000000005fffc4   xer = 0000000000000000   trap =  700
> 0:mon> dl
> <6>Phyp-dump disabled at boot time
> <6>Using pSeries machine description
> <7>Page orders: linear mapping = 24, virtual = 16, io = 12, vmemmap = 24
> <6>Using 1TB segments
> <4>Found initrd at 0xc000000002000000:0xc000000002382800
> <6>console [udbg0] enabled
> <6>Partition configured for 8 cpus.
> <6>CPU maps initialized for 2 threads per core
> <7> (thread shift is 1)
> <4>Starting Linux PPC64 #1 SMP Tue Aug 4 12:15:55 IST 2009
> <4>-----------------------------------------------------
> <4>ppc64_pft_size                = 0x1a
> <4>physicalMemorySize            = 0xa0000000
> <4>htab_hash_mask                = 0x7ffff
> <4>-----------------------------------------------------
> <6>Initializing cgroup subsys cpuset
> <6>Initializing cgroup subsys cpu
> <5>Linux version 2.6.31-rc5-git2 (root@mjs22lp1) (gcc version 4.4.0 20090307 (Red Hat 4.4.0-0.23) (GCC) ) #1 SMP Tue Aug 4 12:15:55 IST 2009
> <4>[boot]0012 Setup Arch
> <7>Node 0 Memory: 0x0-0x54000000
> <7>Node 1 Memory: 0x54000000-0xa0000000
> <4>EEH: No capable adapters found
> <6>PPC64 nvram contains 15360 bytes
> <7>Using shared processor idle loop
> <4>Zone PFN ranges:
> <4>  DMA      0x00000000 -> 0x0000a000
> <4>  Normal   0x0000a000 -> 0x0000a000
> <4>Movable zone start PFN for each node
> <4>early_node_map[2] active PFN ranges
> <4>    0: 0x00000000 -> 0x00005400
> <4>    1: 0x00005400 -> 0x0000a000
> <7>On node 0 totalpages: 21504
> <7>  DMA zone: 19 pages used for memmap
> <7>  DMA zone: 0 pages reserved
> <7>  DMA zone: 21485 pages, LIFO batch:1
> <7>On node 1 totalpages: 19456
> <7>  DMA zone: 17 pages used for memmap
> <7>  DMA zone: 0 pages reserved
> <7>  DMA zone: 19439 pages, LIFO batch:1
> <4>[boot]0015 Setup Done
> <4>Built 2 zonelists in Node order, mobility grouping on.  Total pages: 40924
> <4>Policy zone: DMA
> <5>Kernel command line: ro console=hvc0 root=UUID=9448b379-7842-486c-8bc8-22a1427c4462 
> <4>PID hash table entries: 4096 (order: 12, 32768 bytes)
> <4>freeing bootmem node 0
> <4>freeing bootmem node 1
> <6>Memory: 2570560k/2621440k available (15296k kernel code, 50880k reserved, 1152k data, 1488k bss, 5504k init)
> <6>SLUB: Genslabs=18, HWalign=128, Order=0-3, MinObjects=0, CPUs=8, Nodes=16
> <6>Hierarchical RCU implementation.
> <6>NR_IRQS:512
> <4>[boot]0020 XICS Init
> <4>[boot]0021 XICS Done
> <7>pic: no ISA interrupt controller
> <7>time_init: decrementer frequency = 512.000000 MHz
> <7>time_init: processor frequency   = 4005.000000 MHz
> <6>clocksource: timebase mult[7d0000] shift[22] registered
> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[0]
> <4>Console: colour dummy device 80x25
> <6>console handover: boot [udbg0] -> real [hvc0]
> <6>allocated 1638400 bytes of page_cgroup
> <6>please try 'cgroup_disable=memory' option if you don't want memory cgroups
> <6>Security Framework initialized
> <6>SELinux:  Initializing.
> <7>SELinux:  Starting in permissive mode
> <6>Dentry cache hash table entries: 524288 (order: 6, 4194304 bytes)
> <6>Inode-cache hash table entries: 262144 (order: 5, 2097152 bytes)
> <4>Mount-cache hash table entries: 4096
> <6>Initializing cgroup subsys ns
> <6>Initializing cgroup subsys cpuacct
> <6>Initializing cgroup subsys memory
> <6>Initializing cgroup subsys devices
> <6>Initializing cgroup subsys freezer
> <6>Initializing cgroup subsys net_cls
> <6>ftrace: allocating 19543 entries in 8 pages
> <7>irq: irq 2 on host null mapped to virtual irq 16
> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[1]
> <4>Processor 1 found.
> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[2]
> <4>Processor 2 found.
> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[3]
> <4>Processor 3 found.
> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[4]
> <4>Processor 4 found.
> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[5]
> <4>Processor 5 found.
> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[6]
> <4>Processor 6 found.
> <7>clockevent: decrementer mult[83126e97] shift[32] cpu[7]
> <4>Processor 7 found.
> <6>Brought up 8 CPUs
> <7>Node 0 CPUs: 0-7
> <7>Node 1 CPUs:
> <7>CPU0 attaching sched-domain:
> <7> domain 0: span 0-1 level SIBLING
> <7>  groups: 0 1
> <7>  domain 1: span 0-7 level CPU
> <7>   groups: 0-1 2-3 4-5 6-7
> <7>   domain 2: span 0-7 level NODE
> <7>    groups: 0-7 (__cpu_power = 4096)
> <7>CPU1 attaching sched-domain:
> <7> domain 0: span 0-1 level SIBLING
> <7>  groups: 1 0
> <7>  domain 1: span 0-7 level CPU
> <7>   groups: 0-1 2-3 4-5 6-7
> <7>   domain 2: span 0-7 level NODE
> <7>    groups: 0-7 (__cpu_power = 4096)
> <7>CPU2 attaching sched-domain:
> <7> domain 0: span 2-3 level SIBLING
> <7>  groups: 2 3
> <7>  domain 1: span 0-7 level CPU
> <7>   groups: 2-3 4-5 6-7 0-1
> <7>   domain 2: span 0-7 level NODE
> <7>    groups: 0-7 (__cpu_power = 4096)
> <7>CPU3 attaching sched-domain:
> <7> domain 0: span 2-3 level SIBLING
> <7>  groups: 3 2
> <7>  domain 1: span 0-7 level CPU
> <7>   groups: 2-3 4-5 6-7 0-1
> <7>   domain 2: span 0-7 level NODE
> <7>    groups: 0-7 (__cpu_power = 4096)
> <7>CPU4 attaching sched-domain:
> <7> domain 0: span 4-5 level SIBLING
> <7>  groups: 4 5
> <7>  domain 1: span 0-7 level CPU
> <7>   groups: 4-5 6-7 0-1 2-3
> <7>   domain 2: span 0-7 level NODE
> <7>    groups: 0-7 (__cpu_power = 4096)
> <7>CPU5 attaching sched-domain:
> <7> domain 0: span 4-5 level SIBLING
> <7>  groups: 5 4
> <7>  domain 1: span 0-7 level CPU
> <7>   groups: 4-5 6-7 0-1 2-3
> <7>   domain 2: span 0-7 level NODE
> <7>    groups: 0-7 (__cpu_power = 4096)
> <7>CPU6 attaching sched-domain:
> <7> domain 0: span 6-7 level SIBLING
> <7>  groups: 6 7
> <7>  domain 1: span 0-7 level CPU
> <7>   groups: 6-7 0-1 2-3 4-5
> <7>   domain 2: span 0-7 level NODE
> <7>    groups: 0-7 (__cpu_power = 4096)
> <7>CPU7 attaching sched-domain:
> <7> domain 0: span 6-7 level SIBLING
> <7>  groups: 7 6
> <7>  domain 1: span 0-7 level CPU
> <7>   groups: 6-7 0-1 2-3 4-5
> <7>   domain 2: span 0-7 level NODE
> <7>    groups: 0-7 (__cpu_power = 4096)
> <6>regulator: core version 0.5
> <6>NET: Registered protocol family 16
> <6>IBM eBus Device Driver
> <6>POWER6 performance monitor hardware support registered
> <6>PCI: Probing PCI hardware
> <7>PCI: Probing PCI hardware done
> <4>bio: create slab <bio-0> at 0
> <5>SCSI subsystem initialized
> <7>libata version 3.00 loaded.
> <6>usbcore: registered new interface driver usbfs
> <6>usbcore: registered new interface driver hub
> <6>usbcore: registered new device driver usb
> <6>NetLabel: Initializing
> <6>NetLabel:  domain hash size = 128
> <6>NetLabel:  protocols = UNLABELED CIPSOv4
> <6>NetLabel:  unlabeled traffic allowed by default
> <7>Switched to high resolution mode on CPU 0
> <7>Switched to high resolution mode on CPU 3
> <7>Switched to high resolution mode on CPU 4
> <7>Switched to high resolution mode on CPU 5
> <7>Switched to high resolution mode on CPU 1
> <7>Switched to high resolution mode on CPU 6
> <7>Switched to high resolution mode on CPU 2
> <7>Switched to high resolution mode on CPU 7
> <6>NET: Registered protocol family 2
> <6>IP route cache hash table entries: 32768 (order: 2, 262144 bytes)
> <6>TCP established hash table entries: 131072 (order: 5, 2097152 bytes)
> <6>TCP bind hash table entries: 65536 (order: 4, 1048576 bytes)
> <6>TCP: Hash tables configured (established 131072 bind 65536)
> <6>TCP reno registered
> <6>NET: Registered protocol family 1
> <6>Trying to unpack rootfs image as initramfs...
> <4>Freeing initrd memory: 3594k freed
> <7>irq: irq 655360 on host null mapped to virtual irq 17
> <7>irq: irq 655362 on host null mapped to virtual irq 18
> <6>IOMMU table initialized, virtual merging enabled
> <7>irq: irq 655364 on host null mapped to virtual irq 19
> <7>irq: irq 655365 on host null mapped to virtual irq 20
> <7>irq: irq 589825 on host null mapped to virtual irq 21
> <7>RTAS daemon started
> <7>RTAS: event: 23, Type: Platform Information Event, Severity: 1
> <6>audit: initializing netlink socket (disabled)
> <5>type=2000 audit(1249386596.125:1): initialized
> <6>HugeTLB registered 16 MB page size, pre-allocated 0 pages
> <6>HugeTLB registered 16 GB page size, pre-allocated 0 pages
> <5>VFS: Disk quotas dquot_6.5.2
> <4>Dquot-cache hash table entries: 8192 (order 0, 65536 bytes)
> <6>msgmni has been set to 5024
> <7>SELinux:  Registering netfilter hooks
> <6>alg: No test for stdrng (krng)
> <6>Block layer SCSI generic (bsg) driver version 0.4 loaded (major 252)
> <6>io scheduler noop registered
> <6>io scheduler anticipatory registered
> <6>io scheduler deadline registered
> <6>io scheduler cfq registered (default)
> <6>pci_hotplug: PCI Hot Plug PCI Core version: 0.5
> <6>pciehp: PCI Express Hot Plug Controller Driver version: 0.4
> <7>vio_register_driver: driver hvc_console registering
> <7>HVSI: registered 0 devices
> <6>Linux agpgart interface v0.103
> <6>Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
> <4>Platform driver 'serial8250' needs updating - please use dev_pm_ops
> <6>TX39/49 Serial driver version 1.11
> <4>Platform driver 'serial_txx9' needs updating - please use dev_pm_ops
> <6>brd: module loaded
> <6>loop: module loaded
> <6>input: Macintosh mouse button emulation as /devices/virtual/input/input0
> <6>Uniform Multi-Platform E-IDE driver
> <6>ide-gd driver 1.18
> <6>Fixed MDIO Bus: probed
> <6>ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
> <6>ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
> <6>uhci_hcd: USB Universal Host Controller Interface driver
> <6>mice: PS/2 mouse device common for all mice
> <6>device-mapper: uevent: version 1.0.3
> <6>device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
> <6>usbcore: registered new interface driver hiddev
> <6>usbcore: registered new interface driver usbhid
> <6>usbhid: v2.6:USB HID core driver
> <4>nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
> <4>CONFIG_NF_CT_ACCT is deprecated and will be removed soon. Please use
> <4>nf_conntrack.acct=1 kernel parameter, acct=1 nf_conntrack module option or
> <4>sysctl net.netfilter.nf_conntrack_acct=1 to enable it.
> <6>ip_tables: (C) 2000-2006 Netfilter Core Team
> <6>TCP cubic registered
> <6>Initializing XFRM netlink socket
> <6>NET: Registered protocol family 17
> <7>Running MSI bitmap self-tests ...
> <7>PM: Resume from disk failed.
> <4>registered taskstats version 1
> <6>Initalizing network drop monitor service
> <4>Freeing unused kernel memory: 5504k freed
> <7>vio_register_driver: driver ibmvscsi registering
> <6>ibmvscsi 30000002: SRP_VERSION: 16.a
> <6>scsi0 : IBM POWER Virtual SCSI Adapter 1.5.8
> <6>ibmvscsi 30000002: partner initialization complete
> <6>ibmvscsi 30000002: host srp version: 16.a, host partition 06-1C12A (1), OS 3, max io 262144
> <6>ibmvscsi 30000002: Client reserve enabled
> <6>ibmvscsi 30000002: sent SRP login
> <6>ibmvscsi 30000002: SRP_LOGIN succeeded
> <5>scsi 0:0:1:0: Direct-Access     AIX      VDASD            0001 PQ: 0 ANSI: 3
> <5>scsi 0:0:2:0: CD-ROM            AIX      VOPTA                 PQ: 0 ANSI: 4
> <6>scsi: waiting for bus probes to complete ...
> <5>sd 0:0:1:0: Attached scsi generic sg0 type 0
> <5>sd 0:0:1:0: [sda] 147324928 512-byte logical blocks: (75.4 GB/70.2 GiB)
> <5>sd 0:0:1:0: [sda] Write Protect is off
> <7>sd 0:0:1:0: [sda] Mode Sense: 17 00 00 08
> <5>sd 0:0:1:0: [sda] Cache data unavailable
> <3>sd 0:0:1:0: [sda] Assuming drive cache: write through
> <4>sr0: scsi-1 drive
> <6>Uniform CD-ROM driver Revision: 3.20
> <7>sr 0:0:2:0: Attached scsi CD-ROM sr0
> <5>sr 0:0:2:0: Attached scsi generic sg1 type 5
> <5>sd 0:0:1:0: [sda] Cache data unavailable
> <3>sd 0:0:1:0: [sda] Assuming drive cache: write through
> <6> sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 >
> <5>sd 0:0:1:0: [sda] Cache data unavailable
> <3>sd 0:0:1:0: [sda] Assuming drive cache: write through
> <5>sd 0:0:1:0: [sda] Attached SCSI disk
> <6>EXT4-fs (sda3): INFO: recovery required on readonly filesystem
> <6>EXT4-fs (sda3): write access will be enabled during recovery
> <6>EXT4-fs (sda3): barriers enabled
> <6>kjournald2 starting: pid 126, dev sda3:8, commit interval 5 seconds
> <6>EXT4-fs (sda3): delayed allocation enabled
> <6>EXT4-fs: file extents enabled
> <6>EXT4-fs: mballoc enabled
> <6>EXT4-fs (sda3): recovery complete
> <6>EXT4-fs (sda3): mounted filesystem with ordered data mode
> <5>type=1404 audit(1249386597.188:2): enforcing=1 old_enforcing=0 auid=4294967295 ses=4294967295
> <7>SELinux: 8192 avtab hash slots, 117789 rules.
> <7>SELinux: 8192 avtab hash slots, 117789 rules.
> <7>SELinux:  8 users, 13 roles, 2653 types, 121 bools, 1 sens, 1024 cats
> <7>SELinux:  74 classes, 117789 rules
> <7>SELinux:  Completing initialization.
> <7>SELinux:  Setting up existing superblocks.
> <7>SELinux: initialized (dev sda3, type ext4), uses xattr
> <7>SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> <7>SELinux: initialized (dev selinuxfs, type selinuxfs), uses genfs_contexts
> <7>SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
> <7>SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses genfs_contexts
> <7>SELinux: initialized (dev devpts, type devpts), uses transition SIDs
> <7>SELinux: initialized (dev inotifyfs, type inotifyfs), uses genfs_contexts
> <7>SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> <7>SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses genfs_contexts
> <7>SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
> <7>SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
> <7>SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
> <7>SELinux: initialized (dev proc, type proc), uses genfs_contexts
> <7>SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
> <7>SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
> <7>SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
> <5>type=1403 audit(1249386597.481:3): policy loaded auid=4294967295 ses=4294967295
> <6>udev: starting version 141
> <7>drivers/net/ibmveth.c: ibmveth: IBM i/pSeries Virtual Ethernet Driver 1.03
> <7>vio_register_driver: driver ibmveth registering
> <6>IBM eHEA ethernet device driver (Release EHEA_0101)
> <7>irq: irq 590080 on host null mapped to virtual irq 256
> <6>ehea: eth0: Jumbo frames are enabled
> <6>ehea: eth0 -> logical port id #3
> <6>ehea: eth2: Jumbo frames are enabled
> <6>ehea: eth2 -> logical port id #4
> <6>udev: renamed network interface eth1 to eth3
> <6>udev: renamed network interface eth0_rename to eth1
> <6>device-mapper: multipath: version 1.1.0 loaded
> <6>EXT4-fs (sda3): internal journal on sda3:8
> <6>kjournald starting.  Commit interval 5 seconds
> <6>EXT3 FS on sda2, internal journal
> <6>EXT3-fs: mounted filesystem with writeback data mode.
> <7>SELinux: initialized (dev sda2, type ext3), uses xattr
> <7>SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
> <7>SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses genfs_contexts
> <6>NET: Registered protocol family 10
> <6>lo: Disabled Privacy Extensions
> <6>RPC: Registered udp transport module.
> <6>RPC: Registered tcp transport module.
> <7>SELinux: initialized (dev rpc_pipefs, type rpc_pipefs), uses genfs_contexts
> <7>irq: irq 779 on host null mapped to virtual irq 267
> <6>ehea: eth2: Physical port up
> <6>ehea: External switch port is backup port
> <7>irq: irq 780 on host null mapped to virtual irq 268
> <7>irq: irq 781 on host null mapped to virtual irq 269
> <6>ehea: eth0: Physical port up
> <6>ehea: External switch port is backup port
> <7>irq: irq 782 on host null mapped to virtual irq 270
> <6>Bluetooth: Core ver 2.15
> <6>NET: Registered protocol family 31
> <6>Bluetooth: HCI device and connection manager initialized
> <6>Bluetooth: HCI socket layer initialized
> <6>Bluetooth: L2CAP ver 2.13
> <6>Bluetooth: L2CAP socket layer initialized
> <6>Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> <6>Bluetooth: BNEP filters: protocol multicast
> <6>Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
> <7>SELinux: initialized (dev nfsd, type nfsd), uses genfs_contexts
> <4>NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
> <6>NFSD: starting 90-second grace period
> <5>Bridge firewalling registered
> <6>Bluetooth: SCO (Voice Link) ver 0.6
> <6>Bluetooth: SCO socket layer initialized
> <6>virbr0: starting userspace STP failed, starting kernel STP
> <7>SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
> <7>SELinux: initialized (dev proc, type proc), uses genfs_contexts
> <7>SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
> <6>lo: Disabled Privacy Extensions
> <7>SELinux: initialized (dev proc, type proc), uses genfs_contexts
> <7>eth0: no IPv6 routers present
> <7>eth2: no IPv6 routers present
> <7>eth1: no IPv6 routers present
> <7>eth3: no IPv6 routers present
> <7>virbr0: no IPv6 routers present
> 0:mon> 
> 


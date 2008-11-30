From: Tom Walsh <tom@openhardware.net>
Subject: Re: array always resyncs on boot
Date: Sat, 29 Nov 2008 20:07:41 -0500
Message-ID: <4931E75D.5080905@openhardware.net>
References: <4931B2C5.5060403@openhardware.net> <alpine.DEB.1.10.0811291633140.1796@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811291633140.1796@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> 

>> I just cannot keep the system from resyncing on every boot.  I've
>> gotten to the point that I'm thinking that I may have been root'ed and
>> the boot flash of the drives has been reflashed...  Ok, that is
>> reaching for an answer, I know.  This is time to ask for help.  help!
> 
> If you boot knoppix and manually assemble the array does it assemble 
> cleanly
> or does it need a resync as well?
> 

Well, I used my last CD-R on the WD Data Lifeguard.  But, I think I know 
what you are driving at.  Booting Mandriva 2009 into Rescue mode, then 
choosing "Mount your partitions under mnt" does cleanly start the array.

Following that further, I booted off /dev/sda1 (where my small Mandriva 
system is currently installed), then I disabled the mdadm service in 
/etc/init.d/.  I then waited for the system to do the resync and 
rebooted the system. Then logged into the system.

At this point, I have had a message from dmesg stating that the raid 
array is resync-ing.  This is mdadm -D --scan from before and after 
reboot, and shows before and after mdstat:

=================================================================
/dev/md0:
         Version : 00.90
   Creation Time : Sat Nov 29 09:34:45 2008
      Raid Level : raid10
      Array Size : 62942208 (60.03 GiB 64.45 GB)
   Used Dev Size : 20980736 (20.01 GiB 21.48 GB)
    Raid Devices : 6
   Total Devices : 6
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sat Nov 29 19:45:43 2008
           State : clean
  Active Devices : 6
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 0

          Layout : near=2, far=1
      Chunk Size : 64K

            UUID : cc05dcc8:b5192714:033ef1ee:62f617b8
          Events : 0.42

     Number   Major   Minor   RaidDevice State
        0       8        5        0      active sync   /dev/sda5
        1       8       21        1      active sync   /dev/sdb5
        2       8       37        2      active sync   /dev/sdc5
        3       8       53        3      active sync   /dev/sdd5
        4       8       69        4      active sync   /dev/sde5
        5       8       85        5      active sync   /dev/sdf5
/dev/md0:
         Version : 00.90
   Creation Time : Sat Nov 29 09:34:45 2008
      Raid Level : raid10
      Array Size : 62942208 (60.03 GiB 64.45 GB)
   Used Dev Size : 20980736 (20.01 GiB 21.48 GB)
    Raid Devices : 6
   Total Devices : 6
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sat Nov 29 19:47:03 2008
           State : clean, degraded, recovering
  Active Devices : 5
Working Devices : 6
  Failed Devices : 0
   Spare Devices : 1

          Layout : near=2, far=1
      Chunk Size : 64K

  Rebuild Status : 4% complete

            UUID : cc05dcc8:b5192714:033ef1ee:62f617b8
          Events : 0.44

     Number   Major   Minor   RaidDevice State
        0       8        5        0      active sync   /dev/sda5
        1       8       21        1      active sync   /dev/sdb5
        2       8       37        2      active sync   /dev/sdc5
        6       8       53        3      spare rebuilding   /dev/sdd5
        4       8       69        4      active sync   /dev/sde5
        5       8       85        5      active sync   /dev/sdf5


Personalities : [raid10]
md0 : active raid10 sdd5[6] sdc5[2] sda5[0] sdb5[1] sde5[4] sdf5[5]
       62942208 blocks 64K chunks 2 near-copies [6/5] [UUU_UU]
       [===============>.....]  recovery = 76.2% (15994624/20980736) 
finish=1.4min speed=56416K/sec

unused devices: <none>


Personalities : [raid10]
md0 : active raid10 sdd5[3] sdc5[2] sda5[0] sdb5[1] sde5[4] sdf5[5]
       62942208 blocks 64K chunks 2 near-copies [6/6] [UUUUUU]

unused devices: <none>
=================================================================




> Also:
>> mdadm -Eb /dev/sda5 >> /etc/mdadm
>> blkid /dev/md0 >> /etc/fstab
> 
> I never use these commands?
> 
> I take the output of:
> # mdadm --examine --scan
> 
> And add it to /etc/mdadm/mdadm.conf.
> 
> And then add /dev/md0 /mnt xfs etc into /etc/fstab.

Right, same result, differing approach.  mdadm -Eb <device> will also 
give the UUID in a brief string.

> 
> In addition I don't use a > 0.90 superblock (not saying thats the 
> problem but just noting a difference)
> 
> mdadm --create /dev/md3 -e 0.90 --assume-clean --level=5 --chunk=1024 
> --verbose --raid-devices=10 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 
> missing /dev/sdh1 /dev/sdi1 /dev/sdj1 /dev/sdk1 /dev/sdl1
> 
> Besides that though the commands look the same.

Yes, superblock is a version 0.90 and I cleared them via:
mdadm --zero-supderblock --force /dev/sd[a-f]5

 From what I've googled, the --zero-superblock will remove any 
superblock from front or back of the partition. --force will insist that 
the operation be done even if it doesn't look like a superblock exists.


> 
> Do you use initrd/etc or do you compile everything in at the kernel level?
> Is it possible one disk is on one controller and the others are on another
> or something weird like that, such that the driver for one chipset loads
> before and the other does not load until later?
> 
> Some dmesg output may be useful along with mdadm -D on the raid array 
> before and after reboots.
> 

dmesg (/var/log/messages as well) are mysteriously quiet about why the 
resync was initiated, they merely state that it is being done.  That 
what is driving me nuts, no log info.  This is an ICH10 system board 
(Gigabyte GA-EP43-DS3L), the other board was Asus P5N-T Deluxe, also an 
ICH10 chipset.  This is the dmesg output from the recent Gigabyte board 
boot (and resync):

Linux version 2.6.27.7 (root@localhost) (gcc version 4.3.2 (GCC) ) #1 
SMP Sat Nov 29 10:14:42 EST 2008
Command line: BOOT_IMAGE=linux root=801 quiet
KERNEL supported cpus:
   Intel GenuineIntel
   AMD AuthenticAMD
   Centaur CentaurHauls
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
  BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007fee0000 (usable)
  BIOS-e820: 000000007fee0000 - 000000007fee3000 (ACPI NVS)
  BIOS-e820: 000000007fee3000 - 000000007fef0000 (ACPI data)
  BIOS-e820: 000000007fef0000 - 000000007ff00000 (reserved)
  BIOS-e820: 00000000e0000000 - 00000000e4000000 (reserved)
  BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
DMI 2.4 present.
last_pfn = 0x7fee0 max_arch_pfn = 0x3ffffffff
x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
init_memory_mapping
  0000000000 - 007fe00000 page 2M
  007fe00000 - 007fee0000 page 4k
kernel direct mapping tables up to 7fee0000 @ 8000-c000
last_map_addr: 7fee0000 end: 7fee0000
RAMDISK: 03d1e000 - 040efe24
ACPI: RSDP 000F70C0, 0014 (r0 GBT   )
ACPI: RSDT 7FEE3040, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: FACP 7FEE30C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: DSDT 7FEE3180, 4B8A (r1 GBT    GBTUACPI     1000 MSFT  100000C)
ACPI: FACS 7FEE0000, 0040
ACPI: HPET 7FEE7E80, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
ACPI: MCFG 7FEE7F00, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: APIC 7FEE7D80, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: SSDT 7FEE8860, 03AB (r1  PmRef    CpuPm     3000 INTL 20040311)
No NUMA configuration found
Faking a node at 0000000000000000-000000007fee0000
Bootmem setup node 0 0000000000000000-000000007fee0000
   NODE_DATA [0000000000001000 - 0000000000005fff]
   bootmap [000000000000a000 -  0000000000019fdf] pages 10
(6 early reservations) ==> bootmem [0000000000 - 007fee0000]
   #0 [0000000000 - 0000001000]   BIOS data page ==> [0000000000 - 
0000001000]
   #1 [0000006000 - 0000008000]       TRAMPOLINE ==> [0000006000 - 
0000008000]
   #2 [0000200000 - 00007ca68c]    TEXT DATA BSS ==> [0000200000 - 
00007ca68c]
   #3 [0003d1e000 - 00040efe24]          RAMDISK ==> [0003d1e000 - 
00040efe24]
   #4 [000009f800 - 0000100000]    BIOS reserved ==> [000009f800 - 
0000100000]
   #5 [0000008000 - 000000a000]          PGTABLE ==> [0000008000 - 
000000a000]
found SMP MP-table at [ffff8800000f56d0] 000f56d0
  [ffffe20000000000-ffffe20001bfffff] PMD -> 
[ffff880001200000-ffff880002dfffff] on node 0
Zone PFN ranges:
   DMA      0x00000000 -> 0x00001000
   DMA32    0x00001000 -> 0x00100000
   Normal   0x00100000 -> 0x00100000
Movable zone start PFN for each node
early_node_map[2] active PFN ranges
     0: 0x00000000 -> 0x0000009f
     0: 0x00000100 -> 0x0007fee0
On node 0 totalpages: 523903
   DMA zone: 2358 pages, LIFO batch:0
   DMA32 zone: 512795 pages, LIFO batch:31
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x02] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x03] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 2, version 0, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Setting APIC routing to flat
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
SMP: Allowing 4 CPUs, 0 hotplug CPUs
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000f0000
PM: Registered nosave memory: 00000000000f0000 - 0000000000100000
Allocating PCI resources starting at 80000000 (gap: 7ff00000:60100000)
PERCPU: Allocating 51744 bytes of per cpu data
NR_CPUS: 32, nr_cpu_ids: 4, nr_node_ids 1
Built 1 zonelists in Node order, mobility grouping on.  Total pages: 515153
Policy zone: DMA32
Kernel command line: BOOT_IMAGE=linux root=801 quiet
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 32768 bytes)
TSC: PIT calibration confirmed by PMTIMER.
TSC: using PMTIMER calibration value
Detected 2400.073 MHz processor.
Console: colour VGA+ 80x25
console [tty0] enabled
Checking aperture...
No AGP bridge found
Calgary: detecting Calgary via BIOS EBDA area
Calgary: Unable to locate Rio Grande table in EBDA - bailing!
Memory: 2056720k/2096000k available (2973k kernel code, 38892k reserved, 
1521k data, 532k init)
CPA: page pool initialized 1 of 1 pages preallocated
SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
hpet clockevent registered
Calibrating delay loop (skipped), value calculated using timer 
frequency.. 4800.14 BogoMIPS (lpj=2400073)
Security Framework initialized
Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes)
Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes)
Mount-cache hash table entries: 256
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 0/0 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 0
CPU0: Thermal monitoring enabled (TM2)
using mwait in idle threads.
ACPI: Core revision 20080609
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
CPU0: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
Using local APIC timer interrupts.
APIC timer calibration result 16667158
Detected 16.667 MHz APIC timer.
Booting processor 1/2 ip 6000
Initializing CPU#1
Calibrating delay using timer specific routine.. 4800.18 BogoMIPS 
(lpj=2400090)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 1/2 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 2
CPU1: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
CPU1: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
Booting processor 2/3 ip 6000
Initializing CPU#2
Calibrating delay using timer specific routine.. 4864.63 BogoMIPS 
(lpj=2432315)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 2/3 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 3
CPU2: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
CPU2: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#2]: passed.
Booting processor 3/1 ip 6000
Initializing CPU#3
Calibrating delay using timer specific routine.. 4799.69 BogoMIPS 
(lpj=2399847)
CPU: L1 I cache: 32K, L1 D cache: 32K
CPU: L2 cache: 4096K
CPU 3/1 -> Node 0
CPU: Physical Processor ID: 0
CPU: Processor Core ID: 1
CPU3: Thermal monitoring enabled (TM2)
x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
CPU3: Intel(R) Core(TM)2 Quad CPU    Q6600  @ 2.40GHz stepping 0b
checking TSC synchronization [CPU#0 -> CPU#3]: passed.
Brought up 4 CPUs
Total of 4 processors activated (19264.65 BogoMIPS).
CPU0 attaching sched-domain:
  domain 0: span 0,3 level MC
   groups: 0 3
   domain 1: span 0-3 level CPU
    groups: 0,3 1-2
    domain 2: span 0-3 level NODE
     groups: 0-3
CPU1 attaching sched-domain:
  domain 0: span 1-2 level MC
   groups: 1 2
   domain 1: span 0-3 level CPU
    groups: 1-2 0,3
    domain 2: span 0-3 level NODE
     groups: 0-3
CPU2 attaching sched-domain:
  domain 0: span 1-2 level MC
   groups: 2 1
   domain 1: span 0-3 level CPU
    groups: 1-2 0,3
    domain 2: span 0-3 level NODE
     groups: 0-3
CPU3 attaching sched-domain:
  domain 0: span 0,3 level MC
   groups: 3 0
   domain 1: span 0-3 level CPU
    groups: 0,3 1-2
    domain 2: span 0-3 level NODE
     groups: 0-3
net_namespace: 1552 bytes
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 63
PCI: MCFG area at e0000000 reserved in E820
PCI: Using MMCONFIG at e0000000 - e3ffffff
PCI: Using configuration type 1 for base access
ACPI: EC: Look up EC in DSDT
ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: 0000:00:1a.0 reg 20 io port: [e100, e11f]
PCI: 0000:00:1a.1 reg 20 io port: [e200, e21f]
PCI: 0000:00:1a.2 reg 20 io port: [e000, e01f]
PCI: 0000:00:1a.7 reg 10 32bit mmio: [e8104000, e81043ff]
PCI: 0000:00:1b.0 reg 10 64bit mmio: [e8100000, e8103fff]
pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1b.0: PME# disabled
pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.0: PME# disabled
pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.4: PME# disabled
pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
pci 0000:00:1c.5: PME# disabled
PCI: 0000:00:1d.0 reg 20 io port: [e300, e31f]
PCI: 0000:00:1d.1 reg 20 io port: [e400, e41f]
PCI: 0000:00:1d.2 reg 20 io port: [e500, e51f]
PCI: 0000:00:1d.7 reg 10 32bit mmio: [e8105000, e81053ff]
PCI: 0000:00:1f.2 reg 10 io port: [0, 7]
PCI: 0000:00:1f.2 reg 14 io port: [0, 3]
PCI: 0000:00:1f.2 reg 18 io port: [0, 7]
PCI: 0000:00:1f.2 reg 1c io port: [0, 3]
PCI: 0000:00:1f.2 reg 20 io port: [f000, f00f]
PCI: 0000:00:1f.2 reg 24 io port: [f100, f10f]
PCI: 0000:00:1f.3 reg 10 64bit mmio: [e8106000, e81060ff]
PCI: 0000:00:1f.3 reg 20 io port: [500, 51f]
PCI: 0000:00:1f.5 reg 10 io port: [e700, e707]
PCI: 0000:00:1f.5 reg 14 io port: [e800, e803]
PCI: 0000:00:1f.5 reg 18 io port: [e900, e907]
PCI: 0000:00:1f.5 reg 1c io port: [ea00, ea03]
PCI: 0000:00:1f.5 reg 20 io port: [eb00, eb0f]
PCI: 0000:00:1f.5 reg 24 io port: [ec00, ec0f]
PCI: 0000:02:00.0 reg 10 io port: [c000, c007]
PCI: 0000:02:00.0 reg 14 io port: [c100, c103]
PCI: 0000:02:00.0 reg 18 io port: [c200, c207]
PCI: 0000:02:00.0 reg 1c io port: [c300, c303]
PCI: 0000:02:00.0 reg 20 io port: [c400, c40f]
Pre-1.1 PCIe device detected, disable ASPM for 0000:00:1c.4. It can be 
enabled forcedly with 'pcie_aspm=force'
PCI: bridge 0000:00:1c.4 io port: [c000, cfff]
PCI: bridge 0000:00:1c.4 32bit mmio: [e7000000, e7ffffff]
PCI: 0000:03:00.0 reg 10 io port: [d000, d0ff]
PCI: 0000:03:00.0 reg 18 64bit mmio: [e8010000, e8010fff]
PCI: 0000:03:00.0 reg 20 64bit mmio: [e8000000, e800ffff]
PCI: 0000:03:00.0 reg 30 32bit mmio: [0, ffff]
pci 0000:03:00.0: supports D1
pci 0000:03:00.0: supports D2
pci 0000:03:00.0: PME# supported from D0 D1 D2 D3hot D3cold
pci 0000:03:00.0: PME# disabled
PCI: bridge 0000:00:1c.5 io port: [d000, dfff]
PCI: bridge 0000:00:1c.5 32bit mmio: [e4000000, e4ffffff]
PCI: bridge 0000:00:1c.5 64bit mmio pref: [e8000000, e80fffff]
PCI: 0000:04:00.0 reg 10 32bit mmio: [e5000000, e5ffffff]
PCI: 0000:04:00.0 reg 14 32bit mmio: [d0000000, dfffffff]
PCI: 0000:04:00.0 reg 30 32bit mmio: [0, 1ffff]
pci 0000:00:1e.0: transparent bridge
PCI: bridge 0000:00:1e.0 32bit mmio: [e5000000, e6ffffff]
PCI: bridge 0000:00:1e.0 64bit mmio pref: [d0000000, dfffffff]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK1] (IRQs 3 4 5 *6 7 9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
ACPI: bus type pnp registered
pnp: PnP ACPI: found 15 devices
ACPI: ACPI bus type pnp unregistered
PCI: Using ACPI for IRQ routing
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4
NetLabel:  unlabeled traffic allowed by default
DMAR:parse DMAR table failure.
PCI-GART: No AMD northbridge found.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz
ACPI: RTC can wake from S4
system 00:01: ioport range 0x4d0-0x4d1 has been reserved
system 00:01: ioport range 0x290-0x29f has been reserved
system 00:01: ioport range 0x800-0x87f has been reserved
system 00:01: ioport range 0x290-0x294 has been reserved
system 00:01: ioport range 0x880-0x88f has been reserved
system 00:01: ioport range 0x4c0-0x4ff could not be reserved
system 00:0b: ioport range 0x400-0x4bf has been reserved
system 00:0c: iomem range 0xe0000000-0xe3ffffff could not be reserved
system 00:0d: iomem range 0xcf800-0xcffff has been reserved
system 00:0d: iomem range 0xf0000-0xf7fff could not be reserved
system 00:0d: iomem range 0xf8000-0xfbfff could not be reserved
system 00:0d: iomem range 0xfc000-0xfffff could not be reserved
system 00:0d: iomem range 0x7fee0000-0x7fefffff could not be reserved
system 00:0d: iomem range 0x0-0x9ffff could not be reserved
system 00:0d: iomem range 0x100000-0x7fedffff could not be reserved
system 00:0d: iomem range 0xfec00000-0xfec00fff could not be reserved
system 00:0d: iomem range 0xfed10000-0xfed1dfff could not be reserved
system 00:0d: iomem range 0xfed20000-0xfed8ffff could not be reserved
system 00:0d: iomem range 0xfee00000-0xfee00fff could not be reserved
system 00:0d: iomem range 0xffb00000-0xffb7ffff could not be reserved
system 00:0d: iomem range 0xfff00000-0xffffffff could not be reserved
system 00:0d: iomem range 0xe0000-0xeffff has been reserved
pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
pci 0000:00:1c.0:   IO window: disabled
pci 0000:00:1c.0:   MEM window: disabled
pci 0000:00:1c.0:   PREFETCH window: disabled
pci 0000:00:1c.4: PCI bridge, secondary bus 0000:02
pci 0000:00:1c.4:   IO window: 0xc000-0xcfff
pci 0000:00:1c.4:   MEM window: 0xe7000000-0xe7ffffff
pci 0000:00:1c.4:   PREFETCH window: disabled
pci 0000:00:1c.5: PCI bridge, secondary bus 0000:03
pci 0000:00:1c.5:   IO window: 0xd000-0xdfff
pci 0000:00:1c.5:   MEM window: 0xe4000000-0xe4ffffff
pci 0000:00:1c.5:   PREFETCH window: 0x000000e8000000-0x000000e80fffff
pci 0000:00:1e.0: PCI bridge, secondary bus 0000:04
pci 0000:00:1e.0:   IO window: disabled
pci 0000:00:1e.0:   MEM window: 0xe5000000-0xe6ffffff
pci 0000:00:1e.0:   PREFETCH window: 0x000000d0000000-0x000000dfffffff
pci 0000:00:1c.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.0: setting latency timer to 64
pci 0000:00:1c.4: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pci 0000:00:1c.4: setting latency timer to 64
pci 0000:00:1c.5: PCI INT B -> GSI 17 (level, low) -> IRQ 17
pci 0000:00:1c.5: setting latency timer to 64
pci 0000:00:1e.0: setting latency timer to 64
bus: 00 index 0 io port: [0, ffff]
bus: 00 index 1 mmio: [0, ffffffffffffffff]
bus: 01 index 0 mmio: [0, 0]
bus: 01 index 1 mmio: [0, 0]
bus: 01 index 2 mmio: [0, 0]
bus: 01 index 3 mmio: [0, 0]
bus: 02 index 0 io port: [c000, cfff]
bus: 02 index 1 mmio: [e7000000, e7ffffff]
bus: 02 index 2 mmio: [0, 0]
bus: 02 index 3 mmio: [0, 0]
bus: 03 index 0 io port: [d000, dfff]
bus: 03 index 1 mmio: [e4000000, e4ffffff]
bus: 03 index 2 mmio: [e8000000, e80fffff]
bus: 03 index 3 mmio: [0, 0]
bus: 04 index 0 mmio: [0, 0]
bus: 04 index 1 mmio: [e5000000, e6ffffff]
bus: 04 index 2 mmio: [d0000000, dfffffff]
bus: 04 index 3 io port: [0, ffff]
bus: 04 index 4 mmio: [0, ffffffffffffffff]
NET: Registered protocol family 2
IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
TCP: Hash tables configured (established 262144 bind 65536)
TCP reno registered
NET: Registered protocol family 1
checking if image is initramfs... it is
Switched to high resolution mode on CPU 2
Switched to high resolution mode on CPU 3
Switched to high resolution mode on CPU 0
Switched to high resolution mode on CPU 1
Freeing initrd memory: 3911k freed
audit: initializing netlink socket (disabled)
type=2000 audit(1228006010.551:1): initialized
HugeTLB registered 2 MB page size, pre-allocated 0 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 512 (order 0, 4096 bytes)
msgmni has been set to 4024
Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
pci 0000:04:00.0: Boot video device
pcieport-driver 0000:00:1c.0: setting latency timer to 64
pcieport-driver 0000:00:1c.0: found MSI capability
pci_express 0000:00:1c.0:pcie00: allocate port service
pci_express 0000:00:1c.0:pcie02: allocate port service
pci_express 0000:00:1c.0:pcie03: allocate port service
pcieport-driver 0000:00:1c.4: setting latency timer to 64
pcieport-driver 0000:00:1c.4: found MSI capability
pci_express 0000:00:1c.4:pcie00: allocate port service
pci_express 0000:00:1c.4:pcie02: allocate port service
pci_express 0000:00:1c.4:pcie03: allocate port service
pcieport-driver 0000:00:1c.5: setting latency timer to 64
pcieport-driver 0000:00:1c.5: found MSI capability
pci_express 0000:00:1c.5:pcie00: allocate port service
pci_express 0000:00:1c.5:pcie02: allocate port service
pci_express 0000:00:1c.5:pcie03: allocate port service
hpet_resources: 0xfed00000 is busy
Linux agpgart interface v0.103
Serial: 8250/16550 driver4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:07: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
brd: module loaded
input: Macintosh mouse button emulation as /class/input/input0
PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
serio: i8042 KBD port at 0x60,0x64 irq 1
serio: i8042 AUX port at 0x60,0x64 irq 12
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard as /class/input/input1
cpuidle: using governor ladder
cpuidle: using governor menu
TCP cubic registered
registered taskstats version 1
BIOS EDD facility v0.16 2004-Jun-25, 6 devices found
Freeing unused kernel memory: 532k freed
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
ehci_hcd 0000:00:1a.7: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ehci_hcd 0000:00:1a.7: setting latency timer to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
ehci_hcd 0000:00:1a.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe8104000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
input: PS2++ Logitech MX Mouse as /class/input/input2
usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb1: Product: EHCI Host Controller
usb usb1: Manufacturer: Linux 2.6.27.7 ehci_hcd
usb usb1: SerialNumber: 0000:00:1a.7
ehci_hcd 0000:00:1d.7: PCI INT A -> GSI 23 (level, low) -> IRQ 23
ehci_hcd 0000:00:1d.7: setting latency timer to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
ehci_hcd 0000:00:1d.7: cache line size of 32 is not supported
ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe8105000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 6 ports detected
usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb2: Product: EHCI Host Controller
usb usb2: Manufacturer: Linux 2.6.27.7 ehci_hcd
usb usb2: SerialNumber: 0000:00:1d.7
ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
USB Universal Host Controller Interface driver v3.0
uhci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
uhci_hcd 0000:00:1a.0: setting latency timer to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e100
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
usb usb3: New USB device found, idVendor=1d6b, idProduct=0001
usb usb3: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb3: Product: UHCI Host Controller
usb usb3: Manufacturer: Linux 2.6.27.7 uhci_hcd
usb usb3: SerialNumber: 0000:00:1a.0
uhci_hcd 0000:00:1a.1: PCI INT B -> GSI 21 (level, low) -> IRQ 21
uhci_hcd 0000:00:1a.1: setting latency timer to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1a.1: irq 21, io base 0x0000e200
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb usb4: New USB device found, idVendor=1d6b, idProduct=0001
usb usb4: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb4: Product: UHCI Host Controller
usb usb4: Manufacturer: Linux 2.6.27.7 uhci_hcd
usb usb4: SerialNumber: 0000:00:1a.1
uhci_hcd 0000:00:1a.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1a.2: setting latency timer to 64
uhci_hcd 0000:00:1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1a.2: irq 18, io base 0x0000e000
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb usb5: New USB device found, idVendor=1d6b, idProduct=0001
usb usb5: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb5: Product: UHCI Host Controller
usb usb5: Manufacturer: Linux 2.6.27.7 uhci_hcd
usb usb5: SerialNumber: 0000:00:1a.2
uhci_hcd 0000:00:1d.0: PCI INT A -> GSI 23 (level, low) -> IRQ 23
uhci_hcd 0000:00:1d.0: setting latency timer to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.0: irq 23, io base 0x0000e300
usb usb6: configuration #1 chosen from 1 choice
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
usb usb6: New USB device found, idVendor=1d6b, idProduct=0001
usb usb6: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb6: Product: UHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.27.7 uhci_hcd
usb usb6: SerialNumber: 0000:00:1d.0
uhci_hcd 0000:00:1d.1: PCI INT B -> GSI 19 (level, low) -> IRQ 19
uhci_hcd 0000:00:1d.1: setting latency timer to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 7
uhci_hcd 0000:00:1d.1: irq 19, io base 0x0000e400
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
usb usb7: New USB device found, idVendor=1d6b, idProduct=0001
usb usb7: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb7: Product: UHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.27.7 uhci_hcd
usb usb7: SerialNumber: 0000:00:1d.1
uhci_hcd 0000:00:1d.2: PCI INT C -> GSI 18 (level, low) -> IRQ 18
uhci_hcd 0000:00:1d.2: setting latency timer to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 8
uhci_hcd 0000:00:1d.2: irq 18, io base 0x0000e500
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
usb usb8: New USB device found, idVendor=1d6b, idProduct=0001
usb usb8: New USB device strings: Mfr=3, Product=2, SerialNumber=1
usb usb8: Product: UHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.27.7 uhci_hcd
usb usb8: SerialNumber: 0000:00:1d.2
SCSI subsystem initialized
Driver 'sd' needs updating - please use bus_type methods
No dock devices found.
libata version 3.00 loaded.
ata_piix 0000:00:1f.2: version 2.12
ata_piix 0000:00:1f.2: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.2: MAP [ P0 P2 P1 P3 ]
ata_piix 0000:00:1f.2: setting latency timer to 64
scsi0 : ata_piix
scsi1 : ata_piix
ata1: SATA max UDMA/133 cmd 0x1f0 ctl 0x3f6 bmdma 0xf000 irq 14
ata2: SATA max UDMA/133 cmd 0x170 ctl 0x376 bmdma 0xf008 irq 15
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: HPA detected: current 625140335, native 625142448
ata1.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata1.00: 625140335 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.01: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata1.01: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata1.00: configured for UDMA/133
ata1.01: configured for UDMA/133
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: HPA detected: current 625140335, native 625142448
ata2.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata2.00: 625140335 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.01: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata2.01: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata2.00: configured for UDMA/133
ata2.01: configured for UDMA/133
isa bounce pool size: 16 pages
scsi 0:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 0:0:0:0: [sda] 625140335 512-byte hardware sectors (320072 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:0:0: [sda] 625140335 512-byte hardware sectors (320072 MB)
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sda: sda1 sda2 sda3 < sda5 >
sd 0:0:0:0: [sda] Attached SCSI disk
scsi 0:0:1:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 0:0:1:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 0:0:1:0: [sdb] 625142448 512-byte hardware sectors (320073 MB)
sd 0:0:1:0: [sdb] Write Protect is off
sd 0:0:1:0: [sdb] Mode Sense: 00 3a 00 00
sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sdb: sdb1 sdb2 sdb3 < sdb5 >
sd 0:0:1:0: [sdb] Attached SCSI disk
scsi 1:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 1:0:0:0: [sdc] 625140335 512-byte hardware sectors (320072 MB)
sd 1:0:0:0: [sdc] Write Protect is off
sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 1:0:0:0: [sdc] 625140335 512-byte hardware sectors (320072 MB)
sd 1:0:0:0: [sdc] Write Protect is off
sd 1:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sdc: sdc1 sdc2 sdc3 < sdc5 >
sd 1:0:0:0: [sdc] Attached SCSI disk
scsi 1:0:1:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
sd 1:0:1:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:1:0: [sdd] Write Protect is off
sd 1:0:1:0: [sdd] Mode Sense: 00 3a 00 00
sd 1:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 1:0:1:0: [sdd] 625142448 512-byte hardware sectors (320073 MB)
sd 1:0:1:0: [sdd] Write Protect is off
sd 1:0:1:0: [sdd] Mode Sense: 00 3a 00 00
sd 1:0:1:0: [sdd] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sdd: sdd1 sdd2 sdd3 < sdd5 >
sd 1:0:1:0: [sdd] Attached SCSI disk
ata_piix 0000:00:1f.5: PCI INT B -> GSI 19 (level, low) -> IRQ 19
ata_piix 0000:00:1f.5: MAP [ P0 -- P1 -- ]
ata_piix 0000:00:1f.5: setting latency timer to 64
scsi2 : ata_piix
scsi3 : ata_piix
ata3: SATA max UDMA/133 cmd 0xe700 ctl 0xe800 bmdma 0xeb00 irq 19
ata4: SATA max UDMA/133 cmd 0xe900 ctl 0xea00 bmdma 0xeb08 irq 19
ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata3.00: HPA detected: current 625140335, native 625142448
ata3.00: ATA-8: WDC WD3200AAKS-00VYA0, 12.01B02, max UDMA/133
ata3.00: 625140335 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata4.00: ATA-8: WDC WD3200AAKS-00VYA0, 12.01B02, max UDMA/133
ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
scsi 2:0:0:0: Direct-Access     ATA      WDC WD3200AAKS-0 12.0 PQ: 0 ANSI: 5
sd 2:0:0:0: [sde] 625140335 512-byte hardware sectors (320072 MB)
sd 2:0:0:0: [sde] Write Protect is off
sd 2:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 2:0:0:0: [sde] 625140335 512-byte hardware sectors (320072 MB)
sd 2:0:0:0: [sde] Write Protect is off
sd 2:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 2:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sde: sde1 sde2 sde3 < sde5 >
sd 2:0:0:0: [sde] Attached SCSI disk
scsi 3:0:0:0: Direct-Access     ATA      WDC WD3200AAKS-0 12.0 PQ: 0 ANSI: 5
sd 3:0:0:0: [sdf] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdf] Write Protect is off
sd 3:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
sd 3:0:0:0: [sdf] 625142448 512-byte hardware sectors (320073 MB)
sd 3:0:0:0: [sdf] Write Protect is off
sd 3:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't 
support DPO or FUA
  sdf: sdf1 sdf2 sdf3 < sdf5 >
sd 3:0:0:0: [sdf] Attached SCSI disk
pata_jmicron 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
pata_jmicron 0000:02:00.0: setting latency timer to 64
scsi4 : pata_jmicron
scsi5 : pata_jmicron
ata5: PATA max UDMA/100 cmd 0xc000 ctl 0xc100 bmdma 0xc400 irq 16
ata6: PATA max UDMA/100 cmd 0xc200 ctl 0xc300 bmdma 0xc408 irq 16
ata5.00: ATAPI: Memorex 16X-DDL-IN, 1.A3, max UDMA/33
ata5.00: configured for UDMA/33
scsi 4:0:0:0: CD-ROM            Memorex  16X-DDL-IN       1.A3 PQ: 0 ANSI: 5
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 0:0:1:0: Attached scsi generic sg1 type 0
sd 1:0:0:0: Attached scsi generic sg2 type 0
sd 1:0:1:0: Attached scsi generic sg3 type 0
sd 2:0:0:0: Attached scsi generic sg4 type 0
sd 3:0:0:0: Attached scsi generic sg5 type 0
scsi 4:0:0:0: Attached scsi generic sg6 type 5
Driver 'sr' needs updating - please use bus_type methods
sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
Uniform CD-ROM driver Revision: 3.20
sr 4:0:0:0: Attached scsi CD-ROM sr0
parport_pc 00:08: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
input: PC Speaker as /class/input/input3
ppdev: user-space parallel port driver
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
r8169 0000:03:00.0: setting latency timer to 64
eth0: RTL8168c/8111c at 0xffffc2000032e000, 00:1f:d0:83:97:d1, XID 
3c4000c0 IRQ 1276
rtc_cmos 00:04: rtc core: registered rtc_cmos as rtc0
rtc0: alarms up to one month, hpet irqs
input: Power Button (FF) as /class/input/input4
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input5
ACPI: Power Button (CM) [PWRB]
i801_smbus 0000:00:1f.3: PCI INT C -> GSI 18 (level, low) -> IRQ 18
ACPI: SSDT 7FEE7F80, 022A (r1  PmRef  Cpu0Ist     3000 INTL 20040311)
ACPI: CPU0 (power states: C1[C1] C2[C2])
processor ACPI0007:00: registered as cooling_device0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: SSDT 7FEE8440, 0152 (r1  PmRef  Cpu1Ist     3000 INTL 20040311)
ACPI: CPU1 (power states: C1[C1] C2[C2])
processor ACPI0007:01: registered as cooling_device1
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: SSDT 7FEE85A0, 0152 (r1  PmRef  Cpu2Ist     3000 INTL 20040311)
ACPI: CPU2 (power states: C1[C1] C2[C2])
processor ACPI0007:02: registered as cooling_device2
ACPI: Processor [CPU2] (supports 8 throttling states)
ACPI: SSDT 7FEE8700, 0152 (r1  PmRef  Cpu3Ist     3000 INTL 20040311)
ACPI: CPU3 (power states: C1[C1] C2[C2])
processor ACPI0007:03: registered as cooling_device3
ACPI: Processor [CPU3] (supports 8 throttling states)
md: bind<sdf5>
md: bind<sde5>
md: bind<sdb5>
HDA Intel 0000:00:1b.0: PCI INT A -> GSI 22 (level, low) -> IRQ 22
HDA Intel 0000:00:1b.0: setting latency timer to 64
md: bind<sda5>
md: bind<sdc5>
md: raid10 personality registered for level 10
raid10: raid set md0 active with 5 out of 6 devices
md: bind<sdd5>
RAID10 conf printout:
  --- wd:5 rd:6
  disk 0, wo:0, o:1, dev:sda5
  disk 1, wo:0, o:1, dev:sdb5
  disk 2, wo:0, o:1, dev:sdc5
  disk 3, wo:1, o:1, dev:sdd5
  disk 4, wo:0, o:1, dev:sde5
  disk 5, wo:0, o:1, dev:sdf5
md: recovery of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than 200000 
KB/sec) for recovery.
md: using 128k window, over a total of 20980736 blocks.
device-mapper: uevent: version 1.0.3
device-mapper: ioctl: 4.14.0-ioctl (2008-04-23) initialised: 
dm-devel@redhat.com
EXT3 FS on sda1, internal journal
loop: module loaded
Adding 1959920k swap on /dev/sda2.  Priority:-1 extents:1 across:1959920k
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
r8169: eth0: link up
r8169: eth0: link up
NET: Registered protocol family 17
eth0: no IPv6 routers present
md: md0: recovery done.
RAID10 conf printout:
  --- wd:6 rd:6
  disk 0, wo:0, o:1, dev:sda5
  disk 1, wo:0, o:1, dev:sdb5
  disk 2, wo:0, o:1, dev:sdc5
  disk 3, wo:0, o:1, dev:sdd5
  disk 4, wo:0, o:1, dev:sde5
  disk 5, wo:0, o:1, dev:sdf5


From: "Sam Redfern" <sredfern@gmail.com>
Subject: Fwd: issues rebuilding raid array.
Date: Mon, 22 Oct 2007 21:46:08 +1000
Message-ID: <8a16822a0710220446y1d360965m2f705842e5940932@mail.gmail.com>
References: <8a16822a0710220445i3175a624g5b92535ca3797517@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8a16822a0710220445i3175a624g5b92535ca3797517@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings happy mdadm users.

I have a little problem that after many hours of searching around I
couldn't seem to solve.

I have upgraded my motherboard and kernel (bad practice I know but the
ICH9R controller needs  2.6.2*+) at the same time.

The array was build using 2.6.18-7 Now i'm using  2.6.21-2

I'm trying to recreate the raid array with the following command and
this is the error I get:

mca4:~# mdadm -Av /dev/md1 /dev/sdb /dev/sdc /dev/sdd /dev/sde
/dev/sdf /dev/sdg
mdadm: looking for devices for /dev/md1
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdc has no superblock - assembly aborted

So I figure, oh look the disk sdc has gone cactus, I'll just remove it
from the list. One of the advantages of mdadm.

mca4:~# mdadm -Av /dev/md1 /dev/sdb /dev/sdd /dev/sde /dev/sdf /dev/sdg
mdadm: looking for devices for /dev/md1
mdadm: /dev/sdb is identified as a member of /dev/md1, slot -1.
mdadm: /dev/sdd is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sde is identified as a member of /dev/md1, slot 1.
mdadm: /dev/sdf is identified as a member of /dev/md1, slot 5.
mdadm: /dev/sdg is identified as a member of /dev/md1, slot 4.
mdadm: added /dev/sde to /dev/md1 as 1
mdadm: no uptodate device for slot 2 of /dev/md1
mdadm: no uptodate device for slot 3 of /dev/md1
mdadm: added /dev/sdg to /dev/md1 as 4
mdadm: added /dev/sdf to /dev/md1 as 5
mdadm: failed to add /dev/sdb to /dev/md1: Invalid argument
mdadm: added /dev/sdd to /dev/md1 as 0
mdadm: /dev/md1 assembled from 4 drives - not enough to start the array.

If found this really difficult to understand considering that I can
get the output of mdamd -E /dev/sdb (other disks included to overload
you with information)

mdadm -E /dev/sd[b-h]

/dev/sdb:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 4e3b82e1:f5604e19:a9c9775f:49745adf
  Creation Time : Fri Oct  5 09:18:25 2007
     Raid Level : raid5
    Device Size : 312571136 (298.09 GiB 320.07 GB)
     Array Size : 1562855680 (1490.46 GiB 1600.36 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1

    Update Time : Tue Oct 16 20:03:13 2007
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 80d47486 - correct
         Events : 0.623738

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     6       8       16       -1      spare   /dev/sdb

   0     0       8       80        0      active sync   /dev/sdf
   1     1       8      128        1      active sync   /dev/.static/dev/sdi
   2     2       8      144        2      active sync   /dev/.static/dev/sdj
   3     3       8       16        3      active sync   /dev/sdb
   4     4       8       64        4      active sync   /dev/sde
   5     5       8       96        5      active sync   /dev/sdg
mdadm: No md superblock detected on /dev/sdc.
/dev/sdd:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 4e3b82e1:f5604e19:a9c9775f:49745adf
  Creation Time : Fri Oct  5 09:18:25 2007
     Raid Level : raid5
    Device Size : 312571136 (298.09 GiB 320.07 GB)
     Array Size : 1562855680 (1490.46 GiB 1600.36 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1

    Update Time : Tue Oct 16 20:03:13 2007
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 80d474a8 - correct
         Events : 0.623738

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     0       8       80        0      active sync   /dev/sdf

   0     0       8       80        0      active sync   /dev/sdf
    1     1       8      128        1      active sync   /dev/.static/dev/sdi
   2     2       8      144        2      active sync   /dev/.static/dev/sdj
   3     3       8       16        3      active sync   /dev/sdb
   4     4       8       64        4      active sync   /dev/sde
   5     5       8       96        5      active sync   /dev/sdg
/dev/sde:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 4e3b82e1:f5604e19:a9c9775f:49745adf
  Creation Time : Fri Oct  5 09:18:25 2007
     Raid Level : raid5
    Device Size : 312571136 (298.09 GiB 320.07 GB)
     Array Size : 1562855680 (1490.46 GiB 1600.36 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1

    Update Time : Tue Oct 16 20:03:13 2007
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 80d474da - correct
         Events : 0.623738

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     1       8      128        1      active sync   /dev/.static/dev/sdi

   0     0       8       80        0      active sync   /dev/sdf
   1     1       8      128        1      active sync   /dev/.static/dev/sdi
   2     2       8      144        2      active sync   /dev/.static/dev/sdj
   3     3       8       16        3      active sync   /dev/sdb
   4     4       8       64        4      active sync   /dev/sde
   5     5       8       96        5      active sync   /dev/sdg
/dev/sdf:
           Magic : a92b4efc
        Version : 00.90.00
           UUID : 4e3b82e1:f5604e19:a9c9775f:49745adf
  Creation Time : Fri Oct  5 09:18:25 2007
     Raid Level : raid5
    Device Size : 312571136 (298.09  GiB 320.07 GB)
     Array Size : 1562855680 (1490.46 GiB 1600.36 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1

    Update Time : Tue Oct 16 20:03:13 2007
          State : clean
  Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 80d474c2 - correct
         Events : 0.623738

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     5       8       96        5      active sync   /dev/sdg

   0     0       8       80        0      active sync   /dev/sdf
   1     1       8      128        1      active sync   /dev/.static/dev/sdi
   2     2       8      144        2      active sync   /dev/.static/dev/sdj
   3     3       8       16        3      active sync   /dev/sdb
   4     4       8       64        4      active sync   /dev/sde
   5     5       8       96        5      active sync   /dev/sdg
/dev/sdg:
          Magic : a92b4efc
        Version : 00.90.00
           UUID : 4e3b82e1:f5604e19:a9c9775f:49745adf
  Creation Time : Fri Oct  5 09:18:25 2007
     Raid Level : raid5
    Device Size : 312571136 ( 298.09 GiB 320.07 GB)
     Array Size : 1562855680 (1490.46 GiB 1600.36 GB)
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 1

    Update Time : Tue Oct 16 20:03:13 2007
          State : clean
 Active Devices : 6
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 0
       Checksum : 80d474a0 - correct
         Events : 0.623738

         Layout : left-symmetric
     Chunk Size : 64K

      Number   Major   Minor   RaidDevice State
this     4       8       64        4      active sync   /dev/sde

   0     0       8       80        0      active sync   /dev/sdf
   1     1       8      128        1      active sync   /dev/.static/dev/sdi
   2     2       8      144        2      active sync   /dev/.static/dev/sdj
   3     3       8       16        3      active sync   /dev/sdb
   4     4       8       64        4      active sync   /dev/sde
   5     5       8       96        5      active sync   /dev/sdg

So I decided to try rebuilding the array with the UUID, perhaps that will work.

mca4:~# mdadm -Av /dev/md1 --uuid=4e3b82e1:f5604e19:a9c9775f:49745adf /dev/sd*
mdadm: looking for devices for /dev/md1
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has wrong uuid.
mdadm: no recogniseable superblock on /dev/sda2
mdadm: /dev/sda2 has wrong uuid.
mdadm: cannot open device /dev/sda5: Device or resource busy
mdadm: /dev/sda5 has wrong uuid.
mdadm: no RAID superblock on /dev/sdc
mdadm: /dev/sdc has wrong uuid.
mdadm: /dev/sdb is identified as a member of /dev/md1, slot -1.
mdadm: /dev/sdd is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sde is identified as a member of /dev/md1, slot 1.
mdadm: /dev/sdf is identified as a member of /dev/md1, slot 5.
mdadm: /dev/sdg is identified as a member of /dev/md1, slot 4.
mdadm: added /dev/sde to /dev/md1 as 1
mdadm: no uptodate device for slot 2 of /dev/md1
mdadm: no uptodate device for slot 3 of /dev/md1
mdadm: added /dev/sdg to /dev/md1 as 4
mdadm: added /dev/sdf to /dev/md1 as 5
mdadm: failed to add /dev/sdb to /dev/md1: Invalid argument
mdadm: added /dev/sdd to /dev/md1 as 0
mdadm: /dev/md1 assembled from 4 drives - not enough to start the array.

Now, when the raid array was working all the disks contained the
correct information, now two disks are not functioning. I'd believe
one failed disk during the upgrade process but two having issues is
perplexing.

If anyone could offer a solution I'd be forever grateful, also to
prove that supporting open source isn't all free labour I'll send you
can choose one of 1 of 2 Nintendo DS games, the new radiohead album or
a cree flash light. :)

Included below is the usual dmesg:

Linux version 2.6.21-2-686 (Debian 2.6.21-6~bpo.1)
(nobse@backports.org) (gcc version 4.1.2 20061115 (prerelease) (Debian
4.1.1-21 )) #1 SMP Fri Jul 13 15:05:54 UTC 2007
BIOS-provided physical RAM map:
sanitize start
sanitize end
copy_e820_map() start: 0000000000000000 size: 000000000009f800 end:
000000000009f800 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000000009f800 size: 0000000000000800 end:
00000000000a0000 type: 2
copy_e820_map() start: 00000000000f0000 size: 0000000000010000 end:
0000000000100000 type: 2
copy_e820_map() start: 0000000000100000 size: 000000007f4e0000 end:
000000007f5e0000 type: 1
copy_e820_map() type is E820_RAM
copy_e820_map() start: 000000007f5e0000 size: 0000000000003000 end:
000000007f5e3000 type: 4
copy_e820_map() start: 000000007f5e3000 size: 000000000000d000 end:
000000007f5f0000 type: 3
copy_e820_map() start: 000000007f5f0000 size: 0000000000010000 end:
000000007f600000 type: 2
copy_e820_map() start: 00000000d0000000 size: 0000000010000000 end:
00000000e0000000 type: 2
copy_e820_map() start: 00000000fec00000 size: 0000000001400000 end:
0000000100000000 type: 2
 BIOS-e820: 0000000000000000 - 000000000009f800 (usable)
 BIOS-e820: 000000000009f800 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000f0000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000007f5e0000 (usable)
 BIOS-e820: 000000007f5e0000 - 000000007f5e3000 (ACPI NVS)
 BIOS-e820: 000000007f5e3000 - 000000007f5f0000 (ACPI data)
 BIOS-e820: 000000007f5f0000 - 000000007f600000 (reserved)
 BIOS-e820: 00000000d0000000 - 00000000e0000000 (reserved)
 BIOS-e820: 00000000fec00000 - 0000000100000000 (reserved)
1141MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000f5670
Entering add_active_range(0, 0, 521696) 0 entries of 256 used
 Zone PFN ranges:
  DMA             0 ->     4096
  Normal       4096 ->   229376
  HighMem    229376 ->   521696
early_node_map[1] active PFN ranges
    0:        0 ->   521696
On node 0 totalpages: 521696
  DMA zone: 32 pages used for memmap
  DMA zone: 0 pages reserved
  DMA zone: 4064 pages, LIFO batch:0
  Normal zone: 1760 pages used for memmap
  Normal zone: 223520 pages, LIFO batch:31
  HighMem zone: 2283 pages used for memmap
  HighMem zone: 290037 pages, LIFO batch:31
DMI 2.4 present.
ACPI: RSDP 000F7010, 0014 (r0 GBT   )
ACPI: RSDT 7F5E3040, 0034 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: FACP 7F5E30C0, 0074 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: DSDT 7F5E3180, 52B6 (r1 GBT    GBTUACPI     1000 MSFT  100000C)
ACPI: FACS 7F5E0000, 0040
ACPI: HPET 7F5E8580, 0038 (r1 GBT    GBTUACPI 42302E31 GBTU       98)
ACPI: MCFG 7F5E8600, 003C (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: APIC 7F5E8480, 0084 (r1 GBT    GBTUACPI 42302E31 GBTU  1010101)
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
Processor #0 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
Processor #1 15:4 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x02] disabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x03] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] dfl dfl lint[0x1])
ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
 IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
 ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
ACPI: HPET id: 0x8086a201 base: 0xfed00000
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 80000000 (gap: 7f600000:50a00000)
Built 1 zonelists.  Total pages: 517621
Kernel command line: root=/dev/sda1 ro
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Initializing CPU#0
PID hash table entries: 4096 (order: 12, 16384 bytes)
Detected 3608.763 MHz processor.
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2059908k/2086784k available (1661k kernel code, 25552k
reserved, 640k data, 212k init, 1169280k highmem)
virtual kernel memory layout:
    fixmap  : 0xfff4f000 - 0xfffff000   ( 704 kB)
    pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
    vmalloc : 0xf8800000 - 0xff7fe000   ( 111 MB)
    lowmem  : 0xc0000000 - 0xf8000000   ( 896 MB)
      .init : 0xc0345000 - 0xc037a000   ( 212 kB)
      .data : 0xc029f67d - 0xc033f834   ( 640 kB)
      .text : 0xc0100000 - 0xc029f67d   (1661 kB)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 64-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 7222.86  BogoMIPS
(lpj=14445726)
Security Framework v1.0.0 initialized
SELinux:  Disabled at boot.
Capability LSM initialized
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000
0000659d 00000000 00000000
monitor/mwait feature present.
using mwait in idle threads.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003180
0000659d 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (24) available
CPU0: Thermal monitoring enabled
Compat vDSO mapped to ffffe000.
Checking 'hlt' instruction... OK.
SMP alternatives: switching to UP code
ACPI: Core revision 20070126
CPU0: Intel(R) Pentium(R) 4 CPU 3.60GHz stepping 03
SMP alternatives: switching to SMP code
 Booting processor 1/1 eip 3000
Initializing CPU#1
Calibrating delay using timer specific routine.. 7216.99 BogoMIPS (lpj=14433992)
CPU: After generic identify, caps: bfebfbff 20100000 00000000 00000000
0000659d 00000000 00000000
monitor/mwait feature present.
CPU: Trace cache: 12K uops, L1 D cache: 16K
CPU: L2 cache: 2048K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebfbff 20100000 00000000 00003180
0000659d 00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (24) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Pentium(R) 4 CPU  3.60GHz stepping 03
Total of 2 processors activated (14439.85 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
checking TSC synchronization [CPU#0 -> CPU#1]: passed.
 Brought up 2 CPUs
migration_cost=25
Booting paravirtualized kernel on bare hardware
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: Using MMCONFIG
Setting up standard PCI resources
 ACPI: Interpreter enabled
ACPI: (supports S0 S3 S4 S5)
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
Boot video device is 0000:00:02.0
 PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.HUB0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, disabled.
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 *12 14 15)
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 *6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK0] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNK1] (IRQs *3 4 5 6 7 9 10 11 12 14 15)
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 13 devices
PnPBIOS: Disabled by ACPI PNP
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
NET: Registered protocol family 8
NET: Registered protocol family 20
pnp: 00:09: ioport range 0x400-0x4bf has been reserved
pnp: 00:0a: iomem range 0xd0000000-0xdfffffff could not be reserved
pnp: 00:0b: iomem range 0xcb400-0xcbfff has been reserved
pnp: 00:0b: iomem range 0xf0000-0xf7fff could not be reserved
pnp: 00:0b: iomem range 0xf8000-0xfbfff could not be reserved
pnp: 00:0b: iomem range 0xfc000-0xfffff could not be reserved
Time: tsc clocksource has been installed.
PCI: Ignore bogus resource 6 [0:0] of 0000:00:02.0
PCI: Bridge: 0000:00:1c.0
  IO window: a000-afff
   MEM window: disabled.
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.3
  IO window: b000-bfff
  MEM window: f4100000-f41fffff
  PREFETCH window: disabled.
PCI: Bridge: 0000:00:1c.4
  IO window: c000-cfff
  MEM window: f0000000-f1ffffff
  PREFETCH window: 80000000-800fffff
PCI: Bridge: 0000:00:1e.0
  IO window: d000-dfff
  MEM window: f2000000-f3ffffff
  PREFETCH window: 80100000-801fffff
ACPI: PCI Interrupt 0000:00: 1c.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.0 to 64
ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00: 1c.3 to 64
ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1c.4 to 64
PCI: Setting latency timer of device 0000:00:1e.0 to 64
NET: Registered protocol family 2
Switched to high resolution mode on CPU 1
Switched to high resolution mode on CPU 0
IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
TCP established hash table entries: 131072 (order: 8, 1572864 bytes)
TCP bind hash table entries: 65536 (order: 7, 524288 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
checking if image is initramfs... it is
Freeing initrd memory: 5457k freed
audit: initializing netlink socket (disabled)
audit(1193088181.456:1): initialized
highmem bounce pool size: 64 pages
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered (default)
PCI: Setting latency timer of device 0000:00:1c.0 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.0:pcie00]
Allocate Port Service[0000:00:1c.0:pcie02]
Allocate Port Service[0000:00:1c.0:pcie03]
PCI: Setting latency timer of device 0000:00:1c.3 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.3:pcie00]
Allocate Port Service[0000:00:1c.3:pcie02]
Allocate Port Service[0000:00:1c.3:pcie03]
PCI: Setting latency timer of device 0000:00:1c.4 to 64
assign_interrupt_mode Found MSI capability
Allocate Port Service[0000:00:1c.4:pcie00]
Allocate Port Service[0000:00:1c.4:pcie02]
Allocate Port Service[0000:00:1c.4:pcie03]
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
 Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing enabled
serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
00:06: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
RAMDISK driver initialized: 16 RAM disks of 8192K size 1024 blocksize
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 KBD port at 0x60,0x64 irq 1
mice: PS/2 mouse device common for all mice
TCP bic registered
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI No-Shortcut mode
Freeing unused kernel memory: 212k freed
input: AT Translated Set 2 keyboard as /class/input/input0
ACPI: Processor [CPU0] (supports 8 throttling states)
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device
is not present [20070126]
ACPI Exception (processor_core-0783): AE_NOT_FOUND, Processor Device
is not present [20070126]
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
SCSI subsystem initialized
USB Universal Host Controller Interface driver  v3.0
ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:00:1a.0 to 64
uhci_hcd 0000:00:1a.0: UHCI Host Controller
uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1a.0: irq 16, io base 0x0000e200
usb usb1: configuration #1 chosen from 1 choice
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
libata version 2.20 loaded.
Uniform Multi-Platform E-IDE driver Revision:  7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 18
PCI: Setting latency timer of device 0000:00:1a.1 to 64
uhci_hcd 0000:00:1a.1: UHCI Host Controller
uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1a.1: irq 18, io base 0x0000e600
usb usb2: configuration #1 chosen from 1 choice
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1a.2[C] -> GSI 18 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1a.2 to 64
uhci_hcd 0000:00: 1a.2: UHCI Host Controller
uhci_hcd 0000:00:1a.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1a.2: irq 19, io base 0x0000e000
usb usb3: configuration #1 chosen from 1 choice
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
 uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 4
uhci_hcd 0000:00:1d.0: irq 20, io base 0x0000e300
usb usb4: configuration #1 chosen from 1 choice
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
usb 1-1: new full speed USB device using uhci_hcd and address 2
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00: 1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 5
uhci_hcd 0000:00:1d.1: irq 17, io base 0x0000e400
usb usb5: configuration #1 chosen from 1 choice
hub 5-0:1.0: USB hub found
hub 5-0:1.0: 2 ports detected
usb 1-1: configuration #1 chosen from 1 choice
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1d.2 to 64
 uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 6
uhci_hcd 0000:00:1d.2: irq 19, io base 0x0000e500
usb usb6: configuration #1 chosen from 1 choice
 hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 20 (level, low) -> IRQ 21
skge 1.10 addr 0xf3000000 irq 21 chip Yukon rev 1
skge eth0: addr 00:05:5d:9e:0d:98
ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 19
PCI: Setting latency timer of device 0000:00:1a.7 to 64
ehci_hcd 0000:00:1a.7: EHCI Host Controller
ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 7
PCI: cache line size of 128 is not supported by device 0000:00:1a.7
ehci_hcd 0000:00:1a.7: irq 19, io mem 0xf4285000
ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb7: configuration #1 chosen from 1 choice
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 6 ports detected
Initializing USB Mass Storage driver...
scsi0 : SCSI emulation for USB Mass Storage devices
usbcore: registered new interface driver usb-storage
 USB Mass Storage support registered.
usb-storage: device found at 2
usb-storage: waiting for device to settle before scanning
ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 20
PCI: Setting latency timer of device 0000:00: 1d.7 to 64
ehci_hcd 0000:00:1d.7: EHCI Host Controller
ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 8
PCI: cache line size of 128 is not supported by device 0000:00:1d.7
ehci_hcd 0000:00: 1d.7: irq 20, io mem 0xf4284000
ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
usb usb8: configuration #1 chosen from 1 choice
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 6 ports detected
 ahci 0000:02:00.0: version 2.1
ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 17
usb 1-1: USB disconnect, address 2
usb 1-1: new full speed USB device using uhci_hcd and address 3
usb 1-1: configuration #1 chosen from 1 choice
scsi1 : SCSI emulation for USB Mass Storage devices
usb-storage: device found at 3
usb-storage: waiting for device to settle before scanning
PCI: Setting latency timer of device 0000:02:00.0 to 64
ahci 0000:02: 00.0: AHCI 0001.0000 32 slots 2 ports 3 Gbps 0x3 impl SATA mode
ahci 0000:02:00.0: flags: 64bit ncq pm led clo pmp pio slum part
ata1: SATA max UDMA/133 cmd 0xf888c100 ctl 0x00000000 bmdma 0x00000000 irq 17
ata2: SATA max UDMA/133 cmd 0xf888c180 ctl 0x00000000 bmdma 0x00000000 irq 17
scsi2 : ahci
ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata1.00: ATA-7: ST380815AS, 3.AAD, max UDMA/133
ata1.00: 156301488 sectors, multi 16: LBA48 NCQ (depth 31/32)
ata1.00: configured for UDMA/133
scsi3 : ahci
ata2: SATA link down (SStatus 0 SControl 300)
scsi 2:0:0:0: Direct-Access     ATA      ST380815AS       3.AA PQ: 0 ANSI: 5
r8169 Gigabit Ethernet driver 2.2LK-NAPI loaded
ACPI: PCI Interrupt 0000:03: 00.0[A] -> GSI 16 (level, low) -> IRQ 16
PCI: Setting latency timer of device 0000:03:00.0 to 64
eth0: RTL8168b/8111b at 0xf8858000, 00:1a:4d:51:77:3d, IRQ 16
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
 sda: Write Protect is off
sda: Mode Sense: 00 3a 00 00
SCSI device sda: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sda:<7>ata_piix 0000:00:1f.2: version 2.10ac1
ata_piix 0000:00: 1f.2: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.2[B] -> GSI 19 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00:1f.2 to 64
ata3: SATA max UDMA/133 cmd 0x000101f0 ctl 0x000103f6 bmdma 0x0001f000 irq 14
ata4: SATA max UDMA/133 cmd 0x00010170 ctl 0x00010376 bmdma 0x0001f008 irq 15
scsi4 : ata_piix
 sda1 sda2 < sda5 >
sd 2:0:0:0: Attached scsi disk sda
ata3.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
 ata3.00: 625140335 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.01: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata3.01: 625140335 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata3.00: configured for UDMA/133
ata3.01 : configured for UDMA/133
scsi5 : ata_piix
ata4.00: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata4.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.01: ATA-7: ST3320620AS, 3.AAK, max UDMA/133
ata4.01 : 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata4.00: configured for UDMA/133
ata4.01: configured for UDMA/133
scsi 4:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
SCSI device sdb: 625140335 512-byte hdwr sectors (320072 MB)
sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sdb: 625140335 512-byte hdwr sectors (320072 MB)
 sdb: Write Protect is off
sdb: Mode Sense: 00 3a 00 00
SCSI device sdb: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdb:
sd 4:0:0:0: Attached scsi disk sdb
scsi 4:0:1:0: Direct-Access     ATA      ST3320620AS       3.AA PQ: 0 ANSI: 5
SCSI device sdc: 625140335 512-byte hdwr sectors (320072 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sdc: 625140335 512-byte hdwr sectors (320072 MB)
sdc: Write Protect is off
sdc: Mode Sense: 00 3a 00 00
SCSI device sdc: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
  sdc: unknown partition table
sd 4:0:1:0: Attached scsi disk sdc
scsi 5:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
SCSI device sdd: 625142448 512-byte hdwr sectors (320073 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sdd: 625142448 512-byte hdwr sectors (320073 MB)
sdd: Write Protect is off
 sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdd: unknown partition table
sd 5:0:0:0: Attached scsi disk sdd
scsi 5:0:1:0: Direct-Access     ATA      ST3320620AS       3.AA PQ: 0 ANSI: 5
SCSI device sde: 625142448 512-byte hdwr sectors (320073 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sde: 625142448 512-byte hdwr sectors (320073 MB)
sde: Write Protect is off
sde: Mode Sense: 00 3a 00 00
SCSI device sde: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
  sde: unknown partition table
sd 5:0:1:0: Attached scsi disk sde
ata_piix 0000:00:1f.5: MAP [ P0 P2 P1 P3 ]
ACPI: PCI Interrupt 0000:00:1f.5[B] -> GSI 19 (level, low) -> IRQ 17
PCI: Setting latency timer of device 0000:00: 1f.5 to 64
ata5: SATA max UDMA/133 cmd 0x0001e800 ctl 0x0001e902 bmdma 0x0001ec00 irq 17
ata6: SATA max UDMA/133 cmd 0x0001ea00 ctl 0x0001eb02 bmdma 0x0001ec08 irq 17
scsi6 : ata_piix
ata5.00: ATA-7: ST3320620AS,  3.AAD, max UDMA/133
ata5.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata5.00: configured for UDMA/133
scsi7 : ata_piix
ata6.00: ATA-7: ST3320620AS, 3.AAC, max UDMA/133
ata6.00: 625142448 sectors, multi 16: LBA48 NCQ (depth 0/32)
ata6.00: configured for UDMA/133
scsi 6:0:0:0: Direct-Access     ATA      ST3320620AS      3.AA PQ: 0 ANSI: 5
SCSI device sdf: 625142448 512-byte hdwr sectors (320073 MB)
sdf: Write Protect is off
sdf: Mode Sense: 00 3a 00 00
SCSI device sdf: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sdf: 625142448 512-byte hdwr sectors (320073 MB)
sdf: Write Protect is off
sdf: Mode Sense: 00 3a 00 00
 SCSI device sdf: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
 sdf: unknown partition table
sd 6:0:0:0: Attached scsi disk sdf
scsi 7:0:0:0: Direct-Access     ATA      ST3320620AS       3.AA PQ: 0 ANSI: 5
SCSI device sdg: 625142448 512-byte hdwr sectors (320073 MB)
sdg: Write Protect is off
sdg: Mode Sense: 00 3a 00 00
SCSI device sdg: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
SCSI device sdg: 625142448 512-byte hdwr sectors (320073 MB)
sdg: Write Protect is off
sdg: Mode Sense: 00 3a 00 00
SCSI device sdg: write cache: enabled, read cache: enabled, doesn't
support DPO or FUA
  sdg: unknown partition table
sd 7:0:0:0: Attached scsi disk sdg
JMB363: IDE controller at PCI slot 0000:02:00.1
PCI: Enabling device 0000:02:00.1 (0000 -> 0001)
ACPI: PCI Interrupt 0000:02:00.1[B] -> GSI 16 (level, low) -> IRQ 16
JMB363: chipset revision 2
JMB363: 100% native mode on irq 16
PCI: Setting latency timer of device 0000:02:00.1 to 64
    ide0: BM-DMA at 0xb400-0xb407, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0xb408-0xb40f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
Probing IDE interface ide1...
device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
Attempting manual resume
 kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
usb-storage: device scan complete
scsi 1:0:0:0: CD-ROM            TEAC     CD-210PU         10A6 PQ: 0
ANSI: 0 CCS
sr0: scsi3-mmc drive: 10x/10x cd/rw xa/form2 cdda pop-up
Uniform CD-ROM driver Revision: 3.20
sr 1:0:0:0: Attached scsi CD-ROM sr0
sd 2:0:0:0: Attached scsi generic sg0 type 0
sd 4:0:0:0: Attached scsi generic sg1 type 0
sd 4:0:1:0: Attached scsi generic sg2 type 0
sd 5:0:0:0: Attached scsi generic sg3 type 0
sd 5:0:1:0: Attached scsi generic sg4 type 0
sd 6:0:0:0: Attached scsi generic sg5 type 0
sd 7:0:0:0: Attached scsi generic sg6 type 0
sr 1:0:0:0: Attached scsi generic sg7 type 5
Real Time Clock Driver v1.12ac
input: PC Speaker as /class/input/input1
ACPI: PCI Interrupt 0000:00:1f.3[C] -> GSI 18 (level, low) -> IRQ 19
parport: PnPBIOS parport detected.
parport0: PC-style at 0x378, irq 7 [PCSPP,TRISTATE]
ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
PCI: Setting latency timer of device 0000:00:1b.0 to 64
hda_codec: Unknown model for ALC882, trying auto-probe from BIOS...
Adding 3229024k swap on /dev/sda5.  Priority:-1 extents:1 across:3229024k
EXT3 FS on sda1, internal journal
loop: loaded (max 8 devices)
skge eth1: enabling interface
input: Power Button (FF) as /class/input/input2
ACPI: Power Button (FF) [PWRF]
input: Power Button (CM) as /class/input/input3
ACPI: Power Button (CM) [PWRB]
skge eth1: Link is up at 100 Mbps, full duplex, flow control both
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
eth1: no IPv6 routers present
md: md1 stopped.
md: bind<sde>
md: bind<sdg>
md: bind<sdf>
md: sdb has invalid sb, not importing!
md: md_import_device returned -22
md: bind<sdd>
md: md1 stopped.
md: unbind<sdd>
md: export_rdev(sdd)
md: unbind<sdf>
md: export_rdev(sdf)
md: unbind<sdg>
md: export_rdev(sdg)
md: unbind<sde>
md: export_rdev(sde)
md: md1 stopped.
md: md1 stopped.
md: md1 stopped.
md: md1 stopped.
md: bind<sde>
md: bind<sdg>
md: bind<sdf>
md: sdb has invalid sb, not importing!
md: md_import_device returned -22
md: bind<sdd>
md: md1 stopped.
md: unbind<sdd>
md: export_rdev(sdd)
md: unbind<sdf>
md: export_rdev(sdf)
md: unbind<sdg>
md: export_rdev(sdg)
md: unbind<sde>
md: export_rdev(sde)
md: md1 stopped.
md: bind<sde>
md: bind<sdg>
md: bind<sdf>
md: sdb has invalid sb, not importing!
md: md_import_device returned -22
md: bind<sdd>

-- 
-Sam "MeriX" Redfern

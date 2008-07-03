From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Veliciraptor HDD 3.0gbps but UDMA/100 on PCI-e controller?
Date: Thu, 3 Jul 2008 09:48:41 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0807030941510.30458@p34.internal.lan>
References: <alpine.DEB.1.10.0807030447040.12072@p34.internal.lan> <486CCB12.7040205@garzik.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <486CCB12.7040205@garzik.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids



On Thu, 3 Jul 2008, Jeff Garzik wrote:

> Justin Piszcz wrote:

> You need to show us the full dmesg.  We cannot see which controller is 
> applying limits here.
>
> You need to look at the controller's maximum, as that controls the drive 
> maximum (pasted from my personal workstation):
>
> scsi0 : ahci
> scsi1 : ahci
> scsi2 : ahci
> scsi3 : ahci
> ata1: SATA max UDMA/133 abar m1024@0x90404000 port 0x90404100 irq 507
> ata2: SATA max UDMA/133 abar m1024@0x90404000 port 0x90404180 irq 507
> ata3: SATA max UDMA/133 abar m1024@0x90404000 port 0x90404200 irq 507
> ata4: SATA max UDMA/133 abar m1024@0x90404000 port 0x90404280 irq 507
>
>
> scsi4 : sata_sil
> scsi5 : sata_sil
> scsi6 : sata_sil
> scsi7 : sata_sil
> ata5: SATA max UDMA/100 mmio m1024@0x9000c800 tf 0x9000c880 irq 17
> ata6: SATA max UDMA/100 mmio m1024@0x9000c800 tf 0x9000c8c0 irq 17
> ata7: SATA max UDMA/100 mmio m1024@0x9000c800 tf 0x9000ca80 irq 17
> ata8: SATA max UDMA/100 mmio m1024@0x9000c800 tf 0x9000cac0 irq 17
>
>
> See the UDMA difference?
>
> 	Jeff
>

So they are supposedly 3.0gbps SATA cards etc but why do they only have
a maxiumum negotiated rate of UDMA/100?

[    9.623682] scsi8 : sata_sil24
[    9.625622] scsi9 : sata_sil24
[    9.626608] ata9: SATA max UDMA/100 host m128@0xe0204000 port 0xe0200000 irq 19
[    9.627539] ata10: SATA max UDMA/100 host m128@0xe0204000 port 0xe0202000 irq 19

Also, another question:
How come I can dd if=/dev/sda of=/dev/null (for pretty much all 6 HDD on the
mainboard itself (115MiB/s+) per drive.

But when I stop those and do the same thing for the other 6 drives on PCI-e
x1 controllers (as shown in dmesg/previous lspci output) it does not
give that great of speed?

Example:

(one veliciraptor)

p34:~# dd if=/dev/sdi of=/dev/null bs=1M
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  0  1    160  45796 472120 5764072    0    0   249  1445  123   37  1  2 95  2
  0  1    160  47616 581944 5650376    0    0 109824     0  460 1705  0  4 74 22
  0  1    160  46236 692280 5540896    0    0 110336     0  555 2719  0  4 74 22
  0  1    160  46256 802616 5429316    0    0 110336    28  559 1961  0  3 75 22

(two veliciraptors)
p34:~# dd if=/dev/sdi of=/dev/null bs=1M
p34:~# dd if=/dev/sdj of=/dev/null bs=1M

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  1  2    160  44664 2829936 3399360    0    0 141568     0  581 1925  0  5 74 21
  0  2    160  45748 2970480 3258068    0    0 140544     0  563 2155  0  5 74 22
  0  2    160  47308 3110512 3116780    0    0 140032    68  717 2440  0  5 73 22
  0  2    160  45976 3251568 2976972    0    0 141056     0  559 1837  0  5 74 21
  0  2    160  46860 3392624 2835240    0    0 141056     0  615 2452  0  5 74 22

Is this a PCI-e bandwidth issue, a card issue or driver issue?

Each card has 2 ports on it and I can only get ~140MiB/s using two DDs.

-----------------

And the motherboard itself:

war@p34:~$ vmstat 1
procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
  0  1    160  47820 4021464 2219716    0    0   262  1442  122   37  1  2 95  2
  0  1    160  43520 4144600 2102228    0    0 123136     0  490 1759  0  4 74 22
  0  1    160  47244 4259032 1985600    0    0 114432     0  514 2293  0  3 74 23
  0  1    160  43696 4383348 1866868    0    0 124416     0  512 1707  0  4 74 22

Two veliciraptors:
  0  2    160  59988 5229656 1016484    0    0 125184     0 2041 2220  0  5 49 46
  0  3    160 273784 5371840 665372    0    0 142184     0 1946 2316  0  6 49 46
  1  3    160  45364 5612864 647376    0    0 241024     0 2422 3719  0  7 50 43
  1  1    160  45536 5858476 402584    0    0 245632     0 2199 3205  0  9 53 39
  1  1    160  45192 6034316 227940    0    0 220928    32 1485 4095  0  7 72 21

Three veliciraptors:
  2  2    160  44900 6168900 144008    0    0 364032     0 1448 4349  0 14 66 20
  1  2    160  46488 6206828 112312    0    0 369152     0 1457 4776  0 14 67 19
  1  3    160  44700 6226924 101916    0    0 337920    65 1420 4099  0 12 68 20
  0  3    160  47664 6232840 101776    0    0 363520     0 1425 4507  0 14 67 20

.. and so on ..

Why do I get such poor performance when utilizing more than 1 drive on a PCI-e
x1 card, it cannot even achieve more ~150MiB/s when two drives are being
read con-currently?

Ideas?

Full dmesg below:

[    0.000000] Linux version 2.6.25.9 (root@p34.internal.lan) (gcc version 4.3.1 (Debian 4.3.1-2) ) #6 SMP Sat Jun 28 13:07:55 EDT 2008
[    0.000000] Command line: auto BOOT_IMAGE=2.6.25.9-6 ro root=902
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
[    0.000000] end_pfn_map = 2277376
[    0.000000] DMI 2.4 present.
[    0.000000] ACPI: RSDP 000FE020, 0014 (r0 INTEL )
[    0.000000] ACPI: RSDT CF6FD038, 0050 (r1 INTEL  DG965WH       6CA       1000013)
[    0.000000] ACPI: FACP CF6FC000, 0074 (r1 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: DSDT CF6F7000, 442C (r1 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: FACS CF697000, 0040
[    0.000000] ACPI: APIC CF6F6000, 0078 (r1 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: WDDT CF6F5000, 0040 (r1 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: MCFG CF6F4000, 003C (r1 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: ASF! CF6F3000, 00A6 (r32 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: HPET CF6F2000, 0038 (r1 INTEL  DG965WH       6CA MSFT  1000013)
[    0.000000] ACPI: SSDT CF6F0000, 020C (r1 INTEL     CpuPm      6CA MSFT  1000013)
[    0.000000] ACPI: SSDT CF6EF000, 0175 (r1 INTEL   Cpu0Ist      6CA MSFT  1000013)
[    0.000000] ACPI: SSDT CF696000, 0175 (r1 INTEL   Cpu1Ist      6CA MSFT  1000013)
[    0.000000] ACPI: SSDT CF695000, 0175 (r1 INTEL   Cpu2Ist      6CA MSFT  1000013)
[    0.000000] ACPI: SSDT CF694000, 0175 (r1 INTEL   Cpu3Ist      6CA MSFT  1000013)
[    0.000000] Entering add_active_range(0, 0, 143) 0 entries of 256 used
[    0.000000] Entering add_active_range(0, 256, 849295) 1 entries of 256 used
[    0.000000] Entering add_active_range(0, 849308, 849465) 2 entries of 256 used
[    0.000000] Entering add_active_range(0, 849649, 849650) 3 entries of 256 used
[    0.000000] Entering add_active_range(0, 849663, 849664) 4 entries of 256 used
[    0.000000] Entering add_active_range(0, 1048576, 2277376) 5 entries of 256 used
[    0.000000] early res: 0 [0-fff] BIOS data page
[    0.000000] early res: 1 [6000-7fff] SMP_TRAMPOLINE
[    0.000000] early res: 2 [200000-7c93a7] TEXT DATA BSS
[    0.000000] early res: 3 [9a400-a03ff] EBDA
[    0.000000] early res: 4 [8000-11fff] PGTABLE
[    0.000000]  [ffffe20000000000-ffffe200001fffff] PMD ->ffff810001200000 on node 0
[    0.000000]  [ffffe20000200000-ffffe200003fffff] PMD ->ffff810001600000 on node 0
[    0.000000]  [ffffe20000400000-ffffe200005fffff] PMD ->ffff810001a00000 on node 0
[    0.000000]  [ffffe20000600000-ffffe200007fffff] PMD ->ffff810001e00000 on node 0
[    0.000000]  [ffffe20000800000-ffffe200009fffff] PMD ->ffff810002200000 on node 0
[    0.000000]  [ffffe20000a00000-ffffe20000bfffff] PMD ->ffff810002600000 on node 0
[    0.000000]  [ffffe20000c00000-ffffe20000dfffff] PMD ->ffff810002a00000 on node 0
[    0.000000]  [ffffe20000e00000-ffffe20000ffffff] PMD ->ffff810002e00000 on node 0
[    0.000000]  [ffffe20001000000-ffffe200011fffff] PMD ->ffff810003200000 on node 0
[    0.000000]  [ffffe20001200000-ffffe200013fffff] PMD ->ffff810003600000 on node 0
[    0.000000]  [ffffe20001400000-ffffe200015fffff] PMD ->ffff810003a00000 on node 0
[    0.000000]  [ffffe20001600000-ffffe200017fffff] PMD ->ffff810003e00000 on node 0
[    0.000000]  [ffffe20001800000-ffffe200019fffff] PMD ->ffff810004200000 on node 0
[    0.000000]  [ffffe20001a00000-ffffe20001bfffff] PMD ->ffff810004600000 on node 0
[    0.000000]  [ffffe20001c00000-ffffe20001dfffff] PMD ->ffff810004a00000 on node 0
[    0.000000]  [ffffe20001e00000-ffffe20001ffffff] PMD ->ffff810004e00000 on node 0
[    0.000000]  [ffffe20002000000-ffffe200021fffff] PMD ->ffff810005200000 on node 0
[    0.000000]  [ffffe20002200000-ffffe200023fffff] PMD ->ffff810005600000 on node 0
[    0.000000]  [ffffe20002400000-ffffe200025fffff] PMD ->ffff810005a00000 on node 0
[    0.000000]  [ffffe20002600000-ffffe200027fffff] PMD ->ffff810005e00000 on node 0
[    0.000000]  [ffffe20002800000-ffffe200029fffff] PMD ->ffff810006200000 on node 0
[    0.000000]  [ffffe20002a00000-ffffe20002bfffff] PMD ->ffff810006600000 on node 0
[    0.000000]  [ffffe20002c00000-ffffe20002dfffff] PMD ->ffff810006a00000 on node 0
[    0.000000]  [ffffe20002e00000-ffffe20002ffffff] PMD ->ffff810006e00000 on node 0
[    0.000000]  [ffffe20003000000-ffffe200031fffff] PMD ->ffff810007200000 on node 0
[    0.000000]  [ffffe20003200000-ffffe200033fffff] PMD ->ffff810007600000 on node 0
[    0.000000]  [ffffe20003400000-ffffe200035fffff] PMD ->ffff810007a00000 on node 0
[    0.000000]  [ffffe20003600000-ffffe200037fffff] PMD ->ffff810007e00000 on node 0
[    0.000000]  [ffffe20003800000-ffffe200039fffff] PMD ->ffff810008200000 on node 0
[    0.000000]  [ffffe20003a00000-ffffe20003bfffff] PMD ->ffff810008600000 on node 0
[    0.000000]  [ffffe20003c00000-ffffe20003dfffff] PMD ->ffff810008a00000 on node 0
[    0.000000]  [ffffe20003e00000-ffffe20003ffffff] PMD ->ffff810008e00000 on node 0
[    0.000000]  [ffffe20004000000-ffffe200041fffff] PMD ->ffff810009200000 on node 0
[    0.000000]  [ffffe20004200000-ffffe200043fffff] PMD ->ffff810009600000 on node 0
[    0.000000]  [ffffe20004400000-ffffe200045fffff] PMD ->ffff810009a00000 on node 0
[    0.000000]  [ffffe20004600000-ffffe200047fffff] PMD ->ffff810009e00000 on node 0
[    0.000000]  [ffffe20004800000-ffffe200049fffff] PMD ->ffff81000a200000 on node 0
[    0.000000]  [ffffe20004a00000-ffffe20004bfffff] PMD ->ffff81000a600000 on node 0
[    0.000000]  [ffffe20004c00000-ffffe20004dfffff] PMD ->ffff81000aa00000 on node 0
[    0.000000]  [ffffe20004e00000-ffffe20004ffffff] PMD ->ffff81000ae00000 on node 0
[    0.000000]  [ffffe20005000000-ffffe200051fffff] PMD ->ffff81000b200000 on node 0
[    0.000000]  [ffffe20005200000-ffffe200053fffff] PMD ->ffff81000b600000 on node 0
[    0.000000]  [ffffe20005400000-ffffe200055fffff] PMD ->ffff81000ba00000 on node 0
[    0.000000]  [ffffe20005600000-ffffe200057fffff] PMD ->ffff81000be00000 on node 0
[    0.000000]  [ffffe20005800000-ffffe200059fffff] PMD ->ffff81000c200000 on node 0
[    0.000000]  [ffffe20005a00000-ffffe20005bfffff] PMD ->ffff81000c600000 on node 0
[    0.000000]  [ffffe20005c00000-ffffe20005dfffff] PMD ->ffff81000ca00000 on node 0
[    0.000000]  [ffffe20005e00000-ffffe20005ffffff] PMD ->ffff81000ce00000 on node 0
[    0.000000]  [ffffe20006000000-ffffe200061fffff] PMD ->ffff81000d200000 on node 0
[    0.000000]  [ffffe20006200000-ffffe200063fffff] PMD ->ffff81000d600000 on node 0
[    0.000000]  [ffffe20006400000-ffffe200065fffff] PMD ->ffff81000da00000 on node 0
[    0.000000]  [ffffe20006600000-ffffe200067fffff] PMD ->ffff81000de00000 on node 0
[    0.000000]  [ffffe20006800000-ffffe200069fffff] PMD ->ffff81000e200000 on node 0
[    0.000000]  [ffffe20006a00000-ffffe20006bfffff] PMD ->ffff81000e600000 on node 0
[    0.000000]  [ffffe20006c00000-ffffe20006dfffff] PMD ->ffff81000ea00000 on node 0
[    0.000000]  [ffffe20006e00000-ffffe20006ffffff] PMD ->ffff81000ee00000 on node 0
[    0.000000]  [ffffe20007000000-ffffe200071fffff] PMD ->ffff81000f200000 on node 0
[    0.000000]  [ffffe20007200000-ffffe200073fffff] PMD ->ffff81000f600000 on node 0
[    0.000000]  [ffffe20007400000-ffffe200075fffff] PMD ->ffff81000fa00000 on node 0
[    0.000000]  [ffffe20007600000-ffffe200077fffff] PMD ->ffff81000fe00000 on node 0
[    0.000000]  [ffffe20007800000-ffffe200079fffff] PMD ->ffff810010200000 on node 0
[    0.000000]  [ffffe20007a00000-ffffe20007bfffff] PMD ->ffff810010600000 on node 0
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
[    0.000000]   DMA zone: 1502 pages reserved
[    0.000000]   DMA zone: 2425 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 14280 pages used for memmap
[    0.000000]   DMA32 zone: 831078 pages, LIFO batch:31
[    0.000000]   Normal zone: 16800 pages used for memmap
[    0.000000]   Normal zone: 1212000 pages, LIFO batch:31
[    0.000000]   Movable zone: 0 pages used for memmap
[    0.000000] ACPI: PM-Timer IO Port: 0x408
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
[    0.000000] Processor #0 (Bootup-CPU)
[    0.000000] ACPI: LAPIC (acpi_id[0x03] lapic_id[0x02] enabled)
[    0.000000] Processor #2
[    0.000000] ACPI: LAPIC (acpi_id[0x02] lapic_id[0x01] enabled)
[    0.000000] Processor #1
[    0.000000] ACPI: LAPIC (acpi_id[0x04] lapic_id[0x03] enabled)
[    0.000000] Processor #3
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] dfl dfl lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] dfl dfl lint[0x1])
[    0.000000] ACPI: IOAPIC (id[0x02] address[0xfec00000] gsi_base[0])
[    0.000000] IOAPIC[0]: apic_id 2, address 0xfec00000, GSI 0-23
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ2 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Setting APIC routing to flat
[    0.000000] ACPI: HPET id: 0x8086a201 base: 0xfed00000
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] Allocating PCI resources starting at d2000000 (gap: d0000000:20000000)
[    0.000000] PERCPU: Allocating 21960 bytes of per cpu data
[    0.000000] Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 2045503
[    0.000000] Kernel command line: auto BOOT_IMAGE=2.6.25.9-6 ro root=902
[    0.000000] Initializing CPU#0
[    0.000000] PID hash table entries: 4096 (order: 12, 32768 bytes)
[    0.000000] TSC calibrated against PM_TIMER
[    0.000001] time.c: Detected 2397.601 MHz processor.
[    0.000017] Console: colour dummy device 80x25
[    0.000019] console [tty0] enabled
[    0.000999] Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes)
[    0.000999] Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes)
[    0.000999] Checking aperture...
[    0.000999] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.000999] Placing software IO TLB between 0x11433000 - 0x15433000
[    0.000999] Memory: 8100044k/9109504k available (3999k kernel code, 211796k reserved, 1251k data, 256k init)
[    0.000999] CPA: page pool initialized 1 of 1 pages preallocated
[    0.000999] hpet clockevent registered
[    0.059992] Calibrating delay using timer specific routine.. 4797.82 BogoMIPS (lpj=2398913)
[    0.060036] Mount-cache hash table entries: 256
[    0.060139] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.060143] CPU: L2 cache: 4096K
[    0.060146] CPU: Physical Processor ID: 0
[    0.060148] CPU: Processor Core ID: 0
[    0.060154] CPU0: Thermal monitoring enabled (TM2)
[    0.060156] using mwait in idle threads.
[    0.060164] Freeing SMP alternatives: 35k freed
[    0.060183] ACPI: Core revision 20070126
[    0.077084] Using local APIC timer interrupts.
[    0.077989] APIC timer calibration result 16649988
[    0.077990] Detected 16.649 MHz APIC timer.
[    0.078080] Booting processor 1/4 APIC 0x2
[    0.000999] Initializing CPU#1
[    0.000999] Calibrating delay using timer specific routine.. 4986.79 BogoMIPS (lpj=2493399)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 2
[    0.000999] CPU1: Thermal monitoring enabled (TM2)
[    0.000999] Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.149517] checking TSC synchronization [CPU#0 -> CPU#1]: passed.
[    0.150050] Booting processor 2/4 APIC 0x1
[    0.000999] Initializing CPU#2
[    0.000999] Calibrating delay using timer specific routine.. 4795.93 BogoMIPS (lpj=2397966)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 1
[    0.000999] CPU2: Thermal monitoring enabled (TM2)
[    0.000999] Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.221506] checking TSC synchronization [CPU#0 -> CPU#2]: passed.
[    0.222056] Booting processor 3/4 APIC 0x3
[    0.000999] Initializing CPU#3
[    0.000999] Calibrating delay using timer specific routine.. 4794.98 BogoMIPS (lpj=2397491)
[    0.000999] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.000999] CPU: L2 cache: 4096K
[    0.000999] CPU: Physical Processor ID: 0
[    0.000999] CPU: Processor Core ID: 3
[    0.000999] CPU3: Thermal monitoring enabled (TM2)
[    0.000999] Intel(R) Core(TM)2 Quad CPU           @ 2.40GHz stepping 07
[    0.293411] checking TSC synchronization [CPU#0 -> CPU#3]: passed.
[    0.293961] Brought up 4 CPUs
[    0.294304] net_namespace: 880 bytes
[    0.294414] xor: automatically using best checksumming function: generic_sse
[    0.298955]    generic_sse:  8536.000 MB/sec
[    0.298957] xor: using function: generic_sse (8536.000 MB/sec)
[    0.299013] NET: Registered protocol family 16
[    0.299181] No dock devices found.
[    0.299286] ACPI: bus type pci registered
[    0.302992] PCI: Using MMCONFIG at f0000000 - f7ffffff
[    0.302995] PCI: Using configuration type 1
[    0.306186] ACPI: EC: Look up EC in DSDT
[    0.308136] ACPI: Interpreter enabled
[    0.308139] ACPI: (supports S0 S5)
[    0.308155] ACPI: Using IOAPIC for interrupt routing
[    0.312197] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.312920] pci 0000:00:1f.0: quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
[    0.312925] pci 0000:00:1f.0: quirk: region 0500-053f claimed by ICH6 GPIO
[    0.313707] PCI: Transparent bridge - 0000:00:1e.0
[    0.313738] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.314057] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P32_._PRT]
[    0.314298] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX0._PRT]
[    0.314388] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX1._PRT]
[    0.314478] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX2._PRT]
[    0.314567] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX3._PRT]
[    0.314656] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PEX4._PRT]
[    0.319233] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 7 9 10 *11 12)
[    0.319325] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 7 9 *10 11 12)
[    0.319409] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 9 10 *11 12)
[    0.319492] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 9 10 *11 12)
[    0.319575] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 *9 10 11 12)
[    0.319659] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 9 *10 11 12)
[    0.319742] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 *9 10 11 12)
[    0.319825] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 9 10 *11 12)
[    0.320052] Linux Plug and Play Support v0.97 (c) Adam Belay
[    0.320116] pnp: PnP ACPI init
[    0.320125] ACPI: bus type pnp registered
[    0.322652] pnp: PnP ACPI: found 11 devices
[    0.322656] ACPI: ACPI bus type pnp unregistered
[    0.322918] SCSI subsystem initialized
[    0.322954] libata version 3.00 loaded.
[    0.323071] usbcore: registered new interface driver usbfs
[    0.323140] usbcore: registered new interface driver hub
[    0.323200] usbcore: registered new device driver usb
[    0.323448] PCI: Using ACPI for IRQ routing
[    0.323453] PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a report
[    0.327963] PCI-GART: No AMD northbridge found.
[    0.327970] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0
[    0.327976] hpet0: 3 64-bit timers, 14318180 Hz
[    0.333963] system 00:01: iomem range 0xf0000000-0xf7ffffff could not be reserved
[    0.333969] system 00:01: iomem range 0xfed13000-0xfed13fff has been reserved
[    0.333974] system 00:01: iomem range 0xfed14000-0xfed17fff has been reserved
[    0.333978] system 00:01: iomem range 0xfed18000-0xfed18fff has been reserved
[    0.333984] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.333988] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.333992] system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.333997] system 00:01: iomem range 0xfed45000-0xfed99fff has been reserved
[    0.334001] system 00:01: iomem range 0xc0000-0xdffff has been reserved
[    0.334005] system 00:01: iomem range 0xe0000-0xfffff could not be reserved
[    0.334015] system 00:06: ioport range 0x500-0x53f has been reserved
[    0.334019] system 00:06: ioport range 0x400-0x47f has been reserved
[    0.334023] system 00:06: ioport range 0x360-0x361 has been reserved
[    0.334027] system 00:06: ioport range 0x680-0x6ff has been reserved
[    0.334593] PCI: Bridge: 0000:00:1c.0
[    0.334596]   IO window: disabled.
[    0.334602]   MEM window: disabled.
[    0.334606]   PREFETCH window: disabled.
[    0.334613] PCI: Bridge: 0000:00:1c.1
[    0.334616]   IO window: 5000-5fff
[    0.334622]   MEM window: 0xe0400000-0xe04fffff
[    0.334626]   PREFETCH window: disabled.
[    0.334633] PCI: Bridge: 0000:00:1c.2
[    0.334637]   IO window: 4000-4fff
[    0.334642]   MEM window: 0xe0300000-0xe03fffff
[    0.334647]   PREFETCH window: 0x00000000e0700000-0x00000000e07fffff
[    0.334655] PCI: Bridge: 0000:00:1c.3
[    0.334658]   IO window: 3000-3fff
[    0.334663]   MEM window: 0xe0200000-0xe02fffff
[    0.334668]   PREFETCH window: 0x00000000e0800000-0x00000000e08fffff
[    0.334696] PCI: Bridge: 0000:00:1c.4
[    0.334698]   IO window: 2000-2fff
[    0.334702]   MEM window: 0xe0100000-0xe01fffff
[    0.334716]   PREFETCH window: 0x00000000e0900000-0x00000000e09fffff
[    0.334722] PCI: Bridge: 0000:00:1e.0
[    0.334725]   IO window: 1000-1fff
[    0.334729]   MEM window: 0xe0000000-0xe00fffff
[    0.334733]   PREFETCH window: 0x00000000e0a00000-0x00000000e0afffff
[    0.334753] ACPI: PCI Interrupt 0000:00:1c.0[A] -> GSI 17 (level, low) -> IRQ 17
[    0.334759] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.334773] ACPI: PCI Interrupt 0000:00:1c.1[B] -> GSI 16 (level, low) -> IRQ 16
[    0.334779] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.334792] ACPI: PCI Interrupt 0000:00:1c.2[C] -> GSI 18 (level, low) -> IRQ 18
[    0.334798] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.334811] ACPI: PCI Interrupt 0000:00:1c.3[D] -> GSI 19 (level, low) -> IRQ 19
[    0.334817] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.334830] ACPI: PCI Interrupt 0000:00:1c.4[A] -> GSI 17 (level, low) -> IRQ 17
[    0.334835] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    0.334843] PCI: Setting latency timer of device 0000:00:1e.0 to 64
[    0.334891] NET: Registered protocol family 2
[    0.346005] IP route cache hash table entries: 262144 (order: 9, 2097152 bytes)
[    0.346599] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[    0.348185] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    0.348773] TCP: Hash tables configured (established 262144 bind 65536)
[    0.348777] TCP reno registered
[    0.057531] Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
[    0.057631] SGI XFS with large block/inode numbers, no debug enabled
[    0.057991] async_tx: api initialized (sync-only)
[    0.057991] io scheduler noop registered
[    0.057999] io scheduler cfq registered (default)
[    0.058006] pci 0000:00:02.0: Boot video device
[    0.058440] PCI: Setting latency timer of device 0000:00:1c.0 to 64
[    0.058466] assign_interrupt_mode Found MSI capability
[    0.058495] Allocate Port Service[0000:00:1c.0:pcie00]
[    0.058551] Allocate Port Service[0000:00:1c.0:pcie02]
[    0.058607] Allocate Port Service[0000:00:1c.0:pcie03]
[    0.058693] PCI: Setting latency timer of device 0000:00:1c.1 to 64
[    0.058723] assign_interrupt_mode Found MSI capability
[    0.058755] Allocate Port Service[0000:00:1c.1:pcie00]
[    0.058794] Allocate Port Service[0000:00:1c.1:pcie02]
[    0.058832] Allocate Port Service[0000:00:1c.1:pcie03]
[    0.058915] PCI: Setting latency timer of device 0000:00:1c.2 to 64
[    0.058945] assign_interrupt_mode Found MSI capability
[    0.058978] Allocate Port Service[0000:00:1c.2:pcie00]
[    0.058991] Allocate Port Service[0000:00:1c.2:pcie02]
[    0.059005] Allocate Port Service[0000:00:1c.2:pcie03]
[    0.059109] PCI: Setting latency timer of device 0000:00:1c.3 to 64
[    0.059133] assign_interrupt_mode Found MSI capability
[    0.059159] Allocate Port Service[0000:00:1c.3:pcie00]
[    0.059213] Allocate Port Service[0000:00:1c.3:pcie02]
[    0.059261] Allocate Port Service[0000:00:1c.3:pcie03]
[    0.059344] PCI: Setting latency timer of device 0000:00:1c.4 to 64
[    0.059374] assign_interrupt_mode Found MSI capability
[    0.059406] Allocate Port Service[0000:00:1c.4:pcie00]
[    0.059447] Allocate Port Service[0000:00:1c.4:pcie02]
[    0.059490] Allocate Port Service[0000:00:1c.4:pcie03]
[    0.059922] vesafb: framebuffer at 0xd0000000, mapped to 0xffffc20008100000, using 2560k, total 7616k
[    0.059929] vesafb: mode is 1280x1024x8, linelength=1280, pages=4
[    0.059932] vesafb: scrolling: redraw
[    0.059936] vesafb: Pseudocolor: size=8:8:8:8, shift=0:0:0:0
[    0.070645] Console: switching to colour frame buffer device 160x64
[    0.081321] fb0: VESA VGA frame buffer device
[    0.081468] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[    0.081584] ACPI: Power Button (FF) [PWRF]
[    0.081713] input: Sleep Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0E:00/input/input1
[    0.081832] ACPI: Sleep Button (CM) [SLPB]
[    0.093068] Real Time Clock Driver v1.12ac
[    0.093233] hpet_resources: 0xfed00000 is busy
[    0.093288] Linux agpgart interface v0.103
[    0.093372] agpgart: Detected an Intel 965G Chipset.
[    0.094496] agpgart: Detected 7676K stolen memory.
[    0.107095] agpgart: AGP aperture is 256M @ 0xd0000000
[    0.107308] [drm] Initialized drm 1.1.0 20060810
[    0.107381] ACPI: PCI Interrupt 0000:00:02.0[A] -> GSI 16 (level, low) -> IRQ 16
[    0.107471] PCI: Setting latency timer of device 0000:00:02.0 to 64
[    0.107574] [drm] Initialized i915 1.6.0 20060119 on minor 0
[    0.108072] loop: module loaded
[    0.108194] Intel(R) PRO/1000 Network Driver - version 7.3.20-k2-NAPI
[    0.108281] Copyright (c) 1999-2006 Intel Corporation.
[    0.108380] ACPI: PCI Interrupt 0000:06:00.0[A] -> GSI 21 (level, low) -> IRQ 21
[    0.388944] Switched to high resolution mode on CPU 1
[    0.208970] Switched to high resolution mode on CPU 3
[    0.296959] Switched to high resolution mode on CPU 2
[    0.500926] Switched to high resolution mode on CPU 0
[    0.356438] e1000: 0000:06:00.0: e1000_probe: (PCI:33MHz:32-bit) 00:07:e9:29:37:db
[    0.382220] e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
[    0.382328] ACPI: PCI Interrupt 0000:06:01.0[A] -> GSI 22 (level, low) -> IRQ 22
[    0.644506] e1000: 0000:06:01.0: e1000_probe: (PCI:33MHz:32-bit) 00:0e:0c:00:cd:b1
[    0.792085] e1000: eth1: e1000_probe: Intel(R) PRO/1000 Network Connection
[    0.792214] e1000e: Intel(R) PRO/1000 Network Driver - 0.2.0
[    0.792291] e1000e: Copyright (c) 1999-2007 Intel Corporation.
[    0.792394] ACPI: PCI Interrupt 0000:00:19.0[A] -> GSI 20 (level, low) -> IRQ 20
[    0.792523] PCI: Setting latency timer of device 0000:00:19.0 to 64
[    0.892197] eth2: (PCI Express:2.5GB/s:Width x1) 00:19:d1:6e:9d:43
[    0.892281] eth2: Intel(R) PRO/1000 Network Connection
[    0.892370] eth2: MAC: 4, PHY: 6, PBA No: ffffff-0ff
[    0.892483] console [netcon0] enabled
[    0.892554] netconsole: network logging started
[    0.892659] Driver 'sd' needs updating - please use bus_type methods
[    0.892819] Driver 'sr' needs updating - please use bus_type methods
[    0.892916] ahci 0000:00:1f.2: version 3.0
[    0.892929] ACPI: PCI Interrupt 0000:00:1f.2[A] -> GSI 19 (level, low) -> IRQ 19
[    1.893735] ahci 0000:00:1f.2: AHCI 0001.0100 32 slots 6 ports 3 Gbps 0x3f impl SATA mode
[    1.893846] ahci 0000:00:1f.2: flags: 64bit ncq sntf led clo pio slum part 
[    1.893940] PCI: Setting latency timer of device 0000:00:1f.2 to 64
[    1.894186] scsi0 : ahci
[    1.894310] scsi1 : ahci
[    1.894424] scsi2 : ahci
[    1.894531] scsi3 : ahci
[    1.894805] scsi4 : ahci
[    1.895817] scsi5 : ahci
[    1.897843] ata1: SATA max UDMA/133 abar m2048@0xe0625000 port 0xe0625100 irq 378
[    1.898713] ata2: SATA max UDMA/133 abar m2048@0xe0625000 port 0xe0625180 irq 378
[    1.899713] ata3: SATA max UDMA/133 abar m2048@0xe0625000 port 0xe0625200 irq 378
[    1.900712] ata4: SATA max UDMA/133 abar m2048@0xe0625000 port 0xe0625280 irq 378
[    1.901712] ata5: SATA max UDMA/133 abar m2048@0xe0625000 port 0xe0625300 irq 378
[    1.902712] ata6: SATA max UDMA/133 abar m2048@0xe0625000 port 0xe0625380 irq 378
[    2.360648] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.678244] ata1.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    2.678594] ata1.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    2.684566] ata1.00: configured for UDMA/133
[    2.841574] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.155052] ata2.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    3.155522] ata2.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.161448] ata2.00: configured for UDMA/133
[    3.323502] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    3.631655] ata3.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    3.632449] ata3.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    3.638326] ata3.00: configured for UDMA/133
[    3.805428] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.111323] ata4.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    4.111376] ata4.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.117045] ata4.00: configured for UDMA/133
[    4.396340] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    4.590130] ata5.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    4.590303] ata5.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    4.596212] ata5.00: configured for UDMA/133
[    4.880265] ata6: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    5.066729] ata6.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    5.067231] ata6.00: 586072368 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    5.074323] ata6.00: configured for UDMA/133
[    4.805306] scsi 0:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    4.806410] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
[    4.807279] sd 0:0:0:0: [sda] Write Protect is off
[    4.808270] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.808286] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.809304] sd 0:0:0:0: [sda] 586072368 512-byte hardware sectors (300069 MB)
[    4.810277] sd 0:0:0:0: [sda] Write Protect is off
[    4.811270] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    4.811284] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    4.812270]  sda: sda1 sda2 sda3
[    5.105469] sd 0:0:0:0: [sda] Attached SCSI disk
[    5.107314] scsi 1:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    5.108367] sd 1:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
[    5.110232] sd 1:0:0:0: [sdb] Write Protect is off
[    5.111224] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.111239] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.112255] sd 1:0:0:0: [sdb] 586072368 512-byte hardware sectors (300069 MB)
[    5.113231] sd 1:0:0:0: [sdb] Write Protect is off
[    5.114223] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    5.114240] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.115223]  sdb: sdb1 sdb2 sdb3
[    5.183396] sd 1:0:0:0: [sdb] Attached SCSI disk
[    5.184341] scsi 2:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    5.186340] sd 2:0:0:0: [sdc] 586072368 512-byte hardware sectors (300069 MB)
[    5.187220] sd 2:0:0:0: [sdc] Write Protect is off
[    5.188212] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.188227] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.189239] sd 2:0:0:0: [sdc] 586072368 512-byte hardware sectors (300069 MB)
[    5.190219] sd 2:0:0:0: [sdc] Write Protect is off
[    5.191212] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    5.191226] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.192211]  sdc: sdc1
[    5.195323] sd 2:0:0:0: [sdc] Attached SCSI disk
[    5.196332] scsi 3:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    5.197339] sd 3:0:0:0: [sdd] 586072368 512-byte hardware sectors (300069 MB)
[    5.198218] sd 3:0:0:0: [sdd] Write Protect is off
[    5.199211] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    5.199225] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.200238] sd 3:0:0:0: [sdd] 586072368 512-byte hardware sectors (300069 MB)
[    5.201217] sd 3:0:0:0: [sdd] Write Protect is off
[    5.202210] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    5.202224] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.203210]  sdd: sdd1
[    5.210211] sd 3:0:0:0: [sdd] Attached SCSI disk
[    5.211332] scsi 4:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    5.212335] sd 4:0:0:0: [sde] 586072368 512-byte hardware sectors (300069 MB)
[    5.213216] sd 4:0:0:0: [sde] Write Protect is off
[    5.214209] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    5.214223] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.215236] sd 4:0:0:0: [sde] 586072368 512-byte hardware sectors (300069 MB)
[    5.216215] sd 4:0:0:0: [sde] Write Protect is off
[    5.217208] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    5.217222] sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.218208]  sde: sde1
[    5.226218] sd 4:0:0:0: [sde] Attached SCSI disk
[    5.228273] scsi 5:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    5.229334] sd 5:0:0:0: [sdf] 586072368 512-byte hardware sectors (300069 MB)
[    5.230213] sd 5:0:0:0: [sdf] Write Protect is off
[    5.231206] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    5.231220] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.232233] sd 5:0:0:0: [sdf] 586072368 512-byte hardware sectors (300069 MB)
[    5.233212] sd 5:0:0:0: [sdf] Write Protect is off
[    5.234205] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    5.234219] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    5.235205]  sdf: sdf1
[    5.241316] sd 5:0:0:0: [sdf] Attached SCSI disk
[    5.242403] sata_sil24 0000:03:00.0: version 1.1
[    5.242433] ACPI: PCI Interrupt 0000:03:00.0[A] -> GSI 18 (level, low) -> IRQ 18
[    5.243247] PCI: Setting latency timer of device 0000:03:00.0 to 64
[    5.244260] scsi6 : sata_sil24
[    5.246300] scsi7 : sata_sil24
[    5.248258] ata7: SATA max UDMA/100 host m128@0xe0304000 port 0xe0300000 irq 18
[    5.250204] ata8: SATA max UDMA/100 host m128@0xe0304000 port 0xe0302000 irq 18
[    7.226923] ata7: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    7.398350] ata7.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    7.398877] ata7.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    7.404877] ata7.00: configured for UDMA/100
[    9.387594] ata8: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[    9.554626] ata8.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[    9.555548] ata8.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[    9.561837] ata8.00: configured for UDMA/100
[    9.562618] scsi 6:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    9.563683] sd 6:0:0:0: [sdg] 586072368 512-byte hardware sectors (300069 MB)
[    9.564565] sd 6:0:0:0: [sdg] Write Protect is off
[    9.565547] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    9.565561] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.566576] sd 6:0:0:0: [sdg] 586072368 512-byte hardware sectors (300069 MB)
[    9.567553] sd 6:0:0:0: [sdg] Write Protect is off
[    9.568546] sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
[    9.568560] sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.569547]  sdg: sdg1
[    9.605655] sd 6:0:0:0: [sdg] Attached SCSI disk
[    9.606670] scsi 7:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[    9.607679] sd 7:0:0:0: [sdh] 586072368 512-byte hardware sectors (300069 MB)
[    9.608547] sd 7:0:0:0: [sdh] Write Protect is off
[    9.609540] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    9.609555] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.610566] sd 7:0:0:0: [sdh] 586072368 512-byte hardware sectors (300069 MB)
[    9.611547] sd 7:0:0:0: [sdh] Write Protect is off
[    9.612540] sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
[    9.612554] sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    9.613539]  sdh: sdh1
[    9.620653] sd 7:0:0:0: [sdh] Attached SCSI disk
[    9.621632] ACPI: PCI Interrupt 0000:04:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[    9.623570] PCI: Setting latency timer of device 0000:04:00.0 to 64
[    9.623682] scsi8 : sata_sil24
[    9.625622] scsi9 : sata_sil24
[    9.626608] ata9: SATA max UDMA/100 host m128@0xe0204000 port 0xe0200000 irq 19
[    9.627539] ata10: SATA max UDMA/100 host m128@0xe0204000 port 0xe0202000 irq 19
[   11.680246] ata9: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   11.779515] ata9.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   11.780210] ata9.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   11.788067] ata9.00: configured for UDMA/100
[   13.845917] ata10: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   13.941152] ata10.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   13.941882] ata10.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   13.948166] ata10.00: configured for UDMA/100
[   13.948927] scsi 8:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   13.950941] sd 8:0:0:0: [sdi] 586072368 512-byte hardware sectors (300069 MB)
[   13.951887] sd 8:0:0:0: [sdi] Write Protect is off
[   13.952880] sd 8:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[   13.952894] sd 8:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.953909] sd 8:0:0:0: [sdi] 586072368 512-byte hardware sectors (300069 MB)
[   13.954886] sd 8:0:0:0: [sdi] Write Protect is off
[   13.955879] sd 8:0:0:0: [sdi] Mode Sense: 00 3a 00 00
[   13.955893] sd 8:0:0:0: [sdi] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.956879]  sdi: unknown partition table
[   13.987948] sd 8:0:0:0: [sdi] Attached SCSI disk
[   13.989001] scsi 9:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   13.990007] sd 9:0:0:0: [sdj] 586072368 512-byte hardware sectors (300069 MB)
[   13.990881] sd 9:0:0:0: [sdj] Write Protect is off
[   13.991874] sd 9:0:0:0: [sdj] Mode Sense: 00 3a 00 00
[   13.991888] sd 9:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.992900] sd 9:0:0:0: [sdj] 586072368 512-byte hardware sectors (300069 MB)
[   13.993881] sd 9:0:0:0: [sdj] Write Protect is off
[   13.994873] sd 9:0:0:0: [sdj] Mode Sense: 00 3a 00 00
[   13.994888] sd 9:0:0:0: [sdj] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   13.995873]  sdj: sdj1
[   14.001988] sd 9:0:0:0: [sdj] Attached SCSI disk
[   14.002946] ACPI: PCI Interrupt 0000:05:00.0[A] -> GSI 16 (level, low) -> IRQ 16
[   14.003908] PCI: Setting latency timer of device 0000:05:00.0 to 64
[   14.004042] scsi10 : sata_sil24
[   14.004976] scsi11 : sata_sil24
[   14.005944] ata11: SATA max UDMA/100 host m128@0xe0104000 port 0xe0100000 irq 16
[   14.006873] ata12: SATA max UDMA/100 host m128@0xe0104000 port 0xe0102000 irq 16
[   16.136568] ata11: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   16.155682] ata11.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   16.156545] ata11.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   16.162949] ata11.00: configured for UDMA/100
[   18.298239] ata12: SATA link up 3.0 Gbps (SStatus 123 SControl 0)
[   18.313208] ata12.00: ATA-8: WDC WD3000GLFS-01F8U0, 03.03V01, max UDMA/133
[   18.313217] ata12.00: 586072368 sectors, multi 16: LBA48 NCQ (depth 31/32)
[   18.319286] ata12.00: configured for UDMA/100
[   18.320263] scsi 10:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   18.321354] sd 10:0:0:0: [sdk] 586072368 512-byte hardware sectors (300069 MB)
[   18.322223] sd 10:0:0:0: [sdk] Write Protect is off
[   18.323216] sd 10:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[   18.323230] sd 10:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.324257] sd 10:0:0:0: [sdk] 586072368 512-byte hardware sectors (300069 MB)
[   18.325222] sd 10:0:0:0: [sdk] Write Protect is off
[   18.326215] sd 10:0:0:0: [sdk] Mode Sense: 00 3a 00 00
[   18.326229] sd 10:0:0:0: [sdk] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.327215]  sdk: sdk1
[   18.363321] sd 10:0:0:0: [sdk] Attached SCSI disk
[   18.364339] scsi 11:0:0:0: Direct-Access     ATA      WDC WD3000GLFS-0 03.0 PQ: 0 ANSI: 5
[   18.365337] sd 11:0:0:0: [sdl] 586072368 512-byte hardware sectors (300069 MB)
[   18.366216] sd 11:0:0:0: [sdl] Write Protect is off
[   18.367209] sd 11:0:0:0: [sdl] Mode Sense: 00 3a 00 00
[   18.367223] sd 11:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.369234] sd 11:0:0:0: [sdl] 586072368 512-byte hardware sectors (300069 MB)
[   18.370215] sd 11:0:0:0: [sdl] Write Protect is off
[   18.371208] sd 11:0:0:0: [sdl] Mode Sense: 00 3a 00 00
[   18.371222] sd 11:0:0:0: [sdl] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[   18.372208]  sdl: sdl1
[   18.380318] sd 11:0:0:0: [sdl] Attached SCSI disk
[   18.381337] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 17 (level, low) -> IRQ 17
[   18.383219] PCI: Setting latency timer of device 0000:02:00.0 to 64
[   18.383293] scsi12 : pata_marvell
[   18.384309] scsi13 : pata_marvell
[   18.385277] ata13: PATA max UDMA/100 cmd 0x5018 ctl 0x5024 bmdma 0x5000 irq 17
[   18.386206] ata14: DUMMY
[   18.460247] BAR5:00:00 01:7F 02:22 03:CA 04:00 05:00 06:00 07:00 08:00 09:00 0A:00 0B:00 0C:01 0D:00 0E:00 0F:00 
[   18.766524] ata13.00: ATAPI: _NEC DVD_RW ND-3520A, 1.04, max UDMA/33
[   18.924501] ata13.00: configured for UDMA/33
[   18.862808] scsi 12:0:0:0: CD-ROM            _NEC     DVD_RW ND-3520A  1.04 PQ: 0 ANSI: 5
[   18.866659] sr0: scsi3-mmc drive: 48x/48x writer cd/rw xa/form2 cdda tray
[   18.867133] Uniform CD-ROM driver Revision: 3.20
[   18.868258] sr 12:0:0:0: Attached scsi CD-ROM sr0
[   18.868701] ACPI: PCI Interrupt 0000:06:03.0[A] -> GSI 19 (level, low) -> IRQ 19
[   18.920169] ohci1394: fw-host0: OHCI-1394 1.1 (PCI): IRQ=[19]  MMIO=[e0084000-e00847ff]  Max Packet=[2048]  IR/IT contexts=[4/8]
[   18.921282] ACPI: PCI Interrupt 0000:00:1a.7[C] -> GSI 18 (level, low) -> IRQ 18
[   18.922130] PCI: Setting latency timer of device 0000:00:1a.7 to 64
[   18.922132] ehci_hcd 0000:00:1a.7: EHCI Host Controller
[   18.923206] ehci_hcd 0000:00:1a.7: new USB bus registered, assigned bus number 1
[   18.928444] ehci_hcd 0000:00:1a.7: debug port 1
[   18.929126] PCI: cache line size of 32 is not supported by device 0000:00:1a.7
[   18.929130] ehci_hcd 0000:00:1a.7: irq 18, io mem 0xe0625c00
[   18.940125] ehci_hcd 0000:00:1a.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   18.941334] usb usb1: configuration #1 chosen from 1 choice
[   18.942190] hub 1-0:1.0: USB hub found
[   18.943126] hub 1-0:1.0: 4 ports detected
[   19.045246] ACPI: PCI Interrupt 0000:00:1d.7[A] -> GSI 23 (level, low) -> IRQ 23
[   19.046110] PCI: Setting latency timer of device 0000:00:1d.7 to 64
[   19.046112] ehci_hcd 0000:00:1d.7: EHCI Host Controller
[   19.047174] ehci_hcd 0000:00:1d.7: new USB bus registered, assigned bus number 2
[   19.052030] ehci_hcd 0000:00:1d.7: debug port 1
[   19.052107] PCI: cache line size of 32 is not supported by device 0000:00:1d.7
[   19.052114] ehci_hcd 0000:00:1d.7: irq 23, io mem 0xe0625800
[   19.063107] ehci_hcd 0000:00:1d.7: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[   19.065161] usb usb2: configuration #1 chosen from 1 choice
[   19.067104] hub 2-0:1.0: USB hub found
[   19.068105] hub 2-0:1.0: 6 ports detected
[   19.170235] USB Universal Host Controller Interface driver v3.0
[   19.172114] ACPI: PCI Interrupt 0000:00:1a.0[A] -> GSI 16 (level, low) -> IRQ 16
[   19.173090] PCI: Setting latency timer of device 0000:00:1a.0 to 64
[   19.173093] uhci_hcd 0000:00:1a.0: UHCI Host Controller
[   19.174156] uhci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 3
[   19.175103] uhci_hcd 0000:00:1a.0: irq 16, io base 0x000060c0
[   19.176246] usb usb3: configuration #1 chosen from 1 choice
[   19.177151] hub 3-0:1.0: USB hub found
[   19.178089] hub 3-0:1.0: 2 ports detected
[   19.280199] ACPI: PCI Interrupt 0000:00:1a.1[B] -> GSI 21 (level, low) -> IRQ 21
[   19.281073] PCI: Setting latency timer of device 0000:00:1a.1 to 64
[   19.281075] uhci_hcd 0000:00:1a.1: UHCI Host Controller
[   19.282136] uhci_hcd 0000:00:1a.1: new USB bus registered, assigned bus number 4
[   19.283091] uhci_hcd 0000:00:1a.1: irq 21, io base 0x000060a0
[   19.284224] usb usb4: configuration #1 chosen from 1 choice
[   19.285134] hub 4-0:1.0: USB hub found
[   19.286072] hub 4-0:1.0: 2 ports detected
[   19.459057] hub 2-0:1.0: unable to enumerate USB device on port 1
[   19.388175] ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 23 (level, low) -> IRQ 23
[   19.389056] PCI: Setting latency timer of device 0000:00:1d.0 to 64
[   19.389059] uhci_hcd 0000:00:1d.0: UHCI Host Controller
[   19.390121] uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 5
[   19.391070] uhci_hcd 0000:00:1d.0: irq 23, io base 0x00006080
[   19.392212] usb usb5: configuration #1 chosen from 1 choice
[   19.393117] hub 5-0:1.0: USB hub found
[   19.394056] hub 5-0:1.0: 2 ports detected
[   19.667021] hub 2-0:1.0: unable to enumerate USB device on port 4
[   19.496163] ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 19
[   19.497040] PCI: Setting latency timer of device 0000:00:1d.1 to 64
[   19.497042] uhci_hcd 0000:00:1d.1: UHCI Host Controller
[   19.498104] uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 6
[   19.499054] uhci_hcd 0000:00:1d.1: irq 19, io base 0x00006060
[   19.501102] usb usb6: configuration #1 chosen from 1 choice
[   19.502103] hub 6-0:1.0: USB hub found
[   19.503039] hub 6-0:1.0: 2 ports detected
[   19.605144] ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 18
[   19.606023] PCI: Setting latency timer of device 0000:00:1d.2 to 64
[   19.606026] uhci_hcd 0000:00:1d.2: UHCI Host Controller
[   19.607093] uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 7
[   19.609037] uhci_hcd 0000:00:1d.2: irq 18, io base 0x00006040
[   19.610180] usb usb7: configuration #1 chosen from 1 choice
[   19.611092] hub 7-0:1.0: USB hub found
[   19.612022] hub 7-0:1.0: 2 ports detected
[   19.888981] usb 5-1: new low speed USB device using uhci_hcd and address 2
[   19.714159] Initializing USB Mass Storage driver...
[   19.830416] usb 5-1: configuration #1 chosen from 1 choice
[   20.027100] ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0090270001c5be9f]
[   20.039959] usb 6-2: new full speed USB device using uhci_hcd and address 2
[   20.199972] usb 6-2: configuration #1 chosen from 1 choice
[   20.206898] hub 6-2:1.0: USB hub found
[   20.207419] hub 6-2:1.0: 3 ports detected
[   20.491809] usb 6-2.1: new full speed USB device using uhci_hcd and address 3
[   20.617913] usb 6-2.1: configuration #1 chosen from 1 choice
[   20.804762] usb 6-2.2: new low speed USB device using uhci_hcd and address 4
[   20.924863] usb 6-2.2: configuration #1 chosen from 1 choice
[   20.931789] usbcore: registered new interface driver usb-storage
[   20.931825] USB Mass Storage support registered.
[   20.932992] PNP: No PS/2 controller found. Probing ports directly.
[   20.936818] serio: i8042 KBD port at 0x60,0x64 irq 1
[   20.937820] serio: i8042 AUX port at 0x60,0x64 irq 12
[   20.938892] mice: PS/2 mouse device common for all mice
[   21.270698] input: PC Speaker as /devices/platform/pcspkr/input/input2
[   21.350186] coretemp coretemp.0: Using relative temperature scale!
[   21.350866] coretemp coretemp.1: Using relative temperature scale!
[   21.351896] coretemp coretemp.2: Using relative temperature scale!
[   21.352866] coretemp coretemp.3: Using relative temperature scale!
[   21.354792] md: raid0 personality registered for level 0
[   21.355754] md: raid1 personality registered for level 1
[   21.373756] raid6: int64x1   2277 MB/s
[   21.391750] raid6: int64x2   3000 MB/s
[   21.409760] raid6: int64x4   2789 MB/s
[   21.427751] raid6: int64x8   2089 MB/s
[   21.445746] raid6: sse2x1    3730 MB/s
[   21.463742] raid6: sse2x2    4281 MB/s
[   21.481739] raid6: sse2x4    6664 MB/s
[   21.482735] raid6: using algorithm sse2x4 (6664 MB/s)
[   21.483735] md: raid6 personality registered for level 6
[   21.484735] md: raid5 personality registered for level 5
[   21.485734] md: raid4 personality registered for level 4
[   21.486797] usbcore: registered new interface driver hiddev
[   21.873080] hiddev96: USB HID v1.00 Device [        UPS] on usb-0000:00:1d.0-1
[   21.876924] input: Dell Dell USB Keyboard Hub as /devices/pci0000:00/0000:00:1d.1/usb6/6-2/6-2.1/6-2.1:1.0/input/input3
[   21.881679] input: USB HID v1.10 Keyboard [Dell Dell USB Keyboard Hub] on usb-0000:00:1d.1-2.1
[   21.888676] input: Dell Dell USB Keyboard Hub as /devices/pci0000:00/0000:00:1d.1/usb6/6-2/6-2.1/6-2.1:1.1/input/input4
[   21.893677] input: USB HID v1.10 Device [Dell Dell USB Keyboard Hub] on usb-0000:00:1d.1-2.1
[   21.907820] input: USB Optical Mouse as /devices/pci0000:00/0000:00:1d.1/usb6/6-2/6-2.2/6-2.2:1.0/input/input5
[   21.912715] input: USB HID v1.11 Mouse [USB Optical Mouse] on usb-0000:00:1d.1-2.2
[   21.913728] usbcore: registered new interface driver usbhid
[   21.914680] drivers/hid/usbhid/hid-core.c: v2.6:USB HID core driver
[   21.915740] Advanced Linux Sound Architecture Driver Version 1.0.16rc2 (Thu Jan 31 16:40:16 2008 UTC).
[   21.917751] ACPI: PCI Interrupt 0000:00:1b.0[A] -> GSI 22 (level, low) -> IRQ 22
[   21.918683] PCI: Setting latency timer of device 0000:00:1b.0 to 64
[   21.956239] ALSA device list:
[   21.956663]   #0: HDA Intel at 0xe0620000 irq 22
[   21.957692] u32 classifier
[   21.958662]     Actions configured 
[   21.959708] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[   21.961754] ip_tables: (C) 2000-2006 Netfilter Core Team
[   21.962682] TCP cubic registered
[   21.963679] NET: Registered protocol family 1
[   21.964671] NET: Registered protocol family 17
[   21.965874] RPC: Registered udp transport module.
[   21.966662] RPC: Registered tcp transport module.
[   21.968046] md: Autodetecting RAID arrays.
[   22.110445] md: Scanned 15 and added 15 devices.
[   22.110639] md: autorun ...
[   22.111639] md: considering sdl1 ...
[   22.112643] md:  adding sdl1 ...
[   22.113641] md:  adding sdk1 ...
[   22.114641] md:  adding sdj1 ...
[   22.115641] md:  adding sdh1 ...
[   22.116641] md:  adding sdg1 ...
[   22.117641] md:  adding sdf1 ...
[   22.118640] md:  adding sde1 ...
[   22.119640] md:  adding sdd1 ...
[   22.120640] md:  adding sdc1 ...
[   22.121639] md: sdb3 has different UUID to sdl1
[   22.122639] md: sdb2 has different UUID to sdl1
[   22.123638] md: sdb1 has different UUID to sdl1
[   22.124638] md: sda3 has different UUID to sdl1
[   22.125638] md: sda2 has different UUID to sdl1
[   22.126638] md: sda1 has different UUID to sdl1
[   22.127718] md: created md3
[   22.128637] md: bind<sdc1>
[   22.129643] md: bind<sdd1>
[   22.130642] md: bind<sde1>
[   22.131642] md: bind<sdf1>
[   22.132643] md: bind<sdg1>
[   22.133642] md: bind<sdh1>
[   22.134641] md: bind<sdj1>
[   22.135641] md: bind<sdk1>
[   22.136641] md: bind<sdl1>
[   22.137641] md: running: <sdl1><sdk1><sdj1><sdh1><sdg1><sdf1><sde1><sdd1><sdc1>
[   22.138657] raid5: device sdl1 operational as raid disk 9
[   22.139635] raid5: device sdk1 operational as raid disk 8
[   22.140635] raid5: device sdj1 operational as raid disk 7
[   22.141635] raid5: device sdh1 operational as raid disk 5
[   22.142634] raid5: device sdg1 operational as raid disk 4
[   22.143634] raid5: device sdf1 operational as raid disk 3
[   22.144634] raid5: device sde1 operational as raid disk 2
[   22.145634] raid5: device sdd1 operational as raid disk 1
[   22.146634] raid5: device sdc1 operational as raid disk 0
[   22.148239] raid5: allocated 10574kB for md3
[   22.148634] raid5: raid level 5 set md3 active with 9 out of 10 devices, algorithm 2
[   22.149633] RAID5 conf printout:
[   22.150633]  --- rd:10 wd:9
[   22.151633]  disk 0, o:1, dev:sdc1
[   22.152633]  disk 1, o:1, dev:sdd1
[   22.153633]  disk 2, o:1, dev:sde1
[   22.154633]  disk 3, o:1, dev:sdf1
[   22.155632]  disk 4, o:1, dev:sdg1
[   22.156632]  disk 5, o:1, dev:sdh1
[   22.157632]  disk 7, o:1, dev:sdj1
[   22.158632]  disk 8, o:1, dev:sdk1
[   22.159632]  disk 9, o:1, dev:sdl1
[   22.160710] md: considering sdb3 ...
[   22.161635] md:  adding sdb3 ...
[   22.162633] md: sdb2 has different UUID to sdb3
[   22.163633] md: sdb1 has different UUID to sdb3
[   22.165633] md:  adding sda3 ...
[   22.166632] md: sda2 has different UUID to sdb3
[   22.167632] md: sda1 has different UUID to sdb3
[   22.168717] md: created md2
[   22.169631] md: bind<sda3>
[   22.170637] md: bind<sdb3>
[   22.171636] md: running: <sdb3><sda3>
[   22.172707] raid1: raid set md2 active with 2 out of 2 mirrors
[   22.173697] md: considering sdb2 ...
[   22.174632] md:  adding sdb2 ...
[   22.175631] md: sdb1 has different UUID to sdb2
[   22.176632] md:  adding sda2 ...
[   22.177630] md: sda1 has different UUID to sdb2
[   22.178707] md: created md1
[   22.179629] md: bind<sda2>
[   22.180635] md: bind<sdb2>
[   22.181634] md: running: <sdb2><sda2>
[   22.182704] raid1: raid set md1 active with 2 out of 2 mirrors
[   22.184630] md: considering sdb1 ...
[   22.185630] md:  adding sdb1 ...
[   22.186630] md:  adding sda1 ...
[   22.187628] md: created md0
[   22.188628] md: bind<sda1>
[   22.189634] md: bind<sdb1>
[   22.190633] md: running: <sdb1><sda1>
[   22.191712] raid1: raid set md0 active with 2 out of 2 mirrors
[   22.192687] md: ... autorun DONE.
[   22.231171] UDF-fs: No VRS found
[   22.231967] Filesystem "md2": Disabling barriers, not supported by the underlying device
[   22.232622] XFS: correcting sb_features alignment problem
[   22.246156] XFS mounting filesystem md2
[   22.350580] Ending clean XFS mount for filesystem: md2
[   22.350609] VFS: Mounted root (xfs filesystem) readonly.
[   22.351612] Freeing unused kernel memory: 256k freed
[   24.183088] udev: renamed network interface eth0_rename to eth1
[   25.408803] Adding 16787768k swap on /dev/md0.  Priority:-1 extents:1 across:16787768k
[   25.513012] Filesystem "md2": Disabling barriers, not supported by the underlying device
[   27.718413] kjournald starting.  Commit interval 5 seconds
[   27.302434] EXT3 FS on md1, internal journal
[   27.302439] EXT3-fs: mounted filesystem with ordered data mode.
[   27.310218] Filesystem "md3": Disabling barriers, not supported by the underlying device
[   27.310976] XFS mounting filesystem md3
[   27.449375] Ending clean XFS mount for filesystem: md3
[   29.310914] e1000: eth1: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
[   29.471022] e1000: eth2: e1000_watchdog: NIC Link is Up 100 Mbps Full Duplex, Flow Control: RX
[   31.048381] eth0: Link is Up 1000 Mbps Full Duplex, Flow Control: RX/TX
[   34.302057] warning: `named' uses 32-bit capabilities (legacy support in use)

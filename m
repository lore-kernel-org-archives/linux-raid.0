From: Darko Luketic <darko@luketic.de>
Subject: Re: RAID10 with 2 drives auto-assembled as RAID1
Date: Sat, 5 Nov 2016 22:10:46 +0100
Message-ID: <fdfd254f-bdcf-80a7-2265-893c8ee781fc@luketic.de>
References: <0487f9a4-c04a-8a4d-78ad-0191995d4be9@luketic.de>
 <57ce55da-fadc-db02-289e-db44bf6fb7d7@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57ce55da-fadc-db02-289e-db44bf6fb7d7@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok Phil,

sorry for that.

In the meantime I tried to use mdadm with the --build option.
mdadm --build --level=10 --raid-devices=2 --chunk=64 /dev/md0 /dev/sde1 
/dev/sde2

after about 1% I stopped it and did the same with just /dev/sde and 
/dev/sdf because I remembered I had used the whole drives previously but 
that wasn't that case here -> stopped quickly.

Both times I used e2fsck /dev/md0 -n without success.

I also tried mke2fs -n to find out the superblock copies, without success.

The I created a raid10 because the manpage says: "but the content of the 
device is left otherwise untouched" and waited for about 40% resync, 
checking md0 with hexdump, then rebooted to install a new system, 
because pxe booting is a long process and the risk of the old system 
again auto-assembling the array as RAID1 was there.

So now when I boot a new installation the RAID10 is assembled but not 
resyncing (auto read-only).

Regarding syslogs of the last working assembly, those don't exist 
anymore. The old OS was replaced by a new installation.
Last good assembly was approx. Nov 04 2016 ~ 1400 CET.



# mdadm -E /dev/sde1

/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 7306a1c3:bec6f242:2d17bc6d:17afa5c7
            Name : arch:0
   Creation Time : Sat Nov  5 17:58:30 2016
      Raid Level : raid10
    Raid Devices : 2

  Avail Dev Size : 3906764943 (1862.89 GiB 2000.26 GB)
      Array Size : 1953382400 (1862.89 GiB 2000.26 GB)
   Used Dev Size : 3906764800 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=143 sectors
           State : active
     Device UUID : 91f5e09a:fb8c5d17:e3f052e4:fec979fc

Internal Bitmap : 8 sectors from superblock
     Update Time : Sat Nov  5 19:21:43 2016
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : c546f079 - correct
          Events : 979

          Layout : near=2
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)


-


# mdadm -E /dev/sdf1
/dev/sdf1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : 7306a1c3:bec6f242:2d17bc6d:17afa5c7
            Name : arch:0
   Creation Time : Sat Nov  5 17:58:30 2016
      Raid Level : raid10
    Raid Devices : 2

  Avail Dev Size : 3906764943 (1862.89 GiB 2000.26 GB)
      Array Size : 1953382400 (1862.89 GiB 2000.26 GB)
   Used Dev Size : 3906764800 (1862.89 GiB 2000.26 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262056 sectors, after=143 sectors
           State : active
     Device UUID : f0e3d531:98ce389c:1bed4139:5417791d

Internal Bitmap : 8 sectors from superblock
     Update Time : Sat Nov  5 19:21:43 2016
   Bad Block Log : 512 entries available at offset 72 sectors
        Checksum : 57056a03 - correct
          Events : 979

          Layout : near=2
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AA ('A' == active, '.' == missing, 'R' == replacing)

-

# ./lsdrv
PCI [ahci] 00:17.0 SATA controller: Intel Corporation Sunrise Point-H 
SATA controller [AHCI mode] (rev 31)
├scsi 0:0:0:0 ATA      Samsung SSD 840  {S12RNEAD329899T}
│└sda 238.47g [8:0] Partitioned (gpt)
│ ├sda1 300.00m [8:1] ntfs 'Wiederherstellung' {C268192968191E2B}
│ ├sda2 100.00m [8:2] vfat {3220-6E38}
│ ├sda3 128.00m [8:3] Empty/Unknown
│ ├sda4 237.52g [8:4] ntfs {5CC02A08C029E8CA}
│ └sda5 450.00m [8:5] ntfs {48963645963633B2}
├scsi 1:0:0:0 ATA      Samsung SSD 840  {S12PNEAD320071X}
│└sdb 119.24g [8:16] Partitioned (gpt)
│ ├sdb1 256.00m [8:17] vfat {6B67-1A2D}
│ └sdb2 118.99g [8:18] ext4 {eb75a1fd-f602-4312-b9ea-44c53b27faf7}
│  └Mounted as /dev/sdb2 @ /
├scsi 2:0:0:0 ATA      Samsung SSD 840  {S1D9NSAF642954E}
│└sdc 931.51g [8:32] Partitioned (gpt)
│ ├sdc1 128.00m [8:33] Empty/Unknown
│ └sdc2 931.39g [8:34] ntfs '1TB' {80F86A9DF86A90E8}
├scsi 3:0:0:0 ATA      ST4000DM000-1F21 {Z300CW2F}
│└sdd 3.64t [8:48] Partitioned (gpt)
│ ├sdd1 128.00m [8:49] Empty/Unknown
│ └sdd2 3.64t [8:50] ntfs {F2166E73166E38AD}
├scsi 4:0:0:0 ATA      TOSHIBA DT01ACA2 {13QH679AS}
│└sde 1.82t [8:64] Partitioned (gpt)
│ └sde1 1.82t [8:65] MD raid10,near2 (0/2) (w/ sdf1) in_sync 'arch:0' 
{7306a1c3-bec6-f242-2d17-bc6d17afa5c7}
│  └md127 1.82t [9:127] MD v1.2 raid10,near2 (2) read-auto, 512k Chunk 
{7306a1c3:bec6f242:2d17bc6d:17afa5c7}
│                       Empty/Unknown
└scsi 5:0:0:0 ATA      TOSHIBA DT01ACA2 {13QH4MDAS}
  └sdf 1.82t [8:80] Partitioned (gpt)
   └sdf1 1.82t [8:81] MD raid10,near2 (1/2) (w/ sde1) in_sync 'arch:0' 
{7306a1c3-bec6-f242-2d17-bc6d17afa5c7}
    └md127 1.82t [9:127] MD v1.2 raid10,near2 (2) read-auto, 512k Chunk 
{7306a1c3:bec6f242:2d17bc6d:17afa5c7}
                         Empty/Unknown
PCI [ahci] 03:00.0 SATA controller: ASMedia Technology Inc. ASM1062 
Serial ATA Controller (rev 02)
├scsi 6:x:x:x [Empty]
└scsi 7:x:x:x [Empty]

-

# dmesg
[    0.000000] microcode: microcode updated early to revision 0x9e, date 
= 2016-06-22
[    0.000000] Linux version 4.8.6-1-ARCH (builduser@tobias) (gcc 
version 6.2.1 20160830 (GCC) ) #1 SMP PREEMPT Mon Oct 31 18:51:30 CET 2016
[    0.000000] Command line: BOOT_IMAGE=/boot/vmlinuz-linux 
root=UUID=eb75a1fd-f602-4312-b9ea-44c53b27faf7 rw quiet
[    0.000000] x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating 
point registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds 
registers'
[    0.000000] x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
[    0.000000] x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]: 256
[    0.000000] x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]: 64
[    0.000000] x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]: 64
[    0.000000] x86/fpu: Enabled xstate features 0x1f, context size is 
960 bytes, using 'compacted' format.
[    0.000000] x86/fpu: Using 'eager' FPU context switches.
[    0.000000] e820: BIOS-provided physical RAM map:
[    0.000000] BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] usable
[    0.000000] BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000059000-0x000000000009efff] usable
[    0.000000] BIOS-e820: [mem 0x000000000009f000-0x000000000009ffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000000100000-0x000000006df83fff] usable
[    0.000000] BIOS-e820: [mem 0x000000006df84000-0x000000006df84fff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000006df85000-0x000000006dfcefff] 
reserved
[    0.000000] BIOS-e820: [mem 0x000000006dfcf000-0x000000006e026fff] usable
[    0.000000] BIOS-e820: [mem 0x000000006e027000-0x000000006ed17fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x000000006ed18000-0x000000006ed2dfff] usable
[    0.000000] BIOS-e820: [mem 0x000000006ed2e000-0x000000006ed93fff] 
type 20
[    0.000000] BIOS-e820: [mem 0x000000006ed94000-0x000000006f9cbfff] 
reserved
[    0.000000] BIOS-e820: [mem 0x000000006f9cc000-0x000000006ff99fff] 
ACPI NVS
[    0.000000] BIOS-e820: [mem 0x000000006ff9a000-0x000000006ffccfff] 
ACPI data
[    0.000000] BIOS-e820: [mem 0x000000006ffcd000-0x000000006fffffff] usable
[    0.000000] BIOS-e820: [mem 0x0000000070000000-0x00000000700fffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] 
reserved
[    0.000000] BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] 
reserved
[    0.000000] BIOS-e820: [mem 0x0000000100000000-0x0000000fffffffff] usable
[    0.000000] NX (Execute Disable) protection: active
[    0.000000] efi: EFI v2.40 by American Megatrends
[    0.000000] efi:  ESRT=0x6f5c6018  ACPI=0x6ff1e000  ACPI 
2.0=0x6ff1e000  SMBIOS=0xf05e0  MPS=0xfc960
[    0.000000] esrt: Reserving ESRT space from 0x000000006f5c6018 to 
0x000000006f5c6050.
[    0.000000] SMBIOS 2.8 present.
[    0.000000] DMI: Gigabyte Technology Co., Ltd. To be filled by 
O.E.M./X170-Extreme ECC, BIOS F1 02/18/2016
[    0.000000] e820: update [mem 0x00000000-0x00000fff] usable ==> reserved
[    0.000000] e820: remove [mem 0x000a0000-0x000fffff] usable
[    0.000000] e820: last_pfn = 0x1000000 max_arch_pfn = 0x400000000
[    0.000000] MTRR default type: write-back
[    0.000000] MTRR fixed ranges enabled:
[    0.000000]   00000-9FFFF write-back
[    0.000000]   A0000-BFFFF uncachable
[    0.000000]   C0000-FFFFF write-protect
[    0.000000] MTRR variable ranges enabled:
[    0.000000]   0 base 0080000000 mask 7F80000000 uncachable
[    0.000000]   1 base 0078000000 mask 7FF8000000 uncachable
[    0.000000]   2 base 0074000000 mask 7FFC000000 uncachable
[    0.000000]   3 base 0072000000 mask 7FFE000000 uncachable
[    0.000000]   4 base 0071000000 mask 7FFF000000 uncachable
[    0.000000]   5 base 0070800000 mask 7FFF800000 uncachable
[    0.000000]   6 disabled
[    0.000000]   7 disabled
[    0.000000]   8 disabled
[    0.000000]   9 disabled
[    0.000000] x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB WC  UC- WT
[    0.000000] e820: last_pfn = 0x70000 max_arch_pfn = 0x400000000
[    0.000000] found SMP MP-table at [mem 0x000fcbe0-0x000fcbef] mapped 
at [ffff8800000fcbe0]
[    0.000000] Scanning 1 areas for low memory corruption
[    0.000000] Base memory trampoline at [ffff880000096000] 96000 size 24576
[    0.000000] Using GB pages for direct mapping
[    0.000000] BRK [0x01b4d000, 0x01b4dfff] PGTABLE
[    0.000000] BRK [0x01b4e000, 0x01b4efff] PGTABLE
[    0.000000] BRK [0x01b4f000, 0x01b4ffff] PGTABLE
[    0.000000] BRK [0x01b50000, 0x01b50fff] PGTABLE
[    0.000000] BRK [0x01b51000, 0x01b51fff] PGTABLE
[    0.000000] BRK [0x01b52000, 0x01b52fff] PGTABLE
[    0.000000] RAMDISK: [mem 0x3733f000-0x37996fff]
[    0.000000] ACPI: Early table checksum verification disabled
[    0.000000] ACPI: RSDP 0x000000006FF1E000 000024 (v02 ALASKA)
[    0.000000] ACPI: XSDT 0x000000006FF1E0A0 0000C4 (v01 ALASKA A M I    
01072009 AMI  00010013)
[    0.000000] ACPI: FACP 0x000000006FF40CD0 00010C (v05 ALASKA A M I    
01072009 AMI  00010013)
[    0.000000] ACPI: DSDT 0x000000006FF1E200 022ACC (v02 ALASKA A M I    
01072009 INTL 20120913)
[    0.000000] ACPI: FACS 0x000000006FF99F80 000040
[    0.000000] ACPI: APIC 0x000000006FF40DE0 0000BC (v03 ALASKA A M I    
01072009 AMI  00010013)
[    0.000000] ACPI: FPDT 0x000000006FF40EA0 000044 (v01 ALASKA A M I    
01072009 AMI  00010013)
[    0.000000] ACPI: FIDT 0x000000006FF40EE8 00009C (v01 ALASKA A M I    
01072009 AMI  00010013)
[    0.000000] ACPI: MCFG 0x000000006FF40F88 00003C (v01 ALASKA A M I    
01072009 MSFT 00000097)
[    0.000000] ACPI: HPET 0x000000006FF40FC8 000038 (v01 ALASKA A M I    
01072009 AMI. 0005000B)
[    0.000000] ACPI: SSDT 0x000000006FF41000 00036D (v01 SataRe SataTabl 
00001000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000006FF41370 000490 (v02 Intel PerfTune 
00001000 INTL 20120913)
[    0.000000] ACPI: LPIT 0x000000006FF41800 000094 (v01 INTEL SKL      
00000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x000000006FF41898 000248 (v02 INTEL sensrhub 
00000000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000006FF41AE0 002BAE (v02 INTEL PtidDevc 
00001000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000006FF44690 000C45 (v02 INTEL Ther_Rvp 
00001000 INTL 20120913)
[    0.000000] ACPI: DBGP 0x000000006FF452D8 000034 (v01 INTEL           
00000000 MSFT 0000005F)
[    0.000000] ACPI: DBG2 0x000000006FF45310 000054 (v00 INTEL           
00000000 MSFT 0000005F)
[    0.000000] ACPI: SSDT 0x000000006FF45368 002103 (v02 INTEL xh_rvp10 
00000000 INTL 20120913)
[    0.000000] ACPI: SSDT 0x000000006FF47470 005384 (v02 SaSsdt SaSsdt   
00003000 INTL 20120913)
[    0.000000] ACPI: UEFI 0x000000006FF4C7F8 000042 (v01 ALASKA A M I    
00000000      00000000)
[    0.000000] ACPI: SSDT 0x000000006FF4C840 000E58 (v02 CpuRef CpuSsdt  
00003000 INTL 20120913)
[    0.000000] ACPI: DMAR 0x000000006FF4D698 000070 (v01 INTEL SKL      
00000001 INTL 00000001)
[    0.000000] ACPI: ASF! 0x000000006FF4D708 0000A5 (v32 INTEL HCG     
00000001 TFSM 000F4240)
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] No NUMA configuration found
[    0.000000] Faking a node at [mem 0x0000000000000000-0x0000000fffffffff]
[    0.000000] NODE_DATA(0) allocated [mem 0xfffff9000-0xfffffdfff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
[    0.000000]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
[    0.000000]   Normal   [mem 0x0000000100000000-0x0000000fffffffff]
[    0.000000]   Device   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000000001000-0x0000000000057fff]
[    0.000000]   node   0: [mem 0x0000000000059000-0x000000000009efff]
[    0.000000]   node   0: [mem 0x0000000000100000-0x000000006df83fff]
[    0.000000]   node   0: [mem 0x000000006dfcf000-0x000000006e026fff]
[    0.000000]   node   0: [mem 0x000000006ed18000-0x000000006ed2dfff]
[    0.000000]   node   0: [mem 0x000000006ffcd000-0x000000006fffffff]
[    0.000000]   node   0: [mem 0x0000000100000000-0x0000000fffffffff]
[    0.000000] Initmem setup node 0 [mem 
0x0000000000001000-0x0000000fffffffff]
[    0.000000] On node 0 totalpages: 16179138
[    0.000000]   DMA zone: 64 pages used for memmap
[    0.000000]   DMA zone: 28 pages reserved
[    0.000000]   DMA zone: 3997 pages, LIFO batch:0
[    0.000000]   DMA32 zone: 6977 pages used for memmap
[    0.000000]   DMA32 zone: 446501 pages, LIFO batch:31
[    0.000000]   Normal zone: 245760 pages used for memmap
[    0.000000]   Normal zone: 15728640 pages, LIFO batch:31
[    0.000000] ACPI: PM-Timer IO Port: 0x1808
[    0.000000] ACPI: Local APIC address 0xfee00000
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
[    0.000000] ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
[    0.000000] IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI 
0-119
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
[    0.000000] ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
[    0.000000] ACPI: IRQ0 used by override.
[    0.000000] ACPI: IRQ9 used by override.
[    0.000000] Using ACPI (MADT) for SMP configuration information
[    0.000000] ACPI: HPET id: 0x8086a701 base: 0xfed00000
[    0.000000] smpboot: Allowing 8 CPUs, 0 hotplug CPUs
[    0.000000] PM: Registered nosave memory: [mem 0x00000000-0x00000fff]
[    0.000000] PM: Registered nosave memory: [mem 0x00058000-0x00058fff]
[    0.000000] PM: Registered nosave memory: [mem 0x0009f000-0x0009ffff]
[    0.000000] PM: Registered nosave memory: [mem 0x000a0000-0x000fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x6df84000-0x6df84fff]
[    0.000000] PM: Registered nosave memory: [mem 0x6df85000-0x6dfcefff]
[    0.000000] PM: Registered nosave memory: [mem 0x6e027000-0x6ed17fff]
[    0.000000] PM: Registered nosave memory: [mem 0x6ed2e000-0x6ed93fff]
[    0.000000] PM: Registered nosave memory: [mem 0x6ed94000-0x6f9cbfff]
[    0.000000] PM: Registered nosave memory: [mem 0x6f9cc000-0x6ff99fff]
[    0.000000] PM: Registered nosave memory: [mem 0x6ff9a000-0x6ffccfff]
[    0.000000] PM: Registered nosave memory: [mem 0x70000000-0x700fffff]
[    0.000000] PM: Registered nosave memory: [mem 0x70100000-0xdfffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xe0000000-0xefffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xf0000000-0xfdffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe000000-0xfe010fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfe011000-0xfebfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec00000-0xfec00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfec01000-0xfedfffff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee00000-0xfee00fff]
[    0.000000] PM: Registered nosave memory: [mem 0xfee01000-0xfeffffff]
[    0.000000] PM: Registered nosave memory: [mem 0xff000000-0xffffffff]
[    0.000000] e820: [mem 0x70100000-0xdfffffff] available for PCI devices
[    0.000000] Booting paravirtualized kernel on bare hardware
[    0.000000] clocksource: refined-jiffies: mask: 0xffffffff 
max_cycles: 0xffffffff, max_idle_ns: 6370452778343963 ns
[    0.000000] setup_percpu: NR_CPUS:128 nr_cpumask_bits:128 
nr_cpu_ids:8 nr_node_ids:1
[    0.000000] percpu: Embedded 35 pages/cpu @ffff880fffc00000 s103128 
r8192 d32040 u262144
[    0.000000] pcpu-alloc: s103128 r8192 d32040 u262144 alloc=1*2097152
[    0.000000] pcpu-alloc: [0] 0 1 2 3 4 5 6 7
[    0.000000] Built 1 zonelists in Node order, mobility grouping on.  
Total pages: 15926309
[    0.000000] Policy zone: Normal
[    0.000000] Kernel command line: BOOT_IMAGE=/boot/vmlinuz-linux 
root=UUID=eb75a1fd-f602-4312-b9ea-44c53b27faf7 rw quiet
[    0.000000] PID hash table entries: 4096 (order: 3, 32768 bytes)
[    0.000000] Calgary: detecting Calgary via BIOS EBDA area
[    0.000000] Calgary: Unable to locate Rio Grande table in EBDA - bailing!
[    0.000000] Memory: 63544900K/64716552K available (6130K kernel code, 
1051K rwdata, 1912K rodata, 1256K init, 1036K bss, 1171652K reserved, 0K 
cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] Preemptible hierarchical RCU implementation.
[    0.000000]     Build-time adjustment of leaf fanout to 64.
[    0.000000]     RCU restricting CPUs from NR_CPUS=128 to nr_cpu_ids=8.
[    0.000000] RCU: Adjusting geometry for rcu_fanout_leaf=64, nr_cpu_ids=8
[    0.000000] NR_IRQS:8448 nr_irqs:2048 16
[    0.000000] spurious 8259A interrupt: IRQ7.
[    0.000000] Console: colour dummy device 80x25
[    0.000000] console [tty0] enabled
[    0.000000] clocksource: hpet: mask: 0xffffffff max_cycles: 
0xffffffff, max_idle_ns: 79635855245 ns
[    0.000000] hpet clockevent registered
[    0.000000] tsc: Detected 3600.000 MHz processor
[    0.000027] Calibrating delay loop (skipped), value calculated using 
timer frequency.. 7202.00 BogoMIPS (lpj=12000000)
[    0.000029] pid_max: default: 32768 minimum: 301
[    0.000046] ACPI: Core revision 20160422
[    0.024530] ACPI: 9 ACPI AML tables successfully acquired and loaded
[    0.025246] Security Framework initialized
[    0.025246] Yama: becoming mindful.
[    0.027070] Dentry cache hash table entries: 8388608 (order: 14, 
67108864 bytes)
[    0.034236] Inode-cache hash table entries: 4194304 (order: 13, 
33554432 bytes)
[    0.037336] Mount-cache hash table entries: 131072 (order: 8, 1048576 
bytes)
[    0.037363] Mountpoint-cache hash table entries: 131072 (order: 8, 
1048576 bytes)
[    0.037633] CPU: Physical Processor ID: 0
[    0.037633] CPU: Processor Core ID: 0
[    0.037637] mce: CPU supports 10 MCE banks
[    0.037643] CPU0: Thermal monitoring enabled (TM1)
[    0.037655] process: using mwait in idle threads
[    0.037657] Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
[    0.037657] Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
[    0.037879] Freeing SMP alternatives memory: 24K (ffffffff81a42000 - 
ffffffff81a48000)
[    0.039879] ftrace: allocating 24337 entries in 96 pages
[    0.046511] smpboot: APIC(0) Converting physical 0 to logical package 0
[    0.046511] smpboot: Max logical packages: 2
[    0.046514] DMAR: Host address width 39
[    0.046514] DMAR: DRHD base: 0x000000fed90000 flags: 0x1
[    0.046519] DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 
d2008c40660462 ecap f050da
[    0.046520] DMAR: RMRR base: 0x0000006f8f6000 end: 0x0000006f915fff
[    0.046521] DMAR-IR: IOAPIC id 2 under DRHD base  0xfed90000 IOMMU 0
[    0.046521] DMAR-IR: HPET id 0 under DRHD base 0xfed90000
[    0.046522] DMAR-IR: x2apic is disabled because BIOS sets x2apic opt 
out bit.
[    0.046522] DMAR-IR: Use 'intremap=no_x2apic_optout' to override the 
BIOS setting.
[    0.047881] DMAR-IR: Enabled IRQ remapping in xapic mode
[    0.047881] x2apic: IRQ remapping doesn't support X2APIC mode
[    0.052016] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.085024] TSC deadline timer enabled
[    0.085029] smpboot: CPU0: Intel(R) Xeon(R) CPU E3-1275 v5 @ 3.60GHz 
(family: 0x6, model: 0x5e, stepping: 0x3)
[    0.085031] Performance Events: PEBS fmt3+, Skylake events, 32-deep 
LBR, full-width counters, Intel PMU driver.
[    0.085048] ... version:                4
[    0.085048] ... bit width:              48
[    0.085048] ... generic registers:      4
[    0.085049] ... value mask:             0000ffffffffffff
[    0.085049] ... max period:             0000ffffffffffff
[    0.085049] ... fixed-purpose events:   3
[    0.085049] ... event mask:             000000070000000f
[    0.108541] NMI watchdog: enabled on all CPUs, permanently consumes 
one hw-PMU counter.
[    0.125102] x86: Booting SMP configuration:
[    0.125104] .... node  #0, CPUs:      #1 #2 #3 #4 #5 #6 #7
[    0.790689] x86: Booted up 1 node, 8 CPUs
[    0.790691] smpboot: Total of 8 processors activated (57631.04 BogoMIPS)
[    0.797364] devtmpfs: initialized
[    0.797398] x86/mm: Memory block size: 2048MB
[    0.798519] PM: Registering ACPI NVS region [mem 
0x6df84000-0x6df84fff] (4096 bytes)
[    0.798520] PM: Registering ACPI NVS region [mem 
0x6f9cc000-0x6ff99fff] (6086656 bytes)
[    0.798596] clocksource: jiffies: mask: 0xffffffff max_cycles: 
0xffffffff, max_idle_ns: 6370867519511994 ns
[    0.798624] pinctrl core: initialized pinctrl subsystem
[    0.798725] RTC time: 20:26:17, date: 11/05/16
[    0.799418] NET: Registered protocol family 16
[    0.813169] cpuidle: using governor ladder
[    0.833186] cpuidle: using governor menu
[    0.833254] ACPI FADT declares the system doesn't support PCIe ASPM, 
so disable it
[    0.833270] ACPI: bus type PCI registered
[    0.833270] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[    0.833309] PCI: MMCONFIG for domain 0000 [bus 00-ff] at [mem 
0xe0000000-0xefffffff] (base 0xe0000000)
[    0.833310] PCI: MMCONFIG at [mem 0xe0000000-0xefffffff] reserved in E820
[    0.833318] PCI: Using configuration type 1 for base access
[    0.853323] HugeTLB registered 1 GB page size, pre-allocated 0 pages
[    0.853323] HugeTLB registered 2 MB page size, pre-allocated 0 pages
[    0.853440] ACPI: Added _OSI(Module Device)
[    0.853441] ACPI: Added _OSI(Processor Device)
[    0.853441] ACPI: Added _OSI(3.0 _SCP Extensions)
[    0.853441] ACPI: Added _OSI(Processor Aggregator Device)
[    0.854314] ACPI: Executed 23 blocks of module-level executable AML code
[    0.860386] ACPI: [Firmware Bug]: BIOS _OSI(Linux) query ignored
[    0.918944] ACPI: Dynamic OEM Table Load:
[    0.918947] ACPI: SSDT 0xFFFF880FBAAF5800 000726 (v02 PmRef Cpu0Ist  
00003000 INTL 20120913)
[    0.919530] ACPI: \_PR_.CPU0: _OSC native thermal LVT Acked
[    0.920533] ACPI: Dynamic OEM Table Load:
[    0.920536] ACPI: SSDT 0xFFFF880FBAB07000 00037F (v02 PmRef Cpu0Cst  
00003001 INTL 20120913)
[    0.921527] ACPI: Dynamic OEM Table Load:
[    0.921530] ACPI: SSDT 0xFFFF880FBAAF1800 0005AA (v02 PmRef ApIst    
00003000 INTL 20120913)
[    0.922246] ACPI: Dynamic OEM Table Load:
[    0.922248] ACPI: SSDT 0xFFFF880FBAAFC600 000119 (v02 PmRef ApCst    
00003000 INTL 20120913)
[    0.926306] ACPI: Interpreter enabled
[    0.926331] ACPI: (supports S0 S3 S4 S5)
[    0.926332] ACPI: Using IOAPIC for interrupt routing
[    0.926354] PCI: Using host bridge windows from ACPI; if necessary, 
use "pci=nocrs" and report a bug
[    0.927747] ACPI: Power Resource [PG00] (on)
[    0.927992] ACPI: Power Resource [PG01] (on)
[    0.928218] ACPI: Power Resource [PG02] (on)
[    0.929681] ACPI: Power Resource [WRST] (off)
[    0.929888] ACPI: Power Resource [WRST] (off)
[    0.930097] ACPI: Power Resource [WRST] (off)
[    0.930303] ACPI: Power Resource [WRST] (off)
[    0.930510] ACPI: Power Resource [WRST] (off)
[    0.930713] ACPI: Power Resource [WRST] (off)
[    0.930917] ACPI: Power Resource [WRST] (off)
[    0.931120] ACPI: Power Resource [WRST] (off)
[    0.931337] ACPI: Power Resource [WRST] (off)
[    0.931542] ACPI: Power Resource [WRST] (off)
[    0.931744] ACPI: Power Resource [WRST] (off)
[    0.931948] ACPI: Power Resource [WRST] (off)
[    0.932152] ACPI: Power Resource [WRST] (off)
[    0.932358] ACPI: Power Resource [WRST] (off)
[    0.932560] ACPI: Power Resource [WRST] (off)
[    0.932763] ACPI: Power Resource [WRST] (off)
[    0.933026] ACPI: Power Resource [WRST] (off)
[    0.933230] ACPI: Power Resource [WRST] (off)
[    0.933434] ACPI: Power Resource [WRST] (off)
[    0.933640] ACPI: Power Resource [WRST] (off)
[    0.938424] ACPI: Power Resource [FN00] (off)
[    0.938468] ACPI: Power Resource [FN01] (off)
[    0.938509] ACPI: Power Resource [FN02] (off)
[    0.938550] ACPI: Power Resource [FN03] (off)
[    0.938592] ACPI: Power Resource [FN04] (off)
[    0.939326] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
[    0.939329] acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM 
ClockPM Segments MSI]
[    0.939349] acpi PNP0A08:00: _OSC failed (AE_ERROR); disabling ASPM
[    0.939760] PCI host bridge to bus 0000:00
[    0.939761] pci_bus 0000:00: root bus resource [io 0x0000-0x0cf7 window]
[    0.939762] pci_bus 0000:00: root bus resource [io 0x0d00-0xffff window]
[    0.939762] pci_bus 0000:00: root bus resource [mem 
0x000a0000-0x000bffff window]
[    0.939763] pci_bus 0000:00: root bus resource [mem 
0x71800000-0xdfffffff window]
[    0.939763] pci_bus 0000:00: root bus resource [mem 
0xfd000000-0xfe7fffff window]
[    0.939764] pci_bus 0000:00: root bus resource [bus 00-fe]
[    0.939769] pci 0000:00:00.0: [8086:1918] type 00 class 0x060000
[    0.939971] pci 0000:00:01.0: [8086:1901] type 01 class 0x060400
[    0.939998] pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
[    0.940072] pci 0000:00:01.0: System wakeup disabled by ACPI
[    0.940176] pci 0000:00:14.0: [8086:a12f] type 00 class 0x0c0330
[    0.940192] pci 0000:00:14.0: reg 0x10: [mem 0xda130000-0xda13ffff 64bit]
[    0.940246] pci 0000:00:14.0: PME# supported from D3hot D3cold
[    0.940310] pci 0000:00:14.0: System wakeup disabled by ACPI
[    0.940335] pci 0000:00:14.2: [8086:a131] type 00 class 0x118000
[    0.940349] pci 0000:00:14.2: reg 0x10: [mem 0xda14e000-0xda14efff 64bit]
[    0.940470] pci 0000:00:16.0: [8086:a13a] type 00 class 0x078000
[    0.940486] pci 0000:00:16.0: reg 0x10: [mem 0xda14d000-0xda14dfff 64bit]
[    0.940547] pci 0000:00:16.0: PME# supported from D3hot
[    0.940644] pci 0000:00:17.0: [8086:a102] type 00 class 0x010601
[    0.940655] pci 0000:00:17.0: reg 0x10: [mem 0xda148000-0xda149fff]
[    0.940660] pci 0000:00:17.0: reg 0x14: [mem 0xda14c000-0xda14c0ff]
[    0.940666] pci 0000:00:17.0: reg 0x18: [io  0xf050-0xf057]
[    0.940671] pci 0000:00:17.0: reg 0x1c: [io  0xf040-0xf043]
[    0.940677] pci 0000:00:17.0: reg 0x20: [io  0xf020-0xf03f]
[    0.940682] pci 0000:00:17.0: reg 0x24: [mem 0xda14b000-0xda14b7ff]
[    0.940713] pci 0000:00:17.0: PME# supported from D3hot
[    0.940798] pci 0000:00:1b.0: [8086:a167] type 01 class 0x060400
[    0.940838] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.940907] pci 0000:00:1b.0: System wakeup disabled by ACPI
[    0.940934] pci 0000:00:1b.3: [8086:a16a] type 01 class 0x060400
[    0.940977] pci 0000:00:1b.3: PME# supported from D0 D3hot D3cold
[    0.941048] pci 0000:00:1b.3: System wakeup disabled by ACPI
[    0.941083] pci 0000:00:1c.0: [8086:a110] type 01 class 0x060400
[    0.941132] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.941204] pci 0000:00:1c.0: System wakeup disabled by ACPI
[    0.941228] pci 0000:00:1c.2: [8086:a112] type 01 class 0x060400
[    0.941273] pci 0000:00:1c.2: PME# supported from D0 D3hot D3cold
[    0.941346] pci 0000:00:1c.2: System wakeup disabled by ACPI
[    0.941369] pci 0000:00:1c.4: [8086:a114] type 01 class 0x060400
[    0.941412] pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
[    0.941482] pci 0000:00:1c.4: System wakeup disabled by ACPI
[    0.941513] pci 0000:00:1d.0: [8086:a118] type 01 class 0x060400
[    0.941563] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.941634] pci 0000:00:1d.0: System wakeup disabled by ACPI
[    0.941667] pci 0000:00:1d.4: [8086:a11c] type 01 class 0x060400
[    0.941716] pci 0000:00:1d.4: PME# supported from D0 D3hot D3cold
[    0.941784] pci 0000:00:1d.4: System wakeup disabled by ACPI
[    0.941818] pci 0000:00:1f.0: [8086:a149] type 00 class 0x060100
[    0.941982] pci 0000:00:1f.2: [8086:a121] type 00 class 0x058000
[    0.941991] pci 0000:00:1f.2: reg 0x10: [mem 0xda144000-0xda147fff]
[    0.942111] pci 0000:00:1f.3: [8086:a170] type 00 class 0x040300
[    0.942130] pci 0000:00:1f.3: reg 0x10: [mem 0xda140000-0xda143fff 64bit]
[    0.942157] pci 0000:00:1f.3: reg 0x20: [mem 0xda120000-0xda12ffff 64bit]
[    0.942199] pci 0000:00:1f.3: PME# supported from D3hot D3cold
[    0.942299] pci 0000:00:1f.3: System wakeup disabled by ACPI
[    0.942327] pci 0000:00:1f.4: [8086:a123] type 00 class 0x0c0500
[    0.942373] pci 0000:00:1f.4: reg 0x10: [mem 0xda14a000-0xda14a0ff 64bit]
[    0.942442] pci 0000:00:1f.4: reg 0x20: [io  0xf000-0xf01f]
[    0.942594] pci 0000:00:1f.6: [8086:15b7] type 00 class 0x020000
[    0.942613] pci 0000:00:1f.6: reg 0x10: [mem 0xda100000-0xda11ffff]
[    0.942708] pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
[    0.942773] pci 0000:00:1f.6: System wakeup disabled by ACPI
[    0.942820] pci 0000:01:00.0: [10de:1184] type 00 class 0x030000
[    0.942828] pci 0000:01:00.0: reg 0x10: [mem 0xdb000000-0xdbffffff]
[    0.942837] pci 0000:01:00.0: reg 0x14: [mem 0xb8000000-0xbfffffff 
64bit pref]
[    0.942845] pci 0000:01:00.0: reg 0x1c: [mem 0xc0000000-0xc1ffffff 
64bit pref]
[    0.942850] pci 0000:01:00.0: reg 0x24: [io  0xe000-0xe07f]
[    0.942855] pci 0000:01:00.0: reg 0x30: [mem 0xdc000000-0xdc07ffff pref]
[    0.942907] pci 0000:01:00.0: System wakeup disabled by ACPI
[    0.942931] pci 0000:01:00.1: [10de:0e0a] type 00 class 0x040300
[    0.942939] pci 0000:01:00.1: reg 0x10: [mem 0xdc080000-0xdc083fff]
[    0.950242] pci 0000:00:01.0: PCI bridge to [bus 01]
[    0.950244] pci 0000:00:01.0:   bridge window [io 0xe000-0xefff]
[    0.950245] pci 0000:00:01.0:   bridge window [mem 0xdb000000-0xdc0fffff]
[    0.950247] pci 0000:00:01.0:   bridge window [mem 
0xb8000000-0xc1ffffff 64bit pref]
[    0.950312] acpiphp: Slot [1] registered
[    0.950315] pci 0000:00:1b.0: PCI bridge to [bus 02]
[    0.950388] pci 0000:03:00.0: [1b21:0612] type 00 class 0x010601
[    0.950402] pci 0000:03:00.0: reg 0x10: [io  0xd050-0xd057]
[    0.950410] pci 0000:03:00.0: reg 0x14: [io  0xd040-0xd043]
[    0.950419] pci 0000:03:00.0: reg 0x18: [io  0xd030-0xd037]
[    0.950427] pci 0000:03:00.0: reg 0x1c: [io  0xd020-0xd023]
[    0.950435] pci 0000:03:00.0: reg 0x20: [io  0xd000-0xd01f]
[    0.950443] pci 0000:03:00.0: reg 0x24: [mem 0xdc310000-0xdc3101ff]
[    0.950451] pci 0000:03:00.0: reg 0x30: [mem 0xdc300000-0xdc30ffff pref]
[    0.950537] pci 0000:03:00.0: System wakeup disabled by ACPI
[    0.960232] pci 0000:00:1b.3: PCI bridge to [bus 03]
[    0.960238] pci 0000:00:1b.3:   bridge window [io 0xd000-0xdfff]
[    0.960257] pci 0000:00:1b.3:   bridge window [mem 0xdc300000-0xdc3fffff]
[    0.960320] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    0.960387] pci 0000:00:1c.2: PCI bridge to [bus 05]
[    0.960388] pci 0000:00:1c.2:   bridge window [io 0xc000-0xcfff]
[    0.960390] pci 0000:00:1c.2:   bridge window [mem 0xdc200000-0xdc2fffff]
[    0.960465] pci 0000:06:00.0: [8086:1578] type 01 class 0x060400
[    0.960548] pci 0000:06:00.0: supports D1 D2
[    0.960549] pci 0000:06:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.960609] pci 0000:06:00.0: System wakeup disabled by ACPI
[    0.970242] pci 0000:00:1c.4: PCI bridge to [bus 06-70]
[    0.970250] pci 0000:00:1c.4:   bridge window [mem 0xc4000000-0xda0fffff]
[    0.970268] pci 0000:00:1c.4:   bridge window [mem 
0x90000000-0xb1ffffff 64bit pref]
[    0.970270] pci 0000:06:00.0: bridge configuration invalid ([bus 
00-00]), reconfiguring
[    0.970307] pci_bus 0000:07: busn_res: can not insert [bus 07-ff] 
under [bus 06-70] (conflicts with (null) [bus 06-70])
[    0.970320] pci 0000:07:00.0: [8086:1578] type 01 class 0x060400
[    0.970407] pci 0000:07:00.0: supports D1 D2
[    0.970407] pci 0000:07:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.970460] pci 0000:07:01.0: [8086:1578] type 01 class 0x060400
[    0.970547] pci 0000:07:01.0: supports D1 D2
[    0.970547] pci 0000:07:01.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.970598] pci 0000:07:02.0: [8086:1578] type 01 class 0x060400
[    0.970684] pci 0000:07:02.0: supports D1 D2
[    0.970684] pci 0000:07:02.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.970736] pci 0000:07:04.0: [8086:1578] type 01 class 0x060400
[    0.970822] pci 0000:07:04.0: supports D1 D2
[    0.970823] pci 0000:07:04.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.970890] pci 0000:06:00.0: PCI bridge to [bus 07-ff]
[    0.970895] pci 0000:06:00.0:   bridge window [io 0x0000-0x0fff]
[    0.970897] pci 0000:06:00.0:   bridge window [mem 0x00000000-0x000fffff]
[    0.970902] pci 0000:06:00.0:   bridge window [mem 
0x00000000-0x000fffff 64bit pref]
[    0.970904] pci 0000:07:00.0: bridge configuration invalid ([bus 
00-00]), reconfiguring
[    0.970909] pci 0000:07:01.0: bridge configuration invalid ([bus 
00-00]), reconfiguring
[    0.970915] pci 0000:07:02.0: bridge configuration invalid ([bus 
00-00]), reconfiguring
[    0.970920] pci 0000:07:04.0: bridge configuration invalid ([bus 
00-00]), reconfiguring
[    0.970959] pci 0000:07:00.0: PCI bridge to [bus 08-ff]
[    0.970963] pci 0000:07:00.0:   bridge window [io 0x0000-0x0fff]
[    0.970966] pci 0000:07:00.0:   bridge window [mem 0x00000000-0x000fffff]
[    0.970971] pci 0000:07:00.0:   bridge window [mem 
0x00000000-0x000fffff 64bit pref]
[    0.970972] pci_bus 0000:08: busn_res: [bus 08-ff] end is updated to 08
[    0.971008] pci 0000:07:01.0: PCI bridge to [bus 09-ff]
[    0.971012] pci 0000:07:01.0:   bridge window [io 0x0000-0x0fff]
[    0.971015] pci 0000:07:01.0:   bridge window [mem 0x00000000-0x000fffff]
[    0.971019] pci 0000:07:01.0:   bridge window [mem 
0x00000000-0x000fffff 64bit pref]
[    0.971020] pci_bus 0000:09: busn_res: [bus 09-ff] end is updated to 09
[    0.971069] pci 0000:0a:00.0: [8086:15b6] type 00 class 0x0c0330
[    0.971084] pci 0000:0a:00.0: reg 0x10: [mem 0x00000000-0x0000ffff]
[    0.971208] pci 0000:0a:00.0: supports D1 D2
[    0.971208] pci 0000:0a:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.971280] pci 0000:07:02.0: PCI bridge to [bus 0a-ff]
[    0.971285] pci 0000:07:02.0:   bridge window [io 0x0000-0x0fff]
[    0.971287] pci 0000:07:02.0:   bridge window [mem 0x00000000-0x000fffff]
[    0.971292] pci 0000:07:02.0:   bridge window [mem 
0x00000000-0x000fffff 64bit pref]
[    0.971292] pci_bus 0000:0a: busn_res: [bus 0a-ff] end is updated to 0a
[    0.971328] pci 0000:07:04.0: PCI bridge to [bus 0b-ff]
[    0.971333] pci 0000:07:04.0:   bridge window [io 0x0000-0x0fff]
[    0.971335] pci 0000:07:04.0:   bridge window [mem 0x00000000-0x000fffff]
[    0.971340] pci 0000:07:04.0:   bridge window [mem 
0x00000000-0x000fffff 64bit pref]
[    0.971340] pci_bus 0000:0b: busn_res: [bus 0b-ff] end is updated to 0b
[    0.971343] pci_bus 0000:07: busn_res: [bus 07-ff] end is updated to 0b
[    0.971406] pci 0000:00:1d.0: PCI bridge to [bus 71]
[    0.971476] acpiphp: Slot [1-1] registered
[    0.971484] pci 0000:00:1d.4: PCI bridge to [bus 72]
[    0.972798] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 *10 11 12 
14 15)
[    0.972830] ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    0.972862] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 6 10 11 12 
*14 15)
[    0.972893] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 10 11 12 14 
*15)
[    0.972924] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    0.972955] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    0.972987] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    0.973018] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 10 *11 12 
14 15)
[    0.973275] ACPI: Enabled 6 GPEs in block 00 to 7F
[    0.973330] vgaarb: setting as boot device: PCI:0000:01:00.0
[    0.973330] vgaarb: device added: 
PCI:0000:01:00.0,decodes=io+mem,owns=io+mem,locks=none
[    0.973331] vgaarb: loaded
[    0.973332] vgaarb: bridge control possible 0000:01:00.0
[    0.977322] PCI: Using ACPI for IRQ routing
[    0.996003] PCI: pci_cache_line_size set to 64 bytes
[    0.996063] e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
[    0.996064] e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
[    0.996064] e820: reserve RAM buffer [mem 0x6df84000-0x6fffffff]
[    0.996065] e820: reserve RAM buffer [mem 0x6e027000-0x6fffffff]
[    0.996066] e820: reserve RAM buffer [mem 0x6ed2e000-0x6fffffff]
[    0.996116] NetLabel: Initializing
[    0.996117] NetLabel:  domain hash size = 128
[    0.996117] NetLabel:  protocols = UNLABELED CIPSOv4
[    0.996124] NetLabel:  unlabeled traffic allowed by default
[    0.996191] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
[    0.996194] hpet0: 8 comparators, 64-bit 24.000000 MHz counter
[    0.998234] clocksource: Switched to clocksource hpet
[    1.001805] VFS: Disk quotas dquot_6.6.0
[    1.001857] VFS: Dquot-cache hash table entries: 512 (order 0, 4096 
bytes)
[    1.001895] pnp: PnP ACPI init
[    1.002053] system 00:00: [io  0x0a00-0x0a2f] has been reserved
[    1.002054] system 00:00: [io  0x0a30-0x0a3f] has been reserved
[    1.002055] system 00:00: [io  0x0a40-0x0a4f] has been reserved
[    1.002057] system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.002301] system 00:01: [io  0x0680-0x069f] has been reserved
[    1.002302] system 00:01: [io  0xffff] has been reserved
[    1.002303] system 00:01: [io  0xffff] has been reserved
[    1.002303] system 00:01: [io  0xffff] has been reserved
[    1.002304] system 00:01: [io  0x1800-0x18fe] has been reserved
[    1.002304] system 00:01: [io  0x164e-0x164f] has been reserved
[    1.002306] system 00:01: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.002363] system 00:02: [io  0x0800-0x087f] has been reserved
[    1.002364] system 00:02: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.002376] pnp 00:03: Plug and Play ACPI device, IDs PNP0b00 (active)
[    1.002398] system 00:04: [io  0x1854-0x1857] has been reserved
[    1.002399] system 00:04: Plug and Play ACPI device, IDs INT3f0d 
PNP0c02 (active)
[    1.002530] system 00:05: [mem 0xfed10000-0xfed17fff] has been reserved
[    1.002530] system 00:05: [mem 0xfed18000-0xfed18fff] has been reserved
[    1.002531] system 00:05: [mem 0xfed19000-0xfed19fff] has been reserved
[    1.002532] system 00:05: [mem 0xe0000000-0xefffffff] has been reserved
[    1.002532] system 00:05: [mem 0xfed20000-0xfed3ffff] has been reserved
[    1.002533] system 00:05: [mem 0xfed90000-0xfed93fff] could not be 
reserved
[    1.002534] system 00:05: [mem 0xfed45000-0xfed8ffff] has been reserved
[    1.002535] system 00:05: [mem 0xff000000-0xffffffff] has been reserved
[    1.002535] system 00:05: [mem 0xfee00000-0xfeefffff] could not be 
reserved
[    1.002536] system 00:05: [mem 0xdffe0000-0xdfffffff] has been reserved
[    1.002537] system 00:05: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.002562] system 00:06: [mem 0xfd000000-0xfdabffff] has been reserved
[    1.002562] system 00:06: [mem 0xfdad0000-0xfdadffff] has been reserved
[    1.002563] system 00:06: [mem 0xfdb00000-0xfdffffff] has been reserved
[    1.002564] system 00:06: [mem 0xfe000000-0xfe01ffff] could not be 
reserved
[    1.002564] system 00:06: [mem 0xfe036000-0xfe03bfff] has been reserved
[    1.002565] system 00:06: [mem 0xfe03d000-0xfe3fffff] has been reserved
[    1.002566] system 00:06: [mem 0xfe410000-0xfe7fffff] has been reserved
[    1.002567] system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.003226] system 00:07: [mem 0xfdaf0000-0xfdafffff] has been reserved
[    1.003227] system 00:07: [mem 0xfdae0000-0xfdaeffff] has been reserved
[    1.003228] system 00:07: [mem 0xfdac0000-0xfdacffff] has been reserved
[    1.003229] system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
[    1.003738] pnp: PnP ACPI: found 8 devices
[    1.011606] clocksource: acpi_pm: mask: 0xffffff max_cycles: 
0xffffff, max_idle_ns: 2085701024 ns
[    1.011640] pci 0000:07:01.0: bridge window [io  0x1000-0x0fff] to 
[bus 09] add_size 1000
[    1.011641] pci 0000:07:01.0: bridge window [mem 
0x00100000-0x000fffff 64bit pref] to [bus 09] add_size 200000 add_align 
100000
[    1.011642] pci 0000:07:01.0: bridge window [mem 
0x00100000-0x000fffff] to [bus 09] add_size 200000 add_align 100000
[    1.011655] pci 0000:07:04.0: bridge window [io  0x1000-0x0fff] to 
[bus 0b] add_size 1000
[    1.011656] pci 0000:07:04.0: bridge window [mem 
0x00100000-0x000fffff 64bit pref] to [bus 0b] add_size 200000 add_align 
100000
[    1.011656] pci 0000:07:04.0: bridge window [mem 
0x00100000-0x000fffff] to [bus 0b] add_size 200000 add_align 100000
[    1.011663] pci 0000:07:01.0: res[13]=[io  0x1000-0x0fff] 
res_to_dev_res add_size 1000 min_align 1000
[    1.011664] pci 0000:07:04.0: res[13]=[io  0x1000-0x0fff] 
res_to_dev_res add_size 1000 min_align 1000
[    1.011665] pci 0000:06:00.0: bridge window [io  0x1000-0x0fff] to 
[bus 07-0b] add_size 2000
[    1.011665] pci 0000:07:01.0: res[15]=[mem 0x00100000-0x000fffff 
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    1.011666] pci 0000:07:01.0: res[15]=[mem 0x00100000-0x000fffff 
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    1.011667] pci 0000:07:04.0: res[15]=[mem 0x00100000-0x000fffff 
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    1.011668] pci 0000:07:04.0: res[15]=[mem 0x00100000-0x000fffff 
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    1.011668] pci 0000:06:00.0: bridge window [mem 
0x00100000-0x000fffff 64bit pref] to [bus 07-0b] add_size 400000 
add_align 100000
[    1.011669] pci 0000:07:01.0: res[14]=[mem 0x00100000-0x000fffff] 
res_to_dev_res add_size 200000 min_align 100000
[    1.011670] pci 0000:07:01.0: res[14]=[mem 0x00100000-0x000fffff] 
res_to_dev_res add_size 200000 min_align 100000
[    1.011671] pci 0000:07:04.0: res[14]=[mem 0x00100000-0x000fffff] 
res_to_dev_res add_size 200000 min_align 100000
[    1.011671] pci 0000:07:04.0: res[14]=[mem 0x00100000-0x000fffff] 
res_to_dev_res add_size 200000 min_align 100000
[    1.011672] pci 0000:06:00.0: bridge window [mem 
0x00100000-0x001fffff] to [bus 07-0b] add_size 400000 add_align 100000
[    1.011676] pci 0000:06:00.0: res[13]=[io  0x1000-0x0fff] 
res_to_dev_res add_size 2000 min_align 1000
[    1.011677] pci 0000:00:1c.4: bridge window [io  0x1000-0x0fff] to 
[bus 06-70] add_size 2000
[    1.011688] pci 0000:00:1c.4: res[13]=[io  0x1000-0x0fff] 
res_to_dev_res add_size 2000 min_align 1000
[    1.011689] pci 0000:00:1c.4: res[13]=[io  0x1000-0x2fff] 
res_to_dev_res add_size 2000 min_align 1000
[    1.011690] pci 0000:00:1c.4: BAR 13: assigned [io 0x2000-0x3fff]
[    1.011692] pci 0000:00:01.0: PCI bridge to [bus 01]
[    1.011693] pci 0000:00:01.0:   bridge window [io 0xe000-0xefff]
[    1.011694] pci 0000:00:01.0:   bridge window [mem 0xdb000000-0xdc0fffff]
[    1.011696] pci 0000:00:01.0:   bridge window [mem 
0xb8000000-0xc1ffffff 64bit pref]
[    1.011698] pci 0000:00:1b.0: PCI bridge to [bus 02]
[    1.011704] pci 0000:00:1b.3: PCI bridge to [bus 03]
[    1.011705] pci 0000:00:1b.3:   bridge window [io 0xd000-0xdfff]
[    1.011707] pci 0000:00:1b.3:   bridge window [mem 0xdc300000-0xdc3fffff]
[    1.011711] pci 0000:00:1c.0: PCI bridge to [bus 04]
[    1.011717] pci 0000:00:1c.2: PCI bridge to [bus 05]
[    1.011718] pci 0000:00:1c.2:   bridge window [io 0xc000-0xcfff]
[    1.011721] pci 0000:00:1c.2:   bridge window [mem 0xdc200000-0xdc2fffff]
[    1.011727] pci 0000:06:00.0: res[14]=[mem 0x00100000-0x001fffff] 
res_to_dev_res add_size 400000 min_align 100000
[    1.011727] pci 0000:06:00.0: res[14]=[mem 0x00100000-0x005fffff] 
res_to_dev_res add_size 400000 min_align 100000
[    1.011728] pci 0000:06:00.0: res[15]=[mem 0x00100000-0x000fffff 
64bit pref] res_to_dev_res add_size 400000 min_align 100000
[    1.011729] pci 0000:06:00.0: res[15]=[mem 0x00100000-0x004fffff 
64bit pref] res_to_dev_res add_size 400000 min_align 100000
[    1.011729] pci 0000:06:00.0: res[13]=[io  0x1000-0x0fff] 
res_to_dev_res add_size 2000 min_align 1000
[    1.011730] pci 0000:06:00.0: res[13]=[io  0x1000-0x2fff] 
res_to_dev_res add_size 2000 min_align 1000
[    1.011731] pci 0000:06:00.0: BAR 14: assigned [mem 
0xc4000000-0xc44fffff]
[    1.011732] pci 0000:06:00.0: BAR 15: assigned [mem 
0x90000000-0x903fffff 64bit pref]
[    1.011733] pci 0000:06:00.0: BAR 13: assigned [io 0x2000-0x3fff]
[    1.011735] pci 0000:07:01.0: res[14]=[mem 0x00100000-0x000fffff] 
res_to_dev_res add_size 200000 min_align 100000
[    1.011735] pci 0000:07:01.0: res[14]=[mem 0x00100000-0x002fffff] 
res_to_dev_res add_size 200000 min_align 100000
[    1.011736] pci 0000:07:01.0: res[15]=[mem 0x00100000-0x000fffff 
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    1.011737] pci 0000:07:01.0: res[15]=[mem 0x00100000-0x002fffff 
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    1.011737] pci 0000:07:04.0: res[14]=[mem 0x00100000-0x000fffff] 
res_to_dev_res add_size 200000 min_align 100000
[    1.011738] pci 0000:07:04.0: res[14]=[mem 0x00100000-0x002fffff] 
res_to_dev_res add_size 200000 min_align 100000
[    1.011739] pci 0000:07:04.0: res[15]=[mem 0x00100000-0x000fffff 
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    1.011739] pci 0000:07:04.0: res[15]=[mem 0x00100000-0x002fffff 
64bit pref] res_to_dev_res add_size 200000 min_align 100000
[    1.011740] pci 0000:07:01.0: res[13]=[io  0x1000-0x0fff] 
res_to_dev_res add_size 1000 min_align 1000
[    1.011741] pci 0000:07:01.0: res[13]=[io  0x1000-0x1fff] 
res_to_dev_res add_size 1000 min_align 1000
[    1.011741] pci 0000:07:04.0: res[13]=[io  0x1000-0x0fff] 
res_to_dev_res add_size 1000 min_align 1000
[    1.011742] pci 0000:07:04.0: res[13]=[io  0x1000-0x1fff] 
res_to_dev_res add_size 1000 min_align 1000
[    1.011743] pci 0000:07:01.0: BAR 14: assigned [mem 
0xc4000000-0xc41fffff]
[    1.011744] pci 0000:07:01.0: BAR 15: assigned [mem 
0x90000000-0x901fffff 64bit pref]
[    1.011744] pci 0000:07:02.0: BAR 14: assigned [mem 
0xc4200000-0xc42fffff]
[    1.011745] pci 0000:07:04.0: BAR 14: assigned [mem 
0xc4300000-0xc44fffff]
[    1.011746] pci 0000:07:04.0: BAR 15: assigned [mem 
0x90200000-0x903fffff 64bit pref]
[    1.011747] pci 0000:07:01.0: BAR 13: assigned [io 0x2000-0x2fff]
[    1.011747] pci 0000:07:04.0: BAR 13: assigned [io 0x3000-0x3fff]
[    1.011748] pci 0000:07:00.0: PCI bridge to [bus 08]
[    1.011758] pci 0000:07:01.0: PCI bridge to [bus 09]
[    1.011759] pci 0000:07:01.0:   bridge window [io 0x2000-0x2fff]
[    1.011763] pci 0000:07:01.0:   bridge window [mem 0xc4000000-0xc41fffff]
[    1.011765] pci 0000:07:01.0:   bridge window [mem 
0x90000000-0x901fffff 64bit pref]
[    1.011770] pci 0000:0a:00.0: BAR 0: assigned [mem 0xc4200000-0xc420ffff]
[    1.011774] pci 0000:07:02.0: PCI bridge to [bus 0a]
[    1.011778] pci 0000:07:02.0:   bridge window [mem 0xc4200000-0xc42fffff]
[    1.011784] pci 0000:07:04.0: PCI bridge to [bus 0b]
[    1.011786] pci 0000:07:04.0:   bridge window [io 0x3000-0x3fff]
[    1.011789] pci 0000:07:04.0:   bridge window [mem 0xc4300000-0xc44fffff]
[    1.011792] pci 0000:07:04.0:   bridge window [mem 
0x90200000-0x903fffff 64bit pref]
[    1.011796] pci 0000:06:00.0: PCI bridge to [bus 07-0b]
[    1.011798] pci 0000:06:00.0:   bridge window [io 0x2000-0x3fff]
[    1.011801] pci 0000:06:00.0:   bridge window [mem 0xc4000000-0xc44fffff]
[    1.011804] pci 0000:06:00.0:   bridge window [mem 
0x90000000-0x903fffff 64bit pref]
[    1.011808] pci 0000:00:1c.4: PCI bridge to [bus 06-70]
[    1.011809] pci 0000:00:1c.4:   bridge window [io 0x2000-0x3fff]
[    1.011811] pci 0000:00:1c.4:   bridge window [mem 0xc4000000-0xda0fffff]
[    1.011813] pci 0000:00:1c.4:   bridge window [mem 
0x90000000-0xb1ffffff 64bit pref]
[    1.011816] pci 0000:00:1d.0: PCI bridge to [bus 71]
[    1.011822] pci 0000:00:1d.4: PCI bridge to [bus 72]
[    1.011830] pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
[    1.011831] pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
[    1.011832] pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff 
window]
[    1.011832] pci_bus 0000:00: resource 7 [mem 0x71800000-0xdfffffff 
window]
[    1.011833] pci_bus 0000:00: resource 8 [mem 0xfd000000-0xfe7fffff 
window]
[    1.011833] pci_bus 0000:01: resource 0 [io  0xe000-0xefff]
[    1.011834] pci_bus 0000:01: resource 1 [mem 0xdb000000-0xdc0fffff]
[    1.011834] pci_bus 0000:01: resource 2 [mem 0xb8000000-0xc1ffffff 
64bit pref]
[    1.011835] pci_bus 0000:03: resource 0 [io  0xd000-0xdfff]
[    1.011836] pci_bus 0000:03: resource 1 [mem 0xdc300000-0xdc3fffff]
[    1.011836] pci_bus 0000:05: resource 0 [io  0xc000-0xcfff]
[    1.011837] pci_bus 0000:05: resource 1 [mem 0xdc200000-0xdc2fffff]
[    1.011837] pci_bus 0000:06: resource 0 [io  0x2000-0x3fff]
[    1.011838] pci_bus 0000:06: resource 1 [mem 0xc4000000-0xda0fffff]
[    1.011838] pci_bus 0000:06: resource 2 [mem 0x90000000-0xb1ffffff 
64bit pref]
[    1.011839] pci_bus 0000:07: resource 0 [io  0x2000-0x3fff]
[    1.011840] pci_bus 0000:07: resource 1 [mem 0xc4000000-0xc44fffff]
[    1.011840] pci_bus 0000:07: resource 2 [mem 0x90000000-0x903fffff 
64bit pref]
[    1.011841] pci_bus 0000:09: resource 0 [io  0x2000-0x2fff]
[    1.011841] pci_bus 0000:09: resource 1 [mem 0xc4000000-0xc41fffff]
[    1.011842] pci_bus 0000:09: resource 2 [mem 0x90000000-0x901fffff 
64bit pref]
[    1.011842] pci_bus 0000:0a: resource 1 [mem 0xc4200000-0xc42fffff]
[    1.011843] pci_bus 0000:0b: resource 0 [io  0x3000-0x3fff]
[    1.011843] pci_bus 0000:0b: resource 1 [mem 0xc4300000-0xc44fffff]
[    1.011844] pci_bus 0000:0b: resource 2 [mem 0x90200000-0x903fffff 
64bit pref]
[    1.011859] NET: Registered protocol family 2
[    1.012010] TCP established hash table entries: 524288 (order: 10, 
4194304 bytes)
[    1.012391] TCP bind hash table entries: 65536 (order: 8, 1048576 bytes)
[    1.012469] TCP: Hash tables configured (established 524288 bind 65536)
[    1.012496] UDP hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.012592] UDP-Lite hash table entries: 32768 (order: 8, 1048576 bytes)
[    1.012691] NET: Registered protocol family 1
[    1.041112] pci 0000:01:00.0: Video device with shadowed ROM at [mem 
0x000c0000-0x000dffff]
[    1.041186] pci 0000:06:00.0: enabling device (0000 -> 0003)
[    1.041216] pci 0000:07:02.0: enabling device (0000 -> 0002)
[    1.041246] pci 0000:0a:00.0: enabling device (0000 -> 0002)
[    1.041315] PCI: CLS 0 bytes, default 64
[    1.041336] Unpacking initramfs...
[    1.096225] Freeing initrd memory: 6496K (ffff88003733f000 - 
ffff880037997000)
[    1.096245] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    1.096246] software IO TLB [mem 0x657d1000-0x697d1000] (64MB) mapped 
at [ffff8800657d1000-ffff8800697d0fff]
[    1.096712] Scanning for low memory corruption every 60 seconds
[    1.096883] futex hash table entries: 2048 (order: 5, 131072 bytes)
[    1.097121] Initialise system trusted keyrings
[    1.097409] workingset: timestamp_bits=40 max_order=24 bucket_order=0
[    1.098319] zbud: loaded
[    1.098459] Key type big_key registered
[    1.098932] Key type asymmetric registered
[    1.098949] Block layer SCSI generic (bsg) driver version 0.4 loaded 
(major 249)
[    1.099057] io scheduler noop registered
[    1.099058] io scheduler deadline registered
[    1.099062] io scheduler cfq registered (default)
[    1.099471] pcieport 0000:00:1c.2: enabling device (0000 -> 0003)
[    1.099932] pcieport 0000:07:01.0: enabling device (0000 -> 0003)
[    1.100126] pcieport 0000:07:04.0: enabling device (0000 -> 0003)
[    1.100245] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    1.100248] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[    1.100254] efifb: probing for efifb
[    1.100261] efifb: framebuffer at 0xc1000000, using 3072k, total 3072k
[    1.100262] efifb: mode is 1024x768x32, linelength=4096, pages=1
[    1.100262] efifb: scrolling: redraw
[    1.100263] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
[    1.101369] Console: switching to colour frame buffer device 128x48
[    1.102476] fb0: EFI VGA frame buffer device
[    1.102480] intel_idle: MWAIT substates: 0x142120
[    1.102480] intel_idle: v0.4.1 model 0x5E
[    1.102671] intel_idle: lapic_timer_reliable_states 0xffffffff
[    1.102778] GHES: HEST is not enabled!
[    1.102824] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    1.103198] Linux agpgart interface v0.103
[    1.103580] rtc_cmos 00:03: RTC can wake from S4
[    1.103956] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[    1.104041] rtc_cmos 00:03: alarms up to one month, y3k, 242 bytes 
nvram, hpet irqs
[    1.104044] intel_pstate: Intel P-state driver initializing
[    1.104440] intel_pstate: HWP enabled
[    1.104625] ledtrig-cpu: registered to indicate activity on CPUs
[    1.104809] NET: Registered protocol family 10
[    1.105190] NET: Registered protocol family 17
[    1.105360] microcode: sig=0x506e3, pf=0x2, revision=0x9e
[    1.105677] microcode: Microcode Update Driver: v2.01 
<tigran@aivazian.fsnet.co.uk>, Peter Oruba
[    1.105836] registered taskstats version 1
[    1.105837] Loading compiled-in X.509 certificates
[    1.105844] zswap: loaded using pool lzo/zbud
[    1.108883]   Magic number: 8:901:446
[    1.109209] rtc_cmos 00:03: setting system clock to 2016-11-05 
20:26:17 UTC (1478377577)
[    1.109241] PM: Hibernation image not present or could not be loaded.
[    1.109941] Freeing unused kernel memory: 1256K (ffffffff81908000 - 
ffffffff81a42000)
[    1.109941] Write protecting the kernel read-only data: 8192k
[    1.110428] Freeing unused kernel memory: 136K (ffff8800017de000 - 
ffff880001800000)
[    1.115087] random: systemd-tmpfile: uninitialized urandom read (16 
bytes read)
[    1.116077] random: systemd-udevd: uninitialized urandom read (16 
bytes read)
[    1.116100] random: systemd-udevd: uninitialized urandom read (16 
bytes read)
[    1.116442] random: udevadm: uninitialized urandom read (16 bytes read)
[    1.116451] random: udevadm: uninitialized urandom read (16 bytes read)
[    1.117558] random: systemd-udevd: uninitialized urandom read (16 
bytes read)
[    1.117567] random: systemd-udevd: uninitialized urandom read (16 
bytes read)
[    1.117570] random: systemd-udevd: uninitialized urandom read (16 
bytes read)
[    1.117714] random: systemd-udevd: uninitialized urandom read (16 
bytes read)
[    1.117724] random: systemd-udevd: uninitialized urandom read (16 
bytes read)
[    1.144516] i8042: PNP: No PS/2 controller found. Probing ports directly.
[    1.145664] serio: i8042 KBD port at 0x60,0x64 irq 1
[    1.145685] serio: i8042 AUX port at 0x60,0x64 irq 12
[    1.159210] ACPI: bus type USB registered
[    1.159221] usbcore: registered new interface driver usbfs
[    1.159230] usbcore: registered new interface driver hub
[    1.159278] usbcore: registered new device driver usb
[    1.159420] SCSI subsystem initialized
[    1.161373] libata version 3.00 loaded.
[    1.161400] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.161419] xhci_hcd 0000:00:14.0: new USB bus registered, assigned 
bus number 1
[    1.162876] xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version 
0x100 quirks 0x00109810
[    1.162881] xhci_hcd 0000:00:14.0: cache line size of 64 is not supported
[    1.163078] hub 1-0:1.0: USB hub found
[    1.163113] hub 1-0:1.0: 16 ports detected
[    1.172477] xhci_hcd 0000:00:14.0: xHCI Host Controller
[    1.172479] xhci_hcd 0000:00:14.0: new USB bus registered, assigned 
bus number 2
[    1.172625] hub 2-0:1.0: USB hub found
[    1.172644] hub 2-0:1.0: 10 ports detected
[    1.176377] usb: port power management may be unreliable
[    1.177992] ahci 0000:00:17.0: version 3.0
[    1.178050] xhci_hcd 0000:0a:00.0: xHCI Host Controller
[    1.178052] xhci_hcd 0000:0a:00.0: new USB bus registered, assigned 
bus number 3
[    1.179326] xhci_hcd 0000:0a:00.0: hcc params 0x200077c1 hci version 
0x110 quirks 0x00009810
[    1.179727] hub 3-0:1.0: USB hub found
[    1.179731] hub 3-0:1.0: 2 ports detected
[    1.179818] xhci_hcd 0000:0a:00.0: xHCI Host Controller
[    1.179820] xhci_hcd 0000:0a:00.0: new USB bus registered, assigned 
bus number 4
[    1.180140] hub 4-0:1.0: USB hub found
[    1.180177] hub 4-0:1.0: 2 ports detected
[    1.188494] ahci 0000:00:17.0: AHCI 0001.0301 32 slots 6 ports 6 Gbps 
0x3f impl SATA mode
[    1.188495] ahci 0000:00:17.0: flags: 64bit ncq sntf pm led clo only 
pio slum part ems deso sadm sds apst
[    1.240580] scsi host0: ahci
[    1.241175] scsi host1: ahci
[    1.241767] scsi host2: ahci
[    1.242345] scsi host3: ahci
[    1.242906] scsi host4: ahci
[    1.243457] scsi host5: ahci
[    1.243634] ata1: SATA max UDMA/133 abar m2048@0xda14b000 port 
0xda14b100 irq 128
[    1.243638] ata2: SATA max UDMA/133 abar m2048@0xda14b000 port 
0xda14b180 irq 128
[    1.243642] ata3: SATA max UDMA/133 abar m2048@0xda14b000 port 
0xda14b200 irq 128
[    1.243645] ata4: SATA max UDMA/133 abar m2048@0xda14b000 port 
0xda14b280 irq 128
[    1.243649] ata5: SATA max UDMA/133 abar m2048@0xda14b000 port 
0xda14b300 irq 128
[    1.243652] ata6: SATA max UDMA/133 abar m2048@0xda14b000 port 
0xda14b380 irq 128
[    1.244097] ahci 0000:03:00.0: SSS flag set, parallel bus scan disabled
[    1.244157] ahci 0000:03:00.0: AHCI 0001.0200 32 slots 2 ports 6 Gbps 
0x3 impl SATA mode
[    1.244162] ahci 0000:03:00.0: flags: 64bit ncq sntf stag led clo pmp 
pio slum part ccc sxs
[    1.245240] scsi host6: ahci
[    1.245657] scsi host7: ahci
[    1.245813] ata7: SATA max UDMA/133 abar m512@0xdc310000 port 
0xdc310100 irq 130
[    1.245818] ata8: SATA max UDMA/133 abar m512@0xdc310000 port 
0xdc310180 irq 130
[    1.491642] usb 1-1: new high-speed USB device number 2 using xhci_hcd
[    1.558506] ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.559259] ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.559315] ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.559438] ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.559482] ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.559550] ata7: SATA link down (SStatus 0 SControl 300)
[    1.559554] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[    1.560086] ata1.00: NCQ Send/Recv Log not supported
[    1.560090] ata1.00: ATA-9: Samsung SSD 840 PRO Series, DXM06B0Q, max 
UDMA/133
[    1.560093] ata1.00: 500118192 sectors, multi 16: LBA48 NCQ (depth 
31/32), AA
[    1.560420] ata3.00: supports DRM functions and may not be fully 
accessible
[    1.560472] ata2.00: NCQ Send/Recv Log not supported
[    1.560477] ata2.00: ATA-9: Samsung SSD 840 PRO Series, DXM06B0Q, max 
UDMA/133
[    1.560481] ata2.00: 250069680 sectors, multi 16: LBA48 NCQ (depth 
31/32), AA
[    1.560636] ata4.00: ATA-8: ST4000DM000-1F2168, CC52, max UDMA/133
[    1.560640] ata4.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth 
31/32), AA
[    1.560683] ata5.00: ATA-8: TOSHIBA DT01ACA200, MX4OABB0, max UDMA/133
[    1.560687] ata5.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 
31/32), AA
[    1.560700] ata1.00: NCQ Send/Recv Log not supported
[    1.560707] ata1.00: configured for UDMA/133
[    1.560863] ata3.00: NCQ Send/Recv Log not supported
[    1.560868] ata3.00: ATA-9: Samsung SSD 840 EVO 1TB, EXT0BB6Q, max 
UDMA/133
[    1.560873] ata3.00: 1953525168 sectors, multi 1: LBA48 NCQ (depth 
31/32), AA
[    1.561015] ata6.00: ATA-8: TOSHIBA DT01ACA200, MX4OABB0, max UDMA/133
[    1.561018] ata6.00: 3907029168 sectors, multi 16: LBA48 NCQ (depth 
31/32), AA
[    1.561067] ata2.00: NCQ Send/Recv Log not supported
[    1.561076] ata2.00: configured for UDMA/133
[    1.561248] ata3.00: supports DRM functions and may not be fully 
accessible
[    1.561534] scsi 0:0:0:0: Direct-Access     ATA      Samsung SSD 840  
6B0Q PQ: 0 ANSI: 5
[    1.561620] ata4.00: configured for UDMA/133
[    1.561681] ata3.00: NCQ Send/Recv Log not supported
[    1.561689] ata3.00: configured for UDMA/133
[    1.561924] ata5.00: configured for UDMA/133
[    1.562695] ata6.00: configured for UDMA/133
[    1.599281] scsi 1:0:0:0: Direct-Access     ATA      Samsung SSD 840  
6B0Q PQ: 0 ANSI: 5
[    1.623106] hub 1-1:1.0: USB hub found
[    1.623163] hub 1-1:1.0: 4 ports detected
[    1.652807] scsi 2:0:0:0: Direct-Access     ATA      Samsung SSD 840  
BB6Q PQ: 0 ANSI: 5
[    1.702916] scsi 3:0:0:0: Direct-Access     ATA ST4000DM000-1F21 CC52 
PQ: 0 ANSI: 5
[    1.735132] usb 2-1: new SuperSpeed USB device number 2 using xhci_hcd
[    1.742785] scsi 4:0:0:0: Direct-Access     ATA      TOSHIBA DT01ACA2 
ABB0 PQ: 0 ANSI: 5
[    1.756386] hub 2-1:1.0: USB hub found
[    1.756694] hub 2-1:1.0: 4 ports detected
[    1.786296] scsi 5:0:0:0: Direct-Access     ATA      TOSHIBA DT01ACA2 
ABB0 PQ: 0 ANSI: 5
[    1.921824] usb 1-3: new high-speed USB device number 3 using xhci_hcd
[    2.054865] hub 1-3:1.0: USB hub found
[    2.055213] hub 1-3:1.0: 3 ports detected
[    2.108466] tsc: Refined TSC clocksource calibration: 3600.002 MHz
[    2.108482] clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 
0x33e4559ce44, max_idle_ns: 440795364889 ns
[    2.136613] ata8: SATA link down (SStatus 0 SControl 300)
[    2.143693] ata1.00: Enabling discard_zeroes_data
[    2.143713] ata2.00: Enabling discard_zeroes_data
[    2.143748] sd 0:0:0:0: [sda] 500118192 512-byte logical blocks: (256 
GB/238 GiB)
[    2.143779] sd 1:0:0:0: [sdb] 250069680 512-byte logical blocks: (128 
GB/119 GiB)
[    2.143811] sd 5:0:0:0: [sdf] 3907029168 512-byte logical blocks: 
(2.00 TB/1.82 TiB)
[    2.143812] sd 5:0:0:0: [sdf] 4096-byte physical blocks
[    2.143856] sd 3:0:0:0: [sdd] 7814037168 512-byte logical blocks: 
(4.00 TB/3.64 TiB)
[    2.143857] sd 2:0:0:0: [sdc] 1953525168 512-byte logical blocks: 
(1.00 TB/932 GiB)
[    2.143858] sd 3:0:0:0: [sdd] 4096-byte physical blocks
[    2.143976] sd 4:0:0:0: [sde] 3907029168 512-byte logical blocks: 
(2.00 TB/1.82 TiB)
[    2.143977] sd 4:0:0:0: [sde] 4096-byte physical blocks
[    2.144178] sd 0:0:0:0: [sda] Write Protect is off
[    2.144179] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.144227] sd 3:0:0:0: [sdd] Write Protect is off
[    2.144228] sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
[    2.144250] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.144286] sd 1:0:0:0: [sdb] Write Protect is off
[    2.144286] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.144353] sd 5:0:0:0: [sdf] Write Protect is off
[    2.144355] sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
[    2.144371] sd 2:0:0:0: [sdc] Write Protect is off
[    2.144372] sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
[    2.144380] sd 3:0:0:0: [sdd] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.144387] ata1.00: Enabling discard_zeroes_data
[    2.144407] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.144421] sd 2:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.144434] sd 4:0:0:0: [sde] Write Protect is off
[    2.144435] sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
[    2.144475] sd 4:0:0:0: [sde] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.144601] sd 5:0:0:0: [sdf] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    2.144606] ata2.00: Enabling discard_zeroes_data
[    2.146447]  sda: sda1 sda2 sda3 sda4 sda5
[    2.146801] ata1.00: Enabling discard_zeroes_data
[    2.147198] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.147258]  sdb: sdb1 sdb2
[    2.147442] ata2.00: Enabling discard_zeroes_data
[    2.147759] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.147900]  sdc: sdc1 sdc2
[    2.148622] sd 2:0:0:0: [sdc] Attached SCSI disk
[    2.158007] random: fast init done
[    2.175015] usb 1-5: new high-speed USB device number 4 using xhci_hcd
[    2.178100]  sde: sde1
[    2.179450] sd 4:0:0:0: [sde] Attached SCSI disk
[    2.203121] GPT:disk_guids don't match.
[    2.203124] GPT:partition_entry_array_crc32 values don't match: 
0xa45bd3ef != 0x6849bdb5
[    2.203126] GPT: Use GNU Parted to correct GPT errors.
[    2.203144]  sdf: sdf1
[    2.204157] sd 5:0:0:0: [sdf] Attached SCSI disk
[    2.213046]  sdd: sdd1 sdd2
[    2.213948] sd 3:0:0:0: [sdd] Attached SCSI disk
[    2.308952] hub 1-5:1.0: USB hub found
[    2.309248] hub 1-5:1.0: 4 ports detected
[    2.378344] usb 1-3.2: new full-speed USB device number 5 using xhci_hcd
[    2.580579] EXT4-fs (sdb2): mounted filesystem with ordered data 
mode. Opts: (null)
[    2.588436] usb 1-7: new full-speed USB device number 6 using xhci_hcd
[    2.689932] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.741070] systemd[1]: systemd 231 running in system mode. (+PAM 
-AUDIT -SELINUX -IMA -APPARMOR +SMACK -SYSVINIT +UTMP +LIBCRYPTSETUP 
+GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN)
[    2.741180] systemd[1]: Detected architecture x86-64.
[    2.741387] systemd[1]: Set hostname to <dev.luketic>.
[    2.791709] usb 1-3.3: new full-speed USB device number 7 using xhci_hcd
[    2.795787] systemd[1]: Listening on udev Kernel Socket.
[    2.795991] systemd[1]: Created slice User and Session Slice.
[    2.796055] systemd[1]: Created slice System Slice.
[    2.796087] systemd[1]: Reached target Slices.
[    2.796116] systemd[1]: Reached target Login Prompts.
[    2.796157] systemd[1]: Listening on Device-mapper event daemon FIFOs.
[    2.798907] systemd[1]: Listening on /dev/initctl Compatibility Named 
Pipe.
[    2.826984] EXT4-fs (sdb2): re-mounted. Opts: data=ordered
[    2.963909] input: Sleep Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0E:00/input/input2
[    2.963911] ACPI: Sleep Button [SLPB]
[    2.963958] input: Power Button as 
/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input3
[    2.963959] ACPI: Power Button [PWRB]
[    2.963984] input: Power Button as 
/devices/LNXSYSTM:00/LNXPWRBN:00/input/input4
[    2.963985] ACPI: Power Button [PWRF]
[    2.981923] FUJITSU Extended Socket Network Device Driver - version 
1.1 - Copyright (c) 2015 FUJITSU LIMITED
[    2.989726] hidraw: raw HID events driver (C) Jiri Kosina
[    2.995882] wmi: Mapper loaded
[    3.003970] Bluetooth: Core ver 2.21
[    3.003979] NET: Registered protocol family 31
[    3.003979] Bluetooth: HCI device and connection manager initialized
[    3.003981] Bluetooth: HCI socket layer initialized
[    3.003983] Bluetooth: L2CAP socket layer initialized
[    3.003986] Bluetooth: SCO socket layer initialized
[    3.005043] usb 1-8: new full-speed USB device number 8 using xhci_hcd
[    3.006630] systemd-journald[227]: Received request to flush runtime 
journal from PID 1
[    3.046969] thermal LNXTHERM:00: registered as thermal_zone0
[    3.046970] ACPI: Thermal Zone [TZ00] (28 C)
[    3.047124] thermal LNXTHERM:01: registered as thermal_zone1
[    3.047124] ACPI: Thermal Zone [TZ01] (30 C)
[    3.047153] Bluetooth: HCI UART driver ver 2.3
[    3.047154] Bluetooth: HCI UART protocol H4 registered
[    3.047154] Bluetooth: HCI UART protocol BCSP registered
[    3.047154] Bluetooth: HCI UART protocol LL registered
[    3.047155] Bluetooth: HCI UART protocol ATH3K registered
[    3.047155] Bluetooth: HCI UART protocol Three-wire (H5) registered
[    3.047190] Bluetooth: HCI UART protocol Intel registered
[    3.047198] Bluetooth: HCI UART protocol BCM registered
[    3.047199] Bluetooth: HCI UART protocol QCA registered
[    3.047200] Bluetooth: HCI UART protocol AG6XX registered
[    3.056398] input: PC Speaker as /devices/platform/pcspkr/input/input5
[    3.058645] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[    3.061226] EDAC MC: Ver: 3.0.0
[    3.061350] i801_smbus 0000:00:1f.4: enabling device (0001 -> 0003)
[    3.061531] i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
[    3.065602] random: crng init done
[    3.065620] pps_core: LinuxPPS API ver. 1 registered
[    3.065620] pps_core: Software ver. 5.3.6 - Copyright 2005-2007 
Rodolfo Giometti <giometti@linux.it>
[    3.067386] PTP clock support registered
[    3.069345] EDAC MC0: Giving out device to module ie31200_edac 
controller IE31200: DEV 0000:00:00.0 (POLLED)
[    3.085141] mei_me 0000:00:16.0: enabling device (0000 -> 0002)
[    3.086958] RAPL PMU: API unit is 2^-32 Joules, 5 fixed counters, 
655360 ms ovfl timer
[    3.086959] RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
[    3.086960] RAPL PMU: hw unit of domain package 2^-14 Joules
[    3.086960] RAPL PMU: hw unit of domain dram 2^-14 Joules
[    3.086961] RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
[    3.086961] RAPL PMU: hw unit of domain psys 2^-14 Joules
[    3.090779] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    3.090780] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    3.097027] [drm] Initialized drm 1.1.0 20060810
[    3.103081] e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec) 
set to dynamic conservative mode
[    3.111434] AVX2 version of gcm_enc/dec engaged.
[    3.111435] AES CTR mode by8 optimization enabled
[    3.122073] clocksource: Switched to clocksource tsc
[    3.146245] iTCO_vendor_support: vendor-support=0
[    3.148304] iTCO_wdt: Intel TCO WatchDog Timer Driver v1.11
[    3.148449] iTCO_wdt: Found a Intel PCH TCO device (Version=4, 
TCOBASE=0x0400)
[    3.148614] iTCO_wdt: initialized. heartbeat=30 sec (nowayout=0)
[    3.148982] intel_rapl: Found RAPL domain package
[    3.148983] intel_rapl: Found RAPL domain core
[    3.148985] intel_rapl: Found RAPL domain dram
[    3.154251] usbcore: registered new interface driver usbhid
[    3.154252] usbhid: USB HID core driver
[    3.154284] media: Linux media interface: v0.10
[    3.157190] input: Logitech Gaming Mouse G502 as 
/devices/pci0000:00/0000:00:14.0/usb1/1-7/1-7:1.0/0003:046D:C07D.0001/input/input7
[    3.157372] hid-generic 0003:046D:C07D.0001: input,hidraw0: USB HID 
v1.11 Mouse [Logitech Gaming Mouse G502] on usb-0000:00:14.0-7/input0
[    3.157392] Linux video capture interface: v2.00
[    3.158292] input: Logitech Gaming Mouse G502 as 
/devices/pci0000:00/0000:00:14.0/usb1/1-7/1-7:1.1/0003:046D:C07D.0002/input/input8
[    3.158898] gspca_main: v2.14.0 registered
[    3.159040] input: ROCCAT ROCCAT Ryos MK Pro as 
/devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3.3/1-3.3:1.0/0003:1E7D:3232.0003/input/input9
[    3.160050] gspca_main: gspca_zc3xx-2.14.0 probing 046d:08ad
[    3.193974] nvidia: loading out-of-tree module taints kernel.
[    3.193978] nvidia: module license 'NVIDIA' taints kernel.
[    3.193978] Disabling lock debugging due to kernel taint
[    3.199448] vgaarb: device changed decodes: 
PCI:0000:01:00.0,olddecodes=io+mem,decodes=none:owns=io+mem
[    3.199495] nvidia-nvlink: Nvlink Core is being initialized, major 
device number 239
[    3.199504] NVRM: loading NVIDIA UNIX x86_64 Kernel Module 375.10  
Fri Oct 14 10:30:06 PDT 2016 (using threaded interrupts)
[    3.204645] nvidia-modeset: Loading NVIDIA Kernel Mode Setting Driver 
for UNIX platforms  375.10  Fri Oct 14 10:05:55 PDT 2016
[    3.205786] [drm] [nvidia-drm] [GPU ID 0x00000100] Loading driver
[    3.215102] hid-generic 0003:046D:C07D.0002: input,hiddev0,hidraw1: 
USB HID v1.11 Keyboard [Logitech Gaming Mouse G502] on 
usb-0000:00:14.0-7/input1
[    3.215288] input: RODE Microphones RODE NT-USB as 
/devices/pci0000:00/0000:00:14.0/usb1/1-8/1-8:1.3/0003:19F7:0003.0005/input/input10
[    3.227116] md: bind<sde1>
[    3.260377] md: bind<sdf1>
[    3.265152] md: raid10 personality registered for level 10
[    3.265305] md/raid10:md127: not clean -- starting background 
reconstruction
[    3.265306] md/raid10:md127: active with 2 out of 2 devices
[    3.265354] created bitmap (15 pages) for device md127
[    3.265904] md127: bitmap initialized from disk: read 1 pages, set 
17142 of 29807 bits
[    3.271712] ryos 0003:1E7D:3232.0003: input,hidraw2: USB HID v1.11 
Keyboard [ROCCAT ROCCAT Ryos MK Pro] on usb-0000:00:14.0-3.3/input0
[    3.294230] input: ROCCAT ROCCAT Ryos MK Pro as 
/devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3.3/1-3.3:1.1/0003:1E7D:3232.0004/input/input11
[    3.328364] hid-generic 0003:19F7:0003.0005: input,hiddev0,hidraw3: 
USB HID v1.00 Device [RODE Microphones RODE NT-USB] on 
usb-0000:00:14.0-8/input3
[    3.344809] md127: detected capacity change from 0 to 2000263577600
[    3.385022] ryos 0003:1E7D:3232.0004: input,hiddev0,hidraw4: USB HID 
v1.11 Pointer [ROCCAT ROCCAT Ryos MK Pro] on usb-0000:00:14.0-3.3/input1
[    3.385065] mousedev: PS/2 mouse device common for all mice
[    3.528818] e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): 
registered PHC clock
[    3.615666] e1000e 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) 
40:8d:5c:e2:ab:79
[    3.615670] e1000e 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network 
Connection
[    3.615753] e1000e 0000:00:1f.6 eth0: MAC: 12, PHY: 12, PBA No: 
FFFFFF-0FF
[    3.616046] snd_hda_intel 0000:01:00.1: Disabling MSI
[    3.616048] snd_hda_intel 0000:01:00.1: Handle vga_switcheroo audio 
client
[    3.617523] e1000e 0000:00:1f.6 enp0s31f6: renamed from eth0
[    3.633037] snd_hda_codec_ca0132 hdaudioC0D0: autoconfig for CA0132: 
line_outs=1 (0xb/0x0/0x0/0x0/0x0) type:line
[    3.633038] snd_hda_codec_ca0132 hdaudioC0D0:    speaker_outs=0 
(0x0/0x0/0x0/0x0/0x0)
[    3.633039] snd_hda_codec_ca0132 hdaudioC0D0:    hp_outs=1 
(0x10/0x0/0x0/0x0/0x0)
[    3.633039] snd_hda_codec_ca0132 hdaudioC0D0:    mono: mono_out=0x0
[    3.633040] snd_hda_codec_ca0132 hdaudioC0D0: dig-out=0xc/0x0
[    3.633040] snd_hda_codec_ca0132 hdaudioC0D0:    inputs:
[    3.633041] snd_hda_codec_ca0132 hdaudioC0D0:      Mic=0x12
[    3.633041] snd_hda_codec_ca0132 hdaudioC0D0:      Line=0x11
[    3.931157] NVRM: Your system is not currently configured to drive a 
VGA console
[    3.931161] NVRM: on the primary VGA device. The NVIDIA Linux 
graphics driver
[    3.931163] NVRM: requires the use of a text-mode VGA console. Use of 
other console
[    3.931165] NVRM: drivers including, but not limited to, vesafb, may 
result in
[    3.931166] NVRM: corruption and stability problems, and is not 
supported.
[    3.933054] nvidia-modeset: Allocated GPU:0 
(GPU-446ab0ba-a3a7-d22e-51af-ccc1c8b89978) @ PCI:0000:01:00.0
[    4.199124] input: gspca_zc3xx as 
/devices/pci0000:00/0000:00:14.0/usb1/1-3/1-3.2/input/input13
[    4.199466] usbcore: registered new interface driver gspca_zc3xx
[    4.211219] usbcore: registered new interface driver snd-usb-audio
[    4.225163] snd_hda_codec_ca0132 hdaudioC0D0: ca0132 DSP downloaded 
and running
[    4.232110] input: HDA NVidia HDMI/DP,pcm=3 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input12
[    4.232150] input: HDA NVidia HDMI/DP,pcm=7 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input14
[    4.232183] input: HDA NVidia HDMI/DP,pcm=8 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input15
[    4.232442] input: HDA NVidia HDMI/DP,pcm=9 as 
/devices/pci0000:00/0000:00:01.0/0000:01:00.1/sound/card1/input16
[    4.581159] input: HDA Intel PCH Front Line Out as 
/devices/pci0000:00/0000:00:1f.3/sound/card0/input17
[    4.581300] input: HDA Intel PCH Line Out as 
/devices/pci0000:00/0000:00:1f.3/sound/card0/input18
[    4.581425] input: HDA Intel PCH Front Headphone as 
/devices/pci0000:00/0000:00:1f.3/sound/card0/input19
[    5.375225] snd_hda_codec_ca0132 hdaudioC0D0: ca0132 DSP downloaded 
and running


On 05.11.2016 21:20, Phil Turmel wrote:
> On 11/05/2016 10:10 AM, Darko Luketic wrote:
>
>> Now. I'd like to save whatever data is possible to be saved.
>>
>> I'd like to force the 2 drives to be recognized as being in a RAID10
>> array. By whatever means necessary, without losing more data.
> You haven't provided anywhere near enough data to advise you.  At the
> very least, provide "mdadm -E /dev/sdXn" for each member device and your
> dmesg from the current environment, plus syslogs showing the last
> assembly of the raid10 you think you want.  Paste inline, please.
>
> If you can, run lsdrv[1] on your current environment and paste that in
> your reply as well.
>
> Phil
>
> [1] https://github.com/pturmel/lsdrv
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


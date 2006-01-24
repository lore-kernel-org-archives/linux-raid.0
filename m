From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Problems with multiple Promise SATA150 TX4 cards
Date: Tue, 24 Jan 2006 13:01:51 +1100
Message-ID: <43D58A8F.6040907@nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is probably not entirely the right list for this query, but I 
figure there's enough people here who have experience in the right 
places and have probably tried this sort of thing themselves.  Apologies 
to anyone whose time I waste.

Or, at the very least, I'm sure someone here can point me in the right 
direction :).

I currently have a machine with two Promise SATA150 TX4 cards (PDC20318, 
http://www.promise.com/product/product_detail_eng.asp?segment=undefined&product_id=98#) 
and a 4-drive RAID5 array attached to each.  Since I was nearly out of 
space, I decided it was time to add another 4 drives and expand again. 
So, I bought another TX4 card and another 4 SATA drives and plonked them 
in the machine, thinking it would be as easy as the last time I did it 
(going from 4 to 8 drives).

The first problem is that the Promise cards' onboard BIOS(es) only 
recognise(s) (or, at least, list) 8 of the 12 drives in the machine at 
boot.  However, once Linux has booted it detects all three cards and all 
twelve drives, so this is a relatively insignificant issue.

The second (major) problem is whenever I try to access drives attached 
to the "first" controller (ie: /dev/sd[abcd], I get ATA timeout errors 
like these:

ata3: status=0x51 { DriveReady SeekComplete Error }
ata3: error=0x0c { DriveStatusError }
ata3: status=0x51 { DriveReady SeekComplete Error }
ata3: error=0x0c { DriveStatusError }
ata2: status=0x51 { DriveReady SeekComplete Error }
ata2: error=0x0c { DriveStatusError }
ata2: status=0x51 { DriveReady SeekComplete Error }
ata2: error=0x0c { DriveStatusError }

This _only_ happens when accessing drives attached to the "first" 
controller.  I can have 8 simultaneous 'dd if=/dev/sdX of=/dev/null' 
happening to the other 8 drives for minutes at a time without a problem, 
but as soon as I fire up a dd to /dev/sd[abcd], I get the errors listed 
above within seconds.

Additionally, a dd to only /dev/sd[abcd] with no other system activity 
also produces the errors - again within seconds.

I have shuffled the cards,cables and physical drives around to determine 
that this is not a problem with any of them individually - no matter the 
combination, it only ever happens to drives that are at sd[abcd] (ie: if 
I rejig the hardware so the drive at /dev/sdh, which was working fine, 
is on a different cable and controller, but appears at /dev/sdb, it will 
produce the errors).

Removing cards so there are only one or two in the system results in no 
errors.  Similarly, I tried shuffling the hardware around to verify that 
no individual card, cable or drive was responsible.  The errors _only_ 
occur with three cards in the system, _only_ with whichever drives are 
attached to the "first" controller (ie: sd[abcd]) and _regardless_ of 
other system activity.

I'm trying to locate where the problem is so I can suggest to the right 
people that they fix it :).  Any suggestions people might have that 
could possibly workaround (PCI timings ?) or further contacts will be 
gratefully accepted and tried.

Cheers,
CS

PS: Here are the outputs of 'dmesg' and 'lspci -vvv' for my system:

dmesg:
[root@terminus ~]# dmesg
Linux version 2.6.14-1.1656_FC4smp (bhcompile@tweety.build.redhat.com) 
(gcc version 4.0.2 20051125 (Red Hat 4.0.2-8)) #1 SMP Thu Jan 5 22:24:06 
EST 2006
BIOS-provided physical RAM map:
  BIOS-e820: 0000000000000000 - 000000000009d800 (usable)
  BIOS-e820: 000000000009d800 - 000000000009f800 (reserved)
  BIOS-e820: 00000000000e0000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 000000007fff0000 (usable)
  BIOS-e820: 000000007fff0000 - 000000007ffff000 (ACPI data)
  BIOS-e820: 000000007ffff000 - 0000000080000000 (ACPI NVS)
  BIOS-e820: 00000000fec00000 - 00000000fed00000 (reserved)
  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
  BIOS-e820: 00000000fff80000 - 0000000100000000 (reserved)
1151MB HIGHMEM available.
896MB LOWMEM available.
found SMP MP-table at 000ff780
Using x86 segment limits to approximate NX protection
On node 0 totalpages: 524272
   DMA zone: 4096 pages, LIFO batch:1
   Normal zone: 225280 pages, LIFO batch:31
   HighMem zone: 294896 pages, LIFO batch:31
DMI 2.3 present.
Using APIC driver default
ACPI: RSDP (v000 ACPIAM                                ) @ 0x000f62f0
ACPI: RSDT (v001 A M I  OEMRSDT  0x01000412 MSFT 0x00000097) @ 0x7fff0000
ACPI: FADT (v001 A M I  OEMFACP  0x01000412 MSFT 0x00000097) @ 0x7fff0200
ACPI: MADT (v001 A M I  OEMAPIC  0x01000412 MSFT 0x00000097) @ 0x7fff0300
ACPI: OEMB (v001 A M I  OEMBIOS  0x01000412 MSFT 0x00000097) @ 0x7ffff040
ACPI: DSDT (v001  0AAYB 0AAYB007 0x00000007 MSFT 0x0100000d) @ 0x00000000
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x00] enabled)
Processor #0 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x06] enabled)
Processor #6 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x01] enabled)
Processor #1 15:2 APIC version 20
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x07] enabled)
Processor #7 15:2 APIC version 20
ACPI: IOAPIC (id[0x08] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 8, version 32, address 0xfec00000, GSI 0-23
ACPI: IOAPIC (id[0x09] address[0xfec80000] gsi_base[24])
IOAPIC[1]: apic_id 9, version 32, address 0xfec80000, GSI 24-47
ACPI: IOAPIC (id[0x0a] address[0xfec80400] gsi_base[48])
IOAPIC[2]: apic_id 10, version 32, address 0xfec80400, GSI 48-71
ACPI: IOAPIC (id[0x0b] address[0xfec81000] gsi_base[72])
IOAPIC[3]: apic_id 11, version 32, address 0xfec81000, GSI 72-95
ACPI: IOAPIC (id[0x0c] address[0xfec81400] gsi_base[96])
IOAPIC[4]: apic_id 12, version 32, address 0xfec81400, GSI 96-119
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 5 I/O APICs
Using ACPI (MADT) for SMP configuration information
Allocating PCI resources starting at 88000000 (gap: 80000000:7ec00000)
Built 1 zonelists
Kernel command line: ro root=/dev/vg_data/lv_root console=tty0 
console=ttyS0,115200
mapped APIC to ffffd000 (fee00000)
mapped IOAPIC to ffffc000 (fec00000)
mapped IOAPIC to ffffb000 (fec80000)
mapped IOAPIC to ffffa000 (fec80400)
mapped IOAPIC to ffff9000 (fec81000)
mapped IOAPIC to ffff8000 (fec81400)
Initializing CPU#0
CPU 0 irqstacks, hard=c0448000 soft=c0428000
PID hash table entries: 4096 (order: 12, 65536 bytes)
Detected 2791.076 MHz processor.
Using pmtmr for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
Memory: 2071596k/2097088k available (2167k kernel code, 24188k reserved, 
814k data, 224k init, 1179584k highmem)
Checking if this processor honours the WP bit even in supervisor mode... Ok.
Calibrating delay using timer specific routine.. 5587.77 BogoMIPS 
(lpj=11175541)
Security Framework v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 
00004400 00000000 00000000
CPU: After vendor identify, caps: bfebfbff 00000000 00000000 00000000 
00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebf3ff 00000000 00000000 00000080 00004400 
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU0: Thermal monitoring enabled
mtrr: v2.0 (20020519)
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
CPU0: Intel(R) Xeon(TM) CPU 2.80GHz stepping 05
Booting processor 1/1 eip 2000
CPU 1 irqstacks, hard=c0449000 soft=c0429000
Initializing CPU#1
Calibrating delay using timer specific routine.. 5581.81 BogoMIPS 
(lpj=11163622)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 
00004400 00000000 00000000
CPU: After vendor identify, caps: bfebfbff 00000000 00000000 00000000 
00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 0
CPU: After all inits, caps: bfebf3ff 00000000 00000000 00000080 00004400 
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#1.
CPU1: Intel P4/Xeon Extended MCE MSRs (12) available
CPU1: Thermal monitoring enabled
CPU1: Intel(R) Xeon(TM) CPU 2.80GHz stepping 05
Booting processor 2/6 eip 2000
CPU 2 irqstacks, hard=c044a000 soft=c042a000
Initializing CPU#2
Calibrating delay using timer specific routine.. 5581.93 BogoMIPS 
(lpj=11163871)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 
00004400 00000000 00000000
CPU: After vendor identify, caps: bfebfbff 00000000 00000000 00000000 
00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebf3ff 00000000 00000000 00000080 00004400 
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#2.
CPU2: Intel P4/Xeon Extended MCE MSRs (12) available
CPU2: Thermal monitoring enabled
CPU2: Intel(R) Xeon(TM) CPU 2.80GHz stepping 05
Booting processor 3/7 eip 2000
CPU 3 irqstacks, hard=c044b000 soft=c042b000
Initializing CPU#3
Calibrating delay using timer specific routine.. 5582.11 BogoMIPS 
(lpj=11164230)
CPU: After generic identify, caps: bfebfbff 00000000 00000000 00000000 
00004400 00000000 00000000
CPU: After vendor identify, caps: bfebfbff 00000000 00000000 00000000 
00004400 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: Physical Processor ID: 3
CPU: After all inits, caps: bfebf3ff 00000000 00000000 00000080 00004400 
00000000 00000000
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#3.
CPU3: Intel P4/Xeon Extended MCE MSRs (12) available
CPU3: Thermal monitoring enabled
CPU3: Intel(R) Xeon(TM) CPU 2.80GHz stepping 05
Total of 4 processors activated (22333.63 BogoMIPS).
ENABLING IO-APIC IRQs
..TIMER: vector=0x31 pin1=2 pin2=-1
checking TSC synchronization across 4 CPUs: passed.
Brought up 4 CPUs
checking if image is initramfs... it is
Freeing initrd memory: 1980k freed
NET: Registered protocol family 16
ACPI: bus type pci registered
PCI: PCI BIOS revision 2.10 entry at 0xf0031, last bus=7
PCI: Using configuration type 1
ACPI: Subsystem revision 20050916
ACPI: Interpreter enabled
ACPI: Using IOAPIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (0000:00)
PCI: Probing PCI hardware (bus 00)
PCI quirk: region 0400-047f claimed by ICH4 ACPI/GPIO/TCO
PCI quirk: region 0500-053f claimed by ICH4 GPIO
PCI: Ignoring BAR0-3 of IDE controller 0000:00:1f.1
Boot video device is 0000:07:0c.0
PCI: Transparent bridge - 0000:00:1e.0
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1.P1P2._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1.P1P3._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4.P4P5._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P4.P4P6._PRT]
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P7._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 5 6 7 *9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKB] (IRQs 3 4 5 6 7 9 10 *11 12 14 15)
ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 *5 6 7 9 10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 6 7 9 *10 11 12 14 15)
ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, 
disabled.
ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 6 7 9 10 11 12 14 15) *0, 
disabled.
Linux Plug and Play Support v0.97 (c) Adam Belay
pnp: PnP ACPI init
pnp: PnP ACPI: found 11 devices
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
PCI: If a device doesn't work, try "pci=routeirq".  If it helps, post a 
report
PCI: Bridge: 0000:01:1d.0
   IO window: 9000-9fff
   MEM window: fc400000-fc4fffff
   PREFETCH window: ff300000-ff3fffff
PCI: Bridge: 0000:01:1f.0
   IO window: a000-afff
   MEM window: fc500000-fc5fffff
   PREFETCH window: ff400000-ff4fffff
PCI: Bridge: 0000:00:02.0
   IO window: 9000-afff
   MEM window: fc400000-fc6fffff
   PREFETCH window: ff300000-ff5fffff
PCI: Bridge: 0000:04:1d.0
   IO window: b000-bfff
   MEM window: fc700000-fc7fffff
   PREFETCH window: ff600000-ff6fffff
PCI: Bridge: 0000:04:1f.0
   IO window: c000-cfff
   MEM window: fc800000-fc8fffff
   PREFETCH window: ff700000-ff7fffff
PCI: Bridge: 0000:00:03.0
   IO window: b000-cfff
   MEM window: fc700000-fc9fffff
   PREFETCH window: ff600000-ff8fffff
PCI: Bridge: 0000:00:1e.0
   IO window: d000-dfff
   MEM window: fca00000-feafffff
   PREFETCH window: ff900000-ff9fffff
PCI: Setting latency timer of device 0000:00:1e.0 to 64
apm: BIOS version 1.2 Flags 0x03 (Driver version 1.16ac)
apm: disabled - APM is not SMP safe.
audit: initializing netlink socket (disabled)
audit(1138059504.676:1): initialized
highmem bounce pool size: 64 pages
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
Initializing Cryptographic API
ksign: Installing public key data
Loading keyring
- Added public key 86D1D7472B6BE898
- User ID: Red Hat, Inc. (Kernel Module GPG key)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
ACPI: CPU0 (power states: C1[C1])
ACPI: Processor [CPU1] (supports 8 throttling states)
ACPI: CPU2 (power states: C1[C1])
ACPI: CPU1 (power states: C1[C1])
ACPI: CPU3 (power states: C1[C1])
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12
Linux agpgart interface v0.101 (c) Dave Jones
PNP: PS/2 Controller [PNP0303:PS2K] at 0x60,0x64 irq 1
PNP: PS/2 controller doesn't have AUX irq; using default 12
serio: i8042 AUX port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 32 ports, IRQ sharing enabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
io scheduler noop registered
io scheduler anticipatory registered
io scheduler deadline registered
io scheduler cfq registered
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
ICH3: IDE controller at PCI slot 0000:00:1f.1
PCI: Enabling device 0000:00:1f.1 (0005 -> 0007)
ACPI: PCI Interrupt 0000:00:1f.1[A] -> GSI 18 (level, low) -> IRQ 169
ICH3: chipset revision 2
ICH3: not 100% native mode: will probe irqs later
     ide0: BM-DMA at 0xffa0-0xffa7, BIOS settings: hda:DMA, hdb:pio
     ide1: BM-DMA at 0xffa8-0xffaf, BIOS settings: hdc:pio, hdd:DMA
Probing IDE interface ide0...
hda: QUANTUM FIREBALL ST2.1A, ATA DISK drive
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdd: ST3120022A, ATA DISK drive
ide1 at 0x170-0x177,0x376 on irq 15
hda: max request size: 128KiB
hda: 4124736 sectors (2111 MB) w/81KiB Cache, CHS=4092/16/63, UDMA(33)
hda: cache flushes not supported
  hda: hda1
hdd: max request size: 1024KiB
hdd: 234441648 sectors (120034 MB) w/2048KiB Cache, CHS=16383/255/63, 
UDMA(100)
hdd: cache flushes supported
  hdd: hdd1
ide-floppy driver 0.99.newide
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.6:USB HID core driver
mice: PS/2 mouse device common for all mice
md: md driver 0.90.2 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: bitmap version 3.39
NET: Registered protocol family 2
input: AT Translated Set 2 keyboard on isa0060/serio0
IP route cache hash table entries: 131072 (order: 7, 524288 bytes)
TCP established hash table entries: 131072 (order: 9, 2621440 bytes)
TCP bind hash table entries: 65536 (order: 8, 1310720 bytes)
TCP: Hash tables configured (established 131072 bind 65536)
TCP reno registered
TCP bic registered
Initializing IPsec netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
Using IPI Shortcut mode
Freeing unused kernel memory: 224k freed
Write protecting the kernel read-only data: 336k
SCSI subsystem initialized
libata version 1.12 loaded.
sata_promise version 1.02
ACPI: PCI Interrupt 0000:02:02.0[A] -> GSI 52 (level, low) -> IRQ 177
ata1: SATA max UDMA/133 cmd 0xF8806200 ctl 0xF8806238 bmdma 0x0 irq 177
ata2: SATA max UDMA/133 cmd 0xF8806280 ctl 0xF88062B8 bmdma 0x0 irq 177
ata3: SATA max UDMA/133 cmd 0xF8806300 ctl 0xF8806338 bmdma 0x0 irq 177
ata4: SATA max UDMA/133 cmd 0xF8806380 ctl 0xF88063B8 bmdma 0x0 irq 177
ata1: SATA link up 1.5 Gbps (SStatus 113)
ata1: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4023 85:3469 86:3c01 87:4023 
88:407f
ata1: dev 0 ATA, max UDMA/133, 488397168 sectors: lba48
ata1: dev 0 configured for UDMA/133
scsi0 : sata_promise
ata2: SATA link up 1.5 Gbps (SStatus 113)
ata2: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4023 85:3469 86:3c01 87:4023 
88:407f
ata2: dev 0 ATA, max UDMA/133, 488397168 sectors: lba48
ata2: dev 0 configured for UDMA/133
scsi1 : sata_promise
ata3: SATA link up 1.5 Gbps (SStatus 113)
ata3: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4023 85:3469 86:3c01 87:4023 
88:407f
ata3: dev 0 ATA, max UDMA/133, 488397168 sectors: lba48
ata3: dev 0 configured for UDMA/133
scsi2 : sata_promise
ata4: SATA link up 1.5 Gbps (SStatus 113)
ata4: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4023 85:3469 86:3c01 87:4023 
88:407f
ata4: dev 0 ATA, max UDMA/133, 488397168 sectors: lba48
ata4: dev 0 configured for UDMA/133
scsi3 : sata_promise
   Vendor: ATA       Model: ST3250823AS       Rev: 3.01
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sda: drive cache: write back
  sda: sda1
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
   Vendor: ATA       Model: ST3250823AS       Rev: 3.01
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdb: drive cache: write back
  sdb: sdb1
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
   Vendor: ATA       Model: ST3250823AS       Rev: 3.01
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdc: drive cache: write back
SCSI device sdc: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdc: drive cache: write back
  sdc: sdc1
Attached scsi disk sdc at scsi2, channel 0, id 0, lun 0
   Vendor: ATA       Model: ST3250823AS       Rev: 3.01
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdd: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdd: drive cache: write back
SCSI device sdd: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdd: drive cache: write back
  sdd: sdd1
Attached scsi disk sdd at scsi3, channel 0, id 0, lun 0
ACPI: PCI Interrupt 0000:05:02.0[A] -> GSI 96 (level, low) -> IRQ 185
ata5: SATA max UDMA/133 cmd 0xF882A200 ctl 0xF882A238 bmdma 0x0 irq 185
ata6: SATA max UDMA/133 cmd 0xF882A280 ctl 0xF882A2B8 bmdma 0x0 irq 185
ata7: SATA max UDMA/133 cmd 0xF882A300 ctl 0xF882A338 bmdma 0x0 irq 185
ata8: SATA max UDMA/133 cmd 0xF882A380 ctl 0xF882A3B8 bmdma 0x0 irq 185
ata5: SATA link up 1.5 Gbps (SStatus 113)
ata5: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4023 85:3469 86:3c01 87:4023 
88:407f
ata5: dev 0 ATA, max UDMA/133, 488397168 sectors: lba48
ata5: dev 0 configured for UDMA/133
scsi4 : sata_promise
ata6: SATA link up 1.5 Gbps (SStatus 113)
ata6: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4023 85:3469 86:3c01 87:4023 
88:407f
ata6: dev 0 ATA, max UDMA/133, 488397168 sectors: lba48
ata6: dev 0 configured for UDMA/133
scsi5 : sata_promise
ata7: SATA link up 1.5 Gbps (SStatus 113)
ata7: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4023 85:3469 86:3c01 87:4023 
88:407f
ata7: dev 0 ATA, max UDMA/133, 488397168 sectors: lba48
ata7: dev 0 configured for UDMA/133
scsi6 : sata_promise
ata8: SATA link up 1.5 Gbps (SStatus 113)
ata8: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4023 85:3469 86:3c01 87:4023 
88:407f
ata8: dev 0 ATA, max UDMA/133, 488397168 sectors: lba48
ata8: dev 0 configured for UDMA/133
scsi7 : sata_promise
   Vendor: ATA       Model: ST3250823AS       Rev: 3.04
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sde: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sde: drive cache: write back
SCSI device sde: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sde: drive cache: write back
  sde: unknown partition table
Attached scsi disk sde at scsi4, channel 0, id 0, lun 0
   Vendor: ATA       Model: ST3250823AS       Rev: 3.03
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdf: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdf: drive cache: write back
SCSI device sdf: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdf: drive cache: write back
  sdf: unknown partition table
Attached scsi disk sdf at scsi5, channel 0, id 0, lun 0
   Vendor: ATA       Model: ST3250823AS       Rev: 3.03
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdg: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdg: drive cache: write back
SCSI device sdg: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdg: drive cache: write back
  sdg: unknown partition table
Attached scsi disk sdg at scsi6, channel 0, id 0, lun 0
   Vendor: ATA       Model: ST3250824AS       Rev: 3.AA
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdh: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdh: drive cache: write back
SCSI device sdh: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdh: drive cache: write back
  sdh: unknown partition table
Attached scsi disk sdh at scsi7, channel 0, id 0, lun 0
ACPI: PCI Interrupt 0000:06:02.0[A] -> GSI 72 (level, low) -> IRQ 193
ata9: SATA max UDMA/133 cmd 0xF882C200 ctl 0xF882C238 bmdma 0x0 irq 193
ata10: SATA max UDMA/133 cmd 0xF882C280 ctl 0xF882C2B8 bmdma 0x0 irq 193
ata11: SATA max UDMA/133 cmd 0xF882C300 ctl 0xF882C338 bmdma 0x0 irq 193
ata12: SATA max UDMA/133 cmd 0xF882C380 ctl 0xF882C3B8 bmdma 0x0 irq 193
ata9: SATA link up 1.5 Gbps (SStatus 113)
ata9: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4023 85:3469 86:3c01 87:4023 
88:407f
ata9: dev 0 ATA, max UDMA/133, 488397168 sectors: lba48
ata9: dev 0 configured for UDMA/133
scsi8 : sata_promise
ata10: SATA link up 1.5 Gbps (SStatus 113)
ata10: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4023 85:3469 86:3c01 87:4023 
88:407f
ata10: dev 0 ATA, max UDMA/133, 488397168 sectors: lba48
ata10: dev 0 configured for UDMA/133
scsi9 : sata_promise
ata11: SATA link up 1.5 Gbps (SStatus 113)
ata11: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4023 85:3469 86:3c01 87:4023 
88:407f
ata11: dev 0 ATA, max UDMA/133, 488397168 sectors: lba48
ata11: dev 0 configured for UDMA/133
scsi10 : sata_promise
ata12: SATA link up 1.5 Gbps (SStatus 113)
ata12: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4023 85:3469 86:3c01 87:4023 
88:407f
ata12: dev 0 ATA, max UDMA/133, 488397168 sectors: lba48
ata12: dev 0 configured for UDMA/133
scsi11 : sata_promise
   Vendor: ATA       Model: ST3250823AS       Rev: 3.04
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdi: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdi: drive cache: write back
SCSI device sdi: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdi: drive cache: write back
  sdi: sdi1
Attached scsi disk sdi at scsi8, channel 0, id 0, lun 0
   Vendor: ATA       Model: ST3250823AS       Rev: 3.04
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdj: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdj: drive cache: write back
SCSI device sdj: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdj: drive cache: write back
  sdj: sdj1
Attached scsi disk sdj at scsi9, channel 0, id 0, lun 0
   Vendor: ATA       Model: ST3250823AS       Rev: 3.04
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdk: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdk: drive cache: write back
SCSI device sdk: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdk: drive cache: write back
  sdk: sdk1
Attached scsi disk sdk at scsi10, channel 0, id 0, lun 0
   Vendor: ATA       Model: ST3250823AS       Rev: 3.04
   Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdl: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdl: drive cache: write back
SCSI device sdl: 488397168 512-byte hdwr sectors (250059 MB)
SCSI device sdl: drive cache: write back
  sdl: sdl1
Attached scsi disk sdl at scsi11, channel 0, id 0, lun 0
device-mapper: 4.4.0-ioctl (2005-01-12) initialised: dm-devel@redhat.com
raid5: automatically using best checksumming function: pIII_sse
    pIII_sse  :  3612.000 MB/sec
raid5: using function: pIII_sse (3612.000 MB/sec)
md: raid5 personality registered as nr 4
md: Autodetecting RAID arrays.
md: invalid raid superblock magic on sda1
md: sda1 has invalid sb, not importing!
md: invalid raid superblock magic on sdb1
md: sdb1 has invalid sb, not importing!
md: invalid raid superblock magic on sdc1
md: sdc1 has invalid sb, not importing!
md: invalid raid superblock magic on sdd1
md: sdd1 has invalid sb, not importing!
md: autorun ...
md: ... autorun DONE.
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
ReiserFS: dm-4: found reiserfs format "3.6" with standard journal
ReiserFS: dm-4: using ordered data mode
ReiserFS: dm-4: journal params: device dm-4, size 8192, journal first 
block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
ReiserFS: dm-4: checking transaction log (dm-4)
ReiserFS: dm-4: Using r5 hash to sort names
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
Floppy drive(s): fd0 is 1.44M
FDC 0 is a National Semiconductor PC87306
Intel(R) PRO/1000 Network Driver - version 6.0.60-k2-NAPI
Copyright (c) 1999-2005 Intel Corporation.
ACPI: PCI Interrupt 0000:03:02.0[A] -> GSI 24 (level, low) -> IRQ 201
e1000: eth0: e1000_probe: Intel(R) PRO/1000 Network Connection
shpchp: shpc_init : shpc_cap_offset == 0
shpchp: shpc_init : shpc_cap_offset == 0
shpchp: shpc_init : shpc_cap_offset == 0
shpchp: shpc_init : shpc_cap_offset == 0
shpchp: shpc_init : shpc_cap_offset == 0
shpchp: shpc_init : shpc_cap_offset == 0
shpchp: shpc_init : shpc_cap_offset == 0
shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
hw_random hardware driver 1.0.0 loaded
USB Universal Host Controller Interface driver v2.3
ACPI: PCI Interrupt 0000:00:1d.0[A] -> GSI 16 (level, low) -> IRQ 209
PCI: Setting latency timer of device 0000:00:1d.0 to 64
uhci_hcd 0000:00:1d.0: UHCI Host Controller
uhci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 1
uhci_hcd 0000:00:1d.0: irq 209, io base 0x0000ec00
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.1[B] -> GSI 19 (level, low) -> IRQ 217
PCI: Setting latency timer of device 0000:00:1d.1 to 64
uhci_hcd 0000:00:1d.1: UHCI Host Controller
uhci_hcd 0000:00:1d.1: new USB bus registered, assigned bus number 2
uhci_hcd 0000:00:1d.1: irq 217, io base 0x0000e880
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI Interrupt 0000:00:1d.2[C] -> GSI 18 (level, low) -> IRQ 169
PCI: Setting latency timer of device 0000:00:1d.2 to 64
uhci_hcd 0000:00:1d.2: UHCI Host Controller
uhci_hcd 0000:00:1d.2: new USB bus registered, assigned bus number 3
uhci_hcd 0000:00:1d.2: irq 169, io base 0x0000e800
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: Power Button (FF) [PWRF]
ibm_acpi: ec object not found
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
kjournald starting.  Commit interval 5 seconds
EXT3 FS on hda1, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
ReiserFS: dm-5: found reiserfs format "3.6" with standard journal
ReiserFS: dm-5: using ordered data mode
ReiserFS: dm-5: journal params: device dm-5, size 8192, journal first 
block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
ReiserFS: dm-5: checking transaction log (dm-5)
ReiserFS: dm-5: Using r5 hash to sort names
ReiserFS: dm-1: found reiserfs format "3.6" with standard journal
ReiserFS: dm-1: using ordered data mode
ReiserFS: dm-1: journal params: device dm-1, size 8192, journal first 
block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
ReiserFS: dm-1: checking transaction log (dm-1)
ReiserFS: dm-1: Using r5 hash to sort names
ReiserFS: dm-2: found reiserfs format "3.6" with standard journal
ReiserFS: dm-2: using ordered data mode
ReiserFS: dm-2: journal params: device dm-2, size 8192, journal first 
block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
ReiserFS: dm-2: checking transaction log (dm-2)
ReiserFS: dm-2: Using r5 hash to sort names
ReiserFS: dm-3: found reiserfs format "3.6" with standard journal
ReiserFS: dm-3: using ordered data mode
ReiserFS: dm-3: journal params: device dm-3, size 8192, journal first 
block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
ReiserFS: dm-3: checking transaction log (dm-3)
ReiserFS: dm-3: Using r5 hash to sort names
ReiserFS: dm-0: found reiserfs format "3.6" with standard journal
ReiserFS: dm-0: using ordered data mode
ReiserFS: dm-0: journal params: device dm-0, size 8192, journal first 
block 18, max trans len 1024, max batch 900, max commit age 30, max 
trans age 30
ReiserFS: dm-0: checking transaction log (dm-0)
ReiserFS: dm-0: Using r5 hash to sort names
Adding 2097144k swap on /dev/vg_data/lv_swap.  Priority:-1 extents:1 
across:2097144k
e1000: eth0: e1000_watchdog_task: NIC Link is Up 100 Mbps Full Duplex
Bluetooth: Core ver 2.7
NET: Registered protocol family 31
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP ver 2.7
Bluetooth: L2CAP socket layer initialized
Bluetooth: RFCOMM ver 1.5
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM TTY layer initialized
NET: Registered protocol family 10
Disabled Privacy Extensions on device c0397f80(lo)
IPv6 over IPv4 tunneling driver
Installing knfsd (copyright (C) 1996 okir@monad.swb.de).
NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state recovery directory
NFSD: recovery directory /var/lib/nfs/v4recovery doesn't exist
NFSD: starting 90-second grace period
eth0: no IPv6 routers present
ata3: status=0x51 { DriveReady SeekComplete Error }
ata3: error=0x0c { DriveStatusError }
ata3: status=0x51 { DriveReady SeekComplete Error }
ata3: error=0x0c { DriveStatusError }
ata2: status=0x51 { DriveReady SeekComplete Error }
ata2: error=0x0c { DriveStatusError }
ata2: status=0x51 { DriveReady SeekComplete Error }
ata2: error=0x0c { DriveStatusError }
ata2: status=0x51 { DriveReady SeekComplete Error }
ata2: error=0x0c { DriveStatusError }
ata2: status=0x51 { DriveReady SeekComplete Error }
ata2: error=0x0c { DriveStatusError }
[root@terminus ~]#


lspci -vvv:
[root@terminus ~]# lspci -vvv
00:00.0 Host bridge: Intel Corporation E7501 Memory Controller Hub (rev 01)
         Subsystem: Intel Corporation E7501 Memory Controller Hub
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Capabilities: [40] Vendor Specific Information

00:02.0 PCI bridge: Intel Corporation E7500/E7501 Hub Interface B 
PCI-to-PCI Bridge (rev 01) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 64
         Bus: primary=00, secondary=01, subordinate=03, sec-latency=0
         I/O behind bridge: 00009000-0000afff
         Memory behind bridge: fc400000-fc6fffff
         Prefetchable memory behind bridge: ff300000-ff5fffff
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:03.0 PCI bridge: Intel Corporation E7500/E7501 Hub Interface C 
PCI-to-PCI Bridge (rev 01) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 64
         Bus: primary=00, secondary=04, subordinate=06, sec-latency=0
         I/O behind bridge: 0000b000-0000cfff
         Memory behind bridge: fc700000-fc9fffff
         Prefetchable memory behind bridge: ff600000-ff8fffff
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-

00:1d.0 USB Controller: Intel Corporation 82801CA/CAM USB (Hub #1) (rev 
02) (prog-if 00 [UHCI])
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 209
         Region 4: I/O ports at ec00 [size=32]

00:1d.1 USB Controller: Intel Corporation 82801CA/CAM USB (Hub #2) (rev 
02) (prog-if 00 [UHCI])
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin B routed to IRQ 217
         Region 4: I/O ports at e880 [size=32]

00:1d.2 USB Controller: Intel Corporation 82801CA/CAM USB (Hub #3) (rev 
02) (prog-if 00 [UHCI])
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem- BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin C routed to IRQ 169
         Region 4: I/O ports at e800 [size=32]

00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev 42) (prog-if 
00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Bus: primary=00, secondary=07, subordinate=07, sec-latency=32
         I/O behind bridge: 0000d000-0000dfff
         Memory behind bridge: fca00000-feafffff
         Prefetchable memory behind bridge: ff900000-ff9fffff
         Secondary status: 66Mhz- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort+ <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA+ MAbort- >Reset- FastB2B-

00:1f.0 ISA bridge: Intel Corporation 82801CA LPC Interface Controller 
(rev 02)
         Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0

00:1f.1 IDE interface: Intel Corporation 82801CA Ultra ATA Storage 
Controller (rev 02) (prog-if 8a [Master SecP PriP])
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Interrupt: pin A routed to IRQ 169
         Region 0: I/O ports at <unassigned>
         Region 1: I/O ports at <unassigned>
         Region 2: I/O ports at <unassigned>
         Region 3: I/O ports at <unassigned>
         Region 4: I/O ports at ffa0 [size=16]
         Region 5: Memory at 88000000 (32-bit, non-prefetchable) [size=1K]

00:1f.3 SMBus: Intel Corporation 82801CA/CAM SMBus Controller (rev 02)
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem- BusMaster- SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B-
         Status: Cap- 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Interrupt: pin B routed to IRQ 0
         Region 4: I/O ports at 0540 [size=32]

01:1c.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog-if 
20 [IO(X)-APIC])
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Region 0: Memory at fc6ff000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [50] PCI-X non-bridge device.
                 Command: DPERE- ERO- RBC=0 OST=0
                 Status: Bus=1 Dev=28 Func=0 64bit+ 133MHz+ SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

01:1d.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 
04) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 64, Cache Line Size 10
         Bus: primary=01, secondary=02, subordinate=02, sec-latency=48
         I/O behind bridge: 00009000-00009fff
         Memory behind bridge: fc400000-fc4fffff
         Prefetchable memory behind bridge: 
00000000ff300000-00000000ff300000
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [50] PCI-X bridge device.
                 Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, 
SRD- Freq=0
                 Status: Bus=1 Dev=29 Func=0 64bit+ 133MHz+ SCD- USC-, 
SCO-, SRD-
                 : Upstream: Capacity=65535, Commitment Limit=65535
                 : Downstream: Capacity=65535, Commitment Limit=65535

01:1e.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog-if 
20 [IO(X)-APIC])
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Region 0: Memory at fc6fe000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [50] PCI-X non-bridge device.
                 Command: DPERE- ERO- RBC=0 OST=0
                 Status: Bus=1 Dev=30 Func=0 64bit+ 133MHz+ SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

01:1f.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 
04) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 64, Cache Line Size 10
         Bus: primary=01, secondary=03, subordinate=03, sec-latency=64
         I/O behind bridge: 0000a000-0000afff
         Memory behind bridge: fc500000-fc5fffff
         Prefetchable memory behind bridge: 
00000000ff400000-00000000ff400000
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [50] PCI-X bridge device.
                 Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, 
SRD- Freq=3
                 Status: Bus=1 Dev=31 Func=0 64bit+ 133MHz+ SCD- USC-, 
SCO-, SRD-
                 : Upstream: Capacity=65535, Commitment Limit=65535
                 : Downstream: Capacity=65535, Commitment Limit=65535

02:02.0 Mass storage controller: Promise Technology, Inc. PDC20318 
(SATA150 TX4) (rev 02)
         Subsystem: Promise Technology, Inc. PDC20318 (SATA150 TX4)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (1000ns min, 4500ns max), Cache Line Size 10
         Interrupt: pin A routed to IRQ 177
         Region 0: I/O ports at 9c00 [size=64]
         Region 1: I/O ports at 9880 [size=16]
         Region 2: I/O ports at 9800 [size=128]
         Region 3: Memory at fc4ff000 (32-bit, non-prefetchable) [size=4K]
         Region 4: Memory at fc4c0000 (32-bit, non-prefetchable) [size=128K]
         Expansion ROM at fc4f8000 [disabled] [size=16K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

03:02.0 Ethernet controller: Intel Corporation 82544GC Gigabit Ethernet 
Controller (LOM) (rev 02)
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (63750ns min), Cache Line Size 10
         Interrupt: pin A routed to IRQ 201
         Region 0: Memory at fc5e0000 (64-bit, non-prefetchable) [size=128K]
         Region 2: Memory at fc5c0000 (64-bit, non-prefetchable) [size=128K]
         Region 4: I/O ports at ac00 [size=32]
         Expansion ROM at fc5a0000 [disabled] [size=128K]
         Capabilities: [dc] Power Management version 2
                 Flags: PMEClk- DSI+ D1- D2- AuxCurrent=0mA 
PME(D0+,D1-,D2-,D3hot+,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=1 PME-
         Capabilities: [e4] PCI-X non-bridge device.
                 Command: DPERE- ERO+ RBC=0 OST=0
                 Status: Bus=3 Dev=2 Func=0 64bit+ 133MHz+ SCD- USC-, 
DC=simple, DMMRBC=2, DMOST=0, DMCRS=1, RSCEM-
         Capabilities: [f0] Message Signalled Interrupts: 64bit+ 
Queue=0/0 Enable-
                 Address: 0000000000000000  Data: 0000

04:1c.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog-if 
20 [IO(X)-APIC])
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Region 0: Memory at fc9ff000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [50] PCI-X non-bridge device.
                 Command: DPERE- ERO- RBC=0 OST=0
                 Status: Bus=4 Dev=28 Func=0 64bit+ 133MHz+ SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

04:1d.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 
04) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 64, Cache Line Size 10
         Bus: primary=04, secondary=05, subordinate=05, sec-latency=64
         I/O behind bridge: 0000b000-0000bfff
         Memory behind bridge: fc700000-fc7fffff
         Prefetchable memory behind bridge: 
00000000ff600000-00000000ff600000
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [50] PCI-X bridge device.
                 Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, 
SRD- Freq=0
                 Status: Bus=4 Dev=29 Func=0 64bit+ 133MHz+ SCD- USC-, 
SCO-, SRD-
                 : Upstream: Capacity=65535, Commitment Limit=65535
                 : Downstream: Capacity=65535, Commitment Limit=65535

04:1e.0 PIC: Intel Corporation 82870P2 P64H2 I/OxAPIC (rev 04) (prog-if 
20 [IO(X)-APIC])
         Control: I/O- Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 0
         Region 0: Memory at fc9fe000 (32-bit, non-prefetchable) [size=4K]
         Capabilities: [50] PCI-X non-bridge device.
                 Command: DPERE- ERO- RBC=0 OST=0
                 Status: Bus=4 Dev=30 Func=0 64bit+ 133MHz+ SCD- USC-, 
DC=simple, DMMRBC=0, DMOST=0, DMCRS=0, RSCEM-

04:1f.0 PCI bridge: Intel Corporation 82870P2 P64H2 Hub PCI Bridge (rev 
04) (prog-if 00 [Normal decode])
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR-
         Latency: 64, Cache Line Size 10
         Bus: primary=04, secondary=06, subordinate=06, sec-latency=64
         I/O behind bridge: 0000c000-0000cfff
         Memory behind bridge: fc800000-fc8fffff
         Prefetchable memory behind bridge: 
00000000ff700000-00000000ff700000
         Secondary status: 66Mhz+ FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- <SERR- <PERR-
         BridgeCtl: Parity- SERR+ NoISA- VGA- MAbort- >Reset- FastB2B-
         Capabilities: [50] PCI-X bridge device.
                 Secondary Status: 64bit+, 133MHz+, SCD-, USC-, SCO-, 
SRD- Freq=0
                 Status: Bus=4 Dev=31 Func=0 64bit+ 133MHz+ SCD- USC-, 
SCO-, SRD-
                 : Upstream: Capacity=65535, Commitment Limit=65535
                 : Downstream: Capacity=65535, Commitment Limit=65535

05:02.0 Mass storage controller: Promise Technology, Inc. PDC20318 
(SATA150 TX4) (rev 02)
         Subsystem: Promise Technology, Inc. PDC20318 (SATA150 TX4)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 96 (1000ns min, 4500ns max), Cache Line Size 90
         Interrupt: pin A routed to IRQ 185
         Region 0: I/O ports at bc00 [size=64]
         Region 1: I/O ports at b880 [size=16]
         Region 2: I/O ports at b800 [size=128]
         Region 3: Memory at fc7ff000 (32-bit, non-prefetchable) [size=4K]
         Region 4: Memory at fc7c0000 (32-bit, non-prefetchable) [size=128K]
         Expansion ROM at fc7f8000 [disabled] [size=16K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

06:02.0 Mass storage controller: Promise Technology, Inc. PDC20318 
(SATA150 TX4) (rev 02)
         Subsystem: Promise Technology, Inc. PDC20318 (SATA150 TX4)
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop- 
ParErr- Stepping- SERR+ FastB2B-
         Status: Cap+ 66Mhz+ UDF- FastB2B- ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 96 (1000ns min, 4500ns max), Cache Line Size 90
         Interrupt: pin A routed to IRQ 193
         Region 0: I/O ports at cc00 [size=64]
         Region 1: I/O ports at c880 [size=16]
         Region 2: I/O ports at c800 [size=128]
         Region 3: Memory at fc8ff000 (32-bit, non-prefetchable) [size=4K]
         Region 4: Memory at fc8c0000 (32-bit, non-prefetchable) [size=128K]
         Expansion ROM at fc8f8000 [disabled] [size=16K]
         Capabilities: [60] Power Management version 2
                 Flags: PMEClk- DSI+ D1+ D2- AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

07:0c.0 VGA compatible controller: ATI Technologies Inc Rage XL (rev 27) 
(prog-if 00 [VGA])
         Subsystem: Gateway 2000: Unknown device 891f
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping+ SERR- FastB2B-
         Status: Cap+ 66Mhz- UDF- FastB2B+ ParErr- DEVSEL=medium 
 >TAbort- <TAbort- <MAbort- >SERR- <PERR-
         Latency: 64 (2000ns min), Cache Line Size 10
         Interrupt: pin A routed to IRQ 11
         Region 0: Memory at fd000000 (32-bit, non-prefetchable) [size=16M]
         Region 1: I/O ports at d800 [size=256]
         Region 2: Memory at feaff000 (32-bit, non-prefetchable) [size=4K]
         Expansion ROM at ff900000 [disabled] [size=128K]
         Capabilities: [5c] Power Management version 2
                 Flags: PMEClk- DSI- D1+ D2+ AuxCurrent=0mA 
PME(D0-,D1-,D2-,D3hot-,D3cold-)
                 Status: D0 PME-Enable- DSel=0 DScale=0 PME-

[root@terminus ~]#

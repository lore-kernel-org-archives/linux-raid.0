From: "Clemens Eisserer" <linuxhippy@web.de>
Subject: Still problems with USB
Date: Wed, 16 Feb 2005 17:35:54 +0100
Message-ID: <1062276680@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First of all a big thank you for your fast replies the tipp with the usb-subsystem loading time.
Thanks to some tutorials I got this working (just create an initrd that preloads the usb/scsi subsystems.

However I now have another strage problem:
1.) When booting up my USB hd is detected before raid is initialized.
2.) The MD Driver tells me that it can only find /dev/sda1 of the array, although all partition-types are set correctly ("fd"). Please have a look at the dmesg-output I atached.
3.) Mout tells me, that /dev/md0 is mounted on "/" - in /etc/fstab there is only written something like /      $LABEL (or something like that - I think it has something todo with grub, dont know if it was called LABEL).
4.) If I write data to / only my internal harddisk (/dev/hda3) is involved, althought / is /dev/md0 (accoring to mount) and the raid-driver told me that only /dev/sda1 (usb) is used.
5.) If I do hdparm -tT /dev/md0 only my usb-drive is benchmarked.
6.) If I ask /proc/mdstat it also tells me that only /dev/sda1 is aktive.

Does anybody have an idea whats going wrong. I am quite confused :-(
I am more and more playing with the thought  that I just a small partition as root-partitions and symlink /usr and /opt to my raid. Would that make sence and would it hurt the performance much?


I know such newbie questions are nerving, but I played with raid for now several hours and I really don't see any way to procees any further thats why I am bothering you.

Thanks in advance and sorry for creating so much traffic.
lg Clemens


Heres dmesg's output:


Linux version 2.6.9-1.667 (bhcompile@tweety.build.redhat.com) (gcc version 3.4.2 20041017 (Red Hat 3.4.2-6.fc3)) #1 Tue Nov 2 14:41:25 EST 2004
BIOS-provided physical RAM map:
 BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
 BIOS-e820: 000000000009f400 - 00000000000a0000 (reserved)
 BIOS-e820: 00000000000d0000 - 00000000000d8000 (reserved)
 BIOS-e820: 00000000000e4000 - 0000000000100000 (reserved)
 BIOS-e820: 0000000000100000 - 000000000fdf0000 (usable)
 BIOS-e820: 000000000fdf0000 - 000000000fdff000 (ACPI data)
 BIOS-e820: 000000000fdff000 - 000000000fe00000 (ACPI NVS)
 BIOS-e820: 000000000fe00000 - 0000000010000000 (reserved)
 BIOS-e820: 00000000fff00000 - 0000000100000000 (reserved)
0MB HIGHMEM available.
253MB LOWMEM available.
zapping low mappings.
On node 0 totalpages: 65008
  DMA zone: 4096 pages, LIFO batch:1
  Normal zone: 60912 pages, LIFO batch:14
  HighMem zone: 0 pages, LIFO batch:1
DMI 2.3 present.
ACPI: RSDP (v000 PTLTD                                 ) @ 0x000f6f50
ACPI: RSDT (v001 PTLTD    RSDT   0x06040000  LTP 0x00000000) @ 0x0fdf9a08
ACPI: FADT (v001 SiS    648      0x06040000 PTL  0x000f4240) @ 0x0fdfef64
ACPI: BOOT (v001 PTLTD  $SBFTBL$ 0x06040000  LTP 0x00000001) @ 0x0fdfefd8
ACPI: DSDT (v001 PTLTD       635 0x06040000 MSFT 0x0100000e) @ 0x00000000
ACPI: PM-Timer IO Port: 0x8008
Built 1 zonelists
Kernel command line: ro root=LABEL=/
mapped 4G/4G trampoline to ffff4000.
Initializing CPU#0
CPU 0 irqstacks, hard=023d5000 soft=023d4000
PID hash table entries: 1024 (order: 10, 16384 bytes)
Detected 2600.710 MHz processor.
Using tsc for high-res timesource
Console: colour VGA+ 80x25
Dentry cache hash table entries: 32768 (order: 5, 131072 bytes)
Inode-cache hash table entries: 16384 (order: 4, 65536 bytes)
Memory: 252232k/260032k available (2068k kernel code, 7228k reserved, 647k data, 144k init, 0k highmem)
Calibrating delay loop... 5128.19 BogoMIPS (lpj=2564096)
Security Scaffold v1.0.0 initialized
SELinux:  Initializing.
SELinux:  Starting in permissive mode
There is already a security framework initialized, register_security failed.
selinux_register_security:  Registering secondary module capability
Capability LSM initialized as secondary
Mount-cache hash table entries: 512 (order: 0, 4096 bytes)
CPU: After generic identify, caps: bfebf9ff 00000000 00000000 00000000
CPU: After vendor identify, caps:  bfebf9ff 00000000 00000000 00000000
CPU: Trace cache: 12K uops, L1 D cache: 8K
CPU: L2 cache: 512K
CPU: After all inits, caps:        bfebf1ff 00000000 00000000 00000080
Intel machine check architecture supported.
Intel machine check reporting enabled on CPU#0.
CPU0: Intel P4/Xeon Extended MCE MSRs (12) available
CPU: Intel(R) Pentium(R) 4 CPU 2.60GHz stepping 09
Enabling fast FPU save and restore... done.
Enabling unmasked SIMD FPU exception support... done.
Checking 'hlt' instruction... OK.
ACPI: IRQ11 SCI: Edge set to Level Trigger.
checking if image is initramfs... it is
Freeing initrd memory: 1730k freed
NET: Registered protocol family 16
PCI: PCI BIOS revision 2.10 entry at 0xfd9d8, last bus=1
PCI: Using configuration type 1
mtrr: v2.0 (20020519)
ACPI: Subsystem revision 20040816
ACPI: Interpreter enabled
ACPI: Using PIC for interrupt routing
ACPI: PCI Root Bridge [PCI0] (00:00)
PCI: Probing PCI hardware (bus 00)
Uncovering SIS963 that hid as a SIS503 (compatible=1)
Enabling SiS 96x SMBus.
ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
ACPI: PCI Interrupt Link [LNKA] (IRQs *10)
ACPI: PCI Interrupt Link [LNKB] (IRQs *10)
ACPI: PCI Interrupt Link [LNKC] (IRQs *5)
ACPI: PCI Interrupt Link [LNKD] (IRQs 5) *0, disabled.
ACPI: PCI Interrupt Link [LNKE] (IRQs *5)
ACPI: PCI Interrupt Link [LNKF] (IRQs *5)
ACPI: PCI Interrupt Link [LNKG] (IRQs *5)
ACPI: PCI Interrupt Link [LNKH] (IRQs 5) *0, disabled.
ACPI: Power Resource [FN10] (off)
ACPI: Power Resource [FN11] (off)
Linux Plug and Play Support v0.97 (c) Adam Belay
usbcore: registered new driver usbfs
usbcore: registered new driver hub
PCI: Using ACPI for IRQ routing
ACPI: PCI Interrupt Link [LNKB] enabled at IRQ 10
ACPI: PCI interrupt 0000:00:02.1[B] -> GSI 10 (level, low) -> IRQ 10
ACPI: PCI interrupt 0000:00:02.3[B] -> GSI 10 (level, low) -> IRQ 10
ACPI: PCI Interrupt Link [LNKC] enabled at IRQ 5
ACPI: PCI interrupt 0000:00:02.6[C] -> GSI 5 (level, low) -> IRQ 5
ACPI: PCI interrupt 0000:00:02.7[C] -> GSI 5 (level, low) -> IRQ 5
ACPI: PCI Interrupt Link [LNKE] enabled at IRQ 5
ACPI: PCI interrupt 0000:00:03.0[A] -> GSI 5 (level, low) -> IRQ 5
ACPI: PCI Interrupt Link [LNKF] enabled at IRQ 5
ACPI: PCI interrupt 0000:00:03.1[B] -> GSI 5 (level, low) -> IRQ 5
ACPI: PCI Interrupt Link [LNKG] enabled at IRQ 5
ACPI: PCI interrupt 0000:00:03.2[C] -> GSI 5 (level, low) -> IRQ 5
ACPI: PCI Interrupt Link [LNKH] enabled at IRQ 5
ACPI: PCI interrupt 0000:00:03.3[D] -> GSI 5 (level, low) -> IRQ 5
ACPI: PCI Interrupt Link [LNKD] enabled at IRQ 5
ACPI: PCI interrupt 0000:00:04.0[A] -> GSI 5 (level, low) -> IRQ 5
ACPI: PCI Interrupt Link [LNKA] enabled at IRQ 10
ACPI: PCI interrupt 0000:00:0c.0[A] -> GSI 10 (level, low) -> IRQ 10
ACPI: PCI interrupt 0000:01:00.0[A] -> GSI 5 (level, low) -> IRQ 5
Simple Boot Flag at 0x36 set to 0x1
apm: BIOS not found.
audit: initializing netlink socket (disabled)
audit(1108573723.950:0): initialized
Total HugeTLB memory allocated, 0
VFS: Disk quotas dquot_6.5.1
Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
SELinux:  Registering netfilter hooks
Initializing Cryptographic API
ksign: Installing public key data
Loading keyring
- Added public key 6ECDA687281A73E5
- User ID: Red Hat, Inc. (Kernel Module GPG key)
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
vesafb: probe of vesafb0 failed with error -6
ACPI: Fan [FN1] (off)
ACPI: Fan [FN2] (off)
ACPI: Processor [CPU0] (supports C1 C2, 2 throttling states)
ACPI: Thermal Zone [THRM] (49 C)
isapnp: Scanning for PnP cards...
isapnp: No Plug & Play device found
Real Time Clock Driver v1.12
Linux agpgart interface v0.100 (c) Dave Jones
agpgart: Detected SiS 648 chipset
agpgart: Maximum main memory to use for agp memory: 201M
agpgart: AGP aperture is 256M @ 0xd0000000
i8042.c: Detected active multiplexing controller, rev 1.1.
serio: i8042 AUX0 port at 0x60,0x64 irq 12
serio: i8042 AUX1 port at 0x60,0x64 irq 12
serio: i8042 AUX2 port at 0x60,0x64 irq 12
serio: i8042 AUX3 port at 0x60,0x64 irq 12
serio: i8042 KBD port at 0x60,0x64 irq 1
Serial: 8250/16550 driver $Revision: 1.90 $ 8 ports, IRQ sharing enabled
ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
PCI: Enabling device 0000:00:02.6 (0000 -> 0001)
ACPI: PCI interrupt 0000:00:02.6[C] -> GSI 5 (level, low) -> IRQ 5
RAMDISK driver initialized: 16 RAM disks of 16384K size 1024 blocksize
divert: not allocating divert_blk for non-ethernet device lo
Uniform Multi-Platform E-IDE driver Revision: 7.00alpha2
ide: Assuming 33MHz system bus speed for PIO modes; override with idebus=xx
SIS5513: IDE controller at PCI slot 0000:00:02.5
SIS5513: chipset revision 0
SIS5513: not 100% native mode: will probe irqs later
SIS5513: SiS 962/963 MuTIOL IDE UDMA133 controller
    ide0: BM-DMA at 0x1000-0x1007, BIOS settings: hda:DMA, hdb:pio
    ide1: BM-DMA at 0x1008-0x100f, BIOS settings: hdc:DMA, hdd:pio
Probing IDE interface ide0...
hda: ST94011A, ATA DISK drive
Using cfq io scheduler
ide0 at 0x1f0-0x1f7,0x3f6 on irq 14
Probing IDE interface ide1...
hdc: QSI CD-RW/DVD-ROM SBW-241, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
Probing IDE interface ide2...
ide2: Wait for ready failed before probe !
Probing IDE interface ide3...
ide3: Wait for ready failed before probe !
Probing IDE interface ide4...
ide4: Wait for ready failed before probe !
Probing IDE interface ide5...
ide5: Wait for ready failed before probe !
hda: max request size: 1024KiB
hda: 78140160 sectors (40007 MB) w/2048KiB Cache, CHS=16383/255/63, UDMA(100)
hda: cache flushes supported
 hda: hda1 hda2 hda3 hda4 < hda5 hda6 >
hdc: ATAPI 24X DVD-ROM CD-R/RW drive, 2048kB Cache, UDMA(33)
Uniform CD-ROM driver Revision: 3.20
ide-floppy driver 0.99.newide
usbcore: registered new driver hiddev
usbcore: registered new driver usbhid
drivers/usb/input/hid-core.c: v2.0:USB HID core driver
mice: PS/2 mouse device common for all mice
input: AT Translated Set 2 keyboard on isa0060/serio0
Synaptics Touchpad, model: 1
 Firmware: 5.1
 180 degree mounted touchpad
 Sensor: 15
 new absolute packet format
 Touchpad has extended capability bits
 -> four buttons
 -> multifinger detection
 -> palm detection
input: SynPS/2 Synaptics TouchPad on isa0060/serio4
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
NET: Registered protocol family 2
IP: routing cache hash table of 512 buckets, 16Kbytes
TCP: Hash tables configured (established 16384 bind 4681)
Initializing IPsec netlink socket
NET: Registered protocol family 1
NET: Registered protocol family 17
ACPI: (supports S0 S3 S4 S5)
ACPI wakeup devices: 
 LID USB0 USB1 USB2 USB3 MDM0 ENET 
Freeing unused kernel memory: 144k freed
SCSI subsystem initialized
USB Universal Host Controller Interface driver v2.2
PCI: Enabling device 0000:00:03.3 (0000 -> 0002)
ACPI: PCI interrupt 0000:00:03.3[D] -> GSI 5 (level, low) -> IRQ 5
ehci_hcd 0000:00:03.3: EHCI Host Controller
ehci_hcd 0000:00:03.3: irq 5, pci mem 12806000
ehci_hcd 0000:00:03.3: new USB bus registered, assigned bus number 1
PCI: cache line size of 128 is not supported by device 0000:00:03.3
ehci_hcd 0000:00:03.3: USB 2.0 enabled, EHCI 1.00, driver 2004-May-10
hub 1-0:1.0: USB hub found
hub 1-0:1.0: 6 ports detected
Initializing USB Mass Storage driver...
usbcore: registered new driver usb-storage
USB Mass Storage support registered.
usb 1-2: new high speed USB device using address 2
scsi0 : SCSI emulation for USB Mass Storage devices
  Vendor: Genesys   Model: USB to IDE Disk   Rev: 0033
  Type:   Direct-Access                      ANSI SCSI revision: 02
SCSI device sda: 117210240 512-byte hdwr sectors (60012 MB)
sda: test WP failed, assume Write Enabled
sda: assuming drive cache: write through
 sda: sda1
Attached scsi removable disk sda at scsi0, channel 0, id 0, lun 0
USB Mass Storage device found at 2
SCSI device sda: 117210240 512-byte hdwr sectors (60012 MB)
sda: test WP failed, assume Write Enabled
sda: assuming drive cache: write through
 sda: sda1
kjournald starting.  Commit interval 5 seconds
EXT3-fs: mounted filesystem with ordered data mode.
SELinux:  Disabled at runtime.
SELinux:  Unregistering netfilter hooks
inserting floppy driver for 2.6.9-1.667
floppy0: no floppy controllers found
sis900.c: v1.08.07 11/02/2003
PCI: Enabling device 0000:00:04.0 (0000 -> 0003)
ACPI: PCI interrupt 0000:00:04.0[A] -> GSI 5 (level, low) -> IRQ 5
divert: allocating divert_blk for eth0
eth0: ICS LAN PHY transceiver found at address 1.
eth0: Using transceiver found at address 1 as default
eth0: SiS 900 PCI Fast Ethernet at 0x2000, IRQ 5, 00:40:ca:bf:0f:72.
PCI: Enabling device 0000:00:02.7 (0000 -> 0001)
ACPI: PCI interrupt 0000:00:02.7[C] -> GSI 5 (level, low) -> IRQ 5
intel8x0_measure_ac97_clock: measured 49317 usecs
intel8x0: clocking to 48000
ACPI: PCI interrupt 0000:00:02.6[C] -> GSI 5 (level, low) -> IRQ 5
ohci_hcd: 2004 Feb 02 USB 1.1 'Open' Host Controller (OHCI) Driver (PCI)
ACPI: PCI interrupt 0000:00:03.0[A] -> GSI 5 (level, low) -> IRQ 5
ohci_hcd 0000:00:03.0: OHCI Host Controller
ohci_hcd 0000:00:03.0: irq 5, pci mem 12846000
ohci_hcd 0000:00:03.0: new USB bus registered, assigned bus number 2
hub 2-0:1.0: USB hub found
hub 2-0:1.0: 2 ports detected
ACPI: PCI interrupt 0000:00:03.1[B] -> GSI 5 (level, low) -> IRQ 5
ohci_hcd 0000:00:03.1: OHCI Host Controller
ohci_hcd 0000:00:03.1: irq 5, pci mem 12936000
ohci_hcd 0000:00:03.1: new USB bus registered, assigned bus number 3
hub 3-0:1.0: USB hub found
hub 3-0:1.0: 2 ports detected
ACPI: PCI interrupt 0000:00:03.2[C] -> GSI 5 (level, low) -> IRQ 5
ohci_hcd 0000:00:03.2: OHCI Host Controller
ohci_hcd 0000:00:03.2: irq 5, pci mem 12938000
ohci_hcd 0000:00:03.2: new USB bus registered, assigned bus number 4
hub 4-0:1.0: USB hub found
hub 4-0:1.0: 2 ports detected
Linux Kernel Card Services
  options:  [pci] [cardbus] [pm]
ACPI: PCI interrupt 0000:00:0c.0[A] -> GSI 10 (level, low) -> IRQ 10
Yenta: CardBus bridge found at 0000:00:0c.0 [1509:1861]
Yenta: Using CSCINT to route CSC interrupts to PCI
Yenta: Routing CardBus interrupts to PCI
Yenta TI: socket 0000:00:0c.0, mfunc 0x01821c82, devctl 0x44
Yenta: ISA IRQ mask 0x0208, PCI irq 10
Socket status: 30000006
ohci1394: $Rev: 1223 $ Ben Collins <bcollins@debian.org>
PCI: Enabling device 0000:00:02.3 (0000 -> 0002)
ACPI: PCI interrupt 0000:00:02.3[B] -> GSI 10 (level, low) -> IRQ 10
ohci1394: fw-host0: Unexpected PCI resource length of 1000!
ohci1394: fw-host0: OHCI-1394 1.0 (PCI): IRQ=[10]  MMIO=[e0000000-e00007ff]  Max Packet=[2048]
md: Autodetecting RAID arrays.
md: could not bd_claim hda3.
md: could not bd_claim sda1.
md: autorun ...
md: considering sda1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1>
md: running: <sda1>
md: raid1 personality registered as nr 3
raid1: raid set md0 active with 1 out of 2 mirrors
md: ... autorun DONE.
ACPI: AC Adapter [ACAD] (on-line)
ACPI: Battery Slot [BAT0] (battery present)
ACPI: Power Button (FF) [PWRF]
ACPI: Lid Switch [LID]
ieee1394: Host added: ID:BUS[0-00:1023]  GUID[0040ca01160268c6]
EXT3 FS on hda3, internal journal


______________________________________________________________
Verschicken Sie romantische, coole und witzige Bilder per SMS!
Jetzt bei WEB.DE FreeMail: http://f.web.de/?mc=021193


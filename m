From: "Justin Stephenson" <justin@evensteveninc.com>
Subject: Re[3]: Issue removing failed drive and re adding on raid 6
Date: Sat, 04 Jul 2015 06:10:21 +0000
Message-ID: <emfb4b5aee-68ba-4089-a763-4e835afefc45@littlez>
References: <alpine.DEB.2.02.1507040706560.11810@uplift.swm.pp.se>
Reply-To: "Justin Stephenson" <justin@evensteveninc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1507040706560.11810@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


>On Fri, 3 Jul 2015, Justin Stephenson wrote:
>
>>I have tried assembling with --scan --force and by naming the drives=20
>>sd{b,c,d,e,f,g,h}1 Neither method has worked.
>
>If you want help with that, then you need to provide the output of=20
>commands and dmesg so we can try to figure out why it won't start.
>
>I would recommend you start by using a new mdadm compiled from source:
>
>"git clone git://neil.brown.name/mdadm mdadm"
>
>Most --assemble problems like this is workarounded by using a new=20
>mdadm.2
>
Thank-you!

my dmesg output is below.

I am a little shaky on installing from source code so i am also=20
including my output from the >make install on the new mdadm.

I appreciate your help.

- Justin

------------

[drm]   DDC: 0x6550 0x6550 0x6554 0x6554 0x6558 0x6558 0x655c 0x655c
[drm]   Encoders:
[drm]     DFP2: INTERNAL_UNIPHY
[drm] Internal thermal controller without fan control
[drm] radeon: power management initialized
[drm] fb mappable at 0xC114C000
[drm] vram apper at 0xC0000000
[drm] size 3145728
[drm] fb depth is 24
[drm]    pitch is 4096
fbcon: radeondrmfb (fb0) is primary device
usb 4-1: new low speed USB device number 2 using ohci_hcd
Console: switching to colour frame buffer device 128x48
radeon 0000:00:01.0: fb0: radeondrmfb frame buffer device
radeon 0000:00:01.0: registered panic notifier
Slow work thread pool: Starting up
Slow work thread pool: Ready
[drm] Initialized radeon 2.30.0 20080528 for 0000:00:01.0 on minor 0
dracut: Starting plymouth daemon
Refined TSC clocksource calibration: 3399.998 MHz.
Switching to clocksource tsc
usb 4-1: New USB device found, idVendor=3D0764, idProduct=3D0501
usb 4-1: New USB device strings: Mfr=3D3, Product=3D1, SerialNumber=3D0
usb 4-1: Product:  CP 1350C
usb 4-1: Manufacturer: CPS
usb 4-1: configuration #1 chosen from 1 choice
dracut: rd_NO_DM: removing DM RAID activation
dracut: rd_NO_MD: removing MD RAID activation
generic-usb 0003:0764:0501.0001: hiddev96,hidraw0: USB HID v1.10 Device=
=20
[CPS  CP 1350C] on usb-0000:00:13.0-1/input0
ahci 0000:00:11.0: version 3.0
   alloc irq_desc for 19 on node -1
   alloc kstat_irqs on node -1
ahci 0000:00:11.0: PCI INT A -> GSI 19 (level, low) -> IRQ 19
   alloc irq_desc for 31 on node -1
   alloc kstat_irqs on node -1
ahci 0000:00:11.0: irq 31 for MSI/MSI-X
ahci 0000:00:11.0: AHCI 0001.0300 32 slots 8 ports 6 Gbps 0xff impl SAT=
A=20
mode
ahci 0000:00:11.0: flags: 64bit ncq sntf ilck pm led clo pmp pio slum=20
part
scsi0 : ahci
scsi1 : ahci
scsi2 : ahci
scsi3 : ahci
scsi4 : ahci
scsi5 : ahci
scsi6 : ahci
scsi7 : ahci
ata1: SATA max UDMA/133 irq_stat 0x00400040, connection status changed=20
irq 31
ata2: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed irq 31
ata3: SATA max UDMA/133 irq_stat 0x00400000, PHY RDY changed irq 31
ata4: SATA max UDMA/133 abar m2048@0xfe451000 port 0xfe451280 irq 31
ata5: SATA max UDMA/133 abar m2048@0xfe451000 port 0xfe451300 irq 31
ata6: SATA max UDMA/133 abar m2048@0xfe451000 port 0xfe451380 irq 31
ata7: SATA max UDMA/133 abar m2048@0xfe451000 port 0xfe451400 irq 31
ata8: SATA max UDMA/133 abar m2048@0xfe451000 port 0xfe451480 irq 31
ahci 0000:06:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
   alloc irq_desc for 32 on node -1
   alloc kstat_irqs on node -1
ahci 0000:06:00.0: irq 32 for MSI/MSI-X
ahci 0000:06:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA=
=20
mode
ahci 0000:06:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part=
=20
sxs
ahci 0000:06:00.0: setting latency timer to 64
ahci 0000:06:00.0: port 0 can do FBS, forcing FBSCP
ahci 0000:06:00.0: port 1 can do FBS, forcing FBSCP
scsi8 : ahci
scsi9 : ahci
ata9: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210100 irq 32
ata10: SATA max UDMA/133 abar m2048@0xfe210000 port 0xfe210180 irq 32
ahci 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
   alloc irq_desc for 33 on node -1
   alloc kstat_irqs on node -1
ahci 0000:07:00.0: irq 33 for MSI/MSI-X
ahci 0000:07:00.0: AHCI 0001.0000 32 slots 2 ports 6 Gbps 0x3 impl SATA=
=20
mode
ahci 0000:07:00.0: flags: 64bit ncq sntf led only pmp fbs pio slum part=
=20
sxs
ahci 0000:07:00.0: setting latency timer to 64
ahci 0000:07:00.0: port 0 can do FBS, forcing FBSCP
ahci 0000:07:00.0: port 1 can do FBS, forcing FBSCP
scsi10 : ahci
scsi11 : ahci
ata11: SATA max UDMA/133 abar m2048@0xfe110000 port 0xfe110100 irq 33
ata12: SATA max UDMA/133 abar m2048@0xfe110000 port 0xfe110180 irq 33
usb 4-4: new low speed USB device number 3 using ohci_hcd
ata12: SATA link down (SStatus 0 SControl 330)
ata9: SATA link down (SStatus 0 SControl 330)
ata10: SATA link down (SStatus 0 SControl 330)
ata11: SATA link down (SStatus 0 SControl 330)
usb 4-4: New USB device found, idVendor=3D046d, idProduct=3Dc00c
usb 4-4: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 4-4: Product: USB Mouse
usb 4-4: Manufacturer: Logitech
usb 4-4: configuration #1 chosen from 1 choice
input: Logitech USB Mouse as=20
/devices/pci0000:00/0000:00:13.0/usb4/4-4/4-4:1.0/input/input3
generic-usb 0003:046D:C00C.0002: input,hidraw1: USB HID v1.10 Mouse=20
[Logitech USB Mouse] on usb-0000:00:13.0-4/input0
ata4: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata6.00: ATA-8: ST3000DM001-9YN166, CC4H, max UDMA/133
ata6.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata7.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
ata7.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata8.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
ata8.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata5.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
ata5.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata6.00: configured for UDMA/133
ata4.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
ata4.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata7.00: configured for UDMA/133
ata8.00: configured for UDMA/133
ata5.00: configured for UDMA/133
ata4.00: configured for UDMA/133
usb 4-5: new low speed USB device number 4 using ohci_hcd
usb 4-5: New USB device found, idVendor=3D045e, idProduct=3D00b4
usb 4-5: New USB device strings: Mfr=3D1, Product=3D2, SerialNumber=3D0
usb 4-5: Product: Microsoft=C2=AE Digital Media Keyboard
usb 4-5: Manufacturer: Microsoft
usb 4-5: configuration #1 chosen from 1 choice
input: Microsoft Microsoft=C2=AE Digital Media Keyboard     as=20
/devices/pci0000:00/0000:00:13.0/usb4/4-5/4-5:1.0/input/input4
generic-usb 0003:045E:00B4.0003: input,hidraw2: USB HID v1.11 Keyboard=20
[Microsoft Microsoft=C2=AE Digital Media Keyboard    ] on=20
usb-0000:00:13.0-5/input0
input: Microsoft Microsoft=C2=AE Digital Media Keyboard     as=20
/devices/pci0000:00/0000:00:13.0/usb4/4-5/4-5:1.1/input/input5
generic-usb 0003:045E:00B4.0004: input,hidraw3: USB HID v1.11 Device=20
[Microsoft Microsoft=C2=AE Digital Media Keyboard    ] on=20
usb-0000:00:13.0-5/input1
ata3: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
ata3.00: ATA-8: ST3000DM001-9YN166, CC9F, max UDMA/133
ata3.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata3.00: configured for UDMA/133
ata2.00: ATA-9: ST3000DM001-1CH166, CC27, max UDMA/133
ata2.00: 5860533168 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata2.00: configured for UDMA/133
ata1.00: ATA-8: OCZ-AGILITY3, 2.25, max UDMA/133
ata1.00: 468862128 sectors, multi 16: LBA48 NCQ (depth 31/32), AA
ata1.00: configured for UDMA/133
scsi 0:0:0:0: Direct-Access     ATA      OCZ-AGILITY3     2.25 PQ: 0=20
ANSI: 5
scsi 1:0:0:0: Direct-Access     ATA      ST3000DM001-1CH1 CC27 PQ: 0=20
ANSI: 5
scsi 2:0:0:0: Direct-Access     ATA      ST3000DM001-9YN1 CC9F PQ: 0=20
ANSI: 5
scsi 3:0:0:0: Direct-Access     ATA      ST3000DM001-1CH1 CC27 PQ: 0=20
ANSI: 5
scsi 4:0:0:0: Direct-Access     ATA      ST3000DM001-1CH1 CC27 PQ: 0=20
ANSI: 5
scsi 5:0:0:0: Direct-Access     ATA      ST3000DM001-9YN1 CC4H PQ: 0=20
ANSI: 5
scsi 6:0:0:0: Direct-Access     ATA      ST3000DM001-1CH1 CC27 PQ: 0=20
ANSI: 5
scsi 7:0:0:0: Direct-Access     ATA      ST3000DM001-1CH1 CC27 PQ: 0=20
ANSI: 5
xhci_hcd 0000:00:10.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
xhci_hcd 0000:00:10.0: setting latency timer to 64
xhci_hcd 0000:00:10.0: xHCI Host Controller
xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 6
   alloc irq_desc for 34 on node -1
   alloc kstat_irqs on node -1
xhci_hcd 0000:00:10.0: irq 34 for MSI/MSI-X
   alloc irq_desc for 35 on node -1
   alloc kstat_irqs on node -1
xhci_hcd 0000:00:10.0: irq 35 for MSI/MSI-X
   alloc irq_desc for 36 on node -1
   alloc kstat_irqs on node -1
xhci_hcd 0000:00:10.0: irq 36 for MSI/MSI-X
usb usb6: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb6: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D=
1
usb usb6: Product: xHCI Host Controller
usb usb6: Manufacturer: Linux 2.6.32-431.3.1.el6.x86_64 xhci_hcd
usb usb6: SerialNumber: 0000:00:10.0
usb usb6: configuration #1 chosen from 1 choice
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 6-0:1.0: USB hub found
hub 6-0:1.0: 2 ports detected
xhci_hcd 0000:00:10.0: xHCI Host Controller
xhci_hcd 0000:00:10.0: new USB bus registered, assigned bus number 7
usb usb7: config 1 interface 0 altsetting 0 endpoint 0x81 has no=20
SuperSpeed companion descriptor
usb usb7: New USB device found, idVendor=3D1d6b, idProduct=3D0003
usb usb7: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D=
1
usb usb7: Product: xHCI Host Controller
usb usb7: Manufacturer: Linux 2.6.32-431.3.1.el6.x86_64 xhci_hcd
usb usb7: SerialNumber: 0000:00:10.0
usb usb7: configuration #1 chosen from 1 choice
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 7-0:1.0: USB hub found
hub 7-0:1.0: 2 ports detected
xhci_hcd 0000:00:10.1: PCI INT B -> GSI 17 (level, low) -> IRQ 17
xhci_hcd 0000:00:10.1: setting latency timer to 64
xhci_hcd 0000:00:10.1: xHCI Host Controller
xhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 8
   alloc irq_desc for 37 on node -1
   alloc kstat_irqs on node -1
xhci_hcd 0000:00:10.1: irq 37 for MSI/MSI-X
   alloc irq_desc for 38 on node -1
   alloc kstat_irqs on node -1
xhci_hcd 0000:00:10.1: irq 38 for MSI/MSI-X
   alloc irq_desc for 39 on node -1
   alloc kstat_irqs on node -1
xhci_hcd 0000:00:10.1: irq 39 for MSI/MSI-X
usb usb8: New USB device found, idVendor=3D1d6b, idProduct=3D0002
usb usb8: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D=
1
usb usb8: Product: xHCI Host Controller
usb usb8: Manufacturer: Linux 2.6.32-431.3.1.el6.x86_64 xhci_hcd
usb usb8: SerialNumber: 0000:00:10.1
usb usb8: configuration #1 chosen from 1 choice
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 8-0:1.0: USB hub found
hub 8-0:1.0: 2 ports detected
xhci_hcd 0000:00:10.1: xHCI Host Controller
xhci_hcd 0000:00:10.1: new USB bus registered, assigned bus number 9
usb usb9: config 1 interface 0 altsetting 0 endpoint 0x81 has no=20
SuperSpeed companion descriptor
usb usb9: New USB device found, idVendor=3D1d6b, idProduct=3D0003
usb usb9: New USB device strings: Mfr=3D3, Product=3D2, SerialNumber=3D=
1
usb usb9: Product: xHCI Host Controller
usb usb9: Manufacturer: Linux 2.6.32-431.3.1.el6.x86_64 xhci_hcd
usb usb9: SerialNumber: 0000:00:10.1
usb usb9: configuration #1 chosen from 1 choice
xHCI xhci_add_endpoint called for root hub
xHCI xhci_check_bandwidth called for root hub
hub 9-0:1.0: USB hub found
hub 9-0:1.0: 2 ports detected
sd 0:0:0:0: [sda] 468862128 512-byte logical blocks: (240 GB/223 GiB)
sd 1:0:0:0: [sdb] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB=
)
sd 1:0:0:0: [sdb] 4096-byte physical blocks
sd 2:0:0:0: [sdc] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB=
)
sd 2:0:0:0: [sdc] 4096-byte physical blocks
sd 1:0:0:0: [sdb] Write Protect is off
sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB=
)
sd 3:0:0:0: [sdd] 4096-byte physical blocks
sd 2:0:0:0: [sdc] Write Protect is off
sd 2:0:0:0: [sdc] Mode Sense: 00 3a 00 00
sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't=20
support DPO or FUA
sd 4:0:0:0: [sde] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB=
)
sd 4:0:0:0: [sde] 4096-byte physical blocks
sd 2:0:0:0: [sdc] Write cache: enabled, read cache: enabled, doesn't=20
support DPO or FUA
sd 4:0:0:0: [sde] Write Protect is off
sd 4:0:0:0: [sde] Mode Sense: 00 3a 00 00
sd 4:0:0:0: [sde] Write cache: enabled, read cache: enabled, doesn't=20
support DPO or FUA
sd 3:0:0:0: [sdd] Write Protect is off
sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't=20
support DPO or FUA
sd 0:0:0:0: [sda] Write Protect is off
sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't=20
support DPO or FUA
  sde:
  sdc:
  sdd:
  sdb:
  sda:
sd 5:0:0:0: [sdf] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB=
)
sd 5:0:0:0: [sdf] 4096-byte physical blocks
sd 5:0:0:0: [sdf] Write Protect is off
sd 5:0:0:0: [sdf] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdg] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB=
)
sd 6:0:0:0: [sdg] 4096-byte physical blocks
sd 5:0:0:0: [sdf] Write cache: enabled, read cache: enabled, doesn't=20
support DPO or FUA
sd 7:0:0:0: [sdh] 5860533168 512-byte logical blocks: (3.00 TB/2.72 TiB=
)
sd 7:0:0:0: [sdh] 4096-byte physical blocks
sd 7:0:0:0: [sdh] Write Protect is off
sd 7:0:0:0: [sdh] Mode Sense: 00 3a 00 00
sd 7:0:0:0: [sdh] Write cache: enabled, read cache: enabled, doesn't=20
support DPO or FUA
sd 6:0:0:0: [sdg] Write Protect is off
sd 6:0:0:0: [sdg] Mode Sense: 00 3a 00 00
sd 6:0:0:0: [sdg] Write cache: enabled, read cache: enabled, doesn't=20
support DPO or FUA
  sdf:
  sdh:
  sdg: sda1 sda2 sda3
sd 0:0:0:0: [sda] Attached SCSI disk
  sdf1
sd 5:0:0:0: [sdf] Attached SCSI disk
  sde1
sd 4:0:0:0: [sde] Attached SCSI disk
  sdg1
sd 6:0:0:0: [sdg] Attached SCSI disk
  sdb1
sd 1:0:0:0: [sdb] Attached SCSI disk
  sdc1
sd 2:0:0:0: [sdc] Attached SCSI disk
  sdh1
sd 7:0:0:0: [sdh] Attached SCSI disk
  sdd1
sd 3:0:0:0: [sdd] Attached SCSI disk
dracut: Scanning devices sda3  for LVM logical volumes=20
vg_bigblue/lv_root vg_bigblue/lv_swap
dracut: inactive '/dev/vg_bigblue/lv_root' [50.00 GiB] inherit
dracut: inactive '/dev/vg_bigblue/lv_home' [165.85 GiB] inherit
dracut: inactive '/dev/vg_bigblue/lv_swap' [7.03 GiB] inherit
EXT4-fs (dm-0): INFO: recovery required on readonly filesystem
EXT4-fs (dm-0): write access will be enabled during recovery
EXT4-fs (dm-0): orphan cleanup on readonly fs
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289912=
5
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289912=
4
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289912=
3
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289912=
0
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289911=
5
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289911=
4
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289911=
3
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289911=
2
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289911=
1
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289555=
0
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289507=
0
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289501=
7
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289501=
6
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289500=
6
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289496=
7
EXT4-fs (dm-0): ext4_orphan_cleanup: deleting unreferenced inode 289238=
7
EXT4-fs (dm-0): 16 orphan inodes deleted
EXT4-fs (dm-0): recovery complete
EXT4-fs (dm-0): mounted filesystem with ordered data mode. Opts:
dracut: Mounted root filesystem /dev/mapper/vg_bigblue-lv_root
dracut: Loading SELinux policy
type=3D1404 audit(1435960267.752:2): enforcing=3D1 old_enforcing=3D0=20
auid=3D4294967295 ses=3D4294967295
SELinux: 2048 avtab hash slots, 277805 rules.
SELinux: 2048 avtab hash slots, 277805 rules.
SELinux:  9 users, 12 roles, 3917 types, 217 bools, 1 sens, 1024 cats
SELinux:  81 classes, 277805 rules
SELinux:  Completing initialization.
SELinux:  Setting up existing superblocks.
SELinux: initialized (dev dm-0, type ext4), uses xattr
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev usbfs, type usbfs), uses genfs_contexts
SELinux: initialized (dev selinuxfs, type selinuxfs), uses=20
genfs_contexts
SELinux: initialized (dev mqueue, type mqueue), uses transition SIDs
SELinux: initialized (dev hugetlbfs, type hugetlbfs), uses transition=20
SIDs
SELinux: initialized (dev devpts, type devpts), uses transition SIDs
SELinux: initialized (dev inotifyfs, type inotifyfs), uses=20
genfs_contexts
SELinux: initialized (dev anon_inodefs, type anon_inodefs), uses=20
genfs_contexts
SELinux: initialized (dev pipefs, type pipefs), uses task SIDs
SELinux: initialized (dev debugfs, type debugfs), uses genfs_contexts
SELinux: initialized (dev sockfs, type sockfs), uses task SIDs
SELinux: initialized (dev devtmpfs, type devtmpfs), uses transition SID=
s
SELinux: initialized (dev tmpfs, type tmpfs), uses transition SIDs
SELinux: initialized (dev proc, type proc), uses genfs_contexts
SELinux: initialized (dev bdev, type bdev), uses genfs_contexts
SELinux: initialized (dev rootfs, type rootfs), uses genfs_contexts
SELinux: initialized (dev sysfs, type sysfs), uses genfs_contexts
type=3D1403 audit(1435960268.441:3): policy loaded auid=3D4294967295=20
ses=3D4294967295
dracut:
dracut: Switching root
udev: starting version 147
snd_hda_intel 0000:00:01.1: enabling device (0000 -> 0002)
snd_hda_intel 0000:00:01.1: PCI INT B -> GSI 18 (level, low) -> IRQ 18
hda-intel 0000:00:01.1: Force to non-snoop mode
   alloc irq_desc for 40 on node -1
   alloc kstat_irqs on node -1
snd_hda_intel 0000:00:01.1: irq 40 for MSI/MSI-X
snd_hda_intel 0000:00:01.1: setting latency timer to 64
input: HDA ATI HDMI HDMI/DP,pcm=3D3 as=20
/devices/pci0000:00/0000:00:01.1/sound/card0/input6
snd_hda_intel 0000:00:14.2: PCI INT A -> GSI 16 (level, low) -> IRQ 16
input: HD-Audio Generic Front Headphone as=20
/devices/pci0000:00/0000:00:14.2/sound/card1/input7
input: HD-Audio Generic Line Out as=20
/devices/pci0000:00/0000:00:14.2/sound/card1/input8
input: HD-Audio Generic Line as=20
/devices/pci0000:00/0000:00:14.2/sound/card1/input9
input: HD-Audio Generic Front Mic as=20
/devices/pci0000:00/0000:00:14.2/sound/card1/input10
input: HD-Audio Generic Rear Mic as=20
/devices/pci0000:00/0000:00:14.2/sound/card1/input11
r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded
r8169 0000:02:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
r8169 0000:02:00.0: setting latency timer to 64
   alloc irq_desc for 41 on node -1
   alloc kstat_irqs on node -1
r8169 0000:02:00.0: irq 41 for MSI/MSI-X
r8169 0000:02:00.0: eth0: RTL8168evl/8111evl at 0xffffc90001cb2000,=20
94:de:80:71:9a:ca, XID 0c900800 IRQ 41
r8169 0000:02:00.0: eth0: jumbo features [frames: 9200 bytes, tx=20
checksumming: ko]
esashba: module license 'Proprietary' taints kernel.
Disabling lock debugging due to kernel taint
esashba 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
esashba 0000:01:00.0: setting latency timer to 64
IRQ 18/esashba_00: IRQF_DISABLED is not guaranteed on shared IRQs
esashba: Event: Adapter Number 1.
Adapter Initialization Complete.

scsi12 : ATTO ExpressSAS Adapter (Bus 0x01, Device 0x00, IRQ 0x0B)=20
Driver version 1.31  Firmware version 4.11.5.0

esashba: Found 1 adapters.
sd 0:0:0:0: Attached scsi generic sg0 type 0
sd 1:0:0:0: Attached scsi generic sg1 type 0
sd 2:0:0:0: Attached scsi generic sg2 type 0
sd 3:0:0:0: Attached scsi generic sg3 type 0
sd 4:0:0:0: Attached scsi generic sg4 type 0
sd 5:0:0:0: Attached scsi generic sg5 type 0
sd 6:0:0:0: Attached scsi generic sg6 type 0
sd 7:0:0:0: Attached scsi generic sg7 type 0
parport_pc 00:07: reported by Plug and Play ACPI
parport0: PC-style at 0x378, irq 5 [PCSPP,TRISTATE]
piix4_smbus 0000:00:14.0: SMBus Host Controller at 0xb00, revision 0
md: bind<sdc1>
md: bind<sdb1>
md: bind<sde1>
md: bind<sdf1>
md: bind<sdd1>
md: bind<sdg1>
md: bind<sdh1>
platform microcode: firmware: requesting=20
amd-ucode/microcode_amd_fam15h.bin
microcode: CPU0: patch_level=3D0x6001119
microcode: CPU1: patch_level=3D0x6001119
Microcode Update Driver: v2.00 <tigran@aivazian.fsnet.co.uk>, Peter=20
Oruba
ppdev: user-space parallel port driver
async_tx: api initialized (async)
xor: automatically using best checksumming function: avx
    avx       :  4308.000 MB/sec
xor: using function: avx (4308.000 MB/sec)
raid6: sse2x1    6347 MB/s
raid6: sse2x2    9367 MB/s
raid6: sse2x4   11527 MB/s
raid6: using algorithm sse2x4 (11527 MB/s)
raid6: using ssse3x2 recovery algorithm
md: raid6 personality registered for level 6
md: raid5 personality registered for level 5
md: raid4 personality registered for level 4
bio: create slab <bio-1> at 1
md/raid:md0: not clean -- starting background reconstruction
md/raid:md0: device sdh1 operational as raid disk 5
md/raid:md0: device sdg1 operational as raid disk 4
md/raid:md0: device sdd1 operational as raid disk 1
md/raid:md0: device sde1 operational as raid disk 2
md/raid:md0: device sdb1 operational as raid disk 6
md/raid:md0: device sdc1 operational as raid disk 0
md/raid:md0: allocated 7470kB
md/raid:md0: cannot start dirty degraded array.
RAID conf printout:
  --- level:6 rd:7 wd:6
  disk 0, o:1, dev:sdc1
  disk 1, o:1, dev:sdd1
  disk 2, o:1, dev:sde1
  disk 4, o:1, dev:sdg1
  disk 5, o:1, dev:sdh1
  disk 6, o:1, dev:sdb1
md/raid:md0: failed to run raid set.
md: pers->run() failed ...
EXT4-fs (sda2): mounted filesystem with ordered data mode. Opts:
SELinux: initialized (dev sda2, type ext4), uses xattr
SELinux: initialized (dev sda1, type vfat), uses genfs_contexts
EXT4-fs (dm-2): mounted filesystem with ordered data mode. Opts:
SELinux: initialized (dev dm-2, type ext4), uses xattr
Adding 7372792k swap on /dev/mapper/vg_bigblue-lv_swap.  Priority:-1=20
extents:1 across:7372792k SSD
SELinux: initialized (dev binfmt_misc, type binfmt_misc), uses=20
genfs_contexts
NET: Registered protocol family 10
lo: Disabled Privacy Extensions
ip6_tables: (C) 2000-2006 Netfilter Core Team
nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
ip_tables: (C) 2000-2006 Netfilter Core Team
r8169 0000:02:00.0: firmware: requesting rtl_nic/rtl8168e-3.fw
r8169 0000:02:00.0: eth0: link down
r8169 0000:02:00.0: eth0: link down
ADDRCONF(NETDEV_UP): eth0: link is not ready
r8169 0000:02:00.0: eth0: link up
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
powernow-k8: Found 1 AMD A4-5300 APU with Radeon(tm) HD Graphics     (2=
=20
cpu cores) (version 2.20.00)
powernow-k8: Core Performance Boosting: on.
powernow-k8:    0 : pstate 0 (3400 MHz)
powernow-k8:    1 : pstate 1 (3000 MHz)
powernow-k8:    2 : pstate 2 (2700 MHz)
powernow-k8:    3 : pstate 3 (2300 MHz)
powernow-k8:    4 : pstate 4 (1900 MHz)
powernow-k8:    5 : pstate 5 (1400 MHz)
802.1Q VLAN Support v1.8 Ben Greear <greearb@candelatech.com>
All bugs added by David S. Miller <davem@redhat.com>
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
SELinux: initialized (dev autofs, type autofs), uses genfs_contexts
fuse init (API version 7.13)
eth0: no IPv6 routers present
hda-intel: IRQ timing workaround is activated for card #0. Suggest a=20
bigger bdl_pos_adj.
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
usb 4-4: reset low speed USB device number 3 using ohci_hcd
[justin@BigBlue Desktop]$


-----------------------------------------------------------------------=
----------------
-----------------------------------------------------------------------=
----------------

localuser:root being added to access control list
[justin@BigBlue mdad]$ sudo make install
[sudo] password for justin:
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o mdadm.o mdadm.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o config.o config.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o policy.o policy.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o mdstat.o mdstat.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o ReadMe.o ReadMe.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o util.o util.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o maps.o maps.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o lib.o lib.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Manage.o Manage.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Assemble.o Assemble.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Build.o Build.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Create.o Create.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Detail.o Detail.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Examine.o Examine.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Grow.o Grow.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Monitor.o Monitor.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o dlink.o dlink.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Kill.o Kill.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Query.o Query.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Incremental.o Incremental.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o Dump.o Dump.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o mdopen.o mdopen.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o super0.o super0.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o super1.o super1.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o super-ddf.o super-ddf.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o super-intel.o super-intel.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o bitmap.o bitmap.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o super-mbr.o super-mbr.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o super-gpt.o super-gpt.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o restripe.o restripe.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o sysfs.o sysfs.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DHAVE_STDINT_H -o sha1.o -c sha1.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o mapfile.o mapfile.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o crc32.o crc32.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o sg_io.o sg_io.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o msg.o msg.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o xmalloc.o xmalloc.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o platform-intel.o=20
platform-intel.c
gcc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter=20
-ggdb -DSendmail=3D\""/usr/sbin/sendmail -t"\"=20
-DCONFFILE=3D\"/etc/mdadm.conf\" -DCONFFILE2=3D\"/etc/mdadm/mdadm.conf\=
"=20
-DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=3D\"map\" -DMDMON_DIR=3D\"/run/md=
adm\"=20
-DFAILED_SLOTS_DIR=3D\"/run/mdadm/failed-slots\"=20
-DVERSION=3D\"3.3.2-69-g56fcbcb\" -DVERS_DATE=3D"\"18th June 2015\""=20
-DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o probe_roms.o probe_roms.c
***** Parent of /run/mdadm does not exist.  Maybe set different RUN_DIR=
=3D
*****  e.g. make RUN_DIR=3D/dev/.mdadm
***** or set CHECK_RUN_DIR=3D0
make: *** [check_rundir] Error 1
[justin@BigBlue mdad]$
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

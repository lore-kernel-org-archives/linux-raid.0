From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: Partitions not recognized when auto-assembling array in initramfs
Date: Mon, 27 Dec 2010 21:47:54 +0100
Message-ID: <201012272147.54790.laurent.pinchart@ideasonboard.com>
References: <201012271618.09209.laurent.pinchart@ideasonboard.com> <20101228072945.2141ac13@notabene.brown>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_6tPGNdaEwqOKB6A"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101228072945.2141ac13@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Boundary-00=_6tPGNdaEwqOKB6A
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

Hi Neil,

On Monday 27 December 2010 21:29:45 Neil Brown wrote:

[snip]

> It might help if you could provide the complete boot logs so I can see
> everything that happened leading up to the partitions not being there.  It
> would help me see if they were never created, or created then removed.
> 
> The command
>    blockdev --rereadpt /dev/md/vol0
> should re-detect the partitions for you, so you could try doing something
> with that as a temporary fix.
> 
> mdadm does sometime remove partitions, but only on things that it is about
> to include in an array, so it shouldn't ever remove the partitions
> on /dev/md/vol0.
> 
> So something odd is happening, and more logs are needed to guess what.

Here are the logs you've requested. dmesg.1.log has been captured after 
running mdadm --assemble --scan. dmesg.2.log has been captured after running 
the same command a second time.

-- 
Regards,

Laurent Pinchart

--Boundary-00=_6tPGNdaEwqOKB6A
Content-Type: text/x-log;
  charset="UTF-8";
  name="dmesg.1.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.1.log"

latency timer to 64
[    2.608368] hda_codec: ALC269: SKU not ready 0x411111f0
[    2.609511] hda_codec: ALC259: BIOS auto-probing.
[    2.614290] ALSA device list:
[    2.615392]   #0: HDA Intel at 0xff87c000 irq 16
[    2.616456] Netfilter messages via NETLINK v0.30.
[    2.617513] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[    2.618973] ctnetlink v0.93: registering with nfnetlink.
[    2.620405] ip_tables: (C) 2000-2006 Netfilter Core Team
[    2.621457] TCP cubic registered
[    2.622486] Initializing XFRM netlink socket
[    2.624323] NET: Registered protocol family 10
[    2.625192] ata5: SATA link down (SStatus 0 SControl 300)
[    2.627555] ip6_tables: (C) 2000-2006 Netfilter Core Team
[    2.628641] IPv6 over IPv4 tunneling driver
[    2.630448] NET: Registered protocol family 17
[    2.631482] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    2.631485] hub 1-0:1.0: port 1: status 0501 change 0001
[    2.631505] Registering the dns_resolver key type
[    2.634497] PM: Resume from disk failed.
[    2.634504] registered taskstats version 1
[    2.635715]   Magic number: 6:978:753
[    2.660204] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001803 0  ACK POWER sig=j CSC CONNECT
[    2.660214] hub 2-0:1.0: port 1: status 0501 change 0001
[    2.731053] hub 1-0:1.0: state 7 ports 3 chg 0002 evt 0000
[    2.731060] hub 1-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    2.779022] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.779031] ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.780170] ata2.00: ATA-8: WDC WD2500BEKT-75A25T0, 01.01A01, max UDMA/133
[    2.780173] ata2.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.781404] ata2.00: configured for UDMA/133
[    2.782114] ehci_hcd 0000:00:1a.0: port 1 high speed
[    2.782117] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    2.784315] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    2.785885] ata1.00: ATA-8: WDC WD2500BEKT-75A25T0, 01.01A01, max UDMA/133
[    2.786989] ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32), AA
[    2.788107] ata3.00: ATAPI: PLDS DVD+/-RW DH-16ABS, PD11, max UDMA/100
[    2.789299] ata1.00: configured for UDMA/133
[    2.790740] ata3.00: configured for UDMA/100
[    2.790763] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500BEKT-7 01.0 PQ: 0 ANSI: 5
[    2.791644] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    2.791886] sd 0:0:0:0: [sda] Write Protect is off
[    2.791889] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    2.791932] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    2.792019] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.792238] scsi 1:0:0:0: Direct-Access     ATA      WDC WD2500BEKT-7 01.0 PQ: 0 ANSI: 5
[    2.792384] sd 1:0:0:0: [sdb] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    2.792430] sd 1:0:0:0: Attached scsi generic sg1 type 0
[    2.792435] sd 1:0:0:0: [sdb] Write Protect is off
[    2.792437] sd 1:0:0:0: [sdb] Mode Sense: 00 3a 00 00
[    2.792456] sd 1:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    2.806234] scsi 2:0:0:0: CD-ROM            PLDS     DVD+-RW DH-16ABS PD11 PQ: 0 ANSI: 5
[    2.813932] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[    2.815090] cdrom: Uniform CD-ROM driver Revision: 3.20
[    2.816504] sr 2:0:0:0: Attached scsi CD-ROM sr0
[    2.816729] sr 2:0:0:0: Attached scsi generic sg2 type 5
[    2.821487]  sda: sda1 sda2 sda3
[    2.823104] sd 0:0:0:0: [sda] Attached SCSI disk
[    2.827583]  sdb: sdb1 sdb2 sdb3
[    2.829584] sd 1:0:0:0: [sdb] Attached SCSI disk
[    2.830803] Freeing unused kernel memory: 476k freed
[    2.832053] Write protecting the kernel read-only data: 8192k
[    2.833533] Freeing unused kernel memory: 884k freed
[    2.833753] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    2.835963] Freeing unused kernel memory: 72k freed
[    2.884938] ehci_hcd 0000:00:1a.0: port 1 high speed
[    2.884941] ehci_hcd 0000:00:1a.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    2.947788] ehci_hcd 0000:00:1a.0: set dev address 2 for port 1
[    2.947796] ehci_hcd 0000:00:1a.0: LPM: no device attached
[    2.948038] usb 1-1: udev 2, busnum 1, minor = 1
[    2.948044] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    2.948049] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.948630] usb 1-1: usb_probe_device
[    2.948634] usb 1-1: configuration #1 chosen from 1 choice
[    2.948775] usb 1-1: adding 1-1:1.0 (config #1, interface 0)
[    2.949022] hub 1-1:1.0: usb_probe_interface
[    2.949028] hub 1-1:1.0: usb_probe_interface - got id
[    2.949029] hub 1-1:1.0: USB hub found
[    2.949159] hub 1-1:1.0: 6 ports detected
[    2.949164] hub 1-1:1.0: standalone hub
[    2.949168] hub 1-1:1.0: individual port power switching
[    2.949173] hub 1-1:1.0: individual port over-current protection
[    2.949175] hub 1-1:1.0: Single TT
[    2.949176] hub 1-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    2.949178] hub 1-1:1.0: Port indicators are supported
[    2.949179] hub 1-1:1.0: power on to power good time: 100ms
[    2.949513] hub 1-1:1.0: local power source is good
[    2.949516] hub 1-1:1.0: enabling power on all ports
[    2.950283] drivers/usb/core/inode.c: creating file '002'
[    2.950313] hub 2-0:1.0: state 7 ports 3 chg 0002 evt 0000
[    2.950324] hub 2-0:1.0: port 1, status 0501, change 0000, 480 Mb/s
[    3.000863] ehci_hcd 0000:00:1d.0: port 1 high speed
[    3.000867] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    3.050780] usb 1-1: link qh256-0001/ffff88011e560e80 start 1 [1/0 us]
[    3.051568] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    3.102686] ehci_hcd 0000:00:1d.0: port 1 high speed
[    3.102689] ehci_hcd 0000:00:1d.0: GetStatus port:1 status 001005 0  ACK POWER sig=se0 PE CONNECT
[    3.165534] ehci_hcd 0000:00:1d.0: set dev address 2 for port 1
[    3.165542] ehci_hcd 0000:00:1d.0: LPM: no device attached
[    3.165826] usb 2-1: udev 2, busnum 2, minor = 129
[    3.165832] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    3.165837] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.166403] usb 2-1: usb_probe_device
[    3.166405] usb 2-1: configuration #1 chosen from 1 choice
[    3.166520] usb 2-1: adding 2-1:1.0 (config #1, interface 0)
[    3.166772] hub 2-1:1.0: usb_probe_interface
[    3.166777] hub 2-1:1.0: usb_probe_interface - got id
[    3.166779] hub 2-1:1.0: USB hub found
[    3.166886] hub 2-1:1.0: 8 ports detected
[    3.166888] hub 2-1:1.0: standalone hub
[    3.166889] hub 2-1:1.0: individual port power switching
[    3.166890] hub 2-1:1.0: individual port over-current protection
[    3.166892] hub 2-1:1.0: Single TT
[    3.166893] hub 2-1:1.0: TT requires at most 8 FS bit times (666 ns)
[    3.166895] hub 2-1:1.0: Port indicators are supported
[    3.166896] hub 2-1:1.0: power on to power good time: 100ms
[    3.167150] hub 2-1:1.0: local power source is good
[    3.167152] hub 2-1:1.0: enabling power on all ports
[    3.168108] drivers/usb/core/inode.c: creating file '002'
[    3.168136] hub 1-1:1.0: state 7 ports 6 chg 0000 evt 0000
[    3.267365] hub 2-1:1.0: port 1: status 0101 change 0001
[    3.267649] hub 2-1:1.0: port 2: status 0101 change 0001
[    3.268777] hub 2-1:1.0: port 6: status 0101 change 0001
[    3.269168] hub 2-1:1.0: port 7: status 0101 change 0001
[    3.369049] usb 2-1: link qh256-0001/ffff88011dc10600 start 1 [1/0 us]
[    3.369121] hub 2-1:1.0: state 7 ports 8 chg 00c6 evt 0000
[    3.369347] hub 2-1:1.0: port 1, status 0101, change 0000, 12 Mb/s
[    3.380158] hub 2-1:1.0: port 1 not reset yet, waiting 10ms
[    3.442053] usb 2-1.1: new full speed USB device using ehci_hcd and address 3
[    3.453031] hub 2-1:1.0: port 1 not reset yet, waiting 10ms
[    3.526783] usb 2-1.1: ep0 maxpacket = 8
[    3.529833] usb 2-1.1: skipped 1 descriptor after interface
[    3.529840] usb 2-1.1: skipped 1 descriptor after interface
[    3.529845] usb 2-1.1: skipped 1 descriptor after interface
[    3.530040] usb 2-1.1: default language 0x0409
[    3.530817] usb 2-1.1: udev 3, busnum 2, minor = 130
[    3.530823] usb 2-1.1: New USB device found, idVendor=046d, idProduct=c52b
[    3.530829] usb 2-1.1: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[    3.530833] usb 2-1.1: Product: USB Receiver
[    3.530837] usb 2-1.1: Manufacturer: Logitech
[    3.531359] usb 2-1.1: usb_probe_device
[    3.531362] usb 2-1.1: configuration #1 chosen from 1 choice
[    3.532164] usb 2-1.1: adding 2-1.1:1.0 (config #1, interface 0)
[    3.532727] usbhid 2-1.1:1.0: usb_probe_interface
[    3.532733] usbhid 2-1.1:1.0: usb_probe_interface - got id
[    3.534764] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.0/input/input2
[    3.534790] usb 2-1.1: link qh8-0601/ffff88011dc10400 start 2 [1/2 us]
[    3.535314] generic-usb 0003:046D:C52B.0001: input,hidraw0: USB HID v1.11 Keyboard [Logitech USB Receiver] on usb-0000:00:1d.0-1.1/input0
[    3.535332] usb 2-1.1: adding 2-1.1:1.1 (config #1, interface 1)
[    3.535554] usbhid 2-1.1:1.1: usb_probe_interface
[    3.535557] usbhid 2-1.1:1.1: usb_probe_interface - got id
[    3.537758] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1:1.1/input/input3
[    3.537776] usb 2-1.1: link qh2-0601/ffff88011dc10300 start 1 [1/2 us]
[    3.538213] usbhid 2-1.1:1.1: looking for a minor, starting at 96
[    3.538536] generic-usb 0003:046D:C52B.0002: input,hiddev0,hidraw1: USB HID v1.11 Mouse [Logitech USB Receiver] on usb-0000:00:1d.0-1.1/input1
[    3.538548] usb 2-1.1: adding 2-1.1:1.2 (config #1, interface 2)
[    3.538800] usbhid 2-1.1:1.2: usb_probe_interface
[    3.538801] usbhid 2-1.1:1.2: usb_probe_interface - got id
[    3.541198] usbhid 2-1.1:1.2: looking for a minor, starting at 96
[    3.541845] generic-usb 0003:046D:C52B.0003: hiddev0,hidraw2: USB HID v1.11 Device [Logitech USB Receiver] on usb-0000:00:1d.0-1.1/input2
[    3.541861] drivers/usb/core/inode.c: creating file '003'
[    3.542015] hub 2-1:1.0: port 2, status 0101, change 0000, 12 Mb/s
[    3.552861] hub 2-1:1.0: port 2 not reset yet, waiting 10ms
[    3.614782] usb 2-1.2: new high speed USB device using ehci_hcd and address 4
[    3.625744] hub 2-1:1.0: port 2 not reset yet, waiting 10ms
[    3.699900] usb 2-1.2: udev 4, busnum 2, minor = 131
[    3.699906] usb 2-1.2: New USB device found, idVendor=0424, idProduct=2514
[    3.699911] usb 2-1.2: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.700480] usb 2-1.2: usb_probe_device
[    3.700483] usb 2-1.2: configuration #1 chosen from 1 choice
[    3.700631] usb 2-1.2: adding 2-1.2:1.0 (config #1, interface 0)
[    3.701035] hub 2-1.2:1.0: usb_probe_interface
[    3.701037] hub 2-1.2:1.0: usb_probe_interface - got id
[    3.701039] hub 2-1.2:1.0: USB hub found
[    3.701237] hub 2-1.2:1.0: 4 ports detected
[    3.701242] hub 2-1.2:1.0: standalone hub
[    3.701246] hub 2-1.2:1.0: individual port power switching
[    3.701250] hub 2-1.2:1.0: individual port over-current protection
[    3.701498] hub 2-1.2:1.0: TT per port
[    3.701504] hub 2-1.2:1.0: TT requires at most 8 FS bit times (666 ns)
[    3.701509] hub 2-1.2:1.0: power on to power good time: 100ms
[    3.701882] hub 2-1.2:1.0: local power source is good
[    3.701889] hub 2-1.2:1.0: enabling power on all ports
[    3.702563] drivers/usb/core/inode.c: creating file '004'
[    3.702691] hub 2-1:1.0: port 6, status 0101, change 0000, 12 Mb/s
[    3.713599] hub 2-1:1.0: port 6 not reset yet, waiting 10ms
[    3.775497] usb 2-1.6: new high speed USB device using ehci_hcd and address 5
[    3.786458] hub 2-1:1.0: port 6 not reset yet, waiting 10ms
[    3.802850] usb 2-1.2: link qh256-0001/ffff88011dc10880 start 4 [1/0 us]
[    3.861010] usb 2-1.6: udev 5, busnum 2, minor = 132
[    3.861016] usb 2-1.6: New USB device found, idVendor=0424, idProduct=2514
[    3.861021] usb 2-1.6: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.861584] usb 2-1.6: usb_probe_device
[    3.861587] usb 2-1.6: configuration #1 chosen from 1 choice
[    3.861736] usb 2-1.6: adding 2-1.6:1.0 (config #1, interface 0)
[    3.862194] hub 2-1.6:1.0: usb_probe_interface
[    3.862200] hub 2-1.6:1.0: usb_probe_interface - got id
[    3.862204] hub 2-1.6:1.0: USB hub found
[    3.862290] hub 2-1.6:1.0: 4 ports detected
[    3.862292] hub 2-1.6:1.0: standalone hub
[    3.862293] hub 2-1.6:1.0: individual port power switching
[    3.862294] hub 2-1.6:1.0: individual port over-current protection
[    3.862477] hub 2-1.6:1.0: TT per port
[    3.862483] hub 2-1.6:1.0: TT requires at most 8 FS bit times (666 ns)
[    3.862487] hub 2-1.6:1.0: power on to power good time: 100ms
[    3.862815] hub 2-1.6:1.0: local power source is good
[    3.862817] hub 2-1.6:1.0: enabling power on all ports
[    3.863425] drivers/usb/core/inode.c: creating file '005'
[    3.863538] hub 2-1:1.0: port 7, status 0101, change 0000, 12 Mb/s
[    3.874487] hub 2-1:1.0: port 7 not reset yet, waiting 10ms
[    3.936392] usb 2-1.7: new high speed USB device using ehci_hcd and address 6
[    3.963813] usb 2-1.6: link qh256-0001/ffff88011dc10a00 start 5 [1/0 us]
[    4.005245] hub 2-1:1.0: port 7 not reset yet, waiting 10ms
[    4.138786] usb 2-1.7: default language 0x0409
[    4.143384] usb 2-1.7: udev 6, busnum 2, minor = 133
[    4.143390] usb 2-1.7: New USB device found, idVendor=058f, idProduct=6387
[    4.143396] usb 2-1.7: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.143400] usb 2-1.7: Product: Mass Storage
[    4.143404] usb 2-1.7: Manufacturer: Generic
[    4.143407] usb 2-1.7: SerialNumber: 342791EA
[    4.143961] usb 2-1.7: usb_probe_device
[    4.143964] usb 2-1.7: configuration #1 chosen from 1 choice
[    4.144238] usb 2-1.7: adding 2-1.7:1.0 (config #1, interface 0)
[    4.144825] usb-storage 2-1.7:1.0: usb_probe_interface
[    4.144832] usb-storage 2-1.7:1.0: usb_probe_interface - got id
[    4.145052] scsi6 : usb-storage 2-1.7:1.0
[    4.145862] drivers/usb/core/inode.c: creating file '006'
[    4.145890] hub 2-1:1.0: state 7 ports 8 chg 0000 evt 0040
[    4.146100] hub 2-1.2:1.0: state 7 ports 4 chg 0000 evt 0000
[    4.146107] hub 2-1.6:1.0: state 7 ports 4 chg 0000 evt 0000
[    5.146635] scsi 6:0:0:0: Direct-Access     Generic  Flash Disk       8.07 PQ: 0 ANSI: 2
[    5.148355] sd 6:0:0:0: Attached scsi generic sg3 type 0
[    5.149819] sd 6:0:0:0: [sdc] 1996800 512-byte logical blocks: (1.02 GB/975 MiB)
[    5.150445] sd 6:0:0:0: [sdc] Write Protect is off
[    5.150452] sd 6:0:0:0: [sdc] Mode Sense: 03 00 00 00
[    5.150457] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[    5.151132] usb-stor-scan used greatest stack depth: 4904 bytes left
[    5.152799] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[    5.234038]  sdc: sdc1
[    5.236341] sd 6:0:0:0: [sdc] Assuming drive cache: write through
[    5.236349] sd 6:0:0:0: [sdc] Attached SCSI removable disk
[    7.031639] md: md127 stopped.
[    7.034484] md: bind<sda>
[    7.034520] md: bind<sdb>
[    7.050977] md: md126 stopped.
[    7.051437] md: bind<sdb>
[    7.051495] md: bind<sda>
[    7.055282] md/raid1:md126: active with 2 out of 2 mirrors
[    7.055296] md126: detected capacity change from 0 to 250056015872

--Boundary-00=_6tPGNdaEwqOKB6A
Content-Type: text/x-log;
  charset="UTF-8";
  name="dmesg.2.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="dmesg.2.log"

[   30.239287]  md126: p1 p2 p3

--Boundary-00=_6tPGNdaEwqOKB6A--

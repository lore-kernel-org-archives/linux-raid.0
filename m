From: Nils-Henner Krueger <nhk@netuse.de>
Subject: md autodetection
Date: Mon, 21 Mar 2005 09:06:44 +0100
Message-ID: <423E8094.7050809@netuse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've got a few questions about raid autodetection at boot time.

To use a mirrored boot device, I have to use raid autodetection
to have the md devices running early enough?

To have autodection recognise a disk device, it has to run after
the appropriate device driver, right?

In my current setup, running RHEL3 with kernel 2.4.21, I have
the system installed on a scsi disk. The scsi driver ist loaded
as module and added to the initrd.
Currently raid autodection takes place long before the scsi
device driver is loaded:

[...]
ICH5: IDE controller at PCI slot 00:1f.1
ICH5: chipset revision 2
ICH5: not 100% native mode: will probe irqs later
    ide0: BM-DMA at 0x1460-0x1467, BIOS settings: hda:pio, hdb:pio
    ide1: BM-DMA at 0x1468-0x146f, BIOS settings: hdc:pio, hdd:pio
hdc: DV-28E-C, ATAPI CD/DVD-ROM drive
ide1 at 0x170-0x177,0x376 on irq 15
ide-floppy driver 0.99.newide
ide-floppy driver 0.99.newide
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
md: Autodetecting RAID arrays.
md: autorun ...
md: ... autorun DONE.
pci_hotplug: PCI Hot Plug PCI Core version: 0.5
Initializing Cryptographic API
NET4: Linux TCP/IP 1.0 for NET4.0
IP: routing cache hash table of 65536 buckets, 512Kbytes
TCP: Hash tables configured (established 524288 bind 65536)
Linux IP multicast router 0.06 plus PIM-SM
Initializing IPsec netlink socket
NET4: Unix domain sockets 1.0/SMP for Linux NET4.0.
RAMDISK: Compressed image found at block 0
Freeing initrd memory: 610k freed
VFS: Mounted root (ext2 filesystem).
SCSI subsystem driver Revision: 1.00
libata version 1.02 loaded.
ata_piix version 1.02
PCI: Setting latency timer of device 00:1f.2 to 64
ata1: SATA max UDMA/133 cmd 0x1490 ctl 0x1486 bmdma 0x1470 irq 18
ata2: SATA max UDMA/133 cmd 0x1488 ctl 0x1482 bmdma 0x1478 irq 18
ata1: dev 0 cfg 49:2f00 82:74eb 83:7f63 84:4003 85:74e9 86:3c43 87:4003
88:407f
ata1: dev 0 ATA, max UDMA/133, 145226112 sectors: lba48
ata1: dev 0 configured for UDMA/133
ata2: dev 0 cfg 49:2f00 82:74eb 83:7f63 84:4003 85:74e9 86:3c43 87:4003
88:407f
ata2: dev 0 ATA, max UDMA/133, 145226112 sectors: lba48
ata2: dev 0 configured for UDMA/133
scsi0 : ata_piix
scsi1 : ata_piix
  Vendor: ATA       Model: WDC WD740GD-00FL  Rev: 27.0
  Type:   Direct-Access                      ANSI SCSI revision: 05
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sda: 145226112 512-byte hdwr sectors (74356 MB)
Partition check:
 sda: sda1 sda2 sda3 sda4 < sda5 sda6 >
  Vendor: ATA       Model: WDC WD740GD-00FL  Rev: 27.0
  Type:   Direct-Access                      ANSI SCSI revision: 05
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
SCSI device sdb: 145226112 512-byte hdwr sectors (74356 MB)
 sdb:
[...]

Is there a way to run raid autodection (again?) later in the
boot sequence to detect not only IDE devices but other things
like scsi, too?

Last question:  :-)
Is it possible to make a distinction between some md-devices which
should be detected and started by raid autodetection and others which
should be left untouched?


Thanks for help!

nils-henner

From: Sebastian Slota <sebastian@sslota.de>
Subject: SATA Performance
Date: Fri, 8 Oct 2004 13:35:37 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200410081335.37325.sebastian@sslota.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

After I've updated my system and installed everything anew I experience a 
really low IDE Performance.

Here some data:

hdparm -t /dev/sda

/dev/sda:
 Timing buffered disk reads:   44 MB in  3.09 seconds =  14.24 MB/sec

hdparm -t /dev/md0

/dev/md0:
 Timing buffered disk reads:  116 MB in  3.02 seconds =  38.47 MB/sec

Any Idea whats wrong?
I read this year there were problems with seagate HD and there would be a 
patch against corrupting data....

When is it intended to rise the performance? I remember from 2.4 kernel that 
the HD's were working with average 50MB/s each!


Here is my dmesg (all ide relevant data)

dmesg:

libata version 1.02 loaded.
sata_sil version 0.54
ACPI: PCI interrupt 0000:03:03.0[A] -> GSI 19 (level, low) -> IRQ 19
ata1: SATA max UDMA/100 cmd 0xF8B09080 ctl 0xF8B0908A bmdma 0xF8B09000 irq 19
ata2: SATA max UDMA/100 cmd 0xF8B090C0 ctl 0xF8B090CA bmdma 0xF8B09008 irq 19
ata3: SATA max UDMA/100 cmd 0xF8B09280 ctl 0xF8B0928A bmdma 0xF8B09200 irq 19
ata4: SATA max UDMA/100 cmd 0xF8B092C0 ctl 0xF8B092CA bmdma 0xF8B09208 irq 19
ata1: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 
88:207f
ata1: dev 0 ATA, max UDMA/133, 312581808 sectors: lba48
ata1(0): applying Seagate errata fix
ata1: dev 0 configured for UDMA/100
scsi0 : sata_sil
ata2: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 
88:207f
ata2: dev 0 ATA, max UDMA/133, 312581808 sectors: lba48
ata2(0): applying Seagate errata fix
ata2: dev 0 configured for UDMA/100
scsi1 : sata_sil
ata3: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 
88:207f
ata3: dev 0 ATA, max UDMA/133, 312581808 sectors: lba48
ata3(0): applying Seagate errata fix
ata3: dev 0 configured for UDMA/100
scsi2 : sata_sil
ata4: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01 87:4003 
88:207f
ata4: dev 0 ATA, max UDMA/133, 312581808 sectors: lba48
ata4(0): applying Seagate errata fix
ata4: dev 0 configured for UDMA/100
scsi3 : sata_sil
  Vendor: ATA       Model: ST3160023AS       Rev: 3.05
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sda: 312581808 512-byte hdwr sectors (160042 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
  Vendor: ATA       Model: ST3160023AS       Rev: 3.05
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdb: 312581808 512-byte hdwr sectors (160042 MB)
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0
  Vendor: ATA       Model: ST3160023AS       Rev: 3.05
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdc: 312581808 512-byte hdwr sectors (160042 MB)
SCSI device sdc: drive cache: write back
 sdc: sdc1 sdc2
Attached scsi disk sdc at scsi2, channel 0, id 0, lun 0
  Vendor: ATA       Model: ST3160023AS       Rev: 3.05
  Type:   Direct-Access                      ANSI SCSI revision: 05
SCSI device sdd: 312581808 512-byte hdwr sectors (160042 MB)
SCSI device sdd: drive cache: write back
 sdd: sdd1
Attached scsi disk sdd at scsi3, channel 0, id 0, lun 0
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
raid5: automatically using best checksumming function: pIII_sse
   pIII_sse  :  3920.000 MB/sec
raid5: using function: pIII_sse (3920.000 MB/sec)
md: raid5 personality registered as nr 4
ReiserFS: hda5: found reiserfs format "3.6" with standard journal
ReiserFS: hda5: using ordered data mode
ReiserFS: hda5: journal params: device hda5, size 8192, journal first block 
18,
max trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: hda5: checking transaction log (hda5)
ReiserFS: hda5: Using r5 hash to sort names
Freeing unused kernel memory: 156k freed
md: raidstart(pid 353) used deprecated START_ARRAY ioctl. This will not be 
suppo
rted beyond 2.6
md: autorun ...
md: considering sdc2 ...
md:  adding sdc2 ...
md:  adding sdb2 ...
md:  adding sda2 ...
md: created md0
md: bind<sda2>
md: bind<sdb2>
md: bind<sdc2>
md: running: <sdc2><sdb2><sda2>
raid5: device sdc2 operational as raid disk 2
raid5: device sdb2 operational as raid disk 1
raid5: device sda2 operational as raid disk 0
raid5: allocated 3155kB for md0
raid5: raid level 5 set md0 active with 3 out of 3 devices, algorithm 2
RAID5 conf printout:
 --- rd:3 wd:3 fd:0
 disk 0, o:1, dev:sda2
 disk 1, o:1, dev:sdb2
 disk 2, o:1, dev:sdc2
md: ... autorun DONE.
ReiserFS: md0: found reiserfs format "3.6" with standard journal
ReiserFS: md0: using ordered data mode
ReiserFS: md0: journal params: device md0, size 8192, journal first block 18, 
ma
x trans len 1024, max batch 900, max commit age 30, max trans age 30
ReiserFS: md0: checking transaction log (md0)
ReiserFS: md0: Using r5 hash to sort names


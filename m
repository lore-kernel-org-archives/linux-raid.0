From: Niccolo Rigacci <niccolo@rigacci.org>
Subject: IBM xSeries stop responding during RAID1 reconstruction
Date: Wed, 14 Jun 2006 10:53:54 +0200
Message-ID: <20060614085354.GA18106@rigacci.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi to all,

I have a new IBM xSeries 206m with two SATA drives, I installed a 
Debian Testing (Etch) and configured a software RAID as shown:

Personalities : [raid1]
md1 : active raid1 sdb5[1] sda5[0]
      1951744 blocks [2/2] [UU]

md2 : active raid1 sdb6[1] sda6[0]
      2931712 blocks [2/2] [UU]

md3 : active raid1 sdb7[1] sda7[0]
      39061952 blocks [2/2] [UU]

md0 : active raid1 sdb1[1] sda1[0]
      5855552 blocks [2/2] [UU]

I experience this problem: whenever a volume is reconstructing 
(syncing), the system stops responding. The machine is alive, 
because it responds to the ping, the console is responsive but I 
cannot pass the login prompt. It seems that every disk activity 
is delayed and blocking.

When the sync is complete, the machine start to respond again 
perfectly.

Any hints on how to start debugging?


In the log file nothing strange appears:

Jun 13 18:48:04 paros kernel: md: bind<sdb1>
Jun 13 18:48:04 paros kernel: RAID1 conf printout:
Jun 13 18:48:04 paros kernel:  --- wd:1 rd:2
Jun 13 18:48:04 paros kernel:  disk 0, wo:0, o:1, dev:sda1
Jun 13 18:48:04 paros kernel:  disk 1, wo:1, o:1, dev:sdb1
Jun 13 18:48:04 paros kernel: md: syncing RAID array md0
Jun 13 18:48:04 paros kernel: md: minimum _guaranteed_ 
    reconstruction speed: 1000 KB/sec/disc.
Jun 13 18:48:04 paros kernel: md: using maximum available idle IO 
    bandwidth (but not more than 200000 KB/sec) for 
    reconstruction.
Jun 13 18:48:04 paros kernel: md: using 128k window, over a total 
    of 5855552 blocks.
Jun 13 18:57:30 paros kernel: md: md0: sync done.
Jun 13 18:57:30 paros kernel: RAID1 conf printout:
Jun 13 18:57:30 paros kernel:  --- wd:2 rd:2
Jun 13 18:57:30 paros kernel:  disk 0, wo:0, o:1, dev:sda1
Jun 13 18:57:30 paros kernel:  disk 1, wo:0, o:1, dev:sdb1


Those are the IDE controllers as identified by lspci:

0000:00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 
             Family) IDE Controller (rev 01)
0000:00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 
             Family) Serial ATA Storage Controllers cc=IDE
             (rev 01)


And those are the SATA drivers detected by the kernel:

ata1: SATA max UDMA/133 cmd 0x30C8 ctl 0x30BE bmdma 0x3090
      irq 233
ata2: SATA max UDMA/133 cmd 0x30C0 ctl 0x30BA bmdma 0x3098
      irq 233
ata1: dev 1 cfg 49:2f00 82:346b 83:7fe9 84:4773 85:3469 86:3c01 
      87:4763 88:207f
ata1: dev 1 ATA-7, max UDMA/133, 156312576 sectors: LBA48
ata1: dev 1 configured for UDMA/133
scsi0 : ata_piix
ata2: dev 1 cfg 49:2f00 82:346b 83:7fe9 84:4773 85:3469 86:3c01 
      87:4763 88:207f
ata2: dev 1 ATA-7, max UDMA/133, 156312576 sectors: LBA48
ata2: dev 1 configured for UDMA/133
scsi1 : ata_piix
  Vendor: ATA       Model: HDS728080PLA380   Rev: PF2O
  Type:   Direct-Access                    ANSI SCSI revision: 05
  Vendor: ATA       Model: HDS728080PLA380   Rev: PF2O
  Type:   Direct-Access                    ANSI SCSI revision: 05
SCSI device sda: 156312576 512-byte hdwr sectors (80032 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 156312576 512-byte hdwr sectors (80032 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2 < sda5 sda6 sda7 >
sd 0:0:1:0: Attached scsi disk sda
SCSI device sdb: 156312576 512-byte hdwr sectors (80032 MB)
SCSI device sdb: drive cache: write back
SCSI device sdb: 156312576 512-byte hdwr sectors (80032 MB)
SCSI device sdb: drive cache: write back
 sdb: sdb1 sdb2 < sdb5 sdb6 sdb7 >
sd 1:0:1:0: Attached scsi disk sdb

-- 
Niccolo Rigacci
Firenze - Italy

Iraq, missione di pace: 38355 morti - www.iraqbodycount.net

From: Jan Marek <jmarek@jcu.cz>
Subject: SW RAID0 hung-up on 2.6.11.11 kernel?
Date: Thu, 9 Jun 2005 18:38:49 +0200
Message-ID: <20050609163849.GH17536@hazard.jcu.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I have server on AMD64 platform with root on SW RAID1, which was
made by mdadm utility. Distribution is Debian AMD64 sid.

I have two disks on SATA controller.

dmesg say:
sata_via(0000:00:0f.0): routed to hard irq line 11
ata1: SATA max UDMA/133 cmd 0xB800 ctl 0xBC02 bmdma 0xC800 irq 20
ata2: SATA max UDMA/133 cmd 0xC000 ctl 0xC402 bmdma 0xC808 irq 20
ata1: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01
87:4003 88:407f
ata1: dev 0 ATA, max UDMA/133, 156301488 sectors: lba48
ata1: dev 0 configured for UDMA/133
scsi0 : sata_via
ata2: dev 0 cfg 49:2f00 82:346b 83:7d01 84:4003 85:3469 86:3c01
87:4003 88:407f
ata2: dev 0 ATA, max UDMA/133, 156301488 sectors: lba48
ata2: dev 0 configured for UDMA/133
scsi1 : sata_via
Using anticipatory io scheduler
  Vendor: ATA       Model: ST380817AS        Rev: 3.42
  Type:   Direct-Access                      ANSI SCSI revision:
05
  Vendor: ATA       Model: ST380817AS        Rev: 3.42
  Type:   Direct-Access                      ANSI SCSI revision:
05
SCSI device sda: 156301488 512-byte hdwr sectors (80026 MB)
SCSI device sda: drive cache: write back
 /dev/scsi/host0/bus0/target0/lun0: p1 p2
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
SCSI device sdb: 156301488 512-byte hdwr sectors (80026 MB)
SCSI device sdb: drive cache: write back
 /dev/scsi/host1/bus0/target0/lun0: p1 p2
Attached scsi disk sdb at scsi1, channel 0, id 0, lun 0

...

md: md0 stopped.
md: bind<sdb1>
md: bind<sda1>
md: md0: raid array is not clean -- starting background
reconstruction
raid1: raid set md0 active with 2 out of 2 mirrors
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than
200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 76172096 blocks.

... and after recontruction:

md: md0: sync done.
RAID1 conf printout:
 --- wd:2 rd:2
 disk 0, wo:0, o:1, dev:sda1
 disk 1, wo:0, o:1, dev:sdb1

I have problem, because I though, that this level of RAID give me
a functionality, when one of disk will have problem. But I had
twice problem, when is occured problem to write to the sdb disk
and md0 device hang-up. And, unfortunately, I have not any dmesg
messages after hang-up, md0 is root filesystem and there is logs
too.

Now I removed one partion from swap to the /var/log to have some
messages about hung-up of md0 RAID.

Have I somethink bad? What you can advice me about this
situation? Why RAID1 hung-up?

Please, cc to me, since I'm not subscribed.

Thank you very much.

Sicerely
Jan Marek
-- 
Ing. Jan Marek               | Nez mi poslete prilohu .doc, .xls 
University of South Bohemia  | nebo .ppt, prectete si, prosim,
Academic Computer Centre     | WWW stranku uvedenou na poslednim
Phone: +420-38-9032080       | radku signatury...
http://www.gnu.org/philosophy/no-word-attachments.cs.html

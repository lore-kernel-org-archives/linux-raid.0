From: Dave W <dave+gmane@wuertele.com>
Subject: md/mdadm makes some drives spare even though there appears to be nothing wrong with them!
Date: Sat, 12 Jun 2010 05:02:11 +0000 (UTC)
Message-ID: <loom.20100612T065449-444@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After a reboot recently, my 5-disk RAID6 array wouldn't come up:

[root@fileserver log]# mdadm --stop /dev/md0
mdadm: stopped /dev/md0
[root@fileserver log]# mdadm -Af /dev/md0 /dev/sd[bcdef]1
mdadm: /dev/md0 assembled from 2 drives and 3 spares - not enough to start the \
array.

I never configured spare drives.  I'm trying to determine why md/mdadm has
decided that three of  my drives should be spare.

There is nothing in the logs that indicates a problem with the drives.  smartctl
reports that all the drives are healthy.  I suspected the eSATA cable so I
swapped it for a new one.  I suspected the enclosure's backplane so I swapped it
for a new one of the same model.  What else can I try?

When I powered up the new enclosure, here is what I saw in my /var/log/messages.
 It looks normal to me.  Are there any hints here?

Jun 12 05:31:52 fileserver kernel: ata3.00: ATA-8: WDC WD20EADS-00R6B0,
01.00A01, max UDMA/133
Jun 12 05:31:52 fileserver kernel: ata3.00: 3907029168 sectors, multi 0: LBA48
NCQ (depth 31/32)
Jun 12 05:31:52 fileserver kernel: ata3.00: configured for UDMA/100
Jun 12 05:31:53 fileserver kernel: ata3.01: ATA-8: WDC WD20EADS-00R6B0,
01.00A01, max UDMA/133
Jun 12 05:31:53 fileserver kernel: ata3.01: 3907029168 sectors, multi 0: LBA48
NCQ (depth 31/32)
Jun 12 05:31:53 fileserver kernel: ata3.01: configured for UDMA/100
Jun 12 05:31:53 fileserver kernel: ata3.02: ATA-8: WDC WD20EADS-00R6B0,
01.00A01, max UDMA/133
Jun 12 05:31:53 fileserver kernel: ata3.02: 3907029168 sectors, multi 0: LBA48
NCQ (depth 31/32)
Jun 12 05:31:53 fileserver kernel: ata3.02: configured for UDMA/100
Jun 12 05:31:53 fileserver kernel: ata3.03: ATA-8: WDC WD20EADS-00R6B0,
01.00A01, max UDMA/133
Jun 12 05:31:53 fileserver kernel: ata3.03: 3907029168 sectors, multi 0: LBA48
NCQ (depth 31/32)
Jun 12 05:31:53 fileserver kernel: ata3.03: configured for UDMA/100
Jun 12 05:31:53 fileserver kernel: ata3.04: ATA-8: WDC WD20EADS-00R6B0,
01.00A01, max UDMA/133
Jun 12 05:31:53 fileserver kernel: ata3.04: 3907029168 sectors, multi 0: LBA48
NCQ (depth 31/32)
Jun 12 05:31:53 fileserver kernel: ata3.04: configured for UDMA/100
Jun 12 05:31:53 fileserver kernel: ata3: EH complete
Jun 12 05:31:53 fileserver kernel: scsi 2:0:0:0: Direct-Access     ATA      WDC
WD20EADS-00R 01.0 PQ: 0 ANSI: 5
Jun 12 05:31:53 fileserver kernel: sd 2:0:0:0: [sdb] 3907029168 512-byte
hardware sectors (2000399 MB)
Jun 12 05:31:53 fileserver kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 12 05:31:53 fileserver kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Jun 12 05:31:53 fileserver kernel: sd 2:0:0:0: [sdb] 3907029168 512-byte
hardware sectors (2000399 MB)
Jun 12 05:31:53 fileserver kernel: sd 2:0:0:0: [sdb] Write Protect is off
Jun 12 05:31:53 fileserver kernel: sd 2:0:0:0: [sdb] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Jun 12 05:31:53 fileserver kernel: sdb: sdb1
Jun 12 05:31:53 fileserver kernel: sd 2:0:0:0: [sdb] Attached SCSI disk
Jun 12 05:31:53 fileserver kernel: sd 2:0:0:0: Attached scsi generic sg1 type 0
Jun 12 05:31:53 fileserver kernel: scsi 2:1:0:0: Direct-Access     ATA      WDC
WD20EADS-00R 01.0 PQ: 0 ANSI: 5
Jun 12 05:31:53 fileserver kernel: sd 2:1:0:0: [sdc] 3907029168 512-byte
hardware sectors (2000399 MB)
Jun 12 05:31:53 fileserver kernel: sd 2:1:0:0: [sdc] Write Protect is off
Jun 12 05:31:53 fileserver kernel: sd 2:1:0:0: [sdc] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Jun 12 05:31:53 fileserver kernel: sd 2:1:0:0: [sdc] 3907029168 512-byte
hardware sectors (2000399 MB)
Jun 12 05:31:53 fileserver kernel: sd 2:1:0:0: [sdc] Write Protect is off
Jun 12 05:31:53 fileserver kernel: sd 2:1:0:0: [sdc] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Jun 12 05:31:53 fileserver kernel: sdc: sdc1
Jun 12 05:31:53 fileserver kernel: sd 2:1:0:0: [sdc] Attached SCSI disk
Jun 12 05:31:53 fileserver kernel: sd 2:1:0:0: Attached scsi generic sg2 type 0
Jun 12 05:31:53 fileserver kernel: scsi 2:2:0:0: Direct-Access     ATA      WDC
WD20EADS-00R 01.0 PQ: 0 ANSI: 5
Jun 12 05:31:53 fileserver kernel: sd 2:2:0:0: [sdd] 3907029168 512-byte
hardware sectors (2000399 MB)
Jun 12 05:31:53 fileserver kernel: sd 2:2:0:0: [sdd] Write Protect is off
Jun 12 05:31:53 fileserver kernel: sd 2:2:0:0: [sdd] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Jun 12 05:31:53 fileserver kernel: sd 2:2:0:0: [sdd] 3907029168 512-byte
hardware sectors (2000399 MB)
Jun 12 05:31:53 fileserver kernel: sd 2:2:0:0: [sdd] Write Protect is off
Jun 12 05:31:53 fileserver kernel: sd 2:2:0:0: [sdd] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Jun 12 05:31:53 fileserver kernel: sdd: sdd1
Jun 12 05:31:53 fileserver kernel: sd 2:2:0:0: [sdd] Attached SCSI disk
Jun 12 05:31:53 fileserver kernel: sd 2:2:0:0: Attached scsi generic sg3 type 0
Jun 12 05:31:53 fileserver kernel: scsi 2:3:0:0: Direct-Access     ATA      WDC
WD20EADS-00R 01.0 PQ: 0 ANSI: 5
Jun 12 05:31:53 fileserver kernel: sd 2:3:0:0: [sde] 3907029168 512-byte
hardware sectors (2000399 MB)
Jun 12 05:31:53 fileserver kernel: sd 2:3:0:0: [sde] Write Protect is off
Jun 12 05:31:53 fileserver kernel: sd 2:3:0:0: [sde] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Jun 12 05:31:53 fileserver kernel: sd 2:3:0:0: [sde] 3907029168 512-byte
hardware sectors (2000399 MB)
Jun 12 05:31:53 fileserver kernel: sd 2:3:0:0: [sde] Write Protect is off
Jun 12 05:31:53 fileserver kernel: sd 2:3:0:0: [sde] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Jun 12 05:31:53 fileserver kernel: sde: sde1
Jun 12 05:31:53 fileserver kernel: sd 2:3:0:0: [sde] Attached SCSI disk
Jun 12 05:31:53 fileserver kernel: sd 2:3:0:0: Attached scsi generic sg4 type 0
Jun 12 05:31:53 fileserver kernel: scsi 2:4:0:0: Direct-Access     ATA      WDC
WD20EADS-00R 01.0 PQ: 0 ANSI: 5
Jun 12 05:31:53 fileserver kernel: sd 2:4:0:0: [sdf] 3907029168 512-byte
hardware sectors (2000399 MB)
Jun 12 05:31:53 fileserver kernel: sd 2:4:0:0: [sdf] Write Protect is off
Jun 12 05:31:53 fileserver kernel: sd 2:4:0:0: [sdf] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Jun 12 05:31:53 fileserver kernel: sd 2:4:0:0: [sdf] 3907029168 512-byte
hardware sectors (2000399 MB)
Jun 12 05:31:53 fileserver kernel: sd 2:4:0:0: [sdf] Write Protect is off
Jun 12 05:31:53 fileserver kernel: sd 2:4:0:0: [sdf] Write cache: enabled, read
cache: enabled, doesn't support DPO or FUA
Jun 12 05:31:53 fileserver kernel: sdf: sdf1
Jun 12 05:31:53 fileserver kernel: sd 2:4:0:0: [sdf] Attached SCSI disk
Jun 12 05:31:53 fileserver kernel: sd 2:4:0:0: Attached scsi generic sg5 type 0
Jun 12 05:32:42 fileserver kernel: md: md0 stopped.
Jun 12 05:32:56 fileserver kernel: md: md0 stopped.
Jun 12 05:32:58 fileserver kernel: md: bind<sde1>
Jun 12 05:32:58 fileserver kernel: md: bind<sdf1>
Jun 12 05:32:58 fileserver kernel: md: bind<sdc1>
Jun 12 05:32:58 fileserver kernel: md: bind<sdb1>
Jun 12 05:32:58 fileserver kernel: md: bind<sdd1>

Thanks for any advice you might have.
Dave



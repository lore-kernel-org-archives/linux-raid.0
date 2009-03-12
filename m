From: Mitchell Laks <mlaks@post.harvard.edu>
Subject: Re: raid 1 single drive failure. rebuilt with replacement drive.
	missing 20G of data
Date: Wed, 11 Mar 2009 22:22:24 -0400
Message-ID: <20090312022224.GB31067@earthlink.net>
References: <20090312021024.GA31067@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090312021024.GA31067@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22:10 Wed 11 Mar     , Mitchell Laks wrote:

Additional information:

I use Promise SATA150 or SATA300 TX4 4 port stata controllers and I find the following errors  in 

dmesg|tail -n

ata2: translated ATA stat/err 0x51/84 to SCSI SK/ASC/ASCQ 0xb/47/00
ata2: status=0x51 { DriveReady SeekComplete Error }
ata2: error=0x84 { DriveStatusError BadCRC }
md: md2: sync done.
RAID1 conf printout:
 --- wd:2 rd:2
 disk 0, wo:0, o:1, dev:sdd1
 disk 1, wo:0, o:1, dev:sdb1
ata3: no sense translation for status: 0x50
ata3: translated ATA stat/err 0x50/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata3: status=0x50 { DriveReady SeekComplete }
ata3: no sense translation for status: 0x50
ata3: translated ATA stat/err 0x50/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata3: status=0x50 { DriveReady SeekComplete }
ata3: no sense translation for status: 0x50
ata3: translated ATA stat/err 0x50/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata3: status=0x50 { DriveReady SeekComplete }
md: syncing RAID array md1
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 390708736 blocks.
md: md1: sync done.
RAID1 conf printout:
 --- wd:1 rd:2
 disk 0, wo:0, o:1, dev:sda1
md: syncing RAID array md2
md: minimum _guaranteed_ reconstruction speed: 1000 KB/sec/disc.
md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for reconstruction.
md: using 128k window, over a total of 390708736 blocks.
md: md2: sync done.
RAID1 conf printout:
 --- wd:2 rd:2
 disk 0, wo:0, o:1, dev:sdd1
 disk 1, wo:0, o:1, dev:sdb1
ata3: no sense translation for status: 0x50
ata3: translated ATA stat/err 0x50/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata3: status=0x50 { DriveReady SeekComplete }
ata3: no sense translation for status: 0x50
ata3: translated ATA stat/err 0x50/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata3: status=0x50 { DriveReady SeekComplete }


and when I do 

dmesg|grep ata 

I find:

 BIOS-e820: 000000003ffb0000 - 000000003ffc0000 (ACPI data)
Memory: 1031252k/1048256k available (1541k kernel code, 16308k reserved, 576k data, 196k init, 130752k highmem)
libata version 2.00 loaded.
sata_promise 0000:00:0d.0: version 1.04
 hda:<6>ata1: SATA max UDMA/133 cmd 0xF88C8200 ctl 0xF88C8238 bmdma 0x0 irq 185
ata2: SATA max UDMA/133 cmd 0xF88C8280 ctl 0xF88C82B8 bmdma 0x0 irq 185
ata3: SATA max UDMA/133 cmd 0xF88C8300 ctl 0xF88C8338 bmdma 0x0 irq 185
ata4: SATA max UDMA/133 cmd 0xF88C8380 ctl 0xF88C83B8 bmdma 0x0 irq 185
scsi0 : sata_promise
ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata1.00: ATA-7, max UDMA/133, 781422768 sectors: LBA48 NCQ (depth 0/32)
ata1.00: ata1: dev 0 multi count 0
ata1.00: configured for UDMA/133
scsi1 : sata_promise
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata2.00: ATA-7, max UDMA/133, 781422768 sectors: LBA48 NCQ (depth 0/32)
ata2.00: ata2: dev 0 multi count 0
ata2.00: configured for UDMA/133
scsi2 : sata_promise
ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata3.00: ATA-7, max UDMA/133, 1465149168 sectors: LBA48 NCQ (depth 0/32)
ata3.00: ata3: dev 0 multi count 0
ata3.00: configured for UDMA/133
scsi3 : sata_promise
ata4: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
ata4.00: ATA-7, max UDMA/133, 781422768 sectors: LBA48 NCQ (depth 0/32)
ata4.00: ata4: dev 0 multi count 0
ata4.00: configured for UDMA/133
EXT3-fs: mounted filesystem with ordered data mode.
sata_via 0000:00:0f.0: version 2.0
sata_via 0000:00:0f.0: routed to hard irq line 10
ata5: SATA max UDMA/133 cmd 0xC000 ctl 0xB802 bmdma 0xA800 irq 177
ata6: SATA max UDMA/133 cmd 0xB400 ctl 0xB002 bmdma 0xA808 irq 177
scsi4 : sata_via
ata5: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
scsi5 : sata_via
ata6: SATA link down 1.5 Gbps (SStatus 0 SControl 300)
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs: mounted filesystem with ordered data mode.
EXT3-fs: mounted filesystem with ordered data mode.
ata2: translated ATA stat/err 0x51/84 to SCSI SK/ASC/ASCQ 0xb/47/00
ata2: status=0x51 { DriveReady SeekComplete Error }
ata2: error=0x84 { DriveStatusError BadCRC }
ata3: no sense translation for status: 0x50
ata3: translated ATA stat/err 0x50/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata3: status=0x50 { DriveReady SeekComplete }
ata3: no sense translation for status: 0x50
ata3: translated ATA stat/err 0x50/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata3: status=0x50 { DriveReady SeekComplete }
ata3: no sense translation for status: 0x50
ata3: translated ATA stat/err 0x50/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata3: status=0x50 { DriveReady SeekComplete }
ata3: no sense translation for status: 0x50
ata3: translated ATA stat/err 0x50/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata3: status=0x50 { DriveReady SeekComplete }
ata3: no sense translation for status: 0x50
ata3: translated ATA stat/err 0x50/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata3: status=0x50 { DriveReady SeekComplete }
 
So when I look up in google I find:

http://bugzilla.kernel.org/show_bug.cgi?id=7516



Any more thoughts?

Thanks

Mitchell Laks



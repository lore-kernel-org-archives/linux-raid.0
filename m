From: "Steve Fairbairn" <steve@fairbairn-family.com>
Subject: HDD errors in dmesg, but don't know why...
Date: Mon, 18 Feb 2008 19:27:09 -0000
Message-ID: <13c501c87264$411461d0$0603a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi All,

I've got a degraded RAID5 which I'm trying to add in the replacement
disk.  Trouble is, every time the recovery starts, it flies along at
70MB/s or so.  Then after doing about 1%, it starts dropping rapidly,
until eventually a device is marked failed.

When I look in dmesg, I get the following...

SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
ata5.00: exception Emask 0x0 SAct 0x7ff SErr 0x0 action 0x0
ata5.00: (irq_stat 0x00060002, device error via SDB FIS)
ata5.00: cmd 60/00:10:3f:0e:f9/01:00:00:00:00/40 tag 2 cdb 0x0 data
131072 in
         res 41/40:00:50:0e:f9/9c:00:00:00:00/40 Emask 0x9 (media error)
ata5.00: configured for UDMA/100
ata5: EH complete
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
ata5.00: exception Emask 0x0 SAct 0x7ff SErr 0x0 action 0x0
ata5.00: (irq_stat 0x00060002, device error via SDB FIS)
ata5.00: cmd 60/00:18:3f:02:f9/01:00:00:00:00/40 tag 3 cdb 0x0 data
131072 in
         res 41/40:00:c3:02:f9/9c:00:00:00:00/40 Emask 0x9 (media error)
ata5.00: configured for UDMA/100
ata5: EH complete
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
ata5.00: exception Emask 0x0 SAct 0x7ff SErr 0x0 action 0x0
ata5.00: (irq_stat 0x00060002, device error via SDB FIS)
ata5.00: cmd 60/00:10:3f:0e:f9/01:00:00:00:00/40 tag 2 cdb 0x0 data
131072 in
         res 41/40:00:50:0e:f9/9c:00:00:00:00/40 Emask 0x9 (media error)
ata5.00: configured for UDMA/100
ata5: EH complete
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
ata5.00: exception Emask 0x0 SAct 0x7ff SErr 0x0 action 0x0
ata5.00: (irq_stat 0x00060002, device error via SDB FIS)
ata5.00: cmd 60/00:18:3f:02:f9/01:00:00:00:00/40 tag 3 cdb 0x0 data
131072 in
         res 41/40:00:c3:02:f9/9c:00:00:00:00/40 Emask 0x9 (media error)
ata5.00: configured for UDMA/100
ata5: EH complete
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back
ata5.00: exception Emask 0x0 SAct 0x3ff SErr 0x0 action 0x0
ata5.00: (irq_stat 0x00060002, device error via SDB FIS)
ata5.00: cmd 60/00:10:3f:0e:f9/01:00:00:00:00/40 tag 2 cdb 0x0 data
131072 in
         res 41/40:00:50:0e:f9/9c:00:00:00:00/40 Emask 0x9 (media error)
ata5.00: configured for UDMA/100
ata5: EH complete
SCSI device sdd: 976773168 512-byte hdwr sectors (500108 MB)
sdd: Write Protect is off
sdd: Mode Sense: 00 3a 00 00
SCSI device sdd: drive cache: write back

I've no idea what to make of these errors.  As far as I can work out,
the HD's themselves are fine They are all less than 2 months old.

The box is CentOS 5.1.  Linux space.homenet.com 2.6.18-53.1.13.el5 #1
SMP Tue Feb 12 13:02:30 EST 2008 x86_64 x86_64 x86_64 GNU/Linux

Any suggestions on what I can do to stop this issue?

Steve.

No virus found in this outgoing message.
Checked by AVG Free Edition. 
Version: 7.5.516 / Virus Database: 269.20.7/1284 - Release Date:
17/02/2008 14:39
 


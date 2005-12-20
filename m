From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: RAID 5 - Botched Output information
Date: Tue, 20 Dec 2005 10:42:00 +0000
Message-ID: <43A7DFF8.80203@projecthugo.co.uk>
Reply-To: kernel-lists@projecthugo.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I'm experimenting with the experimental "sata_mv" driver in the 
2.6.15-rc5-mm kernel.

I've found it "works" but its rather flakey and fails a lot (I'll be 
posting seperate information on this in another post)

I've just created a raid 5 array as a test made up of 5 x 250 GB sata disks.

It seems to complete after a life time (hey - its a lot of disk - no rush)

However dmesg shows the following ouptut (just included the raid 5 
devices output)


md: md6: sync done.
RAID5 conf printout:
 --- rd:5 wd:5 fd:0
 disk 0, o:1, dev:sdc1
 disk 1, o:1, dev:sdd1
 disk 2, o:1, dev:sde1
 disk 3, o:1, dev:sdf1
 disk 4, o:1, dev:sdg1
ata10: translated ATA stat/err 0xd0/00 to SCSI SK/ASC/ASCQ 0xb/47/00
ata10: status=0xd0 { Busy }
ata9: translated ATA stat/err 0xd0/00 to SCSI SK/ASC/ASCQ 0xb/47/00
ata9: status=0xd0 { Busy }
blk: request botched
ata8: translated ATA stat/err 0xd0/00 to SCSI SK/ASC/ASCQ 0xb/47/00
ata8: status=0xd0 { Busy }
blk: request botched
ata6: translated ATA stat/err 0xd0/00 to SCSI SK/ASC/ASCQ 0xb/47/00
ata6: status=0xd0 { Busy }
blk: request botched
ata4: translated ATA stat/err 0xd0/00 to SCSI SK/ASC/ASCQ 0xb/47/00
ata4: status=0xd0 { Busy }
blk: request botched


I'm interested in the statement  blk: request botched

Google turns up many interesting theories about this statments which 
seems to be caused by meny theoretical solutions (I think the people 
responding on the threads found on google are making random guesses to 
be honest)

I thought I'd ask here to get a better understanding of the "blk: 
request botched" statement.

Thanks for the input.

Matt


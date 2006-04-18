From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: libata retry - disable?
Date: Tue, 18 Apr 2006 08:30:42 +0200
Message-ID: <62b0912f0604172330g274c286fje159f9d920d5ec61@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Does anyone know of a way to disable libata's 5-time retry when a read fails?

It has the effect of causing every failed sector read to take 6
seconds before it fails, causing raid5 rebuilds to go awfully slow. 
It's generally undesirable too, when you've got RAID on top that can
write replacement data onto the failed sectors..

Log showing a failed sector:
Apr 18 09:49:53 linux kernel: end_request: I/O error, dev sda, sector 131124407
Apr 18 09:49:55 linux kernel: ata1: no sense translation for status: 0x51
Apr 18 09:49:55 linux kernel: ata1: translated ATA stat/err 0x51/00 to
SCSI SK/ASC/ASCQ 0x3/11/04
Apr 18 09:49:55 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 18 09:49:56 linux kernel: ata1: no sense translation for status: 0x51
Apr 18 09:49:56 linux kernel: ata1: translated ATA stat/err 0x51/00 to
SCSI SK/ASC/ASCQ 0x3/11/04
Apr 18 09:49:56 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 18 09:49:57 linux kernel: ata1: no sense translation for status: 0x51
Apr 18 09:49:57 linux kernel: ata1: translated ATA stat/err 0x51/00 to
SCSI SK/ASC/ASCQ 0x3/11/04
Apr 18 09:49:57 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 18 09:49:59 linux kernel: ata1: no sense translation for status: 0x51
Apr 18 09:49:59 linux kernel: ata1: translated ATA stat/err 0x51/00 to
SCSI SK/ASC/ASCQ 0x3/11/04
Apr 18 09:49:59 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 18 09:50:00 linux kernel: ata1: no sense translation for status: 0x51
Apr 18 09:50:00 linux kernel: ata1: translated ATA stat/err 0x51/00 to
SCSI SK/ASC/ASCQ 0x3/11/04
Apr 18 09:50:00 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 18 09:50:01 linux kernel: ata1: no sense translation for status: 0x51
Apr 18 09:50:01 linux kernel: ata1: translated ATA stat/err 0x51/00 to
SCSI SK/ASC/ASCQ 0x3/11/04
Apr 18 09:50:01 linux kernel: ata1: status=0x51 { DriveReady
SeekComplete Error }
Apr 18 09:50:01 linux kernel: sd 0:0:0:0: SCSI error: return code = 0x8000002
Apr 18 09:50:01 linux kernel: sda: Current: sense key: Medium Error
Apr 18 09:50:01 linux kernel:     Additional sense: Unrecovered read
error - auto reallocate failed
Apr 18 09:50:01 linux kernel: end_request: I/O error, dev sda, sector 131124415
Apr 18 09:50:02 linux kernel: raid5: read error corrected!!
Apr 18 09:50:02 linux last message repeated 112 times

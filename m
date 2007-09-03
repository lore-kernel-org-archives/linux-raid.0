From: Mitchell Laks <mlaks@post.harvard.edu>
Subject: Re: raid1 with sata; md stopping all md devices; Synchronizing SCSI cache from disk sda ; ata8 command timeout?
Date: Mon, 3 Sep 2007 15:03:19 -0400
Message-ID: <20070903190319.GA17076@earthlink.net>
References: <20070902221930.GA10738@earthlink.net> <c03b90ed0709030028k4ae7d3b8n6b1fe388c6c4e926@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c03b90ed0709030028k4ae7d3b8n6b1fe388c6c4e926@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 15:28 Mon 03 Sep     , Michael Yao wrote:
> Hi
> 
> Looks like a disk I/O error to me.
> As I can remember, after kernel 2.6.16, raid1 read error will be auto-corrected.
> 
> I think do a filesystem check might help.
> 
> Michael

Nope. It is not fsck problem.

Unfortunately, I had been remiss in running fsck, so I did on all of the filesystems. They
are in great shape now!

However I still get the error below on shutdown -h now.

Any other ideas??

> > "
> > md stopping all md devices
> > Synchronizing SCSI cache from disk sdg:
> > ata8: command timeout
> > ata8: no sense translation for status:0x40
> > ata8: translated ATA status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
> > ata8: Status =0x40{DriveReady}
> > ata8: command timeout
> > ata8: no sense translation for Status:0x40
> > ata8: translated ATA Status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
> > ata8: Status =0x40{DriveReady}
> > ata8: no sense translation for Status:0x40
> > ata8: translated ATA Status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
> > ata8: Status =0x40{DriveReady}
> > Failed
> >        status=1, message=00, host=0, drive=08
> >        <6>sd: Current: sense key: Aborted Command
> >        Additional sense no additional sense information
> >
> >
> > Synchronizing SCSI cache from disk sdf:
> > ata6: command timeout
> > ata6: no sense translation for status:0x40
> > ata6: translated ATA status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
> > ata6: Status =0x40{DriveReady}
> > ata6: command timeout
> > ata6: no sense translation for Status:0x40
> > ata6: translated ATA Status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
> > ata6: Status =0x40{DriveReady}
> > ata6: no sense translation for Status:0x40
> > ata6: translated ATA Status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
> > ata6: Status =0x40{DriveReady}
> > Failed
> >        status=1, message=00, host=0, drive=08
> >        <6>sd: Current: sense key: Aborted Command
> >        Additional sense no additional sense information

Mitchell Laks

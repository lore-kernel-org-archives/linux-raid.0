From: "George  Iosif" <giosif@ase.ro>
Subject: Re: raid1 with sata; md stopping all md devices; Synchronizing
	SCSI cache from disk sda ; ata8 command timeout?
Date: Mon, 03 Sep 2007 22:34:13 +0300
Message-ID: <46DC8BE6020000B5000077E4@s-mail-1.ase.ro>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: mlaks@post.harvard.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Mitchell,

My guess is that it's a SATA controller driver problem.
I remember that, after a transition from kernel version 2.6.x to 2.6.x+1 (I don't remember the x), I began seeing some strange errors related to my SATA disk/controller while the kernel was initializing the devices (during the boot process).

Can you try using the old version of the kernel (2.6.12) and see if you get rid of the errors ? 

Hope it helps !

George Iosif

>>> Mitchell Laks <mlaks@post.harvard.edu> 09/03/07 10:03 PM >>>
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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


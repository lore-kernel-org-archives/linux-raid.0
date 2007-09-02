From: Mitchell Laks <mlaks@post.harvard.edu>
Subject: raid1 with sata; md stopping all md devices; Synchronizing SCSI cache from disk sda ;  ata8  command timeout?
Date: Sun, 2 Sep 2007 18:19:30 -0400
Message-ID: <20070902221930.GA10738@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I run raid1 on a debian etch server.

If I do "halt" = "shutdown -h now"

I have the following output from my system on shutdown. 
Moreover, the sytem takes an extremely long time to shut down, with all the timeouts :).

output below:

"
md stopping all md devices
Synchronizing SCSI cache from disk sdg:
ata8: command timeout
ata8: no sense translation for status:0x40
ata8: translated ATA status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata8: Status =0x40{DriveReady}
ata8: command timeout
ata8: no sense translation for Status:0x40
ata8: translated ATA Status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata8: Status =0x40{DriveReady}
ata8: no sense translation for Status:0x40
ata8: translated ATA Status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata8: Status =0x40{DriveReady}
Failed
 	status=1, message=00, host=0, drive=08
 	<6>sd: Current: sense key: Aborted Command
	Additional sense no additional sense information
 

Synchronizing SCSI cache from disk sdf:
ata8: command timeout
ata8: no sense translation for status:0x40
ata8: translated ATA status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata8: Status =0x40{DriveReady}
ata8: command timeout
ata8: no sense translation for Status:0x40
ata8: translated ATA Status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata8: Status =0x40{DriveReady}
ata8: no sense translation for Status:0x40
ata8: translated ATA Status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata8: Status =0x40{DriveReady}
Failed
 	status=1, message=00, host=0, drive=08
 	<6>sd: Current: sense key: Aborted Command
	Additional sense no additional sense information
 

Synchronizing SCSI cache from disk sde:
ata8: command timeout
ata8: no sense translation for status:0x40
ata8: translated ATA status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata8: Status =0x40{DriveReady}
ata8: command timeout
ata8: no sense translation for Status:0x40
ata8: translated ATA Status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata8: Status =0x40{DriveReady}
ata8: no sense translation for Status:0x40
ata8: translated ATA Status/error 0x40/00 to SCSI SK/ASC/ASCQ 0xb/00/00
ata8: Status =0x40{DriveReady}
Failed
 	status=1, message=00, host=0, drive=08
 	<6>sd: Current: sense key: Aborted Command
	Additional sense no additional sense information
 
etc.

"
While if I do "reboot" = "shutdown -r now" there is no problem :).

*************************


I have previously been using Sata devices for raid-1 for 2 years using Debian Sarge.

I have just moved over to Debian Etch for  a production server. 

For my data storage I am using 2 Promise 4 port SATA 150 TX4 cards, which have worked well with kernel 2.6.12 in past.
I have 7 SATA data hard drives (either 320G or 500G WD SATA drives attached to the server):
I am using  5 drives as degraded individual Raid-1's on single drives,  
and one full mirrored Raid-1 for a pair of drives. (these are /dev/sda1 through /dev/sdg1).
(I keep legacy data  online on the degraded raid1 and new data is on the mirrored Raid1).
All 7 drives are attached to two  "Promise 4 Port 150 TX4 cards". 
The system drive is on a separate Pata IDE connector.
I blacklisted the kernel module for the sata_via module that controls the built in motherboard sata controller.

I am using stock debian 2.6.18-5-486 kernel. I am running stock Debian mdadm package 2.5.6-9.


The system seems to work reasonably otherwise. 

How do I preven these error messages on shutdown?

Note: If I do "reboot" = "shutdown -r now" all is fine.

(Note: I don't want to confuse things, however the following is also interesting.
If I put both  "Promise 4 port SATA 150 Tx4" cards and "Promise 4 port Sata 300 TX4" cards on one system
then in addition to the above errors I also get a kernel oops during the same part of the shutdown sequence.
Note that the system seems to function fine untill I do "shutdown -h now" and there is no problem
with "shutdown -r now".

Very strange!

Thank you,

Mitchell Laks


 

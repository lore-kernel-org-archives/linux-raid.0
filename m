From: danci@agenda.si
Subject: SCSI hot swap question
Date: Thu, 13 May 2004 08:20:44 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0405130815110.26524@desktop.agenda.si>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi there!

I have a SCSI system with hot-swap SCSI backplane. I'm using Linux 
software RAID (mirror).

One disk has gone bad and it was kicked out of RAID. I also managed to get 
the disk out of SCSI using:

# echo "scsi remove-single-device 0 0 1 0" > /proc/scsi/scsi

So basically the operating system has no idea the disk is still there.

But here is what troubles me: most HW RAID controllers change the status
of the disk on the backplane to let you know it can be safely removed.  
Usually this is visible by a yellow LED or something like that.

Is there a utility to do that without HW RAID controller?

Or is the disk hot-swappable no matter what (as I have already managed to
remove it from RAID and SCSI subsystem)?

 Thanks, D.

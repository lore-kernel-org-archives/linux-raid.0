From: "Michael" <michael@insulin-pumpers.org>
Subject: Re: RAID becomes un-bootable after failure
Date: Wed, 2 Jun 2004 09:57:30 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200406021658.i52GwDl22546@bzs.org>
References: <40BDEA63.5040001@plasticboy.com>
Reply-To: michael@insulin-pumpers.org
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <40BDEA63.5040001@plasticboy.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I have a 2-disk RAID-1 that I set up using the Red Hat 9 installer. My
> problem is that pretty much any simulated drive failure makes the system
> unbootable. If I power down the machine and remove drive 1, the system
> can't find any bootable device. If I set a drive faulty using the
> RAIDtools, re-add it, and let the recovery process run the boot loader
> seems to get overwritten and I end up with a system hung at "GRUB
> loading stage2". Can anyone shed some light on what's going on here? My
> guess is that GRUB isn't installed on drive 2, so that removing drive 1
> or recovering drive 1 from drive 2 leads to no boot loader, but
> shouldn't GRUB have been copied to drive 2 in the mirroring process? How
> can I configure my system so that it will still be bootable after a
> drive failure?
> 

Whether or not a system can boot from the second drive in a 2 drive raid 
is entirely dependent on the motherboard and bios, sometimes the 
controller and the nature of the drive failure.

In an IDE system, to be automatically bootable, the bios must 
automatically switch the boot drive to the first available drive. It must 
be able to determine that that drive '0' is either not connected or 
inoperative -- tough challenge. No two vendors do it the same way in most 
cases if they do it at all. With scsii systems, if a drive is missing, 
"usually" the default will be to select the first available drive. This 
may not work if the failed drive is present as a scsi device, spins up, 
but returns bad data do to a head crash or something like that.

Your best bet is to configure all drives in the system with a boot sector 
that is for device 0x80 and manually swap the drives if drive '0' fails. 
Have a boot floopy, cd, or other insertable backup device available until 
the physical change can be accomplished or the failed device replaced. 
Bear in mind that the system will continue to run with the failed drive, 
it just won't boot without help. If it is a "remote" system, leave a 
floppy in the boot drive instead.

Michael
Michael@Insulin-Pumpers.org

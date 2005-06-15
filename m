From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: sata_nv and RAID1
Date: Tue, 14 Jun 2005 20:34:11 -0400
Message-ID: <200506150034.j5F0YG218110@www.watkins-home.com>
References: <42AF7234.5020608@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42AF7234.5020608@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Jeff Garzik' <jgarzik@pobox.com>, 'Molle Bestefich' <molle.bestefich@gmail.com>
Cc: 'Michael Tokarev' <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Jeff Garzik
> Sent: Tuesday, June 14, 2005 8:12 PM
> To: Molle Bestefich
> Cc: Michael Tokarev; linux-raid@vger.kernel.org
> Subject: Re: sata_nv and RAID1
> 
> Molle Bestefich wrote:
> > So you don't care that your Linux system will deadlock if a PATA disk
> > is removed, for instance?  Just an example, one that I've seen happen
> > a couple of times.  Never seen it with Windows, it just tells you that
> > the disk is gone.
> 
> Your computer will deadlock if you yank a PCI card out, too.  That
> doesn't mean all PCI drivers are broken.
> 
> Very very (did I say "very"?) few people yank hard drives which are not
> built specifically for hotplug, in a hotplug enclosure.

But...
If a hard disk fails in such a way that the interface from the disk goes
dead, that is not a hot un-plug!  It is a drive failure.  Maybe a hot
un-plug should be considered a failure until support is added.

I have seen SCSI disks go away when they fail, no one pulled any plugs!

Also, it is common in the SCSI world to have 2 disk trays in a RAID1 config,
each with different power supplies.  If a power supply were to fail half the
disks would be gone.  Would SATA/Linux consider half the disks hot
un-plugged?

Guy

> 
> 	Jeff
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


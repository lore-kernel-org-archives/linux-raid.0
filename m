From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Selective spin-up
Date: Sun, 22 Jan 2006 19:28:59 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0601221905190.24057-100000@coffee.psychology.mcmaster.ca>
References: <43D32E3A.4020508@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43D32E3A.4020508@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > I recently extended my raid array with a 9th drive, and I find that the 
> > 300 watt PSU I use is insufficient to start the system.  What happens is 

IMO, a many-disk server that tries to use normal non-server commodity parts
is pushing its luck.  the mass market just isn't friendly to >=8 disks in 
a box, either in terms of power, mounting, controllers, etc.  unfortunately,
once people start to "serverize" the hardware, it's easy to get carried away
into the gold-plated realm of FC sans and $20/GB end prices...

> > cuts out.  I've heard that it is possible to spin up disks one at a time 
> > or in groups, but cannot find any such option in the BIOS (Asus A8N-E 
> > board).  Any ideas?

this can be implemented in various ways.  it's fairly common for SCSI disks
to have a jumper which causes them to delay spinup depending on their SCSI id.
for SATA systems, I get the impression that the direction is not yet settled.
one direction is to delay spinup until the link (phy) is initialized.
another is for disks to power-on into standby (not spinning but active).
I guess the main issue is that during boot, the bios has to find bootable 
partitions, which is only possible by actually spinning up disks and reading 
from them.  presumably the bios can skip spinup for disks not in the boot
device list.

incidentally, SMART can report "spin up time", which might be useful in
diagnosing situations when you might have too many drives...


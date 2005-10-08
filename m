From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Automatic drive partitioning
Date: Sat, 8 Oct 2005 12:16:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0510081208520.28615-100000@coffee.psychology.mcmaster.ca>
References: <200510081758.50918.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200510081758.50918.thomas.jarosch@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> is there a tool that can copy a partition table from one drive
> and adapt it for another drive?

I use dd.

> In an ideal world both source and destination drive share the same geometry.
> The partition table could easily be copied using sfdisk.

or dd.  but really, with LBA, most drives already use the same geometry;
have you looked?  255 heads, 64 sectors/track, but a variable number of cylinders.

which makes sense, since "rectangular" geometries have been lies for a long
time (all drives have variable spt.)

> What's this all for you might ask?
> If one disc in a RAID1 array (without a preconfigured hot spare) fails,
> I want to plug in a replacement disc and the rest should be handled
> by some automatic system (partition the drive, hot-add it afterwards).

this level of automaticity is normally considered bad because it 
has extremely unpleasant failure modes.  (consider what happens if 
your sysadmin-assistant, low on coffee one monday morning,
plugs in a drive which he *doesn't* want to be auto-sucked into the array...)

does the devfs/hotplug mechanism let you trigger a script when a new
drive appears?  this would depend somewhat on the fabric - I suspect that 
scsi still needs an explicit rescan command.


From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: Automatic drive partitioning
Date: Sat, 8 Oct 2005 19:10:15 +0200
Message-ID: <200510081910.15934.thomas.jarosch@intra2net.com>
References: <Pine.LNX.4.44.0510081208520.28615-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0510081208520.28615-100000@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mark,

On Saturday 08 October 2005 18:16, you wrote:
> > In an ideal world both source and destination drive share the same
> > geometry. The partition table could easily be copied using sfdisk.
>
> or dd.  but really, with LBA, most drives already use the same geometry;
> have you looked?  255 heads, 64 sectors/track, but a variable number of
> cylinders.
>
> which makes sense, since "rectangular" geometries have been lies for a long
> time (all drives have variable spt.)

I tried copying the partition table using sfdisk and it complained
about "partition does not start at a cylinder boundary". After re-running
with the --force flag (like a dd copy would do) and formatting the partition,
the system went nuts.

Thanks for the hint of variable number of cylinders, but I rather not rely on 
that as I want to solve this in a generic manner.

> > What's this all for you might ask?
> > If one disc in a RAID1 array (without a preconfigured hot spare) fails,
> > I want to plug in a replacement disc and the rest should be handled
> > by some automatic system (partition the drive, hot-add it afterwards).
>
> this level of automaticity is normally considered bad because it
> has extremely unpleasant failure modes.  (consider what happens if
> your sysadmin-assistant, low on coffee one monday morning,
> plugs in a drive which he *doesn't* want to be auto-sucked into the
> array...)

;-)

> does the devfs/hotplug mechanism let you trigger a script when a new
> drive appears?  this would depend somewhat on the fabric - I suspect that
> scsi still needs an explicit rescan command.

I don't want it that automatic. You still have to push a button / run a script 
to activate the new drive. Ideally from a little web frontend which shows
the current status of the array, too.

Thomas

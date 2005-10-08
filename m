From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Automatic drive partitioning
Date: Sat, 8 Oct 2005 15:09:56 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0510081503490.28615-100000@coffee.psychology.mcmaster.ca>
References: <200510081910.15934.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200510081910.15934.thomas.jarosch@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > which makes sense, since "rectangular" geometries have been lies for a long
> > time (all drives have variable spt.)
> 
> I tried copying the partition table using sfdisk and it complained
> about "partition does not start at a cylinder boundary". After re-running
> with the --force flag (like a dd copy would do) and formatting the partition,
> the system went nuts.

hmm, well, I guess you are coming from an older/non-LBA disk.  I suppose 
I should have mentioned that little caveat: don't try the dd trick
going from CHS to LBA.  LBA->LBA should be OK, and CHS is OK if nheads
and nsectors match (and ncyl doesn't go off the end of the disk, of course!)
I don't think the kernel's partition code cares much about
cylinder-alignment (in the CHS world), but other OS's would.
the definition of where the first possible partition starts also 
depends on the size of cylinders (nheads*nsectors)...

> Thanks for the hint of variable number of cylinders, but I rather not rely on 
> that as I want to solve this in a generic manner.

I believe that in an all-LBA world, it's a non-problem.


From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Is My Data DESTROYED?!
Date: Sat, 24 Oct 2009 20:28:44 -0500
Message-ID: <20091025012847745.ZOLG5890@cdptpa-omta01.mail.rr.com>
References: <4AE236B4.20103@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE236B4.20103@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Warning: I can only be polite and diplomatic to a limited number of
> technically incompetent people each day. Today isn't your day.

	Well...

> That's like saying a bicycle is not as good as a frying pan. They are
> totally different things, used for different reasons. A raid array is a
> technique used to improve the performance or reliability of a single
> dynamic copy of data. A backup is an independent copy of the data at
> some point in time, and will continue to exist if the original is
> damaged or destroyed.
> 
> Note: a good backup will be off-site to prevent physical destruction.

	When possible, I like a multi-tiered approach.  The most common
cause of data loss is human error.  By the same token, however, it is also
completely harmless to the hardware. Well, usually.  I did once have an
idiot raise the floor tile underneath one of my servers and then drop it.
That was back in the days when a 300M (that's MEGABYTE, not GIGABYTE) drive
cost $1000.  It was my personal system, too...

	I digress.

	The point is, keeping a live backup system on-site for all data
allows dumb-ass losses to be recovered extremely quickly.  For more critical
data, the backup needs to be kept off-site.  This can be done with a
"sneakernet" solution for best economy, or using a WAN connection.  Either
way, recovering the data is going to be a bit slower, although a WAN
connected system can recover a handful of modestly sized files quite
quickly.  Hyper-critical data can go to vault storage, with no access except
by a very small handful of authorized individuals.

> One of the few things I liked about running servers for at&t was that
> they actually had a "smoking hole recovery plan" requiring steps to
> recover if the data center was physically destroyed. The only other
> organization I have worked with who had that level of concern was a bank
> in Ireland during "the troubles." My general data will survive loss of
> my office and a two mile radius around it, my critical data will survive
> lose off the continental US. Okay, I may take this too seriously. ;-)

	Maybe, maybe not.  In either case, however, if the continental U.S.
is lost, we have bigger problems.  :-)

> > - Of course I wish that backing up could save many terabytes of data for
> less than $10,000.  But that is not practical today.
> >
> >
> Hogwash! You can get an eSATA array tower with four bays from Newegg for
> <$200, 1TB drives for $85/ea on sale (mine are WD 'green' which run
> about 10C cooler than Seagate or Hitachi), and have 3TB RAID-5 for
> ~$600, capable of being daisy chained. Choice of built-in or software
> raid. 2TB drives will add about $400, and with an independent copy of
> the filesystem on a box you have backup. For another $400 you can have a
> cheap 2nd system connected by Gbit network and be totally independent.

	What's really silly is he already HAS this.  He is implementing
RAID10 over two separate systems connected by a 1G Ethernet link.  The
remote system is in his garage.  I keep telling him, "Forget the RAID10
solution, and go with an independent system with backups managed via rsync."
Then he complains about poor RAID10 performance and has a cow when he
encounters a file system corruption (or what he thought was file system
corruption).

> > Fact:  I have terabytes of data that I want to keep from losing.
> > Fact:  Disk drives have never been cheaper.
> > Fact:  It is most cost-effective to save terabytes of data on disk
> drives, if the proper regimen can be determined for safety.
> >
> 
> That means backup, sorry, stuff happens if you only have one copy.

	Exactly.  He seems to have a logic-tight compartment wherein "hard
drive" != "backup".  The most economical backup solutions by far right now
are hard drive based.

> > Fact:  After one month's use mdadm RAID has resulted in a failure which
> > could have been catastrophic had I not determined that somehow JFS
> > functionality was destroyed.

	OP: you have provided no evidence mdadm caused this.

> > Fact:  Now one of my  arrays has gone into degraded mode for mysterious
> > reasons, and we are so busy arguing about backups that no one can advise
> > on what to do about this.

	OP: The root cause is likely to be the same as that which degraded
the array.  If you insist on recovering the array directly, we are going to
need more diagnostics.  At a high level, if the suspect drive is bad, then
it needs to be replaced and the array re-synced.  Another choice would be to
divide up the array into two separate RAID0 arrays and fix the one with a
bad drive.  This is an example of exactly what I meant when I told you this
topology is going to be more difficult to manage than a pair of independent
RAID0 or RAID5 arrays.

> I advise you to go to backup. If you can afford to have "terabytes of
> data" you either live with losing it and just wonder when, or you go to
> real backup.

	Or just convert his RAID10 array into two independent arrays and use
one as a backup.


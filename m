From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: entire array lost when some blocks unreadable?
Date: Tue, 7 Jun 2005 22:27:52 -0400
Message-ID: <200506080227.j582Rv217674@www.watkins-home.com>
References: <42A60FDA.5080402@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42A60FDA.5080402@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mike Hardy' <mhardy@h3c.com>, 'Brad Campbell' <brad@wasp.net.au>
Cc: 'Tom Eicher' <tom.eicher@gmx.ch>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have 17 scsi disks, all 18 Gig.  I run a full scan each night.  I find
about 1 error each week.  The rate was much lower until a few months ago.
Mostly the same few disks.  Anyway, the errors are corrected by the scan
before md finds them.  Otherwise the errors could sit dormant for months
waiting for md to find 1, then while re-building to the spare md would find
another and poof!  Array gone.  Manual override needed to correct.  Since I
starting the scanning, md has not found any bad blocks.

The sad part, this is why I say Linux is not ready for prime time.  Ok for
home use, but not a 24x7 system that my job depends on!!!  If my job depends
on it, get an external hardware RAID system with battery backed memory.

Please, someone fix the bad block problems!!!
Without kicking out the disk as part of the solution!!!

Guy

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Mike Hardy
> Sent: Tuesday, June 07, 2005 5:22 PM
> To: Brad Campbell
> Cc: Tom Eicher; linux-raid@vger.kernel.org
> Subject: Re: entire array lost when some blocks unreadable?
> 
> 
> 
> Brad Campbell wrote:
> 
> > Join the long line next to the club trophy cabinet :)
> 
> Its a shame the line is this long - I wish I had the time to implement
> the solution myself, but not having that I can't really whine either.
> Its still a shame though. Alas.
> 
> > Something along those lines.
> > Generally if I get an error notification from smartd I pull the drive
> > from the array and re-add it. This causes a rewrite of the entire disk
> > and everyone is happy. (Unless the drive is dying, in which case the
> > rewrite of the entire disk usually finishes it off nicely)
> 
> When I get one of those, the first thing I do is verify my backup :-).
> The backup is a second array that's on the network, so I typically
> remount it read-only at that point.
> 
> Then I start drive scans on all drives (primary and backup) to see if
> I've got any other blocks that will stop reconstruction. If I find any
> other bad blocks on other devices, I immediately remount the primary as
> read-only to preserve the data (if its not already gone) on all of the
> disks. Note my disks almost never get written to, so this actually does
> preserve the old data everywhere in all the cases I care about.
> 
> After that, a fail and re-add has done the trick for me in the past, but
> once I actually got remapped into a bad block. Very annoying. Since
> then, I fail the disk and do multiple badblocks passes on it.
> 
> Being able to enable an "aggressively correct" raid mode where any
> single-block read error triggered a reconstruct/write/re-read cycle
> until either it worked or failed would be nice. Bonus points for extra
> md status markers that mdadm could pick up and mail to folks depending
> on policy configuration.
> 
> -Mike
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


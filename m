From: Neil Brown <neilb@suse.de>
Subject: Re: linear writes to raid5
Date: Thu, 20 Apr 2006 09:44:57 +1000
Message-ID: <17478.52089.452739.896039@cse.unsw.edu.au>
References: <m37j60udi8.fsf@bzzz.home.net>
	<17465.43983.345817.253532@cse.unsw.edu.au>
	<m3y7ybrffe.fsf@bzzz.home.net>
	<17468.18087.901186.523228@cse.unsw.edu.au>
	<m3hd4yrdx3.fsf@bzzz.home.net>
	<17474.53696.831154.37427@cse.unsw.edu.au>
	<4444F7A8.7050304@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Tokarev on Tuesday April 18
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Alex Tomas <alex@clusterfs.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday April 18, mjt@tls.msk.ru wrote:
> Neil Brown wrote:
> []
> > raid5 shouldn't need to merge small requests into large requests.
> > That is what the 'elevator' or io_scheduler algorithms are for.  There
> > already merge multiple bio's into larger 'requests'.  If they aren't
> > doing that, then something needs to be fixed.
> > 
> > It is certainly possible that raid5 is doing something wrong that
> > makes merging harder - maybe sending bios in the wrong order, or
> > sending them with unfortunate timing.  And if that is the case it
> > certainly makes sense to fix it.  
> > But I really don't see that raid5 should be merging requests together
> > - that is for a lower-level to do.
> 
> Hmm.  So where's the elevator level - before raid level (between e.g.
> a filesystem and md), or after it (between md and physical devices)?

The elevator is immediately above the low-level device.  So it is
between md and the physical device.  There is no elevator above md.


> 
> I mean, mergeing bios into larger requests makes alot of sense between
> a filesystem and md levels, but it makes alot less sense to do that
> between md and physical (fsvo "physical" anyway) disks.

This seems completely backwards to me, so we must be thinking of
different things.

Creating large requests above the md level doesn't make a lot of sense
to me because there is a reasonable chance that md will just need to
break the requests up again to submit to different devices lower down.

Building large requests for the physical disk makes lots of sense
because you get much better throughput on an e.g. SCSI buss by having
few large requests rather than many small requests.  But this building
should be done close to the device so that as much information as
possible is available about particular device characteristics.

What is the rationale for your position?

NeilBrown

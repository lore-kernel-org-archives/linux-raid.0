From: Alex Tomas <alex@clusterfs.com>
Subject: Re: linear writes to raid5
Date: Wed, 19 Apr 2006 23:40:26 +0400
Message-ID: <m3ejzt4amt.fsf@bzzz.home.net>
References: <m37j60udi8.fsf@bzzz.home.net>
	<17465.43983.345817.253532@cse.unsw.edu.au>
	<m3y7ybrffe.fsf@bzzz.home.net>
	<17468.18087.901186.523228@cse.unsw.edu.au>
	<m3hd4yrdx3.fsf@bzzz.home.net>
	<17474.53696.831154.37427@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Alex Tomas <alex@clusterfs.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> Neil Brown (NB) writes:

 NB> raid5 shouldn't need to merge small requests into large requests.
 NB> That is what the 'elevator' or io_scheduler algorithms are for.  There
 NB> already merge multiple bio's into larger 'requests'.  If they aren't
 NB> doing that, then something needs to be fixed.

hmm. then why filesystems try to allocate big chunks and submit them
at once? what's the point to have bio subsystem?

 NB> It is certainly possible that raid5 is doing something wrong that
 NB> makes merging harder - maybe sending bios in the wrong order, or
 NB> sending them with unfortunate timing.  And if that is the case it
 NB> certainly makes sense to fix it.  
 NB> But I really don't see that raid5 should be merging requests together
 NB> - that is for a lower-level to do.

well, another thing is that it's extremly cheap to merge them in raid5
because we know request size and what stripes it covers. at same time
 block layer doesn't know that and need to _search_ where to merge to.

 NB> This implies 3millisecs have passed since the queue was plugged, which
 NB> is a long time.....
 NB> I guess what could be happening is that the queue is being unplugged
 NB> every 3msec whether it is really needed or not.
 NB> i.e. we plug the queue, more requests come, the stripes we plugged the
 NB> queue for get filled up and processes, but the timer never gets reset.
 NB> Maybe we need to find a way to call blk_remove_plug when there are no
 NB> stripes waiting for pre-read...

 NB> Alternately, stripes on the delayed queue could get a timestamp, and
 NB> only get removed if they are older than 3msec.  Then we would replug
 NB> the queue if there were some new stripes left....

could we somehow mark all stripes that belong to given incoming request
in make_request() and skip them in raid5_activate_delayed() ? after the
whole incoming request is processed, drop the mark.

thanks, Alex

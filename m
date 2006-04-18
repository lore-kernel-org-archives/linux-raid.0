From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: linear writes to raid5
Date: Tue, 18 Apr 2006 18:28:56 +0400
Message-ID: <4444F7A8.7050304@tls.msk.ru>
References: <m37j60udi8.fsf@bzzz.home.net>	<17465.43983.345817.253532@cse.unsw.edu.au>	<m3y7ybrffe.fsf@bzzz.home.net>	<17468.18087.901186.523228@cse.unsw.edu.au>	<m3hd4yrdx3.fsf@bzzz.home.net> <17474.53696.831154.37427@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17474.53696.831154.37427@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Alex Tomas <alex@clusterfs.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
[]
> raid5 shouldn't need to merge small requests into large requests.
> That is what the 'elevator' or io_scheduler algorithms are for.  There
> already merge multiple bio's into larger 'requests'.  If they aren't
> doing that, then something needs to be fixed.
> 
> It is certainly possible that raid5 is doing something wrong that
> makes merging harder - maybe sending bios in the wrong order, or
> sending them with unfortunate timing.  And if that is the case it
> certainly makes sense to fix it.  
> But I really don't see that raid5 should be merging requests together
> - that is for a lower-level to do.

Hmm.  So where's the elevator level - before raid level (between e.g.
a filesystem and md), or after it (between md and physical devices) ?

I mean, mergeing bios into larger requests makes alot of sense between
a filesystem and md levels, but it makes alot less sense to do that
between md and physical (fsvo "physical" anyway) disks.

Thanks.

/mjt


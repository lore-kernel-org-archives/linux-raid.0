From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Sat, 1 Mar 2003 13:36:30 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200303011236.h21CaUB19146@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: From "(env:" "ptb)" at "Feb 28, 2003 04:25:37 pm"
To: ptb@it.uc3m.es
Cc: Paul Clements <Paul.Clements@SteelEye.com>, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago ptb wrote:"
> I agree. I modified the bitmap so that when a page can't be got to make
> a mark on, then we count pending "writes" by summing one to a count
> for every attempted write to the zone covered by the missing page
> and subtracting one for every attempted clear.
> 
> The bitmap reports "dirty" if the count is positive and the page for
> that zone is absent.  I put the present code up at
> 
>   ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.6.tgz

And if anybody cares, I put up a fr1-2.7.tgz in which the bitmap also
has a page cache so that it has a bit of leeway when asking for pages to
put into the map.  I think I put lo/hi water mark at 2/7 by default.
That means it will preallocate 7 pages, and when 5 of those have been
used up it will ask for 5 more, and keep them ready.  But even if it
can't get 5 more it will still serve the 2 it has in reserve.

I still have to put in subzone pending-write counters (for 256KB
subzones) for when the page alloc fails completely.  At the moment the
pending-write counter is for a page, which is a whole 4MB zone ondisk.

When a page is completely cleared it disconnects itself from the bitmap
and puts itself in the page cache, unless the cache is already at
hiwater, when it will kfree itself instead.

But I did let the bitmap "heal itself".  If it tries to mark a page that
was unable to be allocated in the past (because of lack of memory) and
which now has no pending writes on it, then it will be attempted to be
re-alloced.  This may not be a good strategy - I can envisage that some
time needs to pass before retrying.

So, all in all, I guess things get more advanced. As usual when
architecture improves, I took out large snips of code.

Peter

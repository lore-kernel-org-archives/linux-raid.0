From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH md 0 of 4] Introduction
Date: Wed, 9 Mar 2005 16:37:04 +0100
Message-ID: <0qh3g2-vo4.ln1@news.it.uc3m.es>
References: <20050308165021.3745.patches@notabene> <6jj0g2-c27.ln1@news.it.uc3m.es> <422DDA99.60608@steeleye.com> <9k91g2-vss.ln1@news.it.uc3m.es> <16942.33924.232086.822210@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@cse.unsw.edu.au> wrote:
> On Tuesday March 8, ptb@lab.it.uc3m.es wrote:
> > Have you remodelled the md/raid1 make_request() fn?
> 
> Somewhat.  Write requests are queued, and raid1d submits them when
> it is happy that all bitmap updates have been done.

OK - so a slight modification of the kernel generic_make_request (I
haven't looked).  Mind you, I think that Paul said that just before
clearing bitmap entries, incoming requests were checked to see if a
bitmap entry should be marked again..

Perhaps both things happen. Bitmap pages in memory are updated as
clean after pending writes have finished and then marked as dirty as
necessary, and then flushed and when the flush finishes new accumulated
requests are started.

One can

> There is no '1/100th' second or anything like that.

I was trying in a way to give a definite image to what happens, rather
than speak abstractly. I'm sure that the ordinary kernel mechanism for
plugging and unplugging is used, as much as it is possible. If yu
unplug when the request struct reservoir is exhausted, then it will be
at 1K requests. If they are each 4KB, that will be every 4MB. At say
64MB/s, that will be every 1/16 s. And unplugging may happen more
frequently because of other kernel magic mumble mumble ...

> When a write request arrives, the queue is 'plugged', requests are
> queued, and bits in the in-memory bitmap are set.

OK.

> When the queue is unplugged (by the filesystem or timeout) the bitmap
> changes (if any) are flushed to disk, then the queued requests are
> submitted. 

That accumulates bitmap markings into the minimum number of extra
transactions.  It does impose extra latency, however.

I'm intrigued by exactly how you exert the memory pressure required to
force just the dirty bitmap pages out. I'll have to look it up.

> Bits on disk are cleaned lazily.

OK - so the disk bitmap state is always pessimistic. That's fine. Very
good.

> Note that for many applications, the bitmap does not need to be huge.
> 4K is enough for 1 bit per 2-3 megabytes on many large drives.
> Having to sync 3 meg when just one block might be out-of-sync may seem
> like a waste, but it is heaps better than syncing 100Gig!!

Yes - I used 1 bit per 1K, falling back to 1 bit per 2MB under memory
pressure.

> > And if so, do you also aggregate them? And what steps are taken to
> > preserve write ordering constraints (do some overlying file systems
> > still require these)?
> 
> filesystems have never had any write ordering constraints, except that
> IO must not be processed before it is requested, nor after it has been
> acknowledged.  md continue to obey these restraints.

Out of curiousity, is aggregation done on the queued requests? Or are
they all kept at 4KB? (or whatever - 1KB).

Thanks!

Peter


From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Sat, 19 Mar 2005 13:16:09 +0100
Message-ID: <9phtg2-6c1.ln1@news.it.uc3m.es>
References: <422F7621.8090602@steeleye.com> <16949.5768.392061.95882@cse.unsw.edu.au> <20050314094454.GK3858@marowsky-bree.de> <16949.26113.68948.938529@cse.unsw.edu.au> <20050314112403.GT3858@marowsky-bree.de> <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <20050318171608.GA28494@percy.comedia.it> <423B4C4B.7070404@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michael Tokarev <mjt@tls.msk.ru> wrote:
> Luca Berra wrote:
> > On Fri, Mar 18, 2005 at 02:42:55PM +0100, Lars Marowsky-Bree wrote:
> > 
> >> The problem is for multi-nodes, both sides have their own bitmap. When a
> >> split scenario occurs, and both sides begin modifying the data, that
> >> bitmap needs to be merged before resync, or else we risk 'forgetting'
> >> that one side dirtied a block.
> > 
> > on a side note i am wondering what would the difference be on using this
> > approach within the md driver versus DRBD?
> 
> DRBD is more suitable for the task IMHO.  Several points:
> 
> o For md, all drives are equal, that is, for example, raid1
>   code will balance reads among all the available drives a-la

Not necessarily so. At least part of the FR1 patch is dedicated to
timing the latencies of the disks, and choosing the fastest disk to
read from.

>   striping, while DRBD knows one mirror is remote and hence
>   will not try to read from it.  Well, todays GigE is fast,
>   but it is yet another layer between your data and the memory,
>   and we also have such a thing as latency.
> 
> o We all know how md "loves" to kick off "faulty" array components
>   after first I/O error, don't we?  DRBD allows "temporary" failures

Again, the FR1 patch contains the "Robust Read" subpatch, which stops
this happening. It's not a patch that intersects with the bitmap
functionality at all, by the way.

>   of remote component, and will recover automatically when the
>   remote comes back.

Well, so will FR1 (at least when run over ENBD, because FR1 contains
a machanism that allows the disks to tell it when they have come back
into their full gleam of health again).

> o DRBD allows local drive to be a bit ahead compared to remote one
>   (configurable), while md will wait for all drives to complete a write.

The FR1 patch allows asynchronous writes too.  This does need the
bitmap.  I presume Paul's latest patches to raid1 for 2.6.11 also add
that to kernel raid1.

Incidentally, async writes are a little risky. We can more easily
imagine a tricky recovery situation with them than without them!

> There's a case which is questionable in the first place: what to
> do if local part of the mirror fails?  Md will happily run on
> single remote component in degraded mode, while DRBD will probably
> fail...  Dunno which behaviour is "better" or "more correct"
> (depends on the usage scenario I think).

It's clearly correct to run on the remote if that's what you have.


Peter


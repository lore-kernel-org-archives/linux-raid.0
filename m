From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: RAID1 and data safety?
Date: Tue, 29 Mar 2005 20:43:02 +0200
Message-ID: <m6koh2-iaj.ln1@news.it.uc3m.es>
References: <76592C4D3DA1AC4FB8424084D10D31A80611527B@mchh2c4e.mchh.siemens.de> <16969.10547.894461.398225@cse.unsw.edu.au> <ipqnh2-o1n.ln1@news.it.uc3m.es> <20050329164645.GD2080@percy.comedia.it>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra <bluca@comedia.it> wrote:
> On Tue, Mar 29, 2005 at 01:29:22PM +0200, Peter T. Breuer wrote:
> >Neil Brown <neilb@cse.unsw.edu.au> wrote:
> >> Due to the system crash the data on hdb is completely ignored.  Data
> >
> >Neil - can you explain the algorithm that stamps the superblocks with
> >an event count, once and for all? (until further amendment :-).
> 
> IIRC it is updated at every event (start, stop, add, remove, fail etc...)

Hmm .. I see it updated sometimes twice and sometimes once between a
setfaulty and a hotadd (no writes between). There may be a race.

It's a bit of a problem because when I start a bitmap (which is when a
disk is faulted from the array), I copy the event count at that time to
the bitmap.  When the disk is re-inserted, I look at the event count on
its sb, and see that it may sometimes be one, sometimes two behind the
count on the bitmap.

And then sometimes the array event count jumps by ten or so.

Here's an example:

  md0: repairing old mirror component 300015 (disk 306 >= bitmap 294)

I had done exactly one write on the degraded array. And maybe a
setfaulty and a hotadd. The test cycle before that (exactly the same)
I got:

  md0: repairing old mirror component 300015 (disk 298 >= bitmap 294)

and at the very first separation (first test cycle) I saw

  md0: warning - new disk 300015 nearly too old for repair (disk 292 < bitmap 294)

(Yeah, these are my printk's - so what).

So it's all consistent with the idea that the event count is
incremented more frequently than you say.

Anyway, what you are saying is that if a crash occurs on the node with the
array, then the event counts on BOTH mirrors will be the same.  Thus
there is no way of knowing which is the more uptodate.

> >It goes without saying that sb's are not stamped at every write, and the
> >event count is not incremented at every write, so when and when?
> 
> the event count is not incremented at every write, but the dirty flag
> is, and it is cleared lazily after some idle time.
> in older code it was set at array start and cleared only at stop.

Hmmm. You mean this

   int                             sb_dirty;

in the mddev?  I don't think that's written out .. well, it may be, if
the whole sb is written, but that's very big. What exactly are you
referencing with "the dirty flag" above?

> so in case of a disk failure the other disks get updated about the
> failure.

Well, yes, but in the case of an array node crash ...

> in case of a restart (crash) the array will be dirty and a coin tossed
> to chose which mirror to use as an authoritative source (the coin is
> biased, but it doesn't matter). At this point any possible parallel
> reality is squashed out of existance.

It is my opinion that one ought always to roll back anything in the
journal (any journal) on a restart. On the grounds that you can't know
for sure if it went to the other mirror.

Would you like me to make a patch to make sure that writes go to all
mirrors or else error back t the user?  The only question in my mind is
how to turn such a policy on or off per array. Any suggestion? I'm not
familiar with most of mdadm's neer capabilities. I'd use the sysctl
interface, but it's not set up to be "per array". It should be.

Peter


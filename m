From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH 1/2] md bitmap bug fixes
Date: Mon, 21 Mar 2005 23:15:22 +0100
Message-ID: <qkt3h2-0u3.ln1@news.it.uc3m.es>
References: <16950.5692.594941.130741@cse.unsw.edu.au> <20050318103326.GA18819@marowsky-bree.de> <6ivqg2-qsn.ln1@news.it.uc3m.es> <20050318134255.GS18819@marowsky-bree.de> <7e6rg2-pj1.ln1@news.it.uc3m.es> <423B09EF.8070708@steeleye.com> <23krg2-4rr.ln1@news.it.uc3m.es> <423B2F7C.3030907@steeleye.com> <qehtg2-6c1.ln1@news.it.uc3m.es> <423EF12A.4030207@steeleye.com> <20050321185606.GA27541@percy.comedia.it> <423F2780.5000601@steeleye.com> <qbo3h2-kjo.ln1@news.it.uc3m.es> <423F3A69.5090502@steeleye.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements <paul.clements@steeleye.com> wrote:

OK - thanks for the reply, Paul ...

> Peter T. Breuer wrote:
> > But why don't we already know from the _single_ bitmap on the array
> > node ("the node with the array") what to rewrite in total? All writes
> > must go through the array. We know how many didn't go to both
> > components. Thus we know how many to rewrite from the survivor to the
> > component that we lost contact with.
> 
> I don't think we're talking about the same thing. I'm talking about this:
> 
> 1) you have an array set up on system A:
> 
>      system A
>      [raid1]
>      /     \
> [disk]    [nbd] --> system B
> 
> 2) you're writing, say, block 10 to the raid1 when A crashes (block 10 
> is dirty in the bitmap, and you don't know whether it got written to the 
> disk on A or B, neither, or both)

But who are WE? Assuming "we" are some network application running on
system A, either

  a) we got an ack from the raid and passed it on
  b) we got an ack from the raid but didn't pass it on
  c) we didn't get an ack from the raid and didn't pass it on

In case (a), we wrote both A and B.
In case (b), we wrote both A and B.
In case (c), we wrote A or B, neither or both.

Because bitmaps are cleared lazily, it's likely that one or both are
dirty in all cases.


> 
> 3) something (i.e., your cluster framework) notices that A is gone and 
> brings up a new raid1, with an empty bitmap, on system B:

Well, OK.  If you want to say that B is pure and unsullied by fiat,
that's OK.  You now start dirtying the bitmap for every write, so as to
track them for when you later want to sync them to A.

At this point clearly you may have received some writes that A did not
(because it crashed), and you need to write those blocks back to A
later too. And similarly A may have received some writes that B did
not, and one may have to "undo" them later. So it looks like one should
RETAIN the bitmap on B, not zero it, in order to "unwrite" blcks on A
that were written, but we never got the writes for.

>      system B
>      [raid1]
>      /     \
> [disk]    missing (eventually will connect back to system A)
> 
> 4) some things get written to the raid1 on system B (i.e., the bitmap is 
> dirty)
> 
> 5) system A comes back and we now want to get the two systems back in sync
> 
> In this scenario, there are two bitmaps that must be consulted in order 
> to sync the proper blocks back to system A. Without bitmaps (or the 
> ability to combine the bitmaps), you must do a full resync from B to A.

Yes, but the analysis is not exact enough to show what should be done.

For example, see the suggeston above that B shoudl NOT start with a
empty bitmap, but should instead remember which blocks it never
received (if any!  or if it knows) in order that it can "unwrite" those
blocks on A later, in case A did receive them.

And I would say that when A receives its write (which would normally
clear its bitmap) it should tell B, so that B only clears its bitmap
when BOTH it and A have done their writes.

And vice versa.

Uh, that means we should store write-ids for a while so that we can
communicate properly .. these can be request addresses, no?

This strategy means that both A and B have pessimistic bitmaps for both
of the pair. Either one will do as a resync map.



Peter


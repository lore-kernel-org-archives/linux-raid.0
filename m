From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: Fast (intelligent) raid1
Date: Tue, 11 Feb 2003 20:47:04 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302111947.h1BJl4j25128@oboe.it.uc3m.es>
References: <Pine.LNX.4.44.0301240354520.3568-100000@devserv.devel.redhat.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0301240354520.3568-100000@devserv.devel.redhat.com>
 from Ingo Molnar at "Jan 24, 2003 04:03:40 am"
To: Ingo Molnar <mingo@redhat.com>
Cc: "Peter T. Breuer" <ptb@it.uc3m.es>, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago Ingo Molnar wrote:"
> [ptb wrote]
> > The driver keeps a bitmap of pending writes in memory, and writes them
> > to the mirror component that's just been repaired when it comes back on
> > line.  The bitmap is two-level and created pagewise on demand, so it's
> > not too expensive. [...]
> 
> how do you ensure that the 'repaired' drive indeed only differs in the
> dirty-bitmap portions of the data disk? It's perfectly valid to add a
> completely new (and unsynced) disk to the system when one disk fails. Or
> is this the responsibility of the administrator?

I've  now built the technology into the kernel raid1 code. It's
available from

   ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.0.tgz

list:
   fr1-2.0/src/Makefile
   fr1-2.0/patches/linux-2.4.20-xfs.patch
   fr1-2.0/patches/linux-2.4.19-xfs.patch
   fr1-2.0/patches/linux-2.4.generic.patch
   fr1-2.0/LICENCE
   fr1-2.0/Makefile
   fr1-2.0/README

The patch modifies md.c in order to allow hotadd directly after
setfaulty (which I count as a "hotrepair").  It does this by
detecting the attempt to hotadd a faulty disk, and doing a hotremove
first, after saving the metadata.

It also modifies raid1.c. It makes the resync skip blocks that are not
marked in the bitmap, if there is a bitmap. It makes ordinary writes
mark the bitmap of every mirror component that is currently not
operational. On being marked bad, the bitmap is created for the
component. On being marked active (i.e. after a resync) the bitmap
is taken away.

Then it combines raid1.c with the support in bitmap.c to form a new
module, fr1.o, which replaces raid1.o.

I would be grateful for corrections. I would like it if a "hotrepair"
could be detected automatically from the disk component uuid. I would
also like it if the bitmap could be marked clean block by block in the
raid1_end_io. Well, maybe I could do that - I haven't so far. The
bitmap is vamooshed when the sync is complete, presently. I think
that's the same since I don't think the resync starts from zero if
interrupted and resumed.

Peter

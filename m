From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Fri, 28 Feb 2003 16:25:37 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302281525.h1SFPbs32224@oboe.it.uc3m.es>
References: <3E5E41FE.B3E434D3@SteelEye.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E5E41FE.B3E434D3@SteelEye.com> from Paul Clements at "Feb 27,
 2003 11:51:10 am"
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: ptb@it.uc3m.es, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Paul Clements wrote:"
> That's OK, we don't need to know. We really just want to know if there
> are any outstanding writes for that chunk. We increment the chunk
> counter for every write and decrement it when the write finishes. Now,

I agree. I modified the bitmap so that when a page can't be got to make
a mark on, then we count pending "writes" by summing one to a count
for every attempted write to the zone covered by the missing page
and subtracting one for every attempted clear.

The bitmap reports "dirty" if the count is positive and the page for
that zone is absent.  I put the present code up at

  ftp://oboe.it.uc3m.es/pub/Programs/fr1-2.6.tgz


I spent much of the morning checking that mark and clear attempts
are balanced unless the write does not succeed. They are. This means
that under memory pressure the bitmap not only fails only by losing
precision (it did before), but now it can lose less precision, dropping
to 256K instead of 4M precision,  although I haven't implemented the
final change to up the precision just yet. I made all the preparatory
moves.   Since it's friday I'll publish what I have.

Under normal circumstances the count for each zone of the bitmap
records the number of dirty bits. It's used to help free the bitmap 
pages at the right time, to stop pages accumulating to the max.
Shucks ..  I have to put them on a free list. I'll do that later too.

Peter

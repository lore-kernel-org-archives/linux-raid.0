From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Thu, 27 Feb 2003 11:51:10 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E5E41FE.B3E434D3@SteelEye.com>
References: <200302271035.h1RAZ9A26165@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer" wrote:
 
> "Paul Clements wrote:"
> > > 3/ Internally, you need to store a counter for each 'chunk' (need a
> > mechanism for tracking multiple pending writes to the same 'chunk'. One

> We cannot account for how many bits are really dirty in this chunk. 

That's OK, we don't need to know. We really just want to know if there
are any outstanding writes for that chunk. We increment the chunk
counter for every write and decrement it when the write finishes. Now,
if the backup device fails, we'll bring it back online at some point and
do a (partial) resync, using the bitmap as a guide. For every chunk, if
the counter is non-zero, we have to do a full resync of every block in
that chunk. We then set the counter back to 0 only after we're done
resyncing the last block in that chunk.

So we really don't care how many blocks are dirty, just that there are
or are not dirty blocks in the chunk. Does that make sense?

--
Paul

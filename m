From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Fri, 28 Feb 2003 11:14:37 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E5F8AED.82D3B484@SteelEye.com>
References: <200302281525.h1SFPbs32224@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer" wrote:
> 
> "Paul Clements wrote:"
> > That's OK, we don't need to know. We really just want to know if there
> > are any outstanding writes for that chunk. We increment the chunk
> > counter for every write and decrement it when the write finishes. Now,
> 
> I agree. I modified the bitmap so that when a page can't be got to make
> a mark on, then we count pending "writes" by summing one to a count
> for every attempted write to the zone covered by the missing page
> and subtracting one for every attempted clear.

That sounds good. I'll have to merge up to 2.6...ugh...now I really need
to put this all in CVS...I'm making some progress with the mmap stuff
and I've got the code done for duplicating the buffers for the async
writes to the backup devices.
I'll need a pool of memory for that too, since I can't just fail in the
middle of I/O...

--
Paul

From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Wed, 26 Feb 2003 13:29:32 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E5D078C.72A523AE@SteelEye.com>
References: <200302261726.h1QHQjS07452@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer" wrote:
> "Paul Clements wrote:"

> > BTW, I'm working on the code to duplicate the bh (and its memory buffer)
> > right now. It's basically coded, but not tested. I've based it off your
> > 2.5 code. I'm also working on a simple queueing mechanism (to queue
> > write requests to backup devices). This will allow us to adjust the bit
> > to block ratio of the bitmap (intent log) to save disk space and memory.
> 
> Don't worry about that - that's not necessary, I think.  The bitmap is
> already lazy on creating pages for itself.  But yes, it needs to
> maintain a count of dirty bits per bitmap page, and when the count drops
> to zero it needs to free the page.  I can do that if you like?

Yes, the on-demand page freeing sounds like a good idea. If you don't
have that, I think the bitmap eventually grows to maximum size over
time...

As far as the bit to block ratio, some numbers:

1 bit/64kb @ 1TB ->   2MB maximum bitmap size

1 bit/512b @ 1TB -> 250MB maximum bitmap size

So, I think that if we want to be sure that this will scale, we'll want
the bit to block ratio to be adjustable. Another benefit of having a
large bitmap block size is that it limits the frequency of the disk
writes required to sync the bitmap to disk (1 sync per 128 sectors
written vs. 1 per sector, in the example above).

--
Paul

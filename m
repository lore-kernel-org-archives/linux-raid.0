From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Thu, 27 Feb 2003 09:48:48 +0100 (MET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200302270848.h1R8mmN14809@oboe.it.uc3m.es>
References: <3E5DBD88.2F0C8D87@SteelEye.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E5DBD88.2F0C8D87@SteelEye.com> from Paul Clements at "Feb 27,
 2003 02:26:00 am"
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: ptb@it.uc3m.es, Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Paul Clements wrote:"
> "Peter T. Breuer" wrote:
> > Curiously enough, I'm slightly more nonplussed by the problem of
> > kfreeing the bitmap pages when their dirty count drops to zero.

> > What should I do? Maintain a how-many-times-we-have-wanted-to-free-this
> > page count and only free it on the 10th attempt?
> 
> hmm...perhaps an LRU approach? you could store a timestamp (jiffies?),
> so that you never deallocate a page unless it hasn't been used in X
> amount of time...might be too heavyweight for what you're trying to do

This is not silly, but is too heavyweight to do each time a bit is set.

The best thing to do is probably either or both of

   a) put the notionally freed pages on a free list and allocate from
      that list first when we want a new page

   b) do a periodic sweep for clean pages and free them. 

Peter

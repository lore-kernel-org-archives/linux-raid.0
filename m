From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Thu, 27 Feb 2003 10:47:29 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E5E3311.C202A939@SteelEye.com>
References: <200302270848.h1R8mmN14809@oboe.it.uc3m.es>
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
> > "Peter T. Breuer" wrote:
> > > Curiously enough, I'm slightly more nonplussed by the problem of
> > > kfreeing the bitmap pages when their dirty count drops to zero.
> 
> > > What should I do? Maintain a how-many-times-we-have-wanted-to-free-this
> > > page count and only free it on the 10th attempt?
> >
> > hmm...perhaps an LRU approach? you could store a timestamp (jiffies?),
> > so that you never deallocate a page unless it hasn't been used in X
> > amount of time...might be too heavyweight for what you're trying to do
> 
> This is not silly, but is too heavyweight to do each time a bit is set.

Yeah, I was thinking of things like an ext3 journal, where you really do
not want to _ever_ free the pages. With a simple counter, I don't think
there's any way to get that type of behavior.

Of course, if you keep a pool of pre-allocated pages, the penalty for
deallocation/reallocation becomes a lot lower.

--
Paul

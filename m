From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: raid1 bitmap code [Was: Re: Questions answered by Neil Brown]
Date: Thu, 27 Feb 2003 02:26:00 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E5DBD88.2F0C8D87@SteelEye.com>
References: <200302262324.h1QNOu711769@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer" wrote:
 
> Curiously enough, I'm slightly more nonplussed by the problem of
> kfreeing the bitmap pages when their dirty count drops to zero.
> I can foresee that when journalling we will go 0 1 0 1 0 1 in terms
> of number of bits dirty in the map, and if we kfree after the
> count drops to zero each time, and kmalloc when we should set
> the count to 1, then we will be held up. And maybe sleep when we
> shouldn't - the bitmap lock is held for some ops. Needs checking.
> 
> What should I do? Maintain a how-many-times-we-have-wanted-to-free-this
> page count and only free it on the 10th attempt?

hmm...perhaps an LRU approach? you could store a timestamp (jiffies?),
so that you never deallocate a page unless it hasn't been used in X
amount of time...might be too heavyweight for what you're trying to do

--
Paul

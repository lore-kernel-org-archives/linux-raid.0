From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: calc. of currspeed in md.c code in 2.4.20
Date: Wed, 14 May 2003 15:54:25 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305141354.h4EDsPS15052@oboe.it.uc3m.es>
References: <3EC24926.1D33CAAB@SteelEye.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EC24926.1D33CAAB@SteelEye.com> from Paul Clements at "May 14,
 2003 09:48:22 am"
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: ptb@it.uc3m.es, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago Paul Clements wrote:"
> "Peter T. Breuer" wrote:
> > 
> > Can you shed some light on this for me?
> > 
> > currspeed =
> >  (j-mddev->resync_mark_cnt)/2/((jiffies-mddev->resync_mark)/HZ +1) +1;
> > 
> > jiffies is divided by HZ here, which results in a quantity of dimension
> > time-squared!
> > 
> > I could understand it (better) if jiffies were multiplied by HZ.
> 
> Just curious, but are you looking at this because the speed calculations
> break when using a bitmap to resync? I realized this problem a few days

Exactly so.

> ago, but I'm not sure how to solve it, yet...

Pushing speed_min up is a workaround.

> I think we might need two counters, one for the actual resync progress
> (to display the progress bar, and show actual resync speed) and the
> other to throttle I/O if actual I/O becomes too fast...

Possibly.  There are a large number of possible solutions, but until
I can understand what the speed calculation is supposed to be doing, I
find myself unable to pick out a way forward.


Peter

From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: calc. of currspeed in md.c code in 2.4.20
Date: Wed, 14 May 2003 16:18:20 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305141418.h4EEIK117980@oboe.it.uc3m.es>
References: <200305141354.h4EDsPS15052@oboe.it.uc3m.es>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200305141354.h4EDsPS15052@oboe.it.uc3m.es> from "Peter T. Breuer"
 at "May 14, 2003 03:54:25 pm"
To: ptb@it.uc3m.es
Cc: Paul Clements <Paul.Clements@SteelEye.com>, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer wrote:"
> > ago, but I'm not sure how to solve it, yet...
> 
> Pushing speed_min up is a workaround.

Correct me if this seems silly, but we could push speed_min up to equal
speed_max (or close) in the intervals in which the resync is skipping
sectors rather than syncing them. It does know.

Then nobody would have to change the (to me inscrutable) speed
calculation and throttling loop.

OTOH it would be nicer to have limits per device.

> > I think we might need two counters, one for the actual resync progress
> > (to display the progress bar, and show actual resync speed) and the
> > other to throttle I/O if actual I/O becomes too fast...


Peter

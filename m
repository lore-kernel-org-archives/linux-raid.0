From: "Peter T. Breuer" <ptb@it.uc3m.es>
Subject: Re: calc. of currspeed in md.c code in 2.4.20
Date: Wed, 14 May 2003 16:53:08 +0200 (MET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305141453.h4EEr8Z21829@oboe.it.uc3m.es>
References: <3EC2558D.7770021F@SteelEye.com>
Reply-To: ptb@it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EC2558D.7770021F@SteelEye.com> from Paul Clements at "May 14,
 2003 10:41:17 am"
To: Paul Clements <Paul.Clements@SteelEye.com>
Cc: ptb@it.uc3m.es, neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"A month of sundays ago Paul Clements wrote:"
> "Peter T. Breuer" wrote:
>  
> > Correct me if this seems silly, but we could push speed_min up to equal
> > speed_max (or close) in the intervals in which the resync is skipping
> > sectors rather than syncing them. It does know.
> 
> But as soon as it hits the disk again, it's going to go to sleep,
> because the resync speed up to that point (when there was no real I/O)
> will be so high that it'll be way over the limits.

It'll be over the (newly set back to normal) minimum, but not over the
maximum. I don't have the code in sight at the moment ... doesn't it
use the max as a highwater mark, then?

Anyway, one could take the min back down to normal slowly.  Halving the
difference every group of sectors resynced might be OK.

Peter

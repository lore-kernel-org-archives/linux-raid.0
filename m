From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: calc. of currspeed in md.c code in 2.4.20
Date: Wed, 14 May 2003 10:41:17 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EC2558D.7770021F@SteelEye.com>
References: <200305141418.h4EEIK117980@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es
Cc: neilb@cse.unsw.edu.au, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer" wrote:
 
> Correct me if this seems silly, but we could push speed_min up to equal
> speed_max (or close) in the intervals in which the resync is skipping
> sectors rather than syncing them. It does know.

But as soon as it hits the disk again, it's going to go to sleep,
because the resync speed up to that point (when there was no real I/O)
will be so high that it'll be way over the limits.

--
Paul

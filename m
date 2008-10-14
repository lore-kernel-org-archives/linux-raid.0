From: Neil Brown <neilb@suse.de>
Subject: Re: Distributed spares
Date: Tue, 14 Oct 2008 21:04:25 +1100
Message-ID: <18676.28329.93345.30205@notabene.brown>
References: <48F3C2A1.3080607@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Monday October 13
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Monday October 13, davidsen@tmr.com wrote:
> Over a year ago I mentioned RAID-5e, a RAID-5 with the spare(s) 
> distributed over multiple drives. This has come up again, so I thought 
> I'd just mention why, and what advantages it offers.
> 
> By spreading the spare over multiple drives the head motion of normal 
> access is spread over one (or several) more drives. This reduces seeks, 
> improves performance, etc. The benefit reduces as the number of drives 
> in the array gets larger, obviously with four drives using only three 
> for normal operation is slower than four, etc. And by using all the 
> drives all the time, the chance of a spare being undetected after going 
> bad is reduced.
> 
> This becomes important as array drive counts shrink. Lower cost for 
> drives ($100/TB!), and attempts to drop power use by using fewer drives, 
> result in an overall drop in drive count, important in serious applications.
> 
> All that said, I would really like to bring this up one more time, even 
> if the answer is "no interest."

How are your coding skills?

The tricky bit is encoding the new state.
We can not longer tell the difference between "optimal" and "degraded"
based on the number of in-sync devices.  We also need some state flag
to say that the "distributed spare" has been constructed. 
Maybe that could be encoded in the "layout".

We would also need to allow a "recovery" pass to happen without having
actually added any spares, or having any non-insync devices.  That
probably means passing the decision "is a recovery pending" down into
the personality rather than making it in common code.  Maybe have some
field in the mddev structure which the personality sets if a recovery
is worth trying.  Or maybe just try it anyway after any significant
change and if the personality finds nothing can be done it aborts.

I'm happy to advise on, review, and eventually accept patches.

NeilBrown

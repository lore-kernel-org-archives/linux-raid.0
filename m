From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: PROBLEM: Kernel 2.6.10 crashing repeatedly and hard
Date: Thu, 30 Dec 2004 19:31:40 +0100
Message-ID: <c5uda2-7sr.ln1@news.it.uc3m.es>
References: <m3is6k4oeu.fsf@reason.gnu-hamburg> <m38y7fn4ay.fsf@reason.gnu-hamburg> <v3rda2-hjn.ln1@news.it.uc3m.es> <20041230175319.GA2448@bluff>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

In gmane.linux.raid Sandro Dentella <sandro@e-den.it> wrote:
> > Yes, well, don't put the journal on the raid partition. Put it
> > elsewhere (anyway, journalling and raid do not mix, as write ordering
> > is not - deliberately - preserved in raid, as far as I can tell).
> 
> ???, do you mean it? which filesystem would you use for a 2TB RAID5 array? I

Whatever one you are using now. Just turn off journalling, or at least move
the journal somewhere else (and safe!).

Or perhaps use metadata-only journalling (but reiser does that by
default, does it not?). That should keep you happy.

> always used reiserfs for raid1/raid5 arrays...

Peter


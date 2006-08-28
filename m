From: linux@horizon.com
Subject: Re: Interesting RAID checking observations
Date: 28 Aug 2006 09:15:52 -0400
Message-ID: <20060828131552.5776.qmail@science.horizon.com>
References: <17650.16675.561765.886119@cse.unsw.edu.au>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17650.16675.561765.886119@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com, neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I don't think the processor is saturating.  I've seen reports of this
> sort of thing before and until recently had no idea what was happening,
> couldn't reproduce it, and couldn't think of any more useful data to
> collect.

Well I can reproduce it easily enough.  It's a production server, but
I can do low-risk experiments after hours.

I'd like to note that the symptoms include not even being
able to *type* at the console, which I thought was all in-kernel
code, not subject to being swapped out.  But whatever.

> I'm not sure exactly how that translates into the machine being
> unresponsive, but it wouldn't surprise me.  I'll try to post a patch
> for that to linux-raid in a soonish.

I look forward to testing it!

> How much RAM does this system have?

1 GB (ECC).  133 MHz SDR SDRAM.

> Again, you aren't the first to report this.  I haven't seen it myself,
> but my regular test machine is busy at the moment.  I'll try to
> organise some testing soon.

I can do a fair bit of experimentation with this machine, as long as I
don't lose the data that's on it.

> Thanks for the reports.

Thanks for the response!  Sorry to be a pain.

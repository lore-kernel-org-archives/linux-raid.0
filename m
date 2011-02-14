From: Andras Korn <korn@raidlist.elan.rulez.org>
Subject: Re: write-behind has no measurable effect?
Date: Mon, 14 Feb 2011 23:57:54 +0100
Message-ID: <20110214225754.GK19990@hellgate.intra.guy>
References: <20110214213817.GG836@hellgate.intra.guy>
 <20110215095042.51ef7e0a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110215095042.51ef7e0a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 15, 2011 at 09:50:42AM +1100, NeilBrown wrote:

> > I experimented a bit with write-mostly and write-behind and found that
> > write-mostly provides a very significant benefit (see below) but
> > write-behind seems to have no effect whatsoever.
> 
> The use-case where write-behind can be expected to have an effect is when the
> throughput is low enough to be well within the capacity of all devices, but
> the latency of the write-behind device is higher than desired.
> write-behind will allow that high latency to be hidden (as long as the
> throughput limit is not exceeded).
> 
> I suspect your tests did not test for low latency in a low-throughput
> scenario.

I thought they did. "High latency" was, in my case, caused by the high seek
times (compared to the SSD) of the spinning disks. Throughput-wise, they
certainly could have kept up (their sequential read/write performance even
exceeds that of the SSD).

But maybe I misunderstand how write-behind works. I thought/hoped it would
commit writes to the fast drive(s) and mark affected areas dirty in the
intent map, then lazily sync the dirty areas over to the slow disk(s).

What does it actually do? md(4) isn't very forthcoming, and the wiki has no
relevant hits either.

Thanks.

-- 
                     Andras Korn <korn at elan.rulez.org>
                  Baroque: (def.) When you are out of Monet.

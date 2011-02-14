From: NeilBrown <neilb@suse.de>
Subject: Re: write-behind has no measurable effect?
Date: Tue, 15 Feb 2011 09:50:42 +1100
Message-ID: <20110215095042.51ef7e0a@notabene.brown>
References: <20110214213817.GG836@hellgate.intra.guy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110214213817.GG836@hellgate.intra.guy>
Sender: linux-raid-owner@vger.kernel.org
To: Andras Korn <korn@raidlist.elan.rulez.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 14 Feb 2011 22:38:17 +0100 Andras Korn <korn@raidlist.elan.rulez.org>
wrote:

> Hi,
> 
> I experimented a bit with write-mostly and write-behind and found that
> write-mostly provides a very significant benefit (see below) but
> write-behind seems to have no effect whatsoever.

The use-case where write-behind can be expected to have an effect is when the
throughput is low enough to be well within the capacity of all devices, but
the latency of the write-behind device is higher than desired.
write-behind will allow that high latency to be hidden (as long as the
throughput limit is not exceeded).

I suspect your tests did not test for low latency in a low-throughput
scenario.

NeilBrown

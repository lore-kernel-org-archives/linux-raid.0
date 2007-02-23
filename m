From: Neil Brown <neilb@suse.de>
Subject: Re: Reshaping raid0/10
Date: Sat, 24 Feb 2007 07:17:12 +1100
Message-ID: <17887.19400.179239.281711@notabene.brown>
References: <Pine.LNX.4.61.0702211726500.12039@yvahk01.tjqt.qr>
	<17884.42154.248251.261955@notabene.brown>
	<Pine.LNX.4.61.0702231357420.9736@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jan Engelhardt on Friday February 23
Sender: linux-raid-owner@vger.kernel.org
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 23, jengelh@linux01.gwdg.de wrote:
> 
> On Feb 22 2007 06:59, Neil Brown wrote:
> >On Wednesday February 21, jengelh@linux01.gwdg.de wrote:
> >> 
> >> are there any plans to support reshaping
> >> on raid0 and raid10?
> >> 
> >
> >No concrete plans.  It largely depends on time and motivation.
> >I expect that the various flavours of raid5/raid6 reshape will come
> >first.
> >Then probably converting raid0->raid5.
> >
> >I really haven't given any thought to how you might reshape a
> >raid10...
> 
> It should not be any different from raid0/raid5 reshaping, should it?

Depends on what level you look at.

If I wanted to reshape a raid0, I would just morph it into a raid4
with a missing parity drive, then use the raid5 code to restripe it.
Then morph it back to regular raid0.

With raid10 I cannot do that.  I would need to do the restriping
inside the raid10 module.  But raid10 doesn't have a stripe-cache like
raid5 does, and the stripe cache is a very integral part of the
restripe process.

So there would be a substantial amount of design and coding to effect
a raid10 reshape - at least as much as the work to produce the initial
raid5 reshape and probably more.

So conceptually it might be very similar, but at the code level, it is
likely to be very different.

NeilBrown

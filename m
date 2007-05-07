From: Neil Brown <neilb@suse.de>
Subject: Re: Raid1 replaced with raid10?
Date: Mon, 7 May 2007 14:15:26 +1000
Message-ID: <17982.42974.461499.127486@notabene.brown>
References: <45FF1BDF.6060304@rabbit.us>
	<463B2D15.7020305@rabbit.us>
	<463B4C4F.9030504@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Friday May 4
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Peter Rabbitson <rabbit@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 4, davidsen@tmr.com wrote:
> Peter Rabbitson wrote:
> > Hi,
> >
> > I asked this question back in march but received no answers, so here it
> > goes again. Is it safe to replace raid1 with raid10 where the amount of
> > disks is equal to the amount of far/near/offset copies? I understand it
> > has the downside of not being a bit-by-bit mirror of a plain filesystem.
> > Are there any other caveats?
> >   
> Clearly you have reduced capacity, since there's a mirror AND a CRC, 
> otherwise I don't see any drawbacks. The performance should be much better.

CRC ??? md/raid10 doesn't have any CRC.
What CRC are you thinking of?

To answer the original question, I assume you mean "replace" as in
"backup, create new array, then restore".
You will get different performance characteristics.  Whether they
better suit your needs or not will depend largely on your needs.

NeilBrown

From: Nick Maynard <nick.maynard@alumni.doc.ic.ac.uk>
Subject: Re: HighPoint Rocket 1540 hang driver load (Was: Re: Which raid card to buy for Sarge)
Date: Wed, 21 Apr 2004 16:24:38 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1082561078.40869236f3c14@www.tastycake.net>
References: <40865AEC.8040604@online.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40865AEC.8040604@online.no>
To: Lars Gaarden <lar-gaar@online.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks all for your replies.

After having tried near everything (RocketRAID OSS driver with NON_RAID=1 (and a
Makefile adjustment for brain errors from Highpoint) ), I still get the hangs
you guys are talking about.  Not to mention hardware conflicts with my ancient
mobo with onboard HPT366.

I've come to the conclusion that the Rocket 1540 is quite frankly a useless
card, and to get it to work with 2.6.x is probably asking too much.  I've
managed to RMA the Rocket 1540 card, and I'm buying a Promise SATA150 TX4.

So to repeat for future reference by the list, Rocket 1540 on Linux (esp 2.6) is
a nono.  Buy a Promise card.

--

Nick Maynard
nick.maynard@alumni.doc.ic.ac.uk

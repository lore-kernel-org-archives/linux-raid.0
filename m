From: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Subject: Re: potentially lost largeish raid5 array..
Date: Sat, 24 Sep 2011 11:53:02 -0600
Message-ID: <201109241153.02753.tfjellstrom@shaw.ca>
References: <201109221950.36910.tfjellstrom@shaw.ca> <201109231022.59437.tfjellstrom@shaw.ca> <alpine.DEB.2.00.1109240758350.13829@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1109240758350.13829@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On September 23, 2011, Mikael Abrahamsson wrote:
> On Fri, 23 Sep 2011, Thomas Fjellstrom wrote:
> >> Card:    SuperMicro AOC-SASLP-MV8            Marvell 88SE6480
> >> Driver:  MVSAS
> > 
> > *DING**DING**DING**DING**DING*
> > 
> > We have a winner! It's a very nice card when it works.
> 
> I have one of these, it's in the drawer. As late as 2.6.38 it worked
> marginally, before that it wouldn't even survive a raid resync. Sell it
> and buy something else. As far as I can tell there is nothing wrong with
> the hardware in this card, it just so happens the driver support is...
> err... lacking.

For the most part, it works. I've only had a couple scary moments with it. The 
funny thing is, it seems as the driver gets closer to working properly, it 
gets more dangerous. Before it'd just lock up the entire card, and thus, the 
file system was mostly clean, just needed to replay the log. Now instead of 
locking up the entire card, the ports return IO errors, which is kinda worse.

2.6.38-2.6.39 were pretty decent. Before that I was using a hacked up version 
of a 1-2 year old set of patches from someone I assume works/worked at 
Marvell. The only problem with that version of the driver was potential OOPSs 
on hot swap, and very odd pauses in IO.

-- 
Thomas Fjellstrom
tfjellstrom@shaw.ca

From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: potentially lost largeish raid5 array..
Date: Sat, 24 Sep 2011 07:59:59 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1109240758350.13829@uplift.swm.pp.se>
References: <201109221950.36910.tfjellstrom@shaw.ca> <201109222310.28684.tfjellstrom@shaw.ca> <4E7C81E0.1040707@hardwarefreak.com> <201109231022.59437.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201109231022.59437.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 23 Sep 2011, Thomas Fjellstrom wrote:

>> Card:    SuperMicro AOC-SASLP-MV8            Marvell 88SE6480
>> Driver:  MVSAS
>
> *DING**DING**DING**DING**DING*
>
> We have a winner! It's a very nice card when it works.

I have one of these, it's in the drawer. As late as 2.6.38 it worked 
marginally, before that it wouldn't even survive a raid resync. Sell it 
and buy something else. As far as I can tell there is nothing wrong with 
the hardware in this card, it just so happens the driver support is... 
err... lacking.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

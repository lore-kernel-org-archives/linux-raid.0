From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Accelerating Linux software raid
Date: Sun, 11 Sep 2005 16:19:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0509111608210.29141-100000@coffee.psychology.mcmaster.ca>
References: <43241C76.4030900@emc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43241C76.4030900@emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >1) If you have an infinite power budget (big box), you might as well
> >   let the main cpus do the raid stuff. If you are short on power (embedded),
> >   you cannot afford to power an extra processor (+memory and stuff).
> >
> >2) If you have rich customers (big box), let them pay for a bigger
> >   main cpu to do the raid, if you want to be cheap (embedded, appliance),
> >   you cannot afford to plop an extra cpu (+support chips) on your custom pcb.
> >
> The actual facts don't support this view since the gap in power 
> consumption is huge. Most of these system on a chip designs provide the 
> main CPU/northbridge/southbridge and extra execution units for a small 
> fraction of one standard CPU.  Say under 20  watts for all of the above 
> versus up to (over sometimes) 100 watts for a standard CPU (without its 
> system chip sets).

we appear to be talking about different things.  the original suggestion
was for appliances like tivo, which clearly have a limited power budget,
but certainly > 20W.  I responded by suggesting that current mainstream
mobile CPUs (like mobile athlon64's) have PLENTY of power to run MD - 
in fact, more than an appliance could possibly have any need for.
and they dissipate 20-30W.

then the topic somehow mutated into SoC designs, such as Intel's,
which are actually intended to *be* the raid card, and have an ARM 
core peaking at 600 MHz, and probably are challenged to sustain even
100 MB/s.  (in spite of bragging about a multi-GB/s internal bus.)

in other words, there's a third category: OEM customers who want to build
a smart raid card that consists of a SoC running linux actually implementing
the raid.  the main technical impediment is that Intel's solution has
XOR and DMA engines to make up for the wimpy CPU, but those engines are 
barely profitable with 4k block sizes.  since MD does XOR's in 4k chunks,
some hacking would be necessary to expand this size.  I expect this would 
have some modest benefit for systems other than the Intel SoC.  (but I 
question the sanity of the Intel approach in the first place, since I believe
the trend in storage is away from this kind of integration.  obviously,
it also doesn't make much sense for linux hosts, but such a card would
probably find more of a market in the windows world.)

regards, mark hahn.


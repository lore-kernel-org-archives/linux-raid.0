From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Which raid card to buy for Sarge
Date: Wed, 31 Mar 2004 14:50:34 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0403311442520.31572-100000@coffee.psychology.mcmaster.ca>
References: <200403312003.41762.ralph@debianbase.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200403312003.41762.ralph@debianbase.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> If would not use the "raid" feature of the Highpoint cards, because it is only 
> software raid and not so performant as a hardware raid. If you don't need a 

please don't say things like this.  HW raid is *NOT* generally
faster or better than software raid.  yes, if you're building a 
quad-gigabit fileserver out of an old P5/100 you had sitting around,
you're not even going to start looking at sw raid.

but for a normal FS config (dual opteron or xeon, >1GB ram,
2-400 MB/s sustained disk throughput), software raid is The Right Choice.

- speed: it's easy to do hundreds of MB/s with sw raid.  it's surprisingly hard
to break even 100 MB/s using sw raid.

- you don't pay through the nose for a crappy embedded processor
to do your parity calculations

- hw raid *does* reduce the amount of PCI-X traffic you generate,
but do you really care, at 1 GB/s?

- sw raid *does* consume some host CPU cycles, but do you care,
given that this is a fileserver?

- give me mdadm and normal userspace tools over some wheel-reinventing
hw raid configurator.

- you've probably got the hardware to fix an exploded sw-raid server
already in your office (other computers, normal disk controllers, etc).
replacing that hw raid card WILL take more than 30 minutes, obviously will
take money, and will eventually become impossible.


From: Christopher Smith <csmith@nighthawkrad.net>
Subject: Re: Problems with multiple Promise SATA150 TX4 cards
Date: Thu, 26 Jan 2006 11:26:56 +1100
Message-ID: <43D81750.3060405@nighthawkrad.net>
References: <Pine.LNX.4.44.0601240132560.32305-100000@coffee.psychology.mcmaster.ca>	 <43D5EF58.9010807@wasp.net.au>  <43D66681.708@dgreaves.com> <1138183485.27604.49.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1138183485.27604.49.camel@localhost.localdomain>
Sender: linux-ide-owner@vger.kernel.org
To: Erik Slagter <erik@slagter.name>
Cc: linux-raid@vger.kernel.org, IDE Linux <linux-ide@vger.kernel.org>
List-Id: linux-raid.ids

Erik Slagter wrote:
> On Tue, 2006-01-24 at 17:40 +0000, David Greaves wrote:
>>>> sounds like a spinup time on marginal power to me.
> 
>>> No, it's a limitation of the Promise BIOS on the cards, it will only
>>> detect a maximum of 8 drives. I had a quick convo with tech support
>>> from Promise over this and they told me they don't support more than
>>> one card in a machine in any case. (Which is odd given they advertise
>>> the ability to RAID-5 across 2 cards!)
> 
>>> <snipped the rest about power issues>
> 
> I'd really consider the PSU. I had all sorts of weird problems with my
> promise SATA150 TX2plus until I replaced the PSU. Apparently it doesn't
> suffice to supply _enough_ power.

I've since setup the machine so only the motherboard and boot drive are 
powered from the system PSU and the 12 SATA drives are powered from a 
separate PSU.

Since the machine has previously been running with 8 drives fine on just 
the system PSU, I feel confident saying power supply has nothing to do 
with my problems.

CS

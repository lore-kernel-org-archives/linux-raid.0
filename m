From: Dan Williams <dan.j.williams@gmail.com>
Subject: Re: Accelerating Linux software raid
Date: Sat, 10 Sep 2005 12:13:57 -0700
Message-ID: <e9c3a7c205091012133d4e07fd@mail.gmail.com>
References: <4322D862.3000300@emc.com>
	 <Pine.LNX.4.44.0509100927130.29141-100000@coffee.psychology.mcmaster.ca>
Reply-To: dan.j.williams@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0509100927130.29141-100000@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Ric Wheeler <ric@emc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> this is an excellent point, and one that argues *against* HW coprocessing.
> consider the NIC market: TOE never happened because adding tcp/ssl to a
> separate card just moves the complexity and bugs from an easy-to-patch place
> into a harder-to-patch place.  I'd much rather upgrade from a uni server to a
> dual and run the tcp/ssl in software than spend the same amount of money
> on a $2000 nic that runs its own OS.  my tcp stack bugs get fixed in a
> few hours if I email netdev, but who knows how long bugs would linger in
> the firmware stack of a TOE card?
> 
> same thing here, except moreso.  making storage appliances smarter is great,
> but why put that smarts in some kind of opaque, inaccessible and hard-to-use
> coprocessor?  good, thoughtful design leads towards a loosely-coupled cluster
> of off-the-shelf components...
> 

The question here is not can a modern server outperform a coprocessor
at a given task.  Of course it can.  The issue here is how to scale
embedded Linux I/O performance for system-on-a-chip storage silicon
designs.  An embedded design breaks some of the assumptions of the
current driver, first that dedicated raid5/6 offload logic is
available, and that, in general, system resources can be biased
towards the I/O subsystem.  I disagree that it is a solution looking
for a problem.  The problem is the MD driver performs sub optimally on
these platforms.

I'm learning MD by reading the source, and stepping through it with a
debugger.  If anyone knows of other documentation or talks given about
MD please point me to it.

Thanks,

Dan

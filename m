From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Accelerating Linux software raid
Date: Sat, 10 Sep 2005 11:35:05 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0509100927130.29141-100000@coffee.psychology.mcmaster.ca>
References: <4322D862.3000300@emc.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4322D862.3000300@emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ric Wheeler <ric@emc.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I think that the above holds for server applications, but there are lots 
> of places where you will start to see a need for serious IO capabilities 
> in low power, multi-core designs.  Think of your Tivo starting to store 
> family photos - you don't want to bolt a server class box under your TV 
> in order to get some reasonable data protection ;-)

I understand your point, but are the numbers right?  it seems to me that 
the main factor in appliance design is power dissipation, and I'm guessing
a budget of say 20W for the CPU.  these days, that's a pretty fast processor,
of the mobile-athlon-64 range - probably 3 GB/s xor performance.  I'd 
guess it amounts to perhaps 5-10% cpu overhead if the appliance were,
for some reason, writing at 100 MB/s.  of course, it is NOT writing at 
that rate (remember, reading doesn't require xors, and appliances probably
do more reads than writes...)

> In the Centera group where I work, we have a linux based box that is 
> used for archival storage.  Customers understand why the cost of a box 
> is related to the number of disks, but the strength of the CPU, memory 
> subsystem, etc are all more or less thought of as overhead (not to 
> mention that nasty software stuff that I work on ;-)).

again, no offense meant, but I hear you saying "we under-designed the 
centera host processor, and over-priced it, so that people are trying to 
Stretch their budget by piling on too many disks".  I'm actually a little
surprised, since I figured the Centera design would be a sane, modern,
building-block-based one, where you could cheaply scale the number of 
host processors, not just disks (like an old-fashioned, not-mourned SAN.)
I see a lot of people using a high-performance network like IB as an internal
backplane-like way to tie together a cluster-in-a-box.  (and I expect they'll
sprint from IB to 10G real soon now.)

but then again, you did say this was an archive box.  so what is the
bandwidth of data coming in?  that's the number that sizes your host cpu.
being able to do xor at 12 GB/s is kind of pointless if the server has just
one or two 2 Gb net links... 

> In this kind of environment as well, finding an elegant way to take 
> advantage of the capabilities of the new system on a chip parts is a win.

I understand completely - aesthetic elegance does tend to inspire most 
solutions-in-search-of-problems.  it's one of those urges that we all must 
simply learn to stifle every day.

> Also keep in mind that the Xor done for simple RAID is not the whole 
> story - think of compression offload, encryption, etc which might also 
> be able to leverage a well thought out solution.

this is an excellent point, and one that argues *against* HW coprocessing.
consider the NIC market: TOE never happened because adding tcp/ssl to a 
separate card just moves the complexity and bugs from an easy-to-patch place 
into a harder-to-patch place.  I'd much rather upgrade from a uni server to a
dual and run the tcp/ssl in software than spend the same amount of money
on a $2000 nic that runs its own OS.  my tcp stack bugs get fixed in a 
few hours if I email netdev, but who knows how long bugs would linger in
the firmware stack of a TOE card?

same thing here, except moreso.  making storage appliances smarter is great,
but why put that smarts in some kind of opaque, inaccessible and hard-to-use
coprocessor?  good, thoughtful design leads towards a loosely-coupled cluster
of off-the-shelf components...

regards, mark hahn.
(I run a large supercomputing center, and spend a lot of effort specifying
and using big compute and storage hardware...)


From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Looking for the cause of poor I/O performance
Date: Sat, 4 Dec 2004 17:59:28 -0500 (EST)
Message-ID: <Pine.LNX.4.44.0412041745290.21262-100000@coffee.psychology.mcmaster.ca>
References: <200412031503.32130.systemloc@earthlink.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200412031503.32130.systemloc@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: TJ <systemloc@earthlink.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> throughput. I'm hoping that this still may be related to some sort of PCI 
> latency issue.

you can use setpci to do this sort of tweaking.  naturally,
you probably want to mount your filesystems RO when you do this,
since accidents do happen...

but in abstract, it's quite odd to believe that you can persuade a 
7-year old machine to perform as well as a current one.  sure, it 
sometimes happens, but so very much has changed.  as a completely
random example, the topology of bus-like links in a modern box is 
vastly less bottlenecked than in the bad old days.  for instance,
it was completely normal back then for the chipset's builtin IDE
(and any add-ons) to sit on a single 32x33 PCI segment.  that segment
was often unable to actually approach 133 MB/s (80 was pretty good 
in those days).  and often vendors would bend the rules a little
like adding a bit more delay in arbitration in order to permit
more PCI slots (since PCI, like any multidrop bus, always has a 
speed-drops tradeoff). 

nowadays, it's actually common to see unshared pcix slots direct
to a memory-controller-hub, along with unshared connections for 
*ATA, sound, even ethernet.  not to mention the fact that memory
itself is 10x faster.


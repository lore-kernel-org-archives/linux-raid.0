From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: RE: Forcing raid1 resync
Date: Tue, 17 Aug 2004 11:43:19 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408171136370.18428-100000@coffee.psychology.mcmaster.ca>
References: <8075D5C3061B9441944E1373776451186488C2@cinshrexc03.shermfin.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8075D5C3061B9441944E1373776451186488C2@cinshrexc03.shermfin.com>
To: "Rechenberg, Andrew" <ARechenberg@sfg.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> The box in question is a quad Xeon 1.4GHz with HT enabled.  I don't
> believe it was CPU bound.

quad xeons are *normally* memory-bound, since their design is really
quite poor, with all four CPUs sharing a relatively slow bus.  they'll
be OK for purely cache-bound workloads, but are pretty much a huge mistake
for anything out-of-cache (as, indeed, md raid5 is carefully designed to be!)

> > Is this behavior expected/by design?  Waiting for 26 arrays 
> > to reconstruct one at a time is painfully slow.  When I 

I wonder whether your configuration might have something to do with this - 
iirc the kernel tries to be smart about sequencing the md's that it resyncs,
since it would be very bad to resync 10 arrays which share the same spindles.
perhaps it doesn't understand which block devices correspond with separate
spindles.

> > about 5 arrays started syncing, but the rest waited until 
> > those were finished and then synced one at a time.

that sounds like a (good, in principle) designed behavior.


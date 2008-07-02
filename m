From: Keld J?rn Simonsen <keld@dkuug.dk>
Subject: Re: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 21:35:27 +0200
Message-ID: <20080702193527.GA13186@rap.rap.dk>
References: <20080702155603.GA11156@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com> <20080702190337.GA2311@sewage.raw-sewage.fake> <cccedfc60807021210y2b47917ap227e46fd1666755e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60807021210y2b47917ap227e46fd1666755e@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: Matt Garman <matthew.garman@gmail.com>, David Lethe <david@santools.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 02, 2008 at 02:10:21PM -0500, Jon Nelson wrote:
> On Wed, Jul 2, 2008 at 2:03 PM, Matt Garman <matthew.garman@gmail.com> wrote:
> > On Wed, Jul 02, 2008 at 12:04:11PM -0500, David Lethe wrote:
> >> The PCI (and PCI-X) bus is shared bandwidth, and operates at
> >> lowest common denominator.  Put a 33Mhz card in the PCI bus, and
> >> not only does everything operate at 33Mhz, but all of the cards
> >> compete.  Grossly simplified, if you have a 133Mhz card and a
> >> 33Mhz card in the same PCI bus, then that card will operate at
> >> 16Mhz. Your motherboard's embedded Ethernet chip and disk
> >> controllers are "on" the PCI bus, so even if you have a single PCI
> >> controller card, and a multiple-bus motherboard, then it does make
> >> a difference what slot you put the controller in.
> >
> > Is that true for all PCI-X implementations?  What's the point, then,
> > of having PCI-X (64 bit/66 MHz or greater) if you have even one PCI
> > card (32 bit/33 MHz)?
> 
> This motherboard (EPoX MF570SLI) uses PCI-E.

PCI-E is quite different architecturally from PCI-X.

> It has a plain old PCI video card in it:
> Trident Microsystems TGUI 9660/938x/968x
> and yet I appear to be able to sustain plenty of disk bandwidth to 4 drives:
> (dd if=/dev/sd[b,c,d,e] of=/dev/null bs=64k)
> vmstat 1 reports:
> 290000 to 310000 "blocks in", hovering around 300000.
> 
> 4x70 would be more like 280, 4x75 is 300. Clearly the system is not
> bandwidth challenged.
> (This is with 4500 context switches/second, BTW.)

Possibly you are using an on-board disk controller, and then it most
likely does not use the PCI-E bus for disk IO.

best regards
keld

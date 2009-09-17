From: Tapani Tarvainen <raid@tapanitarvainen.fi>
Subject: Re: recommended 4port SATA controller ?
Date: Thu, 17 Sep 2009 16:40:34 +0300
Message-ID: <20090917134034.GA10485@musti.tarvainen.info>
References: <4AB22135.7030405@kaneda.iguw.tuwien.ac.at> <87f94c370909170549v156f9b23ie19f7204e21819f1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87f94c370909170549v156f9b23ie19f7204e21819f1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 17, 2009 at 08:49:16AM -0400, Greg Freemyer (greg.freemyer@gmail.com) wrote:

> I don't recall seeing a non-raid 4-port "legacy PCI" controller, but I
> can't say I've looked very hard.  Hopefully your motherboard has a
> "PCI express" slot available.

Curiously, I've found 4-port PCI cards much more common
than PCIe ones. In particular, Sil3114-based cards
are ubiquitous and cheap (~US$20). Most of them have
(fake)RAID bios but I've yet to see one where it could not
be disabled or just ignored, at least if you don't
need to boot off it. Fast they aren't but neither is PCI.
There are also some 4-port Sil3124-based PCI cards, somewhat
more expensive and presumably faster, but PCI is likely
to be the bottleneck anyway.

But good, cheap 4-port PCIe cards are hard to find.
There are several high-end cards that require x8 slot
and cost a fortune, but very few x1 cards with 4 ports
with good Linux support; Sunix 4400P is one (Marvell chipset).

Nor do there seem to be any low-end (<$100 or so)
x4 or x8 cards either; Lycom PE-124 looks promising,
but it's eSATA only and no webshop seems to sell it.

Of course, if you can spare two PCIe x1 slots it's easy:
2-port Sil3132 -based cards are abundant, cheap, and work very well.

-- 
Tapani Tarvainen

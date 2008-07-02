From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: new bottleneck section in wiki
Date: Wed, 2 Jul 2008 14:03:37 -0500
Message-ID: <20080702190337.GA2311@sewage.raw-sewage.fake>
References: <20080702155603.GA11156@rap.rap.dk> <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A20315AE59B5C34585629E258D76A97CF1FCCC@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Keld J?rn Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 02, 2008 at 12:04:11PM -0500, David Lethe wrote:
> The PCI (and PCI-X) bus is shared bandwidth, and operates at
> lowest common denominator.  Put a 33Mhz card in the PCI bus, and
> not only does everything operate at 33Mhz, but all of the cards
> compete.  Grossly simplified, if you have a 133Mhz card and a
> 33Mhz card in the same PCI bus, then that card will operate at
> 16Mhz. Your motherboard's embedded Ethernet chip and disk
> controllers are "on" the PCI bus, so even if you have a single PCI
> controller card, and a multiple-bus motherboard, then it does make
> a difference what slot you put the controller in.

Is that true for all PCI-X implementations?  What's the point, then,
of having PCI-X (64 bit/66 MHz or greater) if you have even one PCI
card (32 bit/33 MHz)?

A lot of "server" motherboards offer PCI-X and some simple graphics
chip.  If you read the motherboard specs, that simple graphics is
usually attached to the PCI bus [1].  So what's the point of having
PCI-X slots if everything is automatically downgraded to PCI speeds
due to the embedded graphics?

I read some of the high-level info on the Intel 6702 PHX PCI-X hub
[2].  If I understand correctly, that controller is actually
attached to the PCI express bus.  So to me, it seems possible that
PCI and PCI-X could be independant, and that PCI-X will compete with
PCI-E for bandwidth.

[1] The ASUS M2N-LR has PCI-X (via the Intel 6702PHX) and an
embedded ATI ES1000 video card.  The ES1000's specs say it has a PCI
bus interface.
ES1000: http://ati.amd.com/products/server/es1000/index.html

[2] http://www.intel.com/design/chipsets/datashts/303633.htm


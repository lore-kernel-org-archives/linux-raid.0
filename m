From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: HighPoint 1820 (8pt sata pcix, $170)
Date: Fri, 28 Nov 2003 14:47:38 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20031128194738.GB21310@gtf.org>
References: <20031119165519.GB14191@ti19.telemetry-investments.com> <Pine.LNX.4.44.0311280100150.27273-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311280100150.27273-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Nov 28, 2003 at 01:04:24AM -0500, Mark Hahn wrote:
> 
> do you have any comment on the HighPoint 1820 card?  it's an 8-port SATA
> controller with PCI-X, and appears to list for about $US 170 (pricewatch).
> there's a driver (apparently binary-only, therefore of unknown quality)
> available from the vendor, but I suspect no real (kerne.org or libata)
> driver support...

HighPoint is just about the only manufacturer that hasn't contacted me
about getting a SATA driver for their hardware into the kernel :)

I would go for Promise or ServerWorks 4-port and 8-port SATA cards, if
you don't wanna spend the extra bucks for a real RAID card (and I
personally trust software RAID over hardware RAID any day).

	Jeff




From: "Peter L. Ashford" <ashford@sdsc.edu>
Subject: Re: Promise FastTrak TX4 losing interrupts (with apic mode)
Date: Thu, 6 Feb 2003 07:33:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.30.0302060728320.15885-100000@multivac.sdsc.edu>
References: <Pine.LNX.4.53.0302060313490.9702@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0302060313490.9702@ddx.a2000.nu>
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Stephan,

> hde: lost interrupt
> hde: lost interrupt
> ide_dmaproc: chipset supported ide_dma_lostirq func only: 13
> hde: lost interrupt
> unknown partition table
> hdg: lost interrupt
> hdg: lost interrupt
> ide_dmaproc: chipset supported ide_dma_lostirq func only: 13
> hdg: lost interrupt
> unknown partition table
> hdi: lost interrupt
> hdi: lost interrupt
> ide_dmaproc: chipset supported ide_dma_lostirq func only: 13
> hdi: lost interrupt
> unknown partition table

I just saw, and fixed, a very similar problem last night (lost interrupts,
but partition table was eventually read).  The system was a dual Xeon on a
P4DP6.  The Promise card was an Ultra100TX2.  The OS was RedHat 7.3.

The fix was to increase the bus master time for the PCI slot in the BIOS.
This was also tried under SuSE 8.1, where it did NOT work.

YMMV.
				Peter Ashford

From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Supermicro AOC-SAT2-MV8
Date: Sat, 20 Dec 2008 04:36:24 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812200434580.22104@p34.internal.lan>
References: <C571CD8F.BA37%groups@email.iain.rauch.co.uk> <494C7FF6.6050100@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <494C7FF6.6050100@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@wasp.net.au>
Cc: Iain Rauch <groups@email.iain.rauch.co.uk>, Max Waterman <davidmaxwaterman@fastmail.co.uk>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Sat, 20 Dec 2008, Brad Campbell wrote:

> Iain Rauch wrote:
>>> OK, so it sounds like my suspicions were correct - I have PCI/PCIe.
>>> 
>>> You say I would be better to use PCIe, but the card is PCI-X. Can I use
>>> PCI-X in a PCIe slot?
>
> These Marvell 7042 chips are great. Cheers Mark!!
>
> You can use a PCI-X card in a PCI slot, but I believe you'll be disappointed 
> with the results.
>
> If you only need a couple of ports and have a PCIe 1x slot available, the 
> SIL-3132 cards are available everywhere and are really pretty good.

Only use them with slow drives, when I had used my Velociraptors, I got around
the maximum bandwidth with 1 disk hooked to each PCI-e x1, when I ran tests
on two of the PCI-e x1 cards, it cut the BW in half.  They are not fast enough
to handle to fast disks.  The Startech card though is great and you can fully
saturate it-- to get all available bandwidth from the disks.


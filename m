From: Drew <drew.kay@gmail.com>
Subject: Re: Port Multipliers
Date: Thu, 10 Sep 2009 11:14:05 -0700
Message-ID: <c268e4660909101114h36229a34xc354a41a4f3610d4@mail.gmail.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
	<70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> If you're looking at port multipliers, you need to find PCI-Express
> modules if you want them to be fast. The PCI ones are gonna be very
> slow when you have more than 2 disks per card.

The existing server we're planning to re-purpose for this is an IBM
xSeries with two free PCI-X/100 slots and dual PCIe/x4 slots.

> You might want to checkout Supermicro's offerings as well.

I'd love to be able to upgrade the servers but the bean counters won't
authorize new servers until the existing kit have been fully amortized
and/or we're overloading the existing units. Given the main ESXi host
is a 8 core IBM x445 that's about 60% loaded and I have 3 years worth
of amortization left I can't add new servers.

Storage is another matter, we're pushing to about 80% of our current
400GB capacity and with our OEM suppliers (we sell commercial trucks)
advising us to expect more of our documentation and training going
electronic, I'm looking at shelves worth of manuals and training
material being made electronic over the next few years and given our
data transmission costs are much higher (~$10/GB) then local storage,
we're looking at local storage.

We've considered upgrading our SCSI drives but the per GB cost
difference of SATA vs SCSI drives just isn't worth it. We pay about
$1-$2/GB for SCSI vs $0.25-$0.50/GB for server grade SATA.


-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

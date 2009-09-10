From: Drew <drew.kay@gmail.com>
Subject: Re: Port Multipliers
Date: Thu, 10 Sep 2009 11:35:03 -0700
Message-ID: <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>
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

I'm definitely going to use the PCIX/PCIe slots for the Host Adapter.

What I'm wondering is if I use a HBA and Port Multiplier that support
FIS based switching, say a Sil 3124 & 3726, how much of a loss in data
transfer rate can I expect from the RAID array built off the PM as
opposed to each disk plugged in separately?

An example configuration I'm looking at is a Sil3124 4 port HBA with
three of the ports having Sil3726 5to1 PMs attached. Each PM then has
four disks hung off the PM. If I create a RAID5 array for example on
each PM, what sort of speed degradation would I be looking at compared
to making a RAID5 off just the 3124?

-- 
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

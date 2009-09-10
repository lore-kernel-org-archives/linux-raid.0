From: "Majed B." <majedb@gmail.com>
Subject: Re: Port Multipliers
Date: Thu, 10 Sep 2009 21:44:48 +0300
Message-ID: <70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>
	<70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>
	<c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Drew <drew.kay@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The maximum throughput you'll get is the PCI bus's speed. Make sure to
note which version your server has.

The silicon image controller will be your bottleneck here, but I don't
have any numbers to say how much of a loss you'll be at. You'd have to
search around for those who already benchmarked their systems, or
buy/request a card to test it out.

If you do get a card and test it, make sure that you report back to us
and update the wiki: http://linux-raid.osdl.org/index.php/Performance

On Thu, Sep 10, 2009 at 9:35 PM, Drew<drew.kay@gmail.com> wrote:
>> If you're looking at port multipliers, you need to find PCI-Express
>> modules if you want them to be fast. The PCI ones are gonna be very
>> slow when you have more than 2 disks per card.
>
> I'm definitely going to use the PCIX/PCIe slots for the Host Adapter.
>
> What I'm wondering is if I use a HBA and Port Multiplier that support
> FIS based switching, say a Sil 3124 & 3726, how much of a loss in data
> transfer rate can I expect from the RAID array built off the PM as
> opposed to each disk plugged in separately?
>
> An example configuration I'm looking at is a Sil3124 4 port HBA with
> three of the ports having Sil3726 5to1 PMs attached. Each PM then has
> four disks hung off the PM. If I create a RAID5 array for example on
> each PM, what sort of speed degradation would I be looking at compared
> to making a RAID5 off just the 3124?
>
> --
> Drew
>
> "Nothing in life is to be feared. It is only to be understood."
> --Marie Curie
>



-- 
       Majed B.

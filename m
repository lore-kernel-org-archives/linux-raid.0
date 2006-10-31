From: "Rob Bray" <raid@bymeinc.com>
Subject: Re: future hardware
Date: Tue, 31 Oct 2006 11:11:06 -0500 (EST)
Message-ID: <55864.192.168.0.1.1162311066.squirrel@bymeinc.com>
References: <000901c6f509$1bd65560$eb00000a@mine3ad5e808fe>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000901c6f509$1bd65560$eb00000a@mine3ad5e808fe>
Sender: linux-raid-owner@vger.kernel.org
To: Dan <dan@korstad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I have been using an older 64bit system, socket 754 for a while now.  It
> has
> the old PCI bus 33Mhz.  I have two low cost (no HW RAID) PCI SATA I cards
> each with 4 ports to give me an eight disk RAID 6.  I also have a Gig NIC,
> on the PCI bus.  I have Gig switches with clients connecting to it at Gig
> speed.
>
> As many know you get a peak transfer rate of 133 MB/s or 1064Mb/s from
> that
> PCI bus http://en.wikipedia.org/wiki/Peripheral_Component_Interconnect
>
> The transfer rate is not bad across the network but my bottle neck it the
> PCI bus.  I have been shopping around for new MB and PCI-express cards.  I
> have been using mdadm for a long time and would like to stay with it.  I
> am
> having trouble finding an eight port PCI-express card that does not have
> all
> the fancy HW RAID which jacks up the cost.  I am now considering using a
> MB
> with eight SATA II slots onboard.  GIGABYTE GA-M59SLI-S5 Socket AM2 NVIDIA
> nForce 590 SLI MCP ATX.
>
> What are other users of mdadm using with the PCI-express cards, most cost
> effective solution?
>
>

I agree that SATA drives on PCI-E cards are as much bang-for-buck as is
available right now. On the newer platforms, each PCI-E slot, the onboard
RAID controller(s), and the 32-bit PCI bus all have discrete paths to the
chip.

Play with the thing to see how many disks you can put on a controller
without a slowdown. Don't assume the controller isn't oversold on
bandwidth (I was only able to use three out of four CK804 ports on a
GA-K8NE without saturating it; two out of four slots on a PCI Sil3114).
Combining the bandwidth of the onboard RAID controller, two SATA slots,
and one PCI controller card, sustained reads reach 450MB/s (across 7
disks, RAID-0) with an $80 board, and three $20 controller cards.


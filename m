From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: future hardware
Date: Sat, 21 Oct 2006 12:52:01 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0610211250300.11410@p34.internal.lan>
References: <000901c6f509$1bd65560$eb00000a@mine3ad5e808fe>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000901c6f509$1bd65560$eb00000a@mine3ad5e808fe>
Sender: linux-raid-owner@vger.kernel.org
To: Dan <dan@korstad.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sat, 21 Oct 2006, Dan wrote:

> I have been using an older 64bit system, socket 754 for a while now.  It has
> the old PCI bus 33Mhz.  I have two low cost (no HW RAID) PCI SATA I cards
> each with 4 ports to give me an eight disk RAID 6.  I also have a Gig NIC,
> on the PCI bus.  I have Gig switches with clients connecting to it at Gig
> speed.
> 
> As many know you get a peak transfer rate of 133 MB/s or 1064Mb/s from that
> PCI bus http://en.wikipedia.org/wiki/Peripheral_Component_Interconnect
> 
> The transfer rate is not bad across the network but my bottle neck it the
> PCI bus.  I have been shopping around for new MB and PCI-express cards.  I
> have been using mdadm for a long time and would like to stay with it.  I am
> having trouble finding an eight port PCI-express card that does not have all
> the fancy HW RAID which jacks up the cost.  I am now considering using a MB
> with eight SATA II slots onboard.  GIGABYTE GA-M59SLI-S5 Socket AM2 NVIDIA
> nForce 590 SLI MCP ATX.
> 
> What are other users of mdadm using with the PCI-express cards, most cost
> effective solution?
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Read this:

http://www.anandtech.com/IT/showdoc.aspx?i=2859

I have a similar setup to you, 6 IDE ATA/100 + 2 SATA/150 (all 400GB) in 
an mdadm RAID5, works well but it maxes out the PCI bus unfortunately.  At 
some point I am going to do what you did, get 2 x SATA PCI-e SiL 3114 
cards perhaps.  Or, after reading that article, consider SAS maybe..?

Justin.

From: Maarten J H van den Berg <maarten@vbvb.nl>
Subject: Re: software raid options
Date: Fri, 27 Feb 2004 08:16:41 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200402270816.41439.maarten@vbvb.nl>
References: <403EE77A.2060508@hivemind.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <403EE77A.2060508@hivemind.net>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 27 February 2004 07:45, Bretton Vine wrote:

> Where I'm hitting a snag is in determining the ideal hardware setup. The
> motherboard has an onboard ide controller but only two channels. I'd
> like to run raid 5 and have investigated costs for purchasing two new
> pci parallel ATA ide controllers, or one pci SATA ide controller.
> (I don't want one controller under via chipset and another under a
> different chipset - seems like things may go wrong in that situation)

In my opinion you should use the onboard controller as well. And I say "as 
well" because you really really only should use one drive per cable, i.e. you 
do not use "slave" drives, only masters. You thus need one or several 
ultra133tx2 cards, depending on the amount of drives you have.

> 1) Will one SATA ide controller suffice if I want to run four disks off
> it, one acting as hot spare. (yeah I know s/w raid is over partitions).
> I'm completely unfamiliar with SATA and don't know if you can run four
> masters off four SATA connections on the same SATA pci card.

I am unfamiliar with SATA as well, but judging from this mailinglist I still 
have some doubts about some of the SATA cards' drivers. I may be mistaken 
though.  Just make sure before you buy any SATA card that it is supported.

> 2) Other option is two have two duplicate pci parallel ide controllers
> (leave the onboard Via chipset controller out of the equation) and run
> two disks per controller. Is there anything I should be aware of if I'm
> sticking in two pci ide controllers. Is this a suggested solution?

I use this myself on my 7 disk IDE raid5 setup. All are running off a couple 
(3 units I think) promise Ultra100TX /Ultra133TX2 and one off the mainboard. 
In addition I have an eighth disk which contains just the OS (the raid is 
userdata only) as first disk, thus also off the mainboard. This is not 
neccessary but it seemed a good idea at the time, and it circumvents any 
(possible) trouble regarding booting off raid5. But that's just me...

As an aside: it was quite a challenge to get 8 IDE disks each on its own 
channel inside a bigtower, what with cooling and cablemanagement... :-)

Maarten


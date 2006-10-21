From: "Dan" <dan@korstad.net>
Subject: future hardware
Date: Sat, 21 Oct 2006 07:04:43 -0500
Message-ID: <000901c6f509$1bd65560$eb00000a@mine3ad5e808fe>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have been using an older 64bit system, socket 754 for a while now.  It has
the old PCI bus 33Mhz.  I have two low cost (no HW RAID) PCI SATA I cards
each with 4 ports to give me an eight disk RAID 6.  I also have a Gig NIC,
on the PCI bus.  I have Gig switches with clients connecting to it at Gig
speed.

As many know you get a peak transfer rate of 133 MB/s or 1064Mb/s from that
PCI bus http://en.wikipedia.org/wiki/Peripheral_Component_Interconnect

The transfer rate is not bad across the network but my bottle neck it the
PCI bus.  I have been shopping around for new MB and PCI-express cards.  I
have been using mdadm for a long time and would like to stay with it.  I am
having trouble finding an eight port PCI-express card that does not have all
the fancy HW RAID which jacks up the cost.  I am now considering using a MB
with eight SATA II slots onboard.  GIGABYTE GA-M59SLI-S5 Socket AM2 NVIDIA
nForce 590 SLI MCP ATX.

What are other users of mdadm using with the PCI-express cards, most cost
effective solution?



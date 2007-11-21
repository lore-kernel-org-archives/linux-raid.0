From: Daniel Korstad <dan@korstad.net>
Subject: RE: Offtopic: hardware advice for SAS RAID6
Date: Wed, 21 Nov 2007 08:24:37 -0600
Message-ID: <1021217410.521195655077757.JavaMail.root@gateway.korstad.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Richard Michael <rmichael-raid@edgeofthenet.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would be very interested to hear how that card works or other suggestions discussions too.
 
I have a 10 disk RAID 6 all inside a large case, using on board MB SATA and a couple 4 port PCI SATA cards.  For one, my PCI bus is saturated and a bottle neck and it is a bit of a pain to replace drives by having to open the case each time.
 
I have been running this for years without issues, but would like to upgrade the system at some point and would like to use mdadm software raid, with an external enclosure allowing easy drive swapping.
 
The most I can contribute to this thread are SATA Multilane Enclosures I have been eyeing.
http://www.pc-pitstop.com/sata_enclosures/
 
But like you, I need a card that is Linux friendly and provides hard drive raid control to mdadm.
 
I'll follow this one and would like to hear about your experiences with the SAS card you choose.

----- Original Message -----
From: Richard Michael <rmichael-raid@edgeofthenet.org>
Sent: Tue, 11/20/2007 10:08am
To: linux-raid@vger.kernel.org
Subject: Offtopic: hardware advice for SAS RAID6

On the heels of last week's post asking about hardware recommendations,
I'd like to ask a few questions too. :)

I'm considering my first SAS purchase.  I'm planning to build a software
RAID6 array using a SAS JBOD attached to a linux box.  I haven't decided
on any of the hardware specifics.

I'm leaning toward this PCI express LSI 3801e controller:
http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/lsisas3801e/index.html

Although, Adaptec has a similar PCI-X model.

I'd probably purchase a cheap Dell rackmount 1U server (e.g. PowerEdge
860) for the controller.  It has dual Gb ethernet, which I'd channel
bond for decent network I/O performance.

The JBOD would ideally be 1U or 2U holding 8 or 10 disks.  If I
understand SAS correctly, I'd probably have a unit with 2 SFF-8088
miniSAS connectors (although, I believe these connectors only support 4
devices, so if the JBOD is >8 disks, I don't know what would happen).

I'm completely undecided on the JBOD itself; recommendations here would
be greatly appreciated.  It's a bit of a shot in the dark.

I'd appreciate feedback and suggestions on the hardware above, or a
discussion of the performance.  (E.g. a discussion of SAS
ports/bandwith, PCI express lanes/bandwidth, disks and network to
determine the through put of this setup.)

Cheers,
Richard
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

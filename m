From: Bretton Vine <bretton@hivemind.net>
Subject: software raid options
Date: Fri, 27 Feb 2004 08:45:14 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <403EE77A.2060508@hivemind.net>
Reply-To: bretton@hivemind.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All

I'm new to the list so apologies if any of my questions have come up
before and been answered.

Given the costs of a hardware raid solution here in South Africa (3-4
times the cost of hardware at online retailers) I've opted for a
software raid configuration under Debian Linux.

Where I'm hitting a snag is in determining the ideal hardware setup. The
motherboard has an onboard ide controller but only two channels. I'd
like to run raid 5 and have investigated costs for purchasing two new
pci parallel ATA ide controllers, or one pci SATA ide controller.
(I don't want one controller under via chipset and another under a
different chipset - seems like things may go wrong in that situation)

1) Will one SATA ide controller suffice if I want to run four disks off
it, one acting as hot spare. (yeah I know s/w raid is over partitions).
I'm completely unfamiliar with SATA and don't know if you can run four
masters off four SATA connections on the same SATA pci card.

2) Other option is two have two duplicate pci parallel ide controllers
(leave the onboard Via chipset controller out of the equation) and run
two disks per controller. Is there anything I should be aware of if I'm
sticking in two pci ide controllers. Is this a suggested solution?

3) I've looked at the Promise SATA150 TX4 and the Promise Ultra133 TX2:
of these two which is better. Broad question I know, but I'm a bit
confused as to whether moving to SATA is even worth it just yet as the
costs are considerably higher than parallel ATA.

4) Is there any other brand of SATA/Parallel pci controller card that
will have few to none driver/kernel issues under Linux. Any particular
brand well supported and ideal?

Thanks in advance and once I have a clear idea of what I'm doing on the
initial hardware setup I'll probably have some more interesting
questions to ponder.

Bretton
-- 
cell: +27.82.494.6902  meatspace: Johannesburg, South Africa
        yahoo: bretton69   icq: 175753755   aim: brettonv
              jabber: bretton@jabber.obsidian.co.za
                        ..gpg key on request..

"The great tragedy of science -- the slaying of a beautiful hypothesis
by an ugly fact." - Thomas Huxley





From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Thu, 14 Apr 2011 14:37:23 -0500
Message-ID: <4DA74CF3.2050509@hardwarefreak.com>
References: <4DA6CCFE.8020708@crc.id.au> <20110414165433.7a7d1cdc@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110414165433.7a7d1cdc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov put forth on 4/14/2011 5:54 AM:

> I suggest that you avoid Silicon Image 3132, they have data corruption issue
> (on some board designs?), triggered or amplified by transferring via both
> ports at the same time, at full speed.

Stating this opinion based on a very limited number of such reports is
irresponsible.  If the issue is a bad PCB from a couple of vendors,
state the vendors and the card model and rev.  DO NOT paint the SATA
chip itself as BAD and something to avoid.  Case in point:

http://blog.backblaze.com/2009/09/01/petabytes-on-a-budget-how-to-build-cheap-cloud-storage/

BackBlaze uses three Sil3132 based 2 port Syba PCIe x1 SATAII cards in
each storage 45 drive storage pod server, and one 4 port Addonics
Sil3124 PCI card.  Odd balance WRT bandwidth, but if you read the doc
it'll be clear why they did this.

They've had HUNDREDS of these Syba and Addonics Silicon Image chip cards
in production for multiple years now and report nothing but great
success.  They use 9 SATAII backplanes per chassis each with a 1:5
Silicon Image 3726 PMP, for a total of 45 drives per chassis.  They
create 3 x 15 drive mdadm RAID6 arrays per chassis, as the drives are
physically laid out in 3 rows of 15.

These systems are greater in scale and complexity than anything I've
seen discussed on this list in the year+ I've been subbed.  Again, the
backbone of their 45 drive pod is the Sil3132 chip, each 3132 managing
10 drives, 5 each connected to BOTH card ports via PMPs, 30 drives total
per chassis controlled by the Sil3132 chips.  The Addonics Sil3124 card
manages 15 drives across 3 ports and 3 PMPs.

Silicon Image has the most compatible, tested, and field proven reliable
SATA chips on the planet, ditto its PMP chips.  BackBlaze is but one
example of this.  Also, Silicon Image PMP chips ship in more products
than all other PMPs combined.

Again, there is nothing wrong with the Silicon Image chips.  They have a
very good reputation.  There is apparently a problem with some Chinese
really cheap badly designed/manufactured Silicon Image based  cards
going into the Russian market.  From the comments I read it appears the
"sample set" of bad cards consisted of less than a dozen.  This could
have simply been a bad batch of cards.  From the comments, this actually
seems like the most likely scenario.

-- 
Stan

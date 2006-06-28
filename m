From: Brad Campbell <brad@wasp.net.au>
Subject: Re: I need a PCI V2.1 4 port SATA card
Date: Wed, 28 Jun 2006 08:29:48 +0400
Message-ID: <44A205BC.90808@wasp.net.au>
References: <200606280245.k5S2jkB24340@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200606280245.k5S2jkB24340@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Guy wrote:
> Hello group,
> 
> 	I am upgrading my disks from old 18 Gig SCSI disks to 300 Gig SATA
> disks.  I need a good SATA controller.  My system is old and has PCI V 2.1.
> I need a 4 port card, or 2 2 port cards.  My system has multi PCI buses, so
> 2 cards may give me better performance, but I don't need it.  I will be
> using software RAID.  Can anyone recommend a card that is supported by the
> current kernel?

I'm using Promise SATA150TX4 cards here in old PCI based systems. They work great and have been rock 
solid for well in excess of a year 24/7 hard use. I have 3 in one box and 4 in another.

I'm actually looking at building another 15 disk server now and was hoping to move to something 
quicker using _almost_ commodity hardware.

My current 15 drive RAID-6 server is built around a KT600 board with an AMD Sempron processor and 4 
SATA150TX4 cards. It does the job but it's not the fastest thing around (takes about 10 hours to do 
a check of the array or about 15 to do a rebuild).

I'd love to do something similar with PCI-E or PCI-X and make it go faster (the PCI bus bandwidth is 
the killer), however I've not seen many affordable PCI-E multi-port cards that are supported yet and 
PCI-X seems to mean moving to "server" class mainboards and the other expenses that come along with 
that.

Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams

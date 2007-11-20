From: Richard Michael <rmichael-raid@edgeofthenet.org>
Subject: Offtopic: hardware advice for SAS RAID6
Date: Tue, 20 Nov 2007 11:08:06 -0500
Message-ID: <20071120160806.GD24510@server>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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

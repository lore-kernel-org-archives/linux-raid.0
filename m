From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Maximum theoretical RAID-0 Speed
Date: Mon, 20 Dec 2004 11:08:55 +0000 (GMT)
Message-ID: <Pine.LNX.4.58.0412201056430.10850@diagnostix.dwd.de>
References: <1c4.217b364e.2ef65ba7@aol.com> <41C5CBB4.1040606@nsr500.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41C5CBB4.1040606@nsr500.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Moore <linux-raid@nsr500.net>
Cc: linux-raid <linux-raid@vger.kernel.org>, AndyLiebman@aol.com
List-Id: linux-raid.ids

On Sun, 19 Dec 2004, Tim Moore wrote:

> AndyLiebman@aol.com wrote:
> > So, as I said above,  that means I don't have any drives connected to the
> > two PCI-X 133 slots (or to the segments they correspond to) because that
> > would slow down the bus speed for those segments and presumably hurt my
> > network performance. 
> 
>   Since the PCI/133 bandwidth available is about 1GB/s and a GbE port consumes
> 100MB/s, that leaves 900MB/s for disk controllers that will only do 400MB/s.
> On the 100MHz slot you get 800MB/s.  This is the first thing to change, then
> retest.
> 
Network controllers are very interrupt intensive and can pull down the
troughput of the disk controllers due to the high interrupt rate. I remember
when I added, on a PCI-X bus that only had the disk controller, a GbE card
the performance of the disks dropped by 10-20%. Bandwith was more then
enough there.

Holger

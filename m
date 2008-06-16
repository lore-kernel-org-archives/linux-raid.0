From: Tejun Heo <tj@kernel.org>
Subject: Re: What do these SATA errors mean / kernel 2.6.25.6 (DRDY ERR/ICRC
 ABRT)
Date: Mon, 16 Jun 2008 12:52:41 +0900
Message-ID: <4855E389.10305@kernel.org>
References: <alpine.DEB.1.10.0806110608080.7726@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0806110608080.7726@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Justin Piszcz wrote:
> Never had a single error so far, powered down my host, powered it back up,
> Jun 11 05:23:24 p34 kernel: [   67.118632] mtrr: no more MTRRs available
> Jun 11 05:46:23 p34 kernel: [ 1445.288619] ata12.00: exception Emask 0x0
> SAct 0x0 SErr 0x0 action 0x2
> Jun 11 05:46:23 p34 kernel: [ 1445.288626] ata12.00: irq_stat
> 0x00060002, device error via D2H FIS
> Jun 11 05:46:23 p34 kernel: [ 1445.288632] ata12.00: cmd
> 35/00:f8:47:dc:35/00:03:02:00:00/e0 tag 0 dma 520192 out
> Jun 11 05:46:23 p34 kernel: [ 1445.288634]          res
> 51/84:f8:47:dc:35/00:03:02:00:00/e0 Emask 0x10 (ATA bus error)
> Jun 11 05:46:23 p34 kernel: [ 1445.288637] ata12.00: status: { DRDY ERR }
> Jun 11 05:46:23 p34 kernel: [ 1445.288639] ata12.00: error: { ICRC ABRT }

That's your drive reporting that it saw transmission error on the wire.


> Jun 11 06:00:32 p34 kernel: [ 2293.491350] ata1.00: exception Emask 0x0
> SAct 0x0 SErr 0x0 action 0x2 frozen
> Jun 11 06:00:32 p34 kernel: [ 2293.491360] ata1.00: cmd
> 35/00:02:43:90:7d/00:00:12:00:00/e0 tag 0 dma 1024 out
> Jun 11 06:00:32 p34 kernel: [ 2293.491362]          res
> 40/00:ff:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
> Jun 11 06:00:32 p34 kernel: [ 2293.491365] ata1.00: status: { DRDY }
> Jun 11 06:00:32 p34 kernel: [ 2293.794295] ata1: soft resetting link
> Jun 11 06:00:32 p34 kernel: [ 2293.947277] ata1: SATA link up 3.0 Gbps
> (SStatus 123 SControl 300)

And a write command timed out which is also often caused by transmission
problems.

> Nothing was broken in any of the arrays and all seems to be functioning
> now but albeit at lower speeds as you see above UDMA/100 and UDMA/133.

No, according to the log, there was no slow down.  Transmission speed is
lowered only after some number of errors have accumulated.

> Could there be a bug with the new Veliciraptors and the drivers in the
> kernel?  I never saw this happen/occur with my old raptor 150s or 74s.
> Also, I stress tested all of these drives for 8hours+ and they never had
> a problem before so it makes the problem rather peculiar.

For SATA drives, occasional transmission problems are expected even on
otherwise pretty healthy systems.  No need to worry about it too much
unless the problem repeats itself a lot.

-- 
tejun

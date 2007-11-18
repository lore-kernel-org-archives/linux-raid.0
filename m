From: Bernd Schubert <bs@q-leap.de>
Subject: Re: raid6 resync blocks the entire system
Date: Sun, 18 Nov 2007 23:18:19 +0100
Message-ID: <20071118221819.GA26053@lanczos.q-leap.de>
References: <fhq60j$an9$1@ger.gmane.org> <18240.42344.102986.988879@base.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18240.42344.102986.988879@base.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: pg_mh@mh.to.sabi.co.UK, Peter Grandi <pg_lxra@lxra.for.sabi.co.UK>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Nov 18, 2007 at 08:49:44PM +0000, pg_mh@mh.to.sabi.co.UK wrote:
> >>> On Sun, 18 Nov 2007 21:06:42 +0100, Bernd Schubert
> >>> <bernd-schubert@gmx.de> said:
> 
> bernd-schubert> Hi, on raid-initialization or later on a re-sync
> bernd-schubert> our systems become unresponsive. [ ... ] Also,
> bernd-schubert> the higher the stripe cache size, the higher the
> bernd-schubert> probability the system will go into this state.
> 
> Is either point surprising?

On a system booted over network, so without anything accessing the raid 
devices IHMO yes.

> 
> [ ... ]
> 
> bernd-schubert> Any ideas?
> 
> Well, the default Linux storage subsystem parameters are set
> usually for high throughput, not low latency. Anyhow, there is

I don't speak about low latency, but latency of at least 24h is a bit high,
isn't it? Linux is a multi-tasking system, even with high load it has to 
respond to keyboard input, especially when there are 8 CPUs with 4 of them
in idle state (almost 4 used for sync processes).

> another interesting point, which is how many disks in that RAID6
> array? What is the system bus and host adapter to the disk bus?

6 x Infortrend A16U-G2430 (hardware raid 6) on 3 dual-channel LSI22320 HBAs 
in U320 mode, so eventually we have raid66. Since linux-raid is presently
not multi-threaded the the CPU would limit raid6 write performance to 
200MB/s. Since we do have 8 CPUs, we have made 3 partions of each A16U-G2430,
so in the end we have 3 x software-raid6.

I know this is a high end configuration, but no latency critical component
is at any limit, 4 CPUs are idling, PCI-X busses are 
far away from being saturated. 


Cheers,
Bernd



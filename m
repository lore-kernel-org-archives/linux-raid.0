From: Ming Zhang <mingz@ele.uri.edu>
Subject: RE: raid0 low performance
Date: Tue, 05 Jul 2005 09:19:47 -0400
Message-ID: <1120569587.5535.7.camel@localhost.localdomain>
References: <Pine.LNX.4.44.0507042009340.16047-100000@coffee.psychology.mcmaster.ca>
	 <1120523217.5459.20.camel@localhost.localdomain>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120523217.5459.20.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

With this

-[00]-+-00.0  8086:2578
      +-03.0-[01]----01.0  8086:1075
      +-1c.0-[02]--+-01.0  11ab:5081
      |            +-03.0  9005:00c0
      |            +-03.1  9005:00c0
      |            \-04.0  11ab:5041
      +-1e.0-[03]--+-09.0  1002:4752
      |            \-0a.0  8086:1076
      +-1f.0  8086:25a1
      +-1f.1  8086:25a2
      +-1f.2  8086:25a3
      \-1f.3  8086:25a4

i tried to tune the latency-timer on 02:01.0 02:04.0 and 00:1c.0
individually or both. tried 40, 60, 80. no luck.

so i think it is the driver or card fault. :) thanks anyway.

ming

On Mon, 2005-07-04 at 20:26 -0400, Ming Zhang wrote:
> On Mon, 2005-07-04 at 20:13 -0400, Mark Hahn wrote:
> > > # ./lspci -vv -d 11ab:
> > > 02:01.0 Class 0100: 11ab:5081 (rev 03)
> > >         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> > > ParErr- Stepping- SERR- FastB2B-
> > >         Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> > > <TAbort- <MAbort- >SERR- <PERR-
> > >         Latency: 32, cache line size 08
> > 
> > latency 32 is quite low; this parameter effects how long the device
> > can hold onto the bus.  try
> > 	setpci -s 02:01.0 latency_timer=80
> 
> thanks a lot for this and i will test it tomorrow.
> 
> > and see whether it improves things.  I'm unclear on whether a bridged device
> > also needs the bridge's latency setting changed.
> > 
> > >         Latency: 32, cache line size 08
> > 
> > also low.  I'm guessing that your bios is tuned for desktop use - some audio
> > setups need low latency settings.
> > 
> yes, i guess so, the only drawback of this box is that i am using a
> entry level server box. so its chipset is quite weak and the setting i
> left as default.
> 
> 
> Ming
> 


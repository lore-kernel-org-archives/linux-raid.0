From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: RE: raid0 low performance
Date: Mon, 4 Jul 2005 20:13:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.44.0507042009340.16047-100000@coffee.psychology.mcmaster.ca>
References: <1120226073.5501.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120226073.5501.13.camel@localhost.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Zhang <mingz@ele.uri.edu>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> # ./lspci -vv -d 11ab:
> 02:01.0 Class 0100: 11ab:5081 (rev 03)
>         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV+ VGASnoop-
> ParErr- Stepping- SERR- FastB2B-
>         Status: Cap+ 66Mhz+ UDF- FastB2B+ ParErr- DEVSEL=medium >TAbort-
> <TAbort- <MAbort- >SERR- <PERR-
>         Latency: 32, cache line size 08

latency 32 is quite low; this parameter effects how long the device
can hold onto the bus.  try
	setpci -s 02:01.0 latency_timer=80
and see whether it improves things.  I'm unclear on whether a bridged device
also needs the bridge's latency setting changed.

>         Latency: 32, cache line size 08

also low.  I'm guessing that your bios is tuned for desktop use - some audio
setups need low latency settings.


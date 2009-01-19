From: Bernd Schubert <bs@q-leap.de>
Subject: Re: Raid6 write performance
Date: Mon, 19 Jan 2009 11:58:43 +0100
Message-ID: <200901191158.44822.bs@q-leap.de>
References: <49742E74.9090502@rabbit.us> <497457D7.90101@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <497457D7.90101@rabbit.us>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Peter,

On Monday 19 January 2009 11:37:11 Peter Rabbitson wrote:
> Peter Rabbitson wrote:
> > Hi,
> >
> > I am experimenting with raid6 on 4 drives on 2.6.27.11. The problem I am
> > having is that no matter what chunk size I use, the write benchmark
> > always comes out at single drive speed, although I should be seeing
> > double drive speed (read speed is at near 4x as expected).
>
> Please disregard this, I appear to be having some sort of weird hardware
> congestion. Can someone explain what could be going on?

I don't know what it is going on, but:


> Combined read speed - limited by the width of a 32bit 66mhz PCI (dev
> 02:04.0 below)

No! You you do have PCI-X, so 64bit with 66MHz. Maybe you are even luckily and 
it is as 133MHz, depends on how many other devices are connected to this bus. 
lspci will always say it is running at 66MHz, though, it also might run at 
100 or 133 MHz,

>
> 02:03.0 Mass storage controller: Silicon Image, Inc. SiI 3124 PCI-X
> Serial ATA Controller (rev 02)  <----- where the 4 drives are attached to
> 	Subsystem: Silicon Image, Inc. SiI 3124 PCI-X Serial ATA Controller
> 	Flags: bus master, stepping, 66MHz, medium devsel, latency 64, IRQ 25
> 	Memory at fc5fd800 (64-bit, non-prefetchable) [size=128]
> 	Memory at fc5f0000 (64-bit, non-prefetchable) [size=32K]
> 	I/O ports at bc00 [size=16]
> 	Expansion ROM at fc480000 [disabled] [size=512K]
> 	Capabilities: [64] Power Management version 2
> 	Capabilities: [40] PCI-X non-bridge device
> 	Capabilities: [54] Message Signalled Interrupts: Mask- 64bit+ Queue=0/0


Cheers,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH

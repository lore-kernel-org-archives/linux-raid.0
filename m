From: Bernd Schubert <bs@q-leap.de>
Subject: Re: Raid6 write performance
Date: Mon, 19 Jan 2009 12:08:12 +0100
Message-ID: <200901191208.13591.bs@q-leap.de>
References: <49742E74.9090502@rabbit.us> <200901191158.44822.bs@q-leap.de> <49745D91.8010802@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49745D91.8010802@rabbit.us>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 19 January 2009 12:01:37 Peter Rabbitson wrote:
> Bernd Schubert wrote:
> > Hello Peter,
> >
> > On Monday 19 January 2009 11:37:11 Peter Rabbitson wrote:
> >> Peter Rabbitson wrote:
> >>> Hi,
> >>>
> >>> I am experimenting with raid6 on 4 drives on 2.6.27.11. The problem I
> >>> am having is that no matter what chunk size I use, the write benchmark
> >>> always comes out at single drive speed, although I should be seeing
> >>> double drive speed (read speed is at near 4x as expected).
> >>
> >> Please disregard this, I appear to be having some sort of weird hardware
> >> congestion. Can someone explain what could be going on?
> >
> > I don't know what it is going on, but:
> >> Combined read speed - limited by the width of a 32bit 66mhz PCI (dev
> >> 02:04.0 below)
> >
> > No! You you do have PCI-X, so 64bit with 66MHz. Maybe you are even
> > luckily and it is as 133MHz, depends on how many other devices are
> > connected to this bus. lspci will always say it is running at 66MHz,
> > though, it also might run at 100 or 133 MHz,
>
> And on the same bus (the last lspci) I have:
>
> 02:04.0 Ethernet controller: Intel Corporation 82541PI Gigabit Ethernet
> Controller (rev 05)
> 	Subsystem: Intel Corporation PRO/1000 GT Desktop Adapter
> 	Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 26
> 	Memory at fc5a0000 (32-bit, non-prefetchable) [size=128K]
> 	Memory at fc580000 (32-bit, non-prefetchable) [size=128K]
> 	I/O ports at b000 [size=64]
> 	Expansion ROM at fc460000 [disabled] [size=128K]
> 	Capabilities: [dc] Power Management version 2
> 	Capabilities: [e4] PCI-X non-bridge device
> 	Kernel driver in use: e1000
>
> which afaik brings everything to 32bits no?

Hmm, I don't know what happens if a 32-bit card is in a 64bit PCI-X bus. 
Wouldn't it only use half of the available lines for this card and all lines 
for the 64bit cards?  Hmm, on the other hand your maximum combined rate seems 
to be at around 240 MB/s, which is close to 32bit x 66 MHz.Any chance you can 
remove this NIC and retest?


Cheers,
Bernd

-- 
Bernd Schubert
Q-Leap Networks GmbH

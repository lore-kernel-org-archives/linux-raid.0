From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Fw: DriveReady SeekComplete problems
Date: Mon, 13 May 2002 07:01:28 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0205130659440.2333-100000@uplift.swm.pp.se>
References: <003401c1fa38$6e3ba600$050010ac@niunia.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003401c1fa38$6e3ba600$050010ac@niunia.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 12 May 2002, Artur Jasowicz wrote:

> > Anyone know if I can force the kernel to not share interrupts.
> I think that Highpoint chip only uses one IRQ for both channels, but it
>
> might be helpfull to move your SCSI card's IRQ to another slot.

How?

> Is your CPU usage also close to 100% when using RAID?

Nope, I barely have any CPU usage at all. If you turn off DMA though, I am 
not surprised you have high CPU usage problems.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se


From: "Artur Jasowicz" <arturj@mousebusiness.com>
Subject: Re: Fw: DriveReady SeekComplete problems
Date: Sun, 12 May 2002 23:41:10 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <003401c1fa38$6e3ba600$050010ac@niunia.org>
References: <Pine.LNX.4.44.0205121022520.2333-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Anyone know if I can force the kernel to not share interrupts.
I think that Highpoint chip only uses one IRQ for both channels, but it
might be helpfull to move your SCSI card's IRQ to another slot.

> Currently I have stability problems with the box, if I use the ide2 and
> ide3 drives a lot the machine freezes.
If your DMA is on on the Highpoint drives, this might cause lockups. That's
what I was getting with another machine I have. It is a M571 mobo (Chinese
cheapo generic crap) with two IWills driving four 80 GB Maxtors in RAID 5.
As long as DMA was on, I couldn't complete syncing array after configuring
it. Contstant lockups. After I did hdparm -d 0 /dev/hd[e,g,i,k] the arrays
synced and seem to be working correctly now. I need to develop a way of
checking for data corruption. Of course the price is the speed. With DMA on
I was getting 2000K/s syncing speed. without DMA - 800K. I am running plain
RH 7.2 on this machine. It may be worth trying hdparm -X to set drives to a
slower DMA, although this is just a patch, not a solution. Before trying to
use this configuration I had a single IWill with two Maxtors in RAID1.
Worked without a glitch. I wish I remembered if the controlled had it's own
IRQ. Although I doubt it. I was running RH 7.1 back then.

Is your CPU usage also close to 100% when using RAID?

Artur


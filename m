From: Gordon Henderson <gordon@drogon.net>
Subject: Re: [PATCH md 2 of 4] Fix raid6 problem
Date: Mon, 14 Feb 2005 08:09:55 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0502140806240.29594@lion.drogon.net>
References: <200502031743.j13Hha910546@www.watkins-home.com> <42026860.1000409@zytor.com>
 <Pine.LNX.4.56.0502031822160.9028@lion.drogon.net> <200502040904.38264.andrew@walrond.org>
 <Pine.LNX.4.56.0502041031470.29133@lion.drogon.net> <42102DC2.3030004@nsr500.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
In-Reply-To: <42102DC2.3030004@nsr500.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Moore <tim.moore@nsr500.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 13 Feb 2005, Tim Moore wrote:

> Gordon Henderson wrote:
> > What I wanted was an 8-way RAID-1 for the boot partition (all of /, in
> > reality) and I've done this many times in the past on other 2-5 way
> > systems without issue. So I do the stuff I've done in the past, and theres
> > nothing really new to me in that respect. (I'm using LILO) So when I try
> > to get it to boot off the md device, it boots and says LIL and then
> > nothing more. (Lilo diagnostics interpret this as a media failure, or
> > geometry mismatch) If I make it boot off /dev/sda1 then it would work.
>
> We put /boot on 100MB /dev/sda1 partition, rest of drive is md.  Lilo
> script section does
> dd if=/dev/sda of=/boot/boot446.sda bs=446 count=1 && \
> fdisk -l /dev/sda > /boot/fdisk.sda && \
> dd if=/dev/sda1 of=/dev/sdb1
> every time a new kernel is built.  Recovery is much easier without RAID
> involved (lilo 22.6).  I've considered manipulating the boot block/disk
> label on copy so that it would boot off any off sda1 or sdb1 transparently.

It's now booting off a 32MB flash IDE drive thing which is mounted
read-only under /boot. I have lilo remount it r/w the do its stuff, then
remount it r/o again. I could boot it OK under raid-1 off the 4 drives on
the on-board controller. As soon as I plugged in PCI disk contorllers it
all goes pear-shaped. This motherboard & bios and serious issues with more
than 4 SATA disks.

> Flashing from 1.x to 2.02b, same problem.  Power off, pull plug, pull
> both power connectors off mobo, wait 15 seconds, clear CMOS for 15
> seconds, reboot, reset BIOS, no worries.

I re-flashed one board to 2.02b - it helps in that the system doesn't
lock-hard with one make of 3112 card, but the other make still can cause a
hard lockup. I also seem to have lose the use of PCI slots 3 and 4 with
this new BIOS. One board died during re-flashing, so it's gone back.

Gordon

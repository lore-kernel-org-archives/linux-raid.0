From: Gordon Henderson <gordon@drogon.net>
Subject: Re: Weird RAID 1 performance
Date: Sun, 19 Sep 2004 16:50:17 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0409191635550.30137@lion.drogon.net>
References: <Pine.LNX.4.44.0409191043350.2576-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0409191043350.2576-100000@coffee.psychology.mcmaster.ca>
To: Mark Hahn <hahn@physics.mcmaster.ca>
Cc: Andrei Badea <andrei.badea@movzx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 19 Sep 2004, Mark Hahn wrote:

> > > few to 99 percent (but usually is roughly rovers around 50 percent).
> > > Moreover, the transfer regularly stops for a few seconds (the CPU usage
> > > is then about 2 percent). The average data transfer rate was 16 MB/s,
> > > while the disks alone can make almost 25 MB/s.
>
> sounds a bit like a combination of poor VM (certainly the case for
> the VM in some kernels), and possibly /proc/sys/vm settings.
>
> > The next thing to look for is interrupt sharing. I've found a lot of
>
> I doubt this is an issue - shared interrupts can result in a few
> extra IOs per interrupt (as the wrong driver checks its device),
> but I'd be very surprised to find this affecting performance unless
> the device is very slow or the irq rate very high (1e5 or so).

I'm just saying what I've seen in some of the servers I've built. Same
hardware, same kernel (2.4.23 to 27) but with different positioning of
boards in various PCI slots and trying to shuffle them about to reduce the
number of devices on the same interrupt, I can make things work better, or
worse.

> > > Is this normal behavior? Can the write performance be tuned (to be less
> > > "jumpy")?
>
> certainly.  in 2.4 kernels, it was trivial to set bdflush to wake up
> every second, rather than every 5 seconds (the default).  I do this
> on a fairly heavily loaded fileserver, since the particular load
> rarely sees any write-coalescing benefit past a few ms.
>
> > Interupts (and/or more likely the controllers) seem to me to be the
> > biggest bug/feature of a modern motherboard )-: I've seen systems work
>
> modern low-end motherboard, perhaps.

Perhaps. (But we don't know what the OPs motherboard is either) The
servers I have had probems with were dual athlon motherboards which
supported ECC ram. I don't know what make they were as I wasn't involved
in the purchasing side of things )-: I do know that when I try to get as
many devices on their own interrupt as possible in these motherboards,
things go remarkably better.

I've seen incrementing ERR interrupts in single processor systems (ASUS
A7N266 and A7N8X) until you turn the APIC off too.

I've seen some very bizarre hardware issues though. One of the above dual
athlon servers has a motherboard that needs to have a mouse plugged in to
make it work. It doesn't use the mouse (it's inside the case!) but if it's
not plugged in, it croaks after a while. (And always during an fsck for
some weird reason) (This we found by scanning the net for hardware issues
with the particular chipset on the motherboard)

Go figure!

Gordon

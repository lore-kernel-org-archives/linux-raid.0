From: Mark Hahn <hahn@physics.mcmaster.ca>
Subject: Re: Weird RAID 1 performance
Date: Sun, 19 Sep 2004 11:32:24 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0409191043350.2576-100000@coffee.psychology.mcmaster.ca>
References: <Pine.LNX.4.56.0409191001390.30137@lion.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0409191001390.30137@lion.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: Andrei Badea <andrei.badea@movzx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > I have a RAID 1 whose write performance I tested by writing a 10 GB file

but under which kernel?

> > Looking at GKrellM I noticed the CPU usage is very jumpy, going from a

that's some sort of gui monitoring tool, right?  I usually use 
"setrealtime vmstat 1" for this kind of thing, since it's at least 
a layer or two closer to the true numbers.

> > few to 99 percent (but usually is roughly rovers around 50 percent).
> > Moreover, the transfer regularly stops for a few seconds (the CPU usage
> > is then about 2 percent). The average data transfer rate was 16 MB/s,
> > while the disks alone can make almost 25 MB/s.

sounds a bit like a combination of poor VM (certainly the case for 
the VM in some kernels), and possibly /proc/sys/vm settings.

> The next thing to look for is interrupt sharing. I've found a lot of

I doubt this is an issue - shared interrupts can result in a few 
extra IOs per interrupt (as the wrong driver checks its device),
but I'd be very surprised to find this affecting performance unless
the device is very slow or the irq rate very high (1e5 or so).

> > Is this normal behavior? Can the write performance be tuned (to be less
> > "jumpy")?

certainly.  in 2.4 kernels, it was trivial to set bdflush to wake up 
every second, rather than every 5 seconds (the default).  I do this 
on a fairly heavily loaded fileserver, since the particular load 
rarely sees any write-coalescing benefit past a few ms.

> Interupts (and/or more likely the controllers) seem to me to be the
> biggest bug/feature of a modern motherboard )-: I've seen systems work

modern low-end motherboard, perhaps.

> > Maybe the RAID 1 is just not suited for video capture?

it's fine; the problem, if any, is your config.  what's the bandwidth
you need to write?  what's the bandwidth of your disks (after accounting
for the fact that every block is written twice)?  you should have a couple
seconds of buffer, at least, to "speed-match" the two rates, even if 
your producer (capture) is significantly slower than the bandwidth of 
your raid1.  note also that your capture card could well be eating 
lots of cpu and/or perturbing the kernel's vm.

regards, mark hahn.


From: TJ <systemloc@earthlink.net>
Subject: Re: Looking for the cause of poor I/O performance
Date: Fri, 3 Dec 2004 01:51:25 -0500
Message-ID: <200412030151.25278.systemloc@earthlink.net>
References: <Pine.LNX.4.44.0412021919400.21152-100000@coffee.psychology.mcmaster.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0412021919400.21152-100000@coffee.psychology.mcmaster.ca>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Mark Hahn <hahn@physics.mcmaster.ca>
List-Id: linux-raid.ids

> such a machine was good in its day, but that day was what, 5-7 years ago?
> in practical terms, the machine probably has about 300 MB/s of memory
> bandwidth (vs 3000 for a low-end server today).  further, it was not
> uncommon for chipsets to fail to cache then-large amounts of RAM (32M was a
> common limit for caches configured writeback, for instance, that would
> magically cache 64M if set to writethrough...)

You are clearly right that the memory bandwidth is lower than a modern 
machine. However, I do feel that the disk I/O still should be much better 
with this limitation. Doing a straight read operation as hdparm -tT does, the 
300 MB/s memory bandwidth should allow for better performance than this. 
Guy's numbers with an oldish P3 box validate me.

Additionally, unless you're talking about a box with 64 bit PCI, PCI-X, or PCI 
Express, the PCI bus is going to be a severely limiting factor compared to 
the memory bus. While the box could do more memory I/O, a disk-bound read 
operation should be limited by the PCI bandwidth on either a new machine, or 
this machine.

> with a modern kernel, manual hdparm tuning is unnecessary and probably
> wrong.

I understand why setting dma and the like is probably unnecessary. For RAID 
arrays, I would think that setting up readaheads, and sound management levels 
with hdparm, and setting kernel readahead parameters in the fs settings would 
be advantageous.

> > To tune these drives, I use:
> > hdparm -c3 -d1 -m16 -X68 -k1 -A1 -a128 -M128 -u1 /dev/hd[kigca]
>
> if you don't mess with the config via hdparm, what mode do they come up in?
> iirc, the 75GXP has a noticably lower density (and thus bandwidth).

Granted, so why on earth would it perform similarly with hdparm -tT? Even more 
confusing, how could it best the newer WD 400JB?

> > /dev/hda:  Timing buffered disk reads:   42 MB in  3.07 seconds =  13.67
> > MB/sec /dev/hdc:  Timing buffered disk reads:   44 MB in  3.12 seconds = 
> > 14.10 MB/sec
>
> not that bad for such a horrible controller (and PCI, CPU, memory system)

So you do think that the VIA controller is inferior?

> > /dev/md0:  Timing buffered disk reads:   70 MB in  3.07 seconds =  22.77
> > MB/sec /dev/md1:  Timing buffered disk reads:   50 MB in  3.03 seconds = 
> > 16.51 MB/sec
>
> since the cpu/mem/chipset/bus are limiting factors, raid doesn't help.

Those low raid numbers do seem to suggest that, wouldn't it..

> keeping a K6 alive is noble and/or amusing, but it's just not reasonable to
> expect it to keep up with modern disks.  expecting it to run samba well is
> not terribly reasonable.
>
> plug those disks into any entry-level machine bought new (celeron, sempron)
> and you'll get whiplash.  plug those disks into a proper server
> (dual-opteron, few GB ram) and you'll never look back.  in fact,
> you'll start looking for a faster network.

I disagree, but I must admit that this is a possibility. My desktop machine is 
an Athlon XP 1700+, 512 MB ram, running at 266MHz DDR bus. It's a class over 
the K6 easily, with a much better memory subsystem. I could dump all the 
drives and controllers onto it and run the same tests using the same kernel 
and everything and record the numbers. Do you feel this would prove or 
disprove the idea that the box is just underpowered?

TJ Harrell

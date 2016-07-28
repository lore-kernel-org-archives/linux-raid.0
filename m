From: Doug Dumitru <doug@easyco.com>
Subject: Re: RAID5 Performance
Date: Thu, 28 Jul 2016 11:45:29 -0700
Message-ID: <CAFx4rwRgZpXtXWh5UHud6TGMubzch9Zr78JZdj3Rz8CeKRNpPg@mail.gmail.com>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
 <22424.50313.900162.715200@tree.ty.sabi.co.uk> <CAFx4rwSRYDACX631eLpX7Jr9jB2u4jbC7dr-0rdi9U1nV9og3Q@mail.gmail.com>
 <22425.63565.439521.592849@tree.ty.sabi.co.uk> <22426.2167.369879.756599@tree.ty.sabi.co.uk>
 <a0921a51-d841-7fbd-0f31-21f5ba8c6f4b@websitemanagers.com.au> <22426.16080.579831.750402@tree.ty.sabi.co.uk>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <22426.16080.579831.750402@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.to.sabi.co.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

... boy this thread is getting long.

A couple of points.

* I am one of a reasonably small group of people that have actually
written an FTL and have it in production use.  FTLs in SSDs are some
of the most closely guarded "implementations" I have ever seen.  I am
not sure if my FTL matches others, as I have not seen the others, but
the patent office thinks my version is unique enough (not that it
really matters).

* Many SSDs, even consumer models, and even models without battery
backup, usually enforce correct serialization.  If you have a single
drive in a laptop, this is what is important.  If you have an array in
a server, and if the power to the SSDs are protected, then this also
protects your data.  You need to separate the failures you are trying
to protect.  SuperCaps on an SSD that is behind redundant power
supplies on redundant UPSs is perhaps not the best place to spend your
money.  Likewise, if you have an HA link, the write is not ACKed until
the other node gets the data at least into the memory buffer.  Are you
trying to engineer against multiple failures at multiple sites.  You
need to decide on the level of redundancy of redundancy of redundancy.

* Assumptions that FTLs wear sync writes at the ratio of the write
block to the erase block sizes are usually wrong.  Older "dumb" flash
like CF and SD cards sometimes work like this, but even there they
have gotten better.  An easier assumption is that "normal" SSDs will
have write amplification at the inverse of free space percentage.  So
your consumer drive with 8% free has 1/.08=12.5:1 write amplification.
This is why data center drives have more free space.  "Better" FTLs,
when working with 100% random workloads can lower this to just over
50% of this value.  My FTL sees 5.45:1 write amp on a 100% random
workload steady state at 10% free.

* Real workloads are sometimes that same as random workloads and
sometimes very different.  Some FTLs can exploit the patterns in a
real file system workload and some cannot.  For example, my FTL sees
1.3:1 write amp with the JEDEC 128GB client trace at 10% free versus
the typical 9:1 for most consumer SSDs on the same trace with about
the same free space.

* Additional games are possible if you start to reach "into" the
blocks.  Compression that only saves you 10% might not seem like much,
but if it moves the free space from 8% to 18%, it matters a lot.  The
above examples were without compression.  Compression can also make
file system write overhead "go away".  It is not uncommon for a
journal and directory entry write to compress 80+% even though the
data is binary.  This makes old hard drive optimizations like
"-noatime" unnecessary.

* You can do a lot more with an FTL if you move it "in front" of raid.
This basically eliminates the raid read/modify/write operation and
overhead entirely.  It does introduce a new "write hole" aspect to the
array, but this can be plugged with nvRAM hardware.

Happy Hunting.

Doug Dumitru

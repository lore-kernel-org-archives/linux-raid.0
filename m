From: Miquel van Smoorenburg <miquels@cistron.net>
Subject: Software raid5 inefficiencies
Date: Fri, 29 Oct 2004 22:24:38 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1099088678l.12509l.1l@stargazer.cistron.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	Format=Flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been playing with software raid5 on a heavily loaded newsserver.

This machine is part of a diablo setup, and basically it's a
database server for usenet articles.

All articles are stored in multiple multi-megabyte sized files on
the filesystem. When a client asks for data (an article, average
300 KB) the location is looked up in a (fast, cached in memory)
database, the file is opened, the server seeks to the offset of
the article and the 300KB is served to the client.

Because many clients are connecting to the server simultaneously,
it's better to use a large stripe size - a stripe size smaller
than 600 KB means that to serve one request, multiple disks need
to seek, and since the clients are higly parallel and the data
is spread randomly over the disks, that is bad. You want to serve
each read request from one disk.

So I'm using a stripe size of 4 MB.

Now it works fine but I'm hitting a few bottlenecks:

1. In this case, for every 4K read I need a stripe_head. So the
   standard NR_STRIPES = 256 is way to low. I increased
   NR_STRIPES to 1024 and that helps, but with 7 disks it
   uses 29 MB of unswappable kernel memory (and 2048 is even
   better but uses 58 MB). With 2 RAID5 devices this adds up.

2. With a heavy read load, on this PIV/3Ghz system time used
   reaches 95% just reading from the raid5 device, and I can't
   read faster than about 50-60 MB/sec. From oprofile, the
   bottleneck appears to be raid5.c::copy_data()

The solution, I think, is:

1. Do not allocate sh->dev[ALL].page when requesting a stripe_head-
   just allocate them for the devices we actually need to read/write.
   Keep the pages on a seperate LRU.

2. Do not copy read data into the stripe_head at all when just
   reading data - just remap the BIOs like dm does. You only need
   to copy the data from/to the stripe_head when the same part of
   the device is being written to, or is in degraded mode.

This should boost performance in normal circumstances a lot, I
think. Is anyone working on this yet ? Comments, flames ?

[please keep the cc, I'm not on the list]

Mike.


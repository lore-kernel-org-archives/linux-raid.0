From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: unbelievably bad performance: 2.6.27.37 and raid6
Date: Sat, 31 Oct 2009 10:55:50 -0500
Message-ID: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a 4 disk raid6. The disks are individually capable of (at
least) 75MB/s on average.
The raid6 looks like this:

md0 : active raid6 sda4[0] sdc4[5] sdd4[4] sdb4[6]
      613409536 blocks super 1.1 level 6, 64k chunk, algorithm 2 [4/4] [UUUU]

The raid serves basically as an lvm physical volume.

While rsyncing a file from an ext3 filesystem to a jfs filesystem, I
am observing speeds in the 10-15MB/s range.
That seems really really slow.

Using vmstat, I see similar numbers (I'm averaging a bit, I'll see
lows of 6MB/s and highs of 18-20MB/s, but these are infrequent.)
The system is, for the most part, otherwise unloaded.

I looked at stripe_cache_size and increased it to 384 - no difference.
blockdev --getra reports 256 for all involved raid components.
I'm using the deadline I/O scheduler.

Am I crazy?  Is 12.5MB/s (average) what I should expect, here?  What
might I look at here?

-- 
Jon

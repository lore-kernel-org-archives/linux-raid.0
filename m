From: Jeff Breidenbach <jeff@jab.org>
Subject: Re: split RAID1 during backups?
Date: Sat, 29 Oct 2005 20:06:54 -0700
Message-ID: <E1EW3X4-0005gu-00@toko.jab.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Thanks to good advice from many people, here are my findings and
conclusions.

(1) Splitting the RAID works. I have now implemented this technique on
the production system and am making a backup right now.

(2) NBD is cool, works well on Debian, and is very convenient. A
couple experiments suggest it may be slower compared to netcat for
blasting data across the network. By slower, I mean less throughput to
the point where the network can become a bottleneck. I don't have
conclusive data yet, so take with a large grain of salt. I am using
netcat for now.

(3) End-to-end throughput is not quite as high as I'd hoped.  At this
point it appears the limiting factor is the speed (throughput) of the
destination disks. During earlier testing, I had been dumping bits to
/dev/null on the destination machine instead of the actual destination
partition. No worries, this can be addressed.

(4) I'll play with fancier options like "write-mostly" when Debian
releases a 2.6.13 kernel, and when I'm convinced that I'm not going
accidentally introduce slower disks into the RAID and bog the entire
system down for writes.

>sendfile() bypasses the copy to user buffer, which in turn will bypass
>copy to system buffers, which eliminates contention for buffer space. Use
>vmstat to check, if you have a lot of system time and lots of space in
>buffers of various kinds, there's a good possibility that the problem is
>there.

I use the -d option in dd_rescue, which invokes O_DIRECT and therefore
doesn't trash Linux's disk buffer. Unfortunately because of the very
random access patterns of the web server, cache misses are extremely
common anyway.

Cheers,
Jeff

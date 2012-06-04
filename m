From: Ole Tange <ole@tange.dk>
Subject: Software RAID checksum performance on 24 disks not even close to
 kernel reported
Date: Tue, 5 Jun 2012 01:14:06 +0200
Message-ID: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On my new 24 disk array I get 900 MB/s of raw read or write using `dd`
to all the disks.

When I set the disks up as a 24 disk software RAID6 I get 400 MB/s
write and 600 MB/s read. It seems to be due to checksuming, as I have
a single process (md0_raid6) taking up 100% of one CPU.

It seems, however, that the performance of the checksumming is heavily
dependent on how many disks are in the RAID and how big the chunk size
is.

That makes sense, as the CPU can compute the checksum faster if the
whole stripe (i.e. one chunk for each disk) can be fit into the CPU
cache.

I tested this by creating 24 devices in RAM, used different chunk
sizes, and then copied the linux kernel source. Test script can be
found on http://oletange.blogspot.dk/2012/05/software-raid-performance-on-24-disks.html

By doing it in RAM the results are not affected by physical disks or
disk controller. So the only change is the speed of computing
checksums. This can also be seen as the time the process md0_raid0 is
running.

The results were:

Chunk size	Time to copy 10 linux kernel sources as files	Time to copy
10 linux kernel sources as a single tar file
16	32s	13s
32	32s	19s
64	31s	11s
128	39s	13s
256	43s	11s
4096	1m38s	16s

It makes sense that it is faster to copy 10 big files than 10 times
the same size in small files - especially on RAID6 where you have to
read from disk if you do not write a full stripe. So the difference
for the big files is minimal.

For the small files the difference is more pronounced. Any chunk size
over 64k gives a performance penalty.

But I cannot explain why even the best performance (4600 MB/11s = 420
MB/s) is not even close to the checksum performance reported by the
kernel at boot (6196 MB/s):

    Mar 13 16:02:42 server kernel: [   35.120035] raid6: using
algorithm sse2x4 (6196 MB/s)

Can you explain why I only get 420 MB/s of real world checksumming
instead of 6196 MB/s?


/Ole
-- 
Have you ordered your GNU Parallel merchandise?
https://www.gnu.org/software/parallel/merchandise.html

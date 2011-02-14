From: Andras Korn <korn@raidlist.elan.rulez.org>
Subject: write-behind has no measurable effect?
Date: Mon, 14 Feb 2011 22:38:17 +0100
Message-ID: <20110214213817.GG836@hellgate.intra.guy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I experimented a bit with write-mostly and write-behind and found that
write-mostly provides a very significant benefit (see below) but
write-behind seems to have no effect whatsoever.

This is not what I expected and I wonder if I missed something.

I built a RAID1 array from a 64GB Corsair SSD and two 7200rpm SATA hard
disks. I created xfs on the array, then benchmarked it using bonnie++,
iozone and by compiling linux 2.6.37 (with allyesconfig).

Some interesting benchmark results follow. I used a 2.6.38-rc2 kernel for
these measurements.

First, the stats that were identical (within a reasonable margin of error)
across all measurements:

bonnie++ blockwise sequential write: ~110MB/s
bonnie++ blockwise sequential rewrite: ~60MB/s
bonnie++ blockwise sequential read: ~160-175MB/s
iozone read, 16k block size: ~135MB/s
kernel compilation time, user: ~5450s (*)
kernel compilation time, system: 570s (*)

(*) I didn't measure kernel compilation times without write-mostly; I expect
they would've been worse.

Now for some of the measurements that resulted in (to me) surprising
differences:

Using just the SSD (so no RAID), xfs mounted with
"noatime,noikeep,attr2,logbufs=8,logbsize=256k":

bonnie++ seeks/s: 7791
iozone random read, 16k block size: ~46MB/s
iozone random write, 16k block size: ~44MB/s
iozone random read, 512k block size: ~130MB/s
iozone random write, 512k block size: ~140MB/s
wall clock kernel compile time: 887s

RAID1 from two disks and one SSD, the disks set to write-behind:

mdadm --create /dev/md/ssdraid --force --assume-clean --level=1 \
--raid-devices=3 --bitmap=internal --bitmap-chunk=262144 \
/dev/sdo2 --write-behind=16383 -W /dev/sd[nm]2

xfs mount options:
noatime,logbsize=256k,logbufs=8,noikeep,attr2,nodiratime,delaylog

bonnie++ seeks/s: 2087
iozone random read, 16k block size: ~43MB/s
iozone random write, 16k block size: ~3.7MB/s
iozone random read, 512k block size: ~126MB/s
iozone random write, 512k block size: ~69MB/s
wall clock kernel compile time: 936s

(Note the drastically reduced random write performance.)

Now the same setup, but with write-behind=0:

bonnie++ seeks/s: 1843
iozone random read, 16k block size: ~48MB/s
iozone random write, 16k block size: ~3.7MB/s
iozone random read, 512k block size: ~126MB/s
iozone random write, 512k block size: ~69MB/s
wall clock kernel compile time: 935s

So, the difference between write-behind=0 and write-behind=16383 (which
seems to be the maximum) is negligible (if not imaginary).

For reference, some results with even write-mostly disabled:

bonnie++ seeks/s: 487.4
iozone random read, 16k block size: ~3.7MB/s
iozone random write, 16k block size: ~3.7MB/s
iozone random read, 512k block size: ~58MB/s
iozone random write, 512k block size: ~69MB/s

(The full result set is available from
<http://elan.rulez.org/~korn/tmp/iobench.ods>, 27k.)

It's easy to see from the results that write-mostly does as advertised:
reads are mostly served by the SSD, so that random reads are approximately
as fast as when I only used the SSD.

I'd have expected write-behind to increase the apparent random write
performance though, and this didn't happen (there was no measurable
difference).

I thought maybe the iozone benchmark was too synthetic (too many writes in
too short a time, so that the buffer effect of write-behind is lost); that's
why I tried the kernel compilation, but I the raid array was as slow with
write-behind as without it.

Any idea why write-behind doesn't seem to have an effect?

Thanks

Andras

-- 
                     Andras Korn <korn at elan.rulez.org>
                 Keep your ears open - but your legs crossed.

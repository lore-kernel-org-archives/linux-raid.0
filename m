From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid10: unfair disk load?
Date: Fri, 21 Dec 2007 14:53:38 +0300
Message-ID: <476BA942.40406@msgid.tls.msk.ru>
References: <476BA4FD.6080401@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <476BA4FD.6080401@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Tokarev wrote:
> I just noticed that with Linux software RAID10, disk
> usage isn't equal at all, that is, most reads are
> done from the first part of mirror(s) only.
> 
> Attached (disk-hour.png) is a little graph demonstrating
> this (please don't blame me for poor choice of colors and
> the like - this stuff is in works right now, it's a first
> rrd graph I produced :).  There's a 14-drive RAID10 array
> and 2 more drives.  In the graph it's clearly visible that
> there are 3 "kinds" of load for drives, because graphs for
> individual drives are stacked on each other forming 3 sets.
> One set (the 2 remaining drives) isn't interesting, but the
> 2 "main" ones (with many individual lines) are interesting.

Ok, looks like vger.kernel.org dislikes png attachments.
I wont represent graphs as ascii-art, and it's really not
necessary -- see below.

> The 7 drives with higher utilization receives almost all
> reads - the second half of the array only gets reads
> sometimes.  And all 14 drives - obviously - receives
> all writes.
> 
> So the picture (modulo that "sometimes" above which is
> too small to take into account) is like - writes are
> going to all drives, while reads are done from the
> first half of each pair only.
> 
> Also attached are two graphs for individual drives,
> one is from first half of the array (diskrq-sdb-hour.png),
> which receives almost all reads (other disks looks
> pretty much the same), and from the second half
> (diskrq-sdl-hour.png), which receives very few
> reads.  The graphs shows number of disk transactions
> per second, separately for reads and writes.

Here's a typical line from iostat -x:

Dev: rrqm/s wrqm/s   r/s  w/s  rsec/s wsec/s avgrq-sz avgqu-sz await svctm %util
sdb    0,32   0,03 22,16 5,84 2054,79 163,74    79,21     0,20  7,29  4,33 12,12
sdk    0,38   0,03  6,28 5,84  716,61 163,74    72,66     0,15 12,29  5,55  6,72

where sdb and sdk are two halfs of the same raid1 part
of a raid10 array - i.e., the content of the two are
identical.  As shown, write requests are the same for
the two, but read requests mostly goes to sdb (the
first half), and very little to sdk (the second half).

> Should raid10 balance reads too, maybe in a way similar
> to what raid1 does?
> 
> The kernel is 2.6.23 but very similar behavior is
> shown by earlier kernels as well.  Raid10 stripe
> size is 256Mb, but again it doesn't really matter
> other sizes behave the same here.

The amount of data is quite large and it is laid out
and accessed pretty much randomly (it's a database
server), so in theory, even with some optimizations
like raid1 does (route request to a drive with "nearest"
head position), the read request distribution should
be basically the same.

Thanks!

/mjt


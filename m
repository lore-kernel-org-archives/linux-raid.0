From: pg_mh@mh.to.sabi.co.UK (Peter Grandi)
Subject: Re: Best Practices for a Virtualized Tira Misu md Setup
Date: Sun, 15 Mar 2009 14:40:57 +0000
Message-ID: <18877.4985.774328.594532@tree.ty.sabi.co.uk>
References: <7bc80d500903141936p64bb0595xc07d4c8a4e9a3cdd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7bc80d500903141936p64bb0595xc07d4c8a4e9a3cdd@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> I've got more layers than I can count.

Bad news in general... and not for performance.

> However, I wanted to ask about what people consider to be best
> practices regarding linux software raid over large numbers of
> drives (> 50).

Lustre? GlusterFS? :-).

> I'm not creating groups that big,

That's excellent, current record holder is the guy who inherited
a 27 drive RAID6 (amazing news from America! ;->).


> but in the aggregate, I'm trying to have md manage about 56
> spindles in 10 separate [ ... ] raid 5 groups rather than 10.

Well, as long as you are happy with the downsides (check
http://WWW.BAARF.com/).

> Write speed has been good, relatively-- 160 MB/sec writes, 110
> MB/sec reads for a six disk group. Since the drives are pretty
> old at this point, I'm happy.

Those numbers are a bit disappointing, but as long as it is
enough for you...

> So far, I haven't seen any horrible problems with the md
> layer--after increasing the size of the stripe cache, my write
> speeds began to look normal.

Uhm, that might indicate that you are testing the speed using
something like 'dd' on the block device, which is not quite the
same as when doing filesystem IO. Because file system code may
not be so good at doing stripe aligned whole stripe writes.

> Im setting this all up for iscsi export, in a DRBD and LVM
> sandwich.

DRBD is nice, but LVM is almost never useful, with only two
minor exceptions.

> Obviously, I expect to lose some performance in the
> assemblage, but I did want to ask about readahead.

In general, especially in 2.6 kernels with the new demented
block layer (and its marvelous plug/unplug logic among other
"features") readhead (and elevators) seems to be in a rather
poor state. So the only way ahead :-) I have found is random
tweaking.

During this I have found that for whatever reason MD does IO
chunked in transactions of size equal to readhead, instead of
rolling it, so a very large block device readhead seem to be a
win.

> When you have a physical device that's part of an md that's
> part of a logical volume, not to mention a drbd pseudo block
> device, you've got a lot of places to set readahead using
> blockdev or lvchange.

Welcome to "it is a pile of undocumented random hacks" world
:-).

> Obviously there's no right answer--if I increase the
> read-ahead too much, I'll kill my random performance,

Not necessarily -- if you have lots of memory to waste relative
to the number of the IO flows you do.

> but given the fact that iscsi is going to throw a fair bit of
> latency into the loop, I may have to increase read ahead to
> get sequential read access up. [ ... ]

That is only going to help in some cases.

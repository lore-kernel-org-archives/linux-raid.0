From: =?UTF-8?Q?Jure_Erzno=C5=BEnik?= <jure.erznoznik@gmail.com>
Subject: (user) Help needed: mdadm seems to constantly touch my disks
Date: Tue, 13 Dec 2016 09:13:00 +0100
Message-ID: <CAJ=9zicFM+wOUhpdX1XEVm+y2gYoW3r2aTRj6gAcEkypxJULmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First of all, I apologise if this mail list is not intended for layman
help, but this is what I am and I couldn't get an explanation
elsewhere.

My problem is that (as it seems) mdadm is touching HDD superblocks
once per second, once at address 8 (sectors), next at address 16.
Total traffic is kilobytes per second, writes only, no other
detectable traffic.

I have detailed the problem here:
http://unix.stackexchange.com/questions/329477/

Shortened:
kubuntu 16.10 4.8.0-30-generic #32, mdadm v3.4 2016-01-28
My configuration: 4 spinning platters (/dev/sd[cdef]) assembled into a
raid5 array, then bcache set to cache (hopefully) everything
(cache_mode = writeback, sequential_cutoff = 0). On top of bcache
volume I have set up lvm.

* iostat shows traffic on sd[cdef] and md0
* iotop shows no traffic
* iosnoop shows COMM=[idle, md0_raid5, kworker] as processes working
on the disk. Blocks reported are 8, 16 (data size a few KB) and
18446744073709500000 (data size 0). That last one must be some virtual
thingie as the disks are nowhere near that large.
* enabling block_dump shows md0_raid5 process writing to block 8 (1
sectors) and 16 (8 sectors)

This touching is caused by any write into the array and goes on for
quite a while after the write has been done (a couple of hours for
60GB of writes). When services actually work with the array, this
becomes pretty much constant.

What am I observing and is there any way of stopping it?

Thanks,
Jure

From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: unbelievably bad performance: 2.6.27.37 and raid6
Date: Tue, 03 Nov 2009 14:07:26 +0100
Message-ID: <87fx8viwoh.fsf@frosties.localdomain>
References: <cccedfc60910310855l5ca6c42aj503fb0e4fd6232ad@mail.gmail.com>
	<4AEEF29C.10309@tmr.com>
	<cccedfc60911020703s3188ebcsac867922f937bb39@mail.gmail.com>
	<9e52db7bed791d8c8f5653b1958b1874.squirrel@neil.brown.name>
	<4877c76c0911022209g60e40364i2cb82909e31f707d@mail.gmail.com>
	<763d89fcf9c0164cbe8b6245dc3d2d7f.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <763d89fcf9c0164cbe8b6245dc3d2d7f.squirrel@neil.brown.name>
	(NeilBrown's message of "Tue, 3 Nov 2009 17:28:57 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Michael Evans <mjevans1983@gmail.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"NeilBrown" <neilb@suse.de> writes:

> A reshape is a fundamentally slow operation.  Each block needs to
> be read and then written somewhere else so there is little opportunity
> for streaming.
> An in-place reshape (i.e the array doesn't get bigger or smaller) is
> even slower as we have to take a backup copy of each range of blocks
> before writing them back out.  This limits streaming even more.
>
> It is possible to get it fast than it is by increasing the
> array's stripe_cache_size and also increasing the 'backup' size
> that mdadm uses.  mdadm-3.1.1 will try to do better in this respect.
> However it will still be significantly slower than e.g. a resync.
>
> So reshape will always be slow.  It is a completely different issue
> to filesystem activity on a RAID array being slow.  Recent reports of
> slowness are, I think, not directly related to md/raid.  It is either
> the filesystem or the VM or a combination of the two that causes
> these slowdowns.
>
>
> NeilBrown

Now why is that? Lets leave out the case of an in-place
reshape. Nothing can be done to avoid making a backup of blocks
there, which severly limits the speed.

But the most common case should be growing an array. Lets look at the
first few steps or 3->4 disk raid5 reshape. Each step denotes a point
where a sync is required:

Step 0         Step 1         Step 2         Step 3         Step 4
 A  B  C  D     A  B  C  D     A  B  C  D     A  B  C  D     A  B  C  D
00 01  p  x    00 01 02  p    00 01 02  p    00 01 02  p    00 01 02  p
02  p 03  x    02  p 03  x    03 04  p 05    03 04  p 05    03 04  p 05
 p 04 05  x     p 04 05  x     x  x  x  x    06  p 07 08    06  p 07 08
06 07  p  x    06 07  p  x    06 07  p  x     x  x  x  x     p 09 10 11
08  p 09  x    08  p 09  x    08  p 09  x    08  p 09  x     x  x  x  x
 p 10 11  x     p 10 11  x     p 10 11  x     p 10 11  x     x  x  x  x
12 13  p  x    12 13  p  x    12 13  p  x    12 13  p  x    12 13  p  x
14  p 15  x    14  p 15  x    14  p 15  x    14  p 15  x    14  p 15  x
 p 16 17  x     p 16 17  x     p 16 17  x     p 16 17  x     p 16 17  x
18 19  p  x    18 19  p  x    18 19  p  x    18 19  p  x    18 19  p  x
20  p 21  x    20  p 21  x    20  p 21  x    20  p 21  x    20  p 21  x
 p 22 23  x     p 22 23  x     p 22 23  x     p 22 23  x     p 22 23  x
24 25  p  x    24 25  p  x    24 25  p  x    24 25  p  x    24 25  p  x
26  p 27  x    26  p 27  x    26  p 27  x    26  p 27  x    26  p 27  x
 p 28 29  x     p 28 29  x     p 28 29  x     p 28 29  x     p 28 29  x

Step 5         Step 6         Step 7         Step 8         Step 9
 A  B  C  D     A  B  C  D     A  B  C  D     A  B  C  D     A  B  C  D
00 01 02  p    00 01 02  p    00 01 02  p    00 01 02  p    00 01 02  p
03 04  p 05    03 04  p 05    03 04  p 05    03 04  p 05    03 04  p 05
06  p 07 08    06  p 07 08    06  p 07 08    06  p 07 08    06  p 07 08
 p 09 10 11     p 09 10 11     p 09 10 11     p 09 10 11     p 09 10 11
 x  x  x  x    12 13 14  p    12 13 14  p    12 13 14  p    12 13 14  p
 x  x  x  x    15 16  p 17    15 16  p 17    15 16  p 17    15 16  p 17
12 13  p  x     x  x  x  x    18  p 19 20    18  p 19 20    18  p 19 20
14  p 15  x     x  x  x  x     p 21 22 23     p 21 22 23     p 21 22 23
 p 16 17  x     x  x  x  x    24 25 26  p    24 25 26  p    24 25 26  p
18 19  p  x    18 19  p  x     x  x  x  x    27 28  p 29    27 28  p 29
20  p 21  x    20  p 21  x     x  x  x  x    30  p 31 32    30  p 31 32
 p 22 23  x     p 22 23  x     x  x  x  x     p 33 34 35     p 33 34 35
24 25  p  x    24 25  p  x     x  x  x  x    36 37 38  p    36 37 38  p
26  p 27  x    26  p 27  x    26  p 27  x     x  x  x  x    39 40  p 41
 p 28 29  x     p 28 29  x     p 28 29  x     x  x  x  x    42  p 43 44


In Step 0 and Step 1 the source and destination stripes overlap so a
backup is required. But at Step 2 you have a full stripe to work with
safely, at Step 4 2 stripes are save, Step 6 3 stripes and Step 7 4
stripes. As you go the safe region gets larger and larger requiring
less and less sync points.

Idealy the raid reshape should read as much data from the source
stripes as possible in one go and then write it all out in one
go. Then rince and repeat. For a simple implementation why not do
this:

1) read reshape-sync-size from proc/sys, default to 10% ram size
2) sync-size = min(reshape-sync-size, size of safe region)
3) setup internal mirror between old (read-write) and new stripes (write only)
4) read source blocks into stripe cache
5) compute new parity
6) put stripe into write cache
7) goto 3 until sync-size is reached
8) sync blocks to disk
9) record progress and remove internal mirror
10) goto 1

Optionally in 9 you can skip recording the progress if the safe region
is big enough for another read/write pass.

The important idea behind this would be that, given enough free ram,
there is a large linear read and large linear write alternating. Also,
since the normal cache is used instead of the static stripe cache, if
there is not enough ram then writes will be flushed out prematurely.
This will lead to a degradation of performance but that is better than
running out of memory.

I have 4GB on my desktop with at least 3GB free if I'm not doing
anything expensive. A raid-reshape should be able to do 3GB linear
read and write alternatively. But I would already be happy if it would
do 256MB. There is lots of opportunity for streaming. It might justbe
hard to get the kernel IO system to cooperate.

MfG
        Goswin

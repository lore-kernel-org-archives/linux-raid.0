From: linux@horizon.com
Subject: Lots of "bio too big" errors with 2.5.63bk5
Date: 4 Mar 2003 12:45:03 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030304124503.10104.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, mingo@elte.hu
List-Id: linux-raid.ids

I asked about this in linux-kernel, but nobody rose to the bait.

I have a fairly generic Athlon+KT133 system with two IDE drives, which
I have striped together (software RAID-0, stripe size 256K) for speed
and hack value.

Anyway, since jumping from 2.4 to 2.5 recently (2.5.63 is the oldest
2.5 kernel I've run), I've been seeing lots of:

bio too big device ide0(3,4) (256 > 255)
bio too big device ide1(22,4) (256 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (328 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (488 > 255)
bio too big device ide1(22,4) (424 > 255)
bio too big device ide0(3,4) (288 > 255)
bio too big device ide0(3,4) (456 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (256 > 255)
bio too big device ide1(22,4) (296 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (376 > 255)
bio too big device ide1(22,4) (336 > 255)
bio too big device ide0(3,4) (384 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide0(3,4) (376 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (344 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide1(22,4) (256 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (360 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (360 > 255)
bio too big device ide1(22,4) (456 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (360 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (360 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (360 > 255)
bio too big device ide1(22,4) (256 > 255)
bio too big device ide1(22,4) (256 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (360 > 255)
bio too big device ide1(22,4) (256 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (360 > 255)
bio too big device ide0(3,4) (256 > 255)
bio too big device ide0(3,4) (256 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (360 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (360 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (360 > 255)
bio too big device ide0(3,4) (424 > 255)
bio too big device ide0(3,4) (272 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)
bio too big device ide1(22,4) (512 > 255)
bio too big device ide0(3,4) (512 > 255)

Since nothing seemed to be breaking, I was just curious if this was
something important or log spam, but since then I've had dkpg complaining
that downloaded packages were corrupt.

The coincidence of the 256K stripe size and the 512 sector maximum in
the messages suggests that the RAID-0 code isn't obeying the IDE
driver's max_sectors limit.  I can't find mention of it in the
raid0.c code.  Unfortunately, I'm not too sure where such a check
should go.  raid0_mergeable_bvec?

The problem is, right now it doesn't seem to even know, at merge time,
which underlying device the request will be sent to, and they might have
different max_sectors values or even merge_bvec_fns of their own.

Any suggestions?  Perhaps a simple fix could be done by changing the
blk_queue_max_sectors limit to the minimum of mddev->chunk_size>>9
and the max_sectors values of all of the underlying devices, but that's
suboptimal if the max_sectors values differ (admittedly unlikely) and
still doesn't take care of the merge_bvec_fn issue.

Thanks!

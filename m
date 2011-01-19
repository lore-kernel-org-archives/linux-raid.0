From: Marc MERLIN <marc@merlins.org>
Subject: How to force rewrite of a smart detected bad block with raid5: checkarray?
Date: Tue, 18 Jan 2011 23:04:19 -0800
Message-ID: <20110119070419.GC31606@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I couldn't quite find the answer to this with a search.

Smart reported a bad block (pending).
I confirmed it with:

hdrecover /dev/sdk
(...)
Sector 3907017780 (99%) ETR: 0 seconds
Error at sector 3907029168
Attempting to pounce on it...
Attempt 1 from sector   3219409027: FAILED
Attempt 2 from sector   1546846730: FAILED
(...)
Attempt 19 from sector   3837517549: FAILED
Attempt 20 from sector   2281104567: FAILED
Couldn't recover sector 3907029168
The data for this sector could not be recovered. However, destroying the
contents of this sector (ie writing zeros to it) should cause the hard disk
to reallocate it making the drive useable again
Do you really want to destroy the data in sector 3907029168?     [ (y)es / (n)o / (a)ll / (q)uit ]:^C

Now, hdrecover had no idea that /dev/sdk is part of a raid5, so I'm not going to
use it to rewrite the bad block.

I know I can remove /dev/sdk1 from my array and put it back in, but that's
unsafe because if during a rebuild another block from another drive happens
to be bad, I'm then left with a double raid failure.

So, I tried this: /usr/share/mdadm/checkarray md7

md7 : active raid5 sdi1[0] sdh1[5] sdl1[3] sdk1[2] sdj1[1]
      7814045696 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
      [>....................]  check =  0.0% (447616/1953511424) finish=28435.6min speed=1144K/sec

But I couldn't quite find documentation on what the kernel does in this case.

Does this actually do what I want? Try all the blocks on each drive and if
one block is unreadable, it forces a rewrite on the bad drive using the n-1
other ones to recreate it?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems & security ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  

From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 0 of 9] Introduction
Date: Fri, 18 Feb 2005 11:40:44 +1100
Message-ID: <20050218111131.790.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


9 patches for md in 2.6.11-rc3-mm2 follow.

1 - tightens up some locking to close a race that is extremely unlikely
    to happen (famous last words).  It can only happen when failed devices are
    being removed.
2 - Fixes a resync related problem for raid5 and raid6 arrays that have
    lost more devices than they can cope with.
3 - Fixes a clumsy test that has very little real effect (just a printk).

These three can be considered stable.

4,5 Improve handling of 'safemode' which is where we mark the superblock
    clean whenever there have been no writes for a little while, and mark 
    it dirty before the next write.
6-9 Introduce "bitmap based intent logging" which allows a file to 
    store - as a bitmap - all block that may have been written recently.
    This allow resync to be optimised, which is more important as drives
    get larger.

These should not be considerred stable - certainly actually using
the bitmap mode (which requires a 2.0 series version of mdadm) should
be seen as 'experimental'.

mdadm-2.0-devel-1  was released today.

NeilBrown

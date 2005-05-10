From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 000 of 4] Introduction
Date: Tue, 10 May 2005 15:04:02 +1000
Message-ID: <20050510145931.1553.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Andrew,

Following are 4 patches for md in 2.6.12-rc3-mm3

The first is appropriate for 2.6.12 - it fixes a potential data corruption 
with linear arrays (which was notice under XFS which does journal writes with
interesting alignments I think).
The second fixes an unlikely-to-hit-in-real-life bug where if an array fails
to be assembled properly, an oops maybe could eventuate.

The last two relate to bitmap intent logging and so depend on the other 
related patches in -mm.
I think this bitmap stuff should be ready to go to Linus as soon as 2.6.12 is out.

Thanks,
NeilBrown

 [PATCH md 001 of 4] Fix spliting of md/linear request that cross a device boundary
 [PATCH md 002 of 4] Set the unplug_fn and issue_flush_fn for md devices *after* committed to creation.
 [PATCH md 003 of 4] Two small fixes for md verion-1 superblocks.
 [PATCH md 004 of 4] Make sure md/bitmap doesn't try to write a page with active writeback

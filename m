From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 0 of 6] Introduction
Date: Mon, 07 Feb 2005 13:44:19 +1100
Message-ID: <20050207133555.17870.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Following are 6 patches for md in 2.6.11-rc2-mm2

I believe they are all suitable for inclusion in 2.6.11

- Fix silly bugs in version-1 superblock code (which currently is 
   not widely used)
- Fix possible Oops in raid_set_faulty (which is hard to trigger in 
   normal usage)
- Make md work better with devfs when it is compiled in.
- Fix a possible endless-resync-loop
- Removing the for loop in "copy_data" (raid5 and raid6) which caused 
  some copinging to be done multiple times (should be harmless, but is 
  a waste)
- Fix handling for overlapping requests to raid5 and raid6.  -mm currently
  has a patch which is even more broken than the original code.  Adding
  this patch fixes it up.

Thanks,
NeilBrown

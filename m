From: "Cress, Andrew R" <andrew.r.cress@intel.com>
Subject: RE: [PATCH] raid superblock sanity checking (validate_sb)
Date: Fri, 16 Aug 2002 10:03:05 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <A5974D8E5F98D511BB910002A50A664702CD66F8@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: 'Neil Brown' <neilb@cse.unsw.edu.au>
Cc: 'Troy Benjegerdes' <hozer@drgw.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

The problem is due to several md kernel bugs that corrupt the superblock.
And, since my target environment is a raid1 root mirror, it's a bigger deal
to reboot to a removable and manually fix it from userspace with mdadm.  

It's a can of worms, but you are right, the right approach is to fix all of
the locations where a blind increment or decrement of the values takes
place, which I guess are the same locations where I put the validate_sb
routine.  I'll drill down further to try to fix the root problems.

Andy

-----Original Message-----
From: Neil Brown [mailto:neilb@cse.unsw.edu.au] 
Sent: Thursday, August 15, 2002 9:43 PM
To: Cress, Andrew R
Cc: 'Troy Benjegerdes'; linux-raid@vger.kernel.org
Subject: Re: [PATCH] raid superblock sanity checking (validate_sb)

On Monday August 12, andrew.r.cress@intel.com wrote:
> I've written a patch to help this problem.  [...]
> Neil, 
> 
> You've seen a lot of these type problems corrected with mdadm.  Does this
> cover most of the cases?

If there is a kernel bug that corrupts the superblock, then we should
fix the bug, not put in lots of validation to see if the bug has hit..

And if a superblock did get corrupted, then fixing it is a userspace
(mdadm) issue, not kernel.

Or maybe I'm not understanding what problem you are trying to solve.

NeilBrown

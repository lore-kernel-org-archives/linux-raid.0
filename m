From: Troy Benjegerdes <hozer@drgw.net>
Subject: Re: [PATCH] raid superblock sanity checking (validate_sb)
Date: Sat, 17 Aug 2002 12:38:48 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020817173848.GF27123@altus.drgw.net>
References: <A5974D8E5F98D511BB910002A50A664702CD66F8@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A5974D8E5F98D511BB910002A50A664702CD66F8@hdsmsx103.hd.intel.com>
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: 'Neil Brown' <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Aug 16, 2002 at 10:03:05AM -0700, Cress, Andrew R wrote:
> Neil,
> 
> The problem is due to several md kernel bugs that corrupt the superblock.
> And, since my target environment is a raid1 root mirror, it's a bigger deal
> to reboot to a removable and manually fix it from userspace with mdadm.  

With the corruption I encountered, the kernel would panic on autodetecting
the raid, since the superblock on disk got corrupted. Yes, the original
cause should be fixed, but IMHO, the kernel should never dereference a
bogus pointer because of corrupt data on the superblock. Spit out a big
fat warning, and maybe panic after that yes.

> It's a can of worms, but you are right, the right approach is to fix all of
> the locations where a blind increment or decrement of the values takes
> place, which I guess are the same locations where I put the validate_sb
> routine.  I'll drill down further to try to fix the root problems.
> 
> Andy
> 
> -----Original Message-----
> From: Neil Brown [mailto:neilb@cse.unsw.edu.au] 
> Sent: Thursday, August 15, 2002 9:43 PM
> To: Cress, Andrew R
> Cc: 'Troy Benjegerdes'; linux-raid@vger.kernel.org
> Subject: Re: [PATCH] raid superblock sanity checking (validate_sb)
> 
> On Monday August 12, andrew.r.cress@intel.com wrote:
> > I've written a patch to help this problem.  [...]
> > Neil, 
> > 
> > You've seen a lot of these type problems corrected with mdadm.  Does this
> > cover most of the cases?
> 
> If there is a kernel bug that corrupts the superblock, then we should
> fix the bug, not put in lots of validation to see if the bug has hit..
> 
> And if a superblock did get corrupted, then fixing it is a userspace
> (mdadm) issue, not kernel.
> 
> Or maybe I'm not understanding what problem you are trying to solve.
> 
> NeilBrown
> 

-- 
Troy Benjegerdes | master of mispeeling | 'da hozer' |  hozer@drgw.net
-----"If this message isn't misspelled, I didn't write it" -- Me -----
"Why do musicians compose symphonies and poets write poems? They do it
because life wouldn't have any meaning for them if they didn't. That's 
why I draw cartoons. It's my life." -- Charles Schulz

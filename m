From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH] raid superblock sanity checking (validate_sb)
Date: Fri, 16 Aug 2002 11:42:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15708.22673.193343.991760@notabene.cse.unsw.edu.au>
References: <A5974D8E5F98D511BB910002A50A664702CD66E4@hdsmsx103.hd.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Cress, Andrew R on Monday August 12
To: "Cress, Andrew R" <andrew.r.cress@intel.com>
Cc: 'Troy Benjegerdes' <hozer@drgw.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 12, andrew.r.cress@intel.com wrote:
> 
> I've written a patch to help this problem.  I guess now is a good time to
> submit it to the group for comments.  The patch is against kernel 2.4.18,
> but should be useful going forward as well.  It uses a common validation
> subroutine when the superblock gets changed, before it is written.  I've
> been using it for a while now with a raid1 root mirror doing various nasty
> tests and haven't had any more problems.  There could be some additional
> tuning to the validation logic though.
> 
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

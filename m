From: Shaohua Li <shli@kernel.org>
Subject: live lock regression in raid5 reshape
Date: Thu, 25 Feb 2016 11:07:12 -0800
Message-ID: <20160225190712.GA2390@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: yuanhan.liu@linux.intel.com, neilb@suse.de
Cc: linux-raid@vger.kernel.org, artur.paszkiewicz@intel.com
List-Id: linux-raid.ids

Hi,

I hit a live lock in reshape test, which is introduced by:

e9e4c377e2f563892c50d1d093dd55c7d518fc3d(md/raid5: per hash value and exclusive wait_for_stripe)

The problem is get_active_stripe waits on conf->wait_for_stripe[hash]. Assume
hash is 0. My test release stripes in this order:
- release all stripes with hash 0
- get_active_stripe still sleeps since active_stripes > max_nr_stripes * 3 / 4
- release all stripes with hash other than 0. active_stripes becomes 0
- get_active_stripe still sleeps, since nobody wakes up wait_for_stripe[0]

The system live locks. The problem is active_stripes isn't a per-hash count.
Revert the patch makes the lock go away.

I didn't come out a solution yet except reverting the patch. Making
active_stripes per-hash is a candidate, but not sure if there is thundering
herd problem because each hash will have less stripes. On the other hand, I'm
wondering if the patch makes sense now. The commit log declares the issue
happens with limited stripes, but now stripe count is automatically increased.

Yuanhan, could you please check if performance changes with the patch reverted
in latest kernel?

Thanks,
Shaohua

From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 3] md: bug fixes for md for 2.6.21
Date: Fri, 23 Mar 2007 12:10:06 +1100
Message-ID: <20070323120828.5793.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

A minor new feature and 2 bug fixes for md suitable for 2.6.21

The minor feature is to make reshape (adding a drive to an array and
restriping it) work for raid4.  The code is all ready, it just wasn't
used.

Thanks,
NeilBrown


 [PATCH 001 of 3] md: Allow raid4 arrays to be reshaped.
 [PATCH 002 of 3] md: Clear the congested_fn when stopping a raid5
 [PATCH 003 of 3] md: Convert compile time warnings into runtime warnings.

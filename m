From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 3] md: Introduction - 3 assorted md fixes
Date: Fri, 24 Mar 2006 16:58:57 +1100
Message-ID: <20060324165531.2372.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Three little fixes.
The last is possibly most interesting as it highlight how wrong I managed
to get the BIO_BARRIER stuff in raid1, which I really thought I had tested.

I'm happy of this and the previous collection of raid5-growth patches
to be merged into 2.6.17-rc1.  I had hoped the raid5-growth could sit
in -mm a bit longer, but I didn't get them there in time, and I'd
rather not wait until after 2.6.17.  They have received a reasonable
amount of testing both by me and others and appear to be safe.

Thanks,
NeilBrown

 [PATCH 001 of 3] md: Remove bi_end_io call out from under a spinlock.
 [PATCH 002 of 3] md: Fix md grow/size code to correctly find the maximum available space.
 [PATCH 003 of 3] md: Restore 'remaining' count when retrying an write operation.

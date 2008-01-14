From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 6] md: various fixes for md
Date: Mon, 14 Jan 2008 12:45:18 +1100
Message-ID: <20080114123726.19968.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>, Dan Williams <dan.j.williams@gmail.com>
List-Id: linux-raid.ids

Following are 6 patches for md which are suitable for 2.6.25-rc1.

The first fixes a bug which could make it a candidate for 24-final.
However it is a deadlock that seems to occur very rarely, and has been
in mainline since 2.6.22.  So letting it into one more release
shouldn't be a big problem.  While the fix is fairly simple, it could
have some unexpected consequences, so I'd rather go for the next cycle.

The second patch fixes a bug which only affect -mm at the moment but
will probably affect 2.6.25 unless fixed.

The rest are cleanups with no functional change (I hope).

Thanks,
NeilBrown


 [PATCH 001 of 6] md: Fix an occasional deadlock in raid5
 [PATCH 002 of 6] md: Fix use-after-free bug when dropping an rdev from an md array.
 [PATCH 003 of 6] md: Change a few 'int' to 'size_t' in md
 [PATCH 004 of 6] md: Change INTERATE_MDDEV to for_each_mddev
 [PATCH 005 of 6] md: Change ITERATE_RDEV to rdev_for_each
 [PATCH 006 of 6] md: Change ITERATE_RDEV_GENERIC to rdev_for_each_list, and remove ITERATE_RDEV_PENDING.

From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 4] md: Introduction
Date: Thu, 24 Aug 2006 17:40:56 +1000
Message-ID: <20060824173647.19026.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Following are 4 patches against 2.6.18-rc4-mm2

The first 2 are bug fixes which should go in 2.6.18, and apply
equally well to that tree as to -mm.

The latter two should stay in -mm until after 2.6.18.

The second patch is maybe bigger than it absolutely needs to be as a bugfix.
If you like I can stripe out all the rcu-extra-carefulness as a separate
patch and just leave the important bit which involves moving the
atomic_add down twenty-something lines.

Thanks,
NeilBrown

 [PATCH 001 of 4] md: Fix recent breakage of md/raid1 array checking
 [PATCH 002 of 4] md: Fix issues with referencing rdev in md/raid1.
 [PATCH 003 of 4] md: new sysfs interface for setting bits in the write-intent-bitmap
 [PATCH 004 of 4] md: Remove unnecessary variable x in stripe_to_pdidx().

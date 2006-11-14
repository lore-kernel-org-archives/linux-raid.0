From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 4] md: Various fixes for new cache-bypassing-reads in raid5/6
Date: Tue, 14 Nov 2006 11:22:23 +1100
Message-ID: <20061114111600.31061.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

The patches which enable reading from raid5 without going through the
stripe cache have a bug which causes corruption when reading from a
raid6.
It might be appropriate to put out a hotfix for rc5-mm1 which reverts

   md-enable-bypassing-cache-for-reads.patch

The follow 4 patches fix this bug and a few other bugs I found while
re-reviewing and re-testing this code.  There are actually about 9
separate bugs here, but I grouped some of them to avoid having lots
of tiny patches.

NeilBrown



 [PATCH 001 of 4] md: Fix innocuous bug in raid6 stripe_to_pdidx
 [PATCH 002 of 4] md: Fix newly introduced read-corruption with raid6.
 [PATCH 003 of 4] md: Misc fixes for aligned-read handling.
 [PATCH 004 of 4] md: Fix a couple more bugs in raid5/6 aligned reads

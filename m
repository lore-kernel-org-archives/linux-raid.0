From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 2] md: bug fixes for 2.6.23-rc
Date: Thu, 16 Aug 2007 10:38:32 +1000
Message-ID: <20070816103626.32539.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Following 2 patches contain bugfixes for md.  Both apply to earlier
kernels, but probably aren't significant enough for -stable (no oops,
no data corruption, no security hole).
They should go in 2.6.23 though.

Thanks,
NeilBrown


 [PATCH 001 of 2] md: Make sure a re-add after a restart honours bitmap when resyncing.
 [PATCH 002 of 2] md: Correctly update sysfs when a raid1 is reshaped.

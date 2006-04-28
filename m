From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 5] md: Introduction - assorted raid10/raid1 fixes
Date: Fri, 28 Apr 2006 12:51:33 +1000
Message-ID: <20060428124313.29510.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

Following are 5 patches to md that are suitable for 2.6.17.

The first is also suitable for 2.6.16.something as it is an obvious
trivial fix for an oops. So it and this are cc:ed to stable@kernel.org

The first two fix problems with the attempt-to-fix-read-errors code in raid10.
The next three fix problems with the handling of BIO_RW_BARRIER requests in raid1.

All patches created against 2.6.17-rc2-mm1. First patch checked to apply to 2.6.16.11.

Thanks,
NeilBrown


 [PATCH 001 of 5] md: Avoid oops when attempting to fix read errors on raid10
 [PATCH 002 of 5] md: Fixed refcounting/locking when attempting read error correction in raid10
 [PATCH 003 of 5] md: Change ENOTSUPP to EOPNOTSUPP
 [PATCH 004 of 5] md: Improve detection of lack of barrier support in raid1
 [PATCH 005 of 5] md: Fix 'rdev->nr_pending' count when retrying barrier requests.

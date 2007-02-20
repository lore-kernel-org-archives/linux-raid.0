From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 6] md: Assorted fixes and features for md for 2.6.21
Date: Tue, 20 Feb 2007 17:34:41 +1100
Message-ID: <20070220172544.15678.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

Following 6 patches are against 2.6.20 and are suitable for 2.6.21.
They are not against -mm because the new plugging makes raid5 not work
and so not testable, and there are a few fairly minor intersections between
these patches and those patches.
There is also a very minor conflict with the hardware-xor patches - one line
of context is different.

Patch 1 should probably go in -stable - the bug could cause data
corruption in a fairly uncommon raid10 configuration, so that one and
this intro are Cc:ed to stable@kernel.org.

Thanks,
NeilBrown


 [PATCH 001 of 6] md: Fix raid10 recovery problem.
 [PATCH 002 of 6] md: RAID6: clean up CPUID and FPU enter/exit code
 [PATCH 003 of 6] md: Move warning about creating a raid array on partitions of the one device.
 [PATCH 004 of 6] md: Clean out unplug and other queue function on md shutdown
 [PATCH 005 of 6] md: Restart a (raid5) reshape that has been aborted due to a read/write error.
 [PATCH 006 of 6] md: Add support for reshape of a raid6

From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 4] md: assorted md patched - please read carefully.
Date: Fri, 18 Jan 2008 22:02:24 +1100
Message-ID: <20080118215531.30136.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Following are 4 patches for md.

The first two replace
   md-allow-devices-to-be-shared-between-md-arrays.patch
which was recently remove.  They should go at the same place in the
series, between
    md-allow-a-maximum-extent-to-be-set-for-resyncing.patch
and
    md-lock-address-when-changing-attributes-of-component-devices.patch

The third is a replacement for
    md-change-iterate_rdev_generic-to-rdev_for_each_list-and-remove-iterate_rdev_pending.patch

which conflicts with the above change.

The last is a fix for
    md-fix-an-occasional-deadlock-in-raid5.patch

which makes me a lot happier about this patch.  It introduced a
performance regression and I now understand why.  I'm now happy for
that patch with this fix to go into 2.6.24 if that is convenient (If
not, 2.6.24.1 will do).

Thanks,
NeilBrown


 [PATCH 001 of 4] md: Set and test the ->persistent flag for md devices more consistently.
 [PATCH 002 of 4] md: Allow devices to be shared between md arrays.
 [PATCH 003 of 4] md: Change ITERATE_RDEV_GENERIC to rdev_for_each_list, and remove ITERATE_RDEV_PENDING.
 [PATCH 004 of 4] md: Fix an occasional deadlock in raid5 - FIX

From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 5] md: assorted bug fixes and minor features
Date: Tue, 8 May 2007 14:29:12 +1000
Message-ID: <20070508142718.28571.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Following are 5 patches for md suitable for 2.6.22.  None are needed for -stable.

Thanks
NeilBrown

 [PATCH 001 of 5] md: Move test for whether level supports bitmap to correct place.
 [PATCH 002 of 5] md: Stop using csum_partial for checksum calculation in md.
 [PATCH 003 of 5] md: Remove the slash from the name of a kmem_cache used by raid5.
 [PATCH 004 of 5] md: Allow reshape_position for md arrays to be set via sysfs.
 [PATCH 005 of 5] md: Improve partition detection in md array.

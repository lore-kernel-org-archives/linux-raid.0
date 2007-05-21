From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 7] md: Introduction EXPLAIN PATCH SET HERE
Date: Mon, 21 May 2007 11:32:57 +1000
Message-ID: <20070521111837.20906.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Jeff Zheng <Jeff.Zheng@endace.com>, Neil Brown <neilb@suse.de>, stable@kernel.org
List-Id: linux-raid.ids

Following are 7 patches for md in current main-line.

The first two fix bugs that can cause data corruption, and so are suitable for -stable. 

The next fixes some problems with hot-adding a device to a linear array.  As has not
been tested by my test-suite until now, it hasn't worked properly until now :-(

The remainder are mainly cleaning up code and comments.  They could
wait for 2.6.23, but are probably safe to go into 2.6.22 (maybe sit a week in -mm??)

Thanks,
NeilBrown


 [PATCH 001 of 7] md: Avoid overflow in raid0 calculation with large components.
 [PATCH 002 of 7] md: Don't write more than is required of the last page of a bitmap
 [PATCH 003 of 7] md: Fix bug with linear hot-add and elsewhere.
 [PATCH 004 of 7] md: Improve message about invalid superblock during autodetect.
 [PATCH 005 of 7] md: Improve the is_mddev_idle test fix
 [PATCH 006 of 7] md: Check that internal bitmap does not overlap other data.
 [PATCH 007 of 7] md: Change bitmap_unplug and others to void functions.

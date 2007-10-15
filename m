From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 5] md: Five minor md patch, some for 2.6.24.
Date: Mon, 15 Oct 2007 14:34:18 +1000
Message-ID: <20071015143136.5200.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Iustin Pop <iusty@k1024.org>
List-Id: linux-raid.ids

Following are 5 minor patches for md in current -mm.

The first 4 are suitable to flow into 2.6.24.

The last fixes a small bug in Dan Williams' patches currently in -mm,
which are not scheduled for 2.6.24.

Thanks,
NeilBrown


 [PATCH 001 of 5] md: Fix a bug in some never-used code.
 [PATCH 002 of 5] md: 'sync_action' in sysfs returns wrong value for readonly arrays
 [PATCH 003 of 5] md: Expose the degraded status of an assembled array through sysfs
 [PATCH 004 of 5] md: Make sure read errors are auto-corrected during a 'check' resync in raid1
 [PATCH 005 of 5] md: Fix type that is stopping raid5 grow from working.

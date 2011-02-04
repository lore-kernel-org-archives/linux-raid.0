From: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
Subject: [PATCH 1/2] FIX: md: process hangs at wait_barrier after 0->10
	takeover
Date: Fri, 04 Feb 2011 14:18:26 +0100
Message-ID: <20110204131826.6426.68141.stgit@gklab-128-111.igk.intel.com>
References: <20110204130757.6426.81544.stgit@gklab-128-111.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110204130757.6426.81544.stgit@gklab-128-111.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, wojciech.neubauer@intel.com, adam.kwolek@intel.com, dan.j.williams@intel.com, ed.ciechanowski@intel.com
List-Id: linux-raid.ids

Following symptoms were observed:
1. After raid0->raid10 takeover operation we have array with 2
missing disks.
When we add disk for rebuild, recovery process starts as expected
but it does not finish- it stops at about 90%, md126_resync process
hangs in "D" state.
2. Similar behavior is when we have mounted raid0 array and we
execute takeover to raid10. After this when we try to unmount array-
it causes process umount hangs in "D"

In scenarios above processes hang at the same function- wait_barrier
in raid10.c.
Process waits in macro "wait_event_lock_irq" until the
"!conf->barrier" condition will be true.
In scenarios above it never happens.

Reason was that at the end of level_store, after calling pers->run,
we call mddev_resume. This calls pers->quiesce(mddev, 0) with
RAID10, that calls lower_barrier.
However raise_barrier hadn't been called on that 'conf' yet,
so conf->barrier becomes negative, which is bad.

This patch introduces setting conf->barrier=1 after takeover
operation. It prevents to become barrier negative after call
lower_barrier().

Signed-off-by: Krzysztof Wojcik <krzysztof.wojcik@intel.com>
---
 drivers/md/raid10.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 69b6595..3b607b2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2463,11 +2463,13 @@ static void *raid10_takeover_raid0(mddev_t *mddev)
 	mddev->recovery_cp = MaxSector;
 
 	conf = setup_conf(mddev);
-	if (!IS_ERR(conf))
+	if (!IS_ERR(conf)) {
 		list_for_each_entry(rdev, &mddev->disks, same_set)
 			if (rdev->raid_disk >= 0)
 				rdev->new_raid_disk = rdev->raid_disk * 2;
-		
+		conf->barrier = 1;
+	}
+
 	return conf;
 }
 


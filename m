From: "Trela, Maciej" <Maciej.Trela@intel.com>
Subject: [PATCH 3/3] md: fix invalid dev slots after takeover
Date: Tue, 15 Jun 2010 09:36:36 +0100
Message-ID: <BE2BFE91933D1B4089447C64486040801E8734B6@irsmsx503.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Williams, Dan J" <dan.j.williams@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

From: Maciej Trela <maciej.trela@intel.com>

While raid10->raid0 takeover incorrect slot numbers are set for raid0. This was caused by invalidating dev slot numbers before calling pers->run(). We are invalidating all devs that has (rdev->raid_disk >= mddev->raid_disks) but rdev->raid_disk numbers are scaled in pers->run().

Another option to fix the problem:
If invalidating devs should rather be performed before run() we could use devlist[index] for invalidating - devlist is already updated after calling takeover...
---
 drivers/md/md.c |   14 ++++++++------
 1 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c index 46b3a04..effe601 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3052,12 +3052,6 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 	}
 
 	module_put(mddev->pers->owner);
-	/* Invalidate devices that are now superfluous */
-	list_for_each_entry(rdev, &mddev->disks, same_set)
-		if (rdev->raid_disk >= mddev->raid_disks) {
-			rdev->raid_disk = -1;
-			clear_bit(In_sync, &rdev->flags);
-		}
 	mddev->pers = pers;
 	mddev->private = priv;
 	strlcpy(mddev->clevel, pers->name, sizeof(mddev->clevel)); @@ -3072,7 +3066,15 @@ level_store(mddev_t *mddev, const char *buf, size_t len)
 		mddev->in_sync = 1;
 		del_timer_sync(&mddev->safemode_timer);
 	}
+
 	pers->run(mddev);
+
+	/* Invalidate devices that are now superfluous */
+	list_for_each_entry(rdev, &mddev->disks, same_set)
+		if (rdev->raid_disk >= mddev->raid_disks) {
+			rdev->raid_disk = -1;
+			clear_bit(In_sync, &rdev->flags);
+		}
 	mddev_resume(mddev);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);


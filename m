From: Song Liu <songliubraving@fb.com>
Subject: [PATCH] skip match_mddev_units check for special roles
Date: Thu, 3 Sep 2015 23:00:35 -0700
Message-ID: <1441346435-4009054-1-git-send-email-songliubraving@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, neilb@suse.de, hch@infradead.org, dan.j.williams@intel.com, hch@lst.de, Kernel-team@fb.com, Song Liu <songliubraving@fb.com>
List-Id: linux-raid.ids

match_mddev_units is used to check whether 2 RAID arrays share
same disk(s). Arrays that share disk(s) will not do resync at the
same time for better performance (fewer HDD seek). However, this
check should not apply to Spare, Faulty, and Journal disks, as
they do not paticipate in resync.

In this patch, match_mddev_units skips check for disks with flag
"Faulty" or "Journal" or raid_disk < 0.

Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Shaohua Li <shli@fb.com>
---
 drivers/md/md.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 95824fb..b96d135 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1957,13 +1957,23 @@ static int match_mddev_units(struct mddev *mddev1, struct mddev *mddev2)
 	struct md_rdev *rdev, *rdev2;
 
 	rcu_read_lock();
-	rdev_for_each_rcu(rdev, mddev1)
-		rdev_for_each_rcu(rdev2, mddev2)
+	rdev_for_each_rcu(rdev, mddev1) {
+		if (test_bit(Faulty, &rdev->flags) ||
+		    test_bit(Journal, &rdev->flags) ||
+		    rdev->raid_disk == -1)
+			continue;
+		rdev_for_each_rcu(rdev2, mddev2) {
+			if (test_bit(Faulty, &rdev2->flags) ||
+			    test_bit(Journal, &rdev2->flags) ||
+			    rdev2->raid_disk == -1)
+				continue;
 			if (rdev->bdev->bd_contains ==
 			    rdev2->bdev->bd_contains) {
 				rcu_read_unlock();
 				return 1;
 			}
+		}
+	}
 	rcu_read_unlock();
 	return 0;
 }
-- 
1.8.1


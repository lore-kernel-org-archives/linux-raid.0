From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 15/16] md/raid5: If there is a spare and a replaceable
 device, start replacement.
Date: Wed, 26 Oct 2011 12:43:02 +1100
Message-ID: <20111026014302.21110.88143.stgit@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111026014240.21110.28487.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When attempting to add a spare to a RAID[456] array, also consider
adding it as a replacement for a replaceable device.

This requires that common md code attempt hot_add even when the array
is not formally degraded.

Signed-off-by: NeilBrown <neilb@suse.de>
---

 drivers/md/md.c    |   34 ++++++++++++++++------------------
 drivers/md/raid5.c |   16 ++++++++++++++--
 2 files changed, 30 insertions(+), 20 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 72a07d0..1b43f86 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7403,25 +7403,23 @@ static int remove_and_add_spares(struct mddev *mddev)
 			}
 		}
 
-	if (mddev->degraded) {
-		list_for_each_entry(rdev, &mddev->disks, same_set) {
-			if (rdev->raid_disk >= 0 &&
-			    !test_bit(In_sync, &rdev->flags) &&
-			    !test_bit(Faulty, &rdev->flags))
+	list_for_each_entry(rdev, &mddev->disks, same_set) {
+		if (rdev->raid_disk >= 0 &&
+		    !test_bit(In_sync, &rdev->flags) &&
+		    !test_bit(Faulty, &rdev->flags))
+			spares++;
+		if (rdev->raid_disk < 0
+		    && !test_bit(Faulty, &rdev->flags)) {
+			rdev->recovery_offset = 0;
+			if (mddev->pers->
+			    hot_add_disk(mddev, rdev) == 0) {
+				if (sysfs_link_rdev(mddev, rdev))
+					/* failure here is OK */;
 				spares++;
-			if (rdev->raid_disk < 0
-			    && !test_bit(Faulty, &rdev->flags)) {
-				rdev->recovery_offset = 0;
-				if (mddev->pers->
-				    hot_add_disk(mddev, rdev) == 0) {
-					if (sysfs_link_rdev(mddev, rdev))
-						/* failure here is OK */;
-					spares++;
-					md_new_event(mddev);
-					set_bit(MD_CHANGE_DEVS, &mddev->flags);
-				} else
-					break;
-			}
+				md_new_event(mddev);
+				set_bit(MD_CHANGE_DEVS, &mddev->flags);
+			} else
+				break;
 		}
 	}
 	return spares;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index efe3679..3f55bef 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -5337,8 +5337,9 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		disk = rdev->saved_raid_disk;
 	else
 		disk = first;
-	for ( ; disk <= last ; disk++)
-		if ((p=conf->disks + disk)->rdev == NULL) {
+	for ( ; disk <= last ; disk++) {
+		p = conf->disks + disk;
+		if (p->rdev == NULL) {
 			clear_bit(In_sync, &rdev->flags);
 			rdev->raid_disk = disk;
 			err = 0;
@@ -5347,6 +5348,17 @@ static int raid5_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			rcu_assign_pointer(p->rdev, rdev);
 			break;
 		}
+		if (test_bit(Replaceable, &p->rdev->flags) &&
+		    p->replacement == NULL) {
+			clear_bit(In_sync, &rdev->flags);
+			set_bit(Replacement, &rdev->flags);
+			rdev->raid_disk = disk;
+			err = 0;
+			conf->fullsync = 1;
+			rcu_assign_pointer(p->replacement, rdev);
+			break;
+		}
+	}
 	print_raid5_conf(conf);
 	return err;
 }



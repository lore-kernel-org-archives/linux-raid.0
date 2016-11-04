From: NeilBrown <neilb@suse.com>
Subject: [md PATCH 1/4] md: perform async updates for metadata where
 possible.
Date: Fri, 04 Nov 2016 16:46:03 +1100
Message-ID: <147823836295.6764.10561299893409401720.stgit@noble>
References: <147823807607.6764.8460942745584467311.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <147823807607.6764.8460942745584467311.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

When adding devices to, or removing device from, an array we need to
update the metadata.  However we don't need to do it synchronously as
data integrity doesn't depend on these changes being recorded
instantly.  So avoid the synchronous call to md_update_sb and just set
a flag so that the thread will do it.

This can reduce the number of updates performed when lots of devices
are being added or removed.

Signed-off-by: NeilBrown <neilb@suse.com>
---
 drivers/md/md.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0354a92636aa..5ea8063587e9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2611,8 +2611,10 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 
 			if (err == 0) {
 				md_kick_rdev_from_array(rdev);
-				if (mddev->pers)
-					md_update_sb(mddev, 1);
+				if (mddev->pers) {
+					set_bit(MD_CHANGE_DEVS, &mddev->flags);
+					md_wakeup_thread(mddev->thread);
+				}
 				md_new_event(mddev);
 			}
 		}
@@ -6178,7 +6180,11 @@ static int hot_remove_disk(struct mddev *mddev, dev_t dev)
 		md_cluster_ops->remove_disk(mddev, rdev);
 
 	md_kick_rdev_from_array(rdev);
-	md_update_sb(mddev, 1);
+	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	if (mddev->thread)
+		md_wakeup_thread(mddev->thread);
+	else
+		md_update_sb(mddev, 1);
 	md_new_event(mddev);
 
 	return 0;
@@ -6243,7 +6249,9 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 
 	rdev->raid_disk = -1;
 
-	md_update_sb(mddev, 1);
+	set_bit(MD_CHANGE_DEVS, &mddev->flags);
+	if (!mddev->thread)
+		md_update_sb(mddev, 1);
 	/*
 	 * Kick recovery, maybe this spare has to be added to the
 	 * array immediately.



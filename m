From: NeilBrown <neilb@suse.de>
Subject: [md PATCH 23/28] md: call md_stop_writes from md_stop
Date: Thu, 15 Apr 2010 16:21:08 +1000
Message-ID: <20100415062108.5126.27024.stgit@notabene.brown>
References: <20100415061516.5126.53068.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415061516.5126.53068.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This moves the call to the other side of set_readonly, but that should
not be an issue.
This encapsulates in 'md_stop' all of the functionality for internally
stopping the array, leaving all the interactions with externalities
(sysfs, request_queue, gendisk) in do_md_stop.

Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 51a109e..ebc0fc9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4633,12 +4633,14 @@ static void md_stop_writes(mddev_t *mddev)
 
 static void md_stop(mddev_t *mddev)
 {
+	md_stop_writes(mddev);
+
 	mddev->pers->stop(mddev);
 	if (mddev->pers->sync_request && mddev->to_remove == NULL)
 		mddev->to_remove = &md_redundancy_group;
 	module_put(mddev->pers->owner);
 	mddev->pers = NULL;
-
+	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 }
 
 static int md_set_readonly(mddev_t *mddev, int is_open)
@@ -4683,8 +4685,6 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		err = -EBUSY;
 	} else if (mddev->pers) {
 
-		md_stop_writes(mddev);
-
 		if (mddev->ro)
 			set_disk_ro(disk, 0);
 
@@ -4709,7 +4709,6 @@ static int do_md_stop(mddev_t * mddev, int mode, int is_open)
 		if (mddev->ro)
 			mddev->ro = 0;
 		
-		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		err = 0;
 	}
 	mutex_unlock(&mddev->open_mutex);



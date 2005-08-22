From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 001 of 8] Make sure resync gets started when array starts.
Date: Mon, 22 Aug 2005 11:59:13 +1000
Message-ID: <E1E71aj-0001Hy-4z@notabene.cse.unsw.edu.au>
References: <20050822115252.4868.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


We weren't actually waking up the md thread after setting
MD_RECOVERY_NEEDED when assembling an array, so it is possible to
lose a race and not actually start resync.

So add a call to md_wakeup_thread, and while we are at it, remove
all the "if (mddev->thread)" guards as md_wake_thread does its own
checking.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/md.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff ./drivers/md/md.c~current~ ./drivers/md/md.c
--- ./drivers/md/md.c~current~	2005-08-22 11:48:17.000000000 +1000
+++ ./drivers/md/md.c	2005-08-22 11:48:37.000000000 +1000
@@ -256,8 +256,7 @@ static inline void mddev_unlock(mddev_t 
 {
 	up(&mddev->reconfig_sem);
 
-	if (mddev->thread)
-		md_wakeup_thread(mddev->thread);
+	md_wakeup_thread(mddev->thread);
 }
 
 mdk_rdev_t * find_rdev_nr(mddev_t *mddev, int nr)
@@ -1726,6 +1725,7 @@ static int do_md_run(mddev_t * mddev)
 	mddev->in_sync = 1;
 	
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
 	
 	if (mddev->sb_dirty)
 		md_update_sb(mddev);
@@ -2255,8 +2255,7 @@ static int add_new_disk(mddev_t * mddev,
 			export_rdev(rdev);
 
 		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
-		if (mddev->thread)
-			md_wakeup_thread(mddev->thread);
+		md_wakeup_thread(mddev->thread);
 		return err;
 	}
 

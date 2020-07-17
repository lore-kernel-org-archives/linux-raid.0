From: Zhao Heming <heming.zhao@suse.com>
Subject: [PATCH v3] md-cluster: fix safemode_delay value when converting to clustered bitmap
Date: Fri, 17 Jul 2020 16:34:20 +0800
Message-ID: <1594974860-12917-1-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Zhao Heming <heming.zhao@suse.com>, neilb@suse.com, song@kernel.org
List-Id: linux-raid.ids

When array convert to clustered bitmap, the safe_mode_delay doesn't clean and vice versa.
the /sys/block/mdX/md/safe_mode_delay keep original value after changing bitmap type.
in safe_delay_store(), the code forbids setting mddev->safemode_delay when array is clustered.
So in cluster-md env, the expected safemode_delay value should be 0.

reproduction steps:
```
node1 # mdadm --zero-superblock /dev/sd{b,c,d}
node1 # mdadm -C /dev/md0 -b internal -e 1.2 -n 2 -l mirror /dev/sdb /dev/sdc
node1 # cat /sys/block/md0/md/safe_mode_delay
0.204
node1 # mdadm -G /dev/md0 -b none
node1 # mdadm --grow /dev/md0 --bitmap=clustered
node1 # cat /sys/block/md0/md/safe_mode_delay
0.204  <== doesn't change, should ZERO for cluster-md

node1 # mdadm --zero-superblock /dev/sd{b,c,d}
node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdb /dev/sdc
node1 # cat /sys/block/md0/md/safe_mode_delay
0.000
node1 # mdadm -G /dev/md0 -b none
node1 # cat /sys/block/md0/md/safe_mode_delay
0.000  <== doesn't change, should default value
```

Neil said md_setup_cluster/md_cluster_stop are good places to fix.
After investigation, md_setup_cluster() is a good place for setting,
but md_cluster_stop is good for cleaning job when md_setup_cluster return err.

see below flow:
(user space)
mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda /dev/sdb
mdadm --grow /dev/md0 -b none
(kernel space)
SET_ARRAY_INFO
 update_array_info
  + mddev->bitmap_info.nodes = 0;
  + md_cluster_ops->leave(mddev)
  + md_bitmap_destroy
     md_bitmap_free //won't trigger md_cluster_stop() because above set 0.

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
v2:
- change setting path from location_store to md_setup_cluster
- add restoring path
v3:
- add restoring path for error case
- modify comments

---
 drivers/md/md.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f567f536b529..e20f1d5a5261 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -101,6 +101,8 @@ static void mddev_detach(struct mddev *mddev);
  * count by 2 for every hour elapsed between read errors.
  */
 #define MD_DEFAULT_MAX_CORRECTED_READ_ERRORS 20
+/* Default safemode delay: 200 msec */
+#define DEFAULT_SAFEMODE_DELAY ((200 * HZ)/1000 +1)
 /*
  * Current RAID-1,4,5 parallel reconstruction 'guaranteed speed limit'
  * is 1000 KB/sec, so the extra system load does not show up that much.
@@ -5982,7 +5984,7 @@ int md_run(struct mddev *mddev)
 	if (mddev_is_clustered(mddev))
 		mddev->safemode_delay = 0;
 	else
-		mddev->safemode_delay = (200 * HZ)/1000 +1; /* 200 msec delay */
+		mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
 	mddev->in_sync = 1;
 	smp_wmb();
 	spin_lock(&mddev->lock);
@@ -7361,6 +7363,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 
 				mddev->bitmap_info.nodes = 0;
 				md_cluster_ops->leave(mddev);
+				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
 			}
 			mddev_suspend(mddev);
 			md_bitmap_destroy(mddev);
@@ -8366,6 +8369,7 @@ int md_setup_cluster(struct mddev *mddev, int nodes)
 	}
 	spin_unlock(&pers_lock);
 
+	mddev->safemode_delay = 0;
 	return md_cluster_ops->join(mddev, nodes);
 }
 
@@ -8375,6 +8379,7 @@ void md_cluster_stop(struct mddev *mddev)
 		return;
 	md_cluster_ops->leave(mddev);
 	module_put(md_cluster_mod);
+	mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
 }
 
 static int is_mddev_idle(struct mddev *mddev, int init)
-- 
2.25.0

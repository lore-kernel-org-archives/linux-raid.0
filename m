From: Zhao Heming <heming.zhao@suse.com>
Subject: [PATCH] md-cluster: fix safemode_delay non-zero when bitmap switch to clustered
Date: Thu, 16 Jul 2020 01:04:04 +0800
Message-ID: <1594832644-8837-1-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Zhao Heming <heming.zhao@suse.com>
List-Id: linux-raid.ids

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
```

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 drivers/md/md-bitmap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 95a5f3757fa3..547adea1d1e6 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2344,6 +2344,8 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 					mddev_resume(mddev);
 					goto out;
 				}
+				if (mddev_is_clustered(mddev))
+					mddev->safemode_delay = 0;
 				mddev_resume(mddev);
 			}
 		}
-- 
2.16.4

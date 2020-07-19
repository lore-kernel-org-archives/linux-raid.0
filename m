From: Zhao Heming <heming.zhao@suse.com>
Subject: [PATCH v4 2/2] md-cluster: fix rmmod issue when md_cluster convert bitmap to none
Date: Sun, 19 Jul 2020 19:08:40 +0800
Message-ID: <1595156920-31427-3-git-send-email-heming.zhao@suse.com>
References: <1595156920-31427-1-git-send-email-heming.zhao@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1595156920-31427-1-git-send-email-heming.zhao@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Zhao Heming <heming.zhao@suse.com>, neilb@suse.com, jes@trained-monkey.org
List-Id: linux-raid.ids

update_array_info misses calling module_put when removing cluster bitmap.

steps to reproduce:
```
node1 # mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sda
/dev/sdb
mdadm: array /dev/md0 started.
node1 # lsmod | egrep "dlm|md_|raid1"
md_cluster             28672  1
dlm                   212992  14 md_cluster
configfs               57344  2 dlm
raid1                  53248  1
md_mod                176128  2 raid1,md_cluster
node1 # mdadm -G /dev/md0 -b none
node1 # lsmod | egrep "dlm|md_|raid1"
md_cluster             28672  1 <== should be zero
dlm                   212992  9 md_cluster
configfs               57344  2 dlm
raid1                  53248  1
md_mod                176128  2 raid1,md_cluster
node1 # mdadm -G /dev/md0 -b clustered
node1 # lsmod | egrep "dlm|md_|raid1"
md_cluster             28672  2 <== increase
dlm                   212992  14 md_cluster
configfs               57344  2 dlm
raid1                  53248  1
md_mod                176128  2 raid1,md_cluster
node1 # mdadm -G /dev/md0 -b none
node1 # mdadm -G /dev/md0 -b clustered
node1 # lsmod | egrep "dlm|md_|raid1"
md_cluster             28672  3 <== increase
dlm                   212992  14 md_cluster
configfs               57344  2 dlm
raid1                  53248  1
md_mod                176128  2 raid1,md_cluster
```

Signed-off-by: Zhao Heming <heming.zhao@suse.com>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index e20f1d5a5261..ca791387e54d 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7363,6 +7363,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 
 				mddev->bitmap_info.nodes = 0;
 				md_cluster_ops->leave(mddev);
+				module_put(md_cluster_mod);
 				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
 			}
 			mddev_suspend(mddev);
-- 
2.25.0

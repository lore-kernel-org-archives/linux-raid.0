From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH 01/12] md-cluster: use %pU to print UUIDs
Date: Fri, 10 Jul 2015 16:54:02 +0800
Message-ID: <1436518453-12660-2-git-send-email-gqjiang@suse.com>
References: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1436518453-12660-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: rgoldwyn@suse.de, linux-raid@vger.kernel.org, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md-cluster.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 0072190..85ef5c5 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -177,18 +177,6 @@ static void lockres_free(struct dlm_lock_resource *res)
 	kfree(res);
 }
 
-static char *pretty_uuid(char *dest, char *src)
-{
-	int i, len = 0;
-
-	for (i = 0; i < 16; i++) {
-		if (i == 4 || i == 6 || i == 8 || i == 10)
-			len += sprintf(dest + len, "-");
-		len += sprintf(dest + len, "%02x", (__u8)src[i]);
-	}
-	return dest;
-}
-
 static void add_resync_info(struct mddev *mddev, struct dlm_lock_resource *lockres,
 		sector_t lo, sector_t hi)
 {
@@ -388,7 +376,7 @@ static void process_add_new_disk(struct mddev *mddev, struct cluster_msg *cmsg)
 	int len;
 
 	len = snprintf(disk_uuid, 64, "DEVICE_UUID=");
-	pretty_uuid(disk_uuid + len, cmsg->uuid);
+	sprintf(disk_uuid + len, "%pU", cmsg->uuid);
 	snprintf(raid_slot, 16, "RAID_DISK=%d", cmsg->raid_slot);
 	pr_info("%s:%d Sending kobject change with %s and %s\n", __func__, __LINE__, disk_uuid, raid_slot);
 	init_completion(&cinfo->newdisk_completion);
@@ -646,7 +634,7 @@ static int join(struct mddev *mddev, int nodes)
 	mddev->cluster_info = cinfo;
 
 	memset(str, 0, 64);
-	pretty_uuid(str, mddev->uuid);
+	sprintf(str, "%pU", mddev->uuid);
 	ret = dlm_new_lockspace(str, mddev->bitmap_info.cluster_name,
 				DLM_LSFL_FS, LVB_SIZE,
 				&md_ls_ops, mddev, &ops_rv, &cinfo->lockspace);
-- 
1.7.12.4


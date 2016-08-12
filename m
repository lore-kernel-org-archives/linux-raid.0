From: Guoqing Jiang <gqjiang@suse.com>
Subject: [PATCH V2 05/10] md-cluster: clean related infos of cluster
Date: Fri, 12 Aug 2016 13:42:38 +0800
Message-ID: <1470980563-26062-6-git-send-email-gqjiang@suse.com>
References: <1470980563-26062-1-git-send-email-gqjiang@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1470980563-26062-1-git-send-email-gqjiang@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: shli@fb.com, Guoqing Jiang <gqjiang@suse.com>
List-Id: linux-raid.ids

cluster_info and bitmap_info.nodes also need to be
cleared when array is stopped.

Reviewed-by: NeilBrown <neilb@suse.com>
Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
---
 drivers/md/md.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index da5741c..f95e5ed 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5457,12 +5457,14 @@ static void md_clean(struct mddev *mddev)
 	mddev->degraded = 0;
 	mddev->safemode = 0;
 	mddev->private = NULL;
+	mddev->cluster_info = NULL;
 	mddev->bitmap_info.offset = 0;
 	mddev->bitmap_info.default_offset = 0;
 	mddev->bitmap_info.default_space = 0;
 	mddev->bitmap_info.chunksize = 0;
 	mddev->bitmap_info.daemon_sleep = 0;
 	mddev->bitmap_info.max_write_behind = 0;
+	mddev->bitmap_info.nodes = 0;
 }
 
 static void __md_stop_writes(struct mddev *mddev)
-- 
2.6.2


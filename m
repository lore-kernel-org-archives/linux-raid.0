From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Subject: [PATCH 1/3] Return error if request_module fails and returns positive value
Date: Wed, 22 Jul 2015 12:09:15 -0500
Message-ID: <1437584957-23879-1-git-send-email-rgoldwyn@suse.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-raid.ids

request_module() can return 256 (process exited) in some cases,
which is not as specified in the documentation before the
request_module() definition. Convert the error to -ENOENT.

This fixes edb39c9deda8 ("Introduce md_cluster_operations to
handle cluster functions")

Signed-off-By: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/md.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d429c30..7a7870f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7437,7 +7437,7 @@ int md_setup_cluster(struct mddev *mddev, int nodes)
 	err = request_module("md-cluster");
 	if (err) {
 		pr_err("md-cluster module not found.\n");
-		return err;
+		return -ENOENT;
 	}
 
 	spin_lock(&pers_lock);
-- 
2.1.4

